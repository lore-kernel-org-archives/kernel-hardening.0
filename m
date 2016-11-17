Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1479376267-18486-1-git-send-email-mpe@ellerman.id.au>
References: <1479376267-18486-1-git-send-email-mpe@ellerman.id.au>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 17 Nov 2016 12:01:51 -0800
Message-ID: <CAGXu5j++5zg8+uLyMfYgq4jiUg_1AM6kKyD_ZgKUczrsg2yiTA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2] slab: Add POISON_POINTER_DELTA to ZERO_SIZE_PTR
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 17, 2016 at 1:51 AM, Michael Ellerman <mpe@ellerman.id.au> wrote:
> POISON_POINTER_DELTA is defined in poison.h, and is intended to be used
> to shift poison values so that they don't alias userspace.
>
> We should add it to ZERO_SIZE_PTR so that attackers can't use
> ZERO_SIZE_PTR as a way to get a non-NULL pointer to userspace.
>
> Currently ZERO_OR_NULL_PTR() uses a trick of doing a single check that
> x <= ZERO_SIZE_PTR, and ignoring the fact that it also matches 1-15.
> That no longer really works once we add the poison delta, so split it
> into two checks. Assign x to a temporary to avoid evaluating it
> twice (suggested by Kees Cook).
>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>

I continue to like this idea. If we want to avoid the loss of the 1-15
check, we could just explicitly retain it, see craziness below...

> ---
>  include/linux/slab.h | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> v2: Rework ZERO_OR_NULL_PTR() to do the two checks separately.
>
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 084b12bad198..404419d9860f 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -12,6 +12,7 @@
>  #define        _LINUX_SLAB_H
>
>  #include <linux/gfp.h>
> +#include <linux/poison.h>
>  #include <linux/types.h>
>  #include <linux/workqueue.h>
>
> @@ -109,10 +110,13 @@
>   * ZERO_SIZE_PTR can be passed to kfree though in the same way that NULL can.
>   * Both make kfree a no-op.
>   */
> -#define ZERO_SIZE_PTR ((void *)16)

#define __ZERO_SIZE_PTR((void *)16)
#define ZERO_SIZE_PTR ((void *)(__ZERO_SIZE_PTR + POISON_POINTER_DELTA))

>
> -#define ZERO_OR_NULL_PTR(x) ((unsigned long)(x) <= \
> -                               (unsigned long)ZERO_SIZE_PTR)
> +#define ZERO_OR_NULL_PTR(x)                            \
> +       ({                                              \
> +               void *p = (void *)(x);                  \
              (p < __ZERO_SIZE_PTR || p == ZERO_SIZE_PTR);      \
> +       })

#undef __ZERO_SIZE_PTR

?

Anyone else have thoughts on this?

-Kees

-- 
Kees Cook
Nexus Security
