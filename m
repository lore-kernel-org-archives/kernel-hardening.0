Return-Path: <kernel-hardening-return-21738-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id BEEE3C38150
	for <kernel-hardening@archiver.kernel.org>; Fri,  5 Jul 2024 18:04:13 +0000 (UTC)
Received: (qmail 15646 invoked by uid 550); 5 Jul 2024 18:04:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15624 invoked from network); 5 Jul 2024 18:04:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720202632;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zSfj4hB72oKzYazsXTJG2nso9UJZp4flz44DNiaCEyM=;
	b=Qg3gHb1xl40z6wfdsi3lBWtR8TpTdKGgBSd3W/Nf8VInd7cT3ye2QVgdJiJqVP2fA662qR
	tKQg7XbXxHGB+3w2wncLKsw+KhE9BIngCqV7Kph2pBTlM4h9oS+6v7BVohMyuouRjsTgxx
	3e8w9OPJ76z8FB2QM4XpbK9cnATktr8=
X-MC-Unique: FWma5yPMP_mRE7JBJbAOnQ-1
From: Florian Weimer <fweimer@redhat.com>
To: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>,  Christian Brauner
 <brauner@kernel.org>,  Kees Cook <keescook@chromium.org>,  Linus Torvalds
 <torvalds@linux-foundation.org>,  Paul Moore <paul@paul-moore.com>,
  Theodore Ts'o <tytso@mit.edu>,  Alejandro Colomar
 <alx.manpages@gmail.com>,  Aleksa Sarai <cyphar@cyphar.com>,  Andrew
 Morton <akpm@linux-foundation.org>,  Andy Lutomirski <luto@kernel.org>,
  Arnd Bergmann <arnd@arndb.de>,  Casey Schaufler <casey@schaufler-ca.com>,
  Christian Heimes <christian@python.org>,  Dmitry Vyukov
 <dvyukov@google.com>,  Eric Biggers <ebiggers@kernel.org>,  Eric Chiang
 <ericchiang@google.com>,  Fan Wu <wufan@linux.microsoft.com>,  Geert
 Uytterhoeven <geert@linux-m68k.org>,  James Morris
 <jamorris@linux.microsoft.com>,  Jan Kara <jack@suse.cz>,  Jann Horn
 <jannh@google.com>,  Jeff Xu <jeffxu@google.com>,  Jonathan Corbet
 <corbet@lwn.net>,  Jordan R Abrahams <ajordanr@google.com>,  Lakshmi
 Ramasubramanian <nramas@linux.microsoft.com>,  Luca Boccassi
 <bluca@debian.org>,  Luis Chamberlain <mcgrof@kernel.org>,  "Madhavan T .
 Venkataraman" <madvenka@linux.microsoft.com>,  Matt Bobrowski
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
In-Reply-To: <20240704190137.696169-2-mic@digikod.net> (=?utf-8?Q?=22Micka?=
 =?utf-8?Q?=C3=ABl_Sala=C3=BCn=22's?=
	message of "Thu, 4 Jul 2024 21:01:33 +0200")
References: <20240704190137.696169-1-mic@digikod.net>
	<20240704190137.696169-2-mic@digikod.net>
Date: Fri, 05 Jul 2024 20:03:14 +0200
Message-ID: <87bk3bvhr1.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

* Micka=C3=ABl Sala=C3=BCn:

> Add a new AT_CHECK flag to execveat(2) to check if a file would be
> allowed for execution.  The main use case is for script interpreters and
> dynamic linkers to check execution permission according to the kernel's
> security policy. Another use case is to add context to access logs e.g.,
> which script (instead of interpreter) accessed a file.  As any
> executable code, scripts could also use this check [1].

Some distributions no longer set executable bits on most shared objects,
which I assume would interfere with AT_CHECK probing for shared objects.
Removing the executable bit is attractive because of a combination of
two bugs: a binutils wart which until recently always set the entry
point address in the ELF header to zero, and the kernel not checking for
a zero entry point (maybe in combination with an absent program
interpreter) and failing the execve with ELIBEXEC, instead of doing the
execve and then faulting at virtual address zero.  Removing the
executable bit is currently the only way to avoid these confusing
crashes, so I understand the temptation.

Thanks,
Florian

