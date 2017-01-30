MIME-Version: 1.0
In-Reply-To: <CAGXu5j+ZFDJgHnWpYcaXupLh8KS=9pMsWY-LydrjavEv4w27SQ@mail.gmail.com>
References: <1485351983-13873-1-git-send-email-kpark3469@gmail.com>
 <20170125135410.GF27026@arm.com> <CA+KhAHY-2+nWBYwgBvu0v_yVBb8sizkYyGOPiW3DxX+EJi7sBg@mail.gmail.com>
 <CAGXu5j+ZFDJgHnWpYcaXupLh8KS=9pMsWY-LydrjavEv4w27SQ@mail.gmail.com>
From: Keun-O Park <kpark3469@gmail.com>
Date: Mon, 30 Jan 2017 15:26:56 +0400
Message-ID: <CA+KhAHZgtTQz+ig=_G+YvasKFw6RjfMj=6EYF8sd6vs5eL1bKg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] arm64: usercopy: Implement stack frame object validation
To: Kees Cook <keescook@chromium.org>
Cc: Will Deacon <will.deacon@arm.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, Pratyush Anand <panand@redhat.com>, keun-o.park@darkmatter.ae, AKASHI Takahiro <takahiro.akashi@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hello Kees,

Thanks for the suggestion about lkdtm. Yes, it worked correctly.
provoke-crash# echo USERCOPY_STACK_FRAME_TO > DIRECT
[11388.369172] lkdtm: Performing direct entry USERCOPY_STACK_FRAME_TO
[11388.369259] lkdtm: attempting good copy_to_user of local stack
[11388.369366] lkdtm: attempting bad copy_to_user of distant stack
[11388.369453] usercopy: kernel memory exposure attempt detected from
ffffffc87985fd60 (<process stack>) (32 bytes)

provoke-crash# echo USERCOPY_STACK_FRAME_FROM > DIRECT
[12687.156830] lkdtm: Performing direct entry USERCOPY_STACK_FRAME_FROM
[12687.156918] lkdtm: attempting good copy_from_user of local stack
[12687.156995] lkdtm: attempting bad copy_from_user of distant stack
[12687.157082] usercopy: kernel memory overwrite attempt detected to
ffffffc87985fd60 (<process stack>) (32 bytes)

One thing I want to ask is..
Does USERCOPY_HEAP_FLAG_FROM/TO work correctly in latest kernel?
Both on Pixel(v3.18) and on emulator(v4.10-rc5)
In these two cases the bad attempt passed. I guess the code for this
test might not be ready. Am I right?

Thanks.

BR
Sahara


On Thu, Jan 26, 2017 at 4:58 AM, Kees Cook <keescook@chromium.org> wrote:
> On Wed, Jan 25, 2017 at 6:44 AM, Keun-O Park <kpark3469@gmail.com> wrote:
>> On Wed, Jan 25, 2017 at 5:54 PM, Will Deacon <will.deacon@arm.com> wrote:
>>> [Adding Akashi, since he'a had fun and games with arm64 stack unwinding
>>>  and I bet he can find a problem with this patch!]
>>>
>>> On Wed, Jan 25, 2017 at 05:46:23PM +0400, kpark3469@gmail.com wrote:
>>>> From: Sahara <keun-o.park@darkmatter.ae>
>>>>
>>>> This implements arch_within_stack_frames() for arm64 that should
>>>> validate if a given object is contained by a kernel stack frame.
>>>>
>>>> Signed-off-by: Sahara <keun-o.park@darkmatter.ae>
>
> Awesome! Thanks for working on this!
>
>>>> ---
>>>>  arch/arm64/Kconfig                   |  1 +
>>>>  arch/arm64/include/asm/thread_info.h | 55 ++++++++++++++++++++++++++++++++++++
>>>>  2 files changed, 56 insertions(+)
>>>>
>>>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>>>> index 1117421..8bf70b4 100644
>>>> --- a/arch/arm64/Kconfig
>>>> +++ b/arch/arm64/Kconfig
>>>> @@ -97,6 +97,7 @@ config ARM64
>>>>       select HAVE_SYSCALL_TRACEPOINTS
>>>>       select HAVE_KPROBES
>>>>       select HAVE_KRETPROBES if HAVE_KPROBES
>>>> +     select HAVE_ARCH_WITHIN_STACK_FRAMES
>>>>       select IOMMU_DMA if IOMMU_SUPPORT
>>>>       select IRQ_DOMAIN
>>>>       select IRQ_FORCED_THREADING
>>>> diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
>>>> index 46c3b93..f610c44 100644
>>>> --- a/arch/arm64/include/asm/thread_info.h
>>>> +++ b/arch/arm64/include/asm/thread_info.h
>>>> @@ -68,7 +68,62 @@ struct thread_info {
>>>>  #define thread_saved_fp(tsk) \
>>>>       ((unsigned long)(tsk->thread.cpu_context.fp))
>>>>
>>>> +/*
>>>> + * Walks up the stack frames to make sure that the specified object is
>>>> + * entirely contained by a single stack frame.
>>>> + *
>>>> + * Returns:
>>>> + *            1 if within a frame
>>>> + *           -1 if placed across a frame boundary (or outside stack)
>>>> + *            0 unable to determine (no frame pointers, etc)
>>>> + */
>>>> +static inline int arch_within_stack_frames(const void * const stack,
>>>> +                                        const void * const stackend,
>>>> +                                        const void *obj, unsigned long len)
>>>> +{
>>>> +#if defined(CONFIG_FRAME_POINTER)
>>>> +     const void *oldframe;
>>>> +     const void *callee_fp = NULL;
>>>> +     const void *caller_fp = NULL;
>>>> +
>>>> +     oldframe = __builtin_frame_address(1);
>>>> +     if (oldframe) {
>>>> +             callee_fp = __builtin_frame_address(2);
>>>> +             if (callee_fp)
>>>> +                     caller_fp = __builtin_frame_address(3);
>>>> +     }
>>>> +     /*
>>>> +      * low ----------------------------------------------> high
>>>> +      * [callee_fp][lr][args][local vars][caller_fp'][lr']
>>>> +      *                ^----------------^
>>>> +      *               allow copies only within here
>>>> +      */
>>>
>>> Which compilers have you tested this with? The GCC folks don't guarantee a
>>> frame layout, and they have changed it in the past, so I suspect this is
>>> pretty fragile. In particularly, if __builtin_frame_address just points
>>> at the frame record, then I don't think you can make assumptions about the
>>> placement of local variables and arguments with respect to that.
>
> How often has it changed in the past? That seems like a strange thing
> to change; either it's aligned and efficiently organized, or ... not?
>
>>>
>>> Will
>>
>> $ aarch64-linux-android-gcc --version
>> aarch64-linux-android-gcc (GCC) 4.9 20150123 (prerelease)
>>
>> I tested this with aosp 7.1 android toolchain on Pixel.
>> Maybe I need a suggestion to make this robust.
>
> I wonder if some kind of BUILD_BUG_ON() magic could be used to
> validate the relative positions of things on the stack? Or in the
> worst case, a boot-time BUG() check...
>
> Did you happen to test the lkdtm USERCOPY_STACK_FRAME_TO and
> USERCOPY_STACK_FRAME_FROM tests to make sure they tripped correctly?
>
> -Kees
>
> --
> Kees Cook
> Nexus Security
