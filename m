Return-Path: <SRS0=7IMJ=32=lists.openwall.com=kernel-hardening-return-17709-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 885ABC2D0B1
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 14:40:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D8D652082E
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 14:40:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ys8PYYc/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D8D652082E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=alum.mit.edu
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17709-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32000 invoked by uid 550); 6 Feb 2020 14:39:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 31978 invoked from network); 6 Feb 2020 14:39:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=i8ZXRcb1q1ZSxQ8Q/mjcQROT9/CmLPHcpBtDmaBy1Do=;
        b=Ys8PYYc/0KffCBFLBHCfIiPTSWh7o1gs3pvRab778kYvcRem+EEiC9ArZsRPtdj/MU
         qz8rh87ZY4R8tPufcXRQ3WJZSBAv4EHo4oS6iNeaIewlyDE1i2lE1m5TCGmLzxJk3ol/
         bIjLXlLTmfXIX3l79fRVQWu9wo+eXgVNQju9mZliLwvBZu35Br26tMCtk4f1h9HiFUjG
         sqkZpxTdi4r1pM8uPb/wfWgmgOrA4ZR86hVUtj42PSRmET8iDZsrhaJh7VaGFlhJOZE2
         1/EHItqP5lbpohrYWipysvn41cif3BBCHN/jgOlcUgnUJFTodDjrrsqjuEC185sijP9c
         nJwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=i8ZXRcb1q1ZSxQ8Q/mjcQROT9/CmLPHcpBtDmaBy1Do=;
        b=AEyz9OwdkEXjY2WzYS5OorweKLQGg1iGQsDxL1TFAnorSu1ZyvlYPlheRch1gYqYYV
         XpcCrcBlogsk4srrux5l8RyA8WMWmW3BK8ACy0I2Tjo6IDUI5AV7lx8RsECV2DIL8DuB
         yocSkrZhEK1+BH7uRdaovwSDGA5/9JxP2MWHerY8MLbuL4xfLtFjAEfg2x1upoAE1XKV
         A7dO17ufeFLaSxKMhksBIInmFHjI11DFVpnhvmaPEhTJp9OJpIlApQugJZlK5czgRnO0
         Z8UnpCTCc+ekCsuivnIHjZhooQ5xG9hqFcbtZsXqMfCzg9rG96MTryPdS3zblHmzhfj2
         nwEg==
X-Gm-Message-State: APjAAAUQBcurCHBKuctcA3TdaXp6LEaalGaGfX8j+9wMYjqbOWfa4iK3
	fCWwfb3Co7DcV0fokdeLE20=
X-Google-Smtp-Source: APXvYqyhDdGz3eHPZG7fiLYgFKopt6WoAXsJMOS9fseDCa61oFpV5/CBKfnx7SYfx4rk1uiOCCLshQ==
X-Received: by 2002:ac8:75d8:: with SMTP id z24mr2850675qtq.193.1580999985259;
        Thu, 06 Feb 2020 06:39:45 -0800 (PST)
Sender: Arvind Sankar <niveditas98@gmail.com>
From: Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date: Thu, 6 Feb 2020 09:39:43 -0500
To: Kees Cook <keescook@chromium.org>
Cc: Kristen Carlson Accardi <kristen@linux.intel.com>, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	arjan@linux.intel.com, rick.p.edgecombe@intel.com, x86@kernel.org,
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 06/11] x86: make sure _etext includes function
 sections
Message-ID: <20200206143941.GA3044151@rani.riverdale.lan>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
 <20200205223950.1212394-7-kristen@linux.intel.com>
 <202002060408.84005CEFFD@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202002060408.84005CEFFD@keescook>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Feb 06, 2020 at 04:26:23AM -0800, Kees Cook wrote:
> I know x86_64 stack alignment is 16 bytes. I cannot find evidence for
> what function start alignment should be. It seems the linker is 16 byte
> aligning these functions, when I think no alignment is needed for
> function starts, so we're wasting some memory (average 8 bytes per
> function, at say 50,000 functions, so approaching 512KB) between
> functions. If we can specify a 1 byte alignment for these orphan
> sections, that would be nice, as mentioned in the cover letter: we lose
> a 4 bits of entropy to this alignment, since all randomized function
> addresses will have their low bits set to zero.
> 

The default function alignment is 16-bytes for x64 at least with gcc.
You can use -falign-functions to specify a different alignment.

There was some old discussion on reducing it [1] but it doesn't seem to
have been merged.

[1] https://lore.kernel.org/lkml/tip-4874fe1eeb40b403a8c9d0ddeb4d166cab3f37ba@git.kernel.org/
