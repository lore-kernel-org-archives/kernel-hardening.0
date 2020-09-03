Return-Path: <SRS0=dByH=CM=lists.openwall.com=kernel-hardening-return-19757-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62360C43461
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 22:09:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AD28B2078E
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 22:09:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="RMbQl2aW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD28B2078E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19757-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24106 invoked by uid 550); 3 Sep 2020 22:09:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24074 invoked from network); 3 Sep 2020 22:09:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1TFkAeGi9KR3Vg+6dLLM1QKXoNn5coQYzJIjZ0tVjI0=;
        b=RMbQl2aWLhRmRg/xlWTquty6EAETDxVrOPrJsvxj3D3ziQggwm1LR9Z+7lvF/RBSAh
         rdDSpm9JIeEpDa886F9HHLV4dstrmldnU0gSRqvqiZwoQrPW2lTBh5oU/X/4TrS8pCra
         DV/jID9deoswwRtNn+Jy77/ci1g1OxqByrPxs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1TFkAeGi9KR3Vg+6dLLM1QKXoNn5coQYzJIjZ0tVjI0=;
        b=dtb4LXslmw6veyGYn+ZS9VaOD3zwxJj5wISYD4x8LFFMyGbimFHUaTUadjEY7KOFGs
         uCDJ50/pDi4zk/L5u1fliTVoJ9chhW09Eg+pjYIhEDtAJF4RhHSdB6gkNEiPlzjGBuo8
         56hEoBTJgQte64gadbwwsd6WzMxFtbFf0HIdpDIdKjJHAwl//Xq/rzl/doYCDCgo3u/L
         0EPW8Bcci5KdoU9ZDsYuC35w+N0crgUSRrsmkb/HT8roxyBVBJHIwNN5B1GEfDveOw4W
         WJV/LdaGCuMylnzWlhcjrnlJNVrlaEPnK6vEzb7UtI44NaxANtfscLhV1aGz27GJ2De+
         7xIQ==
X-Gm-Message-State: AOAM5325dqvSBhJafXuXgNAtGHaY4pOQFeOIdTdUShmhivE3xtdCyNoO
	Zpa7h12sByBSuaqIMeA5i7r+Xw==
X-Google-Smtp-Source: ABdhPJxtv6qZk8AFQNSEBhXOHhLxWmSvOpKmtDAl4TWDKr3eiSBk8TPdIQLGddmagxPcGUhPAwGmGg==
X-Received: by 2002:aa7:925a:: with SMTP id 26mr5953492pfp.6.1599170941115;
        Thu, 03 Sep 2020 15:09:01 -0700 (PDT)
Date: Thu, 3 Sep 2020 15:08:59 -0700
From: Kees Cook <keescook@chromium.org>
To: Sami Tolvanen <samitolvanen@google.com>
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
Message-ID: <202009031504.07098D6F8@keescook>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <20200903203053.3411268-10-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903203053.3411268-10-samitolvanen@google.com>

On Thu, Sep 03, 2020 at 01:30:34PM -0700, Sami Tolvanen wrote:
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

I remain crazy excited about being able to use this in upstream. :)

The only suggestion I have here, if it might help with clarity, would be
to remove DISABLE_LTO globally as a separate patch, since it's entirely
unused in the kernel right now. This series removes it as it goes, which
I think is fine, but it might cause some reviewers to ponder "what's
this DISABLE_LTO thing? Don't we need that?" without realizing currently
unused in the kernel.

I'm glad to see the general CONFIG_LTO, as I think it should be easy for
GCC LTO support to get added when someone steps up to do it. The bulk of
the changed needed to support GCC LTO are part of this series already,
since the build problems involving non-ELF .o files and init ordering
are shared by Clang and GCC AFAICT.

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
