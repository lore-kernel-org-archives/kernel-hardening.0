Return-Path: <SRS0=OO6w=YY=lists.openwall.com=kernel-hardening-return-17206-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 104A6CA9ECB
	for <kernel-hardening@archiver.kernel.org>; Thu, 31 Oct 2019 17:29:14 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5CB80208C0
	for <kernel-hardening@archiver.kernel.org>; Thu, 31 Oct 2019 17:29:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gpOK87CJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5CB80208C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17206-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9634 invoked by uid 550); 31 Oct 2019 17:29:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9611 invoked from network); 31 Oct 2019 17:29:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6m++fSIeBZqcJkeOt8/Shjtnuo+Q7rdlGD1c3YsGie4=;
        b=gpOK87CJRb754Y2+vKxaKrfCJA4dCHJjEnrqUCTDyVh8ydN+OuHauU0RzeuaqcPPqz
         8NeU4ITnb3rEWRmC3gSLVjVWnVesKGM1oyS/yh1NVuxjprhNF47oEx8mkDlnMjX5UGW5
         JiROU1AiJ8h+8ySX34AX4ACrznfiflDYVAMZM4a1Ar3B/7Tg5JN2SEMWHv3bPcn4f9qv
         R2QTmF9UEBbN86wcvkIxoBSkI67Kwa+sSYeRuJikIaYcxF+xfeewIHa6mGB7ZX5LMek1
         44Q7BbPEQbga/h7AhHpE5nwsTjoLhikG9VeHjhjiil8JtMG8WHEWP49lOfvP4ttwUXFY
         /yWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6m++fSIeBZqcJkeOt8/Shjtnuo+Q7rdlGD1c3YsGie4=;
        b=id0QT2QrLbcaiTKQtNaRd7GhERS8ONhGiINiNKKUHdCCHAp87eicxjLDjDGw2dZ6Tu
         ROiBa1RXVfVmW1+NeUkt8bSLLsLG7Wrgw/ZGqLCCf/UMkZbzM0HgCklvQn1O7T4ZYsvS
         RHQW1tA93puXVckKotRP08yKbID9g0i1cdx8JlncyN8A2F1eDOvA5ZmjSrU43k0wj1qo
         KE/+MDGbJBOSQsN17eSCIc3Y5bO1HFfaHcJODLJZgMdoETfbc++E+n8zwPLlc6P5vx1b
         1BpTM9cU+dnFEzvUm87nfUd/qStJRfPVvRT7qrhmTfALTQlCb2jIc4AR3hYOygPoS6H7
         abGw==
X-Gm-Message-State: APjAAAU8W9CnI8fVEWPL6qyPTw50HS3P+Hv+9uPEMBLmrONVJPan7m5z
	amNCFj1mDzhIdlAjRDMSzbJ4x53o5v/ma0Ug1+CIQA==
X-Google-Smtp-Source: APXvYqz/zaeuQgN6H9iXB6EC1IiRwlJeGkd2Ujt7JrblzBduB3a+f7TFswdMNV3RtEu438byzq5VFDkdG5vZyTUTeko=
X-Received: by 2002:a17:902:9b83:: with SMTP id y3mr7530087plp.179.1572542935004;
 Thu, 31 Oct 2019 10:28:55 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191031164637.48901-1-samitolvanen@google.com> <20191031164637.48901-16-samitolvanen@google.com>
In-Reply-To: <20191031164637.48901-16-samitolvanen@google.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Thu, 31 Oct 2019 10:28:43 -0700
Message-ID: <CAKwvOdkAe9TeB-dVqrDT7ZRQG8U4nHkkHwiDcRRPPY8w-Q9wQQ@mail.gmail.com>
Subject: Re: [PATCH v3 15/17] arm64: vdso: disable Shadow Call Stack
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Martin <Dave.Martin@arm.com>, 
	Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, 
	Mark Rutland <mark.rutland@arm.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 31, 2019 at 9:47 AM <samitolvanen@google.com> wrote:

I've gotten slapped down before for -ENOCOMMITMSG; maybe include more
info if there's a v4?  Maintainers can take the safe position of
always saying "no," so it is useful to always provide an answer to the
implicit question, "why should I take this patch?"

>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
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

Looks like vgettimeofday is the only remaining source written in C, so
we shouldn't need to strip it from other assembly source files.
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

>  KBUILD_CFLAGS                  += $(DISABLE_LTO)
>  KASAN_SANITIZE                 := n
>  UBSAN_SANITIZE                 := n
> --
> 2.24.0.rc0.303.g954a862665-goog
>


-- 
Thanks,
~Nick Desaulniers
