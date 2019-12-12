Return-Path: <SRS0=kU0B=2C=lists.openwall.com=kernel-hardening-return-17501-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB162C43603
	for <kernel-hardening@archiver.kernel.org>; Thu, 12 Dec 2019 17:44:48 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4D3DF2067C
	for <kernel-hardening@archiver.kernel.org>; Thu, 12 Dec 2019 17:44:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="XtKdqd1u"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4D3DF2067C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17501-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1945 invoked by uid 550); 12 Dec 2019 17:44:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1911 invoked from network); 12 Dec 2019 17:44:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vAybGGxacChJwAejcpVjaSkmOSjuyOa7Vm0vQDf0ytg=;
        b=XtKdqd1uqEqin8HfnsY6la7gkuC/L5k7UGq5WAVvh5yLgp/O7bgr5j2xLaZPJpJSZY
         BkbEVDXJE8CedObjoydxulNAUnY3TJHHQNcPAZ/CoOJ+AT/xyDRa1yKCyjg1ofQCSrPc
         dmOUjyw+tazUcoYKBq1whPaLNbhoET6FUDY6M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vAybGGxacChJwAejcpVjaSkmOSjuyOa7Vm0vQDf0ytg=;
        b=llVrJQ0YVzUvWuPUiMsqIMl07kSYzKAHXCy6mqlejlKZtkXFJmmhcy+dMMB5Z5zWnH
         mnRNYiQcooMLZ2DtRlcPKp/4UxJ6C84s8gB8yXHpsgOVh+3awJyE4r8AX4I0uiCk0TJQ
         JuzPMAiUttqAkLXueRNSj6GwIeh27DHrAtoLUMiT5oMr2VvusG7B5iGQySwY22+jkDeW
         g90dgpU7pS1qp3cIb6FuG5Uu+MXFOuYKGh1AW+aote5HAYSc512AZSSd7EMS4Lq8pPAP
         9+4/ViKm/dBpWPn8c77iefqXey5ayoebMxwMCuZDn25pk9zBkDK38cVVqfr6WsEQNKCK
         sJtA==
X-Gm-Message-State: APjAAAVBwAlA7UQutgJ9mc0DZGM2sDdkl7tlmlerh8Nq8/6Lqpcprsi/
	Oy8VrF+smGFzHSlanKUaub9YeA==
X-Google-Smtp-Source: APXvYqx2FdF/gi6uYV/9IkBPv0MXEhVzlJwwj3Cn0zKuTW8p0YuVLJmzJYaX5SE2C2iWT2vFodsZPQ==
X-Received: by 2002:aa7:9d0d:: with SMTP id k13mr11590528pfp.254.1576172668230;
        Thu, 12 Dec 2019 09:44:28 -0800 (PST)
Date: Thu, 12 Dec 2019 09:44:26 -0800
From: Kees Cook <keescook@chromium.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Masahiro Yamada <masahiroy@kernel.org>,
	Emese Revfy <re.emese@gmail.com>, Ard Biesheuvel <ardb@kernel.org>,
	Andrey Ryabinin <aryabinin@virtuozzo.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] gcc-plugins: make it possible to disable
 CONFIG_GCC_PLUGINS again
Message-ID: <201912120943.486E507@keescook>
References: <20191211133951.401933-1-arnd@arndb.de>
 <CAK7LNASeyPxgQczSvEN4S3Ae7fRtYyynhU9kJ=96VX34S4TECA@mail.gmail.com>
 <CAK8P3a1dH+msCgxU-=w4gp30Bw+x3=6Cj473DuFzxun+3dfOcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a1dH+msCgxU-=w4gp30Bw+x3=6Cj473DuFzxun+3dfOcA@mail.gmail.com>

On Thu, Dec 12, 2019 at 10:59:40AM +0100, Arnd Bergmann wrote:
> On Thu, Dec 12, 2019 at 5:52 AM Masahiro Yamada <masahiroy@kernel.org> wrote:
> >
> > On Wed, Dec 11, 2019 at 10:40 PM Arnd Bergmann <arnd@arndb.de> wrote:
> > >
> > > I noticed that randconfig builds with gcc no longer produce a lot of
> > > ccache hits, unlike with clang, and traced this back to plugins
> > > now being enabled unconditionally if they are supported.
> > >
> > > I am now working around this by adding
> > >
> > >    export CCACHE_COMPILERCHECK=/usr/bin/size -A %compiler%
> > >
> > > to my top-level Makefile. This changes the heuristic that ccache uses
> > > to determine whether the plugins are the same after a 'make clean'.
> > >
> > > However, it also seems that being able to just turn off the plugins is
> > > generally useful, at least for build testing it adds noticeable overhead
> > > but does not find a lot of bugs additional bugs, and may be easier for
> > > ccache users than my workaround.
> > >
> > > Fixes: 9f671e58159a ("security: Create "kernel hardening" config area")
> > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> >
> > Reviewed-by: Masahiro Yamada <masahiroy@kernel.org>
> 
> On Wed, Dec 11, 2019 at 2:59 PM Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
> >Acked-by: Ard Biesheuvel <ardb@kernel.org>
> 
> Thanks! Who would be the best person to pick up the patch?
> Should I send it to Andrew?

Acked-by: Kees Cook <keescook@chromium.org>

I can take it in my tree, or I'm happy to have Masahiro take it.

-- 
Kees Cook
