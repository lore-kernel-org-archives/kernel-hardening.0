Return-Path: <SRS0=8LvC=CR=lists.openwall.com=kernel-hardening-return-19819-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 552CBC43461
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Sep 2020 17:11:19 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 71EBC20732
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Sep 2020 17:11:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EDOnxu3/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 71EBC20732
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19819-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 12036 invoked by uid 550); 8 Sep 2020 17:11:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 12004 invoked from network); 8 Sep 2020 17:11:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+LDeT2lt9SUcFTCT7BGDtz2er/OFG3MBH42fF3G6h68=;
        b=EDOnxu3/tWXDEbO6aDonCpKCXjFECgrh/c5YRnWtoQ+SHvbswr+J9cGbiv4XUvNfrd
         Em65A52BYE3J8f195qPDI06udLHV8qdKzyftN/XsuICT3JOpkkrJjXA8SwRBW6SJFwIJ
         EzxA2KlhnfS8sc+kRLjxSmT8aJqg9Kgl+vhsMjNmF1fUU2hFGI+XhHju5+YlFt8CwMyV
         icqzwB0Hg81zggur22jiAbr8aGH6mP0aCauFgvoMG6dJURct0IpkkJdXcpVm7v0ecqQb
         mRk0w7ZSMxbIICPrnpndkBSn/Os7FI8G732QR5xMmeo6/XrIMdRBOK6LfscZl2uqp309
         p9Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+LDeT2lt9SUcFTCT7BGDtz2er/OFG3MBH42fF3G6h68=;
        b=XGi/VlSXHrWnxcrqmjLBZYlpDzMVGXAoXvp6CGAlMtU04Ijq0Fypp79NWZPJRK7O4Y
         KCyOutfgjNXaT3TCTHa0FPcpzVvr8S27z25/rkF5rZY67ZA29xSEQ3rnOzZ1X/Ig80+M
         GsRq/xFILtJ6eZdmlaQd3Y7a5F477GydseGNDPZV+QTXp4f9NmWe7iOkToV/RDuJs2m2
         wmXeGYb4Taqys+tlp7Af+LklW3ZZzlhVvUPhRtkZmc0cwgYdDh4r/vqeOjCNWvYpGNYu
         H8jpUDJ1vUWXEDEKxub1UDeyBYGc22JEBWbVPIl0mMaosy9cA7x30xLBPBMU/d01dcJz
         r0zw==
X-Gm-Message-State: AOAM531Bu+eANPQzL0AaK7z8wF7dV3GvKptCCxhbDIBLc3qXrPGifkdA
	bRGeAp2aDGmnxlXjY+fvYnMaqQ==
X-Google-Smtp-Source: ABdhPJzypUk2kaMSsozZWu2eOHXNN4ZkXvherqbpQHodcqeZRg4Fd5ulTMlytF6eoxCVBPUWtIX41g==
X-Received: by 2002:a62:3812:0:b029:13e:d13d:a062 with SMTP id f18-20020a6238120000b029013ed13da062mr30916pfa.40.1599585058742;
        Tue, 08 Sep 2020 10:10:58 -0700 (PDT)
Date: Tue, 8 Sep 2020 10:10:52 -0700
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
Message-ID: <20200908171052.GB2743468@google.com>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <20200903203053.3411268-10-samitolvanen@google.com>
 <CAK7LNAQ40LGvfjca9DASXjyUgRbjFNDWZXgFtMXJ54Xmi6vwkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK7LNAQ40LGvfjca9DASXjyUgRbjFNDWZXgFtMXJ54Xmi6vwkg@mail.gmail.com>

On Sun, Sep 06, 2020 at 04:36:32AM +0900, Masahiro Yamada wrote:
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
> > which defaults to LTO being disabled.
> 
> What is the reason for doing this in a choice?
> To turn off LTO_CLANG for compile-testing?
> 
> I would rather want to give LTO_CLANG more chances
> to be enabled/tested.

It's a choice to prevent LTO from being enabled by default with
allyesconfig and allmodconfig. It would take hours to build these even on a
fast computer, and probably days on older hardware.

> > +ifdef CONFIG_LTO_CLANG
> > +ifdef CONFIG_THINLTO
> > +CC_FLAGS_LTO_CLANG := -flto=thin -fsplit-lto-unit
> > +KBUILD_LDFLAGS += --thinlto-cache-dir=.thinlto-cache
> 
> 
> I think this would break external module builds
> because it would create cache files in the
> kernel source tree.
> 
> External module builds should never ever touch
> the kernel tree, which is usually located under
> the read-only /usr/src/ in distros.
> 
> 
> .thinlto-cache should be created in the module tree
> when it is built with M=.

Thanks for pointing this out, I'll fix the path in v3.

> >  # Directories & files removed with 'make distclean'
> > -DISTCLEAN_FILES += tags TAGS cscope* GPATH GTAGS GRTAGS GSYMS
> > +DISTCLEAN_FILES += tags TAGS cscope* GPATH GTAGS GRTAGS GSYMS .thinlto-cache
> 
> 
> 
> This was suggested in v1, but I could not understand
> why doing this in distclean was appropriate.
> 
> Is keeping cache files of kernel objects
> useful for external module builds?

No, the cache only speeds up incremental kernel builds.

> Also, please clean up .thinlto-cache for external module builds.

Ack.

Sami
