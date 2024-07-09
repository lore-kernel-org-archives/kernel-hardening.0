Return-Path: <kernel-hardening-return-21768-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id EA477C2BD09
	for <kernel-hardening@archiver.kernel.org>; Tue,  9 Jul 2024 10:06:49 +0000 (UTC)
Received: (qmail 7760 invoked by uid 550); 9 Jul 2024 10:06:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7735 invoked from network); 9 Jul 2024 10:06:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720519588;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tjTUnc7IhcTY8yXbQZCHDpYRmcDVvOi7wtfkPwMCZy4=;
	b=Jmxx1qkTxK7lv9nfnILaf/LRMAbZ0ZrxJsn9+rR2fGMZ3N0JczgUYyEgq6X4gqeiXBm3SP
	91Nb3Ubn7bF44Uc96BfLUZCE/1eKPCbEtPCvp2tNpx1JvyV+tlm+a8PG1EjzNF/GBQG9fE
	RRSVW0Pm/eGfzhoKPvOkd5n749e0TNQ=
X-MC-Unique: UiV9XaiFPlaMJoCqgi_zcA-1
From: Florian Weimer <fweimer@redhat.com>
To: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
Cc: Jeff Xu <jeffxu@google.com>,  Al Viro <viro@zeniv.linux.org.uk>,
  Christian Brauner <brauner@kernel.org>,  Kees Cook
 <keescook@chromium.org>,  Linus Torvalds <torvalds@linux-foundation.org>,
  Paul Moore <paul@paul-moore.com>,  Theodore Ts'o <tytso@mit.edu>,
  Alejandro Colomar <alx@kernel.org>,  Aleksa Sarai <cyphar@cyphar.com>,
  Andrew Morton <akpm@linux-foundation.org>,  Andy Lutomirski
 <luto@kernel.org>,  Arnd Bergmann <arnd@arndb.de>,  Casey Schaufler
 <casey@schaufler-ca.com>,  Christian Heimes <christian@python.org>,
  Dmitry Vyukov <dvyukov@google.com>,  Eric Biggers <ebiggers@kernel.org>,
  Eric Chiang <ericchiang@google.com>,  Fan Wu <wufan@linux.microsoft.com>,
  Geert Uytterhoeven <geert@linux-m68k.org>,  James Morris
 <jamorris@linux.microsoft.com>,  Jan Kara <jack@suse.cz>,  Jann Horn
 <jannh@google.com>,  Jonathan Corbet <corbet@lwn.net>,  Jordan R Abrahams
 <ajordanr@google.com>,  Lakshmi Ramasubramanian
 <nramas@linux.microsoft.com>,  Luca Boccassi <bluca@debian.org>,  Luis
 Chamberlain <mcgrof@kernel.org>,  "Madhavan T . Venkataraman"
 <madvenka@linux.microsoft.com>,  Matt Bobrowski
 <mattbobrowski@google.com>,  Matthew Garrett <mjg59@srcf.ucam.org>,
  Matthew Wilcox <willy@infradead.org>,  Miklos Szeredi
 <mszeredi@redhat.com>,  Mimi Zohar <zohar@linux.ibm.com>,  Nicolas
 Bouchinet <nicolas.bouchinet@ssi.gouv.fr>,  Scott Shell
 <scottsh@microsoft.com>,  Shuah Khan <shuah@kernel.org>,  Stephen Rothwell
 <sfr@canb.auug.org.au>,  Steve Dower <steve.dower@python.org>,  Steve
 Grubb <sgrubb@redhat.com>,  Thibaut Sautereau
 <thibaut.sautereau@ssi.gouv.fr>,  Vincent Strubel
 <vincent.strubel@ssi.gouv.fr>,  Xiaoming Ni <nixiaoming@huawei.com>,  Yin
 Fengwei <fengwei.yin@intel.com>,  kernel-hardening@lists.openwall.com,
  linux-api@vger.kernel.org,  linux-fsdevel@vger.kernel.org,
  linux-integrity@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-security-module@vger.kernel.org
Subject: Re: [RFC PATCH v19 1/5] exec: Add a new AT_CHECK flag to execveat(2)
In-Reply-To: <20240709.gae4cu4Aiv6s@digikod.net> (=?utf-8?Q?=22Micka=C3=AB?=
 =?utf-8?Q?l_Sala=C3=BCn=22's?= message
	of "Tue, 9 Jul 2024 11:18:00 +0200")
References: <20240704190137.696169-1-mic@digikod.net>
	<20240704190137.696169-2-mic@digikod.net>
	<87bk3bvhr1.fsf@oldenburg.str.redhat.com>
	<CALmYWFu_JFyuwYhDtEDWxEob8JHFSoyx_SCcsRVKqSYyyw30Rg@mail.gmail.com>
	<87ed83etpk.fsf@oldenburg.str.redhat.com>
	<CALmYWFvkUnevm=npBeaZVkK_PXm=A8MjgxFXkASnERxoMyhYBg@mail.gmail.com>
	<87r0c3dc1c.fsf@oldenburg.str.redhat.com>
	<CALmYWFvA7VPz06Tg8E-R_Jqn2cxMiWPPC6Vhy+vgqnofT0GELg@mail.gmail.com>
	<20240709.gae4cu4Aiv6s@digikod.net>
Date: Tue, 09 Jul 2024 12:05:50 +0200
Message-ID: <87ed82283l.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

* Micka=C3=ABl Sala=C3=BCn:

>> > If we want to avoid that, we could have an agreed-upon error code which
>> > the LSM can signal that it'll never fail AT_CHECK checks, so we only
>> > have to perform the extra system call once.
>
> I'm not sure to follow.  Either we check executable code or we don't,
> but it doesn't make sense to only check some parts (except for migration
> of user space code in a system, which is one purpose of the securebits
> added with the next patch).
>
> The idea with AT_CHECK is to unconditionnaly check executable right the
> same way it is checked when a file is executed.  User space can decide
> to check that or not according to its policy (i.e. securebits).

I meant it purely as a performance optimization, to skip future system
calls if we know they won't provide any useful information for this
process.  In the grand scheme of things, the extra system call probably
does not matter because we already have to do costly things like mmap.

Thanks,
Florian

