From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Subject: RE: [PATCH] power: supply: da9150-fg: remove VLA usage
Date: Fri, 9 Mar 2018 11:36:04 +0000
Message-ID: <2E89032DDAA8B9408CB92943514A0337014C1D771E@SW-EX-MBX01.diasemi.com>
References: <20180309045813.GA11964@embeddedgus>
In-Reply-To: <20180309045813.GA11964@embeddedgus>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Support Opensource <Support.Opensource@diasemi.com>, Sebastian Reichel <sre@kernel.org>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 09 March 2018 04:58, Gustavo A. R. Silva wrote:

> In preparation to enabling -Wvla, remove VLA usage and replace it
> with fixed-length arrays.
>=20
> It seems that the length of array 'buf' will not exceed
> DA9150_QIF_SHORT_SIZE bytes (2 bytes). But a fixed length
> of DA9150_QIF_BYTE_SIZE bytes (8 bytes) was chosen in case
> this change in the future.
>=20
> Fixed as part of the directive to remove all VLAs from
> the kernel: https://lkml.org/lkml/2018/3/7/621
>=20
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  drivers/power/supply/da9150-fg.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/power/supply/da9150-fg.c b/drivers/power/supply/da91=
50-fg.c
> index 8b8ce97..96893be 100644
> --- a/drivers/power/supply/da9150-fg.c
> +++ b/drivers/power/supply/da9150-fg.c
> @@ -92,7 +92,7 @@ struct da9150_fg {
>  static u32 da9150_fg_read_attr(struct da9150_fg *fg, u8 code, u8 size)
>=20
>  {
> -	u8 buf[size];
> +	u8 buf[DA9150_QIF_BYTE_SIZE];

You can use DA9150_QIF_LONG_SIZE as that's the biggest size of an attribute
which can be accessed. This will also save a little space.

>  	u8 read_addr;
>  	u32 res =3D 0;
>  	int i;
> @@ -111,7 +111,7 @@ static void da9150_fg_write_attr(struct da9150_fg *fg=
, u8
> code, u8 size,
>  				 u32 val)
>=20
>  {
> -	u8 buf[size];
> +	u8 buf[DA9150_QIF_BYTE_SIZE];
>  	u8 write_addr;
>  	int i;
>=20
> --
> 2.7.4
