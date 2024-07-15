Return-Path: <kernel-hardening-return-21781-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id BB9EDC3DA4B
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Jul 2024 20:17:08 +0000 (UTC)
Received: (qmail 3125 invoked by uid 550); 15 Jul 2024 20:16:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3104 invoked from network); 15 Jul 2024 20:16:52 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 9853A418A2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1721074602; bh=qCiGfPB1gQ4jS9TNROTwe/253cFlMSCfdlMQaOpPpXM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=DA6RQIEoFFqTWCYbIUWlOKjxmMchd8JstjU1istskyz4wucCTn63QQ1d7WEP9c3N9
	 +uEJiE6NiSQkuIb7A3ybtn/rknSK6559U6x13uhxdkKJ1B40Q7W34CmCjLRNunemQo
	 a2Q6Ij+XN8nAooXYLvFjGy9eLfwOoNCiDakxWij2+n71YbXXa6SEFoI4G5d3kPVxRw
	 LoZgUcOz/BMK7U8TipaVGz7RLHFUB9TAruatbX18ydU7GbsFbC9yGzABG+Dm3+4wPf
	 zWNcR5eToI69Wtncggp6gkWWPGltQFDkucVVEExkDb4c6zJcyWD4zzxMWI/XXgxXBM
	 xtHjVPv2/osKQ==
From: Jonathan Corbet <corbet@lwn.net>
To: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>, Al Viro
 <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Kees Cook <keescook@chromium.org>,
 Linus Torvalds <torvalds@linux-foundation.org>, Paul Moore
 <paul@paul-moore.com>, Theodore Ts'o <tytso@mit.edu>
Cc: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>, Alejandro
 Colomar
 <alx.manpages@gmail.com>, Aleksa Sarai <cyphar@cyphar.com>, Andrew Morton
 <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Arnd
 Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>,
 Christian Heimes <christian@python.org>, Dmitry Vyukov
 <dvyukov@google.com>, Eric Biggers <ebiggers@kernel.org>, Eric Chiang
 <ericchiang@google.com>, Fan Wu <wufan@linux.microsoft.com>, Florian
 Weimer <fweimer@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>,
 James Morris <jamorris@linux.microsoft.com>, Jan Kara <jack@suse.cz>, Jann
 Horn <jannh@google.com>, Jeff Xu <jeffxu@google.com>, Jordan R Abrahams
 <ajordanr@google.com>, Lakshmi Ramasubramanian
 <nramas@linux.microsoft.com>, Luca Boccassi <bluca@debian.org>, Luis
 Chamberlain <mcgrof@kernel.org>, "Madhavan T . Venkataraman"
 <madvenka@linux.microsoft.com>, Matt Bobrowski <mattbobrowski@google.com>,
 Matthew Garrett <mjg59@srcf.ucam.org>, Matthew Wilcox
 <willy@infradead.org>, Miklos Szeredi <mszeredi@redhat.com>, Mimi Zohar
 <zohar@linux.ibm.com>, Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>,
 Scott Shell <scottsh@microsoft.com>, Shuah Khan <shuah@kernel.org>,
 Stephen Rothwell <sfr@canb.auug.org.au>, Steve Dower
 <steve.dower@python.org>, Steve Grubb <sgrubb@redhat.com>, Thibaut
 Sautereau <thibaut.sautereau@ssi.gouv.fr>, Vincent Strubel
 <vincent.strubel@ssi.gouv.fr>, Xiaoming Ni <nixiaoming@huawei.com>, Yin
 Fengwei <fengwei.yin@intel.com>, kernel-hardening@lists.openwall.com,
 linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org
Subject: Re: [RFC PATCH v19 0/5] Script execution control (was O_MAYEXEC)
In-Reply-To: <20240704190137.696169-1-mic@digikod.net>
References: <20240704190137.696169-1-mic@digikod.net>
Date: Mon, 15 Jul 2024 14:16:41 -0600
Message-ID: <8734oawguu.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> writes:

FYI:

> User space patches can be found here:
> https://github.com/clipos-archive/clipos4_portage-overlay/search?q=3DO_MA=
YEXEC

That link appears to be broken.

Thanks,

jon
