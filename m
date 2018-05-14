Date: Mon, 14 May 2018 06:15:55 +0100
From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 2/2] arm64: Clear the stack
Message-ID: <20180514051555.bpbydgr56hyffjch@salmiak>
References: <20180502203326.9491-1-labbott@redhat.com>
 <20180502203326.9491-3-labbott@redhat.com>
 <20180503071917.xm2xvgagvzkworay@salmiak>
 <dd6ad26c-1d2c-88f3-8f01-e68d2b31d6ea@linux.com>
 <20180504110907.c2dw33kjmyybso6t@lakrids.cambridge.arm.com>
 <4badae50-be9b-2c6d-854b-57ab48664800@linux.com>
 <71199506-b46b-5f91-e489-e6450b6d1067@linux.com>
 <20180511161317.57k6prl54xjmsit3@lakrids.cambridge.arm.com>
 <f180b312-d1cf-3992-4e89-9632c1674cd6@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f180b312-d1cf-3992-4e89-9632c1674cd6@linux.com>
To: Alexander Popov <alex.popov@linux.com>
Cc: Andy Lutomirski <luto@kernel.org>, Laura Abbott <labbott@redhat.com>, Kees Cook <keescook@chromium.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, May 13, 2018 at 11:40:07AM +0300, Alexander Popov wrote:
> It seems that previously I was very "lucky" to accidentally have those MIN_STACK_LEFT,
> call trace depth and oops=panic together to experience a hang on stack overflow
> during BUG().
> 
> 
> When I run my test in a loop _without_ VMAP_STACK, I manage to corrupt the neighbour
> processes with BUG() handling overstepping the stack boundary. It's a pity, but
> I have an idea.

I think that in the absence of VMAP_STACK, there will always be cases where we
*could* corrupt a neighbouring stack, but I agree that trying to minimize that
possibility would be good.

> In kernel/sched/core.c we already have:
> 
> #ifdef CONFIG_SCHED_STACK_END_CHECK
>   	if (task_stack_end_corrupted(prev))
> 		panic("corrupted stack end detected inside scheduler\n");
> #endif
> 
> So what would you think if I do the following in check_alloca():
> 
> 	if (size >= stack_left) {
> #if !defined(CONFIG_VMAP_STACK) && defined(CONFIG_SCHED_STACK_END_CHECK)
> 		panic("alloca over the kernel stack boundary\n");
> #else
> 		BUG();
> #endif

Given this is already out-of-line, how about we always use panic(), regardless
of VMAP_STACK and SCHED_STACK_END_CHECK? i.e. just

	if (unlikely(size >= stack_left))
		panic("alloca over the kernel stack boundary");

If we have VMAP_STACK selected, and overflow during the panic, it's the same as
if we overflowed during the BUG(). It's likely that panic() will use less stack
space than BUG(), and the compiler can put the call in a slow path that
shouldn't affect most calls, so in all cases it's likely preferable.

Thanks,
Mark.
