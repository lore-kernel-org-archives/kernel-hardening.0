Return-Path: <SRS0=Q+Ol=32=lists.openwall.com=kernel-hardening-return-17719-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BD94C33CAC
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 17:36:14 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 740AF21775
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 17:36:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cESW/Gp9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 740AF21775
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17719-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5890 invoked by uid 550); 6 Feb 2020 17:36:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5870 invoked from network); 6 Feb 2020 17:36:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SMyOfhZzZPZuujUA9E6GKG9U2eDhQH0R/BujkYeevWk=; b=cESW/Gp9HDS3+G9FpVQTt6hOML
	sjgfAiMlMAPrC4TEVSciFPIhysWIP8ufQdJNbRKMnaikCo8+eDJVaTBvgSUfdGUwuKazj8S5/zve7
	SBkf/3rkk/p/TKFS6tlJnf7uMgL8rChYdeX2tHYoD6liZjqYo5imoBuFHVXbY/CMckJiLTHagj090
	iktPwKHYbuBQWOb3us0vZkN0q8aFayNFrHfWZ8BrhbMcept9LCEkDWVRrRnXagS/b9CneWfFZWFcK
	nWq0TCHsJEFcLdftOsZdiO+WEmMdgzv0QAIsnyf/HZgwx1UUx9SzYff5sySRduCbm+dGIYnxu1jJB
	pDWRlu2w==;
Date: Thu, 6 Feb 2020 18:35:38 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: Kees Cook <keescook@chromium.org>, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, hpa@zytor.com, arjan@linux.intel.com,
	rick.p.edgecombe@intel.com, x86@kernel.org,
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 08/11] x86: Add support for finer grained KASLR
Message-ID: <20200206173538.GY14914@hirez.programming.kicks-ass.net>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
 <20200205223950.1212394-9-kristen@linux.intel.com>
 <20200206103830.GW14879@hirez.programming.kicks-ass.net>
 <202002060356.BDFEEEFB6C@keescook>
 <20200206145253.GT14914@hirez.programming.kicks-ass.net>
 <9f337efdf226e51e3f5699243623e5de7505ac94.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f337efdf226e51e3f5699243623e5de7505ac94.camel@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Feb 06, 2020 at 09:25:01AM -0800, Kristen Carlson Accardi wrote:

> That's right - all of these tables that you mention had relocs and thus
> I did not have to do anything special for them. The orc_unwind_ip
> tables get sorted during unwind_init(). 

No they're not:

  f14bf6a350df ("x86/unwind/orc: Remove boot-time ORC unwind tables sorting")

Or rather, it might be you're working on an old tree.
