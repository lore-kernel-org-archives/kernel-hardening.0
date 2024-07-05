Return-Path: <kernel-hardening-return-21737-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 19F87C3271E
	for <kernel-hardening@archiver.kernel.org>; Fri,  5 Jul 2024 17:54:41 +0000 (UTC)
Received: (qmail 28115 invoked by uid 550); 5 Jul 2024 17:54:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28095 invoked from network); 5 Jul 2024 17:54:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1720202061;
	bh=6nsQl2eLVsfJqAkYOl2Q8wRXDEXx0pOL2pfLfb7tTMo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Uz05dbe7Ob59tAGgoZ5Yjo6Tz5LISGDzXwJzQQmXaIWdnEEvfxibNtD4yptwf9qtz
	 X9SeQWL6U73YIqYx3mjObKAoBQuXFpzZjr3gTfhRYFoNFE5KMnq/nLAcU71rq1XGkq
	 ZFDlzrBMjaVD+zLeDHPNyvdSB5mHYY5rp1r7ybT0=
Date: Fri, 5 Jul 2024 19:54:16 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Kees Cook <kees@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
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
	Miklos Szeredi <mszeredi@redhat.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>, Scott Shell <scottsh@microsoft.com>, 
	Shuah Khan <shuah@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, 
	Steve Dower <steve.dower@python.org>, Steve Grubb <sgrubb@redhat.com>, 
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, Vincent Strubel <vincent.strubel@ssi.gouv.fr>, 
	Xiaoming Ni <nixiaoming@huawei.com>, Yin Fengwei <fengwei.yin@intel.com>, 
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org
Subject: Re: [RFC PATCH v19 2/5] security: Add new SHOULD_EXEC_CHECK and
 SHOULD_EXEC_RESTRICT securebits
Message-ID: <20240705.IeTheequ7Ooj@digikod.net>
References: <20240704190137.696169-1-mic@digikod.net>
 <20240704190137.696169-3-mic@digikod.net>
 <202407041711.B7CD16B2@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <202407041711.B7CD16B2@keescook>
X-Infomaniak-Routing: alpha

On Thu, Jul 04, 2024 at 05:18:04PM -0700, Kees Cook wrote:
> On Thu, Jul 04, 2024 at 09:01:34PM +0200, Mickaël Salaün wrote:
> > Such a secure environment can be achieved with an appropriate access
> > control policy (e.g. mount's noexec option, file access rights, LSM
> > configuration) and an enlighten ld.so checking that libraries are
> > allowed for execution e.g., to protect against illegitimate use of
> > LD_PRELOAD.
> > 
> > Scripts may need some changes to deal with untrusted data (e.g. stdin,
> > environment variables), but that is outside the scope of the kernel.
> 
> If the threat model includes an attacker sitting at a shell prompt, we
> need to be very careful about how process perform enforcement. E.g. even
> on a locked down system, if an attacker has access to LD_PRELOAD or a

LD_PRELOAD should be OK once ld.so will be patched to check the
libraries.  We can still imagine a debug library used to bypass security
checks, but in this case the issue would be that this library is
executable in the first place.

> seccomp wrapper (which you both mention here), it would be possible to
> run commands where the resulting process is tricked into thinking it
> doesn't have the bits set.

As explained in the UAPI comments, all parent processes need to be
trusted.  This meeans that their code is trusted, their seccomp filters
are trusted, and that they are patched, if needed, to check file
executability.

> 
> But this would be exactly true for calling execveat(): LD_PRELOAD or
> seccomp policy could have it just return 0.

If an attacker is allowed/able to load an arbitrary seccomp filter on a
process, we cannot trust this process.

> 
> While I like AT_CHECK, I do wonder if it's better to do the checks via
> open(), as was originally designed with O_MAYEXEC. Because then
> enforcement is gated by the kernel -- the process does not get a file
> descriptor _at all_, no matter what LD_PRELOAD or seccomp tricks it into
> doing.

Being able to check a path name or a file descriptor (with the same
syscall) is more flexible and cover more use cases.  The execveat(2)
interface, including current and future flags, is dedicated to file
execution.  I then think that using execveat(2) for this kind of check
makes more sense, and will easily evolve with this syscall.

> 
> And this thinking also applies to faccessat() too: if a process can be
> tricked into thinking the access check passed, it'll happily interpret
> whatever. :( But not being able to open the fd _at all_ when O_MAYEXEC
> is being checked seems substantially safer to me...

If attackers can filter execveat(2), they can also filter open(2) and
any other syscalls.  In all cases, that would mean an issue in the
security policy.
