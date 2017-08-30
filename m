Date: Wed, 30 Aug 2017 11:57:35 +0200
From: Pavel Machek <pavel@ucw.cz>
Message-ID: <20170830095735.GB31503@amd>
References: <20170816231458.2299-1-labbott@redhat.com>
 <20170816231458.2299-3-labbott@redhat.com>
 <20170817033148.ownsmbdzk2vhupme@thunk.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RASg3xLB4tUQ4RcS"
Content-Disposition: inline
In-Reply-To: <20170817033148.ownsmbdzk2vhupme@thunk.org>
Subject: [kernel-hardening] Re: [PATCHv3 2/2] extract early boot entropy from the passed cmdline
To: Theodore Ts'o <tytso@mit.edu>, Laura Abbott <labbott@redhat.com>, Kees Cook <keescook@chromium.org>, Daniel Micay <danielmicay@gmail.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>


--RASg3xLB4tUQ4RcS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2017-08-16 23:31:48, Theodore Ts'o wrote:
> On Wed, Aug 16, 2017 at 04:14:58PM -0700, Laura Abbott wrote:
> > From: Daniel Micay <danielmicay@gmail.com>
> >=20
> > Existing Android bootloaders usually pass data useful as early entropy
> > on the kernel command-line. It may also be the case on other embedded
> > systems.....
>=20
> May I suggest a slight adjustment to the beginning commit description?
>=20
>    Feed the boot command-line as to the /dev/random entropy pool
>=20
>    Existing Android bootloaders usually pass data which may not be
>    known by an external attacker on the kernel command-line.  It may
>    also be the case on other embedded systems.  Sample command-line
>    from a Google Pixel running CopperheadOS....
>=20
> The idea here is to if anything, err on the side of under-promising
> the amount of security we can guarantee that this technique will
> provide.  For example, how hard is it really for an attacker who has
> an APK installed locally to get the device serial number?  Or the OS
> version?  And how much variability is there in the bootloader stages
> in milliseconds?
>=20
> I think we should definitely do this.  So this is more of a request to
> be very careful what we promise in the commit description, not an
> objection to the change itself.

The command line is visible to unpriviledged userspace (/proc/cmdline,
dmesg). Is that a problem?

U-boot already does some crypto stuff, so it may have some
randomness. Should we create parameter random=3Dxxxxxxxxxxx that is
"censored" during kernel boot?

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--RASg3xLB4tUQ4RcS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlmmjA8ACgkQMOfwapXb+vJx+gCfbuzNxz5YCVMu8ZMV0UZgXiRB
JRsAoLojraEOtgUHHZR5Yk4VSfVR5Ijw
=3UhI
-----END PGP SIGNATURE-----

--RASg3xLB4tUQ4RcS--
