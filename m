Reply-To: kernel-hardening@lists.openwall.com
From: Valdis.Kletnieks@vt.edu
In-Reply-To: <877fc69cnn.fsf@d080-201.cis.zmaw.de>
References: <27907.1469706366@turing-police.cc.vt.edu>
 <877fc69cnn.fsf@d080-201.cis.zmaw.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1469712083_4839P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 28 Jul 2016 09:21:23 -0400
Message-ID: <35991.1469712083@turing-police.cc.vt.edu>
Subject: [kernel-hardening] Re: linux-next - modprobe causes BUG: sleeping function called from invalid context at mm/slab.h:393
To: Nicolai Stange <nicstange@gmail.com>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

--==_Exmh_1469712083_4839P
Content-Type: text/plain; charset=us-ascii

On Thu, 28 Jul 2016 14:21:00 +0200, Nicolai Stange said:
> Hi Valdis,
>
> Valdis Kletnieks <Valdis.Kletnieks@vt.edu> writes:
>
> > This ring any bells for anybody?

> Please see the thread rooted at
> http://lkml.kernel.org/r/87d1lyiygu.fsf@gmail.com
>
> Herbert Xu has provided a fix for this already (which works for me).

Obviously Nicolai is running one step ahead of me all this week. :)

--==_Exmh_1469712083_4839P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBV5oG0wdmEQWDXROgAQK6LA//TiOCyx6GE+1Sz5I17qM9ysBSdHTBlHe0
gbzRNOHWIeCZnOFBCLaudFPqFFFeKm3rHZyVYnFJ0fC8hK6abwQxZGgpyGHHPnys
RfNmgECzsfmnfYth8MYpJI8Z1d5iyzobESF2qktylONQ6E3d83WMuxj1QUPpBx/h
id+/NU44IKMXfqEmgHjFnGqUwGpCJn5M4lIxdizFShICvESvkZJjE0O46ngI+eHq
BmbXxWUzovE0j0sGjZhii2q4bAsbQyY+B941yYTNlS92CQ/v+d2hGPAVmiGtCcLv
LPQOnooMA47LSpvWV/fhEGwsczR3ZlYFaHfSzA1M+i4R4SnmKuAi1qOXdGCWrxbS
Zy/S9AH27GNbISVKiP4BtzUrctM3GX4rZXOoCM5cvdODpQf05oHGs92IL/Jvk4gS
pSYEYgTn+cWbmUAp5+CSUCnVY3k+OVmj20VEmfoG0Y/m431WTnbfFvn+w9U4DBFi
ijgS0gVZ8cBGTUrOnx5s3WpCSR5GJTt1gXb/XJeRUD66ixQIkteyT1naELE7k6Np
L9Y5J4/dF8h2FMS5YO46nI9R4d0BzY1jhWN4PoVDxURMLAbhhNNK8O4KD21ZnPCA
xB4wSuzDPe2iPtdxvUNW6/5g9ySP+rdSmCOnxV42gIgh0x2yXRrIH9rv+HMI0reT
Lc3L6yw6Z+8=
=tP5D
-----END PGP SIGNATURE-----

--==_Exmh_1469712083_4839P--
