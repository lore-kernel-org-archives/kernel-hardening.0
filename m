Return-Path: <SRS0=LXz3=AF=lists.openwall.com=kernel-hardening-return-19133-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4310CC433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 20:59:29 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 978902075A
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 20:59:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pd1+e0uX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 978902075A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19133-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7784 invoked by uid 550); 24 Jun 2020 20:59:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7751 invoked from network); 24 Jun 2020 20:59:22 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zWM/30Wl1IsQgoPaDiN0rPEEBtrHBKt/BJnnp0eLWds=;
        b=pd1+e0uXRIvGNNQgZ7G0+2YkwsDFhSclmocO1GbaT5UM3c6xBTX7UYJjCsai0aiyT7
         fIoijSJoU+eUl8voyiO0IOyBsavQt6eREqkk3whDlDlHejxDQRKECAFiVGUe/CKDHaTc
         EpZ2md8ULTkAVVBJ6O72PRwIcg/GiVClV1rha8JNSiYzT4/v2ecYsi++FLxwW19Hw/Gd
         Fr/Z+ikfp69sRAivcJnbajJT1/5/Qn2W6vWHskjofe5p2ZJr6Cthm+UKTVG2rZslsDkG
         xO7mHbrOSScz4BsI8HgHuMYhqH42CQPx5Ip80xrwiQdph3TwAg+m578XBSL3rfWRIGQZ
         ATEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zWM/30Wl1IsQgoPaDiN0rPEEBtrHBKt/BJnnp0eLWds=;
        b=JchTap1XavjBkGNvssT8oJ1zH539xwi20cYs3MNL0Ku99bx/gU9/bIjhsjuSDObZY6
         3SsUTQwAMVv2m/hBVxXk1Jpk89as/XGAYFQzilpRorBEyCsvIORWgPLGUt/kfiq6vgi9
         BZm9P8Dr3LQkmzRp6ddrxgkqHpJKyKBvLiX1tv8TyP0qSRm6pip1dmaJVk0k6x991xJD
         G2xkJ5I7nrv1o1yVTTYsLZ18COi6na+msITrPNbq/pbz4fGh6/YoYNoLAlMxbZKJ4COA
         R2sTohPa3/fzFinLtzY4Cjhls0lqan6Tjw2K002/pWF5oX0uQ4ZE5HZfoYCy7rcoPft+
         s7oA==
X-Gm-Message-State: AOAM530S8ibu6uhNSE4gczMu+HAozCL/xy/1n9yeYDYggZndbeVO45N0
	JmAP5tEu87C8s2sEs9EXV9yuiqPeU3AurvzVaE5U8w==
X-Google-Smtp-Source: ABdhPJxCHHL5VXpLPing5E72KwPslmx5t7evOEk09T9ji09mKT6bSRCDPTi/AxhdrzEhszh9gGm6vbYGZSEoMtti7/U=
X-Received: by 2002:a17:90a:21ef:: with SMTP id q102mr5252324pjc.101.1593032350091;
 Wed, 24 Jun 2020 13:59:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com> <20200624203200.78870-18-samitolvanen@google.com>
In-Reply-To: <20200624203200.78870-18-samitolvanen@google.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Wed, 24 Jun 2020 13:58:57 -0700
Message-ID: <CAKwvOdnEbCfYZ9o=OF51oswyqDvN4iP-9syWUDhxfueq4q0xcw@mail.gmail.com>
Subject: Re: [PATCH 17/22] arm64: vdso: disable LTO
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-pci@vger.kernel.org, 
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Jun 24, 2020 at 1:33 PM Sami Tolvanen <samitolvanen@google.com> wrote:
>
> Filter out CC_FLAGS_LTO for the vDSO.

Just curious about this patch (and the following one for x86's vdso),
do you happen to recall specifically what the issues with the vdso's
are?

>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> ---
>  arch/arm64/kernel/vdso/Makefile | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kernel/vdso/Makefile b/arch/arm64/kernel/vdso/Makefile
> index 556d424c6f52..cfad4c296ca1 100644
> --- a/arch/arm64/kernel/vdso/Makefile
> +++ b/arch/arm64/kernel/vdso/Makefile
> @@ -29,8 +29,8 @@ ldflags-y := -shared -nostdlib -soname=linux-vdso.so.1 --hash-style=sysv \
>  ccflags-y := -fno-common -fno-builtin -fno-stack-protector -ffixed-x18
>  ccflags-y += -DDISABLE_BRANCH_PROFILING
>
> -CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE) -Os $(CC_FLAGS_SCS)
> -KBUILD_CFLAGS                  += $(DISABLE_LTO)
> +CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE) -Os $(CC_FLAGS_SCS) \
> +                               $(CC_FLAGS_LTO)
>  KASAN_SANITIZE                 := n
>  UBSAN_SANITIZE                 := n
>  OBJECT_FILES_NON_STANDARD      := y
> --
> 2.27.0.212.ge8ba1cc988-goog
>


-- 
Thanks,
~Nick Desaulniers
