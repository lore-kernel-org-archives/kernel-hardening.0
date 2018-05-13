From: Alexander Popov <alex.popov@linux.com>
Subject: [PATCH 2/2] arm64: Clear the stack
References: <20180502203326.9491-1-labbott@redhat.com>
 <20180502203326.9491-3-labbott@redhat.com>
 <20180503071917.xm2xvgagvzkworay@salmiak>
 <dd6ad26c-1d2c-88f3-8f01-e68d2b31d6ea@linux.com>
 <20180504110907.c2dw33kjmyybso6t@lakrids.cambridge.arm.com>
 <4badae50-be9b-2c6d-854b-57ab48664800@linux.com>
 <71199506-b46b-5f91-e489-e6450b6d1067@linux.com>
 <20180511161317.57k6prl54xjmsit3@lakrids.cambridge.arm.com>
Message-ID: <f180b312-d1cf-3992-4e89-9632c1674cd6@linux.com>
Date: Sun, 13 May 2018 11:40:07 +0300
MIME-Version: 1.0
In-Reply-To: <20180511161317.57k6prl54xjmsit3@lakrids.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Mark Rutland <mark.rutland@arm.com>
Cc: Andy Lutomirski <luto@kernel.org>, Laura Abbott <labbott@redhat.com>, Kees Cook <keescook@chromium.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Hello Mark,

Thanks a lot for your reply!

On 11.05.2018 19:13, Mark Rutland wrote:
> On Fri, May 11, 2018 at 06:50:09PM +0300, Alexander Popov wrote:
>> On 06.05.2018 11:22, Alexander Popov wrote:
>>> On 04.05.2018 14:09, Mark Rutland wrote:
>>>>>>> +	stack_left = sp & (THREAD_SIZE - 1);
>>>>>>> +	BUG_ON(stack_left < 256 || size >= stack_left - 256);
>>>>>>
>>>>>> Is this arbitrary, or is there something special about 256?
>>>>>>
>>>>>> Even if this is arbitrary, can we give it some mnemonic?
>>>>>
>>>>> It's just a reasonable number. We can introduce a macro for it.
>>>>
>>>> I'm just not sure I see the point in the offset, given things like
>>>> VMAP_STACK exist. BUG_ON() handling will likely require *more* than 256
>>>> bytes of stack, so it seems superfluous, as we'd be relying on stack
>>>> overflow detection at that point.
>>>>
>>>> I can see that we should take the CONFIG_SCHED_STACK_END_CHECK offset
>>>> into account, though.
>>>
>>> Mark, thank you for such an important remark!
>>>
>>> In Kconfig STACKLEAK implies but doesn't depend on VMAP_STACK. In fact x86_32
>>> doesn't have VMAP_STACK at all but can have STACKLEAK.
>>>
>>> [Adding Andy Lutomirski]
>>>
>>> I've made some additional experiments: I exhaust the thread stack to have only
>>> (MIN_STACK_LEFT - 1) bytes left and then force alloca. If VMAP_STACK is
>>> disabled, BUG_ON() handling causes stack depth overflow, which is detected by
>>> SCHED_STACK_END_CHECK. If VMAP_STACK is enabled, the kernel hangs on BUG_ON()
>>> handling! Enabling CONFIG_PROVE_LOCKING gives the needed report from VMAP_STACK:
> 
> I can't see why CONFIG_VMAP_STACK would only work in conjunction with
> CONFIG_PROVE_LOCKING.
> 
> On arm64 at least, if we overflow the stack while handling a BUG(), we
> *should* trigger the overflow handler as usual, and that should work,
> unless I'm missing something.
> 
> Maybe it gets part-way into panic(), sets up some state,
> stack-overflows, and we get wedged because we're already in a panic?
> Perhaps CONFIG_PROVE_LOCKING causes more stack to be used, so it dies a
> little earlier in panic(), before setting up some state that causes
> wedging.

That seems likely. I later noticed that I had oops=panic kernel parameter.

> ... which sounds like something best fixed in those code paths, and not
> here.
> 
>> [...]
>>
>>> I can't say why VMAP_STACK report hangs during BUG_ON() handling on defconfig.
>>> Andy, can you give a clue?
>>>
>>> I see that MIN_STACK_LEFT = 2048 is enough for BUG_ON() handling on both x86_64
>>> and x86_32. So I'm going to:
>>>  - set MIN_STACK_LEFT to 2048;
>>>  - improve the lkdtm test to cover this case.
>>>
>>> Mark, Kees, Laura, does it sound good?
>>
>>
>> Could you have a look at the following changes in check_alloca() before I send
>> the next version?
>>
>> If VMAP_STACK is enabled and alloca causes stack depth overflow, I write to
>> guard page below the thread stack to cause double fault and VMAP_STACK report.
> 
> On arm64 at least, writing to the guard page will not itself trigger a
> stack overflow, but will trigger a data abort. I suspect similar is true
> on x86, if the stack pointer is sufficiently far above the guard page.

Yes, you are right, my mistake.

The comment about CONFIG_VMAP_STACK in arch/x86/kernel/traps.c says:
"If we overflow the stack into a guard page, the CPU will fail to deliver #PF
and will send #DF instead."

>> If VMAP_STACK is disabled, I use MIN_STACK_LEFT = 2048, which seems to be enough
>> for BUG_ON() handling both on x86_32 and x86_64. Unfortunately, I can't
>> guarantee that it is always enough.
> 
> I don't think that we can choose something that's guaranteed to be
> sufficient for BUG() handling and also not wasting a tonne of space
> under normal operation.
> 
> Let's figure out what's going wrong on x86 in the case that you mention,
> and try to solve that.
> 
> Here I don't think we should reserve space at all -- it's completely
> arbitrary, and as above we can't guarantee that it's sufficient anyway.
> 
>>  #ifdef CONFIG_GCC_PLUGIN_STACKLEAK
>> -#define MIN_STACK_LEFT 256
>> +#define MIN_STACK_LEFT 2048
>>
>>  void __used check_alloca(unsigned long size)
>>  {
>>         unsigned long sp = (unsigned long)&sp;
>>         struct stack_info stack_info = {0};
>>         unsigned long visit_mask = 0;
>>         unsigned long stack_left;
>>
>>         BUG_ON(get_stack_info(&sp, current, &stack_info, &visit_mask));
>>
>>         stack_left = sp - (unsigned long)stack_info.begin;
>> +
>> +#ifdef CONFIG_VMAP_STACK
>> +       /*
>> +        * If alloca oversteps the thread stack boundary, we touch the guard
>> +        * page provided by VMAP_STACK to trigger handle_stack_overflow().
>> +        */
>> +       if (size >= stack_left)
>> +               *(stack_info.begin - 1) = 42;
>> +#else
> 
> On arm64, this won't trigger our stack overflow handler, unless the SP
> is already very close to the boundary.
> 
> Please just use BUG(). If there is an issue on x86, it would be good to
> solve that in the x86 code.
> 
>>         BUG_ON(stack_left < MIN_STACK_LEFT ||
>>                                 size >= stack_left - MIN_STACK_LEFT);
> 
> I really don't think we should bother with this arbitrary offset at all.

Thanks. I agree with all your points.

I wrote a third lkdtm test for STACKLEAK which runs deep recursion with alloca.
If I have just BUG_ON(size >= stack_left) in check_alloca(), I get the following
nice report without any trouble:

[    8.407261] lkdtm: Performing direct entry STACKLEAK_RECURSION_WITH_ALLOCA
[    8.408641] lkdtm: checking unused part of the thread stack (15744 bytes)...
[    8.409936] lkdtm: first 744 bytes are unpoisoned
[    8.410751] lkdtm: the rest of the thread stack is properly erased
[    8.411760] lkdtm: try to overflow the thread stack using recursion & alloca
[    8.412914] BUG: stack guard page was hit at 00000000b993c2bc (stack is 00000000764adcd4..000000005b443f11)
[    8.414471] kernel stack overflow (double-fault): 0000 [#1] SMP PTI
[    8.415409] Dumping ftrace buffer:
[    8.415907]    (ftrace buffer empty)
[    8.416404] Modules linked in: lkdtm
[    8.416905] CPU: 0 PID: 2664 Comm: sh Not tainted 4.17.0-rc3+ #39
[    8.417766] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
[    8.419088] RIP: 0010:do_error_trap+0x31/0x130
[    8.419647] RSP: 0018:ffffc900009b3fc0 EFLAGS: 00010046
[    8.420263] RAX: 0000000000000000 RBX: ffffc900009b4078 RCX: 0000000000000006
[    8.421322] RDX: ffffffff81fdbe4d RSI: 0000000000000000 RDI: ffffc900009b4078
[    8.422837] RBP: 0000000000000006 R08: 0000000000000004 R09: 0000000000000000
[    8.425095] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000004
[    8.427365] R13: ffffffff81fdbe4d R14: 0000000000000000 R15: 0000000000000000
[    8.430111] FS:  00007f7c340c1700(0000) GS:ffff88007fc00000(0000) knlGS:0000000000000000
[    8.432515] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    8.433132] CR2: ffffc900009b3fb8 CR3: 000000007b330000 CR4: 00000000000006f0
[    8.433904] Call Trace:
[    8.434180]  invalid_op+0x14/0x20
[    8.434546] RIP: 0010:check_alloca+0x8e/0xa0
[    8.434995] RSP: 0018:ffffc900009b4128 EFLAGS: 00010283
[    8.435555] RAX: 0000000000000128 RBX: 0000000000000190 RCX: 0000000000000001
[    8.436479] RDX: 0000000000000002 RSI: 0000000000000000 RDI: ffffc900009b4128
[    8.437871] RBP: ffffc900009b4180 R08: 000000000000018f R09: 0000000000000007
[    8.438661] R10: 0000000000000000 R11: 0000000000000030 R12: ffff88007a626000
[    8.439433] R13: 0000000001cf5610 R14: 0000000000000020 R15: ffffc900009b7f08
[    8.440329]  ? check_alloca+0x64/0xa0
[    8.440845]  do_alloca+0x20/0x60 [lkdtm]
[    8.441937]  recursion+0xa0/0xd0 [lkdtm]
[    8.443370]  ? vsnprintf+0xf2/0x4b0
[    8.444289]  ? get_stack_info+0x32/0x160
[    8.445359]  ? check_alloca+0x64/0xa0
[    8.445995]  ? do_alloca+0x20/0x60 [lkdtm]
[    8.446449]  recursion+0xbb/0xd0 [lkdtm]
[    8.446881]  ? vsnprintf+0xf2/0x4b0
[    8.447259]  ? get_stack_info+0x32/0x160
[    8.447693]  ? check_alloca+0x64/0xa0
[    8.448088]  ? do_alloca+0x20/0x60 [lkdtm]
[    8.448539]  recursion+0xbb/0xd0 [lkdtm]
...

It seems that previously I was very "lucky" to accidentally have those MIN_STACK_LEFT,
call trace depth and oops=panic together to experience a hang on stack overflow
during BUG().


When I run my test in a loop _without_ VMAP_STACK, I manage to corrupt the neighbour
processes with BUG() handling overstepping the stack boundary. It's a pity, but
I have an idea.

In kernel/sched/core.c we already have:

#ifdef CONFIG_SCHED_STACK_END_CHECK
  	if (task_stack_end_corrupted(prev))
		panic("corrupted stack end detected inside scheduler\n");
#endif

So what would you think if I do the following in check_alloca():

	if (size >= stack_left) {
#if !defined(CONFIG_VMAP_STACK) && defined(CONFIG_SCHED_STACK_END_CHECK)
		panic("alloca over the kernel stack boundary\n");
#else
		BUG();
#endif

I think that fits well to the CONFIG_SCHED_STACK_END_CHECK policy.

Best regards,
Alexander
