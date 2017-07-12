Date: Wed, 12 Jul 2017 23:59:38 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170712225937.GA25816@leverpostej>
References: <20170712144424.19528-1-ard.biesheuvel@linaro.org>
 <20170712144424.19528-11-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170712144424.19528-11-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] Re: [RFC PATCH 10/10] arm64: kernel: add support for virtually
 mapped stacks
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, labbott@fedoraproject.org, will.deacon@arm.com, dave.martin@arm.com, catalin.marinas@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jul 12, 2017 at 03:44:23PM +0100, Ard Biesheuvel wrote:
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index 2ba3185b1c78..4c3e82d6e2f2 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -392,6 +392,20 @@ ENDPROC(el1_error_invalid)
>   */
>  	.align	6
>  el1_sync:
> +#ifdef CONFIG_VMAP_STACK
> +	/*
> +	 * When taking an exception from EL1, we need to check whether it is
> +	 * caused by a faulting out-of-bounds access to the virtually mapped
> +	 * stack before we can attempt to preserve the interrupted context.
> +	 */
> +	msr	tpidrro_el0, x0			// stash x0
> +	mrs	x0, far_el1			// get faulting address
> +	tbnz	x0, #63, .Lcheck_stack_ovf	// check if not user address

One thing I don't like about this is that we're reading FAR_EL1 even
though we don't know whether it's valid. It could contain junk, and we
could spuriously jump into the slow path. That's liable to make
performance erratic.

Given we have to stash a GPR anyway, we can check whether the SP is
valid in the fast-path, and that should be the only check we require. I
think we can also get rid of the overflow heuristic by checking that the
SP is strictly in the THREAD_SIZE stack area.

[...]

> @@ -234,6 +239,10 @@ static void __do_kernel_fault(unsigned long addr, unsigned int esr,
>  	 */
>  	if (addr >= (u64)current->stack - PAGE_SIZE &&
>  	    addr < (u64)current->stack) {
> +
> +		/* fix up regs->sp, we stashed the faulting value in sp_el0 */
> +		regs->sp = read_sysreg(sp_el0);
> +

This also seems a bit "magic", as we're relying on what the entry asm
will have done in a very specific case.

Thanks,
Mark.
