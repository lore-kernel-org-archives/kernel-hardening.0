From: Alexander Popov <alex.popov@linux.com>
Date: Fri,  9 Jun 2017 17:30:08 +0300
Message-Id: <1497018608-22168-1-git-send-email-alex.popov@linux.com>
Subject: [kernel-hardening] [PATCH RFC v2 1/1] gcc-plugins: Add stackleak feature erasing the kernel stack at the end of syscalls
To: kernel-hardening@lists.openwall.com, keescook@chromium.org, pageexec@freemail.hu, spender@grsecurity.net, tycho@docker.com, alex.popov@linux.com
List-ID: <kernel-hardening.lists.openwall.com>

Hello,

My employer Positive Technologies kindly allowed me to spend a part of my
working time on helping KSPP. So I join the initiative of porting STACKLEAK
to the mainline, which was started by Tycho Andersen.

STACKLEAK is a security feature developed by Grsecurity/PaX (kudos to them!),
which can mitigate the damage from kernel stack leak bugs (see CVE-2010-2963,
CVE-2016-4569 and CVE-2016-4578).

I carefully extracted STACKLEAK from the last public patch of Grsecurity/PaX
and do my best to understand it. So I added some comments describing that
understanding. You are welcome to discuss it.

Here are the results of a brief performance test on x86_64:

Hardware: Intel Core i7-4770, 16 GB RAM

Test #1: stress-ng --cpu 4 --io 2 --vm 2 --vm-bytes 2G --timeout 300s
 --metrics-brief
Result on 4.11-rc8:
  cpu bogo ops 269955
  iosync bogo ops 9809985
  vm bogo ops 17093608
Result on 4.11-rc8+stackleak:
  cpu bogo ops 270106 (+0.6%)
  iosync bogo ops 9474535 (-3.42%)
  vm bogo ops 17093608 (the same)

Test #2: hackbench -s 4096 -l 2000 -g 15 -f 25 -P
Average result on 4.11-rc8: 8.71s
Average result on 4.11-rc8+stackleak: 9.08s (+4.29%)

Test #3: building the Linux kernel with Ubuntu config (time make -j9)
Result on 4.11-rc8:
  real	32m14.893s
  user	237m30.886s
  sys	11m12.273s
Result on 4.11-rc8+stackleak:
  real	32m26.881s (+0.62%)
  user	238m38.926s (+0.48%)
  sys	11m36.426s (+3.59%)

There is an important aspect of STACKLEAK on i386. PaX Team might know
about it, I can't say for sure. Dear Grsecurity, is it fine to talk with
you about such things in that mailing list? Should I do it differently?

The STACKLEAK gcc plugin does not instrument the kernel code for i386. I've
checked that for the last public patch of Grsecurity/PaX and see the same
behaviour on my machines. The reason: the ix86_cmodel for the Linux kernel
on i386 is not CM_KERNEL. So the STACKLEAK plugin seems to skip the
instrumentation for that platform. As a result, on i386 erase_kstack()
always starts to search for the bottom of the stack from the top minus 128.

See the results of the same performance tests on i386:

Test #1: stress-ng --cpu 4 --io 2 --vm 2 --vm-bytes 2G --timeout 300s
 --metrics-brief
Result on 4.11-rc8:
  cpu bogo ops 207754
  iosync bogo ops 9442815
  vm bogo ops 8546804
Result on 4.11-rc8+stackleak:
  cpu bogo ops 206061 (-0.81%)
  iosync bogo ops 9435139 (-0.08%)
  vm bogo ops 8546804 (the same)

Test #2: hackbench -s 4096 -l 2000 -g 15 -f 25 -P
Average result on 4.11-rc8: 8.197s
Average result on 4.11-rc8+stackleak: 9.134s (+11.43%)

Test #3: building the Linux kernel with Ubuntu config (time make -j9)
Result on 4.11-rc8:
  real	18m15.372s
  user	129m58.169s
  sys	8m27.884s
Result on 4.11-rc8+stackleak:
  real	18m34.244s (+1.72%)
  user	132m33.843s (+2.00%)
  sys	8m37.658s (+1.92%)

More things to be done:
 - understand how the STACKLEAK gcc plugin works;
 - develop tests for STACKLEAK.

Best regards,
Alexander

-- >8 --

>From d22af45233b2f6d657a29dcb1815b35a5a45c539 Mon Sep 17 00:00:00 2001
From: Alexander Popov <alex.popov@linux.com>
Date: Fri, 9 Jun 2017 15:21:16 +0300
Subject: [PATCH RFC v2 1/1] gcc-plugins: Add stackleak feature erasing the
 kernel stack at the end of syscalls

The stackleak feature erases the kernel stack before returning from syscalls.
That reduces the information which a kernel stack leak bug can reveal.

This feature consists of:
  - the architecture-specific code filling the used part of the kernel stack
  with a poison value before returning to the userspace (currently only
  for i386 and x86_64);
  - the gcc plugin for tracking the lowest border of the kernel stack. It
  instruments the kernel code inserting the track_stack() function call if
  a stack frame size is over a specified limit.

The stackleak feature is ported from grsecurity/PaX. For more information see:
  https://grsecurity.net/
  https://pax.grsecurity.net/

This code is verbatim from Brad Spengler/PaX Team's code in the last public
patch of grsecurity/PaX based on our understanding of the code. Changes or
omissions from the original code are ours and don't reflect the original
grsecurity/PaX code.

Signed-off-by: Alexander Popov <alex.popov@linux.com>
Signed-off-by: Tycho Andersen <tycho@docker.com>
---
 arch/Kconfig                           |  20 ++
 arch/x86/Kconfig                       |   1 +
 arch/x86/entry/common.c                |  17 +-
 arch/x86/entry/entry_32.S              |  71 +++++++
 arch/x86/entry/entry_64.S              |  99 ++++++++++
 arch/x86/entry/entry_64_compat.S       |   8 +
 arch/x86/include/asm/processor.h       |   4 +
 arch/x86/kernel/asm-offsets.c          |   9 +
 arch/x86/kernel/dumpstack_32.c         |  12 ++
 arch/x86/kernel/dumpstack_64.c         |  33 ++++
 arch/x86/kernel/process_32.c           |   5 +
 arch/x86/kernel/process_64.c           |   5 +
 fs/exec.c                              |  17 ++
 scripts/Makefile.gcc-plugins           |   3 +
 scripts/gcc-plugins/stackleak_plugin.c | 342 +++++++++++++++++++++++++++++++++
 15 files changed, 643 insertions(+), 3 deletions(-)
 create mode 100644 scripts/gcc-plugins/stackleak_plugin.c

diff --git a/arch/Kconfig b/arch/Kconfig
index cd211a1..a209bd5 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -436,6 +436,26 @@ config GCC_PLUGIN_STRUCTLEAK_VERBOSE
 	  initialized. Since not all existing initializers are detected
 	  by the plugin, this can produce false positive warnings.
 
+config ARCH_HAS_STACKLEAK
+	def_bool n
+	help
+	  An architecture should select this if it has the code which
+	  fills the used part of the kernel stack with a poison value
+	  before returning from system calls.
+
+config STACKLEAK
+	bool "Erase the kernel stack before returning from syscalls"
+	depends on GCC_PLUGINS
+	depends on ARCH_HAS_STACKLEAK
+	help
+	  This option makes the kernel erase the kernel stack before it
+	  returns from a system call. That reduces the information which
+	  a kernel stack leak bug can reveal.
+
+	  This plugin was ported from grsecurity/PaX. More information at:
+	   * https://grsecurity.net/
+	   * https://pax.grsecurity.net/
+
 config HAVE_CC_STACKPROTECTOR
 	bool
 	help
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cc98d5a..5988a5f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -56,6 +56,7 @@ config X86
 	select ARCH_HAS_PMEM_API		if X86_64
 	select ARCH_HAS_SET_MEMORY
 	select ARCH_HAS_SG_CHAIN
+	select ARCH_HAS_STACKLEAK
 	select ARCH_HAS_STRICT_KERNEL_RWX
 	select ARCH_HAS_STRICT_MODULE_RWX
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index 370c42c..8ff0a84 100644
--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -43,6 +43,12 @@ __visible inline void enter_from_user_mode(void)
 static inline void enter_from_user_mode(void) {}
 #endif
 
+#ifdef CONFIG_STACKLEAK
+asmlinkage void erase_kstack(void);
+#else
+static void erase_kstack(void) {}
+#endif
+
 static void do_audit_syscall_entry(struct pt_regs *regs, u32 arch)
 {
 #ifdef CONFIG_X86_64
@@ -79,8 +85,10 @@ static long syscall_trace_enter(struct pt_regs *regs)
 		emulated = true;
 
 	if ((emulated || (work & _TIF_SYSCALL_TRACE)) &&
-	    tracehook_report_syscall_entry(regs))
+	    tracehook_report_syscall_entry(regs)) {
+		erase_kstack();
 		return -1L;
+	}
 
 	if (emulated)
 		return -1L;
@@ -114,9 +122,11 @@ static long syscall_trace_enter(struct pt_regs *regs)
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
 
@@ -125,6 +135,7 @@ static long syscall_trace_enter(struct pt_regs *regs)
 
 	do_audit_syscall_entry(regs, arch);
 
+	erase_kstack();
 	return ret ?: regs->orig_ax;
 }
 
diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index 57f7ec3..d8610e9 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -78,6 +78,73 @@
 #endif
 .endm
 
+.macro erase_kstack
+#ifdef CONFIG_STACKLEAK
+	call erase_kstack
+#endif
+.endm
+
+#ifdef CONFIG_STACKLEAK
+/*
+ * ebp: thread_info
+ */
+ENTRY(erase_kstack)
+	pushl	%edi
+	pushl	%ecx
+	pushl	%eax
+	pushl	%ebp
+
+	movl	PER_CPU_VAR(current_task), %ebp
+	mov	TASK_lowest_stack(%ebp), %edi
+	mov	$-0xBEEF, %eax
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
@@ -440,6 +507,8 @@ ENTRY(entry_SYSENTER_32)
 	ALTERNATIVE "testl %eax, %eax; jz .Lsyscall_32_done", \
 		    "jmp .Lsyscall_32_done", X86_FEATURE_XENPV
 
+	erase_kstack
+
 /* Opportunistic SYSEXIT */
 	TRACE_IRQS_ON			/* User mode traces as IRQs on. */
 	movl	PT_EIP(%esp), %edx	/* pt_regs->ip */
@@ -526,6 +595,8 @@ ENTRY(entry_INT80_32)
 	call	do_int80_syscall_32
 .Lsyscall_32_done:
 
+	erase_kstack
+
 restore_all:
 	TRACE_IRQS_IRET
 .Lrestore_all_notrace:
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 044d18e..84829d4 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -58,6 +58,94 @@ ENDPROC(native_usergs_sysret64)
 #endif
 .endm
 
+.macro erase_kstack
+#ifdef CONFIG_STACKLEAK
+	call erase_kstack
+#endif
+.endm
+
+#ifdef CONFIG_STACKLEAK
+ENTRY(erase_kstack)
+	pushq	%rdi
+	pushq	%rcx
+	pushq	%rax
+	pushq	%r11
+
+	movq	PER_CPU_VAR(current_task), %r11
+	mov	TASK_lowest_stack(%r11), %rdi
+	mov	$-0xBEEF, %rax		/* -0xBEEF is a stack poison. */
+	std
+
+1:
+	/*
+	 * Let's search for the poison value in the stack.
+	 * Start from the lowest_stack and go to the bottom (see std above).
+	 */
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
+	 * %rdi and %rsp.
+	 *
+	 * TODO: Sorry, don't understand why the following OR instruction is
+	 * needed. That may be connected to the thread.lowest_stack
+	 * initialization in arch/x86/kernel/process_64.c, where it is set
+	 * to the task_stack_page address + 2 * sizeof(unsigned long).
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
@@ -218,6 +306,8 @@ entry_SYSCALL_64_fastpath:
 	testl	$_TIF_ALLWORK_MASK, TASK_TI_flags(%r11)
 	jnz	1f
 
+	erase_kstack
+
 	LOCKDEP_SYS_EXIT
 	TRACE_IRQS_ON		/* user mode is traced as IRQs on */
 	movq	RIP(%rsp), %rcx
@@ -246,6 +336,8 @@ entry_SYSCALL64_slow_path:
 	call	do_syscall_64		/* returns with IRQs disabled */
 
 return_from_SYSCALL_64:
+	erase_kstack
+
 	RESTORE_EXTRA_REGS
 	TRACE_IRQS_IRETQ		/* we're about to change IF */
 
@@ -419,6 +511,7 @@ ENTRY(ret_from_fork)
 2:
 	leaq	FRAME_OFFSET(%rsp),%rdi	/* pt_regs pointer */
 	call	syscall_return_slowpath	/* returns with IRQs disabled */
+	erase_kstack
 	TRACE_IRQS_ON			/* user mode is traced as IRQS on */
 	SWAPGS
 	FRAME_END
@@ -532,6 +625,12 @@ ret_from_intr:
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
index e1721da..330516a 100644
--- a/arch/x86/entry/entry_64_compat.S
+++ b/arch/x86/entry/entry_64_compat.S
@@ -18,6 +18,12 @@
 
 	.section .entry.text, "ax"
 
+	.macro erase_kstack
+#ifdef CONFIG_STACKLEAK
+	call erase_kstack
+#endif
+	.endm
+
 /*
  * 32-bit SYSENTER entry.
  *
@@ -229,6 +235,7 @@ ENTRY(entry_SYSCALL_compat)
 
 	/* Opportunistic SYSRET */
 sysret32_from_system_call:
+	erase_kstack
 	TRACE_IRQS_ON			/* User mode traces as IRQs on. */
 	movq	RBX(%rsp), %rbx		/* pt_regs->rbx */
 	movq	RBP(%rsp), %rbp		/* pt_regs->rbp */
@@ -337,6 +344,7 @@ ENTRY(entry_INT80_compat)
 .Lsyscall_32_done:
 
 	/* Go back to user mode. */
+	erase_kstack
 	TRACE_IRQS_ON
 	SWAPGS
 	jmp	restore_regs_and_iret
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index f385eca..049abff 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -469,6 +469,10 @@ struct thread_struct {
 
 	mm_segment_t		addr_limit;
 
+#ifdef CONFIG_STACKLEAK
+	unsigned long		lowest_stack;
+#endif
+
 	unsigned int		sig_on_uaccess_err:1;
 	unsigned int		uaccess_err:1;	/* uaccess failed */
 
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index de827d6..31ba8e9 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -37,6 +37,10 @@ void common(void) {
 	BLANK();
 	OFFSET(TASK_TI_flags, task_struct, thread_info.flags);
 	OFFSET(TASK_addr_limit, task_struct, thread.addr_limit);
+#ifdef CONFIG_STACKLEAK
+	OFFSET(TASK_lowest_stack, task_struct, thread.lowest_stack);
+	OFFSET(TASK_thread_sp0, task_struct, thread.sp0);
+#endif
 
 	BLANK();
 	OFFSET(crypto_tfm_ctx_offset, crypto_tfm, __crt_ctx);
@@ -73,6 +77,11 @@ void common(void) {
 	OFFSET(PV_MMU_read_cr2, pv_mmu_ops, read_cr2);
 #endif
 
+#ifdef CONFIG_STACKLEAK
+	BLANK();
+	DEFINE(THREAD_SIZE_asm, THREAD_SIZE);
+#endif
+
 #ifdef CONFIG_XEN
 	BLANK();
 	OFFSET(XEN_vcpu_info_mask, vcpu_info, evtchn_upcall_mask);
diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index b0b3a3d..a223b4e 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -174,3 +174,15 @@ int is_valid_bugaddr(unsigned long ip)
 
 	return ud2 == 0x0b0f;
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
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index a8b117e..c2ffb9f 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -188,3 +188,36 @@ int is_valid_bugaddr(unsigned long ip)
 
 	return ud2 == 0x0b0f;
 }
+
+#ifdef CONFIG_STACKLEAK
+void __used check_alloca(unsigned long size)
+{
+	struct stack_info stack_info = {0};
+	unsigned long visit_mask = 0;
+	unsigned long sp = (unsigned long)&sp;
+	unsigned long stack_left;
+
+	BUG_ON(get_stack_info(&sp, current, &stack_info, &visit_mask));
+
+	switch (stack_info.type) {
+	case STACK_TYPE_TASK:
+		stack_left = sp & (THREAD_SIZE - 1);
+		break;
+
+	case STACK_TYPE_IRQ:
+		stack_left = sp & (IRQ_STACK_SIZE - 1);
+		break;
+
+	case STACK_TYPE_EXCEPTION ... STACK_TYPE_EXCEPTION_LAST:
+		stack_left = sp & (EXCEPTION_STKSZ - 1);
+		break;
+
+	case STACK_TYPE_SOFTIRQ:
+	default:
+		BUG();
+	}
+
+	BUG_ON(stack_left < 256 || size >= stack_left - 256);
+}
+EXPORT_SYMBOL(check_alloca);
+#endif
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 4c818f8..5355b12 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -134,6 +134,11 @@ int copy_thread_tls(unsigned long clone_flags, unsigned long sp,
 	p->thread.sp0 = (unsigned long) (childregs+1);
 	memset(p->thread.ptrace_bps, 0, sizeof(p->thread.ptrace_bps));
 
+#ifdef CONFIG_STACKLEAK
+	p->thread.lowest_stack = (unsigned long)task_stack_page(p) +
+						2 * sizeof(unsigned long);
+#endif
+
 	if (unlikely(p->flags & PF_KTHREAD)) {
 		/* kernel thread */
 		memset(childregs, 0, sizeof(struct pt_regs));
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index d6b784a..f943558 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -161,6 +161,11 @@ int copy_thread_tls(unsigned long clone_flags, unsigned long sp,
 	p->thread.sp = (unsigned long) fork_frame;
 	p->thread.io_bitmap_ptr = NULL;
 
+#ifdef CONFIG_STACKLEAK
+	p->thread.lowest_stack = (unsigned long)task_stack_page(p) +
+						2 * sizeof(unsigned long);
+#endif
+
 	savesegment(gs, p->thread.gsindex);
 	p->thread.gsbase = p->thread.gsindex ? 0 : me->thread.gsbase;
 	savesegment(fs, p->thread.fsindex);
diff --git a/fs/exec.c b/fs/exec.c
index 65145a3..c041611 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1927,3 +1927,20 @@ COMPAT_SYSCALL_DEFINE5(execveat, int, fd,
 				  argv, envp, flags);
 }
 #endif
+
+#ifdef CONFIG_STACKLEAK
+void __used track_stack(void)
+{
+	unsigned long sp = (unsigned long)&sp;
+
+	if (sp < current->thread.lowest_stack &&
+	    sp >= (unsigned long)task_stack_page(current) +
+					2 * sizeof(unsigned long)) {
+		current->thread.lowest_stack = sp;
+	}
+
+	if (unlikely((sp & ~(THREAD_SIZE - 1)) < (THREAD_SIZE / 16)))
+		BUG();
+}
+EXPORT_SYMBOL(track_stack);
+#endif
diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
index 8233553..6cf9487 100644
--- a/scripts/Makefile.gcc-plugins
+++ b/scripts/Makefile.gcc-plugins
@@ -29,6 +29,9 @@ ifdef CONFIG_GCC_PLUGINS
   gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STRUCTLEAK_VERBOSE)	+= -fplugin-arg-structleak_plugin-verbose
   gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STRUCTLEAK)	+= -DSTRUCTLEAK_PLUGIN
 
+  gcc-plugin-$(CONFIG_STACKLEAK)	+= stackleak_plugin.so
+  gcc-plugin-cflags-$(CONFIG_STACKLEAK)	+= -DSTACKLEAK_PLUGIN -fplugin-arg-stackleak_plugin-track-lowest-sp=100
+
   GCC_PLUGINS_CFLAGS := $(strip $(addprefix -fplugin=$(objtree)/scripts/gcc-plugins/, $(gcc-plugin-y)) $(gcc-plugin-cflags-y))
 
   export PLUGINCC GCC_PLUGINS_CFLAGS GCC_PLUGIN GCC_PLUGIN_SUBDIR
diff --git a/scripts/gcc-plugins/stackleak_plugin.c b/scripts/gcc-plugins/stackleak_plugin.c
new file mode 100644
index 0000000..2ee49c4
--- /dev/null
+++ b/scripts/gcc-plugins/stackleak_plugin.c
@@ -0,0 +1,342 @@
+/*
+ * Copyright 2011-2017 by the PaX Team <pageexec@freemail.hu>
+ * Licensed under the GPL v2
+ *
+ * Note: the choice of the license means that the compilation process is
+ *       NOT 'eligible' as defined by gcc's library exception to the GPL v3,
+ *       but for the kernel it doesn't matter since it doesn't link against
+ *       any of the gcc libraries
+ *
+ * gcc plugin to help implement various PaX features
+ *
+ * - track lowest stack pointer
+ *
+ * TODO:
+ * - initialize all local variables
+ *
+ * BUGS:
+ * - none known
+ */
+
+#include "gcc-common.h"
+
+__visible int plugin_is_GPL_compatible;
+
+static int track_frame_size = -1;
+static const char track_function[] = "track_stack";
+static const char check_function[] = "check_alloca";
+static GTY(()) tree track_function_decl;
+static GTY(()) tree check_function_decl;
+static bool init_locals;
+
+static struct plugin_info stackleak_plugin_info = {
+	.version	= "201602181345",
+	.help		= "track-lowest-sp=nn\ttrack sp in functions whose frame size is at least nn bytes\n"
+//			  "initialize-locals\t\tforcibly initialize all stack frames\n"
+};
+
+static void stackleak_check_alloca(gimple_stmt_iterator *gsi)
+{
+	gimple stmt;
+	gcall *check_alloca;
+	tree alloca_size;
+	cgraph_node_ptr node;
+	int frequency;
+	basic_block bb;
+
+	// insert call to void check_alloca(unsigned long size)
+	alloca_size = gimple_call_arg(gsi_stmt(*gsi), 0);
+	stmt = gimple_build_call(check_function_decl, 1, alloca_size);
+	check_alloca = as_a_gcall(stmt);
+	gsi_insert_before(gsi, check_alloca, GSI_SAME_STMT);
+
+	// update the cgraph
+	bb = gimple_bb(check_alloca);
+	node = cgraph_get_create_node(check_function_decl);
+	gcc_assert(node);
+	frequency = compute_call_stmt_bb_frequency(current_function_decl, bb);
+	cgraph_create_edge(cgraph_get_node(current_function_decl), node, check_alloca, bb->count, frequency, bb->loop_depth);
+}
+
+static void stackleak_add_instrumentation(gimple_stmt_iterator *gsi, bool after)
+{
+	gimple stmt;
+	gcall *track_stack;
+	cgraph_node_ptr node;
+	int frequency;
+	basic_block bb;
+
+	// insert call to void track_stack(void)
+	stmt = gimple_build_call(track_function_decl, 0);
+	track_stack = as_a_gcall(stmt);
+	if (after)
+		gsi_insert_after(gsi, track_stack, GSI_CONTINUE_LINKING);
+	else
+		gsi_insert_before(gsi, track_stack, GSI_SAME_STMT);
+
+	// update the cgraph
+	bb = gimple_bb(track_stack);
+	node = cgraph_get_create_node(track_function_decl);
+	gcc_assert(node);
+	frequency = compute_call_stmt_bb_frequency(current_function_decl, bb);
+	cgraph_create_edge(cgraph_get_node(current_function_decl), node, track_stack, bb->count, frequency, bb->loop_depth);
+}
+
+static bool is_alloca(gimple stmt)
+{
+	if (gimple_call_builtin_p(stmt, BUILT_IN_ALLOCA))
+		return true;
+
+#if BUILDING_GCC_VERSION >= 4007
+	if (gimple_call_builtin_p(stmt, BUILT_IN_ALLOCA_WITH_ALIGN))
+		return true;
+#endif
+
+	return false;
+}
+
+static unsigned int stackleak_tree_instrument_execute(void)
+{
+	basic_block bb, entry_bb;
+	bool prologue_instrumented = false, is_leaf = true;
+
+	entry_bb = ENTRY_BLOCK_PTR_FOR_FN(cfun)->next_bb;
+
+	// 1. loop through BBs and GIMPLE statements
+	FOR_EACH_BB_FN(bb, cfun) {
+		gimple_stmt_iterator gsi;
+
+		for (gsi = gsi_start_bb(bb); !gsi_end_p(gsi); gsi_next(&gsi)) {
+			gimple stmt;
+
+			stmt = gsi_stmt(gsi);
+
+			if (is_gimple_call(stmt))
+				is_leaf = false;
+
+			// gimple match: align 8 built-in BUILT_IN_NORMAL:BUILT_IN_ALLOCA attributes <tree_list 0xb7576450>
+			if (!is_alloca(stmt))
+				continue;
+
+			// 2. insert stack overflow check before each __builtin_alloca call
+			stackleak_check_alloca(&gsi);
+
+			// 3. insert track call after each __builtin_alloca call
+			stackleak_add_instrumentation(&gsi, true);
+			if (bb == entry_bb)
+				prologue_instrumented = true;
+		}
+	}
+
+	// special cases for some bad linux code: taking the address of static inline functions will materialize them
+	// but we mustn't instrument some of them as the resulting stack alignment required by the function call ABI
+	// will break other assumptions regarding the expected (but not otherwise enforced) register clobbering  ABI.
+	// case in point: native_save_fl on amd64 when optimized for size clobbers rdx if it were instrumented here.
+	if (is_leaf && !TREE_PUBLIC(current_function_decl) && DECL_DECLARED_INLINE_P(current_function_decl))
+		return 0;
+	if (is_leaf && !strncmp(IDENTIFIER_POINTER(DECL_NAME(current_function_decl)), "_paravirt_", 10))
+		return 0;
+
+	// 4. insert track call at the beginning
+	if (!prologue_instrumented) {
+		gimple_stmt_iterator gsi;
+
+		gcc_assert(single_succ_p(ENTRY_BLOCK_PTR_FOR_FN(cfun)));
+		bb = single_succ(ENTRY_BLOCK_PTR_FOR_FN(cfun));
+		if (!single_pred_p(bb)) {
+//			gcc_assert(bb_loop_depth(bb) || (bb->flags & BB_IRREDUCIBLE_LOOP));
+			split_edge(single_succ_edge(ENTRY_BLOCK_PTR_FOR_FN(cfun)));
+			gcc_assert(single_succ_p(ENTRY_BLOCK_PTR_FOR_FN(cfun)));
+			bb = single_succ(ENTRY_BLOCK_PTR_FOR_FN(cfun));
+		}
+		gsi = gsi_after_labels(bb);
+		stackleak_add_instrumentation(&gsi, false);
+	}
+
+	return 0;
+}
+
+static unsigned int stackleak_final_execute(void)
+{
+	rtx_insn *insn, *next;
+
+	if (cfun->calls_alloca)
+		return 0;
+
+	// keep calls only if function frame is big enough
+	if (get_frame_size() >= track_frame_size)
+		return 0;
+
+	// 1. find track_stack calls
+	for (insn = get_insns(); insn; insn = next) {
+		// rtl match: (call_insn 8 7 9 3 (call (mem (symbol_ref ("track_stack") [flags 0x41] <function_decl 0xb7470e80 track_stack>) [0 S1 A8]) (4)) -1 (nil) (nil))
+		rtx body;
+
+		next = NEXT_INSN(insn);
+		if (!CALL_P(insn))
+			continue;
+		body = PATTERN(insn);
+		if (GET_CODE(body) != CALL)
+			continue;
+		body = XEXP(body, 0);
+		if (GET_CODE(body) != MEM)
+			continue;
+		body = XEXP(body, 0);
+		if (GET_CODE(body) != SYMBOL_REF)
+			continue;
+//		if (strcmp(XSTR(body, 0), track_function))
+		if (SYMBOL_REF_DECL(body) != track_function_decl)
+			continue;
+//		warning(0, "track_frame_size: %d %ld %d", cfun->calls_alloca, get_frame_size(), track_frame_size);
+		// 2. delete call
+		delete_insn_and_edges(insn);
+#if BUILDING_GCC_VERSION >= 4007
+		if (GET_CODE(next) == NOTE && NOTE_KIND(next) == NOTE_INSN_CALL_ARG_LOCATION) {
+			insn = next;
+			next = NEXT_INSN(insn);
+			delete_insn_and_edges(insn);
+		}
+#endif
+	}
+
+//	print_simple_rtl(stderr, get_insns());
+//	print_rtl(stderr, get_insns());
+//	warning(0, "track_frame_size: %d %ld %d", cfun->calls_alloca, get_frame_size(), track_frame_size);
+
+	return 0;
+}
+
+static bool stackleak_track_stack_gate(void)
+{
+	tree section;
+
+	if (ix86_cmodel != CM_KERNEL)
+		return false;
+
+	section = lookup_attribute("section", DECL_ATTRIBUTES(current_function_decl));
+	if (section && TREE_VALUE(section)) {
+		section = TREE_VALUE(TREE_VALUE(section));
+
+		if (!strncmp(TREE_STRING_POINTER(section), ".init.text", 10))
+			return false;
+		if (!strncmp(TREE_STRING_POINTER(section), ".devinit.text", 13))
+			return false;
+		if (!strncmp(TREE_STRING_POINTER(section), ".cpuinit.text", 13))
+			return false;
+		if (!strncmp(TREE_STRING_POINTER(section), ".meminit.text", 13))
+			return false;
+	}
+
+	return track_frame_size >= 0;
+}
+
+static void stackleak_start_unit(void *gcc_data __unused, void *user_data __unused)
+{
+	tree fntype;
+
+	// void track_stack(void)
+	fntype = build_function_type_list(void_type_node, NULL_TREE);
+	track_function_decl = build_fn_decl(track_function, fntype);
+	DECL_ASSEMBLER_NAME(track_function_decl); // for LTO
+	TREE_PUBLIC(track_function_decl) = 1;
+	TREE_USED(track_function_decl) = 1;
+	DECL_EXTERNAL(track_function_decl) = 1;
+	DECL_ARTIFICIAL(track_function_decl) = 1;
+	DECL_PRESERVE_P(track_function_decl) = 1;
+
+	// void check_alloca(unsigned long)
+	fntype = build_function_type_list(void_type_node, long_unsigned_type_node, NULL_TREE);
+	check_function_decl = build_fn_decl(check_function, fntype);
+	DECL_ASSEMBLER_NAME(check_function_decl); // for LTO
+	TREE_PUBLIC(check_function_decl) = 1;
+	TREE_USED(check_function_decl) = 1;
+	DECL_EXTERNAL(check_function_decl) = 1;
+	DECL_ARTIFICIAL(check_function_decl) = 1;
+	DECL_PRESERVE_P(check_function_decl) = 1;
+}
+
+static bool stackleak_tree_instrument_gate(void)
+{
+	return stackleak_track_stack_gate();
+}
+
+#define PASS_NAME stackleak_tree_instrument
+#define PROPERTIES_REQUIRED PROP_gimple_leh | PROP_cfg
+#define TODO_FLAGS_START TODO_verify_ssa | TODO_verify_flow | TODO_verify_stmts
+#define TODO_FLAGS_FINISH TODO_verify_ssa | TODO_verify_stmts | TODO_dump_func | TODO_update_ssa | TODO_rebuild_cgraph_edges
+#include "gcc-generate-gimple-pass.h"
+
+static bool stackleak_final_gate(void)
+{
+	return stackleak_track_stack_gate();
+}
+
+#define PASS_NAME stackleak_final
+#define TODO_FLAGS_FINISH TODO_dump_func
+#include "gcc-generate-rtl-pass.h"
+
+__visible int plugin_init(struct plugin_name_args *plugin_info, struct plugin_gcc_version *version)
+{
+	const char * const plugin_name = plugin_info->base_name;
+	const int argc = plugin_info->argc;
+	const struct plugin_argument * const argv = plugin_info->argv;
+	int i;
+
+	static const struct ggc_root_tab gt_ggc_r_gt_stackleak[] = {
+		{
+			.base = &track_function_decl,
+			.nelt = 1,
+			.stride = sizeof(track_function_decl),
+			.cb = &gt_ggc_mx_tree_node,
+			.pchw = &gt_pch_nx_tree_node
+		},
+		{
+			.base = &check_function_decl,
+			.nelt = 1,
+			.stride = sizeof(check_function_decl),
+			.cb = &gt_ggc_mx_tree_node,
+			.pchw = &gt_pch_nx_tree_node
+		},
+		LAST_GGC_ROOT_TAB
+	};
+
+//	PASS_INFO(stackleak_tree_instrument, "tree_profile", 1, PASS_POS_INSERT_BEFORE);
+	PASS_INFO(stackleak_tree_instrument, "optimized", 1, PASS_POS_INSERT_BEFORE);
+	PASS_INFO(stackleak_final, "final", 1, PASS_POS_INSERT_BEFORE);
+
+	if (!plugin_default_version_check(version, &gcc_version)) {
+		error(G_("incompatible gcc/plugin versions"));
+		return 1;
+	}
+
+	register_callback(plugin_name, PLUGIN_INFO, NULL, &stackleak_plugin_info);
+
+	for (i = 0; i < argc; ++i) {
+		if (!strcmp(argv[i].key, "track-lowest-sp")) {
+			if (!argv[i].value) {
+				error(G_("no value supplied for option '-fplugin-arg-%s-%s'"), plugin_name, argv[i].key);
+				continue;
+			}
+			track_frame_size = atoi(argv[i].value);
+			if (argv[i].value[0] < '0' || argv[i].value[0] > '9' || track_frame_size < 0)
+				error(G_("invalid option argument '-fplugin-arg-%s-%s=%s'"), plugin_name, argv[i].key, argv[i].value);
+			continue;
+		}
+		if (!strcmp(argv[i].key, "initialize-locals")) {
+			if (argv[i].value) {
+				error(G_("invalid option argument '-fplugin-arg-%s-%s=%s'"), plugin_name, argv[i].key, argv[i].value);
+				continue;
+			}
+			init_locals = true;
+			continue;
+		}
+		error(G_("unknown option '-fplugin-arg-%s-%s'"), plugin_name, argv[i].key);
+	}
+
+	register_callback(plugin_name, PLUGIN_START_UNIT, &stackleak_start_unit, NULL);
+	register_callback(plugin_name, PLUGIN_REGISTER_GGC_ROOTS, NULL, (void *)&gt_ggc_r_gt_stackleak);
+	register_callback(plugin_name, PLUGIN_PASS_MANAGER_SETUP, NULL, &stackleak_tree_instrument_pass_info);
+	register_callback(plugin_name, PLUGIN_PASS_MANAGER_SETUP, NULL, &stackleak_final_pass_info);
+
+	return 0;
+}
-- 
2.7.4
