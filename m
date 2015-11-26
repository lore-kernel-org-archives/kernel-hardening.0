Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1448526423.9722.15.camel@debian.org>
From: Yves-Alexis Perez <corsac@debian.org>
Date: Thu, 26 Nov 2015 09:27:03 +0100
In-Reply-To: <CAJpd-bFvTNQK=qGCPdnB1ec=yJ+jZuzaoR9pNbn01pgim=0aLg@mail.gmail.com>
References: 
	<CAJpd-bFvTNQK=qGCPdnB1ec=yJ+jZuzaoR9pNbn01pgim=0aLg@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-+rY7+Yq9A7PGyJjZ4dYX"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] On techniques for preventing commit_creds()
 user-space abuse
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--=-+rY7+Yq9A7PGyJjZ4dYX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On jeu., 2015-11-26 at 00:14 +0100, Salva Peir=C3=B3 wrote:
> Given the typical path for kernel exploitation is the
> `commit_creds(prepare_kernel_cred(0))` being called from user space as
> detailed in [References].
> Why is not a check placed in commit_creds() that checks the return addres=
s
> of the call to ensure the call is a legit one coming from kernel space?.

I have the feeling that commit_creds(prepare_creds(0)) is just a quick way =
for
white hats / good guys to demonstrate a vulnerability by showing an exploit
leading to privilege escalation (or rooting Android devices).

As already said elsewere, we don't have much data on the exploitation
techniques used by real bad guys, but I somehow assume that if you have rin=
g 0
access, the first things you do is disable existing protections and insert
kernel code in order to have free hands on userspace.

Regards,
--=20
Yves-Alexis


--=-+rY7+Yq9A7PGyJjZ4dYX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJWVsJXAAoJEG3bU/KmdcCljHoH/RjFS13u2zawUvG6alLLJpnX
FqCmV4qD4cEjpEdVni1WupAMT2O9HauZEyKJtAOpCXpLSvJI0tgUaBmAUY/XGKSd
in8H2l+B+mfWoPb2b0Ququw9Xi9xhrRfz6fbSGKBBk1azddnJ5fQGW7BVRTS9eXB
G6ZW+xAkIB/VaU/1nI1EEguOnyoMVEkDR4CtqO1qQ4IciJN2XlCVA5T6A2MxI9RK
udwe/GCiiZkvmKPMB37meMnCQOA9wkJvv88f9JJ727SdrN9+w9MApnXKyfwu0hLX
6Cpa6prM77pra1eu3agseQ/TWMBBxIEPK3L0n9ONQ65ddxpdPWV9I0hJkOsyLwo=
=y2mK
-----END PGP SIGNATURE-----

--=-+rY7+Yq9A7PGyJjZ4dYX--
