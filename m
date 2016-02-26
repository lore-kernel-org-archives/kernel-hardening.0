Reply-To: kernel-hardening@lists.openwall.com
From: Laura Abbott <labbott@fedoraproject.org>
Date: Thu, 25 Feb 2016 16:36:44 -0800
Message-Id: <1456447004-21392-4-git-send-email-labbott@fedoraproject.org>
In-Reply-To: <1456447004-21392-1-git-send-email-labbott@fedoraproject.org>
References: <1456447004-21392-1-git-send-email-labbott@fedoraproject.org>
Subject: [kernel-hardening] [PATCHv2 3/3] lkdtm: Add read/write after free tests for buddy memory
To: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@fedoraproject.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


The current tests for read/write after free work on slab
allocated memory. Memory straight from the buddy allocator
may behave slightly differently and have a different set
of parameters to test. Add tests for those cases as well.

On a basic x86 boot:

 # echo WRITE_BUDDY_AFTER_FREE > /sys/kernel/debug/provoke-crash/DIRECT
[   22.291950] lkdtm: Performing direct entry WRITE_BUDDY_AFTER_FREE
[   22.292983] lkdtm: Writing to the buddy page before free
[   22.293950] lkdtm: Attempting bad write to the buddy page after free

 # echo READ_BUDDY_AFTER_FREE > /sys/kernel/debug/provoke-crash/DIRECT
[   32.375601] lkdtm: Performing direct entry READ_BUDDY_AFTER_FREE
[   32.379896] lkdtm: Value in memory before free: 12345678
[   32.383854] lkdtm: Attempting to read from freed memory
[   32.389309] lkdtm: Buddy page was not poisoned

On x86 with CONFIG_DEBUG_PAGEALLOC and debug_pagealloc=on:

 # echo WRITE_BUDDY_AFTER_FREE > /sys/kernel/debug/provoke-crash/DIRECT
[   17.475533] lkdtm: Performing direct entry WRITE_BUDDY_AFTER_FREE
[   17.477360] lkdtm: Writing to the buddy page before free
[   17.479089] lkdtm: Attempting bad write to the buddy page after free
[   17.480904] BUG: unable to handle kernel paging request at
ffff88000ebd8000

 # echo READ_BUDDY_AFTER_FREE > /sys/kernel/debug/provoke-crash/DIRECT
[   14.606433] lkdtm: Performing direct entry READ_BUDDY_AFTER_FREE
[   14.607447] lkdtm: Value in memory before free: 12345678
[   14.608161] lkdtm: Attempting to read from freed memory
[   14.608860] BUG: unable to handle kernel paging request at
ffff88000eba3000

Note that arches without ARCH_SUPPORTS_DEBUG_PAGEALLOC may not
produce the same crash.

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Laura Abbott <labbott@fedoraproject.org>
---
v2: Output updates per the suggestion of Kees
---
 drivers/misc/lkdtm.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
index a00a2b1..8e00e2e 100644
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
@@ -464,6 +468,47 @@ static void lkdtm_do_action(enum ctype which)
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
+		pr_info("Attempting bad write to the buddy page after free\n");
+		memset((void *)p, 0x78, PAGE_SIZE);
+		break;
+	}
+	case CT_READ_BUDDY_AFTER_FREE: {
+		unsigned long p = __get_free_page(GFP_KERNEL);
+		int saw, *val = kmalloc(1024, GFP_KERNEL);
+		int *base;
+
+		if (!p)
+			break;
+
+		if (!val)
+			break;
+
+		base = (int *)p;
+
+		*val = 0x12345678;
+		base[0] = *val;
+		pr_info("Value in memory before free: %x\n", base[0]);
+		free_page(p);
+		pr_info("Attempting to read from freed memory\n");
+		saw = base[0];
+		if (saw != *val) {
+			/* Good! Poisoning happened, so declare a win. */
+			pr_info("Buddy page correctly poisoned, calling BUG\n");
+			BUG();
+		}
+		pr_info("Buddy page was not poisoned\n");
+
+		kfree(val);
+		break;
+	}
 	case CT_SOFTLOCKUP:
 		preempt_disable();
 		for (;;)
-- 
2.5.0
