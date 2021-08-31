Return-Path: <SRS0=gFz8=NW=lists.openwall.com=kernel-hardening-return-21377-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D770C432BE
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 10:14:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 41A2D60F91
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 10:14:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 41A2D60F91
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 5596 invoked by uid 550); 31 Aug 2021 10:14:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5559 invoked from network); 31 Aug 2021 10:14:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1630404864;
	bh=sv+Cg1X+GBWUrO7fD0zMaYtizfycZgRul3+2yg67iwI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jjmdlQqBBwC61Dm6M3j6ltcmjch9JnUdjCt1m3iPM+1xA+zSjCR9ZVE5lUqJvNw0I
	 QmtznYopatvh54G3PJL4O+aOONlBX6vtKCzq43PN3S23Hzf++5YgjJQHyXI+VTsyD+
	 /ERe0A1hTT6brhvBCAv26DIqs4FDgfoYs1b2bRarfMN4RzKSfYYhZk4kT+fZmcuA1Z
	 NxZ779TMOgpDgAQ4FlRaaPr4BqkMVOS9M6W4wLsy0adubDhHGNOMfASpb9RxAlSMpK
	 /y46REUiJRJxP5u8Jg2ukGCMW5O8yRlnFK4TxmfDwysH9amt+7vENnsMIn8878hlmd
	 yjXymAIBf97Cg==
Date: Tue, 31 Aug 2021 13:14:16 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: dave.hansen@intel.com, luto@kernel.org, peterz@infradead.org,
	x86@kernel.org, akpm@linux-foundation.org, keescook@chromium.org,
	shakeelb@google.com, vbabka@suse.cz, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 17/19] x86/mm/cpa: PKS protect direct map page
 tables
Message-ID: <YS4A+F1H9MvyOeMV@kernel.org>
References: <20210830235927.6443-1-rick.p.edgecombe@intel.com>
 <20210830235927.6443-18-rick.p.edgecombe@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210830235927.6443-18-rick.p.edgecombe@intel.com>

On Mon, Aug 30, 2021 at 04:59:25PM -0700, Rick Edgecombe wrote:
> Protecting direct map page tables is a bit more difficult because a page
> table may be needed for a page split as part of setting the PKS
> permission the new page table. So in the case of an empty cache of page
> tables the page table allocator could get into a situation where it cannot
> create any more page tables.
> 
> Several solutions were looked at:
> 
> 1. Break the direct map with pages allocated from the large page being
> converted to PKS. This would result in a window where the table could be
> written to right before it was linked into the page tables. It also
> depends on high order pages being available, and so would regress from
> the un-protected behavior in that respect.
> 2. Hold some page tables in reserve to be able to break the large page
> for a new 2MB page, but if there are no 2MB page's available we may need
> to add a single page to the cache, in which case we would use up the
> reserve of page tables needed to break a new page, but not get enough
> page tables back to replenish the resereve.
> 3. Always map the direct map at 4k when protecting page tables so that
> pages don't need to be broken to map them with a PKS key. This would have
> undesirable performance.
> 
> 4. Lastly, the strategy employed in this patch, have a separate cache of
> page tables just used for the direct map. Early in boot, squirrel away
> enough page tables to map the direct map at 4k. This comes with the same
> memory overhead of mapping the direct map at 4k, but gets the other
> benefits of mapping the direct map as large pages.
> 
> There is also the problem of protecting page tables that are allocated
> during boot. Instead of recording the tables to protect later, create a
> page table traversing infrastructure to walk every page table in init_mm
> and apply protection. This also covers non-direct map odds-and-ends page
> tables that are allocated during boot. The existing page table traversing
> in pagewalk.c cannot be used for this purpose because there are not actual
> vmas for all of the kernel address space.
> 
> The algorithm for protecting the direct map page table cache, while also
> allocating from it for direct map splits is described in the comments of
> init_pks_dmap_tables().
> 
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
>  arch/x86/include/asm/set_memory.h |   2 +
>  arch/x86/mm/init.c                |  89 ++++++++++
>  arch/x86/mm/pat/set_memory.c      | 263 +++++++++++++++++++++++++++++-
>  3 files changed, 350 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_memory.h
> index 1ba2fb45ed05..9f8d0d0ae063 100644
> --- a/arch/x86/include/asm/set_memory.h
> +++ b/arch/x86/include/asm/set_memory.h
> @@ -90,6 +90,8 @@ bool kernel_page_present(struct page *page);
>  
>  extern int kernel_set_to_readonly;
>  
> +void add_dmap_table(unsigned long addr);
> +
>  #ifdef CONFIG_X86_64
>  /*
>   * Prevent speculative access to the page by either unmapping
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index c8933c6d5efd..a91696e3da96 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -6,6 +6,7 @@
>  #include <linux/swapfile.h>
>  #include <linux/swapops.h>
>  #include <linux/kmemleak.h>
> +#include <linux/hugetlb.h>
>  #include <linux/sched/task.h>
>  
>  #include <asm/set_memory.h>
> @@ -26,6 +27,7 @@
>  #include <asm/pti.h>
>  #include <asm/text-patching.h>
>  #include <asm/memtype.h>
> +#include <asm/pgalloc.h>
>  
>  /*
>   * We need to define the tracepoints somewhere, and tlb.c
> @@ -119,6 +121,17 @@ __ref void *alloc_low_pages(unsigned int num)
>  	if (after_bootmem) {
>  		unsigned int order;
>  
> +		if (cpu_feature_enabled(X86_FEATURE_PKS_TABLES)) {
> +			struct page *page;
> +
> +			/* 64 bit only allocates order 0 pages */
> +			WARN_ON(num != 1);
> +
> +			page = alloc_table(GFP_ATOMIC | __GFP_ZERO);
> +			if (!page)
> +				return NULL;
> +			return (void *)page_address(page);
> +		}
>  		order = get_order((unsigned long)num << PAGE_SHIFT);
>  		return (void *)__get_free_pages(GFP_ATOMIC | __GFP_ZERO, order);
>  	}
> @@ -504,6 +517,79 @@ bool pfn_range_is_mapped(unsigned long start_pfn, unsigned long end_pfn)
>  	return false;
>  }
>  
> +#ifdef CONFIG_PKS_PG_TABLES
> +/* Page tables needed in bytes */
> +static u64 calc_tables_needed(unsigned int size)
> +{
> +	unsigned int puds = size >> PUD_SHIFT;
> +	unsigned int pmds = size >> PMD_SHIFT;
> +
> +	/*
> +	 * Catch if direct map ever might need more page tables to split
> +	 * down to 4k.
> +	 */
> +	BUILD_BUG_ON(p4d_huge(foo));
> +	BUILD_BUG_ON(pgd_huge(foo));
> +
> +	return (puds + pmds) << PAGE_SHIFT;
> +}
> +
> +/*
> + * If pre boot, reserve large pages from memory that will be mapped. It's ok that this is not
> + * mapped as PKS, other init code in CPA will handle the conversion.
> + */
> +static unsigned int __init reserve_pre_boot(u64 start, u64 end)
> +{
> +	u64 cur = memblock_find_in_range(start, end, HPAGE_SIZE, HPAGE_SIZE);
> +	int i;

Please use memblock_phys_alloc_range() here.
Besides, it seems this reserved pages are not accessed until late_initcall
time, so there is no need to limit the allocation to already mapped areas,
memblock_alloc_raw() would suffice.

> +
> +	if (!cur)
> +		return 0;
> +	memblock_reserve(cur, HPAGE_SIZE);
> +	for (i = 0; i < HPAGE_SIZE; i += PAGE_SIZE)
> +		add_dmap_table((unsigned long)__va(cur + i));
> +	return HPAGE_SIZE;
> +}
> +
> +/* If post boot, memblock is not available. Just reserve from other memory regions */
> +static unsigned int __init reserve_post_boot(void)
> +{
> +	struct page *page = alloc_table(GFP_KERNEL);
> +
> +	if (!page)
> +		return 0;
> +
> +	add_dmap_table((unsigned long)page_address(page));

add_dmap_table() calls use casting everywhere, maybe make it
add_dmap_table(void *)?

> +
> +	return PAGE_SIZE;
> +}
> +
> +static void __init reserve_page_tables(u64 start, u64 end)
> +{
> +	u64 reserve_size = calc_tables_needed(end - start);
> +	u64 reserved = 0;
> +	u64 cur_reserved;
> +
> +	while (reserved < reserve_size) {
> +		if (after_bootmem)
> +			cur_reserved = reserve_post_boot();
> +		else
> +			cur_reserved = reserve_pre_boot(start, end);
> +
> +		if (!cur_reserved) {
> +			WARN(1, "Could not reserve direct map page tables %llu/%llu\n",
> +				reserved,
> +				reserve_size);
> +			return;
> +		}
> +
> +		reserved += cur_reserved;
> +	}
> +}
> +#else
> +static inline void reserve_page_tables(u64 start, u64 end) { }
> +#endif
> +
>  /*
>   * Setup the direct mapping of the physical memory at PAGE_OFFSET.
>   * This runs before bootmem is initialized and gets pages directly from
> @@ -529,6 +615,9 @@ unsigned long __ref init_memory_mapping(unsigned long start,
>  
>  	add_pfn_range_mapped(start >> PAGE_SHIFT, ret >> PAGE_SHIFT);
>  
> +	if (cpu_feature_enabled(X86_FEATURE_PKS_TABLES))
> +		reserve_page_tables(start, end);
> +
>  	return ret >> PAGE_SHIFT;
>  }

-- 
Sincerely yours,
Mike.
