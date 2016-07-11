Reply-To: kernel-hardening@lists.openwall.com
From: Andy Lutomirski <luto@kernel.org>
Date: Mon, 11 Jul 2016 13:53:41 -0700
Message-Id: <4a1d5fa16a28b32509ece3611690be48a8746778.1468270393.git.luto@kernel.org>
In-Reply-To: <cover.1468270393.git.luto@kernel.org>
References: <cover.1468270393.git.luto@kernel.org>
In-Reply-To: <cover.1468270393.git.luto@kernel.org>
References: <cover.1468270393.git.luto@kernel.org>
Subject: [kernel-hardening] [PATCH v5 08/32] dma-api: Teach the "DMA-from-stack" check about vmapped stacks
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>
List-ID: <kernel-hardening.lists.openwall.com>

If we're using CONFIG_VMAP_STACK and we manage to point an sg entry
at the stack, then either the sg page will be in highmem or sg_virt
will return the direct-map alias.  In neither case will the existing
check_for_stack() implementation realize that it's a stack page.

Fix it by explicitly checking for stack pages.

This has no effect by itself.  It's broken out for ease of review.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 lib/dma-debug.c | 39 +++++++++++++++++++++++++++++++++------
 1 file changed, 33 insertions(+), 6 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 51a76af25c66..5b2e63cba90e 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -22,6 +22,7 @@
 #include <linux/stacktrace.h>
 #include <linux/dma-debug.h>
 #include <linux/spinlock.h>
+#include <linux/vmalloc.h>
 #include <linux/debugfs.h>
 #include <linux/uaccess.h>
 #include <linux/export.h>
@@ -1162,11 +1163,35 @@ static void check_unmap(struct dma_debug_entry *ref)
 	put_hash_bucket(bucket, &flags);
 }
 
-static void check_for_stack(struct device *dev, void *addr)
+static void check_for_stack(struct device *dev,
+			    struct page *page, size_t offset)
 {
-	if (object_is_on_stack(addr))
-		err_printk(dev, NULL, "DMA-API: device driver maps memory from "
-				"stack [addr=%p]\n", addr);
+	void *addr;
+	struct vm_struct *stack_vm_area = task_stack_vm_area(current);
+
+	if (!stack_vm_area) {
+		/* Stack is direct-mapped. */
+		if (PageHighMem(page))
+			return;
+		addr = page_address(page) + offset;
+		if (object_is_on_stack(addr))
+			err_printk(dev, NULL, "DMA-API: device driver maps memory from stack [addr=%p]\n",
+				   addr);
+	} else {
+		/* Stack is vmalloced. */
+		int i;
+
+		for (i = 0; i < stack_vm_area->nr_pages; i++) {
+			if (page != stack_vm_area->pages[i])
+				continue;
+
+			addr = (u8 *)current->stack + i * PAGE_SIZE +
+				offset;
+			err_printk(dev, NULL, "DMA-API: device driver maps memory from stack [probable addr=%p]\n",
+				   addr);
+			break;
+		}
+	}
 }
 
 static inline bool overlap(void *addr, unsigned long len, void *start, void *end)
@@ -1289,10 +1314,11 @@ void debug_dma_map_page(struct device *dev, struct page *page, size_t offset,
 	if (map_single)
 		entry->type = dma_debug_single;
 
+	check_for_stack(dev, page, offset);
+
 	if (!PageHighMem(page)) {
 		void *addr = page_address(page) + offset;
 
-		check_for_stack(dev, addr);
 		check_for_illegal_area(dev, addr, size);
 	}
 
@@ -1384,8 +1410,9 @@ void debug_dma_map_sg(struct device *dev, struct scatterlist *sg,
 		entry->sg_call_ents   = nents;
 		entry->sg_mapped_ents = mapped_ents;
 
+		check_for_stack(dev, sg_page(s), s->offset);
+
 		if (!PageHighMem(sg_page(s))) {
-			check_for_stack(dev, sg_virt(s));
 			check_for_illegal_area(dev, sg_virt(s), sg_dma_len(s));
 		}
 
-- 
2.7.4
