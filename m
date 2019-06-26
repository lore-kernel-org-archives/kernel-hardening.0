Return-Path: <SRS0=5Tv9=UZ=lists.openwall.com=kernel-hardening-return-16263-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57523C48BD3
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Jun 2019 16:25:02 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A525F20665
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Jun 2019 16:25:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="k3mbytoz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A525F20665
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16263-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21630 invoked by uid 550); 26 Jun 2019 16:24:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21603 invoked from network); 26 Jun 2019 16:24:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=k7Dlf8sx47uiTue1xW33w+LOIiPl1PRTBP6uQLvfmJc=;
        b=k3mbytoz0dKL1Q65aiUMJ84oAnT28g8nhrjtb58aw7ZFk7h8X9wymI8O133//OJ68X
         bBEthtOkO4L78sL0Cj9WuZnjyhQtcDErL5hsknDZrkDIrWg5YQoxy89c1fxbJbUUieQH
         AOGZP9mqNskDAia73Gcz0xD5dxv87TWHvAUJf6YCVpdtfRzt9+TeU1D/1z6UMH9W8m90
         YD42gXnBzrGW4fEfjdNQAIvwJk6If+KNFxk5gmVG6DtpIpUUeq+mD6+6tzFA5KXMIWWT
         8OM6bczW04DXflvarNxJklEgYcTlVc1qck7hCy0gIj26IPv05N9dzhdBKZ62PfxqUfY7
         7KQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=k7Dlf8sx47uiTue1xW33w+LOIiPl1PRTBP6uQLvfmJc=;
        b=hRGfmhvguWyIb1404IB3dOIyEdbo/W3gThdanyX3VU652l2akzajX62mId9cW9keHW
         8m1NrDhJPnbEITlOHRPTunvVv+EOEUQ86a8bhQPdE1ldOXSBQTqOLia8QJRL7PIBsJ/d
         vVcynEeEs0kEqMJqpezcZNJy8qjGELkY/Cf75c5bw56aCD/Itsny/SNLYr4VhnuMB7Oa
         0UySjI9j75b/e0hlqRFzeA3IJY4br5pdBqcmkUcmSk8/gEO4IDiVgoIbHXbRSGgSIALt
         9it7+ZXzdOoav3OTylHtdUGDqb0TUbmdKM78CLPhEoHe5+8JgH/SJOAtgrz1HY/N3H4N
         NK+Q==
X-Gm-Message-State: APjAAAUTr+EjU1r9MyMmngqENiLyaXZ4f2Wz8pqPLNtrtLc6tbIGvm39
	O52ZgAvlsCjhnz6m2zKrjNLX/A==
X-Google-Smtp-Source: APXvYqyrDnyRSdi6RpZML1/KC6mkQGLLxMhhVxyn2zHLP5GAtpZV7oVqmJYT0bFeex2r75nE4nwoGw==
X-Received: by 2002:a17:90a:2ec1:: with SMTP id h1mr5730544pjs.101.1561566280920;
        Wed, 26 Jun 2019 09:24:40 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: Detecting the availability of VSYSCALL
From: Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16F203)
In-Reply-To: <87a7e4jr4s.fsf@oldenburg2.str.redhat.com>
Date: Wed, 26 Jun 2019 09:24:38 -0700
Cc: Andy Lutomirski <luto@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>,
 Linux API <linux-api@vger.kernel.org>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 linux-x86_64@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>,
 Kees Cook <keescook@chromium.org>, Carlos O'Donell <carlos@redhat.com>,
 X86 ML <x86@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <6CECE9DE-51AB-4A21-A257-8B85C4C94EB0@amacapital.net>
References: <87v9wty9v4.fsf@oldenburg2.str.redhat.com> <alpine.DEB.2.21.1906251824500.32342@nanos.tec.linutronix.de> <87lfxpy614.fsf@oldenburg2.str.redhat.com> <CALCETrVh1f5wJNMbMoVqY=bq-7G=uQ84BUkepf5RksA3vUopNQ@mail.gmail.com> <87a7e5v1d9.fsf@oldenburg2.str.redhat.com> <CALCETrUDt4v3=FqD+vseGTKTuG=qY+1LwRPrOrU8C7vCVbo=uA@mail.gmail.com> <87o92kmtp5.fsf@oldenburg2.str.redhat.com> <CA96B819-30A9-43D3-9FE3-2D551D35369E@amacapital.net> <87r27gjss3.fsf@oldenburg2.str.redhat.com> <534B9F63-E949-4CF5-ACAC-71381190846F@amacapital.net> <87a7e4jr4s.fsf@oldenburg2.str.redhat.com>
To: Florian Weimer <fweimer@redhat.com>


> On Jun 26, 2019, at 8:36 AM, Florian Weimer <fweimer@redhat.com> wrote:
>=20
> * Andy Lutomirski:
>=20
>> I=E2=80=99m wondering if we can still do it: add a note or other ELF indi=
cator
>> that says =E2=80=9CI don=E2=80=99t need vsyscalls.=E2=80=9D  Then we can c=
hange the default
>> mode to =E2=80=9Cno vsyscalls if the flag is there, else execute-only
>> vsyscalls=E2=80=9D.
>>=20
>> Would glibc go along with this?
>=20
> I think we can make it happen, at least for relatively recent glibc
> linked with current binutils.  It's not trivial because it requires
> coordination among multiple projects.  We have three or four widely used
> link editors now, but we could make it happen.  (Although getting to
> PT_GNU_PROPERTY wasn't exactly easy.)

Can=E2=80=99t an ELF note be done with some more or less ordinary asm such t=
hat any link editor will insert it correctly?

>=20
>> Would enterprise distros consider backporting such a thing?
>=20
> Enterprise distros aren't the problem here because they can't remove
> vsyscall support for quite a while due to existing customer binaries.
> For them, it would just be an additional (and welcome) hardening
> opportunity.
>=20
> The challenge here are container hosting platforms which have already
> disabled vsyscall, presumably to protect the container host itself.
> They would need to rebuild the container host userspace with the markup
> to keep it protected, and then they could switch to a kernel which has
> vsyscall-unless-opt-out logic.  That seems to be a bit of a stretch
> because from their perspective, there's no problem today.
>=20
> My guess is that it would be easier to have a personality flag.  Then
> they could keep the host largely as-is, and would =E2=80=9Conly=E2=80=9D n=
eed a
> mechanism to pass through the flag from the image metadata to the actual
> container creation.  It's still a change to the container host (and the
> kernel change is required as well), but it would not require relinking
> every statically linked binary.
>=20
>=20

The problem with a personality flag is that it needs to have some kind of se=
nsible behavior for setuid programs, and getting that right in a way that do=
esn=E2=80=99t scream =E2=80=9Cexploit me=E2=80=9D while preserving useful co=
mpatibility may be tricky.=
