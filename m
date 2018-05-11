Subject: Re: [PATCH 2/2] arm64: Clear the stack
From: Alexander Popov <alex.popov@linux.com>
References: <20180502203326.9491-1-labbott@redhat.com>
 <20180502203326.9491-3-labbott@redhat.com>
 <20180503071917.xm2xvgagvzkworay@salmiak>
 <dd6ad26c-1d2c-88f3-8f01-e68d2b31d6ea@linux.com>
 <20180504110907.c2dw33kjmyybso6t@lakrids.cambridge.arm.com>
 <4badae50-be9b-2c6d-854b-57ab48664800@linux.com>
Message-ID: <71199506-b46b-5f91-e489-e6450b6d1067@linux.com>
Date: Fri, 11 May 2018 18:50:09 +0300
MIME-Version: 1.0
In-Reply-To: <4badae50-be9b-2c6d-854b-57ab48664800@linux.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Mark Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>, Laura Abbott <labbott@redhat.com>, Kees Cook <keescook@chromium.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Hello everyone,

On 06.05.2018 11:22, Alexander Popov wrote:
> On 04.05.2018 14:09, Mark Rutland wrote:
>>>>> +	stack_left = sp & (THREAD_SIZE - 1);
>>>>> +	BUG_ON(stack_left < 256 || size >= stack_left - 256);
>>>>
>>>> Is this arbitrary, or is there something special about 256?
>>>>
>>>> Even if this is arbitrary, can we give it some mnemonic?
>>>
>>> It's just a reasonable number. We can introduce a macro for it.
>>
>> I'm just not sure I see the point in the offset, given things like
>> VMAP_STACK exist. BUG_ON() handling will likely require *more* than 256
>> bytes of stack, so it seems superfluous, as we'd be relying on stack
>> overflow detection at that point.
>>
>> I can see that we should take the CONFIG_SCHED_STACK_END_CHECK offset
>> into account, though.
> 
> Mark, thank you for such an important remark!
> 
> In Kconfig STACKLEAK implies but doesn't depend on VMAP_STACK. In fact x86_32
> doesn't have VMAP_STACK at all but can have STACKLEAK.
> 
> [Adding Andy Lutomirski]
> 
> I've made some additional experiments: I exhaust the thread stack to have only
> (MIN_STACK_LEFT - 1) bytes left and then force alloca. If VMAP_STACK is
> disabled, BUG_ON() handling causes stack depth overflow, which is detected by
> SCHED_STACK_END_CHECK. If VMAP_STACK is enabled, the kernel hangs on BUG_ON()
> handling! Enabling CONFIG_PROVE_LOCKING gives the needed report from VMAP_STACK:

[...]

> I can't say why VMAP_STACK report hangs during BUG_ON() handling on defconfig.
> Andy, can you give a clue?
> 
> I see that MIN_STACK_LEFT = 2048 is enough for BUG_ON() handling on both x86_64
> and x86_32. So I'm going to:
>  - set MIN_STACK_LEFT to 2048;
>  - improve the lkdtm test to cover this case.
> 
> Mark, Kees, Laura, does it sound good?


Could you have a look at the following changes in check_alloca() before I send
the next version?

If VMAP_STACK is enabled and alloca causes stack depth overflow, I write to
guard page below the thread stack to cause double fault and VMAP_STACK report.

If VMAP_STACK is disabled, I use MIN_STACK_LEFT = 2048, which seems to be enough
for BUG_ON() handling both on x86_32 and x86_64. Unfortunately, I can't
guarantee that it is always enough.


 #ifdef CONFIG_GCC_PLUGIN_STACKLEAK
-#define MIN_STACK_LEFT 256
+#define MIN_STACK_LEFT 2048

 void __used check_alloca(unsigned long size)
 {
        unsigned long sp = (unsigned long)&sp;
        struct stack_info stack_info = {0};
        unsigned long visit_mask = 0;
        unsigned long stack_left;

        BUG_ON(get_stack_info(&sp, current, &stack_info, &visit_mask));

        stack_left = sp - (unsigned long)stack_info.begin;
+
+#ifdef CONFIG_VMAP_STACK
+       /*
+        * If alloca oversteps the thread stack boundary, we touch the guard
+        * page provided by VMAP_STACK to trigger handle_stack_overflow().
+        */
+       if (size >= stack_left)
+               *(stack_info.begin - 1) = 42;
+#else
        BUG_ON(stack_left < MIN_STACK_LEFT ||
                                size >= stack_left - MIN_STACK_LEFT);
+#endif
 }
 EXPORT_SYMBOL(check_alloca);
 #endif


Looking forward to your feedback.

Best regards,
Alexander
