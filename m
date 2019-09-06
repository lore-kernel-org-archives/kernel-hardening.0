Return-Path: <SRS0=LHZi=XB=lists.openwall.com=kernel-hardening-return-16863-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MIME_QP_LONG_LINE,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50FDDC43331
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Sep 2019 19:27:13 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8C33C2173B
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Sep 2019 19:27:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="PUlerU1r"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C33C2173B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16863-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5745 invoked by uid 550); 6 Sep 2019 19:27:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5724 invoked from network); 6 Sep 2019 19:27:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=sT4y3CTgBYYtNnGarz3x+6thexIZIH7G3cYm8cMIUKQ=;
        b=PUlerU1rm1o41pTmV5KAjMoYKrczJxdkqqAsYNlzY/Wa7eDBmqtvItMFE46WtBKToZ
         VCuPteRT1/rLy1ZK/CfMMuPbVYP1YrDhyNNizNk2L4Lw6AsY1/Lwj8B48tdeCSlHjVzh
         HINtmovfAV2mhmzF/o1/nnnIdCulL5I31kes91DyNiGM4mL7gfcI3wPSmMPO7h0mz8Mx
         EcNxB9eMznHeWd1Rw1tSxIWsdL3hu/XZikw4QFp+8c1Tk2u4JF2DXDZLQmg7YTxvat9G
         mDAhYwckpcH1lKPwGZAs4Hptn/2a7GlooykTvhZ5MrxgjuAHKTgai4E4SF62vDJ7AHZu
         S81Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=sT4y3CTgBYYtNnGarz3x+6thexIZIH7G3cYm8cMIUKQ=;
        b=V/ohTXM1uUbquQbRxd30DGydmuBObylaMDacAjI03sCV88PjjYg2UmsmEv3FjpO34f
         agv5MnMELn4NmgVQe1nrPeKhMzNO48TRVwwWqCYWRjHaLDZvBMp3FMObW4Y+n17gY5o/
         4wGmlh3okxagvraXFvdmlFfEWw5FwTKTq7zxjX4Yts3HVbHFG1fXZfjLpTHPO33PMXZK
         zAjNJQ4qhk+mlm/pmFl0KVV39773EE6rNDMBlpc6ZkRtE6Y95P1SDHvO7HKfea14/Wxt
         brtuntDdYZ2XuJrfJ3/KrTFlRocS0R+sJuYvDSrP2DyN6wV/HbHcpMPDAYdsAZyKKGiO
         fteA==
X-Gm-Message-State: APjAAAWHI4QoqYus8phIM9tE+l42jchC5WiBuctUm7y88y59jD7s+qAv
	gePhkW2ygzIQ/9YxR94Lya0H3g==
X-Google-Smtp-Source: APXvYqzLKnx6gmrxEA2t3QvgVMgbsPAWbrDNzl75rw940UK/KcrRM5WCsQwR52Ya/WVS6aBnXlQZFg==
X-Received: by 2002:a63:c006:: with SMTP id h6mr9243639pgg.290.1567798013573;
        Fri, 06 Sep 2019 12:26:53 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2 0/5] Add support for O_MAYEXEC
From: Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16G102)
In-Reply-To: <1802966.yheqmZt8Si@x2>
Date: Fri, 6 Sep 2019 12:26:51 -0700
Cc: Florian Weimer <fweimer@redhat.com>,
 =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>,
 linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>,
 Alexei Starovoitov <ast@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
 Andy Lutomirski <luto@kernel.org>, Christian Heimes <christian@python.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Eric Chiang <ericchiang@google.com>, James Morris <jmorris@namei.org>,
 Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>,
 Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
 Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>,
 Michael Kerrisk <mtk.manpages@gmail.com>,
 =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>,
 Mimi Zohar <zohar@linux.ibm.com>,
 =?utf-8?Q?Philippe_Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
 Scott Shell <scottsh@microsoft.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Shuah Khan <shuah@kernel.org>, Song Liu <songliubraving@fb.com>,
 Steve Dower <steve.dower@python.org>,
 Thibaut S autereau <thibaut.sautereau@ssi.gouv.fr>,
 Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
 Yves-Alexis Perez <yves-alexis.perez@ssi.gouv.fr>,
 kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <C95B704C-F84F-4341-BDE7-CD70C5DDBEEF@amacapital.net>
References: <20190906152455.22757-1-mic@digikod.net> <2989749.1YmIBkDdQn@x2> <87mufhckxv.fsf@oldenburg2.str.redhat.com> <1802966.yheqmZt8Si@x2>
To: Steve Grubb <sgrubb@redhat.com>



> On Sep 6, 2019, at 12:07 PM, Steve Grubb <sgrubb@redhat.com> wrote:
>=20
>> On Friday, September 6, 2019 2:57:00 PM EDT Florian Weimer wrote:
>> * Steve Grubb:
>>> Now with LD_AUDIT
>>> $ LD_AUDIT=3D/home/sgrubb/test/openflags/strip-flags.so.0 strace ./test
>>> 2>&1 | grep passwd openat(3, "passwd", O_RDONLY)           =3D 4
>>>=20
>>> No O_CLOEXEC flag.
>>=20
>> I think you need to explain in detail why you consider this a problem.
>=20
> Because you can strip the O_MAYEXEC flag from being passed into the kernel=
.=20
> Once you do that, you defeat the security mechanism because it never gets=20=

> invoked. The issue is that the only thing that knows _why_ something is be=
ing=20
> opened is user space. With this mechanism, you can attempt to pass this=20=

> reason to the kernel so that it may see if policy permits this. But you ca=
n=20
> just remove the flag.

I=E2=80=99m with Florian here. Once you are executing code in a process, you=
 could just emulate some other unapproved code. This series is not intended t=
o provide the kind of absolute protection you=E2=80=99re imagining.

What the kernel *could* do is prevent mmapping a non-FMODE_EXEC file with PR=
OT_EXEC, which would indeed have a real effect (in an iOS-like world, for ex=
ample) but would break many, many things.=
