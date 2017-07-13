Date: Thu, 13 Jul 2017 17:10:50 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170713161050.GG26194@leverpostej>
References: <1499898783-25732-1-git-send-email-mark.rutland@arm.com>
 <1499898783-25732-7-git-send-email-mark.rutland@arm.com>
 <CAKv+Gu8jey+uPSFoCsjQn9BeGiChZpS=iZ0v9nEWvkwcO1gFYg@mail.gmail.com>
 <20170713104950.GB26194@leverpostej>
 <CAKv+Gu9eSX-f4uv3gaNw9_eKV0soe2-CqSnMaTjjEhMifxe_8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9eSX-f4uv3gaNw9_eKV0soe2-CqSnMaTjjEhMifxe_8g@mail.gmail.com>
Subject: [kernel-hardening] Re: [RFC PATCH 6/6] arm64: add VMAP_STACK and detect out-of-bounds SP
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Takahiro Akashi <akashi.takahiro@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <dave.martin@arm.com>, James Morse <james.morse@arm.com>, Laura Abbott <labbott@fedoraproject.org>, Will Deacon <will.deacon@arm.com>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jul 13, 2017 at 12:49:48PM +0100, Ard Biesheuvel wrote:
> On 13 July 2017 at 11:49, Mark Rutland <mark.rutland@arm.com> wrote:
> > On Thu, Jul 13, 2017 at 07:58:50AM +0100, Ard Biesheuvel wrote:
> >> On 12 July 2017 at 23:33, Mark Rutland <mark.rutland@arm.com> wrote:

> >> The typical prologue looks like
> >>
> >> stp x29, x30, [sp, #-xxx]!
> >> stp x27, x28, [sp, #xxx]
> >> ...
> >> mov x29, sp
> >>
> >> which means that in most cases where we do run off the stack, sp will
> >> still be pointing into it when the exception is taken. This means we
> >> will fault recursively in the handler before having had the chance to
> >> accurately record the exception context.

> >> Given that the max displacement of a store instruction is 512 bytes,
> >> and that the frame size we are about to stash exceeds that, should we
> >> already consider it a stack fault if sp is within 512 bytes (or
> >> S_FRAME_SIZE) of the base of the stack?

> > My original line of thinking was that it was best to rely on the
> > recursive fault to push the SP out-of-bounds. That keeps the overflow
> > detection simple/fast, and hopefully robust to unexpected exceptions,
> > (expected?) probes to the guard page, etc.
> >
> > I also agree that it's annoying to lose the information associated with the
> > initial fault.
> >
> > My fear is that we can't catch those cases robustly and efficiently. At
> > minimum, I believe we'd need to check:
> >
> > * FAR_EL1 is out-of-bounds for the stack. You have a suitable check for
> >   this.
> >
> > * FAR_EL1 is valid (looking at the ESR_ELx.{EC,ISS}, etc). I'm not sure
> >   exactly what we need to check here, and I'm not sure what we want to
> >   do about reserved ESR_ELx encodings.
> >
> > * The base register for the access was the SP (e.g. so this isn't a
> >   probe_kernel_read() or similar).
> >
> > ... so my current feeling is that relying on the recursive fault is the
> > best bet, even if we lose some information from the initial fault.
> 
> There are two related issues at play here that we shouldn't conflate:
> - checking whether we have sufficient stack space left to be able to
> handle the exception in the first place,
> - figuring out whether *this* exception was caused by a faulting
> dereference of the stack pointer (which could be with writeback, or
> even via some intermediate register: x29 is often used as a pseudo
> stack pointer IIRC, although it should never point below sp itself)

Sure; I agree these are separate properties (my robustness and
efficiency concerns fall with the latter).

> Given that the very first stp in kernel_entry will fault if we have
> less than S_FRAME_SIZE bytes of stack left, I think we should check
> that we have at least that much space available. 

I was going to reply saying that I didn't agree, but in writing up
examples, I mostly convinced myself that this is the right thing to do.
So I mostly agree!

This would mean we treat the first impossible-to-handle exception as
that fatal case, which is similar to x86's double-fault, triggered when
the HW can't stack the regs. All other cases are just arbitrary faults.

However, to provide that consistently, we'll need to perform this check
at every exception boundary, or some of those cases will result in a
recursive fault first.

So I think there are three choices:

1) In el1_sync, only check SP bounds, and live with the recursive
   faults.

2) in el1_sync, check there's room for the regs, and live with the
   recursive faults for overflow on other exceptions.

3) In all EL1 entry paths, check there's room for the regs.

> That way, the context is preserved, and we could restart the outer
> exception if we wanted to, or point our pt_regs pointer to it etc.
> 
> When and how we diagnose the condition as a kernel stack overflow is a
> separate issue, and can well wait until we're in C code.

I believe that determining whether the exception was caused by a stack
overflow is not something we can do robustly or efficiently.

You mentioned the x29 pseudo-sp case, and there are other cases where
the SP value is proxied:

	mov	x0, sp
	ldr	x0, [x0, x1]

Or unrelated accesses that hit the guard page:
	
	adrp	x0, some_vmalloc_object
	add	x0, x0, #:lo12:some_vmalloc_object
	mov	x1, #bogus_offset
	ldr	x0, [x0, x1]

As above, I think it's helpful to think of this as something closer to a
double-fault handler (i.e. aiming to catch when we can't take the
exception safely), rather than something that's trying to catch logical
stack overflows.

Thanks,
Mark.
