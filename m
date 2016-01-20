Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1453323437.6344.32.camel@debian.org>
From: Yves-Alexis Perez <corsac@debian.org>
Date: Wed, 20 Jan 2016 21:57:17 +0100
In-Reply-To: <CAGXu5jLsxwhrgyRfvYV79WJrrFr9tkXMe=7-qWBz6VWEsEA_5g@mail.gmail.com>
References: <1450364270-12687-1-git-send-email-dave@progbits.org>
	 <CAGXu5jJJ13z206L6R99MYmiUA7hVYUJC5UVS8h5Mg0sUDr60GQ@mail.gmail.com>
	 <CAGXu5jLsxwhrgyRfvYV79WJrrFr9tkXMe=7-qWBz6VWEsEA_5g@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-LzELat0pqSsREQuHT1ni"
Mime-Version: 1.0
Subject: Re: [kernel-hardening][RFC PATCH v2 00/12] Add PAX_REFCOUNT
 overflow protection
To: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
Cc: David Windsor <dave@progbits.org>
List-ID: <kernel-hardening.lists.openwall.com>


--=-LzELat0pqSsREQuHT1ni
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On mar., 2016-01-19 at 11:07 -0800, Kees Cook wrote:
> Hi David,
>=20
> On Thu, Dec 17, 2015 at 12:55 PM, Kees Cook <keescook@chromium.org> wrote=
:
> > On Thu, Dec 17, 2015 at 6:57 AM, David Windsor <dave@progbits.org> wrot=
e:
> > > NOTE: This is a v2 submission because patch 3/5 in v1 was too large t=
o
> > > sent
> > > to kernel-hardening.=C2=A0=C2=A0Taking that as a sign that the patch =
needed to be
> > > split,
> > > I'm sending this version of the patchset, with the patches split more=
 or
> > > less
> > > on a per-maintainer basis (except for those in drivers/).
>=20
> How's the next spin coming? It looks like we have some new real-world
> examples of exploits that would have been blocked by this protection:
>=20
> http://perception-point.io/2016/01/14/analysis-and-exploitation-of-a-linu=
x-k
> ernel-vulnerability-cve-2016-0728/
>=20
>=20
One thing which is surprising (I have to admit I'm not really an expert on =
how
SLAB works) is how easy it apparently is to have multiple allocations end u=
p
at the same place. You don't even have to *know* the exact address.

Wouldn't it be possible to at least have some randomization here, so new
object are not at the same place as the not-freed-ones, somehow preventing =
the
use-after-free and forcing an attacker to do some heap massaging?

Regards,
--=20
Yves-Alexis


--=-LzELat0pqSsREQuHT1ni
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJWn/StAAoJEG3bU/KmdcCl05wH/1FlBKvCOy2Gn0NwRSk8GsXn
DcvFkMHmaBK4I7SFkAXBbD0r8feXh7DndPtDyeyqP2u8OAaHjWJg7W3QUFKl2mOr
1RZuJoMjXsE9v1/O2iVwEFmL9tS1OWcF8KLE+wWpdg7XGCGBQL6ibHSjw3RtI5+p
CDaWDey7X8d2BqbKb0qmsowx0LrVatLxHKf+sQUCJbxNdx97921wylYRyo+uoWQf
IlAJoYLHoUBEkGA6flrjQOQH0/4kWVFgpwlsWyQBCju1KsOYwpxIZZAG3mLplCUZ
x1t/cqnDejj8KY+uaB9lYazF/P3gS0ZDa4RO9IbIFDvJgyxan/qljrzs8U8Grb8=
=laHt
-----END PGP SIGNATURE-----

--=-LzELat0pqSsREQuHT1ni--
