Return-Path: <SRS0=OUFW=E2=lists.openwall.com=kernel-hardening-return-20431-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC9FBC6379D
	for <kernel-hardening@archiver.kernel.org>; Fri, 20 Nov 2020 16:23:45 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 422382240B
	for <kernel-hardening@archiver.kernel.org>; Fri, 20 Nov 2020 16:23:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BnDD+UEZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 422382240B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20431-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13580 invoked by uid 550); 20 Nov 2020 16:23:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13560 invoked from network); 20 Nov 2020 16:23:35 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vOo6J2qOaNEsmcSt6ibqCSmyULbkJ5ut9vT5313WIA4=;
        b=BnDD+UEZp9fE0ahf/zN/kLbG7kjRVUr1faC9KKf98v7DPL1XE0vyh9dxjpCHrS3lNW
         kKvDMNikzoKSTXwSpuCq2nMSCpe/evgWjYPck5JKJ8+CthvbR0ZNc9v0IupNF+zBlKnE
         uWG4Vnm7aF8vloRUfGNs1t64C7wzHzCYxkl+1FW8NQnQrHmCwCwd5XrUMJbaJCsjLXkf
         PDvNljmVdmQyxI1ZTz4Ld366+uXkkI5lh48Nb6TVvQ1syIEF+qmtpYm348qLXzUWJTvt
         eZGAJVW1RbhW1zWWoyWjl4wJmt5Yp9gZSkDByUKeL3sJfgBeoD9b6u8myXwoWwoCSaXl
         zRGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vOo6J2qOaNEsmcSt6ibqCSmyULbkJ5ut9vT5313WIA4=;
        b=UX03as32sOQVLl8sDsM2wX9cJcQfTrVpPj/4R9pk9ZoU1kIzhTepfqWevABcLvWSLH
         8591Twuu8WssCWehX640mam7kSULz+wfN9z5gwJaUrJTrwOEfZ6ZVI2+Bkukx1+6x4V3
         DScxMZC3IH/kQHot1aI5WBg3ValiQwq7xyTYU42RORmPwy/JMDDomC9CJFSDD6dBWTL9
         k/Ps6CkTs/JOAhANztzEHock3ZflUbiRwYdGYOwTlibsZ1MXHIAvUDyxe2iwMwdgoAcH
         iQWmsrWPVhIhugvZ6QdhEAQrblOoTWRc+2zozhLsIfDYy1gdHLTPiC9dBQip/rAWmjxi
         1pKg==
X-Gm-Message-State: AOAM5311RR41eoeJcYuYJwmLn0+G9n1CQJGxb2aUeHwh7JDw7bbp8g19
	MAbZ2OzL7sOoaT8hUl+XDtXZG9behhZJmqNwMB7BCQ==
X-Google-Smtp-Source: ABdhPJzJbx0o+d/bY6jtwZK7GW+lglt9oYk7o/Vt+a1dboyBqZ3CDfKGfXuk6ql3DjjDQQyhV682LGMMj50jprmokXk=
X-Received: by 2002:ab0:36db:: with SMTP id v27mr12115443uau.66.1605889402882;
 Fri, 20 Nov 2020 08:23:22 -0800 (PST)
MIME-Version: 1.0
References: <20201118220731.925424-1-samitolvanen@google.com>
 <20201118220731.925424-3-samitolvanen@google.com> <CAKwvOdnYTMzaahnBqdNYPz3KMdnkp=jZ4hxiqkTYzM5+BBdezA@mail.gmail.com>
In-Reply-To: <CAKwvOdnYTMzaahnBqdNYPz3KMdnkp=jZ4hxiqkTYzM5+BBdezA@mail.gmail.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Fri, 20 Nov 2020 08:23:11 -0800
Message-ID: <CABCJKucj_jUwoiLc35R7qFe+cNKTWgT+gsCa5pPiY66+1--3Lg@mail.gmail.com>
Subject: Re: [PATCH v7 02/17] kbuild: add support for Clang LTO
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Will Deacon <will@kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Kees Cook <keescook@chromium.org>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, Nov 18, 2020 at 3:49 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> On Wed, Nov 18, 2020 at 2:07 PM Sami Tolvanen <samitolvanen@google.com> wrote:
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
> > Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> > Reviewed-by: Kees Cook <keescook@chromium.org>
> > ---
> >  Makefile                          | 19 +++++++-
> >  arch/Kconfig                      | 75 +++++++++++++++++++++++++++++++
> >  include/asm-generic/vmlinux.lds.h | 11 +++--
> >  scripts/Makefile.build            |  9 +++-
> >  scripts/Makefile.modfinal         |  9 +++-
> >  scripts/Makefile.modpost          | 21 ++++++++-
> >  scripts/link-vmlinux.sh           | 32 +++++++++----
> >  7 files changed, 158 insertions(+), 18 deletions(-)
> >
> > diff --git a/Makefile b/Makefile
> > index 8c8feb4245a6..240560e88d69 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -893,6 +893,21 @@ KBUILD_CFLAGS      += $(CC_FLAGS_SCS)
> >  export CC_FLAGS_SCS
> >  endif
> >
> > +ifdef CONFIG_LTO_CLANG
> > +ifdef CONFIG_THINLTO
> > +CC_FLAGS_LTO   += -flto=thin -fsplit-lto-unit
> > +KBUILD_LDFLAGS += --thinlto-cache-dir=$(extmod-prefix).thinlto-cache
> > +else
> > +CC_FLAGS_LTO   += -flto
> > +endif
> > +CC_FLAGS_LTO   += -fvisibility=default
> > +endif
> > +
> > +ifdef CONFIG_LTO
> > +KBUILD_CFLAGS  += $(CC_FLAGS_LTO)
> > +export CC_FLAGS_LTO
> > +endif
> > +
> >  ifdef CONFIG_DEBUG_FORCE_FUNCTION_ALIGN_32B
> >  KBUILD_CFLAGS += -falign-functions=32
> >  endif
> > @@ -1473,7 +1488,7 @@ MRPROPER_FILES += include/config include/generated          \
> >                   *.spec
> >
> >  # Directories & files removed with 'make distclean'
> > -DISTCLEAN_FILES += tags TAGS cscope* GPATH GTAGS GRTAGS GSYMS
> > +DISTCLEAN_FILES += tags TAGS cscope* GPATH GTAGS GRTAGS GSYMS .thinlto-cache
> >
> >  # clean - Delete most, but leave enough to build external modules
> >  #
> > @@ -1719,7 +1734,7 @@ PHONY += compile_commands.json
> >
> >  clean-dirs := $(KBUILD_EXTMOD)
> >  clean: rm-files := $(KBUILD_EXTMOD)/Module.symvers $(KBUILD_EXTMOD)/modules.nsdeps \
> > -       $(KBUILD_EXTMOD)/compile_commands.json
> > +       $(KBUILD_EXTMOD)/compile_commands.json $(KBUILD_EXTMOD)/.thinlto-cache
> >
> >  PHONY += help
> >  help:
> > diff --git a/arch/Kconfig b/arch/Kconfig
> > index 56b6ccc0e32d..a41fcb3ca7c6 100644
> > --- a/arch/Kconfig
> > +++ b/arch/Kconfig
> > @@ -598,6 +598,81 @@ config SHADOW_CALL_STACK
> >           reading and writing arbitrary memory may be able to locate them
> >           and hijack control flow by modifying the stacks.
> >
> > +config LTO
> > +       bool
> > +
> > +config ARCH_SUPPORTS_LTO_CLANG
> > +       bool
> > +       help
> > +         An architecture should select this option if it supports:
> > +         - compiling with Clang,
> > +         - compiling inline assembly with Clang's integrated assembler,
> > +         - and linking with LLD.
> > +
> > +config ARCH_SUPPORTS_THINLTO
> > +       bool
> > +       help
> > +         An architecture should select this option if it supports Clang's
> > +         ThinLTO.
> > +
> > +config THINLTO
> > +       bool "Clang ThinLTO"
> > +       depends on LTO_CLANG && ARCH_SUPPORTS_THINLTO
> > +       default y
> > +       help
> > +         This option enables Clang's ThinLTO, which allows for parallel
> > +         optimization and faster incremental compiles. More information
> > +         can be found from Clang's documentation:
> > +
> > +           https://clang.llvm.org/docs/ThinLTO.html
> > +
> > +         If you say N here, the compiler will use full LTO, which may
> > +         produce faster code, but building the kernel will be significantly
> > +         slower as the linker won't efficiently utilize multiple threads.
> > +
> > +         If unsure, say Y.
>
> I think the order of these new configs makes it so that ThinLTO
> appears above LTO in menuconfig; I don't like that, and wish it came
> immediately after.  Does `THINLTO` have to be defined _after_ the
> choice for LTO_NONE/LTO_CLANG, perhaps?
>
> Secondly, I don't like how ThinLTO is a config and not a choice.  If I
> don't set ThinLTO, what am I getting?  That's a rhetorical question; I
> know its full LTO, and I guess the help text does talk about the
> tradeoffs and what you would get.  I guess what's curious to me is
> "why does it display ThinLTO? Why not FullLTO?"  I can't help but
> wonder if a kconfig `choice` rather than a `config` would be better
> here, that way it's more obvious the user is making a choice between
> ThinLTO vs Full LTO, rather than the current patches which look like
> "ThinkLTO on/off."

Changing the ThinLTO config to a choice and moving it after the main
LTO config sounds like a good idea to me. I'll see if I can change
this in v8. Thanks!

Sami
