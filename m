Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1466180207.849.50.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Fri, 17 Jun 2016 12:16:47 -0400
In-Reply-To: <20160617065427.GL30154@twins.programming.kicks-ass.net>
References: <20160111151958.GQ28542@decadent.org.uk>	
 <20160111152355.GS28542@decadent.org.uk>	
 <CAGXu5jLT+GR8DEOYLaY4KgZJP=9HEX+w+=mz5fomAMTBr_2Zow@mail.gmail.com>	
 <CABXk95BE3wpgq-Y08G+Z3ZJbxJwgiuVvtQGaV4n-tD6GKNiFKg@mail.gmail.com>	
 <CAGXu5j+D00zz7dVPX4LpW41Gk=m7G_h25vZgOyYdVbW+wyvj6Q@mail.gmail.com>
	 <20160617065427.GL30154@twins.programming.kicks-ass.net>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-eSXDaRwhwiDGyKDltTwA"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] [PATCH 2/2] security,perf: Allow further
 restriction of perf_event_open
To: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


--=-eSXDaRwhwiDGyKDltTwA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2016-06-17 at 08:54 +0200, Peter Zijlstra wrote:
> On Thu, Jun 16, 2016 at 03:27:55PM -0700, Kees Cook wrote:
> > Hi guys,
> >=20
> > This patch wasn't originally CCed to you (I'm fixing that now).
> > Would
> > you consider taking this into the perf tree?=C2=A0
>=20
> No.
>=20
> > It's been in active use
> > in both Debian and Android for a while now.
>=20
> Very nice of you all to finally inform us I suppose :/

It was in Debian a lot longer than Android, although the Android feature
came from a downstream variant where it was done much earlier:

https://android-review.googlesource.com/#/c/233736/

> > > > >=20
> > > > > access to performance events by users without CAP_SYS_ADMIN.
> > > > > Add a Kconfig symbol CONFIG_SECURITY_PERF_EVENTS_RESTRICT that
> > > > > makes this value the default.
> > > > >=20
> > > > > This is based on a similar feature in grsecurity
> > > > > (CONFIG_GRKERNSEC_PERF_HARDEN).=C2=A0=C2=A0This version doesn't i=
nclude
> > > > > making
> > > > > the variable read-only.=C2=A0=C2=A0It also allows enabling furthe=
r
> > > > > restriction
> > > > > at run-time regardless of whether the default is changed.
>=20
> This Changelog is completely devoid of information. _WHY_ are you
> doing
> this?

Attack surface reduction. It's possible to use seccomp-bpf for some
limited cases, but it's not flexible enough. There are lots of
information leaks and local privilege escalation vulnerabilities via
perf events, yet on most Linux installs it's not ever being used. So
turning it off by default on those installs is an easy win. The holes
are reduced to root -> kernel (and that's not a meaningful boundary in
mainline right now - although as is the case here, Debian has a bunch of
securelevel patches for that).
--=-eSXDaRwhwiDGyKDltTwA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXZCJvAAoJEPnnEuWa9fIqw7sP/Rwcr0GvyzDShUJOj7VwA63w
5iqBE1CEXTNvh8W8tgui3ThpbIgRc/M+IdfUjSN225l3AvSmOxKp366eoUwLAjO0
DmPOFDbrApo5szN1mzb0xVkqhULAcNzdpscj4UOU7YyjMfQPAq91ntG29D0vo7sq
WL6g6DMcsvySXgLDGNHS9GUjIkN7auaN0rOech7K880bhTm9FMRuxWvh8VtNgRF3
vDIFayO/j9miEY9NIgw5StdlGFJELra5L8p0B0yHfh40AcX3lb4xrAMn4/D0AdZv
Gt1EZeg0wLe0DlNdBEvJAcxIIhNNN0z0dQM88Y+tGlYBwJJEj62N75tGyrf2oCsr
2Krf7xDoq5PzsUr5UFSvLBcQmq4MtxJ5A1Fp64M8IXniegWpPq5rrSZHSN4dExKz
QF7woaeQg4aIgSGwJ2LCXJjm4fuF52VwkO+Q6tfku6Fc3nCQbR2St0t/mbUrySTG
68bkrLX9QEEC1+ctlGTu3dNMAHdgaIfhrIJFlxyJ4aDBQJ9IagQab9s5XIMVFF9b
GbzmmVQH+hXjgVKOWDu/a7Db4UBFb795qkwBq849FXyNAHZBKaUFX4AdMCBvapRk
KhkzwClZOBCpGdpov0QaRchfEt5wQVD5g+BhK0AYIMtL5VgzNLhqTiBG79fXTtWh
zFp+a98a3ifoOdC2fShQ
=w64C
-----END PGP SIGNATURE-----

--=-eSXDaRwhwiDGyKDltTwA--
