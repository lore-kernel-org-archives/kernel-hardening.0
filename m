Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1466533948.2756.56.camel@redhat.com>
From: Rik van Riel <riel@redhat.com>
Date: Tue, 21 Jun 2016 14:32:28 -0400
In-Reply-To: <CAGXu5jJjihEU0HkSTWJymLZ5y=J03bkBHNgVf9QOSgWz6bf-SQ@mail.gmail.com>
References: <cover.1466466093.git.luto@kernel.org>
	 <f7855f9eae0a27f5a03db1291f46fea1cc0a2a3f.1466466093.git.luto@kernel.org>
	 <CAG48ez3WGu+03HDBA5daSV+zXGoR+iFHHYxZav0o6JCM9-EPMg@mail.gmail.com>
	 <CALCETrWp+7+9j1vMgv5hxvtq3akZZZVdaVDfOLoFwhX+kL=Ntw@mail.gmail.com>
	 <CAGXu5jJjihEU0HkSTWJymLZ5y=J03bkBHNgVf9QOSgWz6bf-SQ@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-JIDeOF8ZZyE1csowjY8T"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Re: [PATCH v3 06/13] fork: Add generic
 vmalloced stack support
To: kernel-hardening@lists.openwall.com, Andy Lutomirski <luto@amacapital.net>
Cc: Jann Horn <jannh@google.com>, Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Brian Gerst <brgerst@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>


--=-JIDeOF8ZZyE1csowjY8T
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2016-06-21 at 10:13 -0700, Kees Cook wrote:
> On Tue, Jun 21, 2016 at 9:59 AM, Andy Lutomirski <luto@amacapital.net
> > wrote:
> >=C2=A0
> > I'm tempted to explicitly disallow VM_NO_GUARD in the vmalloc
> > range.
> > It has no in-tree users for non-fixed addresses right now.
> What about the lack of pre-range guard page? That seems like a
> critical feature for this. :)

If VM_NO_GUARD is disallowed, and every vmalloc area has
a guard area behind it, then every subsequent vmalloc area
will have a guard page ahead of it.

I think disallowing VM_NO_GUARD will be all that is required.

The only thing we may want to verify on the architectures that
we care about is that there is nothing mapped immediately before
the start of the vmalloc range, otherwise the first vmalloced
area will not have a guard page below it.

I suspect all the 64 bit architectures are fine in that regard,
with enormous gaps between kernel memory ranges.

--=20
All Rights Reversed.


--=-JIDeOF8ZZyE1csowjY8T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJXaYg9AAoJEM553pKExN6DMgQH/AkJiDO6nYz4HDPcXzy6mKtQ
P5YfvXRL6roj7l3lG5FQuwcPryPj+vy4HHyysPEvo9Sk8DABLDsvDO3a8QdbWrkm
D2zFcrN3OaAN8IRXHPyhHgDrotBZ5AUkFiUzf4EP18kxML+AWZioifpM8XL5FvH6
YbZRKyNaDz5QZpB+5DIIjT/3ngU+2Cn71ZkreKJ9fSqVfnP4Ea+U+89CzHi9hxUr
tC+eTPrgiJ281SBFQUCbs42WSpd7vfQtSk8Q2IxRCChKAyBhY8AVKH37+hYvOtgw
H5jiIzbdOyDo5ofr01P0emLx/kEGyH4zURu8QCeJMxHB9XB86QVwHh4bc/RzkP4=
=hL+a
-----END PGP SIGNATURE-----

--=-JIDeOF8ZZyE1csowjY8T--
