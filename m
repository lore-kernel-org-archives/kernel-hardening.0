Return-Path: <SRS0=Fpih=5O=lists.openwall.com=kernel-hardening-return-18279-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ACF2C43331
	for <kernel-hardening@archiver.kernel.org>; Sun, 29 Mar 2020 11:12:22 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BB37220675
	for <kernel-hardening@archiver.kernel.org>; Sun, 29 Mar 2020 11:12:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="qSVFHnII"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB37220675
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18279-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 31909 invoked by uid 550); 29 Mar 2020 11:12:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28624 invoked from network); 29 Mar 2020 11:05:25 -0000
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-03.nifty.com 02TB4oEI022767
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
	s=dec2015msa; t=1585479891;
	bh=CZAmvYzErNjohE2ADOOoYKCxYdv4vojfbTYidYBQq1Y=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=qSVFHnIIJnBUjLMS19vCe82bGiz9+8Q/kU6nr+DoilpyKEKa47A0mjbQjjaUdRqsA
	 +NIP9MNPShJN/4pHZjZZsz8wSgewg6yxu0AbQO6V6sdY5UpqSaCYp5FW3p8HyVksJN
	 dv0kU0IIorFxlDYUlBqYegu4o3gCQem4XKUvYArmUwpGexUuEs6KYNsL1Vnn6W1HMC
	 z5Mm8lctTDtW5ABVSGLlYf/RxaoqUDeHR0VCMFnBCozN9LZONIpTO034NwPhxAUAQ/
	 BLAqo0bjZ5uCSZUm67v4p55mf3WzyW7Xk9f1mliOFIO/hz4rWqdZuRscWD7frpptrw
	 mlg263302QbKg==
X-Nifty-SrcIP: [209.85.217.48]
X-Gm-Message-State: AGi0PuZYJj5jpYyhWl84ThhsODCTGSZ+4Z4Gl0H98LBGGy/epnqkONya
	7ZsSH+fF7fxPI56rUuOK9XxVnFVsQ9W/yNmcog0=
X-Google-Smtp-Source: APiQypLko5mdsw5ozmMfBLEpr95LzigdeNWgB5ufKaG/GiPb+WkiNKTf7WbJ1iHXvX0yrsN3B4dkgtViqohO/kWsPYU=
X-Received: by 2002:a67:8745:: with SMTP id j66mr4371097vsd.181.1585479890191;
 Sun, 29 Mar 2020 04:04:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200325031433.28223-1-masahiroy@kernel.org> <20200325031433.28223-2-masahiroy@kernel.org>
 <202003251906.973AD868@keescook>
In-Reply-To: <202003251906.973AD868@keescook>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Sun, 29 Mar 2020 20:04:14 +0900
X-Gmail-Original-Message-ID: <CAK7LNARRZ3_z6tjuGJ=PUw5JUtP5AM31wYpr0mnn9yq6VfzQOA@mail.gmail.com>
Message-ID: <CAK7LNARRZ3_z6tjuGJ=PUw5JUtP5AM31wYpr0mnn9yq6VfzQOA@mail.gmail.com>
Subject: Re: [PATCH 2/2] kbuild: add -Wall to KBUILD_HOSTCXXFLAGS
To: Kees Cook <keescook@chromium.org>
Cc: Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Emese Revfy <re.emese@gmail.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Mar 26, 2020 at 11:06 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Wed, Mar 25, 2020 at 12:14:32PM +0900, Masahiro Yamada wrote:
> > Add -Wall to catch more warnings for C++ host programs.
> >
> > When I submitted the previous version, the 0-day bot reported
> > -Wc++11-compat warnings for old GCC:
> >
> >   HOSTCXX -fPIC scripts/gcc-plugins/latent_entropy_plugin.o
> > In file included from /usr/lib/gcc/x86_64-linux-gnu/4.8/plugin/include/tm.h:28:0,
> >                  from scripts/gcc-plugins/gcc-common.h:15,
> >                  from scripts/gcc-plugins/latent_entropy_plugin.c:78:
> > /usr/lib/gcc/x86_64-linux-gnu/4.8/plugin/include/config/elfos.h:102:21: warning: C++11 requires a space between string literal and macro [-Wc++11-compat]
> >     fprintf ((FILE), "%s"HOST_WIDE_INT_PRINT_UNSIGNED"\n",\
> >                      ^
> > /usr/lib/gcc/x86_64-linux-gnu/4.8/plugin/include/config/elfos.h:170:24: warning: C++11 requires a space between string literal and macro [-Wc++11-compat]
> >        fprintf ((FILE), ","HOST_WIDE_INT_PRINT_UNSIGNED",%u\n",  \
> >                         ^
> > In file included from /usr/lib/gcc/x86_64-linux-gnu/4.8/plugin/include/tm.h:42:0,
> >                  from scripts/gcc-plugins/gcc-common.h:15,
> >                  from scripts/gcc-plugins/latent_entropy_plugin.c:78:
> > /usr/lib/gcc/x86_64-linux-gnu/4.8/plugin/include/defaults.h:126:24: warning: C++11 requires a space between string literal and macro [-Wc++11-compat]
> >        fprintf ((FILE), ","HOST_WIDE_INT_PRINT_UNSIGNED",%u\n",  \
> >                         ^
> >
> > The source of the warnings is in the plugin headers, so we have no
> > control of it. I just suppressed them by adding -Wno-c++11-compat to
> > scripts/gcc-plugins/Makefile.
> >
> > Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
>
> Acked-by: Kees Cook <keescook@chromium.org>
>
> -Kees


Applied to linux-kbuild.



-- 
Best Regards
Masahiro Yamada
