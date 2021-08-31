Return-Path: <SRS0=d2Is=NW=lists.openwall.com=kernel-hardening-return-21374-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45A4FC432BE
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 08:48:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9799760F42
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 08:48:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9799760F42
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 16296 invoked by uid 550); 31 Aug 2021 08:48:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16262 invoked from network); 31 Aug 2021 08:48:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1630399676;
	bh=3JkKQ1Gr2earIXtU9C2611/WmKFsUzaW/Ah1TV/+5oA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J7l2GQM0xUVPZcjBQzRHCJwmHKbqEHZlB2Fvwfw61i4QIMCwVSUX3nsdGc3UsJXAT
	 YCCTMVfajuKn/mqFgguAD7SnbatdFt5IgOjjj3o6J3iuVUQ38rY2FXtin4ZdtyXFrF
	 5oT66uKddnZQV3UxkMsCP07S8ugiHNj0ni3fW8ly90ESmG62I0Pu525sPtWnb3wOX0
	 t880TbzdzHYUaE2DIH+Eeu+WaGB2CRR2OM76NPGMC0Os0t4MhWaxB4SHH6bCTGDPdE
	 48F8rKIQcVm2D9dFPeR5v6veSJ7wWbwL9AZlgqWLJT+B6s8V9AcItu9IJyHm+75lGy
	 C4Rx/uOfZIg0A==
Date: Tue, 31 Aug 2021 11:47:49 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: dave.hansen@intel.com, luto@kernel.org, peterz@infradead.org,
	x86@kernel.org, akpm@linux-foundation.org, keescook@chromium.org,
	shakeelb@google.com, vbabka@suse.cz, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 10/19] x86/mm: Use alloc_table() for fill_pte(),
 etc
Message-ID: <YS3stfkkCLfqROx1@kernel.org>
References: <20210830235927.6443-1-rick.p.edgecombe@intel.com>
 <20210830235927.6443-11-rick.p.edgecombe@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210830235927.6443-11-rick.p.edgecombe@intel.com>

On Mon, Aug 30, 2021 at 04:59:18PM -0700, Rick Edgecombe wrote:
> fill_pte(), set_pte_vaddr(), etc allocate page tables with
> spp_getpage(). Use alloc_table() for these allocations in order to get
> tables from the cache of protected pages when needed.
 
I can't say I tracked all the users of set_pte_vaddr(), but I don't see a
fundamental reason why spp_getpage() would need GFP_ATOMIC. Even if there
is a caller of set_pte_vaddr() that cannot sleep, it seems that page tables
can be prepopulated so that set_pte_vaddr() will not need to allocate
anything.  

> Opportunistically, fix a stale comment.

Ack for this one :)
 
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
>  arch/x86/mm/init_64.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 3c0323ad99da..de5a785ee89f 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -220,16 +220,19 @@ static void sync_global_pgds(unsigned long start, unsigned long end)
>  
>  /*
>   * NOTE: This function is marked __ref because it calls __init function
> - * (alloc_bootmem_pages). It's safe to do it ONLY when after_bootmem == 0.
> + * (memblock_alloc). It's safe to do it ONLY when after_bootmem == 0.
>   */
>  static __ref void *spp_getpage(void)
>  {
>  	void *ptr;
>  
> -	if (after_bootmem)
> -		ptr = (void *) get_zeroed_page(GFP_ATOMIC);
> -	else
> +	if (after_bootmem) {
> +		struct page *page = alloc_table(GFP_ATOMIC | __GFP_ZERO);
> +
> +		ptr = page ? page_address(page) : NULL;
> +	} else {
>  		ptr = memblock_alloc(PAGE_SIZE, PAGE_SIZE);
> +	}
>  
>  	if (!ptr || ((unsigned long)ptr & ~PAGE_MASK)) {
>  		panic("set_pte_phys: cannot allocate page data %s\n",
> -- 
> 2.17.1
> 

-- 
Sincerely yours,
Mike.
