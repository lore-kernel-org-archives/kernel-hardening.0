Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1466801847.22723.5.camel@redhat.com>
From: Rik van Riel <riel@redhat.com>
Date: Fri, 24 Jun 2016 16:57:27 -0400
In-Reply-To: <CAGXu5j+BvZTNW=CqrEHNMiTvwpRvmLsSBKpKHd++woFpO0JBWg@mail.gmail.com>
References: <1465420302-23754-1-git-send-email-keescook@chromium.org>
	 <20160609193927.2f03f128@annuminas.surriel.com>
	 <20160610154403.1d906134@annuminas.surriel.com>
	 <CAGXu5j+BvZTNW=CqrEHNMiTvwpRvmLsSBKpKHd++woFpO0JBWg@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-tHonhRfCfqAshMPPRmmi"
Mime-Version: 1.0
Subject: [kernel-hardening] Re: [RFC][PATCH v2 6/4] mm: disallow user copy to/from separately
 allocated pages
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey.schaufler@intel.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>


--=-tHonhRfCfqAshMPPRmmi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2016-06-24 at 13:53 -0700, Kees Cook wrote:
> On Fri, Jun 10, 2016 at 12:44 PM, Rik van Riel <riel@redhat.com>
> wrote:
> >=20
> > v2 of yesterday's patch, this one seems to completely work on my
> > system, after taking _bdata & _edata into account.
> >=20
> > I am still looking into CMA, but am leaning towards doing that as
> > a follow-up patch.
> >=20
> > ---8<---
> >=20
> > Subject: mm: disallow user copy to/from separately allocated pages
> >=20
> > A single copy_from_user or copy_to_user should go to or from a
> > single
> > kernel object. Inside the slab, or on the stack, we can track the
> > individual objects.
> >=20
> > For the general kernel heap, we do not know exactly where each
> > object
> > is, but we can tell whether the whole range from ptr to ptr + n is
> > inside the same page, or inside the same compound page.
> >=20
> > If the start and end of the "object" are in pages that were not
> > allocated
> > together, we are likely dealing with an overflow from one object
> > into
> > the next page, and should disallow this copy.
> >=20
> > Signed-off-by: Rik van Riel <riel@redhat.com>
> > ---
> > v2:
> > =C2=A0- also test against _bdata & _edata, this appears to be necessary
> > for
> > =C2=A0=C2=A0=C2=A0some kernfs/sysfs stuff
> > =C2=A0- clean up the code a little bit
> >=20
> > =C2=A0mm/usercopy.c | 27 +++++++++++++++++++++++----
> > =C2=A01 file changed, 23 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/mm/usercopy.c b/mm/usercopy.c
> > index e09c33070759..78869ea73194 100644
> > --- a/mm/usercopy.c
> > +++ b/mm/usercopy.c
> > @@ -109,7 +109,8 @@ static inline bool
> > check_kernel_text_object(const void *ptr, unsigned long n)
> >=20
> > =C2=A0static inline const char *check_heap_object(const void *ptr,
> > unsigned long n)
> > =C2=A0{
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct page *page;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct page *page, *endpage;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0const void *end =3D ptr + n =
- 1;
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (ZERO_OR_NULL_PTR(pt=
r))
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0return "<null>";
> > @@ -118,11 +119,29 @@ static inline const char
> > *check_heap_object(const void *ptr, unsigned long n)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0return NULL;
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0page =3D virt_to_head_p=
age(ptr);
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!PageSlab(page))
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (PageSlab(page))
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0/* Check allocator for flags and size. */
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0return __check_heap_object(ptr, n, page);
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* Is the object wholly with=
in one base page? */
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (likely(((unsigned long)p=
tr & (unsigned long)PAGE_MASK)
> > =3D=3D
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0((unsigned long)end & (unsigned
> > long)PAGE_MASK)))
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0return NULL;
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* Are the start and end ins=
ide the same compound page? */
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0endpage =3D virt_to_head_pag=
e(end);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (likely(endpage =3D=3D pa=
ge))
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0return NULL;
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* Is this a special area, e=
g. .rodata, .bss, or device
> > memory? */
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (ptr >=3D (const void *)_=
sdata && end <=3D (const void
> > *)_edata)
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0return NULL;
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (PageReserved(page) && Pa=
geReserved(endpage))
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0return NULL;
> Shouldn't PageReserved cover the .data, .rodata, and .bss areas
> already? Is the concern for the check being added here that a copy
> might span multiple pages and that they're not allocated together
> when
> laying out the kernel data regions?

Having just the PageReserved check was not enough, I had
to specifically add the _sdata & _edata test to get things
to work.

It looks like PageReserved is simply not set in some cases,
perhaps we are mapping those kernel sections with huge pages,
but not setting up the compound page stuff for the backing
pages, since they never pass through the buddy allocator?

--=20
All Rights Reversed.


--=-tHonhRfCfqAshMPPRmmi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJXbZ63AAoJEM553pKExN6Dpd8H/0rv9HJOkVfeMjDjct3PrElO
bHVmjUPrgorqcqPm/Fh32ZcKJ53Q/4L0SPKbs/OUPYdH9PidjQnM7gQR6cfDV20I
pMzX1QD5b7KYjsoOKJxivh2bcNXGp0+iPERhAWxjic/xcYfmTI88odUmZ1HcaBeF
Y+ajLuAeeYwXyFIPlaOwJmC1+DBvTpL8UdtmES8UDdDZc+TzACqrBuz3Nob6gMZc
ay53+Qa6nqij2iykAjbzwUp6QUyPvpm8uRxP80aKwOt1GjC96ZP+kL4sdDyMzRFK
zYf/B7DGd2Vu4fryCTQRNzkBFDB4HG/1O6xPduP4x/t+qXNxGZo1+5+scLdHwLc=
=wO2r
-----END PGP SIGNATURE-----

--=-tHonhRfCfqAshMPPRmmi--
