Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1454404559.31183.10.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Tue, 02 Feb 2016 04:15:59 -0500
In-Reply-To: <56AFE7EE.30100@eng.utah.edu>
References: <1453622354-50686-1-git-send-email-sbauer@eng.utah.edu>
	 <1453622354-50686-2-git-send-email-sbauer@eng.utah.edu>
	 <87twlsaw92.fsf@rasmusvillemoes.dk> <56AFE7EE.30100@eng.utah.edu>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-+tCQPv9XuujXC7C9Ifs2"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Re: [RFC PATCH 1/2] SROP Mitigation:
 Architecture independent code for signal cookies
To: kernel-hardening@lists.openwall.com, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: abhiram@cs.utah.edu
List-ID: <kernel-hardening.lists.openwall.com>


--=-+tCQPv9XuujXC7C9Ifs2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> Maybe secret is a bad term. It's supposed to be something userland
> can't guess=C2=A0
> without doing a bunch of tricks. It's essentially supposed to work
> like a stack
> canary to protect against stack based buffer overflows. If someone
> can leak the
> stack canary in a stack based overflow, then do the overflow they can
> overcome=C2=A0
> stack canaries as a mitigation. The same is true here. If someone can
> generate a
> signal, leak the signal cookie, then leak the address of the signal
> cookie, then
> undo the hash, then they can beat this mitigation. But we're arguing
> if someone
> can do everything we've said above they have already have nearly full
> control of
> a userland process and they won't really need SROP.
>=20
> Essentially the signal cookie is just a way for the kernel to know if
> the=C2=A0
> sigreturn it's handling is in response to a legitimate signal that
> the kernel=C2=A0
> previously delivered without having to save a ton of state in
> current, or=C2=A0
> elsewhere.=C2=A0

Stack canary checking has a tiny performance budget though. It would be
interesting to know how SipHash fared in a case like this. It could be
specialized for fixed-size keys and potentially used elsewhere. Seems
like it would be more than fast enough.
--=-+tCQPv9XuujXC7C9Ifs2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJWsHPPAAoJEPnnEuWa9fIq3PIP/iC2/aEvmIZt62vrShUBDBbF
W0Dd5oeCYrw34GmDiUoQglvFpMMc8BYkVPkuR/YGDcIh4u+xlP2N8Uyzqv9iW0dV
OCC6PF39+s4ewHtRv3dz5G/T80vDaLHp++YeCYOamtZPdKjXF5MGm+iTpzp/SRxS
bYk0hxd7QIswkcy4F62iszMhAe0c31t35blSi4tiZdNzdDsJV/qU9ne/PKNObkja
UgDY8hz3lcNS8qqh9uHCTCtyx3opONd62weYW/TCRZq5ekLoYPQs1DX2Z9Vh6q5B
6jSmK5RZuyVzX2y9m3RUbCnaRIl5qeCzxIViJGddHlwrl+EstI4MCZXm8ekKm8ls
fCQI9DRgI0A6bATS1uPxTjvnv5iH/RZQy2MC2+WbV7wo41g0LPCOtpusqe8vlVgX
SsWff7fItVSJw+jjLeUqS6NLB72mNhnE8r6BM2ln36lvW3LX1an23z8ah8g2S79r
bf1oTwqD0lye2SH6GVSkOU0Y60aKN0SuF5y4aOkmudDBaV64jmiuW/EvnqUBgvC4
u4dy+b5uxSRiyRlTQ8r31ik0NgrquWmYjMuR2TB7cviyUzmsk5c75QhLfH+GjlEy
YQAKMarn0w5FfOU1CirDHkMGyEeZbUsTaCBpbcSbzsO3zSXSOIlkjhwjyGCCuQla
TURephQGi5vd0FBW455o
=jVPu
-----END PGP SIGNATURE-----

--=-+tCQPv9XuujXC7C9Ifs2--
