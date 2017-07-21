Date: Fri, 21 Jul 2017 18:05:09 +0100
From: Dave Martin <Dave.Martin@arm.com>
Message-ID: <20170721170509.GC1538@e103592.cambridge.arm.com>
References: <1500480092-28480-1-git-send-email-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1500480092-28480-1-git-send-email-mark.rutland@arm.com>
Subject: [kernel-hardening] Re: [PATCH 00/11] ARMv8.3 pointer authentication userspace support
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, arnd@arndb.de, jiong.wang@arm.com, marc.zyngier@arm.com, catalin.marinas@arm.com, yao.qi@arm.com, suzuki.poulose@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jul 19, 2017 at 05:01:21PM +0100, Mark Rutland wrote:
> This series adds support for the ARMv8.3 pointer authentication extension.
> 
> Since RFC [1]:
> * Make the KVM context switch (semi-lazy)
> * Rebase to v4.13-rc1
> * Improve pointer authentication documentation
> * Add hwcap documentation
> * Various minor cleanups
> 
> I've pushed the series to the arm64/pointer-auth branch [2] of my linux tree.
> I've also pushed out a necessary bootwrapper patch to the pointer-auth branch
> [3] of my bootwrapper repo.

[...]

> Open questions
> ==============
> 
> * Should keys be per-thread rather than per-process?
> 
>   My understanding is that glibc can't (currently) handle threads having
>   different keys, but it might be that another libc would prefer per-thread

Can you elaborate?

It's not valid to do a function return from one thread to another.

>   keys. If desired, we could add a mechanism for a thread to re-initialize its
>   keys without an exec*().

Switching from per-process to per-thread keys would be an ABI break
unless it's opt-in.

> * Do we need a separate hwcap for XPAC* instructions?
> 
>   Library code performing stack unwinding may need to interoperate with other
>   code which may or may not be using pointer authentication. It may be
>   desirable to use XPAC* rather than attempting authentication and/or acquiring
>   the PAC masks via ptrace.
> 
>   As we may expose APIBKey (potentially separately from APIAKey) in future,
>   HWCAP_APIA cannot be used to determine when these instruction can/should be
>   used.

Can the availability of XPAC* be determined from the feature regs, or
is that insufficient?

This is a little different from the keys, which the kernel must
provision / allow to be set in order for them to be useful.

> * Should we expose a per-process data key now, to go with the insn key?
> 
>   I don't currently have a use-case for this.
> 
> * Should we expose generic authentication (i.e. APGAKey)?
> 
>   I don't currently have a use-case for this.

I guess there's no ABI impact for adding these later, so maybe it's not
urgent if nobody shouts.

> * Should the kernel remove PACs when unwinding user stacks?
> 
>   This is simple to do, but it's arguably placing a policy in the kernel as to
>   what we expect user stacks to look like. Regardless, userspace will have to
>   perform this when unwinding with DWARF.

Not sure.  This is arguably not more gross than related things the
kernel already does, and may be inefficient for userspace to do e.g.,
when capturing perf backtraces.  Still gross though.

Side question: do you know whether there will be DWARF / ELF annotations
for this?  Since ptr auth is a compile-time option, it is plausible that
an attribute could be added to indicate that an image uses it.

Cheers
---Dave
