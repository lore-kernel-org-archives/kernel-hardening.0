Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1470325468.22643.95.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Thu, 04 Aug 2016 11:44:28 -0400
In-Reply-To: <20160804141109.GM6879@twins.programming.kicks-ass.net>
References: <1469630746-32279-1-git-send-email-jeffv@google.com>
	 <20160802095243.GD6862@twins.programming.kicks-ass.net>
	 <CAGXu5j+q4qWFspRCPEd5-MM05Sh_r6VYSQhP7gcAuRMygeZwjg@mail.gmail.com>
	 <20160802203037.GC6879@twins.programming.kicks-ass.net>
	 <CAGXu5jJ+b4mWQ+RwPLo26di1qUwKT344GoN6xwzA1fw5Ke=ydA@mail.gmail.com>
	 <87shulix2z.fsf@x220.int.ebiederm.org>
	 <1470252976.22643.41.camel@gmail.com> <20160804102854.GB4483@leverpostej>
	 <1470318323.22643.70.camel@gmail.com>
	 <20160804141109.GM6879@twins.programming.kicks-ass.net>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-Mqa2422uxmxBrkG68vxg"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Re: [PATCH 1/2] security, perf: allow
 further restriction of perf_event_open
To: Peter Zijlstra <peterz@infradead.org>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Jeff Vander Stoep <jeffv@google.com>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>
List-ID: <kernel-hardening.lists.openwall.com>


--=-Mqa2422uxmxBrkG68vxg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2016-08-04 at 16:11 +0200, Peter Zijlstra wrote:
> On Thu, Aug 04, 2016 at 09:45:23AM -0400, Daniel Micay wrote:
> >=20
> > Qualcomm's perf driver is out-of-tree along with most of their other
> > drivers.=C2=A0
>=20
>=20
> So you're asking us to maim upstream perf for some out of tree junk?
> Srously? *plonk*

This feature doesn't come from Android. The perf events subsystem in the
mainline kernel is packed full of vulnerabilities too. The problem is so
bad that pointing one of the public fuzzers at it for a short period of
time is all that's required to start finding them.

Qualcomm's drivers might be lower quality than core kernel code, but
they're way above the baseline set by mainline kernel drivers...

Shining the same light on mainline drivers wouldn't be pretty. The work
going into hardening the Qualcomm drivers isn't happening upstream to
any comparable extent.
--=-Mqa2422uxmxBrkG68vxg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIzBAABCAAdBQJXo2LcFhxkYW5pZWxtaWNheUBnbWFpbC5jb20ACgkQ+ecS5Zr1
8irfqw//QziB1kFoZK7PhVML1q8fs3kJed+wPy8mRYPpGYHZ4eL0TyMevgwq5Hne
H/kFGvJiwzt53WBJVk9nFoSZo8lrJ2wFJETbTacB3rCnOMrVdUdzDj0NW8Wko1g1
QKwAoNDLtOkgvq3Ub3DRNdaguHnX+EIk6a0NMoQd04/HDMy3gZRWDxhg8tB3TaKM
ScAghGG8IAdwrd+R2gFdEBWnvq3sqDYn4IjTBBz4I8rJ/8qx2362698ZfbAMNhIS
ziHNT3i9KvEZty4pTxxv10XuR4uiE3CZSffS/yicNpmAm4UBu8T9Io8Vlg3hbxeM
CPYjg8JPkjplMUHlZ6uCbO2CcI1uPxdh3CVXiYK5Gz1UwGEoPN89CflDoQu1yUSX
dhxMfzu92BfVziKcQLVf7epYX44uYKrIJkhyG8Di4AZlzIMOz70hil5kjY3KzeYi
SRRb5aFOS5r28dnoHEPVEtX6OaUnnugVu2KLkt8xhlFVwLIcTFs1hyFtGrfXv3q7
PJidz3NRxhMtdMYlsLshReEpnhqq/UgH0aij2MxaId/AUE9HGDas9nC7tZaTIzi0
5aFg1llW6J+SXks8mligIp68abb4Z7cxGmBmvR3pbqRw8AI0lx8x4FwYVMJG2/FV
WklvhPZJ7aiWpN3PvZMrLIM0dpokQMjmDwQashTOca5igDo2iPU=
=OXrZ
-----END PGP SIGNATURE-----

--=-Mqa2422uxmxBrkG68vxg--
