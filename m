Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 3 Oct 2016 23:57:40 +0200
From: Jann Horn <jann@thejh.net>
Message-ID: <20161003215739.GO14666@pc.thejh.net>
References: <1475476886-26232-1-git-send-email-elena.reshetova@intel.com>
 <1475476886-26232-6-git-send-email-elena.reshetova@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Jl+DbTnyraiZ/loT"
Content-Disposition: inline
In-Reply-To: <1475476886-26232-6-git-send-email-elena.reshetova@intel.com>
Subject: Re: [kernel-hardening] [RFC PATCH 05/13] fs: identify wrapping
 atomic usage
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, David Windsor <dwindsor@gmail.com>, Hans Liljestrand <ishkamiel@gmail.com>, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>


--Jl+DbTnyraiZ/loT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 03, 2016 at 09:41:18AM +0300, Elena Reshetova wrote:
> From: David Windsor <dwindsor@gmail.com>
>=20
> In some cases atomic is not used for reference
> counting and therefore should be allowed to overflow.
> Identify such cases and make a switch to non-hardened
> atomic version.

Depending on what the overhead ends up being, it might make sense to opt
f_count in struct file out of the protection. It is the hottest user of
atomic_t/atomic_long_t that I know of (incremented and decremented for
every operation on a file descriptor in a multithreaded process), it is
64 bits wide and it's only incremented and decremented in steps of 1.

--Jl+DbTnyraiZ/loT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX8tRTAAoJED4KNFJOeCOor1MQALWtmHBfTV1OyicF+Ek+UCvy
ogz0Is88Qg2+8EC2PVYU8mkaa3UEGEIu5z64oamR6s/WFmuFERQxA6gOTWiv/62X
EocAXQ6P3B1R7mThJME8mRd+uhDUawfTmMYo3zAWXeRyIH1p/XwJz8huhW39/wMA
9eRHFP18peOO6jrHwQQM+x0f87pF+TMFdsL8YjtT4DCLR6x8Fn2vsTb8HAIwTt0L
CdNvnx9FE1lIsuHMLamdFzdh2ZYBqDVYIfVuPpaMvC9uLTbEVIHTuefg8w8W/Q1X
0D8RHMafzfu+/cTNOZWQ3n8g8Y7tBVUsLq3amarD9ZseUz8zdai91Ztn0mIsAL/8
Cd3K5hcmAY3xeIQOOib+nCdYlJZybhJtx+NVlLeXFzH0vspKgmh+wYwHxvyU1wDf
J17Bl9N2rT3F4jknKDY41rfohlXmUe7iFSIpoXy/NVgDQ2C97BDTdN/25eTsO7gM
MkOW0QFc8fMtGTErYi2K1fu5sr0VT4HQLNalQrmNPD2TzqtcIcd49ucnroaFgsk/
JiyZvuwLgZuAYZgfzmBc3/AmX1Zko/9aXzE1nt6Agn5g1iP6aSmp6MxyaDOQO8Xx
6e6d03r4UG0CQZEE2qKmJJop+KbaHyjv62FWHUFJigA3Zi2njR/zARCPHU3h+Y9E
BbOLLkCcWjMw8KkZ2ywR
=8h8F
-----END PGP SIGNATURE-----

--Jl+DbTnyraiZ/loT--
