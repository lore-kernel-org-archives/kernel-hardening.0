Reply-To: kernel-hardening@lists.openwall.com
From: Laura Abbott <laura@labbott.name>
Date: Mon, 21 Dec 2015 19:40:41 -0800
Message-Id: <1450755641-7856-8-git-send-email-laura@labbott.name>
In-Reply-To: <1450755641-7856-1-git-send-email-laura@labbott.name>
References: <1450755641-7856-1-git-send-email-laura@labbott.name>
Subject: [kernel-hardening] [RFC][PATCH 7/7] lkdtm: Add READ_AFTER_FREE test
To: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Laura Abbott <laura@labbott.name>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-ID: <kernel-hardening.lists.openwall.com>


In a similar manner to WRITE_AFTER_FREE, add a READ_AFTER_FREE
test to test free poisoning features. Sample output when
no poison is present:

[   20.222501] lkdtm: Performing direct entry READ_AFTER_FREE
[   20.226163] lkdtm: Freed val: 12345678

with poison:

[   24.203748] lkdtm: Performing direct entry READ_AFTER_FREE
[   24.207261] general protection fault: 0000 [#1] SMP
[   24.208193] Modules linked in:
[   24.208193] CPU: 0 PID: 866 Comm: sh Not tainted 4.4.0-rc5-work+ #108

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Laura Abbott <laura@labbott.name>
---
 drivers/misc/lkdtm.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
index 11fdadc..c641fb7 100644
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
@@ -417,6 +419,33 @@ static void lkdtm_do_action(enum ctype which)
 		memset(data, 0x78, len);
 		break;
 	}
+	case CT_READ_AFTER_FREE: {
+		int **base;
+		int *val, *tmp;
+
+		base = kmalloc(1024, GFP_KERNEL);
+		if (!base)
+			return;
+
+		val = kmalloc(1024, GFP_KERNEL);
+		if (!val)
+			return;
+
+		*val = 0x12345678;
+
+		/*
+		 * Don't just use the first entry since that's where the
+		 * freelist goes for the slab allocator
+		 */
+		base[1] = val;
+		kfree(base);
+
+		tmp = base[1];
+		pr_info("Freed val: %x\n", *tmp);
+
+		kfree(val);
+		break;
+	}
 	case CT_SOFTLOCKUP:
 		preempt_disable();
 		for (;;)
-- 
2.5.0
