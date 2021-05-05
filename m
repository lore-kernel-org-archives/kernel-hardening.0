Return-Path: <SRS0=LV8A=KA=lists.openwall.com=kernel-hardening-return-21243-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55AE9C433B4
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 May 2021 12:16:28 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5003D61157
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 May 2021 12:16:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5003D61157
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21243-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32552 invoked by uid 550); 5 May 2021 12:16:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28218 invoked from network); 5 May 2021 12:09:29 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1620216557;
	bh=eyDndtMwyuRmZym1pTFZiZuIz6uTY2r81jIr1/YiEfg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U7fttDsTmI9wiuK7swO0Hm9SCpKEYoFuamTqMfTz7sbh91z3OeazDwC35vIS1g+9u
	 A1MnTY4490ECSNp7bClvXAoEPK+UOd25mM2GL4tfok4OlG50SHKaoefpJhejSUeTDQ
	 5Pzk2ttsInuAGZrgxToTAaF9aduPpi2k2nz/toKqNUKAEoTHnxmtGob1eoKJoK/lRP
	 xbdj7bMrHguSWDTw/HoQMwJhMPK0mT8CqmlOYzB0NVjuweRbBUrnvkwqpg+rmTtlXV
	 hRQVvDRxErrL1C0dDOS+mLPoipijqB7jHDnWfzUWIbhuCX4yidlh9uI6JiZfv9yL3B
	 q7GQAR9yK3YDA==
Date: Wed, 5 May 2021 15:09:09 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, dave.hansen@intel.com,
	luto@kernel.org, linux-mm@kvack.org, x86@kernel.org,
	akpm@linux-foundation.org, linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 5/9] x86, mm: Use cache of page tables
Message-ID: <YJKK5RUMOzv488DO@kernel.org>
References: <20210505003032.489164-1-rick.p.edgecombe@intel.com>
 <20210505003032.489164-6-rick.p.edgecombe@intel.com>
 <YJJcqyrMEJipbevT@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJJcqyrMEJipbevT@hirez.programming.kicks-ass.net>

On Wed, May 05, 2021 at 10:51:55AM +0200, Peter Zijlstra wrote:
> On Tue, May 04, 2021 at 05:30:28PM -0700, Rick Edgecombe wrote:
> > @@ -54,6 +98,8 @@ void ___pte_free_tlb(struct mmu_gather *tlb, struct page *pte)
> >  {
> >  	pgtable_pte_page_dtor(pte);
> >  	paravirt_release_pte(page_to_pfn(pte));
> > +	/* Set Page Table so swap knows how to free it */
> > +	__SetPageTable(pte);
> >  	paravirt_tlb_remove_table(tlb, pte);
> >  }
> >  
> > @@ -70,12 +116,16 @@ void ___pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd)
> >  	tlb->need_flush_all = 1;
> >  #endif
> >  	pgtable_pmd_page_dtor(page);
> > +	/* Set Page Table so swap nows how to free it */
> > +	__SetPageTable(virt_to_page(pmd));
> >  	paravirt_tlb_remove_table(tlb, page);
> >  }
> >  
> >  #if CONFIG_PGTABLE_LEVELS > 3
> >  void ___pud_free_tlb(struct mmu_gather *tlb, pud_t *pud)
> >  {
> > +	/* Set Page Table so swap nows how to free it */
> > +	__SetPageTable(virt_to_page(pud));
> >  	paravirt_release_pud(__pa(pud) >> PAGE_SHIFT);
> >  	paravirt_tlb_remove_table(tlb, virt_to_page(pud));
> >  }
> > @@ -83,6 +133,8 @@ void ___pud_free_tlb(struct mmu_gather *tlb, pud_t *pud)
> >  #if CONFIG_PGTABLE_LEVELS > 4
> >  void ___p4d_free_tlb(struct mmu_gather *tlb, p4d_t *p4d)
> >  {
> > +	/* Set Page Table so swap nows how to free it */
> > +	__SetPageTable(virt_to_page(p4d));
> >  	paravirt_release_p4d(__pa(p4d) >> PAGE_SHIFT);
> >  	paravirt_tlb_remove_table(tlb, virt_to_page(p4d));
> >  }
> 
> This, to me, seems like a really weird place to __SetPageTable(), why
> can't we do that on allocation?

We call __ClearPageTable() at pgtable_pxy_page_dtor(), so at least for pte
and pmd we need to somehow tell release_pages() what kind of page it was.
 
> > @@ -888,6 +889,12 @@ void release_pages(struct page **pages, int nr)
> >  			continue;
> >  		}
> >  
> > +		if (PageTable(page)) {
> > +			__ClearPageTable(page);
> > +			free_table(page);
> > +			continue;
> > +		}
> > +
> >  		if (!put_page_testzero(page))
> >  			continue;
> >  
> > diff --git a/mm/swap_state.c b/mm/swap_state.c
> > index 3cdee7b11da9..a60ec3d4ab21 100644
> > --- a/mm/swap_state.c
> > +++ b/mm/swap_state.c
> > @@ -22,6 +22,7 @@
> >  #include <linux/swap_slots.h>
> >  #include <linux/huge_mm.h>
> >  #include <linux/shmem_fs.h>
> > +#include <asm/pgalloc.h>
> >  #include "internal.h"
> >  
> >  /*
> > @@ -310,6 +311,11 @@ static inline void free_swap_cache(struct page *page)
> >  void free_page_and_swap_cache(struct page *page)
> >  {
> >  	free_swap_cache(page);
> > +	if (PageTable(page)) {
> > +		__ClearPageTable(page);
> > +		free_table(page);
> > +		return;
> > +	}
> >  	if (!is_huge_zero_page(page))
> >  		put_page(page);
> >  }
> 
> And then free_table() can __ClearPageTable() and all is nice and
> symmetric and all this weirdness goes away, no?

-- 
Sincerely yours,
Mike.
