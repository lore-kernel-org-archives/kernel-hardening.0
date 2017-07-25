Date: Tue, 25 Jul 2017 13:06:43 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170725120630.GA8116@leverpostej>
References: <1500480092-28480-1-git-send-email-mark.rutland@arm.com>
 <20170721170509.GC1538@e103592.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170721170509.GC1538@e103592.cambridge.arm.com>
Subject: [kernel-hardening] Re: [PATCH 00/11] ARMv8.3 pointer authentication userspace support
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, arnd@arndb.de, jiong.wang@arm.com, marc.zyngier@arm.com, catalin.marinas@arm.com, yao.qi@arm.com, suzuki.poulose@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jul 21, 2017 at 06:05:09PM +0100, Dave Martin wrote:
> On Wed, Jul 19, 2017 at 05:01:21PM +0100, Mark Rutland wrote:
> > This series adds support for the ARMv8.3 pointer authentication extension.

> > Open questions
> > ==============
> > 
> > * Should keys be per-thread rather than per-process?
> > 
> >   My understanding is that glibc can't (currently) handle threads having
> >   different keys, but it might be that another libc would prefer per-thread
> 
> Can you elaborate?
> 
> It's not valid to do a function return from one thread to another.

Regardless of whether it's valid per the C spec or POSIX, some people
use {set,get}context and {set,long}jmp in this manner (IIRC, QEMU does
this), and my understanding is that similar tricks are in use in the
bowels of glibc.

Otherwise, my preference would be to have per-thread keys from day one.

> >   keys. If desired, we could add a mechanism for a thread to re-initialize its
> >   keys without an exec*().
> 
> Switching from per-process to per-thread keys would be an ABI break
> unless it's opt-in.

Indeed, which is why I suggested an opt-in mechanism.

> > * Do we need a separate hwcap for XPAC* instructions?
> > 
> >   Library code performing stack unwinding may need to interoperate with other
> >   code which may or may not be using pointer authentication. It may be
> >   desirable to use XPAC* rather than attempting authentication and/or acquiring
> >   the PAC masks via ptrace.
> > 
> >   As we may expose APIBKey (potentially separately from APIAKey) in future,
> >   HWCAP_APIA cannot be used to determine when these instruction can/should be
> >   used.
> 
> Can the availability of XPAC* be determined from the feature regs, or
> is that insufficient?

I'd forgotten to fix up the id reg emulation to enable this, but this
should be sufficient when wired up.

The painful part is that there are several fields which can imply XPAC*
are present, so userspace has to remember to check all of those fields.

[...]

> > * Should the kernel remove PACs when unwinding user stacks?
> > 
> >   This is simple to do, but it's arguably placing a policy in the kernel as to
> >   what we expect user stacks to look like. Regardless, userspace will have to
> >   perform this when unwinding with DWARF.
> 
> Not sure.  This is arguably not more gross than related things the
> kernel already does, and may be inefficient for userspace to do e.g.,
> when capturing perf backtraces.  Still gross though.
> 
> Side question: do you know whether there will be DWARF / ELF annotations
> for this?  Since ptr auth is a compile-time option, it is plausible that
> an attribute could be added to indicate that an image uses it.

Jiong, Yao, can you answer this?

I think that there's DWARF metadata for unwinding, but I'm not sure
there's an ELF annotation on an image.

Note that you may link with libraries which may or may not use pointer
auth, so a single process can have a mixture of code using pointer auth,
and code which does not.

Thanks,
Mark.
