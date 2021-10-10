Return-Path: <SRS0=KXmw=O6=lists.openwall.com=kernel-hardening-return-21436-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D4DAC433F5
	for <kernel-hardening@archiver.kernel.org>; Sun, 10 Oct 2021 14:11:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7902961058
	for <kernel-hardening@archiver.kernel.org>; Sun, 10 Oct 2021 14:11:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7902961058
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=deneb.enyo.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 28669 invoked by uid 550); 10 Oct 2021 14:11:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28649 invoked from network); 10 Oct 2021 14:11:11 -0000
From: Florian Weimer <fw@deneb.enyo.de>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>,  Andrew Morton
 <akpm@linux-foundation.org>,  Aleksa Sarai <cyphar@cyphar.com>,  Andy
 Lutomirski <luto@kernel.org>,  Arnd Bergmann <arnd@arndb.de>,  Casey
 Schaufler <casey@schaufler-ca.com>,  Christian Brauner
 <christian.brauner@ubuntu.com>,  Christian Heimes <christian@python.org>,
  Deven Bowers <deven.desai@linux.microsoft.com>,  Dmitry Vyukov
 <dvyukov@google.com>,  Eric Biggers <ebiggers@kernel.org>,  Eric Chiang
 <ericchiang@google.com>,  Geert Uytterhoeven <geert@linux-m68k.org>,
  James Morris <jmorris@namei.org>,  Jan Kara <jack@suse.cz>,  Jann Horn
 <jannh@google.com>,  Jonathan Corbet <corbet@lwn.net>,  Kees Cook
 <keescook@chromium.org>,  Lakshmi Ramasubramanian
 <nramas@linux.microsoft.com>,  "Madhavan T . Venkataraman"
 <madvenka@linux.microsoft.com>,  Matthew Garrett <mjg59@google.com>,
  Matthew Wilcox <willy@infradead.org>,  Miklos Szeredi
 <mszeredi@redhat.com>,  Mimi Zohar <zohar@linux.ibm.com>,  Paul Moore
 <paul@paul-moore.com>,  Philippe =?iso-8859-1?Q?Tr=E9buchet?=
 <philippe.trebuchet@ssi.gouv.fr>,  Scott Shell <scottsh@microsoft.com>,
  Shuah Khan <shuah@kernel.org>,  Steve Dower <steve.dower@python.org>,
  Steve Grubb <sgrubb@redhat.com>,  Thibaut Sautereau
 <thibaut.sautereau@ssi.gouv.fr>,  Vincent Strubel
 <vincent.strubel@ssi.gouv.fr>,  kernel-hardening@lists.openwall.com,
  linux-api@vger.kernel.org,  linux-fsdevel@vger.kernel.org,
  linux-integrity@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-security-module@vger.kernel.org,  =?iso-8859-1?Q?Micka=EBl_Sala=FC?=
 =?iso-8859-1?Q?n?=
 <mic@linux.microsoft.com>
Subject: Re: [PATCH v14 1/3] fs: Add trusted_for(2) syscall implementation
 and related sysctl
References: <20211008104840.1733385-1-mic@digikod.net>
	<20211008104840.1733385-2-mic@digikod.net>
Date: Sun, 10 Oct 2021 16:10:07 +0200
In-Reply-To: <20211008104840.1733385-2-mic@digikod.net>
 (=?iso-8859-1?Q?=22Micka=EBl_Sala=FCn=22's?=
	message of "Fri, 8 Oct 2021 12:48:38 +0200")
Message-ID: <87tuhpynr4.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

* Micka=EBl Sala=FCn:

> Being able to restrict execution also enables to protect the kernel by
> restricting arbitrary syscalls that an attacker could perform with a
> crafted binary or certain script languages.  It also improves multilevel
> isolation by reducing the ability of an attacker to use side channels
> with specific code.  These restrictions can natively be enforced for ELF
> binaries (with the noexec mount option) but require this kernel
> extension to properly handle scripts (e.g. Python, Perl).  To get a
> consistent execution policy, additional memory restrictions should also
> be enforced (e.g. thanks to SELinux).

One example I have come across recently is that code which can be
safely loaded as a Perl module is definitely not a no-op as a shell
script: it downloads code and executes it, apparently over an
untrusted network connection and without signature checking.

Maybe in the IMA world, the expectation is that such ambiguous code
would not be signed in the first place, but general-purpose
distributions are heading in a different direction with
across-the-board signing:

  Signed RPM Contents
  <https://fedoraproject.org/wiki/Changes/Signed_RPM_Contents>

So I wonder if we need additional context information for a potential
LSM to identify the intended use case.
