Message-ID: <1506023948.5486.23.camel@redhat.com>
From: Rik van Riel <riel@redhat.com>
Date: Thu, 21 Sep 2017 15:59:08 -0400
In-Reply-To: <20170921185239.88398-2-ebiggers3@gmail.com>
References: <20170921185239.88398-1-ebiggers3@gmail.com>
	 <20170921185239.88398-2-ebiggers3@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-qfwXRB+99E8KK82ihYXp"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] [PATCH v3 1/3] x86/fpu: don't let userspace
 set bogus xcomp_bv
To: Eric Biggers <ebiggers3@gmail.com>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Dmitry Vyukov <dvyukov@google.com>, Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@kernel.org>, Kevin Hao <haokexin@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Wanpeng Li <wanpeng.li@hotmail.com>, Yu-cheng Yu <yu-cheng.yu@intel.com>, Michael Halcrow <mhalcrow@google.com>, Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


--=-qfwXRB+99E8KK82ihYXp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2017-09-21 at 11:52 -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
>=20
> Fix the bug by checking that the user-supplied value of xcomp_bv is 0
> in
> the uncompacted case, and returning an error otherwise.
>=20
Reviewed-by: Rik van Riel <riel@redhat.com>

--=20
All rights reversed
--=-qfwXRB+99E8KK82ihYXp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJZxBoNAAoJEM553pKExN6DsFsH/javwCGM5MIOAFRiFvR+kG92
8Z9bHHnDHpPfPTc/QBnYxuIlGLhtmW+lwCwss6X/ce9TZeJQJUjvkuqMcwou4rvE
v/U0U/zN7YUi2N0G3GCxjvQOr/BLHKgzTms6b9wvuPKoah96c1mra3nAMExGpAy8
G/mS26dLdy8v5RgF5dEoCth84vfbkaXaAJmiaUzc3It8PdXFc8wP8nYV0rgVr/e0
uMSZRBq4wyD3LBYpC+TkXJZ91W00R+M94Eo7oXiiinU/OD/HUaURZBxm7BrqSqVX
zf0BPBtBRZJLwqw1yKCYLlJfUt3GAP8+HhuSkKBHwd3N9dYdas4QXyRHXB439QQ=
=5ZfR
-----END PGP SIGNATURE-----

--=-qfwXRB+99E8KK82ihYXp--
