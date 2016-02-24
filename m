Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 24 Feb 2016 15:27:30 -0800
From: Kees Cook <keescook@chromium.org>
Message-ID: <20160224232730.GA5113@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [RFC][PATCH] lkdtm: improve use-after-free tests
To: Laura Abbott <labbott@fedoraproject.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

This fixes a typo in the CT_READ_AFTER_FREE test (*tmp was triggering a GP),
moves the CT_WRITE_AFTER_FREE test to the middle to better test poisoning
instead of free list checks. Also reorders/clarifies some pr_info calls
and validates poisoning.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
This applies on top of the "[PATCH 0/2] LKDTM test updates" and should
probably just get broken out into the separate patches.
---
 drivers/misc/lkdtm.c | 61 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 40 insertions(+), 21 deletions(-)

diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
index 41213bb7a58c..69a3714ff55c 100644
--- a/drivers/misc/lkdtm.c
+++ b/drivers/misc/lkdtm.c
@@ -415,24 +415,33 @@ static void lkdtm_do_action(enum ctype which)
 		break;
 	}
 	case CT_WRITE_AFTER_FREE: {
+		int *base;
 		size_t len = 1024;
-		u32 *data = kmalloc(len, GFP_KERNEL);
+		/*
+		 * The slub allocator uses the first word to store the free
+		 * pointer in some configurations. Use the middle of the
+		 * allocation to avoid running into the freelist
+		 */
+		size_t offset = (len / sizeof(*base)) / 2;
+
+		base = kmalloc(len, GFP_KERNEL);
+		pr_info("Allocated memory %p-%p\n", base, &base[offset * 2]);
+		kfree(base);
+		pr_info("Attempting bad write to freed memory at %p\n",
+			&base[offset]);
+		base[offset] = 0x0abcdef0;
 
-		kfree(data);
-		schedule();
-		memset(data, 0x78, len);
 		break;
 	}
 	case CT_READ_AFTER_FREE: {
-		int **base;
-		int *val, *tmp;
+		int *base, *val, saw;
 		size_t len = 1024;
 		/*
 		 * The slub allocator uses the first word to store the free
 		 * pointer in some configurations. Use the middle of the
 		 * allocation to avoid running into the freelist
 		 */
-		size_t offset = (len/sizeof(int *))/2;
+		size_t offset = (len / sizeof(*base)) / 2;
 
 		base = kmalloc(len, GFP_KERNEL);
 		if (!base)
@@ -443,14 +452,19 @@ static void lkdtm_do_action(enum ctype which)
 			break;
 
 		*val = 0x12345678;
-		pr_info("Value in memory before free: %x\n", *val);
+		base[offset] = *val;
+		pr_info("Value in memory before free: %x\n", base[offset]);
 
-		base[offset] = val;
 		kfree(base);
 
-		tmp = base[offset];
-		pr_info("Attempting to read from freed memory\n");
-		pr_info("Successfully read value: %x\n", *tmp);
+		pr_info("Attempting bad read from freed memory\n");
+		saw = base[offset];
+		if (saw != *val) {
+			/* Good! Poisoning happened, so declare a win. */
+			pr_info("Memory correctly poisoned, calling BUG\n");
+			BUG();
+		}
+		pr_info("Memory was not poisoned\n");
 
 		kfree(val);
 		break;
@@ -463,15 +477,14 @@ static void lkdtm_do_action(enum ctype which)
 		memset((void *)p, 0x3, PAGE_SIZE);
 		free_page(p);
 		schedule();
-		pr_info("Writing to the buddy page after free\n");
+		pr_info("Attempting bad write to the buddy page after free\n");
 		memset((void *)p, 0x78, PAGE_SIZE);
-		pr_info("Wrote to free page successfully\n");
 		break;
 	}
 	case CT_READ_BUDDY_AFTER_FREE: {
 		unsigned long p = __get_free_page(GFP_KERNEL);
-		int *tmp, *val = kmalloc(1024, GFP_KERNEL);
-		int **base;
+		int saw, *val = kmalloc(1024, GFP_KERNEL);
+		int *base;
 
 		if (!p)
 			break;
@@ -479,15 +492,21 @@ static void lkdtm_do_action(enum ctype which)
 		if (!val)
 			break;
 
-		base = (int **)p;
+		base = (int *)p;
 
 		*val = 0x12345678;
-		pr_info("Value in memory before free: %x\n", *val);
-		base[0] = val;
+		base[0] = *val;
+		pr_info("Value in memory before free: %x\n", base[0]);
 		free_page(p);
-		tmp = base[0];
 		pr_info("Attempting to read from freed memory\n");
-		pr_info("Successfully read value: %x\n", *tmp);
+		saw = base[0];
+		if (saw != *val) {
+			/* Good! Poisoning happened, so declare a win. */
+			pr_info("Buddy page correctly poisoned, calling BUG\n");
+			BUG();
+		}
+		pr_info("Buddy page was not poisoned\n");
+
 		kfree(val);
 		break;
 	}
-- 
2.6.3


-- 
Kees Cook
Chrome OS & Brillo Security
