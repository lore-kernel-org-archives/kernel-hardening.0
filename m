References: <1507157703-14972-1-git-send-email-alex.popov@linux.com>
 <1507157703-14972-2-git-send-email-alex.popov@linux.com>
 <20171005072751.lhf7kamzfw4sdhbo@gmail.com>
 <a3074303-d61f-342a-af8a-64013557c816@linux.com>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <750e768f-6e6e-2144-ae72-207aaf64f182@redhat.com>
Date: Tue, 10 Oct 2017 15:33:52 -0700
MIME-Version: 1.0
In-Reply-To: <a3074303-d61f-342a-af8a-64013557c816@linux.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] Re: [PATCH RFC v4 1/3] gcc-plugins: Add STACKLEAK erasing the kernel
 stack at the end of syscalls
To: alex.popov@linux.com, Ingo Molnar <mingo@kernel.org>
Cc: kernel-hardening@lists.openwall.com, keescook@chromium.org, pageexec@freemail.hu, spender@grsecurity.net, tycho@docker.com, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andy Lutomirski <luto@amacapital.net>, x86@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>
List-ID: <kernel-hardening.lists.openwall.com>

On 10/05/2017 05:31 AM, Alexander Popov wrote:
> On 05.10.2017 10:27, Ingo Molnar wrote:
>>
>> * Alexander Popov <alex.popov@linux.com> wrote:
>>
>>> diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
>>> index 8a13d46..06bc57b 100644
>>> --- a/arch/x86/entry/entry_32.S
>>> +++ b/arch/x86/entry/entry_32.S
>>> @@ -75,6 +75,71 @@
>>>  #endif
>>>  .endm
>>>  
>>> +.macro erase_kstack
>>> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
>>> +	call erase_kstack
>>> +#endif
>>> +.endm
>>> +
>>> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
>>> +/* For the detailed comments, see erase_kstack in entry_64.S */
>>> +ENTRY(erase_kstack)
>>> +	pushl	%edi
>>> +	pushl	%ecx
>>> +	pushl	%eax
>>> +	pushl	%ebp
>>> +
>>> +	movl	PER_CPU_VAR(current_task), %ebp
>>> +	mov	TASK_lowest_stack(%ebp), %edi
>>> +	mov	$STACKLEAK_POISON, %eax
>>> +	std
>>> +
>>> +1:
>>> +	mov	%edi, %ecx
>>> +	and	$THREAD_SIZE_asm - 1, %ecx
>>> +	shr	$2, %ecx
>>> +	repne	scasl
>>> +	jecxz	2f
>>> +
>>> +	cmp	$2*16, %ecx
>>> +	jc	2f
>>> +
>>> +	mov	$2*16, %ecx
>>> +	repe	scasl
>>> +	jecxz	2f
>>> +	jne	1b
>>> +
>>> +2:
>>> +	cld
>>> +	or	$2*4, %edi
>>> +	mov	%esp, %ecx
>>> +	sub	%edi, %ecx
>>> +
>>> +	cmp	$THREAD_SIZE_asm, %ecx
>>> +	jb	3f
>>> +	ud2
>>> +
>>> +3:
>>> +	shr	$2, %ecx
>>> +	rep	stosl
>>> +
>>> +	/*
>>> +	 * TODO: sp0 on x86_32 is not reliable, right?
>>> +	 * Doubt because of the definition of cpu_current_top_of_stack
>>> +	 * in arch/x86/kernel/cpu/common.c.
>>> +	 */
>>> +	mov	TASK_thread_sp0(%ebp), %edi
>>> +	sub	$128, %edi
>>> +	mov	%edi, TASK_lowest_stack(%ebp)
>>> +
>>> +	popl	%ebp
>>> +	popl	%eax
>>> +	popl	%ecx
>>> +	popl	%edi
>>> +	ret
>>> +ENDPROC(erase_kstack)
>>> +#endif
>>> +
>>>  /*
>>>   * User gs save/restore
>>>   *
>>> @@ -445,6 +510,8 @@ ENTRY(entry_SYSENTER_32)
>>>  	ALTERNATIVE "testl %eax, %eax; jz .Lsyscall_32_done", \
>>>  		    "jmp .Lsyscall_32_done", X86_FEATURE_XENPV
>>>  
>>> +	erase_kstack
>>> +
>>>  /* Opportunistic SYSEXIT */
>>>  	TRACE_IRQS_ON			/* User mode traces as IRQs on. */
>>>  	movl	PT_EIP(%esp), %edx	/* pt_regs->ip */
>>> @@ -531,6 +598,8 @@ ENTRY(entry_INT80_32)
>>>  	call	do_int80_syscall_32
>>>  .Lsyscall_32_done:
>>>  
>>> +	erase_kstack
>>> +
>>>  restore_all:
>>>  	TRACE_IRQS_IRET
>>>  .Lrestore_all_notrace:
>>> diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
>>> index 4916725..189d843 100644
>>> --- a/arch/x86/entry/entry_64.S
>>> +++ b/arch/x86/entry/entry_64.S
>>> @@ -59,6 +59,90 @@ END(native_usergs_sysret64)
>>>  #endif
>>>  .endm
>>>  
>>> +.macro erase_kstack
>>> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
>>> +	call erase_kstack
>>> +#endif
>>> +.endm
>>> +
>>> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
>>> +ENTRY(erase_kstack)
>>> +	pushq	%rdi
>>> +	pushq	%rcx
>>> +	pushq	%rax
>>> +	pushq	%r11
>>> +
>>> +	movq	PER_CPU_VAR(current_task), %r11
>>> +	mov	TASK_lowest_stack(%r11), %rdi
>>> +	mov	$STACKLEAK_POISON, %rax
>>> +	std
>>> +
>>> +	/*
>>> +	 * Let's search for the poison value in the stack.
>>> +	 * Start from the lowest_stack and go to the bottom (see std above).
>>> +	 */
>>> +1:
>>> +	mov	%edi, %ecx
>>> +	and	$THREAD_SIZE_asm - 1, %ecx
>>> +	shr	$3, %ecx
>>> +	repne	scasq
>>> +	jecxz	2f	/* Didn't find it. Go to poisoning. */
>>> +
>>> +	/*
>>> +	 * Found the poison value in the stack. Go to poisoning if there are
>>> +	 * less than 16 qwords left.
>>> +	 */
>>> +	cmp	$2*8, %ecx
>>> +	jc	2f
>>> +
>>> +	/*
>>> +	 * Check that 16 further qwords contain poison (avoid false positives).
>>> +	 * If so, the part of the stack below the address in %rdi is likely
>>> +	 * to be poisoned. Otherwise we need to search deeper.
>>> +	 */
>>> +	mov	$2*8, %ecx
>>> +	repe	scasq
>>> +	jecxz	2f	/* Poison the upper part of the stack. */
>>> +	jne	1b	/* Search deeper. */
>>> +
>>> +2:
>>> +	/*
>>> +	 * Prepare the counter for poisoning the kernel stack between
>>> +	 * %rdi and %rsp. Two qwords at the bottom of the stack are reserved
>>> +	 * and should not be poisoned (see CONFIG_SCHED_STACK_END_CHECK).
>>> +	 */
>>> +	cld
>>> +	or	$2*8, %rdi
>>> +	mov	%esp, %ecx
>>> +	sub	%edi, %ecx
>>> +
>>> +	/* Check that the counter value is sane. */
>>> +	cmp	$THREAD_SIZE_asm, %rcx
>>> +	jb	3f
>>> +	ud2
>>> +
>>> +3:
>>> +	/*
>>> +	 * So let's write the poison value to the kernel stack. Start from the
>>> +	 * address in %rdi and move up (see cld above) to the address in %rsp
>>> +	 * (not included, used memory).
>>> +	 */
>>> +	shr	$3, %ecx
>>> +	rep	stosq
>>> +
>>> +	/* Set the lowest_stack value to the top_of_stack - 256. */
>>> +	mov	TASK_thread_sp0(%r11), %rdi
>>> +	sub	$256, %rdi
>>> +	mov	%rdi, TASK_lowest_stack(%r11)
>>> +
>>> +	popq	%r11
>>> +	popq	%rax
>>> +	popq	%rcx
>>> +	popq	%rdi
>>> +	ret
>>> +ENDPROC(erase_kstack)
> 
> 
> Hello Ingo,
> 
> Thanks a lot for your review.
> 
>> A couple of (first round) review observations:
>>
>> - Why is the erase_kstack() function written in assembly, instead of plain C?
>>   The complexity and fragility of this patch could be reduced if it was moved to C.
> 
> Let me shortly describe my tactics.
> 
> Initially the erase_kstack() function is written in assembly in Grsecurity/PaX
> patch. I've extracted the STACKLEAK feature from that huge patch and carefully
> learned it bit by bit (it's quite complex). There are several bugs which I've
> found and fixed in it (they are listed in the cover letter), but generally I
> stick to the initial implementation in order not to accidentally break it.
> 
> I've added the detailed comments describing erase_kstack() for x86_64. IMO this
> code is really cool (my respect to PaX Team). However, if you think that
> rewriting it in C is obligatory, I'll do that. But let me at first fix the other
> issues which you listed below.
> 

I played around with reworking my arm64 version in C. I had to do some
tricks to save x0 which is used on the syscall fastpath. I'm concerned
about relying on gcc to not place anything on the stack when we clear
it. This might be mitigated if we don't make function calls, or maybe
I should have more faith in gcc?

Thanks,
Laura
