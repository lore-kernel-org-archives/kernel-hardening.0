Date: Fri, 2 Mar 2018 21:40:06 +0000
From: James Hogan <jhogan@kernel.org>
Subject: Re: [PATCH] signals: Move put_compat_sigset to compat.h to silence
 hardened usercopy
Message-ID: <20180302214005.GC4197@saruman>
References: <1515636190-24061-1-git-send-email-keescook@chromium.org>
 <1519059306-30135-1-git-send-email-matt.redfearn@mips.com>
 <CAGXu5jKtrJ6Nmses_pM-qkXAkOPXAxwT+V3B+omqu0tx4xEh8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="DIOMP1UsTsWJauNi"
Content-Disposition: inline
In-Reply-To: <CAGXu5jKtrJ6Nmses_pM-qkXAkOPXAxwT+V3B+omqu0tx4xEh8w@mail.gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Matt Redfearn <matt.redfearn@mips.com>, "Dmitry V . Levin" <ldv@altlinux.org>, Al Viro <viro@zeniv.linux.org.uk>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux MIPS Mailing List <linux-mips@linux-mips.org>
List-ID: <kernel-hardening.lists.openwall.com>


--DIOMP1UsTsWJauNi
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 19, 2018 at 03:55:27PM -0800, Kees Cook wrote:
> On Mon, Feb 19, 2018 at 8:55 AM, Matt Redfearn <matt.redfearn@mips.com> w=
rote:
> > Move put_compat_sigset to compat.h, and mark it static inline. This
> > fixes the WARN on MIPS.
> >
> > Fixes: afcc90f8621e ("usercopy: WARN() on slab cache usercopy region vi=
olations")
> > Signed-off-by: Matt Redfearn <matt.redfearn@mips.com>
>=20
> Thanks for the catch and fix!
>=20
> Acked-by: Kees Cook <keescook@chromium.org>

Thanks Kees. I've applied this on the assumption nobody objects to it
going via the MIPS tree.

Cheers
James

--DIOMP1UsTsWJauNi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEd80NauSabkiESfLYbAtpk944dnoFAlqZxLUACgkQbAtpk944
dnpRvw//YigCAwd1TNaLZzn3MXVqAOXsY6IAtAe7QASbMi+ovlu53XBYP74R+Kxp
8wgjmdA9SO8KjqUMWoi/M1fLnhVy/CFVE0rh4mU/4S/c3rN1gOcAAqI9C8AKApF/
yZqF40/3/1z9VzoRA3BXOcBI11iBkRbUWf3T70q0/OPlCS8eIM4dsGyRxbWPYVqs
2yYjagOQfccH68ZUPoHcWjgla5LgsreC5YPoVPtgjJO9ECxG0zFq4hcCRCUWInnu
iklEJ+E5Y/6YrwmiwiqLK3QqByKRNveXVJHnfgM07Y0C5dYPpKW1dTUxzb46A5GN
YK5IcIvaV/fzD5Q8o/ri5lu/ZmCIla5sy7CJ8hICDWWONuSBNFdqqhqCssNCAkT8
OxAHhaI4gLH4oBWRUok2ycyf/5i2BRP/zgPKVJyuTVQ/c8lurYZd51CzcPZaY558
p7FSo1YyZRp2+W6pMyqCp5Gq/BB5zu2pLKh3aB7xK8PpQxI0MDp90vG2edBZ4Qhb
LlIvcbUABn37OqvsaVvmh4XFtk3a5pFZIeBZvj6+n7+CmNHs5GVypOpqDfb92TA7
jHE4yjrvx6cDB5mZUezdinB3HRJKDr2ojvAkf7DPYrN2bina9jt6HnTcjc+DzhYj
WLT3w3H4tQGrg+AQegMo/KCUWzY3u3pqT7OR96JKp5jT/AuGfAk=
=4IQq
-----END PGP SIGNATURE-----

--DIOMP1UsTsWJauNi--
