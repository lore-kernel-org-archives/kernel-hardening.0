From: valdis.kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1500952905_2037P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 24 Jul 2017 23:21:46 -0400
Message-ID: <91431.1500952906@turing-police.cc.vt.edu>
Subject: [kernel-hardening] Issue with CONFIG_GCC_PLUGIN_RANDSTRUCT=y and out of tree modules..
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

--==_Exmh_1500952905_2037P
Content-Type: text/plain; charset=us-ascii

I discovered the hard way that changing that config variable from n to y
and then doing a 'make' of an out of tree module resulted in it not working.

Once I did a 'make clean', the next 'make' resulted in a working module.
So I'm guessing that the kernel dependencies were too subtle for
the 'make' to notice that the structures had changed logically, if not
source code wise.  Probably not fixable, but could probably use
a line or two in the Kconfig help for the item.

I'll code a patch if that seems like a good idea...

--==_Exmh_1500952905_2037P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Comment: Exmh version 2.8.0 04/21/2017

iQEVAwUBWXa5SY0DS38y7CIcAQJtDwgAjji1Kwo7/g7plleSkIE/wUN+yijEHO55
HFoYbuAgAPOalv5XEGFKXVqlFPn45ojGpapZU0gbAmksTv253mQ44riQW2iV920B
vHcLBSPG31J86gQTIpclAftPeakwHbqRSiFBeS2+6YBvI2NaHkOouyFKePyI/lQj
SosQOTsuiqN1wnf/ogcVdgpV4I6NVKDbslVMJihkiF+ZZ41XaAd2WJ5QP+oV0s1G
Tp9uc2iPLDG5eCY6KSW7Q5kxv37zUrD1SLhOmTXEmhwhSANYHGnYKYKdHt2DVR6f
mwzTTWds+KJRDhbzXtXfXTnSnazcQIwwSE6e3gpL68H7Q79JhMUGug==
=/ajn
-----END PGP SIGNATURE-----

--==_Exmh_1500952905_2037P--
