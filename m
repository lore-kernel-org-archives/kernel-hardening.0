From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH] mm: Prevent mapping slab pages to userspace
In-Reply-To: <20190125173827.2658-1-willy@infradead.org>
References: <20190125173827.2658-1-willy@infradead.org>
Date: Thu, 31 Jan 2019 11:37:10 +1100
Message-ID: <87bm3xpsqx.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
To: Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Rik van Riel <riel@surriel.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

Matthew Wilcox <willy@infradead.org> writes:

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
>  	spinlock_t *ptl;
>  
>  	retval = -EINVAL;
> -	if (PageAnon(page))
> +	if (PageAnon(page) || PageSlab(page))
>  		goto out;
>  	retval = -ENOMEM;
>  	flush_dcache_page(page);


Thanks for turning this into an actual patch.

cheers
