MIME-Version: 1.0
References: <20190129053830.3749-1-willy@infradead.org>
In-Reply-To: <20190129053830.3749-1-willy@infradead.org>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 29 Jan 2019 21:09:30 +1300
Message-ID: <CAGXu5jLbC1-T9JbYcDcXjA2G3jv3DLCWSUvJf3KiA8so2XC19g@mail.gmail.com>
Subject: Re: [PATCH] mm: Prevent mapping typed pages to userspace
Content-Type: text/plain; charset="UTF-8"
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Michael Ellerman <mpe@ellerman.id.au>, Will Deacon <will.deacon@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jan 29, 2019 at 6:38 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> Pages which use page_type must never be mapped to userspace as it would
> destroy their page type.  Add an explicit check for this instead of
> assuming that kernel drivers always get this right.
>
> Signed-off-by: Matthew Wilcox <willy@infradead.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  mm/memory.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index ce8c90b752be..db3534bbd652 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1451,7 +1451,7 @@ static int insert_page(struct vm_area_struct *vma, unsigned long addr,
>         spinlock_t *ptl;
>
>         retval = -EINVAL;
> -       if (PageAnon(page) || PageSlab(page))
> +       if (PageAnon(page) || PageSlab(page) || page_has_type(page))
>                 goto out;
>         retval = -ENOMEM;
>         flush_dcache_page(page);
> --
> 2.20.1
>


-- 
Kees Cook
