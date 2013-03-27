Reply-To: kernel-hardening@lists.openwall.com
From: Tim Brown <tmb@65535.com>
Date: Wed, 27 Mar 2013 19:58:38 +0000
References: <51534E5C.8070303@linux.vnet.ibm.com>
In-Reply-To: <51534E5C.8070303@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1614790.7YYJlI9aPr";
  protocol="application/pgp-signature";
  micalg=pgp-sha256
Content-Transfer-Encoding: 7bit
Message-Id: <201303271958.46601.tmb@65535.com>
Subject: Re: [kernel-hardening] Security vulnerability tools
To: kernel-hardening@lists.openwall.com
Cc: Corey Bryant <coreyb@linux.vnet.ibm.com>, oss-security@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

--nextPart1614790.7YYJlI9aPr
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wednesday 27 Mar 2013 19:54:04 Corey Bryant wrote:
> Hi,
>=20
> I'd like to get a better understanding of tools used in the open source
> community (kernel and user space) to detect security vulnerabilities.
>=20
> I have a list below to get started.  If anyone has any input, I'd
> appreciate it!
>=20
> I'll plan on updating http://oss-security.openwall.org/wiki/tools with
> anything it doesn't already have.
>=20

Hey Corey,

One you might want to add is unix-privesc-check from myself, @inquisb and=20
@pentestmonkey.  There are two versions in existence:

1.x - @pentestmonkey's quick and dirty with some hacks by me
trunk - a full blown privesc check framework designed by me with contributi=
ons=20
from the other two, it has multiple modes of operation, a standard library=
=20
which can be leveraged for new checks and (already) enhanced capabilities. =
 =20
Its not perfect yet, I still need to clean it up and port it to the commerc=
ial=20
UNIX platforms we support but it should give a good idea of where we're goi=
ng

Once I've stabilised the API of trunk, it will become 2.x and we'll open it=
 up=20
formerly for contributions.

It's on Google Code if people want to take a look:

* http://code.google.com/p/unix-privesc-check

Tim
=2D-=20
Tim Brown
<mailto:tmb@65535.com>

--nextPart1614790.7YYJlI9aPr
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCAAGBQJRU09vAAoJEPJhpTVyySo7XkAP/jFKxPCfLPUazrDGzxYaHHe3
2PybLUfL+cPHEpvpuoYJ/Ga4pfSdOtA010VwrSGW68j9DtJ/H6JZ03zAtryoieVr
lhJBcyyqa/j+bjoD++IsSQ7SFU8tQSciazpdO/MHXUDiBGGM2FKrmC+a9CVmEMUq
ODtz1kVVyMrYLha8Qbv5Wz4qJDfpeqeN2/5Aw1+6dtRvb4+pn2CKuE4IKo4f+hCY
qHxshQgvX+uCoFamPRkLE5coVp2zqhWhPz4X46N4QMXRTypYP2aY6P6dxvYsw9cg
CDerr2tGIxC95z2l8hsnY2sV5BMn87uZxLbU/9YTW1jeCEqBL9XtX6q6tzMLl//t
v1L3t3n3ZAVPhGVLA+CcSk+1SpExXBzsZOJawdm42WGiyFVhcwYuPIAvtD+EklU2
a9/2H1K3j0SJOrkkjdL6rzWmwdOOvM8ZLm7OYOM5IjTiUp5hTGB5hyh70QQfjEN6
f5uhNWF8CJg7hvUOC2KYMsUhG12bxQTcv3v152z+Mz2HLyGz231DngBCX5nXCHHU
VzsBJCn2EtsCuM1OJmN+Lr4NhsKm77St2zIsIQAEZNBwAQTbJSTvQ/3NEiB07bbs
qYIC70saQdrIszKloEc0cuzZlGVp96PRqr0QXrPVNOKA+f43PjFp9CAphk7lA1cN
p38wt7fc+L+rOaj80Ddh
=NP8c
-----END PGP SIGNATURE-----

--nextPart1614790.7YYJlI9aPr--
