Return-Path: <SRS0=pCD2=CR=lists.openwall.com=kernel-hardening-return-19820-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0098EC2D0A7
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Sep 2020 17:14:38 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F0A452098B
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Sep 2020 17:14:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l8TFfPPi"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F0A452098B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19820-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 14280 invoked by uid 550); 8 Sep 2020 17:14:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 14245 invoked from network); 8 Sep 2020 17:14:29 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/gCc+KLpNK9ExlVMZwWTulckz89Pa9STYRhLISVmRXE=;
        b=l8TFfPPi8zCMxO4dQ+cL2mPjwdbrYknGcvJ3S7KeMVYr2Q/H76gUGB/4DPzblBc4wL
         Z/kVUs7HQzPp6jHkL4co16aB0o/g9Ki0Ci0aIB0eJoVFKyQw8ebfadzXTbu4V+oR00+P
         Y0GX8EGtn/TLhA7swJKiiBEOKxyP30iGgiknVXfiRggge5Bv6Ynx3A+1F897oXDNaoVR
         kVH5X1H8mEjwr96L9W1aE7R55Kb7ZR5yUxkKFHGYbtAPNMDgXY7WU4juuRBrpC4IgkSf
         Q6Y88UZSHorH9uaE9yPAgcDEGg9XIEKFsGjNzLTMMT0/0Jx0dHHH+2sXVL5BjPJrknNp
         m0mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/gCc+KLpNK9ExlVMZwWTulckz89Pa9STYRhLISVmRXE=;
        b=DcI7mCJEz9joL1WgXDlAY1zHnV2VmKaV0IuICeXCeiL1QRseXcVCYDkr03KUgl5KIy
         52u7XKslBLYTVOUKBGNvIU9b4zTuYQil6QdKfP+h9mfRJMzutQf8FI9JLn+RrJnKQHu1
         lNRb7CQ1qfgW9cBesrN7JpVlizD0N69s0cxOEo9MuVmFvSlHQyNHYrMM2sK2yG894g43
         qZU6IrGIP38jlOKqQPu/23TwwYEq+FdBfSgMAFEY/X+s0PQa69ToFkNYSC130fSNUpO+
         1kejvSU/9ZwwBbDik6RwiQdWNvrH1wkuhPn6q/b4MNcNF1iPxtLoZJdPmOXD21doFW7C
         PNrg==
X-Gm-Message-State: AOAM531tyax0zOJGRs7A6atIktNEF5JDi7zn1W25ugC70PcRy9fmul0A
	T8z3xF65McgtlYdhmLhqHZuLjw==
X-Google-Smtp-Source: ABdhPJwIjKawnMHTj/rRnXjnjsmCJjseMt/B3KoD/9OR2ojGQkPMO3BFzGgdcfjb98S269z1QHdN5g==
X-Received: by 2002:a17:90a:ea0c:: with SMTP id w12mr105528pjy.65.1599585257422;
        Tue, 08 Sep 2020 10:14:17 -0700 (PDT)
Date: Tue, 8 Sep 2020 10:14:11 -0700
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>
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
Subject: Re: [PATCH v2 09/28] kbuild: add support for Clang LTO
Message-ID: <20200908171411.GC2743468@google.com>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <20200903203053.3411268-10-samitolvanen@google.com>
 <CAK7LNASTtxJ7OCMM_KxmaoSL3CDfTY-65Pu=-MYkMo7iz-_NOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK7LNASTtxJ7OCMM_KxmaoSL3CDfTY-65Pu=-MYkMo7iz-_NOQ@mail.gmail.com>

On Sun, Sep 06, 2020 at 05:17:32AM +0900, Masahiro Yamada wrote:
> On Fri, Sep 4, 2020 at 5:31 AM Sami Tolvanen <samitolvanen@google.com> wrote:
> >
> > This change adds build system support for Clang's Link Time
> > Optimization (LTO). With -flto, instead of ELF object files, Clang
> > produces LLVM bitcode, which is compiled into native code at link
> > time, allowing the final binary to be optimized globally. For more
> > details, see:
> >
> >   https://llvm.org/docs/LinkTimeOptimization.html
> >
> > The Kconfig option CONFIG_LTO_CLANG is implemented as a choice,
> > which defaults to LTO being disabled. To use LTO, the architecture
> > must select ARCH_SUPPORTS_LTO_CLANG and support:
> >
> >   - compiling with Clang,
> >   - compiling inline assembly with Clang's integrated assembler,
> >   - and linking with LLD.
> >
> > While using full LTO results in the best runtime performance, the
> > compilation is not scalable in time or memory. CONFIG_THINLTO
> > enables ThinLTO, which allows parallel optimization and faster
> > incremental builds. ThinLTO is used by default if the architecture
> > also selects ARCH_SUPPORTS_THINLTO:
> >
> >   https://clang.llvm.org/docs/ThinLTO.html
> >
> > To enable LTO, LLVM tools must be used to handle bitcode files. The
> > easiest way is to pass the LLVM=1 option to make:
> >
> >   $ make LLVM=1 defconfig
> >   $ scripts/config -e LTO_CLANG
> >   $ make LLVM=1
> >
> > Alternatively, at least the following LLVM tools must be used:
> >
> >   CC=clang LD=ld.lld AR=llvm-ar NM=llvm-nm
> >
> > To prepare for LTO support with other compilers, common parts are
> > gated behind the CONFIG_LTO option, and LTO can be disabled for
> > specific files by filtering out CC_FLAGS_LTO.
> >
> > Note that support for DYNAMIC_FTRACE and MODVERSIONS are added in
> > follow-up patches.
> >
> > Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> > ---
> >  Makefile                          | 18 +++++++-
> >  arch/Kconfig                      | 68 +++++++++++++++++++++++++++++++
> >  include/asm-generic/vmlinux.lds.h | 11 +++--
> >  scripts/Makefile.build            |  9 +++-
> >  scripts/Makefile.modfinal         |  9 +++-
> >  scripts/Makefile.modpost          | 24 ++++++++++-
> >  scripts/link-vmlinux.sh           | 32 +++++++++++----
> >  7 files changed, 154 insertions(+), 17 deletions(-)
> >
> > diff --git a/Makefile b/Makefile
> > index a9dae26c93b5..dd49eaea7c25 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -909,6 +909,22 @@ KBUILD_CFLAGS      += $(CC_FLAGS_SCS)
> >  export CC_FLAGS_SCS
> >  endif
> >
> > +ifdef CONFIG_LTO_CLANG
> > +ifdef CONFIG_THINLTO
> > +CC_FLAGS_LTO_CLANG := -flto=thin -fsplit-lto-unit
> > +KBUILD_LDFLAGS += --thinlto-cache-dir=.thinlto-cache
> > +else
> > +CC_FLAGS_LTO_CLANG := -flto
> > +endif
> > +CC_FLAGS_LTO_CLANG += -fvisibility=default
> > +endif
> > +
> > +ifdef CONFIG_LTO
> > +CC_FLAGS_LTO   := $(CC_FLAGS_LTO_CLANG)
> 
> 
> $(CC_FLAGS_LTO_CLANG) is not used elsewhere.
> 
> Why didn't you add the flags to CC_FLAGS_LTO
> directly?
> 
> Will it be useful if LTO_GCC is supported ?

The idea was to allow compiler-specific LTO flags to be filtered out
separately if needed, but you're right, this is not really necessary
right now. I'll drop CC_FLAGS_LTO_CLANG in v3.

Sami
