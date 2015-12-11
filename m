Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1449861423.8579.33.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Fri, 11 Dec 2015 14:17:03 -0500
In-Reply-To: <CAGXu5j+Q3pKN7G9OgCop-DPbq6vjTOL-PoVHTP0tSwxdyjGiJw@mail.gmail.com>
References: 
	<99FC4B6EFCEFD44486C35F4C281DC6731F1DFFDA@ORSMSX107.amr.corp.intel.com>
	 <CAGXu5j+Q3pKN7G9OgCop-DPbq6vjTOL-PoVHTP0tSwxdyjGiJw@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-4wCQLQUy5UEDqgW3F9HV"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Project convention on configuration options
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--=-4wCQLQUy5UEDqgW3F9HV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> I think there will be plenty of bike-shedding, so pick whatever you
> like for now. :)
>=20
> There is already the (disabled due to gcc bugs)
> DEBUG_STRICT_USER_COPY_CHECKS (which should lose the "DEBUG" name
> too). IIRC, it works by tracking memory regions? Maybe TRACK_USERCOPY?
> I'm sure it'll get renamed, so no big deal. In fact, you could just
> leave it as PAX_USERCOPY too for the initial extraction.

The main component is dynamically querying the slab allocator for the
allocation sizes. It also has checking for stack frames and global data.
There are also some tweaks related to __builtin_object_size.

It would make sense to land it in pieces, perhaps starting with the slab
allocator stuff (which is the bulk of the changes since some slabs need
to be marked and it seems like it would be the least controversial part
of the feature).
--=-4wCQLQUy5UEDqgW3F9HV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJWayEvAAoJEPnnEuWa9fIqinIP/RbuRA5oXjVxabTzOU7q8GFJ
CkHMf7FtOoQ1sdc1ZNHKQ3Giv09HgMxRN715HDSXSXB5s9MDmhtnIp0FhH9T/Km6
AreOT4rJ13brzMaOmisGAzSRn/i+UQ0o085qec9A5hDgdbZHg6VgMvKDQCgws/p3
H8VPNfOerg6bREMYOBhWEgF8JDB76n/x7+o+hw5t1Y4Cl6bJnafK6jYNwEZfKqY8
ud9XZsBQLZt10EKcUcXfYZUJnfu1ekdebs+R2ozWNWClEYYd4OIewxIYuDnd4EP+
dTfZJ6zgtZJJGwhVb8+jN/BkB1UtvpjkZMTB/GnUjvs00dQ6FUZlHJ5jVqNjaptk
Z9SiG4SA94tpyAdvjrWVAnjloq2xK6T7slQQQd7cPgUZTirHPJhpGgSZCBkyEWYB
fGyj5g/Ry54q6tYf1Ey6UYasTAcwCg/E9+0A88k3cuD6CsgGz7j114uFpQk2u97u
7GPkYEP57lBMHXETd7FW/x8hFDJMrnujN7M7/tko36z4VbJo3S7taFehV2asWjDa
RZ78euWUSD4cQCiDmymDZ6EbS4F0njQg2c8QOvd/pMQ6eQubyfeYpLVLve3PGct1
64YRw0SlEUuLP0KNxqfKmK5HcR/7GzlQw5QHVPbvICZLQpXu7PnZDzaPywo93pEk
6VjGhQ9bQgqFGquBacbe
=25Oz
-----END PGP SIGNATURE-----

--=-4wCQLQUy5UEDqgW3F9HV--
