Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1470332166.22643.133.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Thu, 04 Aug 2016 13:36:06 -0400
In-Reply-To: <20160804170944.GA16464@leverpostej>
References: <20160802203037.GC6879@twins.programming.kicks-ass.net>
	 <CAGXu5jJ+b4mWQ+RwPLo26di1qUwKT344GoN6xwzA1fw5Ke=ydA@mail.gmail.com>
	 <87shulix2z.fsf@x220.int.ebiederm.org>
	 <1470252976.22643.41.camel@gmail.com> <20160804102854.GB4483@leverpostej>
	 <1470318323.22643.70.camel@gmail.com>
	 <20160804141109.GM6879@twins.programming.kicks-ass.net>
	 <1470325468.22643.95.camel@gmail.com> <20160804161000.GA11673@leverpostej>
	 <1470328352.22643.110.camel@gmail.com> <20160804170944.GA16464@leverpostej>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-7X0eiBuHEsnYqyp8G4wx"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Re: [PATCH 1/2] security, perf: allow
 further restriction of perf_event_open
To: kernel-hardening@lists.openwall.com
Cc: Peter Zijlstra <peterz@infradead.org>, Kees Cook <keescook@chromium.org>, Jeff Vander Stoep <jeffv@google.com>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>
List-ID: <kernel-hardening.lists.openwall.com>


--=-7X0eiBuHEsnYqyp8G4wx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> My claim was not that the mainline code was impressively perfect, but
> rather that the vendor code was worse, countering a prior claim
> otherwise. Hence, reality.

You're arguing with a straw man.

I was responding to a comment about out-of-tree code, not generic
architecture perf drivers vs. alternative versions by SoC vendors.

Qualcomm and other vendors landing their drivers in mainline would be
nice, but it wouldn't make it inherently higher quality. I don't really
see what it has to do with this, which I why I responded...
--=-7X0eiBuHEsnYqyp8G4wx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIzBAABCAAdBQJXo30GFhxkYW5pZWxtaWNheUBnbWFpbC5jb20ACgkQ+ecS5Zr1
8irKtw//flRVy2SRz6ez0aMo7u0wjfaAio4eaMVzaCB86dQbM+4Moq2MgDJAN/u4
mBfzqPC0QKreUnpHT/wt1mUje76fRqApCRi6On1mmkKdP/HLqgvFWyujztsekNxX
dqP+kbw9rX7AYRHwyGOtPR1lmW/Lte3v04y6ZUgFZXzIH0bhe92gG979vs5/DxdC
RbFq+tasV5ZIAsQzUa5twOMfRQ/MaW2mo3jixd9RmKF6AYTiw3jMOJMDVpDpmCh0
DgZA540LlZqFnOorYXRripdGYJx1Y+iXbv+5YsNXzXFaEI9Ts45bXKzwLr2XT/Lq
O4d9BweQCUMloBRoWWAtJNMfmMur+W3EgervKtWHVrjv/RQXRlscCctmNromXlYZ
iIfM4bGM9kHiw+YrakC3KoD72Ur5evjAuxb1dgqocfRAg2n8LbKciK0H3vE9B9nv
da2pQEsQyjsDsZYrkuKTjGUejNsxGWymQza8seF2GJUaUju/V/bYWqKTnHD5wePm
Z4WLhNv5KUq9pXAq09uIhB+7vMx4CgT4mQwCq44NFMzYSwx6d1tvwn5qsT5QNpQl
aVt6O57U1adkqo++hQKqT4eQHAjncgO6hNsArfGArYtpqzZFKinl7WGgAqIR0ke+
r8RrDHc/bTXoJNWqWliuxjx/+zD+9kgNhd1XiHqBdyW3n3PDkRo=
=K3Qo
-----END PGP SIGNATURE-----

--=-7X0eiBuHEsnYqyp8G4wx--
