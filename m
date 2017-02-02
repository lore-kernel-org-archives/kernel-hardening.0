MIME-Version: 1.0
In-Reply-To: <588A1465.4040802@arm.com>
References: <1485351983-13873-1-git-send-email-kpark3469@gmail.com> <588A1465.4040802@arm.com>
From: Keun-O Park <kpark3469@gmail.com>
Date: Thu, 2 Feb 2017 17:34:06 +0400
Message-ID: <CA+KhAHbmahpgPwjb1yOLDnT6Nw+W4kU+cJ0cO3LMBmxUeXyupA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] arm64: usercopy: Implement stack frame object validation
To: James Morse <james.morse@arm.com>
Cc: kernel-hardening@lists.openwall.com, Catalin Marinas <catalin.marinas@arm.com>, Kees Cook <keescook@chromium.org>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Pratyush Anand <panand@redhat.com>, keun-o.park@darkmatter.ae
List-ID: <kernel-hardening.lists.openwall.com>

Hello James,


On Thu, Jan 26, 2017 at 7:23 PM, James Morse <james.morse@arm.com> wrote:
> Hi Sahara,
>
> On 25/01/17 13:46, kpark3469@gmail.com wrote:
>> From: Sahara <keun-o.park@darkmatter.ae>
>>
>> This implements arch_within_stack_frames() for arm64 that should
>> validate if a given object is contained by a kernel stack frame.
>
> Thanks for wade-ing into this, walking the stack is horribly tricky!
>
>
>> diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
>> index 46c3b93..f610c44 100644
>> --- a/arch/arm64/include/asm/thread_info.h
>> +++ b/arch/arm64/include/asm/thread_info.h
>> @@ -68,7 +68,62 @@ struct thread_info {
>>  #define thread_saved_fp(tsk) \
>>       ((unsigned long)(tsk->thread.cpu_context.fp))
>>
>> +/*
>> + * Walks up the stack frames to make sure that the specified object is
>> + * entirely contained by a single stack frame.
>> + *
>> + * Returns:
>> + *            1 if within a frame
>> + *           -1 if placed across a frame boundary (or outside stack)
>> + *            0 unable to determine (no frame pointers, etc)
>
> (Shame the enum in mm/usercopy.c that explains these isn't exposed)

I exposed the enum in mm/usercopy.c by creating and moving to
usercopy.h in v2 patch


>
>
>> + */
>> +static inline int arch_within_stack_frames(const void * const stack,
>> +                                        const void * const stackend,
>> +                                        const void *obj, unsigned long len)
>> +{
>> +#if defined(CONFIG_FRAME_POINTER)
>> +     const void *oldframe;
>> +     const void *callee_fp = NULL;
>> +     const void *caller_fp = NULL;
>> +
>> +     oldframe = __builtin_frame_address(1);
>
> So we always discard _our_ callers frame. This will vary depending on the
> compilers choice on whether or not to inline this function. Its either
> check_stack_object() (which is declared noinline) or __check_object_size().
> I think this is fine either way as obj should never be in the stack-frames of
> these functions.

Unfortunately Akashi reported that obj can be placed at the
stack-frame of these functions,
when dynamic array is used.

>
>
>> +     if (oldframe) {
>> +             callee_fp = __builtin_frame_address(2);
>> +             if (callee_fp)
>> +                     caller_fp = __builtin_frame_address(3);
>> +     }
>> +     /*
>> +      * low ----------------------------------------------> high
>> +      * [callee_fp][lr][args][local vars][caller_fp'][lr']
>
> These are the caller's args and local_vars right?

No, unless my test is wrong, these are callee's args and local vars.

>
>
>> +      *                ^----------------^
>> +      *               allow copies only within here
>> +      */
>> +     while (stack <= callee_fp && callee_fp < stackend) {
>> +             /*
>> +              * If obj + len extends past the caller frame, this
>> +              * check won't pass and the next frame will be 0,
>> +              * causing us to bail out and correctly report
>> +              * the copy as invalid.
>> +              */
>> +             if (!caller_fp) {
>
>> +                     if (obj + len <= stackend)
>
> Isn't this always true? check_stack_object() does this:
>>       if (obj < stack || stackend < obj + len)
>>               return BAD_STACK;
>

You're right. This is redundant check. Thanks.

>
>> +                             return (obj >= callee_fp + 2 * sizeof(void *)) ?
>> +                                     1 : -1;
>
> You do this twice (and its pretty complicated), can you make it a macro with an
> explanatory name? (I think its calculating caller_frame_end from callee_fp,
> having something like caller_frame_start and caller_frame_end would make this
> easier to follow).
>

As your suggestion, I added a macro like get_stack_start()


>
>> +                     else
>> +                             return -1;
>> +             }
>> +             if (obj + len <= caller_fp)
>> +                     return (obj >= callee_fp + 2 * sizeof(void *)) ? 1 : -1;
>> +             callee_fp = caller_fp;
>> +             caller_fp = *(const void * const *)caller_fp;
>
> You test caller_fp lies within the stack next time round the loop, what happens
> if it is miss-aligned? unwind_frame() tests the new fp to check it was 16-byte
> aligned. If not, its probably a corrupted stack frame.

I added missing check for misaligned frame pointer. Thanks.

>
> I wonder if you can make use of unwind_frame()? We have existing machinery for
> walking up the stack, (it takes a callback and you can stop the walk early).
> If you move this function into arch/arm64/kernel/stacktrace.c, you could make
> use of walk_stackframe().

Without modifying existing x86 code for arch_within_stack_frames and
mm/usercopy.c,
it looks to me that it might not be feasible to use unwind_frame().
But, I didn't meticulously consider this point.

>
> I guess you aren't using it because it doesn't give you start/end ranges for
> each stack frame, I think you can get away without this, the callback would only
> needs to test that the provided frame->fp doesn't lie between obj and (obj+len).
> Calculating the frame start and end is extra work for the bounds test - we
> already know obj is contained by the stack so its just a question of whether it
> overlaps an fp record.

Exactly. :-)

>
>
>> +     }
>> +     return -1;
>
> check_stack_object()'s use of task_stack_page(current) means you will never see
> this run on the irq-stack, so no need to worry about stepping between stacks.
>
> This looks correct to me, walking the stack is unavoidably complex, I wonder if
> we can avoid having another stack walker by using the existing framework?
>
>
>
>
> Thanks,
>
> James
