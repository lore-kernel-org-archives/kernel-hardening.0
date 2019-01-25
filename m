MIME-Version: 1.0
References: <20190125173827.2658-1-willy@infradead.org>
In-Reply-To: <20190125173827.2658-1-willy@infradead.org>
From: Kees Cook <keescook@chromium.org>
Date: Sat, 26 Jan 2019 07:44:40 +1300
Message-ID: <CAGXu5jJ=yHXC_S_o6V4QQ+DCV4w2T-tw_BiUXDAW2a8rZDhZJg@mail.gmail.com>
Subject: Re: [PATCH] mm: Prevent mapping slab pages to userspace
Content-Type: text/plain; charset="UTF-8"
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@surriel.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Michael Ellerman <mpe@ellerman.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Jan 26, 2019 at 6:38 AM Matthew Wilcox <willy@infradead.org> wrote:
>
> It's never appropriate to map a page allocated by SLAB into userspace.
> A buggy device driver might try this, or an attacker might be able to
> find a way to make it happen.
>
> Signed-off-by: Matthew Wilcox <willy@infradead.org>
> ---
>  mm/memory.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index e11ca9dd823f..ce8c90b752be 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1451,7 +1451,7 @@ static int insert_page(struct vm_area_struct *vma, unsigned long addr,
>         spinlock_t *ptl;
>
>         retval = -EINVAL;
> -       if (PageAnon(page))
> +       if (PageAnon(page) || PageSlab(page))

Are there other types that should not get mapped? (Or better yet, is
there a whitelist of those that are okay to be mapped?)

Either way, this sounds good. :)

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

>                 goto out;
>         retval = -ENOMEM;
>         flush_dcache_page(page);
> --
> 2.20.1
>


-- 
Kees Cook
