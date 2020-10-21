Return-Path: <SRS0=2Ruy=D4=lists.openwall.com=kernel-hardening-return-20243-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 327FEC4363A
	for <kernel-hardening@archiver.kernel.org>; Wed, 21 Oct 2020 11:31:36 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 35B582177B
	for <kernel-hardening@archiver.kernel.org>; Wed, 21 Oct 2020 11:31:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="QwugJTHg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 35B582177B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20243-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5311 invoked by uid 550); 21 Oct 2020 11:31:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5288 invoked from network); 21 Oct 2020 11:31:26 -0000
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1603279875;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RW7tOE3D2afcPGdHwdZqtikZ9dAMRd9QiBe01yT5Y7o=;
	b=QwugJTHgAjBJGGzJwz85Cl86aBem4nMApyyEPzaBf4IhwXo7Tft0VIpFAfqWHT6lm1aAhB
	l3cy7P63EBbU/GeMQAJ/5AK5qwRA/q6fKOKo+abTOIBhvFXwspBcSMH6YiCtMzbJVq99ai
	Es6ac5YeKkeGYH9X1lL6eVw6kSVUwu4=
Date: Wed, 21 Oct 2020 13:31:14 +0200
From: Michal Hocko <mhocko@suse.com>
To: David Hildenbrand <david@redhat.com>
Cc: "Guilherme G. Piccoli" <gpiccoli@canonical.com>,
	Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org,
	kernel-hardening@lists.openwall.com,
	linux-hardening@vger.kernel.org,
	linux-security-module@vger.kernel.org, kernel@gpiccoli.net,
	cascardo@canonical.com, Alexander Potapenko <glider@google.com>,
	James Morris <jamorris@linux.microsoft.com>,
	Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] mm, hugetlb: Avoid double clearing for hugetlb pages
Message-ID: <20201021113114.GC23790@dhcp22.suse.cz>
References: <20201019182853.7467-1-gpiccoli@canonical.com>
 <20201020082022.GL27114@dhcp22.suse.cz>
 <9cecd9d9-e25c-4495-50e2-8f7cb7497429@canonical.com>
 <20201021061538.GA23790@dhcp22.suse.cz>
 <0ad2f879-7c72-3eef-5cb6-dee44265eb82@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ad2f879-7c72-3eef-5cb6-dee44265eb82@redhat.com>

On Wed 21-10-20 11:50:48, David Hildenbrand wrote:
> On 21.10.20 08:15, Michal Hocko wrote:
> > On Tue 20-10-20 16:19:06, Guilherme G. Piccoli wrote:
> >> On 20/10/2020 05:20, Michal Hocko wrote:
> >>>
> >>> Yes zeroying is quite costly and that is to be expected when the feature
> >>> is enabled. Hugetlb like other allocator users perform their own
> >>> initialization rather than go through __GFP_ZERO path. More on that
> >>> below.
> >>>
> >>> Could you be more specific about why this is a problem. Hugetlb pool is
> >>> usualy preallocatd once during early boot. 24s for 65GB of 2MB pages
> >>> is non trivial amount of time but it doens't look like a major disaster
> >>> either. If the pool is allocated later it can take much more time due to
> >>> memory fragmentation.
> >>>
> >>> I definitely do not want to downplay this but I would like to hear about
> >>> the real life examples of the problem.
> >>
> >> Indeed, 24s of delay (!) is not so harmful for boot time, but...64G was
> >> just my simple test in a guest, the real case is much worse! It aligns
> >> with Mike's comment, we have complains of minute-like delays, due to a
> >> very big pool of hugepages being allocated.
> > 
> > The cost of page clearing is mostly a constant overhead so it is quite
> > natural to see the time scaling with the number of pages. That overhead
> > has to happen at some point of time. Sure it is more visible when
> > allocating during boot time resp. when doing pre-allocation during
> > runtime. The page fault path would be then faster. The overhead just
> > moves to a different place. So I am not sure this is really a strong
> > argument to hold.
> 
> We have people complaining that starting VMs backed by hugetlbfs takes
> too long, they would much rather have that initialization be done when
> booting the hypervisor ...

I can imagine. Everybody would love to have a free lunch ;) But more
seriously, the overhead of the initialization is unavoidable. The memory
has to be zeroed out by definition and somebody has to pay for that.
Sure one can think of a deferred context to do that but this just
spreads  the overhead out to the overall system overhead.

Even if the zeroying is done during the allocation time then it is the
first user who can benefit from that. Any reuse of the hugetlb pool has
to reinitialize again.

One can still be creative - e.g. prefault hugetlb files from userspace
in parallel and reuse that but I am not sure kernel should try to be
clever here.
-- 
Michal Hocko
SUSE Labs
