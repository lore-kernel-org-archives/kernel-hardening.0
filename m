Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 2 Nov 2016 19:13:49 +0100
From: Pavel Machek <pavel@ucw.cz>
Message-ID: <20161102181349.GA28047@amd>
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
	protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
In-Reply-To: <20161028141840.GI3142@twins.programming.kicks-ass.net>
Subject: Re: [kernel-hardening] rowhammer protection [was Re: Getting
 interrupt every million cache misses]
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

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

Well, I tried this... and the movnti is as fast as plain mov. Clearly
it is being cached here.

I guess we could switch to different performance counter, such as

+       [PERF_COUNT_HW_BUS_CYCLES]              =3D 0xc06f, /* Non
halted bus cycles: 0x013c */

if NT stores are indeed a problem. But so far I don't have any
indication they are, so I'd like to have an working example to test
against. (It does not have to produce bitflips, it would be enough to
produce enough memory traffic bypassing cache.)

Best regards,
								Pavel

/*
 * gcc -O2 rowhammer.c -o rowhammer
 */

char pad[1024];
long long foo;
char pad2[1024];

void main(void)
{
	long long i;
	asm volatile(
		"mov $foo, %%edi \n\
			clflush (%%edi)" ::: "%edi");
=09
	for (i=3D0; i<1000000000; i++) {
#if 1
		asm volatile(
			"mov $foo, %%edi \n\
			movnti %%eax, (%%edi)" ::: "%edi");
#endif

		// asm volatile( "" );
	}
}


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgaLN0ACgkQMOfwapXb+vLqEgCfd5qd3bGKTerg4V/72BLh/ZBL
QQcAoKRVpHkpVoQ1bGUeQkspds6e2gQW
=TFw/
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
