From: kpark3469@gmail.com
Date: Thu,  2 Feb 2017 16:50:22 +0400
Message-Id: <1486039824-8470-1-git-send-email-kpark3469@gmail.com>
Subject: [kernel-hardening] [PATCH v2 1/3] usercopy: create usercopy.h and move enum stack_type
To: kernel-hardening@lists.openwall.com
Cc: catalin.marinas@arm.com, keescook@chromium.org, will.deacon@arm.com, mark.rutland@arm.com, james.morse@arm.com, panand@redhat.com, keun-o.park@darkmatter.ae
List-ID: <kernel-hardening.lists.openwall.com>

From: Sahara <keun-o.park@darkmatter.ae>

This patch creates linux/usercopy.h and moves the enum which is
only used in usercopy.c so as to make it usable to x86 and other
architecture's thread_info.h, which may have arch_within_stack_frames().

Signed-off-by: Sahara <keun-o.park@darkmatter.ae>
Suggested-by: James Morse <james.morse@arm.com>
---
 arch/x86/include/asm/thread_info.h | 20 +++++++++++---------
 include/linux/usercopy.h           | 11 +++++++++++
 mm/usercopy.c                      |  8 +-------
 3 files changed, 23 insertions(+), 16 deletions(-)
 create mode 100644 include/linux/usercopy.h

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index ad6f5eb0..c991126 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -51,6 +51,7 @@
 struct task_struct;
 #include <asm/cpufeature.h>
 #include <linux/atomic.h>
+#include <linux/usercopy.h>
 
 struct thread_info {
 	unsigned long		flags;		/* low level flags */
@@ -168,13 +169,13 @@ static inline unsigned long current_stack_pointer(void)
  * entirely contained by a single stack frame.
  *
  * Returns:
- *		 1 if within a frame
- *		-1 if placed across a frame boundary (or outside stack)
- *		 0 unable to determine (no frame pointers, etc)
+ *	GOOD_FRAME	if within a frame
+ *	BAD_STACK	if placed across a frame boundary (or outside stack)
+ *	NOT_STACK	unable to determine (no frame pointers, etc)
  */
-static inline int arch_within_stack_frames(const void * const stack,
-					   const void * const stackend,
-					   const void *obj, unsigned long len)
+static inline enum stack_type arch_within_stack_frames(const void * const stack,
+					const void * const stackend,
+					const void *obj, unsigned long len)
 {
 #if defined(CONFIG_FRAME_POINTER)
 	const void *frame = NULL;
@@ -197,13 +198,14 @@ static inline int arch_within_stack_frames(const void * const stack,
 		 * the copy as invalid.
 		 */
 		if (obj + len <= frame)
-			return obj >= oldframe + 2 * sizeof(void *) ? 1 : -1;
+			return obj >= oldframe + 2 * sizeof(void *) ?
+				GOOD_FRAME : BAD_STACK;
 		oldframe = frame;
 		frame = *(const void * const *)frame;
 	}
-	return -1;
+	return BAD_STACK;
 #else
-	return 0;
+	return NOT_STACK;
 #endif
 }
 
diff --git a/include/linux/usercopy.h b/include/linux/usercopy.h
new file mode 100644
index 0000000..974859e
--- /dev/null
+++ b/include/linux/usercopy.h
@@ -0,0 +1,11 @@
+#ifndef __LINUX_USERCOPY_H
+#define __LINUX_USERCOPY_H
+
+enum stack_type {
+	BAD_STACK = -1,
+	NOT_STACK = 0,
+	GOOD_FRAME,
+	GOOD_STACK,
+};
+
+#endif
diff --git a/mm/usercopy.c b/mm/usercopy.c
index 3c8da0a..ee7bced 100644
--- a/mm/usercopy.c
+++ b/mm/usercopy.c
@@ -16,15 +16,9 @@
 
 #include <linux/mm.h>
 #include <linux/slab.h>
+#include <linux/usercopy.h>
 #include <asm/sections.h>
 
-enum {
-	BAD_STACK = -1,
-	NOT_STACK = 0,
-	GOOD_FRAME,
-	GOOD_STACK,
-};
-
 /*
  * Checks if a given pointer and length is contained by the current
  * stack frame (if possible).
-- 
2.7.4
