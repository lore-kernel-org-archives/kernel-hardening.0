Return-Path: <SRS0=+VhX=FM=lists.openwall.com=kernel-hardening-return-20548-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61582C4361B
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Dec 2020 22:22:18 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5A3B1239FD
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Dec 2020 22:22:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A3B1239FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20548-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9426 invoked by uid 550); 8 Dec 2020 22:21:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9321 invoked from network); 8 Dec 2020 22:21:02 -0000
X-Gm-Message-State: AOAM533bMppYpSCtToWTYWwCZg/AOAfwDIBs51srntPFaqAf+Cz+j+2S
	87VNy6KX3ByAVxS09Vo4rF+Tj7exH8qGNKKPv8Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1607466049;
	bh=8y0P41eu0vrpOJeHzaBUZ9o4sOukFpEZzShJXEuuTDY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=gSkizAjGxLc0+AVGqS+JixiihOGYSXdfGwlEEthB3lNE4PHMREDewI5VO81wOOddC
	 3/AanEtVisMBlpZzZHNsMKbl9KV69BN0lodxF98JeLKqaNJ7xzaDngsmmOqXoQYsFp
	 g+I6B7Cm3sXq8gq473wvzBgECIOpHQc2b75rFjatHNedzz13rnSjS4GkaneyiCEwsm
	 g5zNg+sOgHPqdTVvL+X2Tx0fK0gHGPA4NfA09S2rehUYcmT3dTle9N9lKm0IPuPccy
	 teMFgzt8NUgSGKdVxOAGq1K3T0ScBVdYlwcaYh27/WhCtNUXpgwp8eu8LfCPOqrGlI
	 2TxPXiU/wR52A==
X-Google-Smtp-Source: ABdhPJzqw4tXGHeHAKru+pZFdngSW7KLUcvLigOek1gd95JlX3PyzWo9iAppGBwNF2Oi7ti6Jouun7qgJJV39N2XE+k=
X-Received: by 2002:a9d:be1:: with SMTP id 88mr215992oth.210.1607466049167;
 Tue, 08 Dec 2020 14:20:49 -0800 (PST)
MIME-Version: 1.0
References: <20201201213707.541432-1-samitolvanen@google.com>
 <CAK8P3a1WEAo2SEgKUEs3SB7n7QeeHa0=cx_nO==rDK0jjDArow@mail.gmail.com>
 <CABCJKueCHo2RYfx_A21m+=d1gQLR9QsOOxCsHFeicCqyHkb-Kg@mail.gmail.com>
 <CAK8P3a1Xfpt7QLkvxjtXKcgzcWkS8g9bmxD687+rqjTafTzKrg@mail.gmail.com> <CAKwvOd=hL=Vt1ATYqky9jmv+tM5hpTnLRuZudG-7ki0EYoFGJQ@mail.gmail.com>
In-Reply-To: <CAKwvOd=hL=Vt1ATYqky9jmv+tM5hpTnLRuZudG-7ki0EYoFGJQ@mail.gmail.com>
From: Arnd Bergmann <arnd@kernel.org>
Date: Tue, 8 Dec 2020 23:20:32 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1k_cq3NOUeuQC4-uKDBaGq49GSjAMSiS_M9AVMBxv51g@mail.gmail.com>
Message-ID: <CAK8P3a1k_cq3NOUeuQC4-uKDBaGq49GSjAMSiS_M9AVMBxv51g@mail.gmail.com>
Subject: Re: [PATCH v8 00/16] Add support for Clang LTO
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Sami Tolvanen <samitolvanen@google.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>, 
	Josh Poimboeuf <jpoimboe@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-pci <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Dec 8, 2020 at 10:10 PM 'Nick Desaulniers' via Clang Built
Linux <clang-built-linux@googlegroups.com> wrote:
>
> On Tue, Dec 8, 2020 at 1:00 PM Arnd Bergmann <arnd@kernel.org> wrote:
> >
> > On Tue, Dec 8, 2020 at 5:43 PM 'Sami Tolvanen' via Clang Built Linux
> > <clang-built-linux@googlegroups.com> wrote:
> > >
> > > On Tue, Dec 8, 2020 at 4:15 AM Arnd Bergmann <arnd@kernel.org> wrote:
> > > >
> > > > - one build seems to take even longer to link. It's currently at 35GB RAM
> > > >   usage and 40 minutes into the final link, but I'm worried it might
> > > > not complete
> > > >   before it runs out of memory.  I only have 128GB installed, and google-chrome
> > > >   uses another 30GB of that, and I'm also doing some other builds in parallel.
> > > >   Is there a minimum recommended amount of memory for doing LTO builds?
> > >
> > > When building arm64 defconfig, the maximum memory usage I measured
> > > with ThinLTO was 3.5 GB, and with full LTO 20.3 GB. I haven't measured
> > > larger configurations, but I believe LLD can easily consume 3-4x that
> > > much with full LTO allyesconfig.
> >
> > Ok, that's not too bad then. Is there actually a reason to still
> > support full-lto
> > in your series? As I understand it, full LTO was the initial approach and
> > used to work better, but thin LTO is actually what we want to use in the
> > long run. Perhaps dropping the full LTO option from your series now
> > that thin LTO works well enough and uses less resources would help
> > avoid some of the problems.
>
> While all developers agree that ThinLTO is a much more palatable
> experience than full LTO; our product teams prefer the excessive build
> time and memory high water mark (at build time) costs in exchange for
> slightly better performance than ThinLTO in <benchmarks that I've been
> told are important>.  Keeping support for full LTO in tree would help
> our product teams reduce the amount of out of tree code they have.  As
> long as <benchmarks that I've been told are important> help
> sell/differentiate phones, I suspect our product teams will continue
> to ship full LTO in production.

Ok, fair enough. How about marking FULL_LTO as 'depends on
!COMPILE_TEST' then? I'll do that locally for my randconfig tests,
but it would help the other build bots that also force-enable
COMPILE_TEST.

       Arnd
