Return-Path: <SRS0=N3Zo=BB=lists.openwall.com=kernel-hardening-return-19423-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D652DC433E5
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Jul 2020 21:33:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3220C22B45
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Jul 2020 21:33:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fPLJYEzq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3220C22B45
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19423-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9724 invoked by uid 550); 22 Jul 2020 21:33:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9701 invoked from network); 22 Jul 2020 21:33:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1595453605;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6UgVjjJcVGP42I9xFZ1qZP7ITGojf/KeQGKFYq4eMxc=;
	b=fPLJYEzqFwnLnkCyB2iR28rvmb490oyQew5VM1Uyg6iujpaJRULFtIUmrAUJZtEtAiE3SS
	H49AJo8QWoSiwDWbFdszwdRNOIgU46WNABfj0YE3Zc2mDfEDOVjSl9dFq8XBWiGiEyrTES
	GAVsC3KWFXkQnnHp1sASD9MDWO2ncbs=
X-MC-Unique: 2z4NQGofNKiv8rFqmw4fnw-1
Date: Wed, 22 Jul 2020 16:33:13 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: Kees Cook <keescook@chromium.org>, Miroslav Benes <mbenes@suse.cz>,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	arjan@linux.intel.com, x86@kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com,
	live-patching@vger.kernel.org
Subject: Re: [PATCH v4 00/10] Function Granular KASLR
Message-ID: <20200722213313.aetl3h5rkub6ktmw@treble>
References: <20200717170008.5949-1-kristen@linux.intel.com>
 <alpine.LSU.2.21.2007221122110.10163@pobox.suse.cz>
 <202007220738.72F26D2480@keescook>
 <20200722160730.cfhcj4eisglnzolr@treble>
 <202007221241.EBC2215A@keescook>
 <301c7fb7d22ad6ef97856b421873e32c2239d412.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <301c7fb7d22ad6ef97856b421873e32c2239d412.camel@linux.intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15

On Wed, Jul 22, 2020 at 12:56:10PM -0700, Kristen Carlson Accardi wrote:
> On Wed, 2020-07-22 at 12:42 -0700, Kees Cook wrote:
> > On Wed, Jul 22, 2020 at 11:07:30AM -0500, Josh Poimboeuf wrote:
> > > On Wed, Jul 22, 2020 at 07:39:55AM -0700, Kees Cook wrote:
> > > > On Wed, Jul 22, 2020 at 11:27:30AM +0200, Miroslav Benes wrote:
> > > > > Let me CC live-patching ML, because from a quick glance this is
> > > > > something 
> > > > > which could impact live patching code. At least it invalidates
> > > > > assumptions 
> > > > > which "sympos" is based on.
> > > > 
> > > > In a quick skim, it looks like the symbol resolution is using
> > > > kallsyms_on_each_symbol(), so I think this is safe? What's a good
> > > > selftest for live-patching?
> > > 
> > > The problem is duplicate symbols.  If there are two static
> > > functions
> > > named 'foo' then livepatch needs a way to distinguish them.
> > > 
> > > Our current approach to that problem is "sympos".  We rely on the
> > > fact
> > > that the second foo() always comes after the first one in the
> > > symbol
> > > list and kallsyms.  So they're referred to as foo,1 and foo,2.
> > 
> > Ah. Fun. In that case, perhaps the LTO series has some solutions. I
> > think builds with LTO end up renaming duplicate symbols like that, so
> > it'll be back to being unique.
> > 
> 
> Well, glad to hear there might be some precendence for how to solve
> this, as I wasn't able to think of something reasonable off the top of
> my head. Are you speaking of the Clang LTO series? 
> https://lore.kernel.org/lkml/20200624203200.78870-1-samitolvanen@google.com/

I'm not sure how LTO does it, but a few more (half-brained) ideas that
could work:

1) Add a field in kallsyms to keep track of a symbol's original offset
   before randomization/re-sorting.  Livepatch could use that field to
   determine the original sympos.

2) In fgkaslr code, go through all the sections and mark the ones which
   have duplicates (i.e. same name).  Then when shuffling the sections,
   skip a shuffle if it involves a duplicate section.  That way all the
   duplicates would retain their original sympos.

3) Livepatch could uniquely identify symbols by some feature other than
   sympos.  For example:

   Symbol/function size - obviously this would only work if duplicately
   named symbols have different sizes.

   Checksum - as part of a separate feature we're also looking at giving
   each function its own checksum, calculated based on its instruction
   opcodes.  Though calculating checksums at runtime could be
   complicated by IP-relative addressing.

I'm thinking #1 or #2 wouldn't be too bad.  #3 might be harder.

-- 
Josh

