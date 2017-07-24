Sender: Hans Liljestrand <ishkamiel@gmail.com>
From: Hans Liljestrand <liljestrandh@gmail.com>
Date: Mon, 24 Jul 2017 16:38:23 +0300
Message-Id: <20170724133824.27223-5-LiljestrandH@gmail.com>
In-Reply-To: <20170724133824.27223-1-LiljestrandH@gmail.com>
References: <20170724133824.27223-1-LiljestrandH@gmail.com>
Subject: [kernel-hardening] [RFC PATCH 4/5] x86: MPXK base
To: kernel-hardening@lists.openwall.com
Cc: elena.reshetova@intel.com, dave.hansen@intel.com, keescook@chromium.org, hpa@zytor.com, Hans Liljestrand <LiljestrandH@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Enable and add needed support functionality for ring 0 MPX. MPXK is
enabled in init/main.c by setting the BNDCFGS MSR registers. This also
includes the mpxk_load_bounds implementation and error handling code for
MPX errors, i.e. bound violations.

Signed-off-by: Hans Liljestrand <LiljestrandH@gmail.com>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 arch/x86/include/asm/mpxk.h | 18 ++++++++++++
 arch/x86/kernel/traps.c     | 44 ++++++++++++++++++++++++++++-
 arch/x86/lib/Makefile       |  5 ++++
 arch/x86/lib/mpxk.c         | 69 +++++++++++++++++++++++++++++++++++++++++++++
 include/asm-generic/mpxk.h  | 20 +++++++++++++
 init/main.c                 |  2 ++
 6 files changed, 157 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/include/asm/mpxk.h
 create mode 100644 arch/x86/lib/mpxk.c
 create mode 100644 include/asm-generic/mpxk.h

diff --git a/arch/x86/include/asm/mpxk.h b/arch/x86/include/asm/mpxk.h
new file mode 100644
index 000000000000..b5cb684e24c6
--- /dev/null
+++ b/arch/x86/include/asm/mpxk.h
@@ -0,0 +1,18 @@
+/*
+ * arch/x86/include/asm/mpxk.h
+ *
+ * Copyright (C) 2017 Aalto University
+ */
+#ifndef _X86_INCLUDE_ASM_MPXK_H_
+#define _X86_INCLUDE_ASM_MPXK_H_
+
+#ifndef CONFIG_X86_INTEL_MPX_KERNEL
+/* Use the generic header that provides empty definitions */
+#include <asm-generic/mpxk.h>
+#else /*CONFIG_X86_INTEL_MPX_KERNEL */
+
+extern void mpxk_enable_mpx(void);
+extern void mpxk_print_bounds(const char *str, const void *ptr);
+
+#endif /*CONFIG_X86_INTEL_MPX_KERNEL */
+#endif /* _X86_INCLUDE_ASM_MPXK_H_ */
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index bf54309b85da..8291f57d4727 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -440,6 +440,48 @@ dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
 }
 #endif
 
+inline bool do_bounds_kernel(struct pt_regs *regs, long error_code)
+{
+#ifndef CONFIG_X86_INTEL_MPX_KERNEL
+	die("bounds", regs, error_code);
+#else
+	const struct mpx_bndcsr *bndcsr;
+	const char *err = NULL;
+
+	if (!cpu_feature_enabled(X86_FEATURE_MPX)) {
+		err = "cpu_feature_enabled(X86_FEATURE_MPX)";
+	} else {
+		bndcsr = get_xsave_field_ptr(XFEATURE_MASK_BNDCSR);
+		if (!bndcsr) {
+			err = "get_xsave_field_ptr failed";
+		} else {
+			trace_bounds_exception_mpx(bndcsr);
+
+			switch (bndcsr->bndstatus & MPX_BNDSTA_ERROR_CODE) {
+			case 2:	/* Bound directory has invalid entry. */
+				err = "invalid bound directory entry";
+				break;
+			case 1: /* Bound violation. */
+				err = "bounds violation!!!!";
+				break;
+			case 0: /* No exception caused by Intel MPX. */
+				err = "no Intel MPX exception found!?!";
+				break;
+			default:
+				err = "unrecognized bounds(?) error";
+				break;
+			}
+		}
+	}
+
+	if (err != NULL) {
+		pr_err("mpxk: %s\n", err);
+		BUG();
+	}
+	return true;
+#endif /* CONFIG_X86_INTEL_MPX_KERNEL */
+}
+
 dotraplinkage void do_bounds(struct pt_regs *regs, long error_code)
 {
 	const struct mpx_bndcsr *bndcsr;
@@ -452,7 +494,7 @@ dotraplinkage void do_bounds(struct pt_regs *regs, long error_code)
 	cond_local_irq_enable(regs);
 
 	if (!user_mode(regs))
-		die("bounds", regs, error_code);
+		do_bounds_kernel(regs, error_code);
 
 	if (!cpu_feature_enabled(X86_FEATURE_MPX)) {
 		/* The exception is not from Intel MPX */
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index 34a74131a12c..7024c4848181 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -46,3 +46,8 @@ else
         lib-y += copy_user_64.o
 	lib-y += cmpxchg16b_emu.o
 endif
+
+lib-$(CONFIG_X86_INTEL_MPX_KERNEL) += mpxk.o
+lib-$(CONFIG_X86_INTEL_MPX_KERNEL) += mpxk-wrappers.o
+CFLAGS_mpxk.o 		+= $(MPXK_LIB_CFLAGS)
+CFLAGS_mpxk-wrappers.o 	+= $(MPXK_LIB_CFLAGS)
diff --git a/arch/x86/lib/mpxk.c b/arch/x86/lib/mpxk.c
new file mode 100644
index 000000000000..69a7dae3f200
--- /dev/null
+++ b/arch/x86/lib/mpxk.c
@@ -0,0 +1,69 @@
+/*
+ * arch/x86/lib/mpxk.c
+ *
+ * Copyright (C) 2017 Aalto University
+ */
+#include <asm/siginfo.h>
+#include <linux/vmalloc.h>
+#include <linux/slab.h>
+#include <linux/mm.h>
+#include <asm/pgtable_64.h>
+
+#include <asm/mpx.h>
+#include <asm/mpxk.h>
+
+static struct msr bnd_cfg_s;
+
+__attribute__((bnd_legacy))
+static void mpxk_enable_mpx_cfgs_cpu(void *info)
+{
+	(void) info;
+	wrmsrl(MSR_IA32_BNDCFGS, bnd_cfg_s.q);
+}
+
+__attribute__((bnd_legacy))
+void mpxk_enable_mpx(void)
+{
+	void *ptr = get_vm_area(MPX_BD_SIZE_BYTES_64 + PAGE_SIZE, VM_MAP);
+
+	bnd_cfg_s.q = PAGE_ALIGN((unsigned long) ptr);
+	bnd_cfg_s.q |= MPX_BNDCFG_ENABLE_FLAG;
+
+	pr_info("mpxk: Setting up Intel MPX for kernel\n");
+
+	/* Config is passed via the global bnd_cfg_s.q */
+	on_each_cpu(mpxk_enable_mpx_cfgs_cpu, NULL, 1);
+}
+
+void mpxk_print_bounds(const char *str, const void *ptr)
+{
+	const unsigned long range = (((unsigned long)__bnd_get_ptr_ubound(ptr))
+			- ((unsigned long)__bnd_get_ptr_lbound(ptr)));
+
+	pr_info("%s: pointer %pK (bounds %pK + %ld\n",
+			str, ptr, __bnd_get_ptr_lbound(ptr), range);
+}
+
+void *mpxk_load_bounds(void *ptr)
+{
+	size_t size;
+
+	do {
+		if (ptr == NULL)
+			break;
+
+		if (!virt_addr_valid(ptr))
+			break;
+
+		if (!PageSlab(virt_to_page(ptr)))
+			break;
+
+		size = ksize(ptr);
+
+		if (size == 0)
+			return __bnd_null_ptr_bounds(ptr);
+		return __bnd_set_ptr_bounds(ptr, size);
+	} while (0);
+
+	return __bnd_init_ptr_bounds(ptr);
+}
diff --git a/include/asm-generic/mpxk.h b/include/asm-generic/mpxk.h
new file mode 100644
index 000000000000..0d3af7e12901
--- /dev/null
+++ b/include/asm-generic/mpxk.h
@@ -0,0 +1,20 @@
+/*
+ * include/asm-generic/mpxk.h
+ *
+ * Copyright (C) 2017 Aalto University
+ */
+#ifndef _ASM_MPXK_H_
+#define _ASM_MPXK_H_
+
+#include <asm/mpx.h>
+#include <linux/types.h>
+
+static inline void mpxk_enable_mpx(void)
+{}
+
+static inline void mpxk_print_bounds(const char *str, const void *ptr)
+{
+	pr_info("%s: MPXK disabled, no bounds for pointer %pK\n", str, ptr);
+}
+
+#endif /* _ASM_MPXK_H_ */
diff --git a/init/main.c b/init/main.c
index f866510472d7..eea12c81e7a9 100644
--- a/init/main.c
+++ b/init/main.c
@@ -94,6 +94,7 @@
 #include <asm/setup.h>
 #include <asm/sections.h>
 #include <asm/cacheflush.h>
+#include <asm/mpxk.h>
 
 static int kernel_init(void *);
 
@@ -883,6 +884,7 @@ static void __init do_basic_setup(void)
 	driver_init();
 	init_irq_proc();
 	do_ctors();
+	mpxk_enable_mpx();
 	usermodehelper_enable();
 	do_initcalls();
 }
-- 
2.11.0
