Return-Path: <kernel-hardening-return-21785-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 3FDA8C3DA49
	for <kernel-hardening@archiver.kernel.org>; Tue, 16 Jul 2024 15:15:58 +0000 (UTC)
Received: (qmail 30110 invoked by uid 550); 16 Jul 2024 15:15:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30081 invoked from network); 16 Jul 2024 15:15:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1721142935;
	bh=n0Yyov6793OgT9UdlDqw0KaNB/lL9GCWiAZax8WYA8Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=xNKcZO2jTScaIsHJJ9zP+OUxUwTBkPrcBA1yOc1q+QKNt+FHN/k4cg67/GrzLLdJi
	 imfD9u0LbeCeE3RQsj4zkCXY8TWGoinZMOzqifRdvWlYs/h6Vg/BDKB+K2iD/f4mWS
	 fmkY/ksgCatUJ/DslEjxtcF/8/FKyo6Kcl12Spmc=
Date: Tue, 16 Jul 2024 17:15:28 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Jeff Xu <jeffxu@google.com>
Cc: Kees Cook <kees@kernel.org>, Steve Dower <steve.dower@python.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Paul Moore <paul@paul-moore.com>, Theodore Ts'o <tytso@mit.edu>, 
	Alejandro Colomar <alx@kernel.org>, Aleksa Sarai <cyphar@cyphar.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Casey Schaufler <casey@schaufler-ca.com>, Christian Heimes <christian@python.org>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Biggers <ebiggers@kernel.org>, 
	Eric Chiang <ericchiang@google.com>, Fan Wu <wufan@linux.microsoft.com>, 
	Florian Weimer <fweimer@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	James Morris <jamorris@linux.microsoft.com>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Jordan R Abrahams <ajordanr@google.com>, 
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, Luca Boccassi <bluca@debian.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>, 
	Matt Bobrowski <mattbobrowski@google.com>, Matthew Garrett <mjg59@srcf.ucam.org>, 
	Matthew Wilcox <willy@infradead.org>, Miklos Szeredi <mszeredi@redhat.com>, 
	Mimi Zohar <zohar@linux.ibm.com>, Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>, 
	Scott Shell <scottsh@microsoft.com>, Shuah Khan <shuah@kernel.org>, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Steve Grubb <sgrubb@redhat.com>, 
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, Vincent Strubel <vincent.strubel@ssi.gouv.fr>, 
	Xiaoming Ni <nixiaoming@huawei.com>, Yin Fengwei <fengwei.yin@intel.com>, 
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org
Subject: Re: [RFC PATCH v19 2/5] security: Add new SHOULD_EXEC_CHECK and
 SHOULD_EXEC_RESTRICT securebits
Message-ID: <20240716.Zah8Phaiphae@digikod.net>
References: <20240708.quoe8aeSaeRi@digikod.net>
 <CALmYWFuVJiRZgB0ye9eR95dvBOigoOVShgS9i_ESjEre-H5pLA@mail.gmail.com>
 <ef3281ad-48a5-4316-b433-af285806540d@python.org>
 <CALmYWFuFE=V7sGp0_K+2Vuk6F0chzhJY88CP1CAE9jtd=rqcoQ@mail.gmail.com>
 <20240709.aech3geeMoh0@digikod.net>
 <CALmYWFuOXAiT05Pi2rZ1nUAKDGe9JyTH7fro2EYS1fh3zeGV5Q@mail.gmail.com>
 <20240710.eiKohpa4Phai@digikod.net>
 <202407100921.687BE1A6@keescook>
 <20240711.sequuGhee0th@digikod.net>
 <CALmYWFt7X0v8k1N9=aX6BuT2gCiC9SeWwPEBckvBk8GQtb0rqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALmYWFt7X0v8k1N9=aX6BuT2gCiC9SeWwPEBckvBk8GQtb0rqQ@mail.gmail.com>
X-Infomaniak-Routing: alpha

On Tue, Jul 16, 2024 at 08:02:37AM -0700, Jeff Xu wrote:
> On Thu, Jul 11, 2024 at 1:57 AM Mickaël Salaün <mic@digikod.net> wrote:
> >
> > On Wed, Jul 10, 2024 at 09:26:14AM -0700, Kees Cook wrote:
> > > On Wed, Jul 10, 2024 at 11:58:25AM +0200, Mickaël Salaün wrote:
> > > > Here is another proposal:
> > > >
> > > > We can change a bit the semantic by making it the norm to always check
> > > > file executability with AT_CHECK, and using the securebits to restrict
> > > > file interpretation and/or command injection (e.g. user supplied shell
> > > > commands).  Non-executable checked files can be reported/logged at the
> > > > kernel level, with audit, configured by sysadmins.
> > > >
> > > > New securebits (feel free to propose better names):
> > > >
> > > > - SECBIT_EXEC_RESTRICT_FILE: requires AT_CHECK to pass.
> > >
> > > Would you want the enforcement of this bit done by userspace or the
> > > kernel?
> > >
> > > IIUC, userspace would always perform AT_CHECK regardless of
> > > SECBIT_EXEC_RESTRICT_FILE, and then which would happen?
> > >
> > > 1) userspace would ignore errors from AT_CHECK when
> > >    SECBIT_EXEC_RESTRICT_FILE is unset
> >
> > Yes, that's the idea.
> >
> > >
> > > or
> > >
> > > 2) kernel would allow all AT_CHECK when SECBIT_EXEC_RESTRICT_FILE is
> > >    unset
> > >
> > > I suspect 1 is best and what you intend, given that
> > > SECBIT_EXEC_DENY_INTERACTIVE can only be enforced by userspace.
> >
> > Indeed. We don't want AT_CHECK's behavior to change according to
> > securebits.
> >
> One bit is good.
> 
> > >
> > > > - SECBIT_EXEC_DENY_INTERACTIVE: deny any command injection via
> > > >   command line arguments, environment variables, or configuration files.
> > > >   This should be ignored by dynamic linkers.  We could also have an
> > > >   allow-list of shells for which this bit is not set, managed by an
> > > >   LSM's policy, if the native securebits scoping approach is not enough.
> > > >
> > > > Different modes for script interpreters:
> > > >
> > > > 1. RESTRICT_FILE=0 DENY_INTERACTIVE=0 (default)
> > > >    Always interpret scripts, and allow arbitrary user commands.
> > > >    => No threat, everyone and everything is trusted, but we can get
> > > >    ahead of potential issues with logs to prepare for a migration to a
> > > >    restrictive mode.
> > > >
> > > > 2. RESTRICT_FILE=1 DENY_INTERACTIVE=0
> > > >    Deny script interpretation if they are not executable, and allow
> > > >    arbitrary user commands.
> > > >    => Threat: (potential) malicious scripts run by trusted (and not
> > > >       fooled) users.  That could protect against unintended script
> > > >       executions (e.g. sh /tmp/*.sh).
> > > >    ==> Makes sense for (semi-restricted) user sessions.
> > > >
> > > > 3. RESTRICT_FILE=1 DENY_INTERACTIVE=1
> > > >    Deny script interpretation if they are not executable, and also deny
> > > >    any arbitrary user commands.
> > > >    => Threat: malicious scripts run by untrusted users.
> > > >    ==> Makes sense for system services executing scripts.
> > > >
> > > > 4. RESTRICT_FILE=0 DENY_INTERACTIVE=1
> > > >    Always interpret scripts, but deny arbitrary user commands.
> > > >    => Goal: monitor/measure/assess script content (e.g. with IMA/EVM) in
> > > >       a system where the access rights are not (yet) ready.  Arbitrary
> > > >       user commands would be much more difficult to monitor.
> > > >    ==> First step of restricting system services that should not
> > > >        directly pass arbitrary commands to shells.
> > >
> > > I like these bits!
> >
> > Good! Jeff, Steve, Florian, Matt, others, what do you think?
> 
> For below two cases: will they be restricted by one (or some) mode above ?
> 
> 1> cat /tmp/a.sh | sh
> 
> 2> sh -c "$(cat /tmp/a.sh)"

Yes, DENY_INTERACTIVE=1 is to deny both of these cases (i.e. arbitrary
user command).

These other examples should be allowed with AT_CHECK and RESTRICT_FILE=1
if a.sh is executable though:
* sh /tmp/a.sh
* sh < /tmp/a.sh
