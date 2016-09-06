Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 6 Sep 2016 11:27:42 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
Message-ID: <20160906102741.GF19605@e104818-lin.cambridge.arm.com>
References: <1472828533-28197-1-git-send-email-catalin.marinas@arm.com>
 <1472828533-28197-4-git-send-email-catalin.marinas@arm.com>
 <20160905172038.GC27305@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160905172038.GC27305@leverpostej>
Subject: [kernel-hardening] Re: [PATCH v2 3/7] arm64: Introduce uaccess_{disable, enable}
 functionality based on TTBR0_EL1
To: Mark Rutland <mark.rutland@arm.com>
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Will Deacon <will.deacon@arm.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, James Morse <james.morse@arm.com>, linux-arm-kernel@lists.infradead.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Sep 05, 2016 at 06:20:38PM +0100, Mark Rutland wrote:
> On Fri, Sep 02, 2016 at 04:02:09PM +0100, Catalin Marinas wrote:
> > +#ifdef CONFIG_ARM64_TTBR0_PAN
> > +#define RESERVED_TTBR0_SIZE	(PAGE_SIZE)
> > +#else
> > +#define RESERVED_TTBR0_SIZE	(0)
> > +#endif
> 
> I was going to suggest that we use the empty_zero_page, which we can
> address with an adrp, because I had forgotten that we need to generate
> the *physical* address.
> 
> It would be good if we could have a description of why we need the new
> reserved page somewhere in the code. I'm sure I won't be the only one
> tripped up by this.
> 
> It would be possible to use the existing empty_zero_page, if we're happy
> to have a MOVZ; MOVK; MOVK; MOVK sequence that we patch at boot-time.
> That could be faster than an MRS on some implementations.

I was trying to keep the number of instructions to a minimum in
preference to potentially slightly faster sequence (I haven't done any
benchmarks). On ARMv8.1+ implementations, we just end up with more nops.

We could also do an ldr from a PC-relative address, it's one instruction
and it may not be (significantly) slower than MRS + ADD.

> > +static inline void uaccess_ttbr0_enable(void)
> > +{
> > +	unsigned long flags;
> > +
> > +	/*
> > +	 * Disable interrupts to avoid preemption and potential saved
> > +	 * TTBR0_EL1 updates between reading the variable and the MSR.
> > +	 */
> > +	local_irq_save(flags);
> > +	write_sysreg(current_thread_info()->ttbr0, ttbr0_el1);
> > +	isb();
> > +	local_irq_restore(flags);
> > +}
> 
> I don't follow what problem this actually protects us against. In the
> case of preemption everything should be saved+restored transparently, or
> things would go wrong as soon as we enable IRQs anyway.
> 
> Is this a hold-over from a percpu approach rather than the
> current_thread_info() approach?

If we get preempted between reading current_thread_info()->ttbr0 and
writing TTBR0_EL1, a series of context switches could lead to the update
of the ASID part of ttbr0. The actual MSR would store an old ASID in
TTBR0_EL1.

> > +#else
> > +static inline void uaccess_ttbr0_disable(void)
> > +{
> > +}
> > +
> > +static inline void uaccess_ttbr0_enable(void)
> > +{
> > +}
> > +#endif
> 
> I think that it's better to drop the ifdef and add:
> 
> 	if (!IS_ENABLED(CONFIG_ARM64_TTBR0_PAN))
> 		return;
> 
> ... at the start of each function. GCC should optimize the entire thing
> away when not used, but we'll get compiler coverage regardless, and
> therefore less breakage. All the symbols we required should exist
> regardless.

The reason for this is that thread_info.ttbr0 is conditionally defined.
I don't think the compiler would ignore it.

> >  	.macro	uaccess_enable, tmp1, tmp2
> > +#ifdef CONFIG_ARM64_TTBR0_PAN
> > +alternative_if_not ARM64_HAS_PAN
> > +	save_and_disable_irq \tmp2		// avoid preemption
> > +	uaccess_ttbr0_enable \tmp1
> > +	restore_irq \tmp2
> > +alternative_else
> > +	nop
> > +	nop
> > +	nop
> > +	nop
> > +	nop
> > +	nop
> > +	nop
> > +alternative_endif
> > +#endif
> 
> How about something like:
> 
> 	.macro alternative_endif_else_nop
> 	alternative_else
> 	.rept ((662b-661b) / 4)
> 	       nop
> 	.endr
> 	alternative_endif
> 	.endm
> 
> So for the above we could have:
> 
> 	alternative_if_not ARM64_HAS_PAN
> 		save_and_disable_irq \tmp2
> 		uaccess_ttbr0_enable \tmp1
> 		restore_irq \tmp2
> 	alternative_endif_else_nop
> 
> I'll see about spinning a patch, or discovering why that happens to be
> broken.

This looks better. Minor comment, I would actually name the ending
statement alternative_else_nop_endif to match the order in which you'd
normally write them.

> >  	 * tables again to remove any speculatively loaded cache lines.
> >  	 */
> >  	mov	x0, x25
> > -	add	x1, x26, #SWAPPER_DIR_SIZE
> > +	add	x1, x26, #SWAPPER_DIR_SIZE + RESERVED_TTBR0_SIZE
> >  	dmb	sy
> >  	bl	__inval_cache_range
> >  
> > diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
> > index 659963d40bb4..fe393ccf9352 100644
> > --- a/arch/arm64/kernel/vmlinux.lds.S
> > +++ b/arch/arm64/kernel/vmlinux.lds.S
> > @@ -196,6 +196,11 @@ SECTIONS
> >  	swapper_pg_dir = .;
> >  	. += SWAPPER_DIR_SIZE;
> >  
> > +#ifdef CONFIG_ARM64_TTBR0_PAN
> > +	reserved_ttbr0 = .;
> > +	. += PAGE_SIZE;
> > +#endif
> 
> Surely RESERVED_TTBR0_SIZE, as elsewhere?

I'll try to move it somewhere where it can be included in vmlinux.lds.S
(I can probably include cpufeature.h directly).

-- 
Catalin
