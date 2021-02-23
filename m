Return-Path: <SRS0=sWg3=HZ=lists.openwall.com=kernel-hardening-return-20813-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 550ADC433E0
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Feb 2021 09:44:21 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5694464E21
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Feb 2021 09:44:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5694464E21
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20813-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 14157 invoked by uid 550); 23 Feb 2021 09:44:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 14118 invoked from network); 23 Feb 2021 09:44:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xFUNYfoAYYZ5U7r3yHFujzogh6UJ0S50RxYLO9cPp+w=;
        b=eS73gj+iHW2wuI9NVEsDO4MrEqyPK5julr2w5aBMIXzNeCsECqmuyuN92d0zFONakw
         o45KxEEGbV2ZxYH8ytLSjUaeN9M7RTXbwF9AD6tKTJ1k243RO78d2dqLVh3DwTqK+ufE
         1+LzKBSRm0EW7fxvhEdocHgDGavL/dniHToaMWcYdVycgA9cT0BTLxZGu57IEfgjanmA
         WprKppK6NbsrkvRGNGmvu70AxXiiO5tK4dP4IyV5a8qHhFEg97PMZWT/k7GrbkA4P3tf
         x/LuGqct74WOub+ObQpQIogPRh6PcAp/MO59VBj8NssLxFYZ5rC4e9H8lGkGzi3kfN0z
         S5Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xFUNYfoAYYZ5U7r3yHFujzogh6UJ0S50RxYLO9cPp+w=;
        b=E9bFoKx12C43/S32agtQMO4u7qKBSvuFnYis7ta/p0Cz3+4Qfrf0N5ztrgIOAp26aZ
         DWVAP3gtUzQVOwOVFjiUIMq4QgRMCjuuKOXUyen7JaBcpq/GJox6sZf3yUr4ITctdqN5
         5wrQYv00eZ412BCy5odJfewBnS/fPFhHCPqhNr6bOIG5mUQocJBKQ6hzuMWEllBvogq0
         +YllDehZPqkxYEejMY+gXRhVOmLaRP2uWUGqTlw3YE7ChLrmVMt2OtnXHZiVEQO4WX33
         3EuzE6Zn5owaE/StbAH3A0sE7XYbqII4TGTUkIFQ+VD3ICpLTaYL8GdTeWHo700xxwgk
         LOew==
X-Gm-Message-State: AOAM5319FkwqdoLg3dn9O6Uun8AuaVR+nyewoV5w3nzR3ApfRKY+6voA
	mZLH5V1seKJipifbN5BVb5rBXw/8eO8PHd/YbTg=
X-Google-Smtp-Source: ABdhPJwEeNNR2R2QwWL+RQifym7o/7MjLIodn6vJMtyqCRkB0v7rYnpnoiIsyOK+IdQsSKKCUcs3qWNp1IW5399ZO18=
X-Received: by 2002:a9d:6c4c:: with SMTP id g12mr19953431otq.53.1614073439820;
 Tue, 23 Feb 2021 01:43:59 -0800 (PST)
MIME-Version: 1.0
References: <20210222151231.22572-1-romain.perier@gmail.com>
 <20210222151231.22572-12-romain.perier@gmail.com> <3b8dd556-8c09-9686-dec6-9d523a9762a8@roeck-us.net>
In-Reply-To: <3b8dd556-8c09-9686-dec6-9d523a9762a8@roeck-us.net>
From: Romain Perier <romain.perier@gmail.com>
Date: Tue, 23 Feb 2021 10:43:48 +0100
Message-ID: <CABgxDoLgJH4EYQgGkbWEJ=CFR1fQar6+Jcr3nARaPt__PO4jVQ@mail.gmail.com>
Subject: Re: [PATCH 11/20] hwmon: Manual replacement of the deprecated
 strlcpy() with return values
To: Guenter Roeck <linux@roeck-us.net>
Cc: Kees Cook <keescook@chromium.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-hwmon@vger.kernel.org, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/alternative; boundary="000000000000059e8e05bbfdc29f"

--000000000000059e8e05bbfdc29f
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le lun. 22 f=C3=A9vr. 2021 =C3=A0 16:46, Guenter Roeck <linux@roeck-us.net>=
 a =C3=A9crit :

> On 2/22/21 7:12 AM, Romain Perier wrote:
> > The strlcpy() reads the entire source buffer first, it is dangerous if
> > the source buffer lenght is unbounded or possibility non NULL-terminate=
d.
>
> length
>
> > It can lead to linear read overflows, crashes, etc...
> >
> Not here. This description is misleading.
>
> > As recommended in the deprecated interfaces [1], it should be replaced
> > by strscpy.
> >
> > This commit replaces all calls to strlcpy that handle the return values
> > by the corresponding strscpy calls with new handling of the return
> > values (as it is quite different between the two functions).
> >
> > [1]
> https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
> >
> > Signed-off-by: Romain Perier <romain.perier@gmail.com>
>
> This patch just adds pain to injury, as the source 'buffers' are all fixe=
d
> strings and their length will never exceed the maximum buffer length.
> I really don't see the point of using strscpy() in this situation.
>
>
Hi,

No, no insult or offense at all here (sorry if you understood like this, it
is not my intention ^^), it is just a general description of what the usage
of strlcpy might cause (the description is not specific to your code). The
initial idea was to globally replace all occurrences of the old by the new
functions (the old being deprecated for a reason), however, if some
maintainers disagree or don't think that their drivers are affected, no
problem we can exclude these from the patches series.

Romain

--000000000000059e8e05bbfdc29f
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr">Le=C2=A0lun. 22 f=C3=A9vr. 2021 =C3=A0=C2=
=A016:46, Guenter Roeck &lt;<a href=3D"mailto:linux@roeck-us.net">linux@roe=
ck-us.net</a>&gt; a =C3=A9crit=C2=A0:<br></div><div class=3D"gmail_quote"><=
blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-l=
eft:1px solid rgb(204,204,204);padding-left:1ex">On 2/22/21 7:12 AM, Romain=
 Perier wrote:<br>
&gt; The strlcpy() reads the entire source buffer first, it is dangerous if=
<br>
&gt; the source buffer lenght is unbounded or possibility non NULL-terminat=
ed.<br>
<br>
length<br>
<br>
&gt; It can lead to linear read overflows, crashes, etc...<br>
&gt; <br>
Not here. This description is misleading.<br>
<br>
&gt; As recommended in the deprecated interfaces [1], it should be replaced=
<br>
&gt; by strscpy.<br>
&gt; <br>
&gt; This commit replaces all calls to strlcpy that handle the return value=
s<br>
&gt; by the corresponding strscpy calls with new handling of the return<br>
&gt; values (as it is quite different between the two functions).<br>
&gt; <br>
&gt; [1] <a href=3D"https://www.kernel.org/doc/html/latest/process/deprecat=
ed.html#strlcpy" rel=3D"noreferrer" target=3D"_blank">https://www.kernel.or=
g/doc/html/latest/process/deprecated.html#strlcpy</a><br>
&gt; <br>
&gt; Signed-off-by: Romain Perier &lt;<a href=3D"mailto:romain.perier@gmail=
.com" target=3D"_blank">romain.perier@gmail.com</a>&gt;<br>
<br>
This patch just adds pain to injury, as the source &#39;buffers&#39; are al=
l fixed<br>
strings and their length will never exceed the maximum buffer length.<br>
I really don&#39;t see the point of using strscpy() in this situation.<br>
<br></blockquote><div><br></div><div>Hi,</div><div><br></div><div>No, no in=
sult or offense at all here (sorry if you understood like this, it is not m=
y intention ^^), it is just a general description of what the usage of strl=
cpy might cause (the description is not specific to your code). The initial=
 idea was to globally replace all occurrences of the old by the new functio=
ns (the old being deprecated for a reason), however, if some maintainers di=
sagree or don&#39;t think that their drivers are affected, no problem we ca=
n exclude these from the patches series.</div><div><br></div><div>Romain<br=
></div><div>=C2=A0</div></div></div>

--000000000000059e8e05bbfdc29f--
