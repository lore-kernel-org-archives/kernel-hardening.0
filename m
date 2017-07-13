Date: Thu, 13 Jul 2017 10:12:59 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170713091259.GA26194@leverpostej>
References: <20170712144424.19528-1-ard.biesheuvel@linaro.org>
 <20170712144424.19528-11-ard.biesheuvel@linaro.org>
 <20170712225937.GA25816@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170712225937.GA25816@leverpostej>
Subject: Re: [kernel-hardening] Re: [RFC PATCH 10/10] arm64: kernel: add
 support for virtually mapped stacks
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, labbott@fedoraproject.org, will.deacon@arm.com, dave.martin@arm.com, catalin.marinas@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jul 12, 2017 at 11:59:38PM +0100, Mark Rutland wrote:
> On Wed, Jul 12, 2017 at 03:44:23PM +0100, Ard Biesheuvel wrote:
> > diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> > index 2ba3185b1c78..4c3e82d6e2f2 100644
> > --- a/arch/arm64/kernel/entry.S
> > +++ b/arch/arm64/kernel/entry.S
> > @@ -392,6 +392,20 @@ ENDPROC(el1_error_invalid)
> >   */
> >  	.align	6
> >  el1_sync:
> > +#ifdef CONFIG_VMAP_STACK
> > +	/*
> > +	 * When taking an exception from EL1, we need to check whether it is
> > +	 * caused by a faulting out-of-bounds access to the virtually mapped
> > +	 * stack before we can attempt to preserve the interrupted context.
> > +	 */
> > +	msr	tpidrro_el0, x0			// stash x0
> > +	mrs	x0, far_el1			// get faulting address
> > +	tbnz	x0, #63, .Lcheck_stack_ovf	// check if not user address
> 
> One thing I don't like about this is that we're reading FAR_EL1 even
> though we don't know whether it's valid. It could contain junk, and we
> could spuriously jump into the slow path. That's liable to make
> performance erratic.

Once I sent this, I realised what I said wasn't quite right.

It's true that FAR_EL1 is UNKNOWN in some cases, but today those are all
fatal (e.g. if we take an UNDEFINED exception due to a bad instruction
at EL1).

So my performance concern was spurious; sorry for the noise.

However, so as to not mis-report those fatal cases, we either need to
inspect the SP or ESR_EL1 to determine that FAR_EL1 is valid and/or this
was a stack-overflow

If we follow the approach of this series, we can move those checks into
the check_stack_ovf slow path.

Thanks,
Mark.
