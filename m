Return-Path: <SRS0=6tV7=7W=lists.openwall.com=kernel-hardening-return-18946-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BCAEC433DF
	for <kernel-hardening@archiver.kernel.org>; Tue,  9 Jun 2020 20:42:22 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9B12A207C3
	for <kernel-hardening@archiver.kernel.org>; Tue,  9 Jun 2020 20:42:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="YrIcM+oZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9B12A207C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18946-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 2047 invoked by uid 550); 9 Jun 2020 20:42:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 2027 invoked from network); 9 Jun 2020 20:42:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=S1vBKT0yWnLuB7U8YX8ngGZwmaPvDRzzZCxacO5i+2o=;
        b=YrIcM+oZzwpQaYRF0+ivYfdkE5+At1SGS3X9EkfMcFYnQ+ao3zSFVraPEM6FbJ8twK
         HBHi4qmnExk02NZLB0ffAs8BamSKAcrwlwQAzlslHSqCzDpn7ILTkQUhPepWDwTN7hgf
         AxufcJX6gK90h1RBevEPiDUscn+AdlZoV56is=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S1vBKT0yWnLuB7U8YX8ngGZwmaPvDRzzZCxacO5i+2o=;
        b=g72D3hTzDg20hMEQSXzyUzZZG7wl4XSKTkwDzrru/3imUhRguJo3qbI/dRE+O4mP1x
         pOTSgsqbulJpChDApJuNnbVKvgkB8yq7ctQZFPC7jZt0WqgtRY5rQlZ3uwOA2IRNWtLL
         kuwLXo1bTlwkgONyOBwXLef16wuugtr1SLRp0YL3IhSFUJsWL+vbMbzFNld5Siw+p93w
         cxOUWOt+6yqMlotR+x0uY6fRxA2K9nY3CYnzgMIZZ430Akbd21MC5AsjZOgEKzSiImRG
         ig/4xaIei9og5bxpXpOz+fVqihi1zD1DwVgo64MYQjxApOxG3KUA6mcvksCFvgURTK0r
         +yHw==
X-Gm-Message-State: AOAM532EC3hAkeoAU2tnxlsDqACkl/8herhkUnM6N9jIG1kteKtQjyVb
	1xtGsaZdglHNSXSk/uajyVhwVg==
X-Google-Smtp-Source: ABdhPJzO1L5JcpjNQ1QE9BAOCAjYufkWhpqSvVnXwQlzZodQAiLOBVJh8pc1XAtAd6P8ACdRXXCBKA==
X-Received: by 2002:a17:902:40a:: with SMTP id 10mr180863ple.52.1591735322434;
        Tue, 09 Jun 2020 13:42:02 -0700 (PDT)
Date: Tue, 9 Jun 2020 13:42:00 -0700
From: Kees Cook <keescook@chromium.org>
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Jessica Yu <jeyu@kernel.org>,
	arjan@linux.intel.com, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com,
	Ard Biesheuvel <ardb@kernel.org>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH v2 9/9] module: Reorder functions
Message-ID: <202006091331.A94BB0DA@keescook>
References: <20200521165641.15940-1-kristen@linux.intel.com>
 <20200521165641.15940-10-kristen@linux.intel.com>
 <202005211415.5A1ECC638@keescook>
 <9fdea0bc0008eccd6dfcad496b37930cf5bd364a.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9fdea0bc0008eccd6dfcad496b37930cf5bd364a.camel@linux.intel.com>

On Tue, Jun 09, 2020 at 01:14:04PM -0700, Kristen Carlson Accardi wrote:
> On Thu, 2020-05-21 at 14:33 -0700, Kees Cook wrote:
> > Oh! And I am reminded suddenly about CONFIG_FG_KASLR needing to
> > interact
> > correctly with CONFIG_LD_DEAD_CODE_DATA_ELIMINATION in that we do NOT
> > want the sections to be collapsed at link time:
> 
> sorry - I'm a little confused and was wondering if you could clarify
> something. Does this mean you expect CONFIG_FG_KASLR=y and
> CONFIG_LD_DEAD_CODE_DATA_ELIMINATION=y to be a valid config? I am not

Yes, I don't see a reason they can't be used together.

> familiar with the option, but it seems like you are saying that it
> requires sections to be collapsed, in which case both of these options
> as yes would not be allowed? Should I actively prevent this in the
> Kconfig?

No, I'm saying that CONFIG_LD_DEAD_CODE_DATA_ELIMINATION does _not_
actually require that the sections be collapsed, but the Makefile
currently does this just to keep the resulting ELF "tidy". We want
that disabled (for the .text parts) in the case of CONFIG_FG_KASLR. The
dead code elimination step, is, IIUC, done at link time before the
output sections are written.

-- 
Kees Cook
