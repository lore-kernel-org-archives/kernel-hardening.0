Message-Id: <20180419100934.914488121@linutronix.de>
Date: Thu, 19 Apr 2018 12:04:43 +0200
From: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch V2 2/8] rslib: Cleanup top level comments
References: <20180419100441.548834519@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=rslib--Cleanup_top_level_comments.patch
To: LKML <linux-kernel@vger.kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Segher Boessenkool <segher@kernel.crashing.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linuxfoundation.org>, Boris Brezillon <boris.brezillon@free-electrons.com>, Richard Weinberger <richard@nod.at>, David Woodhouse <dwmw2@infradead.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Thomas Gleixner <tglx@linutronix.de>

File references and stale CVS ids are really not useful.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
 include/linux/rslib.h           |    7 +------
 lib/reed_solomon/decode_rs.c    |   12 ++----------
 lib/reed_solomon/encode_rs.c    |   13 ++-----------
 lib/reed_solomon/reed_solomon.c |    9 +--------
 4 files changed, 6 insertions(+), 35 deletions(-)

--- a/include/linux/rslib.h
+++ b/include/linux/rslib.h
@@ -1,16 +1,11 @@
 /*
- * include/linux/rslib.h
- *
- * Overview:
- *   Generic Reed Solomon encoder / decoder library
+ * Generic Reed Solomon encoder / decoder library
  *
  * Copyright (C) 2004 Thomas Gleixner (tglx@linutronix.de)
  *
  * RS code lifted from reed solomon library written by Phil Karn
  * Copyright 2002 Phil Karn, KA9Q
  *
- * $Id: rslib.h,v 1.4 2005/11/07 11:14:52 gleixner Exp $
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
--- a/lib/reed_solomon/decode_rs.c
+++ b/lib/reed_solomon/decode_rs.c
@@ -1,20 +1,12 @@
 /*
- * lib/reed_solomon/decode_rs.c
- *
- * Overview:
- *   Generic Reed Solomon encoder / decoder library
+ * Generic Reed Solomon encoder / decoder library
  *
  * Copyright 2002, Phil Karn, KA9Q
  * May be used under the terms of the GNU General Public License (GPL)
  *
  * Adaption to the kernel by Thomas Gleixner (tglx@linutronix.de)
  *
- * $Id: decode_rs.c,v 1.7 2005/11/07 11:14:59 gleixner Exp $
- *
- */
-
-/* Generic data width independent code which is included by the
- * wrappers.
+ * Generic data width independent code which is included by the wrappers.
  */
 {
 	int deg_lambda, el, deg_omega;
--- a/lib/reed_solomon/encode_rs.c
+++ b/lib/reed_solomon/encode_rs.c
@@ -1,21 +1,12 @@
 /*
- * lib/reed_solomon/encode_rs.c
- *
- * Overview:
- *   Generic Reed Solomon encoder / decoder library
+ * Generic Reed Solomon encoder / decoder library
  *
  * Copyright 2002, Phil Karn, KA9Q
  * May be used under the terms of the GNU General Public License (GPL)
  *
  * Adaption to the kernel by Thomas Gleixner (tglx@linutronix.de)
  *
- * $Id: encode_rs.c,v 1.5 2005/11/07 11:14:59 gleixner Exp $
- *
- */
-
-/* Generic data width independent code which is included by the
- * wrappers.
- * int encode_rsX (struct rs_control *rs, uintX_t *data, int len, uintY_t *par)
+ * Generic data width independent code which is included by the wrappers.
  */
 {
 	int i, j, pad;
--- a/lib/reed_solomon/reed_solomon.c
+++ b/lib/reed_solomon/reed_solomon.c
@@ -1,16 +1,11 @@
 /*
- * lib/reed_solomon/reed_solomon.c
- *
- * Overview:
- *   Generic Reed Solomon encoder / decoder library
+ * Generic Reed Solomon encoder / decoder library
  *
  * Copyright (C) 2004 Thomas Gleixner (tglx@linutronix.de)
  *
  * Reed Solomon code lifted from reed solomon library written by Phil Karn
  * Copyright 2002 Phil Karn, KA9Q
  *
- * $Id: rslib.c,v 1.7 2005/11/07 11:14:59 gleixner Exp $
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
@@ -35,9 +30,7 @@
  * second stage, which does the decoding / error correction itself.
  * Many hw encoders provide a syndrome calculation over the received
  * data + syndrome and can call the second stage directly.
- *
  */
-
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
