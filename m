Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1446816504.8412.35.camel@debian.org>
From: Yves-Alexis Perez <corsac@debian.org>
Date: Fri, 06 Nov 2015 14:28:24 +0100
In-Reply-To: <CAGXu5jJ3FgxXK9WuOLRwnEq=y4dS+CTm+WQBxWe3sYZ7e9p6Gg@mail.gmail.com>
References: 
	<CAGXu5jJ3FgxXK9WuOLRwnEq=y4dS+CTm+WQBxWe3sYZ7e9p6Gg@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-v9XPqreB6XQK2pbNqrDi"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Kernel Self Protection Project
To: kernel-hardening@lists.openwall.com
Cc: Solar Designer <solar@openwall.com>, Greg KH <gregkh@linuxfoundation.org>, Ben Hutchings <ben@decadent.org.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, James Morris <jmorris@namei.org>
List-ID: <kernel-hardening.lists.openwall.com>


--=-v9XPqreB6XQK2pbNqrDi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On jeu., 2015-11-05 at 12:59 -0800, Kees Cook wrote:
> For now, I'm going to focus on taking a look at the PAX_SIZE_OVERFLOW
> gcc plugin, which will also get us the gcc plugin infrastructure.
> Other people, please speak up on what you'd like to tackle.

Hi Kees, and first many thanks for the initiative. That's definitely someth=
ing
of interest for me (both personally and professionally).

Something which might also be interesting in kernel self protection is the
=E2=80=9Cactive response=E2=80=9D found in grsecurity (GRKERNSEC_SEC_KERN_L=
OCKOUT) and the
=E2=80=9Cdeter exploite bruteforcing=E2=80=9D (GRKERNSEC_BRUTE), which can =
help prevent
exploitation with repeated attempts.

Some features (especially SEC_KERN_LOCKOUT) are really more useful when UDE=
REF
and KERNEXEC are available (since those are the most severe violations one =
can
find), but it could still apply to other violations.

Regards,
--=20
Yves-Alexis


--=-v9XPqreB6XQK2pbNqrDi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJWPKr4AAoJEG3bU/KmdcClpc4H/0TSH0lpT0MmtVB05xPF6Mto
2o7Dw+rwE3RocQBquuaQ2PgwEw8XXKX7u0Gu84q0sNiLRgQDcEja4u8/qM5JwjXp
I+j9Cdg7P16mIHyT258YUxPtm1aQzbisEjXjZ5+y5zCYz8vnOmibuDNujdDPPeHe
H/9Lt4zWFfnXHKSOJMozObRESEWaOc6oqPbC7SgkM/NlaXVOQyy6LKGCtHA6oD21
7noYOzjw3xTdgOGUBuInjWLHkjaBg4vLxdfSKTjRg2YBGObthtOfeSSZojF+E8qd
NKXCDkMIpCxysbDUKMbSPAeR119GAa3Prn28EvSvAWxp7MKc2BCwnwoS6aDKrfQ=
=2Tq6
-----END PGP SIGNATURE-----

--=-v9XPqreB6XQK2pbNqrDi--
