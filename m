Return-Path: <SRS0=qFUu=Y2=lists.openwall.com=kernel-hardening-return-17250-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76170CA9EC7
	for <kernel-hardening@archiver.kernel.org>; Sat,  2 Nov 2019 05:42:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BD43621897
	for <kernel-hardening@archiver.kernel.org>; Sat,  2 Nov 2019 05:42:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b7SeZa6u"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BD43621897
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17250-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19765 invoked by uid 550); 2 Nov 2019 05:42:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19728 invoked from network); 2 Nov 2019 05:42:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TwCyoqEqcafVBAPHUZNRzy8O91jgC0yg4si3yhaEWtU=;
        b=b7SeZa6uSLSeVMfRcXDKUY2jgD2S/63UBZqF1iuSePQLHdZNgl6cX+FVCrl/9jH43W
         8XOTcPOYrvz5lzwGE4GKlGamef8tz0zYysAqvmKUVgJb9G6Xzdahv96K76siVeLHbGIv
         XM0teR8AGj2gia1+1fYJS+bzJ5jiAb3IWKAEKzcyhsAroqrJCqEG/+vh/YXqfiQCQ/tL
         TeJG4/z/vQ1snltCVjACdCbjyXzEwVJ+WbtwQfC+6lPP5sofec84+bqLZQPjmZJUg27c
         9k+Pt792Egckkcc9zkNes/EIi7HgFRzrdeMvcS+E0yZJjvoKxaMJdA3jCqzVS2EtqB3x
         LlnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TwCyoqEqcafVBAPHUZNRzy8O91jgC0yg4si3yhaEWtU=;
        b=sgQFbggC3FoczgrAaeAZwcNrgMTffp0WgeWHX9BHuJQywv49XBHJjHFXZxTzZEoadf
         3BplfGWTWskNmt17WGmCBKEZIycw8UPtIjQdpHgouEnWnHyAjPlSxNh+dR3HSw9vc0QM
         KBP7PBV7bebot3ZFT718YxC0rHNfCjTI/F6OLavTDyN+u5AL+RStxCU5kRoGIO19sqiK
         b5hrYnUq5w1HwRTaa8szsYJZF7DVKsqdPyV0wSRfQDzXQgahhZQULMiLanVH5VAt5g0E
         pdMe2V+DZYmRTR1ZE1jdGbc/F8VwH6xIOF5HBtkBJx3w9NCP3Heyzlx4IsdCddTZnEbI
         4qtw==
X-Gm-Message-State: APjAAAXdmRtr8L+05RtCZdeJHYH7FQqoE4NNFLclmzEgOcbs72D+5Glc
	CnJOdu29FqG7qtCkz/0VvCyfR01jtRcJPE83P7U=
X-Google-Smtp-Source: APXvYqwZkOKcbUtStO616K56Lp9U0G511GomEogcYrPPEV4/Awh/49l+n1f/+oEyq1bU6DmUvC0n7IWWTArPG3r81lc=
X-Received: by 2002:a05:6e02:cc1:: with SMTP id c1mr14382738ilj.139.1572673351138;
 Fri, 01 Nov 2019 22:42:31 -0700 (PDT)
MIME-Version: 1.0
References: <2e2a3d3c-872e-3d07-5585-92734a532ef2@gmail.com>
 <CABob6iq_N8He+ORZuRVqdDhBCuymSwVyRHCsW8GAzXcM8+_tuA@mail.gmail.com> <CAOzgRdbFc_WJDaOg5vdq5Y=nL+vyApCDCGFb-AUo6f=GRSDQWQ@mail.gmail.com>
In-Reply-To: <CAOzgRdbFc_WJDaOg5vdq5Y=nL+vyApCDCGFb-AUo6f=GRSDQWQ@mail.gmail.com>
From: youling 257 <youling257@gmail.com>
Date: Sat, 2 Nov 2019 13:42:17 +0800
Message-ID: <CAOzgRda8+u9GFNv4VZ+10Aj0SaG0sfXd1==2mrsCNfqhfHLbyg@mail.gmail.com>
Subject: Re: How to get the crash dump if system hangs?
To: Lukas Odzioba <lukas.odzioba@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, 
	munisekharrms@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On my v891w, i add "memmap=3D1M!2047M ramoops.mem_size=3D1048576
ramoops.ecc=3D1 ramoops.mem_address=3D0x7ff00000
ramoops.console_size=3D16384 ramoops.ftrace_size=3D16384
ramoops.pmsg_size=3D16384 ramoops.record_size=3D32768" boot parameter,
[ 0.483935] printk: console [pstore-1] enabled
[ 0.484034] pstore: Registered ramoops as persistent store backend
[ 0.484121] ramoops: using 0x100000@0x7ff00000, ecc: 16

But on my ezpad 6 m4, i add "memmap=3D1M!4095M ramoops.mem_size=3D1048576
ramoops.ecc=3D1 ramoops.mem_address=3D0xfff00000
ramoops.console_size=3D16384 ramoops.ftrace_size=3D16384
ramoops.pmsg_size=3D16384 ramoops.record_size=3D32768" boot parameter, it
can't boot, stop at "boot command list", no anyting happen, no dmesg.
I test boot parameter one by one, just add ramoops.mem_size=3D1048576,
will cause can't boot.

youling 257 <youling257@gmail.com> =E4=BA=8E2019=E5=B9=B410=E6=9C=8821=E6=
=97=A5=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=886:22=E5=86=99=E9=81=93=EF=BC=9A
>
> When add cmdline memmap=3D1M!2047M, the iomem will be 7ef00001-7fefffff :=
 RAM buffer 7ff00000-7fffffff : Persistent Memory (legacy) 7ff00000-7ff00ff=
f : MSFT0101:00,
> so ramoops.mem_address=3D0x7ff00000.
>
> Lukas Odzioba <lukas.odzioba@gmail.com> =E4=BA=8E 2019=E5=B9=B410=E6=9C=
=8821=E6=97=A5=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=884:39=E5=86=99=E9=81=93=
=EF=BC=9A
>>
>> youling257 <youling257@gmail.com> wrote:
>> >
>> > I don't know my ramoops.mem_address, please help me.
>> >
>> > what is ramoops.mem_address?
>>
>> It is a Linux kernel parameter, see documentation below:
>> https://www.kernel.org/doc/Documentation/admin-guide/ramoops.rst
>>
>> It requires memory which can hold data between reboots, so i'm not
>> sure how it will suit your case.
>>
>> Thanks,
>> Lukas
