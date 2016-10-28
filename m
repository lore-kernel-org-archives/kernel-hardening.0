Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 28 Oct 2016 19:27:10 +0200
From: Pavel Machek <pavel@ucw.cz>
Message-ID: <20161028172710.GA10309@amd>
References: <20161026204748.GA11177@amd>
 <20161027082801.GE3568@worktop.programming.kicks-ass.net>
 <20161027091104.GB19469@amd>
 <20161027093334.GK3102@twins.programming.kicks-ass.net>
 <CAGXu5jL=xzyPRQgOp5ON2+X0=5z4-jg4NyFCrTSrRPm5puOm0Q@mail.gmail.com>
 <20161027212747.GA18147@amd>
 <20161028095141.GA5806@leverpostej>
 <20161028112136.GA5635@amd>
 <20161028140522.GH5806@leverpostej>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <20161028140522.GH5806@leverpostej>
Subject: Re: [kernel-hardening] rowhammer protection [was Re: Getting
 interrupt every million cache misses]
To: Mark Rutland <mark.rutland@arm.com>
Cc: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> On Fri, Oct 28, 2016 at 01:21:36PM +0200, Pavel Machek wrote:
> > > Has this been tested on a system vulnerable to rowhammer, and if so, =
was
> > > it reliable in mitigating the issue?
> > >=20
> > > Which particular attack codebase was it tested against?
> >=20
> > I have rowhammer-test here,
> >=20
> > commit 9824453fff76e0a3f5d1ac8200bc6c447c4fff57
> > Author: Mark Seaborn <mseaborn@chromium.org>
>=20
> ... from which repo?

https://github.com/mseaborn/rowhammer-test.git

> > I do not have vulnerable machine near me, so no "real" tests, but
> > I'm pretty sure it will make the error no longer reproducible with the
> > newer version. [Help welcome ;-)]
>=20
> Even if we hope this works, I think we have to be very careful with that
> kind of assertion. Until we have data is to its efficacy, I don't think
> we should claim that this is an effective mitigation.

On my hardware, rowhammer errors are not trivial to reproduce. It
takes time (minutes). I'm pretty sure this will be enough to stop the
exploit. If you have machines where rowhammer errors are really easy
to reproduce, testing on it would be welcome.

> > Well, I'd like to postpone debate 'where does it live' to the later
> > stage. The problem is not arch-specific, the solution is not too
> > arch-specific either. I believe we can use Kconfig to hide it from
> > users where it does not apply. Anyway, lets decide if it works and
> > where, first.
>=20
> You seem to have forgotten the drammer case here, which this would not
> have protected against. I'm not sure, but I suspect that we could have
> similar issues with mappings using other attributes (e.g write-through),
> as these would cause the memory traffic without cache miss events.

Can you get me example code for x86 or x86-64? If this is trivial to
workaround using movnt or something like that, it would be good to
know.

I did not go through the drammer paper in too great detail. They have
some kind of DMA-able memory, and they abuse it to do direct writes?
So you can "simply" stop providing DMA-able memory to the userland,
right? [Ok, bye bye accelerated graphics, I guess. But living w/o
graphics acceleration is preferable to remote root...]

OTOH... the exploit that scares me most is javascript sandbox
escape. I should be able to stop that... and other JIT escape cases
where untrusted code does not have access to special instructions.

On x86, there seems to be "DATA_MEM_REFS" performance counter, if
cache misses do not account movnt, this one should. Will need checking.

> Perhaps, but that depends on a number of implementation details. If "too
> often" means "all the time", people will turn this off when they could
> otherwise have been protected (e.g. if we can accurately monitor the
> last level of cache).

Yup. Doing it well is preferable to doing it badly.

> > > * On some implementations, it may be that the counters are not
> > >   interchangeable, and for those this would take away
> > >   PERF_COUNT_HW_CACHE_MISSES from existing users.
> >=20
> > Yup. Note that with this kind of protection, one missing performance
> > counter is likely to be small problem.
>=20
> That depends. Who chooses when to turn this on? If it's down to the
> distro, this can adversely affect users with perfectly safe DRAM.

You don't want this enabled on machines with working DRAM, there will
be performance impact.

> > > > +	/* FIXME msec per usec, reverse logic? */
> > > > +	if (delta < 64 * NSEC_PER_MSEC)
> > > > +		mdelay(56);
> > > > +}
> > >=20
> > > If I round-robin my attack across CPUs, how much does this help?
> >=20
> > See below for new explanation. With 2 CPUs, we are fine. On monster
> > big-little 8-core machines, we'd probably trigger protection too
> > often.
>=20
> We see larger core counts in mobile devices these days. In China,
> octa-core phones are popular, for example. Servers go much larger.

Well, I can't help everyone :-(. On servers, there's ECC. On phones,
well, don't buy broken machines. This will work, but performance
impact will not be nice.

> > +static struct perf_event_attr rh_attr =3D {
=2E..
> > +	.sample_period =3D 10000,
> > +};
>=20
> What kind of overhead (just from taking the interrupt) will this come
> with?

This is not used, see below.

> > +/*
> > + * How often is the DRAM refreshed. Setting it too high is safe.
> > + */
>=20
> Stale comment? Given the check against delta below, this doesn't look to
> be true.

Thinko, actually. Too low is safe, AFAICT.

> > +/*
> > + * DRAM is shared between CPUs, but these performance counters are per=
-CPU.
> > + */
> > +	int max_attacking_cpus =3D 2;
>=20
> As above, many systems today have more than two CPUs. In the drammmer
> paper, it looks like the majority had four.

We can do set this automatically, and we should also take cpu hotplug
into account. But lets get it working first.

Actually in the ARM case (Drammer), it may be better to stop exploit
some other way. Turning off/redesigning GPU acceleration should work
there, right?

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgTim4ACgkQMOfwapXb+vLchwCfUfVADZhOqMZpaLWbD5DHOdJs
cc4An191/K/HNOlBat/1AK+HCgkmWA4D
=CurH
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
