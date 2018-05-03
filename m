Date: Thu, 3 May 2018 08:19:18 +0100
From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 2/2] arm64: Clear the stack
Message-ID: <20180503071917.xm2xvgagvzkworay@salmiak>
References: <20180502203326.9491-1-labbott@redhat.com>
 <20180502203326.9491-3-labbott@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180502203326.9491-3-labbott@redhat.com>
To: Laura Abbott <labbott@redhat.com>
Cc: Alexander Popov <alex.popov@linux.com>, Kees Cook <keescook@chromium.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi Laura,

On Wed, May 02, 2018 at 01:33:26PM -0700, Laura Abbott wrote:
> 
> Implementation of stackleak based heavily on the x86 version
> 
> Signed-off-by: Laura Abbott <labbott@redhat.com>
> ---
> Now written in C instead of a bunch of assembly.

This looks neat!

I have a few minor comments below.

> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
> index bf825f38d206..0ceea613c65b 100644
> --- a/arch/arm64/kernel/Makefile
> +++ b/arch/arm64/kernel/Makefile
> @@ -55,6 +55,9 @@ arm64-reloc-test-y := reloc_test_core.o reloc_test_syms.o
>  arm64-obj-$(CONFIG_CRASH_DUMP)		+= crash_dump.o
>  arm64-obj-$(CONFIG_ARM_SDE_INTERFACE)	+= sdei.o
>  
> +arm64-obj-$(CONFIG_GCC_PLUGIN_STACKLEAK) += erase.o
> +KASAN_SANITIZE_erase.o	:= n

I suspect we want to avoid the full set of instrumentation suspects here, e.g.
GKOV, KASAN, UBSAN, and KCOV.

> +
>  obj-y					+= $(arm64-obj-y) vdso/ probes/
>  obj-m					+= $(arm64-obj-m)
>  head-y					:= head.o
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index ec2ee720e33e..3144f1ebdc18 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -401,6 +401,11 @@ tsk	.req	x28		// current thread_info
>  
>  	.text
>  
> +	.macro	ERASE_KSTACK
> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> +	bl	erase_kstack
> +#endif
> +	.endm

Nit: The rest of our asm macros are lower-case -- can we stick to that here?

>  /*
>   * Exception vectors.
>   */
> @@ -906,6 +911,7 @@ ret_to_user:
>  	cbnz	x2, work_pending
>  finish_ret_to_user:
>  	enable_step_tsk x1, x2
> +	ERASE_KSTACK
>  	kernel_exit 0
>  ENDPROC(ret_to_user)

I believe we also need this in ret_fast_syscall.

[...]

> +asmlinkage void erase_kstack(void)
> +{
> +	unsigned long p = current->thread.lowest_stack;
> +	unsigned long boundary = p & ~(THREAD_SIZE - 1);
> +	unsigned long poison = 0;
> +	const unsigned long check_depth = STACKLEAK_POISON_CHECK_DEPTH /
> +							sizeof(unsigned long);
> +
> +	/*
> +	 * Let's search for the poison value in the stack.
> +	 * Start from the lowest_stack and go to the bottom.
> +	 */
> +	while (p > boundary && poison <= check_depth) {
> +		if (*(unsigned long *)p == STACKLEAK_POISON)
> +			poison++;
> +		else
> +			poison = 0;
> +
> +		p -= sizeof(unsigned long);
> +	}
> +
> +	/*
> +	 * One long int at the bottom of the thread stack is reserved and
> +	 * should not be poisoned (see CONFIG_SCHED_STACK_END_CHECK).
> +	 */
> +	if (p == boundary)
> +		p += sizeof(unsigned long);

I wonder if end_of_stack() should be taught about CONFIG_SCHED_STACK_END_CHECK,
given that's supposed to return the last *usable* long on the stack, and we
don't account for this elsewhere.

If we did, then IIUC we could do:

	unsigned long boundary = (unsigned long)end_of_stack(current);

... at the start of the function, and not have to worry about this explicitly.

> +
> +#ifdef CONFIG_STACKLEAK_METRICS
> +	current->thread.prev_lowest_stack = p;
> +#endif
> +
> +	/*
> +	 * So let's write the poison value to the kernel stack.
> +	 * Start from the address in p and move up till the new boundary.
> +	 */
> +	boundary = current_stack_pointer;

I worry a little that the compiler can move the SP during a function's
lifetime, but maybe that's only the case when there are VLAs, or something like
that?

> +
> +	BUG_ON(boundary - p >= THREAD_SIZE);
> +
> +	while (p < boundary) {
> +		*(unsigned long *)p = STACKLEAK_POISON;
> +		p += sizeof(unsigned long);
> +	}
> +
> +	/* Reset the lowest_stack value for the next syscall */
> +	current->thread.lowest_stack = current_stack_pointer;
> +}

Once this function returns, its data is left on the stack. Is that not a problem?

No strong feelings either way, but it might be worth mentioning in the commit
message.

> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
> index f08a2ed9db0d..156fa0a0da19 100644
> --- a/arch/arm64/kernel/process.c
> +++ b/arch/arm64/kernel/process.c
> @@ -364,6 +364,9 @@ int copy_thread(unsigned long clone_flags, unsigned long stack_start,
>  	p->thread.cpu_context.pc = (unsigned long)ret_from_fork;
>  	p->thread.cpu_context.sp = (unsigned long)childregs;
>  
> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> +	p->thread.lowest_stack = (unsigned long)task_stack_page(p);

Nit: end_of_stack(p) would be slightly better semantically, even though
currently equivalent to task_stack_page(p).

[...]

> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> +void __used check_alloca(unsigned long size)
> +{
> +	unsigned long sp, stack_left;
> +
> +	sp = current_stack_pointer;
> +
> +	stack_left = sp & (THREAD_SIZE - 1);
> +	BUG_ON(stack_left < 256 || size >= stack_left - 256);
> +}

Is this arbitrary, or is there something special about 256?

Even if this is arbitrary, can we give it some mnemonic?

> +EXPORT_SYMBOL(check_alloca);
> +#endif
> diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
> index a34e9290a699..25dd2a14560d 100644
> --- a/drivers/firmware/efi/libstub/Makefile
> +++ b/drivers/firmware/efi/libstub/Makefile
> @@ -20,7 +20,8 @@ cflags-$(CONFIG_EFI_ARMSTUB)	+= -I$(srctree)/scripts/dtc/libfdt
>  KBUILD_CFLAGS			:= $(cflags-y) -DDISABLE_BRANCH_PROFILING \
>  				   -D__NO_FORTIFY \
>  				   $(call cc-option,-ffreestanding) \
> -				   $(call cc-option,-fno-stack-protector)
> +				   $(call cc-option,-fno-stack-protector) \
> +				   $(DISABLE_STACKLEAK_PLUGIN)
>  
>  GCOV_PROFILE			:= n
>  KASAN_SANITIZE			:= n

I believe we'll also need to do this for the KVM hyp code in arch/arm64/kvm/hyp/.

Thanks,
Mark.
