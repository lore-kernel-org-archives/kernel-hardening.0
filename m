Return-Path: <kernel-hardening-return-21761-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id E80A3C3271E
	for <kernel-hardening@archiver.kernel.org>; Mon,  8 Jul 2024 19:38:45 +0000 (UTC)
Received: (qmail 31873 invoked by uid 550); 8 Jul 2024 19:38:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 31765 invoked from network); 8 Jul 2024 19:38:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720467500;
	bh=e5oHiwwZ0DY7Dmv393o9ZUxAt+dMtNFWFPwbkMtnVJQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Jfb5YOAvhFAWSlZd9EaSBneZ/YcVipzNxWs4j8tWUSij/ubtl3hRK2uYE+qVesZk8
	 L+ZMtxuh+PC5igYpPTqAUN1mef7sfB2u6n/PWF0O8s3cbQmc0OxIs49tnpe/fdX6Q7
	 P/yKUh0CNat8czIKYGHk/p/ioGlbNn8Dn4gMc15PHkuUQ/VC2/GkSGooGnAXzMVgpb
	 2rkWcXcpWR3oZIR4MGr5SJPDPwtdVVOLu+uft6AMPYOl0CGNmO0vg1F2Q9Kc/xWLCB
	 REf//u5kAPiLeRho9Yfk8b8TcVfRACOr0RIAzQibnvhTJ03AjzgTNn2CDd9k86IOj2
	 5XOChLcu7orZQ==
Date: Mon, 8 Jul 2024 12:38:19 -0700
From: Kees Cook <kees@kernel.org>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Paul Moore <paul@paul-moore.com>, Theodore Ts'o <tytso@mit.edu>,
	Alejandro Colomar <alx@kernel.org>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Christian Heimes <christian@python.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Eric Chiang <ericchiang@google.com>,
	Fan Wu <wufan@linux.microsoft.com>,
	Florian Weimer <fweimer@redhat.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	James Morris <jamorris@linux.microsoft.com>,
	Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>,
	Jeff Xu <jeffxu@google.com>, Jonathan Corbet <corbet@lwn.net>,
	Jordan R Abrahams <ajordanr@google.com>,
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
	Luca Boccassi <bluca@debian.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Matthew Wilcox <willy@infradead.org>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>,
	Scott Shell <scottsh@microsoft.com>, Shuah Khan <shuah@kernel.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Steve Dower <steve.dower@python.org>,
	Steve Grubb <sgrubb@redhat.com>,
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	Xiaoming Ni <nixiaoming@huawei.com>,
	Yin Fengwei <fengwei.yin@intel.com>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [RFC PATCH v19 1/5] exec: Add a new AT_CHECK flag to execveat(2)
Message-ID: <202407081237.42C50C2F7@keescook>
References: <20240704190137.696169-1-mic@digikod.net>
 <20240704190137.696169-2-mic@digikod.net>
 <202407041656.3A05153@keescook>
 <20240705.uch1saeNi6mo@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240705.uch1saeNi6mo@digikod.net>

On Fri, Jul 05, 2024 at 07:53:10PM +0200, Mickaël Salaün wrote:
> On Thu, Jul 04, 2024 at 05:04:03PM -0700, Kees Cook wrote:
> > On Thu, Jul 04, 2024 at 09:01:33PM +0200, Mickaël Salaün wrote:
> > > Add a new AT_CHECK flag to execveat(2) to check if a file would be
> > > allowed for execution.  The main use case is for script interpreters and
> > > dynamic linkers to check execution permission according to the kernel's
> > > security policy. Another use case is to add context to access logs e.g.,
> > > which script (instead of interpreter) accessed a file.  As any
> > > executable code, scripts could also use this check [1].
> > > 
> > > This is different than faccessat(2) which only checks file access
> > > rights, but not the full context e.g. mount point's noexec, stack limit,
> > > and all potential LSM extra checks (e.g. argv, envp, credentials).
> > > Since the use of AT_CHECK follows the exact kernel semantic as for a
> > > real execution, user space gets the same error codes.
> > 
> > Nice! I much prefer this method of going through the exec machinery so
> > we always have a single code path for these kinds of checks.
> > 
> > > Because AT_CHECK is dedicated to user space interpreters, it doesn't
> > > make sense for the kernel to parse the checked files, look for
> > > interpreters known to the kernel (e.g. ELF, shebang), and return ENOEXEC
> > > if the format is unknown.  Because of that, security_bprm_check() is
> > > never called when AT_CHECK is used.
> > 
> > I'd like some additional comments in the code that reminds us that
> > access control checks have finished past a certain point.
> 
> Where in the code? Just before the bprm->is_check assignment?

Yeah, that's what I was thinking.

-- 
Kees Cook
