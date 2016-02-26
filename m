Reply-To: kernel-hardening@lists.openwall.com
From: Laura Abbott <labbott@fedoraproject.org>
Date: Thu, 25 Feb 2016 16:36:42 -0800
Message-Id: <1456447004-21392-2-git-send-email-labbott@fedoraproject.org>
In-Reply-To: <1456447004-21392-1-git-send-email-labbott@fedoraproject.org>
References: <1456447004-21392-1-git-send-email-labbott@fedoraproject.org>
Subject: [kernel-hardening] [PATCHv4 1/3] lkdtm: Add READ_AFTER_FREE test
To: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@fedoraproject.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


In a similar manner to WRITE_AFTER_FREE, add a READ_AFTER_FREE
test to test free poisoning features. Sample output when
no sanitization is present:

 # echo READ_AFTER_FREE > /sys/kernel/debug/provoke-crash/DIRECT
[   17.542473] lkdtm: Performing direct entry READ_AFTER_FREE
[   17.543866] lkdtm: Value in memory before free: 12345678
[   17.545212] lkdtm: Attempting bad read from freed memory
[   17.546542] lkdtm: Memory was not poisoned

with slub_debug=P:

 # echo READ_AFTER_FREE > /sys/kernel/debug/provoke-crash/DIRECT
[   22.415531] lkdtm: Performing direct entry READ_AFTER_FREE
[   22.416366] lkdtm: Value in memory before free: 12345678
[   22.417137] lkdtm: Attempting bad read from freed memory
[   22.417897] lkdtm: Memory correctly poisoned, calling BUG

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Laura Abbott <labbott@fedoraproject.org>
---
v4: Tweak the output as per the suggestion of Kees. Add explicit BUG for
failure.
---
 drivers/misc/lkdtm.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
index 11fdadc..8de4746 100644
--- a/drivers/misc/lkdtm.c
+++ b/drivers/misc/lkdtm.c
@@ -92,6 +92,7 @@ enum ctype {
 	CT_UNALIGNED_LOAD_STORE_WRITE,
 	CT_OVERWRITE_ALLOCATION,
 	CT_WRITE_AFTER_FREE,
+	CT_READ_AFTER_FREE,
 	CT_SOFTLOCKUP,
 	CT_HARDLOCKUP,
 	CT_SPINLOCKUP,
@@ -129,6 +130,7 @@ static char* cp_type[] = {
 	"UNALIGNED_LOAD_STORE_WRITE",
 	"OVERWRITE_ALLOCATION",
 	"WRITE_AFTER_FREE",
+	"READ_AFTER_FREE",
 	"SOFTLOCKUP",
 	"HARDLOCKUP",
 	"SPINLOCKUP",
@@ -417,6 +419,42 @@ static void lkdtm_do_action(enum ctype which)
 		memset(data, 0x78, len);
 		break;
 	}
+	case CT_READ_AFTER_FREE: {
+		int *base, *val, saw;
+		size_t len = 1024;
+		/*
+		 * The slub allocator uses the first word to store the free
+		 * pointer in some configurations. Use the middle of the
+		 * allocation to avoid running into the freelist
+		 */
+		size_t offset = (len / sizeof(*base)) / 2;
+
+		base = kmalloc(len, GFP_KERNEL);
+		if (!base)
+			break;
+
+		val = kmalloc(len, GFP_KERNEL);
+		if (!val)
+			break;
+
+		*val = 0x12345678;
+		base[offset] = *val;
+		pr_info("Value in memory before free: %x\n", base[offset]);
+
+		kfree(base);
+
+		pr_info("Attempting bad read from freed memory\n");
+		saw = base[offset];
+		if (saw != *val) {
+			/* Good! Poisoning happened, so declare a win. */
+			pr_info("Memory correctly poisoned, calling BUG\n");
+			BUG();
+		}
+		pr_info("Memory was not poisoned\n");
+
+		kfree(val);
+		break;
+	}
 	case CT_SOFTLOCKUP:
 		preempt_disable();
 		for (;;)
-- 
2.5.0
