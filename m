Return-Path: <SRS0=LoLU=7D=lists.openwall.com=kernel-hardening-return-18847-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AE4DC433E0
	for <kernel-hardening@archiver.kernel.org>; Thu, 21 May 2020 20:00:34 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4E6FE20748
	for <kernel-hardening@archiver.kernel.org>; Thu, 21 May 2020 20:00:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="arknal30"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E6FE20748
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18847-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1754 invoked by uid 550); 21 May 2020 20:00:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1731 invoked from network); 21 May 2020 20:00:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ulvs3QovAejney8/yaIpAssOKiAEegTNo53VZEhb45g=;
        b=arknal30qqyUt9Uultoin1W2eEnpjZOh2M50gfKNKsh2c05XoVw664fE7SmegYbFqL
         1jYIOZFK3qvFTzSvZb1a/0TeRh7x1QwAIQ0yudjxW7Ohj3kbGc5wR0AnbDcmCs1eSjqo
         W43A5+fzigzpmM6CKgu4thGrBpPlM6zXWyDTc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ulvs3QovAejney8/yaIpAssOKiAEegTNo53VZEhb45g=;
        b=F/BFa+at2BVVCsLeApL4Il+WoFBQZp7ruWLvz/lbJh6FRT7yZ7AITsF4uaZ2MinnFk
         7XAjjVA3tfK2TMrZSDi60P2aXsWq3UEwmHiFyJsOHOvUHTzsozuAKvx3OhO30Y+F7jYa
         jSGlvAukTCLJISsyylspkeaGRRo0iiLTj+Tdl/9BkwIUY0xY2xQYqUFPHxQs9duM8kpY
         s/1/gpxRyyHnLWz61KEG6sJcjZUpX+Z22vGgOeNLKRnyRS6aHloMaua9kWNU39a5y3gH
         WlfMHl6L5P4ZJVsEueEujiwjm2cbSw4+dDBqKWtwOBKbCA9xxIniiY49qcnDAUb1Twnm
         k2/A==
X-Gm-Message-State: AOAM532C5n1UKZD0ickmk62vvvbEiLvHQg+RLf3XQ2tYNVr7chXB/sb/
	FxmZSgznKHySHaDrOJMYkgLZhw==
X-Google-Smtp-Source: ABdhPJygsq417Det10M2bkwgpyvuYKzPNse7VchUrWVJXxj4vjS2acqQQI4FoLCeiaO83wNsdfO0qw==
X-Received: by 2002:a17:90a:4fc6:: with SMTP id q64mr241368pjh.34.1590091215159;
        Thu, 21 May 2020 13:00:15 -0700 (PDT)
Date: Thu, 21 May 2020 13:00:12 -0700
From: Kees Cook <keescook@chromium.org>
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	Masahiro Yamada <masahiroy@kernel.org>,
	Michal Marek <michal.lkml@markovi.net>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, arjan@linux.intel.com,
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
	rick.p.edgecombe@intel.com, Tony Luck <tony.luck@intel.com>,
	linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v2 4/9] x86: Makefile: Add build and config option for
 CONFIG_FG_KASLR
Message-ID: <202005211255.33E27D05@keescook>
References: <20200521165641.15940-1-kristen@linux.intel.com>
 <20200521165641.15940-5-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200521165641.15940-5-kristen@linux.intel.com>

On Thu, May 21, 2020 at 09:56:35AM -0700, Kristen Carlson Accardi wrote:
> Allow user to select CONFIG_FG_KASLR if dependencies are met. Change
> the make file to build with -ffunction-sections if CONFIG_FG_KASLR
> 
> Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> Tested-by: Tony Luck <tony.luck@intel.com>
> ---
>  Makefile         |  4 ++++
>  arch/x86/Kconfig | 13 +++++++++++++
>  2 files changed, 17 insertions(+)
> 
> diff --git a/Makefile b/Makefile
> index 04f5662ae61a..28e515baa824 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -862,6 +862,10 @@ ifdef CONFIG_LIVEPATCH
>  KBUILD_CFLAGS += $(call cc-option, -flive-patching=inline-clone)
>  endif
>  
> +ifdef CONFIG_FG_KASLR
> +KBUILD_CFLAGS += -ffunction-sections
> +endif
> +
>  # arch Makefile may override CC so keep this after arch Makefile is included
>  NOSTDINC_FLAGS += -nostdinc -isystem $(shell $(CC) -print-file-name=include)
>  
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 2d3f963fd6f1..50e83ea57d70 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -2183,6 +2183,19 @@ config RANDOMIZE_BASE
>  
>  	  If unsure, say Y.
>  
> +config FG_KASLR
> +	bool "Function Granular Kernel Address Space Layout Randomization"
> +	depends on $(cc-option, -ffunction-sections)
> +	depends on RANDOMIZE_BASE && X86_64
> +	help
> +	  This option improves the randomness of the kernel text
> +	  over basic Kernel Address Space Layout Randomization (KASLR)
> +	  by reordering the kernel text at boot time. This feature
> +	  uses information generated at compile time to re-layout the
> +	  kernel text section at boot time at function level granularity.
> +
> +	  If unsure, say N.
> +
>  # Relocation on x86 needs some additional build support
>  config X86_NEED_RELOCS
>  	def_bool y

Kconfig bikeshedding: how about putting FG_KASLR in arch/Kconfig, add
a "depends on ARCH_HAS_FG_KASLR", and remove the arch-specific depends.

Then in arch/x86 have ARCH_HAS_FG_KASLR as a def_bool y with the
RANDOMIZE_BASE && X86_64 depends.

This will more cleanly split the build elements (compiler flags) from
the arch elements (64-bit x86, arch-specific flags, etc).

With that split out:

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
