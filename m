Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1470143793.13627.28.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Tue, 02 Aug 2016 09:16:33 -0400
In-Reply-To: <20160802095243.GD6862@twins.programming.kicks-ass.net>
References: <1469630746-32279-1-git-send-email-jeffv@google.com>
	 <20160802095243.GD6862@twins.programming.kicks-ass.net>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-UW4sAI/QUQSvhcT19qbS"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Re: [PATCH 1/2] security, perf: allow
 further restriction of perf_event_open
To: kernel-hardening@lists.openwall.com, Jeff Vander Stoep <jeffv@google.com>
Cc: mingo@redhat.com, acme@kernel.org, alexander.shishkin@linux.intel.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


--=-UW4sAI/QUQSvhcT19qbS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2016-08-02 at 11:52 +0200, Peter Zijlstra wrote:
> On Wed, Jul 27, 2016 at 07:45:46AM -0700, Jeff Vander Stoep wrote:
> >=20
> > When kernel.perf_event_paranoid is set to 3 (or greater), disallow
> > all access to performance events by users without CAP_SYS_ADMIN.
> >=20
> > This new level of restriction is intended to reduce the attack
> > surface of the kernel. Perf is a valuable tool for developers but
> > is generally unnecessary and unused on production systems. Perf may
> > open up an attack vector to vulnerable device-specific drivers as
> > recently demonstrated in CVE-2016-0805, CVE-2016-0819,
> > CVE-2016-0843, CVE-2016-3768, and CVE-2016-3843.
>=20
> We have bugs we fix them, we don't kill complete infrastructure
> because
>=20
> of them.

It's still accessible to privileged processes either way. Android still
allows access from unprivileged processes but it can only be enabled via
the debugging shell, which is not enabled by default either.

It isn't even possible to disable the perf events infrastructure via
kernel configuration for every architecture right now. You're forcing
people to have common local privilege escalation and information leak
vulnerabilities for something few people actually use.

This patch is now a requirement for any Android devices with a security
patch level above August 2016. The only thing that not merging it is
going to accomplish is preventing a mainline kernel from ever being used
on Android devices, unless you provide an=C2=A0alternative it can use for t=
he
same use case.

https://source.android.com/security/bulletin/2016-08-01.html

> > This new level of
> > restriction allows for a safe default to be set on production
> > systems
> > while leaving a simple means for developers to grant access [1].
>=20
> So the problem I have with this is that it will completely inhibit
> development of things like JITs that self-profile to re-compile
> frequently used code.
>=20
> I would much rather have an LSM hook where the security stuff can do
more fine grained control of things. Allowing some apps perf usage while
> denying others.

If the only need was controlling access per-process statically, then
using seccomp-bpf works fine. It needs to be dynamic though. I don't
think SELinux could be used to provide the functionality so it would
have to be a whole new LSM. I doubt anyone will implement that when the
necessary functionality is already available. It's already exposed only
for developers using profiling tools until they reboot, so finer grained
control wouldn't accomplish much.
--=-UW4sAI/QUQSvhcT19qbS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIzBAABCAAdBQJXoJ0xFhxkYW5pZWxtaWNheUBnbWFpbC5jb20ACgkQ+ecS5Zr1
8iquPA/9HzFDrpPmjjSoatAQekF92uwd9Iiym5ubHXV5XSt1tfnBL6m7nkIIPfHW
WNHlmWv4P/pitzZKgASkKK5V/YVV52e+Bzq2kisHomstG6lFoA+876O9pT5HKV1V
B+SLG/fam1lTjz9tPx8LsWhcag2pJ6waSaRUMaTxs4s5wjlDOcq8RyrlsTGbZiC5
UHmRaJ8RGcuNxU1iJ2yu4ZzboKwD+cgNL7QX+uFemuiXbFQYT4q0WRsszTGdYnNa
gTVOLKb0Q21M4brbhNVjJGzIocMgtPqlwwdyCfw7unHDik3mqkLPv/G3AQqO8mRG
rU9jIM/q7gWbRU5VqqW64vEoqrcsbzpVnX8dVoY7VtHWh+QLM1RibkC9yw1bo2Bh
PreSCSnp5kx3B8A96AiFkppn1/9/bUfiICH0rRuMFqcpm7fRki0IM/ZAa0Glzr9L
NLIR4hMgfOz8jBt/vrRudbdKNyLmqgw6NIlN/ipf54T2fDuD35oZvafGM6igtCsa
4jAAYgf88fuCVKqK65v/ByHztGiFQuZoZS+V/DJ5Msa/IFoLGODdK07skp5lrW9R
HHuLuNrOtlAHb2jxD5h9kUv4Y4hYJt99io4I3+VWzDyhAGMqQ5YT1R9VavOW0KP7
BZ13eQJq/PG5QAdm5+4p223wLPJNhVWcOHJpyqcNj9Ah0GyFrHo=
=VTV6
-----END PGP SIGNATURE-----

--=-UW4sAI/QUQSvhcT19qbS--
