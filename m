Return-Path: <kernel-hardening-return-21823-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id F0481C3DA63
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jul 2024 13:15:49 +0000 (UTC)
Received: (qmail 5297 invoked by uid 550); 23 Jul 2024 13:15:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5277 invoked from network); 23 Jul 2024 13:15:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1721740524;
	bh=Qj8Xgm8rcMJSt8La6LY/BFSnfayKGlNJ2hnbPdsP+c4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HjieBgpROL8YzXywnxRaVs/lBhQC8sCG72MSmA1PAGizlICvD8PSvtDlMWicL9X1d
	 V6xSMy1NB4+7ISBIZb5R4Qb0Q/5r6uVtc04r+yNAtiVVgbQ5PNuDUeO/uAa8G6Yad2
	 AwO0Y79iGqgbZUsXUVSXoOuwFz3cBPmXaXbe6uxk=
Date: Tue, 23 Jul 2024 15:15:16 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Andy Lutomirski <luto@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Paul Moore <paul@paul-moore.com>, Theodore Ts'o <tytso@mit.edu>, 
	Alejandro Colomar <alx.manpages@gmail.com>, Aleksa Sarai <cyphar@cyphar.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, 
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
Message-ID: <20240723.Uquiangopie6@digikod.net>
References: <20240704190137.696169-1-mic@digikod.net>
 <20240704190137.696169-3-mic@digikod.net>
 <CALCETrWpk5Es9GPoAdDD=m_vgSePm=cA16zCor_aJV0EPXBw1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALCETrWpk5Es9GPoAdDD=m_vgSePm=cA16zCor_aJV0EPXBw1A@mail.gmail.com>
X-Infomaniak-Routing: alpha

On Sat, Jul 20, 2024 at 10:06:28AM +0800, Andy Lutomirski wrote:
> On Fri, Jul 5, 2024 at 3:02 AM Mickaël Salaün <mic@digikod.net> wrote:
> >
> > These new SECBIT_SHOULD_EXEC_CHECK, SECBIT_SHOULD_EXEC_RESTRICT, and
> > their *_LOCKED counterparts are designed to be set by processes setting
> > up an execution environment, such as a user session, a container, or a
> > security sandbox.  Like seccomp filters or Landlock domains, the
> > securebits are inherited across proceses.
> >
> > When SECBIT_SHOULD_EXEC_CHECK is set, programs interpreting code should
> > check executable resources with execveat(2) + AT_CHECK (see previous
> > patch).
> >
> > When SECBIT_SHOULD_EXEC_RESTRICT is set, a process should only allow
> > execution of approved resources, if any (see SECBIT_SHOULD_EXEC_CHECK).
> 
> I read this twice, slept on it, read them again, and I *still* can't
> understand it.  See below...

There is a new proposal:
https://lore.kernel.org/all/20240710.eiKohpa4Phai@digikod.net/
The new securebits will be SECBIT_EXEC_RESTRICT_FILE and
SECBIT_EXEC_DENY_INTERACTIVE.  I'll send a new patch series with that.

> 
> > The only restriction enforced by the kernel is the right to ptrace
> > another process.  Processes are denied to ptrace less restricted ones,
> > unless the tracer has CAP_SYS_PTRACE.  This is mainly a safeguard to
> > avoid trivial privilege escalations e.g., by a debugging process being
> > abused with a confused deputy attack.
> 
> What's the actual issue?  And why can't I, as root, do, in a carefully
> checked, CHECK'd and RESTRICT'd environment, # gdb -p <pid>?  Adding
> weird restrictions to ptrace can substantially *weaken* security
> because it forces people to do utterly daft things to work around the
> restrictions.

Restricting ptrace was a cautious approach, but I get you point and I
agree.  I'll remove the ptrace restrictions in the next patch series.

> 
> ...
> 
> > +/*
> > + * When SECBIT_SHOULD_EXEC_CHECK is set, a process should check all executable
> > + * files with execveat(2) + AT_CHECK.  However, such check should only be
> > + * performed if all to-be-executed code only comes from regular files.  For
> > + * instance, if a script interpreter is called with both a script snipped as
> 
> s/snipped/snippet/
> 
> > + * argument and a regular file, the interpreter should not check any file.
> > + * Doing otherwise would mislead the kernel to think that only the script file
> > + * is being executed, which could for instance lead to unexpected permission
> > + * change and break current use cases.
> 
> This is IMO not nearly clear enough to result in multiple user
> implementations and a kernel implementation and multiple LSM
> implementations and LSM policy authors actually agreeing as to what
> this means.

Right, no kernel parts (e.g. LSMs) should try to infer anything other
than an executability check.  We should handle things such as role
transitions with something else (e.g. a complementary dedicated flag),
and that should be decorrelated from this patch series.

> 
> I also think it's wrong to give user code instructions about what
> kernel checks it should do.  Have the user code call the kernel and
> have the kernel implement the policy.

Call the kernel for what?  Script interpreter is a user space thing, and
restrictions enforced on interpreters need to be a user space thing.
The kernel cannot restrict user space according to a semantic only
defined by user space, such as Python interpretation, CLI arguments,
content of environment variables...  If a process wants to interpret
some data and turn than into code, there is no way for the kernel to
know about that.

> 
> > +/*
> > + * When SECBIT_SHOULD_EXEC_RESTRICT is set, a process should only allow
> > + * execution of approved files, if any (see SECBIT_SHOULD_EXEC_CHECK).  For
> > + * instance, script interpreters called with a script snippet as argument
> > + * should always deny such execution if SECBIT_SHOULD_EXEC_RESTRICT is set.
> > + * However, if a script interpreter is called with both
> > + * SECBIT_SHOULD_EXEC_CHECK and SECBIT_SHOULD_EXEC_RESTRICT, they should
> > + * interpret the provided script files if no unchecked code is also provided
> > + * (e.g. directly as argument).
> 
> I think you're trying to say that this is like (the inverse of)
> Content-Security-Policy: unsafe-inline.  In other words, you're saying
> that, if RESTRICT is set, then programs should not execute code-like
> text that didn't come from a file.  Is that right?

That is the definition of the new SECBIT_EXEC_DENY_INTERACTIVE, which
should be clearer.

> 
> I feel like it would be worth looking at the state of the art of
> Content-Security-Policy and all the lessons people have learned from
> it.  Whatever the result is should be at least as comprehensible and
> at least as carefully engineered as Content-Security-Policy.

That's a good idea, but I guess Content-Security-Policy cannot be
directly applied here.  My understanding is that CSP enables web servers
to request restrictions on code they provide.  In the
AT_CHECK+securebits case, the policy is defined and enforced by the
interpreter, not necessarily the script provider. One big difference is
that web servers (should) know the scripts they provide, and can then
request the browser to ensure that they do what they should do, while
the script interpreter trusts the kernel to check security properties of
a script.  In other words, something like CSP could be implemented with
AT_CHECK+securebits and a LSM policy (e.g. according to file's xattr).

> 
> --Andy
