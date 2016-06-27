Reply-To: kernel-hardening@lists.openwall.com
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1466998197_2120P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 26 Jun 2016 23:29:57 -0400
Message-ID: <57138.1466998197@turing-police.cc.vt.edu>
Subject: [kernel-hardening] Usercopy caught another one - ping IPv6...
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

--==_Exmh_1466998197_2120P
Content-Type: text/plain; charset=us-ascii

usercopy kills attempts to use ping....

(Kernel tainted by a probably unrelated MMC issue)

[135768.173443] usercopy: kernel memory overwrite attempt detected to ffff8800be26fd90 (RAWv6) (32 bytes)
[135768.173451] CPU: 3 PID: 56577 Comm: ping Tainted: G      D    OE   4.7.0-rc3-next-20160614-dirty #302
[135768.173453] Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A17 08/19/2015
[135768.173455]  0000000000000000 000000004951b1ca ffff880223687e10 ffffffffb169f61a
[135768.173459]  ffff8800be26fd90 000000004951b1ca 0000000000000020 0000000000000000
[135768.173463]  ffff880223687e60 ffffffffb1367b30 0000000000000001 ffffea0002998868
[135768.173467] Call Trace:
[135768.173473]  [<ffffffffb169f61a>] dump_stack+0x7b/0xd1
[135768.173476]  [<ffffffffb1367b30>] __check_object_size+0x70/0x3d4
[135768.173479]  [<ffffffffb1ded6bb>] compat_rawv6_setsockopt.part.11+0x4b/0x80
[135768.173482]  [<ffffffffb1ded824>] rawv6_setsockopt+0x84/0xb0
[135768.173485]  [<ffffffffb15c66c5>] ? selinux_socket_setsockopt+0x45/0x60
[135768.173488]  [<ffffffffb1bd1d0a>] sock_common_setsockopt+0x3a/0xc0
[135768.173490]  [<ffffffffb1bcfb99>] SyS_setsockopt+0x89/0x120
[135768.173493]  [<ffffffffb20896e5>] entry_SYSCALL_64_fastpath+0x18/0xa8
[135768.173497]  [<ffffffffb1143e3f>] ? trace_hardirqs_off_caller+0x1f/0xf0


--==_Exmh_1466998197_2120P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBV3CdtAdmEQWDXROgAQLxHw//TMcGf1Bg/rMOJRvj77Pjrr+lK3hnpK8X
9JwE2hd+afCERSLd/1nt1Tw/+xTU2pjYhyXjYKWI6ItkKbuVdMTheH5Fb8LZgsdd
tBYYMI3ILf1mzZSuXpA8pTsadZhC/CuGKuYx2mAZ8+HFNeedWw6i46BkA4UT51H4
28ZLaISc0SDAojvCi2M7aoJ2ytbXJTeRjTAdfe/8AtLOKB86YB2yAVBlGcRyPyqb
fuRF72rSk2fKkwisJ2NuC8cMQmMUTJYVKvjFgUW6WxpGpbI6AK3bmwohxrMKoCGH
XJAFWYNfmSU2jk92AmTDK8deZsCb9xo1IoGFqwSrjUw/HEhHjSHWBdo9lEEI5lpO
kZ5ihmhIjU7wUxKgWgJec6jINewb26M/ye9UJEM3Vt98jXYkj7FTNXw+aWuFFyDW
WXEaI8Bl4Q2t1MoegT9saNfa1qXn6nucZO036F1uB0FooIV5MErWra0qeqM9UCsS
KQAA6g3WPUW9nARLsN8n1lkRYh6IXqALn3PIU11ju8xPGXXhb8BwQfzp4fFjF9RN
93WB/AlO99+cx0J/VpZjykEjwJHCa6H2ZnAnKEQA7OPG41OWSfIthIzu2r1gNWeJ
AafVhyVyeeISqt4MOWhGM+UfGVz/5IUnMu/d+veuEMJyJZGSXHSnPOpRTg7Sc6ao
Xg3pwww5RFY=
=mgPy
-----END PGP SIGNATURE-----

--==_Exmh_1466998197_2120P--
