Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1481835061.3477.5.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Thu, 15 Dec 2016 15:51:01 -0500
In-Reply-To: <20161215175439.GA1172@kroah.com>
References: <20161214185000.GA3930@kroah.com>
	 <20161214185052.GC4939@kroah.com>
	 <20161214202952.GV1555@brightrain.aerifal.cx>
	 <20161214205444.GA16183@kroah.com> <20161215175439.GA1172@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-mEQrlQ4srrBPrUpywrwF"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] [PATCH 3/4] Make static usermode helper
 binaries constant
To: kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


--=-mEQrlQ4srrBPrUpywrwF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> To follow up on this, and after staring at too many outputs of the
> compiler, I think what this really should be is:
> 	static char const critical_overtemp_path[] =3D
> "/sbin/critical_overtemp";
> right?
>=20
> That way both the variable, and the data, end up in read-only memory
> from what I can tell.
>=20
> But, if I do:
> 	static char const char critical_overtemp_path[] =3D
> "/sbin/critical_overtemp";
> then sparse complains to me about:
> 	warning: duplicate const
>=20
> Is that just sparse being dense, or is the latter one really better
> here?=C2=A0=C2=A0It seems that both of the above put the data and variabl=
e into
> the same segment (.rodata).
>=20
> thanks,
>=20
> greg k-h

Either 'char *const foo =3D "bar"' or 'const char *const foo =3D "bar" will
also be a string constant in rodata with a pointer in rodata referring
to them. Duplicate string constants get merged without any analysis as
there's no guarantee of a unique address for the data itself since it's
not a variable. 'const char foo[] =3D "bar"' goes into rodata too, but is
the toolchain can't assume it can't safely merge strings + sizeof works
but gcc/clang know how to optimize constant strlen anyway.

The 'const' qualifier for pointers doesn't really do anything, it's when
it's used on the variable (after the pointer) that it can do more than
acting as a programming guide.
--=-mEQrlQ4srrBPrUpywrwF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQJKBAABCAA0FiEEZe7+AiEI4rcIy/z3+ecS5Zr18ioFAlhTAjUWHGRhbmllbG1p
Y2F5QGdtYWlsLmNvbQAKCRD55xLlmvXyKl0+D/wIbVLko+yLxrpRROVSRzk5AqX8
5qd/DAPFtc46FiTKRPycFgVrGZxfJ8tkFN6jv84nssYuFEYADVkeq+85N5gT6UT/
9rQMWYploSyUykHku+o9jA1OF9RaGRL1ppORaIoC6GvvPHH9cUgdhenL+BTQqDnI
87t1JafMF1zuxN5V2oXfZLyHnU3yikPLvr/+7Mr7FEWZ9L7enNXinA9tmORnyMiH
kJgBkiGtBYijBn3qZtA3CfWrs7jhOt78b37Oq3Yr+bdIijm2nI8yxSMvleJfJKXf
GSjTCLBFhDjo/ZqSftJltj7KTQxLjt/kHBynrP0b0G46Lba2hTPtlRtJBDZpiKPp
RhMaB4LNwF53ufOrHmbhPuvRj1aKVpCjIoLVbxeperySF792/IjsF5aXN4CO28+h
2oNVry9Pj/kpXyEPVIxAvB9Os3fb0nfEjDx3K6vkdHII73V7yMJQ62wd8euWXY1h
WgtFs3E9XEspPprjDoirqVLB/SXKag7WPfMW4H2hQvkP3No8BA6A3Lh/JJVsHwC1
RkQOJNWbgUbrOkEV37zMXcxwlfjpQMiBVKsnrg5GJ4HO4oArjp4rzBQWuad5PBpB
myQBgtXDaRaZAL4oQOVt1eF47G8grAc1sowtbGqUAwt8c1qXVM8HsTU+SoKy4uxm
Cxgr0OJwP04H+/NNNA==
=LJf+
-----END PGP SIGNATURE-----

--=-mEQrlQ4srrBPrUpywrwF--
