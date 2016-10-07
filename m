Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 7 Oct 2016 13:52:39 +0200
From: Jann Horn <jann@thejh.net>
Message-ID: <20161007115239.GA14666@pc.thejh.net>
References: <1475690686-16138-1-git-send-email-william.c.roberts@intel.com>
 <20161006133147.GA20206@infradead.org>
 <476DC76E7D1DF2438D32BFADF679FC561CD14651@ORSMSX103.amr.corp.intel.com>
 <20161006140553.GY14666@pc.thejh.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XCIqNWEteo88hZlY"
Content-Disposition: inline
In-Reply-To: <20161006140553.GY14666@pc.thejh.net>
Subject: Re: [kernel-hardening] RE: [PATCH] printk: introduce kptr_restrict
 level 3
To: "Roberts, William C" <william.c.roberts@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "corbet@lwn.net" <corbet@lwn.net>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


--XCIqNWEteo88hZlY
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

Actually, I think I missed something here.

We don't really want to censor pointers in dmesg, right? dmesg can
contain pointers by design - and in particular, when an oops
happens, the register dump will reveal pointers. dmesg should just
be restricted using dmesg_restrict.

(What is annoying, though, is that e.g. Debian's default rsyslog
config sends all KERN_EMERG messages to all active PTYs by default,
meaning that on a system with such a config, making the kernel oops
can be used to leak some ASLR information.)

(And why does __die() in arch/x86/kernel/dumpstack.c use KERN_EMERG
for CONFIG_X86_32, but KERN_ALERT for !CONFIG_X86_32?)

--XCIqNWEteo88hZlY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX94yGAAoJED4KNFJOeCOo23AP/A8ckLuaFR98c5smrxOejd+5
hYWWEWVoz/KFvobzIywgs8cJRRW/oyCExP7X385rmi6QEfa09p2ucbMlY1s8cZtx
muERWdyXkKjGJdWFitLtxecnLu2FOCcQi4WQgEapbsczSx4Q3SVEpVh/5QpD2BLc
XY8Khz145CMS7H9CigHQf5BRT2SvZhUPR6GhfLjMfeZRKFYOQdfZV60VkHX4KFM/
CDxuc72zYPoeANhYaPbQW8Mh17UnV8Sq2G17d0nLq9jIy8bMwSTpWKDovRQB6U4C
OGp2hDszfFv/eHvW7DJ0cz4nKg+wbouKBmYbv6tKcba8b+cZsE8C0A+Ftp3Tq7zA
nWNorXQHhVOomMj9ywUoLdOB5kbrygILfPtSKeG07MwgIaWWea7mDW33Nc2T0/b7
KItgoJBT0e1MQu3IBkAhNbL4h1xW79a6NzVKxYTiMLjFIGIR5UyNUR2qnFvivLMS
/kGIKHzYU0qq8JDufBNhKtgLBNgmlZfxK8YpemJRcnRtx/jtVLhQMJpDaoYDBPX2
ntQPoizdLOnoy8qFjEcv/QpQo3w2pclfYP7fIQW+Dhj8VTzkvvMguYWsXt+a6jdk
LkDw13HKpvo38kv1RkU1U6lWtucfh/v2fMIOTen0jHv2UQMqbW1f3qpHKdrgWIhd
2mQ+yLLTyMA0wZpOOcMA
=V4ca
-----END PGP SIGNATURE-----

--XCIqNWEteo88hZlY--
