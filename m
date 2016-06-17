Reply-To: kernel-hardening@lists.openwall.com
From: Valdis.Kletnieks@vt.edu
In-Reply-To: <16741.1466120212@turing-police.cc.vt.edu>
References: <1465420302-23754-1-git-send-email-keescook@chromium.org> <9020.1466040627@turing-police.cc.vt.edu> <CAGXu5jKcLHy3t0C7RyX8xXYowhYuh0rO+WPxWQFKuSn9LN6sjA@mail.gmail.com>
 <16741.1466120212@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1466127526_2103P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 16 Jun 2016 21:38:46 -0400
Message-ID: <3694.1466127526@turing-police.cc.vt.edu>
Subject: Re: [kernel-hardening] [RFC][PATCH v2 0/4] mm: Hardened usercopy
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey.schaufler@intel.com>, Rik van Riel <riel@redhat.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

--==_Exmh_1466127526_2103P
Content-Type: text/plain; charset=us-ascii

On Thu, 16 Jun 2016 19:36:52 -0400, Valdis.Kletnieks@vt.edu said:

> stuff is working.  I may whomp on it with trinity for a while, see if
> anything falls out...

Woo hoo! Bagged one! :)  (Haven't figured out yet if actual bug, or missing
annotation)

[ 4033.178386] NET: Registered protocol family 21
[ 4033.226806] NET: Registered protocol family 38
[ 4033.256276] Guest personality initialized and is inactive
[ 4033.256797] VMCI host device registered (name=vmci, major=10, minor=53)
[ 4033.256801] Initialized host personality
[ 4033.266376] NET: Registered protocol family 40
[ 4033.365982] NET: Registered protocol family 24
[ 4033.413031] irda_setsockopt: not allowed to set MAXSDUSIZE for this socket type!
[ 4033.531569] sock: process `trinity-main' is using obsolete setsockopt SO_BSDCOMPAT
[ 4033.834839] irda_setsockopt: not allowed to set MAXSDUSIZE for this socket type!
[ 4034.444515] irda_setsockopt: not allowed to set MAXSDUSIZE for this socket type!
[ 4034.569913] sctp: [Deprecated]: trinity-main (pid 19154) Use of int in max_burst socket option deprecated.
[ 4034.569913] Use struct sctp_assoc_value instead
[ 4034.728723] usercopy: kernel memory overwrite attempt detected to ffff8801ecef4700 (SCTP) (4 bytes)
[ 4034.728730] CPU: 3 PID: 19154 Comm: trinity-main Tainted: G           OE   4.7.0-rc3-next-20160614-dirty #302
[ 4034.728732] Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A17 08/19/2015
[ 4034.728734]  0000000000000000 0000000063913a95 ffff8801f8b33da8 ffffffffb269f61a
[ 4034.728740]  ffff8801ecef4700 0000000063913a95 0000000000000004 0000000000000000
[ 4034.728744]  ffff8801f8b33df8 ffffffffb2367b30 0000000000000004 ffffea0006bd4580
[ 4034.728748] Call Trace:
[ 4034.728754]  [<ffffffffb269f61a>] dump_stack+0x7b/0xd1
[ 4034.728758]  [<ffffffffb2367b30>] __check_object_size+0x70/0x3d4
[ 4034.728761]  [<ffffffffb2eae5e4>] sctp_setsockopt.part.9+0x684/0x1e70
[ 4034.728764]  [<ffffffffb236f002>] ? __vfs_write+0x22/0x2e0
[ 4034.728767]  [<ffffffffb2eafe3e>] sctp_setsockopt+0x6e/0xe0
[ 4034.728770]  [<ffffffffb2bd1d0a>] sock_common_setsockopt+0x3a/0xc0
[ 4034.728772]  [<ffffffffb2bcfb99>] SyS_setsockopt+0x89/0x120
[ 4034.728775]  [<ffffffffb30896e5>] entry_SYSCALL_64_fastpath+0x18/0xa8
[ 4034.728779]  [<ffffffffb2143e3f>] ? trace_hardirqs_off_caller+0x1f/0xf0

Do we have a good place to collect these, or should I just post them here
as I find stuff?


--==_Exmh_1466127526_2103P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBV2NUpgdmEQWDXROgAQIJ4xAAuiYh9L8ncb9uyujvi0Stbd5WzuaH/lz0
O1x6xH/RZoAt88gD6fwqq7oqvZMvxV1ko2S0BkCPPp903pvkgXUHGFyhVCcdBrsm
KLxBa4/F6vyRHH897yYuMm9m19V0A7Fg2jc8Zo8Qg0P7/C4CcQucjUg08HfAsk8k
05/V0D49Oq93AVREcyIwAjKm1oIT73nqJA1Ct6tvBozPBQJw2YK4OhgtqgMQBdgA
1ajqR58Jq4dpzP1uarLiTA1YsVhSg3FpNw2Te47ALmC3fn1x7ZbqpXl0UECwz1Nf
Bd57WAXB9CLJVIyo8HjwfQKazrezQdWUQLMC4WtteuoUhQJc7qDGEE+yBTU3K6H8
I3yuOBCIOxq0zLCmK0cPrH04s56ikbMOxmr1HuJ14VzhUjMPa/rAaTk/C2No5r5F
iwQc0+BJ0ySYnkO94wlBkxAvgFxiWrMTubo8Y7GHPBVvrsUqw8oilwcmMwjVEae7
Rl5kFnjiGUX4OyE44ZVzvs1UbpvbxMcg10Iuo8tUgfRU+2QPXaBEP3aV4VB35L8+
9yFKkzvscmSLYAFO1NSHg22hCBnv3eJKF9efm+FHXBdBpWeJNJvptDfpsvXOGgWL
IGxxWYINuglVb+johmYa6EdNBxCZSnQFweW9NLSFrlUvnL0Le1EaxU66UODY6nWS
ivt8LUQ8eKU=
=K4C8
-----END PGP SIGNATURE-----

--==_Exmh_1466127526_2103P--
