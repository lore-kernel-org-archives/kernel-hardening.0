Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 29 Jul 2016 20:15:26 +0200
From: Jann Horn <jann@thejh.net>
Message-ID: <20160729181526.GE11621@pc.thejh.net>
References: <1469777680-3687-1-git-send-email-elena.reshetova@intel.com>
 <1469777680-3687-4-git-send-email-elena.reshetova@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HeFlAV5LIbMFYYuh"
Content-Disposition: inline
In-Reply-To: <1469777680-3687-4-git-send-email-elena.reshetova@intel.com>
Subject: Re: [kernel-hardening] [RFC] [PATCH 3/5] sb_unsharefs LSM hook
To: kernel-hardening@lists.openwall.com
Cc: linux-security-module@vger.kernel.org, keescook@chromium.org, spender@grsecurity.net, jmorris@namei.org, casey.schaufler@intel.com, michael.leibowitz@intel.com, william.c.roberts@intel.com, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>


--HeFlAV5LIbMFYYuh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 29, 2016 at 10:34:38AM +0300, Elena Reshetova wrote:
> This adds a new security_sb_unsharefs() LSM hook.
> It can be used by LSMs concerned about unsharefs()
> system call.
>=20
> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> ---
[...]
> @@ -132,11 +133,15 @@ int unshare_fs_struct(void)
>  {
>  	struct fs_struct *fs =3D current->fs;
>  	struct fs_struct *new_fs =3D copy_fs_struct(fs);
> -	int kill;
> +	int kill, retval;
> =20
>  	if (!new_fs)
>  		return -ENOMEM;
> =20
> +	retval =3D security_sb_unsharefs(&new_fs->root);
> +	if (retval)
> +		return retval;

Oh, and this is a memory leak. If copy_fs_struct() succeeds but
security_sb_unsharefs() fails, new_fs isn't deallocated.

--HeFlAV5LIbMFYYuh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXm50+AAoJED4KNFJOeCOoIRcQAKofIZBjYEV3AHEYZ35+XBf2
rms0ZfopHP9CggjgjcnVZNGFPSo/CNXVhIgOj63O7mAbnaXCDSCsxRHCopbOFv+j
XUyzqZ8KBJdG9bzlPb/5FfTU+EYbWJwNMArlGFw/b+PddxNgxDkf5NhhLSg1aKXc
CVrefJWNn6CiIGhPjzIRCL5ioEmCt8vf/mNIZJwG42vB916iKqH/wtdjgBfrFQWV
FOyBbMzdFZIepidHlMkJZsY05icR+dIx9ftKfPYXUHV3qbbxh/zmDNwd5CXFwdng
zpx6PN9IsF0fCqdA0H9MY+brFkGSMRL9sq6z3bpZCFi0Lh0gXhkjrjNLRcU3AARW
duCtJmN1M+KgUytokkG84pn6K90pipYT+6Aoj9rqa6d+0wPuPNShvOr16wr2aJtx
AQFzPMFk76SGmjjCRvu83M78Ki0Gp/s+zMSyMsz0brg58BA1x4sMPU4/Onf9d4Y2
/SQdcT8yIJqJBoob2LMHyT684x5gA/bGqWKGQMieuqT542yJJX8QzrQDmiIV2Qjg
nggJl2d47n5M43i7gzLrzEjFUkz3Vx4gKyvp9somu8kZj7GY9Z7ZhQRnKDwU8cAd
dManLeRrK+ffRl2rvzYdCs2ARuWheeeDRxnIfeY5ZRenaad2FYc+BwJKYcWaMFqs
fbNs35jTMnLVliLO2hRv
=9Nv3
-----END PGP SIGNATURE-----

--HeFlAV5LIbMFYYuh--
