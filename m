Date: Mon, 14 Aug 2017 18:25:09 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170814172509.GD23428@leverpostej>
References: <1502130965-18710-1-git-send-email-mark.rutland@arm.com>
 <1502130965-18710-15-git-send-email-mark.rutland@arm.com>
 <20170814153253.GA22747@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170814153253.GA22747@arm.com>
Subject: [kernel-hardening] Re: [PATCH 14/14] arm64: add VMAP_STACK overflow detection
To: Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org, catalin.marinas@arm.com, james.morse@arm.com, labbott@redhat.com, linux-kernel@vger.kernel.org, luto@amacapital.net, matt@codeblueprint.co.uk, kernel-hardening@lists.openwall.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 14, 2017 at 04:32:53PM +0100, Will Deacon wrote:
> Just some minor comments on this (after taking ages to realise you were
> using tpidr_el0 as a temporary rather than tpidr_el1 and getting totally
> confused!).
> 
> On Mon, Aug 07, 2017 at 07:36:05PM +0100, Mark Rutland wrote:

> > +static inline bool on_overflow_stack(unsigned long sp)
> > +{
> > +	unsigned long low = (unsigned long)this_cpu_ptr(overflow_stack);
> 
> Can you use raw_cpu_ptr here, like you do for the irq stack?

Sure; done.

> > diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> > index e5aa866..44a27c3 100644
> > --- a/arch/arm64/kernel/entry.S
> > +++ b/arch/arm64/kernel/entry.S
> > @@ -72,6 +72,37 @@
> >  	.macro kernel_ventry	label
> >  	.align 7
> >  	sub	sp, sp, #S_FRAME_SIZE
> > +#ifdef CONFIG_VMAP_STACK
> > +	add	sp, sp, x0			// sp' = sp + x0
> > +	sub	x0, sp, x0			// x0' = sp' - x0 = (sp + x0) - x0 = sp
> > +	tbnz	x0, #THREAD_SHIFT, 0f
> > +	sub	x0, sp, x0			// sp' - x0' = (sp + x0) - sp = x0
> > +	sub	sp, sp, x0			// sp' - x0 = (sp + x0) - x0 = sp
> > +	b	\label
> > +
> > +	/* Stash the original SP value in tpidr_el0 */
> > +0:	msr	tpidr_el0, x0
> 
> The comment here is a bit confusing, since the sp has already been
> decremented for the frame, as mention in a later comment.

True. I've updated the comment to say:

	/*
	 * Stash the SP (minus S_FRAME_SIZE) in tpidr_el0. We can recover the
	 * original SP value later if we need it.
	 */  

[...]

> > +	 * Store the original GPRs to the new stack. The orginial SP (minus
> 
> original

Took me a moment to spot the second instance. Fixed now.

[...]

> > +	/* Time to die */
> > +	bl	handle_bad_stack
> > +	ASM_BUG()
> 
> Why not just a b without the ASM_BUG?

We need the BL to ensure that the LR is valid for unwinding. That's
necessary for the backtrace to identify the exception regs based on the
LR falling into .entry.text.

The ASM_BUG() ensures that the LR value definitely falls in .entry.text,
and makes the backtrace resolve the symbol correctly regardless of
what's next.

I didn't add a comment for the other cases, so I hadn't bothered here.
I'm happy to add those, so long as we're consistent.

Thanks,
Mark.
