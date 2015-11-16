Reply-To: kernel-hardening@lists.openwall.com
References: <CAHfkTQF33M8eqAPUr3wTDe-yB4k_MLSfMtAfPWW=AhA9aQdtmQ@mail.gmail.com>
 <CAFLxGvxukmvg9jHWXO=-Bbn3eoNrqwFvWsS-v_R99McPU4n_sg@mail.gmail.com>
 <56496AB0.5070905@gmail.com> <56496D65.8030903@gmail.com>
 <CAEXv5_g-VJJweZKNuw5ozMfiVxMrfhw4biEkSu4A29-uuEmD6A@mail.gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Message-ID: <564A529A.2040005@gmail.com>
Date: Mon, 16 Nov 2015 17:03:06 -0500
MIME-Version: 1.0
In-Reply-To: <CAEXv5_g-VJJweZKNuw5ozMfiVxMrfhw4biEkSu4A29-uuEmD6A@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rpgsN4aMkkfXMxWvQ2iB7LP4OVC9ODsLu"
Subject: Re: [kernel-hardening]
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rpgsN4aMkkfXMxWvQ2iB7LP4OVC9ODsLu
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 16/11/15 01:38 AM, David Windsor wrote:
> I'm currently in the process of preparing my earlier PAX_REFCOUNT patch=

> set for resubmission, and I tend to agree with you - I'm not very
> hopeful of Linus, et al accepting them.  But, we will try again.
>=20
> With respect to the issue of having a refcount_t type, PAX_REFCOUNT add=
s
> overflow protection to the already existing atomic_t type, and creates =
a
> new type, atomic_unchecked_t, for non-reference-counter types (i.e.
> statistical counters).

Yeah, I'm aware it does it that way. The problem is that it would have
to be done the other way around for it to land upstream (realistically).

Doing it the only way around would be involve too many changes so it
wouldn't be feasible to land everything, but the positive side of it is
that the changes could be landed bit by bit (i.e. one set of refcount
fields at a time).


--rpgsN4aMkkfXMxWvQ2iB7LP4OVC9ODsLu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWSlKjAAoJEPnnEuWa9fIq0IkP/jDq6hh7YV0Y6Q2faN6c6mUb
mKYUuQPyC53d31pdVVRUaXnpiki6TI6BeqQcW0RakDxiDZ+aE1+vYkBcYpX3tUd6
6UXzCuh1DCcir+A5mTlR7uKlddljUkDKIB9irVoM8bEnWkCnEJsaEhLdOVg7BiAu
ayvNELfrZnexUbBP1jnS7PpG/hHSdxodH3UvZyUAIuoenl8n7RuxXSKZwKqaYiIN
0dc+y45S/0ALtyqBxa7/4uHjRGAhO9N7YZNAttbEvQLRduLhve2pAZ3ICQBfY2PH
quvKYAkv8RWqRwIDNIOAdYeM5B6ZQ4P3vg5qqZBWTjKsmZZJyHXS6+ozog3GsZUn
oe6TzQblAV5UsLCUbZzKriI4CNlnNycHHXl/EhKqK9g6D6fBoGoVM9V5B8egylRm
kDO+xCtxk6XmEYhw6o+jl48EFUiipuKziQckV4w5ev5OF70vxQTsVumLekCM92jc
NjaWKV0Kgf1rGhA8WkMvuHEZJoqDbQ/WBJ6VWDQjQWKB7rTd4E6dcjbdBLg89rxI
cJmrlUYvAiAcOke6j3p6DqMrwmqfEVS0KFR0h/Xr3vPE9dqLNUkUe6QLy9QpzsG1
xXYaaQncSJJd3R9Q6F8YFvmnYmyv0RVPb5NTUUS+R/gDr0A2k5vTQi5kq1bAyu/r
0CJXH37VWCRfQ0y079DY
=CEj2
-----END PGP SIGNATURE-----

--rpgsN4aMkkfXMxWvQ2iB7LP4OVC9ODsLu--
