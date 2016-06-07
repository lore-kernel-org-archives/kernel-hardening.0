Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Tue,  7 Jun 2016 14:57:06 -0700
Message-Id: <1465336628-18219-4-git-send-email-keescook@chromium.org>
In-Reply-To: <1465336628-18219-1-git-send-email-keescook@chromium.org>
References: <1465336628-18219-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 3/5] lkdtm: add function for testing .rodata section
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Jiri Slaby <jslaby@suse.cz>, Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

This adds a function that lives in the .rodata section. The section
flags are corrected using objcopy since there is no way with gcc to
declare section flags in an architecture-agnostic way.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/misc/Makefile       |  7 +++++++
 drivers/misc/lkdtm.h        |  6 ++++++
 drivers/misc/lkdtm_core.c   | 24 +++++++++++++++++-------
 drivers/misc/lkdtm_rodata.c | 10 ++++++++++
 4 files changed, 40 insertions(+), 7 deletions(-)
 create mode 100644 drivers/misc/lkdtm.h
 create mode 100644 drivers/misc/lkdtm_rodata.c

diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index c3cb6ad8cc37..b2d3d68dfa22 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -59,3 +59,10 @@ obj-$(CONFIG_CXL_BASE)		+= cxl/
 obj-$(CONFIG_PANEL)             += panel.o
 
 lkdtm-$(CONFIG_LKDTM)		+= lkdtm_core.o
+lkdtm-$(CONFIG_LKDTM)		+= lkdtm_rodata_objcopy.o
+
+OBJCOPYFLAGS_lkdtm_rodata_objcopy.o := \
+			--set-section-flags .text=alloc,readonly \
+			--rename-section .text=.rodata
+$(obj)/lkdtm_rodata_objcopy.o: $(obj)/lkdtm_rodata.o
+	$(call if_changed,objcopy)
diff --git a/drivers/misc/lkdtm.h b/drivers/misc/lkdtm.h
new file mode 100644
index 000000000000..9531fa3be4c3
--- /dev/null
+++ b/drivers/misc/lkdtm.h
@@ -0,0 +1,6 @@
+#ifndef __LKDTM_H
+#define __LKDTM_H
+
+void lkdtm_rodata_do_nothing(void);
+
+#endif
diff --git a/drivers/misc/lkdtm_core.c b/drivers/misc/lkdtm_core.c
index 605050c60f10..187cd9b63e9a 100644
--- a/drivers/misc/lkdtm_core.c
+++ b/drivers/misc/lkdtm_core.c
@@ -52,6 +52,8 @@
 #include <linux/ide.h>
 #endif
 
+#include "lkdtm.h"
+
 /*
  * Make sure our attempts to over run the kernel stack doesn't trigger
  * a compiler warning when CONFIG_FRAME_WARN is set. Then make sure we
@@ -103,6 +105,7 @@ enum ctype {
 	CT_EXEC_STACK,
 	CT_EXEC_KMALLOC,
 	CT_EXEC_VMALLOC,
+	CT_EXEC_RODATA,
 	CT_EXEC_USERSPACE,
 	CT_ACCESS_USERSPACE,
 	CT_WRITE_RO,
@@ -145,6 +148,7 @@ static char* cp_type[] = {
 	"EXEC_STACK",
 	"EXEC_KMALLOC",
 	"EXEC_VMALLOC",
+	"EXEC_RODATA",
 	"EXEC_USERSPACE",
 	"ACCESS_USERSPACE",
 	"WRITE_RO",
@@ -346,15 +350,18 @@ static noinline void corrupt_stack(void)
 	memset((void *)data, 0, 64);
 }
 
-static void noinline execute_location(void *dst)
+static noinline void execute_location(void *dst, bool write)
 {
 	void (*func)(void) = dst;
 
 	pr_info("attempting ok execution at %p\n", do_nothing);
 	do_nothing();
 
-	memcpy(dst, do_nothing, EXEC_SIZE);
-	flush_icache_range((unsigned long)dst, (unsigned long)dst + EXEC_SIZE);
+	if (write) {
+		memcpy(dst, do_nothing, EXEC_SIZE);
+		flush_icache_range((unsigned long)dst,
+				   (unsigned long)dst + EXEC_SIZE);
+	}
 	pr_info("attempting bad execution at %p\n", func);
 	func();
 }
@@ -551,25 +558,28 @@ static void lkdtm_do_action(enum ctype which)
 		schedule();
 		break;
 	case CT_EXEC_DATA:
-		execute_location(data_area);
+		execute_location(data_area, true);
 		break;
 	case CT_EXEC_STACK: {
 		u8 stack_area[EXEC_SIZE];
-		execute_location(stack_area);
+		execute_location(stack_area, true);
 		break;
 	}
 	case CT_EXEC_KMALLOC: {
 		u32 *kmalloc_area = kmalloc(EXEC_SIZE, GFP_KERNEL);
-		execute_location(kmalloc_area);
+		execute_location(kmalloc_area, true);
 		kfree(kmalloc_area);
 		break;
 	}
 	case CT_EXEC_VMALLOC: {
 		u32 *vmalloc_area = vmalloc(EXEC_SIZE);
-		execute_location(vmalloc_area);
+		execute_location(vmalloc_area, true);
 		vfree(vmalloc_area);
 		break;
 	}
+	case CT_EXEC_RODATA:
+		execute_location(lkdtm_rodata_do_nothing, false);
+		break;
 	case CT_EXEC_USERSPACE: {
 		unsigned long user_addr;
 
diff --git a/drivers/misc/lkdtm_rodata.c b/drivers/misc/lkdtm_rodata.c
new file mode 100644
index 000000000000..4d0d851f02b9
--- /dev/null
+++ b/drivers/misc/lkdtm_rodata.c
@@ -0,0 +1,10 @@
+/*
+ * This includes functions that are meant to live entirely in .rodata
+ * (via objcopy tricks), to validate the non-executability of .rodata.
+ */
+#include <linux/kernel.h>
+
+void lkdtm_rodata_do_nothing(void)
+{
+	/* Does nothing. We just want an architecture agnostic "return". */
+}
-- 
2.7.4
