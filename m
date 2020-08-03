Return-Path: <SRS0=uuRd=BN=lists.openwall.com=kernel-hardening-return-19548-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0753C433E0
	for <kernel-hardening@archiver.kernel.org>; Mon,  3 Aug 2020 21:41:28 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7E7A1207FC
	for <kernel-hardening@archiver.kernel.org>; Mon,  3 Aug 2020 21:41:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="cP3b+JMQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7E7A1207FC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19548-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1047 invoked by uid 550); 3 Aug 2020 21:41:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1026 invoked from network); 3 Aug 2020 21:41:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AoXxxzPdcjWwfJPdErgifOsTsvhhfF5cKu6R8ZrrXiE=;
        b=cP3b+JMQBwVvMgicWaLrhYHCtWd5xoSj8dj2pYNIWtzEsYYJHvm6UFtv4fCjHWdqV/
         80FE7JTPA3xE9NC1kzqojZBRfaL8sYYxgslYAa7F69WcFl+x2nosPcFZb2Ok+yHsL99p
         qpAG8+RGZRwE8k74YOkvNHoo5nYxA1SiGOgV8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AoXxxzPdcjWwfJPdErgifOsTsvhhfF5cKu6R8ZrrXiE=;
        b=oXR/cdEAeHi9U4JWFBNyb4fDfX1rLuOWo/3WpaCdePuQqlx8P2v7nocpARWawHmObo
         BK6FhOAQWbd/V500OSvN4p6wPrVmqJ0/SOl76JTu4U1xhrQlW1Gqu0hFPsGedKSzJdP1
         Z2tGZ+tf3BatZu1hFs2UOhzIDZyecKhrasH2pImS2Fes4EkANaq7qCFIXLoXbhPy9niu
         T1GVSPmOkIM0DVlw88UQmIL+x8r+1MFCbL9gZShZSnuIliyt5H8215YpGL2UtXyQTYau
         qXpQN+mrV2Ywo97a2p/4yB4yK7uVIfIpH24dg+lc4J/BCsCTupGJreoZTWlSb+dDsFIs
         XfMQ==
X-Gm-Message-State: AOAM530iRM3D3di8XicbN7N3xOZFH4IfjlWVFFJgNk7g0PGsNEdn/wAj
	W/rITCMOoxGD2503UrPvBR0WgQ==
X-Google-Smtp-Source: ABdhPJzKfOSTGggKfBY9ChUZm4EGBh+2aAyWRhVuvypuYHUArV91N1Rdgtgk5e2SPvx0o4R9ZogITA==
X-Received: by 2002:a17:90a:6d96:: with SMTP id a22mr1158690pjk.26.1596490869599;
        Mon, 03 Aug 2020 14:41:09 -0700 (PDT)
Date: Mon, 3 Aug 2020 14:41:07 -0700
From: Kees Cook <keescook@chromium.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Joe Lawrence <joe.lawrence@redhat.com>,
	Evgenii Shatokhin <eshatokhin@virtuozzo.com>,
	Kristen Carlson Accardi <kristen@linux.intel.com>,
	Miroslav Benes <mbenes@suse.cz>, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, arjan@linux.intel.com,
	x86@kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com,
	live-patching@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
	Jessica Yu <jeyu@kernel.org>
Subject: Re: [PATCH v4 00/10] Function Granular KASLR
Message-ID: <202008031439.F1399A588@keescook>
References: <20200717170008.5949-1-kristen@linux.intel.com>
 <alpine.LSU.2.21.2007221122110.10163@pobox.suse.cz>
 <e9c4d88b-86db-47e9-4299-3fac45a7e3fd@virtuozzo.com>
 <202008031043.FE182E9@keescook>
 <fc6d2289-af97-5cf8-a4bb-77c2b0b8375c@redhat.com>
 <20200803193837.GB30810@redhat.com>
 <202008031310.4F8DAA20@keescook>
 <20200803211228.GC30810@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200803211228.GC30810@redhat.com>

On Mon, Aug 03, 2020 at 05:12:28PM -0400, Frank Ch. Eigler wrote:
> Hi -
> 
> On Mon, Aug 03, 2020 at 01:11:27PM -0700, Kees Cook wrote:
> > [...]
> > > Systemtap needs to know base addresses of loaded text & data sections,
> > > in order to perform relocation of probe point PCs and context data
> > > addresses.  It uses /sys/module/...., kind of under protest, because
> > > there seems to exist no MODULE_EXPORT'd API to get at that information
> > > some other way.
> > 
> > Wouldn't /proc/kallsysms entries cover this? I must be missing
> > something...
> 
> We have relocated based on sections, not some subset of function
> symbols accessible that way, partly because DWARF line- and DIE- based
> probes can map to addresses some way away from function symbols, into
> function interiors, or cloned/moved bits of optimized code.  It would
> take some work to prove that function-symbol based heuristic
> arithmetic would have just as much reach.

Interesting. Do you have an example handy? It seems like something like
that would reference the enclosing section, which means we can't just
leave them out of the sysfs list... (but if such things never happen in
the function-sections, then we *can* remove them...)

-- 
Kees Cook
