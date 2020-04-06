Return-Path: <SRS0=iju4=5W=lists.openwall.com=kernel-hardening-return-18444-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8DC4C2BA17
	for <kernel-hardening@archiver.kernel.org>; Mon,  6 Apr 2020 18:25:57 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4EF90206C3
	for <kernel-hardening@archiver.kernel.org>; Mon,  6 Apr 2020 18:25:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="SDponCt4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4EF90206C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18444-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25699 invoked by uid 550); 6 Apr 2020 18:25:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25675 invoked from network); 6 Apr 2020 18:25:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9XYlLQFnWWwdu63sAOZZGoKgEJL0Ub8ZWN6C/xE+U6U=;
        b=SDponCt4iCqvCfanCAa+3pMV+vTOM+mT//ho9jt22D8PbBsbH2TJbTcKnPOBjtwXoZ
         SQGfpcE+gQXFzNGbuAmAiUIxrWnTfyp79v9RE+eyo4jV4iEqo5Rzj6koUCpF2IQ8lEGG
         y96wsJ90XGooCKj5qCos/vO8fxQnHFE8YVifk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9XYlLQFnWWwdu63sAOZZGoKgEJL0Ub8ZWN6C/xE+U6U=;
        b=fJGLtEVPYRy69cFfpbi5o4g8xGDJr+2IgwOg3jeqJn/rAUpNk/g9591MZ+IrF907GH
         SwQbjtMPSCacHzb3+i7qUS5CZA/odB/dbCSAYs4WV1d1MErCMX8ghBMV8Chu6ZeVlq6S
         ZPNgvWsbc0kYTa1drlxEjfsdHjQBaitWJtaf1DILjmUAjBAEeanE/BLOVtsB89suCr6k
         36VPy0PPg/EUW0mvkf7xJP4iExTx661KNCH/N3rMiIHWq2Llh0/Msbuaj0An6eDZ+Uyv
         09a+pTzeRXEYy0+OR066BNVt4rian8w+hx3hpyzyjE5hWWEEtcsmxHuhieb4oAhMuPAc
         Kfvw==
X-Gm-Message-State: AGi0PuYpEFO7BtlBMUg+osPFtXPdcPJqjSeAHHMl+5vQzSxewSSze6WI
	hO1envBvFFLC6S5GdN7GppXg1g==
X-Google-Smtp-Source: APiQypL0jJAGP0KYiq4xc4nfkEj6Ve2H6MRdFYIgYzUTD/bPjtmfpTZVeXWK4n9dyWmezbWFwHJWVQ==
X-Received: by 2002:a63:9143:: with SMTP id l64mr388752pge.75.1586197538998;
        Mon, 06 Apr 2020 11:25:38 -0700 (PDT)
Date: Mon, 6 Apr 2020 11:25:37 -0700
From: Kees Cook <keescook@chromium.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Jann Horn <jannh@google.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 12/12] efi/libstub: disable SCS
Message-ID: <202004061125.A4C4EB70@keescook>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200406164121.154322-1-samitolvanen@google.com>
 <20200406164121.154322-13-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200406164121.154322-13-samitolvanen@google.com>

On Mon, Apr 06, 2020 at 09:41:21AM -0700, Sami Tolvanen wrote:
> Shadow stacks are not available in the EFI stub, filter out SCS flags.
> 
> Suggested-by: James Morse <james.morse@arm.com>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

> ---
>  drivers/firmware/efi/libstub/Makefile | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
> index 094eabdecfe6..fa0bb64f93d6 100644
> --- a/drivers/firmware/efi/libstub/Makefile
> +++ b/drivers/firmware/efi/libstub/Makefile
> @@ -32,6 +32,9 @@ KBUILD_CFLAGS			:= $(cflags-y) -DDISABLE_BRANCH_PROFILING \
>  				   $(call cc-option,-fno-stack-protector) \
>  				   -D__DISABLE_EXPORTS
>  
> +#  remove SCS flags from all objects in this directory

nit: double space

-Kees

> +KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_SCS), $(KBUILD_CFLAGS))
> +
>  GCOV_PROFILE			:= n
>  KASAN_SANITIZE			:= n
>  UBSAN_SANITIZE			:= n
> -- 
> 2.26.0.292.g33ef6b2f38-goog
> 

-- 
Kees Cook
