Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1470329589.22643.117.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Thu, 04 Aug 2016 12:53:09 -0400
In-Reply-To: <1469557346-5534-1-git-send-email-william.c.roberts@intel.com>
References: <1469557346-5534-1-git-send-email-william.c.roberts@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-XkGgBfrMkywwOo3O8N1Z"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] [PATCH] [RFC] Introduce mmap randomization
To: kernel-hardening@lists.openwall.com, jason@lakedaemon.net, linux-mm@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: keescook@chromium.org, gregkh@linuxfoundation.org, nnk@google.com, jeffv@google.com, salyzyn@android.com, dcashman@android.com
List-ID: <kernel-hardening.lists.openwall.com>


--=-XkGgBfrMkywwOo3O8N1Z
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2016-07-26 at 11:22 -0700, william.c.roberts@intel.com wrote:
> The recent get_random_long() change in get_random_range() and then the
> subsequent patches Jason put out, all stemmed from my tinkering
> with the concept of randomizing mmap.
>=20
> Any feedback would be greatly appreciated, including any feedback
> indicating that I am idiot.

The RAND_THREADSTACK feature in grsecurity makes the gaps the way I
think would be ideal, i.e. tracked as part of the appropriate VMA. It
would be straightforward to make it more general purpose.
--=-XkGgBfrMkywwOo3O8N1Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIyBAABCAAdBQJXo3L1FhxkYW5pZWxtaWNheUBnbWFpbC5jb20ACgkQ+ecS5Zr1
8iqJJw/4/LHorEjAdGH7oSLHhx6KzY8DkiPZG1RrqDOggPNsZI+ACDAZtp/c7J5m
sdBYRsSK3wr4rsVAlWSPwh81J/Iabr9KsLiJbZJbLMn9bBQuuPsei3ySpOxK8PiG
FSdWZmYe1LRRHSGCUETbOLpkDWikLKGJIUlgDMWDcNce5wCXwm/uUnAkwUXGHF69
S2JM3CfJxq9U3H+VmBxQFA9SW+Wb8Lls3VaMPOheZvmTwg418N/W1BaUaF59OOI7
ZjAnIAJcryi+iSuguyhLB3CIi/VKMu8K9fvi61d7bPuUIXCico/UriXzCiHEaUoM
VdFv0YksnthcWL/kqseH79KtVMz2isvgwEkGD7TuZRYp4f1osCZC6mf23C6eTt1S
6OJuR3QGhw8DJWqB/4biAYn9637jDiIXa3dCwEI2TqVDfdMTpTVYScKmDevtWQAf
n02EIoMXp61cJ/ystly9Rls1jpfQ1AVDuHYqLOVM/QadCnfqG6TPcP2Irck/GeWl
PWsbvwhe3WuGhCoP51LvPbbN6WHBKhpmrSjLEIKyuPtCazPucZpz2GhSNY1RVkwp
Qj6HgTyCyI93P7veINj/Zu0eqx/BlqkyNsgL0Zq8X+/zJkdqsR3pAYUY6IbPSzfk
uhHRw5oUiXqmnYKA9D83qTRvhoMI1YtkN2QR2Yi8xHugeV3NZg==
=Ptbg
-----END PGP SIGNATURE-----

--=-XkGgBfrMkywwOo3O8N1Z--
