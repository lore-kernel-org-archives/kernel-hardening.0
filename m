Return-Path: <SRS0=TcgQ=IC=lists.openwall.com=kernel-hardening-return-20873-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 570E4C433E0
	for <kernel-hardening@archiver.kernel.org>; Thu,  4 Mar 2021 10:09:11 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9767064F0A
	for <kernel-hardening@archiver.kernel.org>; Thu,  4 Mar 2021 10:09:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9767064F0A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20873-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9660 invoked by uid 550); 4 Mar 2021 10:09:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9627 invoked from network); 4 Mar 2021 10:09:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OEUiKzYCcawIW7E6XaqnAykbSQ9VcOEA92FGbPakSRw=;
        b=Q63TEOOre7PLkYiCsEe1OXSE1ePYw66J2FVoCmVfxuW6VnfXmTlli6IETqw6NOY1Q3
         426tiXz/yuPKGm2BOSy3KnvLaVjsB6cNhSq3JQUo+ZYBXftZwZbZHufiCpPva9sBq35J
         gy9AVmQiVi/cECYE9poLB8hEDXfV9K8aYoWRp/GSqIjk/XFdR1XES3hfojulsgjDgHQO
         02zwEdJdeLVFMEoRK1uvJP7RwWEqVfPe4ykvgo2a1qIiU1CCg0O5udkfcrD06wj2eP1z
         IozKi7ALHjLgbP4UbFYRoqYJfueo11Uf3Dbv+GxYIIW4YMit3lidnJzYnpM1RdFTNa6D
         gVTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OEUiKzYCcawIW7E6XaqnAykbSQ9VcOEA92FGbPakSRw=;
        b=tr2TblmNj1/hAqC2JCmN9GmErpaHSRJCKsvNB30Sxt9Zfkfj3/vQ7/934PAO+eUSYS
         wNGQwjlScdsSPzzbR+M8rsOpOmoNmix/xHdA44pUpERP42AQvebEBND/7GmC5Ib2GGvP
         h+M8GvfhY6Q1MKc3AYHqeyPaZR2ejDR75fcpe/d15bHSCkkuNL8AeEm8MD9E59C0rqqG
         j5eda3MM+14at0VLmS1Lch/MV1tbobO+lOyfnxjOfdVShHjNjyJsLUnn1/WcBCIiOjjt
         C0K2mzEmi+MCNozvj3DIi0t2Dc5H4t2JVcxqWnxdnIoHSefRbI2TMS5kED2XVZNC2uOz
         3t3w==
X-Gm-Message-State: AOAM5327tx7TvjkmqOpLPnuvH/3vTj3yZIdr7jo+wmVO2EHUf+XijnMc
	FkPSr9cnEkE5e0XQSoFLsgK1vZNKwjnNxHYMPl4=
X-Google-Smtp-Source: ABdhPJzAkei7GZVyieltReSS3+sM6gow6EuNpbrLFRMOtEN+mbkZSZvuWos4YHPdqpBwgqyaTagceqyXJ74oA5UJF8k=
X-Received: by 2002:a05:6820:58:: with SMTP id v24mr2690378oob.55.1614852530317;
 Thu, 04 Mar 2021 02:08:50 -0800 (PST)
MIME-Version: 1.0
References: <20210222151231.22572-1-romain.perier@gmail.com>
 <20210222151231.22572-3-romain.perier@gmail.com> <20210304043711.GA25928@gondor.apana.org.au>
In-Reply-To: <20210304043711.GA25928@gondor.apana.org.au>
From: Romain Perier <romain.perier@gmail.com>
Date: Thu, 4 Mar 2021 11:08:39 +0100
Message-ID: <CABgxDo+puf5P__TDXP5kG6mgCLejxuEwWY0yt-+kPUj2qmCFrQ@mail.gmail.com>
Subject: Re: [PATCH 02/20] crypto: Manual replacement of the deprecated
 strlcpy() with return values
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Kees Cook <keescook@chromium.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	"David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/alternative; boundary="0000000000006f2fe505bcb327fe"

--0000000000006f2fe505bcb327fe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le jeu. 4 mars 2021 =C3=A0 05:37, Herbert Xu <herbert@gondor.apana.org.au> =
a
=C3=A9crit :

> On Mon, Feb 22, 2021 at 04:12:13PM +0100, Romain Perier wrote:
> >
> > diff --git a/crypto/lrw.c b/crypto/lrw.c
> > index bcf09fbc750a..4d35f4439012 100644
> > --- a/crypto/lrw.c
> > +++ b/crypto/lrw.c
> > @@ -357,10 +357,10 @@ static int lrw_create(struct crypto_template
> *tmpl, struct rtattr **tb)
> >        * cipher name.
> >        */
> >       if (!strncmp(cipher_name, "ecb(", 4)) {
> > -             unsigned len;
> > +             ssize_t len;
> >
> > -             len =3D strlcpy(ecb_name, cipher_name + 4, sizeof(ecb_nam=
e));
> > -             if (len < 2 || len >=3D sizeof(ecb_name))
> > +             len =3D strscpy(ecb_name, cipher_name + 4, sizeof(ecb_nam=
e));
> > +             if (len =3D=3D -E2BIG || len < 2)
>
> len =3D=3D -E2BIG is superfluous as len < 2 will catch it anyway.
>
> Thanks,
>
>
Hello,

Yeah that's fixed in v2.

Thanks,
Romain

--0000000000006f2fe505bcb327fe
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote">=
<div dir=3D"ltr" class=3D"gmail_attr">Le=C2=A0jeu. 4 mars 2021 =C3=A0=C2=A0=
05:37, Herbert Xu &lt;<a href=3D"mailto:herbert@gondor.apana.org.au">herber=
t@gondor.apana.org.au</a>&gt; a =C3=A9crit=C2=A0:<br></div><blockquote clas=
s=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid r=
gb(204,204,204);padding-left:1ex">On Mon, Feb 22, 2021 at 04:12:13PM +0100,=
 Romain Perier wrote:<br>
&gt;<br>
&gt; diff --git a/crypto/lrw.c b/crypto/lrw.c<br>
&gt; index bcf09fbc750a..4d35f4439012 100644<br>
&gt; --- a/crypto/lrw.c<br>
&gt; +++ b/crypto/lrw.c<br>
&gt; @@ -357,10 +357,10 @@ static int lrw_create(struct crypto_template *tm=
pl, struct rtattr **tb)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 * cipher name.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!strncmp(cipher_name, &quot;ecb(&quot;, =
4)) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned len;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ssize_t len;<br>
&gt;=C2=A0 <br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0len =3D strlcpy(ecb_n=
ame, cipher_name + 4, sizeof(ecb_name));<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (len &lt; 2 || len=
 &gt;=3D sizeof(ecb_name))<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0len =3D strscpy(ecb_n=
ame, cipher_name + 4, sizeof(ecb_name));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (len =3D=3D -E2BIG=
 || len &lt; 2)<br>
<br>
len =3D=3D -E2BIG is superfluous as len &lt; 2 will catch it anyway.<br>
<br>
Thanks,<br><br></blockquote><div><br></div><div>Hello,</div><div><br></div>=
<div>Yeah that&#39;s fixed in v2.</div><div><br></div><div>Thanks,</div><di=
v>Romain<br></div></div></div>

--0000000000006f2fe505bcb327fe--
