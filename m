Reply-To: kernel-hardening@lists.openwall.com
From: Laura Abbott <labbott@fedoraproject.org>
Date: Thu, 25 Feb 2016 16:36:43 -0800
Message-Id: <1456447004-21392-3-git-send-email-labbott@fedoraproject.org>
In-Reply-To: <1456447004-21392-1-git-send-email-labbott@fedoraproject.org>
References: <1456447004-21392-1-git-send-email-labbott@fedoraproject.org>
Subject: [kernel-hardening] [PATCH 2/3] lkdtm: Update WRITE_AFTER_FREE test
To: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@fedoraproject.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


The SLUB allocator may use the first word of a freed block to store the
freelist information. This may make it harder to test poisoning
features. Change the WRITE_AFTER_FREE test to better match what
the READ_AFTER_FREE test does and also print out a big more information.

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Laura Abbott <labbott@fedoraproject.org>
---
 drivers/misc/lkdtm.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
index 8de4746..a00a2b1 100644
--- a/drivers/misc/lkdtm.c
+++ b/drivers/misc/lkdtm.c
@@ -411,12 +411,21 @@ static void lkdtm_do_action(enum ctype which)
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
 
-		kfree(data);
-		schedule();
-		memset(data, 0x78, len);
+		base = kmalloc(len, GFP_KERNEL);
+		pr_info("Allocated memory %p-%p\n", base, &base[offset * 2]);
+		kfree(base);
+		pr_info("Attempting bad write to freed memory at %p\n",
+			&base[offset]);
+		base[offset] = 0x0abcdef0;
 		break;
 	}
 	case CT_READ_AFTER_FREE: {
-- 
2.5.0
