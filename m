Return-Path: <kernel-hardening-return-21741-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 80429C2BD09
	for <kernel-hardening@archiver.kernel.org>; Sat,  6 Jul 2024 12:46:23 +0000 (UTC)
Received: (qmail 30633 invoked by uid 550); 6 Jul 2024 12:46:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22406 invoked from network); 5 Jul 2024 22:22:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720218138;
	bh=ENklnaGwg7gbVoxwnNN9rxnZRVBjkNfp1WlAFtAN+BM=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=R82FvL6Jp535Akx7VaoouTVyo3yZ0oGQHmxMZDd8FwAEPKBkSuOcmyJ9yJToPi+f9
	 UFyV7ns+xPCXVNrONu4MLRJ+og/16DTLW2nn8UuBAWcIEwgWrhiYRfAE6UC5NF6fEW
	 o8fn/hy3aBZgrLuJfjcZ5BJ5x9sR4unHadsjfrLzWnrBoQTX8zJnvSwCMdcBdRTRiw
	 TXzP3JsHskW93BnEtYnD2cSp6iB3K3VR7Tey1BRNlrZeD9ilvydyOdUhlnBqXbDmwD
	 sGTt5wEsH8n14WZh+M/G2uVc89lBBgwL/9yNfZMoGxCPo4ph3osIyWc0IRFrCqyTX9
	 C3W/JiomT1p3A==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 06 Jul 2024 01:22:06 +0300
Message-Id: <D2HYFLLXVYLS.ORASE7L62L3N@kernel.org>
Subject: Re: [RFC PATCH v19 2/5] security: Add new SHOULD_EXEC_CHECK and
 SHOULD_EXEC_RESTRICT securebits
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Kees Cook" <kees@kernel.org>, =?utf-8?q?Micka=C3=ABl_Sala=C3=BCn?=
 <mic@digikod.net>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner"
 <brauner@kernel.org>, "Linus Torvalds" <torvalds@linux-foundation.org>,
 "Paul Moore" <paul@paul-moore.com>, "Theodore Ts'o" <tytso@mit.edu>,
 "Alejandro Colomar" <alx@kernel.org>, "Aleksa Sarai" <cyphar@cyphar.com>,
 "Andrew Morton" <akpm@linux-foundation.org>, "Andy Lutomirski"
 <luto@kernel.org>, "Arnd Bergmann" <arnd@arndb.de>, "Casey Schaufler"
 <casey@schaufler-ca.com>, "Christian Heimes" <christian@python.org>,
 "Dmitry Vyukov" <dvyukov@google.com>, "Eric Biggers" <ebiggers@kernel.org>,
 "Eric Chiang" <ericchiang@google.com>, "Fan Wu"
 <wufan@linux.microsoft.com>, "Florian Weimer" <fweimer@redhat.com>, "Geert
 Uytterhoeven" <geert@linux-m68k.org>, "James Morris"
 <jamorris@linux.microsoft.com>, "Jan Kara" <jack@suse.cz>, "Jann Horn"
 <jannh@google.com>, "Jeff Xu" <jeffxu@google.com>, "Jonathan Corbet"
 <corbet@lwn.net>, "Jordan R Abrahams" <ajordanr@google.com>, "Lakshmi
 Ramasubramanian" <nramas@linux.microsoft.com>, "Luca Boccassi"
 <bluca@debian.org>, "Luis Chamberlain" <mcgrof@kernel.org>, "Madhavan T .
 Venkataraman" <madvenka@linux.microsoft.com>, "Matt Bobrowski"
 <mattbobrowski@google.com>, "Matthew Garrett" <mjg59@srcf.ucam.org>,
 "Matthew Wilcox" <willy@infradead.org>, "Miklos Szeredi"
 <mszeredi@redhat.com>, "Mimi Zohar" <zohar@linux.ibm.com>, "Nicolas
 Bouchinet" <nicolas.bouchinet@ssi.gouv.fr>, "Scott Shell"
 <scottsh@microsoft.com>, "Shuah Khan" <shuah@kernel.org>, "Stephen
 Rothwell" <sfr@canb.auug.org.au>, "Steve Dower" <steve.dower@python.org>,
 "Steve Grubb" <sgrubb@redhat.com>, "Thibaut Sautereau"
 <thibaut.sautereau@ssi.gouv.fr>, "Vincent Strubel"
 <vincent.strubel@ssi.gouv.fr>, "Xiaoming Ni" <nixiaoming@huawei.com>, "Yin
 Fengwei" <fengwei.yin@intel.com>, <kernel-hardening@lists.openwall.com>,
 <linux-api@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-integrity@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-security-module@vger.kernel.org>
X-Mailer: aerc 0.17.0
References: <20240704190137.696169-1-mic@digikod.net>
 <20240704190137.696169-3-mic@digikod.net> <202407041711.B7CD16B2@keescook>
 <20240705.IeTheequ7Ooj@digikod.net> <202407051425.32AF9D2@keescook>
In-Reply-To: <202407051425.32AF9D2@keescook>

On Sat Jul 6, 2024 at 12:44 AM EEST, Kees Cook wrote:
> > As explained in the UAPI comments, all parent processes need to be
> > trusted.  This meeans that their code is trusted, their seccomp filters
> > are trusted, and that they are patched, if needed, to check file
> > executability.
>
> But we have launchers that apply arbitrary seccomp policy, e.g. minijail
> on Chrome OS, or even systemd on regular distros. In theory, this should
> be handled via other ACLs.

Or a regular web browser? AFAIK seccomp filtering was the tool to make
secure browser tabs in the first place.

BR, Jarkko
