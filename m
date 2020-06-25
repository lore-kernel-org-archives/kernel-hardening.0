Return-Path: <SRS0=j74A=AG=lists.openwall.com=kernel-hardening-return-19158-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6062EC433E0
	for <kernel-hardening@archiver.kernel.org>; Thu, 25 Jun 2020 05:36:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 86C2120720
	for <kernel-hardening@archiver.kernel.org>; Thu, 25 Jun 2020 05:36:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AZcqU08v"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 86C2120720
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19158-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27681 invoked by uid 550); 25 Jun 2020 05:36:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27652 invoked from network); 25 Jun 2020 02:27:01 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZQNZYHZs3Rf5u37OLrL6y0pvgTgU4h8M5jVmsv5Nrec=;
        b=AZcqU08vwZw9lrCsZsKBlLyXkNyZa4Z91/EmPbGeOoW2ao/UQMOSfq81bN29+UrCso
         7XPCJ68zo766UgdGF3xas4X6/4NGojSucMUgoIYWA6qPtQ80X69hWEj5o2B37QuhSRyy
         p3T5MPqVetLqV6OVPTWY3BhiYkewqHCVhjDURFb/o2OBxrl4wtZ70UcwJ6PC2x35PBHU
         a+5QytEgeiUH6+TzQCmECEq9Gjrx76ilvOkvVCK2qPGIbt8zlhiBAAvrmfbAx2O7mbJe
         QlK6xMcNBCWbtNdDmUQ+DHQHM9dT2zR7aGR7uZ05zx+3QEHSIhDQ9TVdZSL7xdC/foKW
         khWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZQNZYHZs3Rf5u37OLrL6y0pvgTgU4h8M5jVmsv5Nrec=;
        b=k9eqHtNHDhUaQ+WSxCfOpL+QPSKFBfIlAHogSBjPExsADk4TBCSo5n6AKb2v9oO8V9
         xFYVvEXh6eA59IqZb+21DtMhFzkqYd5VecFnYmRvFvvJSLQLcS2pukEXdsVdELFBUOFE
         d+7tU0zevv18LHseRQ1Rpo/D3Xju+D53/38kYdcXiYbtKmLoVSCJM+xGM0n1O5HzxmNu
         afj4aCfAIEMtqYynbAQgSJkx6tcPRSl6KQpv1TYy4EB/4UL9Ex0UQ/7AityZZLWiDMrD
         ih/IQ5EyXyni5DBSa4ogt1TTiFbpUtMKMq7nxZUTRtS7AyMH2QI03RkjKvnUl6WbRAnL
         gNug==
X-Gm-Message-State: AOAM530W+vOmw9nh3pD2DzHMQbkAkep1VcnnSFEqKqkugilO39G5fR1K
	EkCwNuoxiW443tycll0H0jI=
X-Google-Smtp-Source: ABdhPJw1AzgRgryeo1cu/6FpvQVFO+54yG3gpbWyWO2n0QHC6FG7I1bntUQA1AKQNkHP8ISfYtWv5g==
X-Received: by 2002:a9d:32a1:: with SMTP id u30mr5549372otb.264.1593052009657;
        Wed, 24 Jun 2020 19:26:49 -0700 (PDT)
Date: Wed, 24 Jun 2020 19:26:47 -0700
From: Nathan Chancellor <natechancellor@gmail.com>
To: Sami Tolvanen <samitolvanen@google.com>
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
Message-ID: <20200625022647.GB2871607@ubuntu-n2-xlarge-x86>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200624203200.78870-3-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624203200.78870-3-samitolvanen@google.com>

Hi Sami,

On Wed, Jun 24, 2020 at 01:31:40PM -0700, 'Sami Tolvanen' via Clang Built Linux wrote:
> This change adds build system support for Clang's Link Time
> Optimization (LTO). With -flto, instead of ELF object files, Clang
> produces LLVM bitcode, which is compiled into native code at link
> time, allowing the final binary to be optimized globally. For more
> details, see:
> 
>   https://llvm.org/docs/LinkTimeOptimization.html
> 
> The Kconfig option CONFIG_LTO_CLANG is implemented as a choice,
> which defaults to LTO being disabled. To use LTO, the architecture
> must select ARCH_SUPPORTS_LTO_CLANG and support:
> 
>   - compiling with Clang,
>   - compiling inline assembly with Clang's integrated assembler,
>   - and linking with LLD.
> 
> While using full LTO results in the best runtime performance, the
> compilation is not scalable in time or memory. CONFIG_THINLTO
> enables ThinLTO, which allows parallel optimization and faster
> incremental builds. ThinLTO is used by default if the architecture
> also selects ARCH_SUPPORTS_THINLTO:
> 
>   https://clang.llvm.org/docs/ThinLTO.html
> 
> To enable LTO, LLVM tools must be used to handle bitcode files. The
> easiest way is to pass the LLVM=1 option to make:
> 
>   $ make LLVM=1 defconfig
>   $ scripts/config -e LTO_CLANG
>   $ make LLVM=1
> 
> Alternatively, at least the following LLVM tools must be used:
> 
>   CC=clang LD=ld.lld AR=llvm-ar NM=llvm-nm
> 
> To prepare for LTO support with other compilers, common parts are
> gated behind the CONFIG_LTO option, and LTO can be disabled for
> specific files by filtering out CC_FLAGS_LTO.
> 
> Note that support for DYNAMIC_FTRACE and MODVERSIONS are added in
> follow-up patches.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> ---
>  Makefile                          | 16 ++++++++
>  arch/Kconfig                      | 66 +++++++++++++++++++++++++++++++
>  include/asm-generic/vmlinux.lds.h | 11 ++++--
>  scripts/Makefile.build            |  9 ++++-
>  scripts/Makefile.modfinal         |  9 ++++-
>  scripts/Makefile.modpost          | 24 ++++++++++-
>  scripts/link-vmlinux.sh           | 32 +++++++++++----
>  7 files changed, 151 insertions(+), 16 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index ac2c61c37a73..0c7fe6fb2143 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -886,6 +886,22 @@ KBUILD_CFLAGS	+= $(CC_FLAGS_SCS)
>  export CC_FLAGS_SCS
>  endif
>  
> +ifdef CONFIG_LTO_CLANG
> +ifdef CONFIG_THINLTO
> +CC_FLAGS_LTO_CLANG := -flto=thin $(call cc-option, -fsplit-lto-unit)
> +KBUILD_LDFLAGS	+= --thinlto-cache-dir=.thinlto-cache
> +else
> +CC_FLAGS_LTO_CLANG := -flto
> +endif
> +CC_FLAGS_LTO_CLANG += -fvisibility=default
> +endif
> +
> +ifdef CONFIG_LTO
> +CC_FLAGS_LTO	:= $(CC_FLAGS_LTO_CLANG)
> +KBUILD_CFLAGS	+= $(CC_FLAGS_LTO)
> +export CC_FLAGS_LTO
> +endif
> +
>  # arch Makefile may override CC so keep this after arch Makefile is included
>  NOSTDINC_FLAGS += -nostdinc -isystem $(shell $(CC) -print-file-name=include)
>  
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 8cc35dc556c7..e00b122293f8 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -552,6 +552,72 @@ config SHADOW_CALL_STACK
>  	  reading and writing arbitrary memory may be able to locate them
>  	  and hijack control flow by modifying the stacks.
>  
> +config LTO
> +	bool
> +
> +config ARCH_SUPPORTS_LTO_CLANG
> +	bool
> +	help
> +	  An architecture should select this option if it supports:
> +	  - compiling with Clang,
> +	  - compiling inline assembly with Clang's integrated assembler,
> +	  - and linking with LLD.
> +
> +config ARCH_SUPPORTS_THINLTO
> +	bool
> +	help
> +	  An architecture should select this option if it supports Clang's
> +	  ThinLTO.
> +
> +config THINLTO
> +	bool "Clang ThinLTO"
> +	depends on LTO_CLANG && ARCH_SUPPORTS_THINLTO
> +	default y
> +	help
> +	  This option enables Clang's ThinLTO, which allows for parallel
> +	  optimization and faster incremental compiles. More information
> +	  can be found from Clang's documentation:
> +
> +	    https://clang.llvm.org/docs/ThinLTO.html
> +
> +choice
> +	prompt "Link Time Optimization (LTO)"
> +	default LTO_NONE
> +	help
> +	  This option enables Link Time Optimization (LTO), which allows the
> +	  compiler to optimize binaries globally.
> +
> +	  If unsure, select LTO_NONE.
> +
> +config LTO_NONE
> +	bool "None"
> +
> +config LTO_CLANG
> +	bool "Clang's Link Time Optimization (EXPERIMENTAL)"
> +	depends on CC_IS_CLANG && CLANG_VERSION >= 110000 && LD_IS_LLD

I am curious, what is the reason for gating this at clang 11.0.0?

Presumably this? https://github.com/ClangBuiltLinux/linux/issues/510

It might be nice to notate this so that we do not have to wonder :)

Cheers,
Nathan
