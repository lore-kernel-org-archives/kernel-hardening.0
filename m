Return-Path: <SRS0=g6cQ=BB=lists.openwall.com=kernel-hardening-return-19409-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D50AC433E6
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Jul 2020 16:08:00 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7CA9020781
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Jul 2020 16:07:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dfLpvKEf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7CA9020781
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19409-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24124 invoked by uid 550); 22 Jul 2020 16:07:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24101 invoked from network); 22 Jul 2020 16:07:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1595434059;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bE26wHn/H6+Nxep03XAoDVa8RROZuwKayFCoxg4SHVI=;
	b=dfLpvKEffSckngJbhAkTPCnt6COrYtqaOCsCLwOndOmWAA68jU0U2srLH7WLH7PXFtzKFB
	WhV+8RpPe/Z5IOz+H5UJXCXcZq7BXgbKdRYPP5ZyQOWQed7sMfBIZ8DiCqO2H6SpUSjr+x
	KaYx25+xa/ZnLjy8me5q3uNsksOa1vg=
X-MC-Unique: ZOruSB_gPSe_y9gfuhk1QQ-1
Date: Wed, 22 Jul 2020 11:07:30 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: Miroslav Benes <mbenes@suse.cz>,
	Kristen Carlson Accardi <kristen@linux.intel.com>,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	arjan@linux.intel.com, x86@kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com,
	live-patching@vger.kernel.org
Subject: Re: [PATCH v4 00/10] Function Granular KASLR
Message-ID: <20200722160730.cfhcj4eisglnzolr@treble>
References: <20200717170008.5949-1-kristen@linux.intel.com>
 <alpine.LSU.2.21.2007221122110.10163@pobox.suse.cz>
 <202007220738.72F26D2480@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202007220738.72F26D2480@keescook>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23

On Wed, Jul 22, 2020 at 07:39:55AM -0700, Kees Cook wrote:
> On Wed, Jul 22, 2020 at 11:27:30AM +0200, Miroslav Benes wrote:
> > Let me CC live-patching ML, because from a quick glance this is something 
> > which could impact live patching code. At least it invalidates assumptions 
> > which "sympos" is based on.
> 
> In a quick skim, it looks like the symbol resolution is using
> kallsyms_on_each_symbol(), so I think this is safe? What's a good
> selftest for live-patching?

The problem is duplicate symbols.  If there are two static functions
named 'foo' then livepatch needs a way to distinguish them.

Our current approach to that problem is "sympos".  We rely on the fact
that the second foo() always comes after the first one in the symbol
list and kallsyms.  So they're referred to as foo,1 and foo,2.

-- 
Josh

