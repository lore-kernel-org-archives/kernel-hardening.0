MIME-Version: 1.0
In-Reply-To: <CA+KhAHZB6_V-9dKeXzJEmUuYt3Qn7YqoH+rqEncD-tvx9HS6qA@mail.gmail.com>
References: <1519899591-29761-1-git-send-email-kpark3469@gmail.com>
 <1519899591-29761-2-git-send-email-kpark3469@gmail.com> <1519899591-29761-3-git-send-email-kpark3469@gmail.com>
 <1519899591-29761-4-git-send-email-kpark3469@gmail.com> <CAGXu5j+DW-qpFwCxN0dgsNLn35940SX+n0nJTceNfRzRrswU+A@mail.gmail.com>
 <CA+KhAHZB6_V-9dKeXzJEmUuYt3Qn7YqoH+rqEncD-tvx9HS6qA@mail.gmail.com>
From: Keun-O Park <kpark3469@gmail.com>
Date: Mon, 9 Apr 2018 09:54:24 +0400
Message-ID: <CA+KhAHZBfeVFrAaGaxY=+DWtLkHSgy7xH4yitnUJ6UmdVuyW4A@mail.gmail.com>
Subject: Re: [PATCH 3/4] arm64: usercopy: consider dynamic array stack variable
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, James Morse <james.morse@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, keun-o.park@darkmatter.ae
List-ID: <kernel-hardening.lists.openwall.com>

I removed this patch from v2 patchset.
I noticed that this patch can not pass the current lkdtm
stack_frame_to/from tests.
Because the bad_stack is placed before the do_usercopy_stack frame,
this patch makes bad_stack pass the check.
It's not what we want to happen.
For now and later, I think this might be the best solution.

These are the each frame's information in walk_stackframe, when
discard_frame is set to 3 in order to filter the variable length
array.

root@genericarmv8:/sys/kernel/debug/provoke-crash# echo
USERCOPY_STACK_FRAME_TO > DIRECT
[ 3726.088794] lkdtm: Performing direct entry USERCOPY_STACK_FRAME_TO
[ 3726.088867] lkdtm: >>> buf=0xffff00000bf7bc18
[ 3726.088936] lkdtm: >>> do_usercopy_stack_callee:
fp=ffff00000bf7bbf0 xfp=ffff00000bf7bc40
[ 3726.089037] lkdtm: >>> do_usercopy_stack:
good_stack=0xffff00000bf7bc98, bad_stack=0xffff00000bf7bc18
[ 3726.089129] lkdtm: >>> do_usercopy_stack: fp=ffff00000bf7bc40
xfp=ffff00000bf7bcc0
[ 3726.089203] lkdtm: attempting good copy_to_user of local stack
[ 3726.089267] =====================================
[ 3726.089358] > PC        = arch_within_stack_frames+0x0/0x88
[ 3726.089423] > discard_f = 3
[ 3726.089477] > frm_start = 0xffff00000bf7bb90
[ 3726.089539] > frame_end = 0xffff00000bf7bb90
[ 3726.089601] > obj start = 0xffff00000bf7bc98
[ 3726.089662] > obj end   = 0xffff00000bf7bcb8
[ 3726.089720] =====================================
[ 3726.089803] > PC        = check_stack_object+0x44/0x68
[ 3726.089867] > discard_f = 2
[ 3726.089921] > frm_start = 0xffff00000bf7bba0
[ 3726.089982] > frame_end = 0xffff00000bf7bbf0
[ 3726.090044] > obj start = 0xffff00000bf7bc98
[ 3726.090105] > obj end   = 0xffff00000bf7bcb8
[ 3726.090163] =====================================
[ 3726.090247] > PC        = __check_object_size+0x50/0x1e0
[ 3726.090311] > discard_f = 1
[ 3726.090365] > frm_start = 0xffff00000bf7bc00
[ 3726.090427] > frame_end = 0xffff00000bf7bc00
[ 3726.090489] > obj start = 0xffff00000bf7bc98
[ 3726.090550] > obj end   = 0xffff00000bf7bcb8
[ 3726.090608] =====================================
[ 3726.090688] > PC        = do_usercopy_stack+0x188/0x3c0
[ 3726.090752] > discard_f = 0
[ 3726.090806] > frm_start = 0xffff00000bf7bc10
[ 3726.090867] > frame_end = 0xffff00000bf7bc40
[ 3726.091025] > obj start = 0xffff00000bf7bc98
[ 3726.091134] > obj end   = 0xffff00000bf7bcb8
[ 3726.091240] =====================================
[ 3726.091365] > PC        = lkdtm_USERCOPY_STACK_FRAME_TO+0x24/0x38
[ 3726.091495] > discard_f = 0
[ 3726.091596] > frm_start = 0xffff00000bf7bc50
[ 3726.091702] > frame_end = 0xffff00000bf7bcc0
[ 3726.091806] > obj start = 0xffff00000bf7bc98
[ 3726.091909] > obj end   = 0xffff00000bf7bcb8
[ 3726.092037] lkdtm: attempting bad copy_to_user of distant stack
[ 3726.092163] =====================================
[ 3726.092298] > PC        = arch_within_stack_frames+0x0/0x88
[ 3726.092424] > discard_f = 3
[ 3726.092528] > frm_start = 0xffff00000bf7bb90
[ 3726.092634] > frame_end = 0xffff00000bf7bb90
[ 3726.092696] > obj start = 0xffff00000bf7bc18
[ 3726.092757] > obj end   = 0xffff00000bf7bc38
[ 3726.092815] =====================================
[ 3726.092897] > PC        = check_stack_object+0x44/0x68
[ 3726.092960] > discard_f = 2
[ 3726.093014] > frm_start = 0xffff00000bf7bba0
[ 3726.093075] > frame_end = 0xffff00000bf7bbf0
[ 3726.093136] > obj start = 0xffff00000bf7bc18
[ 3726.093198] > obj end   = 0xffff00000bf7bc38
[ 3726.093255] =====================================
[ 3726.093338] > PC        = __check_object_size+0x50/0x1e0
[ 3726.093402] > discard_f = 1
[ 3726.093456] > frm_start = 0xffff00000bf7bc00
[ 3726.093517] > frame_end = 0xffff00000bf7bc00
[ 3726.093578] > obj start = 0xffff00000bf7bc18
[ 3726.093640] > obj end   = 0xffff00000bf7bc38
[ 3726.093697] =====================================
[ 3726.093777] > PC        = do_usercopy_stack+0x318/0x3c0
[ 3726.093840] > discard_f = 0
[ 3726.093894] > frm_start = 0xffff00000bf7bc10
[ 3726.093955] > frame_end = 0xffff00000bf7bc40
[ 3726.094016] > obj start = 0xffff00000bf7bc18
[ 3726.094077] > obj end   = 0xffff00000bf7bc38


Thanks.

BR
Sahara

On Sun, Apr 8, 2018 at 10:45 AM, Keun-O Park <kpark3469@gmail.com> wrote:
> On Thu, Apr 5, 2018 at 2:57 AM, Kees Cook <keescook@chromium.org> wrote:
>> On Thu, Mar 1, 2018 at 2:19 AM,  <kpark3469@gmail.com> wrote:
>>> From: Sahara <keun-o.park@darkmatter.ae>
>>>
>>> When an array is dynamically declared, the array may be placed
>>> at next frame. If this variable is used for usercopy, then it
>>> will cause an Oops because the current check code does not allow
>>> this exceptional case.
>>>
>>>  low -----------------------------------------------------> high
>>>  [__check_object_size fp][lr][args][local vars][caller_fp][lr]
>>>                              ^----------------^
>>>                      dynamically allocated stack variable of
>>>                      caller frame copies are allowed within here
>>>
>>>  < example code snippet >
>>>  array_size = get_random_int() & 0x0f;
>>>  if (to_user) {
>>>          unsigned char array[array_size];
>>>          if (copy_to_user((void __user *)user_addr, array,
>>>                           unconst + sizeof(array))) {
>>
>> And once we have -Wvla in the build[1] by default we can revert this
>> and ignore the VLA case, yes?
>
> Yes, you are right. Once we enable -Wvla, then we don't need this.
> Thanks.
>
> BR,
> Sahara
>
>
>>
>> Reviewed-by: Kees Cook <keescook@chromium.org>
>>
>> -Kees
>>
>> [1] https://lkml.org/lkml/2018/3/7/621
>>
>>>
>>> Signed-off-by: Sahara <keun-o.park@darkmatter.ae>
>>> ---
>>>  arch/arm64/kernel/stacktrace.c | 7 ++++++-
>>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
>>> index 6d37fad..75a8f20 100644
>>> --- a/arch/arm64/kernel/stacktrace.c
>>> +++ b/arch/arm64/kernel/stacktrace.c
>>> @@ -162,8 +162,13 @@ int arch_within_stack_frames(const void *stack,
>>>          * Skip 4 non-inlined frames: <fake frame>,
>>>          * arch_within_stack_frames(), check_stack_object() and
>>>          * __check_object_size().
>>> +        *
>>> +        * From Akashi's report, an object may be placed between next caller's
>>> +        * frame, when the object is created as dynamic array.
>>> +        * Setting the discard_frames to 3 is proper to catch this exceptional
>>> +        * case.
>>>          */
>>> -       arg.discard_frames = 4;
>>> +       arg.discard_frames = 3;
>>>
>>>         walk_stackframe(current, &frame, check_frame, &arg);
>>>
>>> --
>>> 2.7.4
>>>
>>
>>
>>
>> --
>> Kees Cook
>> Pixel Security
