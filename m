Return-Path: <SRS0=+l7L=C3=lists.openwall.com=kernel-hardening-return-19948-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5306C43464
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 20:50:34 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C9E8B206A2
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 20:50:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TxBH8Ayv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C9E8B206A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19948-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22461 invoked by uid 550); 18 Sep 2020 20:50:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22429 invoked from network); 18 Sep 2020 20:50:26 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f4okZ/7bct4uSKwZ6O3z2m5KyitVLtU4XG9WgtUAxwc=;
        b=TxBH8AyvU6HWp66ncdZqEtoRFWD/YTji6mddQAC1tx4KXEeHFtGLdS3R9syxDOr/gw
         EJ35wyT17gb2NJYLGzLi6nzgB21j9JTRzpSNH6ko4dn+slxaKb4IH8Ki7QRFsqI7v9aA
         S87ydkbPm8kuIhgWoL3lKfaG0SLalSIBz1ahIC+ONuQXK7GoSVTs2pnZksirb/CgEcGJ
         dda7cH+5KO+boQPBNW5nn7bmDiexjhjP2RtZPQz3JvCcezgV03AKeN1igjv/uW0ePsfq
         kEgfrqOrvUv6gNdwmh3rNp+rjsPflT1TKKMgiRyTccCH7ogTg/un4wxhA9XtkrhpxfY7
         o61Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f4okZ/7bct4uSKwZ6O3z2m5KyitVLtU4XG9WgtUAxwc=;
        b=aYyIQewF30wGOs24qfkuY8i70kQYlcEOGgPC2P3cwffe4gzmaCsk1qwODU9NxNNTtG
         vfqw3aZ/jW7mfwnvvmAd9ncPBopJZDT//QA/VSPebg+8HQ5RJUe2cbuozCQAVHRn/3Uq
         ftYvmJ+dpNEqSzHcDhaaMQtB8EmVMC5htHewR9adxtWD88W348FeeYdqhni0nt64MYf6
         wt4xyGge0zu59huag5dXX7ahm1MHsn6s9oEB8dD8cuW8waZ3TMVVF/wKHlZUwHTq3lKF
         0vWDGy4VWIsSuXSk87mmdXepfgXEsCt0gI0g8m04+EfigTtIU6VV/r3Qm9nhRS1s6CSU
         qdUw==
X-Gm-Message-State: AOAM533lRY06ZqZh0aM/SJF2a/pQyLvchd5iezRhR6A+Jeqowidn4n/E
	q2t47cVgWj8KYzvaOl8l81sPHXyy5/iXgK5wsi0OMg==
X-Google-Smtp-Source: ABdhPJxlmp9BJajUv0E4cVIdv3SYp0wheOk/nOpDB3mBZ4a/wfqp4uUfhfc+2gKB4vscqXhsi0M+J+iTaTW/5sPlq3g=
X-Received: by 2002:a17:906:454e:: with SMTP id s14mr38862035ejq.137.1600462214260;
 Fri, 18 Sep 2020 13:50:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200918201436.2932360-1-samitolvanen@google.com> <CA+icZUW1MYSUz8jwOaVpi6ib1dyCv1VmG5priw6TTzXGSh_8Gg@mail.gmail.com>
In-Reply-To: <CA+icZUW1MYSUz8jwOaVpi6ib1dyCv1VmG5priw6TTzXGSh_8Gg@mail.gmail.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Fri, 18 Sep 2020 13:50:03 -0700
Message-ID: <CABCJKueyWvNB2MQw_PCLtZb8F1+sA1QOLJi_5qMKwdFCcwSMGg@mail.gmail.com>
Subject: Re: [PATCH v3 00/30] Add support for Clang LTO
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Clang-Built-Linux ML <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	linux-kbuild <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-pci@vger.kernel.org, X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Sep 18, 2020 at 1:22 PM Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
> On Fri, Sep 18, 2020 at 10:14 PM 'Sami Tolvanen' via Clang Built Linux
> <clang-built-linux@googlegroups.com> wrote:
> >
> > This patch series adds support for building x86_64 and arm64 kernels
> > with Clang's Link Time Optimization (LTO).
> >
> > In addition to performance, the primary motivation for LTO is
> > to allow Clang's Control-Flow Integrity (CFI) to be used in the
> > kernel. Google has shipped millions of Pixel devices running three
> > major kernel versions with LTO+CFI since 2018.
> >
> > Most of the patches are build system changes for handling LLVM
> > bitcode, which Clang produces with LTO instead of ELF object files,
> > postponing ELF processing until a later stage, and ensuring initcall
> > ordering.
> >
> > Note that patches 1-5 are not directly related to LTO, but are
> > needed to compile LTO kernels with ToT Clang, so I'm including them
> > in the series for your convenience:
> >
> >  - Patches 1-3 fix build issues with LLVM and they are already in
> >    linux-next.
> >
> >  - Patch 4 fixes x86 builds with LLVM IAS, but it hasn't yet been
> >    picked up by maintainers.
> >
> >  - Patch 5 is from Masahiro's kbuild tree and makes the LTO linker
> >    script changes much cleaner.
> >
>
> Hi Sami,
>
> might be good to point to your GitHub tree and corresponding
> release-tag for easy fetching.

Ah, true. You can also pull this series from

  https://github.com/samitolvanen/linux.git lto-v3

Sami
