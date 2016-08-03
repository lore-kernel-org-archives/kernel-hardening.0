Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1470228801.19955.38.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Wed, 03 Aug 2016 08:53:21 -0400
In-Reply-To: <1470227290.19955.30.camel@gmail.com>
References: <1469630746-32279-1-git-send-email-jeffv@google.com>
	 <20160802095243.GD6862@twins.programming.kicks-ass.net>
	 <CAGXu5j+q4qWFspRCPEd5-MM05Sh_r6VYSQhP7gcAuRMygeZwjg@mail.gmail.com>
	 <20160802203037.GC6879@twins.programming.kicks-ass.net>
	 <CAGXu5jJ+b4mWQ+RwPLo26di1qUwKT344GoN6xwzA1fw5Ke=ydA@mail.gmail.com>
	 <20160803082830.GA3163@gmail.com> <1470227290.19955.30.camel@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-1SHrwI1+tCED2XSg4WYJ"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Re: [PATCH 1/2] security, perf: allow
 further restriction of perf_event_open
To: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Jeff Vander Stoep <jeffv@google.com>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, "Eric W. Biederman" <ebiederm@xmission.com>
List-ID: <kernel-hardening.lists.openwall.com>


--=-1SHrwI1+tCED2XSg4WYJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Having this in Yama would also make it probable that there would be a
security-centric default. It would end up wiping out unprivileged perf
events access on distributions using Yama for ptrace_scope unless they
make the explicit decision to disable it. Having the perf subsystem
extend the existing perf_event_paranoid sysctl leaves the control over
the upstream default in the hands of the perf subsystem, not LSMs.
--=-1SHrwI1+tCED2XSg4WYJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIzBAABCAAdBQJXoelBFhxkYW5pZWxtaWNheUBnbWFpbC5jb20ACgkQ+ecS5Zr1
8iq7jhAAiiY6jGZV/rt0Z7mRYBvJDu/j/LQDfltDlLOvIJCMjUKaL0viXYp+1Vrq
gVf6U9BiGHHwwflvSoujK/ay34JNTM+7B935QIeQJHedQ36O88Xo4SmKVPrjmIXk
XLAw6WOafzcy/j6ZhJPULm1c2bMrIXcmwe9cYMOtc2VKB5rhfeaRq5OIEWiTBfMh
/YKC0SSDYhoUBQQKaryaRGvhHTyUHW93g3a5CPChl7EyrnkRM7NNx59/pzXgMSGc
8+Ohylv7L0kPLlXYKL6xj/0dr2dqFe8gpd2IBpYsr0eD1vW7AtnTC7btopLppf6k
8VPe1qNFogAplbij50irteTXjURbu/0OTnsmYx7JAZJcz87hf/dEtEYaid9+s5Jw
JdVClHsYGNGhrX2Rc/d1paLnH5E4PXc3xw7DvIEV+RGRRp+iOLC6nG7wyo1fYZii
qFRbLKfFCMmW2QD3TAnZ7/8+8a6/4My70324R9F07JnDmb21z2oa4v05e2+lrktR
Az7l1bAmP69ObuRjLiqVvtIuhXVpdM/gv3E+wxr2Kw5ZCrl2ufgsBPFh9RCzvc3h
noM7brdHRX4j/9ekX+o5vqjvg4PqE5MjqE/QMK2GMQmUIAjV3WoIQzLdQqspvxQ8
b3N5gHYgmF6kbfZekth+qwBw0DsMj9KOnOFPXZtOKUm/cG9eONo=
=+s2j
-----END PGP SIGNATURE-----

--=-1SHrwI1+tCED2XSg4WYJ--
