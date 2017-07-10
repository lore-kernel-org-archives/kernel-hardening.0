From: Laura Abbott <labbott@redhat.com>
Date: Mon, 10 Jul 2017 15:04:43 -0700
Message-Id: <1499724283-30719-3-git-send-email-labbott@redhat.com>
In-Reply-To: <1499724283-30719-1-git-send-email-labbott@redhat.com>
References: <1499724283-30719-1-git-send-email-labbott@redhat.com>
Subject: [kernel-hardening] [RFC][PATCH 2/2] arm64: Clear the stack
To: Kees Cook <keescook@chromium.org>, Alex Popov <alex.popov@linux.com>
Cc: Laura Abbott <labbott@redhat.com>, kernel-hardening@lists.openwall.com, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

Implementation of stackleak based heavily on the x86 version

Signed-off-by: Laura Abbott <labbott@redhat.com>
---
The biggest points that need review here:
- Is the extra offsetting (subtracting/adding from the stack) correct?
- Where else do we need to clear the stack?
- The assembly can almost certainly be optimized. I tried to keep the
  behavior of the x86 'repe scasq' and the like where possible. I'm also a
  terrible register allocator.
---
 arch/arm64/Kconfig                    |  1 +
 arch/arm64/include/asm/processor.h    |  3 ++
 arch/arm64/kernel/asm-offsets.c       |  3 ++
 arch/arm64/kernel/entry.S             | 92 +++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/process.c           | 18 +++++++
 drivers/firmware/efi/libstub/Makefile |  3 +-
 scripts/Makefile.gcc-plugins          |  5 +-
 7 files changed, 123 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 8addb85..0b65bfc 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -17,6 +17,7 @@ config ARM64
 	select ARCH_HAS_KCOV
 	select ARCH_HAS_SET_MEMORY
 	select ARCH_HAS_SG_CHAIN
+	select ARCH_HAS_STACKLEAK
 	select ARCH_HAS_STRICT_KERNEL_RWX
 	select ARCH_HAS_STRICT_MODULE_RWX
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 64c9e78..76f2738 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -88,6 +88,9 @@ struct thread_struct {
 	unsigned long		fault_address;	/* fault info */
 	unsigned long		fault_code;	/* ESR_EL1 value */
 	struct debug_info	debug;		/* debugging */
+#ifdef CONFIG_STACKLEAK
+	unsigned long           lowest_stack;
+#endif
 };
 
 #ifdef CONFIG_COMPAT
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index b3bb7ef..e0a5ae2 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -43,6 +43,9 @@ int main(void)
   DEFINE(TSK_TI_TTBR0,		offsetof(struct task_struct, thread_info.ttbr0));
 #endif
   DEFINE(TSK_STACK,		offsetof(struct task_struct, stack));
+#ifdef CONFIG_STACKLEAK
+  DEFINE(TSK_TI_LOWEST_STACK,	offsetof(struct task_struct, thread.lowest_stack));
+#endif
   BLANK();
   DEFINE(THREAD_CPU_CONTEXT,	offsetof(struct task_struct, thread.cpu_context));
   BLANK();
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index b738880..e573633 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -744,6 +744,7 @@ ENDPROC(cpu_switch_to)
  */
 ret_fast_syscall:
 	disable_irq				// disable interrupts
+	bl	erase_kstack
 	str	x0, [sp, #S_X0]			// returned x0
 	ldr	x1, [tsk, #TSK_TI_FLAGS]	// re-check for syscall tracing
 	and	x2, x1, #_TIF_SYSCALL_WORK
@@ -772,6 +773,7 @@ work_pending:
  */
 ret_to_user:
 	disable_irq				// disable interrupts
+	bl	erase_kstack
 	ldr	x1, [tsk, #TSK_TI_FLAGS]
 	and	x2, x1, #_TIF_WORK_MASK
 	cbnz	x2, work_pending
@@ -865,3 +867,93 @@ ENTRY(sys_rt_sigreturn_wrapper)
 	mov	x0, sp
 	b	sys_rt_sigreturn
 ENDPROC(sys_rt_sigreturn_wrapper)
+
+#ifdef CONFIG_STACKLEAK
+ENTRY(erase_kstack)
+	/* save x0 for the fast path */
+	mov	x10, x0
+
+	get_thread_info	x0
+	ldr	x1, [x0, #TSK_TI_LOWEST_STACK]
+
+	/* get the number of bytes to check for lowest stack */
+	mov	x3, x1
+	and	x3, x3, #THREAD_SIZE - 1
+	lsr	x3, x3, #3
+
+	/* now generate the start of the stack */
+	mov	x4, sp
+	movn	x2, #THREAD_SIZE - 1
+	and	x1, x4, x2
+
+	mov	x2, #-0xBEEF	/* stack poison */
+
+	cmp     x3, #0
+	b.eq    4f /* Found nothing, go poison */
+
+1:
+	ldr     x4, [x1, x3, lsl #3]
+	cmp     x4, x2  /* did we find the poison? */
+	b.eq    2f /* yes we did, go check it */
+
+	sub     x3, x3, #1
+	cmp     x3, #0
+	b.eq    4f /* Found nothing, go poison */
+	b       1b /* loop again */
+
+2:
+	cmp     x3, #16
+	b.ls    4f /* Go poison if there are less than 16 things left? */
+
+	mov     x3, #16
+3:
+	ldr     x4, [x1, x3, lsl #3]
+	cmp     x4, x2  /* did we find the poison? */
+	b.ne    1b /* nope we have to check deeper */
+
+	sub     x3, x3, #1
+	cmp     x3, #0
+	b.eq    4f /* Found nothing, go poison */
+	b       3b /* loop again */
+
+	/* The poison function */
+4:
+	/* Generate the address we found */
+	add     x5, x1, x3, lsl #3
+	orr     x5, x5, #16
+
+	mov	x4, sp
+	/* subtrace the current pointer */
+	sub     x8, x4, x5
+
+	/* subtract one more so we don't touch the current sp */
+	sub	x8, x8, #1
+
+	/* sanity check */
+	cmp     x8, #THREAD_SIZE
+	b.lo    5f
+999:
+	b       999b
+
+5:
+	lsr     x8, x8, #3
+	mov     x3, x8
+6:
+	cmp     x3, #0
+	b.eq    7f
+
+	str     x2, [x1, x3, lsl #3]
+	sub     x3, x3, #1
+	b	6b
+
+	/* Reset the lowest stack to the top of the stack */
+7:
+	ldr	x1, [x0, TSK_STACK]
+	add	x1, x1, #THREAD_SIZE
+	sub	x1, x1, #256
+	str	x1, [x0, #TSK_TI_LOWEST_STACK]
+
+	mov	x0, x10
+	ret
+ENDPROC(erase_kstack)
+#endif
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 659ae80..1b6cca2 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -293,6 +293,12 @@ int copy_thread(unsigned long clone_flags, unsigned long stack_start,
 	p->thread.cpu_context.pc = (unsigned long)ret_from_fork;
 	p->thread.cpu_context.sp = (unsigned long)childregs;
 
+#ifdef CONFIG_STACKLEAK
+	p->thread.lowest_stack = (unsigned long)task_stack_page(p) +
+					2 * sizeof(unsigned long);
+#endif
+
+
 	ptrace_hw_copy_thread(p);
 
 	return 0;
@@ -417,3 +423,15 @@ unsigned long arch_randomize_brk(struct mm_struct *mm)
 	else
 		return randomize_page(mm->brk, SZ_1G);
 }
+
+#ifdef CONFIG_STACKLEAK
+void __used check_alloca(unsigned long size)
+{
+	unsigned long sp = (unsigned long)&sp, stack_left;
+
+	/* all kernel stacks are of the same size */
+	stack_left = sp & (THREAD_SIZE - 1);
+	BUG_ON(stack_left < 256 || size >= stack_left - 256);
+}
+EXPORT_SYMBOL(check_alloca);
+#endif
diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index f742596..cb378fa 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -18,7 +18,8 @@ cflags-$(CONFIG_EFI_ARMSTUB)	+= -I$(srctree)/scripts/dtc/libfdt
 
 KBUILD_CFLAGS			:= $(cflags-y) -DDISABLE_BRANCH_PROFILING \
 				   $(call cc-option,-ffreestanding) \
-				   $(call cc-option,-fno-stack-protector)
+				   $(call cc-option,-fno-stack-protector) \
+				   $(DISABLE_STACKLEAK_PLUGIN)
 
 GCOV_PROFILE			:= n
 KASAN_SANITIZE			:= n
diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
index 5c86f64..0eb8dbc 100644
--- a/scripts/Makefile.gcc-plugins
+++ b/scripts/Makefile.gcc-plugins
@@ -35,11 +35,14 @@ ifdef CONFIG_GCC_PLUGINS
 
   gcc-plugin-$(CONFIG_STACKLEAK)	+= stackleak_plugin.so
   gcc-plugin-cflags-$(CONFIG_STACKLEAK)	+= -DSTACKLEAK_PLUGIN -fplugin-arg-stackleak_plugin-track-lowest-sp=100
+  ifdef CONFIG_STACKLEAK
+    DISABLE_STACKLEAK_PLUGIN		+= -fplugin-arg-stackleak_plugin-disable
+  endif
 
   GCC_PLUGINS_CFLAGS := $(strip $(addprefix -fplugin=$(objtree)/scripts/gcc-plugins/, $(gcc-plugin-y)) $(gcc-plugin-cflags-y))
 
   export PLUGINCC GCC_PLUGINS_CFLAGS GCC_PLUGIN GCC_PLUGIN_SUBDIR
-  export SANCOV_PLUGIN DISABLE_LATENT_ENTROPY_PLUGIN
+  export SANCOV_PLUGIN DISABLE_LATENT_ENTROPY_PLUGIN DISABLE_STACKLEAK_PLUGIN
 
   ifneq ($(PLUGINCC),)
     # SANCOV_PLUGIN can be only in CFLAGS_KCOV because avoid duplication.
-- 
2.7.5
