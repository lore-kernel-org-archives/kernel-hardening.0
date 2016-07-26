Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1469563923.10218.13.camel@redhat.com>
From: Rik van Riel <riel@redhat.com>
Date: Tue, 26 Jul 2016 16:12:03 -0400
In-Reply-To: <1469557346-5534-2-git-send-email-william.c.roberts@intel.com>
References: <1469557346-5534-1-git-send-email-william.c.roberts@intel.com>
	 <1469557346-5534-2-git-send-email-william.c.roberts@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-uInklHcATbRBVk/CLPm9"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] [PATCH] [RFC] Introduce mmap randomization
To: kernel-hardening@lists.openwall.com, jason@lakedaemon.net, linux-mm@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: keescook@chromium.org, gregkh@linuxfoundation.org, nnk@google.com, jeffv@google.com, salyzyn@android.com, dcashman@android.com, William Roberts <william.c.roberts@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>


--=-uInklHcATbRBVk/CLPm9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2016-07-26 at 11:22 -0700, william.c.roberts@intel.com wrote:
> From: William Roberts <william.c.roberts@intel.com>
>=20
> This patch introduces the ability randomize mmap locations where the
> address is not requested, for instance when ld is allocating pages
> for
> shared libraries. It chooses to randomize based on the current
> personality for ASLR.
>=20
> Currently, allocations are done sequentially within unmapped address
> space gaps. This may happen top down or bottom up depending on
> scheme.
>=20
> For instance these mmap calls produce contiguous mappings:
> int size =3D getpagesize();
> mmap(NULL, size, flags, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =3D
> 0x40026000
> mmap(NULL, size, flags, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =3D
> 0x40027000
>=20
> Note no gap between.
>=20
> After patches:
> int size =3D getpagesize();
> mmap(NULL, size, flags, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =3D
> 0x400b4000
> mmap(NULL, size, flags, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =3D
> 0x40055000
>=20
> Note gap between.

I suspect this randomization will be more useful
for file mappings than for anonymous mappings.

I don't know whether there are downsides to creating
more anonymous VMAs than we have to, with malloc
libraries that may perform various kinds of tricks
with mmap for their own performance reasons.

Does anyone have convincing reasons why mmap
randomization should do both file and anon, or
whether it should do just file mappings?

--=20
All rights reversed

--=-uInklHcATbRBVk/CLPm9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJXl8QTAAoJEM553pKExN6D3iIH/R1kNo97Yvqrfjxh4QPJWDL5
d4EoNba8popXiLyfs2cmxIZOTBcrMtF7iHBQj1rc2ZC/jsrRihuhi8iIFRmHp/mi
7MRjdv+dfLic3Uf+pcacUG/YQxu03NVM9zW7MFMg0UXOZb5JSA38mHg6bts3udns
84j5HVpJYZgDYkcWwTFlOP6vBoAvkHsDzI+MJLe2zsj9Cyi8M0CqUIIBx3dcYV36
533wufpFkyfreqmxLyyv0VCehH6G21HYCzzavbjkNaNHrdhwyfNrCEbssyx5jrUD
NjzEkkeZkb8wOOyLuGGRvXIXIt3uF//svs834MAGG71jMsdIFi9gaxqqyOdEQQ4=
=1Tax
-----END PGP SIGNATURE-----

--=-uInklHcATbRBVk/CLPm9--
