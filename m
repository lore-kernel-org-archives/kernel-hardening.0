Subject: Re: [PATCH 2/2] arm64: Clear the stack
References: <20180502203326.9491-1-labbott@redhat.com>
 <20180502203326.9491-3-labbott@redhat.com>
 <20180503071917.xm2xvgagvzkworay@salmiak>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <a8ce3e4d-f0f3-1321-92af-9aed0097d205@redhat.com>
Date: Thu, 3 May 2018 12:00:26 -0700
MIME-Version: 1.0
In-Reply-To: <20180503071917.xm2xvgagvzkworay@salmiak>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Mark Rutland <mark.rutland@arm.com>
Cc: Alexander Popov <alex.popov@linux.com>, Kees Cook <keescook@chromium.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 05/03/2018 12:19 AM, Mark Rutland wrote:
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
>>   arm64-obj-$(CONFIG_CRASH_DUMP)		+= crash_dump.o
>>   arm64-obj-$(CONFIG_ARM_SDE_INTERFACE)	+= sdei.o
>>   
>> +arm64-obj-$(CONFIG_GCC_PLUGIN_STACKLEAK) += erase.o
>> +KASAN_SANITIZE_erase.o	:= n
> 
> I suspect we want to avoid the full set of instrumentation suspects here, e.g.
> GKOV, KASAN, UBSAN, and KCOV.
> 
>> +
>>   obj-y					+= $(arm64-obj-y) vdso/ probes/
>>   obj-m					+= $(arm64-obj-m)
>>   head-y					:= head.o
>> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
>> index ec2ee720e33e..3144f1ebdc18 100644
>> --- a/arch/arm64/kernel/entry.S
>> +++ b/arch/arm64/kernel/entry.S
>> @@ -401,6 +401,11 @@ tsk	.req	x28		// current thread_info
>>   
>>   	.text
>>   
>> +	.macro	ERASE_KSTACK
>> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
>> +	bl	erase_kstack
>> +#endif
>> +	.endm
> 
> Nit: The rest of our asm macros are lower-case -- can we stick to that here?
> 
>>   /*
>>    * Exception vectors.
>>    */
>> @@ -906,6 +911,7 @@ ret_to_user:
>>   	cbnz	x2, work_pending
>>   finish_ret_to_user:
>>   	enable_step_tsk x1, x2
>> +	ERASE_KSTACK
>>   	kernel_exit 0
>>   ENDPROC(ret_to_user)
> 
> I believe we also need this in ret_fast_syscall.
> 
> [...]
> 

Yeah I had this in previous versions but I managed to out think
myself. I'll add it in with a comment to avoid confusion.

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
> 
> If we did, then IIUC we could do:
> 
> 	unsigned long boundary = (unsigned long)end_of_stack(current);
> 
> ... at the start of the function, and not have to worry about this explicitly.
> 
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
> 

I think that's true and a risk we take writing this in C. Here's
the disassembly on gcc-7.3.1:

ffff00000809d4d8 <erase_kstack>:
ffff00000809d4d8:       a9bf7bfd        stp     x29, x30, [sp, #-16]!
ffff00000809d4dc:       d5384100        mrs     x0, sp_el0
ffff00000809d4e0:       910003fd        mov     x29, sp
ffff00000809d4e4:       f946e400        ldr     x0, [x0, #3528]
ffff00000809d4e8:       9272c404        and     x4, x0, #0xffffffffffffc000
ffff00000809d4ec:       eb04001f        cmp     x0, x4
ffff00000809d4f0:       540002c9        b.ls    ffff00000809d548 <erase_kstack+0x70>  // b.plast
ffff00000809d4f4:       d2800003        mov     x3, #0x0                        // #0
ffff00000809d4f8:       9297ddc5        mov     x5, #0xffffffffffff4111         // #-48879
ffff00000809d4fc:       14000008        b       ffff00000809d51c <erase_kstack+0x44>
ffff00000809d500:       d1002000        sub     x0, x0, #0x8
ffff00000809d504:       52800022        mov     w2, #0x1                        // #1
ffff00000809d508:       eb00009f        cmp     x4, x0
ffff00000809d50c:       d2800003        mov     x3, #0x0                        // #0
ffff00000809d510:       1a9f27e1        cset    w1, cc  // cc = lo, ul, last
ffff00000809d514:       6a01005f        tst     w2, w1
ffff00000809d518:       54000180        b.eq    ffff00000809d548 <erase_kstack+0x70>  // b.none
ffff00000809d51c:       f9400001        ldr     x1, [x0]
ffff00000809d520:       eb05003f        cmp     x1, x5
ffff00000809d524:       54fffee1        b.ne    ffff00000809d500 <erase_kstack+0x28>  // b.any
ffff00000809d528:       91000463        add     x3, x3, #0x1
ffff00000809d52c:       d1002000        sub     x0, x0, #0x8
ffff00000809d530:       f100407f        cmp     x3, #0x10
ffff00000809d534:       1a9f87e2        cset    w2, ls  // ls = plast
ffff00000809d538:       eb00009f        cmp     x4, x0
ffff00000809d53c:       1a9f27e1        cset    w1, cc  // cc = lo, ul, last
ffff00000809d540:       6a01005f        tst     w2, w1
ffff00000809d544:       54fffec1        b.ne    ffff00000809d51c <erase_kstack+0x44>  // b.any
ffff00000809d548:       eb00009f        cmp     x4, x0
ffff00000809d54c:       91002001        add     x1, x0, #0x8
ffff00000809d550:       9a800020        csel    x0, x1, x0, eq  // eq = none
ffff00000809d554:       910003e1        mov     x1, sp
ffff00000809d558:       d5384102        mrs     x2, sp_el0
ffff00000809d55c:       f906e840        str     x0, [x2, #3536]
ffff00000809d560:       cb000023        sub     x3, x1, x0
ffff00000809d564:       d287ffe2        mov     x2, #0x3fff                     // #16383
ffff00000809d568:       eb02007f        cmp     x3, x2
ffff00000809d56c:       540001a8        b.hi    ffff00000809d5a0 <erase_kstack+0xc8>  // b.pmore
ffff00000809d570:       9297ddc2        mov     x2, #0xffffffffffff4111         // #-48879
ffff00000809d574:       eb01001f        cmp     x0, x1
ffff00000809d578:       54000082        b.cs    ffff00000809d588 <erase_kstack+0xb0>  // b.hs, b.nlast
ffff00000809d57c:       f8008402        str     x2, [x0], #8
ffff00000809d580:       eb00003f        cmp     x1, x0
ffff00000809d584:       54ffffc8        b.hi    ffff00000809d57c <erase_kstack+0xa4>  // b.pmore
ffff00000809d588:       910003e1        mov     x1, sp
ffff00000809d58c:       d5384100        mrs     x0, sp_el0
ffff00000809d590:       f906e401        str     x1, [x0, #3528]
ffff00000809d594:       a8c17bfd        ldp     x29, x30, [sp], #16
ffff00000809d598:       d65f03c0        ret
ffff00000809d59c:       d503201f        nop
ffff00000809d5a0:       d4210000        brk     #0x800
ffff00000809d5a4:       00000000        .inst   0x00000000 ; undefined

It looks to be okay although admittedly that's subject to compiler
whims. It might be safer to save the stack pointer almost as soon as
we get into the function and use that?

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
>> +}
> 
> Once this function returns, its data is left on the stack. Is that not a problem?
> 
> No strong feelings either way, but it might be worth mentioning in the commit
> message.
> 
>> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
>> index f08a2ed9db0d..156fa0a0da19 100644
>> --- a/arch/arm64/kernel/process.c
>> +++ b/arch/arm64/kernel/process.c
>> @@ -364,6 +364,9 @@ int copy_thread(unsigned long clone_flags, unsigned long stack_start,
>>   	p->thread.cpu_context.pc = (unsigned long)ret_from_fork;
>>   	p->thread.cpu_context.sp = (unsigned long)childregs;
>>   
>> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
>> +	p->thread.lowest_stack = (unsigned long)task_stack_page(p);
> 
> Nit: end_of_stack(p) would be slightly better semantically, even though
> currently equivalent to task_stack_page(p).
> 
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
> 
>> +EXPORT_SYMBOL(check_alloca);
>> +#endif
>> diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
>> index a34e9290a699..25dd2a14560d 100644
>> --- a/drivers/firmware/efi/libstub/Makefile
>> +++ b/drivers/firmware/efi/libstub/Makefile
>> @@ -20,7 +20,8 @@ cflags-$(CONFIG_EFI_ARMSTUB)	+= -I$(srctree)/scripts/dtc/libfdt
>>   KBUILD_CFLAGS			:= $(cflags-y) -DDISABLE_BRANCH_PROFILING \
>>   				   -D__NO_FORTIFY \
>>   				   $(call cc-option,-ffreestanding) \
>> -				   $(call cc-option,-fno-stack-protector)
>> +				   $(call cc-option,-fno-stack-protector) \
>> +				   $(DISABLE_STACKLEAK_PLUGIN)
>>   
>>   GCOV_PROFILE			:= n
>>   KASAN_SANITIZE			:= n
> 
> I believe we'll also need to do this for the KVM hyp code in arch/arm64/kvm/hyp/.
> 
> Thanks,
> Mark.
> 

Thanks,
Laura
