Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 30 Oct 2016 00:01:33 +0200
From: Pavel Machek <pavel@ucw.cz>
Message-ID: <20161029220133.GE3827@amd>
References: <20161028172710.GA10309@amd>
 <d2f7dc1d-12ab-de12-cf73-7565fc27f5f7@gruss.cc>
 <20161029194224.GB3827@amd>
 <5f5741d5-0695-6a56-6c05-ebdaaa896f54@gruss.cc>
 <20161029210518.GC3827@amd>
 <571c5ef8-ccce-0b7a-b506-c69a024276a0@gruss.cc>
 <20161029214540.GD3827@amd>
 <c16d6b6c-608e-c711-cc18-34b8d0082183@gruss.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qz2CZ664xQdCRdPu"
Content-Disposition: inline
In-Reply-To: <c16d6b6c-608e-c711-cc18-34b8d0082183@gruss.cc>
Subject: Re: [kernel-hardening] rowhammer protection [was Re: Getting
 interrupt every million cache misses]
To: Daniel Gruss <daniel@gruss.cc>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>


--Qz2CZ664xQdCRdPu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat 2016-10-29 23:49:57, Daniel Gruss wrote:
> On 29.10.2016 23:45, Pavel Machek wrote:
> >indy/sandy/haswell/skylake, so I'll just use the generic version...?)
>=20
> yes, generic might work, but i never tested it on anything that old...
>=20
> on my system i have >30 bit flips per second (ivy bridge i5-3xxx) with the
> rowhammer-ivy test... sometimes even more than 100 per second...

Hmm, maybe I'm glad I don't have a new machine :-).

I assume you still get _some_ bitflips with generic "rowhammer"?

Best regards,
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--Qz2CZ664xQdCRdPu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgVHD0ACgkQMOfwapXb+vIwowCeIPO5shuK1NeNYJ5OdNfg3Y8V
EK4An28d6tyJTXnvLwORtcyZf+ZJ84qL
=hZaE
-----END PGP SIGNATURE-----

--Qz2CZ664xQdCRdPu--
