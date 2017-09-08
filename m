Date: Fri, 8 Sep 2017 00:51:40 -0700
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20170908075140.GB4957@infradead.org>
References: <20170907173609.22696-1-tycho@docker.com>
 <20170907173609.22696-4-tycho@docker.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170907173609.22696-4-tycho@docker.com>
Subject: [kernel-hardening] Re: [PATCH v6 03/11] mm, x86: Add support for eXclusive Page Frame
 Ownership (XPFO)
To: Tycho Andersen <tycho@docker.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com, Marco Benatto <marco.antonio.780@gmail.com>, Juerg Haefliger <juerg.haefliger@canonical.com>, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

I think this patch needs to be split into the generic mm code, and
the x86 arch code at least.

> +/*
> + * The current flushing context - we pass it instead of 5 arguments:
> + */
> +struct cpa_data {
> +	unsigned long	*vaddr;
> +	pgd_t		*pgd;
> +	pgprot_t	mask_set;
> +	pgprot_t	mask_clr;
> +	unsigned long	numpages;
> +	int		flags;
> +	unsigned long	pfn;
> +	unsigned	force_split : 1;
> +	int		curpage;
> +	struct page	**pages;
> +};

Fitting these 10 variables into 5 arguments would require an awesome
compression scheme anyway :)

> +			if  (__split_large_page(&cpa, pte, (unsigned long)kaddr, base) < 0)

Overly long line.

> +#include <linux/xpfo.h>
>  
>  #include <asm/cacheflush.h>
>  
> @@ -55,24 +56,34 @@ static inline struct page *kmap_to_page(void *addr)
>  #ifndef ARCH_HAS_KMAP
>  static inline void *kmap(struct page *page)
>  {
> +	void *kaddr;
> +
>  	might_sleep();
> -	return page_address(page);
> +	kaddr = page_address(page);
> +	xpfo_kmap(kaddr, page);
> +	return kaddr;
>  }
>  
>  static inline void kunmap(struct page *page)
>  {
> +	xpfo_kunmap(page_address(page), page);
>  }
>  
>  static inline void *kmap_atomic(struct page *page)
>  {
> +	void *kaddr;
> +
>  	preempt_disable();
>  	pagefault_disable();
> -	return page_address(page);
> +	kaddr = page_address(page);
> +	xpfo_kmap(kaddr, page);
> +	return kaddr;
>  }

It seems to me like we should simply direct to pure xpfo
implementations for the !HIGHMEM && XPFO case. - that is
just have the prototypes for kmap, kunmap and co in
linux/highmem.h and implement them in xpfo under those names.

Instead of sprinkling them around.

> +DEFINE_STATIC_KEY_FALSE(xpfo_inited);

s/inited/initialized/g ?

> +	bool "Enable eXclusive Page Frame Ownership (XPFO)"
> +	default n

default n is the default, so you can remove this line.
