MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170216182917.19637-2-james.morse@arm.com>
References: <20170216182917.19637-1-james.morse@arm.com> <20170216182917.19637-2-james.morse@arm.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 4 Apr 2017 15:19:34 -0700
Message-ID: <CAGXu5jLN81EhTdXT9mc=G0Ci-ib3PRc7jw=3DxOvEHzo-QaNgA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v4 1/3] usercopy: create enum stack_type
To: James Morse <james.morse@arm.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Pratyush Anand <panand@redhat.com>, keun-o.park@darkmatter.ae
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 16, 2017 at 10:29 AM, James Morse <james.morse@arm.com> wrote:
> From: Sahara <keun-o.park@darkmatter.ae>
>
> This patch creates enum stack_type which is only used in usercopy.c
> for now. This enum type can be used for x86 and other architecture's
> thread_info.h, which may have arch_within_stack_frames().
>
> Signed-off-by: Sahara <keun-o.park@darkmatter.ae>
> Signed-off-by: James Morse <james.morse@arm.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Acked-by: Kees Cook <keescook@chromium.org>

I've adjusted this slightly and added it to my usercopy tree for -next.

-Kees

> ---
>  arch/x86/include/asm/thread_info.h | 19 ++++++++++---------
>  include/linux/thread_info.h        | 13 ++++++++++---
>  mm/usercopy.c                      |  8 +-------
>  3 files changed, 21 insertions(+), 19 deletions(-)
>
> diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
> index ad6f5eb07a95..7af4b8b23b8b 100644
> --- a/arch/x86/include/asm/thread_info.h
> +++ b/arch/x86/include/asm/thread_info.h
> @@ -168,13 +168,13 @@ static inline unsigned long current_stack_pointer(void)
>   * entirely contained by a single stack frame.
>   *
>   * Returns:
> - *              1 if within a frame
> - *             -1 if placed across a frame boundary (or outside stack)
> - *              0 unable to determine (no frame pointers, etc)
> + *     GOOD_FRAME      if within a frame
> + *     BAD_STACK       if placed across a frame boundary (or outside stack)
> + *     NOT_STACK       unable to determine (no frame pointers, etc)
>   */
> -static inline int arch_within_stack_frames(const void * const stack,
> -                                          const void * const stackend,
> -                                          const void *obj, unsigned long len)
> +static inline enum stack_type arch_within_stack_frames(const void * const stack,
> +                                       const void * const stackend,
> +                                       const void *obj, unsigned long len)
>  {
>  #if defined(CONFIG_FRAME_POINTER)
>         const void *frame = NULL;
> @@ -197,13 +197,14 @@ static inline int arch_within_stack_frames(const void * const stack,
>                  * the copy as invalid.
>                  */
>                 if (obj + len <= frame)
> -                       return obj >= oldframe + 2 * sizeof(void *) ? 1 : -1;
> +                       return obj >= oldframe + 2 * sizeof(void *) ?
> +                               GOOD_FRAME : BAD_STACK;
>                 oldframe = frame;
>                 frame = *(const void * const *)frame;
>         }
> -       return -1;
> +       return BAD_STACK;
>  #else
> -       return 0;
> +       return NOT_STACK;
>  #endif
>  }
>
> diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
> index 58373875e8ee..a38b3be347df 100644
> --- a/include/linux/thread_info.h
> +++ b/include/linux/thread_info.h
> @@ -22,6 +22,13 @@
>  #endif
>
>  #include <linux/bitops.h>
> +
> +enum stack_type {
> +       BAD_STACK = -1,
> +       NOT_STACK = 0,
> +       GOOD_FRAME,
> +       GOOD_STACK,
> +};
>  #include <asm/thread_info.h>
>
>  #ifdef __KERNEL__
> @@ -77,9 +84,9 @@ static inline int test_ti_thread_flag(struct thread_info *ti, int flag)
>  #define tif_need_resched() test_thread_flag(TIF_NEED_RESCHED)
>
>  #ifndef CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES
> -static inline int arch_within_stack_frames(const void * const stack,
> -                                          const void * const stackend,
> -                                          const void *obj, unsigned long len)
> +static inline enum stack_type arch_within_stack_frames(const void * const stack,
> +                                       const void * const stackend,
> +                                       const void *obj, unsigned long len)
>  {
>         return 0;
>  }
> diff --git a/mm/usercopy.c b/mm/usercopy.c
> index 3c8da0af9695..3531ae735d87 100644
> --- a/mm/usercopy.c
> +++ b/mm/usercopy.c
> @@ -16,15 +16,9 @@
>
>  #include <linux/mm.h>
>  #include <linux/slab.h>
> +#include <linux/thread_info.h>
>  #include <asm/sections.h>
>
> -enum {
> -       BAD_STACK = -1,
> -       NOT_STACK = 0,
> -       GOOD_FRAME,
> -       GOOD_STACK,
> -};
> -
>  /*
>   * Checks if a given pointer and length is contained by the current
>   * stack frame (if possible).
> --
> 2.10.1
>



-- 
Kees Cook
Pixel Security
