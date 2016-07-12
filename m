Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1465420302-23754-2-git-send-email-keescook@chromium.org>
References: <1465420302-23754-1-git-send-email-keescook@chromium.org> <1465420302-23754-2-git-send-email-keescook@chromium.org>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 12 Jul 2016 19:04:52 -0400
Message-ID: <CAGXu5j+6ObHXB7E_Ynb3uB36EPtSnM7C3aZ2xLjqgBfVpxVp4Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2 1/4] mm: Hardened usercopy
To: PaX Team <pageexec@freemail.hu>
Cc: Brad Spengler <spender@grsecurity.net>, Casey Schaufler <casey.schaufler@intel.com>, Rik van Riel <riel@redhat.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 8, 2016 at 5:11 PM, Kees Cook <keescook@chromium.org> wrote:
> This is an attempt at porting PAX_USERCOPY into the mainline kernel,
> calling it CONFIG_HARDENED_USERCOPY. The work is based on code by Brad
> Spengler and PaX Team, and an earlier port from Casey Schaufler.
>
> This patch contains the logic for validating several conditions when
> performing copy_to_user() and copy_from_user() on the kernel object
> being copied to/from:
> - if on the heap:
>   - the size of copy must be less than or equal to the size of the object
> - if on the stack (and we have architecture/build support for frames):
>   - object must be contained by the current stack frame
> - object must not be contained in the kernel text
>
> Additional restrictions are in following patches.
>
> This implements the checks on many architectures, but I have only tested
> x86_64 so far. I would love to see an arm64 port added as well.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> [...]
> +/*
> + * Checks if a given pointer and length is contained by the current
> + * stack frame (if possible).
> + *
> + *     0: not at all on the stack
> + *     1: fully on the stack (when can't do frame-checking)
> + *     2: fully inside the current stack frame
> + *     -1: error condition (invalid stack position or bad stack frame)
> + */
> +static noinline int check_stack_object(const void *obj, unsigned long len)
> +{
> +       const void * const stack = task_stack_page(current);
> +       const void * const stackend = stack + THREAD_SIZE;
> +
> +#if defined(CONFIG_FRAME_POINTER) && defined(CONFIG_X86)
> +       const void *frame = NULL;
> +       const void *oldframe;
> +#endif
> +
> +       /* Reject: object wraps past end of memory. */
> +       if (obj + len < obj)
> +               return -1;
> +
> +       /* Object is not on the stack at all. */
> +       if (obj + len <= stack || stackend <= obj)
> +               return 0;
> +
> +       /*
> +        * Reject: object partially overlaps the stack (passing the
> +        * the check above means at least one end is within the stack,
> +        * so if this check fails, the other end is outside the stack).
> +        */
> +       if (obj < stack || stackend < obj + len)
> +               return -1;
> +
> +#if defined(CONFIG_FRAME_POINTER) && defined(CONFIG_X86)
> +       oldframe = __builtin_frame_address(1);
> +       if (oldframe)
> +               frame = __builtin_frame_address(2);
> +       /*
> +        * low ----------------------------------------------> high
> +        * [saved bp][saved ip][args][local vars][saved bp][saved ip]
> +        *                   ^----------------^
> +        *             allow copies only within here
> +        */
> +       while (stack <= frame && frame < stackend) {
> +               /*
> +                * If obj + len extends past the last frame, this
> +                * check won't pass and the next frame will be 0,
> +                * causing us to bail out and correctly report
> +                * the copy as invalid.
> +                */
> +               if (obj + len <= frame)
> +                       return obj >= oldframe + 2 * sizeof(void *) ? 2 : -1;
> +               oldframe = frame;
> +               frame = *(const void * const *)frame;
> +       }
> +       return -1;
> +#else
> +       return 1;
> +#endif
> +}

PaX Team,

Doesn't this checking leave (possible) stack canaries exposed to being
copied to userspace? I'm at a loss for a way to reliably determine if
they're present or not, though...

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
