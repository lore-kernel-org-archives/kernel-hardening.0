Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1470318323.22643.70.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Thu, 04 Aug 2016 09:45:23 -0400
In-Reply-To: <20160804102854.GB4483@leverpostej>
References: <1469630746-32279-1-git-send-email-jeffv@google.com>
	 <20160802095243.GD6862@twins.programming.kicks-ass.net>
	 <CAGXu5j+q4qWFspRCPEd5-MM05Sh_r6VYSQhP7gcAuRMygeZwjg@mail.gmail.com>
	 <20160802203037.GC6879@twins.programming.kicks-ass.net>
	 <CAGXu5jJ+b4mWQ+RwPLo26di1qUwKT344GoN6xwzA1fw5Ke=ydA@mail.gmail.com>
	 <87shulix2z.fsf@x220.int.ebiederm.org>
	 <1470252976.22643.41.camel@gmail.com> <20160804102854.GB4483@leverpostej>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-1vtBHCk0HlujxRydRT/r"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Re: [PATCH 1/2] security, perf: allow
 further restriction of perf_event_open
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Jeff Vander Stoep <jeffv@google.com>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>
List-ID: <kernel-hardening.lists.openwall.com>


--=-1vtBHCk0HlujxRydRT/r
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2016-08-04 at 11:28 +0100, Mark Rutland wrote:
> On Wed, Aug 03, 2016 at 03:36:16PM -0400, Daniel Micay wrote:
> >=20
> > There's a lot of architecture and vendor specific perf events code
> > and
> > lots of bleeding edge features. On Android, a lot of the perf events
> > vulnerabilities have been specific to the Qualcomm SoC platform.
> > Other
> > platforms are likely just receiving a lot less attention.
>=20
> Are the relevant perf drivers for those platforms upstream? I've seen
> no
> patches addressing security issues in the ARMv7 krait+Scorpion PMU
> driver since it was added, and there's no ARMv8 QCOM PMU driver.
>=20
> If there are outstanding issues, please report them upstream.
>=20
> FWIW, I've used Vince Weaver's perf fuzzer to test the ARM PMU code
> (both the framework and drivers), so other platforms are seeing some
> attention. That said, I haven't done that recently.

Qualcomm's perf driver is out-of-tree along with most of their other
drivers. Their drivers add up to a LOT of code shared across over a
billion mobile devices, leading to the focus on them. It also helps that
there are bounties for Nexus devices, so there are multi thousand dollar
rewards for bugs in the Qualcomm drivers compared to nothing for other
platforms / drivers. Now that perf is only available via ADB debugging,
further perf bugs no longer technically qualify for their bounties (but
they might still pay, I don't know).
--=-1vtBHCk0HlujxRydRT/r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIzBAABCAAdBQJXo0bzFhxkYW5pZWxtaWNheUBnbWFpbC5jb20ACgkQ+ecS5Zr1
8ip7cA//X9fgSHlITAWparMeffM8JSJ3DzCQk7KE7HmNzw86F4QvNVT9QINwamdh
UsPu4gRzAzoRNLt/YQ9dI6Li+yVJIK7cF4f5JaoPrkSV/SiJkKWjFkFtT2l0NxQl
7vc2CoPgRxOXk1xmbtLnxpqrKnYVfvUv0q8/VR6aOZUuY4xzoHwGoT/A7AG7yMxh
1ppASufWtbo5+EXBrvAvXfpSm/knsYNLJl1cl5zxjxsARdUhonO3INuqnORnmost
eDJWd/VSAfj/aQHfZUx3GRFRKnSv4USfaovgaoF7Ur+d4HZlsR8scTcCxyuiVUsA
I3AQwRT7p26SrlKETX2zvse9A/ekDozfjd9P1lPRSDT0V0M0kKgxlloYkxyg1uxv
Ofz69ZJ7RhJpQH4Za+vUWSGPXtDs4F0Id5VtcvsgmEgyesEkxXPcW8VRPkyNMHjB
e9GkoxASqmoZHCMLBW0iYdK/I2bG5Bln/j/prOksZGmUfegtj+VtM2TRvOunzx4j
JLm7YFaS5vNnP8/AGycnZMF1qCDvlWSeG5ZuLxZkt7we2mxRykRiMoaAiLl5/Vcd
8PHtIk9BwLiGjoetNnpr3yOCVM33gxCG4QW/sOXf2/IWOZvhyJ0Ky+6pDtrCKZ/R
KB6HX+1Ky+cqtVYVKKgKxwzCtN3P7sN/FCnNSRsJoeTgehcusQU=
=iPaz
-----END PGP SIGNATURE-----

--=-1vtBHCk0HlujxRydRT/r--
