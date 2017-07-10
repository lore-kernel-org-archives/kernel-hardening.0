References: <1497286620-15027-1-git-send-email-s.mesoraca16@gmail.com>
 <53a2d710-b0f0-cdf9-e7ad-cd8d03fc835a@digikod.net>
 <CAJHCu1+=uYQ-N7CH4KfmTHrN2hJjwzN0tgg4sWHU0LjVr+uGGA@mail.gmail.com>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <c19917fa-f62c-b7e0-8cbd-f10a96f686ba@digikod.net>
Date: Tue, 11 Jul 2017 01:40:22 +0200
MIME-Version: 1.0
In-Reply-To: <CAJHCu1+=uYQ-N7CH4KfmTHrN2hJjwzN0tgg4sWHU0LjVr+uGGA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="8OANMwvrIeUbH3Vgkqa51jBmiP6HdHxMi"
Subject: Re: [kernel-hardening] [PATCH 00/11] S.A.R.A. a new stacked LSM
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey@schaufler-ca.com>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, Matt Brown <matt@nmatt.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8OANMwvrIeUbH3Vgkqa51jBmiP6HdHxMi
Content-Type: multipart/mixed; boundary="678tlcFEikQ7jSL0LxgwUhenfWDHVeWes";
 protected-headers="v1"
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
 linux-security-module <linux-security-module@vger.kernel.org>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>,
 Casey Schaufler <casey@schaufler-ca.com>, Kees Cook <keescook@chromium.org>,
 James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn"
 <serge@hallyn.com>, Matt Brown <matt@nmatt.com>,
 Mimi Zohar <zohar@linux.vnet.ibm.com>
Message-ID: <c19917fa-f62c-b7e0-8cbd-f10a96f686ba@digikod.net>
Subject: Re: [kernel-hardening] [PATCH 00/11] S.A.R.A. a new stacked LSM
References: <1497286620-15027-1-git-send-email-s.mesoraca16@gmail.com>
 <53a2d710-b0f0-cdf9-e7ad-cd8d03fc835a@digikod.net>
 <CAJHCu1+=uYQ-N7CH4KfmTHrN2hJjwzN0tgg4sWHU0LjVr+uGGA@mail.gmail.com>
In-Reply-To: <CAJHCu1+=uYQ-N7CH4KfmTHrN2hJjwzN0tgg4sWHU0LjVr+uGGA@mail.gmail.com>

--678tlcFEikQ7jSL0LxgwUhenfWDHVeWes
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


On 10/07/2017 09:59, Salvatore Mesoraca wrote:
> 2017-07-09 21:35 GMT+02:00 Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>:
>> Hi,
>>
>> I think it make sense to merge the W^X features with the TPE/shebang L=
SM
>> [1].
>>
>> Regards,
>>  Micka=C3=ABl
>>
>> [1]
>> https://lkml.kernel.org/r/d9aca46b-97c6-4faf-b559-484feb4aa640@digikod=
=2Enet
>=20
> Hi,
> Can you elaborate why it would be an advantage to have those features m=
erged?
> They seem quite unrelated.
> Also, they work in rather different ways in respect to how they are con=
figured.
> I'm not sure what would be a reasonable way to merge them.
> Thank you for your comment,
>=20
> Salvatore
>=20

The aim of the Trusted Path Execution is to constraint calls to execve
(e.g. forbid an user to execute his own binaries, i.e. apply a W^X
security policy). This should handle binaries and could handle scripts
too [1]. However, there is always a way for a process to mmap/mprotect
arbitrary data and make it executable, be it intentional or not. PaX and
the W^X part of your LSM can handle this, or make exceptions by marking
a file with dedicated xattr values. This kind of exception fit well with
TPE to get a more hardened executable security policy (e.g. forbid an
user to execute his own binaries or to mmap arbitrary executable code).
Moreover, TPE could handle some part of its configuration from some
xattr values (e.g. allow scripts/interpreters, a whitelist of
environment variables, additional memory restrictions=E2=80=A6) as you do=
 with
SARA thanks to your tools.

 Micka=C3=ABl

[1]
https://lkml.kernel.org/r/25278a42-736e-0d3b-8c0a-7b2b05ed7d28@digikod.ne=
t


--678tlcFEikQ7jSL0LxgwUhenfWDHVeWes--

--8OANMwvrIeUbH3Vgkqa51jBmiP6HdHxMi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEUysCyY8er9Axt7hqIt7+33O9apUFAllkEGsACgkQIt7+33O9
apUlBQgAilQeKDaeGcd/ZnroGMQdgZpsCqvBnO61t4BVRxDk+KFQke9zURjGJHnN
xhgT8d0kE3eNp8bogseovJxVYHiIzd5QcwZZXGdXs3c5FI4qyrL/DpEt/gbirfbl
eeEGfVYXtMKwFKAi82u6k2ERUvTT/wXNLXcY+YSWkHFXsKe+FKCLRhXCUWNTVxRh
aCPeUI2j/W+2VeFGAQNqTKDGXCouquy1VDSyjtL8wYR1lG7JdHNHn6Ej856dNMSK
zlvkm2MyHkVTOi4y0TOGtSoOv8u0VJCTjfXAmsCvYZOzasIHNOSqwQsVdAm/3eb2
8yNw1sDJe41iZ/sXK/9dFfFFp9FGQw==
=kTh0
-----END PGP SIGNATURE-----

--8OANMwvrIeUbH3Vgkqa51jBmiP6HdHxMi--
