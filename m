Return-Path: <SRS0=Z7Yi=YZ=lists.openwall.com=kernel-hardening-return-17223-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EE51CA9EC9
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 04:01:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6B2CB2085B
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 04:01:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="A00p0LVj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6B2CB2085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17223-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 6074 invoked by uid 550); 1 Nov 2019 04:01:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 6054 invoked from network); 1 Nov 2019 04:01:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0eLf5qXAn9yR1tTlhAmZ2Kyb0+x5CBMrOVTM9Du04Q8=;
        b=A00p0LVjeslqYiGa9TTMJecCqjqU7CuF+R+GJN9ZwqNA5P/P216qCVQztow4VmlEnX
         tXLnkW6Xadee2MXfzJDDN/6VDJN5Hvg7PpCaYjXDQRr3aQ7tgxO8Gz8ZM85B1pEViloJ
         seuhFXQr7ONKb9UEjQKAiqbFkyir6kSgsYGMk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0eLf5qXAn9yR1tTlhAmZ2Kyb0+x5CBMrOVTM9Du04Q8=;
        b=A9QvpGDkn+tyCmEDy2g3JlnnGtug4o+37pR/p40twBOQiUfqhBhyv0YBO4J3JSoxC8
         VzSDrmlvAieekN4i0obIyX25IhcVwYkRAxlig7rWyTgLuE3A/sd2vu7adbTzfrcapWlN
         Zptohm5InlVWQLp6hZFWgb7YNeDfI8Oh/sDPPV3gViPJefhDRXwSGaocqN9PXYc9idBK
         hbs+LYQaRozCj37pfi/Y2W6+eYXkEm+x6NjNhctwWhvS5gjJ+dZhQNIL1OsMuFi+ctVJ
         QWgXUKk5KwFP0xB573yTzv1BoPa2OMeRnHxD/G2DaW8zKwCjN1o3VS5ET02VvmTGtOV4
         o7AQ==
X-Gm-Message-State: APjAAAU7ApLPASWfDRXOgDfxu2MleYYICn0qAG63dHUv3/vOH3Zzx8G9
	sIExcuThc05ceuC589+0HsGP0Q==
X-Google-Smtp-Source: APXvYqwGmV0Y740oqbS4ugktxZHKaSCLqRcPnlrVthpsiltg8oKVKBEvzW9AoxDE8RXSX8ETUSyBWw==
X-Received: by 2002:a63:5422:: with SMTP id i34mr11142718pgb.142.1572580892713;
        Thu, 31 Oct 2019 21:01:32 -0700 (PDT)
Date: Thu, 31 Oct 2019 21:01:30 -0700
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
Subject: Re: [PATCH v3 15/17] arm64: vdso: disable Shadow Call Stack
Message-ID: <201910312101.4F2048D9@keescook>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191031164637.48901-1-samitolvanen@google.com>
 <20191031164637.48901-16-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191031164637.48901-16-samitolvanen@google.com>

On Thu, Oct 31, 2019 at 09:46:35AM -0700, samitolvanen@google.com wrote:
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

I think Nick already mentioned the missing commit log. With that:

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  arch/arm64/kernel/vdso/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kernel/vdso/Makefile b/arch/arm64/kernel/vdso/Makefile
> index dd2514bb1511..a87a4f11724e 100644
> --- a/arch/arm64/kernel/vdso/Makefile
> +++ b/arch/arm64/kernel/vdso/Makefile
> @@ -25,7 +25,7 @@ ccflags-y += -DDISABLE_BRANCH_PROFILING
>  
>  VDSO_LDFLAGS := -Bsymbolic
>  
> -CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE) -Os
> +CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE) -Os $(CC_FLAGS_SCS)
>  KBUILD_CFLAGS			+= $(DISABLE_LTO)
>  KASAN_SANITIZE			:= n
>  UBSAN_SANITIZE			:= n
> -- 
> 2.24.0.rc0.303.g954a862665-goog
> 

-- 
Kees Cook
