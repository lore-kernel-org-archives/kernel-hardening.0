Return-Path: <SRS0=8GmE=KB=lists.openwall.com=kernel-hardening-return-21253-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0203DC433ED
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 May 2021 18:01:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CA6D9610F7
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 May 2021 18:01:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA6D9610F7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21253-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32016 invoked by uid 550); 6 May 2021 18:01:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 31982 invoked from network); 6 May 2021 18:01:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Myawrg/Eh1KKgeTyc8ETEcq2kjGMoYOMLzTzDqOVZ8M=; b=e1iQYj3+gozYvU6ezrdcNd1QV7
	1igZVEJMBjQgsXbWw3o1LId2dxXxUwIzERDtwbZH9np9H49DxNcTZP5rOtEiNy8Qk6136BD3b6aEm
	TIRQ7A7IMFbPVndkLVi2JlngFtakfotDoxPUyutj+vRgEZwNTuBedmr3LWgzE2GEZ8cNke/KUl/1E
	R3208cffmARKSrUwB5+AoKN3AHMAqaw+11+4GAWO0Ip5IvUOI8XKIGHvCZI+s6Pyf1hxvY/11fNZU
	mlQ2ghYICxRp7q7xrCk/xA/nPJh91+pNNa+HZJ1n6Skwmg9chI1VSPLgi8i6D01lh9y8U6D/ebs2Y
	ewi8ZWdQ==;
Date: Thu, 6 May 2021 18:59:18 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>, dave.hansen@intel.com,
	luto@kernel.org, linux-mm@kvack.org, x86@kernel.org,
	akpm@linux-foundation.org, linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 5/9] x86, mm: Use cache of page tables
Message-ID: <20210506175918.GC388843@casper.infradead.org>
References: <20210505003032.489164-1-rick.p.edgecombe@intel.com>
 <20210505003032.489164-6-rick.p.edgecombe@intel.com>
 <YJJcqyrMEJipbevT@hirez.programming.kicks-ass.net>
 <YJKK5RUMOzv488DO@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJKK5RUMOzv488DO@kernel.org>

On Wed, May 05, 2021 at 03:09:09PM +0300, Mike Rapoport wrote:
> On Wed, May 05, 2021 at 10:51:55AM +0200, Peter Zijlstra wrote:
> > On Tue, May 04, 2021 at 05:30:28PM -0700, Rick Edgecombe wrote:
> > > @@ -54,6 +98,8 @@ void ___pte_free_tlb(struct mmu_gather *tlb, struct page *pte)
> > >  {
> > >  	pgtable_pte_page_dtor(pte);
> > >  	paravirt_release_pte(page_to_pfn(pte));
> > > +	/* Set Page Table so swap knows how to free it */
> > > +	__SetPageTable(pte);
> > >  	paravirt_tlb_remove_table(tlb, pte);
> > >  }
> > >  
> > > @@ -70,12 +116,16 @@ void ___pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd)
> > >  	tlb->need_flush_all = 1;
> > >  #endif
> > >  	pgtable_pmd_page_dtor(page);
> > > +	/* Set Page Table so swap nows how to free it */
> > > +	__SetPageTable(virt_to_page(pmd));
> > >  	paravirt_tlb_remove_table(tlb, page);
> > >  }
> > >  
> > >  #if CONFIG_PGTABLE_LEVELS > 3
> > >  void ___pud_free_tlb(struct mmu_gather *tlb, pud_t *pud)
> > >  {
> > > +	/* Set Page Table so swap nows how to free it */
> > > +	__SetPageTable(virt_to_page(pud));
> > >  	paravirt_release_pud(__pa(pud) >> PAGE_SHIFT);
> > >  	paravirt_tlb_remove_table(tlb, virt_to_page(pud));
> > >  }
> > > @@ -83,6 +133,8 @@ void ___pud_free_tlb(struct mmu_gather *tlb, pud_t *pud)
> > >  #if CONFIG_PGTABLE_LEVELS > 4
> > >  void ___p4d_free_tlb(struct mmu_gather *tlb, p4d_t *p4d)
> > >  {
> > > +	/* Set Page Table so swap nows how to free it */
> > > +	__SetPageTable(virt_to_page(p4d));
> > >  	paravirt_release_p4d(__pa(p4d) >> PAGE_SHIFT);
> > >  	paravirt_tlb_remove_table(tlb, virt_to_page(p4d));
> > >  }
> > 
> > This, to me, seems like a really weird place to __SetPageTable(), why
> > can't we do that on allocation?
> 
> We call __ClearPageTable() at pgtable_pxy_page_dtor(), so at least for pte
> and pmd we need to somehow tell release_pages() what kind of page it was.

One of the things I've been thinking about doing is removing the pgtable
dtors and instead calling the pgtable dtor in __put_page() if PageTable().
Might work nicely with this ...
