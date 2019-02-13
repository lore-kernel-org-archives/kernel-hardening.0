From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH 3/3] leaking_addresses: Expand tilde in output file name
Date: Wed, 13 Feb 2019 15:56:47 +0000
Message-ID: <6aed136f16e8451dbcfa97f90c04438f@AcuMS.aculab.com>
References: <20190207225026.11723-1-tobin@kernel.org>
 <20190207225026.11723-4-tobin@kernel.org>
In-Reply-To: <20190207225026.11723-4-tobin@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: "'Tobin C. Harding'" <tobin@kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: Tycho Andersen <tycho@tycho.ws>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

From: Tobin C. Harding
> Sent: 07 February 2019 22:50
>=20
> Currently if user passes an output file to the script via
> --output-raw we do not handle expansion of tilde.
>=20
> Use perl function glob() to expand tilde in output file name.

What happens if glob() returns multiple files?
I'm guessing that it can...

=09David

> Signed-off-by: Tobin C. Harding <tobin@kernel.org>
> ---
>  scripts/leaking_addresses.pl | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
> index ef9e5b2a1614..ce545ca3fb70 100755
> --- a/scripts/leaking_addresses.pl
> +++ b/scripts/leaking_addresses.pl
> @@ -150,7 +150,7 @@ if (!(is_supported_architecture() or $opt_32bit or $p=
age_offset_32bit)) {
>  }
>=20
>  if ($output_raw) {
> -=09open my $fh, '>', $output_raw or die "$0: $output_raw: $!\n";
> +=09open my $fh, '>', glob($output_raw) or die "$0: $output_raw: $!\n";
>  =09select $fh;
>  }
>=20
> --
> 2.20.1

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)
