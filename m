Return-Path: <SRS0=/5po=UZ=lists.openwall.com=kernel-hardening-return-16258-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62770C48BD3
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Jun 2019 15:00:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BFACD2133F
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Jun 2019 15:00:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BFACD2133F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16258-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13846 invoked by uid 550); 26 Jun 2019 15:00:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13828 invoked from network); 26 Jun 2019 15:00:50 -0000
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
Date: Wed, 26 Jun 2019 17:00:28 +0200
In-Reply-To: <CA96B819-30A9-43D3-9FE3-2D551D35369E@amacapital.net> (Andy
	Lutomirski's message of "Wed, 26 Jun 2019 07:15:59 -0700")
Message-ID: <87r27gjss3.fsf@oldenburg2.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Wed, 26 Jun 2019 15:00:38 +0000 (UTC)

* Andy Lutomirski:

> I didn=E2=80=99t add a flag because the vsyscall page was thoroughly obso=
lete
> when all this happened, and I wanted to encourage all new code to just
> parse the vDSO instead of piling on the hacks.

It turned out that the thorny cases just switched to system calls
instead.  I think we finally completed the transition in glibc upstream
in 2018 (for x86).

> Anyway, you may be the right person to ask: is there some credible way
> that the kernel could detect new binaries that don=E2=80=99t need vsyscal=
ls?
> Maybe a new ELF note on a static binary or on the ELF interpreter? We
> can dynamically switch it in principle.

For this kind of change, markup similar to PT_GNU_STACK would have been
appropriate, I think: Old kernels and loaders would have ignored the
program header and loaded the program anyway, but the vsyscall page
still existed, so that would have been fine. The kernel would have
needed to check the program interpreter or the main executable (without
a program interpreter, i.e., the statically linked case).  Due the way
the vsyscalls are concentrated in glibc, a dynamically linked executable
would not have needed checking (or re-linking).  I don't think we would
have implemented the full late enablement after dlopen we did for
executable stacks.  In theory, any code could have jumped to the
vsyscall area, but in practice, it's just dynamically linked glibc and
static binaries.

But nowadays, unmarked glibcs which do not depend on vsyscall vastly
outnumber unmarked glibcs which requrie it.  Therefore, markup of
binaries does not seem to be reasonable to day.  I could imagine a
personality flag you can set (if yoy have CAP_SYS_ADMIN) that re-enables
vsyscall support for new subprocesses.  And a container runtime would do
this based on metadata found in the image.  This way, the container host
itself could be protected, and you could still run legacy images which
require vsyscall.

For the non-container case, if you know that you'll run legacy
workloads, you'd still have the boot parameter.  But I think it could
default to vsyscall=3Dnone in many more cases.

Thanks,
Florian
