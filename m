MIME-Version: 1.0
In-Reply-To: <20170126071010.GE23406@linaro.org>
References: <1485351983-13873-1-git-send-email-kpark3469@gmail.com>
 <20170125135410.GF27026@arm.com> <20170126071010.GE23406@linaro.org>
From: Keun-O Park <kpark3469@gmail.com>
Date: Mon, 30 Jan 2017 16:42:23 +0400
Message-ID: <CA+KhAHbdYEdwqo5EspmkEPnvyucS2jStR_rhCe9H497T9jJ9aA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] arm64: usercopy: Implement stack frame object validation
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>, kernel-hardening@lists.openwall.com, Catalin Marinas <catalin.marinas@arm.com>, Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, Pratyush Anand <panand@redhat.com>, keun-o.park@darkmatter.ae
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 26, 2017 at 11:10 AM, AKASHI Takahiro
<takahiro.akashi@linaro.org> wrote:
> On Wed, Jan 25, 2017 at 01:54:10PM +0000, Will Deacon wrote:
>> [Adding Akashi, since he'a had fun and games with arm64 stack unwinding
>>  and I bet he can find a problem with this patch!]
>
> I have had hard time to play with that :)
>
>> On Wed, Jan 25, 2017 at 05:46:23PM +0400, kpark3469@gmail.com wrote:
>> > From: Sahara <keun-o.park@darkmatter.ae>
>> >
>> > This implements arch_within_stack_frames() for arm64 that should
>> > validate if a given object is contained by a kernel stack frame.
>> >
>> > Signed-off-by: Sahara <keun-o.park@darkmatter.ae>
>> > ---
>> >  arch/arm64/Kconfig                   |  1 +
>> >  arch/arm64/include/asm/thread_info.h | 55 ++++++++++++++++++++++++++++++++++++
>> >  2 files changed, 56 insertions(+)
>> >
>> > diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> > index 1117421..8bf70b4 100644
>> > --- a/arch/arm64/Kconfig
>> > +++ b/arch/arm64/Kconfig
>> > @@ -97,6 +97,7 @@ config ARM64
>> >     select HAVE_SYSCALL_TRACEPOINTS
>> >     select HAVE_KPROBES
>> >     select HAVE_KRETPROBES if HAVE_KPROBES
>> > +   select HAVE_ARCH_WITHIN_STACK_FRAMES
>> >     select IOMMU_DMA if IOMMU_SUPPORT
>> >     select IRQ_DOMAIN
>> >     select IRQ_FORCED_THREADING
>> > diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
>> > index 46c3b93..f610c44 100644
>> > --- a/arch/arm64/include/asm/thread_info.h
>> > +++ b/arch/arm64/include/asm/thread_info.h
>> > @@ -68,7 +68,62 @@ struct thread_info {
>> >  #define thread_saved_fp(tsk)       \
>> >     ((unsigned long)(tsk->thread.cpu_context.fp))
>> >
>> > +/*
>> > + * Walks up the stack frames to make sure that the specified object is
>> > + * entirely contained by a single stack frame.
>> > + *
>> > + * Returns:
>> > + *          1 if within a frame
>> > + *         -1 if placed across a frame boundary (or outside stack)
>> > + *          0 unable to determine (no frame pointers, etc)
>> > + */
>> > +static inline int arch_within_stack_frames(const void * const stack,
>> > +                                      const void * const stackend,
>> > +                                      const void *obj, unsigned long len)
>> > +{
>> > +#if defined(CONFIG_FRAME_POINTER)
>
> nitpick: s/#if defined()/#ifdef/, or just remove this guard?
>
>> > +   const void *oldframe;
>> > +   const void *callee_fp = NULL;
>> > +   const void *caller_fp = NULL;
>> > +
>> > +   oldframe = __builtin_frame_address(1);
>> > +   if (oldframe) {
>> > +           callee_fp = __builtin_frame_address(2);
>> > +           if (callee_fp)
>> > +                   caller_fp = __builtin_frame_address(3);
>> > +   }
>> > +   /*
>> > +    * low ----------------------------------------------> high
>> > +    * [callee_fp][lr][args][local vars][caller_fp'][lr']
>> > +    *                ^----------------^
>> > +    *               allow copies only within here
>> > +    */
>>
>> Which compilers have you tested this with? The GCC folks don't guarantee a
>> frame layout, and they have changed it in the past,
>
> I don't know whether any changes have been made before or not, but
>
>> so I suspect this is
>> pretty fragile. In particularly, if __builtin_frame_address just points
>> at the frame record, then I don't think you can make assumptions about the
>> placement of local variables and arguments with respect to that.
>>
>> Will
>
> Yes and no.
>
> AAPCS64 says,
> - The stack implementation is full-descending (5.2.2)
> - A process may only access (for reading or writing) the closed interval
>   of the entire stack delimited by [SP, stack-base - 1]. (5.2.2.1)
> - The location of the frame record within a stack frame is not specified
>   (5.2.3)
>
> To my best knowledge, dynamically allocated object (local variable) may be
> allocated below the current frame pointer, decrementing the stack pointer.
> Take a look at a simple example:
>
> ===8<===
> #include <stdio.h>
> #include <stdlib.h>
>
> int main(int ac, char **av) {
>         int array_size;
>         register unsigned long sp asm("sp");
>
>         if (ac < 2) {
>                 printf("No argument\n");
>                 return 1;
>         }
>         array_size = atoi(av[1]);
>         printf("frame pointer: %lx\n", __builtin_frame_address(0));
>         printf("Before dynamic alloc: %lx\n", sp);
>         {
>                 long array[array_size];
>
>                 printf("After dynamic alloc: %lx\n", sp);
>         }
>
>         return 0;
> }
> ===>8===
>
> and the result (with gcc 5.3) is:
>   frame pointer:        ffffe32bacd0
>   Before dynamic alloc: ffffe32bacd0
>   After dynamic alloc:  ffffe32bac70
>
> Given this fact,
>
>> > +   /*
>> > +    * low ----------------------------------------------> high
>> > +    * [callee_fp][lr][args][local vars][caller_fp'][lr']
>> > +    *                ^----------------^
>> > +    *               allow copies only within here
>> > +    */
>
> this picture may not always be precise in that "local variables" are
> local to the callee, OR possibly local to the *caller*.
> However, the range check is done here in a while loop that walks through
> the whole callstack chain, and so I assume that it would work in most cases
> except the case that a callee function hits that usage.
>
> I think there are a few (not many) places of such code in the kernel,
> (around net IIRC, but don' know they call usercopy functions or not).

Hello AKASHI,

Thanks so much for the example code. Basically I totally missed this case.
I modified do_usercopy_stack() slightly following your code snippet.
Like your comment, I could see the similar result.
....
        array_size = get_random_int() & 0x0F;
        if (to_user) {
                unsigned char array[array_size];
....
                pr_info("attempting bad copy_to_user of distant stack 2\n");
                if (copy_to_user((void __user *)user_addr, array,
                                 unconst + sizeof(array))) {
                        pr_warn("copy_to_user failed, but lacked Oops\n");
                        goto free_user;
                }
....
# echo USERCOPY_STACK_FRAME_TO > DIRECT
[ 1999.832209] Before dynamic alloc: ffffffc079013d40
[ 1999.832309] After dynamic alloc: ffffffc079013d40
[ 1999.832370] lkdtm: attempting good copy_to_user of local stack
[ 1999.832476] lkdtm: attempting bad copy_to_user of distant stack
[ 1999.832562] usercopy: kernel memory exposure attempt detected from
ffffffc079013d20 (<process stack>) (32 bytes)
[ 1999.832636] usercopy: BUG()!!!
[ 1999.832693] lkdtm: attempting bad copy_to_user of distant stack 2
[ 1999.832779] usercopy: kernel memory exposure attempt detected from
ffffffc079013d30 (<process stack>) (6 bytes)
[ 1999.832853] usercopy: BUG()!!!

This is output of GCC 4.9, so maybe the sp value is not expected one.
Anyway it looks to me that the object should be scanned from oldframe.

Thank you.

BR
Sahara

>
> Thanks,
> -Takahiro AKASHI
