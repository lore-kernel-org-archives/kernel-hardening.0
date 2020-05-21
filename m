Return-Path: <SRS0=IGhl=7D=lists.openwall.com=kernel-hardening-return-18845-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9B98C433DF
	for <kernel-hardening@archiver.kernel.org>; Thu, 21 May 2020 18:11:41 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1A829207D3
	for <kernel-hardening@archiver.kernel.org>; Thu, 21 May 2020 18:11:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="g/kstoEF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1A829207D3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18845-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15379 invoked by uid 550); 21 May 2020 18:11:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 14331 invoked from network); 21 May 2020 18:11:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QnbqNy9EV06MW5CdU8p7rG6H8xARB4MCiMEyZtqlPZY=;
        b=g/kstoEF7jBH50MDuXScB/Wy07PeKyWkq6ndhA3tjBPgWJ0fihAAPJUK0c+ShkSt/7
         wNJiwUfFT3bKmn3+xX8i8/Aqrw/2AHceGXIuENBN9r3NnYy7oCRDmrpBRbLHh6v6yWO8
         bVxXeURBoZhPWu0Orftx1teKFHlJomMID6Lbg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QnbqNy9EV06MW5CdU8p7rG6H8xARB4MCiMEyZtqlPZY=;
        b=F3UiDGnz9nRuyZTKmjAm/y60T1pwk1cnTya6JWFenKT12esDcSnlP1o2MYdYxLRZlL
         Y+zsJeeom6wjWCRt24RSrdOjTMEnDSw8dGuC2vodjNiZqbYTtl7OlEa4DMpOKFIx6K87
         PFPzAxmiMKnFuSlfddmCXXpD+6TZhv5FzKSA0C5yG2Fc6hYpD8GqHjTwflhtl3zSEhDW
         342GTFVa0sMiZ5hJkSGUgo28XnWS8klDjVIXmJ8xcUVE7cI9yVha+Nj95O5X91ZhsAxH
         omY2CVgItcIHXtuxrgGur3QwHjFDHp0gpx2tkFau0zOsHNS4dMlxFh9Y7jgkj7ZsRe4+
         fb0A==
X-Gm-Message-State: AOAM532udtVBrEoygHzzV44P6K0UivvoS7YHTIT4jyeQ2O6s8VBCYa/L
	DkRd20ESlr/OrduMIU626s6bCA==
X-Google-Smtp-Source: ABdhPJy113rjg4c4EN6iCv8PasCClmRYQtUFgwcjDCT+6DDqbtZLHo/8b4GBbIQvhAQar9rQTc/TEw==
X-Received: by 2002:a17:902:bf43:: with SMTP id u3mr10554884pls.240.1590084681259;
        Thu, 21 May 2020 11:11:21 -0700 (PDT)
Date: Thu, 21 May 2020 11:11:18 -0700
From: Kees Cook <keescook@chromium.org>
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
	arjan@linux.intel.com, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com,
	Tony Luck <tony.luck@intel.com>, linux-arch@vger.kernel.org
Subject: Re: [PATCH v2 5/9] x86: Make sure _etext includes function sections
Message-ID: <202005211109.4EE4DCBA3@keescook>
References: <20200521165641.15940-1-kristen@linux.intel.com>
 <20200521165641.15940-6-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200521165641.15940-6-kristen@linux.intel.com>

On Thu, May 21, 2020 at 09:56:36AM -0700, Kristen Carlson Accardi wrote:
> When using -ffunction-sections to place each function in
> it's own text section so it can be randomized at load time, the
> linker considers these .text.* sections "orphaned sections", and
> will place them after the first similar section (.text). In order
> to accurately represent the end of the text section and the
> orphaned sections, _etext must be moved so that it is after both
> .text and .text.* The text size must also be calculated to
> include .text AND .text.*
> 
> Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> Tested-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/vmlinux.lds.S     | 18 +++++++++++++++++-
>  include/asm-generic/vmlinux.lds.h |  2 +-
>  2 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
> index 1bf7e312361f..044f7528a2f0 100644
> --- a/arch/x86/kernel/vmlinux.lds.S
> +++ b/arch/x86/kernel/vmlinux.lds.S
> @@ -147,8 +147,24 @@ SECTIONS
>  #endif
>  	} :text =0xcccc
>  
> -	/* End of text section, which should occupy whole number of pages */
> +#ifdef CONFIG_FG_KASLR
> +	/*
> +	 * -ffunction-sections creates .text.* sections, which are considered
> +	 * "orphan sections" and added after the first similar section (.text).
> +	 * Adding this ALIGN statement causes the address of _etext
> +	 * to be below that of all the .text.* orphaned sections
> +	 */
> +	. = ALIGN(PAGE_SIZE);
> +#endif
>  	_etext = .;
> +
> +	/*
> +	 * the size of the .text section is used to calculate the address
> +	 * range for orc lookups. If we just use SIZEOF(.text), we will
> +	 * miss all the .text.* sections. Calculate the size using _etext
> +	 * and _stext and save the value for later.
> +	 */
> +	text_size = _etext - _stext;
>  	. = ALIGN(PAGE_SIZE);

I don't think there's any need for this #ifdef (nor the trailing ALIGN).
I think leave the comment to explain why the ALIGN is being moved before
the _etext.

A repeated ALIGN won't move the position:

--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -147,9 +147,11 @@ SECTIONS
 #endif
        } :text =0xcccc
 
+       . = ALIGN(PAGE_SIZE);
        /* End of text section, which should occupy whole number of * pages */
        _etext = .;
        . = ALIGN(PAGE_SIZE);
+       _ktext = .;
 
        X86_ALIGN_RODATA_BEGIN
        RO_DATA(PAGE_SIZE)


$ nm vmlinux | grep '_[ek]text'
ffffffff81e02000 R _etext
ffffffff81e02000 R _ktext

-- 
Kees Cook
