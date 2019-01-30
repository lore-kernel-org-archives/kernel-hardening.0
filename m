Subject: Re: [PATCH] mm: Prevent mapping typed pages to userspace
References: <20190129053830.3749-1-willy@infradead.org>
From: David Hildenbrand <david@redhat.com>
Message-ID: <44ea1fd9-f0ae-f031-0232-05afbd7aa7e5@redhat.com>
Date: Wed, 30 Jan 2019 13:01:23 +0100
MIME-Version: 1.0
In-Reply-To: <20190129053830.3749-1-willy@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Michael Ellerman <mpe@ellerman.id.au>, Will Deacon <will.deacon@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 29.01.19 06:38, Matthew Wilcox wrote:
> Pages which use page_type must never be mapped to userspace as it would
> destroy their page type.  Add an explicit check for this instead of
> assuming that kernel drivers always get this right.
> 
> Signed-off-by: Matthew Wilcox <willy@infradead.org>
> ---
>  mm/memory.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index ce8c90b752be..db3534bbd652 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1451,7 +1451,7 @@ static int insert_page(struct vm_area_struct *vma, unsigned long addr,
>  	spinlock_t *ptl;
>  
>  	retval = -EINVAL;
> -	if (PageAnon(page) || PageSlab(page))
> +	if (PageAnon(page) || PageSlab(page) || page_has_type(page))
>  		goto out;
>  	retval = -ENOMEM;
>  	flush_dcache_page(page);
> 

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 

Thanks,

David / dhildenb
