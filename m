Reply-To: kernel-hardening@lists.openwall.com
References: <CAGXu5jJ3FgxXK9WuOLRwnEq=y4dS+CTm+WQBxWe3sYZ7e9p6Gg@mail.gmail.com>
 <n1iirh$q7o$1@ger.gmane.org>
 <CAGXu5j+ponF+a3aoCnLqEVfBy545BsxT4w=8KGikNCb_24ZgyQ@mail.gmail.com>
 <n1khkt$lc7$1@ger.gmane.org> <87h9kvze0o.fsf@rasmusvillemoes.dk>
 <20151109103315.GB19735@chrystal.uk.oracle.com>
 <87bnb3ou1c.fsf@rasmusvillemoes.dk>
 <CAGXu5jLST1eoNU3YF-kLnTOHcq6iyD8YbS=oGr+3p2eFsz-X=A@mail.gmail.com>
 <c3c5f9857a782b1d4405272f08ce5b3d@opensec.fr>
 <29498.1447107624@turing-police.cc.vt.edu>
 <d5b6cf123db60902d480129396d0a8fb@opensec.fr>
From: Daniel Micay <danielmicay@gmail.com>
Message-ID: <56459A43.3020400@gmail.com>
Date: Fri, 13 Nov 2015 03:07:31 -0500
MIME-Version: 1.0
In-Reply-To: <d5b6cf123db60902d480129396d0a8fb@opensec.fr>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GpBL3FNGXCO88sxowg2sIafvWCaiNXNVo"
Subject: Re: [kernel-hardening] Binary blobs
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GpBL3FNGXCO88sxowg2sIafvWCaiNXNVo
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

> all hardened options for GCC.

Well, you probably can't get away with -fsanitize=3Dundefined
-fsanitize-undefined-trap-on-error yet (object-size and
signed-integer-overflow checks specifically). I know what you mean
though :).


--GpBL3FNGXCO88sxowg2sIafvWCaiNXNVo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWRZpDAAoJEPnnEuWa9fIq5EgQAIaVWcWz1BG467riGFGI4D3V
57VzflOmQNfiSHgtIVFXK1FLyrvQ9c772FnBkK1BLoR82Yzy3DLwwghbfto/FldT
Ac7E9I4yB/h06gN5HkIFqRJjUO5jHtoSd72rC8BFoEjNnfgcXboPOKq61kp0AZ0g
iYuAAvSdo1fmYzYIQld1XCFx4UYx7em7RGbyqzTIhJaktkn7YLRax6bIU/NPvyBb
tapzlWvI1J9mEY+YpmVwOREs85gMizWhB/sVId86onwSP1KfPA74ToNmnRi75y4V
58ocE2kL8ygXwo8P2sVNr2W0ZsWlgsnzBKMQ/pKbJYhWPdzoGNa1n4ZACKjAAMh+
ewCuMVzh924jZDZP1RZfbLKTP7gflaK+tpSnFzaAEpoIt1d9CZWJjxzJkJsH6Vfg
VhIXI3wxffTuNfRIrmG2OYLKnKU5zY38QprBuOF4tM6f1Pe6/O+G5/52YG2pMZy0
pvPv3qRGMg5uf1VW/+war74zcCL1pA5VXjDPJB3NSEZv01y+GDly9QQqRx+Jn22l
3uCwI7fqd7YMBvHYRDyeEfDZX+RBxYdn/DrrOSyTSkZaIEKzV+gI9E3KaqgQ98L3
g9Xw+kzMtehYBESLHjBH+aQzfOmbpCVHZOT0RFUUJQIdE7H5GWoschoXcJ//Wo+E
KPzPNQqKuPBFAdFBdZVr
=CP6b
-----END PGP SIGNATURE-----

--GpBL3FNGXCO88sxowg2sIafvWCaiNXNVo--
