Return-Path: <SRS0=G4Tc=U2=lists.openwall.com=kernel-hardening-return-16292-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4802AC48BD7
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Jun 2019 14:30:38 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9C2A920828
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Jun 2019 14:30:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NxocVgNq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9C2A920828
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16292-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7575 invoked by uid 550); 27 Jun 2019 14:30:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7537 invoked from network); 27 Jun 2019 14:30:29 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=/zC8GO8bqHnXUqvMp3nSlEtzu8NhgecwJnWv6fQW+5s=;
        b=NxocVgNqPlMmUtov9VlWD/LK6TwoCzb2hpgAf62jRpKz8XNAXsYGfS4v/E4Za4Ap3p
         78lOmEIIwlq/4VexMSg6dQF1y8dCqP5DAMniFUOoeznSuHGtvJO7nVHYrlSJvzk/VFZ0
         9jZAQ3blwP5il+fhbAN3odkU7cdPZnKYx1jKNNdov05zKTDLa6VeVkRSPgiXLX1vkkgW
         hdMbIre0HNinPHTqAzBYOajM4PKinOOmi/Yll5kf2/CZ6MYOGFcdAVUOpUt++pG7qFeI
         Eqi2kh0mr7HQkIJ9fSGvxWuo+FVae5BMM/LIZ5x+Ho1VMjpx9eJWhBgFICWLL8ZYB4Hw
         /jGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=/zC8GO8bqHnXUqvMp3nSlEtzu8NhgecwJnWv6fQW+5s=;
        b=AYwDQdR3n7/i6sq70oNIhYbUbQBQlFxCC4/EqAkcMkZopr4QS5k0Ddneo5EP2pjwOf
         jw89DZkhjfpf9l2N/cnP2Ilak9vWE0My4/5NU2OQM2RIOgPqfbLcHOD7W7s8daBCbEWQ
         GBRP7V6Fhann1TTWpMYG3C6lSoatxJPOACm1o1xETjF/9ZKxvLY/+mzs+e9f4MNVBsBF
         QzpoKnMHnp+iOEbtUuzahgtxwD5ggJOcVXmZ8arvc0Slwj1upxP/w3p698BehgIDXmFL
         j3So35CfeejqBQ0m51yKmFuTLPn71hx/iAfDxQ4+TBisFo3T7E483AOEg3OKrAe3PYFN
         3AKA==
X-Gm-Message-State: APjAAAW+HM1lPOalGW33cnR/N0IJifjGmjJxYZmnBDliPeTE/LVq25Cv
	Qu6Yq9ZXCUvmVldlgWbzO7dIJ1rOKkOEBAMAtwHqtA==
X-Google-Smtp-Source: APXvYqzpSun2qfET13+wKS9lv4dcRQn7bwhAch8nPdiY7axVZ2jtaaCp4v2SswxH1NQrNssfDxjcvhqtgS+2ZQhmeQY=
X-Received: by 2002:a17:90a:2190:: with SMTP id q16mr6251047pjc.23.1561645817259;
 Thu, 27 Jun 2019 07:30:17 -0700 (PDT)
MIME-Version: 1.0
References: <CABgxDoLSzkVJ7Vh8mLiZySz6uS+VEu+GUxRqX8EWHKQDyz2fSg@mail.gmail.com>
 <201906200913.D2698BD0@keescook> <CABgxDoKQ4cnSS3p0sz8BgP65-R15U2Sr1AHVpU77ZGJu-Gvvvg@mail.gmail.com>
 <CABgxDoKTC1=5P=rnLmGzAgFs704+occs4Gw+6WyU99r4HwFBHA@mail.gmail.com>
 <201906261649.F2AFDCDBE@keescook> <CABgxDoJJo=AUHc1vWMeBpZHnMeBdRHSFnXWuN4RZwWnmB-9nBg@mail.gmail.com>
In-Reply-To: <CABgxDoJJo=AUHc1vWMeBpZHnMeBdRHSFnXWuN4RZwWnmB-9nBg@mail.gmail.com>
From: Romain Perier <romain.perier@gmail.com>
Date: Thu, 27 Jun 2019 16:30:06 +0200
Message-ID: <CABgxDo+KH25gscncQ7TLaQsw4UOir5whqkj8SgMWxtgDiSj7uw@mail.gmail.com>
Subject: Fwd: Audit and fix all misuse of NLA_STRING: STATUS
To: Kernel Hardening <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Adding the ML to Cc:
---------- Forwarded message ---------
De : Romain Perier <romain.perier@gmail.com>
Date: jeu. 27 juin 2019 =C3=A0 16:29
Subject: Re: Audit and fix all misuse of NLA_STRING: STATUS
To: Kees Cook <keescook@chromium.org>


Hi,

Yeah sure, it's done :)
What do you suggest as next task ?

Regards,
Romain

Le jeu. 27 juin 2019 =C3=A0 01:51, Kees Cook <keescook@chromium.org> a =C3=
=A9crit :
>
> On Tue, Jun 25, 2019 at 06:42:48PM +0200, Romain Perier wrote:
> > I have double checked.
> >
> > See, https://salsa.debian.org/rperier-guest/linux-tree/raw/next/STATUS
> >
> > Nothing worrying, it seems.
>
> Excellent; thanks! Do you want to remove this from the TODO list?
>
> --
> Kees Cook
