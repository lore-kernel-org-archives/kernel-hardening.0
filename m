Subject: Re: [PATCH 1/7] genalloc: track beginning of allocations
References: <20180228200620.30026-1-igor.stoppa@huawei.com>
 <20180228200620.30026-2-igor.stoppa@huawei.com>
From: J Freyensee <why2jjj.linux@gmail.com>
Message-ID: <6a31164a-af3f-91ea-d385-7c6d1888b28c@gmail.com>
Date: Mon, 5 Mar 2018 11:00:08 -0800
MIME-Version: 1.0
In-Reply-To: <20180228200620.30026-2-igor.stoppa@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
To: Igor Stoppa <igor.stoppa@huawei.com>, david@fromorbit.com, willy@infradead.org, keescook@chromium.org, mhocko@kernel.org
Cc: labbott@redhat.com, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

.
.


On 2/28/18 12:06 PM, Igor Stoppa wrote:
> +
> +/**
> + * gen_pool_dma_alloc() - allocate special memory from the pool for DMA usage
> + * @pool: pool to allocate from
> + * @size: number of bytes to allocate from the pool
> + * @dma: dma-view physical address return value.  Use NULL if unneeded.
> + *
> + * Allocate the requested number of bytes from the specified pool.
> + * Uses the pool allocation function (with first-fit algorithm by default).
> + * Can not be used in NMI handler on architectures without
> + * NMI-safe cmpxchg implementation.
> + *
> + * Return:
> + * * address of the memory allocated	- success
> + * * NULL				- error
> + */
> +void *gen_pool_dma_alloc(struct gen_pool *pool, size_t size, dma_addr_t *dma);
> +

OK, so gen_pool_dma_alloc() is defined here, which believe is the API 
line being drawn for this series.

so,
.
.
.
>
>   
>   /**
> - * gen_pool_dma_alloc - allocate special memory from the pool for DMA usage
> + * gen_pool_dma_alloc() - allocate special memory from the pool for DMA usage
>    * @pool: pool to allocate from
>    * @size: number of bytes to allocate from the pool
>    * @dma: dma-view physical address return value.  Use NULL if unneeded.
> @@ -342,14 +566,15 @@ EXPORT_SYMBOL(gen_pool_alloc_algo);
>    * Uses the pool allocation function (with first-fit algorithm by default).
>    * Can not be used in NMI handler on architectures without
>    * NMI-safe cmpxchg implementation.
> + *
> + * Return:
> + * * address of the memory allocated	- success
> + * * NULL				- error
>    */
>   void *gen_pool_dma_alloc(struct gen_pool *pool, size_t size, dma_addr_t *dma)
>   {
>   	unsigned long vaddr;
>   
> -	if (!pool)
> -		return NULL;
> -
why is this being removed?  I don't believe this code was getting 
removed from your v17 series patches.
>   	vaddr = gen_pool_alloc(pool, size);
>   	if (!vaddr)
>   		return NULL;
> @@ -362,10 +587,10 @@ void *gen_pool_dma_alloc(struct gen_pool *pool, size_t size, dma_addr_t *dma)
>   EXPORT_SYMBOL(gen_pool_dma_alloc);
>   
>
Otherwise, looks good,

Reviewed-by: Jay Freyensee <why2jjj.linux@gmail.com>
