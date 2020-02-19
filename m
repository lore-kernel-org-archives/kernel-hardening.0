Return-Path: <SRS0=NmlK=4H=lists.openwall.com=kernel-hardening-return-17840-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61C3BC34031
	for <kernel-hardening@archiver.kernel.org>; Wed, 19 Feb 2020 00:59:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B2A6C2173E
	for <kernel-hardening@archiver.kernel.org>; Wed, 19 Feb 2020 00:59:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="IzhUosfr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B2A6C2173E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17840-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28573 invoked by uid 550); 19 Feb 2020 00:59:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28553 invoked from network); 19 Feb 2020 00:59:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gnHrGjs2d4rz7O5tZjdzLtL+/TxZSgxldIF3J/GkKZs=;
        b=IzhUosfrcEGWqNX3mEcMBIr1zOOchilV9ewuFD+HoG5ciFAxqXbB4J+beO2BpkVdd2
         SpEpavUmfa3Uu83TMZyvYqjzM1rYC38XzZ6PgxBVtweceDQ65TXzBQcjSOeXX0zJL559
         DAcpGs9S0QzkDBHDXRYSuTfPTPAw54Oj19kC8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gnHrGjs2d4rz7O5tZjdzLtL+/TxZSgxldIF3J/GkKZs=;
        b=ljQGxccsv27oAKyqLE/L95DGlqQvKEvDqyX23uqJxR/qTR+h7iQLX2RalJukw/IAXL
         5c7Yy1VT/KPrHLjHDVChaAMVvR1HyUZVIWtduBOMc1hzrCRScEDUbK+FNDtGPxxPqp/j
         XOrzl1oGDfIpAUUjH4D91x9e+edisKaYeiaasdL1wJETNxEu15r4tJnshxJ/Ncj67oD4
         6HSHLF985/kQzCcjcI/oV2eLnYxwvvNhh7cwyLGYdjw4NFDC28U3uEzE5AX1bDEBEwai
         twK0oU5ShrinAP0ACNeX7X6f0syp7Rd+K2XDapnBZIF/utazKti75JCpCv/yrb7Qnzla
         +UZg==
X-Gm-Message-State: APjAAAU3QT2D5v7saMz7FAsJJCej47cHEnprLIxzhkLNXeJWjD2pxsAB
	C6tGrfSMHxanfCbTCIfecAXBug==
X-Google-Smtp-Source: APXvYqyyUVqi0udPEq0kk+xXnOiXAZrDL6nmRuPiWdSBtQVB+Zr5mfeTFPLXXkm6NSzwKNuLtifp4A==
X-Received: by 2002:a17:902:7244:: with SMTP id c4mr21514780pll.49.1582073937923;
        Tue, 18 Feb 2020 16:58:57 -0800 (PST)
Date: Tue, 18 Feb 2020 16:58:56 -0800
From: Kees Cook <keescook@chromium.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Mark Rutland <mark.rutland@arm.com>, james.morse@arm.com,
	Dave Martin <Dave.Martin@arm.com>,
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Jann Horn <jannh@google.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 12/12] efi/libstub: disable SCS
Message-ID: <202002181658.45F66E21F@keescook>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200219000817.195049-1-samitolvanen@google.com>
 <20200219000817.195049-13-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219000817.195049-13-samitolvanen@google.com>

On Tue, Feb 18, 2020 at 04:08:17PM -0800, Sami Tolvanen wrote:
> Disable SCS for the EFI stub and allow x18 to be used.
> 
> Suggested-by: James Morse <james.morse@arm.com>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  drivers/firmware/efi/libstub/Makefile | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
> index 98a81576213d..dff9fa5a3f1c 100644
> --- a/drivers/firmware/efi/libstub/Makefile
> +++ b/drivers/firmware/efi/libstub/Makefile
> @@ -30,6 +30,9 @@ KBUILD_CFLAGS			:= $(cflags-y) -DDISABLE_BRANCH_PROFILING \
>  				   $(call cc-option,-fno-stack-protector) \
>  				   -D__DISABLE_EXPORTS
>  
> +#  remove SCS flags from all objects in this directory
> +KBUILD_CFLAGS := $(filter-out -ffixed-x18 $(CC_FLAGS_SCS), $(KBUILD_CFLAGS))
> +
>  GCOV_PROFILE			:= n
>  KASAN_SANITIZE			:= n
>  UBSAN_SANITIZE			:= n
> -- 
> 2.25.0.265.gbab2e86ba0-goog
> 

-- 
Kees Cook
