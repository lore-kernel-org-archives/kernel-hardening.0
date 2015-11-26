Reply-To: kernel-hardening@lists.openwall.com
References: <1448401114-24650-1-git-send-email-keescook@chromium.org>
 <CA+rthh-euk2hGGWjsDqXogWSmzmJNV1aiUVfnTfrzyQhndgbOQ@mail.gmail.com>
 <56558826.1060202@ladisch.de>
From: Daniel Micay <danielmicay@gmail.com>
Message-ID: <565723F6.30708@gmail.com>
Date: Thu, 26 Nov 2015 10:23:34 -0500
MIME-Version: 1.0
In-Reply-To: <56558826.1060202@ladisch.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rCBtpNRBd2vj82WdAsPt6Ao38TKlgb37x"
Subject: Re: [kernel-hardening] [PATCH 0/2] introduce post-init read-only
 memory
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rCBtpNRBd2vj82WdAsPt6Ao38TKlgb37x
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 25/11/15 05:06 AM, Clemens Ladisch wrote:
> Mathias Krause wrote:
>> [...]
>> So, prior extending the usage of the __read_only annotation some
>> toolchain support is needed. Maybe a gcc plugin that'll warn/error on
>> code that writes to such a variable but is not __init itself.
>=20
> Or mark them as "const".  This would require the initialization code to=

> cast it away, probably with a helper macro.
>=20
>=20
> Regards,
> Clemens
>=20

That would be undefined. It would only be safe if you exposed a const
pointer as the only way of accessing a non-const variable. It would be
silly to mangle the code simply to get a warning as it should be easy
enough to add to GCC. The usefulness isn't just limited to the kernel
either.


--rCBtpNRBd2vj82WdAsPt6Ao38TKlgb37x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWVyP8AAoJEPnnEuWa9fIq+VUP/1+5jlskFs92BXQ557/jjLJ+
cceZIF17TKuGkx3b1eSsaAo/vsbjU7pOLDsCGXvxGpNU/YSMI3EglwaAT9f0+91v
EfHVbVOgQfKgndk9BcavhRhz5LYKUjuYqbbs+8wR0y2GPfPhwL5q6ESHJYtgtkW4
QwDhJEyhR0/a8EnK3p4vUOj3cJ0BGrTNsHKBC5bbTLgJL47ssksI57LGrhrAxQOT
LRdhtlewAMRVH9uz1BfrITJVDB0kfONA9wVGL5/BKAw5plhNpxwiiV0V530RUarN
iRzddzUN4Jm38yH2AHhxIWtfi96in1edAsysZg8z0+Pv39Jhdk2vjZCB7EOKiBzx
olKPip2wunrmDfzsI6JHEw7golWKFJBm7e1HHPqlfFyOzMNe8DKKXwyucZOWdMzj
32+S2Q9V8ao+XHcjvaeGCbGPcxoz+G+IBJojwAU0Ddc9lC2cIHStmE+1EMIGZlzM
vNjrbqvFO66iC21pcGf5Pl+1ar6Bj0dSNIhOObfNcAjACUPibc666uJyjTl5cih5
9o1FBXBnD604bf0LH7F0qYFLBgCqBm1KfyBI8+HTsn3X6J4M2Qr+yfrpnWi3/vxR
GmMQdW7YTdqycvyNlJPSC12XBT02iX7wiKyHxUmDG3BxTjGH/TyWlSP7ihcB4lFz
gfjQ2mtmC3tvfOakbX+V
=ORk2
-----END PGP SIGNATURE-----

--rCBtpNRBd2vj82WdAsPt6Ao38TKlgb37x--
