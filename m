References: <1499883471-23822-1-git-send-email-alex.popov@linux.com>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <e604f541-084d-53e0-7f5c-d87e3729068b@redhat.com>
Date: Fri, 14 Jul 2017 14:44:46 -0700
MIME-Version: 1.0
In-Reply-To: <1499883471-23822-1-git-send-email-alex.popov@linux.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] Re: [PATCH RFC v3 1/1] gcc-plugins: Add stackleak feature erasing the
 kernel stack at the end of syscalls
To: Alexander Popov <alex.popov@linux.com>, kernel-hardening@lists.openwall.com, keescook@chromium.org, pageexec@freemail.hu, spender@grsecurity.net, tycho@docker.com, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, x86@kernel.org, Andy Lutomirski <luto@amacapital.net>
List-ID: <kernel-hardening.lists.openwall.com>

On 07/12/2017 11:17 AM, Alexander Popov wrote:
> This is the third version of the patch introducing STACKLEAK to the
> mainline kernel. STACKLEAK is a security feature developed by Grsecurity/PaX
> (kudos to them again), which:
>  - reduces the information that can be revealed by some kernel stack leak bugs
>     (e.g. CVE-2016-4569 and CVE-2016-4578);
>  - blocks some uninitialized stack variable attacks (e.g. CVE-2010-2963);
>  - introduces some runtime checks for kernel stack overflow detection.
> 
> Changes in v3 (rebased on the recent rc)
> 
> 1. Added the detailed comments describing the STACKLEAK gcc plugin.
>    Read the plugin from bottom up, like you do for Linux kernel drivers.
>    Additional information:
>     - gcc internals documentation, which is available from gcc sources;
>     - wonderful slides by Diego Novillo
>        https://www.airs.com/dnovillo/200711-GCC-Internals/
>     - nice introduction to gcc plugins at LWN
>        https://lwn.net/Articles/457543/
> 
> 2. Improved the commit message and Kconfig description according the
>    feedback from Kees Cook. Also added the original notice describing
>    the performance impact of the STACKLEAK feature.
> 
> 3. Removed arch-specific ix86_cmodel check from stackleak_track_stack_gate().
>    It caused skipping the kernel code instrumentation for i386.
> 
> 4. Fixed a minor mistake in stackleak_tree_instrument_execute().
>    First versions of the plugin used ENTRY_BLOCK_PTR_FOR_FN(cfun)->next_bb
>    to get the basic block with the function prologue. That was not correct
>    since the control flow graph edge from the ENTRY_BLOCK_PTR doesn't always
>    go to that basic block.
> 
>    So later it was changed it to single_succ(ENTRY_BLOCK_PTR_FOR_FN(cfun)),
>    but not completely. next_bb was still used for entry_bb assignment,
>    which could cause the wrong value of the prologue_instrumented variable.
> 
>    I've reported this issue to Grsecurity and proposed the fix for it, but
>    unfortunately didn't get any reply.
> 
> 5. Introduced the STACKLEAK_POISON macro and renamed the config option
>    according the feedback from Kees Cook.
> 
> More things to be done:
>  - carefully look into the assertions in track_stack() and check_alloca();
>  - find answers to the questions marked with TODO in the comments;
>  - think of erasing the kernel stack after invoking EFI runtime services;
>  - update self-protection.rst.
> 
> Parallel work (thanks for that!):
>  - Tycho Andersen is developing tests for STACKLEAK;
>  - Laura Abbott is working on porting STACKLEAK to arm64.
> 
> -- >8 --
> 
> The stackleak feature erases the kernel stack before returning from syscalls.
> That reduces the information which a kernel stack leak bug can reveal and
> blocks some uninitialized stack variable attacks. Moreover, stackleak
> provides runtime checks for kernel stack overflow detection.
> 
> This feature consists of:
>  - the architecture-specific code filling the used part of the kernel stack
>     with a poison value before returning to the userspace;
>  - the stackleak gcc plugin. It instruments the kernel code inserting the
>     track_stack() call for tracking the lowest border of the kernel stack
>     and check_alloca() call for checking alloca size.
> 
> The stackleak feature is ported from grsecurity/PaX. For more information see:
>   https://grsecurity.net/
>   https://pax.grsecurity.net/
> 
> This code is modified from Brad Spengler/PaX Team's code in the last public
> patch of grsecurity/PaX based on our understanding of the code. Changes or
> omissions from the original code are ours and don't reflect the original
> grsecurity/PaX code.
> 
> Signed-off-by: Alexander Popov <alex.popov@linux.com>
> ---
>  arch/Kconfig                           |  27 +++
>  arch/x86/Kconfig                       |   1 +
>  arch/x86/entry/common.c                |  17 +-
>  arch/x86/entry/entry_32.S              |  71 ++++++
>  arch/x86/entry/entry_64.S              |  99 ++++++++
>  arch/x86/entry/entry_64_compat.S       |   8 +
>  arch/x86/include/asm/processor.h       |   4 +
>  arch/x86/kernel/asm-offsets.c          |   9 +
>  arch/x86/kernel/dumpstack_32.c         |  12 +
>  arch/x86/kernel/dumpstack_64.c         |  33 +++
>  arch/x86/kernel/process_32.c           |   5 +
>  arch/x86/kernel/process_64.c           |   5 +
>  fs/exec.c                              |  17 ++
>  include/linux/compiler.h               |   4 +
>  scripts/Makefile.gcc-plugins           |   3 +
>  scripts/gcc-plugins/stackleak_plugin.c | 397 +++++++++++++++++++++++++++++++++
>  16 files changed, 709 insertions(+), 3 deletions(-)
>  create mode 100644 scripts/gcc-plugins/stackleak_plugin.c
> 
> diff --git a/arch/Kconfig b/arch/Kconfig
> index cae0958..0c9a0f5 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -361,6 +361,13 @@ config SECCOMP_FILTER
>  
>  	  See Documentation/prctl/seccomp_filter.txt for details.
>  
> +config HAVE_ARCH_STACKLEAK
> +	bool
> +	help
> +	  An architecture should select this if it has the code which
> +	  fills the used part of the kernel stack with the STACKLEAK_POISON
> +	  value before returning from system calls.
> +
>  config HAVE_GCC_PLUGINS
>  	bool
>  	help
> @@ -482,6 +489,26 @@ config GCC_PLUGIN_RANDSTRUCT_PERFORMANCE
>  	  in structures.  This reduces the performance hit of RANDSTRUCT
>  	  at the cost of weakened randomization.
>  
> +config GCC_PLUGIN_STACKLEAK
> +	bool "Erase the kernel stack before returning from syscalls"
> +	depends on GCC_PLUGINS
> +	depends on HAVE_ARCH_STACKLEAK
> +	help
> +	  This option makes the kernel erase the kernel stack before it
> +	  returns from a system call. That reduces the information which
> +	  a kernel stack leak bug can reveal and blocks some uninitialized
> +	  stack variable attacks. This option also provides runtime checks
> +	  for kernel stack overflow detection.
> +
> +	  The tradeoff is the performance impact: on a single CPU system kernel
> +	  compilation sees a 1% slowdown, other systems and workloads may vary
> +	  and you are advised to test this feature on your expected workload
> +	  before deploying it.
> +
> +	  This plugin was ported from grsecurity/PaX. More information at:
> +	   * https://grsecurity.net/
> +	   * https://pax.grsecurity.net/
> +
>  config HAVE_CC_STACKPROTECTOR
>  	bool
>  	help
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 94a1868..1359e01 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -112,6 +112,7 @@ config X86
>  	select HAVE_ARCH_MMAP_RND_COMPAT_BITS	if MMU && COMPAT
>  	select HAVE_ARCH_COMPAT_MMAP_BASES	if MMU && COMPAT
>  	select HAVE_ARCH_SECCOMP_FILTER
> +	select HAVE_ARCH_STACKLEAK
>  	select HAVE_ARCH_TRACEHOOK
>  	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
>  	select HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD if X86_64
> diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
> index cdefcfd..5e9cd0a 100644
> --- a/arch/x86/entry/common.c
> +++ b/arch/x86/entry/common.c
> @@ -44,6 +44,12 @@ __visible inline void enter_from_user_mode(void)
>  static inline void enter_from_user_mode(void) {}
>  #endif
>  
> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> +asmlinkage void erase_kstack(void);
> +#else
> +static void erase_kstack(void) {}
> +#endif
> +
>  static void do_audit_syscall_entry(struct pt_regs *regs, u32 arch)
>  {
>  #ifdef CONFIG_X86_64
> @@ -80,8 +86,10 @@ static long syscall_trace_enter(struct pt_regs *regs)
>  		emulated = true;
>  
>  	if ((emulated || (work & _TIF_SYSCALL_TRACE)) &&
> -	    tracehook_report_syscall_entry(regs))
> +	    tracehook_report_syscall_entry(regs)) {
> +		erase_kstack();
>  		return -1L;
> +	}
>  
>  	if (emulated)
>  		return -1L;
> @@ -115,9 +123,11 @@ static long syscall_trace_enter(struct pt_regs *regs)
>  			sd.args[5] = regs->bp;
>  		}
>  
> -		ret = __secure_computing(&sd);
> -		if (ret == -1)
> +		ret = secure_computing(&sd);
> +		if (ret == -1) {
> +			erase_kstack();
>  			return ret;
> +		}
>  	}
>  #endif
>  
> @@ -126,6 +136,7 @@ static long syscall_trace_enter(struct pt_regs *regs)
>  
>  	do_audit_syscall_entry(regs, arch);
>  
> +	erase_kstack();
>  	return ret ?: regs->orig_ax;
>  }
>  
> diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
> index 48ef7bb..f3d2666 100644
> --- a/arch/x86/entry/entry_32.S
> +++ b/arch/x86/entry/entry_32.S
> @@ -75,6 +75,73 @@
>  #endif
>  .endm
>  
> +.macro erase_kstack
> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> +	call erase_kstack
> +#endif
> +.endm
> +
> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> +/*
> + * ebp: thread_info
> + */
> +ENTRY(erase_kstack)
> +	pushl	%edi
> +	pushl	%ecx
> +	pushl	%eax
> +	pushl	%ebp
> +
> +	movl	PER_CPU_VAR(current_task), %ebp
> +	mov	TASK_lowest_stack(%ebp), %edi
> +	mov	$STACKLEAK_POISON, %eax
> +	std
> +
> +1:
> +	mov	%edi, %ecx
> +	and	$THREAD_SIZE_asm - 1, %ecx
> +	shr	$2, %ecx
> +	repne	scasl
> +	jecxz	2f
> +
> +	cmp	$2*16, %ecx
> +	jc	2f
> +
> +	mov	$2*16, %ecx
> +	repe	scasl
> +	jecxz	2f
> +	jne	1b
> +
> +2:
> +	cld
> +	or	$2*4, %edi
> +	mov	%esp, %ecx
> +	sub	%edi, %ecx
> +
> +	cmp	$THREAD_SIZE_asm, %ecx
> +	jb	3f
> +	ud2
> +
> +3:
> +	shr	$2, %ecx
> +	rep	stosl
> +
> +	/*
> +	 * TODO: sp0 on x86_32 is not reliable, right?
> +	 * Doubt because of the definition of cpu_current_top_of_stack
> +	 * in arch/x86/kernel/cpu/common.c.
> +	 */
> +	mov	TASK_thread_sp0(%ebp), %edi
> +	sub	$128, %edi
> +	mov	%edi, TASK_lowest_stack(%ebp)
> +
> +	popl	%ebp
> +	popl	%eax
> +	popl	%ecx
> +	popl	%edi
> +	ret
> +ENDPROC(erase_kstack)
> +#endif
> +
>  /*
>   * User gs save/restore
>   *
> @@ -445,6 +512,8 @@ ENTRY(entry_SYSENTER_32)
>  	ALTERNATIVE "testl %eax, %eax; jz .Lsyscall_32_done", \
>  		    "jmp .Lsyscall_32_done", X86_FEATURE_XENPV
>  
> +	erase_kstack
> +
>  /* Opportunistic SYSEXIT */
>  	TRACE_IRQS_ON			/* User mode traces as IRQs on. */
>  	movl	PT_EIP(%esp), %edx	/* pt_regs->ip */
> @@ -531,6 +600,8 @@ ENTRY(entry_INT80_32)
>  	call	do_int80_syscall_32
>  .Lsyscall_32_done:
>  
> +	erase_kstack
> +
>  restore_all:
>  	TRACE_IRQS_IRET
>  .Lrestore_all_notrace:
> diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
> index a9a8027..c106925 100644
> --- a/arch/x86/entry/entry_64.S
> +++ b/arch/x86/entry/entry_64.S
> @@ -57,6 +57,94 @@ ENDPROC(native_usergs_sysret64)
>  #endif
>  .endm
>  
> +.macro erase_kstack
> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> +	call erase_kstack
> +#endif
> +.endm
> +
> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> +ENTRY(erase_kstack)
> +	pushq	%rdi
> +	pushq	%rcx
> +	pushq	%rax
> +	pushq	%r11
> +
> +	movq	PER_CPU_VAR(current_task), %r11
> +	mov	TASK_lowest_stack(%r11), %rdi
> +	mov	$STACKLEAK_POISON, %rax
> +	std
> +
> +1:
> +	/*
> +	 * Let's search for the poison value in the stack.
> +	 * Start from the lowest_stack and go to the bottom (see std above).
> +	 */
> +	mov	%edi, %ecx
> +	and	$THREAD_SIZE_asm - 1, %ecx
> +	shr	$3, %ecx
> +	repne	scasq
> +	jecxz	2f	/* Didn't find it. Go to poisoning. */
> +
> +	/*
> +	 * Found the poison value in the stack. Go to poisoning if there are
> +	 * less than 16 qwords left.
> +	 */
> +	cmp	$2*8, %ecx
> +	jc	2f
> +
> +	/*
> +	 * Check that 16 further qwords contain poison (avoid false positives).
> +	 * If so, the part of the stack below the address in %rdi is likely
> +	 * to be poisoned. Otherwise we need to search deeper.
> +	 */
> +	mov	$2*8, %ecx
> +	repe	scasq
> +	jecxz	2f	/* Poison the upper part of the stack. */
> +	jne	1b	/* Search deeper. */
> +
> +2:
> +	/*
> +	 * Prepare the counter for poisoning the kernel stack between
> +	 * %rdi and %rsp.
> +	 *
> +	 * TODO: Sorry, don't understand why the following OR instruction is
> +	 * needed. That may be connected to the thread.lowest_stack
> +	 * initialization in arch/x86/kernel/process_64.c, where it is set
> +	 * to the task_stack_page address + 2 * sizeof(unsigned long).
> +	 */
> +	cld
> +	or	$2*8, %rdi
> +	mov	%esp, %ecx
> +	sub	%edi, %ecx
> +
> +	/* Check that the counter value is sane. */
> +	cmp	$THREAD_SIZE_asm, %rcx
> +	jb	3f
> +	ud2
> +
> +3:
> +	/*
> +	 * So let's write the poison value to the kernel stack. Start from the
> +	 * address in %rdi and move up (see cld above) to the address in %rsp
> +	 * (not included, used memory).
> +	 */
> +	shr	$3, %ecx
> +	rep	stosq
> +
> +	/* Set the lowest_stack value to the top_of_stack - 256. */
> +	mov	TASK_thread_sp0(%r11), %rdi
> +	sub	$256, %rdi
> +	mov	%rdi, TASK_lowest_stack(%r11)
> +
> +	popq	%r11
> +	popq	%rax
> +	popq	%rcx
> +	popq	%rdi
> +	ret
> +ENDPROC(erase_kstack)
> +#endif
> +
>  /*
>   * When dynamic function tracer is enabled it will add a breakpoint
>   * to all locations that it is about to modify, sync CPUs, update
> @@ -217,6 +305,8 @@ entry_SYSCALL_64_fastpath:
>  	testl	$_TIF_ALLWORK_MASK, TASK_TI_flags(%r11)
>  	jnz	1f
>  
> +	erase_kstack
> +
>  	LOCKDEP_SYS_EXIT
>  	TRACE_IRQS_ON		/* user mode is traced as IRQs on */
>  	movq	RIP(%rsp), %rcx
> @@ -245,6 +335,8 @@ entry_SYSCALL64_slow_path:
>  	call	do_syscall_64		/* returns with IRQs disabled */
>  
>  return_from_SYSCALL_64:
> +	erase_kstack
> +
>  	RESTORE_EXTRA_REGS
>  	TRACE_IRQS_IRETQ		/* we're about to change IF */
>  
> @@ -415,6 +507,7 @@ ENTRY(ret_from_fork)
>  2:
>  	movq	%rsp, %rdi
>  	call	syscall_return_slowpath	/* returns with IRQs disabled */
> +	erase_kstack
>  	TRACE_IRQS_ON			/* user mode is traced as IRQS on */
>  	SWAPGS
>  	jmp	restore_regs_and_iret
> @@ -527,6 +620,12 @@ ret_from_intr:
>  GLOBAL(retint_user)
>  	mov	%rsp,%rdi
>  	call	prepare_exit_to_usermode
> +
> +	/*
> +	 * TODO: Do we need to call erase_kstack here?
> +	 * The PaX patch has it here commented out.
> +	 */
> +
>  	TRACE_IRQS_IRETQ
>  	SWAPGS
>  	jmp	restore_regs_and_iret
> diff --git a/arch/x86/entry/entry_64_compat.S b/arch/x86/entry/entry_64_compat.S
> index e1721da..05a75a6 100644
> --- a/arch/x86/entry/entry_64_compat.S
> +++ b/arch/x86/entry/entry_64_compat.S
> @@ -18,6 +18,12 @@
>  
>  	.section .entry.text, "ax"
>  
> +	.macro erase_kstack
> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> +	call erase_kstack
> +#endif
> +	.endm
> +
>  /*
>   * 32-bit SYSENTER entry.
>   *
> @@ -229,6 +235,7 @@ ENTRY(entry_SYSCALL_compat)
>  
>  	/* Opportunistic SYSRET */
>  sysret32_from_system_call:
> +	erase_kstack
>  	TRACE_IRQS_ON			/* User mode traces as IRQs on. */
>  	movq	RBX(%rsp), %rbx		/* pt_regs->rbx */
>  	movq	RBP(%rsp), %rbp		/* pt_regs->rbp */
> @@ -337,6 +344,7 @@ ENTRY(entry_INT80_compat)
>  .Lsyscall_32_done:
>  
>  	/* Go back to user mode. */
> +	erase_kstack
>  	TRACE_IRQS_ON
>  	SWAPGS
>  	jmp	restore_regs_and_iret
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index 6a79547..f67417d 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -470,6 +470,10 @@ struct thread_struct {
>  
>  	mm_segment_t		addr_limit;
>  
> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> +	unsigned long		lowest_stack;
> +#endif
> +
>  	unsigned int		sig_on_uaccess_err:1;
>  	unsigned int		uaccess_err:1;	/* uaccess failed */
>  
> diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
> index de827d6..4ed7451 100644
> --- a/arch/x86/kernel/asm-offsets.c
> +++ b/arch/x86/kernel/asm-offsets.c
> @@ -37,6 +37,10 @@ void common(void) {
>  	BLANK();
>  	OFFSET(TASK_TI_flags, task_struct, thread_info.flags);
>  	OFFSET(TASK_addr_limit, task_struct, thread.addr_limit);
> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> +	OFFSET(TASK_lowest_stack, task_struct, thread.lowest_stack);
> +	OFFSET(TASK_thread_sp0, task_struct, thread.sp0);
> +#endif
>  
>  	BLANK();
>  	OFFSET(crypto_tfm_ctx_offset, crypto_tfm, __crt_ctx);
> @@ -73,6 +77,11 @@ void common(void) {
>  	OFFSET(PV_MMU_read_cr2, pv_mmu_ops, read_cr2);
>  #endif
>  
> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> +	BLANK();
> +	DEFINE(THREAD_SIZE_asm, THREAD_SIZE);
> +#endif
> +
>  #ifdef CONFIG_XEN
>  	BLANK();
>  	OFFSET(XEN_vcpu_info_mask, vcpu_info, evtchn_upcall_mask);
> diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
> index e5f0b40..2eaa810 100644
> --- a/arch/x86/kernel/dumpstack_32.c
> +++ b/arch/x86/kernel/dumpstack_32.c
> @@ -162,3 +162,15 @@ void show_regs(struct pt_regs *regs)
>  	}
>  	pr_cont("\n");
>  }
> +
> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> +void __used check_alloca(unsigned long size)
> +{
> +	unsigned long sp = (unsigned long)&sp, stack_left;
> +
> +	/* all kernel stacks are of the same size */
> +	stack_left = sp & (THREAD_SIZE - 1);
> +	BUG_ON(stack_left < 256 || size >= stack_left - 256);
> +}
> +EXPORT_SYMBOL(check_alloca);
> +#endif
> diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
> index 3e1471d..dc1bb0b 100644
> --- a/arch/x86/kernel/dumpstack_64.c
> +++ b/arch/x86/kernel/dumpstack_64.c
> @@ -178,3 +178,36 @@ void show_regs(struct pt_regs *regs)
>  	}
>  	pr_cont("\n");
>  }
> +
> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> +void __used check_alloca(unsigned long size)
> +{
> +	struct stack_info stack_info = {0};
> +	unsigned long visit_mask = 0;
> +	unsigned long sp = (unsigned long)&sp;
> +	unsigned long stack_left;
> +
> +	BUG_ON(get_stack_info(&sp, current, &stack_info, &visit_mask));
> +
> +	switch (stack_info.type) {
> +	case STACK_TYPE_TASK:
> +		stack_left = sp & (THREAD_SIZE - 1);
> +		break;
> +
> +	case STACK_TYPE_IRQ:
> +		stack_left = sp & (IRQ_STACK_SIZE - 1);
> +		break;
> +
> +	case STACK_TYPE_EXCEPTION ... STACK_TYPE_EXCEPTION_LAST:
> +		stack_left = sp & (EXCEPTION_STKSZ - 1);
> +		break;
> +
> +	case STACK_TYPE_SOFTIRQ:
> +	default:
> +		BUG();
> +	}
> +
> +	BUG_ON(stack_left < 256 || size >= stack_left - 256);
> +}
> +EXPORT_SYMBOL(check_alloca);
> +#endif
> diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
> index c6d6dc5..26f7301 100644
> --- a/arch/x86/kernel/process_32.c
> +++ b/arch/x86/kernel/process_32.c
> @@ -136,6 +136,11 @@ int copy_thread_tls(unsigned long clone_flags, unsigned long sp,
>  	p->thread.sp0 = (unsigned long) (childregs+1);
>  	memset(p->thread.ptrace_bps, 0, sizeof(p->thread.ptrace_bps));
>  
> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> +	p->thread.lowest_stack = (unsigned long)task_stack_page(p) +
> +						2 * sizeof(unsigned long);
> +#endif
> +
>  	if (unlikely(p->flags & PF_KTHREAD)) {
>  		/* kernel thread */
>  		memset(childregs, 0, sizeof(struct pt_regs));
> diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
> index c3169be..8cdee97 100644
> --- a/arch/x86/kernel/process_64.c
> +++ b/arch/x86/kernel/process_64.c
> @@ -167,6 +167,11 @@ int copy_thread_tls(unsigned long clone_flags, unsigned long sp,
>  	p->thread.sp = (unsigned long) fork_frame;
>  	p->thread.io_bitmap_ptr = NULL;
>  
> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> +	p->thread.lowest_stack = (unsigned long)task_stack_page(p) +
> +						2 * sizeof(unsigned long);
> +#endif
> +

Do you know why this initialization value was chosen? In clear_kstack,
this gets reset to sp0. It seems like this forces a clear of the entire
stack on the first call of clear_kstack?

>  	savesegment(gs, p->thread.gsindex);
>  	p->thread.gsbase = p->thread.gsindex ? 0 : me->thread.gsbase;
>  	savesegment(fs, p->thread.fsindex);
> diff --git a/fs/exec.c b/fs/exec.c
> index 62175cb..22ba66d 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1949,3 +1949,20 @@ COMPAT_SYSCALL_DEFINE5(execveat, int, fd,
>  				  argv, envp, flags);
>  }
>  #endif
> +
> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> +void __used track_stack(void)
> +{
> +	unsigned long sp = (unsigned long)&sp;
> +

Mark Rutland pointed out in the review of my arm64 draft that
using current_stack_pointer() is cleaner.

> +	if (sp < current->thread.lowest_stack &&
> +	    sp >= (unsigned long)task_stack_page(current) +
> +					2 * sizeof(unsigned long)) {
> +		current->thread.lowest_stack = sp;
> +	}
> +
> +	if (unlikely((sp & ~(THREAD_SIZE - 1)) < (THREAD_SIZE / 16)))
> +		BUG();
> +}

All of the above checks have the x86-isms. Can this either be
cleaned up or made architecture specific?

> +EXPORT_SYMBOL(track_stack);
> +#endif
> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> index 219f82f..a97d334 100644
> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
> @@ -585,4 +585,8 @@ static __always_inline void __write_once_size(volatile void *p, void *res, int s
>  	(_________p1); \
>  })
>  
> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> +# define STACKLEAK_POISON -0xBEEF
> +#endif
> +

Pulling out the poison to be common is certainly good, compiler.h doesn't seem
quite right though. I don't have a strong opinion if there are no other
objections or better ideas.

>  #endif /* __LINUX_COMPILER_H */
> diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
> index 2e0e2ea..aab824d 100644
> --- a/scripts/Makefile.gcc-plugins
> +++ b/scripts/Makefile.gcc-plugins
> @@ -33,6 +33,9 @@ ifdef CONFIG_GCC_PLUGINS
>    gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_RANDSTRUCT)	+= -DRANDSTRUCT_PLUGIN
>    gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_RANDSTRUCT_PERFORMANCE)	+= -fplugin-arg-randomize_layout_plugin-performance-mode
>  
> +  gcc-plugin-$(CONFIG_GCC_PLUGIN_STACKLEAK)	+= stackleak_plugin.so
> +  gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STACKLEAK)	+= -DSTACKLEAK_PLUGIN -fplugin-arg-stackleak_plugin-track-lowest-sp=100
> +

Might be useful to make the bytes limit a Kconfig
for tuning.

Thanks,
Laura
