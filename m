Return-Path: <SRS0=8EaF=C3=lists.openwall.com=kernel-hardening-return-19949-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8F64C43463
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 20:53:48 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CB47123119
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 20:53:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KW2Q2zo+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB47123119
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19949-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26486 invoked by uid 550); 18 Sep 2020 20:53:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26445 invoked from network); 18 Sep 2020 20:53:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Iy3TQ3C1Ek23yK9GZJXs0daNRNetn5CYF4/zAE2h7ik=;
        b=KW2Q2zo+JFuYkr4TiNUBIe05OcRvez9oPhQD2VPO4rhQx4vr57iS+J6zydE3kkrQLF
         DI66mG3IeYuMnm30FYVw5h6Oxc9WygSHNlBMmug3nlJy8G1DUZ0juqx+QQnea9m7Gete
         ZlaTZ+Z/2TdOkps+Zf6K1JMQCJdPxK/x+hQD14J8YYA/+4YQfkWf+gJLTCmIge3scE76
         p3ygrRlm7Krhqb7M2JzcHo7FC2+dzmjQDXITtDjcCKKvClFY66fCZJuYnZ82RbA6pZTO
         Ed6GbIdgELybyBiBA7rEsXwGMBM8G5XyQ62y/lS/J/y5NTvmLs19ZGyoccTTuwOoeW73
         b8Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Iy3TQ3C1Ek23yK9GZJXs0daNRNetn5CYF4/zAE2h7ik=;
        b=RUyTkAM/4hoReirjYWVQPhtcHRqx8p/ojJrEPS38+MiDOMPKq8ljOUdWsJ7jI9k2kw
         lt1R4UXYVhAcmsIgwAKJQKMzEKg6yCO7YU0q38r5G9HStxcp7Uf8ou5Qms1K6QF6Qst2
         i3II8ZsURV3G4iPZT3eMPzHrH8IUqynufujbRqxRnBsF9uunbspWBJed76VDcdxgFqM5
         TYqZmd69Yv3ggsuL0vpmt1m+B6ypxfnjV5I+Aqo/PMrxLPEOMEX7e3mjI1CzTJr00mMJ
         LIgJkrjk4oOXmTI/YBRee3KAq+p22aYu4R4Yx+UMlLb0i//7M56C9YYxs6BJTPCZghMX
         ZevQ==
X-Gm-Message-State: AOAM531H+Tz209lFyevv1hNxJcsRLJSWCj7vt21Zo3o//mWTDrMAiTto
	4/qssXFlCogl4aCV3xfAqWK6LMisUcAFKq0PTTwLQw==
X-Google-Smtp-Source: ABdhPJykoyGWTRcD0lR6xnSRRS+gTsSrH7i8r0dJuA7wRYkUeLk2vde81YvSA+MIvTflgkJVw4xrDt+AfE3pnj9QWgw=
X-Received: by 2002:a17:90b:f18:: with SMTP id br24mr2004360pjb.32.1600462408474;
 Fri, 18 Sep 2020 13:53:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200918201436.2932360-1-samitolvanen@google.com>
 <CA+icZUW1MYSUz8jwOaVpi6ib1dyCv1VmG5priw6TTzXGSh_8Gg@mail.gmail.com> <CABCJKueyWvNB2MQw_PCLtZb8F1+sA1QOLJi_5qMKwdFCcwSMGg@mail.gmail.com>
In-Reply-To: <CABCJKueyWvNB2MQw_PCLtZb8F1+sA1QOLJi_5qMKwdFCcwSMGg@mail.gmail.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Fri, 18 Sep 2020 13:53:17 -0700
Message-ID: <CAKwvOd=N5XS+c7X+fM+0aHWoo8j-xZ96Qk1a4n6gvYJZAq1mCQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/30] Add support for Clang LTO
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Clang-Built-Linux ML <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	linux-kbuild <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-pci@vger.kernel.org, X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Sep 18, 2020 at 1:50 PM Sami Tolvanen <samitolvanen@google.com> wrote:
>
> On Fri, Sep 18, 2020 at 1:22 PM Sedat Dilek <sedat.dilek@gmail.com> wrote:
> >
> > On Fri, Sep 18, 2020 at 10:14 PM 'Sami Tolvanen' via Clang Built Linux
> > <clang-built-linux@googlegroups.com> wrote:
> > >
> > > This patch series adds support for building x86_64 and arm64 kernels
> > > with Clang's Link Time Optimization (LTO).
> > >
> > > In addition to performance, the primary motivation for LTO is
> > > to allow Clang's Control-Flow Integrity (CFI) to be used in the
> > > kernel. Google has shipped millions of Pixel devices running three
> > > major kernel versions with LTO+CFI since 2018.
> > >
> > > Most of the patches are build system changes for handling LLVM
> > > bitcode, which Clang produces with LTO instead of ELF object files,
> > > postponing ELF processing until a later stage, and ensuring initcall
> > > ordering.
> > >
> > > Note that patches 1-5 are not directly related to LTO, but are
> > > needed to compile LTO kernels with ToT Clang, so I'm including them
> > > in the series for your convenience:
> > >
> > >  - Patches 1-3 fix build issues with LLVM and they are already in
> > >    linux-next.
> > >
> > >  - Patch 4 fixes x86 builds with LLVM IAS, but it hasn't yet been
> > >    picked up by maintainers.
> > >
> > >  - Patch 5 is from Masahiro's kbuild tree and makes the LTO linker
> > >    script changes much cleaner.
> > >
> >
> > Hi Sami,
> >
> > might be good to point to your GitHub tree and corresponding
> > release-tag for easy fetching.
>
> Ah, true. You can also pull this series from
>
>   https://github.com/samitolvanen/linux.git lto-v3

Also, I've been using b4 happily for a short while now.
https://people.kernel.org/monsieuricon/introducing-b4-and-patch-attestation

My workflow would be: check lore.kernel.org/lkml/
for the series in question. In this case:
https://lore.kernel.org/lkml/CABCJKueyWvNB2MQw_PCLtZb8F1+sA1QOLJi_5qMKwdFCcwSMGg@mail.gmail.com/T/#t
is the cover letter.  Then in my tree:
$ b4 am https://lore.kernel.org/lkml/CABCJKueyWvNB2MQw_PCLtZb8F1+sA1QOLJi_5qMKwdFCcwSMGg@mail.gmail.com/T/#t
-o - | git am
-- 
Thanks,
~Nick Desaulniers
