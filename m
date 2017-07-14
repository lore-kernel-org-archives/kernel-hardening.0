Date: Fri, 14 Jul 2017 11:32:59 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170714103258.GA16128@leverpostej>
References: <1499898783-25732-1-git-send-email-mark.rutland@arm.com>
 <1499898783-25732-7-git-send-email-mark.rutland@arm.com>
 <CAKv+Gu8jey+uPSFoCsjQn9BeGiChZpS=iZ0v9nEWvkwcO1gFYg@mail.gmail.com>
 <20170713104950.GB26194@leverpostej>
 <CAKv+Gu9eSX-f4uv3gaNw9_eKV0soe2-CqSnMaTjjEhMifxe_8g@mail.gmail.com>
 <20170713161050.GG26194@leverpostej>
 <20170713175543.GA32528@leverpostej>
 <CAKv+Gu_v3PO7=JSgCTb3aZu3sg4cwYYjy68VJnr58vzaMYvhTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_v3PO7=JSgCTb3aZu3sg4cwYYjy68VJnr58vzaMYvhTw@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [RFC PATCH 6/6] arm64: add VMAP_STACK and
 detect out-of-bounds SP
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Takahiro Akashi <akashi.takahiro@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <dave.martin@arm.com>, James Morse <james.morse@arm.com>, Laura Abbott <labbott@fedoraproject.org>, Will Deacon <will.deacon@arm.com>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jul 13, 2017 at 07:28:48PM +0100, Ard Biesheuvel wrote:
> On 13 July 2017 at 18:55, Mark Rutland <mark.rutland@arm.com> wrote:
> > On Thu, Jul 13, 2017 at 05:10:50PM +0100, Mark Rutland wrote:
> >> On Thu, Jul 13, 2017 at 12:49:48PM +0100, Ard Biesheuvel wrote:
> >> > On 13 July 2017 at 11:49, Mark Rutland <mark.rutland@arm.com> wrote:
> >> > > On Thu, Jul 13, 2017 at 07:58:50AM +0100, Ard Biesheuvel wrote:
> >> > >> On 12 July 2017 at 23:33, Mark Rutland <mark.rutland@arm.com> wrote:
> >
> >> > Given that the very first stp in kernel_entry will fault if we have
> >> > less than S_FRAME_SIZE bytes of stack left, I think we should check
> >> > that we have at least that much space available.
> >>
> >> I was going to reply saying that I didn't agree, but in writing up
> >> examples, I mostly convinced myself that this is the right thing to do.
> >> So I mostly agree!
> >>
> >> This would mean we treat the first impossible-to-handle exception as
> >> that fatal case, which is similar to x86's double-fault, triggered when
> >> the HW can't stack the regs. All other cases are just arbitrary faults.
> >>
> >> However, to provide that consistently, we'll need to perform this check
> >> at every exception boundary, or some of those cases will result in a
> >> recursive fault first.
> >>
> >> So I think there are three choices:
> >>
> >> 1) In el1_sync, only check SP bounds, and live with the recursive
> >>    faults.
> >>
> >> 2) in el1_sync, check there's room for the regs, and live with the
> >>    recursive faults for overflow on other exceptions.
> >>
> >> 3) In all EL1 entry paths, check there's room for the regs.
> >
> > FWIW, for the moment I've applied (2), as you suggested, to my
> > arm64/vmap-stack branch, adding an additional:
> >
> >         sub     x0, x0, #S_FRAME_SIZE
> >
> > ... to the entry path.
> >
> > I think it's worth trying (3) so that we consistently report these
> > cases, benchmarks permitting.
> >
> 
> OK, so here's a crazy idea: what if we
> a) carve out a dedicated range in the VMALLOC area for stacks
> b) for each stack, allocate a naturally aligned window of 2x the stack
> size, and map the stack inside it, leaving the remaining space
> unmapped

This is not such a crazy idea. :)

In fact, it was one I toyed with before getting lost on a register
juggling tangent (see below).

> That way, we can compare SP (minus S_FRAME_SIZE) against a mask that
> is a build time constant, to decide whether its value points into a
> stack or not. Of course, it may be pointing into the wrong stack, but
> that should not prevent us from taking the exception, and we can deal
> with that later. It would give us a very cheap way to perform this
> test on the hot paths.

The logical ops (TST) and conditional branches (TB(N)Z, CB(N)Z) operate
on XZR rather than SP, so to do this we need to get the SP value into a
GPR.

Previously, I assumed this meant we needed to corrupt a GPR (and hence
stash that GPR in a sysreg), so I started writing code to free sysregs.

However, I now realise I was being thick, since we can stash the GPR
in the SP:

	sub	sp, sp, x0	// sp = orig_sp - x0
	add	x0, sp, x0	// x0 = x0 - (orig_sp - x0) == orig_sp
	sub	x0, x0, #S_FRAME_SIZE
	tb(nz)	x0, #THREAD_SHIFT, overflow
	add	x0, x0, #S_FRAME_SIZE
	sub	x0, sp, x0
	add	sp, sp, x0

... so yes, this could work!

This means that we have to align the initial task, so the kernel Image
will grow by THREAD_SIZE. Likewise for IRQ stacks, unless we can rework
things such that we can dynamically allocate all of those.

> >> I believe that determining whether the exception was caused by a stack
> >> overflow is not something we can do robustly or efficiently.
> 
> Actually, if the stack pointer is within S_FRAME_SIZE of the base, and
> the faulting address points into the guard page, that is a pretty
> strong indicator that the stack overflowed. That shouldn't be too
> costly?

Sure, but that's still a a heuristic. For example, that also catches an
unrelated vmalloc address gone wrong, while SP was close to the end of
the stack.

The important thing is whether we can *safely enter the exception* (i.e.
stack the regs), or whether this'll push the SP (further) out-of-bounds.
I think we agree that we can reliably and efficiently check this.

The general case of nominal "stack overflows" (e.g. large preidx
decrements, proxied SP values, unrelated guard-page faults) is a
semantic minefield. I don't think we should add code to try to
distinguish these.

For that general case, if we can enter the exception then we can try to
handle the exception in the usual way, and either:

* The fault code determines the access was bad. We at least kill the
  thread.

* We overflow the stack while trying to handle the exception, triggering
  a new fault to triage.

To make it possible to distinguish and debug these, we need to fix the
backtracing code, but that's it.

Thanks,
Mark.
