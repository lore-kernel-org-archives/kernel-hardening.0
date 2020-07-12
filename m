Return-Path: <SRS0=icfd=AX=lists.openwall.com=kernel-hardening-return-19289-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEC7BC433DF
	for <kernel-hardening@archiver.kernel.org>; Sun, 12 Jul 2020 19:01:31 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 014F6206F0
	for <kernel-hardening@archiver.kernel.org>; Sun, 12 Jul 2020 19:01:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N0HHcMjV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 014F6206F0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19289-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7367 invoked by uid 550); 12 Jul 2020 19:01:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1329 invoked from network); 12 Jul 2020 18:40:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=5TJ+34sQAVUrawBXByyfuwrbgj6i1cli/YCTjxtCBqw=;
        b=N0HHcMjVGeZLZKs6kySBi/kLjx//vGsHRhAgAn70NbsmCWAMm2ggej1XEym1TkTrI2
         1RaGmxT5o0gLydjCDJGV76FDHQsG0/MeBmIbxTv5DSaT3TULK/IfbYlfepfNEkiMQmk9
         pMxE7Rt2/EFgEH7Quq7GvESDdpvWY+RbR8tRKc/SElrWfewWr1bDfzmOZAel5bastYU4
         l+o96BGwta1qZ7PRMbDolq2P/ebYU/wwwO2jQcK/mwQ0tlDCRPQ2vZa/eEBWU7Y6nUZT
         K+Ku0Xl1nF8NMzl71Sss8yD4qs25ojddZtL3UAw9gfH97kt9dPHm6QwrFWkINM8fPBxh
         i8Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=5TJ+34sQAVUrawBXByyfuwrbgj6i1cli/YCTjxtCBqw=;
        b=dq6Cw2mfMU7QyF/UgRORwIzpm7rgf/MqX8cAhIj0gU+oxat53GeauuhxqtBARRlNqh
         X0Qd5F41GkML0dzUcvpLqRwsaw2sCWhsFIk1r0N+pE5U2fkWBxF/0d3qYZLE5JHJGlVU
         3bC+nK82WF4ekMuhkQ7IFDEyPHhFXq8kOaCqYvOerYCn0cxDXaUqymLwRXb44KQ46W4Z
         X9mmRCi3fzBcdTjskQwCFGxxs7VMLA6mDx3NFJczy/ddsA1Db6dv3bnSwRlSiIcG4LEL
         bKEfcN1TV6LX8GxHhNz2jcnhBfta6OiZdRPpmwknaIvP/tQ2qCnvkw+VqPVcNXO4iFcL
         /fcQ==
X-Gm-Message-State: AOAM5302WTrisgHQHZboMelO2t1M5k+rG9V1nN5Ax+GtLgFl4XWA6UM5
	4BGQzwA6YDEY8E/TqrbVsQU=
X-Google-Smtp-Source: ABdhPJwaLeWOxzmuhJhjgAdmI0j3ddtpspQ4OkHVexe7PvXeW20GC370vRPp3GnVrW9KjIJcaky3VQ==
X-Received: by 2002:a62:29c6:: with SMTP id p189mr52732155pfp.55.1594579245655;
        Sun, 12 Jul 2020 11:40:45 -0700 (PDT)
Date: Sun, 12 Jul 2020 11:40:41 -0700
From: Nathan Chancellor <natechancellor@gmail.com>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>,
	Sami Tolvanen <samitolvanen@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Will Deacon <will@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH 00/22] add support for Clang LTO
Message-ID: <20200712184041.GA1838@Ryzen-9-3900X.localdomain>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <671d8923-ed43-4600-2628-33ae7cb82ccb@molgen.mpg.de>
 <CA+icZUXPB_C1bjA13zi3OLFCpiZh+GsgHT0y6kumzVRavs4LkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+icZUXPB_C1bjA13zi3OLFCpiZh+GsgHT0y6kumzVRavs4LkQ@mail.gmail.com>

On Sun, Jul 12, 2020 at 10:59:17AM +0200, Sedat Dilek wrote:
> On Sat, Jul 11, 2020 at 6:32 PM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
> >
> > Dear Sami,
> >
> >
> > Am 24.06.20 um 22:31 schrieb Sami Tolvanen:
> > > This patch series adds support for building x86_64 and arm64 kernels
> > > with Clang's Link Time Optimization (LTO).
> > >
> > > In addition to performance, the primary motivation for LTO is to allow
> > > Clang's Control-Flow Integrity (CFI) to be used in the kernel. Google's
> > > Pixel devices have shipped with LTO+CFI kernels since 2018.
> > >
> > > Most of the patches are build system changes for handling LLVM bitcode,
> > > which Clang produces with LTO instead of ELF object files, postponing
> > > ELF processing until a later stage, and ensuring initcall ordering.
> > >
> > > Note that first objtool patch in the series is already in linux-next,
> > > but as it's needed with LTO, I'm including it also here to make testing
> > > easier.
> >
> > […]
> >
> > Thank you very much for sending these changes.
> >
> > Do you have a branch, where your current work can be pulled from? Your
> > branch on GitHub [1] seems 15 months old.
> >
> 
> Agreed it's easier to git-pull.
> I have seen [1] - not sure if this is the latest version.
> Alternatively, you can check patchwork LKML by searching for $submitter.
> ( You can open patch 01/22 and download the whole patch-series by
> following the link "series", see [3]. )
> 
> - Sedat -
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild.git/log/?h=lto
> [2] https://lore.kernel.org/patchwork/project/lkml/list/?series=&submitter=19676
> [3] https://lore.kernel.org/patchwork/series/450026/mbox/
> 

Sami tagged this series on his GitHub:

https://github.com/samitolvanen/linux/releases/tag/lto-v1

git pull https://github.com/samitolvanen/linux lto-v1

Otherwise, he is updating the clang-cfi branch that includes both the
LTO and CFI patchsets. You can pull that and just turn on
CONFIG_LTO_CLANG.

Lastly, for the future, I would recommend grabbing b4 to easily apply
patches (specifically full series) from lore.kernel.org.

https://git.kernel.org/pub/scm/utils/b4/b4.git/
https://git.kernel.org/pub/scm/utils/b4/b4.git/tree/README.rst

You could grab this series and apply it easily by either downloading the
mbox file and following the instructions it gives for applying the mbox
file:

$ b4 am 20200624203200.78870-1-samitolvanen@google.com

or I prefer piping so that I don't have to clean up later:

$ b4 am -o - 20200624203200.78870-1-samitolvanen@google.com | git am

Cheers,
Nathan
