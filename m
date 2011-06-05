Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sun, 5 Jun 2011 23:17:47 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110605191747.GA6174@albatros>
References: <20110603191153.GB514@openwall.com>
 <20110604054758.GA4063@albatros>
 <20110604132054.GC2583@openwall.com>
 <20110604200948.GA5850@shinshilla>
 <20110604205955.GA5972@openwall.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
In-Reply-To: <20110604205955.GA5972@openwall.com>
Subject: Re: [kernel-hardening] procfs mount options
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Solar,

On Sun, Jun 05, 2011 at 00:59 +0400, Solar Designer wrote:
> > > This is not generic, but at least it's simple, not
> > > confusing, and it allows for future changes (we may change what exact=
ly
> > > restricted means).
> >=20
> > Changing what some option means after implementing it is a ABI breakage,
> > which is terrible for upstream.
>=20
> This depends on how the option is defined initially.  It is possible to
> define the option as "enabling unspecified version-dependent restrictions,
> which are subject to change across kernel versions and builds". ;-)  OK,
> the word "unspecified" may be dropped.

Everything that is implemented should behave the same way it was
initially implemented, regardless of what is explicitly marked as "ABI".
This is upsteam's way to define "ABI" term.  Often they deliberately
break such ABI, but normally this is not encouraged.

> Here's a related thought: if these mount options happen to affect all
> instances of the filesystem (in the same container), maybe they should
> be sysctl's instead?

AFAIR, only net namespaces have their own sysctl sets.  Other sysctls
are global.  So, implementing pid_namespace-specific sysctl would be a
bit weird (according to current policies).

Thanks,

--=20
Vasiliy

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJN69ZXAAoJEBoUx9gkVaZcyIsP/0qH09KVZ+SaCy6w1exIP+h1
j7eP0U/WG0XvasKejTkVxajryelQCNUZ1b5CJunkyDLt/JCuaJ0eZo/3Oun8jHDM
SXkVyOw3vs6XqwU8QhxkAmRpDTUymZGhmZGAKZ0WjtazTPIPmbAoyr4UZk821F5g
Tpma7affKhdcjEUFKWZ+Cofh8ycnE7x4vdACsf0sT2y0SaSTg/oJl0Jw7B26AQBq
ID+PBxc+G1n16EQl6eeAZ4i9r+PKgxU7HzpT6tZGUn0kj2nBkAi0teUDRJD3G3sy
ivFu4nJ2quxT/HU18jtZBKcfRWpmqNgTXrcSb38P+O+Lz2nJlFRhWTqFDWHS4qux
xBUN++IHilIXzxbi9USCKWQ7Ej6QMnKKDW1aLz9fd1P9D44HbRi2QlmmVMUaFBXf
hG/1JRhuWy5sEC12hVk5hXm1yxtBiVbQOnHJhqi3HJYtmW00I5m9+jc6oNTzu0Nz
1LZlZY36klvdleOUcTEzIBXzvENP+vXzJN29+gLJ3SVlFI+1V2Sbcj3qFBkBDE+7
phMILX7m2Abw4EVYPhqW6IhF/OSSiMGBgdTiiyBuENkkrUQWaVptzW4JAVOTEAzh
tyj/jzhZy8AAR+M6/xdRGXqRp+UlXLnGzvCjKQSOQNLi6zhs56t7GrC7Wghiy6BD
sQbJ4meGAkFs/MAK8KVD
=RRgR
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
