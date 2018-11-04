From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC/RFT PATCH] ARM: smp: add support for per-task stack canaries
Date: Sun,  4 Nov 2018 17:28:45 +0100
Message-Id: <20181104162845.16938-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: linux-arm-kernel@lists.infradead.org
Cc: linux@armlinux.org.uk, keescook@chromium.org, arnd@arndb.de, re.emese@gmail.com, nicolas.pitre@linaro.org, kernel-hardening@lists.openwall.com, labbott@redhat.com, marc.zyngier@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On ARM, we currently only change the value of the stack canary when
switching tasks if the kernel was built for UP. On SMP kernels, this
is impossible since the stack canary value is obtained via a global
symbol reference, which means
a) all running tasks on all CPUs must use the same value
b) we can only modify the value when no kernel stack frames are live,
   which is effectively never.

So instead, use a GCC plugin to add a RTL pass that replaces each
reference to the address of the __stack_chk_guard symbol with an
expression that produces the address of the 'stack_canary' field
that is added to struct thread_info. This way, each task will use
its own randomized value.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
Known issues:
- The plugin requires the values of THREAD_SIZE and the offset of
  stack_canary in struct thread_info at a really early stage in the
  build, so I had to redefine them in the plugin source.

Questions:
- Are there any execution contexts except for the decompressor and the
  EFI stub where we should disable this? KVM perhaps?

Comments and test results welcome.

 arch/arm/Kconfig                              | 16 ++++
 arch/arm/boot/compressed/Makefile             |  1 +
 arch/arm/include/asm/stackprotector.h         | 12 ++-
 arch/arm/include/asm/thread_info.h            |  3 +
 arch/arm/kernel/process.c                     |  9 ++-
 scripts/Makefile.gcc-plugins                  |  6 ++
 scripts/gcc-plugins/Kconfig                   |  4 +
 scripts/gcc-plugins/arm_ssp_per_task_plugin.c | 78 ++++++++++++++++++++
 8 files changed, 126 insertions(+), 3 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 91be74d8df65..7b50d5e3d030 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1810,6 +1810,22 @@ config XEN
 	help
 	  Say Y if you want to run Linux in a Virtual Machine on Xen on ARM.
 
+config STACKPROTECTOR_PER_TASK
+	bool "Use a unique stack canary value for each task"
+	depends on GCC_PLUGINS && STACKPROTECTOR && SMP
+	select GCC_PLUGIN_ARM_SSP_PER_TASK
+	help
+	  Due to the fact that GCC uses an ordinary symbol reference from
+	  which to load the value of the stack canary, this value can only
+	  change at reboot time on SMP systems, and all tasks running in the
+	  kernel's address space are forced to use the same canary value for
+	  the entire duration that the system is up.
+
+	  Enable this option to switch to a different method that uses a
+	  different canary value for each task.
+
+	  This is not enabled by default since it relies on a GCC plugin.
+
 endmenu
 
 menu "Boot options"
diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index 1f5a5ffe7fcf..01bf2585a0fa 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -101,6 +101,7 @@ clean-files += piggy_data lib1funcs.S ashldi3.S bswapsdi2.S \
 		$(libfdt) $(libfdt_hdrs) hyp-stub.S
 
 KBUILD_CFLAGS += -DDISABLE_BRANCH_PROFILING
+KBUILD_CFLAGS += $(DISABLE_ARM_SSP_PER_TASK_PLUGIN)
 
 ifeq ($(CONFIG_FUNCTION_TRACER),y)
 ORIG_CFLAGS := $(KBUILD_CFLAGS)
diff --git a/arch/arm/include/asm/stackprotector.h b/arch/arm/include/asm/stackprotector.h
index ef5f7b69443e..72a20c3a0a90 100644
--- a/arch/arm/include/asm/stackprotector.h
+++ b/arch/arm/include/asm/stackprotector.h
@@ -6,8 +6,10 @@
  * the stack frame and verifying that it hasn't been overwritten when
  * returning from the function.  The pattern is called stack canary
  * and gcc expects it to be defined by a global variable called
- * "__stack_chk_guard" on ARM.  This unfortunately means that on SMP
- * we cannot have a different canary value per task.
+ * "__stack_chk_guard" on ARM.  This prevents SMP systems from using a
+ * different value for each task unless we enable a GCC plugin that
+ * replaces these symbol references with references to each task's own
+ * value.
  */
 
 #ifndef _ASM_STACKPROTECTOR_H
@@ -16,6 +18,8 @@
 #include <linux/random.h>
 #include <linux/version.h>
 
+#include <asm/thread_info.h>
+
 extern unsigned long __stack_chk_guard;
 
 /*
@@ -33,7 +37,11 @@ static __always_inline void boot_init_stack_canary(void)
 	canary ^= LINUX_VERSION_CODE;
 
 	current->stack_canary = canary;
+#ifndef CONFIG_STACKPROTECTOR_PER_TASK
 	__stack_chk_guard = current->stack_canary;
+#else
+	current_thread_info()->stack_canary = current->stack_canary;
+#endif
 }
 
 #endif	/* _ASM_STACKPROTECTOR_H */
diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
index 8f55dc520a3e..bd661c7681b1 100644
--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -57,6 +57,9 @@ struct thread_info {
 	__u32			syscall;	/* syscall number */
 	__u8			used_cp[16];	/* thread used copro */
 	unsigned long		tp_value[2];	/* TLS registers */
+#ifdef CONFIG_STACKPROTECTOR_PER_TASK
+	unsigned long		stack_canary;
+#endif
 #ifdef CONFIG_CRUNCH
 	struct crunch_state	crunchstate;
 #endif
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 82ab015bf42b..ca2e220ec892 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -39,7 +39,7 @@
 #include <asm/tls.h>
 #include <asm/vdso.h>
 
-#ifdef CONFIG_STACKPROTECTOR
+#if defined(CONFIG_STACKPROTECTOR) && !defined(CONFIG_STACKPROTECTOR_PER_TASK)
 #include <linux/stackprotector.h>
 unsigned long __stack_chk_guard __read_mostly;
 EXPORT_SYMBOL(__stack_chk_guard);
@@ -267,6 +267,13 @@ copy_thread(unsigned long clone_flags, unsigned long stack_start,
 
 	thread_notify(THREAD_NOTIFY_COPY, thread);
 
+#ifdef CONFIG_STACKPROTECTOR_PER_TASK
+	BUILD_BUG_ON(offsetof(struct thread_info, stack_canary) != 100);
+	BUILD_BUG_ON(THREAD_SIZE != 0x2000);
+
+	thread->stack_canary = p->stack_canary;
+#endif
+
 	return 0;
 }
 
diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
index 46c5c6809806..048179d8c07f 100644
--- a/scripts/Makefile.gcc-plugins
+++ b/scripts/Makefile.gcc-plugins
@@ -36,6 +36,12 @@ ifdef CONFIG_GCC_PLUGIN_STACKLEAK
 endif
 export DISABLE_STACKLEAK_PLUGIN
 
+gcc-plugin-$(CONFIG_GCC_PLUGIN_ARM_SSP_PER_TASK) += arm_ssp_per_task_plugin.so
+ifdef CONFIG_GCC_PLUGIN_ARM_SSP_PER_TASK
+    DISABLE_ARM_SSP_PER_TASK_PLUGIN += -fplugin-arg-arm_ssp_per_task_plugin-disable
+endif
+export DISABLE_ARM_SSP_PER_TASK_PLUGIN
+
 # All the plugin CFLAGS are collected here in case a build target needs to
 # filter them out of the KBUILD_CFLAGS.
 GCC_PLUGINS_CFLAGS := $(strip $(addprefix -fplugin=$(objtree)/scripts/gcc-plugins/, $(gcc-plugin-y)) $(gcc-plugin-cflags-y))
diff --git a/scripts/gcc-plugins/Kconfig b/scripts/gcc-plugins/Kconfig
index 0d5c799688f0..d45f7f36b859 100644
--- a/scripts/gcc-plugins/Kconfig
+++ b/scripts/gcc-plugins/Kconfig
@@ -190,4 +190,8 @@ config STACKLEAK_RUNTIME_DISABLE
 	  runtime to control kernel stack erasing for kernels built with
 	  CONFIG_GCC_PLUGIN_STACKLEAK.
 
+config GCC_PLUGIN_ARM_SSP_PER_TASK
+	bool
+	depends on GCC_PLUGINS && ARM
+
 endif
diff --git a/scripts/gcc-plugins/arm_ssp_per_task_plugin.c b/scripts/gcc-plugins/arm_ssp_per_task_plugin.c
new file mode 100644
index 000000000000..97d090e08b40
--- /dev/null
+++ b/scripts/gcc-plugins/arm_ssp_per_task_plugin.c
@@ -0,0 +1,78 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "gcc-common.h"
+
+/* TODO: wire these up to the .h files that define them */
+#define THREAD_SIZE			0x2000
+#define TI_STACK_CANARY_OFFSET		100
+
+__visible int plugin_is_GPL_compatible;
+
+static unsigned int arm_pertask_ssp_rtl_execute(void)
+{
+	rtx_insn *insn;
+
+	for (insn = get_insns(); insn; insn = NEXT_INSN(insn)) {
+		const char *sym;
+		rtx body;
+		rtx masked_sp;
+
+		/*
+		 * Find a SET insn involving a SYMBOL_REF to __stack_chk_guard
+		 */
+		if (!INSN_P(insn))
+			continue;
+		body = PATTERN(insn);
+		if (GET_CODE(body) != SET ||
+		    GET_CODE(SET_SRC(body)) != SYMBOL_REF)
+			continue;
+		sym = XSTR(SET_SRC(body), 0);
+		if (strcmp(sym, "__stack_chk_guard"))
+			continue;
+
+		/*
+		 * Replace the source of the SET insn with an expression that
+		 * produces the address of the copy of the stack canary value
+		 * stored in struct thread_info
+		 */
+		masked_sp = gen_reg_rtx(Pmode);
+
+		emit_insn_before(gen_rtx_SET(masked_sp,
+					     gen_rtx_AND(Pmode,
+							 stack_pointer_rtx,
+							 GEN_INT(~(THREAD_SIZE - 1)))),
+				 insn);
+
+		SET_SRC(body) = gen_rtx_PLUS(Pmode, masked_sp,
+					     GEN_INT(TI_STACK_CANARY_OFFSET));
+	}
+	return 0;
+}
+
+#define PASS_NAME arm_pertask_ssp_rtl
+
+#define NO_GATE
+#include "gcc-generate-rtl-pass.h"
+
+__visible int plugin_init(struct plugin_name_args *plugin_info,
+			  struct plugin_gcc_version *version)
+{
+	int i;
+
+	if (!plugin_default_version_check(version, &gcc_version)) {
+		error(G_("incompatible gcc/plugin versions"));
+		return 1;
+	}
+
+	for (i = 0; i < plugin_info->argc; i++) {
+		if (strcmp(plugin_info->argv[i].key, "disable") == 0)
+			return 0;
+	}
+
+	PASS_INFO(arm_pertask_ssp_rtl, "expand", 1, PASS_POS_INSERT_AFTER);
+
+	register_callback(plugin_info->base_name, PLUGIN_PASS_MANAGER_SETUP,
+			  NULL, &arm_pertask_ssp_rtl_pass_info);
+
+	return 0;
+}
-- 
2.19.1
