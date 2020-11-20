Return-Path: <SRS0=Dp8k=E2=lists.openwall.com=kernel-hardening-return-20440-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE17AC5519F
	for <kernel-hardening@archiver.kernel.org>; Fri, 20 Nov 2020 23:59:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CC36C2242A
	for <kernel-hardening@archiver.kernel.org>; Fri, 20 Nov 2020 23:59:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="EnMit/LS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC36C2242A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20440-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24348 invoked by uid 550); 20 Nov 2020 23:59:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24326 invoked from network); 20 Nov 2020 23:59:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jBGijJIY6Z+oa+4qlAfyy6WPNwc/Uit7UWvV3O3C13o=;
        b=EnMit/LSqllcllZ3eo2MUQHxhmoJn+/noatv+OSr2NnhmqUwBuwZ8MLT0Y0eDx9Qyc
         +V3TQCz2Q5XQ+93j0mZJpr6cgSGKcAJaf9fed/SV1yOMK2rloi1IxxxprgLP/Frr97qL
         567ewue2XpdI+/74TjYZ4dRhZ+f0cL1Fkqqpo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jBGijJIY6Z+oa+4qlAfyy6WPNwc/Uit7UWvV3O3C13o=;
        b=rZJwJlJWQVOEGchaHn5yZ/vx+VygW7g0IaQSWZfcp7NaNYAK16jqW7fPm2iosHAF3O
         50ypuF5iBJ685+JvMs17OhE7YfBRQSo/tOtDjRoYuRt6dGRInT3yMWCwBz7oh+vYreh5
         7ritWmMGh14SPoPAzuoFZqctoSEH0rJZdYN3Bf/MUBVKB84sKViKNuH20974yMu+JIiC
         EkNWXuWRGWjRZDhaqlk6s1Hfxw9C+uJbtwq/2CmcdzU20jTfK74CN43JqciqtbJB7l7f
         Dp87R8YbW4FH/zyWWpIPRNih5623RUHhJNrLL+eM3YSN2VxxRVxtsN5VSWxUEc68b4T0
         B8WQ==
X-Gm-Message-State: AOAM531TIMNMBLZPNQcUTE1C4onCdliOOP+AicGZcyI/nrTwEjG18XpC
	y7cRRagxxqyYKAd/uvKOi+4Ryw==
X-Google-Smtp-Source: ABdhPJwINZgrcgr/0mqpYj168NJb0A8eAVUPoNMIidZ14BcDQ0ir2/tk9jpwBITAPhghCkl/yMjHaA==
X-Received: by 2002:aa7:9ddb:0:b029:18b:396b:70a3 with SMTP id g27-20020aa79ddb0000b029018b396b70a3mr16223347pfq.3.1605916771276;
        Fri, 20 Nov 2020 15:59:31 -0800 (PST)
Date: Fri, 20 Nov 2020 15:59:28 -0800
From: Kees Cook <keescook@chromium.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Nathan Chancellor <natechancellor@gmail.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arch <linux-arch@vger.kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH v7 02/17] kbuild: add support for Clang LTO
Message-ID: <202011201556.3B910EF@keescook>
References: <20201118220731.925424-1-samitolvanen@google.com>
 <20201118220731.925424-3-samitolvanen@google.com>
 <CAKwvOdnYTMzaahnBqdNYPz3KMdnkp=jZ4hxiqkTYzM5+BBdezA@mail.gmail.com>
 <CABCJKucj_jUwoiLc35R7qFe+cNKTWgT+gsCa5pPiY66+1--3Lg@mail.gmail.com>
 <202011201144.3F2BB70C@keescook>
 <20201120202935.GA1220359@ubuntu-m3-large-x86>
 <202011201241.B159562D7@keescook>
 <CABCJKucJ87wa73YJkN_dYUyE7foQT+12gdWJZw1PgZ_decFr4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABCJKucJ87wa73YJkN_dYUyE7foQT+12gdWJZw1PgZ_decFr4w@mail.gmail.com>

On Fri, Nov 20, 2020 at 12:58:41PM -0800, Sami Tolvanen wrote:
> On Fri, Nov 20, 2020 at 12:43 PM Kees Cook <keescook@chromium.org> wrote:
> >
> > On Fri, Nov 20, 2020 at 01:29:35PM -0700, Nathan Chancellor wrote:
> > > On Fri, Nov 20, 2020 at 11:47:21AM -0800, Kees Cook wrote:
> > > > On Fri, Nov 20, 2020 at 08:23:11AM -0800, Sami Tolvanen wrote:
> > > > > Changing the ThinLTO config to a choice and moving it after the main
> > > > > LTO config sounds like a good idea to me. I'll see if I can change
> > > > > this in v8. Thanks!
> > > >
> > > > Originally, I thought this might be a bit ugly once GCC LTO is added,
> > > > but this could be just a choice like we're done for the stack
> > > > initialization. Something like an "LTO" choice of NONE, CLANG_FULL,
> > > > CLANG_THIN, and in the future GCC, etc.
> > >
> > > Having two separate choices might be a little bit cleaner though? One
> > > for the compiler (LTO_CLANG versus LTO_GCC) and one for the type
> > > (THINLTO versus FULLLTO). The type one could just have a "depends on
> > > CC_IS_CLANG" to ensure it only showed up when needed.
> >
> > Right, that's how the stack init choice works. Kconfigs that aren't
> > supported by the compiler won't be shown. I.e. after Sami's future
> > patch, the only choice for GCC will be CONFIG_LTO_NONE. But building
> > under Clang, it would offer CONFIG_LTO_NONE, CONFIG_LTO_CLANG_FULL,
> > CONFIG_LTO_CLANG_THIN, or something.
> >
> > (and I assume  CONFIG_LTO would be def_bool y, depends on !LTO_NONE)
> 
> I'm fine with adding ThinLTO as another option to the LTO choice, but
> it would duplicate the dependencies and a lot of the help text. I
> suppose we could add another config for the dependencies and have both
> LTO options depend on that instead.

How about something like this? This separates the arch support, compiler
support, and user choice into three separate Kconfig areas, which I
think should work.


diff --git a/Makefile b/Makefile
index e397c4caec1b..af902718e882 100644
--- a/Makefile
+++ b/Makefile
@@ -897,7 +897,7 @@ export CC_FLAGS_SCS
 endif
 
 ifdef CONFIG_LTO_CLANG
-ifdef CONFIG_THINLTO
+ifdef CONFIG_LTO_CLANG_THIN
 CC_FLAGS_LTO	+= -flto=thin -fsplit-lto-unit
 KBUILD_LDFLAGS	+= --thinlto-cache-dir=$(extmod-prefix).thinlto-cache
 else
diff --git a/arch/Kconfig b/arch/Kconfig
index cdd29b5fdb56..5c22e10e4c12 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -600,6 +600,14 @@ config SHADOW_CALL_STACK
 
 config LTO
 	bool
+	help
+	  Selected if the kernel will be built using the compiler's LTO feature.
+
+config LTO_CLANG
+	bool
+	select LTO
+	help
+	  Selected if the kernel will be built using Clang's LTO feature.
 
 config ARCH_SUPPORTS_LTO_CLANG
 	bool
@@ -609,28 +617,25 @@ config ARCH_SUPPORTS_LTO_CLANG
 	  - compiling inline assembly with Clang's integrated assembler,
 	  - and linking with LLD.
 
-config ARCH_SUPPORTS_THINLTO
+config ARCH_SUPPORTS_LTO_CLANG_THIN
 	bool
 	help
-	  An architecture should select this option if it supports Clang's
-	  ThinLTO.
+	  An architecture should select this option if it can supports Clang's
+	  ThinLTO mode.
 
-config THINLTO
-	bool "Clang ThinLTO"
-	depends on LTO_CLANG && ARCH_SUPPORTS_THINLTO
-	default y
+config HAS_LTO_CLANG
+	def_bool y
+	# Clang >= 11: https://github.com/ClangBuiltLinux/linux/issues/510
+	depends on CC_IS_CLANG && CLANG_VERSION >= 110000 && LD_IS_LLD
+	depends on $(success,$(NM) --help | head -n 1 | grep -qi llvm)
+	depends on $(success,$(AR) --help | head -n 1 | grep -qi llvm)
+	depends on ARCH_SUPPORTS_LTO_CLANG
+	depends on !FTRACE_MCOUNT_USE_RECORDMCOUNT
+	depends on !KASAN
+	depends on !GCOV_KERNEL
 	help
-	  This option enables Clang's ThinLTO, which allows for parallel
-	  optimization and faster incremental compiles. More information
-	  can be found from Clang's documentation:
-
-	    https://clang.llvm.org/docs/ThinLTO.html
-
-	  If you say N here, the compiler will use full LTO, which may
-	  produce faster code, but building the kernel will be significantly
-	  slower as the linker won't efficiently utilize multiple threads.
-
-	  If unsure, say Y.
+	  The compiler and Kconfig options support building with Clang's
+	  LTO.
 
 choice
 	prompt "Link Time Optimization (LTO)"
@@ -644,20 +649,14 @@ choice
 
 config LTO_NONE
 	bool "None"
+	help
+	  Build the kernel normally, without Link Time Optimization (LTO).
 
-config LTO_CLANG
-	bool "Clang's Link Time Optimization (EXPERIMENTAL)"
-	# Clang >= 11: https://github.com/ClangBuiltLinux/linux/issues/510
-	depends on CC_IS_CLANG && CLANG_VERSION >= 110000 && LD_IS_LLD
-	depends on $(success,$(NM) --help | head -n 1 | grep -qi llvm)
-	depends on $(success,$(AR) --help | head -n 1 | grep -qi llvm)
-	depends on ARCH_SUPPORTS_LTO_CLANG
-	depends on !FTRACE_MCOUNT_USE_RECORDMCOUNT
-	depends on !KASAN
-	depends on !GCOV_KERNEL
-	select LTO
+config LTO_CLANG_FULL
+	bool "Clang Full LTO (EXPERIMENTAL)"
+	select LTO_CLANG
 	help
-          This option enables Clang's Link Time Optimization (LTO), which
+          This option enables Clang's full Link Time Optimization (LTO), which
           allows the compiler to optimize the kernel globally. If you enable
           this option, the compiler generates LLVM bitcode instead of ELF
           object files, and the actual compilation from bitcode happens at
@@ -667,9 +666,22 @@ config LTO_CLANG
 
 	    https://llvm.org/docs/LinkTimeOptimization.html
 
-	  To select this option, you also need to use LLVM tools to handle
-	  the bitcode by passing LLVM=1 to make.
+	  During link time, this option can use a large amount of RAM, and
+	  may take much longer than the ThinLTO option.
 
+config LTO_CLANG_THIN
+	bool "Clang ThinLTO (EXPERIMENTAL)"
+	depends on ARCH_SUPPORTS_LTO_CLANG_THIN
+	select LTO_CLANG
+	help
+	  This option enables Clang's ThinLTO, which allows for parallel
+	  optimization and faster incremental compiles compared to the
+	  CONFIG_LTO_CLANG_FULL option. More information can be found
+	  from Clang's documentation:
+
+	    https://clang.llvm.org/docs/ThinLTO.html
+
+	  If unsure, say Y.
 endchoice
 
 config CFI_CLANG
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 8bf763307544..f39df315316e 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -74,7 +74,7 @@ config ARM64
 	select ARCH_SUPPORTS_MEMORY_FAILURE
 	select ARCH_SUPPORTS_SHADOW_CALL_STACK if CC_HAVE_SHADOW_CALL_STACK
 	select ARCH_SUPPORTS_LTO_CLANG
-	select ARCH_SUPPORTS_THINLTO
+	select ARCH_SUPPORTS_LTO_CLANG_THIN
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128 && (GCC_VERSION >= 50000 || CC_IS_CLANG)
 	select ARCH_SUPPORTS_NUMA_BALANCING
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cb4c77a9b5ab..f99a4d3b55ae 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -93,7 +93,7 @@ config X86
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_SUPPORTS_NUMA_BALANCING	if X86_64
 	select ARCH_SUPPORTS_LTO_CLANG		if X86_64
-	select ARCH_SUPPORTS_THINLTO		if X86_64
+	select ARCH_SUPPORTS_LTO_CLANG_THIN	if X86_64
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_QUEUED_RWLOCKS
 	select ARCH_USE_QUEUED_SPINLOCKS
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 3106636375c0..96505113b907 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -161,7 +161,7 @@ static unsigned long kallsyms_sym_address(int idx)
 	return kallsyms_relative_base - 1 - kallsyms_offsets[idx];
 }
 
-#if defined(CONFIG_CFI_CLANG) && defined(CONFIG_THINLTO)
+#if defined(CONFIG_CFI_CLANG) && defined(CONFIG_LTO_CLANG_THIN)
 /*
  * LLVM appends a hash to static function names when ThinLTO and CFI are
  * both enabled, which causes confusion and potentially breaks user space

-- 
Kees Cook
