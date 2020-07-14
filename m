Return-Path: <SRS0=+gRO=AZ=lists.openwall.com=kernel-hardening-return-19306-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26E6DC433E4
	for <kernel-hardening@archiver.kernel.org>; Tue, 14 Jul 2020 12:36:27 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 679A722472
	for <kernel-hardening@archiver.kernel.org>; Tue, 14 Jul 2020 12:36:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="exjA6lvA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 679A722472
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19306-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 31892 invoked by uid 550); 14 Jul 2020 12:36:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 31858 invoked from network); 14 Jul 2020 12:36:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=Gb+Q70LB3bQ72JL0eSnIdekJKUYUeTWGONZ+6Nqwogo=;
        b=exjA6lvAWxUvf1Td2gq98AcVXUNkO3OPeywwuYDfsL+Z0YPJPbs2u85bRho4FdyAYG
         h1Me90Y/Xi9mrbBb8IaCwjCCtYe0iU8Kdh8gvx4lPvw3ww0BSuQCAaIggiGzNrJ/rvTH
         NUMDgXk2hTiz164UVDp0X/EMe5UZSZk9rzOG8RZLS92wGG7i2sWIFctBkIViYipOQgok
         xcfHbLR2UQt/A0WzfMGMQVUKm26Utu92kngSJt91ObuRmBmWkKww8U1+XQaxchUIoULg
         LETQQruiS74VAz/QrOz41g7p3HeSVdiEqjGWDHkLxWa7roAfEPM+hfKFIBuOgsfaV0cy
         L0ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=Gb+Q70LB3bQ72JL0eSnIdekJKUYUeTWGONZ+6Nqwogo=;
        b=lUfNF5uDmvIF3HqrcKHbU4bZBT3i7yi4BDvAT5dMaI4cViJme9tKX16M3hUHJw8DAT
         blRtCF7+Zst48qh0Eyl+4fXw099sds3gjktEpcaMSf1ojCmWSyRtDPj2UIvtc9vLPGib
         P0RcHi95QC48+hVR+AxFLj8IV31d37xiwYCBcSHnnveJZZMbDtHON8ARoXc3xi3XbDAd
         61nQDXkCUCefAJZ5Z+OOmo9zrnS5/mV3Xvp5cq1b/IzFMkaBcvhsdqc1jMJDaGo4vS2Y
         C8zgr6bzzQtL+rQgSQSn+nYScgvEHXoaszWo6tSgx/W/QuCuHg4o4m3xqhUY8VaovWdN
         1YEA==
X-Gm-Message-State: AOAM531mCRz9WAhYKgJuNmNzHWPinEs2kIqxrQ4c6Fx5CRYCRNSNBOtu
	3bqDtuiG00LS/XA5dmBdokCqCARQkEgeW7qcxBM=
X-Google-Smtp-Source: ABdhPJy08S8ez9XwftwQn5CP8eSR816kqqnMmTFnXtvq9GDL8Kyd4FJY0vpVR/06YozpswqRqTbLAb4BcgAV34vv4aM=
X-Received: by 2002:a5e:9309:: with SMTP id k9mr4608670iom.135.1594730166218;
 Tue, 14 Jul 2020 05:36:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com>
 <671d8923-ed43-4600-2628-33ae7cb82ccb@molgen.mpg.de> <CABCJKuedpxAqndgL=jHT22KtjnLkb1dsYaM6hQYyhqrWjkEe6A@mail.gmail.com>
 <2ac9e722-949b-aa92-3553-df1bf69bf9e5@molgen.mpg.de>
In-Reply-To: <2ac9e722-949b-aa92-3553-df1bf69bf9e5@molgen.mpg.de>
From: Sedat Dilek <sedat.dilek@gmail.com>
Date: Tue, 14 Jul 2020 14:35:52 +0200
Message-ID: <CA+icZUXwLocrBNRL+1-koCW50Fm+f4_u3xzy-_eJSxyoW2VTfw@mail.gmail.com>
Subject: Re: [PATCH 00/22] add support for Clang LTO
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Sami Tolvanen <samitolvanen@google.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Will Deacon <will@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, 
	Clang-Built-Linux ML <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, 
	linux-kbuild <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-pci@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Jul 14, 2020 at 2:16 PM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
>
> Dear Sami,
>
>
> Am 13.07.20 um 01:34 schrieb Sami Tolvanen:
> > On Sat, Jul 11, 2020 at 9:32 AM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
> >> Thank you very much for sending these changes.
> >>
> >> Do you have a branch, where your current work can be pulled from? Your
> >> branch on GitHub [1] seems 15 months old.
> >
> > The clang-lto branch is rebased regularly on top of Linus' tree.
> > GitHub just looks at the commit date of the last commit in the tree,
> > which isn't all that informative.
>
> Thank you for clearing this up, and sorry for not checking myself.
>
> >> Out of curiosity, I applied the changes, allowed the selection for i386
> >> (x86), and with Clang 1:11~++20200701093119+ffee8040534-1~exp1 from
> >> Debian experimental, it failed with `Invalid absolute R_386_32
> >> relocation: KERNEL_PAGES`:
> >
> > I haven't looked at getting this to work on i386, which is why we only
> > select ARCH_SUPPORTS_LTO for x86_64. I would expect there to be a few
> > issues to address.
> >
> >>>    arch/x86/tools/relocs vmlinux > arch/x86/boot/compressed/vmlinux.relocs;arch/x86/tools/relocs --abs-relocs vmlinux
> >>> Invalid absolute R_386_32 relocation: KERNEL_PAGES
> >
> > KERNEL_PAGES looks like a constant, so it's probably safe to ignore
> > the absolute relocation in tools/relocs.c.
>
> Thank you for pointing me to the right direction. I am happy to report,
> that with the diff below (no idea to what list to add the string), Linux
> 5.8-rc5 with the LLVM/Clang/LTO patches on top, builds and boots on the
> ASRock E350M1.
>
> ```
> diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
> index 8f3bf34840cef..e91af127ed3c0 100644
> --- a/arch/x86/tools/relocs.c
> +++ b/arch/x86/tools/relocs.c
> @@ -79,6 +79,7 @@ static const char * const
> sym_regex_kernel[S_NSYMTYPES] = {
>          "__end_rodata_hpage_align|"
>   #endif
>          "__vvar_page|"
> +       "KERNEL_PAGES|"
>          "_end)$"
>   };
> ```
>

What llvm-toolchain and version did you use?

Can you post your linux-config?

Thanks.

- Sedat -
