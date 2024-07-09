Return-Path: <kernel-hardening-return-21774-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id F3007C2BD09
	for <kernel-hardening@archiver.kernel.org>; Tue,  9 Jul 2024 20:43:35 +0000 (UTC)
Received: (qmail 2027 invoked by uid 550); 9 Jul 2024 20:43:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 2001 invoked from network); 9 Jul 2024 20:43:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1720557793;
	bh=DY4ON4k53sWhYGXcmX6VPO/UCUA4DRMBJPJ0GnvYcrk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZqRVY2T000kk3VOhlxPReWQIchX7FYTF2wQp4BjX3GAwTn0fhrcoaVg+CigqAOSaD
	 D8aAZvc2WCTOi8EjqQ6s3J3db5HeeRCYYE2W2kAddPCPXeBiQ66hhn14p6fJms5Ayp
	 VX+6dJPd1KiM5p1EE1AXfQ/D2U7LKMPctgbEShYA=
Date: Tue, 9 Jul 2024 22:43:09 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Mimi Zohar <zohar@linux.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Paul Moore <paul@paul-moore.com>, Theodore Ts'o <tytso@mit.edu>, 
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
Message-ID: <20240709.AhJ7oTh1biej@digikod.net>
References: <20240704190137.696169-1-mic@digikod.net>
 <55b4f6291e8d83d420c7d08f4233b3d304ce683d.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <55b4f6291e8d83d420c7d08f4233b3d304ce683d.camel@linux.ibm.com>
X-Infomaniak-Routing: alpha

On Mon, Jul 08, 2024 at 04:35:38PM -0400, Mimi Zohar wrote:
> Hi Mickaël,
> 
> On Thu, 2024-07-04 at 21:01 +0200, Mickaël Salaün wrote:
> > Hi,
> > 
> > The ultimate goal of this patch series is to be able to ensure that
> > direct file execution (e.g. ./script.sh) and indirect file execution
> > (e.g. sh script.sh) lead to the same result, especially from a security
> > point of view.
> > 
> > Overview
> > --------
> > 
> > This patch series is a new approach of the initial O_MAYEXEC feature,
> > and a revamp of the previous patch series.  Taking into account the last
> > reviews [1], we now stick to the kernel semantic for file executability.
> > One major change is the clear split between access check and policy
> > management.
> > 
> > The first patch brings the AT_CHECK flag to execveat(2).  The goal is to
> > enable user space to check if a file could be executed (by the kernel).
> > Unlike stat(2) that only checks file permissions, execveat2(2) +
> > AT_CHECK take into account the full context, including mount points
> > (noexec), caller's limits, and all potential LSM extra checks (e.g.
> > argv, envp, credentials).
> > 
> > The second patch brings two new securebits used to set or get a security
> > policy for a set of processes.  For this to be meaningful, all
> > executable code needs to be trusted.  In practice, this means that
> > (malicious) users can be restricted to only run scripts provided (and
> > trusted) by the system.
> > 
> > [1] https://lore.kernel.org/r/CAHk-=wjPGNLyzeBMWdQu+kUdQLHQugznwY7CvWjmvNW47D5sog@mail.gmail.com
> > 
> > Script execution
> > ----------------
> > 
> > One important thing to keep in mind is that the goal of this patch
> > series is to get the same security restrictions with these commands:
> > * ./script.py
> > * python script.py
> > * python < script.py
> > * python -m script.pyT
> 
> This is really needed, but is it the "only" purpose of this patch set or can it
> be used to also monitor files the script opens (for read) with the intention of
> executing.

This feature can indeed also be used to monitor files requested by
scripts to be executed e.g. using
https://docs.python.org/3/library/io.html#io.open_code

IMA/EVM can include this check in its logs.

> 
> > 
> > However, on secure systems, we should be able to forbid these commands
> > because there is no way to reliably identify the origin of the script:
> > * xargs -a script.py -d '\r' -- python -c
> > * cat script.py | python
> > * python
> > 
> > Background
> > ----------
> > 
> > Compared to the previous patch series, there is no more dedicated
> > syscall nor sysctl configuration.  This new patch series only add new
> > flags: one for execveat(2) and four for prctl(2).
> > 
> > This kind of script interpreter restriction may already be used in
> > hardened systems, which may need to fork interpreters and install
> > different versions of the binaries.  This mechanism should enable to
> > avoid the use of duplicate binaries (and potential forked source code)
> > for secure interpreters (e.g. secure Python [2]) by making it possible
> > to dynamically enforce restrictions or not.
> > 
> > The ability to control script execution is also required to close a
> > major IMA measurement/appraisal interpreter integrity [3].
> 
> Definitely.  But it isn't limited to controlling script execution, but also
> measuring the script.  Will it be possible to measure and appraise the indirect
> script calls with this patch set?

Yes. You should only need to implement security_bprm_creds_for_exec()
for IMA/EVM.

BTW, I noticed that IMA only uses the security_bprm_check() hook (which
can be called several times for one execve), but
security_bprm_creds_for_exec() might be more appropriate.

> 
> Mimi
> 
> > This new execveat + AT_CHECK should not be confused with the O_EXEC flag
> > (for open) which is intended for execute-only, which obviously doesn't
> > work for scripts.
> > 
> > I gave a talk about controlling script execution where I explain the
> > previous approaches [4].  The design of the WIP RFC I talked about
> > changed quite a bit since then.
> > 
> > [2] https://github.com/zooba/spython
> > [3] https://lore.kernel.org/lkml/20211014130125.6991-1-zohar@linux.ibm.com/
> > [4] https://lssna2023.sched.com/event/1K7bO
> > 
> 
> 
