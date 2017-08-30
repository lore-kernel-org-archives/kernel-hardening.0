Message-ID: <1504121364.26846.80.camel@redhat.com>
From: Rik van Riel <riel@redhat.com>
Date: Wed, 30 Aug 2017 15:29:24 -0400
In-Reply-To: <1503956111-36652-25-git-send-email-keescook@chromium.org>
References: <1503956111-36652-1-git-send-email-keescook@chromium.org>
	 <1503956111-36652-25-git-send-email-keescook@chromium.org>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-o+32mO1p2qCsUgwGVrLy"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] [PATCH v2 24/30] fork: Define usercopy
 region in mm_struct slab caches
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Cc: David Windsor <dave@nullcore.net>, Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@kernel.org>, linux-mm@kvack.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--=-o+32mO1p2qCsUgwGVrLy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2017-08-28 at 14:35 -0700, Kees Cook wrote:
> From: David Windsor <dave@nullcore.net>
>=20
> In support of usercopy hardening, this patch defines a region in the
> mm_struct slab caches in which userspace copy operations are allowed.
> Only the auxv field is copied to userspace.
>=20
Acked-by: Rik van Riel <riel@redhat.com>

--=20
All rights reversed
--=-o+32mO1p2qCsUgwGVrLy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJZpxIUAAoJEM553pKExN6DdRcIAMBgD6cpezITkPTYqS7q0Eox
UGeb0/1FZcS7HsgyOJWXHP5dJxtFUUwiH/VwYnFhck9ne6ZZ1lzIsnnosPQvGxk/
O1kHDW7/4G7TejZUaWxvrxdAIgLFIlUDoFmjlq4vQmuT1y1UPmZwyBfvCFUKyqHq
dz2bztfedO6Ffw/r5iACiqJnzrWm0fqxh9oBCEEcVbUeGoshUcfRJeVlUvOW7F4k
JAdtoYzmsqx06isMAQNSenB4mLGasziWBomf6vH974tATVHtzF2GuJwiDLaFuZ0T
ABDQ7XUerekUPWreWKQQShxaEN4eajJ0kSvzSnQmV7balnugjIDXyLKQ9aYYNdE=
=Ne21
-----END PGP SIGNATURE-----

--=-o+32mO1p2qCsUgwGVrLy--
