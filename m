Return-Path: <SRS0=Azy9=KA=lists.openwall.com=kernel-hardening-return-21238-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F812C433B4
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 May 2021 08:38:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B1A5E611AC
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 May 2021 08:38:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B1A5E611AC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21238-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13521 invoked by uid 550); 5 May 2021 08:37:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13489 invoked from network); 5 May 2021 08:37:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jK0moekqG1xhMRv7+xXp4lJk9jp8uiNxobgiWKXh+5A=; b=jkvUVKohOf8O1K994UUXsnu1Gj
	pAAaW1jnaye2Wb2MFj/ciaGL47PIcPViHLq0CnU333G/XawQNPK0MV6jmzZ4iyBgSQMki6+TDvuy3
	hBUKvCswsLWem6snP55iS3jVqkke/+1gG137r3Igj/sdeN6oBGiR5ejHqcP/5OYtpMBlxQlB0WvYZ
	XUmLfDJtEqZ3rlw81tUS47E6aBsOEjpbYfbPZzqkON39WlzByDrdH6PpKXhyVLiOTqB/200jKL5pv
	RtP0WEXVcHu+1wVhJHtq1jJEiB5kNS5Dmu64OI+dtC1CWvHBIwfvdgtby5nCAAbOX0JIxQC66ZV60
	1Vbtr6cA==;
Date: Wed, 5 May 2021 10:37:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kees Cook <keescook@chromium.org>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, dave.hansen@intel.com,
	luto@kernel.org, linux-mm@kvack.org, x86@kernel.org,
	akpm@linux-foundation.org, linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com, ira.weiny@intel.com,
	rppt@kernel.org, dan.j.williams@intel.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 0/9] PKS write protected page tables
Message-ID: <YJJZSdVoP6yBbIjN@hirez.programming.kicks-ass.net>
References: <20210505003032.489164-1-rick.p.edgecombe@intel.com>
 <202105042253.ECBBF6B6@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202105042253.ECBBF6B6@keescook>

On Tue, May 04, 2021 at 11:25:31PM -0700, Kees Cook wrote:

> It looks like PKS-protected page tables would be much like the
> RO-protected text pages in the sense that there is already code in
> the kernel to do things to make it writable, change text, and set it
> read-only again (alternatives, ftrace, etc).

We don't actually modify text by changing the mapping at all. We modify
through a writable (but not executable) temporary alias on the page (on
x86).

Once a mapping is RX it will *never* be writable again (until we tear it
all down).
