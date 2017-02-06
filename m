MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1486296850-16045-2-git-send-email-kpark3469@gmail.com>
References: <1486296850-16045-1-git-send-email-kpark3469@gmail.com> <1486296850-16045-2-git-send-email-kpark3469@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 6 Feb 2017 14:34:20 -0800
Message-ID: <CAGXu5jJX5M1FvQgJE6xuKN2rSsU7iv+uCN2UMOx=Gq5Tigr6vQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 2/3] arm64: usercopy: Implement stack frame object validation
To: Keun-O Park <kpark3469@gmail.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, Pratyush Anand <panand@redhat.com>, keun-o.park@darkmatter.ae
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Feb 5, 2017 at 4:14 AM,  <kpark3469@gmail.com> wrote:
> From: Sahara <keun-o.park@darkmatter.ae>
>
> This implements arch_within_stack_frames() for arm64 that should
> validate if a given object is contained by a kernel stack frame.
>
> Signed-off-by: Sahara <keun-o.park@darkmatter.ae>
> Reviewed-by: James Morse <james.morse@arm.com>
> ---
>  arch/arm64/Kconfig                   |  1 +
>  arch/arm64/include/asm/thread_info.h | 64 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 65 insertions(+)
>
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 1117421..8bf70b4 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -97,6 +97,7 @@ config ARM64
>         select HAVE_SYSCALL_TRACEPOINTS
>         select HAVE_KPROBES
>         select HAVE_KRETPROBES if HAVE_KPROBES
> +       select HAVE_ARCH_WITHIN_STACK_FRAMES
>         select IOMMU_DMA if IOMMU_SUPPORT
>         select IRQ_DOMAIN
>         select IRQ_FORCED_THREADING
> diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
> index 46c3b93..70baad3 100644
> --- a/arch/arm64/include/asm/thread_info.h
> +++ b/arch/arm64/include/asm/thread_info.h
> @@ -68,7 +68,71 @@ struct thread_info {
>  #define thread_saved_fp(tsk)   \
>         ((unsigned long)(tsk->thread.cpu_context.fp))
>
> +#define get_stack_start(fp) (fp + 2 * sizeof(void *))

This define is only used once: might be better to just leave it
open-coded below.

> +
> +/*
> + * Walks up the stack frames to make sure that the specified object is
> + * entirely contained by a single stack frame.
> + *
> + * Returns:
> + *     GOOD_FRAME      if within a frame
> + *     BAD_STACK       if placed across a frame boundary (or outside stack)
> + *     NOT_STACK       unable to determine (no frame pointers, etc)
> + */
> +
> +static inline enum stack_type arch_within_stack_frames(const void * const stack,
> +                                       const void * const stackend,
> +                                       const void *obj, unsigned long len)
> +{
> +#ifdef CONFIG_FRAME_POINTER
> +       const void *oldframe = NULL;
> +       const void *frame = NULL;

I've renamed your variables back to match the x86 implementation so I
can more easily compare the differences. Since oldframe is always
initialized, it doesn't need the = NULL above.

> +
> +       oldframe = __builtin_frame_address(1);
> +       if (oldframe)
> +               frame = *(const void * const *)oldframe;

Why this instead of __builting_frame_address(2)? Just to avoid the "2" argument?

> +       /*
> +        * Case #1:
> +        * low ----------------------------------------------> high
> +        * [callee_fp][lr][args][local vars][caller_fp'][lr']
> +        *                ^----------------^
> +        *               allow copies only within here
> +        *
> +        * Case #2:
> +        * low ----------------------------------------------> high
> +        * [check_object_size_fp][lr][args][local vars][callee_fp][lr]
> +        *                           ^----------------^
> +        *                     dynamically allocated stack variable of
> +        *                     callee frame copies are allowed within here

I don't understand how these are different cases. We're walking the
entire stack, so each frame comparison should be the same.

> +        *
> +        * < example code snippet for Case#2 >
> +        * array_size = get_random_int() & 0x0f;
> +        * if (to_user) {
> +        *         unsigned char array[array_size];
> +        *         if (copy_to_user((void __user *)user_addr, array,
> +        *                          unconst + sizeof(array))) {
> +        */
> +       while (stack <= oldframe && oldframe < stackend &&

Why does this examine oldframe instead of the current frame?

> +                       !((unsigned long)frame & 0xf)) {

What is the 0xf test?

> +               /*
> +                * If obj + len extends past the caller frame, this
> +                * check won't pass and the next frame will be 0,
> +                * causing us to bail out and correctly report
> +                * the copy as invalid.
> +                */
> +               if (!frame || (obj + len <= frame))

Excepting the initial frame test, this is identical to x86, which seems fine.

> +                       return (obj >= oldframe + 2 * sizeof(void *) ?
> +                               GOOD_FRAME : BAD_STACK;
> +               oldframe = frame;
> +               frame = *(const void * const *)frame;
> +       }
> +       return BAD_STACK;
> +#else
> +       return NOT_STACK;
>  #endif
> +}
> +
> +#endif /* !__ASSEMBLY__ */
>
>  /*
>   * thread information flags:
> --
> 2.7.4
>

I guess I just don't see the special case for arm64 frames?

-Kees

-- 
Kees Cook
Pixel Security
