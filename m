Subject: Re: [PATCH 2/2] arm64: Clear the stack
References: <20180502203326.9491-1-labbott@redhat.com>
 <20180502203326.9491-3-labbott@redhat.com>
 <20180503071917.xm2xvgagvzkworay@salmiak>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <dd6ad26c-1d2c-88f3-8f01-e68d2b31d6ea@linux.com>
Date: Thu, 3 May 2018 20:33:38 +0300
MIME-Version: 1.0
In-Reply-To: <20180503071917.xm2xvgagvzkworay@salmiak>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Mark Rutland <mark.rutland@arm.com>, Laura Abbott <labbott@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Hello Mark and Laura,

Let me join the discussion. Mark, thanks for your feedback!

On 03.05.2018 10:19, Mark Rutland wrote:
> Hi Laura,
> 
> On Wed, May 02, 2018 at 01:33:26PM -0700, Laura Abbott wrote:
>>
>> Implementation of stackleak based heavily on the x86 version
>>
>> Signed-off-by: Laura Abbott <labbott@redhat.com>
>> ---
>> Now written in C instead of a bunch of assembly.
> 
> This looks neat!
> 
> I have a few minor comments below.
> 
>> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
>> index bf825f38d206..0ceea613c65b 100644
>> --- a/arch/arm64/kernel/Makefile
>> +++ b/arch/arm64/kernel/Makefile
>> @@ -55,6 +55,9 @@ arm64-reloc-test-y := reloc_test_core.o reloc_test_syms.o
>>  arm64-obj-$(CONFIG_CRASH_DUMP)		+= crash_dump.o
>>  arm64-obj-$(CONFIG_ARM_SDE_INTERFACE)	+= sdei.o
>>  
>> +arm64-obj-$(CONFIG_GCC_PLUGIN_STACKLEAK) += erase.o
>> +KASAN_SANITIZE_erase.o	:= n
> 
> I suspect we want to avoid the full set of instrumentation suspects here, e.g.
> GKOV, KASAN, UBSAN, and KCOV.

I've disabled KASAN instrumentation for that file on x86 because erase_kstack()
intentionally writes to the stack and causes KASAN false positive reports.

But I didn't see any conflicts with other types of instrumentation that you
mentioned.

>> +
>>  obj-y					+= $(arm64-obj-y) vdso/ probes/
>>  obj-m					+= $(arm64-obj-m)
>>  head-y					:= head.o
>> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
>> index ec2ee720e33e..3144f1ebdc18 100644
>> --- a/arch/arm64/kernel/entry.S
>> +++ b/arch/arm64/kernel/entry.S
>> @@ -401,6 +401,11 @@ tsk	.req	x28		// current thread_info
>>  
>>  	.text
>>  
>> +	.macro	ERASE_KSTACK
>> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
>> +	bl	erase_kstack
>> +#endif
>> +	.endm
> 
> Nit: The rest of our asm macros are lower-case -- can we stick to that here?
> 
>>  /*
>>   * Exception vectors.
>>   */
>> @@ -906,6 +911,7 @@ ret_to_user:
>>  	cbnz	x2, work_pending
>>  finish_ret_to_user:
>>  	enable_step_tsk x1, x2
>> +	ERASE_KSTACK
>>  	kernel_exit 0
>>  ENDPROC(ret_to_user)
> 
> I believe we also need this in ret_fast_syscall.
> 
> [...]
> 
>> +asmlinkage void erase_kstack(void)
>> +{
>> +	unsigned long p = current->thread.lowest_stack;
>> +	unsigned long boundary = p & ~(THREAD_SIZE - 1);
>> +	unsigned long poison = 0;
>> +	const unsigned long check_depth = STACKLEAK_POISON_CHECK_DEPTH /
>> +							sizeof(unsigned long);
>> +
>> +	/*
>> +	 * Let's search for the poison value in the stack.
>> +	 * Start from the lowest_stack and go to the bottom.
>> +	 */
>> +	while (p > boundary && poison <= check_depth) {
>> +		if (*(unsigned long *)p == STACKLEAK_POISON)
>> +			poison++;
>> +		else
>> +			poison = 0;
>> +
>> +		p -= sizeof(unsigned long);
>> +	}
>> +
>> +	/*
>> +	 * One long int at the bottom of the thread stack is reserved and
>> +	 * should not be poisoned (see CONFIG_SCHED_STACK_END_CHECK).
>> +	 */
>> +	if (p == boundary)
>> +		p += sizeof(unsigned long);
> 
> I wonder if end_of_stack() should be taught about CONFIG_SCHED_STACK_END_CHECK,
> given that's supposed to return the last *usable* long on the stack, and we
> don't account for this elsewhere.

I would be afraid to change the meaning of end_of_stack()... Currently it
considers that magic long as usable (include/linux/sched/task_stack.h):

#define task_stack_end_corrupted(task) \
		(*(end_of_stack(task)) != STACK_END_MAGIC)


> If we did, then IIUC we could do:
> 
> 	unsigned long boundary = (unsigned long)end_of_stack(current);
> 
> ... at the start of the function, and not have to worry about this explicitly.

I should mention that erase_kstack() can be called from x86 trampoline stack.
That's why the boundary is calculated from the lowest_stack.

>> +
>> +#ifdef CONFIG_STACKLEAK_METRICS
>> +	current->thread.prev_lowest_stack = p;
>> +#endif
>> +
>> +	/*
>> +	 * So let's write the poison value to the kernel stack.
>> +	 * Start from the address in p and move up till the new boundary.
>> +	 */
>> +	boundary = current_stack_pointer;
> 
> I worry a little that the compiler can move the SP during a function's
> lifetime, but maybe that's only the case when there are VLAs, or something like
> that?

Oh, I don't know.

However, erase_kstack() doesn't call anything except simple inline functions.
And as I see from its disasm on x86, the local variables reside in registers.

>> +
>> +	BUG_ON(boundary - p >= THREAD_SIZE);
>> +
>> +	while (p < boundary) {
>> +		*(unsigned long *)p = STACKLEAK_POISON;
>> +		p += sizeof(unsigned long);
>> +	}
>> +
>> +	/* Reset the lowest_stack value for the next syscall */
>> +	current->thread.lowest_stack = current_stack_pointer;

Laura, that might be wrong and introduce huge performance impact.

I think, lowest_stack should be reset similarly to the original version.

>> +}
> 
> Once this function returns, its data is left on the stack. Is that not a problem?
> 
> No strong feelings either way, but it might be worth mentioning in the commit
> message.

I managed to bypass that with "register" specifier. Although it doesn't give an
absolute guarantee.

>> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
>> index f08a2ed9db0d..156fa0a0da19 100644
>> --- a/arch/arm64/kernel/process.c
>> +++ b/arch/arm64/kernel/process.c
>> @@ -364,6 +364,9 @@ int copy_thread(unsigned long clone_flags, unsigned long stack_start,
>>  	p->thread.cpu_context.pc = (unsigned long)ret_from_fork;
>>  	p->thread.cpu_context.sp = (unsigned long)childregs;
>>  
>> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
>> +	p->thread.lowest_stack = (unsigned long)task_stack_page(p);
> 
> Nit: end_of_stack(p) would be slightly better semantically, even though
> currently equivalent to task_stack_page(p).

Thanks, I agree, I'll fix it in v12.

> [...]
> 
>> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
>> +void __used check_alloca(unsigned long size)
>> +{
>> +	unsigned long sp, stack_left;
>> +
>> +	sp = current_stack_pointer;
>> +
>> +	stack_left = sp & (THREAD_SIZE - 1);
>> +	BUG_ON(stack_left < 256 || size >= stack_left - 256);
>> +}
> 
> Is this arbitrary, or is there something special about 256?
> 
> Even if this is arbitrary, can we give it some mnemonic?

It's just a reasonable number. We can introduce a macro for it.

>> +EXPORT_SYMBOL(check_alloca);
>> +#endif
>> diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
>> index a34e9290a699..25dd2a14560d 100644
>> --- a/drivers/firmware/efi/libstub/Makefile
>> +++ b/drivers/firmware/efi/libstub/Makefile
>> @@ -20,7 +20,8 @@ cflags-$(CONFIG_EFI_ARMSTUB)	+= -I$(srctree)/scripts/dtc/libfdt
>>  KBUILD_CFLAGS			:= $(cflags-y) -DDISABLE_BRANCH_PROFILING \
>>  				   -D__NO_FORTIFY \
>>  				   $(call cc-option,-ffreestanding) \
>> -				   $(call cc-option,-fno-stack-protector)
>> +				   $(call cc-option,-fno-stack-protector) \
>> +				   $(DISABLE_STACKLEAK_PLUGIN)
>>  
>>  GCOV_PROFILE			:= n
>>  KASAN_SANITIZE			:= n
> 
> I believe we'll also need to do this for the KVM hyp code in arch/arm64/kvm/hyp/.

Could you please give more details on that? Why STACKLEAK breaks it?

Thanks a lot!

Best regards,
Alexander
