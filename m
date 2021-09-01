Return-Path: <SRS0=8M5U=NX=lists.openwall.com=kernel-hardening-return-21384-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C48B5C432BE
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Sep 2021 07:23:13 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C166860F92
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Sep 2021 07:23:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C166860F92
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 22080 invoked by uid 550); 1 Sep 2021 07:23:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22039 invoked from network); 1 Sep 2021 07:23:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1630480971;
	bh=ROvubnIZ7CG7NtmC524Rg5/WiRX8ZoyaERotUEZbRL0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OwvGS0g9Rk3Sbnr9PqhqnIqsnpglwcimyj5PYWZl+ld0I8CY15MKMWHd3uVhtm18y
	 DXLWffZNKZCSjJ8MwZVNT4VI130Pw8HnmI1QDiG8OZafTNCe3l/J1Ck1ZXFGIrPrSU
	 iW5bZiqaaPZkiTXAqz3RcDIyqE2xSDcKxm57tPE83v8pIPwp2+xP3lRaYHWo4/M9na
	 i5AaXBZHxFAJdF4sv7rwX33WBPT6fOVKQJVlZXJJK8Jn9D8e/ml2Jhye3d88jqtHVw
	 qJ1ivQ9AhefJSJF9A5hafWAMdfJRsLXUNDadIIMh4dglT0cmfW1f8BVhpF1m9biuBY
	 +bKu2nmjT8KOg==
Date: Wed, 1 Sep 2021 10:22:44 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"keescook@chromium.org" <keescook@chromium.org>,
	"Weiny, Ira" <ira.weiny@intel.com>,
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"vbabka@suse.cz" <vbabka@suse.cz>,
	"x86@kernel.org" <x86@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"Williams, Dan J" <dan.j.williams@intel.com>,
	"Lutomirski, Andy" <luto@kernel.org>,
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>,
	"Hansen, Dave" <dave.hansen@intel.com>,
	"shakeelb@google.com" <shakeelb@google.com>
Subject: Re: [RFC PATCH v2 11/19] mm/sparsemem: Use alloc_table() for table
 allocations
Message-ID: <YS8qRHrGzevns32P@kernel.org>
References: <20210830235927.6443-1-rick.p.edgecombe@intel.com>
 <20210830235927.6443-12-rick.p.edgecombe@intel.com>
 <YS3uhdT88XFvP9n3@kernel.org>
 <f77f3312a1b17b8f8de2ccf0f40f9f19f4a9f151.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f77f3312a1b17b8f8de2ccf0f40f9f19f4a9f151.camel@intel.com>

On Tue, Aug 31, 2021 at 06:25:23PM +0000, Edgecombe, Rick P wrote:
> On Tue, 2021-08-31 at 11:55 +0300, Mike Rapoport wrote:
> > On Mon, Aug 30, 2021 at 04:59:19PM -0700, Rick Edgecombe wrote:
> <trim> 
> > > -static void * __meminit vmemmap_alloc_block_zero(unsigned long
> > > size, int node)
> > > +static void * __meminit vmemmap_alloc_table(int node)
> > >  {
> > > -	void *p = vmemmap_alloc_block(size, node);
> > > +	void *p;
> > > +	if (slab_is_available()) {
> > > +		struct page *page = alloc_table_node(GFP_KERNEL |
> > > __GFP_ZERO, node);
> > 
> > This change removes __GFP_RETRY_MAYFAIL|__GFP_NOWARN from the
> > original gfp
> > vmemmap_alloc_block() used.
> Oh, yea good point. Hmm, I guess grouped pages could be aware of that
> flag too. Would be a small addition, but it starts to grow
> unfortunately.
> 
> > Not sure __GFP_RETRY_MAYFAIL is really needed in
> > vmemmap_alloc_block_zero()
> > at the first place, though.
> Looks like due to a real issue:
> 055e4fd96e95b0eee0d92fd54a26be7f0d3bcad0

I believe the issue was with memory map blocks rather than with page
tables, but since sparse-vmemmap uses the same vmemmap_alloc_block() for
both, the GFP flag got stick with both.

I'm not really familiar with reclaim internals to say if
__GFP_RETRY_MAYFAIL would help much for order-0 allocation.

Vlastimil, can you comment on this?
 
> I think it should not affect PKS tables for now, so maybe I can make
> separate logic instead. I'll look into it. Thanks.
> > 
> > More broadly, maybe it makes sense to split boot time and memory
> > hotplug
> > paths and use pxd_alloc() for the latter.
> > 
> > > +
> > > +		if (!page)
> > > +			return NULL;
> > > +		return page_address(page);
> > > +	}
> > >  
> > > +	p = __earlyonly_bootmem_alloc(node, PAGE_SIZE, PAGE_SIZE,
> > > __pa(MAX_DMA_ADDRESS));
> > 
> > Opportunistically rename to __earlyonly_memblock_alloc()? ;-)
> > 
> Heh, I can. Just grepping, there are several other instances of
> foo_bootmem() only calling foo_memblock() pattern scattered about. Or
> maybe I'm missing the distinction.

Heh, I didn't do s/bootmem/memblock/g, so foo_bootmem() are reminders we
had bootmem allocator once.
Maybe it's a good time to remove them :)
 
> <trim>

-- 
Sincerely yours,
Mike.
