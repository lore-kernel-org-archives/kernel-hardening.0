Return-Path: <SRS0=Q59r=ZV=lists.openwall.com=kernel-hardening-return-17450-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A74C7C432C0
	for <kernel-hardening@archiver.kernel.org>; Fri, 29 Nov 2019 17:32:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F3AB321736
	for <kernel-hardening@archiver.kernel.org>; Fri, 29 Nov 2019 17:32:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PEPVu47G"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F3AB321736
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17450-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10000 invoked by uid 550); 29 Nov 2019 17:32:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9959 invoked from network); 29 Nov 2019 17:32:39 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kBBp2emJoDECyrQnVYs4diBFbHaf6j6lX2z+09U6ZTc=;
        b=PEPVu47G2DbrT2XNsQzAtIuCFXtpOYEKf2nbSMue3ok0IsxT8sU7w2MCClv7OFx5Jo
         2DorGszelqb/NqAVetHogdY4Ffy7LqULneEa41nHFo/Zi+nYW6Zt0cfBox3sb8U5h3bo
         0oky8CFJ3HVnKd+GQGgkNisioyi03LOTRe/UZRAIJrlc02mrst8Yn4ho9NwonrYMBl8o
         NXpEyLKuvIjMVHjDGKxqVIrYvEBY0vpbxpcKSMkcdkeX/vR+0SqrZxUtvJ0gDu3hZ+uY
         xccYdw9KDqy69Ujs8pjbH6DimZpvZ9MzF8pfw4BwmD8QFRrdexnyKK2n1wR7+JnVwXnD
         84rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kBBp2emJoDECyrQnVYs4diBFbHaf6j6lX2z+09U6ZTc=;
        b=WZqExkIlC8yr5dOZbVC9ZJpeewwD2lW2HL4KwiGPkSbzdfysV3UGT3EfN1If7K2GSC
         lLAHCl/xS3b5KC6aauZ5noM99mSy4gVxCSzju45jZcW1Yf53Z3440nqEW1LlPut0SL+u
         ajIZSbZ6MlC/1sX4MPfPU07mVRyy0GyVRs/IKOTiHHPlYVrnxcw3i+G8rbfrepxxBeeG
         g6WVMnAJH2yr5h3XBykBdBXbdkJK3qTrwQx1ubvYzCApYTpzw00vzLI8hY8AtUHanMSM
         69oGOYVXSNnJ8PFa8FYamHFTUYQjiA+ZIo0o4e6B/hxfrC1RjXf/0QgjoWNW69FqyiIy
         cSmA==
X-Gm-Message-State: APjAAAWz0JVZwI6H6WkHDzY6eo7GDXxYzAM5MeG06r9iwhTFzbSMhs/k
	wBugqZ9YVE6FpbReBfECDrtNcHBM5iHPeBhduFE=
X-Google-Smtp-Source: APXvYqywEZY9N6BLlGKPngVu0MzuLSQVd/bbUAHN7xRcQ2CV3KOp05cjUcVNzfkLtJUwKk8pzyQobSIZfy2P0YdSN5Y=
X-Received: by 2002:a9d:6206:: with SMTP id g6mr11766977otj.51.1575048747686;
 Fri, 29 Nov 2019 09:32:27 -0800 (PST)
MIME-Version: 1.0
References: <CA+OAcEM94aAcaXB17Z2q9_iMWVEepCR8SycY6WSTcKYd+5rCAg@mail.gmail.com>
 <20191129112825.GA27873@lakrids.cambridge.arm.com>
In-Reply-To: <20191129112825.GA27873@lakrids.cambridge.arm.com>
From: Kassad <aashad940@gmail.com>
Date: Fri, 29 Nov 2019 12:32:17 -0500
Message-ID: <CA+OAcEO8TnqLTBoCUjP=-z4TCrTTHqXx4pY7mBj+FZ0pAvw8XA@mail.gmail.com>
Subject: Re: Contributing to KSPP newbie
To: Mark Rutland <mark.rutland@arm.com>
Cc: keescook@chromium.org, kernel-hardening@lists.openwall.com
Content-Type: multipart/alternative; boundary="0000000000001c1db105987f9d8d"

--0000000000001c1db105987f9d8d
Content-Type: text/plain; charset="UTF-8"

This might be a bit to vague but is there any task that is beginner
friendly? I did have a look at todo list and most of them look quite
daunting.


On Fri, Nov 29, 2019 at 6:29 AM Mark Rutland <mark.rutland@arm.com> wrote:

> On Thu, Nov 28, 2019 at 11:39:11PM -0500, Kassad wrote:
> > Hey Kees,
> >
> > I'm 3rd university student interested in learning more about the linux
> kernel.
> > I'm came across this subsystem, since it aligns with my interest in
> security.
> > Do you think as a newbie this task
> https://github.com/KSPP/linux/issues/11 will
> > be a good starting point?
>
> I think this specific task (Disable arm32 kuser helpers) has already
> been done, and the ticket is stale.
>
> On arm CONFIG_KUSER_HELPERS can be disabled on kernels that don't need
> to run on HW prior to ARMv6. See commit:
>
>   f6f91b0d9fd971c6 ("ARM: allow kuser helpers to be removed from the
> vector page")
>
> On arm64, CONFIG_KUSER_HELPERS can be disabled on any kernel. See
> commit:
>
>   1b3cf2c2a3f42b ("arm64: compat: Add KUSER_HELPERS config option")
>
> Thanks,
> Mark.
>

--0000000000001c1db105987f9d8d
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div><div dir=3D"auto">This might be a bit to vague but is there any task t=
hat is beginner friendly? I did have a look at todo list and most of them l=
ook quite daunting.</div><br></div><div><br><div class=3D"gmail_quote"><div=
 dir=3D"ltr" class=3D"gmail_attr">On Fri, Nov 29, 2019 at 6:29 AM Mark Rutl=
and &lt;<a href=3D"mailto:mark.rutland@arm.com">mark.rutland@arm.com</a>&gt=
; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .=
8ex;border-left:1px #ccc solid;padding-left:1ex">On Thu, Nov 28, 2019 at 11=
:39:11PM -0500, Kassad wrote:<br>
&gt; Hey Kees,<br>
&gt; <br>
&gt; I&#39;m 3rd university student interested in learning more about the l=
inux kernel.<br>
&gt; I&#39;m came across this subsystem, since it aligns with my interest i=
n security.<br>
&gt; Do you think as a newbie this task <a href=3D"https://github.com/KSPP/=
linux/issues/11" rel=3D"noreferrer" target=3D"_blank">https://github.com/KS=
PP/linux/issues/11</a> will<br>
&gt; be a good starting point?<br>
<br>
I think this specific task (Disable arm32 kuser helpers) has already<br>
been done, and the ticket is stale.<br>
<br>
On arm CONFIG_KUSER_HELPERS can be disabled on kernels that don&#39;t need<=
br>
to run on HW prior to ARMv6. See commit:<br>
<br>
=C2=A0 f6f91b0d9fd971c6 (&quot;ARM: allow kuser helpers to be removed from =
the vector page&quot;)<br>
<br>
On arm64, CONFIG_KUSER_HELPERS can be disabled on any kernel. See<br>
commit:<br>
<br>
=C2=A0 1b3cf2c2a3f42b (&quot;arm64: compat: Add KUSER_HELPERS config option=
&quot;)<br>
<br>
Thanks,<br>
Mark.<br>
</blockquote></div></div>

--0000000000001c1db105987f9d8d--
