Reply-To: kernel-hardening@lists.openwall.com
References: <CAHfkTQF33M8eqAPUr3wTDe-yB4k_MLSfMtAfPWW=AhA9aQdtmQ@mail.gmail.com>
 <CAFLxGvxukmvg9jHWXO=-Bbn3eoNrqwFvWsS-v_R99McPU4n_sg@mail.gmail.com>
 <56496AB0.5070905@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Message-ID: <56496D65.8030903@gmail.com>
Date: Mon, 16 Nov 2015 00:45:09 -0500
MIME-Version: 1.0
In-Reply-To: <56496AB0.5070905@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="AHfr7MMSgnu7JrdjBQhu72RNKNat5P3Jn"
Subject: Re: [kernel-hardening]
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--AHfr7MMSgnu7JrdjBQhu72RNKNat5P3Jn
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

> I really can't see Linus and others being okay with any GCC
> plugins with alterations to the semantics of C rather than just codegen=

> like the KERNEXEC plugin.

Oh and REFCOUNT is basically the same situation. I can't see any
possibility of that landing without switching to having a refcount_t
type and having separate functions for working with it, with a
configuration option like DEBUG_REFCOUNT to flip on overflow checks.
It's a whole bunch of busy-work and since it will touch so much code it
will run into the same problems that the previous attempts to upstream
constification did.


--AHfr7MMSgnu7JrdjBQhu72RNKNat5P3Jn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWSW1lAAoJEPnnEuWa9fIqZB4P/jS+w2zLLeMPLeDNDBo8FAV3
NvbMRrjOm1gLVmj2PPUJj9l9N8O5kaSUCmvZ5HNNEhWl98CnhP9iedOCUukCB+x/
93owCEc0n7NTpvETxq9jLzC+QOsKbMmpOX6HLsEeH7HZIh6X8R2tp3N3mu772NSr
xXv1X5JdpSrCXiWny6J0DG+ShXbkmfAbwXXY2t3yu+Xr4PFyzN5i0nnu390L9wCi
LnyiPwcUiM5HWwZ7E3iFmgCPwUUvv2wJJMyLlfsF85/m8knZhV43zX1VcrrLXAnZ
/9k4Q4QwYWdMC/Yq4mGuIvyYssC4BaWWoeoSqfsGAeXWdKG0DfNw7I+8i+Umy0uH
uun6tAQhGPpARhfCX//eMhG4lVHknOkFQerfjf/RxU8q+M7irhPKmJBfRJKkFpaS
qBow4T32rSk4+/gWIz5sZ5Z5tDPk4WdGZtM77K8+B+y2gDRJdBglZO5COo6vpAJQ
OzaHRMlcMZ986+l3fmAAaNF4RAECpEQf0teHPUl+MRQR048pK4I6YoFMlAsmowYj
tdvJTi1Q4+UcUFTOTZ4D9mQxcJ7S0f9mUGepFFTTFxlNotezScXM+PxRT8qtMH9O
WNCULuvsJ8A95XqQK6j03uPLQXLpycjbF8CgquvFXYuDnCpBnEGea+AAnYLo19Se
HLKhkBy1wstv0NXhiI9E
=3xF0
-----END PGP SIGNATURE-----

--AHfr7MMSgnu7JrdjBQhu72RNKNat5P3Jn--
