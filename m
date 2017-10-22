From: Alexander Popov <alex.popov@linux.com>
Date: Sun, 22 Oct 2017 03:22:49 +0300
Message-Id: <1508631773-2502-2-git-send-email-alex.popov@linux.com>
In-Reply-To: <1508631773-2502-1-git-send-email-alex.popov@linux.com>
References: <1508631773-2502-1-git-send-email-alex.popov@linux.com>
Subject: [kernel-hardening] [PATCH RFC v5 1/5] x86/entry: Add STACKLEAK erasing the kernel stack at the end of syscalls
To: kernel-hardening@lists.openwall.com, keescook@chromium.org, pageexec@freemail.hu, spender@grsecurity.net, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, tycho@docker.com, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, x86@kernel.org, alex.popov@linux.com
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
 arch/Kconfig                     | 27 ++++++++++++
 arch/x86/Kconfig                 |  1 +
 arch/x86/entry/common.c          | 17 +++++--
 arch/x86/entry/entry_32.S        | 69 +++++++++++++++++++++++++++++
 arch/x86/entry/entry_64.S        | 95 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/entry/entry_64_compat.S |  8 ++++
 arch/x86/include/asm/processor.h |  4 ++
 arch/x86/kernel/asm-offsets.c    |  9 ++++
 arch/x86/kernel/process_32.c     |  5 +++
 arch/x86/kernel/process_64.c     |  5 +++
 include/linux/compiler.h         |  4 ++
 11 files changed, 241 insertions(+), 3 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index d789a89..e9ec94c 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -386,6 +386,13 @@ config SECCOMP_FILTER
 
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
@@ -516,6 +523,26 @@ config GCC_PLUGIN_RANDSTRUCT_PERFORMANCE
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
index 971feac..b7da58f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -114,6 +114,7 @@ config X86
 	select HAVE_ARCH_MMAP_RND_COMPAT_BITS	if MMU && COMPAT
 	select HAVE_ARCH_COMPAT_MMAP_BASES	if MMU && COMPAT
 	select HAVE_ARCH_SECCOMP_FILTER
+	select HAVE_ARCH_STACKLEAK
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD if X86_64
diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index 03505ff..075487e 100644
--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -45,6 +45,12 @@ __visible inline void enter_from_user_mode(void)
 static inline void enter_from_user_mode(void) {}
 #endif
 
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+asmlinkage void erase_kstack(void);
+#else
+static void erase_kstack(void) {}
+#endif
+
 static void do_audit_syscall_entry(struct pt_regs *regs, u32 arch)
 {
 #ifdef CONFIG_X86_64
@@ -81,8 +87,10 @@ static long syscall_trace_enter(struct pt_regs *regs)
 		emulated = true;
 
 	if ((emulated || (work & _TIF_SYSCALL_TRACE)) &&
-	    tracehook_report_syscall_entry(regs))
+	    tracehook_report_syscall_entry(regs)) {
+		erase_kstack();
 		return -1L;
+	}
 
 	if (emulated)
 		return -1L;
@@ -116,9 +124,11 @@ static long syscall_trace_enter(struct pt_regs *regs)
 			sd.args[5] = regs->bp;
 		}
 
-		ret = __secure_computing(&sd);
-		if (ret == -1)
+		ret = secure_computing(&sd);
+		if (ret == -1) {
+			erase_kstack();
 			return ret;
+		}
 	}
 #endif
 
@@ -127,6 +137,7 @@ static long syscall_trace_enter(struct pt_regs *regs)
 
 	do_audit_syscall_entry(regs, arch);
 
+	erase_kstack();
 	return ret ?: regs->orig_ax;
 }
 
diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index 50e0d2b..a7b0c52 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -75,6 +75,71 @@
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
+	cmp	$2*16, %ecx
+	jc	2f
+
+	mov	$2*16, %ecx
+	repe	scasl
+	jecxz	2f
+	jne	1b
+
+2:
+	cld
+	or	$2*4, %edi
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
+	/*
+	 * TODO: sp0 on x86_32 is not reliable, right?
+	 * Doubt because of the definition of cpu_current_top_of_stack
+	 * in arch/x86/kernel/cpu/common.c.
+	 */
+	mov	TASK_thread_sp0(%ebp), %edi
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
@@ -445,6 +510,8 @@ ENTRY(entry_SYSENTER_32)
 	ALTERNATIVE "testl %eax, %eax; jz .Lsyscall_32_done", \
 		    "jmp .Lsyscall_32_done", X86_FEATURE_XENPV
 
+	erase_kstack
+
 /* Opportunistic SYSEXIT */
 	TRACE_IRQS_ON			/* User mode traces as IRQs on. */
 	movl	PT_EIP(%esp), %edx	/* pt_regs->ip */
@@ -531,6 +598,8 @@ ENTRY(entry_INT80_32)
 	call	do_int80_syscall_32
 .Lsyscall_32_done:
 
+	erase_kstack
+
 restore_all:
 	TRACE_IRQS_IRET
 .Lrestore_all_notrace:
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 4916725..189d843 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -59,6 +59,90 @@ END(native_usergs_sysret64)
 #endif
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
+	movq	PER_CPU_VAR(current_task), %r11
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
+	 * Found the poison value in the stack. Go to poisoning if there are
+	 * less than 16 qwords left.
+	 */
+	cmp	$2*8, %ecx
+	jc	2f
+
+	/*
+	 * Check that 16 further qwords contain poison (avoid false positives).
+	 * If so, the part of the stack below the address in %rdi is likely
+	 * to be poisoned. Otherwise we need to search deeper.
+	 */
+	mov	$2*8, %ecx
+	repe	scasq
+	jecxz	2f	/* Poison the upper part of the stack. */
+	jne	1b	/* Search deeper. */
+
+2:
+	/*
+	 * Prepare the counter for poisoning the kernel stack between
+	 * %rdi and %rsp. Two qwords at the bottom of the stack are reserved
+	 * and should not be poisoned (see CONFIG_SCHED_STACK_END_CHECK).
+	 */
+	cld
+	or	$2*8, %rdi
+	mov	%esp, %ecx
+	sub	%edi, %ecx
+
+	/* Check that the counter value is sane. */
+	cmp	$THREAD_SIZE_asm, %rcx
+	jb	3f
+	ud2
+
+3:
+	/*
+	 * So let's write the poison value to the kernel stack. Start from the
+	 * address in %rdi and move up (see cld above) to the address in %rsp
+	 * (not included, used memory).
+	 */
+	shr	$3, %ecx
+	rep	stosq
+
+	/* Set the lowest_stack value to the top_of_stack - 256. */
+	mov	TASK_thread_sp0(%r11), %rdi
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
@@ -216,6 +300,8 @@ entry_SYSCALL_64_fastpath:
 	testl	$_TIF_ALLWORK_MASK, TASK_TI_flags(%r11)
 	jnz	1f
 
+	erase_kstack
+
 	LOCKDEP_SYS_EXIT
 	TRACE_IRQS_ON		/* user mode is traced as IRQs on */
 	movq	RIP(%rsp), %rcx
@@ -245,6 +331,8 @@ entry_SYSCALL64_slow_path:
 	call	do_syscall_64		/* returns with IRQs disabled */
 
 return_from_SYSCALL_64:
+	erase_kstack
+
 	RESTORE_EXTRA_REGS
 	TRACE_IRQS_IRETQ		/* we're about to change IF */
 
@@ -421,6 +509,7 @@ ENTRY(ret_from_fork)
 	UNWIND_HINT_REGS
 	movq	%rsp, %rdi
 	call	syscall_return_slowpath	/* returns with IRQs disabled */
+	erase_kstack
 	TRACE_IRQS_ON			/* user mode is traced as IRQS on */
 	SWAPGS
 	jmp	restore_regs_and_iret
@@ -610,6 +699,12 @@ ret_from_intr:
 GLOBAL(retint_user)
 	mov	%rsp,%rdi
 	call	prepare_exit_to_usermode
+
+	/*
+	 * TODO: Do we need to call erase_kstack here?
+	 * The PaX patch has it here commented out.
+	 */
+
 	TRACE_IRQS_IRETQ
 	SWAPGS
 	jmp	restore_regs_and_iret
diff --git a/arch/x86/entry/entry_64_compat.S b/arch/x86/entry/entry_64_compat.S
index e26c25c..f79cbf4 100644
--- a/arch/x86/entry/entry_64_compat.S
+++ b/arch/x86/entry/entry_64_compat.S
@@ -18,6 +18,12 @@
 
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
@@ -228,6 +234,7 @@ GLOBAL(entry_SYSCALL_compat_after_hwframe)
 
 	/* Opportunistic SYSRET */
 sysret32_from_system_call:
+	erase_kstack
 	TRACE_IRQS_ON			/* User mode traces as IRQs on. */
 	movq	RBX(%rsp), %rbx		/* pt_regs->rbx */
 	movq	RBP(%rsp), %rbp		/* pt_regs->rbp */
@@ -335,6 +342,7 @@ ENTRY(entry_INT80_compat)
 .Lsyscall_32_done:
 
 	/* Go back to user mode. */
+	erase_kstack
 	TRACE_IRQS_ON
 	SWAPGS
 	jmp	restore_regs_and_iret
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index b390ff7..c6eaf2d 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -477,6 +477,10 @@ struct thread_struct {
 
 	mm_segment_t		addr_limit;
 
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+	unsigned long		lowest_stack;
+#endif
+
 	unsigned int		sig_on_uaccess_err:1;
 	unsigned int		uaccess_err:1;	/* uaccess failed */
 
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index de827d6..4ed7451 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -37,6 +37,10 @@ void common(void) {
 	BLANK();
 	OFFSET(TASK_TI_flags, task_struct, thread_info.flags);
 	OFFSET(TASK_addr_limit, task_struct, thread.addr_limit);
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+	OFFSET(TASK_lowest_stack, task_struct, thread.lowest_stack);
+	OFFSET(TASK_thread_sp0, task_struct, thread.sp0);
+#endif
 
 	BLANK();
 	OFFSET(crypto_tfm_ctx_offset, crypto_tfm, __crt_ctx);
@@ -73,6 +77,11 @@ void common(void) {
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
index 1196625..c7345d2 100644
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
index 302e7b2..65ba73f 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -283,6 +283,11 @@ int copy_thread_tls(unsigned long clone_flags, unsigned long sp,
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
index e95a263..916f02d 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -624,4 +624,8 @@ static __always_inline void __write_once_size(volatile void *p, void *res, int s
 	(_________p1); \
 })
 
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+# define STACKLEAK_POISON -0xBEEF
+#endif
+
 #endif /* __LINUX_COMPILER_H */
-- 
2.7.4
