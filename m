Subject: Re: [PATCH 2/3] gfp: mm: introduce __GFP_NOINIT
References: <20190418154208.131118-1-glider@google.com>
 <20190418154208.131118-3-glider@google.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <7bf6bd62-c8e0-df3d-8e98-70063f2d175a@intel.com>
Date: Thu, 18 Apr 2019 09:52:21 -0700
MIME-Version: 1.0
In-Reply-To: <20190418154208.131118-3-glider@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Alexander Potapenko <glider@google.com>, akpm@linux-foundation.org, cl@linux.com, dvyukov@google.com, keescook@chromium.org, labbott@redhat.com
Cc: linux-mm@kvack.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 4/18/19 8:42 AM, Alexander Potapenko wrote:
> __GFP_NOINIT basically defeats the hardening against information leaks
> provided by the init_allocations feature, so one should use it with
> caution.

Even more than that, shouldn't we try to use it only in places where
there is a demonstrated benefit, like performance data?

> diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
> index be84f5f95c97..f9d1f1236cd0 100644
> --- a/kernel/kexec_core.c
> +++ b/kernel/kexec_core.c
> @@ -302,7 +302,7 @@ static struct page *kimage_alloc_pages(gfp_t gfp_mask, unsigned int order)
>  {
>  	struct page *pages;
>  
> -	pages = alloc_pages(gfp_mask & ~__GFP_ZERO, order);
> +	pages = alloc_pages((gfp_mask & ~__GFP_ZERO) | __GFP_NOINIT, order);
>  	if (pages) {
>  		unsigned int count, i;

While this is probably not super security-sensitive, it's also not
performance sensitive.

> diff --git a/mm/slab.c b/mm/slab.c
> index dcc5b73cf767..762cb0e7bcc1 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -1393,7 +1393,7 @@ static struct page *kmem_getpages(struct kmem_cache *cachep, gfp_t flags,
>  	struct page *page;
>  	int nr_pages;
>  
> -	flags |= cachep->allocflags;
> +	flags |= (cachep->allocflags | __GFP_NOINIT);
>  
>  	page = __alloc_pages_node(nodeid, flags, cachep->gfporder);
>  	if (!page) {
> diff --git a/mm/slob.c b/mm/slob.c
> index 18981a71e962..867d2d68a693 100644
> --- a/mm/slob.c
> +++ b/mm/slob.c
> @@ -192,6 +192,7 @@ static void *slob_new_pages(gfp_t gfp, int order, int node)
>  {
>  	void *page;
>  
> +	gfp |= __GFP_NOINIT;
>  #ifdef CONFIG_NUMA
>  	if (node != NUMA_NO_NODE)
>  		page = __alloc_pages_node(node, gfp, order
> diff --git a/mm/slub.c b/mm/slub.c
> index e4efb6575510..a79b4cb768a2 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1493,6 +1493,7 @@ static inline struct page *alloc_slab_page(struct kmem_cache *s,
>  	struct page *page;
>  	unsigned int order = oo_order(oo);
>  
> +	flags |= __GFP_NOINIT;
>  	if (node == NUMA_NO_NODE)
>  		page = alloc_pages(flags, order);
>  	else
> 

These sl*b ones seem like a bad idea.  We already have rules that sl*b
allocations must be initialized by callers, and we have reasonably
frequent bugs where the rules are broken.

Setting __GFP_NOINIT might be reasonable to do, though, for slabs that
have a constructor.  We have much higher confidence that *those* are
going to get initialized properly.
