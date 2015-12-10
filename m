Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1449770155.8579.2.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Thu, 10 Dec 2015 12:55:55 -0500
In-Reply-To: <CAGXu5j+0oBHdS7vTQp_0ubuwvUftosYZCx8RJPXh7v7eYQncEQ@mail.gmail.com>
References: <20151209172101.GA70633@davidb.org>
	 <CAGXu5j+0oBHdS7vTQp_0ubuwvUftosYZCx8RJPXh7v7eYQncEQ@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-39DZ/bcQmU0R2rkEzKhR"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Self Introduction
To: kernel-hardening@lists.openwall.com
Cc: Catalin Marinas <catalin.marinas@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>


--=-39DZ/bcQmU0R2rkEzKhR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> ARMv8 64-bit: ??

The worst case scenario would be doing something like the x86_64 UDEREF.

> x86 pre-late-Broadwell: nothing upstream (though UDEREF in PaX exists)

It's worth noting that there's the pre-PCID implementation (slow and
vulnerable to races) and then two choices of better implementations when
PCID is available. You probably know that already, but it's not obvious
to everyone else.
--=-39DZ/bcQmU0R2rkEzKhR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJWabyrAAoJEPnnEuWa9fIq/h4P/R5+wl+zDLjEVpUQ9u/vi3K+
S3a7Tnzxn7o7z27kOkW1suqfRz43PV5fOGjSZdtoLxJ1RrihtwI9vzwtGqox0cV5
nQVwNH0XyVG70e11vGCZ3mZrwOqU/cEa+0SznLTxUpdvaAFdG/nnhAWGORARtiLz
K7GC2Cr6twAxv559awLZ0Rb+q+3k2uoysqzbyu9rQF0hWS0LxKg/eCq1yvUKO/Xr
Ohku5mFByxl3T8EFFO5PfhJxmZZjV3R0piu6Oe+HXPE+ayNhqf4DQKN1R4ng8Kmu
dvRAeucM4sGpG5C0d6+WseOyNxB6gRbdFMSDfYVEyhzqIt/wLlgwn7HPS1m3uEEu
PrVBql81olJaUO8TqoMuSf3yfYhM9oqDdxX6sH/sUsHSO45rgRPawIsA2YCKX5xW
Fg/Wk02pK/+IaFXWxFb6aaiZhW/0REPC1G8yVMT6GezsvXzAV7/gb2Vbhbd061EQ
6u2gBVNzG1BJouFvp+/HlQhwb8RqoCJwbcZuyQOPgkdguwTBweJWvx/QDkdmH6Yr
pF3LoIv9j+oCUwcX6v37relX/d+yvTWOYNEnsSyyNiEJq8YJEFD4CxXXxgDH/ajZ
w8LRx4B4df8904+ljvSmG6iRP3oCouPJZuEeVLSPC2ToebXTeEOpN6H1aXtBBiDu
FIkFunzGdX373QxqLCF0
=crTT
-----END PGP SIGNATURE-----

--=-39DZ/bcQmU0R2rkEzKhR--
