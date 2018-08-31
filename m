Date: Fri, 31 Aug 2018 13:44:06 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Subject: "Hardened" tree on kernel.org?
Message-ID: <20180831174406.GA1702@chatter>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi, all:

There's a lot of excellent work being done on this list and as part of=20
KSPP that enjoys limited exposure due to long and arduous upstreaming=20
process. I am wondering if some of the proposed changes would see wider=20
testing if there was a curated semi-official "hardened" tree hosted on=20
kernel.org that would carry kernel hardening patches proposed for=20
inclusion into mainline. There is at least one project that does=20
something like this:

https://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

though there's the distinction that, to my knowledge, RT is not intended=20
to be upstreamed.

I think wider testing and adoption would be easier if there was a place=20
for folks to download a "hardened Linux tarball" -- with the=20
understanding that it would include features that may or may not=20
eventually make it into mainline. I know it's a lot of work, and I'm=20
certainly not volunteering for it (I don't have the right set of skills=20
for this), but I believe there is a demand for such resource among=20
security enthusiasts and security-minded distros.

In a sense, this would shadow Greg's work -- taking the latest stable=20
tree and porting a hardening patchset on top of it. Maybe one of the LTS=20
trees, too?

Do you think this would be a worthwhile thing, or would that distract=20
=66rom overall mainlining goals?

-K

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQR2vl2yUnHhSB5njDW2xBzjVmSZbAUCW4l+ZgAKCRC2xBzjVmSZ
bMZTAQCRq+z4OTL3MlxWYj+MO8SDZh5ApJ4bPP8nT1OExUf5XAD9Fr2PkfY9z6aS
np9pVOPGcxaLOtmAz0yXiWumTB/wkAA=
=bZht
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
