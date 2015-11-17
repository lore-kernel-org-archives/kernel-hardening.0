Reply-To: kernel-hardening@lists.openwall.com
From: Daniel Micay <danielmicay@gmail.com>
Message-ID: <564ADBDA.10901@gmail.com>
Date: Tue, 17 Nov 2015 02:48:42 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cN15ibSSKdUfcIDeUkMnQsPWfIuuFhcNb"
Subject: [kernel-hardening] What ever happened to the kernel UBSan work?
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cN15ibSSKdUfcIDeUkMnQsPWfIuuFhcNb
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

I remember seeing the UBSan submission at one point but it appears that
it never landed. It would be really nice to have it because among other
things it will encourage fixing all kinds of things that conflict with
features like SIZE_OVERFLOW and soon RAP. Maybe the kernel could even
begin migrating away from relying on signed overflow (by marking the
cases of intentional overflow with wrappers around the overflow
intrinsics like addw(a, b)).

There are also some niches where a 20% performance hit for something
like this makes sense (maybe only ~10% for just the parts that are
relevant to security, especially if it's just set to trap instead of
calling functions producing debug output).


--cN15ibSSKdUfcIDeUkMnQsPWfIuuFhcNb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWStvaAAoJEPnnEuWa9fIqkDIP/1wX/5+ItifZbBx2Tk/HQauq
tFr4ht1N7xPjDpZhnqsm7tuvplbggcTUiXAId2YUS5XrLKyXr42f9+0Tfxl6eIVN
71oCREkiRGFqgN4pAYYLPQq16I0NhbS+vgWO1SYpdZy0cJQEiLYGQw0F/XYqBjbb
qFmz9yTjGLKmwAjVafYc4Pu7z5XCVLsNe9FhbUHKZ3RV8eymdzdLvqCDHwCrTAT0
WwIG1I2boTsyRvUjvG45DJdckc/TLOyi9+IXVSlu6a02dFkPUiQhdN0eWVlzfDW/
m20likrDFUrz9U/r+M9VcNW9PJwKrctmN9SHiKUj43OQDopi322rBtvGsAe5NrPe
1BXBg6bwc08n9XsEThjzqdRVyBLMV2atf/wEq3LRAXFzb5vGQaiTuqQedrmxBMx7
MhoMi7DmCYpWxvgaTkP3Tsbf2J03sRo02raCmkWyu96Hfew1yGE3I133vrNNaCxm
g2DVKkWsb2hjymQg3UotLupfiJCfPVZhByKfohOllKTTKwHt6FsXTJvfmstYtW9B
LG5aWDTvTo8EQZlsYfI+5wl2TF5Zr/TisUGSwUdDCNoIMvB6Mf6PEhPr5HP+O0UL
gzhzUKToLfbbVQzlzRlH5z6+aEPl3D+PPHHL5Eeg6pHPhQp55wX5vnLImUt1VAHY
D3h/IFxO8Bi1ToF7JSgH
=724r
-----END PGP SIGNATURE-----

--cN15ibSSKdUfcIDeUkMnQsPWfIuuFhcNb--
