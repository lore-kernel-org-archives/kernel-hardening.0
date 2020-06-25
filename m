Return-Path: <SRS0=DeTF=AG=lists.openwall.com=kernel-hardening-return-19165-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FFC0C433E0
	for <kernel-hardening@archiver.kernel.org>; Thu, 25 Jun 2020 16:14:08 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B2E412089D
	for <kernel-hardening@archiver.kernel.org>; Thu, 25 Jun 2020 16:14:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FNy/7DFb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B2E412089D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19165-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25915 invoked by uid 550); 25 Jun 2020 16:14:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25872 invoked from network); 25 Jun 2020 16:13:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tN3RRFkW8H40rA8SGu1JDOigZLSzT5qVO0+D16XtuLc=;
        b=FNy/7DFbxnBgI72+dWF1OpzoyRqVVhI3k7b313hoPAknwI2gtcpnrbI/QxduZaLChO
         XsS20NJXJUX+BgZZni3WHhBJhCOxGeey5qw4s+h96KkQc1DbqtdERktvlQbbWfMI5Qtj
         CMFRos0WWK71LdR3xO8mzueiOZZD/HrvnbZcL7TWPhuTj08pp29CzK2iwQtWYxS/KzPS
         DbZRhxXQXIM+BXTF2MYRYYBA9EL7Z4t+n9j3emOXcA8xRPQhjqftNQZaWno22ZXuxY9B
         OJCpp0YifwADaKWWU1uXVBh+ae7gxCNBEpNdOASG/NzMPjRUdcy8BrCxoR+02HHMW5zQ
         TEBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tN3RRFkW8H40rA8SGu1JDOigZLSzT5qVO0+D16XtuLc=;
        b=R+C5mcXq8cTwHWrlixgExlXHu4LaKYQdTG3qzd1FzIWUXZo3eLFEfHvrhn2hMmU4/y
         Nt/VKz4E8jnZ4YeCALsDDD4PQtVwd6V3dA8O/vwyc9wgdVjSuL0+YQVtNGniKUXvaPhl
         Dgy+h6tCi9TAjCakhADgtR3auglOeZvteUQXWevRt2N9UHFbklBkDcXD9oaKZyHqkv+m
         Vy2ZwA0VBUsjQuSZBDpqfDDvMHWYw158WOjmSthV5OvJa9z12sp4bpvsg+9w/4GMJO4w
         tjJ1rRTs05mxXjGcdqBtupzNoKdgjWKIMADCpV+paIyjkAQ2S5QG8qWEtRRT4QDi/OAv
         eI8w==
X-Gm-Message-State: AOAM530UomOM3ER5HcRV0jM5LKXDJmwV14VB8DwYE927YQ/AVsoo6ow7
	ZI0KmOG66n4Qt6VVLDr8MDiTVA==
X-Google-Smtp-Source: ABdhPJxZZxKF0/AUF+MScBXa8zZXuQ+lX7KkH7oqN3X8Y0ebQY5u9x4x5ou8dadW03hvgkUjiMZCBw==
X-Received: by 2002:a17:90a:7c4e:: with SMTP id e14mr4310401pjl.52.1593101626297;
        Thu, 25 Jun 2020 09:13:46 -0700 (PDT)
Date: Thu, 25 Jun 2020 09:13:39 -0700
From: Sami Tolvanen <samitolvanen@google.com>
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH 02/22] kbuild: add support for Clang LTO
Message-ID: <20200625161339.GA173089@google.com>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200624203200.78870-3-samitolvanen@google.com>
 <20200625022647.GB2871607@ubuntu-n2-xlarge-x86>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625022647.GB2871607@ubuntu-n2-xlarge-x86>

On Wed, Jun 24, 2020 at 07:26:47PM -0700, Nathan Chancellor wrote:
> Hi Sami,
> 
> On Wed, Jun 24, 2020 at 01:31:40PM -0700, 'Sami Tolvanen' via Clang Built Linux wrote:
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
> >  Makefile                          | 16 ++++++++
> >  arch/Kconfig                      | 66 +++++++++++++++++++++++++++++++
> >  include/asm-generic/vmlinux.lds.h | 11 ++++--
> >  scripts/Makefile.build            |  9 ++++-
> >  scripts/Makefile.modfinal         |  9 ++++-
> >  scripts/Makefile.modpost          | 24 ++++++++++-
> >  scripts/link-vmlinux.sh           | 32 +++++++++++----
> >  7 files changed, 151 insertions(+), 16 deletions(-)
> > 
> > diff --git a/Makefile b/Makefile
> > index ac2c61c37a73..0c7fe6fb2143 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -886,6 +886,22 @@ KBUILD_CFLAGS	+= $(CC_FLAGS_SCS)
> >  export CC_FLAGS_SCS
> >  endif
> >  
> > +ifdef CONFIG_LTO_CLANG
> > +ifdef CONFIG_THINLTO
> > +CC_FLAGS_LTO_CLANG := -flto=thin $(call cc-option, -fsplit-lto-unit)
> > +KBUILD_LDFLAGS	+= --thinlto-cache-dir=.thinlto-cache
> > +else
> > +CC_FLAGS_LTO_CLANG := -flto
> > +endif
> > +CC_FLAGS_LTO_CLANG += -fvisibility=default
> > +endif
> > +
> > +ifdef CONFIG_LTO
> > +CC_FLAGS_LTO	:= $(CC_FLAGS_LTO_CLANG)
> > +KBUILD_CFLAGS	+= $(CC_FLAGS_LTO)
> > +export CC_FLAGS_LTO
> > +endif
> > +
> >  # arch Makefile may override CC so keep this after arch Makefile is included
> >  NOSTDINC_FLAGS += -nostdinc -isystem $(shell $(CC) -print-file-name=include)
> >  
> > diff --git a/arch/Kconfig b/arch/Kconfig
> > index 8cc35dc556c7..e00b122293f8 100644
> > --- a/arch/Kconfig
> > +++ b/arch/Kconfig
> > @@ -552,6 +552,72 @@ config SHADOW_CALL_STACK
> >  	  reading and writing arbitrary memory may be able to locate them
> >  	  and hijack control flow by modifying the stacks.
> >  
> > +config LTO
> > +	bool
> > +
> > +config ARCH_SUPPORTS_LTO_CLANG
> > +	bool
> > +	help
> > +	  An architecture should select this option if it supports:
> > +	  - compiling with Clang,
> > +	  - compiling inline assembly with Clang's integrated assembler,
> > +	  - and linking with LLD.
> > +
> > +config ARCH_SUPPORTS_THINLTO
> > +	bool
> > +	help
> > +	  An architecture should select this option if it supports Clang's
> > +	  ThinLTO.
> > +
> > +config THINLTO
> > +	bool "Clang ThinLTO"
> > +	depends on LTO_CLANG && ARCH_SUPPORTS_THINLTO
> > +	default y
> > +	help
> > +	  This option enables Clang's ThinLTO, which allows for parallel
> > +	  optimization and faster incremental compiles. More information
> > +	  can be found from Clang's documentation:
> > +
> > +	    https://clang.llvm.org/docs/ThinLTO.html
> > +
> > +choice
> > +	prompt "Link Time Optimization (LTO)"
> > +	default LTO_NONE
> > +	help
> > +	  This option enables Link Time Optimization (LTO), which allows the
> > +	  compiler to optimize binaries globally.
> > +
> > +	  If unsure, select LTO_NONE.
> > +
> > +config LTO_NONE
> > +	bool "None"
> > +
> > +config LTO_CLANG
> > +	bool "Clang's Link Time Optimization (EXPERIMENTAL)"
> > +	depends on CC_IS_CLANG && CLANG_VERSION >= 110000 && LD_IS_LLD
> 
> I am curious, what is the reason for gating this at clang 11.0.0?
> 
> Presumably this? https://github.com/ClangBuiltLinux/linux/issues/510
> 
> It might be nice to notate this so that we do not have to wonder :)

Yes, that's the reason. I'll add a note about it. Thanks!

Sami
