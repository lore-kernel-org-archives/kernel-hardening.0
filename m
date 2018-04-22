Date: Sun, 22 Apr 2018 10:05:21 +0200
From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCHv3 11/11] arm64: docs: document pointer authentication
Message-ID: <20180422080520.GC17875@amd>
References: <20180417183735.56985-1-mark.rutland@arm.com>
 <20180417183735.56985-12-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V88s5gaDVPzZ0KCq"
Content-Disposition: inline
In-Reply-To: <20180417183735.56985-12-mark.rutland@arm.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, arnd@arndb.de, catalin.marinas@arm.com, cdall@kernel.org, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org, marc.zyngier@arm.com, ramana.radhakrishnan@arm.com, suzuki.poulose@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, awallis@codeaurora.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--V88s5gaDVPzZ0KCq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> @@ -205,6 +205,14 @@ Before jumping into the kernel, the following condit=
ions must be met:
>      ICC_SRE_EL2.SRE (bit 0) must be initialised to 0b0.
>    - The DT or ACPI tables must describe a GICv2 interrupt controller.
> =20
> +  For CPUs with pointer authentication functionality:
> +  - If EL3 is present:
> +    SCR_EL3.APK (bit 16) must be initialised to 0b1
> +    SCR_EL3.API (bit 17) must be initialised to 0b1
> +  - If the kernel is entered at EL1:
> +    HCR_EL2.APK (bit 40) must be initialised to 0b1
> +    HCR_EL2.API (bit 41) must be initialised to 0b1
> +

0b1 is quite confusing way to write 1.

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--V88s5gaDVPzZ0KCq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlrcQkAACgkQMOfwapXb+vKlSQCeNU0RERVJm4ZqVsCIP89svUq/
RK0AnR1nYiaJQ9ICHmunce6TL5rFZM0O
=7Aq9
-----END PGP SIGNATURE-----

--V88s5gaDVPzZ0KCq--
