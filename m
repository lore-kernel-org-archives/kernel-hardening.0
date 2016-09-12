Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 12 Sep 2016 17:26:23 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
Message-ID: <20160912162622.GD2492@e104818-lin.cambridge.arm.com>
References: <1472828533-28197-1-git-send-email-catalin.marinas@arm.com>
 <1472828533-28197-2-git-send-email-catalin.marinas@arm.com>
 <20160905153828.GA27305@leverpostej>
 <20160912145219.GC2492@e104818-lin.cambridge.arm.com>
 <20160912150958.GC14165@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160912150958.GC14165@leverpostej>
Subject: [kernel-hardening] Re: [PATCH v2 1/7] arm64: Factor out PAN enabling/disabling into
 separate uaccess_* macros
To: Mark Rutland <mark.rutland@arm.com>
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Will Deacon <will.deacon@arm.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, James Morse <james.morse@arm.com>, linux-arm-kernel@lists.infradead.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Sep 12, 2016 at 04:09:59PM +0100, Mark Rutland wrote:
> On Mon, Sep 12, 2016 at 03:52:19PM +0100, Catalin Marinas wrote:
> > On Mon, Sep 05, 2016 at 04:38:28PM +0100, Mark Rutland wrote:
> > > On Fri, Sep 02, 2016 at 04:02:07PM +0100, Catalin Marinas wrote:
> > > >  /*
> > > > + * User access enabling/disabling.
> > > > + */
> > > > +#define uaccess_disable(alt)						\
> > > > +do {									\
> > > > +	asm(ALTERNATIVE("nop", SET_PSTATE_PAN(1), alt,			\
> > > > +			CONFIG_ARM64_PAN));				\
> > > > +} while (0)
> > > > +
> > > > +#define uaccess_enable(alt)						\
> > > > +do {									\
> > > > +	asm(ALTERNATIVE("nop", SET_PSTATE_PAN(0), alt,			\
> > > > +			CONFIG_ARM64_PAN));				\
> > > > +} while (0)
> > > 
> > > Passing the alternative down is somewhat confusing. e.g. in the futex
> > > case it looks like we're only doing something when PAN is present,
> > > whereas we'll manipulate TTBR0 in the absence of PAN.
> > 
> > I agree it's confusing (I got it wrong first time as well and used the
> > wrong alternative for futex).
> > 
> > > If I've understood correctly, we need this to distinguish regular
> > > load/store uaccess sequences (eg. the futex code) from potentially
> > > patched unprivileged load/store sequences (e.g. {get,put}_user) when
> > > poking PSTATE.PAN.
> > > 
> > > So perhaps we could ahve something like:
> > > 
> > > * privileged_uaccess_{enable,disable}()
> > >   Which toggle TTBR0, or PAN (always).
> > >   These would handle cases like the futex/swp code.
> > >  
> > > * (unprivileged_)uaccess_{enable,disable}()
> > >   Which toggle TTBR0, or PAN (in the absence of UAO).
> > >   These would handle cases like the {get,put}_user sequences.
> > > 
> > > Though perhaps that is just as confusing. ;)
> > 
> > I find it more confusing. 
> 
> Fair enough. :)
> 
> > In the non-UAO case, get_user etc. would
> > normally have to use privileged_uaccess_enable() since ldr is not
> > replaced with ldtr. Maybe uaccess_enable_for_exclusives() but it doesn't
> > look any better. 
> 
> I strongly prefer uaccess_enable_exclusives(), or something of that sort
> to both of the above. ;)

I think we would need a few more uaccess_enable_* variants (cache
maintenance, Xen) which makes this impractical.

We can consider the PAN_NOT_UAO the special case and if we assume that
UAO also implies PAN (ARMv8.2), we can define uaccess_enable_not_uao()
for the get_user etc. cases. We would use uaccess_enable() for the rest.

-- 
Catalin
