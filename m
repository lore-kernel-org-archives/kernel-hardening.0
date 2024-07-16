Return-Path: <kernel-hardening-return-21783-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 196DAC3DA49
	for <kernel-hardening@archiver.kernel.org>; Tue, 16 Jul 2024 15:03:41 +0000 (UTC)
Received: (qmail 32444 invoked by uid 550); 16 Jul 2024 15:03:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32421 invoked from network); 16 Jul 2024 15:03:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721142197; x=1721746997; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MQXyGuZsqmv7+37GKhT1A2NCIQ7jfA+IZBk14phBRDQ=;
        b=r6+nX7cdOvJjc4FOJJKbfDDJ/q2mmrm7ltZ0Go9TfF3kg/xihEMxf0pNLeobK10OMP
         3RWFktAqAX8mW50TLnvpw6jwqMwV1qz/OodbVyJ0JMpb+qt/XOZRZlTobEm/yYmIiX98
         tR9E45JFWf0eBCqMH5bp4O67boJaYwRZwUTFayrJqM3cCJgmuovC+Wm9LXhgxbOj9zxA
         kWM/12KyUCUlN1i5L86QGFpIef2ZmpzY4HIVdBIa+lLCrBQrHYxJw3R47RSbzwIHw2NV
         vNCqezoEm40/YsoWIObhNluAMFzqnWI25l2AL3MuyWrk79BFjn/SlOEEFo0eHdZMNsFr
         /qqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721142197; x=1721746997;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MQXyGuZsqmv7+37GKhT1A2NCIQ7jfA+IZBk14phBRDQ=;
        b=OzNssthDcmcc5KT2ry7I9lavzZ2crwQYpVt7navOk7JuGAuR8ivo9GLugnBixIEhm2
         UiSgUkUQ/bVrOo1YDJZlxi27pH5ouTGuSfsclxtwW3TNgQx6WJbz78T6wvMAL5hvcegI
         iMdWHMAFkxOdFvSpPM33Fb3FDHtZCrNq3qFMfjaBPtaHtvpaHfU/BaSbZXWWoUzsVHx8
         at2Wn6PRJKngbPtigvY81NHBWWJQOtMvOVh6YJUV3JYBZwQqZeN2JD8UyARZYpT3j7jM
         cUva+BSDIvupkB0v7xbiduZ2W3WviXTbr8frmLkSKdxLESc8WEPP0HpJXbOEMPk1rHSZ
         szxw==
X-Forwarded-Encrypted: i=1; AJvYcCWwMY5yB8CbrtwRcbmZsZuq19FSKurXiNKLwz7JfulrSsRzL96lXahiqPqQyHcgGLUc9ODALCku+kbxHSVgfYQq5KsvnABm4Fs+zdZj9HFqYcvA2A==
X-Gm-Message-State: AOJu0YzkFgmKbD4m9SRPtAzdUZV38d54fDVoS+Pa/VMumt8MMzU44KMT
	3qC+10LUIUm4l9oG5lalwbHh0VgGboD8Pv8lvGHXvV0VHGTvLD8glJ5GxgEpcbohR65BvqoRQvu
	GNOJGN73ThrE3kFatKcsGAe6w5vF0Yq+qq+4Y
X-Google-Smtp-Source: AGHT+IGAbpbbKqsLUGXh464cytP863iXT7qQnuBJhBT38qhaCF0Grsul4hxlGXsYzxPX+jxvJ5qXz6HHJ6C646I/Z5I=
X-Received: by 2002:a05:6402:4304:b0:57c:bb0d:5e48 with SMTP id
 4fb4d7f45d1cf-59ec5417830mr368292a12.2.1721142196804; Tue, 16 Jul 2024
 08:03:16 -0700 (PDT)
MIME-Version: 1.0
References: <CALmYWFscz5W6xSXD-+dimzbj=TykNJEDa0m5gvBx93N-J+3nKA@mail.gmail.com>
 <CALmYWFsLUhkU5u1NKH8XWvSxbFKFOEq+A_eqLeDsN29xOEAYgg@mail.gmail.com>
 <20240708.quoe8aeSaeRi@digikod.net> <CALmYWFuVJiRZgB0ye9eR95dvBOigoOVShgS9i_ESjEre-H5pLA@mail.gmail.com>
 <ef3281ad-48a5-4316-b433-af285806540d@python.org> <CALmYWFuFE=V7sGp0_K+2Vuk6F0chzhJY88CP1CAE9jtd=rqcoQ@mail.gmail.com>
 <20240709.aech3geeMoh0@digikod.net> <CALmYWFuOXAiT05Pi2rZ1nUAKDGe9JyTH7fro2EYS1fh3zeGV5Q@mail.gmail.com>
 <20240710.eiKohpa4Phai@digikod.net> <202407100921.687BE1A6@keescook> <20240711.sequuGhee0th@digikod.net>
In-Reply-To: <20240711.sequuGhee0th@digikod.net>
From: Jeff Xu <jeffxu@google.com>
Date: Tue, 16 Jul 2024 08:02:37 -0700
Message-ID: <CALmYWFt7X0v8k1N9=aX6BuT2gCiC9SeWwPEBckvBk8GQtb0rqQ@mail.gmail.com>
Subject: Re: [RFC PATCH v19 2/5] security: Add new SHOULD_EXEC_CHECK and
 SHOULD_EXEC_RESTRICT securebits
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: Kees Cook <kees@kernel.org>, Steve Dower <steve.dower@python.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Paul Moore <paul@paul-moore.com>, 
	"Theodore Ts'o" <tytso@mit.edu>, Alejandro Colomar <alx@kernel.org>, Aleksa Sarai <cyphar@cyphar.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, 
	Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, 
	Christian Heimes <christian@python.org>, Dmitry Vyukov <dvyukov@google.com>, 
	Eric Biggers <ebiggers@kernel.org>, Eric Chiang <ericchiang@google.com>, 
	Fan Wu <wufan@linux.microsoft.com>, Florian Weimer <fweimer@redhat.com>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, James Morris <jamorris@linux.microsoft.com>, 
	Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	Jordan R Abrahams <ajordanr@google.com>, Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, 
	Luca Boccassi <bluca@debian.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>, Matt Bobrowski <mattbobrowski@google.com>, 
	Matthew Garrett <mjg59@srcf.ucam.org>, Matthew Wilcox <willy@infradead.org>, 
	Miklos Szeredi <mszeredi@redhat.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>, Scott Shell <scottsh@microsoft.com>, 
	Shuah Khan <shuah@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, Steve Grubb <sgrubb@redhat.com>, 
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, 
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Xiaoming Ni <nixiaoming@huawei.com>, 
	Yin Fengwei <fengwei.yin@intel.com>, kernel-hardening@lists.openwall.com, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 11, 2024 at 1:57=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <mic@digik=
od.net> wrote:
>
> On Wed, Jul 10, 2024 at 09:26:14AM -0700, Kees Cook wrote:
> > On Wed, Jul 10, 2024 at 11:58:25AM +0200, Micka=C3=ABl Sala=C3=BCn wrot=
e:
> > > Here is another proposal:
> > >
> > > We can change a bit the semantic by making it the norm to always chec=
k
> > > file executability with AT_CHECK, and using the securebits to restric=
t
> > > file interpretation and/or command injection (e.g. user supplied shel=
l
> > > commands).  Non-executable checked files can be reported/logged at th=
e
> > > kernel level, with audit, configured by sysadmins.
> > >
> > > New securebits (feel free to propose better names):
> > >
> > > - SECBIT_EXEC_RESTRICT_FILE: requires AT_CHECK to pass.
> >
> > Would you want the enforcement of this bit done by userspace or the
> > kernel?
> >
> > IIUC, userspace would always perform AT_CHECK regardless of
> > SECBIT_EXEC_RESTRICT_FILE, and then which would happen?
> >
> > 1) userspace would ignore errors from AT_CHECK when
> >    SECBIT_EXEC_RESTRICT_FILE is unset
>
> Yes, that's the idea.
>
> >
> > or
> >
> > 2) kernel would allow all AT_CHECK when SECBIT_EXEC_RESTRICT_FILE is
> >    unset
> >
> > I suspect 1 is best and what you intend, given that
> > SECBIT_EXEC_DENY_INTERACTIVE can only be enforced by userspace.
>
> Indeed. We don't want AT_CHECK's behavior to change according to
> securebits.
>
One bit is good.

> >
> > > - SECBIT_EXEC_DENY_INTERACTIVE: deny any command injection via
> > >   command line arguments, environment variables, or configuration fil=
es.
> > >   This should be ignored by dynamic linkers.  We could also have an
> > >   allow-list of shells for which this bit is not set, managed by an
> > >   LSM's policy, if the native securebits scoping approach is not enou=
gh.
> > >
> > > Different modes for script interpreters:
> > >
> > > 1. RESTRICT_FILE=3D0 DENY_INTERACTIVE=3D0 (default)
> > >    Always interpret scripts, and allow arbitrary user commands.
> > >    =3D> No threat, everyone and everything is trusted, but we can get
> > >    ahead of potential issues with logs to prepare for a migration to =
a
> > >    restrictive mode.
> > >
> > > 2. RESTRICT_FILE=3D1 DENY_INTERACTIVE=3D0
> > >    Deny script interpretation if they are not executable, and allow
> > >    arbitrary user commands.
> > >    =3D> Threat: (potential) malicious scripts run by trusted (and not
> > >       fooled) users.  That could protect against unintended script
> > >       executions (e.g. sh /tmp/*.sh).
> > >    =3D=3D> Makes sense for (semi-restricted) user sessions.
> > >
> > > 3. RESTRICT_FILE=3D1 DENY_INTERACTIVE=3D1
> > >    Deny script interpretation if they are not executable, and also de=
ny
> > >    any arbitrary user commands.
> > >    =3D> Threat: malicious scripts run by untrusted users.
> > >    =3D=3D> Makes sense for system services executing scripts.
> > >
> > > 4. RESTRICT_FILE=3D0 DENY_INTERACTIVE=3D1
> > >    Always interpret scripts, but deny arbitrary user commands.
> > >    =3D> Goal: monitor/measure/assess script content (e.g. with IMA/EV=
M) in
> > >       a system where the access rights are not (yet) ready.  Arbitrar=
y
> > >       user commands would be much more difficult to monitor.
> > >    =3D=3D> First step of restricting system services that should not
> > >        directly pass arbitrary commands to shells.
> >
> > I like these bits!
>
> Good! Jeff, Steve, Florian, Matt, others, what do you think?

For below two cases: will they be restricted by one (or some) mode above ?

1> cat /tmp/a.sh | sh

2> sh -c "$(cat /tmp/a.sh)"
