Return-Path: <SRS0=HiQ4=AS=lists.openwall.com=kernel-hardening-return-19224-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA62AC433DF
	for <kernel-hardening@archiver.kernel.org>; Tue,  7 Jul 2020 15:51:36 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 36F052080D
	for <kernel-hardening@archiver.kernel.org>; Tue,  7 Jul 2020 15:51:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qbZF9hTu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 36F052080D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19224-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30713 invoked by uid 550); 7 Jul 2020 15:51:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30675 invoked from network); 7 Jul 2020 15:51:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6nbLKEvdqqtu0DOxk+RX2NCeuVjz/d5/WDsGYxOKe+A=;
        b=qbZF9hTub3E6dJOMlijRiMiRkHYkFQubSYFp6P+VnStOU35ksLbT5c2olfLiJpXsF3
         p3AHOCADz7BlPRcb5xlVfsDuFkpaWzroZytIxmWQMa1Tq9gUpWVZPukI1yqE2KFTHiA3
         9YlWvV6iIbDdJ+BZAyuKLx1RPuPn/LEcUmBvsAMcz6jJ5yyWtgLEw10Q8wnhLwp1ZVgF
         o4GGnZfpFXNrCeoFTPW5BteobP+ETyf4GPs6Ui4f/hVYa1npYd2Jb7cBEU2OssXqWPH4
         auU0losOJLOMYxa1RdqPXWKkY62FkFHARI3LfbFiT0CpoTlE2LZsZ8/SQVRU7EUqTPAC
         0DtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6nbLKEvdqqtu0DOxk+RX2NCeuVjz/d5/WDsGYxOKe+A=;
        b=EPhe1rb9/R6PmaiEBzIr5o/TTyRZaVF5nVv3QU+kx29ElbKGRPY/wBIWMrsLdzqhAv
         k9qbqUVryGL9pJJMumZP3eop9j+Sf39y4GXviJl4XCG3dDv828y0kM6EhNxlBHpl9pFQ
         xu62wyuaPJBjFFO2Sq2MyNLWGcH2hhoPI9x7ltbDKmUWVqcowmko95KWDN/MP+uLdTuO
         9z7RbiFWTKAU6Nf+BvjO+1fGNE2I9WEhfmQzba+8jOP4Ugzme7zshzaBNq2WPgIaJxhl
         YE3fzNDK1oL2I3TVpPuwN+R+GbXqE2DSeJpZzd66HowaaGCT6NI2sMTsHJ0vAMNPSx5K
         ToUw==
X-Gm-Message-State: AOAM532uo8KArBviUjUgB3F3EM4xs7RSc6XA7bj5O4tq7rMPB4vLX1Ht
	SinOFjouB7qYCAzcgpOiXEY/5Q==
X-Google-Smtp-Source: ABdhPJzoBjROrVaJtp6nujXRaXTatw7gwLtR2zb8jqFckSgpuUCpME8ySKJl8GGYK6iDFTRo3tsWzA==
X-Received: by 2002:a17:90a:a106:: with SMTP id s6mr5003560pjp.53.1594137075030;
        Tue, 07 Jul 2020 08:51:15 -0700 (PDT)
Date: Tue, 7 Jul 2020 08:51:07 -0700
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>,
	Jiong Wang <jiong.wang@netronome.com>,
	Jakub Kicinski <kuba@kernel.org>
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
Message-ID: <20200707155107.GA3357035@google.com>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <CAK7LNASvb0UDJ0U5wkYYRzTAdnEs64HjXpEUL7d=V0CXiAXcNw@mail.gmail.com>
 <20200629232059.GA3787278@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200629232059.GA3787278@google.com>

On Mon, Jun 29, 2020 at 04:20:59PM -0700, Sami Tolvanen wrote:
> Hi Masahiro,
> 
> On Mon, Jun 29, 2020 at 01:56:19AM +0900, Masahiro Yamada wrote:
> > I also got an error for
> > ARCH=arm64 allyesconfig + CONFIG_LTO_CLANG=y
> > 
> > 
> > 
> > $ make ARCH=arm64 LLVM=1 LLVM_IAS=1
> > CROSS_COMPILE=~/tools/aarch64-linaro-7.5/bin/aarch64-linux-gnu-
> > -j24
> > 
> >   ...
> > 
> >   GEN     .version
> >   CHK     include/generated/compile.h
> >   UPD     include/generated/compile.h
> >   CC      init/version.o
> >   AR      init/built-in.a
> >   GEN     .tmp_initcalls.lds
> >   GEN     .tmp_symversions.lds
> >   LTO     vmlinux.o
> >   MODPOST vmlinux.symvers
> >   MODINFO modules.builtin.modinfo
> >   GEN     modules.builtin
> >   LD      .tmp_vmlinux.kallsyms1
> > ld.lld: error: undefined symbol: __compiletime_assert_905
> > >>> referenced by irqbypass.c
> > >>>               vmlinux.o:(jeq_imm)
> > make: *** [Makefile:1161: vmlinux] Error 1
> 
> I can reproduce this with ToT LLVM and it's BUILD_BUG_ON_MSG(..., "value
> too large for the field") in drivers/net/ethernet/netronome/nfp/bpf/jit.c.
> Specifically, the FIELD_FIT / __BF_FIELD_CHECK macro in ur_load_imm_any.
> 
> This compiles just fine with an earlier LLVM revision, so it could be a
> relatively recent regression. I'll take a look. Thanks for catching this!

After spending some time debugging this with Nick, it looks like the
error is caused by a recent optimization change in LLVM, which together
with the inlining of ur_load_imm_any into jeq_imm, changes a runtime
check in FIELD_FIT that would always fail, to a compile-time check that
breaks the build. In jeq_imm, we have:

    /* struct bpf_insn: _s32 imm */
    u64 imm = insn->imm; /* sign extend */
    ...
    if (imm >> 32) { /* non-zero only if insn->imm is negative */
    	/* inlined from ur_load_imm_any */
	u32 __imm = imm >> 32; /* therefore, always 0xffffffff */

        /*
	 * __imm has a value known at compile-time, which means
	 * __builtin_constant_p(__imm) is true and we end up with
	 * essentially this in __BF_FIELD_CHECK:
	 */
	if (__builtin_constant_p(__imm) && __imm <= 255)
	      __compiletime_assert_N();

The compile-time check comes from the following BUILD_BUG_ON_MSG:

    #define __BF_FIELD_CHECK(_mask, _reg, _val, _pfx)		\
    ...
	BUILD_BUG_ON_MSG(__builtin_constant_p(_val) ?		\
			 ~((_mask) >> __bf_shf(_mask)) & (_val) : 0, \
			 _pfx "value too large for the field"); \

While we could stop the compiler from performing this optimization by
telling it to never inline ur_load_imm_any, we feel like a better fix
might be to replace FIELD_FIT(UR_REG_IMM_MAX, imm) with a simple imm
<= UR_REG_IMM_MAX check that won't trip a compile-time assertion even
when the condition is known to fail.

Jiong, Jakub, do you see any issues here?

Sami
