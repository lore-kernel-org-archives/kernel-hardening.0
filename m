Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 28 Oct 2016 13:55:45 +0200
From: Pavel Machek <pavel@ucw.cz>
Message-ID: <20161028115545.GC5635@amd>
References: <20161026204748.GA11177@amd>
 <20161027082801.GE3568@worktop.programming.kicks-ass.net>
 <20161027091104.GB19469@amd>
 <20161027093334.GK3102@twins.programming.kicks-ass.net>
 <CAGXu5jL=xzyPRQgOp5ON2+X0=5z4-jg4NyFCrTSrRPm5puOm0Q@mail.gmail.com>
 <20161027212747.GA18147@amd>
 <20161028070701.GA11376@gmail.com>
 <20161028085039.GA15032@amd>
 <20161028085937.GA21247@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y5rl02BVI9TCfPar"
Content-Disposition: inline
In-Reply-To: <20161028085937.GA21247@gmail.com>
Subject: [kernel-hardening] Re: rowhammer protection [was Re: Getting interrupt every million
 cache misses]
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>


--Y5rl02BVI9TCfPar
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > I agree this needs to be tunable (and with the other suggestions). But
> > this is actually not the most important tunable: the detection
> > threshold (rh_attr.sample_period) should be way more important.
> >=20
> > And yes, this will all need to be tunable, somehow. But lets verify
> > that this works, first :-).
>=20
> Yeah.
>=20
> Btw., a 56 NMI delay is pretty brutal in terms of latencies - it might
> result in a smoother system to detect 100,000 cache misses and do a
> ~5.6 msecs delay instead?
>=20
> (Assuming the shorter threshold does not trigger too often, of
> course.)

Yeah, it is brutal workaround for a nasty bug. Slowdown depends on maximum =
utilization:

+/*
+ * Maximum permitted utilization of DRAM. Setting this to f will mean that
+ * when more than 1/f of maximum cache-miss performance is used, delay will
+ * be inserted, and will have similar effect on rowhammer as refreshing me=
mory
+ * f times more often.
+ *
+ * Setting this to 8 should prevent the rowhammer attack.
+ */
+       int dram_max_utilization_factor =3D 8;

|                               | no prot. | fact. 1 | fact. 2 | fact. 8 |
| linux-n900$ time ./mkit       | 1m35     | 1m47    | 2m07    | 6m37    |
| rowhammer-test (for 43200000) | 2.86     | 9.75    | 16.7307 | 59.3738 |

(With factor 1 and 2 cpu attacker, we don't guarantee any protection.)

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--Y5rl02BVI9TCfPar
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgTPMEACgkQMOfwapXb+vLqTACfevx5eZPpkuITqiQ+Jrh/8g2S
43gAoLXhbqbVTp+Es/3Nwpo1KEAldJFn
=93O7
-----END PGP SIGNATURE-----

--Y5rl02BVI9TCfPar--
