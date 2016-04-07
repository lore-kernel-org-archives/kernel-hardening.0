Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1460045867.2818.67.camel@debian.org>
From: Yves-Alexis Perez <corsac@debian.org>
Date: Thu, 07 Apr 2016 18:17:47 +0200
In-Reply-To: <CAGXu5jLEENTFL_NYA5r4SqmUefkEwL68_Br6bX_RY2xNv95GVg@mail.gmail.com>
References: <1459971348-81477-1-git-send-email-thgarnie@google.com>
	 <CAGXu5jLEENTFL_NYA5r4SqmUefkEwL68_Br6bX_RY2xNv95GVg@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-biMppi13q/Rue9M3C58x"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Re: [RFC v1] mm: SLAB freelist randomization
To: kernel-hardening@lists.openwall.com, Thomas Garnier <thgarnie@google.com>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Thelen <gthelen@google.com>, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Laura Abbott <labbott@fedoraproject.org>
List-ID: <kernel-hardening.lists.openwall.com>


--=-biMppi13q/Rue9M3C58x
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On mer., 2016-04-06 at 14:45 -0700, Kees Cook wrote:
> > This security feature reduces the predictability of
> > the kernel slab allocator against heap overflows.
>=20
> I would add "... rendering attacks much less stable." And if you can
> find a specific example exploit that is foiled by this, I would refer
> to it.

One good example might (or might not) be the keyring issue from earlier thi=
s
year (CVE-2016-0728):

http://perception-point.io/2016/01/14/analysis-and-exploitation-of-a-linux-=
ker
nel-vulnerability-cve-2016-0728/

Regards,
--=20
Yves-Alexis


--=-biMppi13q/Rue9M3C58x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJXBogrAAoJEG3bU/KmdcClQKsH/1y013Vezh04OGPgpDotuaC4
w6CHEpjyFdxg2WZCEoJuV7EeSiAYmczw9uRKAGAeJ+gXdmf+z66U2FwqXkvJlkGc
2sFBpsO/JYNydlyfsc7r8LVP5/PzTazm4Ww1nWYQPKCj65cQhy9yczsn2SgUDGgL
IN8ks/AJNZT2qxuYsr8E6dmv448xf4u/p9HTf9MGfv0S3/4CeeU2+BjPQnOCmGuP
yxvYVIxxavHICp8We+fyNDIYva+nKtLSvETuwF4QkxuscJrY17xI04rLIK0alTiT
EyqvZluPVWRgQ3Hm945gLf4ifXsNiTgOKKuurLrMVdCe6UEu0p8b0LiAGMvi8E0=
=62+d
-----END PGP SIGNATURE-----

--=-biMppi13q/Rue9M3C58x--
