Return-Path: <SRS0=9mJV=HZ=lists.openwall.com=kernel-hardening-return-20812-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B61FCC433DB
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Feb 2021 09:31:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 67EC964E02
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Feb 2021 09:31:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 67EC964E02
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20812-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7955 invoked by uid 550); 23 Feb 2021 09:31:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7929 invoked from network); 23 Feb 2021 09:31:39 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DVFCa2/tt2H+LD0hRmA62OWnetDkcRuJ237RaPObmX8=;
        b=swbR//PfErd8XhgqzDSvvUK5jzVq9I8ZOx5107KVbKYg6OqJq5hU9Y7+FdR1SBeUja
         XJmX1+I6H5AglonFmbvrr81dNBwM3QnXE4EuG7TJWhIi/6FE1+8He3sEPJbO4INmoKra
         9iOMcrz+CTsosmGPpFBUPjF+flTGoUO7NFRfH/pMaTjMhY28cNzYuNdI2H+2agFc87TG
         NNcg1BKrJzAhg+GQMv7+q2S3lhDlcToJGSD5Pj4TUA/3WGlfjh98Gwmyxaz51z2EFPhd
         TSDFq9glzNWUmQSNEfoHH4rl6gUgulaH0LvJ5akCuSta4YkpTYqMt9yAEiC7zavZGd35
         C9qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DVFCa2/tt2H+LD0hRmA62OWnetDkcRuJ237RaPObmX8=;
        b=LFdxoEUFDWrf5okSGkx44CAFg3OzvUai+y52EX3f3EQIRvPQFUf73SnsoRHWCaGTlu
         QczhsIYATGFLkcQGRDVgZ7phBgkbTgP52C8kRxS0GFCsZF8y5CbcKNgjGU8CQ/+xwo4O
         kV4oxMsZn/odWOKLerBJ+XT9dTODYr+QBXMqvP1GwaI5PVirDltS5PkCEZqY4+ZagNUc
         g3yAJ4BR1XRoZXiLYxVuflpCQ7vcGzu6KMERrQ0SqSFhFt8oA6qKVAnSclBdlUcYOjir
         oVJGfUQT62uZfUgCj7xvajoapt4WsnvVoSGPkVrfFpRN6NUgdHNDQvhMlIlTSRvFVyFg
         CLfw==
X-Gm-Message-State: AOAM532c5npEuNpvj5hRBOItX+qHeRyRrM+2ZRhOk+BVdW9nRKK0x7cq
	jHQstNR1ofVk5jFd9hcTBeSbpe6YLXXc2Djy4NM=
X-Google-Smtp-Source: ABdhPJw119jqyynvn6i6tP3tXQai/RxjO4NuMQBdVlW9Zg6eOFuI0kMlNL/nUCHjxtta9WlCiGOPHrcAz/7jkLcfzHw=
X-Received: by 2002:a9d:67cb:: with SMTP id c11mr19768599otn.290.1614072687320;
 Tue, 23 Feb 2021 01:31:27 -0800 (PST)
MIME-Version: 1.0
References: <20210222151231.22572-1-romain.perier@gmail.com> <936bcf5e-2006-7643-7804-9efa318b3e2b@linuxfoundation.org>
In-Reply-To: <936bcf5e-2006-7643-7804-9efa318b3e2b@linuxfoundation.org>
From: Romain Perier <romain.perier@gmail.com>
Date: Tue, 23 Feb 2021 10:31:15 +0100
Message-ID: <CABgxDoLZKbrzghbp09kraEsk0iLzn7B0BEQWmZcdrXwmOu_MKw@mail.gmail.com>
Subject: Re: [PATCH 00/20] Manual replacement of all strlcpy in favor of strscpy
To: Shuah Khan <skhan@linuxfoundation.org>
Cc: Kees Cook <keescook@chromium.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Tejun Heo <tj@kernel.org>, 
	Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Jiri Pirko <jiri@nvidia.com>, Sumit Semwal <sumit.semwal@linaro.org>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mimi Zohar <zohar@linux.ibm.com>, 
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, "J. Bruce Fields" <bfields@fieldses.org>, 
	Chuck Lever <chuck.lever@oracle.com>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	Jessica Yu <jeyu@kernel.org>, Guenter Roeck <linux@roeck-us.net>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, 
	Steffen Maier <maier@linux.ibm.com>, Benjamin Block <bblock@linux.ibm.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Jaroslav Kysela <perex@perex.cz>, 
	Takashi Iwai <tiwai@suse.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, 
	Jiri Slaby <jirislaby@kernel.org>, Felipe Balbi <balbi@kernel.org>, 
	Valentina Manea <valentina.manea.m@gmail.com>, Shuah Khan <shuah@kernel.org>, 
	Wim Van Sebroeck <wim@linux-watchdog.org>, cgroups@vger.kernel.org, 
	linux-crypto@vger.kernel.org, netdev <netdev@vger.kernel.org>, 
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linaro-mm-sig@lists.linaro.org, "Rafael J. Wysocki" <rafael@kernel.org>, 
	linux-integrity@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-hwmon@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, alsa-devel@alsa-project.org, 
	linux-usb@vger.kernel.org, linux-watchdog@vger.kernel.org, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/alternative; boundary="0000000000002b63e105bbfd9544"

--0000000000002b63e105bbfd9544
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le lun. 22 f=C3=A9vr. 2021 =C3=A0 17:36, Shuah Khan <skhan@linuxfoundation.=
org> a
=C3=A9crit :

>
> Cool. A quick check shows me 1031 strscpy() calls with no return
> checks. All or some of these probably need to be reviewed and add
> return checks. Is this something that is in the plan to address as
> part of this work?
>
> thanks,
> -- Shuah
>

Hi,

Initially, what we planned with Kees is to firstly replace all calls with
error handling codes (like this series does),
and then replace all other simple calls (without error handling). However,
we can also start a discussion about this topic, all suggestions are
welcome.

I am not sure that it does make sense to check all returns code in all
cases (for example in arch/alpha/kernel/setup.c, there are a ton of other
examples in the kernel). But a general review (as you suggest), would make
sense.

Regards,
Romain

--0000000000002b63e105bbfd9544
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmail=
_attr">Le=C2=A0lun. 22 f=C3=A9vr. 2021 =C3=A0=C2=A017:36, Shuah Khan &lt;<a=
 href=3D"mailto:skhan@linuxfoundation.org">skhan@linuxfoundation.org</a>&gt=
; a =C3=A9crit=C2=A0:<br></div><blockquote class=3D"gmail_quote" style=3D"m=
argin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left=
:1ex"><br>
Cool. A quick check shows me 1031 strscpy() calls with no return<br>
checks. All or some of these probably need to be reviewed and add<br>
return checks. Is this something that is in the plan to address as<br>
part of this work?<br>
<br>
thanks,<br>
-- Shuah<br></blockquote><div><br></div><div>
<div>Hi,</div><div><br></div><div>Initially, what we planned with Kees is t=
o firstly replace all calls with error handling codes (like this series doe=
s),</div><div>and then replace all other simple calls (without error handli=
ng). However, we can also start a discussion about this topic, all suggesti=
ons are welcome.</div><div><br></div><div>I am not sure that it does make s=
ense to check all returns code in all cases (for example in arch/alpha/kern=
el/setup.c, there are a ton of other examples in the kernel). But a general=
 review (as you suggest), would make sense.<br></div><div><br></div><div>Re=
gards,</div><div>Romain<br></div>=C2=A0 <br></div></div></div>

--0000000000002b63e105bbfd9544--
