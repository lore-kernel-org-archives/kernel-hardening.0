Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1466532133.2756.50.camel@redhat.com>
From: Rik van Riel <riel@redhat.com>
Date: Tue, 21 Jun 2016 14:02:13 -0400
In-Reply-To: <CAGXu5jJaWxcOKLtXG3r1XWE8NpL=GFSZwmV_UYjjv6q0135ETQ@mail.gmail.com>
References: <cover.1466466093.git.luto@kernel.org>
	 <13212319.WrhLzgRA6Z@wuerfel>
	 <CAGXu5jJaWxcOKLtXG3r1XWE8NpL=GFSZwmV_UYjjv6q0135ETQ@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-CorTQSSXHM2WOtKrQ0Sl"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Re: [PATCH v3 00/13] Virtually mapped stacks
 with guard pages (x86, core)
To: kernel-hardening@lists.openwall.com, Arnd Bergmann <arnd@arndb.de>
Cc: Andy Lutomirski <luto@kernel.org>, "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Brian Gerst <brgerst@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>


--=-CorTQSSXHM2WOtKrQ0Sl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2016-06-21 at 10:16 -0700, Kees Cook wrote:
> On Tue, Jun 21, 2016 at 2:24 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> >=20
> > On Monday, June 20, 2016 4:43:30 PM CEST Andy Lutomirski wrote:
> > >=20
> > >=20
> > > On my laptop, this adds about 1.5=C2=B5s of overhead to task creation=
,
> > > which seems to be mainly caused by vmalloc inefficiently
> > > allocating
> > > individual pages even when a higher-order page is available on
> > > the
> > > freelist.
> > Would it help to have a fixed virtual address for the stack instead
> > and map the current stack to that during a task switch, similar to
> > how we handle fixmap pages?
> >=20
> > That would of course trade the allocation overhead for a task
> > switch
> > overhead, which may be better or worse. It would also give
> > "current"
> > a constant address, which may give a small performance advantage
> > but may also introduce a new attack vector unless we randomize it
> > again.
> Right: we don't want a fixed address. That makes attacks WAY easier.

Does that imply we might want the per-cpu cache of
these stacks to be larger than one, in order to
introduce some more randomness after an attacker
crashed an ASLRed program looking for ROP gadgets,
and the next one is spawned? :)

--=20
All Rights Reversed.


--=-CorTQSSXHM2WOtKrQ0Sl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJXaYElAAoJEM553pKExN6Dd1IH/26D9y8/CCeKr35zps5ADJPk
xdGDss78w8Dks+PT0yUsqCXZBlvKdmJAxveAx+nME2RQ/hvcanGAFvoJf4EunSJv
UWtkErANVA9mm6gtVqguW276BnkNdv0mjPfF5oGuiptmHfmjE0Oc+0HyuX4xcj4G
rN1Nw+fZtJIgCZn/8HCkHF2q5jladxfZneJpI9wsEwbUBBzzciqQbxAJr11JHdxm
1CmHq36G3PX3BssWgx7bb79sKnyaOpccfuBFuUK4d5mMQ0kyd2q2YauTiqxECcm7
GCj2Zx9lDnA3rs1vxcmcr5+0q0osYKh+NU/H9rqDkoMc7B5qHSW9kSyiDE34jDE=
=6XiW
-----END PGP SIGNATURE-----

--=-CorTQSSXHM2WOtKrQ0Sl--
