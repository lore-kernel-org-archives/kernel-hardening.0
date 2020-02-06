Return-Path: <SRS0=W1yC=32=lists.openwall.com=kernel-hardening-return-17714-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F6F6C33CAC
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 15:46:08 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E43C121741
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 15:46:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RAFdqENd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E43C121741
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=alum.mit.edu
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17714-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1486 invoked by uid 550); 6 Feb 2020 15:46:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1466 invoked from network); 6 Feb 2020 15:46:01 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Mn+wA32ADRES29XAZT8b1wcKCAP8BI3eSNuQNmbNfNI=;
        b=RAFdqENdrRpxI0v2GiPV3o1SXTb/XkGh+oHRxBt+cT6uE9zL54hbm8+2vQazQwl5j1
         9H5N04RZiQRovRUQnqLFFJAovT4rnmd01bEcD7JSx/m4DYMnYRH/ziFiLYRFSLs7Qx1O
         rZ20FG4+w7tQv6Ee7YhedtQxyNULYNkE2pTerz0GTHv3H2pWs4KeZsPPwTxfY7jI1/wa
         Bn1SF2Z7b2BXTPXUZOAnkI60557e/9CrOopaLf1EsYorWzsE795nuwz5DZwLFNYiyA2Z
         r8nAm3vmkM9YfsnkPntdLZJHuQegXZwrnd8YXiy7NZxgCBje5vo9U86wVEC2mSQA6uP3
         HWAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Mn+wA32ADRES29XAZT8b1wcKCAP8BI3eSNuQNmbNfNI=;
        b=QRH8VH0zdqkkbKYY5l+t1nGP5KYv6UwBv0nkwtFW4AndBMOfBnSP2KaiyNWRTNKUoU
         7CAsxDFuCB7kAhKnat6qgv/PYZFmSOLrFWC22hCX1TDHOEdMoBiA17tJrhzrHaej9o8j
         WFKerZbHBZNEawrS96tXM5nKNPHfGks2bmFCjQ9Ul90W5eGFJbfdlKC0rTcIrNB4uXGV
         WfamgbIoOUb4QqcenAi3eIx3FsWgqquWt7bKIGpQBJta3+AvhseVHM3uMILSwrQMdRrs
         sFnQGwUajDbBhRBk4UKtJ9fZ1tCy0rTs1i1h3z1k0zxmRUxBLz7ge9uuQLKKWZRzmBSw
         3Smw==
X-Gm-Message-State: APjAAAXcDAUiyyIcwm93e/xWD3V9McYuiJ25QuC1xOPkMnS8DJ8A8rQG
	BZKyXOmnv8uJ8EO9gtYLlZg=
X-Google-Smtp-Source: APXvYqwnM5iXRheHAs7nPBvixr2V+pZnAthM0vrkuFe9eFK8du3HOTpIyaFVDRn3kNtcGHFBn1SJ8Q==
X-Received: by 2002:a05:620a:1273:: with SMTP id b19mr3122584qkl.482.1581003949271;
        Thu, 06 Feb 2020 07:45:49 -0800 (PST)
Sender: Arvind Sankar <niveditas98@gmail.com>
From: Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date: Thu, 6 Feb 2020 10:45:47 -0500
To: Arvind Sankar <nivedita@alum.mit.edu>
Cc: Kees Cook <keescook@chromium.org>,
	Kristen Carlson Accardi <kristen@linux.intel.com>,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	arjan@linux.intel.com, rick.p.edgecombe@intel.com, x86@kernel.org,
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 06/11] x86: make sure _etext includes function
 sections
Message-ID: <20200206154547.GA3064177@rani.riverdale.lan>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
 <20200205223950.1212394-7-kristen@linux.intel.com>
 <202002060408.84005CEFFD@keescook>
 <20200206145738.GA3049612@rani.riverdale.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200206145738.GA3049612@rani.riverdale.lan>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Feb 06, 2020 at 09:57:40AM -0500, Arvind Sankar wrote:
> On Thu, Feb 06, 2020 at 04:26:23AM -0800, Kees Cook wrote:
> > On Wed, Feb 05, 2020 at 02:39:45PM -0800, Kristen Carlson Accardi wrote:
> > > We will be using -ffunction-sections to place each function in
> > > it's own text section so it can be randomized at load time. The
> > > linker considers these .text.* sections "orphaned sections", and
> > > will place them after the first similar section (.text). However,
> > > we need to move _etext so that it is after both .text and .text.*
> > > We also need to calculate text size to include .text AND .text.*
> > 
> > The dependency on the linker's orphan section handling is, I feel,
> > rather fragile (during work on CFI and generally building kernels with
> > Clang's LLD linker, we keep tripping over difference between how BFD and
> > LLD handle orphans). However, this is currently no way to perform a
> > section "pass through" where input sections retain their name as an
> > output section. (If anyone knows a way to do this, I'm all ears).
> > 
> > Right now, you can only collect sections like this:
> > 
> >         .text :  AT(ADDR(.text) - LOAD_OFFSET) {
> > 		*(.text.*)
> > 	}
> > 
> > or let them be orphans, which then the linker attempts to find a
> > "similar" (code, data, etc) section to put them near:
> > https://sourceware.org/binutils/docs-2.33.1/ld/Orphan-Sections.html
> > 
> > So, basically, yes, this works, but I'd like to see BFD and LLD grow
> > some kind of /PASSTHRU/ special section (like /DISCARD/), that would let
> > a linker script specify _where_ these sections should roughly live.
> > 
> 
> You could go through the objects that are being linked and find the
> individual text sections, and generate the linker script using that?

Also, one thing to note about the orphan section handling -- by default
ld will combine multiple orphan sections with the same name into a
single output section. So if you have sections corresponding to static
functions with the same name but from different files, they will get
unnecessarily combined. You may want to add --unique to the ld options
to keep them separate. That will create multiple sections with the same
name instead of merging them.
