Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 6 Oct 2016 16:46:56 +0200
From: Jann Horn <jann@thejh.net>
Message-ID: <20161006144656.GZ14666@pc.thejh.net>
References: <1475690686-16138-1-git-send-email-william.c.roberts@intel.com>
 <20161006133147.GA20206@infradead.org>
 <476DC76E7D1DF2438D32BFADF679FC561CD14651@ORSMSX103.amr.corp.intel.com>
 <20161006140553.GY14666@pc.thejh.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="doUn1Hmx68n+7ij2"
Content-Disposition: inline
In-Reply-To: <20161006140553.GY14666@pc.thejh.net>
Subject: Re: [kernel-hardening] RE: [PATCH] printk: introduce kptr_restrict
 level 3
To: "Roberts, William C" <william.c.roberts@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "corbet@lwn.net" <corbet@lwn.net>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


--doUn1Hmx68n+7ij2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 06, 2016 at 04:05:53PM +0200, Jann Horn wrote:
> On Thu, Oct 06, 2016 at 01:47:47PM +0000, Roberts, William C wrote:
> > > -----Original Message-----
> > > From: Christoph Hellwig [mailto:hch@infradead.org]
> > > Sent: Thursday, October 6, 2016 9:32 AM
> > > To: Roberts, William C <william.c.roberts@intel.com>
> > > Cc: kernel-hardening@lists.openwall.com; corbet@lwn.net; linux-
> > > doc@vger.kernel.org; linux-kernel@vger.kernel.org
> > > Subject: Re: [PATCH] printk: introduce kptr_restrict level 3
> > >=20
> > > On Wed, Oct 05, 2016 at 02:04:46PM -0400, william.c.roberts@intel.com=
 wrote:
> > > > From: William Roberts <william.c.roberts@intel.com>
> > > >
> > > > Some out-of-tree modules do not use %pK and just use %p, as it's the
> > > > common C paradigm for printing pointers. Because of this,
> > > > kptr_restrict has no affect on the output and thus, no way to conta=
in
> > > > the kernel address leak.
> > >=20
> > > So what?  We a) don't care about out of tree modules and b) you could=
 just triviall
> > > fix them up if you care.
> >=20
> > Out of tree modules still affect core kernel security. I would also bet=
 money, that somewhere
> > In-tree someone has put a %p when they wanted a %pK. So this method is =
just quite error
> > prone. We currently have a blacklist approach versus whitelist.
>=20
> grep says you have a point:
>=20
> $ grep -IR 'seq_printf.*%p[^FfSsBRrhbMmIiEUVKNadCDgG].*&'
> drivers/dma/qcom/hidma_dbg.c:	seq_printf(s, "dev_trca=3D%p\n", &dmadev->d=
ev_trca);
> drivers/dma/qcom/hidma_dbg.c:	seq_printf(s, "dev_evca=3D%p\n", &dmadev->d=
ev_evca);
>=20
> $ grep -IR 'pr_info.*%p[^FfSsBRrhbMmIiEUVKNadCDgG].*&'
> drivers/misc/lkdtm_heap.c:	pr_info("Allocated memory %p-%p\n", base, &bas=
e[offset * 2]);
>=20
> $ grep -IR 'pr_err.*%p[^FfSsBRrhbMmIiEUVKNadCDgG].*&'
> drivers/net/ethernet/qlogic/qlge/qlge_dbg.c:	pr_err("rx_ring->cqicb =3D %=
p\n", &rx_ring->cqicb);
>=20
> And these are just trivially greppable, low-hanging-fruit ones.
> With somewhat broader greps, there seem to be lots more, but they'd
> require manual review.

(Although, of course, most matches for seq_printf are in debugfs
files or stuff that's only enabled with some DEBUG config option
or so. But there are also e.g. pr_warn() users of %p that are not
in debug code.)

--doUn1Hmx68n+7ij2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX9mPgAAoJED4KNFJOeCOoKpMP/ROMkmaIyM6ljgl4dAmvOjHy
MEnXmtjXpERVkfvWpLypLPw8p96pprig6Vy+M5uGjE/bWcFpCNrrAwSVmHth6RBT
r3j9NXh08gTBFqdZxQw+g12zT0gaIdXgNY5W9oCA1y3K9jvja3RaS+GCPlZzoCTp
t6LatwwfQReRic+MPhPXum/Gmri9z5f51oXIrTbJzjCUwYYjnVqrde+sbuNXh2fp
Ma6AxL4A8DoDpoR+9wbBuxM4g9oWdrdkQaAqZFo26fGdLP0XCFtea64lkLydEXDg
+gDOo5vWxWY3q+PqzjQcYUOUVONmnRkHRt09bo9oNssxbIItD5ewWoBHwvxKtR0A
Z691x1UpczUOHZpfPjuBRHK+7lvs5ie/1ofKzmtQ/VgApMqIUqzWSeIwkjWf2fkS
Way0d2fNg001NX9DhDFA1iaaEdJ5Ou1JqAqy5KMWrqZkldlSnEEdpnSQgyPHtBxw
O0BkSQ5NXA8vNaEWckQYQ8qYDVsTaAHij12MBwClU65ntJSI/IzlZvtG9PyAM0dF
+kZp1FF09ho4j+40fU6siaVbTjcH2aIoVCenZAZGYmGA/VFe0VA+Yw1UWENUC9/l
5DM0LYWsyB54PLXToWbh4JgKv/Np4gKglEt2CXqmhlBJRp89tOOc2prHJYfS9b6e
HUy/9bIpTqGW/JaZnf33
=Lv+9
-----END PGP SIGNATURE-----

--doUn1Hmx68n+7ij2--
