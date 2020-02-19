Return-Path: <SRS0=hZQB=4H=lists.openwall.com=kernel-hardening-return-17842-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E98B8C34022
	for <kernel-hardening@archiver.kernel.org>; Wed, 19 Feb 2020 07:41:19 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 468B2208E4
	for <kernel-hardening@archiver.kernel.org>; Wed, 19 Feb 2020 07:41:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kTNAFKeN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 468B2208E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17842-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5300 invoked by uid 550); 19 Feb 2020 07:41:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5280 invoked from network); 19 Feb 2020 07:41:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+GRLqrD8FueaUCHAoE5W7lTJg+Amhm25j14mDfWmjkA=;
        b=kTNAFKeNi58a6U94aPNyk90UBSKG8JCWjWNuMiUHZEtRSl6WJsZaJcDG0H0NH/MESj
         CjnehUs+Mw5wnTTjyRcxVTT8DDO3TYKY0i49PAel3wB79hMGCm8kP6wc5AXe7RhLv4MG
         +BJtU+G3G+qHz0vhZxG2POr56LNKq9ITudB6s0ZRvs8mXQa3vl+MuBIH+nb5viJeO9EE
         WuqgXiODR0hhXK6X737HDKvNJ93MQgCsXeD80gmkLYPXyPNM4g+yhccOAZXmHVgNNDt/
         S9dtWANw0xDedARfY27ZmjbXLcmfUtUmkx35qyMjHNcc57H5Bs3W8aBX9QwmS7EiVRsL
         6sIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+GRLqrD8FueaUCHAoE5W7lTJg+Amhm25j14mDfWmjkA=;
        b=toosm+KCpeG0KdrpUbCI0kmbxFrh6o4JGEf++Tsk7i/4JWXA/oN+0KB8YontVm9WPm
         4JVIBXIrLMlT2HqMxxbIhAHQrd/GnMmW67OAShDSyzUzthNW1dScAt7Rh4U1iBfxxkMq
         8FBaCBDVYpsbDdUa2t2oby5y+0j72pVhxvrncgfnvNGPnJaYlWJ668tMmYbwHZrmcCfP
         lhQoKaLfeDXcvSE/dTkK0+RyMxJj2TJVNI38pWjaChFFSH5MibRaIPIKRgIonuMp7z+V
         aPLmbO5sm/WWnUkm4FZAk/H5VYTAXdBjR1Am3GUFyvFMgdBd4nZhvduCNwLW1R+BhgTX
         lBcg==
X-Gm-Message-State: APjAAAVC6RYs/OwD/N+x2fA4uPL0G59UkJ/WB/AIc5zQ3Shg5/rIvAw2
	Mib+dVEX1GWBJJJzurGuiCB8kEsAT6ECiYOP+fqrGw==
X-Google-Smtp-Source: APXvYqwCy2jqrGLYe7fHN/XM0e6FNRRUyJj1Go/h3HngUYGMwgnjHkeOth6L5p2FLRI+tlLg9m6uzOIAHQ0dkTFKCQ4=
X-Received: by 2002:a5d:5188:: with SMTP id k8mr34117209wrv.151.1582098060684;
 Tue, 18 Feb 2020 23:41:00 -0800 (PST)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200219000817.195049-1-samitolvanen@google.com> <20200219000817.195049-13-samitolvanen@google.com>
In-Reply-To: <20200219000817.195049-13-samitolvanen@google.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 19 Feb 2020 08:40:47 +0100
Message-ID: <CAKv+Gu9HpKBO-r+Ker47sPxvHBWLa6NAHe4P71x=K4Wiy2ybwQ@mail.gmail.com>
Subject: Re: [PATCH v8 12/12] efi/libstub: disable SCS
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, 
	Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 19 Feb 2020 at 01:09, Sami Tolvanen <samitolvanen@google.com> wrote:
>
> Disable SCS for the EFI stub and allow x18 to be used.
>
> Suggested-by: James Morse <james.morse@arm.com>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> ---
>  drivers/firmware/efi/libstub/Makefile | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
> index 98a81576213d..dff9fa5a3f1c 100644
> --- a/drivers/firmware/efi/libstub/Makefile
> +++ b/drivers/firmware/efi/libstub/Makefile
> @@ -30,6 +30,9 @@ KBUILD_CFLAGS                 := $(cflags-y) -DDISABLE_BRANCH_PROFILING \
>                                    $(call cc-option,-fno-stack-protector) \
>                                    -D__DISABLE_EXPORTS
>
> +#  remove SCS flags from all objects in this directory
> +KBUILD_CFLAGS := $(filter-out -ffixed-x18 $(CC_FLAGS_SCS), $(KBUILD_CFLAGS))
> +

I don't see why you'd need to remove -ffixed-x18 again here. Not using
x18 anywhere in the kernel is a much more maintainable approach.

In fact, now that I think of it, the EFI AArch64 platform binding
forbids the use of x18, so it would be better to add the -ffixed-x18
unconditionally for arm64 (even though the reason it forbids it is to
ensure compatibility with an OS using it as a platform register, and
so nothing is actually broken atm).

>  GCOV_PROFILE                   := n
>  KASAN_SANITIZE                 := n
>  UBSAN_SANITIZE                 := n
> --
> 2.25.0.265.gbab2e86ba0-goog
>
