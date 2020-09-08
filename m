Return-Path: <SRS0=GHWP=CR=lists.openwall.com=kernel-hardening-return-19818-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5932C433E2
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Sep 2020 17:03:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C34D62087C
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Sep 2020 17:03:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pKJ8j7uK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C34D62087C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19818-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7812 invoked by uid 550); 8 Sep 2020 17:03:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7780 invoked from network); 8 Sep 2020 17:03:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TS+pFAf+gXvyICCIZ7exDi0/Gxg54q8UJXDvRO7l168=;
        b=pKJ8j7uKJcb7uVWaQ5j/SnvkaAx4KCY55KCie8OQaygCpy1OPF8cDgeNH1qrPaLMvG
         8srfgOOgbosqJmTceeQvjWZChA+6j/LEIRcay7cMsXtBzLKxqoBwUcyD/WziBOgMhTht
         H95mhfOyXrIvUmREbH1YWzNRx8qhfoLUnK6vxg72nBJz4Zsryt8ZJJ5SgRHKxhMkN6NG
         dtOewrVFqRwrzOeM6o0lzzlRd9V3/io+BfvvategCuZpFKOLhdC7d/WJPglYjH7skxA9
         mFBhEsZ3kh8WuUPDicHPjHktAGiGpoaEUWzf67bzqCSOGx192KG66jA3O0NwWTFIar6q
         WtYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TS+pFAf+gXvyICCIZ7exDi0/Gxg54q8UJXDvRO7l168=;
        b=U0+B6qZ6KFees/JeZIQfnm82Knko6Q1fN+Y2UoN6CEuGAiu4pPU5PJILpRddSacmIH
         e/95hFPGoIcRDNh92oz1RqcBGB7ns5KZGZnvc4l329vARzNa7ISq/fzjfzgv3GfIEenn
         dFeb6Hsc+y8gQSx583rz3akEfaufWzMtIZYyzMNLtcqkkMykWrYqYwIbRFEVfyRPhstM
         ZrvJdfN1s3MHyS+M1bkQpU88iiYyOMlyo5iR7J2KEOCeK9MdRMr7UiyW/AvUOnxwLy64
         dx/YLRCFRVJ10nrX2od0K1akLrcw5TikebciA9KdQyL2Fm6yzZ0IxrYtzLeRgYv4EBw/
         l9bw==
X-Gm-Message-State: AOAM531nm9rzbDY5V0w4AB0JO1V41bdoBv//Oev6v9uqGFGL4bdsbkB0
	akCOJCKyJBflHsiPOaUCj/xQvA==
X-Google-Smtp-Source: ABdhPJypTa9m8baYyH7KtZLmA6Dhp5bWpLPg7YpbRm1G9HK65/WnGTkmsSsfgelDtI+oA1WrmQRR/g==
X-Received: by 2002:a17:902:d714:b029:d0:cbe1:e738 with SMTP id w20-20020a170902d714b02900d0cbe1e738mr2106530ply.19.1599584582581;
        Tue, 08 Sep 2020 10:03:02 -0700 (PDT)
Date: Tue, 8 Sep 2020 10:02:56 -0700
From: Sami Tolvanen <samitolvanen@google.com>
To: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH v2 09/28] kbuild: add support for Clang LTO
Message-ID: <20200908170256.GA2743468@google.com>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <20200903203053.3411268-10-samitolvanen@google.com>
 <202009031504.07098D6F8@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202009031504.07098D6F8@keescook>

On Thu, Sep 03, 2020 at 03:08:59PM -0700, Kees Cook wrote:
> On Thu, Sep 03, 2020 at 01:30:34PM -0700, Sami Tolvanen wrote:
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
> 
> I remain crazy excited about being able to use this in upstream. :)
> 
> The only suggestion I have here, if it might help with clarity, would be
> to remove DISABLE_LTO globally as a separate patch, since it's entirely
> unused in the kernel right now. This series removes it as it goes, which
> I think is fine, but it might cause some reviewers to ponder "what's
> this DISABLE_LTO thing? Don't we need that?" without realizing currently
> unused in the kernel.

Sure, that makes sense. I'll add a patch to remove DISABLE_LTO treewide
in v3.

Sami
