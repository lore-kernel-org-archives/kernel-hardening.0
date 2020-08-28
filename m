Return-Path: <SRS0=Ghnv=CG=lists.openwall.com=kernel-hardening-return-19711-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3256EC433E6
	for <kernel-hardening@archiver.kernel.org>; Fri, 28 Aug 2020 19:24:54 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7F18A20848
	for <kernel-hardening@archiver.kernel.org>; Fri, 28 Aug 2020 19:24:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cbl6o1Iv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7F18A20848
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19711-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24536 invoked by uid 550); 28 Aug 2020 19:24:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24514 invoked from network); 28 Aug 2020 19:24:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1598642671;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sg9fSrFQWXxpehnV4M1dhnTgmup13p6OKz0M6A4ji4k=;
	b=cbl6o1Ivu+iE/vpNZM5sziUiybyqNX1mY+WKWDVIxnrvFIxBC5DJgbqXIYoNMaTM2wKX2E
	ZJFvSOwESJ/jdaqvv0AYTIdQ817RuF6yeom57l/WvsSBBWx37nAZyNNLvgr640BAtL25sh
	4xz3VL8po58gYvCFG8DHjDkVKwVYdzs=
X-MC-Unique: w0KKgvflMN6fGsKM0dzwlw-1
Date: Fri, 28 Aug 2020 14:24:13 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Miroslav Benes <mbenes@suse.cz>
Cc: Kristen Carlson Accardi <kristen@linux.intel.com>,
	Kees Cook <keescook@chromium.org>, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, arjan@linux.intel.com,
	x86@kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com,
	live-patching@vger.kernel.org, Hongjiu Lu <hongjiu.lu@intel.com>,
	joe.lawrence@redhat.com
Subject: Re: [PATCH v4 00/10] Function Granular KASLR
Message-ID: <20200828192413.p6rctr42xtuh2c2e@treble>
References: <20200717170008.5949-1-kristen@linux.intel.com>
 <alpine.LSU.2.21.2007221122110.10163@pobox.suse.cz>
 <202007220738.72F26D2480@keescook>
 <20200722160730.cfhcj4eisglnzolr@treble>
 <202007221241.EBC2215A@keescook>
 <301c7fb7d22ad6ef97856b421873e32c2239d412.camel@linux.intel.com>
 <20200722213313.aetl3h5rkub6ktmw@treble>
 <46c49dec078cb8625a9c3a3cd1310a4de7ec760b.camel@linux.intel.com>
 <alpine.LSU.2.21.2008281216031.29208@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2008281216031.29208@pobox.suse.cz>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11

On Fri, Aug 28, 2020 at 12:21:13PM +0200, Miroslav Benes wrote:
> > Hi there! I was trying to find a super easy way to address this, so I
> > thought the best thing would be if there were a compiler or linker
> > switch to just eliminate any duplicate symbols at compile time for
> > vmlinux. I filed this question on the binutils bugzilla looking to see
> > if there were existing flags that might do this, but H.J. Lu went ahead
> > and created a new one "-z unique", that seems to do what we would need
> > it to do. 
> > 
> > https://sourceware.org/bugzilla/show_bug.cgi?id=26391
> > 
> > When I use this option, it renames any duplicate symbols with an
> > extension - for example duplicatefunc.1 or duplicatefunc.2. You could
> > either match on the full unique name of the specific binary you are
> > trying to patch, or you match the base name and use the extension to
> > determine original position. Do you think this solution would work?
> 
> Yes, I think so (thanks, Joe, for testing!).
> 
> It looks cleaner to me than the options above, but it may just be a matter 
> of taste. Anyway, I'd go with full name matching, because -z unique-symbol 
> would allow us to remove sympos altogether, which is appealing.
> 
> > If
> > so, I can modify livepatch to refuse to patch on duplicated symbols if
> > CONFIG_FG_KASLR and when this option is merged into the tool chain I
> > can add it to KBUILD_LDFLAGS when CONFIG_FG_KASLR and livepatching
> > should work in all cases. 
> 
> Ok.
> 
> Josh, Petr, would this work for you too?

Sounds good to me.  Kristen, thanks for finding a solution!

-- 
Josh

