Return-Path: <SRS0=M9nn=CT=lists.openwall.com=kernel-hardening-return-19850-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7C68C433E2
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Sep 2020 18:19:12 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D77B1206A2
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Sep 2020 18:19:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="HLvuaRMW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D77B1206A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19850-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25618 invoked by uid 550); 10 Sep 2020 18:19:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24556 invoked from network); 10 Sep 2020 18:19:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NNmcHwO+Iwg+rMeH3STh9feD6/hRsrC6t3t7wQ2j07g=;
        b=HLvuaRMWnIdqkY/j252Zk2tw3F2MY+FcibjdL/KozWLivJNfEdTrKZ7CqbgRS7PlOp
         JYDi+SPDHVcl/yQBRgsBfinBkUhTC2Vg4LOpBjFc6XUoK73NwgnL9x33VlwMsXmy4U//
         L1KOhxbAqZ23ZfVN8lGVbKftKzpOrRTb+F6EQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NNmcHwO+Iwg+rMeH3STh9feD6/hRsrC6t3t7wQ2j07g=;
        b=JXe+oJeA+/l5+B6hpJ3LY8itrkPEMq+THMwrcKZI7ZbGu/J9b+FR7Eyg1H0QB9EnSI
         8yOp89E1AyvsQpv5nwX1XXgojvHF75+P6zvRsMWEI0+R+ARiNMZ12FaHW2/5MvEbF7kz
         FP2hotzR8RDeSWiDutR+JRCe5LXifypwpJs789q86s4Hv9aVxOYp3haXoD2PELuw/JrA
         7jBpQCji0ecHqCd646JsYQlRcFElrQI1CMCQgybahKmfyImHAxYr4ymwlZXlu5Iji5Kt
         zG7DOGHOcaSrrFQDRx5qeAYUQT4DCZ5B/VgGQ5AbuwYrPmEroSU2l0E6bARzAgpNenQA
         n5gQ==
X-Gm-Message-State: AOAM532nAgN1lpE10Ds7XSzEB3tnmdJOutrz7jMto95xZ4Nqgcxnch3O
	Jm5iBINcj3gzYIlIqFHLDnJjHw==
X-Google-Smtp-Source: ABdhPJw/4pL1OYUwp6z4yw3Dzx5FlBwoM08u2lDH1WyZ3QTjZmpweja7YeY9sCB7pjDSgbG18rK2lA==
X-Received: by 2002:a63:6cc4:: with SMTP id h187mr5452054pgc.129.1599761932269;
        Thu, 10 Sep 2020 11:18:52 -0700 (PDT)
Date: Thu, 10 Sep 2020 11:18:50 -0700
From: Kees Cook <keescook@chromium.org>
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>, Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arch <linux-arch@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-pci@vger.kernel.org, X86 ML <x86@kernel.org>
Subject: Re: [PATCH v2 00/28] Add support for Clang LTO
Message-ID: <202009101057.1CCEB434@keescook>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <CAK7LNASDUkyJMDD0a5K_HT=1q5NEc6dcN4=FUb330yK0BCKcTw@mail.gmail.com>
 <20200908234643.GF1060586@google.com>
 <CAK7LNAR9zzP0ZU3b__PZv8gRtKrwz6-8GE1zG5UyFx1wDpOBzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK7LNAR9zzP0ZU3b__PZv8gRtKrwz6-8GE1zG5UyFx1wDpOBzQ@mail.gmail.com>

On Thu, Sep 10, 2020 at 10:18:05AM +0900, Masahiro Yamada wrote:
> On Wed, Sep 9, 2020 at 8:46 AM Sami Tolvanen <samitolvanen@google.com> wrote:
> >
> > On Sun, Sep 06, 2020 at 09:24:38AM +0900, Masahiro Yamada wrote:
> > > On Fri, Sep 4, 2020 at 5:30 AM Sami Tolvanen <samitolvanen@google.com> wrote:
> > > >
> > > > This patch series adds support for building x86_64 and arm64 kernels
> > > > with Clang's Link Time Optimization (LTO).
> > > [...]
> > > One more thing, could you teach me
> > > how Clang LTO optimizes the code against
> > > relocatable objects?
> > >
> > > When I learned Clang LTO first, I read this document:
> > > https://llvm.org/docs/LinkTimeOptimization.html
> > >
> > > It is easy to confirm the final executable
> > > does not contain foo2, foo3...
> > >
> > > In contrast to userspace programs,
> > > kernel modules are basically relocatable objects.
> > >
> > > Does Clang drop unused symbols from relocatable objects?
> > > If so, how?
> >
> > I don't think the compiler can legally drop global symbols from
> > relocatable objects, but it can rename and possibly even drop static
> > functions.
> 
> Compilers can drop static functions without LTO.
> Rather, it is a compiler warning
> (-Wunused-function), so the code should be cleaned up.

Right -- I think you're both saying the same thing. Unused static
functions can be dropped (modulo a warning) in both regular and LTO
builds.

> At first, I thought the motivation of LTO
> was to remove unused global symbols, and
> to perform further optimization.

One of LTO's benefits is the performance optimizations, but that's not
the driving motivation for it here. The performance optimizations are
possible because LTO provides the compiler with a view of the entire
built-in portion of the kernel (i.e. not shared objects). That "visible
all at once" state is the central concern because CFI (Control Flow
Integrity, the driving motivation for this series) needs it in the same
way that the performance optimization passes need it.

i.e. to gain CFI coverage, LTO is required. Since LTO is a distinct
first step independent of CFI, it was split out to be upstreamed while
fixes for CFI continued to land independently[1]. Once LTO is landed,
CFI comes next.

> In contrast, this patch set produces a bigger kernel
> because LTO cannot remove any unused symbol.
> 
> So, I do not understand what the benefit is.
> 
> Is inlining beneficial?
> I am not sure.

This is just a side-effect of LTO. As Sami mentions, it's entirely
tunable, and that tuning was chosen based on measurements made for the
kernel being built with LTO[2].

> As a whole, I still do not understand
> the motivation of this patch set.

It is a prerequisite for CFI, and CFI has been protecting *mumble*billion
Android device kernels against code-reuse attacks for the last 2ish
years[3]. I want this available for the entire Linux ecosystem, not just
Android; it is a strong security flaw mitigation technique.

I hope that helps explain it!

-Kees


[1] for example, these are some:
    https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/log/?qt=grep&q=Control+Flow+Integrity

[2] https://lore.kernel.org/lkml/20200624203200.78870-1-samitolvanen@google.com/T/#m6b576c3af79bdacada10f21651a2b02d33a4e32e

[3] https://android-developers.googleblog.com/2018/10/control-flow-integrity-in-android-kernel.html

-- 
Kees Cook
