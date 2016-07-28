Reply-To: kernel-hardening@lists.openwall.com
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1469706366_4839P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 28 Jul 2016 07:46:06 -0400
Message-ID: <27907.1469706366@turing-police.cc.vt.edu>
Subject: [kernel-hardening] linux-next - modprobe causes BUG: sleeping function called from invalid context at mm/slab.h:393
To: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

--==_Exmh_1469706366_4839P
Content-Type: text/plain; charset=us-ascii

I've been seeing this several times per boot since next-20160708 or so,
finally had a chance to reproduce it on a linux-next that wasn't horribly
hand-hacked.

Not every modprobe, maybe 5-8 out of 40 modules usually loaded, with no
real rhyme/reason that I've spotted.

I keep having a nagging suspicion it's due to HARDENED_USERCOPY snagging itself
a GFP_ flag, and we forgot to update __GFP_BITS_SHIFT (though I'm unable to
find the line  #define ___GFP_USERCOPY            0x4000000u in next-20160727
that was in previous versions of the patch...  other than that, I have
no clue what's causing it...)

This ring any bells for anybody?

[   20.418310] BUG: sleeping function called from invalid context at mm/slab.h:393
[   20.420592] in_atomic(): 1, irqs_disabled(): 0, pid: 679, name: systemd-udevd
[   20.423143] no locks held by systemd-udevd/679.
[   20.423147] CPU: 3 PID: 679 Comm: systemd-udevd Not tainted 4.7.0-next-20160727-dirty #339
[   20.423149] Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A17 08/19/2015
[   20.423152]  0000000000000000 000000007e9484e4 ffff97a022bd78d8 ffffffff976f0c0a
[   20.423159]  ffffffff984cd7ff 000000007e9484e4 ffff97a01e72d300 ffff97a01e72d988
[   20.423166]  ffff97a022bd7910 ffffffff97105d06 ffff97a01e72d300 ffffffff984cd7ff
[   20.423172] Call Trace:
[   20.423180]  [<ffffffff976f0c0a>] dump_stack+0x7b/0xd1
[   20.423185]  [<ffffffff97105d06>] ___might_sleep+0x196/0x2f0
[   20.423190]  [<ffffffff97105ec5>] __might_sleep+0x65/0x1f0
[   20.423195]  [<ffffffff97377a4c>] kmem_cache_alloc_trace+0x2fc/0x4f0
[   20.423200]  [<ffffffff9771459b>] ? sg_miter_get_next_page+0x3b/0xe0
[   20.423204]  [<ffffffff97766b70>] mpi_alloc+0x20/0xa0
[   20.423208]  [<ffffffff977617cf>] mpi_read_raw_from_sgl+0x11f/0x4e0
[   20.423211]  [<ffffffff97377aad>] ? kmem_cache_alloc_trace+0x35d/0x4f0
[   20.423216]  [<ffffffff9764ecc8>] rsa_verify+0xc8/0x170
[   20.423220]  [<ffffffff97650a59>] pkcs1pad_verify+0x169/0x250
[   20.423225]  [<ffffffff97141952>] ? __init_waitqueue_head+0x52/0xa0
[   20.423230]  [<ffffffff97694fc1>] public_key_verify_signature+0x2c1/0x450
[   20.423236]  [<ffffffff9715791d>] ? trace_hardirqs_on+0xd/0x10
[   20.423240]  [<ffffffff97695176>] public_key_verify_signature_2+0x26/0x40
[   20.423244]  [<ffffffff976947bb>] verify_signature+0x4b/0x80
[   20.423248]  [<ffffffff97698f15>] pkcs7_validate_trust+0x2c5/0x3c0
[   20.423253]  [<ffffffff972bd1a5>] verify_pkcs7_signature+0x125/0x160
[   20.423257]  [<ffffffff9734de3b>] ? vmap_page_range_noflush+0x31b/0x4f0
[   20.423263]  [<ffffffff971cdc00>] mod_verify_sig+0x100/0x170
[   20.423267]  [<ffffffff971ca8d7>] load_module+0x177/0x22b0
[   20.423272]  [<ffffffff971ccb7d>] SYSC_init_module+0x16d/0x190
[   20.423277]  [<ffffffff971ccc9e>] SyS_init_module+0xe/0x10
[   20.423280]  [<ffffffff9700419f>] do_syscall_64+0x8f/0x240
[   20.423284]  [<ffffffff9810865a>] entry_SYSCALL64_slow_path+0x25/0x25


--==_Exmh_1469706366_4839P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBV5nwfgdmEQWDXROgAQIjGA/+JB9494fE9mFLF4mYdHVZxEZLw8XdToPH
RyF7DyfziDKXVCWCxkfGOHMa9YLUo/PykEUsshtK7KC0jjoa7d6+SJtgChSswFv2
ktgBgoG8l+L2Uli8RVZ7+iIjGbhURO4FNKnDFov/tEJxrw+I6+ZsRcHLAXkPlW5N
2vlKtlR/az8Knw8a/38P5ZydlXxjjLtjb6pmFAKKgltSh3cQT43K2GlUQKPcDYYC
K6D/8hnlDdevYB+HaeOFFz/2hMZE6pYow5iaBnQPi7jUHdyPtW+2rDrfAo6BDcxN
K8U3Gq1OAXPhexsHQ7h914L3A6k1ryjWVt/Q6K9NmDH/JCYZzJZkJYoviFfde3Fu
QOzlrUTUN4dqZaKbH+v38OLDUISbWCQ98qWK5lvGFEbIo88WsMpt2dv4gCL83Htu
eAt7+I0ZbOPlpgk4FUsZWZNW21TnmOflSJXyHbIUZ8n5T4IMgWRaQ727NMrFEM0C
LXBYUvSh5mBh3j6NE6Ysircv26hxcXt/Mo3QMXzOH4jote237RrI9P4H8lR9rzlk
MgwOJAuQofYqtYz5vC5gcuR9kYa64DdLW/uOqbCwS+N0Ko8kBklZXeOy88cHbZga
cH0f6hUHIaIxGInCFplpDxdFhoaDVGcH2VuoBPykd/KL8s9bqJBaFa3GqPEUW4HJ
i7g7tRR9Ktk=
=Oz+o
-----END PGP SIGNATURE-----

--==_Exmh_1469706366_4839P--
