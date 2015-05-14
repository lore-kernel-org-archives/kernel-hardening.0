Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Thu, 14 May 2015 14:07:48 +0300
From: Vasily Kulikov <segoon@openwall.com>
Message-ID: <20150514110748.GA23454@cachalot>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [RFC] pointer poisoning macro
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, Randy Dunlap <rdunlap@xenotime.net>
List-ID: <kernel-hardening.lists.openwall.com>

This is a raw version of the patch inspired by the discussion:
http://www.openwall.com/lists/oss-security/2015/05/02/6.

The patch tries to achieve two goals:
1) Move "overflowed" poison pointers out of the mmap'able memory zone
2) Simplify addition of new poison pointers

The current 0x00200200 poison pointer value of LIST_POISON2 might be
too big for mmap_min_addr values equal or less than 2 MB (common case,
e.g. Ubuntu uses only 0x10000).  There is little point to use such a big
value given the "poison pointer space" below 2 MB is not yet exhausted.
Changing it to a smaller value solves the problem for small
mmap_min_addr setups.

In general, poisoned pointers should meet the following criteria:

1) poisoned pointer base must be non-mmap'able (already done via
CONFIG_ILLEGAL_POINTER_VALUE)
2) all poisoned pointers (i.e. base+offset) must be non-mmap'able
3) a small offset relative to poisoned pointers must be non-mmap'able
4) poisoned pointers from different subsystems should be different

(2) can be solved at the compile time by BUILD_BUG_ON().
(3) and (4) should be solved by a creator of the new poisoned pointer.

At least (2) can be done automatically.  I propose a new macro for this
purpose, POISON_POINTER().  It should check whether the poison pointer
offset is not too big.  E.g. in case of too big offset the compilation
fails with the following message:

    mm/page_alloc.c: In function 'free_pages_prepare':
    mm/page_alloc.c:840:23: error: call to '__compiletime_assert_840' declared with attribute error: BUILD_BUG_ON failed: 0x0111400 >= POISON_AREA_SIZE

There is still an unsolved issue with the macro related to
static variables initialization.  If you uncomment the line just after
"FIXME" line, you'll see:

    kernel/irq/spurious.c:23:8: error: braced-group within expression allowed only inside a function

I'll be happy with the comments to the idea and the implementation.

diff --git a/include/linux/poison.h b/include/linux/poison.h
index 7b2a7fc..47b43ed 100644
--- a/include/linux/poison.h
+++ b/include/linux/poison.h
@@ -1,40 +1,54 @@
 #ifndef _LINUX_POISON_H
 #define _LINUX_POISON_H
+#include <linux/bug.h>
 
 /********** include/linux/list.h **********/
 
 /*
  * Architectures might want to move the poison pointer offset
  * into some well-recognized area such as 0xdead000000000000,
- * that is also not mappable by user-space exploits:
+ * that is also not mappable by user-space exploits,
+ * by adjusting CONFIG_ILLEGAL_POINTER_VALUE:
  */
 #ifdef CONFIG_ILLEGAL_POINTER_VALUE
 # define POISON_POINTER_DELTA _AC(CONFIG_ILLEGAL_POINTER_VALUE, UL)
 #else
 # define POISON_POINTER_DELTA 0
 #endif
+/* 
+ * Poisoned pointers of different subsystems should be different
+ * but must not move far away from POISON_POINTER_DELTA.
+ * Otherwise poisoned pointer might be mmap'able on some architectures.
+ */
+#define POISON_AREA_SIZE 0x1000
+#define POISON_POINTER(x) \
+	({ \
+		BUILD_BUG_ON(x >= POISON_AREA_SIZE); \
+       	((void *)(x) + POISON_POINTER_DELTA);})
 
 /*
  * These are non-NULL pointers that will result in page faults
  * under normal circumstances, used to verify that nobody uses
  * non-initialized list entries.
  */
-#define LIST_POISON1  ((void *) 0x00100100 + POISON_POINTER_DELTA)
-#define LIST_POISON2  ((void *) 0x00200200 + POISON_POINTER_DELTA)
+#define LIST_POISON1  POISON_POINTER(0x0100)
+#define LIST_POISON2  POISON_POINTER(0x0200)
 
 /********** include/linux/timer.h **********/
 /*
  * Magic number "tsta" to indicate a static timer initializer
  * for the object debugging code.
  */
-#define TIMER_ENTRY_STATIC	((void *) 0x74737461)
+#define TIMER_ENTRY_STATIC	((void*)0x0300 + POISON_POINTER_DELTA)
+// FIXME
+//#define TIMER_ENTRY_STATIC	POISON_POINTER(0x0300)
 
 /********** mm/debug-pagealloc.c **********/
 #define PAGE_POISON 0xaa
 
 /********** mm/page_alloc.c ************/
 
-#define TAIL_MAPPING	((void *) 0x01014A11 + POISON_POINTER_DELTA)
+#define TAIL_MAPPING	POISON_POINTER(0x400)
 
 /********** mm/slab.c **********/
 /*

-- 
Vasily
