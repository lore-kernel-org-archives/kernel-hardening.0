Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1479318060.21171.31.camel@redhat.com>
From: Rik van Riel <riel@redhat.com>
Date: Wed, 16 Nov 2016 12:41:00 -0500
In-Reply-To: <20161116173243.GX3142@twins.programming.kicks-ass.net>
References: <20161110233835.GA23164@kroah.com>
	 <CAEXv5_j22xaH4cfVztp58XJxCo8UDut44ei_0Rhv_FUbfHDwsQ@mail.gmail.com>
	 <CAGXu5jJ0h6+r7T1bcrzVW0gF3Jis1shDbxcpxXR9sniD0B+74A@mail.gmail.com>
	 <20161111174630.GO3117@twins.programming.kicks-ass.net>
	 <CAGXu5j+_wdv_vn=Us-i=bvCwCGk5Ks_gpoK9bHja4dDNUZi9eQ@mail.gmail.com>
	 <20161111201704.GQ3117@twins.programming.kicks-ass.net>
	 <CAGXu5jJG0LUxLPtqr79PG=RmWgV96sy2j7dQKr9yvjadzrc3Ag@mail.gmail.com>
	 <1479228602.4622.64.camel@redhat.com>
	 <CAGXu5j+eA9wPMpM18iiD0RVX7UZVoLRn8JBKG2d8b3FF5+vwKw@mail.gmail.com>
	 <1479316156.21171.30.camel@redhat.com>
	 <20161116173243.GX3142@twins.programming.kicks-ass.net>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-nUNcJLHDRolTpmduiTIz"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Re: [RFC v4 PATCH 00/13] HARDENED_ATOMIC
To: kernel-hardening@lists.openwall.com
Cc: Will Deacon <will.deacon@arm.com>, Greg KH <gregkh@linuxfoundation.org>, David Windsor <dave@progbits.org>, Elena Reshetova <elena.reshetova@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter
 Anvin" <h.peter.anvin@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>


--=-nUNcJLHDRolTpmduiTIz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2016-11-16 at 18:32 +0100, Peter Zijlstra wrote:
> On Wed, Nov 16, 2016 at 12:09:16PM -0500, Rik van Riel wrote:
> > On Tue, 2016-11-15 at 09:23 -0800, Kees Cook wrote:
> > >=20
> > > Right, but it's the continuing atomic_t use that concerns me...
> >=20
> > Can we remove inc_not_zero and dec_and_test functionality
> > from the atomic_t macros?
> >=20
> > It would require fixing all of the in tree code, and after
> > that people with out of tree code would have to switch to
> > refcount_t to make their code work again.
>=20
> People will just use (atomic_add_return(-1, &refcount) =3D=3D 0) instead,
> or
> any other variant along those lines.

They could, but switching the variable type to refcount_t
seems like it would be the way of least resistance.

--=20
All Rights Reversed.
--=-nUNcJLHDRolTpmduiTIz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJYLJosAAoJEM553pKExN6DwpIH/RuM7NBMkqURHJbeNcF/UM26
D4zmJYdp2BIkJbr1icxyx+3/uc34XExzQH0m/CpBAs+jF1/8Zd26wWpmN/WWDMb5
DIu1fpXLT1hNe4dNSGAW8Hkqu7Uppm6j8WzkdVvPURpeJ/BjypPcsAcoCFCM5CbV
ZIdn1Cafg3JnNllf0OS/CNqdIGINkKnkyghJXdX6WHL7c20iuX5lj3/mm6apQoeC
0MIH7C9255wXw6sVBzxNPY6REbBSI0/+IkHfDsl1e6g1aExcNXJoRx/O7d3O1e2K
7/FSbT3+e/sNWl26NvqMhStcTaxqVJPZ6i2Vhh4FkxvXZYew2V+nnETWy+PW5Ig=
=lLwL
-----END PGP SIGNATURE-----

--=-nUNcJLHDRolTpmduiTIz--
