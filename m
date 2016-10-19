Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1476891544.4032.11.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Wed, 19 Oct 2016 11:39:04 -0400
In-Reply-To: <20161019102602.GA25522@kernel.org>
References: <1469630746-32279-1-git-send-email-jeffv@google.com>
	 <20161017134413.GK29095@leverpostej>
	 <CAGXu5jLnjWV5i3-6+wE2ME0fr4QcMsvtwQ2Q2AZNurxrxKBfRA@mail.gmail.com>
	 <1476825301.4032.7.camel@gmail.com>
	 <20161019100126.GI3102@twins.programming.kicks-ass.net>
	 <20161019102602.GA25522@kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-aVODqEHD+Ce685wk9hAX"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] [PATCH 1/2] security, perf: allow further
 restriction of perf_event_open
To: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>, Peter Zijlstra <peterz@infradead.org>
Cc: kernel-hardening@lists.openwall.com, Mark Rutland <mark.rutland@arm.com>, Ingo Molnar <mingo@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jeff Vander Stoep <jeffv@google.com>
List-ID: <kernel-hardening.lists.openwall.com>


--=-aVODqEHD+Ce685wk9hAX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2016-10-19 at 07:26 -0300, Arnaldo Carvalho de Melo wrote:
>=20
> But self profiling JITs would be useful for non-developers, on Android
> (anywhere, really), and for that it would require being able to at
> least, well, self profile, using sys_perf_event_open() by a normal
> process, limited to profiling itself, no?
>=20
> This not being possible, self profiling will use some other means, its
> like sys_perf_event_open() never existed for them.
>=20
> - Arnaldo

It would defeat the purpose of the security feature if it was exposed to
apps on Android. There are other ways for Chromium (including WebView)
and the ART JIT to profile. AFAIK, they've never actually considered
using perf for their JIT profiling. It wasn't something that anyone
cared about when this was implemented.

Chromium would *certainly* never use perf for this. They use a much
tighter sandbox than the Android app sandbox. It doesn't have system
calls like open(), let alone perf events. Their seccomp-bpf usage is to
reduce kernel attack surface, since it has proven to be the easiest way
out of a sandbox. They don't even allow futex() without filtering based=20
on the parameters anymore. That proved to be a major
issue.

The only case where untrusted apps declaring the privileges they need
actually works out is when the privileges are high-level controls over
access to a user's personal information. That way, they can be exposed
to the user with the ability to reject access when it's first needed or
toggle it off later. The strength of the app sandbox isn't something
that end users can be responsible for. Permissions also don't work if
apps bypass them with local privilege escalation vulnerabilities.

Even for the base system, no perf access is better than having it used
anywhere. The difference is only that the base system can actually be
trusted to declare what it needs, but those components can be exploited
so it's still best if they are trusted as little as possible at runtime.

I could see Android completely removing unprivileged access down the
road too, not as a form of access control (apps already run as unique
uid/gid pairs, etc.) but to remove a non-trivial form of kernel attack
surface. The perf API isn't being singled out here. It just happened to
be the first case where a kernel API was restricted to developer usage
on Android. Should expect more of this.

If you want perf exposed, make it secure. Stop writing kernel code in a
memory unsafe language and start using isolation. Not going to happen in
all likelihood, so kernel code will be increasingly walled off instead
since it's the biggest liability on the system. Fixing bugs on a case by
case basis doesn't work for systems that need even basic security.
--=-aVODqEHD+Ce685wk9hAX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdBQJYB5OZFhxkYW5pZWxtaWNheUBnbWFpbC5jb20ACgkQ+ecS5Zr1
8ioKNg//doRuU/akc2OnyiBA/8/6hVygrNQOLPHwL5/r+VISxPFajsupPugf07Bf
0iDlQzFr0LBWj5HYsIScaoyoF+6UIe0XZHB7CD7yOiJJQGF52AHWXru97tof63+r
e8K6un9rrspysHx76bhfcn+u2Id08ehQEt2vGmIGZUIw2voqk2VDhkvSvMODByqg
AUS8DcXexqysHgZ3K8w5mJ2YuY1ceUiR9x18zD6hAei6dEyIwM4AUxIqgmytPhzO
Bp7DXU2jME+CtQGWdchmIggOzvWP4qf9BUXfo7I+tgTQYe92abd6RMOlDFoIv/4z
ZTbsw7LgJbSt06hHz3nmua8Ahet5noRwIl5bxhUzFbWz+IKE9jdpamAau+TRNx62
ievNs2rmTp0PzuErIMbP5Pzt/GboSOx0huklT8/6hlHoZSxZMIRvCNsmToB2hm34
gpDSiZPvt7abIYQ0cf1kOdcUs8qA2ZaZateV1YQoZJwbm127BJUJsbTey+Zx9507
mib3OJDLPWYC68pMVlMuppLZQyrNRSR+JNbardHHH7fHPoX3k/Go89MpXTQMSxdw
pgo9o2xqLx1DeB6YsbTGDN9rafgr68b3a2bqtgd6uinhhxpWw5V/CuLpxW7tCsYo
/+QdbVWHnzXJAAZSuiQYRrFx/aisFezfWPdPOMj1WtHv2NOqUaQ=
=3Szv
-----END PGP SIGNATURE-----

--=-aVODqEHD+Ce685wk9hAX--
