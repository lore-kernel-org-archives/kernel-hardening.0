Date: Tue, 27 Jun 2017 11:06:32 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170627100631.GA30002@leverpostej>
References: <CAGXu5jLCAdPOKZFotaWZ8MjwqW8Eq9_tLc_fgbYsTcbVWv77AQ@mail.gmail.com>
 <1498517551.22457.7.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1498517551.22457.7.camel@gmail.com>
Subject: Re: [kernel-hardening] non-x86 per-task stack canaries
To: Daniel Micay <danielmicay@gmail.com>
Cc: Kees Cook <keescook@google.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 26, 2017 at 06:52:31PM -0400, Daniel Micay wrote:
> On Mon, 2017-06-26 at 14:04 -0700, Kees Cook wrote:
> > Hi,
> > 
> > The stack protector functionality on x86_64 uses %gs:0x28 (%gs is the
> > percpu area) for __stack_chk_guard, and all other architectures use a
> > global variable instead. This means we never change the stack canary
> > on non-x86 architectures which allows for a leak in one task to expose
> > the canary in another task.

FWIW, I'd love to have per-task canaries on arm64.

> > I'm curious what thoughts people may have about how to get this
> > correctly implemented. Teaching the compiler about per-cpu data sounds
> > exciting. :)

On concern I'd have is that it's possible/likely that we'll want to
change the way we handle per-cpu offsets in future.

One specific reason is that we may need to shuffle the way we use
TPIDR_EL1 and SP_EL0 to allow us to implement stack overflow handling on
arm64 usnig EL1t mode.

It would be beneficial if we could somehow avoid baking this detail into
the compiler. For example, by having an inlinable callback to load the
canary, or adding the protection using a plugin that we control.

> arm64 has many integer registers so I don't think reserving one would
> hurt performance, especially in the kernel where hot numeric loops
> barely exist. 

A while back I did experiments with an ancient GCC, reserving single
GPRs with -ffixed. For a kernel compile workload, with said ancient GCC,
reserving the register had a small, but noisy impact.

With more recent GCCs it was much more noisy, and it looked like it was
liable to adversely affect performance.

We'd need numbers across a few GCC versions (and clang too, I guess).

> It would reduce the cost of SSP by getting rid of the memory read for
> the canary value. On the other hand, using per-cpu data would likely
> be higher cost than the global. x86 has segment registers but most
> archs probably need to do something more painful.

I had a prototype [1] that used the reserved GPR to hold the per-cpu
offset. That allow access to per-cpu data using plain loads/stores with
a register-offset addressing mode.

If your arch has an addressing mode that takes a base register and an
offset register, you can use a GPR in place of x86's segment register.

That should benefit most this_cpu_*() ops, as it's no longer necessary
to disable preemption for address generation, and is likely preferable
to using it for the canary alone.

Atomics are more complex, as those can be LL/SC and/or have limited
addressing modes, but those are both solvable.

> It's safe as long as it's a callee-saved register. It should be enforced
> that there's no assembly spilling it and calling into C code without the
> random canary. There's very little assembly using registers like x28 so
> it wouldn't be that bad. It's possible there's one where nothing needs
> to be changed, there only needs to be a check to make sure it stays that
> way.

IIRC, the exception entry paths need to be altered to set up the GPR,
but that was about it. EFI runtime services are outside of our control
and might spill any callee-saved registers, so we'd need to restore the
GPR upon exceptions from EL1. Luckily (AFAIK) those don't call back into
the kernel otherwise.

The AAPCS reserves x18 as a platform register for special usage, and
this might be the best choice. For example the EFI spec says that
runtime services mustn't touch this (though I can believe there's buggy
code which does).

> It would be a step towards making SSP cheap enough to expand it into a
> feature like the StackGuard XOR canaries.
> 
> Samsung has a return address XOR feature based on reserving a register
> and while RAP's probabilistic return address mitigation isn't open-
> source, it was stated that it reserves a register on x86_64 where they
> aren't as plentiful as arm64.

Thanks,
Mark.

[1] git://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git arm64/this-cpu-reg
