Return-Path: <kernel-hardening-return-21654-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 3165FC76188
	for <kernel-hardening@archiver.kernel.org>; Tue,  4 Apr 2023 21:55:27 +0000 (UTC)
Received: (qmail 7651 invoked by uid 550); 4 Apr 2023 21:55:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7616 invoked from network); 4 Apr 2023 21:55:16 -0000
Date: Tue, 04 Apr 2023 21:54:50 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.ch;
	s=protonmail3; t=1680645304; x=1680904504;
	bh=NpQ92rNGfAqVgwg/jEbrLTBw0yxaLRnii1wIBG4JYYY=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=fVUcn5P8FXGrSa403ClzGxpYot7ohBiim7KDq5cYllyoW/vDwKGplguC9Zhf49aKB
	 g7bfg2jTs2jRo7CmZ4+P50pZunS3czZukjr4neaQeQoZb3Js+KWR4A2LKG4J0UPtvd
	 aQ5XL/FkkgLecSFzFCOVM4kP9PJxWBSUgDAQeGKqroEJXpeLx1mfDWblc3RJb8RcWy
	 i4iXGswj6SKhgU4FnfazB1hVTgil/99bjbACV/o3fF6IAA3yL0LrkBLz1qVzvBNHFI
	 +vSq/r0ZOxNkgmFGB16i0cW1cD4UsWum3pebtvtn0st48H6MssM47N9ZsSxbZa48/U
	 eSaCTVRiNZKww==
To: Greg KH <gregkh@linuxfoundation.org>
From: Jordan Glover <Golden_Miller83@protonmail.ch>
Cc: =?utf-8?Q?Hanno_B=C3=B6ck?= <hanno@hboeck.de>, kernel-hardening@lists.openwall.com
Subject: Re: [PATCH] Restrict access to TIOCLINUX
Message-ID: <FOFeJXer4RVQAe5RPxTFP5O4QbHgzTJ-HjZSftfcdO9dK5OMKEfaD2iJ8BiOWxtzfbpGl_t0hcsPrQToQ72Dc3D3seQ5joggnqEmuKOLBcg=@protonmail.ch>
In-Reply-To: <2023040237-empty-etching-c988@gregkh>
References: <20230402160815.74760f87.hanno@hboeck.de> <2023040232-untainted-duration-daf6@gregkh> <20230402191652.747b6acc.hanno@hboeck.de> <2023040207-pretender-legislate-2e8b@gregkh> <20230402193310.0e2be5bb.hanno@hboeck.de> <2023040237-empty-etching-c988@gregkh>
Feedback-ID: 3367390:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Sunday, April 2nd, 2023 at 7:44 PM, Greg KH <gregkh@linuxfoundation.org>=
 wrote:


> On Sun, Apr 02, 2023 at 07:33:10PM +0200, Hanno B=C3=B6ck wrote:
>=20
> > On Sun, 2 Apr 2023 19:23:44 +0200
> > Greg KH gregkh@linuxfoundation.org wrote:
> >=20
> > > > Do you have other proposals how to fix this issue? One could
> > > > introduce an option like for TIOCSTI that allows disabling
> > > > selection features by default.
> > >=20
> > > What exact issue are you trying to fix here?
> >=20
> > The fact that the selection features of TIOCLINUX can be used for
> > privilege escalation.
>=20
>=20
> Only if you had root permissions already, and then go to try to run
> something using su or sudo as someone with less permission, right?
>=20
> And as you already had permissions before, it's not really an
> excalation, or am I missing something?
>=20
> > I already mentioned this in the original patch description, but I think
> > the minitty.c example here illustrates this well:
> > https://www.openwall.com/lists/oss-security/2023/03/14/3
> >=20
> > Compile it, do
> > sudo -u [anynonprivilegeduser] ./minitty
> >=20
> > It'll execute shell code with root permission.
>=20
>=20
> That doesn't work if you run it from a user without root permissions to
> start with, right?
>=20
> thanks,
>=20
> greg k-h

The problem in the example is that sudo executed unpriv process which then =
re-gained the privs of sudo itself. It doesn't need to be sudo or even root=
 - the same problem affects all containers/sandboxes (privileged or not) in=
 linux - the (supposedly) contained process can use TIOCSTI/TIOCLINUX to br=
eak out of the container/sandbox (unless they're blocked as well).

BTW: you seem in favor of restricting TIOCSTI [1] which landed in kernel so=
 why suddenly question same problem here?

[1] https://lore.kernel.org/all/Y0pIRKpPwqk2Igu%2F@kroah.com/raw
