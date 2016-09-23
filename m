Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 23 Sep 2016 22:12:57 +0200
From: Jann Horn <jann@thejh.net>
Message-ID: <20160923201257.GA4763@pc.thejh.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
Subject: [kernel-hardening] CONFIG_HARDENED_USERCOPY incompatible with /proc/kcore
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, Valdis Kletnieks <valdis.kletnieks@vt.edu>, Michael Ellerman <mpe@ellerman.id.au>, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey.schaufler@intel.com>, Rik van Riel <riel@redhat.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On a relatively recent kernel, I ran "perf top", then tried to view
performance-annotated disassembly of a kernel function, and this happened:

[  990.083103] usercopy: kernel memory exposure attempt detected from fffff=
fffaf1e4a70 (<kernel text>) (1424 bytes)
[  990.083112] ------------[ cut here ]------------
[  990.083171] kernel BUG at mm/usercopy.c:75!
[  990.083200] invalid opcode: 0000 [#1] PREEMPT SMP
[  990.083240] Modules linked in:
[  990.083265] CPU: 3 PID: 4148 Comm: perf Not tainted 4.8.0-rc6jann-00222-=
gf4a7ce3 #144
[  990.083365] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M.=
/H81M-HDS, BIOS P1.60 12/06/2013
[  990.083397] task: ffff8e52e0fc48c0 task.stack: ffff8e528191c000
[  990.083417] RIP: 0010:[<ffffffffaf556bfc>]  [<ffffffffaf556bfc>] __check=
_object_size+0x7c/0x2ba
[  990.083452] RSP: 0018:ffff8e528191fd30  EFLAGS: 00010286
[  990.083471] RAX: 0000000000000064 RBX: ffffffffaf1e4a70 RCX: 00000000000=
00004
[  990.083506] RDX: 0000000000000000 RSI: ffff8e532f2cce88 RDI: ffff8e532f2=
cce88
[  990.083594] RBP: ffff8e528191fd70 R08: 0000000000000001 R09: 00000000000=
00000
[  990.083618] R10: 0000000000000001 R11: 0000000000000001 R12: ffffffffaf1=
e5000
[  990.083642] R13: 0000000000000001 R14: 0000000000000590 R15: ffffea000ab=
5f900
[  990.083666] FS:  00007fdda7e47700(0000) GS:ffff8e532f2c0000(0000) knlGS:=
0000000000000000
[  990.083705] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  990.083726] CR2: 00007fdda0006958 CR3: 00000003e2cf5000 CR4: 00000000001=
407e0
[  990.083751] Stack:
[  990.083762]  ffffffffaf1e4a70 ffffea000ab5f920 000000002bf10e26 00000000=
00000880
[  990.083799]  ffff8e528191ff18 00007fdda0005950 ffffffffaf1e4a70 00000000=
00000590
[  990.083833]  ffff8e528191fdd8 ffffffffaf697977 000000002bf10e26 00000000=
2bf10e26
[  990.083863] Call Trace:
[  990.083877]  [<ffffffffaf1e4a70>] ? ptrace_get_task_struct+0x150/0x150
[  990.083902]  [<ffffffffaf1e4a70>] ? ptrace_get_task_struct+0x150/0x150
[  990.083928]  [<ffffffffaf697977>] read_kcore+0x397/0x660
[  990.083966]  [<ffffffffaf6786b3>] proc_reg_read+0x83/0x190
[  990.084025]  [<ffffffffaf55fc49>] __vfs_read+0x69/0x4e0
[  990.084046]  [<ffffffffafade90a>] ? security_file_permission+0xca/0x150
[  990.084069]  [<ffffffffaf560d3a>] ? rw_verify_area+0x6a/0x230
[  990.084090]  [<ffffffffaf560fc2>] vfs_read+0xc2/0x290
[  990.084109]  [<ffffffffaf563de3>] SyS_read+0x53/0xc0
[  990.084129]  [<ffffffffb0fca9a9>] entry_SYSCALL_64_fastpath+0x1c/0xac
[  990.084150] Code: 74 85 3a b1 48 c7 c6 9d 78 36 b1 48 0f 45 d1 48 c7 c1 =
e1 e2 35 b1 48 c7 c7 60 40 36 b1 48 0f 44 f1 48 89 d9 31 c0 e8 fb 5c ec ff =
<0f> 0b 48 c7 c7 f0 a3 bd b1 e8 f6 ef 7a 00 48 8b 45 d0 65 48 33=20
[  990.084294] RIP  [<ffffffffaf556bfc>] __check_object_size+0x7c/0x2ba
[  990.084317]  RSP <ffff8e528191fd30>
[  990.092817] ---[ end trace 1d4ac38ee0788468 ]---

Basically, CONFIG_HARDENED_USERCOPY is incompatible with any feature that
intentionally exposes kernel memory to root - CONFIG_PROC_KCORE, CONFIG_DEV=
MEM,
and probably (didn't test it) also CONFIG_DEVKMEM.

I'm not entirely sure about what the best way to fix this would be - maybe
just prevent the simultaneous use of those config options?

--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX5YzJAAoJED4KNFJOeCOo29UQALiZEtVphbY+bHDeObnno2YO
+EFz5D7XlE+VIl6c2n0KuuVtxRZNTKpfAKbSDvzmc9oN5F5ov3kWHi5c7FmFGRDi
SmRrXokvt3nw2PiIVMPUpYSsl+IU4omMyngR/htJSw0YOYu7QLnEkwhSKKS/omz1
Pzv7uUrVe33jphBKA5e9P4Dr29RAojD0XBNQW4TGRdD/12TNbBNScR/fq4fMDYRd
gYLAILGCNEXP+TGHzKXl7Hpm7Q/7msxatQoq5uGm8DEDAUFV4Hhxav0v97QDzRVu
hWPhc+z4E/yXIlnE5sJIj1yQSC8/NjtpwcAwmcNP08tShQlOlSA81WKHYPSDxu/l
Nktv8SVY6b0doTjYJ1x+Uls3l3Frg5MsGB1Cx+YPoyDqg7O+zsru1CAw7I6BhEPH
NahB6Pm+UJ4B1WWPWDoyxIsHGwH1OglwwFMz+Bi2Mt9fyibBRsJGgLsj3I+02Mga
r+lvFfH8dcD4RScJa7inbcPRa2eh133Hqbj68uyvRNa61Yx5KEUfUQgNPvh91uZB
MztzJi6eAFpWOltHKajkt8yoUL+MbaFLgX5GnEH7jLyPimd1JGIWbtsMEoHkNioJ
FM6pLXYC+c5tQ5RKLm9l2IvSkTbNyxEZt/C/2wUZVhkVof/axTzBe5rVl/Aj2aBv
7R5wyTxfa+13e9tN5Zu+
=BXEb
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
