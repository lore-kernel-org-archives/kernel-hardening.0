Return-Path: <kernel-hardening-return-21767-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id F333EC3DA41
	for <kernel-hardening@archiver.kernel.org>; Tue,  9 Jul 2024 09:18:37 +0000 (UTC)
Received: (qmail 23936 invoked by uid 550); 9 Jul 2024 09:18:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23913 invoked from network); 9 Jul 2024 09:18:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1720516695;
	bh=v/JFEHCX3gZ0MVpHje3ikJ9/D0FTAcZwjQbECtZLdZE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZTiHpEnfNR3mlatCxWux7y7Eu0qGDnEqSh+8W8s09JC/3VLLlbrWZwmN1jeWX5Vho
	 ndmFxLkDKg4N0dPsk7JixdJH7Olf3q4BBy/rLZ/oO3L8jaUA2xpIdzwOIgKnGlTAP3
	 N7+HAeqyif99g6G9CBVvsU6dg8SkNZKc9yNMrgvw=
Date: Tue, 9 Jul 2024 11:18:00 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Jeff Xu <jeffxu@google.com>
Cc: Florian Weimer <fweimer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Paul Moore <paul@paul-moore.com>, Theodore Ts'o <tytso@mit.edu>, 
	Alejandro Colomar <alx@kernel.org>, Aleksa Sarai <cyphar@cyphar.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Casey Schaufler <casey@schaufler-ca.com>, Christian Heimes <christian@python.org>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Biggers <ebiggers@kernel.org>, 
	Eric Chiang <ericchiang@google.com>, Fan Wu <wufan@linux.microsoft.com>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, James Morris <jamorris@linux.microsoft.com>, 
	Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, 
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
Subject: Re: [RFC PATCH v19 1/5] exec: Add a new AT_CHECK flag to execveat(2)
Message-ID: <20240709.gae4cu4Aiv6s@digikod.net>
References: <20240704190137.696169-1-mic@digikod.net>
 <20240704190137.696169-2-mic@digikod.net>
 <87bk3bvhr1.fsf@oldenburg.str.redhat.com>
 <CALmYWFu_JFyuwYhDtEDWxEob8JHFSoyx_SCcsRVKqSYyyw30Rg@mail.gmail.com>
 <87ed83etpk.fsf@oldenburg.str.redhat.com>
 <CALmYWFvkUnevm=npBeaZVkK_PXm=A8MjgxFXkASnERxoMyhYBg@mail.gmail.com>
 <87r0c3dc1c.fsf@oldenburg.str.redhat.com>
 <CALmYWFvA7VPz06Tg8E-R_Jqn2cxMiWPPC6Vhy+vgqnofT0GELg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALmYWFvA7VPz06Tg8E-R_Jqn2cxMiWPPC6Vhy+vgqnofT0GELg@mail.gmail.com>
X-Infomaniak-Routing: alpha

On Mon, Jul 08, 2024 at 10:52:36AM -0700, Jeff Xu wrote:
> On Mon, Jul 8, 2024 at 10:33 AM Florian Weimer <fweimer@redhat.com> wrote:
> >
> > * Jeff Xu:
> >
> > > On Mon, Jul 8, 2024 at 9:26 AM Florian Weimer <fweimer@redhat.com> wrote:
> > >>
> > >> * Jeff Xu:
> > >>
> > >> > Will dynamic linkers use the execveat(AT_CHECK) to check shared
> > >> > libraries too ?  or just the main executable itself.
> > >>
> > >> I expect that dynamic linkers will have to do this for everything they
> > >> map.
> > > Then all the objects (.so, .sh, etc.) will go through  the check from
> > > execveat's main  to security_bprm_creds_for_exec(), some of them might
> > > be specific for the main executable ?

Yes, we should check every executable code (including seccomp filters)
to get a consistent policy.

What do you mean by "specific for the main executable"?

> >
> > If we want to avoid that, we could have an agreed-upon error code which
> > the LSM can signal that it'll never fail AT_CHECK checks, so we only
> > have to perform the extra system call once.

I'm not sure to follow.  Either we check executable code or we don't,
but it doesn't make sense to only check some parts (except for migration
of user space code in a system, which is one purpose of the securebits
added with the next patch).

The idea with AT_CHECK is to unconditionnaly check executable right the
same way it is checked when a file is executed.  User space can decide
to check that or not according to its policy (i.e. securebits).

> >
> Right, something like that.
> I would prefer not having AT_CHECK specific code in LSM code as an
> initial goal, if that works, great.

LSMs should not need to change anything, but they are free to implement
new access right according to AT_CHECK.

> 
> -Jeff
> 
> > Thanks,
> > Florian
> >
