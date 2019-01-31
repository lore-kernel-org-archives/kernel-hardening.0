Subject: Re: [PATCH] mm: Prevent mapping slab pages to userspace
References: <20190125173827.2658-1-willy@infradead.org>
From: Pekka Enberg <penberg@iki.fi>
Message-ID: <f1cd3105-2d36-a699-ed4c-e293d26b828d@iki.fi>
Date: Thu, 31 Jan 2019 08:03:54 +0200
MIME-Version: 1.0
In-Reply-To: <20190125173827.2658-1-willy@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Rik van Riel <riel@surriel.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Michael Ellerman <mpe@ellerman.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

On 25/01/2019 19.38, Matthew Wilcox wrote:
> It's never appropriate to map a page allocated by SLAB into userspace.
> A buggy device driver might try this, or an attacker might be able to
> find a way to make it happen.
> 
> Signed-off-by: Matthew Wilcox <willy@infradead.org>

Acked-by: Pekka Enberg <penberg@kernel.org>

A WARN_ON_ONCE() would be nice here to let those buggy drivers know that 
they will no longer work.

> ---
>   mm/memory.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index e11ca9dd823f..ce8c90b752be 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1451,7 +1451,7 @@ static int insert_page(struct vm_area_struct *vma, unsigned long addr,
>   	spinlock_t *ptl;
>   
>   	retval = -EINVAL;
> -	if (PageAnon(page))
> +	if (PageAnon(page) || PageSlab(page))
>   		goto out;
>   	retval = -ENOMEM;
>   	flush_dcache_page(page);
> 
