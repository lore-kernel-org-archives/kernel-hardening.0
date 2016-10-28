Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 28 Oct 2016 20:30:14 +0200
From: Pavel Machek <pavel@ucw.cz>
Message-ID: <20161028183013.GA13354@amd>
References: <20161026204748.GA11177@amd>
 <20161027082801.GE3568@worktop.programming.kicks-ass.net>
 <20161027091104.GB19469@amd>
 <20161027093334.GK3102@twins.programming.kicks-ass.net>
 <CAGXu5jL=xzyPRQgOp5ON2+X0=5z4-jg4NyFCrTSrRPm5puOm0Q@mail.gmail.com>
 <20161027212747.GA18147@amd>
 <20161028095141.GA5806@leverpostej>
 <20161028112136.GA5635@amd>
 <20161028140522.GH5806@leverpostej>
 <20161028141840.GI3142@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
In-Reply-To: <20161028141840.GI3142@twins.programming.kicks-ass.net>
Subject: Re: [kernel-hardening] rowhammer protection [was Re: Getting
 interrupt every million cache misses]
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2016-10-28 16:18:40, Peter Zijlstra wrote:
> On Fri, Oct 28, 2016 at 03:05:22PM +0100, Mark Rutland wrote:
> >=20
> > > > * the precise semantics of performance counter events varies drasti=
cally
> > > >   across implementations. PERF_COUNT_HW_CACHE_MISSES, might only ma=
p to
> > > >   one particular level of cache, and/or may not be implemented on a=
ll
> > > >   cores.
> > >=20
> > > If it maps to one particular cache level, we are fine (or maybe will
> > > trigger protection too often). If some cores are not counted, that's =
bad.
> >=20
> > Perhaps, but that depends on a number of implementation details. If "too
> > often" means "all the time", people will turn this off when they could
> > otherwise have been protected (e.g. if we can accurately monitor the
> > last level of cache).
>=20
> Right, so one of the things mentioned in the paper is x86 NT stores.
> Those are not cached and I'm not at all sure they're accounted in the
> event we use for cache misses.

Would you (or someone) have pointer to good documentation source on
available performance counters?

Rowhammer is normally done using reads (not writes), exploiting fact
that you can modify memory just by reading it. But it may be possible
that writes have similar effect, and that attacker cells can be far
enough from victim cells that it is a problem.

MOVNTDQA could be another problem, but hopefully that happens only on
memory types userland does not have access to.

Hmm, and according to short test, movnt is not counted:

pavel@duo:/data/l/linux/tools$ sudo perf_3.16 stat
--event=3Dcache-misses ./a.out
^C./a.out: Interrupt

 Performance counter stats for './a.out':

            61,271      cache-misses

      11.605840031 seconds time elapsed

long long foo;

void main(void)
{
	foo =3D &foo;
	while (1) {
	      asm volatile(
	      	  "mov foo, %edi \n\
		  movnti %eax, (%edi)");
	}
}
						=09

								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgTmTUACgkQMOfwapXb+vKXmACfRKLpdx1ajiU2LEfYIboqr6gM
pHkAn0FNavhiWFNc4q7M0zPGRshEMcYO
=4OlY
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
