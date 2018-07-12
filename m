Date: Wed, 11 Jul 2018 17:03:37 -0700
From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] arm64: Add support for STACKLEAK gcc plugin
Message-ID: <20180712000337.GA4022@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
To: Will Deacon <will.deacon@arm.com>
Cc: Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Alexander Popov <alex.popov@linux.com>, Catalin Marinas <catalin.marinas@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Laura Abbott <labbott@redhat.com>

This adds support for the STACKLEAK gcc plugin to arm64 by implementing
stackleak_check_alloca(), based heavily on the x86 version, and adding the
two helpers used by the stackleak common code: current_top_of_stack() and
on_thread_stack(). The stack erasure calls are made at syscall returns.
Additionally, this disables the plugin in hypervisor and EFI stub code,
which are out of scope for the protection.

Signed-off-by: Laura Abbott <labbott@redhat.com>
[kees: add cast to current_top_of_stack(), tweak commit log & comments]
Signed-off-by: Kees Cook <keescook@chromium.org>
---
This is tweaked to be stand-alone from Alexander's series so it can land
via the arm64 tree. (Alexander's v14 pulled one change out already, and
I've lifted the last remaining: the newly needed include in stackleak.h)
---
 arch/arm64/Kconfig                    |  1 +
 arch/arm64/include/asm/processor.h    | 10 ++++++++++
 arch/arm64/kernel/entry.S             |  7 +++++++
 arch/arm64/kernel/process.c           | 16 ++++++++++++++++
 arch/arm64/kvm/hyp/Makefile           |  3 ++-
 drivers/firmware/efi/libstub/Makefile |  3 ++-
 6 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 42c090cf0292..216d36a49ab5 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -96,6 +96,7 @@ config ARM64
 	select HAVE_ARCH_MMAP_RND_BITS
 	select HAVE_ARCH_MMAP_RND_COMPAT_BITS if COMPAT
 	select HAVE_ARCH_SECCOMP_FILTER
+	select HAVE_ARCH_STACKLEAK
 	select HAVE_ARCH_THREAD_STRUCT_WHITELIST
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index a73ae1e49200..ca856bda2051 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -266,5 +266,15 @@ extern void __init minsigstksz_setup(void);
 #define SVE_SET_VL(arg)	sve_set_current_vl(arg)
 #define SVE_GET_VL()	sve_get_current_vl()
 
+/*
+ * For the STACKLEAK gcc plugin.
+ *
+ * These need to be macros because otherwise we get stuck in a nightmare
+ * of header definitions for the use of task_stack_page.
+ */
+#define current_top_of_stack()	((unsigned long)task_stack_page(current) + \
+				 THREAD_SIZE)
+#define on_thread_stack()	(on_task_stack(current, current_stack_pointer))
+
 #endif /* __ASSEMBLY__ */
 #endif /* __ASM_PROCESSOR_H */
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 28ad8799406f..80bc93d971f7 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -431,6 +431,11 @@ tsk	.req	x28		// current thread_info
 
 	.text
 
+	.macro	stackleak_erase
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+	bl	stackleak_erase_kstack
+#endif
+	.endm
 /*
  * Exception vectors.
  */
@@ -910,6 +915,7 @@ ret_fast_syscall:
 	and	x2, x1, #_TIF_WORK_MASK
 	cbnz	x2, work_pending
 	enable_step_tsk x1, x2
+	stackleak_erase
 	kernel_exit 0
 ret_fast_syscall_trace:
 	enable_daif
@@ -936,6 +942,7 @@ ret_to_user:
 	cbnz	x2, work_pending
 finish_ret_to_user:
 	enable_step_tsk x1, x2
+	stackleak_erase
 	kernel_exit 0
 ENDPROC(ret_to_user)
 
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index e10bc363f533..d99281b476b0 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -493,3 +493,19 @@ void arch_setup_new_exec(void)
 {
 	current->mm->context.flags = is_compat_task() ? MMCF_AARCH32 : 0;
 }
+
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+#define MIN_STACK_LEFT	256
+
+void __used stackleak_check_alloca(unsigned long size)
+{
+	unsigned long sp, stack_left;
+
+	sp = current_stack_pointer;
+
+	stack_left = sp & (THREAD_SIZE - 1);
+	BUG_ON(stack_left < MIN_STACK_LEFT ||
+		size >= stack_left - MIN_STACK_LEFT);
+}
+EXPORT_SYMBOL(stackleak_check_alloca);
+#endif
diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index 4313f7475333..2fabc2dc1966 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -3,7 +3,8 @@
 # Makefile for Kernel-based Virtual Machine module, HYP part
 #
 
-ccflags-y += -fno-stack-protector -DDISABLE_BRANCH_PROFILING
+ccflags-y += -fno-stack-protector -DDISABLE_BRANCH_PROFILING \
+		$(DISABLE_STACKLEAK_PLUGIN)
 
 KVM=../../../../virt/kvm
 
diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index a34e9290a699..25dd2a14560d 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -20,7 +20,8 @@ cflags-$(CONFIG_EFI_ARMSTUB)	+= -I$(srctree)/scripts/dtc/libfdt
 KBUILD_CFLAGS			:= $(cflags-y) -DDISABLE_BRANCH_PROFILING \
 				   -D__NO_FORTIFY \
 				   $(call cc-option,-ffreestanding) \
-				   $(call cc-option,-fno-stack-protector)
+				   $(call cc-option,-fno-stack-protector) \
+				   $(DISABLE_STACKLEAK_PLUGIN)
 
 GCOV_PROFILE			:= n
 KASAN_SANITIZE			:= n
-- 
2.17.1


-- 
Kees Cook
Pixel Security
