Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 18 Oct 2016 15:13:00 +0200
From: Jann Horn <jann@thejh.net>
Message-ID: <20161018131300.GM14666@pc.thejh.net>
References: <58061416.7020209@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mlxBsilMljZ1v4XL"
Content-Disposition: inline
In-Reply-To: <58061416.7020209@oracle.com>
Subject: Re: [kernel-hardening] Use-after-free and management of reference
 counts
To: Vaishali Thakkar <vaishali.thakkar@oracle.com>
Cc: kernel-hardening@lists.openwall.com, Julia Lawall <julia.lawall@lip6.fr>
List-ID: <kernel-hardening.lists.openwall.com>


--mlxBsilMljZ1v4XL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 18, 2016 at 05:52:46PM +0530, Vaishali Thakkar wrote:
> Hi,
>=20
> Recently I studied the reported CVEs of last 2 years and there were
> fair number of use-after-free bugs. Usually we also see many reports
> of use-after-free bugs in the LKML [reported by one or other tools].
>=20
> Also, at Kernel recipes Jonathan Corbet  mentioned reference counts as
> a security issue. I believe if we have more kernel hardening patches
> then we can avoid such bugs. I was wondering if there is some ongoing
> work in the both [use-after-free and management of reference counts]
> of these areas?

Use-after-frees are really hard to deal with. I think I saw some patch
semi-recently for randomizing kernel allocations, to make it harder to
exploit memory safety bugs, but actually fixing use-after-free is a
really hard problem.

For reference counting, refcount overdecrements are pretty much as
hard to deal with as UAFs, but for refcount overincrements, you can
take a look at Elena Reshetova's refcount hardening patch series (see
http://www.openwall.com/lists/kernel-hardening/2016/10/10/1).

--mlxBsilMljZ1v4XL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYBh/cAAoJED4KNFJOeCOoJE8P/ieziTPjFg+snTRPxhChgAj5
vxiEanOEEz/gwROKW04IDGYLVvh69JR37EN/DnQ8YcwOmFwu0OvyQnTCL9J8YGfL
LkegUsHFSfV89IaB2RXm4WGs6feBJLlwlcIJcXQO+rLYOeIYgxnt5D3qUkRfyn2h
/yiiXRblWbP14lWd+b5TPIEcGQLVeMRNJ8akz6y/rhXNEVsumsl/y9KhwtT1+VQX
B4HHN3fdyUSk2ma2q464itusLShHw5osf9uEeAeVRnOMCYhm7Izcd4rg7uTz+v9R
gdIg56ZpsH4icB1QldnCXp5CtF67QG86TXPXzKEQZHIcNVoHUXcFFElJ8LgsRqu7
n8oJYIHpV6OYrg6JPlQA0bCwoMFDy6fcv8W3ERimQ4wqa+dwYXguNmeLysJRLmdP
SuezsEokyW53GWaCNrQRi2FB3UTWF+Vztb91kKhFpNx7YC/0eepd81gFxtDEYBYF
d1BHNM8+8hjZfzcaxgDpJWNsqpZmZ+geIf9XSOw49HydsgG0eJCyW4j8mDidAMk7
ozsG9+D+inW+Zy2v3OyrhoIJQb2DHF7TAWe0LrBhLUDK/JP/JMN68rh+IF69YnKl
r9A2bKZOyQ/M0DoZqpm1WLZhF0q/oaSvzmi9dyx93sMd+1F+A+LmAG/iXytP4Tm7
I/JtQBfjQmT8wOGrjzlX
=N0u1
-----END PGP SIGNATURE-----

--mlxBsilMljZ1v4XL--
