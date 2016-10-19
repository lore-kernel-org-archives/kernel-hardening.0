Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1476890160.4032.9.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Wed, 19 Oct 2016 11:16:00 -0400
In-Reply-To: <20161019094115.GC9616@leverpostej>
References: <1469630746-32279-1-git-send-email-jeffv@google.com>
	 <20161017134413.GK29095@leverpostej> <1476716073.4032.5.camel@gmail.com>
	 <20161019094115.GC9616@leverpostej>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-HnaYufBSCXV+yD3c0YAy"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] [PATCH 1/2] security, perf: allow further
 restriction of perf_event_open
To: kernel-hardening@lists.openwall.com
Cc: peterz@infradead.org, mingo@redhat.com, acme@kernel.org, alexander.shishkin@linux.intel.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Jeff Vander Stoep <jeffv@google.com>
List-ID: <kernel-hardening.lists.openwall.com>


--=-HnaYufBSCXV+yD3c0YAy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2016-10-19 at 10:41 +0100, Mark Rutland wrote:
> On Mon, Oct 17, 2016 at 10:54:33AM -0400, Daniel Micay wrote:
> > On Mon, 2016-10-17 at 14:44 +0100, Mark Rutland wrote:
> > > It's also my understanding that for Android, perf_event_paranoid
> > > is
> > > lowered when the user enables developer mode (rather than only
> > > when an
> > > external debugger is attached); is that correct?
> >=20
> > It's exposed as a "system property" marked as writable by the shell
> > user, so the Android Debug Bridge shell can lower it. The debugging
> > tools learned how to toggle it off automatically when they're used.
> > It
> > intentionally isn't a persist. prefixed property so the setting also
> > goes away on reboot.
> >=20
> > ADB (incl. the shell user) isn't available until developer mode is
> > enabled + ADB is toggled on in the developer settings, and then it
> > still
> > requires whitelisting keys.
>=20
> Ah; so I'd misunderstood somewhat.
>=20
> I was under the (clearly mistaken) impression that this was lowered
> when
> developer mode was enabled, rather than only when it was both enabled
> and ADB was connected, for example.
>=20
> Thanks for clearing that up!

ADB provides a shell as the 'shell' user, and that user has the ability
to toggle the sysctl. So profiling tools were able to be taught to do
that automatically. It's the only way that the 'shell' user is actually
exposed. For example, a terminal app just runs in the untrusted_app
SELinux domain as a unique unprivileged uid/gid pair, not as the much
more privileged ADB 'shell' domain.

So it doesn't actually get toggled off you use ADB to do something else.

ADB itself is pretty much comparable to SSH, but over USB (i.e. key-
based way of getting a shell).

The 'shell' user has tools like 'run-as' to be able to run things as
various apps (if they are marked debuggable), so in theory it could be
finer-grained and act only there, for the app being debugged. It would
be really hard to cover all use cases and maybe things other than apps
though (although in an Android 'user' build, the base system itself
isn't very debuggable, you really need 'userdebug' or 'eng' which isn't
what ships on end user devices).
--=-HnaYufBSCXV+yD3c0YAy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdBQJYB44wFhxkYW5pZWxtaWNheUBnbWFpbC5jb20ACgkQ+ecS5Zr1
8irsnA/+Pq3EsCpp3VrBAugOFGhzDlt0EAD5KjuUHWQawWddE61tQg6Nm0tiT22B
aV1fCQdBHqSm9S7LGohrkMjP33b2Bu/IlbdjrIS/FCG04YS67u3sb92EfRWuqLZg
u8eMpPdeQWQLAoTZgAxOlJfX59J9kwKnxgeFsT8cN69lY96RTMG2sPMPxAnG91JM
7tsun95xBmymWjunUo6wmmR5zM9Eb2iAKqAK3+d0KONZDv7xrbTx9mC+HNC0+y8v
Xg0nByKYeEtWdorsxlCZo8a55HwIw03llKKZSEnf5/0CiTB1PCvahZUvOp3hATs8
DqM/uPFFgDswILWXrDPOw+a4xN34J5aaNfO0tkAB5Tg/jNvHxu3QRkaHKMrKUK8C
HkDRslk9GJ/PYgIMqwZsUJXXgrCyDhujqzsYZSQnFeuApISdDj8Og1CsWnkw8ykE
mGwpAzMzJoMqZnyozwn8BfYbLmDaw3AU+vp9y3wV9gbqNJbBJGcU7POvuNd1RJPL
FfO09a18ok0KRosA83jC0daL4pShufRNbSIMcNRg7cUAV8TgejFr4K1f47xUh1Yy
EBRAHjOHOicsKVfbRUCPEx28JlgYxj1EOozYkyomGM/ke9TTZfxjNQvse8tJP1aG
kD3zluEWzXCMh4YUy6YSpCuLVVPuG0n4R547hjaVoYYsVYkSHQo=
=0RnL
-----END PGP SIGNATURE-----

--=-HnaYufBSCXV+yD3c0YAy--
