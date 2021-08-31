Return-Path: <SRS0=ifQk=NW=lists.openwall.com=kernel-hardening-return-21373-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0707BC432BE
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 08:40:28 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 53B296101B
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 08:40:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 53B296101B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 10050 invoked by uid 550); 31 Aug 2021 08:40:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10017 invoked from network); 31 Aug 2021 08:40:20 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1630399208;
	bh=gqiAk6efM2NN49iQ6niUDVype6wdTyTtrakguXN3l0s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G+2OqoixJR5gxsUHm+HCT4jEjATdneaHH8fhceORBhplLmZnEa8lBaX3OdTjQtbUj
	 ypyZHT7vKvuDgO6ss0PxUhJXTLgWgyquyyn9/4Wrl7+R//GUcG4mQ7Igkhg9YNm7i+
	 HljCOvfeS2INezlaD3Xblc9SWH4FWctfVr0SubaJAav7J2VZ860G0YYhtnNlPQo/lJ
	 7xouBtHZyh9x53cP1oIT2tkFmU/5oR6Njp3bv8dtOQ6YDIpU+nSCUUfphv5mZU2Fa1
	 gQcm92SwWyqLwAh8tTDAqlam2nc+VuC95/Wuj295yfSmdaeRAiR2LEHdiLoyiRlIgc
	 7q3OxLc8rIjIQ==
Date: Tue, 31 Aug 2021 11:40:01 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: dave.hansen@intel.com, luto@kernel.org, peterz@infradead.org,
	x86@kernel.org, akpm@linux-foundation.org, keescook@chromium.org,
	shakeelb@google.com, vbabka@suse.cz, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 05/19] x86, mm: Use cache of page tables
Message-ID: <YS3q4Q+ybxweHoLK@kernel.org>
References: <20210830235927.6443-1-rick.p.edgecombe@intel.com>
 <20210830235927.6443-6-rick.p.edgecombe@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210830235927.6443-6-rick.p.edgecombe@intel.com>

On Mon, Aug 30, 2021 at 04:59:13PM -0700, Rick Edgecombe wrote:
> Change the page table allocation functions defined in pgalloc.h to use
> a cache of physically grouped pages. This will let the page tables be set
> with PKS permissions later.
> 
> For userspace page tables, they are gathered up using mmu gather, and
> freed along with other types of pages in swap.c. Move setting/clearing of
> the PageTable page flag to the allocators so that swap can know to return
> this page to the cache of page tables, and not free it to the page
> allocator. Where it currently is, in the ctor/dtors, causes it to be
> cleared before the page gets to swap.
> 
> Do not set PKS permissions on the page tables, because the page table
> setting functions cannot handle it yet. This will be done in later
> patches.
> 
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
>  arch/x86/include/asm/pgalloc.h |  6 ++-
>  arch/x86/include/asm/pgtable.h |  6 +++
>  arch/x86/mm/pgtable.c          | 79 ++++++++++++++++++++++++++++++++++
>  include/asm-generic/pgalloc.h  | 44 ++++++++++++++-----
>  include/linux/mm.h             | 11 +++--
>  mm/swap.c                      |  6 +++
>  mm/swap_state.c                |  5 +++
>  7 files changed, 142 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/include/asm/pgalloc.h b/arch/x86/include/asm/pgalloc.h
> index c7ec5bb88334..1ff308ea76cd 100644
> --- a/arch/x86/include/asm/pgalloc.h
> +++ b/arch/x86/include/asm/pgalloc.h
> @@ -7,6 +7,10 @@
>  #include <linux/pagemap.h>
>  
>  #define __HAVE_ARCH_PTE_ALLOC_ONE
> +#ifdef CONFIG_PKS_PG_TABLES
> +#define __HAVE_ARCH_FREE_TABLE
> +#define __HAVE_ARCH_ALLOC_TABLE

I think one define would suffice. If we'd ever have an architecture that
can implement only one of those, we update the ifdefery in
asm-generic/pgalloc.h

> +#endif
>  #define __HAVE_ARCH_PGD_FREE
>  #include <asm-generic/pgalloc.h>
>  
> @@ -162,7 +166,7 @@ static inline void p4d_free(struct mm_struct *mm, p4d_t *p4d)
>  		return;
>  
>  	BUG_ON((unsigned long)p4d & (PAGE_SIZE-1));
> -	free_page((unsigned long)p4d);
> +	free_table(virt_to_page(p4d));
>  }
>  
>  extern void ___p4d_free_tlb(struct mmu_gather *tlb, p4d_t *p4d);

...

> diff --git a/include/asm-generic/pgalloc.h b/include/asm-generic/pgalloc.h
> index 02932efad3ab..e576c19abc8c 100644
> --- a/include/asm-generic/pgalloc.h
> +++ b/include/asm-generic/pgalloc.h
> @@ -2,11 +2,26 @@
>  #ifndef __ASM_GENERIC_PGALLOC_H
>  #define __ASM_GENERIC_PGALLOC_H
>  
> +#include <linux/mm.h>
> +

Why is this required?

>  #ifdef CONFIG_MMU
>  
>  #define GFP_PGTABLE_KERNEL	(GFP_KERNEL | __GFP_ZERO)
>  #define GFP_PGTABLE_USER	(GFP_PGTABLE_KERNEL | __GFP_ACCOUNT)
>  
> +#ifndef __HAVE_ARCH_ALLOC_TABLE
> +static inline struct page *alloc_table(gfp_t gfp)
> +{
> +	return alloc_page(gfp);
> +}
> +#else /* __HAVE_ARCH_ALLOC_TABLE */
> +extern struct page *alloc_table(gfp_t gfp);
> +#endif /* __HAVE_ARCH_ALLOC_TABLE */
> +
> +#ifdef __HAVE_ARCH_FREE_TABLE
> +extern void free_table(struct page *);
> +#endif /* __HAVE_ARCH_FREE_TABLE */
> +
>  /**
>   * __pte_alloc_one_kernel - allocate a page for PTE-level kernel page table
>   * @mm: the mm_struct of the current context

...

> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index c13c7af7cad3..ab63d5a201cb 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2327,6 +2327,13 @@ static inline bool ptlock_init(struct page *page) { return true; }
>  static inline void ptlock_free(struct page *page) {}
>  #endif /* USE_SPLIT_PTE_PTLOCKS */
>  
> +#ifndef CONFIG_PKS_PG_TABLES
> +static inline void free_table(struct page *table_page)
> +{
> +	__free_pages(table_page, 0);
> +}
> +#endif /* CONFIG_PKS_PG_TABLES */
> +

Can't this live in asm-generic/pgalloc.h?
Then you won't need to include linux/mm.h there.

>  static inline void pgtable_init(void)
>  {
>  	ptlock_cache_init();
> @@ -2337,7 +2344,6 @@ static inline bool pgtable_pte_page_ctor(struct page *page)
>  {
>  	if (!ptlock_init(page))
>  		return false;
> -	__SetPageTable(page);

This change is only valid when __HAVE_ARCH_ALLOC_TABLE is set.

>  	inc_lruvec_page_state(page, NR_PAGETABLE);
>  	return true;
>  }
> @@ -2345,7 +2351,6 @@ static inline bool pgtable_pte_page_ctor(struct page *page)
>  static inline void pgtable_pte_page_dtor(struct page *page)
>  {
>  	ptlock_free(page);
> -	__ClearPageTable(page);
>  	dec_lruvec_page_state(page, NR_PAGETABLE);
>  }
>  

-- 
Sincerely yours,
Mike.
