Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 1 Nov 2016 09:10:43 +0100
From: Pavel Machek <pavel@ucw.cz>
Message-ID: <20161101081043.GA27659@amd>
References: <20161027082801.GE3568@worktop.programming.kicks-ass.net>
 <20161027091104.GB19469@amd>
 <20161027093334.GK3102@twins.programming.kicks-ass.net>
 <CAGXu5jL=xzyPRQgOp5ON2+X0=5z4-jg4NyFCrTSrRPm5puOm0Q@mail.gmail.com>
 <20161027212747.GA18147@amd>
 <20161028095141.GA5806@leverpostej>
 <20161028112136.GA5635@amd>
 <20161028140522.GH5806@leverpostej>
 <20161031082705.GA2863@amd>
 <20161101063359.GA27822@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
In-Reply-To: <20161101063359.GA27822@gmail.com>
Subject: Re: [kernel-hardening] rowhammer protection [was Re: Getting
 interrupt every million cache misses]
To: Ingo Molnar <mingo@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> * Pavel Machek <pavel@ucw.cz> wrote:
>=20
> > I'm not going to buy broken hardware just for a test.
>=20
> Can you suggest a method to find heavily rowhammer affected hardware? Onl=
y by=20
> testing it, or are there some chipset IDs ranges or dmidecode info that w=
ill=20
> pinpoint potentially affected machines?

Testing can be used. https://github.com/mseaborn/rowhammer-test.git
=2E It finds faults at 1 of 2 machines here (but takes half an
hour). Then, if your hardware is one of ivy/sandy/haswell/skylake,
https://github.com/IAIK/rowhammerjs.git can be used for much faster
attack (many flips a second).

Unfortunately, what I have here is:

cpu family     : 6
model	       	 : 23
model name	 : Intel(R) Core(TM)2 Duo CPU     E7400  @ 2.80GHz
stepping	 : 10
microcode	 : 0xa07

so rowhammerjs/native is not available for this system. Bit mapping
for memory hash functions would need to be reverse engineered for more
effective attack.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgYTgMACgkQMOfwapXb+vIeeACgs8XkNnYORWDI8AwinhWMKvd7
2fAAn1GEtRDpsN0da/j1JjnVTRB2kyv4
=Wojg
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
