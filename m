Return-Path: <kernel-hardening-return-21749-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 1637DC3271E
	for <kernel-hardening@archiver.kernel.org>; Mon,  8 Jul 2024 16:26:53 +0000 (UTC)
Received: (qmail 1804 invoked by uid 550); 8 Jul 2024 16:26:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1784 invoked from network); 8 Jul 2024 16:26:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720455993;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J8+nyKJPtmYL3Q1Jw+NMTU5s3BULPLom/3c1fVXHWAY=;
	b=AwlpJ4jc1IgkQSOJvrt/DPBCJ2hdWDGFyk6her5DCcpgzeU8APkW6OgDBnU5vwUOujhpj3
	fMcIf3JSxLPbVBYiD8DZpl03kr4AJsnoBpbVYja88RR7rRxqRnMCWYWoIvebuj1VQMgfWv
	qsj2LbjTK5E1PmJQbgyFn92OB2/CezQ=
X-MC-Unique: PTESLuptN-miLqEs4oSOeA-1
From: Florian Weimer <fweimer@redhat.com>
To: Jeff Xu <jeffxu@google.com>
Cc: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>,  Al Viro
 <viro@zeniv.linux.org.uk>,
  Christian Brauner <brauner@kernel.org>,  Kees Cook
 <keescook@chromium.org>,  Linus Torvalds <torvalds@linux-foundation.org>,
  Paul Moore <paul@paul-moore.com>,  "Theodore Ts'o" <tytso@mit.edu>,
  Alejandro Colomar <alx.manpages@gmail.com>,  Aleksa Sarai
 <cyphar@cyphar.com>,  Andrew Morton <akpm@linux-foundation.org>,  Andy
 Lutomirski <luto@kernel.org>,  Arnd Bergmann <arnd@arndb.de>,  Casey
 Schaufler <casey@schaufler-ca.com>,  Christian Heimes
 <christian@python.org>,  Dmitry Vyukov <dvyukov@google.com>,  Eric Biggers
 <ebiggers@kernel.org>,  Eric Chiang <ericchiang@google.com>,  Fan Wu
 <wufan@linux.microsoft.com>,  Geert Uytterhoeven <geert@linux-m68k.org>,
  James Morris <jamorris@linux.microsoft.com>,  Jan Kara <jack@suse.cz>,
  Jann Horn <jannh@google.com>,  Jonathan Corbet <corbet@lwn.net>,  Jordan
 R Abrahams <ajordanr@google.com>,  Lakshmi Ramasubramanian
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
In-Reply-To: <CALmYWFu_JFyuwYhDtEDWxEob8JHFSoyx_SCcsRVKqSYyyw30Rg@mail.gmail.com>
	(Jeff Xu's message of "Mon, 8 Jul 2024 09:08:29 -0700")
References: <20240704190137.696169-1-mic@digikod.net>
	<20240704190137.696169-2-mic@digikod.net>
	<87bk3bvhr1.fsf@oldenburg.str.redhat.com>
	<CALmYWFu_JFyuwYhDtEDWxEob8JHFSoyx_SCcsRVKqSYyyw30Rg@mail.gmail.com>
Date: Mon, 08 Jul 2024 18:25:59 +0200
Message-ID: <87ed83etpk.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

* Jeff Xu:

> Will dynamic linkers use the execveat(AT_CHECK) to check shared
> libraries too ?  or just the main executable itself.

I expect that dynamic linkers will have to do this for everything they
map.  Usually, that does not include the maim program, but this can
happen with explicit loader invocations (=E2=80=9Cld.so /bin/true=E2=80=9D).

Thanks,
Florian

