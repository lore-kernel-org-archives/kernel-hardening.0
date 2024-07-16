Return-Path: <kernel-hardening-return-21791-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 36F98C3DA59
	for <kernel-hardening@archiver.kernel.org>; Tue, 16 Jul 2024 17:48:29 +0000 (UTC)
Received: (qmail 11742 invoked by uid 550); 16 Jul 2024 17:48:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11719 invoked from network); 16 Jul 2024 17:48:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1721152088;
	bh=LWblpPfF9wNYIYfX15oQl6tTRp3rZAKkmPWjrsQep60=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QQQ+S7I2Ua4od8sW/6D1JC9ivlgTH1sZMkaw8jYNQtPma8Ip6DbG40h1NpdimI7Xc
	 F/k0WwtFrl7pTIGzv0AQntKmgMTJmCu5m09toaI5LhDwng++5GebvyVFtv5GfZB3yN
	 VtdK+y0E4iqnH4BuYwNCr38mLDQw/yAs+Enhz0wE=
Date: Tue, 16 Jul 2024 19:47:59 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Boris Lukashev <blukashev@sempervictus.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, 
	Roberto Sassu <roberto.sassu@huaweicloud.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Paul Moore <paul@paul-moore.com>, Theodore Ts'o <tytso@mit.edu>, 
	Alejandro Colomar <alx@kernel.org>, Aleksa Sarai <cyphar@cyphar.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Casey Schaufler <casey@schaufler-ca.com>, Christian Heimes <christian@python.org>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Biggers <ebiggers@kernel.org>, 
	Eric Chiang <ericchiang@google.com>, Fan Wu <wufan@linux.microsoft.com>, 
	Florian Weimer <fweimer@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	James Morris <jamorris@linux.microsoft.com>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, 
	Jeff Xu <jeffxu@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	Jordan R Abrahams <ajordanr@google.com>, Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, 
	Luca Boccassi <bluca@debian.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>, Matt Bobrowski <mattbobrowski@google.com>, 
	Matthew Garrett <mjg59@srcf.ucam.org>, Matthew Wilcox <willy@infradead.org>, 
	Miklos Szeredi <mszeredi@redhat.com>, Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>, 
	Scott Shell <scottsh@microsoft.com>, Shuah Khan <shuah@kernel.org>, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Steve Dower <steve.dower@python.org>, 
	Steve Grubb <sgrubb@redhat.com>, Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, 
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Xiaoming Ni <nixiaoming@huawei.com>, 
	Yin Fengwei <fengwei.yin@intel.com>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org
Subject: Re: [RFC PATCH v19 0/5] Script execution control (was O_MAYEXEC)
Message-ID: <20240716.shaliZ2chohj@digikod.net>
References: <20240704190137.696169-1-mic@digikod.net>
 <55b4f6291e8d83d420c7d08f4233b3d304ce683d.camel@linux.ibm.com>
 <20240709.AhJ7oTh1biej@digikod.net>
 <9e3df65c2bf060b5833558e9f8d82dcd2fe9325a.camel@huaweicloud.com>
 <ee1ae815b6e75021709612181a6a4415fda543a4.camel@HansenPartnership.com>
 <E608EDB8-72E8-4791-AC9B-8FF9AC753FBE@sempervictus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <E608EDB8-72E8-4791-AC9B-8FF9AC753FBE@sempervictus.com>
X-Infomaniak-Routing: alpha

(adding back other people in Cc)

On Tue, Jul 16, 2024 at 01:29:43PM -0400, Boris Lukashev wrote:
> Wouldn't count those shell chickens - awk alone is enough and we can
> use ssh and openssl clients (all in metasploit public code). As one of
> the people who makes novel shell types, I can assure you that this
> effort is only going to slow skiddies and only until the rest of us
> publish mitigations for this mitigation :)

Security is not binary. :)

Not all Linux systems are equals. Some hardened systems need this kind
of feature and they can get guarantees because they fully control and
trust their executable binaries (e.g. CLIP OS, chromeOS) or they
properly sandbox them.  See context in the cover letter.

awk is a script interpreter that should be patched too, like other Linux
tools.

> 
> -Boris (RageLtMan)
> 
> On July 16, 2024 12:12:49 PM EDT, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> >On Tue, 2024-07-16 at 17:57 +0200, Roberto Sassu wrote:
> >> But the Clip OS 4 patch does not cover the redirection case:
> >> 
> >> # ./bash < /root/test.sh
> >> Hello World
> >> 
> >> Do you have a more recent patch for that?
> >
> >How far down the rabbit hole do you want to go?  You can't forbid a
> >shell from executing commands from stdin because logging in then won't
> >work.  It may be possible to allow from a tty backed file and not from
> >a file backed one, but you still have the problem of the attacker
> >manually typing in the script.
> >
> >The saving grace for this for shells is that they pretty much do
> >nothing on their own (unlike python) so you can still measure all the
> >executables they call out to, which provides reasonable safety.
> >
> >James
> >
