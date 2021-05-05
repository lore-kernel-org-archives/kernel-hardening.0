Return-Path: <SRS0=5qNj=KA=lists.openwall.com=kernel-hardening-return-21241-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A26CFC433ED
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 May 2021 11:57:40 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9D8976112F
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 May 2021 11:57:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9D8976112F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21241-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20285 invoked by uid 550); 5 May 2021 11:57:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20253 invoked from network); 5 May 2021 11:57:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FJVYW0nVvzqzV0WuVSs2TE+406TDgUZdxaAg4wu6QtQ=; b=nJLzibjO7NeYl3c8yjFLSafo+H
	nPW9d5mpe6/UtkdfbkiY8dlbuJiyUAJVhUDchJ0hrxMm6YWssSXl8nm8yx1w6e6SD8ASz+bx15rJX
	lNU2/cH5dLiCzBV/LtxSgGkrZeoL5kizOm5brfC1OOfnmvue+nHegEoUBa+gk3hKb1pRGZNob7b/H
	ECFF+QqD6WpyPg7PPCh3pPs70ro2wTZBa2OgYya5a0j4wDd/ue8jYhDtmZrpOQoUSP4PkFRDrds5m
	rU07lsDHCE3TGxxbc86eji6Ptn1c4tWQ/Vn2zzzOlRFOZIh+ar/V+ZaKq9VGyC2tigC9Vjs2c5pSy
	u5NjT/4Q==;
Date: Wed, 5 May 2021 13:56:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, dave.hansen@intel.com,
	luto@kernel.org, linux-mm@kvack.org, x86@kernel.org,
	akpm@linux-foundation.org, linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com, ira.weiny@intel.com,
	rppt@kernel.org, dan.j.williams@intel.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 0/9] PKS write protected page tables
Message-ID: <YJKH4HDuCGLArdmp@hirez.programming.kicks-ass.net>
References: <20210505003032.489164-1-rick.p.edgecombe@intel.com>
 <d01c7845-6f9c-6770-c861-e624c3e2bfc5@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d01c7845-6f9c-6770-c861-e624c3e2bfc5@suse.cz>

On Wed, May 05, 2021 at 01:08:35PM +0200, Vlastimil Babka wrote:
> On 5/5/21 2:30 AM, Rick Edgecombe wrote:

> > Why use PKS for this?
> > =====================
> > PKS is an upcoming CPU feature that allows supervisor virtual memory 
> > permissions to be changed without flushing the TLB, like PKU does for user 
> > memory. Protecting page tables would normally be really expensive because you 
> > would have to do it with paging itself. PKS helps by providing a way to toggle 
> > the writability of the page tables with just a per-cpu MSR.
> 
> I can see in patch 8/9 that you are flipping the MSR around individual
> operations on page table entries. In my patch I hooked making the page table
> writable to obtaining the page table lock (IIRC I had only the PTE level fully
> handled though). Wonder if that would be better tradeoff even for your MSR approach?

There's also the HIGHPTE code we could abuse to kmap an alias while
we're at it.
