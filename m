Return-Path: <kernel-hardening-return-21991-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id D971ECA0EFF
	for <kernel-hardening@archiver.kernel.org>; Thu, 28 Aug 2025 00:32:34 +0000 (UTC)
Received: (qmail 23553 invoked by uid 550); 28 Aug 2025 00:32:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22497 invoked from network); 28 Aug 2025 00:32:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756341136;
	bh=yFq2/idFtNoKxfqONa3lFVunxo2YTbhdRw8i4j3V+8g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dKGHQ0t8y8ngpO8oQiaqbJhdoUVSVS8DBm/p+nD/Q3almAHFqvHQY/Wxmqy1ZtaeA
	 Wu98Hpo4zoMa8P4vs+6AkRRXF61DXlBkyi4Xe3f5QMwtcWZuP/nutx6SS6OyyUDwh5
	 g+svymb2e8Po6ywHghfIdC1G8llFZLRthIkDACqVx2zXSkQoyRE24kOWiT55NZizhb
	 Q5qsLKVMmVirkLyxbfzakXCNgtliQZfZaXiibaqzbS/2CMDEBtZ1DJfxA6WiPeLWXK
	 Me2Av3WCHEUCYV/wqFXzSY2gM0fsAOMizoLlsMWRGWkaMKxmbhgrfHiIGwfjHNtsDo
	 gteUfyV0DDjVg==
X-Forwarded-Encrypted: i=1; AJvYcCX1vAD+HmA4DlmqAGWWNTB4205hEBXsvTTLV7ad816dqCM5S16Xg4W0mLY4o4P5aM51t7xYfmypGsy5FbBUnqJj@lists.openwall.com
X-Gm-Message-State: AOJu0Yy9b2d7bB+c9MevGePqwtf6GGO5HXkk1ZoMM1nYWhL3/EDaaUIU
	kYD6Kk5nYuGToYKFMRb1Wwmja/QPI8pFWJqz5OG8uK1vDa45QWBiVctiIG9FWKJvAV2AgQI5qxS
	XIdSpSfIJ77Raf3hEMv0w/J6i5mtbvi3f3FlEmHvU
X-Google-Smtp-Source: AGHT+IFBs4E/ufqmFInmmCfp8Nwce44WjgaXqekpIOhAHuwl87Hc2TiTY2CPCDgnPsJSmqV5fcG8a1TMiCPT2sNMeO0=
X-Received: by 2002:a05:6512:258d:b0:55f:596f:2ec4 with SMTP id
 2adb3069b0e04-55f596f3039mr681952e87.23.1756341133959; Wed, 27 Aug 2025
 17:32:13 -0700 (PDT)
MIME-Version: 1.0
References: <20250822170800.2116980-1-mic@digikod.net> <20250826-skorpion-magma-141496988fdc@brauner>
 <20250826.aig5aiShunga@digikod.net> <2025-08-27-obscene-great-toy-diary-X1gVRV@cyphar.com>
In-Reply-To: <2025-08-27-obscene-great-toy-diary-X1gVRV@cyphar.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Wed, 27 Aug 2025 17:32:02 -0700
X-Gmail-Original-Message-ID: <CALCETrWHKga33bvzUHnd-mRQUeNXTtXSS8Y8+40d5bxv-CqBhw@mail.gmail.com>
X-Gm-Features: Ac12FXxg-YalsCfcTcpKiyudyQQfe_FOt5x1XpJ9sIiByXo4by4N2XquUDNMVBc
Message-ID: <CALCETrWHKga33bvzUHnd-mRQUeNXTtXSS8Y8+40d5bxv-CqBhw@mail.gmail.com>
Subject: Re: [RFC PATCH v1 0/2] Add O_DENY_WRITE (complement AT_EXECVE_CHECK)
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	Christian Brauner <brauner@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, 
	Serge Hallyn <serge@hallyn.com>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Christian Heimes <christian@python.org>, Dmitry Vyukov <dvyukov@google.com>, 
	Elliott Hughes <enh@google.com>, Fan Wu <wufan@linux.microsoft.com>, 
	Florian Weimer <fweimer@redhat.com>, Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Jordan R Abrahams <ajordanr@google.com>, 
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, Luca Boccassi <bluca@debian.org>, 
	Matt Bobrowski <mattbobrowski@google.com>, Miklos Szeredi <mszeredi@redhat.com>, 
	Mimi Zohar <zohar@linux.ibm.com>, 
	Nicolas Bouchinet <nicolas.bouchinet@oss.cyber.gouv.fr>, Robert Waite <rowait@microsoft.com>, 
	Roberto Sassu <roberto.sassu@huawei.com>, Scott Shell <scottsh@microsoft.com>, 
	Steve Dower <steve.dower@python.org>, Steve Grubb <sgrubb@redhat.com>, 
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 27, 2025 at 5:14=E2=80=AFPM Aleksa Sarai <cyphar@cyphar.com> wr=
ote:
>
> On 2025-08-26, Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> wrote:
> > On Tue, Aug 26, 2025 at 11:07:03AM +0200, Christian Brauner wrote:
> > > Nothing has changed in that regard and I'm not interested in stuffing
> > > the VFS APIs full of special-purpose behavior to work around the fact
> > > that this is work that needs to be done in userspace. Change the apps=
,
> > > stop pushing more and more cruft into the VFS that has no business
> > > there.
> >
> > It would be interesting to know how to patch user space to get the same
> > guarantees...  Do you think I would propose a kernel patch otherwise?
>
> You could mmap the script file with MAP_PRIVATE. This is the *actual*
> protection the kernel uses against overwriting binaries (yes, ETXTBSY is
> nice but IIRC there are ways to get around it anyway).

Wait, really?  MAP_PRIVATE prevents writes to the mapping from
affecting the file, but I don't think that writes to the file will
break the MAP_PRIVATE CoW if it's not already broken.

IPython says:

In [1]: import mmap, tempfile

In [2]: f =3D tempfile.TemporaryFile()

In [3]: f.write(b'initial contents')
Out[3]: 16

In [4]: f.flush()

In [5]: map =3D mmap.mmap(f.fileno(), f.tell(), flags=3Dmmap.MAP_PRIVATE,
prot=3Dmmap.PROT_READ)

In [6]: map[:]
Out[6]: b'initial contents'

In [7]: f.seek(0)
Out[7]: 0

In [8]: f.write(b'changed')
Out[8]: 7

In [9]: f.flush()

In [10]: map[:]
Out[10]: b'changed contents'
