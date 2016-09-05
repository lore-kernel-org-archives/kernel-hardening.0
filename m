Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 5 Sep 2016 18:20:38 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160905172038.GC27305@leverpostej>
References: <1472828533-28197-1-git-send-email-catalin.marinas@arm.com>
 <1472828533-28197-4-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1472828533-28197-4-git-send-email-catalin.marinas@arm.com>
Subject: [kernel-hardening] Re: [PATCH v2 3/7] arm64: Introduce uaccess_{disable, enable}
 functionality based on TTBR0_EL1
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, AKASHI Takahiro <takahiro.akashi@linaro.org>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Catalin,

On Fri, Sep 02, 2016 at 04:02:09PM +0100, Catalin Marinas wrote:
> This patch adds the uaccess macros/functions to disable access to user
> space by setting TTBR0_EL1 to a reserved zeroed page. Since the value
> written to TTBR0_EL1 must be a physical address, for simplicity this
> patch introduces a reserved_ttbr0 page at a constant offset from
> swapper_pg_dir. The uaccess_disable code uses the ttbr1_el1 value
> adjusted by the reserved_ttbr0 offset.
> 
> Enabling access to user is done by restoring TTBR0_EL1 with the value
> from the struct thread_info ttbr0 variable. Interrupts must be disabled
> during the uaccess_ttbr0_enable code to ensure the atomicity of the
> thread_info.ttbr0 read and TTBR0_EL1 write.

[...]

>  /*
> + * Return the current thread_info.
> + */
> +	.macro	get_thread_info, rd
> +	mrs	\rd, sp_el0
> +	.endm

It may be worth noting in the commit message that we had to factor this
out of entry.S, or doing that as a preparatory patch.

> +/*
>   * Errata workaround post TTBR0_EL1 update.
>   */
>  	.macro	post_ttbr0_update_workaround, ret = 0
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index 7099f26e3702..023066d9bf7f 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -216,6 +216,12 @@ static inline bool system_supports_mixed_endian_el0(void)
>  	return id_aa64mmfr0_mixed_endian_el0(read_system_reg(SYS_ID_AA64MMFR0_EL1));
>  }
>  
> +static inline bool system_supports_ttbr0_pan(void)
> +{
> +	return IS_ENABLED(CONFIG_ARM64_TTBR0_PAN) &&
> +		!cpus_have_cap(ARM64_HAS_PAN);
> +}
> +

Nit: s/supports/uses/ would be clearer.

[...]

> +#ifdef CONFIG_ARM64_TTBR0_PAN
> +#define RESERVED_TTBR0_SIZE	(PAGE_SIZE)
> +#else
> +#define RESERVED_TTBR0_SIZE	(0)
> +#endif

I was going to suggest that we use the empty_zero_page, which we can
address with an adrp, because I had forgotten that we need to generate
the *physical* address.

It would be good if we could have a description of why we need the new
reserved page somewhere in the code. I'm sure I won't be the only one
tripped up by this.

It would be possible to use the existing empty_zero_page, if we're happy
to have a MOVZ; MOVK; MOVK; MOVK sequence that we patch at boot-time.
That could be faster than an MRS on some implementations.

We don't (yet) have infrastructure for that, though.

[...]

> +static inline void uaccess_ttbr0_enable(void)
> +{
> +	unsigned long flags;
> +
> +	/*
> +	 * Disable interrupts to avoid preemption and potential saved
> +	 * TTBR0_EL1 updates between reading the variable and the MSR.
> +	 */
> +	local_irq_save(flags);
> +	write_sysreg(current_thread_info()->ttbr0, ttbr0_el1);
> +	isb();
> +	local_irq_restore(flags);
> +}

I don't follow what problem this actually protects us against. In the
case of preemption everything should be saved+restored transparently, or
things would go wrong as soon as we enable IRQs anyway.

Is this a hold-over from a percpu approach rather than the
current_thread_info() approach?

What am I missing?

> +#else
> +static inline void uaccess_ttbr0_disable(void)
> +{
> +}
> +
> +static inline void uaccess_ttbr0_enable(void)
> +{
> +}
> +#endif

I think that it's better to drop the ifdef and add:

	if (!IS_ENABLED(CONFIG_ARM64_TTBR0_PAN))
		return;

... at the start of each function. GCC should optimize the entire thing
away when not used, but we'll get compiler coverage regardless, and
therefore less breakage. All the symbols we required should exist
regardless.

[...]

>  	.macro	uaccess_enable, tmp1, tmp2
> +#ifdef CONFIG_ARM64_TTBR0_PAN
> +alternative_if_not ARM64_HAS_PAN
> +	save_and_disable_irq \tmp2		// avoid preemption
> +	uaccess_ttbr0_enable \tmp1
> +	restore_irq \tmp2
> +alternative_else
> +	nop
> +	nop
> +	nop
> +	nop
> +	nop
> +	nop
> +	nop
> +alternative_endif
> +#endif

How about something like:

	.macro alternative_endif_else_nop
	alternative_else
	.rept ((662b-661b) / 4)
	       nop
	.endr
	alternative_endif
	.endm

So for the above we could have:

	alternative_if_not ARM64_HAS_PAN
		save_and_disable_irq \tmp2
		uaccess_ttbr0_enable \tmp1
		restore_irq \tmp2
	alternative_endif_else_nop

I'll see about spinning a patch, or discovering why that happens to be
broken.

[...]

>  	 * tables again to remove any speculatively loaded cache lines.
>  	 */
>  	mov	x0, x25
> -	add	x1, x26, #SWAPPER_DIR_SIZE
> +	add	x1, x26, #SWAPPER_DIR_SIZE + RESERVED_TTBR0_SIZE
>  	dmb	sy
>  	bl	__inval_cache_range
>  
> diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
> index 659963d40bb4..fe393ccf9352 100644
> --- a/arch/arm64/kernel/vmlinux.lds.S
> +++ b/arch/arm64/kernel/vmlinux.lds.S
> @@ -196,6 +196,11 @@ SECTIONS
>  	swapper_pg_dir = .;
>  	. += SWAPPER_DIR_SIZE;
>  
> +#ifdef CONFIG_ARM64_TTBR0_PAN
> +	reserved_ttbr0 = .;
> +	. += PAGE_SIZE;
> +#endif

Surely RESERVED_TTBR0_SIZE, as elsewhere?

Thanks,
Mark.
