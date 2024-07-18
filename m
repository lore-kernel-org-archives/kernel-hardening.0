Return-Path: <kernel-hardening-return-21811-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id A4C7BC3DA61
	for <kernel-hardening@archiver.kernel.org>; Thu, 18 Jul 2024 22:54:59 +0000 (UTC)
Received: (qmail 23990 invoked by uid 550); 18 Jul 2024 22:54:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23970 invoked from network); 18 Jul 2024 22:54:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721343277; x=1721948077; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SnXUJZUUq5kQBG44OPNJniIMw+LK8h1ZLMMk9t95bZg=;
        b=UnV4wtQnBVl17rLJ1fvb08AnqY40AaeJSB3hgNAbtAuNvMaC3Hw+eBcWNsZAyxzRBd
         MlYF9NJe4Ni8o9Pt3w9cxQL9A26GxJE8ct+kukIw6Hjf2wnlTE5RBQsurSjzTOzZZ5KM
         Y34Scp/pRhyWrFkZvTbhqEqCx3aPYpYvDHSO1GGf/w/HUaOKd9RDpNzW6fWqOf+/6Udg
         4zG+XFohNFj8NkRJYZ0YO3aSf5iTDvQUa2nd+veE9JLlWqH3IgkSq84bpcRJcvTI6JHq
         E5hImcyHAWRTVZm26A4hb3dr12Q+/38U/xm/wzz0DpU5Sqi9xAOrmkOabSPpJJt0DkUn
         lHKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721343277; x=1721948077;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SnXUJZUUq5kQBG44OPNJniIMw+LK8h1ZLMMk9t95bZg=;
        b=qQChQq/94Lyv1EsgLtBl4+dwva/mY4Zyu4RBtGrUfzgWnufk4n7SP/wSbjXgBKt1hg
         P6CUkLRtiRu1jjySoA/LOGZ3vufiN6lhpLtI4aRoA3hwVWd7o5DGZSrWMEaWLvET5RNo
         UO2wuNmdByjfvLtas5pfn3sie2rm2oKMW/Zd7lLidfi0lOpj/fVbaOONyroaluxmtU6T
         34xkpPF2cceHmYGsIikgahQ/VtGr+pbOvkLEevpjdP6QoLvR4tBtjZsxntHwVl9aYg18
         jTF4FJYUdCr15cCFrqP3A6qI1wkP2mqoJ6spcxMcXXJk8zH7zh0mvNtVqBreHo5008kr
         oRnA==
X-Forwarded-Encrypted: i=1; AJvYcCXab2XsAXbRtqudw05cymyeJ5DRQCuPlj1Tsq+soQxngm+83fyTJixdGs0LU0bS6QdhqoqJbc6A8V5QqxLbaUS7C5XRMU7ny2j61SOkh5BIEWkV1A==
X-Gm-Message-State: AOJu0Yxl3LOsyBsoys7d7FtB6yir0FbBWHyPFgTVcO2Ch0MuKGEaLMC+
	Xp6Zwpko98I0JQtu/9Y4bqbG1Uk1y2JKFbymfFBVkDhMpypizxVuGtCqRSsr9ztP+wNkaowHYBU
	668DghHFgyZwYN+oUEK+XAU1s8sO31f0/NuuK
X-Google-Smtp-Source: AGHT+IFD08e2bkpE0+ciYMxbQAHum1I99VoHhJUfFR8GdMFbVfM2/11g6fb19Z5YGSucTrp/1La67vd2feM3Ldh0j0I=
X-Received: by 2002:a05:6402:51cd:b0:57d:32ff:73ef with SMTP id
 4fb4d7f45d1cf-5a2cae572bbmr113920a12.6.1721343277083; Thu, 18 Jul 2024
 15:54:37 -0700 (PDT)
MIME-Version: 1.0
References: <20240704190137.696169-1-mic@digikod.net> <20240704190137.696169-2-mic@digikod.net>
 <CALmYWFss7qcpR9D_r3pbP_Orxs55t3y3yXJsac1Wz=Hk9Di0Nw@mail.gmail.com>
 <a0da7702-dabe-49e4-87f4-5d6111f023a8@python.org> <20240717.AGh2shahc9ee@digikod.net>
 <CALmYWFvxJSyi=BT5BKDiKCNanmbhLuZ6=iAMvv1ibnP24SC7fA@mail.gmail.com> <20240718.ahph4che5Shi@digikod.net>
In-Reply-To: <20240718.ahph4che5Shi@digikod.net>
From: Jeff Xu <jeffxu@google.com>
Date: Thu, 18 Jul 2024 15:54:00 -0700
Message-ID: <CALmYWFvAFfXmHgo6Ca+FsKhAapJ_C1VXhqT7LdFy3ZnU4Vu3Hw@mail.gmail.com>
Subject: Re: [RFC PATCH v19 1/5] exec: Add a new AT_CHECK flag to execveat(2)
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: Steve Dower <steve.dower@python.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Kees Cook <keescook@chromium.org>, 
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
	linux-security-module@vger.kernel.org, Elliott Hughes <enh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 18, 2024 at 5:23=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <mic@digik=
od.net> wrote:
>
> On Wed, Jul 17, 2024 at 06:51:11PM -0700, Jeff Xu wrote:
> > On Wed, Jul 17, 2024 at 3:00=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <mic@d=
igikod.net> wrote:
> > >
> > > On Wed, Jul 17, 2024 at 09:26:22AM +0100, Steve Dower wrote:
> > > > On 17/07/2024 07:33, Jeff Xu wrote:
> > > > > Consider those cases: I think:
> > > > > a> relying purely on userspace for enforcement does't seem to be
> > > > > effective,  e.g. it is trivial  to call open(), then mmap() it in=
to
> > > > > executable memory.
> > > >
> > > > If there's a way to do this without running executable code that ha=
d to pass
> > > > a previous execveat() check, then yeah, it's not effective (e.g. a =
Python
> > > > interpreter that *doesn't* enforce execveat() is a trivial way to d=
o it).
> > > >
> > > > Once arbitrary code is running, all bets are off. So long as all ar=
bitrary
> > > > code is being checked itself, it's allowed to do things that would =
bypass
> > > > later checks (and it's up to whoever audited it in the first place =
to
> > > > prevent this by not giving it the special mark that allows it to pa=
ss the
> > > > check).
> > >
> > We will want to define what is considered as "arbitrary code is running=
"
> >
> > Using an example of ROP, attackers change the return address in stack,
> > e.g. direct the execution flow to a gauge to call "ld.so /tmp/a.out",
> > do you consider "arbitrary code is running" when stack is overwritten
> > ? or after execve() is called.
>
> Yes, ROP is arbitrary code execution (which can be mitigated with CFI).
> ROP could be enough to interpret custom commands and create a small
> interpreter/VM.
>
> > If it is later, this patch can prevent "ld.so /tmp/a.out".
> >
> > > Exactly.  As explained in the patches, one crucial prerequisite is th=
at
> > > the executable code is trusted, and the system must provide integrity
> > > guarantees.  We cannot do anything without that.  This patches series=
 is
> > > a building block to fix a blind spot on Linux systems to be able to
> > > fully control executability.
> >
> > Even trusted executable can have a bug.
>
> Definitely, but this patch series is dedicated to script execution
> control.
>
> >
> > I'm thinking in the context of ChromeOS, where all its system services
> > are from trusted partitions, and legit code won't load .so from a
> > non-exec mount.  But we want to sandbox those services, so even under
> > some kind of ROP attack, the service still won't be able to load .so
> > from /tmp. Of course, if an attacker can already write arbitrary
> > length of data into the stack, it is probably already a game over.
> >
>
> OK, you want to tie executable file permission to mmap.  That makes
> sense if you have a consistent execution model.  This can be enforced by
> LSMs.  Contrary to script interpretation which is a full user space
> implementation (and then controlled by user space), mmap restrictions
> should indeed be enforced by the kernel.
Ya, that is what I meant. it can be out of scope for this patch.
Indeed, as you point out, this patch is dedicated to script execution
control, and fixing ld.so /tmp/a.out is an extra bonus in addition to
script.

Thanks
-Jeff
