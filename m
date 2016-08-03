Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1470252976.22643.41.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Wed, 03 Aug 2016 15:36:16 -0400
In-Reply-To: <87shulix2z.fsf@x220.int.ebiederm.org>
References: <1469630746-32279-1-git-send-email-jeffv@google.com>
	 <20160802095243.GD6862@twins.programming.kicks-ass.net>
	 <CAGXu5j+q4qWFspRCPEd5-MM05Sh_r6VYSQhP7gcAuRMygeZwjg@mail.gmail.com>
	 <20160802203037.GC6879@twins.programming.kicks-ass.net>
	 <CAGXu5jJ+b4mWQ+RwPLo26di1qUwKT344GoN6xwzA1fw5Ke=ydA@mail.gmail.com>
	 <87shulix2z.fsf@x220.int.ebiederm.org>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-xEcPaAw7LA1nF6DF8Kz7"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Re: [PATCH 1/2] security, perf: allow
 further restriction of perf_event_open
To: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Jeff Vander Stoep <jeffv@google.com>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>
List-ID: <kernel-hardening.lists.openwall.com>


--=-xEcPaAw7LA1nF6DF8Kz7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> One of the strengths of linux is applications of features the authors
> of
> the software had not imagined.=C2=A0=C2=A0Your proposals seem to be tryin=
g to
> put
> the world a tiny little box where if someone had not imagined and
> preapproved a use of a feature it should not happen.=C2=A0=C2=A0=C2=A0Let=
's please
> avoid implementing totalitarianism to avoid malicious code exploiting
> bugs in the kernel.=C2=A0=C2=A0I am not interested in that future.

You're describing operating systems like Android, ChromeOS and iOS.

That future is already here and the Linux kernel is the major weak point
in the attempts to build those systems based on Linux. Even for the very
restricted Chrome sandbox, it's the easiest way out.

Android similarly allows near zero access to /sys for apps and little
access to /proc beyond the /proc/PID directories belonging to an app.

> Especially when dealing with disabling code to reduce attack surface,
> when then are no known attacks what we are actually dealing with
> is a small percentage probability reduction that a malicious attacker
> will be able to exploit the attack.

There are perf events vulnerabilities being exploited in the wild to
gain root on Android. It's not a theoretical attack vector. They're used
in both malware and rooting tools. Local privilege escalation bugs in
the kernel are common so there are a lot of alternatives but it's one of
the major sources for vulnerabilities. There's a lot of architecture and
vendor specific perf events code and lots of bleeding edge features. On
Android, a lot of the perf events vulnerabilities have been specific to
the Qualcomm SoC platform. Other platforms are likely just receiving a
lot less attention.

> Remember security is as much about availability as it is about
> integrity.=C2=A0=C2=A0You keep imagining features that are great big deni=
al of
> service attacks on legitimate users.

Only developers care about perf events and they still have access to it.
JIT compilers have other ways to do tracing and even if they consider
this to be the ideal API, it's not particularly important if they have
to settle for something else. In reality, it's a small compromise.

> I vote for sandboxes.=C2=A0=C2=A0Perhaps seccomp.=C2=A0=C2=A0Perhaps a pe=
r userns sysctl.
> Perhaps something else.

It's not possible to use the current incarnation of seccomp for this
since it can't be dynamically granted/revoked. Perhaps it would be
possible to support adding/removing or at least toggling seccomp filters
for groups of processes. That would be good enough to take care of user
ns, ptrace, perf events, etc.
--=-xEcPaAw7LA1nF6DF8Kz7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIzBAABCAAdBQJXokewFhxkYW5pZWxtaWNheUBnbWFpbC5jb20ACgkQ+ecS5Zr1
8iovqhAAk4nsP1H+ZPB00bUkcFv0INx+3VqsSOIm6EmelrdO/2Z+qb4BzJz4BZ+0
vXpDVphyGFEKlXrBUUCigBWSW69EkxbA9LG+EFc+qd2DKx3yqLbcv77OXViJBTsk
Ek+2XQzSfSVp8wdI/fJ5gi3hPRMSDj35f+QYnAW1JGjKhWPMTb8oPHWHT7nwxukz
nnDdauBHIt9alBvQdaVIHkYCotRJWSvPbkIIxmgP4ZiHAGvBo8gL2UlTlxbKWz/G
EekBmDM/C3jghhM80HlkCnzf2XsiSLsl4nTY824bEQLAfr0K16pZ8YLD8+/OWO5z
AQMmTyHo8dqEgfFUVzafUOEAXGhEzEaAyDBG8kC2+MKGXiqa43FPf75jzPd8r9e5
wOLFOFXAENHZhZQFIsPmSdwbeGo9/6P6xmQfLEMfdUFm3XbcIfv4TZJT88rWlMv9
sfS7Bk411bqTHexoKoxI6OlPza13R03iijfqZEOgKgDrt/hGGCDGnKnOvaICr9y/
hX2h+i17FdFY9G8jjQjkCE+QWHYLTgXtwbt+Xji+Eeec1osnNHZ90oPCUNZxnAfD
ioIPsc4cG5As64ptiL2NTa9nZVQZMwGyg8+G/sUhVO6NCNK+KK1+VJFYiZE1ByQi
uKqokzFbb+VH8+ek23vNJrj7r6o5bxA1r+dgsTIZdLXG3XZu6kg=
=jmni
-----END PGP SIGNATURE-----

--=-xEcPaAw7LA1nF6DF8Kz7--
