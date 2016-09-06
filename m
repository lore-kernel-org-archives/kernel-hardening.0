Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 6 Sep 2016 11:45:14 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160906104514.GC1425@leverpostej>
References: <1472828533-28197-1-git-send-email-catalin.marinas@arm.com>
 <1472828533-28197-4-git-send-email-catalin.marinas@arm.com>
 <20160905172038.GC27305@leverpostej>
 <20160906102741.GF19605@e104818-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160906102741.GF19605@e104818-lin.cambridge.arm.com>
Subject: [kernel-hardening] Re: [PATCH v2 3/7] arm64: Introduce uaccess_{disable, enable}
 functionality based on TTBR0_EL1
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Will Deacon <will.deacon@arm.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, James Morse <james.morse@arm.com>, linux-arm-kernel@lists.infradead.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Sep 06, 2016 at 11:27:42AM +0100, Catalin Marinas wrote:
> On Mon, Sep 05, 2016 at 06:20:38PM +0100, Mark Rutland wrote:
> > On Fri, Sep 02, 2016 at 04:02:09PM +0100, Catalin Marinas wrote:
> > > +static inline void uaccess_ttbr0_enable(void)
> > > +{
> > > +	unsigned long flags;
> > > +
> > > +	/*
> > > +	 * Disable interrupts to avoid preemption and potential saved
> > > +	 * TTBR0_EL1 updates between reading the variable and the MSR.
> > > +	 */
> > > +	local_irq_save(flags);
> > > +	write_sysreg(current_thread_info()->ttbr0, ttbr0_el1);
> > > +	isb();
> > > +	local_irq_restore(flags);
> > > +}
> > 
> > I don't follow what problem this actually protects us against. In the
> > case of preemption everything should be saved+restored transparently, or
> > things would go wrong as soon as we enable IRQs anyway.
> > 
> > Is this a hold-over from a percpu approach rather than the
> > current_thread_info() approach?
> 
> If we get preempted between reading current_thread_info()->ttbr0 and
> writing TTBR0_EL1, a series of context switches could lead to the update
> of the ASID part of ttbr0. The actual MSR would store an old ASID in
> TTBR0_EL1.

Ah! Can you fold something about racing with an ASID update into the
description?

> > > +#else
> > > +static inline void uaccess_ttbr0_disable(void)
> > > +{
> > > +}
> > > +
> > > +static inline void uaccess_ttbr0_enable(void)
> > > +{
> > > +}
> > > +#endif
> > 
> > I think that it's better to drop the ifdef and add:
> > 
> > 	if (!IS_ENABLED(CONFIG_ARM64_TTBR0_PAN))
> > 		return;
> > 
> > ... at the start of each function. GCC should optimize the entire thing
> > away when not used, but we'll get compiler coverage regardless, and
> > therefore less breakage. All the symbols we required should exist
> > regardless.
> 
> The reason for this is that thread_info.ttbr0 is conditionally defined.
> I don't think the compiler would ignore it.

Good point; I missed that.

[...]

> > How about something like:
> > 
> > 	.macro alternative_endif_else_nop
> > 	alternative_else
> > 	.rept ((662b-661b) / 4)
> > 	       nop
> > 	.endr
> > 	alternative_endif
> > 	.endm
> > 
> > So for the above we could have:
> > 
> > 	alternative_if_not ARM64_HAS_PAN
> > 		save_and_disable_irq \tmp2
> > 		uaccess_ttbr0_enable \tmp1
> > 		restore_irq \tmp2
> > 	alternative_endif_else_nop
> > 
> > I'll see about spinning a patch, or discovering why that happens to be
> > broken.
> 
> This looks better. Minor comment, I would actually name the ending
> statement alternative_else_nop_endif to match the order in which you'd
> normally write them.

Completely agreed. I already made this change locally, immediately after
sending the suggestion. :)

> > >  	 * tables again to remove any speculatively loaded cache lines.
> > >  	 */
> > >  	mov	x0, x25
> > > -	add	x1, x26, #SWAPPER_DIR_SIZE
> > > +	add	x1, x26, #SWAPPER_DIR_SIZE + RESERVED_TTBR0_SIZE
> > >  	dmb	sy
> > >  	bl	__inval_cache_range
> > >  
> > > diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
> > > index 659963d40bb4..fe393ccf9352 100644
> > > --- a/arch/arm64/kernel/vmlinux.lds.S
> > > +++ b/arch/arm64/kernel/vmlinux.lds.S
> > > @@ -196,6 +196,11 @@ SECTIONS
> > >  	swapper_pg_dir = .;
> > >  	. += SWAPPER_DIR_SIZE;
> > >  
> > > +#ifdef CONFIG_ARM64_TTBR0_PAN
> > > +	reserved_ttbr0 = .;
> > > +	. += PAGE_SIZE;
> > > +#endif
> > 
> > Surely RESERVED_TTBR0_SIZE, as elsewhere?
> 
> I'll try to move it somewhere where it can be included in vmlinux.lds.S
> (I can probably include cpufeature.h directly).

Our vmlinux.lds.S already includes <asm/kernel-pagetable.h>, so I think
that should work already.

Thanks,
Mark.
