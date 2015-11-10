Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1447154645.29239.8.camel@debian.org>
From: Yves-Alexis Perez <corsac@debian.org>
Date: Tue, 10 Nov 2015 12:24:05 +0100
In-Reply-To: <20151110104747.GG25737@suse.de>
References: 
	<CAGXu5jK2boq=rSwrdyqyq=B_kZJR2pUQe99+tPBwK+pKEx0X+w@mail.gmail.com>
	 <563F4A78.21151.23C6852D@pageexec.freemail.hu>
	 <5640E0DD.6040107@labbott.name> <20151109182832.GB20491@io.lakedaemon.net>
	 <13041.1447095477@turing-police.cc.vt.edu>
	 <20151109190224.GD20491@io.lakedaemon.net>
	 <CAGagf4d4A8ZN2hVDDUFge78D_AZKFwkh6ZCV9faEZe=DO_fwKQ@mail.gmail.com>
	 <20151109210922.GF20491@io.lakedaemon.net>
	 <20151109211341.GA29829@srcf.ucam.org>
	 <1447152151.29239.0.camel@debian.org> <20151110104747.GG25737@suse.de>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-DXsl/L+hrPxAWRxhLCvs"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Re: Proposal for kernel self protection
 features
To: kernel-hardening@lists.openwall.com, Marcus Meissner <meissner@suse.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Theodore Tso <tytso@google.com>, Emese Revfy <re.emese@gmail.com>, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Greg KH <gregkh@linuxfoundation.org>, Josh Triplett <josh@joshtriplett.org>
List-ID: <kernel-hardening.lists.openwall.com>


--=-DXsl/L+hrPxAWRxhLCvs
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On mar., 2015-11-10 at 11:47 +0100, Marcus Meissner wrote:
> The kernel has infrastructure for this (feeding hardware random generator=
s
> into the random pool) these days.
>=20
> e.g.
> drivers/char/hw_random/tpm-rng.c

Thanks, I was missing those bits. Actually those are in (on v4.3, starting
from drivers/char/hw_random/core.c#L483):

hwrng_register()
	add_early_randomness()
		rng_get_data()
		add_device_randomness()

but as far as I can tell it only gets called once when registering the hwrn=
g
driver, and only if the RNG driver doesn't define an init function (tpm-rng
doesn't). But that's still better than no randomness at all.

Regards,
--=20
Yves-Alexis


--=-DXsl/L+hrPxAWRxhLCvs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJWQdPWAAoJEG3bU/KmdcClHhcH/1S+lFa1MT8MxLkW/8dOPEbp
Hf210OctyinD47y46aQdtLJdN4JblixA6eQi2Oaiqfh3eXDanWhAOaJXufvVR4NA
wH8fBNwLYlaYGXegh9dGOW3ySdxjPkWbA63d23e7mq+6l9FZjn9JSKlNmL8mbPIV
ipgZtdUNIxVIWW8FKos7thJaW+MWSZ2WN7s18mqpkOuSNyQX/qqBS4HVG1oZAkOE
Tg05GWPaELtI5XoFALq5ZgUv6zNWYYzbKnTfnBRuXDrtjJ5HPNyuFKEF+tU30Imb
79digt6PggoX3RT2ML9UrQ6nCVgnwSrolTfC+rKfPptXTce3Mz0MY+tGv0JAvV0=
=Rx+s
-----END PGP SIGNATURE-----

--=-DXsl/L+hrPxAWRxhLCvs--
