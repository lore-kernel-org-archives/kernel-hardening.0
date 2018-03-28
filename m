Message-Id: <20180328205138.301218351@linutronix.de>
Date: Wed, 28 Mar 2018 22:51:38 +0200
From: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 0/8] rslib: Cleanup and VLA removal
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

Thanks,

	tglx

8<---------------
 drivers/md/dm-verity-fec.c      |    7 +
 drivers/mtd/nand/cafe_nand.c    |    7 -
 drivers/mtd/nand/diskonchip.c   |   72 ++++++--------
 include/linux/rslib.h           |   46 ++++-----
 lib/reed_solomon/decode_rs.c    |   34 +++---
 lib/reed_solomon/encode_rs.c    |   15 --
 lib/reed_solomon/reed_solomon.c |  203 +++++++++++++++++++++++-----------------
 7 files changed, 209 insertions(+), 175 deletions(-)
