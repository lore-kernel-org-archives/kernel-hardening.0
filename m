Return-Path: <SRS0=fw9N=UZ=lists.openwall.com=kernel-hardening-return-16261-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25C0BC48BD3
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Jun 2019 15:36:30 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7A0932085A
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Jun 2019 15:36:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7A0932085A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16261-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1914 invoked by uid 550); 26 Jun 2019 15:36:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1888 invoked from network); 26 Jun 2019 15:36:21 -0000
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
Date: Wed, 26 Jun 2019 17:36:03 +0200
In-Reply-To: <534B9F63-E949-4CF5-ACAC-71381190846F@amacapital.net> (Andy
	Lutomirski's message of "Wed, 26 Jun 2019 08:21:05 -0700")
Message-ID: <87a7e4jr4s.fsf@oldenburg2.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Wed, 26 Jun 2019 15:36:09 +0000 (UTC)

* Andy Lutomirski:

> I=E2=80=99m wondering if we can still do it: add a note or other ELF indi=
cator
> that says =E2=80=9CI don=E2=80=99t need vsyscalls.=E2=80=9D  Then we can =
change the default
> mode to =E2=80=9Cno vsyscalls if the flag is there, else execute-only
> vsyscalls=E2=80=9D.
>
> Would glibc go along with this?

I think we can make it happen, at least for relatively recent glibc
linked with current binutils.  It's not trivial because it requires
coordination among multiple projects.  We have three or four widely used
link editors now, but we could make it happen.  (Although getting to
PT_GNU_PROPERTY wasn't exactly easy.)

> Would enterprise distros consider backporting such a thing?

Enterprise distros aren't the problem here because they can't remove
vsyscall support for quite a while due to existing customer binaries.
For them, it would just be an additional (and welcome) hardening
opportunity.

The challenge here are container hosting platforms which have already
disabled vsyscall, presumably to protect the container host itself.
They would need to rebuild the container host userspace with the markup
to keep it protected, and then they could switch to a kernel which has
vsyscall-unless-opt-out logic.  That seems to be a bit of a stretch
because from their perspective, there's no problem today.

My guess is that it would be easier to have a personality flag.  Then
they could keep the host largely as-is, and would =E2=80=9Conly=E2=80=9D ne=
ed a
mechanism to pass through the flag from the image metadata to the actual
container creation.  It's still a change to the container host (and the
kernel change is required as well), but it would not require relinking
every statically linked binary.

Thanks,
Florian
