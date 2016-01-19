Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1453221128.3734.26.camel@decadent.org.uk>
From: Ben Hutchings <ben@decadent.org.uk>
Date: Tue, 19 Jan 2016 16:32:08 +0000
In-Reply-To: <20160119112812.GA10818@mwanda>
References: <20160119112812.GA10818@mwanda>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-XYq2xIil+V/XwGlgtYyU"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] 2015 kernel CVEs
To: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


--=-XYq2xIil+V/XwGlgtYyU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2016-01-19 at 14:28 +0300, Dan Carpenter wrote:
> I like to look back over old CVEs to see how we could do better.=C2=A0=C2=
=A0Here
> is the list from 2015.=C2=A0=C2=A0I got most of this information from the=
 Ubuntu
> CVE tracker.=C2=A0=C2=A0Thanks Ubuntu!.=C2=A0=C2=A0If it doesn't have a h=
ash that means it
> might not be fixed yet.
[...]
> CVE-2013-2015 0e9a9a1ad619: ext4: hang during mount
[...]

That's not *from* 2015.

You missed a few recent ones:

CVE-2015-7566 : Crash on invalid USB device descriptors in visor driver
CVE-2015-8550 54d5d882c7e4, 0f589967a73f, 68a33bfd8403, 1f13d75ccb80, 18779=
149101c, be69746ec12f, 8135cf8b0927: paravirtualized drivers incautious abo=
ut shared memory contents
CVE-2015-8551 56441f3c8e5b, 5e0ce1455c09, a396f3a210c3, 7cfb905b9638, 408fb=
0e5aa7f: Linux pciback missing sanity checks leading to crash
CVE-2015-8552 56441f3c8e5b, 5e0ce1455c09, a396f3a210c3, 7cfb905b9638, 408fb=
0e5aa7f: Linux pciback missing sanity checks leading to crash

(There's some subtle distinction between the last two.)

[...]
> There was only a coupls CVEs that looks like they came from a filesystem
> fuzzer where you create a corrupt filesystems and then try use them.
> There was only one that might have come from a USB fuzzer.=C2=A0=C2=A0We =
probably
> should be testing those things better.

I think that hardening filesystems is a losing battle. =C2=A0We can fuzz
with and protect against invalid static filesystem images, but the full
problem includes malicious removable storage devices that can exploit
TOCTTOU issues. =C2=A0We should probably be encouraging distributions to
mount removable devices using FUSE and to run the filesystem code with
minimal privileges.

As for USB descriptors, I'm somewhat more hopeful about hardening. =C2=A0At
the same time, it seems like it should be practical to put more low-
performance USB drivers into userspace.

[...]
> A lot of the bugs are just really complicated things with funny corner
> cases, namespace issues or people just made mistake in the logic and
> it's hard to do anything about it.

We can add chicken bits so that admins who don't need certain features
can turn them off (or, inversely, those who do need them will need to
turn them on).

Ben.

--=20
Ben Hutchings
Horngren's Observation:
                   Among economists, the real world is often a special case=
.

--=-XYq2xIil+V/XwGlgtYyU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAVp5lCOe/yOyVhhEJAQpD/BAAorj1Su03tBi450GG69vNP+Nx/7z8Mdvx
DDTegHub3VjIifLpHyuFPhRI+LG+wjlIgQBL7Fr7QpiEOCaIfYEkToii3AziLwux
7TldtCI+R7F+wL9vyGRE/H16vQ4gbg2l6dLrzmf9Zg5FGirFfhnSsn1h2Z2rG7Fc
66OUFF7Lvk4Y0QNcdgvz3sdxFxqzSM6f50+85JH6ApBsH7OMPGcrqIyJC1I05OR4
++O8ZltBvWxt3vNRzM7BvHiLMpAaiOg+3z3qZlCtTmKa5k9RszfGst48W9SyWX8z
QIrpXKMw24wIAb1m95CvUhvRptJJsXuBdXd0U7e9yRpLQey4k1aSDVl9c0i1uNrc
L/TU4ycUSLz5n/DOVz9QaOWKKxEG/TuoxINsiTjt3rTZl2czzfayOgc9SGkR1Aqf
wX1Z0x29h4XHT3u3EyFPeVk6XkX74Qa1CB4AzdWutLZClZyGyHY9tfioAdQQDaCL
47ppBlZU4DKKPAr9fa1KiQPaGy3aXDaJXLG0XAG5kZVmCWthC5+fASIOz7nHj3GV
KedjldCes2zb/d3oOUT0UFhp9aA8G+eLoc/30ES5f0+VUHDLcgEQDZm6kMWN/UdE
4vS37if41Q0QytnPZn4TEtlfYncW3omz0b7jZHJWvy30xRXEq8TajjFGAUbd4Nsf
pfijN95toF8=
=KGxV
-----END PGP SIGNATURE-----

--=-XYq2xIil+V/XwGlgtYyU--
