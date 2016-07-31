Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 31 Jul 2016 14:02:55 +0200
From: Jann Horn <jann@thejh.net>
Message-ID: <20160731120255.GB14676@pc.thejh.net>
References: <1469777680-3687-1-git-send-email-elena.reshetova@intel.com>
 <1469777680-3687-2-git-send-email-elena.reshetova@intel.com>
 <20160729181213.GD11621@pc.thejh.net>
 <2236FBA76BA1254E88B949DDB74E612B41B7029C@IRSMSX102.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3lcZGd9BuhuYXNfi"
Content-Disposition: inline
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41B7029C@IRSMSX102.ger.corp.intel.com>
Subject: Re: [kernel-hardening] [RFC] [PATCH 1/5] path_fchdir and
 path_fhandle LSM hooks
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "keescook@chromium.org" <keescook@chromium.org>, "spender@grsecurity.net" <spender@grsecurity.net>, "jmorris@namei.org" <jmorris@namei.org>, "Schaufler, Casey" <casey.schaufler@intel.com>, "Leibowitz, Michael" <michael.leibowitz@intel.com>, "Roberts, William C" <william.c.roberts@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>


--3lcZGd9BuhuYXNfi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 31, 2016 at 10:55:04AM +0000, Reshetova, Elena wrote:
> On Fri, Jul 29, 2016 at 10:34:36AM +0300, Elena Reshetova wrote:
> > This introduces two new LSM hooks operating on paths.
> >=20
> >   - security_path_fchdir() checks for permission on
> >     changing working directory. It can be used by
> >     LSMs concerned on fchdir system call
>=20
> >I don't think security_path_fchdir() is a good abstraction level. It
> neither covers the whole case of "cwd is changed" nor does it cover the
> whole case of "someone uses a file descriptor to a directory to look up
> stuff outside that directory".
> Do you have a suggestion on what can be a good place?=20
>=20
> >For example, security_path_fchdir() seems to be intended to prevent the =
use
> of a leaked file descriptor to the outside world for accessing other files
> in the outside world.=20
> Yes, this was exactly the use case.
>=20
> >But this is trivially bypassed by first using openat() directly instead =
of
> fchdir()+open() (something that used to work against grsecurity, but was
> fixed quite a while ago).
> The way it has been addressed in grsecurity is having a check inside
> filename_lookup() , but it doesn't look a very great place for putting a
> hook. I was thinking about it , but so far didn't find any other good
> alternatives.=20

Yeah, if you want to have such a hook, I think it needs to be in
filename_lookup() or below - but that's a relatively hot function, so it
might have a measurable performance impact.

Alternatively, you could forbid double-chroots and use the LSM hooks for
file descriptor passing via unix domain sockets and binder to check
incoming file descriptors. As long as no directories are moved out of the
chroot directory by something outside the chroot (a process chrooted into
a parent directory or a process that isn't chrooted), that should
prooobably work?

--3lcZGd9BuhuYXNfi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXnejvAAoJED4KNFJOeCOobAoQAIJu6hA+mDWsnxhB7ngeUdSf
fdb8SMt2zZ3xiIA9AQc3Rfhx0yd2wrf+UO1Bt/7bCt2r1IFDeQEE9jPm4MOi7N2N
iM0dLuyr9khpYI4Cg1wcbV/7kbeJpLy7Rx8XL0gTmWB4DylpqsX7ERFTzTmWg2TF
Kg/RNStK2/4BnOw+IPbe/B4K+TWXkc2A3faoxbuOZNtnFEYFk2kM+2HJBinzXxI0
i4ZTGG8leC6jRsfIZYF5CnFbb8/HmoNqisR2sLh3cXlrioeMAK2VXxqhUcuTn5VD
91Nljy5R6ChsYvPctskgnor1Q22ZXN6au3oQ3i4hsJtSBAbs6IbTPJiWzKDnfHgK
fhVj1hQlELLkmFFgXLmpY7ruVavHiUl/znHAu4cOyn7O9Nu8xs+9lKpRrffqKhEX
4d/EyMsWwRhOIxiugJfyas2XtVWwmMdOqazUZeecMtmEG0M4nHPYKZ2EkZJcAqU5
nqRwrm+vFFHCbY6StQQgaaz+54jiTrpCLiS9mYRAtRTaiU0k7bFA3hqqXQksBNZr
HAmNjZHXY8ngIOBVSYNwFvRe40agOfFuUgGj/tsyknLiGj6Z4noHKnHJcCGE2vDh
bhwFSwPexIhi8SAVZMfwjKiQuhtoUrm9CjC0YFpzLCi7jzfb2fz3pltGprPSiy0V
Cmr2bHVnlWNbhRx8Yen5
=h74U
-----END PGP SIGNATURE-----

--3lcZGd9BuhuYXNfi--
