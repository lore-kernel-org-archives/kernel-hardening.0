Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 29 Jul 2016 19:58:19 +0200
From: Jann Horn <jann@thejh.net>
Message-ID: <20160729175819.GA11621@pc.thejh.net>
References: <1469777680-3687-1-git-send-email-elena.reshetova@intel.com>
 <1469777680-3687-3-git-send-email-elena.reshetova@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
In-Reply-To: <1469777680-3687-3-git-send-email-elena.reshetova@intel.com>
Subject: Re: [kernel-hardening] [RFC] [PATCH 2/5] task_unshare LSM hook
To: kernel-hardening@lists.openwall.com
Cc: linux-security-module@vger.kernel.org, keescook@chromium.org, spender@grsecurity.net, jmorris@namei.org, casey.schaufler@intel.com, michael.leibowitz@intel.com, william.c.roberts@intel.com, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 29, 2016 at 10:34:37AM +0300, Elena Reshetova wrote:
> This adds a new security_task_unshare() LSM hook.
> It can be used by LSMs concerned about unshare
> system call.
>=20
> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> ---
[...]
> @@ -2052,6 +2052,11 @@ SYSCALL_DEFINE1(unshare, unsigned long, unshare_fl=
ags)
>  	if (err)
>  		goto bad_unshare_cleanup_cred;
> =20
> +	err =3D security_task_unshare(unshare_flags, new_fs, new_fd,
> +			new_cred, new_nsproxy);
> +	if (err)
> +		goto bad_unshare_cleanup_cred;
> +
>  	if (new_fs || new_fd || do_sysvsem || new_cred || new_nsproxy) {
>  		if (do_sysvsem) {
>  			/*

Why would you have an LSM hook just for the unshare() syscall given
that clone() exposes nearly the same functionality?

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXm5k7AAoJED4KNFJOeCOo/jkP/iJf8diM73DK5/3d0G7uuW5q
des/ZvKy1uZjd/sOKCmlwzAILK9Eo1RvJEOSjx8EzmoY30G8xD5IHw1xxC7V1+C8
hTA6zqygNH/byp6ZHBHpKMqlk14QO9QgxJdkb1+jAxyl1kPLZj875bMVbMcZ/dVY
8QWN1immSARWl9h/KfUNup+OztT3auMwrq8Cx7ZfGgoym6iJuRFkG2BNKVm2ZeMG
ufvVsjoHRdJCdqL4bMvU19NbhGHsZ6uf48BZzd7vWl0nL16+XwmHXn3bciRXyiOU
SVSemyqY9AMsFhwT2UTXhQP+BM/Mt759+vcs+dbYZeLZxQR3Onvu6+ScCcVNIvZ/
E8PyQ6Fs8wMkCV60Su9Ji7hxpqdkC4CBGYRor2IAX4nl0ecgNYGqUI7vyCk+7xuk
GijoJ/3sfGW8OXQfUDNVEW7hYj2VUuzDohMhFLxrs5qt2eRd0E/kQtXhvlAwn5Wm
xz1O1+ZlskTzspcQYP5ErIJ9UE2RKr0NK2KqJon4J2kj+lJRzUCvwPA6my91AzZG
m3d/HrOyeUQgEPxZESqCwECKoIZnTKDEXYgUB1+U9uBhzlzlprP307Yh7c6qBQwX
XRikqPC1Y/lwKSLbsnIFqMmg+Nwr+qXdXQe/WU1TJZERWOPk6TlNaw9ZvSOhZvMr
m7OBcmo9r5GT5Uqyg+TJ
=U8EX
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
