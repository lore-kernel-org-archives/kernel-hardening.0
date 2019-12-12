Return-Path: <SRS0=tNQH=2C=lists.openwall.com=kernel-hardening-return-17500-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 862C5C43603
	for <kernel-hardening@archiver.kernel.org>; Thu, 12 Dec 2019 10:00:18 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DA3FF206DA
	for <kernel-hardening@archiver.kernel.org>; Thu, 12 Dec 2019 10:00:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DA3FF206DA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arndb.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17500-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30150 invoked by uid 550); 12 Dec 2019 10:00:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30116 invoked from network); 12 Dec 2019 10:00:09 -0000
X-Gm-Message-State: APjAAAUOLS5BPEolqb5NBLquNrf88L6f2vJ1/6afN6i/r+ir6EHhc65d
	k/YbtKO6fIpDVyzX3tu/3UYsQk4AH/8GYbkBNhg=
X-Google-Smtp-Source: APXvYqxkULaZmjXZpjS5HEn1p1TLik8jAP/fqAKzJNUYyZjMz9AYttUv30jL0zE54EkdUAz9jbgN1/fDqh4J5Uq3tUk=
X-Received: by 2002:a05:620a:a5b:: with SMTP id j27mr7290911qka.286.1576144796165;
 Thu, 12 Dec 2019 01:59:56 -0800 (PST)
MIME-Version: 1.0
References: <20191211133951.401933-1-arnd@arndb.de> <CAK7LNASeyPxgQczSvEN4S3Ae7fRtYyynhU9kJ=96VX34S4TECA@mail.gmail.com>
In-Reply-To: <CAK7LNASeyPxgQczSvEN4S3Ae7fRtYyynhU9kJ=96VX34S4TECA@mail.gmail.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 12 Dec 2019 10:59:40 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1dH+msCgxU-=w4gp30Bw+x3=6Cj473DuFzxun+3dfOcA@mail.gmail.com>
Message-ID: <CAK8P3a1dH+msCgxU-=w4gp30Bw+x3=6Cj473DuFzxun+3dfOcA@mail.gmail.com>
Subject: Re: [PATCH] gcc-plugins: make it possible to disable
 CONFIG_GCC_PLUGINS again
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:WI+Add5FWK0iVlfGEanFPQC1u+JSTrYiSmjizYLjo6ia+wnFX1K
 ChLGOfgVAeWhDMLbf+ukrOqJCQA5pvHPxPgJuYgNv/5FpCW3xeD7MmgwQiiziliUiJzU6Oj
 CTJT6tz/wNfXzHKrvHbrJrAv2gdRXSRshcb8N9VZ9KmbC3vCj13ObOj9UMTBDB48t3FIan/
 CCpjYZiVhvFThYiGUtrJw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:J9ennvHGrVE=:FugoGMcmNNVFX1JQieM1O7
 6Hn8g+mcyekEV1LIixPNEhsjInMErpCdldNcOo8KrmJIAZzvuwD7Up1mRp2yZTuZ0Zpd+Mszi
 wR2Oikq7Gp80oGrZs3kzN2RfFCtpt5rggxTnM3YCg3pnZNuz1gwQ8FFeMVw1sUqkhx1f5t+AQ
 Fkg2cxTW/phqUiBbaLTx9o1oV2MunmKx5WCTXReQ+hWFAfQp/XQywhRNIoVDne//vElebUe/U
 Osxp5jWMEnqrTLrWkGlw9wh9IZ5hEW+rlpuRolaJJru5iOshA9CDfPYybGR/eGLhAYvpVuVG8
 0Ct+20S+bzdzwLb579Tb7k0ixHM1nxgIYLSuOoJK3Vc8KLMt3vBDwiEkfaDYfX5PTgTbmKdyb
 ZJL9kiIoj5U6PKnfy1RcVsuox0nWPQ9fDodmJmj+7wXjAV6ELXTVdu3E+w95XN3rvBSgrxSxq
 uyZA+XpON6kI70a7xFRUvAztQ2ev2F2PCvL5oL28xDV1W8rL5z5ZF0s2H+3uwJQzkhYpofTmk
 O9+T943AqZrrchzcvaGhPn2MZAZFMQEitGB2JS7aphsCyg3RQgWpiImpmfmn43zB6wh/8jyGo
 BW6ACvN8D0FRU6TIP+Ci8xIlY4TWRh8R1wfZoyHS0WNa2xt/kZVw71h1ySxs2d0PI/VULMLHi
 pU/Sp4TzNOHfoj66JkAKQvEvu7de3x33PxfirdbfWxSZrHVzaqbDHAhlJ4wCxmjgjmo0+TuBO
 9L4iampic+VDGcgBwE5CuIniL68Q1eBlFw9Rmb5pJ7trHxE2ZUNzZM97oeOCA4LwdDGgyRNuK
 mGNZU1hWnwNRvQ8Qq6+QashhVDYWHc9ERlPGeDKWCGWjQW8eFQJk0OafAeUV/bJLq31tIQCwk
 Mv4QWunXAYhUL9+QnVrg==

On Thu, Dec 12, 2019 at 5:52 AM Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> On Wed, Dec 11, 2019 at 10:40 PM Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > I noticed that randconfig builds with gcc no longer produce a lot of
> > ccache hits, unlike with clang, and traced this back to plugins
> > now being enabled unconditionally if they are supported.
> >
> > I am now working around this by adding
> >
> >    export CCACHE_COMPILERCHECK=/usr/bin/size -A %compiler%
> >
> > to my top-level Makefile. This changes the heuristic that ccache uses
> > to determine whether the plugins are the same after a 'make clean'.
> >
> > However, it also seems that being able to just turn off the plugins is
> > generally useful, at least for build testing it adds noticeable overhead
> > but does not find a lot of bugs additional bugs, and may be easier for
> > ccache users than my workaround.
> >
> > Fixes: 9f671e58159a ("security: Create "kernel hardening" config area")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> Reviewed-by: Masahiro Yamada <masahiroy@kernel.org>

On Wed, Dec 11, 2019 at 2:59 PM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>Acked-by: Ard Biesheuvel <ardb@kernel.org>

Thanks! Who would be the best person to pick up the patch?
Should I send it to Andrew?

    Arnd
