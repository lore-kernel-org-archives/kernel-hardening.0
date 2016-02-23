Reply-To: kernel-hardening@lists.openwall.com
From: Laura Abbott <labbott@fedoraproject.org>
Date: Mon, 22 Feb 2016 17:27:52 -0800
Message-Id: <1456190872-30828-3-git-send-email-labbott@fedoraproject.org>
In-Reply-To: <1456190872-30828-1-git-send-email-labbott@fedoraproject.org>
References: <1456190872-30828-1-git-send-email-labbott@fedoraproject.org>
Subject: [kernel-hardening] [PATCH 2/2] lkdtm: Add read/write after free tests for buddy memory
To: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@fedoraproject.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


The current tests for read/write after free work on slab
allocated memory. Memory straight from the buddy allocator
may behave slightly differently and have a different set
of parameters to test. Add tests for those cases as well.

On a basic x86 boot:

 # echo WRITE_BUDDY_AFTER_FREE > /sys/kernel/debug/provoke-crash/DIRECT
[   20.358964] lkdtm: Performing direct entry WRITE_BUDDY_AFTER_FREE
[   20.359979] lkdtm: Writing to the buddy page before free
[   20.360943] lkdtm: Writing to the buddy page after free
[   20.361838] lkdtm: Wrote to free page successfully

 # echo READ_BUDDY_AFTER_FREE > /sys/kernel/debug/provoke-crash/DIRECT
[   32.590826] lkdtm: Performing direct entry READ_BUDDY_AFTER_FREE
[   32.591692] lkdtm: Value in memory before free: 12345678
[   32.592459] lkdtm: Attempting to read from freed memory
[   32.593213] lkdtm: Successfully read value: 12345678

On x86 with CONFIG_DEBUG_PAGEALLOC and debug_pagealloc=on:

 # echo WRITE_BUDDY_AFTER_FREE > /sys/kernel/debug/provoke-crash/DIRECT
[   49.761358] lkdtm: Performing direct entry WRITE_BUDDY_AFTER_FREE
[   49.762177] lkdtm: Writing to the buddy page before free
[   49.762890] lkdtm: Writing to the buddy page after free
[   49.763606] BUG: unable to handle kernel paging request at
ffff880000034000

 # echo READ_BUDDY_AFTER_FREE > /sys/kernel/debug/provoke-crash/DIRECT
[   20.454176] lkdtm: Performing direct entry READ_BUDDY_AFTER_FREE
[   20.455198] lkdtm: Value in memory before free: 12345678
[   20.456107] BUG: unable to handle kernel paging request at
ffff880000039000

Note that arches without ARCH_SUPPORTS_DEBUG_PAGEALLOC may not
produce the same crash.

Signed-off-by: Laura Abbott <labbott@fedoraproject.org>
---
The examples I gave were for ARCH_SUPPORTS_DEBUG_PAGEALLOC because
that's going to look different that the slab allocators. With
page poisoning, the behavior is going to look similar to the slab
allocators (write will succeed quietly, read should abort).
---
 drivers/misc/lkdtm.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
index f95a582..2ef99e9 100644
--- a/drivers/misc/lkdtm.c
+++ b/drivers/misc/lkdtm.c
@@ -93,6 +93,8 @@ enum ctype {
 	CT_OVERWRITE_ALLOCATION,
 	CT_WRITE_AFTER_FREE,
 	CT_READ_AFTER_FREE,
+	CT_WRITE_BUDDY_AFTER_FREE,
+	CT_READ_BUDDY_AFTER_FREE,
 	CT_SOFTLOCKUP,
 	CT_HARDLOCKUP,
 	CT_SPINLOCKUP,
@@ -131,6 +133,8 @@ static char* cp_type[] = {
 	"OVERWRITE_ALLOCATION",
 	"WRITE_AFTER_FREE",
 	"READ_AFTER_FREE",
+	"WRITE_BUDDY_AFTER_FREE",
+	"READ_BUDDY_AFTER_FREE",
 	"SOFTLOCKUP",
 	"HARDLOCKUP",
 	"SPINLOCKUP",
@@ -451,6 +455,42 @@ static void lkdtm_do_action(enum ctype which)
 		kfree(val);
 		break;
 	}
+	case CT_WRITE_BUDDY_AFTER_FREE: {
+		unsigned long p = __get_free_page(GFP_KERNEL);
+		if (!p)
+			break;
+		pr_info("Writing to the buddy page before free\n");
+		memset((void *)p, 0x3, PAGE_SIZE);
+		free_page(p);
+		schedule();
+		pr_info("Writing to the buddy page after free\n");
+		memset((void *)p, 0x78, PAGE_SIZE);
+		pr_info("Wrote to free page successfully\n");
+		break;
+	}
+	case CT_READ_BUDDY_AFTER_FREE: {
+		unsigned long p = __get_free_page(GFP_KERNEL);
+		int *tmp, *val = kmalloc(1024, GFP_KERNEL);
+		int **base;
+
+		if (!p)
+			break;
+
+		if (!val)
+			break;
+
+		base = (int **)p;
+
+		*val = 0x12345678;
+		pr_info("Value in memory before free: %x\n", *val);
+		base[0] = val;
+		free_page(p);
+		tmp = base[0];
+		pr_info("Attempting to read from freed memory\n");
+		pr_info("Successfully read value: %x\n", *tmp);
+		kfree(val);
+		break;
+	}
 	case CT_SOFTLOCKUP:
 		preempt_disable();
 		for (;;)
-- 
2.5.0
