Reply-To: kernel-hardening@lists.openwall.com
From: "Reshetova, Elena" <elena.reshetova@intel.com>
Date: Mon, 10 Oct 2016 06:02:16 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41BDCAF6@IRSMSX102.ger.corp.intel.com>
References: <1476016472.2329.38.camel@cvidal.org>
 <CE954033-54F3-47AE-9788-B26B9CE45401@gmail.com>
 <1476040182.2329.72.camel@cvidal.org> <20161009193731.GD14666@pc.thejh.net>
In-Reply-To: <20161009193731.GD14666@pc.thejh.net>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: RE: [kernel-hardening] self introduction
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Colin Vidal <colin@cvidal.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Oct 09, 2016 at 09:09:42PM +0200, Colin Vidal wrote:
> Hi David,
>=20
> > If you're interested, the HARDENED_ATOMIC team is looking for people=20
> > to help porting the feature to other architectures.=A0=A0ARM is a=20
> > reasonable candidate for someone new to the project.=A0=A0I have begun=
=20
> > this effort myself, but if you'd like to collaborate I'd be=20
> > grateful.
>=20
> Sounds good!
>=20
> > It essentially involves porting the original arch-specific features=20
> > from PAX_REFCOUNT into Elena Reshetova's official HARDENED_ATOMIC=20
> > tree, which can be found at=20
> > https://github.com/esreshetova/linux-stable
>=20
> The link seems broken (https://github.com/esreshetova too). I found=20
> https://github.com/dwindsor/hardened-atomic but it is empty. Did I=20
> miss something/Github filter?

>Typo in the link, I think?
>https://github.com/ereshetova/linux-stable

This branch to be precise:=20
https://github.com/ereshetova/linux-stable/tree/hardened_atomic_on_next=20

This is where the latest code for linux-next is hosted now and where we wor=
k with David and Hans.=20

> > Please contact me if you have any questions; I'd be glad to help!
>=20
> I actually have question. :-) As far as I understand, PAX_REFCOUNT [1]=20
> is mainly a x86-only

>No, PAX_REFCOUNT also supports a bunch of other architectures. As far as I=
 can tell from a quick look: ARM, MIPS, PowerPC and SPARC.

Yes, just in our patch series we only made implementation for x86. But if y=
ou look into Grsecurity/PaX patches, it has support for others implemented.=
=20
