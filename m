Subject: Re: [PATCH 3/7] struct page: add field for vm_struct
References: <20180228200620.30026-1-igor.stoppa@huawei.com>
 <20180228200620.30026-4-igor.stoppa@huawei.com>
From: J Freyensee <why2jjj.linux@gmail.com>
Message-ID: <2985e90a-5937-9432-c53e-f594b27e7afa@gmail.com>
Date: Mon, 5 Mar 2018 12:31:14 -0800
MIME-Version: 1.0
In-Reply-To: <20180228200620.30026-4-igor.stoppa@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Igor Stoppa <igor.stoppa@huawei.com>, david@fromorbit.com, willy@infradead.org, keescook@chromium.org, mhocko@kernel.org
Cc: labbott@redhat.com, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Reviewed-by: Jay Freyensee <why2jjj.linux@gmail.com>

On 2/28/18 12:06 PM, Igor Stoppa wrote:
> When a page is used for virtual memory, it is often necessary to obtain
> a handler to the corresponding vm_struct, which refers to the virtually
> continuous area generated when invoking vmalloc.
>
> The struct page has a "mapping" field, which can be re-used, to store a
> pointer to the parent area.
>
> This will avoid more expensive searches, later on.
>
> Signed-off-by: Igor Stoppa <igor.stoppa@huawei.com>
> ---
>   include/linux/mm_types.h | 1 +
>   mm/vmalloc.c             | 2 ++
>   2 files changed, 3 insertions(+)
>
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index fd1af6b9591d..c3a4825e10c0 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -84,6 +84,7 @@ struct page {
>   		void *s_mem;			/* slab first object */
>   		atomic_t compound_mapcount;	/* first tail page */
>   		/* page_deferred_list().next	 -- second tail page */
> +		struct vm_struct *area;
>   	};
>   
>   	/* Second double word */
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index ebff729cc956..61a1ca22b0f6 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -1536,6 +1536,7 @@ static void __vunmap(const void *addr, int deallocate_pages)
>   			struct page *page = area->pages[i];
>   
>   			BUG_ON(!page);
> +			page->area = NULL;
>   			__free_pages(page, 0);
>   		}
>   
> @@ -1705,6 +1706,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>   			area->nr_pages = i;
>   			goto fail;
>   		}
> +		page->area = area;
>   		area->pages[i] = page;
>   		if (gfpflags_allow_blocking(gfp_mask|highmem_mask))
>   			cond_resched();
