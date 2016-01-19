Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 19 Jan 2016 12:49:17 +0100
From: Hanno =?UTF-8?B?QsO2Y2s=?= <hanno@hboeck.de>
Message-ID: <20160119124917.6058019b@pc1>
In-Reply-To: <20160119112812.GA10818@mwanda>
References: <20160119112812.GA10818@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512; protocol="application/pgp-signature"; boundary="=_zucker.schokokeks.org-31825-1453204118-0001-2"
Subject: Re: [kernel-hardening] 2015 kernel CVEs
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_zucker.schokokeks.org-31825-1453204118-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 19 Jan 2016 14:28:12 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> There was only a coupls CVEs that looks like they came from a
> filesystem fuzzer where you create a corrupt filesystems and then try
> use them.

I tried that, but it didn't lead to any results in the kernel [1].
What I did:
* Use filesystem checking tools (fsck) and fuzz them with afl
* Use the queue created by afl and try to mount these with a
  kasan-enabled kernel

My conclusion was that the filesystem code in the kernel is relatively
robust (at least robust enough for this trivial fuzzing).
But it led to a number of bugs discovered in filesystem fsck tools.

> There was only one that might have come from a USB fuzzer.
> We probably should be testing those things better.

This is surprising to me. There was a talk at black hat amsterdam in
2014 about a project trying to do exactly this. They sounded like they
have dozends of crashers that just need to be sorted and reported
upstream. Here's the code [2] and the talk [3].
Maybe this project has stalled and needs someone to look at it?

[1]
https://www.coreinfrastructure.org/sites/cii/files/pages/files/2015-09-fuzz=
ing-report.pdf
[2] https://github.com/schumilo/vUSBf
[3] https://www.youtube.com/watch?v=3DOAbzN8k6Am4


--=20
Hanno B=C3=B6ck
http://hboeck.de/

mail/jabber: hanno@hboeck.de
GPG: BBB51E42

--=_zucker.schokokeks.org-31825-1453204118-0001-2
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCgAGBQJWniK9AAoJEKWIAHK7tR5C7w8P/RActv9YXh1tSUSKDJoj4vcM
t51ybww+vRXST3GffgC+DVmWFkBockkfhbZSqUH6LzCyAMXKCf0rjwY23/Go/IzC
HfjM62JyCas7gR2MgROSYU3pr5dxBPDI5su08dLaXQqNJxpF6Mp1r0jqIUUKTc1C
bAmRMRWMn++c/q6MrcTPE3slOAga+BTZ/Hv3uCii/Kphid5cl4pn2yuH0nMn+uvD
tAK1LOooz1VNq170jChI2VI9Gh/YUPuP2X6cnWuun1B018FerwJLt5DN42IBNj0t
SaO8q4Kh/8FMK2IpV8Qn77+YrnonWrUcSoXsrItmNb7r9T84NfbZUjTM0EBry6gL
lXLasNlavDRwPwR+1H3NKv+4RmAXU6HsHrdisNGjqn7kcWPJE7NYl4tpWeQScHRy
K1kBYV2vZspgWIjd7yNLgNPPkAd7Ckyqwum9FxkgcXRsd/2czFR6NEqOvLNOnnzg
YT+GA4kVpSK6JANti8XnUrQQZ5zJWqNNbXaMigYIcKMilA+XiqWApwtxDtruEIHA
NXfrW7G1WAX0M+BXL4E8KO9j4P9ZRvv39ZlniXJRnY3zy7gz0vnux1os6s+4T1TN
ypWWVO/kJEtlEkK6JyAbxi/d5pkI+QgsrkVJKxNL6KIn01L/pR+Qr2egpeYcui7p
TF2C7dDpbJCMSV7LuGnc
=Qpop
-----END PGP SIGNATURE-----

--=_zucker.schokokeks.org-31825-1453204118-0001-2--
