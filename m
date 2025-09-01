Return-Path: <kernel-hardening-return-21998-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 1EB2DCA0FF0
	for <kernel-hardening@archiver.kernel.org>; Mon,  1 Sep 2025 16:01:49 +0000 (UTC)
Received: (qmail 1587 invoked by uid 550); 1 Sep 2025 16:01:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1547 invoked from network); 1 Sep 2025 16:01:39 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756742488;
	bh=fRGtPoXNXozo7EUo/+X+0CRDT4KEoSMrhbUl6FXLK04=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=GT9XLlILxbzJQKfZrcncv5FDmb5xqXm7lWoVNtxQxqSnrU226V7KsM+H4vLScYY1c
	 zDGYrWFQTMh4ugpctY6Bv6RnrKv60oTJOwcRX75wJIwxuTy6raFhsWBBfZX3bJuinj
	 d1fx/1HZsgoS1bagdzfR7ra/lFmxZRQMbRXC8FiDNRfA+qXUvhAXVZwVlAGHE4c+5Z
	 1Y4J1MxU3Vg0Su1HxCL4z4wQt1pzQNiW3J0hlc/stH8fbUMewCr+gx88yqG95Q970W
	 tzYu9cantZryBxbFwAt9HnQPxF2HqfmEmiIDITAIuoolltbu4BH20iM9MGlzq81cgV
	 dHiypGhT3AWeQ==
X-Forwarded-Encrypted: i=1; AJvYcCVcMhPv/n43mK6y5/CLYaD2h4W5bYPhfiQth3kWnbkMSQehjaUo2QbdB9sk88suZzHHGYXfeA8h6YZWsb9wmz7S@lists.openwall.com
X-Gm-Message-State: AOJu0YxvGNE6E2zTQGTwVY6pTs5GkNw3Rr6k+4UwVWCtTvqZLnQoBGJI
	06NGVoss5J6KjNGy6pmye3cVFXDO8RP9ypVvM9kIUq14Q1RCE/JrRjm+ECunuanZyoGDV8iSni6
	50D/7sMY4N9KXr/potjVBVQM1NGu6nHv8ak3tH4Mf
X-Google-Smtp-Source: AGHT+IHnj6OIwdQiXJlgVo5UF3VJeh7L4asptxGZmWwqZWC31UpjffLFt4qPv8DDjEOzi1qlSKdOs+b3QNOSTgcuUzg=
X-Received: by 2002:a05:6512:448e:b0:55f:4485:9620 with SMTP id
 2adb3069b0e04-55f709bf748mr1461445e87.51.1756742486920; Mon, 01 Sep 2025
 09:01:26 -0700 (PDT)
MIME-Version: 1.0
References: <20250822170800.2116980-1-mic@digikod.net> <20250826-skorpion-magma-141496988fdc@brauner>
 <20250826.aig5aiShunga@digikod.net> <2025-08-27-obscene-great-toy-diary-X1gVRV@cyphar.com>
 <CALCETrWHKga33bvzUHnd-mRQUeNXTtXSS8Y8+40d5bxv-CqBhw@mail.gmail.com>
 <aLDDk4x7QBKxLmoi@mail.hallyn.com> <CAG48ez0p1B9nmG3ZyNRywaSYTtEULSpbxueia912nVpg2Q7WYA@mail.gmail.com>
In-Reply-To: <CAG48ez0p1B9nmG3ZyNRywaSYTtEULSpbxueia912nVpg2Q7WYA@mail.gmail.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Mon, 1 Sep 2025 09:01:15 -0700
X-Gmail-Original-Message-ID: <CALCETrUM7LAzm-pXwgTVACvO7uvaUZ0B7j=6Vy0BrDkngpu=yg@mail.gmail.com>
X-Gm-Features: Ac12FXwKS6-FHwq3nvpTeXOsn_tseUs4dZWGKJnLf2Z-xopwBmsE6DWor8ej0K0
Message-ID: <CALCETrUM7LAzm-pXwgTVACvO7uvaUZ0B7j=6Vy0BrDkngpu=yg@mail.gmail.com>
Subject: Re: [RFC PATCH v1 0/2] Add O_DENY_WRITE (complement AT_EXECVE_CHECK)
To: Jann Horn <jannh@google.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Andy Lutomirski <luto@kernel.org>, Aleksa Sarai <cyphar@cyphar.com>, 
	=?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	Christian Brauner <brauner@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, 
	Arnd Bergmann <arnd@arndb.de>, Christian Heimes <christian@python.org>, Dmitry Vyukov <dvyukov@google.com>, 
	Elliott Hughes <enh@google.com>, Fan Wu <wufan@linux.microsoft.com>, 
	Florian Weimer <fweimer@redhat.com>, Jeff Xu <jeffxu@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	Jordan R Abrahams <ajordanr@google.com>, Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, 
	Luca Boccassi <bluca@debian.org>, Matt Bobrowski <mattbobrowski@google.com>, 
	Miklos Szeredi <mszeredi@redhat.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	Nicolas Bouchinet <nicolas.bouchinet@oss.cyber.gouv.fr>, Robert Waite <rowait@microsoft.com>, 
	Roberto Sassu <roberto.sassu@huawei.com>, Scott Shell <scottsh@microsoft.com>, 
	Steve Dower <steve.dower@python.org>, Steve Grubb <sgrubb@redhat.com>, 
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 1, 2025 at 4:06=E2=80=AFAM Jann Horn <jannh@google.com> wrote:
>
> On Thu, Aug 28, 2025 at 11:01=E2=80=AFPM Serge E. Hallyn <serge@hallyn.co=
m> wrote:
> > On Wed, Aug 27, 2025 at 05:32:02PM -0700, Andy Lutomirski wrote:
> > > On Wed, Aug 27, 2025 at 5:14=E2=80=AFPM Aleksa Sarai <cyphar@cyphar.c=
om> wrote:
> > > >
> > > > On 2025-08-26, Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> wrote:
> > > > > On Tue, Aug 26, 2025 at 11:07:03AM +0200, Christian Brauner wrote=
:
> > > > > > Nothing has changed in that regard and I'm not interested in st=
uffing
> > > > > > the VFS APIs full of special-purpose behavior to work around th=
e fact
> > > > > > that this is work that needs to be done in userspace. Change th=
e apps,
> > > > > > stop pushing more and more cruft into the VFS that has no busin=
ess
> > > > > > there.
> > > > >
> > > > > It would be interesting to know how to patch user space to get th=
e same
> > > > > guarantees...  Do you think I would propose a kernel patch otherw=
ise?
> > > >
> > > > You could mmap the script file with MAP_PRIVATE. This is the *actua=
l*
> > > > protection the kernel uses against overwriting binaries (yes, ETXTB=
SY is
> > > > nice but IIRC there are ways to get around it anyway).
> > >
> > > Wait, really?  MAP_PRIVATE prevents writes to the mapping from
> > > affecting the file, but I don't think that writes to the file will
> > > break the MAP_PRIVATE CoW if it's not already broken.
> > >
> > > IPython says:
> > >
> > > In [1]: import mmap, tempfile
> > >
> > > In [2]: f =3D tempfile.TemporaryFile()
> > >
> > > In [3]: f.write(b'initial contents')
> > > Out[3]: 16
> > >
> > > In [4]: f.flush()
> > >
> > > In [5]: map =3D mmap.mmap(f.fileno(), f.tell(), flags=3Dmmap.MAP_PRIV=
ATE,
> > > prot=3Dmmap.PROT_READ)
> > >
> > > In [6]: map[:]
> > > Out[6]: b'initial contents'
> > >
> > > In [7]: f.seek(0)
> > > Out[7]: 0
> > >
> > > In [8]: f.write(b'changed')
> > > Out[8]: 7
> > >
> > > In [9]: f.flush()
> > >
> > > In [10]: map[:]
> > > Out[10]: b'changed contents'
> >
> > That was surprising to me, however, if I split the reader
> > and writer into different processes, so
>
> Testing this in python is a terrible idea because it obfuscates the
> actual syscalls from you.
>
> > P1:
> > f =3D open("/tmp/3", "w")
> > f.write('initial contents')
> > f.flush()
> >
> > P2:
> > import mmap
> > f =3D open("/tmp/3", "r")
> > map =3D mmap.mmap(f.fileno(), f.tell(), flags=3Dmmap.MAP_PRIVATE, prot=
=3Dmmap.PROT_READ)
> >
> > Back to P1:
> > f.seek(0)
> > f.write('changed')
> >
> > Back to P2:
> > map[:]
> >
> > Then P2 gives me:
> >
> > b'initial contents'
>
> Because when you executed `f.write('changed')`, Python internally
> buffered the write. "changed" is never actually written into the file
> in your example. If you add a `f.flush()` in P1 after this, running
> `map[:]` in P2 again will show you the new data.
>

These days, one can type in Python, ask an LLM to translate to C, and
get almost-correct output :)  Or one can use os.write(), which is
exactly what I should have done.

--Andy
