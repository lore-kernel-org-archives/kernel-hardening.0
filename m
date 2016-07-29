Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 29 Jul 2016 20:12:13 +0200
From: Jann Horn <jann@thejh.net>
Message-ID: <20160729181213.GD11621@pc.thejh.net>
References: <1469777680-3687-1-git-send-email-elena.reshetova@intel.com>
 <1469777680-3687-2-git-send-email-elena.reshetova@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4zI0WCX1RcnW9Hbu"
Content-Disposition: inline
In-Reply-To: <1469777680-3687-2-git-send-email-elena.reshetova@intel.com>
Subject: Re: [kernel-hardening] [RFC] [PATCH 1/5] path_fchdir and
 path_fhandle LSM hooks
To: kernel-hardening@lists.openwall.com
Cc: linux-security-module@vger.kernel.org, keescook@chromium.org, spender@grsecurity.net, jmorris@namei.org, casey.schaufler@intel.com, michael.leibowitz@intel.com, william.c.roberts@intel.com, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>


--4zI0WCX1RcnW9Hbu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 29, 2016 at 10:34:36AM +0300, Elena Reshetova wrote:
> This introduces two new LSM hooks operating on paths.
>=20
>   - security_path_fchdir() checks for permission on
>     changing working directory. It can be used by
>     LSMs concerned on fchdir system call

I don't think security_path_fchdir() is a good abstraction
level. It neither covers the whole case of "cwd is changed" nor does
it cover the whole case of "someone uses a file descriptor to a
directory to look up stuff outside that directory".

For example, security_path_fchdir() seems to be intended to prevent
the use of a leaked file descriptor to the outside world for accessing
other files in the outside world. But this is trivially bypassed by
first using openat() directly instead of fchdir()+open() (something
that used to work against grsecurity, but was fixed quite a while
ago).

--4zI0WCX1RcnW9Hbu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXm5x9AAoJED4KNFJOeCOou+gP/11s+oLq0A65yAgmAXrCnE7L
MO8kar1ZApfTRAEN8k0xLHylCbaLglGhDFR3OYPwgLqsqHtuvaO8dUggF0My6ljb
QD8jylY5g1KpZvMtGzgzZsya7UL1CapxDM15e+plpJ2oyLb8KmCXoIaI/8hI7cxc
hU+Z9tXBO81Q1CTosghlSDeZg6BxKEd0mTjIEhuRIn5RINROWFCLYzaP8gucsXQk
PkO3sMwJeXQFPpSWPXn/y29nvC/YxGUtJ2/Pbh2hGD7gpnFhlVDcTKGO4beIPmnY
R5U93gR+aJYNRGgf7nE0tFHm4H56+o4EAFfErO4qoY70PqEv7DQ+0NGkaYb1lXWW
zlLwSRnZmsvsk9nARLuZOkEocrBcZsYe+HGjyJ2QwmPhrIpo0p8skqXCtBv//S/f
+R5pkSitqlQeVvRP9KlzaxxUzkCAfYJHXY4rcN3FykfSQnaXsVnDPIA8C6u3MNtv
X9aOtBKQ2ssGtqhVRxr0SCAcpxokHHA57uOHHB4yqNH8ufDxa7yRtQVx3kwZKm5o
835+FzeWd+3bWPYPbRkGEZOt7lYSUQ/4f+if8z0ezEwS0mdeqmUA3kHMee6F72kY
Jf3yxLLWpGW1G0ZdzcN3Ifr8B1qUFy8nVk0LzYjfpzKpLHaengZzlXUQFXp3Cfms
iHSWfhw7W34iwoZje4zS
=S/A4
-----END PGP SIGNATURE-----

--4zI0WCX1RcnW9Hbu--
