Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1479316156.21171.30.camel@redhat.com>
From: Rik van Riel <riel@redhat.com>
Date: Wed, 16 Nov 2016 12:09:16 -0500
In-Reply-To: <CAGXu5j+eA9wPMpM18iiD0RVX7UZVoLRn8JBKG2d8b3FF5+vwKw@mail.gmail.com>
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
	 <1479228602.4622.64.camel@redhat.com>
	 <CAGXu5j+eA9wPMpM18iiD0RVX7UZVoLRn8JBKG2d8b3FF5+vwKw@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-jEQ7m7/KpQV8pNnjFgLW"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Re: [RFC v4 PATCH 00/13] HARDENED_ATOMIC
To: kernel-hardening@lists.openwall.com
Cc: Peter Zijlstra <peterz@infradead.org>, Will Deacon <will.deacon@arm.com>, Greg KH <gregkh@linuxfoundation.org>, David Windsor <dave@progbits.org>, Elena Reshetova <elena.reshetova@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <h.peter.anvin@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>


--=-jEQ7m7/KpQV8pNnjFgLW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2016-11-15 at 09:23 -0800, Kees Cook wrote:
> On Tue, Nov 15, 2016 at 8:50 AM, Rik van Riel <riel@redhat.com>
> wrote:
> >=20
> > On Mon, 2016-11-14 at 12:31 -0800, Kees Cook wrote:
> > >=C2=A0
> > > Keeping the implementation details of refcount_t and stats_t
> > > opaque
> > > to
> > > the users should discourage misuse...
> >=20
> > I suspect a lack of inc_not_zero and dec_and_test would
> > be the biggest things discouraging misuse of stats_t
> > for reference counting :)
>=20
> Right, but it's the continuing atomic_t use that concerns me...

Can we remove inc_not_zero and dec_and_test functionality
from the atomic_t macros?

It would require fixing all of the in tree code, and after
that people with out of tree code would have to switch to
refcount_t to make their code work again.

--=20
All Rights Reversed.
--=-jEQ7m7/KpQV8pNnjFgLW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJYLJK9AAoJEM553pKExN6DBF0H/39RZS2SnbsqIBYexNGRiT8O
Ym5QHl+1OEKzbNnKPAdpnz/in/a73bXIoyqvC5OCvgrIuHwl4+MQYZ+nxUg+ozBK
0pSHfoDpN93kR+kftCGqyL89QB8y1QGMjiEGFVKWZfyG3Wt+vSYP925i4AxAEeP2
VP2a2YJMFREcGrsdoti7/wPqSqU1c4ZbdEGC/xa0/QmZ2EYTzRVuI0+Ox2Fq5Vvc
gf/ECefMQLJkny2ucE952FZd9SS26HA/bVQtsd3jKJdPJEmKIcj7/Jz9xHrF9dPu
4m+frjggCat6feP7d6/LryWG72cqWK3ngSra8YKVvj9VrUyNimV02qL5rDijvPs=
=fsUO
-----END PGP SIGNATURE-----

--=-jEQ7m7/KpQV8pNnjFgLW--
