Return-Path: <SRS0=eFuf=2U=lists.openwall.com=kernel-hardening-return-17539-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58B63C2D0C2
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Dec 2019 19:42:05 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A96CD206DB
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Dec 2019 19:42:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="VhyEFlYR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A96CD206DB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17539-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28465 invoked by uid 550); 30 Dec 2019 19:41:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28431 invoked from network); 30 Dec 2019 19:41:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PkkLXDj8HeyoAsXSUf7EB7C7ycPCZ7nOePq2CDe6W7A=;
        b=VhyEFlYR+ibRZhAU/Zlt2WaACOPEq9e9Vua53F8j4jJDylYSIMjRh8PTNivSdiOxNH
         GsF4EZ4lDP4c63w3DIq6yAiRMC7U2Wjn4E1OYu9+mjH50XgD09xcHuyi4vW53UbRh0Si
         PcAeooP0hmoYMydJKlP+uyiavUfPJ6ELFhEAg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PkkLXDj8HeyoAsXSUf7EB7C7ycPCZ7nOePq2CDe6W7A=;
        b=REugOppyj3LJ8MNnLEh+ply13QUPaL9Y9uZ7Sxj6D9QePBtzCPHo0KKK1iPl2ah88O
         aN+GKFFVet6D/8Zea23ruiSqq6whqgQFd8sjCQGttabYH04OlIfMHIvcQowxoKTbAZL6
         R2EXW2Kk6Bkcmsg17KGz+/y+eh3grTsX7DqxyXL454zFVZhLaYT1L4QqOl+IWTL9QSib
         l0pLhZ5MF3WJcLx3IHN/KWIwHfPWyDo6YjWKDxMP/r2Z0q+Q7dZ9I7cJtN66Fw86w6T1
         JJy9HBalkZfAfF7zO1649Ttn7AvcE2W9URR2XUCyrRPMTjnqjFBqaoPKJ7vV7G3Ek7Q7
         KQbQ==
X-Gm-Message-State: APjAAAUOaFjVcKvRyBNTBn7foyb3CBN3X9J4bFplJJ07uN6RbyXQ2aaZ
	8KcBDBFJlTe9Ip78+kvh5Zfhig==
X-Google-Smtp-Source: APXvYqzVpx3dL/tLel5sEMYXF+VVdZW9N+hNBFJ6GOs9NKyDtNGyXnUBHxnP/VH+O2xwue27dLhq5A==
X-Received: by 2002:a05:6830:13d9:: with SMTP id e25mr73720379otq.134.1577734906535;
        Mon, 30 Dec 2019 11:41:46 -0800 (PST)
Date: Mon, 30 Dec 2019 11:41:44 -0800
From: Kees Cook <keescook@chromium.org>
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Emese Revfy <re.emese@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Andrey Ryabinin <aryabinin@virtuozzo.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] gcc-plugins: make it possible to disable
 CONFIG_GCC_PLUGINS again
Message-ID: <201912301141.38C6F7E0@keescook>
References: <20191211133951.401933-1-arnd@arndb.de>
 <CAK7LNASeyPxgQczSvEN4S3Ae7fRtYyynhU9kJ=96VX34S4TECA@mail.gmail.com>
 <CAK8P3a1dH+msCgxU-=w4gp30Bw+x3=6Cj473DuFzxun+3dfOcA@mail.gmail.com>
 <201912120943.486E507@keescook>
 <CAK7LNAQKuyyC-bjSZ=8bhkd1PHjRa-LDEsZra_tFdYbL7X-Azw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK7LNAQKuyyC-bjSZ=8bhkd1PHjRa-LDEsZra_tFdYbL7X-Azw@mail.gmail.com>

On Sat, Dec 14, 2019 at 05:56:34PM +0900, Masahiro Yamada wrote:
> On Fri, Dec 13, 2019 at 2:44 AM Kees Cook <keescook@chromium.org> wrote:
> >
> > On Thu, Dec 12, 2019 at 10:59:40AM +0100, Arnd Bergmann wrote:
> > > On Thu, Dec 12, 2019 at 5:52 AM Masahiro Yamada <masahiroy@kernel.org> wrote:
> > > >
> > > > On Wed, Dec 11, 2019 at 10:40 PM Arnd Bergmann <arnd@arndb.de> wrote:
> > > > >
> > > > > I noticed that randconfig builds with gcc no longer produce a lot of
> > > > > ccache hits, unlike with clang, and traced this back to plugins
> > > > > now being enabled unconditionally if they are supported.
> > > > >
> > > > > I am now working around this by adding
> > > > >
> > > > >    export CCACHE_COMPILERCHECK=/usr/bin/size -A %compiler%
> > > > >
> > > > > to my top-level Makefile. This changes the heuristic that ccache uses
> > > > > to determine whether the plugins are the same after a 'make clean'.
> > > > >
> > > > > However, it also seems that being able to just turn off the plugins is
> > > > > generally useful, at least for build testing it adds noticeable overhead
> > > > > but does not find a lot of bugs additional bugs, and may be easier for
> > > > > ccache users than my workaround.
> > > > >
> > > > > Fixes: 9f671e58159a ("security: Create "kernel hardening" config area")
> > > > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > > >
> > > > Reviewed-by: Masahiro Yamada <masahiroy@kernel.org>
> > >
> > > On Wed, Dec 11, 2019 at 2:59 PM Ard Biesheuvel
> > > <ard.biesheuvel@linaro.org> wrote:
> > > >Acked-by: Ard Biesheuvel <ardb@kernel.org>
> > >
> > > Thanks! Who would be the best person to pick up the patch?
> > > Should I send it to Andrew?
> >
> > Acked-by: Kees Cook <keescook@chromium.org>
> >
> > I can take it in my tree, or I'm happy to have Masahiro take it.
> >
> > --
> > Kees Cook
> 
> Kees,
> Please apply it to your tree.

Thanks, applied!

-- 
Kees Cook
