Return-Path: <SRS0=hull=E2=lists.openwall.com=kernel-hardening-return-20436-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A44D4C56202
	for <kernel-hardening@archiver.kernel.org>; Fri, 20 Nov 2020 20:43:37 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5B95422470
	for <kernel-hardening@archiver.kernel.org>; Fri, 20 Nov 2020 20:43:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="GpFB8JoF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5B95422470
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20436-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7462 invoked by uid 550); 20 Nov 2020 20:43:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7442 invoked from network); 20 Nov 2020 20:43:28 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=i55oAU3/0ChRWnSy8Vy2lsf5/3oQQZ1SpwWH7R5fDAQ=;
        b=GpFB8JoFYlzs5IPt1A4zHefiujfDAb4Aupd2Gt8XWPGlHwTgyLSPZ69lnmpG8AcDUI
         P5TQWbT45S+7ZLN8NYpqb8spc1x7xM2RTsvR4yoBcsZ8FoV3W56Xp36fdQTbZm5G+EPS
         8sdwQfqqqLt9BxwKajipmRGH3q24bpLwIUoOI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i55oAU3/0ChRWnSy8Vy2lsf5/3oQQZ1SpwWH7R5fDAQ=;
        b=pBu0/lIYWXemYL/WJQFIxrR8IOD654BwuxqAsSxs74BkOWx2UnYtmMU/kfPHDZzHcL
         fCpFPVNcfHnIJs7gX7SqtmYX1XTNNBtTRnMaQkMpTI7OYcMglDmFnqBj+pTvMCn6ka1S
         P9ISdztfbk/V8eG1ihCqn+SKEzt/aZ2mlkoOF6grU8oErFr5I5LzGB5Vo0asfDNTYDAG
         8ns+RX59ig23BuI86p9Xbqm41ZDXqbYppGeCRBPx1/PkafijuzAeea7iFwBhxQbhH4Ti
         Bv4nx4ttBPyfJMAXru1i5QVkO+IheFTbUfpDITQNVwNGdc+RgnS7/vFOhEkOZ7sWeLa8
         nu5w==
X-Gm-Message-State: AOAM533l6L0lwYW1ky2wHGnAMQa3w8GrtQQN8mLd20eFzmzcSOdRoeEY
	KpmuVLPfd/ZKCdN3DCHniPUC3Q==
X-Google-Smtp-Source: ABdhPJwImKJNbu1EQwiGGAUktKiLdCpi1F8qQGza+VZgx7A7t3fyRz/FVTV1hNGkrOLQAws/XjLW2g==
X-Received: by 2002:a17:90b:e08:: with SMTP id ge8mr12659157pjb.29.1605904996598;
        Fri, 20 Nov 2020 12:43:16 -0800 (PST)
Date: Fri, 20 Nov 2020 12:43:14 -0800
From: Kees Cook <keescook@chromium.org>
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
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
Message-ID: <202011201241.B159562D7@keescook>
References: <20201118220731.925424-1-samitolvanen@google.com>
 <20201118220731.925424-3-samitolvanen@google.com>
 <CAKwvOdnYTMzaahnBqdNYPz3KMdnkp=jZ4hxiqkTYzM5+BBdezA@mail.gmail.com>
 <CABCJKucj_jUwoiLc35R7qFe+cNKTWgT+gsCa5pPiY66+1--3Lg@mail.gmail.com>
 <202011201144.3F2BB70C@keescook>
 <20201120202935.GA1220359@ubuntu-m3-large-x86>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201120202935.GA1220359@ubuntu-m3-large-x86>

On Fri, Nov 20, 2020 at 01:29:35PM -0700, Nathan Chancellor wrote:
> On Fri, Nov 20, 2020 at 11:47:21AM -0800, Kees Cook wrote:
> > On Fri, Nov 20, 2020 at 08:23:11AM -0800, Sami Tolvanen wrote:
> > > Changing the ThinLTO config to a choice and moving it after the main
> > > LTO config sounds like a good idea to me. I'll see if I can change
> > > this in v8. Thanks!
> > 
> > Originally, I thought this might be a bit ugly once GCC LTO is added,
> > but this could be just a choice like we're done for the stack
> > initialization. Something like an "LTO" choice of NONE, CLANG_FULL,
> > CLANG_THIN, and in the future GCC, etc.
> 
> Having two separate choices might be a little bit cleaner though? One
> for the compiler (LTO_CLANG versus LTO_GCC) and one for the type
> (THINLTO versus FULLLTO). The type one could just have a "depends on
> CC_IS_CLANG" to ensure it only showed up when needed.

Right, that's how the stack init choice works. Kconfigs that aren't
supported by the compiler won't be shown. I.e. after Sami's future
patch, the only choice for GCC will be CONFIG_LTO_NONE. But building
under Clang, it would offer CONFIG_LTO_NONE, CONFIG_LTO_CLANG_FULL,
CONFIG_LTO_CLANG_THIN, or something.

(and I assume  CONFIG_LTO would be def_bool y, depends on !LTO_NONE)

-- 
Kees Cook
