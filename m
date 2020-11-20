Return-Path: <SRS0=6Wpf=E2=lists.openwall.com=kernel-hardening-return-20437-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05EADC56202
	for <kernel-hardening@archiver.kernel.org>; Fri, 20 Nov 2020 20:59:14 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0E5F122264
	for <kernel-hardening@archiver.kernel.org>; Fri, 20 Nov 2020 20:59:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n7Q8WZSH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0E5F122264
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20437-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 12199 invoked by uid 550); 20 Nov 2020 20:59:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 12176 invoked from network); 20 Nov 2020 20:59:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JWd8Wn96hX4ViEXOk8cnBriUSzyNGlVdd9D7G7X9krM=;
        b=n7Q8WZSHAzqNmYrv9dNqZivuKsDeywwvO4kl1fLm8yAB9nz+k+3lzkHIC6URMndd9N
         ncfzYU53qrW6L7ktmuiCSCQkVZ/eP5JDWD7TMwJg8e5yVePPZIH2mL+P1inZGOs772ll
         a8QRES6vjPZ1qfhyKHcxA2SDzvnvBpk4g78r8aAZWi1llK+zb+YIfMZx34KzfOChRgPa
         6pg4ojnEfHCIbmevi1eG30tobfXlx2k6qexNCevPM6lVr7/QqpezqSu6yAgpxx7oPbC8
         wgUzxLS+Q8yRx5MTE+8rAH2p4+zi25RWg2L/DNevmi7STfpPOI63AYByOiSP7iPAbmY3
         vTAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JWd8Wn96hX4ViEXOk8cnBriUSzyNGlVdd9D7G7X9krM=;
        b=iCTGbq0blwjWmaAFXL8bSX48bD2b46ke7JeoJIqIVHNtIzkBDN/4ETftB6pXtC6xeO
         eeEF2evgiYRfXdz0htN1VqbBmvjyeFPAvq7CC4uJCZJQX+oiqfjbQ3bMJHQeuvYvbQip
         SWlNN2P23LbeFryYbDSn3ppycXzqLJt239pSvo6JPOZ5et5QLhk7pWENQ5zFMvXA7lJ1
         cENZHkImT4YXPGdDjpc1YMcNXEk6IlB6Y6ZDL41AjNPldREXqBtLjuA9xX21LAfptpmY
         QyZQuGsT2wNX6AS1iMpfkZq6eTWBV6YcNjC8gplSSqTvnsZgBbobrSh2zqwDk7EYwDip
         BrOg==
X-Gm-Message-State: AOAM5306ggHIjPw0DRivc3g7dG+s3A7OJMBIPfVOIUNs9utCXq1KQtcI
	bpwNltOEH7d88StxY0SrdY2drr6zjQouP7LCJaCUNw==
X-Google-Smtp-Source: ABdhPJwahvlnvpf0HHckrWnv4UpriDhIz+vSW2ABkfUPKok1Yyd5+VP5JP/VFRj6CCBwEc5NUFJu59Sg2jFzgZb6jlE=
X-Received: by 2002:ab0:23cc:: with SMTP id c12mr12322573uan.89.1605905932783;
 Fri, 20 Nov 2020 12:58:52 -0800 (PST)
MIME-Version: 1.0
References: <20201118220731.925424-1-samitolvanen@google.com>
 <20201118220731.925424-3-samitolvanen@google.com> <CAKwvOdnYTMzaahnBqdNYPz3KMdnkp=jZ4hxiqkTYzM5+BBdezA@mail.gmail.com>
 <CABCJKucj_jUwoiLc35R7qFe+cNKTWgT+gsCa5pPiY66+1--3Lg@mail.gmail.com>
 <202011201144.3F2BB70C@keescook> <20201120202935.GA1220359@ubuntu-m3-large-x86>
 <202011201241.B159562D7@keescook>
In-Reply-To: <202011201241.B159562D7@keescook>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Fri, 20 Nov 2020 12:58:41 -0800
Message-ID: <CABCJKucJ87wa73YJkN_dYUyE7foQT+12gdWJZw1PgZ_decFr4w@mail.gmail.com>
Subject: Re: [PATCH v7 02/17] kbuild: add support for Clang LTO
To: Kees Cook <keescook@chromium.org>
Cc: Nathan Chancellor <natechancellor@gmail.com>, Nick Desaulniers <ndesaulniers@google.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Will Deacon <will@kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, Nov 20, 2020 at 12:43 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Fri, Nov 20, 2020 at 01:29:35PM -0700, Nathan Chancellor wrote:
> > On Fri, Nov 20, 2020 at 11:47:21AM -0800, Kees Cook wrote:
> > > On Fri, Nov 20, 2020 at 08:23:11AM -0800, Sami Tolvanen wrote:
> > > > Changing the ThinLTO config to a choice and moving it after the main
> > > > LTO config sounds like a good idea to me. I'll see if I can change
> > > > this in v8. Thanks!
> > >
> > > Originally, I thought this might be a bit ugly once GCC LTO is added,
> > > but this could be just a choice like we're done for the stack
> > > initialization. Something like an "LTO" choice of NONE, CLANG_FULL,
> > > CLANG_THIN, and in the future GCC, etc.
> >
> > Having two separate choices might be a little bit cleaner though? One
> > for the compiler (LTO_CLANG versus LTO_GCC) and one for the type
> > (THINLTO versus FULLLTO). The type one could just have a "depends on
> > CC_IS_CLANG" to ensure it only showed up when needed.
>
> Right, that's how the stack init choice works. Kconfigs that aren't
> supported by the compiler won't be shown. I.e. after Sami's future
> patch, the only choice for GCC will be CONFIG_LTO_NONE. But building
> under Clang, it would offer CONFIG_LTO_NONE, CONFIG_LTO_CLANG_FULL,
> CONFIG_LTO_CLANG_THIN, or something.
>
> (and I assume  CONFIG_LTO would be def_bool y, depends on !LTO_NONE)

I'm fine with adding ThinLTO as another option to the LTO choice, but
it would duplicate the dependencies and a lot of the help text. I
suppose we could add another config for the dependencies and have both
LTO options depend on that instead.

Sami
