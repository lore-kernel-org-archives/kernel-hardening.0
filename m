Return-Path: <SRS0=zS24=UZ=lists.openwall.com=kernel-hardening-return-16260-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F4D2C48BD6
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Jun 2019 15:21:29 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5D2812086D
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Jun 2019 15:21:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="E6tOyEpU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5D2812086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16260-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17524 invoked by uid 550); 26 Jun 2019 15:21:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17503 invoked from network); 26 Jun 2019 15:21:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=cKkdMkj6I/DdZ06dL/lw28dVMlILlB8aQ8Zk+4qZukk=;
        b=E6tOyEpUJtT9bsBRqjmm4swXIq2Tmj1zHNduQ7AvCpJ66mVCh7SLRIW0v67jE8tpkf
         70LPPrTiSKM3VizjOa9kEBRzGvToUhNltbKL9EXS0y/TSGMK9bOIyCdmBotLqYjERbld
         aByysWxWC0Z4SbfsDjgcPgI+hhCCUZxaEODOFmR5yhQ20tIanr/Qu+ROvPbfqPmjU31h
         njBu/S5Z4bZQJoqZSKR5TTyelyM1HifmU4ymUOOewL7e0lpd/NIN1CH/Fb7pzAS0Xvoq
         efcQPkqTQIplTmWzvUBcg7C1PmjoqyUCxoqeIT0Uz9Rbezzs5+PC1rXvAmySL3uqtzLj
         UeAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=cKkdMkj6I/DdZ06dL/lw28dVMlILlB8aQ8Zk+4qZukk=;
        b=HwUQwVSsDmBNYutjsUnNZ3fcBBCefafL6/ALaOnMvcy0m/DHlsvRbvhwb8dl+Lx5gJ
         5X7tyEcmfHBawxf1ggFfIgpZGGkI2SmOCFv+Wful16v63ByFtPXedjd+A3CDTDiZjTdC
         XxsPR8CjZaDPTQFakogySUBpfLQP1rx62JMmp0XnPRDKPhNIpkMT1F9wER0dnJIUtvon
         K5Us/mdPA5vcwAzBDBa8bqRQDMtqS0r7du2ThSf637MPX6ZRpoI0Jbt1/QpVj2pEMyvB
         tV+OKVyMOQ8+LgpDbX9vDM4JV1kLfBLYqnn9JJM1FlekhJfjV4dqsV87blDQE7OV4JPS
         DuCQ==
X-Gm-Message-State: APjAAAW4dSFjhtXN+owO2CkceNDYXgnvUJTNXmvblJTHvVDfv8jtXwt8
	AUsDU7NMoFWewYhQ6RA7hq3cig==
X-Google-Smtp-Source: APXvYqxaRUw/tJQ7ebMVrUGEt329aWj0HyECbt1bpTaqtxT9Am1UrCaDNv+W8eqCYJJ5BbN8o6BlAw==
X-Received: by 2002:a17:902:f64:: with SMTP id 91mr5912284ply.247.1561562467144;
        Wed, 26 Jun 2019 08:21:07 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: Detecting the availability of VSYSCALL
From: Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16F203)
In-Reply-To: <87r27gjss3.fsf@oldenburg2.str.redhat.com>
Date: Wed, 26 Jun 2019 08:21:05 -0700
Cc: Andy Lutomirski <luto@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>,
 Linux API <linux-api@vger.kernel.org>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 linux-x86_64@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>,
 Kees Cook <keescook@chromium.org>, Carlos O'Donell <carlos@redhat.com>,
 X86 ML <x86@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <534B9F63-E949-4CF5-ACAC-71381190846F@amacapital.net>
References: <87v9wty9v4.fsf@oldenburg2.str.redhat.com> <alpine.DEB.2.21.1906251824500.32342@nanos.tec.linutronix.de> <87lfxpy614.fsf@oldenburg2.str.redhat.com> <CALCETrVh1f5wJNMbMoVqY=bq-7G=uQ84BUkepf5RksA3vUopNQ@mail.gmail.com> <87a7e5v1d9.fsf@oldenburg2.str.redhat.com> <CALCETrUDt4v3=FqD+vseGTKTuG=qY+1LwRPrOrU8C7vCVbo=uA@mail.gmail.com> <87o92kmtp5.fsf@oldenburg2.str.redhat.com> <CA96B819-30A9-43D3-9FE3-2D551D35369E@amacapital.net> <87r27gjss3.fsf@oldenburg2.str.redhat.com>
To: Florian Weimer <fweimer@redhat.com>



> On Jun 26, 2019, at 8:00 AM, Florian Weimer <fweimer@redhat.com> wrote:
>=20
> * Andy Lutomirski:
>=20
>> I didn=E2=80=99t add a flag because the vsyscall page was thoroughly obso=
lete
>> when all this happened, and I wanted to encourage all new code to just
>> parse the vDSO instead of piling on the hacks.
>=20
> It turned out that the thorny cases just switched to system calls
> instead.  I think we finally completed the transition in glibc upstream
> in 2018 (for x86).
>=20
>> Anyway, you may be the right person to ask: is there some credible way
>> that the kernel could detect new binaries that don=E2=80=99t need vsyscal=
ls?
>> Maybe a new ELF note on a static binary or on the ELF interpreter? We
>> can dynamically switch it in principle.
>=20
> For this kind of change, markup similar to PT_GNU_STACK would have been
> appropriate, I think: Old kernels and loaders would have ignored the
> program header and loaded the program anyway, but the vsyscall page
> still existed, so that would have been fine. The kernel would have
> needed to check the program interpreter or the main executable (without
> a program interpreter, i.e., the statically linked case).  Due the way
> the vsyscalls are concentrated in glibc, a dynamically linked executable
> would not have needed checking (or re-linking).  I don't think we would
> have implemented the full late enablement after dlopen we did for
> executable stacks.  In theory, any code could have jumped to the
> vsyscall area, but in practice, it's just dynamically linked glibc and
> static binaries.
>=20
> But nowadays, unmarked glibcs which do not depend on vsyscall vastly
> outnumber unmarked glibcs which requrie it.  Therefore, markup of
> binaries does not seem to be reasonable to day.  I could imagine a
> personality flag you can set (if yoy have CAP_SYS_ADMIN) that re-enables
> vsyscall support for new subprocesses.  And a container runtime would do
> this based on metadata found in the image.  This way, the container host
> itself could be protected, and you could still run legacy images which
> require vsyscall.
>=20
> For the non-container case, if you know that you'll run legacy
> workloads, you'd still have the boot parameter.  But I think it could
> default to vsyscall=3Dnone in many more cases.
>=20

I=E2=80=99m wondering if we can still do it: add a note or other ELF indicat=
or that says =E2=80=9CI don=E2=80=99t need vsyscalls.=E2=80=9D  Then we can c=
hange the default mode to =E2=80=9Cno vsyscalls if the flag is there, else e=
xecute-only vsyscalls=E2=80=9D.

Would glibc go along with this?  Would enterprise distros consider backporti=
ng such a thing?

I=
