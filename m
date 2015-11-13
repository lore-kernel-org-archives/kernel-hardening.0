Reply-To: kernel-hardening@lists.openwall.com
From: Valdis.Kletnieks@vt.edu
In-Reply-To: <CAHfkTQF33M8eqAPUr3wTDe-yB4k_MLSfMtAfPWW=AhA9aQdtmQ@mail.gmail.com>
References: <CAHfkTQF33M8eqAPUr3wTDe-yB4k_MLSfMtAfPWW=AhA9aQdtmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1447453432_2416P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 13 Nov 2015 17:23:52 -0500
Message-ID: <9860.1447453432@turing-police.cc.vt.edu>
Subject: Re: [kernel-hardening]
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

--==_Exmh_1447453432_2416P
Content-Type: text/plain; charset=us-ascii

On Fri, 13 Nov 2015 10:43:23 -0500, west suhanic said:
> I am a hardened gentoo user. How can we get the grsecurity code into the
> kernel?

How do you eat an elephant?  One bite at a time. :)

Seriously - some of the grsecurity code will never get into the kernel, because
there's just too wide a philosophy gap.  The rest will have to go into the
kernel the same way any other very large thing does - one set of patches per
stand-alone feature.

That does mean we'll need to tease out each piece separately, and get it
into a format that has a good shot at getting into Linus's tree.

--==_Exmh_1447453432_2416P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBVkZi+AdmEQWDXROgAQLtwg/9FdTuzHD9Eugd71zkh3E5+fBJzvheUBKb
mBTPc0okC6aAyxxmQvwHxewezzi7ETFR2n1DnVQvYS/rofXei3mrr0A5IXes68el
xUjciNbGrpPpwHay3wfqjCSG81MKxeKQJRPFwo11Tzg3SrBrAz0mEBkTC0aezD1A
ZvA2ZN0OUQLlIv75eAh1Sy/e2anESco/ns+pYW3/uoFdh7OSQLUX4n/B35d6nm9U
5E5vbVqOkb9WKmVafinAXEvf2m3AU9l10TVuZOeLurrAbKPsMa6Q1vFUBH4kqVzu
xV4nwNOpGiW+dFU+kWR49Oip/nDJ3yFJhS8eKfCCMIKVdrEojUg9ob6aTE3+CyYT
yVrfZzCcoI52ffLa8dYSWJebFwKvw3ixRv5T+Hdei4mvLngDdq1y+SkJ1aErNeoh
aiwgkN09R1e+pMPy76sc2zeoG1D+2LggdiQFRNTVDwJ3KDBCKi/1TO71zgLnxNzl
7FUIwjJhcdM+72C0RoN8pRc1OdDhi2LXFsDm/yxLm5JKUuiW3U3CjLxVqwB/XmzQ
riyMvhTmPQMbN5OSGQ8FnB/fZvdjLQj8Ta7tR8ri/tyMJK+1WH7J0bDCDb4ah8/H
nduJrnJGT3MXL4UP0aEw6dy0w5Dj75YMgjMY4Lyik4BMVgrAYX1vbezHuFEXmGPq
drAMpiYnO5A=
=lLoV
-----END PGP SIGNATURE-----

--==_Exmh_1447453432_2416P--
