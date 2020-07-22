Return-Path: <SRS0=ozdc=BB=lists.openwall.com=kernel-hardening-return-19420-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19C06C433E2
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Jul 2020 19:43:12 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6855E20714
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Jul 2020 19:43:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="UQTdPm/n"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6855E20714
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19420-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11598 invoked by uid 550); 22 Jul 2020 19:43:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11572 invoked from network); 22 Jul 2020 19:43:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j8EVfDnsbKkDzkQmKYCo8r+kuzC3a5xUIaeiauPjHyg=;
        b=UQTdPm/nC+HkSL2BrWnoVYlDw4QRQrGAqDirB5zm5BpUzgtCvJy4d6xrBDUdh5Guck
         /So1K/Y/MIZEeY8A8JAEnjxncJ8eGOce7xc0/mjnlbSh3Wd2At8ckPa28ZKIzSZ4bf/0
         ZywAUOxsQOzs1FswGb+32DSfL9xYxikcwziYE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j8EVfDnsbKkDzkQmKYCo8r+kuzC3a5xUIaeiauPjHyg=;
        b=ihrY1glHxhQIyqNodzCP6EFgudwDrk+4b7aTzZZ4cxStUJ3zpFWJJbYHPjmjkRf+NZ
         mRVJt1W4FswYyF52eGjLFo9DWnAmwzDwI0vVIrKWMOqX9+GMeeXX/vOi0vB2MFyK1RoL
         vWvNXfNXKiFt1rtP1sGCrM16EgFoTuX65CjaAmoBeAcQUxHkZn29W1MAvHRVFl9Al8gi
         uu8mRaVHIeB6un0bi49ZAQ4nXTNQS4FRK0W6UjLLr/DgRLWkIHYa69l7OWXPY6hpFhIT
         IFGbXjsOBYQrKHu3rCdDs7OfO4qWKQl6C143TL3dCCarMhSY1YFLoIYX0G1T2jpy980/
         t9wg==
X-Gm-Message-State: AOAM533yPk7mlGrfFqdDdrQb79F2t1fEnUOtXFKiZzD+ML0s76OMmg0+
	LV7BN2vhlnicI+BVIN4zkasxbQ==
X-Google-Smtp-Source: ABdhPJwNDMuWHpZri+I/lnXdThH9TpOPI3+GSq/C/NGpYVJ4A3ptfCQ9jBQki7H6FXs3LEtMLCmGWw==
X-Received: by 2002:a17:90b:2350:: with SMTP id ms16mr903643pjb.127.1595446972510;
        Wed, 22 Jul 2020 12:42:52 -0700 (PDT)
Date: Wed, 22 Jul 2020 12:42:50 -0700
From: Kees Cook <keescook@chromium.org>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Miroslav Benes <mbenes@suse.cz>,
	Kristen Carlson Accardi <kristen@linux.intel.com>,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	arjan@linux.intel.com, x86@kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com,
	live-patching@vger.kernel.org
Subject: Re: [PATCH v4 00/10] Function Granular KASLR
Message-ID: <202007221241.EBC2215A@keescook>
References: <20200717170008.5949-1-kristen@linux.intel.com>
 <alpine.LSU.2.21.2007221122110.10163@pobox.suse.cz>
 <202007220738.72F26D2480@keescook>
 <20200722160730.cfhcj4eisglnzolr@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722160730.cfhcj4eisglnzolr@treble>

On Wed, Jul 22, 2020 at 11:07:30AM -0500, Josh Poimboeuf wrote:
> On Wed, Jul 22, 2020 at 07:39:55AM -0700, Kees Cook wrote:
> > On Wed, Jul 22, 2020 at 11:27:30AM +0200, Miroslav Benes wrote:
> > > Let me CC live-patching ML, because from a quick glance this is something 
> > > which could impact live patching code. At least it invalidates assumptions 
> > > which "sympos" is based on.
> > 
> > In a quick skim, it looks like the symbol resolution is using
> > kallsyms_on_each_symbol(), so I think this is safe? What's a good
> > selftest for live-patching?
> 
> The problem is duplicate symbols.  If there are two static functions
> named 'foo' then livepatch needs a way to distinguish them.
> 
> Our current approach to that problem is "sympos".  We rely on the fact
> that the second foo() always comes after the first one in the symbol
> list and kallsyms.  So they're referred to as foo,1 and foo,2.

Ah. Fun. In that case, perhaps the LTO series has some solutions. I
think builds with LTO end up renaming duplicate symbols like that, so
it'll be back to being unique.

-- 
Kees Cook
