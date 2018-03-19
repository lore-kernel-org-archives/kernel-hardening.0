Message-ID: <1521421160.2495.188.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 56/76] x86/syscall: Sanitize syscall table
 de-references under speculation
From: Ben Hutchings <ben@decadent.org.uk>
Date: Mon, 19 Mar 2018 00:59:20 +0000
In-Reply-To: <2a1d3a0f-6227-39c6-0ed9-a07c22424d67@suse.cz>
References: <lsq.1520823972.93871245@decadent.org.uk>
	 <2a1d3a0f-6227-39c6-0ed9-a07c22424d67@suse.cz>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-mI2R8bO8LtGKrB4ZLhsb"
Mime-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Jinpu Wang <jinpu.wang@profitbricks.com>, kernel-hardening@lists.openwall.com, Andy Lutomirski <luto@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Jan Beulich <JBeulich@suse.com>, alan@linux.intel.com, Thomas Gleixner <tglx@linutronix.de>, Dan Williams <dan.j.williams@intel.com>, gregkh@linuxfoundation.org, linux-arch@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


--=-mI2R8bO8LtGKrB4ZLhsb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2018-03-12 at 08:32 +0100, Jiri Slaby wrote:
> On 03/12/2018, 04:06 AM, Ben Hutchings wrote:
> > In 3.16 the x86_32 syscall table lookup is also written in assembly.
> > So I've taken Jiri's version and added similar masking in entry_32.S,
> > using edx as the temporary.  edx is clobbered by SAVE_REGS and seems
> > to be free at this point.
>=20
> I don't know the state in 3.16, but in 3.12, I had to fix the 32bit
> entry on 64bit in arch/x86/ia32/ia32entry.S (ia32_sysenter_target &
> others) too.

Thank you, yes I need to fix them in 3.16 too.  I also failed to use
retpolines there.

Ben.

--=20
Ben Hutchings
The first rule of tautology club is the first rule of tautology club.


--=-mI2R8bO8LtGKrB4ZLhsb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAlqvC2gACgkQ57/I7JWG
EQmXpRAAwMMnb5IZ7NDeYxMrSAYDFY4c7Bf/qHchP6Sj4WB8pR58u6Ptt0pQR5nJ
d3gt2EKjANaXJQfp6JKX9SOFyY1HEL0hz1tf/E99Qib4hHPJ4PnD8srug4MQW3q2
1Rcl2LE+pqHRP6N3ge4/QEV+xRcs2+k+RMHVOrMco+9s1RfPfQJKTE7Bh1VkYX1R
iTkcc+r+eA53pkorBOovZ48Ih74SWuV3CdJ2jypZBcVbep4dPrw/dzrsLTKa9DL1
d64KEiZLCWOcZs1exeDAzvFFk0QKiB61znapD3MHlkor6lFp2DgNIU7rizYdW2G5
Ig/XNpKZnhFaPLB56xAZ/dZU5RgFwo0wpOvDH97OOdf6cYu9dM0f5m5eK7W/Ozaz
JrJEEbWPcL5WEgEtTIY7B890sgacwlJdxBqeVmeurBU7nE2DcGCgqTisF7DbJIMv
BPBrQct92RpS9xM3HQxMbOsqP91w1GHL+TrDr65ehSZzG7pE9E03rzE2k/LBn8yn
9cE55uVVU84u13+jR9A63us7c3j+pJkMiUoLZVHZasFoZjlrysuxyiR/NAo4gNJA
Ue6X7VW/nAdIQkgzA3Nrgnx5HOHkjJK3DdweQkzR4+5zuWXq98TTOetVuC/Pcrhk
DrLIPKiUdkuIC4z6n9tk1RpKWITpeIVq+hScPnnZ6NuG0fQJOOw=
=nHXF
-----END PGP SIGNATURE-----

--=-mI2R8bO8LtGKrB4ZLhsb--
