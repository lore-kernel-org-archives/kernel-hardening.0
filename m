Return-Path: <SRS0=fgSu=AK=lists.openwall.com=kernel-hardening-return-19189-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65570C433E0
	for <kernel-hardening@archiver.kernel.org>; Mon, 29 Jun 2020 23:21:27 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B60EE20780
	for <kernel-hardening@archiver.kernel.org>; Mon, 29 Jun 2020 23:21:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wE7nxuQQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B60EE20780
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19189-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15779 invoked by uid 550); 29 Jun 2020 23:21:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15747 invoked from network); 29 Jun 2020 23:21:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Y3eOZWqjsfvFABJlAWadxHNb9WOoW2QZW11FNR7qgIM=;
        b=wE7nxuQQ8Ee1SyIlOGu96foC1kguVLhQnWfsM449qkfn/VoKBCtsVMOqOmKx7IZI4C
         RVaEjdafrzkZKrdHnHpUfIuUaR+nDUOQdXro+nnJx5XibnwFB04m0UpfLU8lcAfNzunK
         FH4vq/4AmRKx0OXYjTpIwOSmyWjemlGQQrsAim9D+osZfnHYYrMcyKBMOA6AcmZTCt7D
         SC8HEZlX2KwR8OsKRbEGGGO82nQHiO6QrFnPdGaYVsrLOIGowYuaQm3rOF21PeyeGPnP
         uhJe537nfOotmxkifcJzP2KlYRs06hCp+YYdixCMO/J34Bhc2jSz49ZJoQbscAlwSyYN
         PnZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y3eOZWqjsfvFABJlAWadxHNb9WOoW2QZW11FNR7qgIM=;
        b=WpsBOyA9YGbL+rMX2pRZZa68XhaDjGZBylKTyZ0SCBtsxbIFJGKxmJGQaxZaMGbyjR
         SCIhYImxXuUZEQumgWyHYksgFZXaDC2vDNvqIXASHXrh7ynraa133DkD3kkdvIFIOega
         bx8V3C0HHrZoDfEaoaHNQeUhFkwLQsezW5iulUfybVXbbfWj9x8bW/4t4+2J4r/hlzrd
         KW75nKeN9MnkIMGpWdEX4HMu2dZycU9WC2nTyaqWo1Y1BWloY+/OPHPbSRqC1NmeNFjL
         E3uU+nqmi51jyClLFstc/66kc8G/lz+CfAUK75tTTseJkbwqLmqmX9Q6+X0kS2j22mJd
         xnZw==
X-Gm-Message-State: AOAM531MsP7JdD6+R89w6Tp4uYo5IRpNJjhdxaoIGtFTgm9J8Tkriuop
	w4RoHwrteF1ZMphuLasn5TMhYQ==
X-Google-Smtp-Source: ABdhPJyWjBAVW07I/bBTVGZOBkIjcBIoUitijR4kfg05/memnxRwz5hP6QJZ8z5KUGyU1tHG6QOWdA==
X-Received: by 2002:a62:ce48:: with SMTP id y69mr15584876pfg.208.1593472865320;
        Mon, 29 Jun 2020 16:21:05 -0700 (PDT)
Date: Mon, 29 Jun 2020 16:20:59 -0700
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: Will Deacon <will@kernel.org>,
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
Subject: Re: [PATCH 00/22] add support for Clang LTO
Message-ID: <20200629232059.GA3787278@google.com>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <CAK7LNASvb0UDJ0U5wkYYRzTAdnEs64HjXpEUL7d=V0CXiAXcNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK7LNASvb0UDJ0U5wkYYRzTAdnEs64HjXpEUL7d=V0CXiAXcNw@mail.gmail.com>

Hi Masahiro,

On Mon, Jun 29, 2020 at 01:56:19AM +0900, Masahiro Yamada wrote:
> On Thu, Jun 25, 2020 at 5:32 AM 'Sami Tolvanen' via Clang Built Linux
> <clang-built-linux@googlegroups.com> wrote:
> >
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
> 
> I put this series on a testing branch,
> and 0-day bot started reporting some issues.

Yes, I'll fix those issues in v2.

> (but 0-day bot is quieter than I expected.
> Perhaps, 0-day bot does not turn on LLVM=1 ?)

In order for it to test an LTO build, it would need to enable LTO_CLANG
explicitly though, in addition to LLVM=1.

> I also got an error for
> ARCH=arm64 allyesconfig + CONFIG_LTO_CLANG=y
> 
> 
> 
> $ make ARCH=arm64 LLVM=1 LLVM_IAS=1
> CROSS_COMPILE=~/tools/aarch64-linaro-7.5/bin/aarch64-linux-gnu-
> -j24
> 
>   ...
> 
>   GEN     .version
>   CHK     include/generated/compile.h
>   UPD     include/generated/compile.h
>   CC      init/version.o
>   AR      init/built-in.a
>   GEN     .tmp_initcalls.lds
>   GEN     .tmp_symversions.lds
>   LTO     vmlinux.o
>   MODPOST vmlinux.symvers
>   MODINFO modules.builtin.modinfo
>   GEN     modules.builtin
>   LD      .tmp_vmlinux.kallsyms1
> ld.lld: error: undefined symbol: __compiletime_assert_905
> >>> referenced by irqbypass.c
> >>>               vmlinux.o:(jeq_imm)
> make: *** [Makefile:1161: vmlinux] Error 1

I can reproduce this with ToT LLVM and it's BUILD_BUG_ON_MSG(..., "value
too large for the field") in drivers/net/ethernet/netronome/nfp/bpf/jit.c.
Specifically, the FIELD_FIT / __BF_FIELD_CHECK macro in ur_load_imm_any.

This compiles just fine with an earlier LLVM revision, so it could be a
relatively recent regression. I'll take a look. Thanks for catching this!

Sami
