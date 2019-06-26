Return-Path: <SRS0=4BJg=UZ=lists.openwall.com=kernel-hardening-return-16266-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A817C48BD3
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Jun 2019 17:04:42 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D1E9320665
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Jun 2019 17:04:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D1E9320665
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16266-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1930 invoked by uid 550); 26 Jun 2019 17:04:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1902 invoked from network); 26 Jun 2019 17:04:34 -0000
From: Florian Weimer <fweimer@redhat.com>
To: Andy Lutomirski <luto@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,  Linux API <linux-api@vger.kernel.org>,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  linux-x86_64@vger.kernel.org,  linux-arch <linux-arch@vger.kernel.org>,  Kees Cook <keescook@chromium.org>,  "Carlos O'Donell" <carlos@redhat.com>,  X86 ML <x86@kernel.org>
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
	<87sgrw1ejv.fsf@oldenburg2.str.redhat.com>
	<CALCETrUG9yHf4D_fDEj054Bgo4zXpmK5UzME9mKNqD70U7vy5Q@mail.gmail.com>
Date: Wed, 26 Jun 2019 19:04:12 +0200
In-Reply-To: <CALCETrUG9yHf4D_fDEj054Bgo4zXpmK5UzME9mKNqD70U7vy5Q@mail.gmail.com>
	(Andy Lutomirski's message of "Wed, 26 Jun 2019 09:52:15 -0700")
Message-ID: <87ef3g1do3.fsf@oldenburg2.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Wed, 26 Jun 2019 17:04:22 +0000 (UTC)

* Andy Lutomirski:

> On Wed, Jun 26, 2019 at 9:45 AM Florian Weimer <fweimer@redhat.com> wrote:
>>
>> * Andy Lutomirski:
>>
>> > Can=E2=80=99t an ELF note be done with some more or less ordinary asm =
such
>> > that any link editor will insert it correctly?
>>
>> We've just been over this for the CET enablement.  ELF PT_NOTE parsing
>> was rejected there.
>
> No one told me this.  Unless I missed something, the latest kernel
> patches still had PT_NOTE parsing.  Can you point me at an
> enlightening thread or explain what happened?

The ABI was changed rather late, and PT_GNU_PROPERTY has been added.
But this is okay because the kernel only looks at the dynamic loader,
which we can update fairly easily.

The thread is:

Subject: Re: [PATCH v7 22/27] binfmt_elf: Extract .note.gnu.property from a=
n ELF file

<87blyu7ubf.fsf@oldenburg2.str.redhat.com> is a message reference in it.

>> > The problem with a personality flag is that it needs to have some kind
>> > of sensible behavior for setuid programs, and getting that right in a
>> > way that doesn=E2=80=99t scream =E2=80=9Cexploit me=E2=80=9D while pre=
serving useful
>> > compatibility may be tricky.
>>
>> Are restrictive personality flags still a problem with user namespaces?
>> I think it would be fine to restrict this one to CAP_SYS_ADMIN.
>
> We could possibly get away with this, but now we're introducing a
> whole new mechanism.  I'd rather just add proper per-namespace
> sysctls, but this is a pretty big hammer.

Oh, I wasn't aware of that.  I thought that this already existed in some
form, e.g. prctl with PR_SET_SECCOMP requiring CAP_SYS_ADMIN unless
PR_SET_NO_NEW_PRIVS was active as well.

Thanks,
Florian
