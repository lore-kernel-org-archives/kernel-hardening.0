Date: Thu, 18 Jan 2018 22:57:55 +0100
From: Pavel Machek <pavel@ucw.cz>
Message-ID: <20180118215755.GB17196@amd>
References: <20171230175804.7354-1-alonid@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cvVnyQ+4j833TQvp"
Content-Disposition: inline
In-Reply-To: <20171230175804.7354-1-alonid@gmail.com>
Subject: [kernel-hardening] Re: [PATCH 0/5] RFC: Public key encryption of dmesg by the kernel
To: Dan Aloni <dan@kernelim.com>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--cvVnyQ+4j833TQvp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat 2017-12-30 19:57:59, Dan Aloni wrote:
> From: Dan Aloni <dan@kernelim.com>
>=20
> Hi All,
>=20
> There has been a lot of progress in recent times regarding the removal
> of sensitive information from dmesg (pointers, etc.), so I figured - why
> not encrypt it all? However, I have not found any existing discussions
> or references regarding this technical direction.
>=20
> I am not sure that desktop and power users would like to have their
> kernel message encrypted, but there are scenarios such as in mobile
> devices, where only the developers, makers of devices, may actually
> benefit from access to kernel prints messages, and the users may be
> more protected from exploits.

Yes, we have "TiVo" problem in mobile space, but please no, don't make
it worse.

We should not make it easy for device makers to lock devices down from
their owners.

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--cvVnyQ+4j833TQvp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlphGGMACgkQMOfwapXb+vKYzgCgsXhCQ5k4FTFeHZGSErOtmUzB
r48Ani2BjUlFeMGZgeZfQJcXYIoFXO0h
=NApR
-----END PGP SIGNATURE-----

--cvVnyQ+4j833TQvp--
