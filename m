Return-Path: <SRS0=uPig=5O=lists.openwall.com=kernel-hardening-return-18278-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1916C43331
	for <kernel-hardening@archiver.kernel.org>; Sun, 29 Mar 2020 11:12:14 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4C4F320675
	for <kernel-hardening@archiver.kernel.org>; Sun, 29 Mar 2020 11:12:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="xhfH7CHY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4C4F320675
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18278-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30623 invoked by uid 550); 29 Mar 2020 11:12:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28525 invoked from network); 29 Mar 2020 11:04:57 -0000
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-03.nifty.com 02TB4Fr9022591
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
	s=dec2015msa; t=1585479856;
	bh=EU2108wCRxym6ou+uSsn9nTW9F9rhQ/CqadQn7+lTn0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=xhfH7CHYqsdYqHY+K2ou0pYdKqtz/s7Yswet3nSTTST4DylHzT9jazYgl060yBj/H
	 fCwTbEaFfUnpgq5BLUR5tw7iMoYoqBj4sSf3P7LQxqWVrFLVUqditPZnLrXtOrWBHg
	 oPTji28Ko9Yc/Jrik8iRLDhYFpTUEUZj+EIDCsluXhXBv7vRbL/uOFmc3sK6zdFXZe
	 X3j95YwMKmpUdYcYQXum+EqOseOJC6CXBKJZsjHNm4G29rl6UE7BvUVsYG53ug9xwP
	 89YLfroPUx7pTN9Grg1fuvnLDTxPhzWqu/aP97XhXg7U7v1kMPN5VJdU1lJKZyTmU7
	 fUdK7OGKIIDYw==
X-Nifty-SrcIP: [209.85.221.174]
X-Gm-Message-State: AGi0PubS5fjhSogWTB+awaWMrAEh5o0iQK8CAMSuUgo33IW29ge1rX5F
	eGFLv3OKJvh+sV/kiyR8lsXFrai04pPIj50wBbg=
X-Google-Smtp-Source: APiQypImfB6tagTqcvE4vgOZ5u6yx/ne3N54JbAO22wwBI1pcsS8aliSJz9f7hjsjn6h7riXl4m5AvPEkKA/id8MjPw=
X-Received: by 2002:a1f:1786:: with SMTP id 128mr4298073vkx.26.1585479855039;
 Sun, 29 Mar 2020 04:04:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200325031433.28223-1-masahiroy@kernel.org> <202003251905.6D43E64@keescook>
In-Reply-To: <202003251905.6D43E64@keescook>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Sun, 29 Mar 2020 20:03:39 +0900
X-Gmail-Original-Message-ID: <CAK7LNATWkXiWtR+=eWxqxewsJjy_nvSmcByCR-ZehO95yN-c+A@mail.gmail.com>
Message-ID: <CAK7LNATWkXiWtR+=eWxqxewsJjy_nvSmcByCR-ZehO95yN-c+A@mail.gmail.com>
Subject: Re: [PATCH 1/2] kconfig: remove unused variable in qconf.cc
To: Kees Cook <keescook@chromium.org>
Cc: Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 26, 2020 at 11:06 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Wed, Mar 25, 2020 at 12:14:31PM +0900, Masahiro Yamada wrote:
> > If this file were compiled with -Wall, the following warning would be
> > reported:
> >
> > scripts/kconfig/qconf.cc:312:6: warning: unused variable =E2=80=98i=E2=
=80=99 [-Wunused-variable]
> >   int i;
> >       ^
> >
> > The commit prepares to turn on -Wall for C++ host programs.
> >
> > Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
>
> Reviewed-by: Kees Cook <keescook@chromium.org>
>

Applied to linux-kbuild.



> -Kees
>
> > ---
> >
> >  scripts/kconfig/qconf.cc | 2 --
> >  1 file changed, 2 deletions(-)
> >
> > diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
> > index 82773cc35d35..50a5245d87bb 100644
> > --- a/scripts/kconfig/qconf.cc
> > +++ b/scripts/kconfig/qconf.cc
> > @@ -309,8 +309,6 @@ ConfigList::ConfigList(ConfigView* p, const char *n=
ame)
> >         showName(false), showRange(false), showData(false), mode(single=
Mode), optMode(normalOpt),
> >         rootEntry(0), headerPopup(0)
> >  {
> > -     int i;
> > -
> >       setObjectName(name);
> >       setSortingEnabled(false);
> >       setRootIsDecorated(true);
> > --
> > 2.17.1
> >
>
> --
> Kees Cook



--=20
Best Regards
Masahiro Yamada
