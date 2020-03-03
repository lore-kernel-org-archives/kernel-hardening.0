Return-Path: <SRS0=NATd=4U=lists.openwall.com=kernel-hardening-return-18046-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66E72C3F2CD
	for <kernel-hardening@archiver.kernel.org>; Tue,  3 Mar 2020 05:00:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AFFFD214D8
	for <kernel-hardening@archiver.kernel.org>; Tue,  3 Mar 2020 05:00:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="nbtp2Tl3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AFFFD214D8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18046-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17477 invoked by uid 550); 3 Mar 2020 05:00:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17451 invoked from network); 3 Mar 2020 05:00:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OSg+JSGp6hQhw1bce7F3mzW7bduFXt5gWaDypQm8zyQ=;
        b=nbtp2Tl36OKExvWG4Z11h/mNp7CTtxBemLmJhMZ31czsu66C86WttOMdwcZrEfew9l
         stexFmDexS+B5uCgHu4F404ZjmjNs/DCYfxYCA74JgeyMxOOnWB5Wq+tRyLYJp3gcR1C
         9in0FcBLeOIrELlzyfvQH3MvAXgrRU6VQDef8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OSg+JSGp6hQhw1bce7F3mzW7bduFXt5gWaDypQm8zyQ=;
        b=kIzFaFeti+dq3HlgVEXC1TqxZHt5+AwOyyr46ylNDoW+5CpAjIMO8sGzQoMG+WL3nY
         T56WcrXgH8SX6U0aeJ5Mxal+dpc5/H+YPFZ5j6K7lypQT1betnX2pF7jX/zIyoApESwL
         JU8fini93mJPaWxqJFCugstCHGF586kbQDAqVaiNsA3x6glaNL/08Lqjii/gl+Dc7zt+
         x7L5dIXTqMnN1BKllKiKizmHE8PYWJTvZdEBpDRppc5KO/GUFmSricin9LgmH+xvi0ON
         N4GvrtJ4iDX5CTDDohQ5bpHSHSJ5Fl/W4L/msuAADqp96jsGFOs4lp/Pfq0roM7kYRvy
         rcRg==
X-Gm-Message-State: ANhLgQ2souMajwQ0aRAtHHxeUDwifcNlb4oKvHk/27aNek2ioh5h6YoP
	wd8I/WFX+Cj2uKRqG1O5QBYL+Q==
X-Google-Smtp-Source: ADFU+vupxZfjILlqH5h0J2YTQlKFsovubCjWTMtXLdyyWGfbmfoz5dCW8BCqr9rffqRMgylCer7bUg==
X-Received: by 2002:a17:90b:2290:: with SMTP id kx16mr2109790pjb.152.1583211601610;
        Mon, 02 Mar 2020 21:00:01 -0800 (PST)
Date: Mon, 2 Mar 2020 20:59:59 -0800
From: Kees Cook <keescook@chromium.org>
To: Thomas Garnier <thgarnie@chromium.org>
Cc: kernel-hardening@lists.openwall.com, kristen@linux.intel.com,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 11/11] x86/alternatives: Adapt assembly for PIE
 support
Message-ID: <202003022059.67FCB9CB75@keescook>
References: <20200228000105.165012-1-thgarnie@chromium.org>
 <20200228000105.165012-12-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200228000105.165012-12-thgarnie@chromium.org>

On Thu, Feb 27, 2020 at 04:00:56PM -0800, Thomas Garnier wrote:
> Change the assembly options to work with pointers instead of integers.
> The generated code is the same PIE just ensures input is a pointer.
> 
> Signed-off-by: Thomas Garnier <thgarnie@chromium.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  arch/x86/include/asm/alternative.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
> index 13adca37c99a..43a148042656 100644
> --- a/arch/x86/include/asm/alternative.h
> +++ b/arch/x86/include/asm/alternative.h
> @@ -243,7 +243,7 @@ static inline int alternatives_text_reserved(void *start, void *end)
>  /* Like alternative_io, but for replacing a direct call with another one. */
>  #define alternative_call(oldfunc, newfunc, feature, output, input...)	\
>  	asm_inline volatile (ALTERNATIVE("call %P[old]", "call %P[new]", feature) \
> -		: output : [old] "i" (oldfunc), [new] "i" (newfunc), ## input)
> +		: output : [old] "X" (oldfunc), [new] "X" (newfunc), ## input)
>  
>  /*
>   * Like alternative_call, but there are two features and respective functions.
> @@ -256,8 +256,8 @@ static inline int alternatives_text_reserved(void *start, void *end)
>  	asm_inline volatile (ALTERNATIVE_2("call %P[old]", "call %P[new1]", feature1,\
>  		"call %P[new2]", feature2)				      \
>  		: output, ASM_CALL_CONSTRAINT				      \
> -		: [old] "i" (oldfunc), [new1] "i" (newfunc1),		      \
> -		  [new2] "i" (newfunc2), ## input)
> +		: [old] "X" (oldfunc), [new1] "X" (newfunc1),		      \
> +		  [new2] "X" (newfunc2), ## input)
>  
>  /*
>   * use this macro(s) if you need more than one output parameter
> -- 
> 2.25.1.481.gfbce0eb801-goog
> 

-- 
Kees Cook
