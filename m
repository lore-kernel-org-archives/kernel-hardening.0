Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1479309777.21171.27.camel@redhat.com>
From: Rik van Riel <riel@redhat.com>
Date: Wed, 16 Nov 2016 10:22:57 -0500
In-Reply-To: <CAAseMr6Fae=4otZZX9HmO1YgehjsVmd+44G5RN7Wu8iF2+fruA@mail.gmail.com>
References: 
	<CAAseMr6Fae=4otZZX9HmO1YgehjsVmd+44G5RN7Wu8iF2+fruA@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-btl9V1LYpEubIenb0//U"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] patches for __write_rarely section
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>


--=-btl9V1LYpEubIenb0//U
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2016-11-16 at 22:39 +0800, Gengjia Chen wrote:
> Hello kees and everyone :
>=20
> This email introduces two patches.
>=20
> Patch 1 introduce the write-rarely memory section for
> those kernel objects which are read only mostly=C2=A0
> but need to be written to sometimes.
>=20
> Patch 2 introduce two helper functions (mark_wrdata_rw/
> mark_wrdata_ro) to make __write_rarely memory section
> writable or unwritable. They play like the pax_open_kernel/
> pax_close_kernel functions in grsecurity patch.Right now=C2=A0
> this only been implemented on arm32.

Is this the way we want to go with this, or could it
make more sense to have a special ELF section in the
kernel that is allowed to write to write-rarely memory,
and have the exception handler deal with writes coming
from that code?

That way it would be much harder to insert code into the
kernel that calls your mark_wrdata_rw/mark_wrdata_ro
functions.

--=20
All Rights Reversed.
--=-btl9V1LYpEubIenb0//U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJYLHnRAAoJEM553pKExN6Dcf8IAIeMQSlHhGtoFWZfo97GPV6H
regGve/BA5d2XPTCzyKLs4iU1NQED8DkIKtGaSVVwbFX+RZzhtX53Egk7AFECt5y
OpG90CoeqUamjTgcQmm8KeW8uDYJXo48Xvxzit68ggya5F+1BCEhPl0sqXEErG6l
wsOjYeWG8hSgLR6FGXjEFsVVPgEaloKk3W3escVFxxqtbKwqyZ2HnOoozlKFr2of
bDbBb3osssOlgiouBahJuSMQM0JPmOQmNtp3DFv57fy6hk53rgiLPJFhvh7XnTSL
iIje/X9f86phCEoKCP25V8Qrz4TrCbmmeOibvUZ/a6EVhQo/6QUk8fB2TQSaMGg=
=Pkky
-----END PGP SIGNATURE-----

--=-btl9V1LYpEubIenb0//U--
