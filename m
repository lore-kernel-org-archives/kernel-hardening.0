From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 13 Jan 2018 10:17:58 -0800
Message-ID: <151586747805.5820.4398196873415688758.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151586744180.5820.13215059696964205856.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151586744180.5820.13215059696964205856.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v3 6/9] asm/nospec: mask speculative execution flows
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, Catalin Marinas <catalin.marinas@arm.com>, x86@kernel.org, Will Deacon <will.deacon@arm.com>, Russell King <linux@armlinux.org.uk>, Ingo Molnar <mingo@redhat.com>, gregkh@linuxfoundation.org, "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de, torvalds@linux-foundation.org, akpm@linux-foundation.org, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

'__array_ptr' is proposed as a generic mechanism to mitigate against
Spectre-variant-1 attacks, i.e. an attack that bypasses memory bounds
checks via speculative execution). The '__array_ptr' implementation
appears safe for current generation cpus across multiple architectures.

In comparison, 'ifence_array_ptr' uses a hard / architectural 'ifence'
approach to preclude the possibility speculative execution. However, it
is not the default given a concern for avoiding instruction-execution
barriers in potential fast paths.

Based on an original implementation by Linus Torvalds, tweaked to remove
speculative flows by Alexei Starovoitov, and tweaked again by Linus to
introduce an x86 assembly implementation for the mask generation.

Co-developed-by: Linus Torvalds <torvalds@linux-foundation.org>
Co-developed-by: Alexei Starovoitov <ast@kernel.org>
Co-developed-by: Peter Zijlstra <peterz@infradead.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/arm/Kconfig       |    1 +
 arch/arm64/Kconfig     |    1 +
 arch/x86/Kconfig       |    3 ++
 include/linux/nospec.h |   92 ++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/Kconfig.nospec  |   46 ++++++++++++++++++++++++
 kernel/Makefile        |    1 +
 kernel/nospec.c        |   52 +++++++++++++++++++++++++++
 lib/Kconfig            |    3 ++
 8 files changed, 199 insertions(+)
 create mode 100644 include/linux/nospec.h
 create mode 100644 kernel/Kconfig.nospec
 create mode 100644 kernel/nospec.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 51c8df561077..fd4789ec8cac 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -7,6 +7,7 @@ config ARM
 	select ARCH_HAS_DEBUG_VIRTUAL
 	select ARCH_HAS_DEVMEM_IS_ALLOWED
 	select ARCH_HAS_ELF_RANDOMIZE
+	select ARCH_HAS_IFENCE
 	select ARCH_HAS_SET_MEMORY
 	select ARCH_HAS_STRICT_KERNEL_RWX if MMU && !XIP_KERNEL
 	select ARCH_HAS_STRICT_MODULE_RWX if MMU
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index c9a7e9e1414f..22765c4b6986 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -16,6 +16,7 @@ config ARM64
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_GIGANTIC_PAGE if (MEMORY_ISOLATION && COMPACTION) || CMA
 	select ARCH_HAS_KCOV
+	select ARCH_HAS_IFENCE
 	select ARCH_HAS_SET_MEMORY
 	select ARCH_HAS_SG_CHAIN
 	select ARCH_HAS_STRICT_KERNEL_RWX
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d4fc98c50378..68698289c83c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -54,6 +54,7 @@ config X86
 	select ARCH_HAS_FORTIFY_SOURCE
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_KCOV			if X86_64
+	select ARCH_HAS_IFENCE
 	select ARCH_HAS_PMEM_API		if X86_64
 	# Causing hangs/crashes, see the commit that added this change for details.
 	select ARCH_HAS_REFCOUNT
@@ -442,6 +443,8 @@ config INTEL_RDT
 
 	  Say N if unsure.
 
+source "kernel/Kconfig.nospec"
+
 if X86_32
 config X86_EXTENDED_PLATFORM
 	bool "Support for extended (non-PC) x86 platforms"
diff --git a/include/linux/nospec.h b/include/linux/nospec.h
new file mode 100644
index 000000000000..f6e7ba7a7344
--- /dev/null
+++ b/include/linux/nospec.h
@@ -0,0 +1,92 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright(c) 2018 Intel Corporation. All rights reserved.
+
+#ifndef __NOSPEC_H__
+#define __NOSPEC_H__
+
+#include <linux/jump_label.h>
+#include <asm/barrier.h>
+
+/*
+ * If idx is negative or if idx > size then bit 63 is set in the mask,
+ * and the value of ~(-1L) is zero. When the mask is zero, bounds check
+ * failed, __array_ptr will return NULL.
+ */
+#ifndef array_ptr_mask
+#define array_ptr_mask(idx, sz)						\
+({									\
+	unsigned long mask;						\
+	unsigned long _i = (idx);					\
+	unsigned long _s = (sz);					\
+									\
+	mask = ~(long)(_i | (_s - 1 - _i)) >> (BITS_PER_LONG - 1);	\
+	mask;								\
+})
+#endif
+
+/**
+ * __array_ptr - Generate a pointer to an array element, ensuring
+ * the pointer is bounded under speculation to NULL.
+ *
+ * @base: the base of the array
+ * @idx: the index of the element, must be less than LONG_MAX
+ * @sz: the number of elements in the array, must be less than LONG_MAX
+ *
+ * If @idx falls in the interval [0, @sz), returns the pointer to
+ * @arr[@idx], otherwise returns NULL.
+ */
+#define __array_ptr(base, idx, sz)					\
+({									\
+	union { typeof(*(base)) *_ptr; unsigned long _bit; } __u;	\
+	typeof(*(base)) *_arr = (base);					\
+	unsigned long _i = (idx);					\
+	unsigned long _mask = array_ptr_mask(_i, (sz));			\
+									\
+	__u._ptr = _arr + (_i & _mask);					\
+	__u._bit &= _mask;						\
+	__u._ptr;							\
+})
+
+#if defined(ARCH_HAS_IFENCE) && !defined(ifence_array_ptr)
+#error Arch claims ARCH_HAS_IFENCE, but does not implement ifence_array_ptr
+#endif
+
+#ifdef CONFIG_SPECTRE1_DYNAMIC
+#ifndef HAVE_JUMP_LABEL
+#error Compiler lacks asm-goto, can generate unsafe code
+#endif
+
+#ifdef CONFIG_SPECTRE1_IFENCE
+DECLARE_STATIC_KEY_TRUE(nospec_key);
+#else
+DECLARE_STATIC_KEY_FALSE(nospec_key);
+#endif
+
+/*
+ * The expectation is that no compiler or cpu will mishandle __array_ptr
+ * leading to problematic speculative execution. Bypass the ifence
+ * based implementation by default.
+ */
+#define array_ptr(base, idx, sz)				\
+({								\
+	typeof(*(base)) *__ret;					\
+								\
+	if (static_branch_unlikely(&nospec_key))		\
+		__ret = ifence_array_ptr(base, idx, sz);	\
+	else							\
+		__ret = __array_ptr(base, idx, sz);		\
+	__ret;							\
+})
+#else /* CONFIG_SPECTRE1_DYNAMIC */
+/*
+ * If jump labels are disabled we hard code either ifence_array_ptr or
+ * array_ptr based on the config choice
+ */
+#ifdef CONFIG_SPECTRE1_IFENCE
+#define array_ptr ifence_array_ptr
+#else
+/* fallback to __array_ptr by default */
+#define array_ptr __array_ptr
+#endif
+#endif /* CONFIG_SPECTRE1_DYNAMIC */
+#endif /* __NOSPEC_H__ */
diff --git a/kernel/Kconfig.nospec b/kernel/Kconfig.nospec
new file mode 100644
index 000000000000..33e34a87d067
--- /dev/null
+++ b/kernel/Kconfig.nospec
@@ -0,0 +1,46 @@
+# SPDX-License-Identifier: GPL-2.0
+
+menu "Speculative execution past bounds check"
+	depends on ARCH_HAS_IFENCE
+
+choice
+        prompt "Speculative execution past bounds check"
+        default SPECTRE1_MASK
+        help
+	  Select the default mechanism for guarding against kernel
+	  memory leaks via speculative execution past a boundary-check
+	  (Spectre variant1) . This choice determines the contents of
+	  the array_ptr() helper. Note, that vulnerable code paths need
+	  to be instrumented with this helper to be protected.
+
+config SPECTRE1_MASK
+	bool "mask"
+	help
+	  Provide an array_ptr() implementation that arranges for only
+	  safe speculative flows to be exposed to the compiler/cpu. It
+	  is preferred over "ifence" since it arranges for problematic
+	  speculation to be disabled without need of an instruction
+	  barrier.
+
+config SPECTRE1_IFENCE
+	bool "ifence"
+	depends on ARCH_HAS_IFENCE
+	help
+	  Provide a array_ptr() implementation that is specified by the
+	  cpu architecture to barrier all speculative execution.  Unless
+	  you have specific knowledge of the "mask" approach being
+	  unsuitable with a given compiler/cpu, select "mask".
+
+endchoice
+
+config SPECTRE1_DYNAMIC
+	bool "Support dynamic switching of speculative execution mitigation"
+	depends on ARCH_HAS_IFENCE
+	depends on JUMP_LABEL
+	help
+	  For architectures that support the 'ifence' mitigation, allow
+	  dynamic switching between it and the 'mask' approach. This supports
+	  evaluation or emergency switching.
+
+	  If unsure, say Y
+endmenu
diff --git a/kernel/Makefile b/kernel/Makefile
index 172d151d429c..d5269be9d58a 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -101,6 +101,7 @@ obj-$(CONFIG_TRACEPOINTS) += trace/
 obj-$(CONFIG_IRQ_WORK) += irq_work.o
 obj-$(CONFIG_CPU_PM) += cpu_pm.o
 obj-$(CONFIG_BPF) += bpf/
+obj-$(CONFIG_SPECTRE1_DYNAMIC) += nospec.o
 
 obj-$(CONFIG_PERF_EVENTS) += events/
 
diff --git a/kernel/nospec.c b/kernel/nospec.c
new file mode 100644
index 000000000000..992de957216d
--- /dev/null
+++ b/kernel/nospec.c
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright(c) 2018 Intel Corporation. All rights reserved.
+#include <linux/module.h>
+#include <linux/compiler.h>
+#include <linux/jump_label.h>
+#include <linux/moduleparam.h>
+
+enum {
+	F_IFENCE,
+};
+
+#ifdef CONFIG_SPECTRE1_IFENCE
+static unsigned long nospec_flag = 1 << F_IFENCE;
+DEFINE_STATIC_KEY_TRUE(nospec_key);
+#else
+static unsigned long nospec_flag;
+DEFINE_STATIC_KEY_FALSE(nospec_key);
+#endif
+
+EXPORT_SYMBOL(nospec_key);
+
+static int param_set_nospec(const char *val, const struct kernel_param *kp)
+{
+	unsigned long *flags = kp->arg;
+
+	if (strcmp(val, "ifence") == 0 || strcmp(val, "ifence\n") == 0) {
+		if (!test_and_set_bit(F_IFENCE, flags))
+			static_key_enable(&nospec_key.key);
+		return 0;
+	} else if (strcmp(val, "mask") == 0 || strcmp(val, "mask\n") == 0) {
+		if (test_and_clear_bit(F_IFENCE, flags))
+			static_key_disable(&nospec_key.key);
+		return 0;
+	}
+	return -EINVAL;
+}
+
+static int param_get_nospec(char *buffer, const struct kernel_param *kp)
+{
+	unsigned long *flags = kp->arg;
+
+	return sprintf(buffer, "%s\n", test_bit(F_IFENCE, flags)
+			? "ifence" : "mask");
+}
+
+static struct kernel_param_ops nospec_param_ops = {
+	.set = param_set_nospec,
+	.get = param_get_nospec,
+};
+
+core_param_cb(spectre_v1, &nospec_param_ops, &nospec_flag, 0600);
+MODULE_PARM_DESC(spectre_v1, "Spectre-v1 mitigation: 'mask' (default) vs 'ifence'");
diff --git a/lib/Kconfig b/lib/Kconfig
index c5e84fbcb30b..3cc7e7a03781 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -570,6 +570,9 @@ config STACKDEPOT
 	bool
 	select STACKTRACE
 
+config ARCH_HAS_IFENCE
+	bool
+
 config SBITMAP
 	bool
 
