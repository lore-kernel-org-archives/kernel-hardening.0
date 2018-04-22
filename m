Message-Id: <20180422162345.004292133@linutronix.de>
Date: Sun, 22 Apr 2018 18:23:45 +0200
From: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch V3 00/10] rslib: Cleanup and VLA removal
To: LKML <linux-kernel@vger.kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Segher Boessenkool <segher@kernel.crashing.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linuxfoundation.org>, Boris Brezillon <boris.brezillon@free-electrons.com>, Richard Weinberger <richard@nod.at>, David Woodhouse <dwmw2@infradead.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

Kees tried to get rid of the Variable Length Arrays in the Reed-Solomon
library by replacing them with fixed length arrays on stack. Though they
are rather large and Andrew did not fall in love with that solution.

This series addresses that in a different way by splitting the rs control
structure up, so that each invocation of rs_init() returns a new instance
in which the decoder buffers are allocated. The polynom tables which build
the base for the RS codecs are still shareable between the instances to
avoid large allocations and initializations of the same data over and over.

The usage sites have been audited and fixed up where necessary to
accomodate the decoder change which forbids parallel decoder invocation for
a particular rs control instance to prevent buffer corruption.

While at it the patch set tidies up the code and converts the related files
over to use SPDX license identifiers.

Changes since V2:

   Provide a gfp aware variant of init_rs and use it in the alloc callback
   of the dm/verity_fec rs_pool mempool allocations

   Picked up Reviewed/Acked-by tags and fixed the subject line for the MTD
   specific patch.

Changes since V1:

   Simplify error path in the diskonchip code and use the proper
   function to free the decoder.

As this spawns multiple subsystems it should either go through Andrews tree
or Kees can route it with his other hardening stuff.

Thanks,

        tglx

8<---------------
 drivers/md/dm-verity-fec.c        |    2 
 drivers/mtd/nand/raw/cafe_nand.c  |    7 -
 drivers/mtd/nand/raw/diskonchip.c |   67 +++++-----
 include/linux/rslib.h             |   71 +++++++----
 lib/reed_solomon/decode_rs.c      |   34 ++---
 lib/reed_solomon/encode_rs.c      |   15 --
 lib/reed_solomon/reed_solomon.c   |  233 ++++++++++++++++++++++----------------
 7 files changed, 237 insertions(+), 192 deletions(-)
