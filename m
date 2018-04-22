Message-Id: <20180422162512.747021175@linutronix.de>
Date: Sun, 22 Apr 2018 18:23:50 +0200
From: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch V3 05/10] rslib: Add SPDX identifiers
References: <20180422162345.004292133@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=rslib--Add_SPDX_identifiers.patch
To: LKML <linux-kernel@vger.kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Segher Boessenkool <segher@kernel.crashing.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linuxfoundation.org>, Boris Brezillon <boris.brezillon@free-electrons.com>, Richard Weinberger <richard@nod.at>, David Woodhouse <dwmw2@infradead.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>, Kate Stewart <kstewart@linuxfoundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

From: Thomas Gleixner <tglx@linutronix.de>

The Reed-Solomon library is based on code from Phil Karn who granted
permission to import it into the kernel under the GPL V2.

See commit 15b5423757a7 ("Shared Reed-Solomon ECC library") in the history
git tree at: git://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git

  ...
  The encoder/decoder code is lifted from the GPL'd userspace RS-library
  written by Phil Karn. I modified/wrapped it to provide the different
  functions which we need in the MTD/NAND code.
  ...    
  Signed-Off-By: Thomas Gleixner <tglx@linutronix.de>
  Signed-Off-By: David Woodhouse <dwmw2@infradead.org>
  "No objections at all. Just keep the authorship notices." -- Phil Karn

Add the proper SPDX identifiers according to
Documentation/process/license-rules.rst.


Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Kate Stewart <kstewart@linuxfoundation.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Colin Cross <ccross@android.com>
Cc: Andrew Morton <akpm@linuxfoundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Alasdair Kergon <agk@redhat.com>

---
 include/linux/rslib.h           |    1 +
 lib/reed_solomon/decode_rs.c    |    1 +
 lib/reed_solomon/encode_rs.c    |    1 +
 lib/reed_solomon/reed_solomon.c |    1 +
 4 files changed, 4 insertions(+)

--- a/include/linux/rslib.h
+++ b/include/linux/rslib.h
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Generic Reed Solomon encoder / decoder library
  *
--- a/lib/reed_solomon/decode_rs.c
+++ b/lib/reed_solomon/decode_rs.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Generic Reed Solomon encoder / decoder library
  *
--- a/lib/reed_solomon/encode_rs.c
+++ b/lib/reed_solomon/encode_rs.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Generic Reed Solomon encoder / decoder library
  *
--- a/lib/reed_solomon/reed_solomon.c
+++ b/lib/reed_solomon/reed_solomon.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Generic Reed Solomon encoder / decoder library
  *
