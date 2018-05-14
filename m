Date: Mon, 14 May 2018 11:06:40 +0100
From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 2/2] arm64: Clear the stack
Message-ID: <20180514100639.v3erlzbuv2e4awfh@lakrids.cambridge.arm.com>
References: <20180502203326.9491-3-labbott@redhat.com>
 <20180503071917.xm2xvgagvzkworay@salmiak>
 <dd6ad26c-1d2c-88f3-8f01-e68d2b31d6ea@linux.com>
 <20180504110907.c2dw33kjmyybso6t@lakrids.cambridge.arm.com>
 <4badae50-be9b-2c6d-854b-57ab48664800@linux.com>
 <71199506-b46b-5f91-e489-e6450b6d1067@linux.com>
 <20180511161317.57k6prl54xjmsit3@lakrids.cambridge.arm.com>
 <f180b312-d1cf-3992-4e89-9632c1674cd6@linux.com>
 <20180514051555.bpbydgr56hyffjch@salmiak>
 <6c311899-7131-d21b-10f6-d2ba7380a392@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c311899-7131-d21b-10f6-d2ba7380a392@linux.com>
To: Alexander Popov <alex.popov@linux.com>
Cc: Andy Lutomirski <luto@kernel.org>, Laura Abbott <labbott@redhat.com>, Kees Cook <keescook@chromium.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, May 14, 2018 at 12:35:25PM +0300, Alexander Popov wrote:
> On 14.05.2018 08:15, Mark Rutland wrote:
> > On Sun, May 13, 2018 at 11:40:07AM +0300, Alexander Popov wrote:
> >> So what would you think if I do the following in check_alloca():
> >>
> >> 	if (size >= stack_left) {
> >> #if !defined(CONFIG_VMAP_STACK) && defined(CONFIG_SCHED_STACK_END_CHECK)
> >> 		panic("alloca over the kernel stack boundary\n");
> >> #else
> >> 		BUG();
> >> #endif
> > 
> > Given this is already out-of-line, how about we always use panic(), regardless
> > of VMAP_STACK and SCHED_STACK_END_CHECK? i.e. just
> > 
> > 	if (unlikely(size >= stack_left))
> > 		panic("alloca over the kernel stack boundary");
> > 
> > If we have VMAP_STACK selected, and overflow during the panic, it's the same as
> > if we overflowed during the BUG(). It's likely that panic() will use less stack
> > space than BUG(), and the compiler can put the call in a slow path that
> > shouldn't affect most calls, so in all cases it's likely preferable.
> 
> I'm sure that maintainers and Linus will strongly dislike my patch if I always
> use panic() here. panic() kills the whole kernel and we shouldn't use it when we
> can safely continue to work.
> 
> Let me describe my logic. So let's have size >= stack_left on a thread stack.
> 
> 1. If CONFIG_VMAP_STACK is enabled, we can safely use BUG(). Even if BUG()
> handling overflows the thread stack into the guard page, handle_stack_overflow()
> is called and the neighbour memory is not corrupted. The kernel can proceed to live.

On arm64 with CONFIG_VMAP_STACK, a stack overflow will result in a
panic(). My understanding was that the same is true on x86.

> 2. If CONFIG_VMAP_STACK is disabled, BUG() handling can corrupt the neighbour
> kernel memory and cause the undefined behaviour of the whole kernel. I see it on
> my lkdtm test. That is a cogent reason for panic().

In this case, panic() can also corrupt the neighbour stack, and could
also fail.

When CONFIG_VMAP_STACK is not selected, a stack overflow simply cannot
be handled reliably -- while panic() may be more likely to succeed, it
is not gauranteed to.

> 2.a. If CONFIG_SCHED_STACK_END_CHECK is enabled, the kernel already does panic()
> when STACK_END_MAGIC is corrupted. So we will _not_ break the safety policy if
> we do panic() in a similar situation in check_alloca().

Sure, I'm certainly happy with panic() here.

> 2.b. If CONFIG_SCHED_STACK_END_CHECK is disabled, the user has some real reasons
> not to do panic() when the kernel stack is corrupted. 

I believe that CONFIG_SCHED_STACK_END_CHECK is seen as a debug feature,
and hence people don't select it. I strongly doubt that people have
reasons to disable it other than not wanting the overhead associated
with debug features.

I think it is reasonable to panic() here even with CONFIG_VMAP_STACK
selected.

> So we should not do it in check_alloca() as well, just use BUG() and
> hope for the best.

Regardless of whether we BUG() or panic(), we're hoping for the best.

Consistently using panic() here will keep things simpler, so any failure
reported will be easier to reason about, and easier to debug.

Thanks,
Mark.
