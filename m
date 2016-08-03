Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1470227290.19955.30.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Wed, 03 Aug 2016 08:28:10 -0400
In-Reply-To: <20160803082830.GA3163@gmail.com>
References: <1469630746-32279-1-git-send-email-jeffv@google.com>
	 <20160802095243.GD6862@twins.programming.kicks-ass.net>
	 <CAGXu5j+q4qWFspRCPEd5-MM05Sh_r6VYSQhP7gcAuRMygeZwjg@mail.gmail.com>
	 <20160802203037.GC6879@twins.programming.kicks-ass.net>
	 <CAGXu5jJ+b4mWQ+RwPLo26di1qUwKT344GoN6xwzA1fw5Ke=ydA@mail.gmail.com>
	 <20160803082830.GA3163@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-0daHzNNEZdaSeg//GM6y"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Re: [PATCH 1/2] security, perf: allow
 further restriction of perf_event_open
To: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Jeff Vander Stoep <jeffv@google.com>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, "Eric W. Biederman" <ebiederm@xmission.com>
List-ID: <kernel-hardening.lists.openwall.com>


--=-0daHzNNEZdaSeg//GM6y
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> The default has no impact on the "it's too coarse and limiting"
> negative property=C2=A0
> of this patch, which is the show-stopper aspect. Please fix that
> aspect instead of=C2=A0
> trying to argue around it.

Disabling perf events in the kernel configuration is even more limiting,
and is currently the alternative to doing it this way. It makes sense
for debugging features to be disabled in production releases of products
unless there's a way to control them where risk isn't increased. Having
a way to toggle it dynamically will allow it to be remain available.

> This isn't some narrow debugging mechanism we can turn on/off globally
> and forget=C2=A0
> about, this is a wide scope performance measurement and event logging=C2=
=A0
> infrastructure that is being utilized not just by developers but by
> apps and=C2=A0
> runtimes as well.

The incredibly wide scope is why it's such a big security problem. If it
wasn't such a frequent source of vulnerabilities, it wouldn't have been
disabled for unprivileged users in grsecurity, Debian and then Android.
It's extended by lots of vendor code to specific to platforms too, so it
isn't just some core kernel code that's properly reviewed.

I don't think there are runtimes using this for JIT tracing. Perhaps it
doesn't actually suit their needs. It's a theoretical use case.

> > Let me take this another way instead. What would be a better way to
> > provide a=C2=A0
> > mechanism for system owners to disable perf without an LSM? (Since
> > far fewer=C2=A0
> > folks run with an enforcing "big" LSM: I'm seeking as wide a
> > coverage as=C2=A0
> > possible.)
>=20
> Because in practice what will happen is that if the only option is to
> do something=C2=A0
> drastic for sekjurity, IT departments will do it - while if there's a
> more=C2=A0
> flexible mechanism that does not throw out the baby with the bath
> water that is=C2=A0
> going to be used.

It's already done: Android and Debian disable it for unprivileged users
by default. It's already done for most of desktop and mobile Linux and
perhaps even most servers. Not providing functionality desired by
downstream doesn't mean it won't be provided there.

They'll keep doing it whether or not this lands. If it doesn't land, it
will only mean that mainline kernels aren't usable for making Android
devices. They need to pass the compatibility test suite, which means
having this. The mechanism could change but I don't see why the actual
requirement would.

> This is as if 20 years ago you had submitted a patch to the early
> Linux TCP/IP=C2=A0
> networking code to be on/off via a global sysctl switch and told
> people that=C2=A0
> "in developer mode you can have networking, talk to your admin".
>=20
> We'd have told you: "this switch is too coarse and limiting, please
> implement=C2=A0
> something better, like a list of routes which defines which IP ranges
> are=C2=A0
> accessible, and a privileged range of listen sockets ports and some
> flexible=C2=A0
> kernel side filtering mechanism to inhibit outgoing/incoming
> connections".
>=20
> Global sysctls are way too coarse.

The end result of submitting an LSM hook instead of using this would
probably come down to having a global sysctl toggle in Yama. There would
be two sysctl controls for perf restrictions rather than one which is
needless complexity for the interface.

Android and Debian would be using a fine-grained perf LSM to accomplish
the same thing: globally disabling it for unprivileged users when not
doing development. The nice thing about fine-grained control would be
implementing a *more* restrictive policy for the case when it's toggled
on. It wouldn't necessarily have to be globally enabled, only enabled
for the relevant user or even a specific process, but that would be
complicated to implement.
--=-0daHzNNEZdaSeg//GM6y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIzBAABCAAdBQJXoeNaFhxkYW5pZWxtaWNheUBnbWFpbC5jb20ACgkQ+ecS5Zr1
8ip/Fw/+JhkT7+r8oE1ZDTQWQrJCcRJDoUmGyhEVqDstIyADIfeipHJ9UE0uXxuR
0L7VduvTWfn/U6ObFGom9OQY1bN46RAiTUys0PQQTx8tKfrn/hnewmD0VP5ysdm9
uBk7Vi+c5RjRlZ29TM6hcbx1hrkbU/LSIZoI3oEyOSpJDtjlijnnictgXOEXsfpC
fYfmlslX4+qgcNU/sl+5K1tB7CBxEP3iLzHQ2AzGEpqGS8qa6mrST3AYNtuG0taN
jB9T1eAAlwhKOBhW5bTsArwU1Uqjwm5grZ8jICEOhfKjslI2pGvlUNFb4vjYQMRl
vN/On2g8Th8/z9lbrXPFN1U0L70JKzhwrQ9nCuvYcXyPlG2W7aUL278qXPcKPW5Z
ND4BS/5QKucgq5Uozo1abG1Z/eBdgdgDRekd04ndPHYfR5Gk1qWGYfjcxEUpFr4P
E7udI4Rof2o+96ReD2AXsmIcMnBAsf7l2jq4h6CqlRPnmoCTW0+AabKDBNP4bLBp
YR8x+K8KpP1GquT2KZgFBkJqyDxBBfTRWyN6UIMyQW7IdeCr+Hanmuks05wijLGf
WJxy5JUsH4dcJBz/5NauC36pjGYhenUud4Frf8WGEqNh56pCX/JE7LoMGVRaUx2w
Vrf22LjEGqOzCVXyRtBwcvRnjkXhZmm0h0AcBoPpzgvpBLJNoP8=
=AD+5
-----END PGP SIGNATURE-----

--=-0daHzNNEZdaSeg//GM6y--
