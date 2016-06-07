Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Tue,  7 Jun 2016 14:57:05 -0700
Message-Id: <1465336628-18219-3-git-send-email-keescook@chromium.org>
In-Reply-To: <1465336628-18219-1-git-send-email-keescook@chromium.org>
References: <1465336628-18219-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 2/5] lkdtm: clean up after rename
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Jiri Slaby <jslaby@suse.cz>, Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

This cleans up comments a bit to improve readability, adjusts the
name of the module after the source file renaming, and corrects the
MAINTAINERS for the upcoming lkdtm files.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 MAINTAINERS               |  2 +-
 drivers/misc/lkdtm_core.c | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ed42cb65a19b..437e291a7b30 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6953,7 +6953,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jikos/livepatching.git
 LINUX KERNEL DUMP TEST MODULE (LKDTM)
 M:	Kees Cook <keescook@chromium.org>
 S:	Maintained
-F:	drivers/misc/lkdtm.c
+F:	drivers/misc/lkdtm*
 
 LLC (802.2)
 M:	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
diff --git a/drivers/misc/lkdtm_core.c b/drivers/misc/lkdtm_core.c
index 0a5cbbe12452..605050c60f10 100644
--- a/drivers/misc/lkdtm_core.c
+++ b/drivers/misc/lkdtm_core.c
@@ -1,5 +1,9 @@
 /*
- * Kprobe module for testing crash dumps
+ * Linux Kernel Dump Test Module for testing kernel crashes conditions:
+ * induces system failures at predefined crashpoints and under predefined
+ * operational conditions in order to evaluate the reliability of kernel
+ * sanity checking and crash dumps obtained using different dumping
+ * solutions.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -19,10 +23,6 @@
  *
  * Author: Ankita Garg <ankita@in.ibm.com>
  *
- * This module induces system failures at predefined crashpoints to
- * evaluate the reliability of crash dumps obtained using different dumping
- * solutions.
- *
  * It is adapted from the Linux Kernel Dump Test Tool by
  * Fernando Luis Vazquez Cao <http://lkdtt.sourceforge.net>
  *
@@ -30,7 +30,7 @@
  *
  * See Documentation/fault-injection/provoke-crashes.txt for instructions
  */
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#define pr_fmt(fmt) "lkdtm: " fmt
 
 #include <linux/kernel.h>
 #include <linux/fs.h>
-- 
2.7.4
