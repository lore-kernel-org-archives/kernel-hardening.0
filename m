Return-Path: <SRS0=62+t=YZ=lists.openwall.com=kernel-hardening-return-17211-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D53F8CA9EC9
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 03:47:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 29365208E3
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 03:47:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="OUr7ArDi"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 29365208E3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17211-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19464 invoked by uid 550); 1 Nov 2019 03:47:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18420 invoked from network); 1 Nov 2019 03:47:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=u5Q9VGAIWgqBExeYcYbdu3s9udgqDxFzlJQ7eRueT/Q=;
        b=OUr7ArDiqHbONLazU8MgPIGz23M1A8vMM7F8b9Md5DVHQ+EZhCFgoZlMZ+G5HTnpZ+
         wE2eqONi9hN3i5Bcrge6nsj37dKyheWOwYi04/RxLQQQWFlzKYDXXwSGgtrWINXpoHTa
         pu2AouoST0OW8JKhXcovsqIH4Xg7eOJ6N8a30=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u5Q9VGAIWgqBExeYcYbdu3s9udgqDxFzlJQ7eRueT/Q=;
        b=lRIfCYU54RRcM5LGzYzKrx8XdrKWCmRPCP3hF2i4GNLSD6S00DK32KDRfFzDRt4xQT
         13ynfI2T3+aDNSzdAqbbG/SUiz8lAp5kBasbjCGHmH7FhRq8Fbpsf8dWdHfkhUboSUue
         xOjJhs+d/2FKf7JBbWcFYB1+4zgW1IQ+cnBK168HOnGZQ4SdNCAFpGWXF42SLvpT+h3X
         4lCGebV8sUyWsvNvGkKFTccbHUb39x87Kt+WjhyRkkb+2QAhSd4RPrLr4JhA9KP8MrEF
         IhJlWAz5jnOboCdZfhSYE6/Jin6oaOQO1ERGHGSs98fYapYM9ng0+M5tvwxr7JFg/bag
         2s7g==
X-Gm-Message-State: APjAAAVplMKB0Iu1Ad7W+Cl4ie+AaZuYxgmlYqPWxnJ7LIOu5TwGE7lA
	6iTqybDCfB0I/tmEqhloi46AvQ==
X-Google-Smtp-Source: APXvYqzxXwp35RHwMjtICT5o/o5TX+pRdcY4/XDk99r6vm9qvXrxFtMjtkTLjrDyCFVkkuXacPUM+g==
X-Received: by 2002:a17:902:9042:: with SMTP id w2mr10476445plz.323.1572580026099;
        Thu, 31 Oct 2019 20:47:06 -0700 (PDT)
Date: Thu, 31 Oct 2019 20:47:04 -0700
From: Kees Cook <keescook@chromium.org>
To: samitolvanen@google.com
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Dave Martin <Dave.Martin@arm.com>,
	Laura Abbott <labbott@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Jann Horn <jannh@google.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 04/17] arm64: kernel: avoid x18 __cpu_soft_restart
Message-ID: <201910312046.53A31D394@keescook>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191031164637.48901-1-samitolvanen@google.com>
 <20191031164637.48901-5-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191031164637.48901-5-samitolvanen@google.com>

On Thu, Oct 31, 2019 at 09:46:24AM -0700, samitolvanen@google.com wrote:
> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> 
> The code in __cpu_soft_restart() uses x18 as an arbitrary temp register,
> which will shortly be disallowed. So use x8 instead.
> 
> Link: https://patchwork.kernel.org/patch/9836877/
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

This one is easy to validate! ;)

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> Reviewed-by: Mark Rutland <mark.rutland@arm.com>
> ---
>  arch/arm64/kernel/cpu-reset.S | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kernel/cpu-reset.S b/arch/arm64/kernel/cpu-reset.S
> index 6ea337d464c4..32c7bf858dd9 100644
> --- a/arch/arm64/kernel/cpu-reset.S
> +++ b/arch/arm64/kernel/cpu-reset.S
> @@ -42,11 +42,11 @@ ENTRY(__cpu_soft_restart)
>  	mov	x0, #HVC_SOFT_RESTART
>  	hvc	#0				// no return
>  
> -1:	mov	x18, x1				// entry
> +1:	mov	x8, x1				// entry
>  	mov	x0, x2				// arg0
>  	mov	x1, x3				// arg1
>  	mov	x2, x4				// arg2
> -	br	x18
> +	br	x8
>  ENDPROC(__cpu_soft_restart)
>  
>  .popsection
> -- 
> 2.24.0.rc0.303.g954a862665-goog
> 

-- 
Kees Cook
