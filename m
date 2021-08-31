Return-Path: <SRS0=vF52=NW=lists.openwall.com=kernel-hardening-return-21375-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F8C0C432BE
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 08:56:00 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 428406023F
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 08:55:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 428406023F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 21872 invoked by uid 550); 31 Aug 2021 08:55:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21834 invoked from network); 31 Aug 2021 08:55:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1630400140;
	bh=bnuyHXDUsJj9o5rgMuonmJZYVMQ+ewGrcJK0XOQKYeo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y5ZK7tKOpyfAuCyeblR4eHlrsNnVjT1nbN07J8NTAJhkl3cZvgiVK4BIy5f0fE7Mp
	 Y2Yzu404o/elq8xE1AA0fDyiTkJkUi2oUrs1VsLgwqCEiFqxKMkrScjf3ACl055ZeG
	 JsGfJEptohZZUZzk8Ek3gTvzMF523cXcbgOfN+nK//iQfl3XMKCLjD1u7B/XJ1aRmO
	 Ju+/absN6LGHRL/qD69o3FPamMa4YGfkrgJEfpN68YbiNKUlEE27J1uGIwB/+lXDJZ
	 +xLXh4xLJkuRzw1fWCdJI1K3AQncIQnrQmCuy0Bw5Hkm11VLdwQfqqk4NGzRVWESZe
	 g23EwBM35lmgA==
Date: Tue, 31 Aug 2021 11:55:33 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: dave.hansen@intel.com, luto@kernel.org, peterz@infradead.org,
	x86@kernel.org, akpm@linux-foundation.org, keescook@chromium.org,
	shakeelb@google.com, vbabka@suse.cz, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 11/19] mm/sparsemem: Use alloc_table() for table
 allocations
Message-ID: <YS3uhdT88XFvP9n3@kernel.org>
References: <20210830235927.6443-1-rick.p.edgecombe@intel.com>
 <20210830235927.6443-12-rick.p.edgecombe@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210830235927.6443-12-rick.p.edgecombe@intel.com>

On Mon, Aug 30, 2021 at 04:59:19PM -0700, Rick Edgecombe wrote:
> In order to support allocating PKS protected page tables for vmememap,
> create a new variant of alloc_table(), alloc_table_node() that allows for
> allocation of tables from a specific node. Use it when possible for
> allocating vmemmap tables.
> 
> vmemmap_alloc_block_zero() is currently only used to allocate page
> tables, so fold it into a new function, vmemem_alloc_table() that can
> be free to call alloc_table_node(). Since it is today only called with
> PAGE_SIZE size, drop the size argument.
> 
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
>  arch/x86/mm/pgtable.c         | 10 +++++++---
>  include/asm-generic/pgalloc.h |  2 ++
>  include/linux/mm.h            |  5 +++++
>  mm/sparse-vmemmap.c           | 22 +++++++++++++++-------
>  4 files changed, 29 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
> index e65d69ad6e0c..006dc4f81f6d 100644
> --- a/arch/x86/mm/pgtable.c
> +++ b/arch/x86/mm/pgtable.c
> @@ -41,7 +41,7 @@ static struct grouped_page_cache gpc_pks;
>  static bool __ro_after_init pks_tables_inited_val;
>  
>  
> -struct page *alloc_table(gfp_t gfp)
> +struct page *alloc_table_node(gfp_t gfp, int node)
>  {
>  	struct page *table;
>  
> @@ -53,9 +53,9 @@ struct page *alloc_table(gfp_t gfp)
>  	}
>  
>  	if (gfp & GFP_ATOMIC)
> -		table = get_grouped_page_atomic(numa_node_id(), &gpc_pks);
> +		table = get_grouped_page_atomic(node, &gpc_pks);
>  	else
> -		table = get_grouped_page(numa_node_id(), &gpc_pks);
> +		table = get_grouped_page(node, &gpc_pks);
>  	if (!table)
>  		return NULL;
>  	__SetPageTable(table);
> @@ -72,6 +72,10 @@ struct page *alloc_table(gfp_t gfp)
>  
>  	return table;
>  }
> +struct page *alloc_table(gfp_t gfp)
> +{
> +	return alloc_table_node(gfp, numa_node_id());
> +}
>  
>  void free_table(struct page *table_page)
>  {
> diff --git a/include/asm-generic/pgalloc.h b/include/asm-generic/pgalloc.h
> index e576c19abc8c..eb08371db211 100644
> --- a/include/asm-generic/pgalloc.h
> +++ b/include/asm-generic/pgalloc.h
> @@ -14,8 +14,10 @@ static inline struct page *alloc_table(gfp_t gfp)
>  {
>  	return alloc_page(gfp);
>  }
> +/* alloc_table_node() stub defined in mm.h */
>  #else /* __HAVE_ARCH_ALLOC_TABLE */
>  extern struct page *alloc_table(gfp_t gfp);
> +extern struct page *alloc_table_node(gfp_t gfp, int node);
>  #endif /* __HAVE_ARCH_ALLOC_TABLE */
>  
>  #ifdef __HAVE_ARCH_FREE_TABLE
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index ab63d5a201cb..fdb33bc6bba8 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2332,6 +2332,11 @@ static inline void free_table(struct page *table_page)
>  {
>  	__free_pages(table_page, 0);
>  }
> +
> +static inline struct page *alloc_table_node(gfp_t gfp, int node)
> +{
> +	return alloc_pages_node(node, gfp, 0);
> +}
>  #endif /* CONFIG_PKS_PG_TABLES */
>  
>  static inline void pgtable_init(void)
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index bdce883f9286..4f479c75cc8d 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -511,13 +511,21 @@ pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
>  	return pte;
>  }
>  
> -static void * __meminit vmemmap_alloc_block_zero(unsigned long size, int node)
> +static void * __meminit vmemmap_alloc_table(int node)
>  {
> -	void *p = vmemmap_alloc_block(size, node);
> +	void *p;
> +	if (slab_is_available()) {
> +		struct page *page = alloc_table_node(GFP_KERNEL | __GFP_ZERO, node);

This change removes __GFP_RETRY_MAYFAIL|__GFP_NOWARN from the original gfp
vmemmap_alloc_block() used.
Not sure __GFP_RETRY_MAYFAIL is really needed in vmemmap_alloc_block_zero()
at the first place, though.

More broadly, maybe it makes sense to split boot time and memory hotplug
paths and use pxd_alloc() for the latter.

> +
> +		if (!page)
> +			return NULL;
> +		return page_address(page);
> +	}
>  
> +	p = __earlyonly_bootmem_alloc(node, PAGE_SIZE, PAGE_SIZE, __pa(MAX_DMA_ADDRESS));

Opportunistically rename to __earlyonly_memblock_alloc()? ;-)

>  	if (!p)
>  		return NULL;
> -	memset(p, 0, size);
> +	memset(p, 0, PAGE_SIZE);
>  
>  	return p;
>  }
> @@ -526,7 +534,7 @@ pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node)
>  {
>  	pmd_t *pmd = pmd_offset(pud, addr);
>  	if (pmd_none(*pmd)) {
> -		void *p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
> +		void *p = vmemmap_alloc_table(node);
>  		if (!p)
>  			return NULL;
>  		pmd_populate_kernel(&init_mm, pmd, p);
> @@ -538,7 +546,7 @@ pud_t * __meminit vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node)
>  {
>  	pud_t *pud = pud_offset(p4d, addr);
>  	if (pud_none(*pud)) {
> -		void *p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
> +		void *p = vmemmap_alloc_table(node);
>  		if (!p)
>  			return NULL;
>  		pud_populate(&init_mm, pud, p);
> @@ -550,7 +558,7 @@ p4d_t * __meminit vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node)
>  {
>  	p4d_t *p4d = p4d_offset(pgd, addr);
>  	if (p4d_none(*p4d)) {
> -		void *p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
> +		void *p = vmemmap_alloc_table(node);
>  		if (!p)
>  			return NULL;
>  		p4d_populate(&init_mm, p4d, p);
> @@ -562,7 +570,7 @@ pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
>  {
>  	pgd_t *pgd = pgd_offset_k(addr);
>  	if (pgd_none(*pgd)) {
> -		void *p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
> +		void *p = vmemmap_alloc_table(node);
>  		if (!p)
>  			return NULL;
>  		pgd_populate(&init_mm, pgd, p);
> -- 
> 2.17.1
> 

-- 
Sincerely yours,
Mike.
