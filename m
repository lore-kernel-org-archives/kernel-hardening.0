Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1479228602.4622.64.camel@redhat.com>
From: Rik van Riel <riel@redhat.com>
Date: Tue, 15 Nov 2016 11:50:02 -0500
In-Reply-To: <CAGXu5jJG0LUxLPtqr79PG=RmWgV96sy2j7dQKr9yvjadzrc3Ag@mail.gmail.com>
References: <20161110203749.GV3117@twins.programming.kicks-ass.net>
	 <20161110204838.GE17134@arm.com>
	 <20161110211310.GX3117@twins.programming.kicks-ass.net>
	 <20161110222744.GD8086@kroah.com>
	 <CAGXu5jJz_dHt-QNqPrYFnQNhj1oV_ux62SSi=PN=VEBm6oq0Mg@mail.gmail.com>
	 <20161110233835.GA23164@kroah.com>
	 <CAEXv5_j22xaH4cfVztp58XJxCo8UDut44ei_0Rhv_FUbfHDwsQ@mail.gmail.com>
	 <CAGXu5jJ0h6+r7T1bcrzVW0gF3Jis1shDbxcpxXR9sniD0B+74A@mail.gmail.com>
	 <20161111174630.GO3117@twins.programming.kicks-ass.net>
	 <CAGXu5j+_wdv_vn=Us-i=bvCwCGk5Ks_gpoK9bHja4dDNUZi9eQ@mail.gmail.com>
	 <20161111201704.GQ3117@twins.programming.kicks-ass.net>
	 <CAGXu5jJG0LUxLPtqr79PG=RmWgV96sy2j7dQKr9yvjadzrc3Ag@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-faNltuRSb4IoTFU/TIWw"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Re: [RFC v4 PATCH 00/13] HARDENED_ATOMIC
To: kernel-hardening@lists.openwall.com, Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will.deacon@arm.com>, Greg KH <gregkh@linuxfoundation.org>, David Windsor <dave@progbits.org>, Elena Reshetova <elena.reshetova@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter
 Anvin" <h.peter.anvin@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>


--=-faNltuRSb4IoTFU/TIWw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2016-11-14 at 12:31 -0800, Kees Cook wrote:
> On Fri, Nov 11, 2016 at 12:17 PM, Peter Zijlstra <peterz@infradead.or
> g> wrote:
> >=20
> > On Fri, Nov 11, 2016 at 10:04:42AM -0800, Kees Cook wrote:
> >=20
> > >=20
> > > I'm totally open about how to get there, but things can't just be
> > > opt-in.
> > There really is no alternative.
> I realize you feel that way, but if we can find a way to squeeze
> mistakes down to impossible or very small, that has a strong effect
> on
> the future of avoiding exploitation of these kinds of things.
>=20
> >=20
> > refcount_t; should only have: inc, inc_not_zero, dec_and_test
> Sounds good. Two questions remain:
>=20
> - how to deal with existing refcounting atomic_t users that want _add
> and _sub?
> - keeping this fast enough that it can be used even in very sensitive
> places (net, fs, etc).
>=20
> >=20
> > stats_t; should only have: add,sub
> Seems right, though why not inc/dec? And shouldn't it have a _read of
> some kind?
>=20
> Keeping the implementation details of refcount_t and stats_t opaque
> to
> the users should discourage misuse...

I suspect a lack of inc_not_zero and dec_and_test would
be the biggest things discouraging misuse of stats_t
for reference counting :)

--=20
All rights reversed

--=-faNltuRSb4IoTFU/TIWw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJYKzy7AAoJEM553pKExN6DSrUH/28cvAWXBDujsDxQOCeNGhEx
ScdGfzRBN9o12jPNmPPzwHj5dQYn98PX06vUoV8ZYFWpPIK1Zk0/cszNsAySjeuO
WimIcvYEXyVi2N+qa7Zib2rXX07JhCC/QG6yl1C1JWHOp8ZtsFMfDXfpe8gRoFr0
2oGQz7o0qng56Z5tCdrGH/qFnE21pJz1oLUzLQQBweiihpWkh0HRoHAnY1mHQGWv
h4ngdp1ilm3lBsrnxzHxWObUh+PSZdm/a1MpD02jM2ZslozuuwT4ZYUHyhPiMfD9
vCNb82n7ucichs9wXm7nuPQ8l/p6o9qMCV/cDvXrQq8YbNHyn2Uyi5zx2xOdYCA=
=ELHd
-----END PGP SIGNATURE-----

--=-faNltuRSb4IoTFU/TIWw--
