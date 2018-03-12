Date: Mon, 12 Mar 2018 14:41:05 +0100
From: Sebastian Reichel <sre@kernel.org>
Subject: Re: [PATCH v2] power: supply: da9150-fg: remove VLA usage
Message-ID: <20180312134105.vyuqjluqyght4trd@earth.universe>
References: <20180309182708.GA18542@embeddedgus>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="k6uosldzav3rb6ov"
Content-Disposition: inline
In-Reply-To: <20180309182708.GA18542@embeddedgus>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>, Support Opensource <support.opensource@diasemi.com>, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-ID: <kernel-hardening.lists.openwall.com>


--k6uosldzav3rb6ov
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Mar 09, 2018 at 12:27:08PM -0600, Gustavo A. R. Silva wrote:
> In preparation to enabling -Wvla, remove VLA usage and replace it
> with fixed-length arrays.
>=20
> DA9150_QIF_LONG_SIZE (4 bytes) is the biggest size of an attribute which =
can
> be accessed [1].
>=20
> Fixed as part of the directive to remove all VLAs from
> the kernel: https://lkml.org/lkml/2018/3/7/621
>=20
> [1] https://marc.info/?l=3Dkernel-hardening&m=3D152059600524753&w=3D2
>=20
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---

Thanks, queued to power-supply's for-next branch.

-- Sebastian

> Changes in v2:
>  - Use DA9150_QIF_LONG_SIZE instead of DA9150_QIF_BYTE_SIZE as the
>    maximum size for array 'buf'. Thanks to Adam Thomson for the
>    feedback on this.
>  - Update changelog based on Adam's comments.
>=20
>  drivers/power/supply/da9150-fg.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/power/supply/da9150-fg.c b/drivers/power/supply/da91=
50-fg.c
> index 8b8ce97..7ea2188 100644
> --- a/drivers/power/supply/da9150-fg.c
> +++ b/drivers/power/supply/da9150-fg.c
> @@ -92,7 +92,7 @@ struct da9150_fg {
>  static u32 da9150_fg_read_attr(struct da9150_fg *fg, u8 code, u8 size)
> =20
>  {
> -	u8 buf[size];
> +	u8 buf[DA9150_QIF_LONG_SIZE];
>  	u8 read_addr;
>  	u32 res =3D 0;
>  	int i;
> @@ -111,7 +111,7 @@ static void da9150_fg_write_attr(struct da9150_fg *fg=
, u8 code, u8 size,
>  				 u32 val)
> =20
>  {
> -	u8 buf[size];
> +	u8 buf[DA9150_QIF_LONG_SIZE];
>  	u8 write_addr;
>  	int i;
> =20
> --=20
> 2.7.4
>=20

--k6uosldzav3rb6ov
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlqmg2QACgkQ2O7X88g7
+prUaBAAiHY3IHzDJtEVUEwmwUZGx1ESHMbGkCYgodZlMTdzDwNpeUjT2o8Pdf5g
Nj5WjVm09XBh/h6kXMcZllsi/OOAhPEsA6AFqsTOWgeLIu6QikUywFA4giC3U5R9
x4hLUyFlScVcNBr6bE1N+QFqCgZ7ZdURsLNFQ3ASdwdxkozjvdWe0worIkFN+CIi
1N5KttrgwLN0FJmcZDreHu9YcPRcbU8wubXjSgTpbdotS3uOnrTieyIFkN7kj4EY
DGqlKcuem3Lpl96mYC/W7H1sQP9xe2D5LH9xWxvtiqAEegATXNJ7h2Jcw7+wqV0S
8IFEmGIDOZ7SKFQqjJfoX6BkKuey7vjELwnhS0sD4cdQ2rAx3Sz7WLxCeTrYdqVp
VmiNED4MV9MRB/KVqLUINv7zsxQYwC8Z8F9vyAJmnZpD4CVhRX6Ie7GXSuq8OU2Q
K+F92tggVcE+z+gfztvcXEU5JPxboE2TlVMShUXNUSWUFU1jqfvfQTElPHaPdrQ+
pWOxEaX9cJs/qsJZavP0r+oZdDA1r2ET+lk5MthzJCVy47bc3r/wr4Pn5yMPXQ25
jpNg9Fqh8VFNOyLRPNjhG9YPkzAV27+lDruAKejL31O9pzd3K2PIILEB4YNpnMl/
QwtX3NDWH/tFKsDu6tS6g1N7C5tLiEKiRzDR5uIdo13xnRr5lWQ=
=Khci
-----END PGP SIGNATURE-----

--k6uosldzav3rb6ov--
