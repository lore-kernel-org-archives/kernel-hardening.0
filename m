Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 31 Oct 2016 22:13:03 +0100
From: Pavel Machek <pavel@ucw.cz>
Message-ID: <20161031211303.GA15724@amd>
References: <20161027082801.GE3568@worktop.programming.kicks-ass.net>
 <20161027091104.GB19469@amd>
 <20161027093334.GK3102@twins.programming.kicks-ass.net>
 <CAGXu5jL=xzyPRQgOp5ON2+X0=5z4-jg4NyFCrTSrRPm5puOm0Q@mail.gmail.com>
 <20161027212747.GA18147@amd>
 <20161028095141.GA5806@leverpostej>
 <20161028112136.GA5635@amd>
 <20161028140522.GH5806@leverpostej>
 <20161031082705.GA2863@amd>
 <20161031144739.GA6007@remoulade>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
In-Reply-To: <20161031144739.GA6007@remoulade>
Subject: Re: [kernel-hardening] rowhammer protection [was Re: Getting
 interrupt every million cache misses]
To: Mark Rutland <mark.rutland@arm.com>
Cc: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2016-10-31 14:47:39, Mark Rutland wrote:
> On Mon, Oct 31, 2016 at 09:27:05AM +0100, Pavel Machek wrote:
> > > On Fri, Oct 28, 2016 at 01:21:36PM +0200, Pavel Machek wrote:
> > > > > Has this been tested on a system vulnerable to rowhammer, and if =
so, was
> > > > > it reliable in mitigating the issue?
>=20
> > > > I do not have vulnerable machine near me, so no "real" tests, but
> > > > I'm pretty sure it will make the error no longer reproducible with =
the
> > > > newer version. [Help welcome ;-)]
> > >=20
> > > Even if we hope this works, I think we have to be very careful with t=
hat
> > > kind of assertion. Until we have data is to its efficacy, I don't thi=
nk
> > > we should claim that this is an effective mitigation.
=2E..
>=20
> To be quite frank, this is anecdotal. It only shows one particular attack=
 is
> made slower (or perhaps defeated), and doesn't show that the mitigation is
> reliable or generally applicable (to other machines or other variants of =
the
> attack).

So... I said that I'm pretty sure it will fix problem in my testing,
then you say that I should be careful with my words, I confirm it was
true, and now you complain that it is anecdotal?

Are you serious?

Of course I know that fixing rowhammer-test on my machine is quite a
low bar to ask. _And that's also why I said I'm pretty sure I'd pass
that bar_.

I'm still asking for help with testing, but all you do is claim that
"we can't be sure".

> Even if this happens to work on some machines, I still do not think one c=
an
> sell this as a generally applicable and reliable mitigation. Especially g=
iven
> that others working in this area seem to have evidence otherwise, e.g. [1=
] (as
> noted by spender in the LWN comments).

Slowing this attack _is_ defeating it. It is enough to slow it 8
times, and it is gone, boom, not there any more.

Now.. I have to figure out what to do with movnt. No currently known
attack uses movnt. Still, that one should be solved.

Other than that... this is not magic. Attack is quite well
understood. All you have to do is prevent more than 8msec worth of
memory accesses. My patch can do that, and it will work,
everywhere... you just won't like the fact that your machine now works
on 10% of original performance.

Now, it is possible that researches will come up with attack that only
needs 2msec worth of accesses. So we change the constants. Performance
will be even worse. It is also possible that even more broken DRAM
comes out. Same solution. Plus someone certainly has a memory that
flips some bits even without help from funny access patterns. Too
bad. We can't help them.

Would it be less confusing if we redefined task description from
"prevent rowhammer" to "prevent more than X memory accesses in 64
msec"?

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

iEYEARECAAYFAlgXs94ACgkQMOfwapXb+vIhjQCfXUwqw3ptw0b5WCddHxVP6m1G
m2wAn2n3FTUmz7VfowZQNM/XxhvZMDR8
=neRu
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
