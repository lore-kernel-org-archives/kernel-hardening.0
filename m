Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1450399738.3054.10.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Thu, 17 Dec 2015 19:48:58 -0500
In-Reply-To: <CAGXu5j+mTVrtDXbGtF=-nyAxnTe2YDL4PyUnJw+vfXX_ZVzwxg@mail.gmail.com>
References: 
	<CAB-iPKVnu554hZ=nSmSgrLQE+c02oGKE8As5prWHy6n0O=erCw@mail.gmail.com>
	 <CAGXu5j+mTVrtDXbGtF=-nyAxnTe2YDL4PyUnJw+vfXX_ZVzwxg@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-TmYyokXM+kekTCQLptm0"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Introduction
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--=-TmYyokXM+kekTCQLptm0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2015-12-17 at 16:36 -0800, Kees Cook wrote:
> On Thu, Dec 17, 2015 at 3:34 PM, Leibowitz, Michael
> <michael.leibowitz@intel.com> wrote:
> > I work in Intel's Open Source Technology center, along with my
> > colleague, Elena Reshetova.=C2=A0=C2=A0I'm reasonably new real-life ker=
nel
> > development, having previously just mucked about.=C2=A0=C2=A0Otherwise,=
 I'm a
> > long-time open source/security trouble maker.
>=20
> Hi! Welcome! :)
>=20
> > I'm Interested in working on struct randomization ala RANDSTRUCT.
> > Does this seem like a suitable task?
>=20
> I certainly wouldn't turn it down, but I would observe that it has
> some limited utility to users of the kernel that produce binary
> builds. e.g. all the given builds of Ubuntu with RANDSTRUCT would be
> the same (though the next released version would see a different
> randomization, etc). It also complicates externally built modules. I
> see it depends on HIDESYM, though, which in turn depends on
> PAX_USERCOPY, so it would be much weaker without these two finished
> first.
>=20
> All that said, it might still be an interesting piece to extract. It
> would make automated cross-distro or cross-version attacks much more
> difficult to mount and has in the past exposed some bugs. (e.g.
> missing container_of() uses, etc.)

AFAIK spender was planning on implementing stack frame layout
randomization too (not sure if it's done yet) and that wouldn't have the
same ABI implications. They could be offered separately.

LLVM also has some code diversity stuff in progress like randomizing instru=
ction scheduling to an extent (can at least determine any of the arbitrary =
decisions with random choices), and it would make sense for GCC too.

It can be more useful for builds distributions as binaries than it
seems. Making 256 or more builds with the tarballs padded out to the
same size and distributing them via encryption connections wouldn't be
difficult. It would be more difficult to implement for Android and
ChromeOS since they use delta updates but it could be done by having a
bunch of different release channels for each device. It might really
screw up delta updates if it's used across the system though, but the
kernel alone wouldn't be that bad.
--=-TmYyokXM+kekTCQLptm0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJWc1f6AAoJEPnnEuWa9fIqOksP/24QgGukb4diGhYvJwODA0Re
x1ZN+b5Q8BSsliwrq+gT9YcwuKa26r+dSG7KhD1mWoCJ/+EKkDuC9QHqzpyH4dWD
Mqs8qvs4q56NrXRVDvondEpgs7DY9pZH58RzgAi8VM0ELBuIJ3tl2BHdKj4x6P4X
AKQsPL3NuruBtJ455yop1cXKtjF3dQlMLDUTlE0L4ZpOuD6/nQ4iYeTeb9E4Z9N/
/9qR7OvtRc32KC8GOKbD57nLe90ycanbzMfM1l7Fd+9uT44p9yKJ++mUFnzlTXTj
zLClhn7n4hmz+lPRmtsWUTpZFbaieXwxcmi64RPKBSzUQmRKCY9ZJBkxPZfASsDb
2btlYAodPZ5Rak3CbsJ/+ZwRVl6xV80EWBcKGNCdOovxPXq/zU8IAc9UMdwj0P6d
RdBtLVF5XJFkoGfERmvjpmLJb7HEWCQYVSN+CvROBVTaNMFXjhWHwMLxxSX2GtKM
/FHxjlxjsaraG6tFedWE1x5iLl8KzApbJK0DqNCy0Iw+Kyec6Xo452Pcz7vut3fM
VDUlj3zwfZ1e0+zMf3gW11eNQbuXnckswt9x7hzTWMCSNnbLTKzO8l8GLCh0Tvzm
bD9dYCEQO7+8k3a9ZaKHubjGBVzpeW4wS1jNFMfaTB7vJn40pE+1EONxoewbZksm
lGs+dZxb4iaV5Btf3Uoh
=tWQV
-----END PGP SIGNATURE-----

--=-TmYyokXM+kekTCQLptm0--
