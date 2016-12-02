Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 2 Dec 2016 09:17:59 +0800
From: Boqun Feng <boqun.feng@gmail.com>
Message-ID: <20161202011759.GA28026@tardis.cn.ibm.com>
References: <2236FBA76BA1254E88B949DDB74E612B41C1884B@IRSMSX102.ger.corp.intel.com>
 <20161128121347.GY3092@twins.programming.kicks-ass.net>
 <2236FBA76BA1254E88B949DDB74E612B41C190FC@IRSMSX102.ger.corp.intel.com>
 <20161201191543.GG3124@twins.programming.kicks-ass.net>
 <CAEXv5_isZ__znAw5vvE_srdP+irJW=TnUy2jQZxM33ZCAg037A@mail.gmail.com>
 <20161201230328.GS3045@worktop.programming.kicks-ass.net>
 <CAGXu5jLHLoPPPSEiHq-faWHDxJQWEnfc=HeC=RJ=umaqWX2Yiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
In-Reply-To: <CAGXu5jLHLoPPPSEiHq-faWHDxJQWEnfc=HeC=RJ=umaqWX2Yiw@mail.gmail.com>
Subject: [kernel-hardening] Re: Conversion from atomic_t to refcount_t: summary of issues
To: Kees Cook <keescook@chromium.org>
Cc: Peter Zijlstra <peterz@infradead.org>, David Windsor <dwindsor@gmail.com>, "Reshetova, Elena" <elena.reshetova@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Greg KH <gregkh@linuxfoundation.org>, "will.deacon@arm.com" <will.deacon@arm.com>, Hans Liljestrand <ishkamiel@gmail.com>, "aik@ozlabs.ru" <aik@ozlabs.ru>, "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
List-ID: <kernel-hardening.lists.openwall.com>


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 01, 2016 at 03:20:29PM -0800, Kees Cook wrote:
> On Thu, Dec 1, 2016 at 3:03 PM, Peter Zijlstra <peterz@infradead.org> wro=
te:
> > On Thu, Dec 01, 2016 at 04:31:16PM -0500, David Windsor wrote:
> >> Also, I'd like to point out that while identifying stats_t instances, I
> >> have found a similar distribution of non-standard functions (as agreed=
 upon
> >> for the stats_t API).
> >
> >> First, usage of atomic_long_wrap_t (there currently isn't a stats_long=
_t
> >> planned for implementation):
> >
> > There isn't even a stats_t planned. I'm still very much not convinced
> > stats_t is needed or even makes sense.
> >
> > It wouldn't have any different semantics from atomic_t, and the only
> > argument Kees made was that reduced atomic_t usage would make it easier
> > to spot refcounts, but you're already building tools to find those.
> >
> > Once the tools work, who cares.
>=20
> The tool is only part of the whole thing. By distinctly splitting the
> other major atomic_t usage pattern away from atomic_t, it solidifies a
> stats_t as NOT a reference counter. It's the slow feature-creep or bad
> example situations that I'd like to avoid. Also, tools won't catch
> everything, and doing manual inspection is much easier if we know a
> stats_t cannot be misused.
>=20
> There doesn't seem to be a good reason NOT to have stats_t, beyond the
> work needed to create it and audit the places it should be used.
>=20

So we currently don't have a clear semantics for stats_t, do we? What
kind of atomic_t should be replaced with stats_t? In the link David
pointed out, there are a few cases where a stats_t is put on a
correctness-related variable. I don't think that's a good place to use
stats_t.

Besides, there are many statistics-purpose variables in kernel which are
not atomic, given those, only calling atomic statistic variables stats_t
seems inappropriate and misleading.

How about provide a modifier, say __stats, like __rcu, __percpu. We can
add it to the types of the variables that are only for
statistics-purpose. I think it won't be difficult to find all related
callsites of a __stats with the help of some compiler frontend tools, we
can then detect a possible problem if we do a cmpxchg on a __stats,
which is unlikely a proper usage for a statistic variable. And we don't
need to change or use special APIs, we just need to mark variables and
fields.

Thoughts?

Regards,
Boqun

> -Kees
>=20
> --=20
> Kees Cook
> Nexus Security

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEcBAABCAAGBQJYQMvDAAoJEEl56MO1B/q4AngH/05rn42XjRH7egRawuz+4u1T
sM7prjF6U2TWPmFPac3tqh9paELsXevtGkscn09ce/B0Cy0KmGAFLQ8q7ZVUcAmk
t1bsN9QtefOng7YlfHJODDTshtm8Xff9f1bcovtfxbHJt+YZE8w5n5Mbb8748IyQ
4bpGFcczoze+9/68Z7ayNGAgrOD/eaXfNhAzufB8V9d0r6fIeTjmsUeKXeuOwh0o
RLq5xVIm2ehHB1S52iQ6k517tt+sjcIJRgy/Qa0aE0tGeBVf1CP57l7qyINaqv86
5PH4kFFUVHbbzHOAsOPfut8ABQD9O+Z5Xrc0A/vn6ZkJ/GS5q2B9SgD+yVSJYTQ=
=FAsl
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
