Return-Path: <SRS0=4Ut+=H6=lists.openwall.com=kernel-hardening-return-20862-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39DBDC433DB
	for <kernel-hardening@archiver.kernel.org>; Sun, 28 Feb 2021 16:00:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F2F3A64DA3
	for <kernel-hardening@archiver.kernel.org>; Sun, 28 Feb 2021 16:00:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F2F3A64DA3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20862-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13821 invoked by uid 550); 28 Feb 2021 16:00:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13788 invoked from network); 28 Feb 2021 16:00:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=d4sxdORW23b0pSArg3qYJV0WueychNIK8cEhEhzB5pE=;
        b=oUSnFa/1N5ZH1xYtopqzj+yc26ojQNtbrUS6hFVtqtAFcfVjTOr1klwx1TbBHeDX3S
         +nKHXNmv0dN+NG1ijwNmgcmx0GJZ6j2mz1wBvmrwb5lQF/Hj2nCgZhXFzdUf7on4NfBM
         Iq/OVoJoT9zJP62BF/76iB3vZZhlQZpOUw36gXe0GxF+7vxEVz4eC8wuRZramn4HzK3F
         zMnaa0RFW2Ym7+4Mbxpk9Z+dyLZJ5/933z8DZQy5KgDee8T42i/gUOWyCwgWdQ4mw3W+
         8hwpqhsC52o0y+y8VQ7uXLI2jv1lObnd6dORXuZkUmobddwpA0TmgUHnCqb/oinN63UZ
         N/iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=d4sxdORW23b0pSArg3qYJV0WueychNIK8cEhEhzB5pE=;
        b=mYSPt89J0fCeUH43sb2opLj6IfoIgFtzQDJXjDJsD46hd0ikattoD7G/S0snfVFl8e
         9FH0bV7VeYfCmmLTMdxWmdsNwBNhXkoqkH7xYeVMHCjJUfR7SwcWz8k29ip71KKoP8CF
         okn1x6X3HNTZscZ+u3mSbzYAHklWB7UnXzDRW149OyVs33rG71xlXssh8dRCD25xJjZ5
         5Rpbe5+TwJrXk5nhPQ1Bl0TDMsEAkzT94pzYwouo8Pc6UA67314X9MnD8SohftaMiXKr
         ratoY5nt95eGZ19fPtZzKI0W6LrhU9zoLq9prQmqM9difQABdnf5xexNXdyOi9tB1wzw
         TV7Q==
X-Gm-Message-State: AOAM533jN4ypaJWgu9Gbtd+cbULGgw6qLZ5b1kFFZb7uZmiX4nld0np7
	hlreXdJhgxNC7P6+8oxb2sFdc8Y/qdf6Eumcw2Y=
X-Google-Smtp-Source: ABdhPJwWQAW+EAS58BZaGvOwZqzll0efo1KTlXTKiRL4tmAmFLZgakGwTs/H/MskMuKgU3BAA52cci2E6/uHNAt/HvE=
X-Received: by 2002:a62:1ad4:0:b029:1ed:b92c:6801 with SMTP id
 a203-20020a621ad40000b02901edb92c6801mr11261226pfa.7.1614528009663; Sun, 28
 Feb 2021 08:00:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20210222151231.22572-20-romain.perier@gmail.com>
References: <20210222151231.22572-1-romain.perier@gmail.com> <20210222151231.22572-20-romain.perier@gmail.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Sun, 28 Feb 2021 18:00:09 +0200
Message-ID: <CAHp75VcfW6rv3Z1cz_D-XkX+_CGo9r6q9EAhVFibKM27TLQPGw@mail.gmail.com>
Subject: Re: [PATCH 19/20] usbip: usbip_host: Manual replacement of the
 deprecated strlcpy() with return values
To: Romain Perier <romain.perier@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, 
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Valentina Manea <valentina.manea.m@gmail.com>, 
	Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, 
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: multipart/alternative; boundary="0000000000007ef8d205bc6798fe"

--0000000000007ef8d205bc6798fe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Monday, February 22, 2021, Romain Perier <romain.perier@gmail.com> wrote=
:

> The strlcpy() reads the entire source buffer first, it is dangerous if
> the source buffer lenght is unbounded or possibility non NULL-terminated.
> It can lead to linear read overflows, crashes, etc...
>
> As recommended in the deprecated interfaces [1], it should be replaced
> by strscpy.
>
> This commit replaces all calls to strlcpy that handle the return values
> by the corresponding strscpy calls with new handling of the return
> values (as it is quite different between the two functions).
>
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcp=
y
>
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> ---
>  drivers/usb/usbip/stub_main.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/usb/usbip/stub_main.c b/drivers/usb/usbip/stub_main.=
c
> index 77a5b3f8736a..5bc2c09c0d10 100644
> --- a/drivers/usb/usbip/stub_main.c
> +++ b/drivers/usb/usbip/stub_main.c
> @@ -167,15 +167,15 @@ static ssize_t match_busid_show(struct device_drive=
r
> *drv, char *buf)
>  static ssize_t match_busid_store(struct device_driver *dev, const char
> *buf,
>                                  size_t count)
>  {
> -       int len;
> +       ssize_t len;
>         char busid[BUSID_SIZE];
>
>         if (count < 5)
>                 return -EINVAL;
>
>         /* busid needs to include \0 termination */
> -       len =3D strlcpy(busid, buf + 4, BUSID_SIZE);
> -       if (sizeof(busid) <=3D len)
> +       len =3D strscpy(busid, buf + 4, BUSID_SIZE);
> +       if (len =3D=3D -E2BIG)
>                 return -EINVAL;
>
>
I=E2=80=99m wondering why you shadow the initial error. Should not be bette=
r

if (Len < 0)
  return Len;

?



>         if (!strncmp(buf, "add ", 4)) {
>
>

--=20
With Best Regards,
Andy Shevchenko

--0000000000007ef8d205bc6798fe
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<br><br>On Monday, February 22, 2021, Romain Perier &lt;<a href=3D"mailto:r=
omain.perier@gmail.com">romain.perier@gmail.com</a>&gt; wrote:<br><blockquo=
te class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc so=
lid;padding-left:1ex">The strlcpy() reads the entire source buffer first, i=
t is dangerous if<br>
the source buffer lenght is unbounded or possibility non NULL-terminated.<b=
r>
It can lead to linear read overflows, crashes, etc...<br>
<br>
As recommended in the deprecated interfaces [1], it should be replaced<br>
by strscpy.<br>
<br>
This commit replaces all calls to strlcpy that handle the return values<br>
by the corresponding strscpy calls with new handling of the return<br>
values (as it is quite different between the two functions).<br>
<br>
[1] <a href=3D"https://www.kernel.org/doc/html/latest/process/deprecated.ht=
ml#strlcpy" target=3D"_blank">https://www.kernel.org/doc/<wbr>html/latest/p=
rocess/<wbr>deprecated.html#strlcpy</a><br>
<br>
Signed-off-by: Romain Perier &lt;<a href=3D"mailto:romain.perier@gmail.com"=
>romain.perier@gmail.com</a>&gt;<br>
---<br>
=C2=A0drivers/usb/usbip/stub_main.c |=C2=A0 =C2=A0 6 +++---<br>
=C2=A01 file changed, 3 insertions(+), 3 deletions(-)<br>
<br>
diff --git a/drivers/usb/usbip/stub_main.<wbr>c b/drivers/usb/usbip/stub_ma=
in.<wbr>c<br>
index 77a5b3f8736a..5bc2c09c0d10 100644<br>
--- a/drivers/usb/usbip/stub_main.<wbr>c<br>
+++ b/drivers/usb/usbip/stub_main.<wbr>c<br>
@@ -167,15 +167,15 @@ static ssize_t match_busid_show(struct device_driver =
*drv, char *buf)<br>
=C2=A0static ssize_t match_busid_store(struct device_driver *dev, const cha=
r *buf,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0size_t count)<br>
=C2=A0{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0int len;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0ssize_t len;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char busid[BUSID_SIZE];<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (count &lt; 5)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EINVAL;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* busid needs to include \0 termination */<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0len =3D strlcpy(busid, buf + 4, BUSID_SIZE);<br=
>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (sizeof(busid) &lt;=3D len)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0len =3D strscpy(busid, buf + 4, BUSID_SIZE);<br=
>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (len =3D=3D -E2BIG)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EINVAL;<br>
<br></blockquote><div><br></div><div>I=E2=80=99m wondering why you shadow t=
he initial error. Should not be better=C2=A0</div><div><br></div><div>if (L=
en &lt; 0)</div><div>=C2=A0 return Len;</div><div><br></div><div>?</div><di=
v><br></div><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"mar=
gin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!strncmp(buf, &quot;add &quot;, 4)) {<br>
<br>
</blockquote><br><br>-- <br>With Best Regards,<br>Andy Shevchenko<br><br><b=
r>

--0000000000007ef8d205bc6798fe--
