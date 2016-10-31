Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1477914064.3558.4.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Mon, 31 Oct 2016 07:41:04 -0400
In-Reply-To: <20161031112236.GA6816@openwall.com>
References: <14b76703-8185-dadb-7605-10496331452c@redhat.com>
	 <20161031112236.GA6816@openwall.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-EUowmpRhJLqBcpEapgT/"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Re: Stack guard canary massaging
To: kernel-hardening@lists.openwall.com, oss-security@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--=-EUowmpRhJLqBcpEapgT/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2016-10-31 at 12:22 +0100, Solar Designer wrote:
> On Mon, Oct 31, 2016 at 11:48:45AM +0100, Florian Weimer wrote:
> > Sorry for cross-posting.
>=20
> Sorry to bikeshed, but I think this isn't a kernel-hardening topic at
> all, so the thread should continue on oss-security only, please.
>=20
> Florian, if there's a reason why you think it's kernel-hardening
> related, please let me know.=C2=A0=C2=A0To me, it looks like userspace ha=
rdening
> that is not even kernel-assisted (at least not directly in this place,
> even though the kernel may have helped provide the random numbers).
>=20
> If your cross-posting was to reach more of the right people, then you
> have already done so, and they can join oss-security now. ;-)
>=20
> Alexander

The kernel supports SSP but it doesn't appear to do the same thing.

arch/*/include/asm/stackprotector.h

Why do the non-x86 implementations XOR in LINUX_VERSION_CODE though? Is
it supposed to be a placeholder for a random at compile-time value? :\

It's not harmful but that's just... weird.
--=-EUowmpRhJLqBcpEapgT/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIyBAABCAAdBQJYFy3QFhxkYW5pZWxtaWNheUBnbWFpbC5jb20ACgkQ+ecS5Zr1
8iowhA/1FImN3knrfXylVbN4UblnozoTF3gzNo7zvOLdvF72jQ+0vJS5qvrnYxPX
/JsV9/PM64+V13QmsQblMRc7csMs9hlNhJqsTYJZvsJEmt+ldC5y8OXhlr72Vwr5
rBD7WQoAUS1liywq7KAdOdb09i2a2ft/JlzNcJ4ibSWuypraoBhQa5/icsFlUi2k
/8E9gmuuyPw/NbVPSaR2JIqhA/WACUB3hfvZh5JK0nkVKhxTAbeGydHC1OH15nqa
tqImcH+vAZINNAt4YGaPEpOmj01osnvCGQ4jwM9G24FvuI5i4lTwkX5ROcL2cO2f
NxWFrRibxkeqoS8Iv5nG3t70p3rbblnbzlOdXq53W8ONpNR3YVMOGBub5QC7IMX6
hp8aNrCURXHvdqXLxn/ONNG070vL3iBaoL4lwdxPu3wOIUcfTywbPPe1IHmpfN3f
nii+V2us++PLkvCxOPEwMk/yqnsbwur8xT0rpq+XMqHhkI0dToZ9g9Nld3T9TK31
tVT3l9lVmyLigp/7Lbj4xVRA+CUP1I9k4oPXUDotUlorxQWiaIt+sJHt1x9h2lVM
tUjIACcKmtefSY7gofFM20RfWxIPWq1BC6Yz1ZVG/WTvZvY6HtUKP6CyOGJL5K59
lyD6ol0LbvAiDli7c6wTv7GhWQMKu4rat0NVBPQo/O34KcURzg==
=vSEU
-----END PGP SIGNATURE-----

--=-EUowmpRhJLqBcpEapgT/--
