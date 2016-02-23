Reply-To: kernel-hardening@lists.openwall.com
From: Laura Abbott <labbott@fedoraproject.org>
Date: Mon, 22 Feb 2016 17:27:51 -0800
Message-Id: <1456190872-30828-2-git-send-email-labbott@fedoraproject.org>
In-Reply-To: <1456190872-30828-1-git-send-email-labbott@fedoraproject.org>
References: <1456190872-30828-1-git-send-email-labbott@fedoraproject.org>
Subject: [kernel-hardening] [PATCHv3 1/2] lkdtm: Add READ_AFTER_FREE test
To: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@fedoraproject.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


In a similar manner to WRITE_AFTER_FREE, add a READ_AFTER_FREE
test to test free poisoning features. Sample output when
no sanitization is present:

[   22.414170] lkdtm: Performing direct entry READ_AFTER_FREE
[   22.415124] lkdtm: Value in memory before free: 12345678
[   22.415900] lkdtm: Attempting to read from freed memory
[   22.416394] lkdtm: Successfully read value: 12345678

with slub_debug=P:

[   25.874585] lkdtm: Performing direct entry READ_AFTER_FREE
[   25.875527] lkdtm: Value in memory before free: 12345678
[   25.876382] lkdtm: Attempting to read from freed memory
[   25.876900] general protection fault: 0000 [#1] SMP

Signed-off-by: Laura Abbott <labbott@fedoraproject.org>
---
v3: Add mention of slub debug option to give example crash.
Change 'return' to 'break' to better match with the other
functions.
---
 drivers/misc/lkdtm.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
index 11fdadc..f95a582 100644
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
@@ -417,6 +419,38 @@ static void lkdtm_do_action(enum ctype which)
 		memset(data, 0x78, len);
 		break;
 	}
+	case CT_READ_AFTER_FREE: {
+		int **base;
+		int *val, *tmp;
+		size_t len = 1024;
+		/*
+		 * The slub allocator uses the first word to store the free
+		 * pointer in some configurations. Use the middle of the
+		 * allocation to avoid running into the freelist
+		 */
+		size_t offset = (len/sizeof(int *))/2;
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
+		pr_info("Value in memory before free: %x\n", *val);
+
+		base[offset] = val;
+		kfree(base);
+
+		tmp = base[offset];
+		pr_info("Attempting to read from freed memory\n");
+		pr_info("Successfully read value: %x\n", *tmp);
+
+		kfree(val);
+		break;
+	}
 	case CT_SOFTLOCKUP:
 		preempt_disable();
 		for (;;)
-- 
2.5.0
