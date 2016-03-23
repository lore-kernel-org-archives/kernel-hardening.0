Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1458736327.5889.19.camel@debian.org>
From: Yves-Alexis Perez <corsac@debian.org>
Date: Wed, 23 Mar 2016 13:32:07 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-I/YDEVA7cCu60UEtO7HF"
Mime-Version: 1.0
Subject: [kernel-hardening] [CSW16] Getting Physical: Extreme Abuse of Intel Based Paging
 Systems
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--=-I/YDEVA7cCu60UEtO7HF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

[wasn't sure whether I should cross-post to oss-sec or not]

In case some people would be interested, Nicolas Economou and Enrique Nissi=
m
gave a presentation last week at CanSecWest about what you can do with a
kernel arbitrary write with current paging situation on Intel hardware, in
Linux and Windows. The slides (and code for Linux) are available at:

https://github.com/n3k/CansecWest2016_Getting_Physical_Extreme_Abuse_of_Int=
el_
Based_Paging_Systems/

There might be (a lot of) other way to exploit a running kernel with an
arbitrary write, but it's still quite interesting.

The authors give some advice at the end (slide 84 =E2=80=9CLinux conclusion=
=E2=80=9D):

- Paging tables shouldn=E2=80=99t be in *fixed addresses*
=C2=A0 - It can be abused by LOCAL and REMOTE kernel exploits
- All fixed paging structures should be *read-only*
- Some advice, compile the kernel with Grsec ;-)

Regards,
--=20
Yves-Alexis


--=-I/YDEVA7cCu60UEtO7HF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJW8ozHAAoJEG3bU/KmdcClPPcH/A93WurWFG4hOgonyYwUVQiB
7vqCv7jmRzVED5CuGZRiQTOHsv5YkynN7ND6qxP6Y5d0zZy/ZLjBmXGQBl/234+q
rwboXInI4kSh4lk1qs9B+lw5d6ETU3cNOgpGUIvhAdsq2s3/Mz4p+uuG8ZLHr9JK
qt/9SxGGtl80OwJ0SA6rxeDJTNHF35W2gavr2Sw0ezanrglrDvyYpQwCqJUVfayy
43QwutP0CMsATeMV/OD2W3wylRtBCw7fpxzLhRb+3M0+4Lt1bOdIe7fPQdz8BbNY
ZJpgIMiednblXDPG0/UKKVtTWvLtLH3/iVJOO0rH3hYeVU9BTRQNc05n1eKjS1o=
=LQEu
-----END PGP SIGNATURE-----

--=-I/YDEVA7cCu60UEtO7HF--
