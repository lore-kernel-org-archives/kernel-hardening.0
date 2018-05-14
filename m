Subject: Re: [PATCH 2/2] arm64: Clear the stack
References: <20180502203326.9491-1-labbott@redhat.com>
 <20180502203326.9491-3-labbott@redhat.com>
 <20180503071917.xm2xvgagvzkworay@salmiak>
 <dd6ad26c-1d2c-88f3-8f01-e68d2b31d6ea@linux.com>
 <20180504110907.c2dw33kjmyybso6t@lakrids.cambridge.arm.com>
 <4badae50-be9b-2c6d-854b-57ab48664800@linux.com>
 <71199506-b46b-5f91-e489-e6450b6d1067@linux.com>
 <20180511161317.57k6prl54xjmsit3@lakrids.cambridge.arm.com>
 <f180b312-d1cf-3992-4e89-9632c1674cd6@linux.com>
 <20180514051555.bpbydgr56hyffjch@salmiak>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <6c311899-7131-d21b-10f6-d2ba7380a392@linux.com>
Date: Mon, 14 May 2018 12:35:25 +0300
MIME-Version: 1.0
In-Reply-To: <20180514051555.bpbydgr56hyffjch@salmiak>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Mark Rutland <mark.rutland@arm.com>
Cc: Andy Lutomirski <luto@kernel.org>, Laura Abbott <labbott@redhat.com>, Kees Cook <keescook@chromium.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 14.05.2018 08:15, Mark Rutland wrote:
> On Sun, May 13, 2018 at 11:40:07AM +0300, Alexander Popov wrote:
>> It seems that previously I was very "lucky" to accidentally have those MIN_STACK_LEFT,
>> call trace depth and oops=panic together to experience a hang on stack overflow
>> during BUG().
>>
>>
>> When I run my test in a loop _without_ VMAP_STACK, I manage to corrupt the neighbour
>> processes with BUG() handling overstepping the stack boundary. It's a pity, but
>> I have an idea.
> 
> I think that in the absence of VMAP_STACK, there will always be cases where we
> *could* corrupt a neighbouring stack, but I agree that trying to minimize that
> possibility would be good.

Ok!

>> In kernel/sched/core.c we already have:
>>
>> #ifdef CONFIG_SCHED_STACK_END_CHECK
>>   	if (task_stack_end_corrupted(prev))
>> 		panic("corrupted stack end detected inside scheduler\n");
>> #endif
>>
>> So what would you think if I do the following in check_alloca():
>>
>> 	if (size >= stack_left) {
>> #if !defined(CONFIG_VMAP_STACK) && defined(CONFIG_SCHED_STACK_END_CHECK)
>> 		panic("alloca over the kernel stack boundary\n");
>> #else
>> 		BUG();
>> #endif
> 
> Given this is already out-of-line, how about we always use panic(), regardless
> of VMAP_STACK and SCHED_STACK_END_CHECK? i.e. just
> 
> 	if (unlikely(size >= stack_left))
> 		panic("alloca over the kernel stack boundary");
> 
> If we have VMAP_STACK selected, and overflow during the panic, it's the same as
> if we overflowed during the BUG(). It's likely that panic() will use less stack
> space than BUG(), and the compiler can put the call in a slow path that
> shouldn't affect most calls, so in all cases it's likely preferable.

I'm sure that maintainers and Linus will strongly dislike my patch if I always
use panic() here. panic() kills the whole kernel and we shouldn't use it when we
can safely continue to work.

Let me describe my logic. So let's have size >= stack_left on a thread stack.

1. If CONFIG_VMAP_STACK is enabled, we can safely use BUG(). Even if BUG()
handling overflows the thread stack into the guard page, handle_stack_overflow()
is called and the neighbour memory is not corrupted. The kernel can proceed to live.

2. If CONFIG_VMAP_STACK is disabled, BUG() handling can corrupt the neighbour
kernel memory and cause the undefined behaviour of the whole kernel. I see it on
my lkdtm test. That is a cogent reason for panic().

2.a. If CONFIG_SCHED_STACK_END_CHECK is enabled, the kernel already does panic()
when STACK_END_MAGIC is corrupted. So we will _not_ break the safety policy if
we do panic() in a similar situation in check_alloca().

2.b. If CONFIG_SCHED_STACK_END_CHECK is disabled, the user has some real reasons
not to do panic() when the kernel stack is corrupted. So we should not do it in
check_alloca() as well, just use BUG() and hope for the best.

That logic can be expressed this way:

	if (size >= stack_left) {
#if !defined(CONFIG_VMAP_STACK) && defined(CONFIG_SCHED_STACK_END_CHECK)
		panic("alloca over the kernel stack boundary\n");
#else
		BUG();
#endif

I think I should add a proper comment to describe it.

Thank you.

Best regards,
Alexander
