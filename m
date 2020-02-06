Return-Path: <SRS0=rQk3=32=lists.openwall.com=kernel-hardening-return-17701-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC36CC2D0B1
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 12:26:46 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F1788214AF
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 12:26:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="D63fMXu7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F1788214AF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17701-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25802 invoked by uid 550); 6 Feb 2020 12:26:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25775 invoked from network); 6 Feb 2020 12:26:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NOY8bS0asHpD+z721OXmKaafugnpGdhKSAQgjErq5zs=;
        b=D63fMXu7FJZcwQhCNxkpNOfFGC8DypWspcBegFsiI4VcZrFqIotWhCwDMPATuBJiaR
         0r3jy3H4r1OuKl9TP/+9jyIGTeAMZImp8EiuyJVDRquG6f8GWM5vL3Aj2ekMsgH52lKL
         DQ/0fYPfdM1hK/ifrIFdCc6Yi/9yUC+XTDLto=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NOY8bS0asHpD+z721OXmKaafugnpGdhKSAQgjErq5zs=;
        b=f7aEEjwbLlzNdJIDzrrV6DNwOU1zCP4h9Hrc5gCzS1E2V6TNaWvcoK99C/s1ymAWAT
         E4eCyQshdZi5oKmsl2qrMDZyJXUVKKQ+5ZxS/39CUjp/+FeYB0HHSBXh+y0IF2Q1gA2g
         Q7xOzDygp70vM7FVYd0gnk68F0SJoO9uV5iyQp0cFXRM3xu6rwRPVcIkj/rTT4fyTzTx
         X5/tPVzMCVRRR58jR5rnCRKAoXP/YbA9HduO50ZHwe/jlBetK2CXGaGj8tOSuCW7V8SP
         69sn7jV4sSxgvpqIeF/5D8Uv/rIXSV/JCudRucGTnS46prMmP06f/kvcMnzgzD+2QsXc
         SyDg==
X-Gm-Message-State: APjAAAXQHmcixqvXAYimB9BT07zxkaibTigc3tl7l2U/88WNpPHu+m3y
	31C9hec+bai90gkWiBeUug3UZSvHwvk=
X-Google-Smtp-Source: APXvYqwEZlN/eh3Ye+I2c+zEIeVmfOEkt+iEawFFgaC+cF+h2RqeLLo4LxogwNsdAQFa4PrpwOMMiQ==
X-Received: by 2002:a9d:7357:: with SMTP id l23mr28943725otk.10.1580991985931;
        Thu, 06 Feb 2020 04:26:25 -0800 (PST)
Date: Thu, 6 Feb 2020 04:26:23 -0800
From: Kees Cook <keescook@chromium.org>
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	arjan@linux.intel.com, rick.p.edgecombe@intel.com, x86@kernel.org,
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 06/11] x86: make sure _etext includes function
 sections
Message-ID: <202002060408.84005CEFFD@keescook>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
 <20200205223950.1212394-7-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200205223950.1212394-7-kristen@linux.intel.com>

On Wed, Feb 05, 2020 at 02:39:45PM -0800, Kristen Carlson Accardi wrote:
> We will be using -ffunction-sections to place each function in
> it's own text section so it can be randomized at load time. The
> linker considers these .text.* sections "orphaned sections", and
> will place them after the first similar section (.text). However,
> we need to move _etext so that it is after both .text and .text.*
> We also need to calculate text size to include .text AND .text.*

The dependency on the linker's orphan section handling is, I feel,
rather fragile (during work on CFI and generally building kernels with
Clang's LLD linker, we keep tripping over difference between how BFD and
LLD handle orphans). However, this is currently no way to perform a
section "pass through" where input sections retain their name as an
output section. (If anyone knows a way to do this, I'm all ears).

Right now, you can only collect sections like this:

        .text :  AT(ADDR(.text) - LOAD_OFFSET) {
		*(.text.*)
	}

or let them be orphans, which then the linker attempts to find a
"similar" (code, data, etc) section to put them near:
https://sourceware.org/binutils/docs-2.33.1/ld/Orphan-Sections.html

So, basically, yes, this works, but I'd like to see BFD and LLD grow
some kind of /PASSTHRU/ special section (like /DISCARD/), that would let
a linker script specify _where_ these sections should roughly live.

Related thoughts:

I know x86_64 stack alignment is 16 bytes. I cannot find evidence for
what function start alignment should be. It seems the linker is 16 byte
aligning these functions, when I think no alignment is needed for
function starts, so we're wasting some memory (average 8 bytes per
function, at say 50,000 functions, so approaching 512KB) between
functions. If we can specify a 1 byte alignment for these orphan
sections, that would be nice, as mentioned in the cover letter: we lose
a 4 bits of entropy to this alignment, since all randomized function
addresses will have their low bits set to zero.

And we can't adjust function section alignment, or there is some
benefit to a larger alignment, I would like to have a way for the linker
to specify the inter-section padding (or fill) bytes. Right now, the
FILL(0xnn) (or =0xnn) can be used to specify the padding bytes _within_
a section, but not between sections. Right now, BFD appears to 0-pad. I'd
like that to be 0xCC so "guessing" addresses incorrectly will trigger
a trap.

-Kees

> 
> Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> ---
>  arch/x86/kernel/vmlinux.lds.S     | 18 +++++++++++++++++-
>  include/asm-generic/vmlinux.lds.h |  2 +-
>  2 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
> index 3a1a819da137..e54e9ac5b429 100644
> --- a/arch/x86/kernel/vmlinux.lds.S
> +++ b/arch/x86/kernel/vmlinux.lds.S
> @@ -146,8 +146,24 @@ SECTIONS
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
>  
>  	X86_ALIGN_RODATA_BEGIN
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index e00f41aa8ec4..edf19f4296e2 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -798,7 +798,7 @@
>  	. = ALIGN(4);							\
>  	.orc_lookup : AT(ADDR(.orc_lookup) - LOAD_OFFSET) {		\
>  		orc_lookup = .;						\
> -		. += (((SIZEOF(.text) + LOOKUP_BLOCK_SIZE - 1) /	\
> +		. += (((text_size + LOOKUP_BLOCK_SIZE - 1) /	\
>  			LOOKUP_BLOCK_SIZE) + 1) * 4;			\
>  		orc_lookup_end = .;					\
>  	}
> -- 
> 2.24.1
> 

-- 
Kees Cook
