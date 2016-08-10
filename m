Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1470848794.22360.1.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Wed, 10 Aug 2016 13:06:34 -0400
In-Reply-To: <20160810094339.GK1041@n2100.armlinux.org.uk>
References: <1464979224-2085-1-git-send-email-keescook@chromium.org>
	 <1464979224-2085-3-git-send-email-keescook@chromium.org>
	 <20160810094339.GK1041@n2100.armlinux.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-Q/qlRIpvYaP1z5fi9iJQ"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Re: [PATCH 2/2] arm: apply more
 __ro_after_init
To: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
Cc: linux-arch@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, x86@kernel.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Mathias Krause <minipli@googlemail.com>, linux-arm-kernel@lists.infradead.org
List-ID: <kernel-hardening.lists.openwall.com>


--=-Q/qlRIpvYaP1z5fi9iJQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2016-08-10 at 10:43 +0100, Russell King - ARM Linux wrote:
> On Fri, Jun 03, 2016 at 11:40:24AM -0700, Kees Cook wrote:
> >=20
> > @@ -1309,16 +1309,11 @@ void __init arm_mm_memblock_reserve(void)
> > =C2=A0 * Any other function or debugging method which may touch any
> > device _will_
> > =C2=A0 * crash the kernel.
> > =C2=A0 */
> > +static char vectors[PAGE_SIZE * 2] __ro_after_init
> > __aligned(PAGE_SIZE);
> > =C2=A0static void __init devicemaps_init(const struct machine_desc
> > *mdesc)
> > =C2=A0{
> > =C2=A0	struct map_desc map;
> > =C2=A0	unsigned long addr;
> > -	void *vectors;
> > -
> > -	/*
> > -	=C2=A0* Allocate the vector page early.
> > -	=C2=A0*/
> > -	vectors =3D early_alloc(PAGE_SIZE * 2);
>=20
> This one is not appropriate.=C2=A0=C2=A0We _do_ write to these pages afte=
r init
> for FIQ handler updates.=C2=A0=C2=A0See set_fiq_handler().

This is one of the many cases where pax_open_kernel/pax_close_kernel are
needed to temporarily toggle it read-only. From grsecurity:

@@ -95,7 +95,10 @@ void set_fiq_handler(void *start, unsigned int
length)
=C2=A0	void *base =3D vectors_page;
=C2=A0	unsigned offset =3D FIQ_OFFSET;
=C2=A0
+	pax_open_kernel();
=C2=A0	memcpy(base + offset, start, length);
+	pax_close_kernel();
--=-Q/qlRIpvYaP1z5fi9iJQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIzBAABCAAdBQJXq18aFhxkYW5pZWxtaWNheUBnbWFpbC5jb20ACgkQ+ecS5Zr1
8irePg//TKe757WyOXALrOMRUCu23Hyabo8KH2hG1+89dhY5wcf8WU62MetiI2ES
yI8i464YC/IQJaPt3ue6DUgI59msSXjbgHFRxUWA/lZBL1AnQQ751g6dQW1Fe52c
KI1DoNcCKEhRFOSRRInhWHjmw0norIb89Uj2VpZzDUigil47mBgDF+cJupV/T+JA
qpgeqHPFRX8x9qB6xySHlrWCShpRobYWqJ3A1o0mPPNucha1S7/HvWbcoLSKxEkS
a+C+At+C8bb5ADgwj+fDEhx1cwLF5GQMyWMFG3X7iEe/FhwAXqtxeALMXpndFjH1
t0iV4yyeiXG4hz+9rbVh6A176rYUC8nQIHKSZNMNo9W/A9zL3qy3l/IjvuPMF71F
xR44u/kXQ8W7ZFFaGV3FgIFNLP72Aedx26CeDwAfMTf0M79QsUOuRatQfi5WSHQZ
w2So8K+u9C4ZpDWdvMvz+0MxqSrzi6Wscrxnzcy0MnWxYvxDFctGSC71vZCmm5yj
SkZzCN0AXkzBc/u6WgRvUJzbOWLG/VWDAq/NtyCl5WJd2Brn27Wpsw9BGDWbyPUR
HeNXLNfHvk1iCs8ZjHhWmqK+D9hkCL8HhtR0ZTO3u6X+yxyXXC8ThEw/7xVFVjKp
yD0kYhouVM5I/TniKly285OD5WfNlSe1+GL76LiK/sL44uFzOZk=
=ES56
-----END PGP SIGNATURE-----

--=-Q/qlRIpvYaP1z5fi9iJQ--
