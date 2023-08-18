Return-Path: <kernel-hardening-return-21672-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 35048EE4982
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Aug 2023 17:15:14 +0000 (UTC)
Received: (qmail 7672 invoked by uid 550); 18 Aug 2023 17:15:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27961 invoked from network); 18 Aug 2023 16:10:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692375021; x=1692979821;
        h=content-transfer-encoding:cc:to:from:subject:references
         :mime-version:message-id:in-reply-to:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sr07mSREfAsydHaIsdSRJgqSY9Wp4tg2bjw2EfDiAIM=;
        b=GmZsqXtLuKStet0x0b3bkt9jFpZb9pDxv6cUGPcag+jnpf5vnrBXHL0rCAwHgfg8pQ
         jo/0ItokVOPtnH6CbSc+4usHTjrOwV5GTMHvuxJx+RszBhicD+Q8tgoQA+Q/tZb43yrg
         5W0ZPAD5gtfIYbFpVH1LTGchCQDVi7PFuKDQBGEuQwjroNvrFJMpeDRogfL4nDNLJQHp
         gyNmeMVosO0h16q+wFF+rOIi3qgvDCgAkErBASbtPHry+YqsaA8aZ0Mnyv/nChltWbod
         yC9xwfkOpozTd/B/xp9cCYI4t5Z028IZdATA3y1sXoPWFcDu46hsLkYECXU3g8cdwIXZ
         EmOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692375021; x=1692979821;
        h=content-transfer-encoding:cc:to:from:subject:references
         :mime-version:message-id:in-reply-to:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Sr07mSREfAsydHaIsdSRJgqSY9Wp4tg2bjw2EfDiAIM=;
        b=DxECBcyDmfuY+msROt4uyOtUjc36SYZgIam+pvV1GGVdjdG9pF/FxDZFxcF07hZb9x
         5Ou0ANLHRZ5kkwhdRk4ABQDk3/tThivCf5KdvGFbrnjrrILd1GKS1kcrsmUjFyrM2iMW
         0lPv6O9bnvtX9QyWdIq8H8ahhyNVoJW1RgMYcyn4jlDogQ4IuOKu7tbEs+F4c8XItEDd
         cKZ/rKS8y0c0015RxJ0/hMdC+zyBVPp1iqdLqNTOUdjnyn7FF4L4q/H/w1lw6F0Mf469
         jKv8JOraDvU5ZjgediynsJ5BtiMz2t444L1+uXXtzWX6s+8RtKHSClkZF5TbJpjnq+5K
         32MQ==
X-Gm-Message-State: AOJu0YwiUX9U4bgh505X7C++SRaVdd729ZfxXyNl0ZSxEB+XCHMNqvrt
	QrbzqTnFFBQE1/pfHxTOTFgdnC3Wzt4=
X-Google-Smtp-Source: AGHT+IHV6GpDNTvVkkgb1lQTZdoXbIUHv/uSlPkw2Ihc6sLOavtHyImbVH27p/gg2eSgTuMAqJ02ijlyycA=
X-Received: from sport.zrh.corp.google.com ([2a00:79e0:9d:4:e92d:f2d7:8998:9d2f])
 (user=gnoack job=sendgmr) by 2002:a25:d057:0:b0:c00:a33:7 with SMTP id
 h84-20020a25d057000000b00c000a330007mr38818ybg.8.1692375020672; Fri, 18 Aug
 2023 09:10:20 -0700 (PDT)
Date: Fri, 18 Aug 2023 18:10:18 +0200
In-Reply-To: <2023040207-pretender-legislate-2e8b@gregkh>
Message-Id: <ZN+X6o3cDWcLoviq@google.com>
Mime-Version: 1.0
References: <20230402160815.74760f87.hanno@hboeck.de> <2023040232-untainted-duration-daf6@gregkh>
 <20230402191652.747b6acc.hanno@hboeck.de> <2023040207-pretender-legislate-2e8b@gregkh>
Subject: Re: [PATCH] Restrict access to TIOCLINUX
From: "=?iso-8859-1?Q?G=FCnther?= Noack" <gnoack@google.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "Hanno =?iso-8859-1?Q?B=F6ck?=" <hanno@hboeck.de>, kernel-hardening@lists.openwall.com, 
	Kees Cook <keescook@chromium.org>, Jiri Slaby <jirislaby@kernel.org>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, Paul Moore <paul@paul-moore.com>, 
	Samuel Thibault <samuel@ens-lyon.org>, David Laight <David.Laight@aculab.com>, 
	Simon Brand <simon.brand@postadigitale.de>, Dave Mielke <Dave@mielke.cc>, 
	"=?iso-8859-1?Q?Micka=EBl_Sala=FCn?=" <mic@digikod.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello!

+CC the people involved in TIOCSTI

This patch seems sensible to me --
and I would like to kindly ask you to reconsider it.

On Sun, Apr 02, 2023 at 07:23:44PM +0200, Greg KH wrote:
> On Sun, Apr 02, 2023 at 07:16:52PM +0200, Hanno B=C3=B6ck wrote:
> > On Sun, 2 Apr 2023 16:55:01 +0200
> > Greg KH <gregkh@linuxfoundation.org> wrote:
> >=20
> > > You just now broke any normal user programs that required this (or th=
e
> > > other ioctls), and so you are going to have to force them to be run
> > > with CAP_SYS_ADMIN permissions?=20
> >=20
> > Are you aware of such normal user programs?
> > It was my impression that this is a relatively obscure feature and gpm
> > is pretty much the only tool using it.
>=20
> "Pretty much" does not mean "none" :(

This patch only affects TIOCLINUX subcodes which are responsible for text
cut-and-paste, TIOCL_SETSEL, TIOCL_PASTESEL and TIOCL_SELLOADLUT.

The only program that I am aware of which uses cut&paste on the console is =
gpm.
My web searches for these subcode names have only surfaced Linux header fil=
es
and discussions about their security problems.


> > > And you didn't change anything for programs like gpm that already had
> > > root permission (and shouldn't that permission be dropped anyway?)
> >=20
> > Well, you could restrict all that to a specific capability. However, it
> > is my understanding that the existing capability system is limited in
> > the number of capabilities and new ones should only be introduced in
> > rare cases. It does not seem a feature probably few people use anyway
> > deserves a new capability.
>=20
> I did not suggest that a new capability be created for this, that would
> be an abust of the capability levels for sure.
>=20
> > Do you have other proposals how to fix this issue? One could introduce
> > an option like for TIOCSTI that allows disabling selection features by
> > default.
>=20
> What exact issue are you trying to fix here?

It's the same problem as with TIOCSTI, which got (optionally) disabled for
non-CAP_SYS_ADMIN in commit 83efeeeb3d04 ("tty: Allow TIOCSTI to be disable=
d")
and commit 690c8b804ad2 ("TIOCSTI: always enable for CAP_SYS_ADMIN").

The number of exploits which have used TIOCSTI in the past is long[1] and h=
as
affected multiple sandboxing and sudo-like tools.  If the user is using the
console, TIOCLINUX's cut&paste functionality can replace TIOCSTI in these
exploits.

We have this problem with the Landlock LSM as well, with both TIOCSTI and t=
hese
TIOCLINUX subcodes.

Here is an example scenario:

* User runs a vulnerable version of the "ping" command from the console.

* The "ping" command is a hardened version which puts itself into a Landloc=
k
  sandbox, but it still has the TTY FD through stdout.

* Ping gets buffer-overflow-exploited by an attacker through ping responses=
.

* The attacker can't directly access the file system, but the attacker can
  escape the sandbox by controlling the surrounding (non-sandboxed) shell o=
n its
  terminal through TIOCLINUX.

The ping example is not completely made up -- FreeBSD had such a vulnerabil=
ity
in its ping utility in 2022[2].  The impact of the vulnerability was mitiga=
ted
by FreeBSD's Capsicum sandboxing.

The correct solution for the problem on Linux is to my knowledge to create =
a
pty/tty pair, but that is somewhat impractical for small utilities like pin=
g, in
order to restrict themselves (they would need to create a sidecar process t=
o
shovel the data back and forth).  Workarounds include setsid() and seccomp-=
bpf,
but they also have their limits and are not a clean solution.  We've previo=
usly
discussed it in [3].

I do believe that requiring CAP_SYS_ADMIN for TIOCLINUX's TIOCL_PASTESEL su=
bcode
would be a better approach than so many sudo-style and sandboxing tools hav=
ing
to learn this lesson the hard way.  Can we please reconsider this patch?

=E2=80=94G=C3=BCnther

[1] https://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=3DTIOCSTI
[2] https://www.freebsd.org/security/advisories/FreeBSD-SA-22:15.ping.asc
[3] https://lore.kernel.org/all/20230626.0a8f70d4228e@gnoack.org/

--=20
Sent using Mutt =F0=9F=90=95 Woof Woof
