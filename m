Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 31 Oct 2016 09:27:05 +0100
From: Pavel Machek <pavel@ucw.cz>
Message-ID: <20161031082705.GA2863@amd>
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
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <20161028140522.GH5806@leverpostej>
Subject: Re: [kernel-hardening] rowhammer protection [was Re: Getting
 interrupt every million cache misses]
To: Mark Rutland <mark.rutland@arm.com>
Cc: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>


--/04w6evG8XlLl3ft
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
>=20
> > I do not have vulnerable machine near me, so no "real" tests, but
> > I'm pretty sure it will make the error no longer reproducible with the
> > newer version. [Help welcome ;-)]
>=20
> Even if we hope this works, I think we have to be very careful with that
> kind of assertion. Until we have data is to its efficacy, I don't think
> we should claim that this is an effective mitigation.

Ok, so it turns out I was right. On my vulnerable machine, normally
bug is reproducible in less than 500 iterations:

Iteration 432 (after 1013.31s)
  error at 0xda7cf280: got 0xffffffffffffffef
Iteration 446 (after 1102.56s)
  error at 0xec21ea00: got 0xffffffefffffffff
Iteration 206 (after 497.50s)
  error at 0xd07d1438: got 0xffffffffffffffdf
Iteration 409 (after 1350.96s)
  error at 0xbd3b9108: got 0xefffffffffffffff
Iteration 120 (after 326.08s)
  error at 0xe398c438: got 0xffffffffffffffdf

With nohammer, I'm at 2300 iterations, and still no faults.

Daniel Gruss <daniel@gruss.cc> claims he has an attack that can do 30
flips a second on modern hardware. I'm not going to buy broken
hardware just for a test. Code is at
https://github.com/IAIK/rowhammerjs/tree/master/native . Would someone
be willing to get it running on vulnerable machine and test kernel
patches?

Thanks,

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgXAFkACgkQMOfwapXb+vK3DwCeIlEzdz9g+/28y1DgmQXdLqlx
RREAoIS+SBlTGml2wOzOYPoaZkGU+z1Y
=FirG
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
