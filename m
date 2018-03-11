Date: Sun, 11 Mar 2018 16:01:35 +0100
From: Stephen Kitt <steve@sk2.org>
Subject: Re: [PATCH] scsi: resolve COMMAND_SIZE at compile time
Message-ID: <20180311160135.66af901e@heffalump.sk2.org>
In-Reply-To: <1520714957.4495.5.camel@linux.vnet.ibm.com>
References: <20180309232933.14e39858@heffalump.sk2.org>
	<20180309223355.21222-1-steve@sk2.org>
	<1520635631.2907.16.camel@wdc.com>
	<20180310142930.0692200b@heffalump.sk2.org>
	<1520714957.4495.5.camel@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/HrbAIS.N=s49FcwG=AMbuTz"; protocol="application/pgp-signature"
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "hare@suse.com" <hare@suse.com>, "martin.petersen@oracle.com\"
 <martin.petersen@oracle.com>, "axboe@kernel.dk, " <axboe@kernel.dk>,
 "linux-scsi@vger.kernel.org\, "  <linux-scsi@vger.kernel.org>,
 "linux-kernel@vger.kernel.org\, "  <linux-kernel@vger.kernel.org>,
 "linux-block@vger.kernel.org\, "  <linux-block@vger.kernel.org>,
 "kernel-hardening@lists.openwall.com\,  
 <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

--Sig_/HrbAIS.N=s49FcwG=AMbuTz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 10 Mar 2018 12:49:17 -0800, James Bottomley <jejb@linux.vnet.ibm.co=
m>
wrote:
> On Sat, 2018-03-10 at 14:29 +0100, Stephen Kitt wrote:
> > On Fri, 9 Mar 2018 22:47:12 +0000, Bart Van Assche <Bart.VanAssche@wd =
=20
> > c.com> =20
> > wrote: =20
> > > On Fri, 2018-03-09 at 23:33 +0100, Stephen Kitt wrote: =20
> > > > +/*
> > > > + * SCSI command sizes are as follows, in bytes, for fixed size
> > > > commands,
> > > > per
> > > > + * group: 6, 10, 10, 12, 16, 12, 10, 10. The top three bits of
> > > > an opcode
> > > > + * determine its group.
> > > > + * The size table is encoded into a 32-bit value by subtracting
> > > > each
> > > > value
> > > > + * from 16, resulting in a value of 1715488362
> > > > + * (6 << 28 + 6 << 24 + 4 << 20 + 0 << 16 + 4 << 12 + 6 << 8 + 6
> > > > << 4 +
> > > > 10).
> > > > + * Command group 3 is reserved and should never be used.
> > > > + */
> > > > +#define COMMAND_SIZE(opcode) \
> > > > +	(16 - (15 & (1715488362 >> (4 * (((opcode) >> 5) &
> > > > 7)))))=C2=A0=C2=A0 =20
> > >=20
> > > To me this seems hard to read and hard to verify. Could this have
> > > been
> > > written as a combination of ternary expressions, e.g. using a gcc
> > > statement
> > > expression to ensure that opcode is evaluated once? =20
> >=20
> > That=E2=80=99s what I=E2=80=99d tried initially, e.g.
> >=20
> > #define COMMAND_SIZE(opcode) ({ \
> > int index =3D ((opcode) >> 5) & 7; \
> > index =3D=3D 0 ? 6 : (index =3D=3D 4 ? 16 : index =3D=3D 3 || index =3D=
=3D 5 ? 12 :
> > 10); \
> > })
> >=20
> > But gcc still reckons that results in a VLA, defeating the initial
> > purpose of
> > the exercise.
> >=20
> > Does it help if I make the magic value construction clearer?
> >=20
> > #define SCSI_COMMAND_SIZE_TBL (	\
> > 	=C2=A0=C2=A0=C2=A0(16 -=C2=A0=C2=A06)		\
> > 	+ ((16 - 10) <<=C2=A0=C2=A04)	\
> > 	+ ((16 - 10) <<=C2=A0=C2=A08)	\
> > 	+ ((16 - 12) << 12)	\
> > 	+ ((16 - 16) << 16)	\
> > 	+ ((16 - 12) << 20)	\
> > 	+ ((16 - 10) << 24)	\
> > 	+ ((16 - 10) << 28))
> >=20
> > #define
> > COMMAND_SIZE(opcode) \
> > =C2=A0 (16 - (15 & (SCSI_COMMAND_SIZE_TBL >> (4 * (((opcode) >> 5) &
> > 7))))) =20
>=20
> Couldn't we do the less clever thing of making the array a static const
> and moving it to a header? =C2=A0That way the compiler should be able to
> work it out at compile time.

I hoped so too, but const-ifying a variable doesn=E2=80=99t make it a compi=
le-time
constant (even though the optimiser can resolve it at build-time), so GCC
still considers uses such as

	u8 cdb[COMMAND_SIZE(MAINTENANCE_IN)];

as variable-length arrays, which C90 forbids (and which we=E2=80=99re tryin=
g to
eliminate here).

Regards,

Stephen

--Sig_/HrbAIS.N=s49FcwG=AMbuTz
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEnPVX/hPLkMoq7x0ggNMC9Yhtg5wFAlqlRNAACgkQgNMC9Yht
g5yoKA//fdE6sqEdCKbnOKP2/aNswF66g/5/fcY8rso+f/2I9F3W7qMZQu+idQZ0
qi7RNtOmU71WCaav/vzoH18zLMC9Q6k4AxoEeaaQ2gcFoUgrvE/SgVECiYpzEA8g
Nt+kBmZsaSUbiQroEqBKbgagRp8WM28BqnFXwpjnff66RpWgghPPZKA/y1xMp4a/
JlXK72QavMUThMSAZp11VZh0LR/BtrbutwRv+cLdcsqCg3dfIXy90iQqR7FkkSc9
GhEkHFvJfFIWN6WSKmWzV5U52czokBJyTuTYSYOPRMcGuPf2WBIToNuyDg9DEIJ4
zkmEru0qtHvthakQ/D5nMkkKQ+O+qbhCzhNR21+voY7sqQsRNsVfDo7ilEa6jnfC
llc0t/jLaq1r3lzwRdB/ERMyoUAwXSt7UAouoqIgyFnV0Ky2G58DQLgNGEih4WMh
ihpZTmLgv5nzy39G1G7no4StvjqfQcWJl+Gc6t+EWtR+QGsToYTj+3kvRoc2GfJC
SlHOnfQ7EEK8akYSK2lipDvWvosRwboBjiYc5k/SLe1q81tl08L3SPVXqb6YSLxr
sZmJZQRb5fR0TzbsqgkOnSBqe/2+SWTp/OIetADrrYIpM+3KHJ9VRdnR3FN2Fc8J
rd8+ir5vnDFn/Aip0514a9lM92uNeGFdTYLV1KdaW6NuO8BfZy4=
=BHt1
-----END PGP SIGNATURE-----

--Sig_/HrbAIS.N=s49FcwG=AMbuTz--
