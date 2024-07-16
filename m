Return-Path: <kernel-hardening-return-21789-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 93F6FC3DA59
	for <kernel-hardening@archiver.kernel.org>; Tue, 16 Jul 2024 17:30:09 +0000 (UTC)
Received: (qmail 29774 invoked by uid 550); 16 Jul 2024 17:29:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29732 invoked from network); 16 Jul 2024 17:29:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sempervictus-com.20230601.gappssmtp.com; s=20230601; t=1721150985; x=1721755785; darn=lists.openwall.com;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cmtuHn9x1Oqr5WrMucfot/Syf3xDJCovJ1Y+yAMW3FE=;
        b=SalOPLn0F0anEB3a76Ju7sWoT/GQKqKR7Uz50zAet4dbFPO4flEHkx3Sjtuxc4CHos
         4+8HbKThcvul8SnnUZHVTdfqqlpsbOc7Qlav44Qvyb3yga0eZB1bNVb0AD6M4A/7vjLD
         w1tencf4/IU4Omcse7/9y7Vozz1ZiGWv8wk1PhanU9joh84QdjA/B+HaJPoIhJ5YCThc
         1wQGKwV+jNe6OdPANAU0X5v6hR2xm8coQ6cJbQ/CbAg0wi6I/nylBu/f6LRuB6rMaews
         nvjbEECa7dpzytgdRMuik/ztDBI/P8pZdKZ458++lRKTUD/pE5vs56XpFGGl6E0SQw3b
         tP/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721150985; x=1721755785;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cmtuHn9x1Oqr5WrMucfot/Syf3xDJCovJ1Y+yAMW3FE=;
        b=VDAhbi3sUT6jocvDK5vCffZhp2yeN3mDLIKweSHF2M3pfvtSgympfJr9A23O+sUbSk
         n4VX/GwYmJ2Jf0h9gfPKO6zsmt3KXPH5JfxgLhaReBqYCQOOv87guZzaKZ1g5zIYnmao
         EatKWEtO5mtcl2LruNgVZTzZLFjAinY5Mci0qAteCIN55lIDyx48Tv6SxrqNIZpBu6gw
         LIP4jBzXPBQDw8sbn+/7grbC1f6eceP2W55OndomvW4RL0LG9p023MtNxc3bHCR+CpnR
         4aJ/kkQZJFYhQMIKyzlbgbQ7EFnbvRBgsTsjlFZIvW7s59h4yh9cMZ9vJr14+RtmPo2D
         nyAw==
X-Gm-Message-State: AOJu0YzZ5IlRzjRt+SXXNN6BYbtj0qRSeU4paXi6qrY+yeATfAQRjrfS
	ikTnDdbaVOY0dd8v/yabNYATrDKT7rxjCOx9AMpuJowXy9qZq3XjQnG0QBauhWChsnJ6auN70Yq
	C
X-Google-Smtp-Source: AGHT+IE8hnQTBiNtQOghApm4tPStGJsq7M55mvWT59UEPRIBFa/CMRKFgKewrs9LysJT5NF5GxpvVA==
X-Received: by 2002:a05:620a:4488:b0:79d:6fcd:9116 with SMTP id af79cd13be357-7a17b65e742mr305866985a.23.1721150985026;
        Tue, 16 Jul 2024 10:29:45 -0700 (PDT)
Date: Tue, 16 Jul 2024 13:29:43 -0400
From: Boris Lukashev <blukashev@sempervictus.com>
To: kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH v19 0/5] Script execution control (was O_MAYEXEC)
User-Agent: K-9 Mail for Android
In-Reply-To: <ee1ae815b6e75021709612181a6a4415fda543a4.camel@HansenPartnership.com>
References: <20240704190137.696169-1-mic@digikod.net> <55b4f6291e8d83d420c7d08f4233b3d304ce683d.camel@linux.ibm.com> <20240709.AhJ7oTh1biej@digikod.net> <9e3df65c2bf060b5833558e9f8d82dcd2fe9325a.camel@huaweicloud.com> <ee1ae815b6e75021709612181a6a4415fda543a4.camel@HansenPartnership.com>
Message-ID: <E608EDB8-72E8-4791-AC9B-8FF9AC753FBE@sempervictus.com>
MIME-Version: 1.0
Content-Type: multipart/alternative;
 boundary=----NYBVU3GMD2T0ALK8CPN8CO2PW76S5Y
Content-Transfer-Encoding: 7bit

------NYBVU3GMD2T0ALK8CPN8CO2PW76S5Y
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

Wouldn't count those shell chickens - awk alone is enough and we can use ss=
h and openssl clients (all in metasploit public code)=2E As one of the peop=
le who makes novel shell types, I can assure you that this effort is only g=
oing to slow skiddies and only until the rest of us publish mitigations for=
 this mitigation :)

-Boris (RageLtMan)

On July 16, 2024 12:12:49 PM EDT, James Bottomley <James=2EBottomley@Hanse=
nPartnership=2Ecom> wrote:
>On Tue, 2024-07-16 at 17:57 +0200, Roberto Sassu wrote:
>> But the Clip OS 4 patch does not cover the redirection case:
>>=20
>> # =2E/bash < /root/test=2Esh
>> Hello World
>>=20
>> Do you have a more recent patch for that?
>
>How far down the rabbit hole do you want to go?  You can't forbid a
>shell from executing commands from stdin because logging in then won't
>work=2E  It may be possible to allow from a tty backed file and not from
>a file backed one, but you still have the problem of the attacker
>manually typing in the script=2E
>
>The saving grace for this for shells is that they pretty much do
>nothing on their own (unlike python) so you can still measure all the
>executables they call out to, which provides reasonable safety=2E
>
>James
>

------NYBVU3GMD2T0ALK8CPN8CO2PW76S5Y
Content-Type: text/html;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html><head></head><body><div dir=3D"auto">Wouldn't count those shell chick=
ens - awk alone is enough and we can use ssh and openssl clients (all in me=
tasploit public code)=2E As one of the people who makes novel shell types, =
I can assure you that this effort is only going to slow skiddies and only u=
ntil the rest of us publish mitigations for this mitigation :)<br><br>-Bori=
s (RageLtMan)</div><br><br><div class=3D"gmail_quote"><div dir=3D"auto">On =
July 16, 2024 12:12:49 PM EDT, James Bottomley &lt;James=2EBottomley@Hansen=
Partnership=2Ecom&gt; wrote:</div><blockquote class=3D"gmail_quote" style=
=3D"margin: 0pt 0pt 0pt 0=2E8ex; border-left: 1px solid rgb(204, 204, 204);=
 padding-left: 1ex;">
<pre class=3D"k9mail"><div dir=3D"auto">On Tue, 2024-07-16 at 17:57 +0200,=
 Roberto Sassu wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"m=
argin: 0pt 0pt 1ex 0=2E8ex; border-left: 1px solid #729fcf; padding-left: 1=
ex;"><div dir=3D"auto">But the Clip OS 4 patch does not cover the redirecti=
on case:<br><br># =2E/bash &lt; /root/test=2Esh<br>Hello World<br><br>Do yo=
u have a more recent patch for that?<br></div></blockquote><div dir=3D"auto=
"><br>How far down the rabbit hole do you want to go?  You can't forbid a<b=
r>shell from executing commands from stdin because logging in then won't<br=
>work=2E  It may be possible to allow from a tty backed file and not from<b=
r>a file backed one, but you still have the problem of the attacker<br>manu=
ally typing in the script=2E<br><br>The saving grace for this for shells is=
 that they pretty much do<br>nothing on their own (unlike python) so you ca=
n still measure all the<br>executables they call out to, which provides rea=
sonable safety=2E<br><br>James<br><br></div></pre></blockquote></div></body=
></html>
------NYBVU3GMD2T0ALK8CPN8CO2PW76S5Y--
