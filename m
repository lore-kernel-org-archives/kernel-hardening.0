Return-Path: <SRS0=18eU=UZ=lists.openwall.com=kernel-hardening-return-16264-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2F82C48BD3
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Jun 2019 16:45:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 455332080C
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Jun 2019 16:45:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 455332080C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16264-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11785 invoked by uid 550); 26 Jun 2019 16:45:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11765 invoked from network); 26 Jun 2019 16:45:36 -0000
From: Florian Weimer <fweimer@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andy Lutomirski <luto@kernel.org>,  Thomas Gleixner <tglx@linutronix.de>,  Linux API <linux-api@vger.kernel.org>,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  linux-x86_64@vger.kernel.org,  linux-arch <linux-arch@vger.kernel.org>,  Kees Cook <keescook@chromium.org>,  Carlos O'Donell <carlos@redhat.com>,  X86 ML <x86@kernel.org>
Subject: Re: Detecting the availability of VSYSCALL
References: <87v9wty9v4.fsf@oldenburg2.str.redhat.com>
	<alpine.DEB.2.21.1906251824500.32342@nanos.tec.linutronix.de>
	<87lfxpy614.fsf@oldenburg2.str.redhat.com>
	<CALCETrVh1f5wJNMbMoVqY=bq-7G=uQ84BUkepf5RksA3vUopNQ@mail.gmail.com>
	<87a7e5v1d9.fsf@oldenburg2.str.redhat.com>
	<CALCETrUDt4v3=FqD+vseGTKTuG=qY+1LwRPrOrU8C7vCVbo=uA@mail.gmail.com>
	<87o92kmtp5.fsf@oldenburg2.str.redhat.com>
	<CA96B819-30A9-43D3-9FE3-2D551D35369E@amacapital.net>
	<87r27gjss3.fsf@oldenburg2.str.redhat.com>
	<534B9F63-E949-4CF5-ACAC-71381190846F@amacapital.net>
	<87a7e4jr4s.fsf@oldenburg2.str.redhat.com>
	<6CECE9DE-51AB-4A21-A257-8B85C4C94EB0@amacapital.net>
Date: Wed, 26 Jun 2019 18:45:08 +0200
In-Reply-To: <6CECE9DE-51AB-4A21-A257-8B85C4C94EB0@amacapital.net> (Andy
	Lutomirski's message of "Wed, 26 Jun 2019 09:24:38 -0700")
Message-ID: <87sgrw1ejv.fsf@oldenburg2.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Wed, 26 Jun 2019 16:45:19 +0000 (UTC)

* Andy Lutomirski:

> Can=E2=80=99t an ELF note be done with some more or less ordinary asm such
> that any link editor will insert it correctly?

We've just been over this for the CET enablement.  ELF PT_NOTE parsing
was rejected there.

I don't think binutils ld has a way to set an ELF program header it
doesn't know anything about.

>>> Would enterprise distros consider backporting such a thing?
>>=20
>> Enterprise distros aren't the problem here because they can't remove
>> vsyscall support for quite a while due to existing customer binaries.
>> For them, it would just be an additional (and welcome) hardening
>> opportunity.
>>=20
>> The challenge here are container hosting platforms which have already
>> disabled vsyscall, presumably to protect the container host itself.
>> They would need to rebuild the container host userspace with the markup
>> to keep it protected, and then they could switch to a kernel which has
>> vsyscall-unless-opt-out logic.  That seems to be a bit of a stretch
>> because from their perspective, there's no problem today.
>>=20
>> My guess is that it would be easier to have a personality flag.  Then
>> they could keep the host largely as-is, and would =E2=80=9Conly=E2=80=9D=
 need a
>> mechanism to pass through the flag from the image metadata to the actual
>> container creation.  It's still a change to the container host (and the
>> kernel change is required as well), but it would not require relinking
>> every statically linked binary.

> The problem with a personality flag is that it needs to have some kind
> of sensible behavior for setuid programs, and getting that right in a
> way that doesn=E2=80=99t scream =E2=80=9Cexploit me=E2=80=9D while preser=
ving useful
> compatibility may be tricky.

Are restrictive personality flags still a problem with user namespaces?
I think it would be fine to restrict this one to CAP_SYS_ADMIN.

Thanks,
Florian
