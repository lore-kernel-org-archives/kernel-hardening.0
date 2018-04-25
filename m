Date: Wed, 25 Apr 2018 11:16:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [patch V3 01/10] rslib: Add GFP aware init function
Message-ID: <20180425111617.2f4dc127@canb.auug.org.au>
In-Reply-To: <20180422162512.363154748@linutronix.de>
References: <20180422162345.004292133@linutronix.de>
	<20180422162512.363154748@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/FEjP3biZc_p55XmvXMS7DkJ"; protocol="application/pgp-signature"
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Segher Boessenkool <segher@kernel.crashing.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linuxfoundation.org>, Boris Brezillon <boris.brezillon@free-electrons.com>, Richard Weinberger <richard@nod.at>, David Woodhouse <dwmw2@infradead.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>, Neil Brown <neilb@suse.com>
List-ID: <kernel-hardening.lists.openwall.com>

--Sig_/FEjP3biZc_p55XmvXMS7DkJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Thomas,

On Sun, 22 Apr 2018 18:23:46 +0200 Thomas Gleixner <tglx@linutronix.de> wro=
te:
>
> The rslib usage in dm/verity_fec is broken because init_rs() can nest in
> GFP_NOIO mempool allocations as init_rs() is invoked from the mempool all=
oc
> callback.
>=20
> Provide a variant which takes gfp_t flags as argument.
>=20
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: Alasdair Kergon <agk@redhat.com>
> Cc: Neil Brown <neilb@suse.com>
> ---
>  include/linux/rslib.h           |   26 +++++++++++++++++++++++---
>  lib/reed_solomon/reed_solomon.c |   36 ++++++++++++++++++++-------------=
---
>  2 files changed, 43 insertions(+), 19 deletions(-)
>=20
> --- a/include/linux/rslib.h
> +++ b/include/linux/rslib.h
> @@ -77,10 +77,30 @@ int decode_rs16(struct rs_control *rs, u
>  #endif
> =20
>  /* Create or get a matching rs control structure */
> -struct rs_control *init_rs(int symsize, int gfpoly, int fcr, int prim,
> -			   int nroots);
> +struct rs_control *init_rs_gfp(int symsize, int gfpoly, int fcr, int pri=
m,
> +			       int nroots, gfp_t gfp);
> +
> +/**
> + * init_rs - Create a RS control struct and initialize it
> + *  @symsize:	the symbol size (number of bits)
> + *  @gfpoly:	the extended Galois field generator polynomial coefficients,
> + *		with the 0th coefficient in the low order bit. The polynomial
> + *		must be primitive;
> + *  @fcr:	the first consecutive root of the rs code generator polynomial
> + *		in index form
> + *  @prim:	primitive element to generate polynomial roots
> + *  @nroots:	RS code generator polynomial degree (number of roots)
> + *
> + * Allocations use GFP_KERNEL.
> + */
> +static inline struct rs_control *init_rs(int symsize, int gfpoly, int fc=
r,
> +					 int prim, int nroots)
> +{
> +	return init_rs_gfp(symsize, gfpoly, fcr, prim, nroots, GFP_KERNEL);
> +}
> +

The version of this patch that Kees has committed to his kspp tree in linux=
-next has

#include <linux/slab.h>

why not just

#include <linux/types.h>	/* for gpf_t */
#include <linux/gpf.h>		/* for GFP_KERNEL */

?
--=20
Cheers,
Stephen Rothwell

--Sig_/FEjP3biZc_p55XmvXMS7DkJ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlrf1uEACgkQAVBC80lX
0GwdiAgAh2IsI8eH5M4eMgRi4XhtunwTjLxD+o2o1Dsrfa33+uh3y4bzOVJA7Kwq
xaU6+1q40QG6TYZNAK0uLWu/s9kyb6klmUUCxxX3I3+3BxN/qmEwrlQS1gG8uUSE
qxtvRDSbAVZu8BF5l/aWelIao8qMQECZOP+Aj8OgoxMd9YDT2jtJMDqqmdvsckQG
Wtbz1Z6i+W2CAIahQImw5uGiSdeoKwXvWKWd8mzbqM4Ys6p1sAEyz1RZQs36AlyE
T8ApRe9UjU/WHVidHiv6uJAUoC2xLMqIFbyjo5bHY6qe9xgMuu2OfxogQ7Lh0hY5
OUqADjuYkyowdIlYXo0BbJaWGdUHsw==
=oadR
-----END PGP SIGNATURE-----

--Sig_/FEjP3biZc_p55XmvXMS7DkJ--
