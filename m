Message-ID: <1497987673.20270.107.camel@redhat.com>
From: Rik van Riel <riel@redhat.com>
Date: Tue, 20 Jun 2017 15:41:13 -0400
In-Reply-To: <1497915397-93805-1-git-send-email-keescook@chromium.org>
References: <1497915397-93805-1-git-send-email-keescook@chromium.org>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-3ihE6/2MaQiT3iOQ6Gtk"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] [PATCH 00/23] Hardened usercopy whitelisting
To: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
Cc: David Windsor <dave@nullcore.net>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


--=-3ihE6/2MaQiT3iOQ6Gtk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2017-06-19 at 16:36 -0700, Kees Cook wrote:
> This series is modified from Brad Spengler/PaX Team's PAX_USERCOPY
> code
> in the last public patch of grsecurity/PaX based on our understanding
> of the code. Changes or omissions from the original code are ours and
> don't reflect the original grsecurity/PaX code.
>=20
> David Windsor did the bulk of the porting, refactoring, splitting,
> testing, etc; I just did some extra tweaks, hunk moving, and small
> extra patches.
>=20
>=20
> This updates the slab allocator to add annotations (useroffset and
> usersize) to define allowed usercopy regions.

This is a great improvement over the old system
of having a few whitelisted kmalloc caches, and
bounce buffering to copy data from caches that
are not whitelisted!

I like it.

--=20
All rights reversed
--=-3ihE6/2MaQiT3iOQ6Gtk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJZSXpZAAoJEM553pKExN6DM4UH/1B6tlBjRtn/7Ce6np+or7Cm
bmHL8dw81Dgbs4sjkA/yPZVcnunN8v5KsWpqTuDuU0V6by+b+zt0lao5vMn1gRuW
YgGucAs6+EGuwWOw6dH8BYoUTO6DCDi16W8yKMIjXKeY0ORmGWC5+5EfCNvJUr7H
NzaQb+Io/iJxIllc1iTXchRHRuZYvN7pSJtaxI8oukbkuibs01QC7s04YxLUQEef
MEkNBRimVgxulFdr1YVgFlZ5U8Tun26aWXP3APGGH7dg4HsZo1JsqvVshXUytcvQ
pBJywFWStinKDkiHrBKvqh4VUkAS0chlyujCuVtnKYPMQRs0m1iZCwmmwHLSJZA=
=dguK
-----END PGP SIGNATURE-----

--=-3ihE6/2MaQiT3iOQ6Gtk--
