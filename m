Return-Path: <kernel-hardening-return-21996-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 07A4DCA1002
	for <kernel-hardening@archiver.kernel.org>; Mon,  1 Sep 2025 11:06:13 +0000 (UTC)
Received: (qmail 7540 invoked by uid 550); 1 Sep 2025 11:06:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7517 invoked from network); 1 Sep 2025 11:06:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756724754; x=1757329554; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H2Gn0F3UVjDM2gGMhXQsx0gqpBNXUu+/C4/628F9+6w=;
        b=0K4oaAjmSneorPoAC/KPoocNGeXTgRQp0sS26HCVbyL9BPKRT05GWfl5LZJOCtRezL
         jLNoJhCafJe+n7+5ybsv1ft/fHxJ9D7kAjKbomuD5qwC5gTsPfgabnYnyn2KJmf2Fyux
         mKE2HEFTNl8pO3Q2x8GiKHaM0zwdweC/T/KTR9tOO3bZhR/DMm2Kh/2KEyfRjY7xB/hZ
         dR//x3cHW4tb1bJBIz99ZZmEVwGZsJNCVaPv8tkPIYCXD50ToeVhw/m7xjX9lNFXdfBt
         Cvwv8zkKkHM7R+JMWfyQYUA9ecacoZKvI4wH/WDVcddPCze9devF14MvhuuUNZFfiO0x
         bdPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756724754; x=1757329554;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H2Gn0F3UVjDM2gGMhXQsx0gqpBNXUu+/C4/628F9+6w=;
        b=vt0ICiqHGyBxWSrXgTDDXGttmkGANSvEmOaKO3w4We847YON206vB6GVjMMidZRWnv
         a1HuKLi1CsOhpVOoeRIYaqw5hh4tSXecPjiDqOrHjNbu4hP9HzWOFeia5inGiWbVWVZ1
         JAr/IjdJXT65y4fmGekk/hLZfWr1x+z/XLqdknuBF/Ub/o4yCVG3iseslGsL3t0mDhc0
         qQ9+AQNBA5zIdVnvoPWLbrfIHu3EGnJFmO/PvTFMTd/8aWJjA+xEYtcgKgyieTL4Ljco
         I+ut47dgVOH1dAQU8656tybMudn56tvbDs76josXhzuigYOi30zKow2B/4F/fMf9PLyX
         s5kg==
X-Forwarded-Encrypted: i=1; AJvYcCWCslYUioNj34BySxE8Q7fWBkcQxtN5fPDLIPnwvwPciAuV6lIaVnW+LLnXp0PgVvtxGsGNCE3zjz9miZ4RF8k0@lists.openwall.com
X-Gm-Message-State: AOJu0YyiR/JTwreZxBED+XXn9pBLlGUtul97J2gy8P2rUXOh7wQrCF4x
	URn60ka1IOfmUf43oUZ1jXpO8FAsVBaKskq/uQgAS1TUCjgMl+T2z7xFJr2gj/YxdPS1TXoTOV8
	6EI4+gHbN0vHug5E8rVzoIMF5ZNIeRPOMkFBNh2kL
X-Gm-Gg: ASbGncv2K1hbcvArJKo5MAn4RIL/W7JVyXZSX6MT8OOopiUhH/70CHIHfbYyTXCze96
	U276R+CSw/1s7itiOzqmUi4BBW8AaTf7gWoXChf3bqCKMXSCIVUXueJc2zbFqxi2wvJ1OaXuEGw
	NIM9tUui2ber3guAPZ0JjBq6YpbTglaD+E49OHeg9kQ1JsPC1Ar4kxd72vC8snfxPfCzL3Uh/cg
	QeaR+LKjhwja+w6I5UC3oIoFJ7bhIjppFEHyURwfQ==
X-Google-Smtp-Source: AGHT+IEX9I7U3nv8ZNRMUsZz4F6PIX/KTn5ofQX/L8rVN2zWLtQUH9G0KmEck4019L1pfWH3sn8LvwP06awvWqA6Rb8=
X-Received: by 2002:a05:6402:14ca:b0:61e:a896:de87 with SMTP id
 4fb4d7f45d1cf-61ea896df66mr30742a12.2.1756724753434; Mon, 01 Sep 2025
 04:05:53 -0700 (PDT)
MIME-Version: 1.0
References: <20250822170800.2116980-1-mic@digikod.net> <20250826-skorpion-magma-141496988fdc@brauner>
 <20250826.aig5aiShunga@digikod.net> <2025-08-27-obscene-great-toy-diary-X1gVRV@cyphar.com>
 <CALCETrWHKga33bvzUHnd-mRQUeNXTtXSS8Y8+40d5bxv-CqBhw@mail.gmail.com> <aLDDk4x7QBKxLmoi@mail.hallyn.com>
In-Reply-To: <aLDDk4x7QBKxLmoi@mail.hallyn.com>
From: Jann Horn <jannh@google.com>
Date: Mon, 1 Sep 2025 13:05:16 +0200
X-Gm-Features: Ac12FXz5pCbJNirecqxwiyEggxW7kJ9K_j8hu8U2LuwZM19I7qdULHA6wz1yLJg
Message-ID: <CAG48ez0p1B9nmG3ZyNRywaSYTtEULSpbxueia912nVpg2Q7WYA@mail.gmail.com>
Subject: Re: [RFC PATCH v1 0/2] Add O_DENY_WRITE (complement AT_EXECVE_CHECK)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Andy Lutomirski <luto@kernel.org>, Aleksa Sarai <cyphar@cyphar.com>, 
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

On Thu, Aug 28, 2025 at 11:01=E2=80=AFPM Serge E. Hallyn <serge@hallyn.com>=
 wrote:
> On Wed, Aug 27, 2025 at 05:32:02PM -0700, Andy Lutomirski wrote:
> > On Wed, Aug 27, 2025 at 5:14=E2=80=AFPM Aleksa Sarai <cyphar@cyphar.com=
> wrote:
> > >
> > > On 2025-08-26, Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> wrote:
> > > > On Tue, Aug 26, 2025 at 11:07:03AM +0200, Christian Brauner wrote:
> > > > > Nothing has changed in that regard and I'm not interested in stuf=
fing
> > > > > the VFS APIs full of special-purpose behavior to work around the =
fact
> > > > > that this is work that needs to be done in userspace. Change the =
apps,
> > > > > stop pushing more and more cruft into the VFS that has no busines=
s
> > > > > there.
> > > >
> > > > It would be interesting to know how to patch user space to get the =
same
> > > > guarantees...  Do you think I would propose a kernel patch otherwis=
e?
> > >
> > > You could mmap the script file with MAP_PRIVATE. This is the *actual*
> > > protection the kernel uses against overwriting binaries (yes, ETXTBSY=
 is
> > > nice but IIRC there are ways to get around it anyway).
> >
> > Wait, really?  MAP_PRIVATE prevents writes to the mapping from
> > affecting the file, but I don't think that writes to the file will
> > break the MAP_PRIVATE CoW if it's not already broken.
> >
> > IPython says:
> >
> > In [1]: import mmap, tempfile
> >
> > In [2]: f =3D tempfile.TemporaryFile()
> >
> > In [3]: f.write(b'initial contents')
> > Out[3]: 16
> >
> > In [4]: f.flush()
> >
> > In [5]: map =3D mmap.mmap(f.fileno(), f.tell(), flags=3Dmmap.MAP_PRIVAT=
E,
> > prot=3Dmmap.PROT_READ)
> >
> > In [6]: map[:]
> > Out[6]: b'initial contents'
> >
> > In [7]: f.seek(0)
> > Out[7]: 0
> >
> > In [8]: f.write(b'changed')
> > Out[8]: 7
> >
> > In [9]: f.flush()
> >
> > In [10]: map[:]
> > Out[10]: b'changed contents'
>
> That was surprising to me, however, if I split the reader
> and writer into different processes, so

Testing this in python is a terrible idea because it obfuscates the
actual syscalls from you.

> P1:
> f =3D open("/tmp/3", "w")
> f.write('initial contents')
> f.flush()
>
> P2:
> import mmap
> f =3D open("/tmp/3", "r")
> map =3D mmap.mmap(f.fileno(), f.tell(), flags=3Dmmap.MAP_PRIVATE, prot=3D=
mmap.PROT_READ)
>
> Back to P1:
> f.seek(0)
> f.write('changed')
>
> Back to P2:
> map[:]
>
> Then P2 gives me:
>
> b'initial contents'

Because when you executed `f.write('changed')`, Python internally
buffered the write. "changed" is never actually written into the file
in your example. If you add a `f.flush()` in P1 after this, running
`map[:]` in P2 again will show you the new data.
