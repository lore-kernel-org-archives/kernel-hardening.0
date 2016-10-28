Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 28 Oct 2016 13:27:08 +0200
From: Pavel Machek <pavel@ucw.cz>
Message-ID: <20161028112707.GB5635@amd>
References: <20161026204748.GA11177@amd>
 <20161027082801.GE3568@worktop.programming.kicks-ass.net>
 <20161027091104.GB19469@amd>
 <20161027093334.GK3102@twins.programming.kicks-ass.net>
 <CAGXu5jL=xzyPRQgOp5ON2+X0=5z4-jg4NyFCrTSrRPm5puOm0Q@mail.gmail.com>
 <20161027212747.GA18147@amd>
 <20161028070701.GA11376@gmail.com>
 <20161028085039.GA15032@amd>
 <20161028090423.GY3102@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gatW/ieO32f1wygP"
Content-Disposition: inline
In-Reply-To: <20161028090423.GY3102@twins.programming.kicks-ass.net>
Subject: [kernel-hardening] Re: rowhammer protection [was Re: Getting interrupt every million
 cache misses]
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Kees Cook <keescook@chromium.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>


--gatW/ieO32f1wygP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > I agree this needs to be tunable (and with the other suggestions). But
> > this is actually not the most important tunable: the detection
> > threshold (rh_attr.sample_period) should be way more important.
>=20
> So being totally ignorant of the detail of how rowhammer abuses the DDR
> thing, would it make sense to trigger more often and delay shorter? Or
> is there some minimal delay required for things to settle or
 > something.

We can trigger more often and delay shorter, but it will mean that
protection will trigger with more false positives. I guess I'll play
with constants too see how big the effect is.

BTW...

[ 6267.180092] INFO: NMI handler (perf_event_nmi_handler) took too
long to run: 63.501 msecs

but I'm doing mdelay(64). .5 msec is not big difference, but...

Best regards,
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--gatW/ieO32f1wygP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgTNgsACgkQMOfwapXb+vJQVACdEnUaKPJsS465Ht/EPS2Ak6nZ
548AnRa6MSiB7zItnc4TJcLTTBQPy2x6
=rR+o
-----END PGP SIGNATURE-----

--gatW/ieO32f1wygP--
