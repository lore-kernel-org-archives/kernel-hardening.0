Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 8 Jun 2016 20:47:58 -0400
From: Brad Spengler <spender@grsecurity.net>
Message-ID: <20160609004758.GA8658@grsecurity.net>
References: <1465420302-23754-1-git-send-email-keescook@chromium.org>
 <1465420302-23754-2-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
In-Reply-To: <1465420302-23754-2-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] Re: [PATCH v2 1/4] mm: Hardened usercopy
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey.schaufler@intel.com>, Rik van Riel <riel@redhat.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> diff --git a/mm/usercopy.c b/mm/usercopy.c
> new file mode 100644
> index 000000000000..e09c33070759
> --- /dev/null
> +++ b/mm/usercopy.c
> @@ -0,0 +1,177 @@
> +/*
> + * This implements the various checks for CONFIG_HARDENED_USERCOPY*,
> + * which are designed to protect kernel memory from needless exposure
> + * and overwrite under many conditions.
> + */

As this is a new file being introduced which is (modulo some bikeshedding
and addition of a few comments) a direct copy+paste of our code and comments
in fs/exec.c, I would appreciate both a GPL notice (the same as exists for
KASAN, etc) and both the PaX Team and myself being listed as the copyright
owners.

-Brad

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJXWLy3AAoJEETRwPglJf5JOacP/jF5D/k8Og17BJCu+aqtNcdf
8MyXDDfmxby/z7ISwQpDBQH4SqY3VaI47UCIv+/2e23R8Fjo/yp7ExcExE+44NMZ
S2I0kj+nE0O2DzcaNlPHT4AMTdJZXy8pYLmvugCljXq5OPs+odhgfsZwHDmHa2qE
4C3qExOlMJZCiw1X/e1+o/qkUT0r/E1EGv9OJnQzlraV9Xpn5E2dTKHfV78LsSxt
0rzpMUereXGr2NkyRnlqk3AVmnGAQaSDjDfj8NMAjPSul40uKr+oKZlrqECOrbhd
jzjgH0XGmCJ3dH7o8a8sIGmCs7rsX6iSPngLnNpLfgX6IdwpY0GRhoFDNiHovtmV
Qg1Qeo1cz5sCp3/YO36ttu3aaea1m2e280WicFZ14VnQswQ/ZpwfCo+nEyx0xrhh
nPGYVv0OYDhXt+EfHmHkIrlYa67x5DAWL2dRlzvAB+poe8sUBpj/bRWiBHYr5sl/
m5yConsY0haTrlGrZ2OeRKT437OVpAwg7VGb9jOwcggeglF3G3up7uVKzB00Vihi
awZA2qPeXOCB75LJGoNUEvP6Z3BAZyDrGvByDe8Xm5dlvizGs9LkTe7rV2s7pMqE
h6fEPob55lJUbxcpaxkgmJA17Hcf2DLAw/BC38JfFP+9NhG/a94TzhVQusPT27Qx
+E1S/FnqjEQVeqwcZGj2
=DeUt
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
