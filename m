Return-Path: <kernel-hardening-return-21769-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 17018C3DA42
	for <kernel-hardening@archiver.kernel.org>; Tue,  9 Jul 2024 18:58:28 +0000 (UTC)
Received: (qmail 7588 invoked by uid 550); 9 Jul 2024 18:58:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7563 invoked from network); 9 Jul 2024 18:58:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720551485; x=1721156285; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zAoQUSx9bhpcdjQTt+qmhPqP+zZAnIGtZqlOI0lzq4w=;
        b=v0DtrkrMW4nFzMe9/fjIGCVoGBke4wYmjoXXRz+zf9woXa1hxCAGhDAiOc3T1vNpc8
         nlXszz0D6pXe9+4GT4XiSZHBynIXWPZ6gpphY1JnqDbpZ4aZ7fgfLJySXkXp1Xehi2+v
         ff3VN5+Kxw/7+3sXDyBvWAPnYh0aC2KW0dxkXgq/0qKBtaOdyXny5Eamky2O/N4yyXka
         M01KRg/9faTD0YdR6OvjNXMwotnlrj+6najW/YoY2kwgNkB9THCoHs5YVonc88M9MwND
         sOJVuxMBG8M1vZfmYuSmZkzzSv0/g0LKP9nODG5wjOEXpOXacc+cOaT4WEDXbbqax5ce
         WNVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720551485; x=1721156285;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zAoQUSx9bhpcdjQTt+qmhPqP+zZAnIGtZqlOI0lzq4w=;
        b=GorRft16h7SEbl4hMW+INhlpvfQ6D9l2BCDbz+xPSoE2LnAyIBlMeuGYh1xe3SmaR8
         iXXdgWjtJy59bj//HuW4h7tcryC9sSkH/gPxvoajQkVEurkFghGd2n7bisfj8e+LAwh8
         4dCa9FhFFsz9AH06bf1wbvKFjtPnJpzXV1xvHDblNmGpMGYDxRpzPPy9N8iK5Fvbbuxf
         5b9p7zXCc8Logti+s7FSEcqeh629JzR2RkflqA/DNXLJpTJ2V+gc8Go5vslv7LkhAL2P
         FLoj1ctzYTPtFvjiNc6CsU8sqxl7OrU0q5/G+MmHUwThgRaxv0KlLhC3LlAMAxVg6ArG
         tQkw==
X-Forwarded-Encrypted: i=1; AJvYcCUHnLxzspO5dakhCx63e9lWE88a+qbSmeD29sX0YCotnLnEw2gu+XHwuAK3IDR6oIR5qIwuUVozR17WWuszssHbAGL+ABuJLs3oVGUxLJACNdm+YQ==
X-Gm-Message-State: AOJu0Yz9NMXXzDF0ca880kSWmpqExd/Fm8RejWceSbn1VHocsig9ckHm
	y0u3PLooGJdBnq0h8wRJpn5bl5+EXYtFJ2QJpJw45v9lp4fTDhQBw7WpWdVTtMvflw7YA1iL9rc
	uXhc+Z38CDuF7fVXYAdPQljBOh2UD/kNvIUbG
X-Google-Smtp-Source: AGHT+IECwTUCWfNd/m0r/4U5ddqq9szdLi7Tw8glyBT6PX7+eYxwo4Ic0ZuXywbnuTJaGnFDZBWSOOJzFKOrzR9sUWE=
X-Received: by 2002:a50:9f84:0:b0:58b:dfaa:a5ca with SMTP id
 4fb4d7f45d1cf-596d4daf533mr28844a12.6.1720551484754; Tue, 09 Jul 2024
 11:58:04 -0700 (PDT)
MIME-Version: 1.0
References: <20240704190137.696169-1-mic@digikod.net> <20240704190137.696169-2-mic@digikod.net>
 <87bk3bvhr1.fsf@oldenburg.str.redhat.com> <CALmYWFu_JFyuwYhDtEDWxEob8JHFSoyx_SCcsRVKqSYyyw30Rg@mail.gmail.com>
 <87ed83etpk.fsf@oldenburg.str.redhat.com> <CALmYWFvkUnevm=npBeaZVkK_PXm=A8MjgxFXkASnERxoMyhYBg@mail.gmail.com>
 <87r0c3dc1c.fsf@oldenburg.str.redhat.com> <CALmYWFvA7VPz06Tg8E-R_Jqn2cxMiWPPC6Vhy+vgqnofT0GELg@mail.gmail.com>
 <20240709.gae4cu4Aiv6s@digikod.net>
In-Reply-To: <20240709.gae4cu4Aiv6s@digikod.net>
From: Jeff Xu <jeffxu@google.com>
Date: Tue, 9 Jul 2024 11:57:27 -0700
Message-ID: <CALmYWFsvKq+yN4qHhBamxyjtcy9myg8_t3Nc=5KErG=DDaDAEA@mail.gmail.com>
Subject: Re: [RFC PATCH v19 1/5] exec: Add a new AT_CHECK flag to execveat(2)
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: Florian Weimer <fweimer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Paul Moore <paul@paul-moore.com>, 
	"Theodore Ts'o" <tytso@mit.edu>, Alejandro Colomar <alx@kernel.org>, Aleksa Sarai <cyphar@cyphar.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, 
	Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, 
	Christian Heimes <christian@python.org>, Dmitry Vyukov <dvyukov@google.com>, 
	Eric Biggers <ebiggers@kernel.org>, Eric Chiang <ericchiang@google.com>, 
	Fan Wu <wufan@linux.microsoft.com>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	James Morris <jamorris@linux.microsoft.com>, Jan Kara <jack@suse.cz>, 
	Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	Jordan R Abrahams <ajordanr@google.com>, Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, 
	Luca Boccassi <bluca@debian.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>, Matt Bobrowski <mattbobrowski@google.com>, 
	Matthew Garrett <mjg59@srcf.ucam.org>, Matthew Wilcox <willy@infradead.org>, 
	Miklos Szeredi <mszeredi@redhat.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>, Scott Shell <scottsh@microsoft.com>, 
	Shuah Khan <shuah@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, 
	Steve Dower <steve.dower@python.org>, Steve Grubb <sgrubb@redhat.com>, 
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, 
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Xiaoming Ni <nixiaoming@huawei.com>, 
	Yin Fengwei <fengwei.yin@intel.com>, kernel-hardening@lists.openwall.com, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 9, 2024 at 2:18=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <mic@digiko=
d.net> wrote:
>
> On Mon, Jul 08, 2024 at 10:52:36AM -0700, Jeff Xu wrote:
> > On Mon, Jul 8, 2024 at 10:33=E2=80=AFAM Florian Weimer <fweimer@redhat.=
com> wrote:
> > >
> > > * Jeff Xu:
> > >
> > > > On Mon, Jul 8, 2024 at 9:26=E2=80=AFAM Florian Weimer <fweimer@redh=
at.com> wrote:
> > > >>
> > > >> * Jeff Xu:
> > > >>
> > > >> > Will dynamic linkers use the execveat(AT_CHECK) to check shared
> > > >> > libraries too ?  or just the main executable itself.
> > > >>
> > > >> I expect that dynamic linkers will have to do this for everything =
they
> > > >> map.
> > > > Then all the objects (.so, .sh, etc.) will go through  the check fr=
om
> > > > execveat's main  to security_bprm_creds_for_exec(), some of them mi=
ght
> > > > be specific for the main executable ?
>
> Yes, we should check every executable code (including seccomp filters)
> to get a consistent policy.
>
> What do you mean by "specific for the main executable"?
>
I meant:

The check is for the exe itself, not .so, etc.

For example:  /usr/bin/touch is checked.
not the shared objects:
ldd /usr/bin/touch
linux-vdso.so.1 (0x00007ffdc988f000)
libc.so.6 =3D> /lib/x86_64-linux-gnu/libc.so.6 (0x00007f59b6757000)
/lib64/ld-linux-x86-64.so.2 (0x00007f59b6986000)

Basically, I asked if the check can be extended to shared-objects,
seccomp filters, etc, without modifying existing LSMs.
you pointed out "LSM should not need to be updated with this patch
series.", which already answered my question.

Thanks.
-Jeff

-Jeff
