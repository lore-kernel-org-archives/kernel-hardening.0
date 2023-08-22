Return-Path: <kernel-hardening-return-21677-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 89472EE49A5
	for <kernel-hardening@archiver.kernel.org>; Tue, 22 Aug 2023 19:51:16 +0000 (UTC)
Received: (qmail 17723 invoked by uid 550); 22 Aug 2023 19:51:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22489 invoked from network); 22 Aug 2023 18:22:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692728527; x=1693333327;
        h=content-transfer-encoding:cc:to:from:subject:references
         :mime-version:message-id:in-reply-to:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ANyda03hn0Q+QSTkmPVloqs/xsaqm5JSqEmUS3BMSkg=;
        b=3zJOJ4ZlDBRRb7PO6PDJ03gPIA69mG0I6M0m7aFlqkIYPtL+Y181db9l4r1naGuqPj
         7DEes6yqSkKWtsG37UOKX1WnITutanmmtOO5lzI1PNRzh3DFqo/Zfua6x0a8tlKTRxFg
         hdnLFlg4yvjG3qaBsDTGnDSU3aIbddVdcPueEhdfpuKOHCueS5Cw6wfHUyjpXIta2pSn
         wlTKKZLKKMdTgDtkVri9X2krK+eqKuLWWgM8vo//2fcFhCec2HUloOzLdQV02qpTpVEu
         QOIEb5ZUKrMvzbWyiN63p/n5gG9bHQ/jFTm80BDsadF2GvUurkg8FT+o3h9E+xPacksS
         Yxjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692728527; x=1693333327;
        h=content-transfer-encoding:cc:to:from:subject:references
         :mime-version:message-id:in-reply-to:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ANyda03hn0Q+QSTkmPVloqs/xsaqm5JSqEmUS3BMSkg=;
        b=jmB/7pmUqqd9AWEbW2pdYOrfr/l+pNIkI441xyPUyGdD3iGSxMVNn6iDOTCdXZ2dd3
         /eEToXPvRXJ6R9L6WVrgwL+i7D7Iy9rr9S5+LSY8wkvl4AKCbLKc+Vh4xsUCBz7KIXtG
         Oa4XQ6sPBRwHWtSV0LahljRK8BDfrpjRcZyHrwc7tqae0YYyag04Rc/8843TVhLgH5xB
         6T2BdTa7RX0Ga/i8gUNRrWs+wN3NPn1JwrOIgEHUxoCsTn3IG1ONvKiMPLHplihLqwHt
         6aSPV32xY7GhLsNnRzDme46DcEbXo665gHP7j7Vy8HvfIJtqjAVUpe1+fvpIc+1xBvUy
         So7A==
X-Gm-Message-State: AOJu0YxRyOLzGCBNEYuVy0XlU+Etjb54HxKgAUc1Gk+vsP6Yz/58iN4U
	+8aGYy84ZW9QDE97SQcWN6fSF49TpKM=
X-Google-Smtp-Source: AGHT+IHN5COOeZ87RTY3zfquTqFtC2Dvh1cK4WGfeFWh/PZy+EN3lBGohHRF8BspDnl41ywXqd2bURcAahE=
X-Received: from sport.zrh.corp.google.com ([2a00:79e0:9d:4:6ee0:5b1d:6886:698e])
 (user=gnoack job=sendgmr) by 2002:a05:6902:1894:b0:d12:d6e4:a08d with SMTP id
 cj20-20020a056902189400b00d12d6e4a08dmr135546ybb.7.1692728527635; Tue, 22 Aug
 2023 11:22:07 -0700 (PDT)
Date: Tue, 22 Aug 2023 20:22:04 +0200
In-Reply-To: <2023082203-slackness-sworn-2c80@gregkh>
Message-Id: <ZOT8zL8tXqy41XmM@google.com>
Mime-Version: 1.0
References: <20230402160815.74760f87.hanno@hboeck.de> <2023040232-untainted-duration-daf6@gregkh>
 <20230402191652.747b6acc.hanno@hboeck.de> <2023040207-pretender-legislate-2e8b@gregkh>
 <ZN+X6o3cDWcLoviq@google.com> <2023082203-slackness-sworn-2c80@gregkh>
Subject: Re: [PATCH] Restrict access to TIOCLINUX
From: "=?iso-8859-1?Q?G=FCnther?= Noack" <gnoack@google.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "Hanno =?iso-8859-1?Q?B=F6ck?=" <hanno@hboeck.de>, kernel-hardening@lists.openwall.com, 
	Kees Cook <keescook@chromium.org>, Jiri Slaby <jirislaby@kernel.org>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, Paul Moore <paul@paul-moore.com>, 
	Samuel Thibault <samuel.thibault@ens-lyon.org>, David Laight <David.Laight@aculab.com>, 
	Simon Brand <simon.brand@postadigitale.de>, Dave Mielke <Dave@mielke.cc>, 
	"=?iso-8859-1?Q?Micka=EBl_Sala=FCn?=" <mic@digikod.net>, KP Singh <kpsingh@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hi!

Thanks for re-considering this patch set!

On Tue, Aug 22, 2023 at 02:07:24PM +0200, Greg KH wrote:
> On Fri, Aug 18, 2023 at 06:10:18PM +0200, G=C3=BCnther Noack wrote:
> > The only program that I am aware of which uses cut&paste on the console=
 is gpm.
> > My web searches for these subcode names have only surfaced Linux header=
 files
> > and discussions about their security problems.
>=20
> Is gpm running with the needed permissions already?

Yes, this should work.

GPM runs as root with the CAP_SYS_ADMIN capability (and many others).


> > We have this problem with the Landlock LSM as well, with both TIOCSTI a=
nd these
> > TIOCLINUX subcodes.
> >=20
> > Here is an example scenario:
> >=20
> > * User runs a vulnerable version of the "ping" command from the console=
.
>=20
> Don't do that :)
>=20
> > * The "ping" command is a hardened version which puts itself into a Lan=
dlock
> >   sandbox, but it still has the TTY FD through stdout.
> >=20
> > * Ping gets buffer-overflow-exploited by an attacker through ping respo=
nses.
>=20
> You allowed a root-permissioned program to accept unsolicted network
> code, why is it the kernel's issue here?

I did not mean to imply that ping runs as root due to the setuid flag.  In =
this
scenario, ping runs as a normal user with only a few additional networking
capabilities (as I believe it is common on most distributions now?).

Also, as Landlock is a sandboxing feature, it makes sense to assume from th=
at
perspective that the confined process is already hostile.

So the privilege boundary that the example is about is not that the ping pr=
ocess
was successfully attacked (that is a problem too), but it is that the
now-hostile ping process can escape the sandbox through the TTY file descri=
ptor.

It is the *shell* which has more privileges for accessing *files* than the =
ping
process has.  This is because the ping process has self-confined itself wit=
h a
Landlock sandbox before it was attacked, and therefore ping itself only has=
 very
limited access to files.

ping is indeed a bit unusual because of the special capabilities it needs -=
- the
same example would also apply to netcat, or any other Unix utility which
commonly gets invoked from the command line, which processes untrusted inpu=
t,
and which should sandbox itself.


> > * The attacker can't directly access the file system, but the attacker =
can
> >   escape the sandbox by controlling the surrounding (non-sandboxed) she=
ll on its
> >   terminal through TIOCLINUX.
> >=20
> > The ping example is not completely made up -- FreeBSD had such a vulner=
ability
> > in its ping utility in 2022[2].  The impact of the vulnerability was mi=
tigated
> > by FreeBSD's Capsicum sandboxing.
> >=20
> > The correct solution for the problem on Linux is to my knowledge to cre=
ate a
> > pty/tty pair, but that is somewhat impractical for small utilities like=
 ping, in
> > order to restrict themselves (they would need to create a sidecar proce=
ss to
> > shovel the data back and forth).  Workarounds include setsid() and secc=
omp-bpf,
> > but they also have their limits and are not a clean solution.  We've pr=
eviously
> > discussed it in [3].
> >=20
> > I do believe that requiring CAP_SYS_ADMIN for TIOCLINUX's TIOCL_PASTESE=
L subcode
> > would be a better approach than so many sudo-style and sandboxing tools=
 having
> > to learn this lesson the hard way.  Can we please reconsider this patch=
?
>=20
> Have you verified that nothing will break with this?

Not yet, but I am happy to try it out.


> If so, it needs to be submitted in a form that could be accepted (this
> one was not, so I couldn't take it even if I wanted to), and please add
> a tested-by from you and we will be glad to reconsider it.

Thanks, will do.

In my understanding from the thread, the outstanding problems that were
discussed were:

 - compatibility with GPM -- I can try this out.
 - clarification of why this is needed -- I hope the additional
   discussion in this thread has clarified this.
 - submittable "form"

By the non-submittable "form", I assume you mean the formatting and maybe
phrasing of the e-mail, so that it can be cleanly applied to git?  Or was t=
here
anything in the code which I missed?

Thanks,
=E2=80=94G=C3=BCnther

--=20
Sent using Mutt =F0=9F=90=95 Woof Woof
