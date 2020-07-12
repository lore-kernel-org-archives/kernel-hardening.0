Return-Path: <SRS0=dALg=AX=lists.openwall.com=kernel-hardening-return-19288-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64A3FC433E0
	for <kernel-hardening@archiver.kernel.org>; Sun, 12 Jul 2020 09:26:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AE4B320720
	for <kernel-hardening@archiver.kernel.org>; Sun, 12 Jul 2020 09:26:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="et8c4srf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE4B320720
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19288-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27718 invoked by uid 550); 12 Jul 2020 09:26:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18413 invoked from network); 12 Jul 2020 08:59:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=+Dl8Q1XzZiYA4GO8ZZtoY/mYTNvNLG4yL/TSgXjOVXM=;
        b=et8c4srf7jKz/ghq6ldgJw1wpsajAh/iicKsgGLSk5HCxGZ5CQ86IFUST3G/dAZS9R
         BK+JEehQthnnir07FeiPcL/qpVUZ2NGCyUjND9byzvK8PnixOnaWkF96m/M5kUymOL2C
         LII6vqDG01OkywVTUDEiMrt1QcYjd+y6es/0VA01BLEP3VrfKh/wxRZhab4S/+5xDWOB
         xe88vsXrHJ2oYLtwubG993g1CAsa5aM8/V0M7++JN1XNtMqDZiEmh7FXGrho8fAIGKiT
         KJW0LpTSPQuedYjKrMO8KvYmRECOyDbXavBRUCJEaU4kO1PGAriZ+FRdd/Me8DIzlfab
         p9uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=+Dl8Q1XzZiYA4GO8ZZtoY/mYTNvNLG4yL/TSgXjOVXM=;
        b=iW19X+si0LVL/+YOoa3uymCJIa8hj7g+U1o7yNhaZwCVZUm9isAFmeXuZ1lzvFeiEW
         Ll7WF2ZfryIUjmsmzXJU0SIstPkcpre5nDSe4cjF0bLqfOAhk6GGga9VEEk4n4lr8BXj
         7bENdyHgc+M3KnS9AnAGXPt1dQ6VyWz09P00LQ/CxPnDk/5kxJt9Z0A3enp3fO/iw8nZ
         9ffvw6Rz31S99pbkSoZcUzEbwHdBNuc+HgWfOagUy3tR1Lbt5ExlecxVglEtQH4fzXYS
         Fop/Dd3h1tjJJaXxDY5UVgFAi5oiPy1cCz87bSyeW91vnPcWbI15S66dXMmGTxKD0PtX
         GsuA==
X-Gm-Message-State: AOAM533GlGJMpkK3Ip4CxvKd1PENRdGDYebSBq1/Y59joxBtvuRdHEy6
	mbrkEhCS6N5pzEPV9klzbMQJzvMYydSKFE/Tl0I=
X-Google-Smtp-Source: ABdhPJz6yajbht8v21aUb5AqbeseJZbW7WiEMt9+Xzj6unIHhgR9p8E/p5dg9MyRRh3U33wQNCR5IYqWyZHeGZXnsKY=
X-Received: by 2002:a05:6602:1555:: with SMTP id h21mr6773338iow.163.1594544369052;
 Sun, 12 Jul 2020 01:59:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com> <671d8923-ed43-4600-2628-33ae7cb82ccb@molgen.mpg.de>
In-Reply-To: <671d8923-ed43-4600-2628-33ae7cb82ccb@molgen.mpg.de>
From: Sedat Dilek <sedat.dilek@gmail.com>
Date: Sun, 12 Jul 2020 10:59:17 +0200
Message-ID: <CA+icZUXPB_C1bjA13zi3OLFCpiZh+GsgHT0y6kumzVRavs4LkQ@mail.gmail.com>
Subject: Re: [PATCH 00/22] add support for Clang LTO
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Sami Tolvanen <samitolvanen@google.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Will Deacon <will@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, 
	Clang-Built-Linux ML <clang-built-linux@googlegroups.com>, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 11, 2020 at 6:32 PM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
>
> Dear Sami,
>
>
> Am 24.06.20 um 22:31 schrieb Sami Tolvanen:
> > This patch series adds support for building x86_64 and arm64 kernels
> > with Clang's Link Time Optimization (LTO).
> >
> > In addition to performance, the primary motivation for LTO is to allow
> > Clang's Control-Flow Integrity (CFI) to be used in the kernel. Google's
> > Pixel devices have shipped with LTO+CFI kernels since 2018.
> >
> > Most of the patches are build system changes for handling LLVM bitcode,
> > which Clang produces with LTO instead of ELF object files, postponing
> > ELF processing until a later stage, and ensuring initcall ordering.
> >
> > Note that first objtool patch in the series is already in linux-next,
> > but as it's needed with LTO, I'm including it also here to make testing
> > easier.
>
> [=E2=80=A6]
>
> Thank you very much for sending these changes.
>
> Do you have a branch, where your current work can be pulled from? Your
> branch on GitHub [1] seems 15 months old.
>

Agreed it's easier to git-pull.
I have seen [1] - not sure if this is the latest version.
Alternatively, you can check patchwork LKML by searching for $submitter.
( You can open patch 01/22 and download the whole patch-series by
following the link "series", see [3]. )

- Sedat -

[1] https://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild.=
git/log/?h=3Dlto
[2] https://lore.kernel.org/patchwork/project/lkml/list/?series=3D&submitte=
r=3D19676
[3] https://lore.kernel.org/patchwork/series/450026/mbox/
