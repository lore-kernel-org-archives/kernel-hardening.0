Return-Path: <SRS0=ha3Z=YY=lists.openwall.com=kernel-hardening-return-17203-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48FAECA9ECB
	for <kernel-hardening@archiver.kernel.org>; Thu, 31 Oct 2019 17:11:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8F3B72053B
	for <kernel-hardening@archiver.kernel.org>; Thu, 31 Oct 2019 17:11:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Jy/SacxJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8F3B72053B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17203-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26182 invoked by uid 550); 31 Oct 2019 17:11:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26160 invoked from network); 31 Oct 2019 17:11:39 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b0X5YfN75r7PDdNJxvGQlnZAXFwdwuMLiQ3l0U13bDg=;
        b=Jy/SacxJhf/Nbsx+JKEbMsxTmi9nTvRx9QrYmlIIdjaRaYWNvdZdUveUzeL7wIBsMZ
         yB8Nz5UMhco8wy0o9k2IWrgIZlOKbDsMBdp3atJjR2eE50+zYjEZBM7mTKuaEMqSUi91
         ueCuaeZ6gpnfO9SKoIhfR/pmAwffakughLyHWB5/OC9EGvGmL4MkTswLiMaKPF11fEWK
         w0yeyTRVppcLDoCs0H8aL/rz2ddY3Gr0oQA89wXCPpwffH+YyILuj3R30CX+hlyoHfZ7
         WFIUgANql15NGTPB5eu58+Vz5mden9xZ/hmIuvN0j6C6tSpO51yEvLSx5eUFDkhOQhtj
         fI9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b0X5YfN75r7PDdNJxvGQlnZAXFwdwuMLiQ3l0U13bDg=;
        b=pFmN+vLyY/bZ8VIAu/4WuEE3K5wpuJt9NvPhm8B1DxQFhvac2k+0oHf27sn+bx8MAq
         S6dolYrV2AsGCMpPMf3GyO3+iaEBGIFSgLWsdwXGUiNP7i0SQM46dqUcxY3ko+xvZZOI
         YrCkHEFJWVrsEsRtsg01x1s2iyYk1Ku0IAgrDFowhcEaL50SdUMGU3gN5fvopwoHsU2P
         jHrY5uN1T91ZBrbI17xfNTUShouSrW7CTP8WqfyppzHAJxVryHT4q4/wLS3eb5srrvU7
         DeOgTuXa/YVAz4ZGj9cf/xh7LQZ/VtSnW8LFgKT79flnj6+PAY7OrNKCiaHKPxMq2Rjy
         xXEg==
X-Gm-Message-State: APjAAAUwBlK1N1QdlW5/9qXhDkcf2ioDHLrgAWBevDULsn3vUQGjK3Y1
	EolWcoFg2FE+VAyuoka4Cw9GYigrOQY34W3gwVx3QA==
X-Google-Smtp-Source: APXvYqyggyEISFvRqnEZ0+/A7Iby9Fs7Q+2KDnPlM3xak8otQQ4zH05zLjAp9ajmSpT131omcbyYgDm2ydz5aTw6/As=
X-Received: by 2002:a17:902:b40f:: with SMTP id x15mr3965837plr.119.1572541887443;
 Thu, 31 Oct 2019 10:11:27 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191031164637.48901-1-samitolvanen@google.com> <20191031164637.48901-13-samitolvanen@google.com>
In-Reply-To: <20191031164637.48901-13-samitolvanen@google.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Thu, 31 Oct 2019 10:11:16 -0700
Message-ID: <CAKwvOdmBcHuhZZV54-76zY60F0Tvd_0DGCi+5dzFTxk0upOYrQ@mail.gmail.com>
Subject: Re: [PATCH v3 12/17] arm64: reserve x18 from general allocation with SCS
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
>
> Reserve the x18 register from general allocation when SCS is enabled,
> because the compiler uses the register to store the current task's
> shadow stack pointer. Note that all external kernel modules must also be
> compiled with -ffixed-x18 if the kernel has SCS enabled.

Inline/out-of-line assembly will also need to be careful not to
accidentally overwrite the current task's shadow stack pointer.

Without automated checking for that, we'll have to rely on a
"gentlemen's promise" for code reviewers, though we'd likely hit such
a regression with Android+mainline.

Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> ---
>  arch/arm64/Makefile | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
> index 2c0238ce0551..ef76101201b2 100644
> --- a/arch/arm64/Makefile
> +++ b/arch/arm64/Makefile
> @@ -72,6 +72,10 @@ stack_protector_prepare: prepare0
>                                         include/generated/asm-offsets.h))
>  endif
>
> +ifeq ($(CONFIG_SHADOW_CALL_STACK), y)
> +KBUILD_CFLAGS  += -ffixed-x18
> +endif
> +
>  ifeq ($(CONFIG_CPU_BIG_ENDIAN), y)
>  KBUILD_CPPFLAGS        += -mbig-endian
>  CHECKFLAGS     += -D__AARCH64EB__
> --
> 2.24.0.rc0.303.g954a862665-goog
>


-- 
Thanks,
~Nick Desaulniers
