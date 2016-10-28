Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 28 Oct 2016 10:50:39 +0200
From: Pavel Machek <pavel@ucw.cz>
Message-ID: <20161028085039.GA15032@amd>
References: <20161026204748.GA11177@amd>
 <20161027082801.GE3568@worktop.programming.kicks-ass.net>
 <20161027091104.GB19469@amd>
 <20161027093334.GK3102@twins.programming.kicks-ass.net>
 <CAGXu5jL=xzyPRQgOp5ON2+X0=5z4-jg4NyFCrTSrRPm5puOm0Q@mail.gmail.com>
 <20161027212747.GA18147@amd>
 <20161028070701.GA11376@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
In-Reply-To: <20161028070701.GA11376@gmail.com>
Subject: [kernel-hardening] Re: rowhammer protection [was Re: Getting interrupt every million
 cache misses]
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2016-10-28 09:07:01, Ingo Molnar wrote:
>=20
> * Pavel Machek <pavel@ucw.cz> wrote:
>=20
> > +static void rh_overflow(struct perf_event *event, struct perf_sample_d=
ata *data, struct pt_regs *regs)
> > +{
> > +	u64 *ts =3D this_cpu_ptr(&rh_timestamp); /* this is NMI context */
> > +	u64 now =3D ktime_get_mono_fast_ns();
> > +	s64 delta =3D now - *ts;
> > +
> > +	*ts =3D now;
> > +
> > +	/* FIXME msec per usec, reverse logic? */
> > +	if (delta < 64 * NSEC_PER_MSEC)
> > +		mdelay(56);
> > +}
>=20
> I'd suggest making the absolute delay sysctl tunable, because 'wait 56 ms=
ecs' is=20
> very magic, and do we know it 100% that 56 msecs is what is needed
> everywhere?

I agree this needs to be tunable (and with the other suggestions). But
this is actually not the most important tunable: the detection
threshold (rh_attr.sample_period) should be way more important.

And yes, this will all need to be tunable, somehow. But lets verify
that this works, first :-).

Thanks and best regards,
								Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgTEV8ACgkQMOfwapXb+vInWgCgkxN612QLhTOaFrxBGh+uc6Op
5WMAoIRCUeLRxbOtQ0496Lc7Ij8nAxkl
=8m/2
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
