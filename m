Return-Path: <kernel-hardening-return-21709-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id CD82AC00A8F
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Oct 2023 14:29:51 +0000 (UTC)
Received: (qmail 26473 invoked by uid 550); 24 Oct 2023 14:29:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26438 invoked from network); 24 Oct 2023 14:29:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1698157768; x=1698762568; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9St+NC+XD1HvjvLwwsYc0DGwnb1k0QyELVidz1a0GZc=;
        b=L+6yexc+oCGERgulhvTU8vSBcsmKvvmZvJiWoqMtrp2h3H+laDhaZO2ZVW674XHpyT
         hd61xbLFQlQftDYSLL1p54VdUd9I6GmkRtlksusC6S7g39oN8Tkcwcgd9GWMfy3TZz7E
         XQ3AKMgLae+3hwdneXUCqe+Yyz1ezsonf2ArsUdj8CM7qmQ1GPdcJXDLucmI52SMk3xj
         iShxyF69ITxJAiFG/ScEvMWFJqnvD2c0B/GYCiUaHoLZCawcQs/BO5wPPT9Txq9WJNSs
         qmBtbPUbr8bsQqtgoZKS+zkUAPU4Q/ioHq7Q9diUk3TaUzCknl0WLQpNxqyflMT/sGu/
         /Cnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698157768; x=1698762568;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9St+NC+XD1HvjvLwwsYc0DGwnb1k0QyELVidz1a0GZc=;
        b=OIVyNfgzhqvnasoslQAjGgJDTzwbHruLO/Clm7ZxJ8BcxBQNY3gsGEPyBgjO2BGfLJ
         WaXxG0akHujRfnLCKmf9nzKE7oyWWqLzeJnAJRWGNuwWlLM39XoJao2jM8Quj1xMikK1
         x2gqeCvHtfKh416/KRHq82agQfE3t4uy8T9qEkpX+Q+KzXoJKSlV9uhmAo+NsFC0yDCT
         rGfqq3wOS07x5Adn+LEJRbcdroVMx9Ft3ekz8IoAPQFSCud4DsmhUTWladvX1SBwg6Bg
         sBqtAHtcYm7x+e8zygLNekiy57PBXBY5TGUoIZ3PelP503osNjRCd3ky90WMeINwOKcm
         QP9g==
X-Gm-Message-State: AOJu0Yx8GvYzahSpFjP9UD64z4M92siBJQuaYpLQ9jSs8lESRf3AVTL0
	AQ5ZOPlydx6x8WRVGNNqtxaRTLWkufU4JpOREw8o+LLccFWAMVM=
X-Google-Smtp-Source: AGHT+IFtA3/HQ2zpytfREiV5TTig4qKINm6MGhnXPuhthXB33oQqf+csIi0haSBqSrBP/+YD5LoK7hvXQEdKBYlqKfY=
X-Received: by 2002:a25:d38d:0:b0:d9c:2a9c:3f4f with SMTP id
 e135-20020a25d38d000000b00d9c2a9c3f4fmr13007814ybf.62.1698157768313; Tue, 24
 Oct 2023 07:29:28 -0700 (PDT)
MIME-Version: 1.0
References: <Y59qBh9rRDgsIHaj@mailbox.org> <20231024134608.GC320399@mail.hallyn.com>
 <CAHC9VhRCJfBRu8172=5jF_gFhv2znQXTnGs_c_ae1G3rk_Dc-g@mail.gmail.com> <20231024141807.GB321218@mail.hallyn.com>
In-Reply-To: <20231024141807.GB321218@mail.hallyn.com>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 24 Oct 2023 10:29:17 -0400
Message-ID: <CAHC9VhQaotVPGzWFFzRCgw9mDDc2tu6kmGHioMBghj-ybbYx1Q@mail.gmail.com>
Subject: Re: Isolating abstract sockets
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Stefan Bavendiek <stefan.bavendiek@mailbox.org>, kernel-hardening@lists.openwall.com, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 24, 2023 at 10:18=E2=80=AFAM Serge E. Hallyn <serge@hallyn.com>=
 wrote:
> On Tue, Oct 24, 2023 at 10:14:29AM -0400, Paul Moore wrote:
> > On Tue, Oct 24, 2023 at 9:46=E2=80=AFAM Serge E. Hallyn <serge@hallyn.c=
om> wrote:
> > > On Sun, Dec 18, 2022 at 08:29:10PM +0100, Stefan Bavendiek wrote:
> > > > When building userspace application sandboxes, one issue that does =
not seem trivial to solve is the isolation of abstract sockets.
> > >
> > > Veeery late reply.  Have you had any productive discussions about thi=
s in
> > > other threads or venues?
> > >
> > > > While most IPC mechanism can be isolated by mechanisms like mount n=
amespaces, abstract sockets are part of the network namespace.
> > > > It is possible to isolate abstract sockets by using a new network n=
amespace, however, unprivileged processes can only create a new empty netwo=
rk namespace, which removes network access as well and makes this useless f=
or network clients.
> > > >
> > > > Same linux sandbox projects try to solve this by bridging the exist=
ing network interfaces into the new namespace or use something like slirp4n=
etns to archive this, but this does not look like an ideal solution to this=
 problem, especially since sandboxing should reduce the kernel attack surfa=
ce without introducing more complexity.
> > > >
> > > > Aside from containers using namespaces, sandbox implementations bas=
ed on seccomp and landlock would also run into the same problem, since land=
lock only provides file system isolation and seccomp cannot filter the path=
 argument and therefore it can only be used to block new unix domain socket=
 connections completely.
> > > >
> > > > Currently there does not seem to be any way to disable network name=
spaces in the kernel without also disabling unix domain sockets.
> > > >
> > > > The question is how to solve the issue of abstract socket isolation=
 in a clean and efficient way, possibly even without namespaces.
> > > > What would be the ideal way to implement a mechanism to disable abs=
tract sockets either globally or even better, in the context of a process.
> > > > And would such a patch have a realistic chance to make it into the =
kernel?
> > >
> > > Disabling them altogether would break lots of things depending on the=
m,
> > > like X :)  (@/tmp/.X11-unix/X0).  The other path is to reconsider net=
work
> > > namespaces.  There are several directions this could lead.  For one, =
as
> > > Dinesh Subhraveti often points out, the current "network" namespace i=
s
> > > really a network device namespace.  If we instead namespace at the
> > > bind/connect/etc calls, we end up with much different abilities.
> >
> > The LSM layer supports access controls on abstract sockets, with at
> > least two (AppArmor, SELinux) providing abstract socket access
> > controls, other LSMs may provide controls as well.
>
> Good point.  And for Stefan that may suffice, so thanks for mentioning
> that.  But The LSM layer is mandatory access control for use by the
> admins.  That doesn't help an unprivileged user.

Individual LSMs may implement mandatory access control models, but
that is not an inherent requirement imposed by the LSM layer.  While
the Landlock LSM does not (yet?) support access controls for abstract
sockets, it is a discretionary access control mechanism.

I'm not currently aware of a discretionary access control LSM that
supports abstract socket access control, but such a LSM should be
possible if someone wanted to implement one.

--=20
paul-moore.com
