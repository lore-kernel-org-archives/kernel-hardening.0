Date: Sun, 22 Apr 2018 11:00:03 +0200
From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCHv3 11/11] arm64: docs: document pointer authentication
Message-ID: <20180422090003.GA24344@amd>
References: <20180417183735.56985-1-mark.rutland@arm.com>
 <20180417183735.56985-12-mark.rutland@arm.com>
 <20180422080520.GC17875@amd>
 <86h8o3r5jy.wl-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
In-Reply-To: <86h8o3r5jy.wl-marc.zyngier@arm.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, linux-arm-kernel@lists.infradead.org, arnd@arndb.de, catalin.marinas@arm.com, cdall@kernel.org, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org, ramana.radhakrishnan@arm.com, suzuki.poulose@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, awallis@codeaurora.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun 2018-04-22 09:47:29, Marc Zyngier wrote:
> On Sun, 22 Apr 2018 09:05:21 +0100,
> Pavel Machek wrote:
> >=20
> > Hi!
> >=20
> > > @@ -205,6 +205,14 @@ Before jumping into the kernel, the following co=
nditions must be met:
> > >      ICC_SRE_EL2.SRE (bit 0) must be initialised to 0b0.
> > >    - The DT or ACPI tables must describe a GICv2 interrupt controller.
> > > =20
> > > +  For CPUs with pointer authentication functionality:
> > > +  - If EL3 is present:
> > > +    SCR_EL3.APK (bit 16) must be initialised to 0b1
> > > +    SCR_EL3.API (bit 17) must be initialised to 0b1
> > > +  - If the kernel is entered at EL1:
> > > +    HCR_EL2.APK (bit 40) must be initialised to 0b1
> > > +    HCR_EL2.API (bit 41) must be initialised to 0b1
> > > +
> >=20
> > 0b1 is quite confusing way to write 1.
>=20
> Do you find 0x1 equally confusing?

It is slightly better. Still I'd not use it for describing single bit.

> 0bx is a pretty common way of describing bit-fields of a hardware
> register. It is also consistent with the rest of this document.

=2E..and inconsistent with rest of the world :-).
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlrcTxMACgkQMOfwapXb+vKI0ACeMo1/1nh61yFTOI/1mDSHcvzC
YrMAoIhqWJC2fBZtLjTJysk3kqkTVZC/
=h4Dt
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
