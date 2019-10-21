Return-Path: <SRS0=CIZV=YO=lists.openwall.com=kernel-hardening-return-17077-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BF4FCA9EAF
	for <kernel-hardening@archiver.kernel.org>; Mon, 21 Oct 2019 10:22:27 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E36C12084C
	for <kernel-hardening@archiver.kernel.org>; Mon, 21 Oct 2019 10:22:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X3tDozxU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E36C12084C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17077-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17572 invoked by uid 550); 21 Oct 2019 10:22:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17536 invoked from network); 21 Oct 2019 10:22:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6xiAvDrnQ8e4TWZ4wtLKKrmaQ/Ia4CwZwFpjoEe4UQ8=;
        b=X3tDozxU+c+ARu2/sV9/ob1xVrQOXPDtKLMC+QE/uJM7h0/mKF4PO7XajZ2jdE+c05
         dzfV1+uLP/5vhTPvA2NNOTFO1TJwcibTEmNo7yQu7bz4U3S6H328YddrN2LJGGRxrkbN
         gSs40lciNiuPf3ilzQcKpAgZRW9tLODFswmSEf5SQo1zwGs6xU4BXg+PnlLTcr5NrQyV
         9yGJ3FwyO8lyevtf1Ufxd9m5GXMskpOthLLzDIJbOpIbJ9p+fECsN6s1JWzurYkAMxHR
         Ls/LX4o+ZInAMb74bcwqGWqTNMYTH0TWzbXlKJdJbXk1qc+/AAdeNIIC21YQfpFx/UEJ
         Zysw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6xiAvDrnQ8e4TWZ4wtLKKrmaQ/Ia4CwZwFpjoEe4UQ8=;
        b=f69BRYuCcZCboVPpGFefTWYbHadT+u88sUDy57Pe/P2qOIgLVQrvJD0o0fB2qS0nYp
         MAo+Hkh21zJU3MduQRIp/ypZ50svF7gBcEdikJSxzJGzk5fErpqMyTbeXQWP3nZ45zOe
         42lB1TmqeyAKiikf4PIz8gfju9QcyKCYejMPi82T4DhQmIVTmSYnhYeOeJRfMRTX2qpt
         F+FMHh3pHqoums4xstA3fwmOwIwiShac+kOXL2OAyaugUoq/lhuEf4hfTI/wieHTheTt
         yH5zviG7CgGhZYCDNvXou4M3MolN4cnQ7QKjQovcB2aUCLugSRVTwuA0b/7nCZVn6Hts
         qd8Q==
X-Gm-Message-State: APjAAAXxM7eP9+oLvFEQUE4YrNVMvGhzn+rG3SdccTNLcD/nD6Hl1qEn
	+nt1C5OeoETx/BTIrTiUIcurEkVfVMyFxKvOz5U=
X-Google-Smtp-Source: APXvYqxar7eiW0LM5LvhCA63H9av+KqG9mcipqZ5MU8KxCvxJ2vHAINjBYfGTsCfPfC6R2EwS801PmdpTUYQO8wHNgA=
X-Received: by 2002:a92:8749:: with SMTP id d9mr10892308ilm.94.1571653327743;
 Mon, 21 Oct 2019 03:22:07 -0700 (PDT)
MIME-Version: 1.0
References: <2e2a3d3c-872e-3d07-5585-92734a532ef2@gmail.com> <CABob6iq_N8He+ORZuRVqdDhBCuymSwVyRHCsW8GAzXcM8+_tuA@mail.gmail.com>
In-Reply-To: <CABob6iq_N8He+ORZuRVqdDhBCuymSwVyRHCsW8GAzXcM8+_tuA@mail.gmail.com>
From: youling 257 <youling257@gmail.com>
Date: Mon, 21 Oct 2019 18:22:02 +0800
Message-ID: <CAOzgRdbFc_WJDaOg5vdq5Y=nL+vyApCDCGFb-AUo6f=GRSDQWQ@mail.gmail.com>
Subject: Re: How to get the crash dump if system hangs?
To: Lukas Odzioba <lukas.odzioba@gmail.com>
Cc: keescook@chromium.org, kernel-hardening@lists.openwall.com, 
	munisekharrms@gmail.com
Content-Type: multipart/alternative; boundary="0000000000004f72750595690e54"

--0000000000004f72750595690e54
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

When add cmdline memmap=3D1M!2047M, the iomem will be 7ef00001-7fefffff : R=
AM
buffer 7ff00000-7fffffff : Persistent Memory (legacy) 7ff00000-7ff00fff :
MSFT0101:00,
so ramoops.mem_address=3D0x7ff00000.

Lukas Odzioba <lukas.odzioba@gmail.com> =E4=BA=8E 2019=E5=B9=B410=E6=9C=882=
1=E6=97=A5=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=884:39=E5=86=99=E9=81=93=EF=BC=
=9A

> youling257 <youling257@gmail.com> wrote:
> >
> > I don't know my ramoops.mem_address, please help me.
> >
> > what is ramoops.mem_address?
>
> It is a Linux kernel parameter, see documentation below:
> https://www.kernel.org/doc/Documentation/admin-guide/ramoops.rst
>
> It requires memory which can hold data between reboots, so i'm not
> sure how it will suit your case.
>
> Thanks,
> Lukas
>

--0000000000004f72750595690e54
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><div>When add cmdline memmap=3D1M!2047M, the iomem will b=
e 7ef00001-7fefffff : RAM buffer 7ff00000-7fffffff : Persistent Memory (leg=
acy) 7ff00000-7ff00fff : MSFT0101:00,</div><div dir=3D"auto">so ramoops.mem=
_address=3D0x7ff00000.</div><div dir=3D"auto"><br><div class=3D"gmail_quote=
" dir=3D"auto"><div dir=3D"ltr" class=3D"gmail_attr">Lukas Odzioba &lt;<a h=
ref=3D"mailto:lukas.odzioba@gmail.com">lukas.odzioba@gmail.com</a>&gt; =E4=
=BA=8E 2019=E5=B9=B410=E6=9C=8821=E6=97=A5=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=
=8D=884:39=E5=86=99=E9=81=93=EF=BC=9A<br></div><blockquote class=3D"gmail_q=
uote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1e=
x">youling257 &lt;<a href=3D"mailto:youling257@gmail.com" target=3D"_blank"=
 rel=3D"noreferrer">youling257@gmail.com</a>&gt; wrote:<br>
&gt;<br>
&gt; I don&#39;t know my ramoops.mem_address, please help me.<br>
&gt;<br>
&gt; what is ramoops.mem_address?<br>
<br>
It is a Linux kernel parameter, see documentation below:<br>
<a href=3D"https://www.kernel.org/doc/Documentation/admin-guide/ramoops.rst=
" rel=3D"noreferrer noreferrer" target=3D"_blank">https://www.kernel.org/do=
c/Documentation/admin-guide/ramoops.rst</a><br>
<br>
It requires memory which can hold data between reboots, so i&#39;m not<br>
sure how it will suit your case.<br>
<br>
Thanks,<br>
Lukas<br>
</blockquote></div></div></div>

--0000000000004f72750595690e54--
