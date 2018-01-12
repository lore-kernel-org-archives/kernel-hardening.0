From: Alexander Popov <alex.popov@linux.com>
Date: Fri, 12 Jan 2018 17:19:24 +0300
Message-Id: <1515766769-9120-2-git-send-email-alex.popov@linux.com>
In-Reply-To: <1515766769-9120-1-git-send-email-alex.popov@linux.com>
References: <1515766769-9120-1-git-send-email-alex.popov@linux.com>
Subject: [kernel-hardening] [PATCH RFC v7 1/6] x86/entry: Add STACKLEAK erasing the kernel stack at the end of syscalls
To: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, x86@kernel.org, alex.popov@linux.com
List-ID: <kernel-hardening.lists.openwall.com>

The STACKLEAK feature erases the kernel stack before returning from
syscalls. That reduces the information which kernel stack leak bugs can
reveal and blocks some uninitialized stack variable attacks. Moreover,
STACKLEAK provides runtime checks for kernel stack overflow detection.

This commit introduces the architecture-specific code filling the used
part of the kernel stack with a poison value before returning to the
userspace. Full STACKLEAK feature also contains the gcc plugin which
comes in a separate commit.

The STACKLEAK feature is ported from grsecurity/PaX. More information at:
  https://grsecurity.net/
  https://pax.grsecurity.net/

This code is modified from Brad Spengler/PaX Team's code in the last
public patch of grsecurity/PaX based on our understanding of the code.
Changes or omissions from the original code are ours and don't reflect
the original grsecurity/PaX code.

Signed-off-by: Alexander Popov <alex.popov@linux.com>
---
 arch/Kconfig                     |  27 ++++++++++
 arch/x86/Kconfig                 |   1 +
 arch/x86/entry/entry_32.S        |  65 +++++++++++++++++++++++
 arch/x86/entry/entry_64.S        | 109 +++++++++++++++++++++++++++++++++++++++
 arch/x86/entry/entry_64_compat.S |  11 ++++
 arch/x86/include/asm/processor.h |   4 ++
 arch/x86/kernel/asm-offsets.c    |   8 +++
 arch/x86/kernel/process_32.c     |   5 ++
 arch/x86/kernel/process_64.c     |   5 ++
 include/linux/compiler.h         |   6 +++
 10 files changed, 241 insertions(+)

diff --git a/arch/Kconfig b/arch/Kconfig
index 400b9e1..721fdae 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -387,6 +387,13 @@ config SECCOMP_FILTER
 
 	  See Documentation/prctl/seccomp_filter.txt for details.
 
+config HAVE_ARCH_STACKLEAK
+	bool
+	help
+	  An architecture should select this if it has the code which
+	  fills the used part of the kernel stack with the STACKLEAK_POISON
+	  value before returning from system calls.
+
 config HAVE_GCC_PLUGINS
 	bool
 	help
@@ -517,6 +524,26 @@ config GCC_PLUGIN_RANDSTRUCT_PERFORMANCE
 	  in structures.  This reduces the performance hit of RANDSTRUCT
 	  at the cost of weakened randomization.
 
+config GCC_PLUGIN_STACKLEAK
+	bool "Erase the kernel stack before returning from syscalls"
+	depends on GCC_PLUGINS
+	depends on HAVE_ARCH_STACKLEAK
+	help
+	  This option makes the kernel erase the kernel stack before it
+	  returns from a system call. That reduces the information which
+	  kernel stack leak bugs can reveal and blocks some uninitialized
+	  stack variable attacks. This option also provides runtime checks
+	  for kernel stack overflow detection.
+
+	  The tradeoff is the performance impact: on a single CPU system kernel
+	  compilation sees a 1% slowdown, other systems and workloads may vary
+	  and you are advised to test this feature on your expected workload
+	  before deploying it.
+
+	  This plugin was ported from grsecurity/PaX. More information at:
+	   * https://grsecurity.net/
+	   * https://pax.grsecurity.net/
+
 config HAVE_CC_STACKPROTECTOR
 	bool
 	help
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d4fc98c..4981cb6 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -116,6 +116,7 @@ config X86
 	select HAVE_ARCH_MMAP_RND_COMPAT_BITS	if MMU && COMPAT
 	select HAVE_ARCH_COMPAT_MMAP_BASES	if MMU && COMPAT
 	select HAVE_ARCH_SECCOMP_FILTER
+	select HAVE_ARCH_STACKLEAK
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD if X86_64
diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index ace8f32..f400d8f 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -76,6 +76,66 @@
 #endif
 .endm
 
+.macro erase_kstack
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+	call erase_kstack
+#endif
+.endm
+
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+/* For the detailed comments, see erase_kstack in entry_64.S */
+ENTRY(erase_kstack)
+	pushl	%edi
+	pushl	%ecx
+	pushl	%eax
+	pushl	%ebp
+
+	movl	PER_CPU_VAR(current_task), %ebp
+	mov	TASK_lowest_stack(%ebp), %edi
+	mov	$STACKLEAK_POISON, %eax
+	std
+
+1:
+	mov	%edi, %ecx
+	and	$THREAD_SIZE_asm - 1, %ecx
+	shr	$2, %ecx
+	repne	scasl
+	jecxz	2f
+
+	cmp	$STACKLEAK_POISON_CHECK_DEPTH / 4, %ecx
+	jc	2f
+
+	mov	$STACKLEAK_POISON_CHECK_DEPTH / 4, %ecx
+	repe	scasl
+	jecxz	2f
+	jne	1b
+
+2:
+	cld
+	or	$2 * 4, %edi
+	mov	%esp, %ecx
+	sub	%edi, %ecx
+
+	cmp	$THREAD_SIZE_asm, %ecx
+	jb	3f
+	ud2
+
+3:
+	shr	$2, %ecx
+	rep	stosl
+
+	movl	PER_CPU_VAR(cpu_current_top_of_stack), %edi
+	sub	$128, %edi
+	mov	%edi, TASK_lowest_stack(%ebp)
+
+	popl	%ebp
+	popl	%eax
+	popl	%ecx
+	popl	%edi
+	ret
+ENDPROC(erase_kstack)
+#endif
+
 /*
  * User gs save/restore
  *
@@ -286,6 +346,7 @@ ENTRY(ret_from_fork)
 	/* When we fork, we trace the syscall return in the child, too. */
 	movl    %esp, %eax
 	call    syscall_return_slowpath
+	erase_kstack
 	jmp     restore_all
 
 	/* kernel thread */
@@ -446,6 +507,8 @@ ENTRY(entry_SYSENTER_32)
 	ALTERNATIVE "testl %eax, %eax; jz .Lsyscall_32_done", \
 		    "jmp .Lsyscall_32_done", X86_FEATURE_XENPV
 
+	erase_kstack
+
 /* Opportunistic SYSEXIT */
 	TRACE_IRQS_ON			/* User mode traces as IRQs on. */
 	movl	PT_EIP(%esp), %edx	/* pt_regs->ip */
@@ -532,6 +595,8 @@ ENTRY(entry_INT80_32)
 	call	do_int80_syscall_32
 .Lsyscall_32_done:
 
+	erase_kstack
+
 restore_all:
 	TRACE_IRQS_IRET
 .Lrestore_all_notrace:
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index f048e38..3ff0802 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -65,6 +65,112 @@ END(native_usergs_sysret64)
 	TRACE_IRQS_FLAGS EFLAGS(%rsp)
 .endm
 
+.macro erase_kstack
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+	call erase_kstack
+#endif
+.endm
+
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+ENTRY(erase_kstack)
+	pushq	%rdi
+	pushq	%rcx
+	pushq	%rax
+	pushq	%r11
+
+	mov	PER_CPU_VAR(current_task), %r11
+	mov	TASK_lowest_stack(%r11), %rdi
+	mov	$STACKLEAK_POISON, %rax
+	std
+
+	/*
+	 * Let's search for the poison value in the stack.
+	 * Start from the lowest_stack and go to the bottom (see std above).
+	 */
+1:
+	mov	%edi, %ecx
+	and	$THREAD_SIZE_asm - 1, %ecx
+	shr	$3, %ecx
+	repne	scasq
+	jecxz	2f	/* Didn't find it. Go to poisoning. */
+
+	/*
+	 * Found the poison value in the stack. Go to poisoning if there is
+	 * not enough space left for the poison check.
+	 */
+	cmp	$STACKLEAK_POISON_CHECK_DEPTH / 8, %ecx
+	jb	2f
+
+	/*
+	 * Check that some further qwords contain poison. If so, the part
+	 * of the stack below the address in %rdi is likely to be poisoned.
+	 * Otherwise we need to search deeper.
+	 */
+	mov	$STACKLEAK_POISON_CHECK_DEPTH / 8, %ecx
+	repe	scasq
+	jecxz	2f	/* Poison the upper part of the stack */
+	jne	1b	/* Search deeper */
+
+2:
+	/*
+	 * Two qwords at the bottom of the thread stack are reserved and
+	 * should not be poisoned (see CONFIG_SCHED_STACK_END_CHECK).
+	 */
+	or	$2 * 8, %rdi
+
+	/*
+	 * Check whether we are on the thread stack to prepare the counter
+	 * for stack poisoning.
+	 */
+	mov	PER_CPU_VAR(cpu_current_top_of_stack), %rcx
+	sub	%rsp, %rcx
+	cmp	$THREAD_SIZE_asm, %rcx
+	jb	3f
+
+	/*
+	 * We are not on the thread stack, so we can write poison between
+	 * the address in %rdi and the stack top.
+	 */
+	mov	PER_CPU_VAR(cpu_current_top_of_stack), %rcx
+	sub	%rdi, %rcx
+	jmp	4f
+
+3:
+	/*
+	 * We are on the thread stack, so we can write poison between the
+	 * address in %rdi and the address in %rsp (not included, used memory).
+	 */
+	mov	%rsp, %rcx
+	sub	%rdi, %rcx
+
+4:
+	/* Check that the counter value is sane */
+	cmp	$THREAD_SIZE_asm, %rcx
+	jb	5f
+	ud2
+
+5:
+	/*
+	 * So let's write the poison value to the kernel stack. Start from the
+	 * address in %rdi and move up (see cld).
+	 */
+	cld
+	shr	$3, %ecx
+	rep	stosq
+
+	/* Set the lowest_stack value to the top_of_stack - 256 */
+	mov	PER_CPU_VAR(cpu_current_top_of_stack), %rdi
+	sub	$256, %rdi
+	mov	%rdi, TASK_lowest_stack(%r11)
+
+	popq	%r11
+	popq	%rax
+	popq	%rcx
+	popq	%rdi
+	ret
+ENDPROC(erase_kstack)
+#endif
+
 /*
  * When dynamic function tracer is enabled it will add a breakpoint
  * to all locations that it is about to modify, sync CPUs, update
@@ -411,6 +517,8 @@ syscall_return_via_sysret:
 	 * We are on the trampoline stack.  All regs except RDI are live.
 	 * We can do future final exit work right here.
 	 */
+	erase_kstack
+
 	SWITCH_TO_USER_CR3_STACK scratch_reg=%rdi
 
 	popq	%rdi
@@ -748,6 +856,7 @@ GLOBAL(swapgs_restore_regs_and_return_to_usermode)
 	 * We are on the trampoline stack.  All regs except RDI are live.
 	 * We can do future final exit work right here.
 	 */
+	erase_kstack
 
 	SWITCH_TO_USER_CR3_STACK scratch_reg=%rdi
 
diff --git a/arch/x86/entry/entry_64_compat.S b/arch/x86/entry/entry_64_compat.S
index 98d5358..727dde2 100644
--- a/arch/x86/entry/entry_64_compat.S
+++ b/arch/x86/entry/entry_64_compat.S
@@ -19,6 +19,12 @@
 
 	.section .entry.text, "ax"
 
+	.macro erase_kstack
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+	call erase_kstack
+#endif
+	.endm
+
 /*
  * 32-bit SYSENTER entry.
  *
@@ -238,6 +244,11 @@ GLOBAL(entry_SYSCALL_compat_after_hwframe)
 
 	/* Opportunistic SYSRET */
 sysret32_from_system_call:
+	/*
+	 * We are not going to return to the userspace from the trampoline
+	 * stack. So let's erase the thread stack right now.
+	 */
+	erase_kstack
 	TRACE_IRQS_ON			/* User mode traces as IRQs on. */
 	movq	RBX(%rsp), %rbx		/* pt_regs->rbx */
 	movq	RBP(%rsp), %rbp		/* pt_regs->rbp */
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index d3a67fb..9736829 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -496,6 +496,10 @@ struct thread_struct {
 
 	mm_segment_t		addr_limit;
 
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+	unsigned long		lowest_stack;
+#endif
+
 	unsigned int		sig_on_uaccess_err:1;
 	unsigned int		uaccess_err:1;	/* uaccess failed */
 
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index 76417a9..ef5d260 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -39,6 +39,9 @@ void common(void) {
 	BLANK();
 	OFFSET(TASK_TI_flags, task_struct, thread_info.flags);
 	OFFSET(TASK_addr_limit, task_struct, thread.addr_limit);
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+	OFFSET(TASK_lowest_stack, task_struct, thread.lowest_stack);
+#endif
 
 	BLANK();
 	OFFSET(crypto_tfm_ctx_offset, crypto_tfm, __crt_ctx);
@@ -75,6 +78,11 @@ void common(void) {
 	OFFSET(PV_MMU_read_cr2, pv_mmu_ops, read_cr2);
 #endif
 
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+	BLANK();
+	DEFINE(THREAD_SIZE_asm, THREAD_SIZE);
+#endif
+
 #ifdef CONFIG_XEN
 	BLANK();
 	OFFSET(XEN_vcpu_info_mask, vcpu_info, evtchn_upcall_mask);
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 5224c60..6d256ab 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -136,6 +136,11 @@ int copy_thread_tls(unsigned long clone_flags, unsigned long sp,
 	p->thread.sp0 = (unsigned long) (childregs+1);
 	memset(p->thread.ptrace_bps, 0, sizeof(p->thread.ptrace_bps));
 
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+	p->thread.lowest_stack = (unsigned long)task_stack_page(p) +
+						2 * sizeof(unsigned long);
+#endif
+
 	if (unlikely(p->flags & PF_KTHREAD)) {
 		/* kernel thread */
 		memset(childregs, 0, sizeof(struct pt_regs));
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index c754662..4345fdf 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -281,6 +281,11 @@ int copy_thread_tls(unsigned long clone_flags, unsigned long sp,
 	p->thread.sp = (unsigned long) fork_frame;
 	p->thread.io_bitmap_ptr = NULL;
 
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+	p->thread.lowest_stack = (unsigned long)task_stack_page(p) +
+						2 * sizeof(unsigned long);
+#endif
+
 	savesegment(gs, p->thread.gsindex);
 	p->thread.gsbase = p->thread.gsindex ? 0 : me->thread.gsbase;
 	savesegment(fs, p->thread.fsindex);
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 52e611a..001c3e2 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -327,4 +327,10 @@ static __always_inline void __write_once_size(volatile void *p, void *res, int s
 	compiletime_assert(__native_word(t),				\
 		"Need native word sized stores/loads for atomicity.")
 
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+/* Poison value points to the unused hole in the virtual memory map */
+# define STACKLEAK_POISON -0xBEEF
+# define STACKLEAK_POISON_CHECK_DEPTH 128
+#endif
+
 #endif /* __LINUX_COMPILER_H */
-- 
2.7.4
