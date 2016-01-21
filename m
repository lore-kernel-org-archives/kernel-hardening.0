Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1453380319.4133.8.camel@debian.org>
From: Yves-Alexis Perez <corsac@debian.org>
Date: Thu, 21 Jan 2016 13:45:19 +0100
In-Reply-To: <1453338072.4942.16.camel@gmail.com>
References: <1450364270-12687-1-git-send-email-dave@progbits.org>
	 <CAGXu5jJJ13z206L6R99MYmiUA7hVYUJC5UVS8h5Mg0sUDr60GQ@mail.gmail.com>
	 <CAGXu5jLsxwhrgyRfvYV79WJrrFr9tkXMe=7-qWBz6VWEsEA_5g@mail.gmail.com>
	 <1453323437.6344.32.camel@debian.org> <1453338072.4942.16.camel@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-krRap2hT5k/eMHXpRxDi"
Mime-Version: 1.0
Subject: Re: [kernel-hardening][RFC PATCH v2 00/12] Add PAX_REFCOUNT
 overflow protection
To: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
Cc: David Windsor <dave@progbits.org>
List-ID: <kernel-hardening.lists.openwall.com>


--=-krRap2hT5k/eMHXpRxDi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On mer., 2016-01-20 at 20:01 -0500, Daniel Micay wrote:
> It could do some fine-grained randomization. It does have a measurable
> performance cost since it makes allocations colder and there isn't much
> room for adding entropy but it does add up over time. Depending on the
> locking design it could also hurt there too.
>=20
> Take a look at OpenBSD malloc if you're interested in it. It has a few
> forms of randomization and they do add=20

I also checked in the PaX patch to see if there was something done to harde=
n
slab, and while it's not randomisation, there's some hardening done as part=
 of
PAX_USERCOPY (heap hardening for copy_{from,to}_user stuff).

The patch adds a GFP_USERCOPY/SLAB_USERCOPY flag for allocation, and then u=
se
it for =E2=80=9Ctagging=E2=80=9D allocations of pages which will end up in =
a
copy_{from,to}_user() call (as far as I can tell, it's a manual approach). =
The
tagged allocations are then using a separate slab cache from the kernel
itself, so it shouldn't be possible to exploit an UAF: the memory originati=
ng
from userland would not be dereferenced as a kernel allocation.

4.5 kernel will apparently include a SLAB_ACCOUNT flag which is use from
accounting. I wonder if it'd be possible to also use it to tag and isolate
memory allocated from different privilege levels.

Regards,
--=20
Yves-Alexis


--=-krRap2hT5k/eMHXpRxDi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJWoNLfAAoJEG3bU/KmdcClHYoH/07xOUTYamdNWQ8w4FUxCBTr
vJ3xthYkD9kolZEcxAStUuKOrciy9iGGLJ8IKeJ1jEd92oew7uvUHOTQIszjcn1H
RDsN4OVuWWD6vPUXsheQ11Xcq5JIgAXMYkPBXhvT2dUIHwzR8P9xZyyKgaFchahx
3b1qdACXGbbwZLxwXqzkYNVtWCrnv6ztIERfo+s6BUS7c+cfMGP8e/w1cjRj4Sp2
t9UVRPIMpEZUHmUzK5aoW0ZQanDCCHxTqPRonFqUtUSyntVNIoAKvTyDZ/5Vo/1Q
Xon1rc6Bi+jypPk8zH8f6U/DhylKiGJYzrtECKFecFPTGdU9vT3Uy1IleXxXLHE=
=wi2T
-----END PGP SIGNATURE-----

--=-krRap2hT5k/eMHXpRxDi--
