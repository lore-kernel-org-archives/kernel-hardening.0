Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sun, 5 Jun 2011 23:53:43 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110605195343.GA6608@albatros>
References: <20110603191153.GB514@openwall.com>
 <20110604054758.GA4063@albatros>
 <20110604132054.GC2583@openwall.com>
 <20110604200948.GA5850@shinshilla>
 <20110604205955.GA5972@openwall.com>
 <20110605191747.GA6174@albatros>
 <20110605194052.GA9370@openwall.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <20110605194052.GA9370@openwall.com>
Subject: Re: [kernel-hardening] procfs mount options
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Solar,

On Sun, Jun 05, 2011 at 23:40 +0400, Solar Designer wrote:
> Since recent versions of OpenVZ build upon the namespaces code that has
> been upstream'ed, I guess this will rely on upstream's namespaces code
> (once we move to RHEL6'ish OpenVZ kernels and beyond), correct?

Namespaces - yes.  But AFAIK, only a pair of sysctls is accessible in
containers, IIRC, only net sysctls.

> Now, leaving sysctl's aside and speaking of mount options only for now,
> what happens when a container mounts /proc with umask=3D007, but then
> another container mounts /proc without that option or with umask=3D0?
> Does the first container retain its restricted perms, including for
> newly appearing entries under its /proc?  If so, where is this different
> setting stored?  Is it per mount (preferable)?  Is it per pid namespace
> (OK)?

It is per-pid_namespace, it should be fully consistent with OpenVZ.

Thanks,

--=20
Vasiliy

--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJN697HAAoJEBoUx9gkVaZciOcP/j/L7K3LiD7cmEH6jnBoEHYU
REHRU8cC/Mrns8gmnX3EXBE3aScc6yStMflIwCYJSw30S8lWJjWnsl8+21VQGOPP
+Z0hD7sYU46MNMLdrVCXRooLLezokDKnXMiqd4g8wI2QW7puQUIp3Xjj+gXRCR+L
kP2cUg79BYhuQSJeN4Nd1odNfIZ7Ak5y070so01skNvo4RfQRhdJx/fYXKQr9QSG
91ul0lBxQPO/jWrzyZsyMA14vogA8RzZ/Njv2o2bCXE7siQUKgo8hH0YC9uu014/
FCYY9iK4gTPLWlaGnXKt6oZDl+ddOi80/YiPxkI7QulRcNBEP1FYvR5szlLz67EY
VxlP0aXnKDD/1s6sjAzRawP6ZsFlGMcYfRYS5ZK/88HMfCGG1qmkr4h0YZx3bxw5
oubXyq99EbUlwJG4Ivnktv/6aD/qqa8ZfFJ+z8HM/SvrvXJeJpfyBCSfGZGaWvBo
RxZNfbHM7XyT7MJeF7BXWz8vcKty9Hnem4kruM0dHnF6KCKcvFPeBi55zkwMW3S0
+tqMji8BZI9i9Dh29eCyTP4CFBLNxoV8rfKESszfxqy2meXdyXEN8orfhCZ3hjUG
dx+woYqBGt+nKL9jLyhx37YcrhnNFiQOd5n7ojmxiz5KY5oVSRXakOrAvZ+bT2mW
7wYU3UxFc8MviPNnIzM5
=ZZuI
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
