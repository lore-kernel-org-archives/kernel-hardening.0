Return-Path: <kernel-hardening-return-21544-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by smtp.lore.kernel.org (Postfix) with SMTP id 62382C433EF
	for <kernel-hardening@archiver.kernel.org>; Sat,  5 Feb 2022 11:32:12 +0000 (UTC)
Received: (qmail 3452 invoked by uid 550); 5 Feb 2022 11:32:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25871 invoked from network); 5 Feb 2022 07:58:13 -0000
Date: Sat, 5 Feb 2022 10:57:58 +0300
From: "Anton V. Boyarshinov" <boyarsh@altlinux.org>
To: Christian Brauner <brauner@kernel.org>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
 ebiederm@xmission.com, legion@kernel.org, ldv@altlinux.org,
 linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
 Christoph Hellwig <hch@lst.de>, Linus Torvalds
 <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Add ability to disallow idmapped mounts
Message-ID: <20220205105758.1623e78d@tower>
In-Reply-To: <20220204151032.7q22hgzcil4hqvkl@wittgenstein>
References: <20220204065338.251469-1-boyarsh@altlinux.org>
	<20220204094515.6vvxhzcyemvrb2yy@wittgenstein>
	<20220204132616.28de9c4a@tower>
	<20220204151032.7q22hgzcil4hqvkl@wittgenstein>
Organization: ALT Linux
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-alt-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=D0=92 Fri, 4 Feb 2022 16:10:32 +0100
Christian Brauner <brauner@kernel.org> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:


> > It turns off much more than idmapped mounts only. More fine grained
> > control seems better for me. =20
>=20
> If you allow user namespaces and not idmapped mounts you haven't reduced
> your attack surface.

I have. And many other people have. People who have creating user
namespaces by unpriviliged user disabled. I find it sad that we have no
tool in mainline kernel to limit users access to creating user
namespaces except complete disabling them. But many distros have that
tools. Different tools with different interfaces and semantics :(

And at least one major GNU/Linux distro disabled idmapped mounts
unconditionally. If I were the author of this functionality, I would
prefer to have a knob then have it unavailible for for so many users. But a=
s you wish.

> An unprivileged user can reach much more
> exploitable code simply via unshare -user --map-root -mount which we
> still allow upstream without a second thought even with all the past and
> present exploits (see
> https://www.openwall.com/lists/oss-security/2022/01/29/1 for a current
> one from this January).
>=20
> >  =20
> > > They can neither
> > > be created as an unprivileged user nor can they be created inside user
> > > namespaces. =20
> >=20
> > But actions of fully privileged user can open non-obvious ways to
> > privilege escalation. =20
>=20
> A fully privileged user potentially being able to cause issues is really
> not an argument; especially not for a new sysctl.
> You need root to create idmapped mounts and you need root to turn off
> the new knob.
>=20
> It also trivially applies to a whole slew of even basic kernel tunables
> basically everything that can be reached by unprivileged users after a
> privileged user has turned it on or configured it.
>=20
> After 2 years we haven't seen any issue with this code and while I'm not
> promising that there won't ever be issues - nobody can do that - the
> pure suspicion that there could be some is not a justification for
> anything.

