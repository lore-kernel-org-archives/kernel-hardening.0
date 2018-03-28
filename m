Message-Id: <20180328205554.579463196@linutronix.de>
Date: Wed, 28 Mar 2018 22:51:42 +0200
From: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 4/8] rslib: Remove GPL boilerplate
References: <20180328205138.301218351@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=rslib--Remove-GPL-boilerplate.patch
To: LKML <linux-kernel@vger.kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Segher Boessenkool <segher@kernel.crashing.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linuxfoundation.org>, Boris Brezillon <boris.brezillon@free-electrons.com>, Richard Weinberger <richard@nod.at>, David Woodhouse <dwmw2@infradead.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>, Kate Stewart <kstewart@linuxfoundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

Now that SPDX identifiers are in place, remove the GPL boiler plate
text. Leave the notices which document that Phil Karn granted permission in
place (encode/decode source code). The modified files are code written for
the kernel by me.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Kate Stewart <kstewart@linuxfoundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/rslib.h           |    5 -----
 lib/reed_solomon/reed_solomon.c |    4 ----
 2 files changed, 9 deletions(-)

--- a/include/linux/rslib.h
+++ b/include/linux/rslib.h
@@ -6,12 +6,7 @@
  *
  * RS code lifted from reed solomon library written by Phil Karn
  * Copyright 2002 Phil Karn, KA9Q
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
-
 #ifndef _RSLIB_H_
 #define _RSLIB_H_
 
--- a/lib/reed_solomon/reed_solomon.c
+++ b/lib/reed_solomon/reed_solomon.c
@@ -7,10 +7,6 @@
  * Reed Solomon code lifted from reed solomon library written by Phil Karn
  * Copyright 2002 Phil Karn, KA9Q
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
  * Description:
  *
  * The generic Reed Solomon library provides runtime configurable
