From: Laura Abbott <labbott@redhat.com>
Subject: [PATCH 2/2] arm64: Clear the stack
Date: Tue, 20 Feb 2018 17:13:03 -0800
Message-Id: <20180221011303.20392-3-labbott@redhat.com>
In-Reply-To: <20180221011303.20392-1-labbott@redhat.com>
References: <20180221011303.20392-1-labbott@redhat.com>
To: Alexander Popov <alex.popov@linux.com>, Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Laura Abbott <labbott@redhat.com>, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


Implementation of stackleak based heavily on the x86 version

Signed-off-by: Laura Abbott <labbott@redhat.com>
---
 arch/arm64/Kconfig                    |   1 +
 arch/arm64/include/asm/processor.h    |   6 ++
 arch/arm64/kernel/asm-offsets.c       |   3 +
 arch/arm64/kernel/entry.S             | 108 ++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/process.c           |  16 +++++
 drivers/firmware/efi/libstub/Makefile |   3 +-
 scripts/Makefile.gcc-plugins          |   5 +-
 7 files changed, 140 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 7381eeb7ef8e..dcadcae674a7 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -92,6 +92,7 @@ config ARM64
 	select HAVE_ARCH_MMAP_RND_BITS
 	select HAVE_ARCH_MMAP_RND_COMPAT_BITS if COMPAT
 	select HAVE_ARCH_SECCOMP_FILTER
+	select HAVE_ARCH_STACKLEAK
 	select HAVE_ARCH_THREAD_STRUCT_WHITELIST
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index fce604e3e599..4b309101ac83 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -114,6 +114,12 @@ struct thread_struct {
 	unsigned long		fault_address;	/* fault info */
 	unsigned long		fault_code;	/* ESR_EL1 value */
 	struct debug_info	debug;		/* debugging */
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+	unsigned long           lowest_stack;
+#ifdef CONFIG_STACKLEAK_METRICS
+	unsigned long		prev_lowest_stack;
+#endif
+#endif
 };
 
 /*
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 1303e04110cd..b5c6100e8b14 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -45,6 +45,9 @@ int main(void)
   DEFINE(TSK_TI_TTBR0,		offsetof(struct task_struct, thread_info.ttbr0));
 #endif
   DEFINE(TSK_STACK,		offsetof(struct task_struct, stack));
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+  DEFINE(TSK_TI_LOWEST_STACK,	offsetof(struct task_struct, thread.lowest_stack));
+#endif
   BLANK();
   DEFINE(THREAD_CPU_CONTEXT,	offsetof(struct task_struct, thread.cpu_context));
   BLANK();
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index ec2ee720e33e..b909b436293a 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -401,6 +401,11 @@ tsk	.req	x28		// current thread_info
 
 	.text
 
+	.macro	erase_kstack
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+	bl	__erase_kstack
+#endif
+	.endm
 /*
  * Exception vectors.
  */
@@ -901,6 +906,7 @@ work_pending:
  */
 ret_to_user:
 	disable_daif
+	erase_kstack
 	ldr	x1, [tsk, #TSK_TI_FLAGS]
 	and	x2, x1, #_TIF_WORK_MASK
 	cbnz	x2, work_pending
@@ -1337,3 +1343,105 @@ alternative_else_nop_endif
 ENDPROC(__sdei_asm_handler)
 NOKPROBE(__sdei_asm_handler)
 #endif /* CONFIG_ARM_SDE_INTERFACE */
+
+/*
+ * This is what the stack looks like
+ *
+ * +---+ <- task_stack_page(p) + THREAD_SIZE
+ * |   |
+ * +---+ <- task_stack_page(p) + THREAD_START_SP
+ * |   |
+ * |   |
+ * +---+ <- task_pt_regs(p)
+ * |   |
+ * |   |
+ * |   | <- current_sp
+ * ~~~~~
+ *
+ * ~~~~~
+ * |   | <- lowest_stack
+ * |   |
+ * |   |
+ * +---+ <- task_stack_page(p)
+ *
+ * This function is desgned to poison the memory between the lowest_stack
+ * and the current stack pointer. After clearing the stack, the lowest
+ * stack is reset.
+ */
+
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+ENTRY(__erase_kstack)
+	mov	x10, x0	// save x0 for the fast path
+
+	get_thread_info	x0
+	ldr	x1, [x0, #TSK_TI_LOWEST_STACK]
+
+	/* get the number of bytes to check for lowest stack */
+	mov	x3, x1
+	and	x3, x3, #THREAD_SIZE - 1
+	lsr	x3, x3, #3
+
+	/* generate addresses from the bottom of the stack */
+	mov	x4, sp
+	movn	x2, #THREAD_SIZE - 1
+	and	x1, x4, x2
+
+	mov	x2, #STACKLEAK_POISON
+
+	mov	x5, #0
+1:
+	/*
+	 * As borrowed from the x86 logic, start from the lowest_stack
+	 * and go to the bottom to find the poison value.
+	 * The check of 16 is to hopefully avoid false positives.
+	 */
+	cbz	x3, 4f
+	ldr	x4, [x1, x3, lsl #3]
+	cmp	x4, x2
+	csinc	x5, xzr, x5, ne
+	tbnz	x5, #STACKLEAK_POISON_CHECK_DEPTH/4, 4f	// found 16 poisons?
+	sub	x3, x3, #1
+	b	1b
+
+4:
+	/* total number of bytes to poison */
+	add     x5, x1, x3, lsl #3
+	mov	x4, sp
+	sub     x8, x4, x5
+
+	cmp     x8, #THREAD_SIZE // sanity check the range
+	b.lo    5f
+	ASM_BUG()
+
+5:
+	/*
+	 * We may have hit a path where the stack did not get used,
+	 * no need to do anything here
+	 */
+	cbz	x8, 7f
+
+	sub	x8, x8, #1 // don't poison the current stack pointer
+
+	lsr     x8, x8, #3
+	add     x3, x3, x8
+
+	/*
+	 * The logic of this loop ensures the last stack word isn't
+	 * ovewritten.
+	 */
+6:
+	cbz     x8, 7f
+	str     x2, [x1, x3, lsl #3]
+	sub     x3, x3, #1
+	sub     x8, x8, #1
+	b	6b
+
+	/* Reset the lowest stack to the top of the stack */
+7:
+	mov	x1, sp
+	str	x1, [x0, #TSK_TI_LOWEST_STACK]
+
+	mov	x0, x10
+	ret
+ENDPROC(__erase_kstack)
+#endif
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index ad8aeb098b31..fd0528db6772 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -357,6 +357,9 @@ int copy_thread(unsigned long clone_flags, unsigned long stack_start,
 	p->thread.cpu_context.pc = (unsigned long)ret_from_fork;
 	p->thread.cpu_context.sp = (unsigned long)childregs;
 
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+	p->thread.lowest_stack = (unsigned long)task_stack_page(p);
+#endif
 	ptrace_hw_copy_thread(p);
 
 	return 0;
@@ -486,3 +489,16 @@ void arch_setup_new_exec(void)
 {
 	current->mm->context.flags = is_compat_task() ? MMCF_AARCH32 : 0;
 }
+
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+void __used check_alloca(unsigned long size)
+{
+	unsigned long sp, stack_left;
+
+	sp = current_stack_pointer;
+
+	stack_left = sp & (THREAD_SIZE - 1);
+	BUG_ON(stack_left < 256 || size >= stack_left - 256);
+}
+EXPORT_SYMBOL(check_alloca);
+#endif
diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index 7b3ba40f0745..35ebbc1b17ff 100644
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
diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
index 8d6070fc538f..6cc0e35d3324 100644
--- a/scripts/Makefile.gcc-plugins
+++ b/scripts/Makefile.gcc-plugins
@@ -37,11 +37,14 @@ ifdef CONFIG_GCC_PLUGINS
 
   gcc-plugin-$(CONFIG_GCC_PLUGIN_STACKLEAK)	+= stackleak_plugin.so
   gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STACKLEAK)	+= -DSTACKLEAK_PLUGIN -fplugin-arg-stackleak_plugin-track-min-size=$(CONFIG_STACKLEAK_TRACK_MIN_SIZE)
+  ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+    DISABLE_STACKLEAK_PLUGIN		+= -fplugin-arg-stackleak_plugin-disable
+  endif
 
   GCC_PLUGINS_CFLAGS := $(strip $(addprefix -fplugin=$(objtree)/scripts/gcc-plugins/, $(gcc-plugin-y)) $(gcc-plugin-cflags-y))
 
   export PLUGINCC GCC_PLUGINS_CFLAGS GCC_PLUGIN GCC_PLUGIN_SUBDIR
-  export SANCOV_PLUGIN DISABLE_LATENT_ENTROPY_PLUGIN
+  export SANCOV_PLUGIN DISABLE_LATENT_ENTROPY_PLUGIN DISABLE_STACKLEAK_PLUGIN
 
   ifneq ($(PLUGINCC),)
     # SANCOV_PLUGIN can be only in CFLAGS_KCOV because avoid duplication.
-- 
2.14.3
