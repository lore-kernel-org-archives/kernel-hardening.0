Return-Path: <SRS0=SEou=2E=lists.openwall.com=kernel-hardening-return-17502-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38645C43603
	for <kernel-hardening@archiver.kernel.org>; Sat, 14 Dec 2019 12:22:01 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7FC1F20706
	for <kernel-hardening@archiver.kernel.org>; Sat, 14 Dec 2019 12:22:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="mTlnWukx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7FC1F20706
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17502-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32031 invoked by uid 550); 14 Dec 2019 12:21:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32202 invoked from network); 14 Dec 2019 08:57:30 -0000
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-02.nifty.com xBE8vBLM002327
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
	s=dec2015msa; t=1576313832;
	bh=tOG6kTlp8s2Wa7TA90vKI50NyHvG0cGEmJq+pmXM+IE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=mTlnWukxuu2SqbGLPkUDKfpYQ/ZAn+86k4XT14LRN8XsN1ra0P5s6SjxJmYGqpVzp
	 sE6uE+roNh0mO1+KEXOeZNGFb66vk4aUcGe1yGHru2Q1EWh0OhHyZSzAw+m6gPoruD
	 18ZGdRsRVwQ8saau56I6EYetCreURZbpAyJHoRLm+OlYsrO4Lur/bWPr4okL1bEKcF
	 mrdTmKzaeVJT8k7PsGkm3NPKuKQVxVpArWDJ0MBAWjD0DMKpKR3Ah9DWEkgxTvKFiO
	 6oF/500SRoyjV7eKhN9E+xDVoLocHvjJv3ElLGX+Wbj5JJkFAwVyPKGWyDyLTsyPZX
	 4rPcT/r9ajPQg==
X-Nifty-SrcIP: [209.85.222.41]
X-Gm-Message-State: APjAAAUrw8pMPMct7Czx3UODrGjFpdWHfaRsDONPWAasVegFKYEfiljM
	GqoDVtU83ptMRkZN6zo3x/Q8Z352nmeAVMM2NU8=
X-Google-Smtp-Source: APXvYqwmYrpSUuPxlEvWVvOsd7YEYsu2OUZUKhh6HhH9l2daQiTwE8jfI3K3o+1Jd09Fb5ZcIFx0iW/FrDCBUOBdsbM=
X-Received: by 2002:ab0:2814:: with SMTP id w20mr15685601uap.95.1576313830670;
 Sat, 14 Dec 2019 00:57:10 -0800 (PST)
MIME-Version: 1.0
References: <20191211133951.401933-1-arnd@arndb.de> <CAK7LNASeyPxgQczSvEN4S3Ae7fRtYyynhU9kJ=96VX34S4TECA@mail.gmail.com>
 <CAK8P3a1dH+msCgxU-=w4gp30Bw+x3=6Cj473DuFzxun+3dfOcA@mail.gmail.com> <201912120943.486E507@keescook>
In-Reply-To: <201912120943.486E507@keescook>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Sat, 14 Dec 2019 17:56:34 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQKuyyC-bjSZ=8bhkd1PHjRa-LDEsZra_tFdYbL7X-Azw@mail.gmail.com>
Message-ID: <CAK7LNAQKuyyC-bjSZ=8bhkd1PHjRa-LDEsZra_tFdYbL7X-Azw@mail.gmail.com>
Subject: Re: [PATCH] gcc-plugins: make it possible to disable
 CONFIG_GCC_PLUGINS again
To: Kees Cook <keescook@chromium.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Emese Revfy <re.emese@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Dec 13, 2019 at 2:44 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Thu, Dec 12, 2019 at 10:59:40AM +0100, Arnd Bergmann wrote:
> > On Thu, Dec 12, 2019 at 5:52 AM Masahiro Yamada <masahiroy@kernel.org> wrote:
> > >
> > > On Wed, Dec 11, 2019 at 10:40 PM Arnd Bergmann <arnd@arndb.de> wrote:
> > > >
> > > > I noticed that randconfig builds with gcc no longer produce a lot of
> > > > ccache hits, unlike with clang, and traced this back to plugins
> > > > now being enabled unconditionally if they are supported.
> > > >
> > > > I am now working around this by adding
> > > >
> > > >    export CCACHE_COMPILERCHECK=/usr/bin/size -A %compiler%
> > > >
> > > > to my top-level Makefile. This changes the heuristic that ccache uses
> > > > to determine whether the plugins are the same after a 'make clean'.
> > > >
> > > > However, it also seems that being able to just turn off the plugins is
> > > > generally useful, at least for build testing it adds noticeable overhead
> > > > but does not find a lot of bugs additional bugs, and may be easier for
> > > > ccache users than my workaround.
> > > >
> > > > Fixes: 9f671e58159a ("security: Create "kernel hardening" config area")
> > > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > >
> > > Reviewed-by: Masahiro Yamada <masahiroy@kernel.org>
> >
> > On Wed, Dec 11, 2019 at 2:59 PM Ard Biesheuvel
> > <ard.biesheuvel@linaro.org> wrote:
> > >Acked-by: Ard Biesheuvel <ardb@kernel.org>
> >
> > Thanks! Who would be the best person to pick up the patch?
> > Should I send it to Andrew?
>
> Acked-by: Kees Cook <keescook@chromium.org>
>
> I can take it in my tree, or I'm happy to have Masahiro take it.
>
> --
> Kees Cook

Kees,
Please apply it to your tree.

Thanks.


-- 
Best Regards
Masahiro Yamada
