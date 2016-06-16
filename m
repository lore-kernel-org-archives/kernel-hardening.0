Reply-To: kernel-hardening@lists.openwall.com
From: Valdis.Kletnieks@vt.edu
In-Reply-To: <1465420302-23754-1-git-send-email-keescook@chromium.org>
References: <1465420302-23754-1-git-send-email-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1466040627_2241P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 15 Jun 2016 21:30:27 -0400
Message-ID: <9020.1466040627@turing-police.cc.vt.edu>
Subject: Re: [kernel-hardening] [RFC][PATCH v2 0/4] mm: Hardened usercopy
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey.schaufler@intel.com>, Rik van Riel <riel@redhat.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

--==_Exmh_1466040627_2241P
Content-Type: text/plain; charset=us-ascii

On Wed, 08 Jun 2016 14:11:38 -0700, Kees Cook said:
> Hi,
>
> This is v2 of the RFC patches for a mainline port of PAX_USERCOPY. After
> I started writing tests for Casey's earlier port[1], I kept fixing things
> further and further until I ended up with a whole new patch series. To
> that end, I also took Rik's feedback and made a number of other changes
> and clean-ups, which are noted in the "v2" history at the end.

In the "For what it's worth" category - the 6 patches apply mostly cleanly
to the linux-next tree as of next-20160614 - a bunch of offsets, and one
easily fixed reject against include/linux/slab.h caused by KASAN landing
in linux-next.

And I found a test case - the NVidia driver is, of course, not annotated
for USERCOPY, so this happened:

[   39.184701] usercopy: kernel memory exposure attempt detected from ffff8800bb056fc0 (nvidia_stack_cache) (3 bytes)
[   39.184715] CPU: 2 PID: 1583 Comm: Xorg Tainted: G           O    4.7.0-rc3-next-20160614-dirty #302
[   39.184720] Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A17 08/19/2015
[   39.184725]  0000000000000000 00000000422dbb87 ffff8802233cbb28 ffffffffb769f61a
[   39.184736]  ffff8800bb056fc0 00000000422dbb87 0000000000000003 0000000000000001
[   39.184744]  ffff8802233cbb78 ffffffffb7367b30 0000000000000000 ffffea00028e92f0
[   39.184754] Call Trace:
[   39.184766]  [<ffffffffb769f61a>] dump_stack+0x7b/0xd1
[   39.184772]  [<ffffffffb7367b30>] __check_object_size+0x70/0x3d4
[   39.184947]  [<ffffffffc0287098>] os_memcpy_to_user+0x38/0x60 [nvidia]

So I guess you can stick a:

Tested-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>

on that patch set. :)

(Of course, the system only lived for another 4 seconds after that, because the
blocked copy_to_user() caused the module to not initialize properly, and it
quite reasonably crapped all over itself as a result.  And yes, I realize that
*fixing* the module with proper annotations is a problem for me and the NVidia
engineering team...  :)


--==_Exmh_1466040627_2241P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBV2IBMwdmEQWDXROgAQJ+cRAAhfZbFJOCmm9JN0WV4WDfSM9BchLbFkmF
ExNwfGw5ciL7cYB/fGqm3PgsRYI6WHKEcCHw8ojbWeskVjCS2W4dZK/jJP6sgUXV
PHK8vDTBPukLnwhI5zD34qbcwAX31KGPIRZX45Fojcue+yX/MOaz7/PArUXkQKaQ
ERpOTcUDKjkCXBCSyN28cAyQqCIVflvZX23lBs3EzhKD0zenLw95u3Ha84TgFprh
yqiL51qixjTVgagJlKAgi+y+Su91AHl3g6jPmmcSK9hd2Q/r7rENxU9U5StTwEoq
QWxV8Q81hLJz3dnP7asGdLocPNtzMdYmtO97Tz7od3n9Csb4uHUNB91RQlokTyev
ZTcq7TQNyCX5sBsKESxIurDy+DN1Bl/QP9RiMScffVEx2t0SDWIXoDm6ksmJEz3Y
Tj4hXxJonruF9/QwNG2XIKVELdbWr3eSc7AsckTAlIXFZpc+fJrEKQn7yK7lK6N3
8iZOsZnCIk28x739mqL7yI7lsvi7zx+BM82RJzmnSZJ8NGwMi3q5Zi8R3cdLvOz+
ZZ9aAKFNKWjnrdlFU2HtRERwiKgBWia9P1NRDdehzh261y0SVRSFntVUX/h9HqFn
pxkLKAAWdop4qDrsfX1SJ+3gsdP5g47/P/hOTKGYM5wkHEVmbv6nmi73gqYCTGd1
ImmumVOzpjM=
=gE9M
-----END PGP SIGNATURE-----

--==_Exmh_1466040627_2241P--
