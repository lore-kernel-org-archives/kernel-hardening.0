Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 6 Oct 2016 16:05:53 +0200
From: Jann Horn <jann@thejh.net>
Message-ID: <20161006140553.GY14666@pc.thejh.net>
References: <1475690686-16138-1-git-send-email-william.c.roberts@intel.com>
 <20161006133147.GA20206@infradead.org>
 <476DC76E7D1DF2438D32BFADF679FC561CD14651@ORSMSX103.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MLcyhLwX/7AHNQNx"
Content-Disposition: inline
In-Reply-To: <476DC76E7D1DF2438D32BFADF679FC561CD14651@ORSMSX103.amr.corp.intel.com>
Subject: Re: [kernel-hardening] RE: [PATCH] printk: introduce kptr_restrict
 level 3
To: "Roberts, William C" <william.c.roberts@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "corbet@lwn.net" <corbet@lwn.net>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


--MLcyhLwX/7AHNQNx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 06, 2016 at 01:47:47PM +0000, Roberts, William C wrote:
> > -----Original Message-----
> > From: Christoph Hellwig [mailto:hch@infradead.org]
> > Sent: Thursday, October 6, 2016 9:32 AM
> > To: Roberts, William C <william.c.roberts@intel.com>
> > Cc: kernel-hardening@lists.openwall.com; corbet@lwn.net; linux-
> > doc@vger.kernel.org; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH] printk: introduce kptr_restrict level 3
> >=20
> > On Wed, Oct 05, 2016 at 02:04:46PM -0400, william.c.roberts@intel.com w=
rote:
> > > From: William Roberts <william.c.roberts@intel.com>
> > >
> > > Some out-of-tree modules do not use %pK and just use %p, as it's the
> > > common C paradigm for printing pointers. Because of this,
> > > kptr_restrict has no affect on the output and thus, no way to contain
> > > the kernel address leak.
> >=20
> > So what?  We a) don't care about out of tree modules and b) you could j=
ust triviall
> > fix them up if you care.
>=20
> Out of tree modules still affect core kernel security. I would also bet m=
oney, that somewhere
> In-tree someone has put a %p when they wanted a %pK. So this method is ju=
st quite error
> prone. We currently have a blacklist approach versus whitelist.

grep says you have a point:

$ grep -IR 'seq_printf.*%p[^FfSsBRrhbMmIiEUVKNadCDgG].*&'
drivers/dma/qcom/hidma_dbg.c:	seq_printf(s, "dev_trca=3D%p\n", &dmadev->dev=
_trca);
drivers/dma/qcom/hidma_dbg.c:	seq_printf(s, "dev_evca=3D%p\n", &dmadev->dev=
_evca);

$ grep -IR 'pr_info.*%p[^FfSsBRrhbMmIiEUVKNadCDgG].*&'
drivers/misc/lkdtm_heap.c:	pr_info("Allocated memory %p-%p\n", base, &base[=
offset * 2]);

$ grep -IR 'pr_err.*%p[^FfSsBRrhbMmIiEUVKNadCDgG].*&'
drivers/net/ethernet/qlogic/qlge/qlge_dbg.c:	pr_err("rx_ring->cqicb =3D %p\=
n", &rx_ring->cqicb);

And these are just trivially greppable, low-hanging-fruit ones.
With somewhat broader greps, there seem to be lots more, but they'd
require manual review.

And in total, there are 13578 matches for %p[^FfSsBRrhbMmIiEUVKNadCDgG]
throughout the kernel. Reviewing all of those manually would suck.

--MLcyhLwX/7AHNQNx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX9lpBAAoJED4KNFJOeCOoYg4QANR2lpikQh7+IETMZl45yuT9
Q2j+3Ggk62iZKDmRHkjDSBkXfc0tvJaSGUDEqNmHrcFq6N7DY38eywXvCzZDVYER
zEm9pXBQtFpTg7YoVG72BKyr13wh6x4peFtZ9a2FsRIIawOVDKuobmUKko2/VZf4
nZ9oIQ1KX6c1VpI+ld5RJltseziOdcB6qFpbiI6qMJ0iPmOL/m3o2/N9za4AoLaa
EJPfDeJj+xePvQy/2L5sPGKdBJx1vE48v+Em2YYChSDmI9P//6C63C/CZUT3JCuK
uZtl5hYjTiJ3wbUZ+8oo98vOHkqI1C2PyT+4RRWHsKdQ9AVGsh4QFtrrLw5gtMz4
vObq6vCMC0CcBYJdZaw5l+RSCTTDy2IPvqLJOjDEFr5ND97rGwCcuQe4TE6CGNIr
NDt2DRu1GtTMgS/zH1pUupSyUbgoAkWM5+3iP8RKlW1iwp6ojCducaOIQwPaqCCk
Y291BJXF7Sj0CzDoOaVxbm2Dlvg3Az1qOehoQipJj+Jimm2FzYbJlPYxX3fDemvW
0K/oCTWHdO8vk/pcJSMf1EyFdU4sTytnelLrzl/HVUrd2WEHJvmZCLM3GHS0uJ22
eELa53kaoiB9BZ75viwFby/6yc3hKBphCub7nLHuuaLsFfe2mkFC3NmEUpqhhxBa
XkSwikoRKZV9uoqjx1vC
=Hg5y
-----END PGP SIGNATURE-----

--MLcyhLwX/7AHNQNx--
