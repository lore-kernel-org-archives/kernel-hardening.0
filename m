Message-ID: <1495724872.20270.46.camel@redhat.com>
From: Rik van Riel <riel@redhat.com>
Date: Thu, 25 May 2017 11:07:52 -0400
In-Reply-To: <85inkpie9o.fsf@boum.org>
References: 
	<CAFwXZv_b3hdEA4xOFKqAVfc4UZEBX=dL9DOY_mDHExsW+Qg6tQ@mail.gmail.com>
	 <85inkpie9o.fsf@boum.org>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-UatAolcKaw/hcFyso4Vz"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Patch for random mac address
To: intrigeri <intrigeri@boum.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--=-UatAolcKaw/hcFyso4Vz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2017-05-25 at 09:31 +0200, intrigeri wrote:
> Hi,
>=20
> HacKurx:
> > Because this would be useful for distributions like Tails, Subgraph
> > OS, Kali Linux and other ...
>=20
> For what it's worth, it's unlikely that Tails ever uses this unless
> it
> can be controlled at runtime from userspace: we need to give users an
> option to disable MAC address randomization, because it breaks
> network
> connectivity in some cases.

That suggests maybe this kind of functionality should
be implemented in userspace, instead?

Maybe in NetworkManager, or whatever Tails uses to
manage the network. After all, setting the MAC address
to something else is already supported by the kernel...

--=20
All rights reversed
--=-UatAolcKaw/hcFyso4Vz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJZJvNIAAoJEM553pKExN6DQv0H/Rf4o01IgXvK7l3xhDFX0ga4
Cwf2mp+58bdl3tEBrFw6pqwvi1svLQqcVt/x+QJB6bXgi2L1kxm++VnNF/fSgW3D
Zlp5at/2KwJeJmuzPWxgeQ6WvnK3xBfbshj80h6uIUR2WufRcuxgc2eWdtMxSW3c
TjGJxU9N3k5FFZCg3X2AUOssOFadx4bntEQwu1b7gnzpiDWiqWs3eAZsBUZR/Bq9
gRkSl71a241pJd4FWOEUbQNK/zOW1Xf7OxG51NyUicDXCvtEmsRovHJRuze5qA7R
nbTkd3Po2EFXP3Yzas3T49lPN/a0uUQMDnB+yIT2dcJEb1cMilepHE4nUtAYlz4=
=h/Ik
-----END PGP SIGNATURE-----

--=-UatAolcKaw/hcFyso4Vz--
