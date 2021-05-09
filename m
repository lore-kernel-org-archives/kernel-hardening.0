Return-Path: <SRS0=+O/G=KE=lists.openwall.com=kernel-hardening-return-21258-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2430BC43461
	for <kernel-hardening@archiver.kernel.org>; Sun,  9 May 2021 09:40:28 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 418E661370
	for <kernel-hardening@archiver.kernel.org>; Sun,  9 May 2021 09:40:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 418E661370
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21258-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 4014 invoked by uid 550); 9 May 2021 09:40:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3975 invoked from network); 9 May 2021 09:40:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1620553204;
	bh=arqj45G9UntJeTybAfBKTHblqTMzSlsbmScLhph1JQw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LME6quczRrfH5T+sZlxMjLWKBvWW/uhkH89PfrtZENGozc14UbpYKyz+LEMe3jtTv
	 A6Mq05FD+ZyCTiA7nDPDKOB0s6jgVT5AhLMzdI/xtaOrCL0el5+kwoYWXjdrbGZgI4
	 bbZEGw4A23BaP2+qZN/TMDhOSzQ41o9h3RWsxO6uOdMwB1EUgL+EugElVMeWayt2Lg
	 0+MpKZCLvUhmfjFvN2sL1/bJpFSgUfHAVnJCT0KQ+VaMceRy1twji2MkndvwMQv/kB
	 PX/sRh0EuMbEZsc0L0+R8eCr0CrObDm/G9ZN39HhS6SO2FJKy5PYBj7+g2ZZTUBt/q
	 VjhYQsQCEcxhQ==
Date: Sun, 9 May 2021 12:39:55 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>,
	"Hansen, Dave" <dave.hansen@intel.com>,
	"luto@kernel.org" <luto@kernel.org>,
	"x86@kernel.org" <x86@kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Williams, Dan J" <dan.j.williams@intel.com>,
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
	"Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [PATCH RFC 3/9] x86/mm/cpa: Add grouped page allocations
Message-ID: <YJet66kzbb6UB5Qe@kernel.org>
References: <20210505003032.489164-1-rick.p.edgecombe@intel.com>
 <20210505003032.489164-4-rick.p.edgecombe@intel.com>
 <YJKKu7kMCtCuel2L@kernel.org>
 <YJKY+Ccxfe9wD0iP@hirez.programming.kicks-ass.net>
 <YJLnyJP755XAPZNX@kernel.org>
 <bb2a9aaedcd5d47ace719050fa06d7a21050cfc5.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb2a9aaedcd5d47ace719050fa06d7a21050cfc5.camel@intel.com>

On Wed, May 05, 2021 at 09:57:17PM +0000, Edgecombe, Rick P wrote:
> On Wed, 2021-05-05 at 21:45 +0300, Mike Rapoport wrote:
> > On Wed, May 05, 2021 at 03:09:12PM +0200, Peter Zijlstra wrote:
> > > On Wed, May 05, 2021 at 03:08:27PM +0300, Mike Rapoport wrote:
> > > > On Tue, May 04, 2021 at 05:30:26PM -0700, Rick Edgecombe wrote:
> > > > > For x86, setting memory permissions on the direct map results
> > > > > in fracturing
> > > > > large pages. Direct map fracturing can be reduced by locating
> > > > > pages that
> > > > > will have their permissions set close together.
> > > > > 
> > > > > Create a simple page cache that allocates pages from huge page
> > > > > size
> > > > > blocks. Don't guarantee that a page will come from a huge page
> > > > > grouping,
> > > > > instead fallback to non-grouped pages to fulfill the allocation
> > > > > if
> > > > > needed. Also, register a shrinker such that the system can ask
> > > > > for the
> > > > > pages back if needed. Since this is only needed when there is a
> > > > > direct
> > > > > map, compile it out on highmem systems.
> > > > 
> > > > I only had time to skim through the patches, I like the idea of
> > > > having a
> > > > simple cache that allocates larger pages with a fallback to basic
> > > > page
> > > > size.
> > > > 
> > > > I just think it should be more generic and closer to the page
> > > > allocator.
> > > > I was thinking about adding a GFP flag that will tell that the
> > > > allocated
> > > > pages should be removed from the direct map. Then alloc_pages()
> > > > could use
> > > > such cache whenever this GFP flag is specified with a fallback
> > > > for lower
> > > > order allocations.
> > > 
> > > That doesn't provide enough information I think. Removing from
> > > direct
> > > map isn't the only consideration, you also want to group them by
> > > the
> > > target protection bits such that we don't get to use 4k pages quite
> > > so
> > > much.
> > 
> > Unless I'm missing something we anyway hand out 4k pages from the
> > cache and
> > the neighbouring 4k may end up with different protections.
> > 
> > This is also similar to what happens in the set Rick posted a while
> > ago to
> > support grouped vmalloc allocations:
> > 
> 
> One issue is with the shrinker callbacks. If you are just trying to
> reset and free a single page because the system is low on memory, it
> could be problematic to have to break a large page, which would require
> another page.

I don't follow you here. Maybe I've misread the patches but AFAIU the large
page is broken at allocation time and 4k pages remain 4k pages afterwards.

In my understanding the problem with a simple shrinker is that even if we
have the entire 2M free it is not being reinstated as 2M page in the direct
mapping.
 
-- 
Sincerely yours,
Mike.
