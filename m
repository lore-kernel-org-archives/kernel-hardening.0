Return-Path: <SRS0=W0NB=DU=lists.openwall.com=kernel-hardening-return-20199-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B28D5C433DF
	for <kernel-hardening@archiver.kernel.org>; Tue, 13 Oct 2020 18:33:02 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 906ED208D5
	for <kernel-hardening@archiver.kernel.org>; Tue, 13 Oct 2020 18:33:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HLs40/UJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 906ED208D5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20199-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13505 invoked by uid 550); 13 Oct 2020 18:32:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13469 invoked from network); 13 Oct 2020 18:32:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vuhHKj8oJjmu0Y1ZhMf4WKBAQebNoS6+UTZf2tN+Ki8=;
        b=HLs40/UJJ76kidkD9z4IY5tPjsLmsq9QFAEqbHGnNDZxwToGY3bwjPHOSEWN3+fP7Z
         0S3Wu9iAiCZGeaMrVEC3A86iz+C/0oq9ZE7B9bBsW7DSyOVROORLVdBzf+VAvQjSbT2r
         GchEdwJuPQ14McSbp2dmsH995sq0IMld9033CCT+wBXexnHTJKFUDRnzCuO9xym4OaaR
         JZjKCiOR9ysPrmDWyVV8TLsy/+Xbq5yOVqo6yTACFSDraH+GGH4ITi0MSgnGSJD9Z65e
         bSkQxmAXdAxJipLm162FZ24TfHmATOH6NVz62O/ixJaj6ZQPI8yqq8qkzhNMS/EzFq3q
         Z21A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vuhHKj8oJjmu0Y1ZhMf4WKBAQebNoS6+UTZf2tN+Ki8=;
        b=VppSlm3wm7w73KRqrWDlTq/wdxhJuO63s5tBuYRfV1xjLDqGsxmNXhgToxkdwCG+r2
         d1kmWiOB3YfQm1ew0AFiUns0078fFtQw0fNRz0mALDHYnb4PUXH2jIpLjZt15VnZONSK
         LF0m6BeQO6JlR0FtylrvCVrRJQhcmu+Zq28p4e7RwPOfmApNWSUfCmvtOlYzCmzWrqJD
         XSzl+FCLmiv5Q9Wap+L3I2CHrSCpZ4VlNqgmB2h2Ob70ZaY+oFdYVpJI3vpdPloyPvLD
         jQgb8KI+pFsxT5cj5UbPHmJexYhrrQMqUYZE1imjTuE/RMfEurQfQWolmQeEiSpdiSuq
         abmQ==
X-Gm-Message-State: AOAM5337MNYkKqugbybZHjfN8eGJ4vsjCzFmOHoI7tAi+zKVXIBE7xRh
	OL0xWz0gF5JaDVJ7uyaLAyG8oq2sWTM7FBY2+hw=
X-Google-Smtp-Source: ABdhPJxUlOL8LsZ6BkcMzDc2N+qRC9sDgrkBifRK0tolt7UIjtHaINSYjczKE5ixxnR0/A4jQpWFeNOVf3ptJCsRqD8=
X-Received: by 2002:a6b:d80d:: with SMTP id y13mr142088iob.15.1602613961036;
 Tue, 13 Oct 2020 11:32:41 -0700 (PDT)
MIME-Version: 1.0
References: <CABgxDoJwP+5Z3qUKuv3Tr=P24eGidk2cjO+yq0y_NwNmSbvQKA@mail.gmail.com>
 <202010121201.6ED466E1C7@keescook>
In-Reply-To: <202010121201.6ED466E1C7@keescook>
From: Romain Perier <romain.perier@gmail.com>
Date: Tue, 13 Oct 2020 20:32:29 +0200
Message-ID: <CABgxDo+W6ptdF9O9N9v5_f=eD+KnCWaVru8hoqwb9iQcgAp8gg@mail.gmail.com>
Subject: Re: Remove all strlcpy() uses in favor of strscpy() (#89)
To: Kees Cook <keescook@chromium.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-hardening@vger.kernel.org
Content-Type: multipart/alternative; boundary="000000000000dc17e305b191a389"

--000000000000dc17e305b191a389
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kees,

If it is easier for you to discuss here, np for me (I have posted a comment
on #89 but feel free to reply here).
Yep, I have took the "treewide" approach. It is preferable to fix
nla_strlcpy into a separated contribution, or I can fix it too?

Romain

Le lun. 12 oct. 2020 =C3=A0 21:03, Kees Cook <keescook@chromium.org> a =C3=
=A9crit :

> On Sun, Oct 11, 2020 at 08:24:19AM +0200, Romain Perier wrote:
> > That's just to let you know that I start to work on this task,
> > I have also added a comment on the bugtracker.
>
> Okay, great; thanks! I'll reply there; it looks like there are several
> approaches that could be taken.
>
> (For reference, this is https://github.com/KSPP/linux/issues/89 )
>
> --
> Kees Cook
>

--000000000000dc17e305b191a389
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi Kees,</div><div><br></div><div>If it is easier for=
 you to discuss here, np for me (I have posted a comment on #89 but feel fr=
ee to reply here).</div><div>Yep, I have took the &quot;treewide&quot; appr=
oach. It is preferable to fix nla_strlcpy into a separated contribution, or=
 I can fix it too?</div><div><br></div><div>Romain<br></div></div><br><div =
class=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmail_attr">Le=C2=A0lun. 12=
 oct. 2020 =C3=A0=C2=A021:03, Kees Cook &lt;<a href=3D"mailto:keescook@chro=
mium.org">keescook@chromium.org</a>&gt; a =C3=A9crit=C2=A0:<br></div><block=
quote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1=
px solid rgb(204,204,204);padding-left:1ex">On Sun, Oct 11, 2020 at 08:24:1=
9AM +0200, Romain Perier wrote:<br>
&gt; That&#39;s just to let you know that I start to work on this task,<br>
&gt; I have also added a comment on the bugtracker.<br>
<br>
Okay, great; thanks! I&#39;ll reply there; it looks like there are several<=
br>
approaches that could be taken.<br>
<br>
(For reference, this is <a href=3D"https://github.com/KSPP/linux/issues/89"=
 rel=3D"noreferrer" target=3D"_blank">https://github.com/KSPP/linux/issues/=
89</a> )<br>
<br>
-- <br>
Kees Cook<br>
</blockquote></div>

--000000000000dc17e305b191a389--
