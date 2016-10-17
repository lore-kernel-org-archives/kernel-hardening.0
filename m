Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1476716073.4032.5.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Mon, 17 Oct 2016 10:54:33 -0400
In-Reply-To: <20161017134413.GK29095@leverpostej>
References: <1469630746-32279-1-git-send-email-jeffv@google.com>
	 <20161017134413.GK29095@leverpostej>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-1cqfBr7mUTNqbtlsB5+5"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] [PATCH 1/2] security, perf: allow further
 restriction of perf_event_open
To: kernel-hardening@lists.openwall.com
Cc: peterz@infradead.org, mingo@redhat.com, acme@kernel.org, alexander.shishkin@linux.intel.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Jeff Vander Stoep <jeffv@google.com>
List-ID: <kernel-hardening.lists.openwall.com>


--=-1cqfBr7mUTNqbtlsB5+5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2016-10-17 at 14:44 +0100, Mark Rutland wrote:
> Hi,
>=20
> Attempt to revive discussions below...
>=20
> On Wed, Jul 27, 2016 at 07:45:46AM -0700, Jeff Vander Stoep wrote:
> > When kernel.perf_event_paranoid is set to 3 (or greater), disallow
> > all access to performance events by users without CAP_SYS_ADMIN.
> >=20
> > This new level of restriction is intended to reduce the attack
> > surface of the kernel. Perf is a valuable tool for developers but
> > is generally unnecessary and unused on production systems. Perf may
> > open up an attack vector to vulnerable device-specific drivers as
> > recently demonstrated in CVE-2016-0805, CVE-2016-0819,
> > CVE-2016-0843, CVE-2016-3768, and CVE-2016-3843. This new level of
> > restriction allows for a safe default to be set on production
> > systems
> > while leaving a simple means for developers to grant access [1].
> >=20
> > This feature is derived from CONFIG_GRKERNSEC_PERF_HARDEN by Brad
> > Spengler. It is based on a patch by Ben Hutchings [2]. Ben's patches
> > have been modified and split up to address on-list feedback.
> >=20
> > kernel.perf_event_paranoid=3D3 is the default on both Debian [2] and
> > Android [3].
>=20
> While people weren't particularly happy with this global toggle
> approach, my understanding from face-to-face discussions at LSS2016
> was
> that people were happy with a more scoped restriction (e.g. using
> capabilities or some other access control mechanism), but no-one had
> the
> time to work on that.
>=20
> Does that match everyone's understanding, or am I mistaken?
>=20
> It's also my understanding that for Android, perf_event_paranoid is
> lowered when the user enables developer mode (rather than only when an
> external debugger is attached); is that correct?

It's exposed as a "system property" marked as writable by the shell
user, so the Android Debug Bridge shell can lower it. The debugging
tools learned how to toggle it off automatically when they're used. It
intentionally isn't a persist. prefixed property so the setting also
goes away on reboot.

ADB (incl. the shell user) isn't available until developer mode is
enabled + ADB is toggled on in the developer settings, and then it still
requires whitelisting keys.
--=-1cqfBr7mUTNqbtlsB5+5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdBQJYBOYpFhxkYW5pZWxtaWNheUBnbWFpbC5jb20ACgkQ+ecS5Zr1
8ioGMw/+NaPoyjQfLjt83182FvbpgST86m0BCn93n9IQfOyzmVOJbtCdwL38tjeE
l5BOgisdSfV7/vMs25xP4mtZKihXTFneTdV/8tlaCpSCePnlCKHzqn6wu6fqedTr
s4to8HjHVFLJwJiYJIyt1t/I+2vX7W2kyAI/VWHMPiPUZZvjuddgnI9POnstwHHR
FLvs8pyGUHmPE1IQwputOxj4v9OrS4ciSXqWNv224GeoMEJYnRBhwz7EOFbSIbk3
7UDN7DtExWwlCqxw/qfsrkiYgQYLPSDNPKjZmNEr4FkOA73hxGcad+Jz7RA/BVX6
zmvUOv5Bra8FMhog6VpqxLw2K0YxujrSHet5bDlV7jUrG2jwpHpUnN76eeSpXMYc
MUqKDspP17+nF18fqmzPFYOUyoFFxx9U8OrCc9vFsx9gRD09jd+XHtOZa1e8GjFZ
ykg6kHpP7u1byMGTJWwSV5TQ46pGKfhzuEt2gD1lx384N/sz2KjIQaUOGz41/0x3
knKElGasCYmpVXwakVZgP1wMVl+C75kucK2ZckYbgsIPcP3hSVOWyJFJR3VHMDrb
+bw9CPRtE0YK/KyTXAXVLkMM+qAZPEioXkJEYxGX2dbRJWA5R03ZqYxDt+52/1Bz
3flZF9h4XP+M2kvRuL/hCHCQtk6cwIZRzwG/TKBGvf4c5RyUgEc=
=fsda
-----END PGP SIGNATURE-----

--=-1cqfBr7mUTNqbtlsB5+5--
