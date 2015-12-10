Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1449788644.8579.27.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Thu, 10 Dec 2015 18:04:04 -0500
In-Reply-To: <5669FEE1.8812.1230AD@pageexec.freemail.hu>
References: <20151209172101.GA70633@davidb.org>
	, <1449770155.8579.2.camel@gmail.com>
	, <CAGXu5jK7LcS9M4NBZr3q8RVQss6GKQ-ifxhOTCMTAGZv3hF02A@mail.gmail.com>
	 <5669FEE1.8812.1230AD@pageexec.freemail.hu>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-p3+U8qIHNSjZm76wIrvB"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Self Introduction
To: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>


--=-p3+U8qIHNSjZm76wIrvB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> uhm, what races? the per-cpu PGD exists for that reason, regardless of
> PCID.

Ah, that makes sense. So the non-strong PCID UDEREF is really just
hardware acceleration for what you were already doing before.
--=-p3+U8qIHNSjZm76wIrvB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJWagTkAAoJEPnnEuWa9fIqSVMP/0RtkbfpDUIf/DCIryc8Kx2F
pMEStsthzkwIbmOGWoFOFzioIpMy+lPUp+7Fdi6BuhOh0gSL2nmBJcfy2vym9C0V
kTyfekmzxz8br6++NctOhPA3/tRawBO0SKZKcvvHjBe3lDScKHFukihb9i7zdmWr
fDZr9BAO5fISY7n/s0LPK80GHKqnjDIM2cG8E4LKkgdPeMn9mwjmVvOfYmsN4Yut
6SDy8AUPiBB62UoWFGAUQ63ebCLPYyNjXQxsrtUby3eXHInw5wYZNzMS9DxF66mY
cXfGnOiWGfM4Scdrzc9yVt5iGF0/c2EYRcMxJPgatScbOSP1xFSu8gTCcS8bzOZ0
jb38i+0jIheUnfnGKzDvDnBUue0IpYJw0uvFEXouWtLPDxprK8uf8tVRB/+FJAec
Ce5gbZobzb5xhobvkuvAXxpjH/6r5xy9LCHjCJ25brlK7L4N8EU6KD6dGriUN2Ok
jqw9/+AdM/nJbXwFRIPqJDlvMI+OiToDCvpii76LSKX2ILcXlWi6fosOxrdg5DqS
kJxDqpZtEy2SOfmVj8Trk0qFGPmjdDeH/004/7uhQ6GRqi6EEXdcEaluEgZLf3yu
xrG/z0ybFUnj1AMXsBNuJHlCThw9l5ANCNwujIWdmlRXP9/0V2Xv5TZg2zntozhd
M7bLWTQ96Au/8k4IMmxj
=a5eX
-----END PGP SIGNATURE-----

--=-p3+U8qIHNSjZm76wIrvB--
