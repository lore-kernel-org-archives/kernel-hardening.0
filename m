Return-Path: <SRS0=DwW9=DO=lists.openwall.com=kernel-hardening-return-20117-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BBEDC41604
	for <kernel-hardening@archiver.kernel.org>; Wed,  7 Oct 2020 15:16:53 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 25A6B20797
	for <kernel-hardening@archiver.kernel.org>; Wed,  7 Oct 2020 15:16:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IYCwbUUf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 25A6B20797
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20117-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24378 invoked by uid 550); 7 Oct 2020 15:16:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24342 invoked from network); 7 Oct 2020 15:16:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=si0tKTxTeVkWVj0BeoHFdzp7cmLXpxq6990uROthJtY=;
        b=IYCwbUUfjXo5J/iCuDKknYlMY8TBd0hIjogH4QKdlGfGkzyqxezRoJ+V0TKxL0aied
         paq085JeGRDaZ8Bd2sR5shIWq1NlsLQK1sGSy93fF86rJifq6RufD761/FikiCwHd5Rl
         wGqhOTBPFT16kkG2cyZn4AJEBVu3+8qJffG0vuws/PyGFh3ZaFSvy3hbYMHQTKUEZvsS
         LGEABAPPspWSTJWC3hZGIURtUHtrdx1NqQ4wtlVCqqtzjvyORtWOU4YWImOiT0IKOBVo
         Xq+xB7KiTGQG3DKFLxG4iTqgNIwBBAtLV0Z2W/27b/GJSvszG913EHBZiP+UnEGZZhf/
         xVqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=si0tKTxTeVkWVj0BeoHFdzp7cmLXpxq6990uROthJtY=;
        b=OYMQRfILbs3Kl16WHQJ+MMBfNJz10uH7YDCFp4058mWTHB/4bSHXiODFcUcoaWbV6Q
         dkYpwY0bRRY/BgweOMSqR5P2FGCGkmtGHSmQakfzek5okzijekS6wtZlY/XQT/2OY89r
         AjBurWp0QFyAxKMo4GvYR8NPBrQRiK8hggn/0VLu89g06PpeVLA6xg20MxmM/2RMZpwk
         t8ApgrcLtEQ49SEAw4IaVsTx4IZF2ie1ihnWdWM8MwZ/P8tzYhMhnQkerk5++ItItWq/
         ECPAhxKN0VZSbQb8ITrXfBKi6uaDAChkdqZFzk6ZlpgRoFMV5aW9NTRvm6HfQSsjnF4c
         gL8A==
X-Gm-Message-State: AOAM5315g1RkW/zZn6O/SgoxcRAha7TSvzTc58JYJWaZi1CM1WTpXaUM
	IQij//zCJbqXC959Acy4TI51/rgGj6c+nFxvplU=
X-Google-Smtp-Source: ABdhPJz6oi837cpEo5G5+iGaxLhrAN0tUMv20ViJxCxqGjwfi8qXSJoMn8MycoEBY14R+CIG6RL707SqqoO/K7ZrNt0=
X-Received: by 2002:a92:3608:: with SMTP id d8mr3126732ila.2.1602083790857;
 Wed, 07 Oct 2020 08:16:30 -0700 (PDT)
MIME-Version: 1.0
References: <202009281907.946FBE7B@keescook>
In-Reply-To: <202009281907.946FBE7B@keescook>
From: Romain Perier <romain.perier@gmail.com>
Date: Wed, 7 Oct 2020 17:16:19 +0200
Message-ID: <CABgxDo+t3ssWP109UiDjzroowU_h2HscUwty1U-8mReiTAnkkA@mail.gmail.com>
Subject: Re: Linux-specific kernel hardening
To: Kees Cook <keescook@chromium.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-hardening@vger.kernel.org
Content-Type: multipart/alternative; boundary="00000000000041288e05b116334a"

--00000000000041288e05b116334a
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Great!
Don't send anything else, we have the perfect amount of archived
discussions already! ( that is currently* 42*)

:P

Regards,
Romain



Le mar. 29 sept. 2020 =C3=A0 20:19, Kees Cook <keescook@chromium.org> a =C3=
=A9crit :

> Hello!
>
> The work of improving the Linux kernel's security is, of course,
> and endless task. While many of the new features come through on the
> kernel-hardening@lists.openwall.com list[1], there is a stated desire
> to avoid "maintenance" topics[2] on the list, and that isn't compatible
> with the on-going work done within the upstream Linux kernel development
> community, which may need to discuss the nuances of performing that work.
>
> As such there is now a new list, linux-hardening@vger.kernel.org[3],
> which will take kernel-hardening's place in the Linux MAINTAINERS
> file. New topics and on-going work will be discussed there, and I urge
> anyone interested in Linux kernel hardening to join the new list. It's
> my intention that all future upstream work can be CCed there, following
> the standard conventions of the Linux development model, for better or
> worse. ;)
>
> For anyone discussing new topics or ideas, please continue to CC
> kernel-hardening too, as there will likely be many people only subscribed
> there. Hopefully this will get the desired split of topics between the
> two lists.
>
> Thanks and take care,
>
> -Kees
>
> [1] https://www.openwall.com/lists/kernel-hardening/
>     https://lore.kernel.org/kernel-hardening/
>
> [2]
> https://lore.kernel.org/kernel-hardening/20200902121604.GA10684@openwall.=
com/
>
> [3] http://vger.kernel.org/vger-lists.html#linux-hardening
>     https://lore.kernel.org/linux-hardening/
>
> --
> Kees Cook
>

--00000000000041288e05b116334a
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi,</div><div><br></div><div>Great!</div><div>Don&#39=
;t send anything else, we have the perfect amount of archived discussions a=
lready! ( that is currently<b> 42</b>)<br></div><div><br></div><div>:P</div=
><div><br></div><div>Regards,<br></div><div>Romain<br></div><div><div><br><=
/div><div><br>

</div></div></div><br><div class=3D"gmail_quote"><div dir=3D"ltr" class=3D"=
gmail_attr">Le=C2=A0mar. 29 sept. 2020 =C3=A0=C2=A020:19, Kees Cook &lt;<a =
href=3D"mailto:keescook@chromium.org" target=3D"_blank">keescook@chromium.o=
rg</a>&gt; a =C3=A9crit=C2=A0:<br></div><blockquote class=3D"gmail_quote" s=
tyle=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);pad=
ding-left:1ex">Hello!<br>
<br>
The work of improving the Linux kernel&#39;s security is, of course,<br>
and endless task. While many of the new features come through on the<br>
<a href=3D"mailto:kernel-hardening@lists.openwall.com" target=3D"_blank">ke=
rnel-hardening@lists.openwall.com</a> list[1], there is a stated desire<br>
to avoid &quot;maintenance&quot; topics[2] on the list, and that isn&#39;t =
compatible<br>
with the on-going work done within the upstream Linux kernel development<br=
>
community, which may need to discuss the nuances of performing that work.<b=
r>
<br>
As such there is now a new list, <a href=3D"mailto:linux-hardening@vger.ker=
nel.org" target=3D"_blank">linux-hardening@vger.kernel.org</a>[3],<br>
which will take kernel-hardening&#39;s place in the Linux MAINTAINERS<br>
file. New topics and on-going work will be discussed there, and I urge<br>
anyone interested in Linux kernel hardening to join the new list. It&#39;s<=
br>
my intention that all future upstream work can be CCed there, following<br>
the standard conventions of the Linux development model, for better or<br>
worse. ;)<br>
<br>
For anyone discussing new topics or ideas, please continue to CC<br>
kernel-hardening too, as there will likely be many people only subscribed<b=
r>
there. Hopefully this will get the desired split of topics between the<br>
two lists.<br>
<br>
Thanks and take care,<br>
<br>
-Kees<br>
<br>
[1] <a href=3D"https://www.openwall.com/lists/kernel-hardening/" rel=3D"nor=
eferrer" target=3D"_blank">https://www.openwall.com/lists/kernel-hardening/=
</a><br>
=C2=A0 =C2=A0 <a href=3D"https://lore.kernel.org/kernel-hardening/" rel=3D"=
noreferrer" target=3D"_blank">https://lore.kernel.org/kernel-hardening/</a>=
<br>
<br>
[2] <a href=3D"https://lore.kernel.org/kernel-hardening/20200902121604.GA10=
684@openwall.com/" rel=3D"noreferrer" target=3D"_blank">https://lore.kernel=
.org/kernel-hardening/20200902121604.GA10684@openwall.com/</a><br>
<br>
[3] <a href=3D"http://vger.kernel.org/vger-lists.html#linux-hardening" rel=
=3D"noreferrer" target=3D"_blank">http://vger.kernel.org/vger-lists.html#li=
nux-hardening</a><br>
=C2=A0 =C2=A0 <a href=3D"https://lore.kernel.org/linux-hardening/" rel=3D"n=
oreferrer" target=3D"_blank">https://lore.kernel.org/linux-hardening/</a><b=
r>
<br>
-- <br>
Kees Cook<br>
</blockquote></div>

--00000000000041288e05b116334a--
