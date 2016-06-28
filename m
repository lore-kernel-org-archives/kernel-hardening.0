Reply-To: kernel-hardening@lists.openwall.com
From: Valdis.Kletnieks@vt.edu
In-Reply-To: <20160628131525.GB1255@suse.de>
References: <57138.1466998197@turing-police.cc.vt.edu>
 <20160628131525.GB1255@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1467131509_1978P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 28 Jun 2016 12:31:49 -0400
Message-ID: <17753.1467131509@turing-police.cc.vt.edu>
Subject: Re: [kernel-hardening] Usercopy caught another one - ping IPv6...
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

--==_Exmh_1467131509_1978P
Content-Type: text/plain; charset=us-ascii

On Tue, 28 Jun 2016 15:15:25 +0200, Marcus Meissner said:
> Hi,
>
> This is probably the ICMPV6_FILTER setting?
>
>                 if (optlen > sizeof(struct icmp6_filter))
> 		                        optlen = sizeof(struct icmp6_filter);
>                 if (copy_from_user(&raw6_sk(sk)->filter, optval, optlen))
> 		                        return -EFAULT;
>
> struct raw6_sock has
>         struct icmp6_filter     filter;
>
> not sure where the bug is.

Probably no actual bug, but the allocation of storage for 'filter' needs to be
annotated.  Thanks for finding that, that's the *hard* part.  I'll look at it
and see if a reasonable patch is doable...


--==_Exmh_1467131509_1978P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBV3KmdQdmEQWDXROgAQKMHw/+Ik6VMe/+DJP7VPAT8tW8Pdk+5Cxcxm6m
1qDxxiFvPrehPWbtCvzqWKWqMmQ49iny8Is9NF3F7nJYeBTUphoGH/D8+BJabn8i
BPkiJQVxBSNVRoqzn0933qDLzqCewcw9PVYq/BLu72U2inKCGF9oMbsukoD9hnR3
FznbpqZ1jToI/ZE1OVsS1hlRrybb5iVTJ4jZnnOOciXaanSxeS+zgeHDuRWuO3hx
fAW247xQRmz3+D4LNlV+8kHQXdh+3EMvG4jIxDzBzE+HLat3TYt+XVzPHrl8iSwD
WVluX3mrASuOE1KXaRPbUWzxPsLRtcxnqxi+9OoYK/0YdIsJCTXunkqKwCTQkhJS
F6iAJtCJopb+2ScND9kXPag0GBbNtyO+NhksicVL7cwIwj2GAYA/MyWVVVAVZxsp
LE8j1q0PHaOuTR8jbyZx9Fp+R4Am9e03xZfUDmMldhn+scddtjT34qz0K47kBVqS
iOrM6JGAJ5u8x1V+IkKvGSEktuKiNupBSej7tkFj0oysicAnHnhE366cH633752s
170HIyLKft3WOyU2lovnrjWycUteEOldfdt+f03p3H1Y6RR49K7IlsTogc9ehDg1
h97CtAWyTYGSUKq8tgJtltxLB4376OpLkkJQHnz2/ZnYHQ989aYqHYPbB17NEbK7
iZE8os+oE3o=
=DD/N
-----END PGP SIGNATURE-----

--==_Exmh_1467131509_1978P--
