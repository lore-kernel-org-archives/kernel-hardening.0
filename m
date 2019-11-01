Return-Path: <SRS0=2eWq=YZ=lists.openwall.com=kernel-hardening-return-17221-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 043B4CA9EC9
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 04:00:19 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 487BC2083E
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 04:00:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="SoIAx/f+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 487BC2083E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17221-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3497 invoked by uid 550); 1 Nov 2019 04:00:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3474 invoked from network); 1 Nov 2019 04:00:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=A7vrO+MQB63nPz6FPwTRdUgznbxQobdODcdehGRotvI=;
        b=SoIAx/f+o5ObJpWgtzqlvIdoi9BrVBtR0sORn7UXLhxKD40+Hq5g8o71ljOsCw58Xu
         nV5Xy/0YwVtNd7g4N0HQfZNFqvK0+sr9AAyTxnNs4Qwhx3+vEE4Ynyv8Aid4jjjCxSzD
         BwrcVTfNY0xZuV8VaybEOQY3+plZAuUInWL9I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=A7vrO+MQB63nPz6FPwTRdUgznbxQobdODcdehGRotvI=;
        b=Pk5hU0QuWkFgYcxl7YN3gpAhELc6m0jCpH/F0m+82jGe/9liV5LRlL/v4RhaFhjXxW
         JSxHRJRQYiBxF3zzBzjFIBY276xuGKR0bauDCMOGR8g5Y6ABtjgBdSXWpSDVlf9AAhLZ
         DUmc+2ESUqv/8rmzfwtmXbSvuOdG0TgeLAm5PwClvDDY0r6EFTaNbejcYq65BTJO7cl6
         nwK6yEjXI3zRc65uoOiPazQP1ttat/QfjVy32DCvJpgMnCX+BUfaTrNlyLJyjTiGbY6a
         /oLq3zuKhg96r89gz1HrLaCbVkyNjJ1MDn0CCaPvmd/kgCFJ700c8X/2JUTKPk+L2+WA
         rXSA==
X-Gm-Message-State: APjAAAXs63u7xIn8v4aijOlxLA4fTbUzxwlUPvu+lcxDRwiQD/8c3eM1
	iZsGXYzAw9ksUYJ9nyy7ovP8Mw==
X-Google-Smtp-Source: APXvYqxYKGSK6I8b7hoUIAqJTB3Ku0XRihpPu4nBcAxKCNBJscoqFmYbPUJv9aMkupfl7+/RJ59IiA==
X-Received: by 2002:a63:611:: with SMTP id 17mr10933319pgg.191.1572580800014;
        Thu, 31 Oct 2019 21:00:00 -0700 (PDT)
Date: Thu, 31 Oct 2019 20:59:58 -0700
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
Subject: Re: [PATCH v3 12/17] arm64: reserve x18 from general allocation with
 SCS
Message-ID: <201910312059.C43A11D@keescook>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191031164637.48901-1-samitolvanen@google.com>
 <20191031164637.48901-13-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191031164637.48901-13-samitolvanen@google.com>

On Thu, Oct 31, 2019 at 09:46:32AM -0700, samitolvanen@google.com wrote:
> Reserve the x18 register from general allocation when SCS is enabled,
> because the compiler uses the register to store the current task's
> shadow stack pointer. Note that all external kernel modules must also be
> compiled with -ffixed-x18 if the kernel has SCS enabled.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  arch/arm64/Makefile | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
> index 2c0238ce0551..ef76101201b2 100644
> --- a/arch/arm64/Makefile
> +++ b/arch/arm64/Makefile
> @@ -72,6 +72,10 @@ stack_protector_prepare: prepare0
>  					include/generated/asm-offsets.h))
>  endif
>  
> +ifeq ($(CONFIG_SHADOW_CALL_STACK), y)
> +KBUILD_CFLAGS	+= -ffixed-x18
> +endif
> +
>  ifeq ($(CONFIG_CPU_BIG_ENDIAN), y)
>  KBUILD_CPPFLAGS	+= -mbig-endian
>  CHECKFLAGS	+= -D__AARCH64EB__
> -- 
> 2.24.0.rc0.303.g954a862665-goog
> 

-- 
Kees Cook
