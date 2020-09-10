Return-Path: <SRS0=ouJ1=CT=lists.openwall.com=kernel-hardening-return-19836-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6110DC43461
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Sep 2020 01:19:12 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D656C22229
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Sep 2020 01:19:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="enir3QxF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D656C22229
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19836-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5495 invoked by uid 550); 10 Sep 2020 01:19:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5460 invoked from network); 10 Sep 2020 01:19:00 -0000
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-04.nifty.com 08A1Iht3013562
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
	s=dec2015msa; t=1599700723;
	bh=x2qUAAqVWiePSrCzfI1IEP4eafAB9yee8r8ckQho/u8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=enir3QxFBVldAB2cBmhnMG4LoKhdrRvGgj1+55R4UEaqRUrAvgeYVhCN7Ifi1gro5
	 +zzJvoLQR0AoT+rl9PYTlAN0cLMSYcZW2ieLwI3Hfscw53ZO7dbUbxLW2M0RFH1GY0
	 +MoI9UF17dlDalJHv1YUP389blVeLcnmjnWpU1KOMS4kgTJ1zTbxKDzpqmKRkXoOF2
	 tK4XKnX6F26RcT4sSRD93FyEikbDqma27/GR3GMZxpQwlnpPbsINtQ5KbUgajft7//
	 lanAARLP8i8J9YDIrcnLXX4oc5Pz6iyo9qZTFf69j5/e3JR+XXrCmElZhH140fSdWD
	 ss6Go76T0mdJQ==
X-Nifty-SrcIP: [209.85.215.178]
X-Gm-Message-State: AOAM530a4Jy37/AZRidz929ATKHP1x4Owg6guAttW3OFn9v0q8B6YGRl
	t5+COQEHsJNezx/rFtNpJini5ZiudFs8R/DpNwA=
X-Google-Smtp-Source: ABdhPJw3+uiV59rG6EDJ8QWqM7TRK95TtkCpF/iAWICblIOjIFopt/zBNTTyCv+Bm880c1rm+ZI8WQaujb2+mHAsSEI=
X-Received: by 2002:a63:f546:: with SMTP id e6mr2466312pgk.7.1599700722672;
 Wed, 09 Sep 2020 18:18:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com> <CAK7LNASDUkyJMDD0a5K_HT=1q5NEc6dcN4=FUb330yK0BCKcTw@mail.gmail.com>
 <20200908234643.GF1060586@google.com>
In-Reply-To: <20200908234643.GF1060586@google.com>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Thu, 10 Sep 2020 10:18:05 +0900
X-Gmail-Original-Message-ID: <CAK7LNAR9zzP0ZU3b__PZv8gRtKrwz6-8GE1zG5UyFx1wDpOBzQ@mail.gmail.com>
Message-ID: <CAK7LNAR9zzP0ZU3b__PZv8gRtKrwz6-8GE1zG5UyFx1wDpOBzQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/28] Add support for Clang LTO
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org, X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Sep 9, 2020 at 8:46 AM Sami Tolvanen <samitolvanen@google.com> wrote:
>
> On Sun, Sep 06, 2020 at 09:24:38AM +0900, Masahiro Yamada wrote:
> > On Fri, Sep 4, 2020 at 5:30 AM Sami Tolvanen <samitolvanen@google.com> wrote:
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
> > > Note that patches 1-4 are not directly related to LTO, but are
> > > needed to compile LTO kernels with ToT Clang, so I'm including them
> > > in the series for your convenience:
> > >
> > >  - Patches 1-3 are required for building the kernel with ToT Clang,
> > >    and IAS, and patch 4 is needed to build allmodconfig with LTO.
> > >
> > >  - Patches 3-4 are already in linux-next, but not yet in 5.9-rc.
> > >
> >
> >
> > I still do not understand how this patch set works.
> > (only me?)
> >
> > Please let me ask fundamental questions.
> >
> >
> >
> > I applied this series on top of Linus' tree,
> > and compiled for ARCH=arm64.
> >
> > I compared the kernel size with/without LTO.
> >
> >
> >
> > [1] No LTO  (arm64 defconfig, CONFIG_LTO_NONE)
> >
> > $ llvm-size   vmlinux
> >    text    data     bss     dec     hex filename
> > 15848692 10099449 493060 26441201 19375f1 vmlinux
> >
> >
> >
> > [2] Clang LTO  (arm64 defconfig + CONFIG_LTO_CLANG)
> >
> > $ llvm-size   vmlinux
> >    text    data     bss     dec     hex filename
> > 15906864 10197445 490804 26595113 195cf29 vmlinux
> >
> >
> > I compared the size of raw binary, arch/arm64/boot/Image.
> > Its size increased too.
> >
> >
> >
> > So, in my experiment, enabling CONFIG_LTO_CLANG
> > increases the kernel size.
> > Is this correct?
>
> Yes. LTO does produce larger binaries, mostly due to function
> inlining between translation units, I believe. The compiler people
> can probably give you a more detailed answer here. Without -mllvm
> -import-instr-limit, the binaries would be even larger.
>
> > One more thing, could you teach me
> > how Clang LTO optimizes the code against
> > relocatable objects?
> >
> >
> >
> > When I learned Clang LTO first, I read this document:
> > https://llvm.org/docs/LinkTimeOptimization.html
> >
> > It is easy to confirm the final executable
> > does not contain foo2, foo3...
> >
> >
> >
> > In contrast to userspace programs,
> > kernel modules are basically relocatable objects.
> >
> > Does Clang drop unused symbols from relocatable objects?
> > If so, how?
>
> I don't think the compiler can legally drop global symbols from
> relocatable objects, but it can rename and possibly even drop static
> functions.


Compilers can drop static functions without LTO.
Rather, it is a compiler warning
(-Wunused-function), so the code should be cleaned up.



> This is why we need global wrappers for initcalls, for
> example, to have stable symbol names.
>
> Sami



At first, I thought the motivation of LTO
was to remove unused global symbols, and
to perform further optimization.


It is true for userspace programs.
In fact, the example of
https://llvm.org/docs/LinkTimeOptimization.html
produces a smaller binary.


In contrast, this patch set produces a bigger kernel
because LTO cannot remove any unused symbol.

So, I do not understand what the benefit is.


Is inlining beneficial?
I am not sure.


Documentation/process/coding-style.rst
"15) The inline disease"
mentions that inlining is not always
a good thing.


As a whole, I still do not understand
the motivation of this patch set.


-- 
Best Regards
Masahiro Yamada
