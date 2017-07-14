Date: Fri, 14 Jul 2017 13:52:15 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170714125214.GA16687@leverpostej>
References: <1499898783-25732-1-git-send-email-mark.rutland@arm.com>
 <1499898783-25732-7-git-send-email-mark.rutland@arm.com>
 <CAKv+Gu8jey+uPSFoCsjQn9BeGiChZpS=iZ0v9nEWvkwcO1gFYg@mail.gmail.com>
 <20170713104950.GB26194@leverpostej>
 <CAKv+Gu9eSX-f4uv3gaNw9_eKV0soe2-CqSnMaTjjEhMifxe_8g@mail.gmail.com>
 <20170713161050.GG26194@leverpostej>
 <20170713175543.GA32528@leverpostej>
 <CAKv+Gu_v3PO7=JSgCTb3aZu3sg4cwYYjy68VJnr58vzaMYvhTw@mail.gmail.com>
 <20170714103258.GA16128@leverpostej>
 <CAKv+Gu-FvfPFQooCie6HwP=mBng3C0jp9p8WMkFwTxctDu4JBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-FvfPFQooCie6HwP=mBng3C0jp9p8WMkFwTxctDu4JBA@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [RFC PATCH 6/6] arm64: add VMAP_STACK and
 detect out-of-bounds SP
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Takahiro Akashi <akashi.takahiro@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <dave.martin@arm.com>, James Morse <james.morse@arm.com>, Laura Abbott <labbott@fedoraproject.org>, Will Deacon <will.deacon@arm.com>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jul 14, 2017 at 11:48:20AM +0100, Ard Biesheuvel wrote:
> On 14 July 2017 at 11:32, Mark Rutland <mark.rutland@arm.com> wrote:
> > On Thu, Jul 13, 2017 at 07:28:48PM +0100, Ard Biesheuvel wrote:
> >> On 13 July 2017 at 18:55, Mark Rutland <mark.rutland@arm.com> wrote:
> >> > On Thu, Jul 13, 2017 at 05:10:50PM +0100, Mark Rutland wrote:
> >> >> On Thu, Jul 13, 2017 at 12:49:48PM +0100, Ard Biesheuvel wrote:
> >> >> > On 13 July 2017 at 11:49, Mark Rutland <mark.rutland@arm.com> wrote:
> >> >> > > On Thu, Jul 13, 2017 at 07:58:50AM +0100, Ard Biesheuvel wrote:
> >> >> > >> On 12 July 2017 at 23:33, Mark Rutland <mark.rutland@arm.com> wrote:
> > This means that we have to align the initial task, so the kernel Image
> > will grow by THREAD_SIZE. Likewise for IRQ stacks, unless we can rework
> > things such that we can dynamically allocate all of those.
> >
> 
> We can't currently do that for 64k pages, since the segment alignment
> is only 64k. But we should be able to patch that up I think

I was assuming that the linked would bump up the segment alignment if a
more-aligned object were placed inside. I guess that doesn't happen in
all cases?

... or do you mean when the EFI stub relocates the kernel, assuming
relaxed alignment constraints?

> >> >> I believe that determining whether the exception was caused by a stack
> >> >> overflow is not something we can do robustly or efficiently.
> >>
> >> Actually, if the stack pointer is within S_FRAME_SIZE of the base, and
> >> the faulting address points into the guard page, that is a pretty
> >> strong indicator that the stack overflowed. That shouldn't be too
> >> costly?
> >
> > Sure, but that's still a a heuristic. For example, that also catches an
> > unrelated vmalloc address gone wrong, while SP was close to the end of
> > the stack.
> 
> Yes, but the likelihood that an unrelated stray vmalloc access is
> within 16 KB of a stack pointer that is close ot its limit is
> extremely low, so we should be able to live with the risk of
> misidentifying it.

I guess, but at that point, why bother?

That gives us a fuzzy check for one specific "stack overflow", while not
catching the general case.

So long as we have a reliable stack trace, we can figure out that was
the case, and we don't set the expectation that we're trying to
categorize the general case (minefield and all).

Thanks,
Mark.
