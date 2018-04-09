From: kpark3469@gmail.com
Subject: [PATCH v3 1/3] stacktrace: move arch_within_stack_frames from thread_info.h
Date: Mon,  9 Apr 2018 15:59:14 +0400
Message-Id: <1523275156-29087-2-git-send-email-kpark3469@gmail.com>
In-Reply-To: <1523275156-29087-1-git-send-email-kpark3469@gmail.com>
References: <1523275156-29087-1-git-send-email-kpark3469@gmail.com>
To: kernel-hardening@lists.openwall.com
Cc: catalin.marinas@arm.com, keescook@chromium.org, will.deacon@arm.com, mark.rutland@arm.com, james.morse@arm.com, panand@redhat.com, keun-o.park@darkmatter.ae, psodagud@codeaurora.org, jpoimboe@redhat.com, mingo@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

From: Sahara <keun-o.park@darkmatter.ae>

Since the inlined arch_within_stack_frames function was placed within
asm/thread_info.h, using stacktrace functions to unwind stack was
restricted. Now in order to have this function use more abundant apis,
it is moved to architecture's stacktrace.c. And, it is changed from
inline to noinline function to clearly have three depth calls like:

do_usercopy_stack()
  copy_[to|from]_user() : inline
    check_copy_size() : inline
      __check_object_size()
        check_stack_object()
          arch_within_stack_frames()

With this change, the x86's implementation was slightly changed also.

Signed-off-by: Sahara <keun-o.park@darkmatter.ae>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/include/asm/thread_info.h | 51 +-------------------------------------
 arch/x86/kernel/Makefile           |  2 +-
 arch/x86/kernel/stacktrace.c       | 49 ++++++++++++++++++++++++++++++++++++
 include/linux/page_ext.h           |  1 -
 include/linux/stacktrace.h         | 24 ++++++++++++++++++
 include/linux/thread_info.h        | 21 ----------------
 mm/usercopy.c                      |  2 +-
 7 files changed, 76 insertions(+), 74 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index a5d9521..e25d70a 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -156,59 +156,10 @@ struct thread_info {
  *
  * preempt_count needs to be 1 initially, until the scheduler is functional.
  */
-#ifndef __ASSEMBLY__
-
-/*
- * Walks up the stack frames to make sure that the specified object is
- * entirely contained by a single stack frame.
- *
- * Returns:
- *	GOOD_FRAME	if within a frame
- *	BAD_STACK	if placed across a frame boundary (or outside stack)
- *	NOT_STACK	unable to determine (no frame pointers, etc)
- */
-static inline int arch_within_stack_frames(const void * const stack,
-					   const void * const stackend,
-					   const void *obj, unsigned long len)
-{
-#if defined(CONFIG_FRAME_POINTER)
-	const void *frame = NULL;
-	const void *oldframe;
-
-	oldframe = __builtin_frame_address(1);
-	if (oldframe)
-		frame = __builtin_frame_address(2);
-	/*
-	 * low ----------------------------------------------> high
-	 * [saved bp][saved ip][args][local vars][saved bp][saved ip]
-	 *                     ^----------------^
-	 *               allow copies only within here
-	 */
-	while (stack <= frame && frame < stackend) {
-		/*
-		 * If obj + len extends past the last frame, this
-		 * check won't pass and the next frame will be 0,
-		 * causing us to bail out and correctly report
-		 * the copy as invalid.
-		 */
-		if (obj + len <= frame)
-			return obj >= oldframe + 2 * sizeof(void *) ?
-				GOOD_FRAME : BAD_STACK;
-		oldframe = frame;
-		frame = *(const void * const *)frame;
-	}
-	return BAD_STACK;
-#else
-	return NOT_STACK;
-#endif
-}
-
-#else /* !__ASSEMBLY__ */
-
+#ifdef __ASSEMBLY__
 #ifdef CONFIG_X86_64
 # define cpu_current_top_of_stack (cpu_tss_rw + TSS_sp1)
 #endif
-
 #endif
 
 #ifdef CONFIG_COMPAT
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 02d6f5c..3b8afd5 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -70,7 +70,7 @@ obj-$(CONFIG_IA32_EMULATION)	+= tls.o
 obj-y				+= step.o
 obj-$(CONFIG_INTEL_TXT)		+= tboot.o
 obj-$(CONFIG_ISA_DMA_API)	+= i8237.o
-obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
+obj-y				+= stacktrace.o
 obj-y				+= cpu/
 obj-y				+= acpi/
 obj-y				+= reboot.o
diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index 093f2ea..ff178a0 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -12,6 +12,54 @@
 #include <asm/stacktrace.h>
 #include <asm/unwind.h>
 
+
+/*
+ * Walks up the stack frames to make sure that the specified object is
+ * entirely contained by a single stack frame.
+ *
+ * Returns:
+ *	GOOD_FRAME	if within a frame
+ *	BAD_STACK	if placed across a frame boundary (or outside stack)
+ *	NOT_STACK	unable to determine (no frame pointers, etc)
+ */
+int arch_within_stack_frames(const void * const stack,
+			     const void * const stackend,
+			     const void *obj, unsigned long len)
+{
+#if defined(CONFIG_FRAME_POINTER)
+	const void *frame = NULL;
+	const void *oldframe;
+
+	oldframe = __builtin_frame_address(2);
+	if (oldframe)
+		frame = __builtin_frame_address(3);
+	/*
+	 * low ----------------------------------------------> high
+	 * [saved bp][saved ip][args][local vars][saved bp][saved ip]
+	 *                     ^----------------^
+	 *               allow copies only within here
+	 */
+	while (stack <= frame && frame < stackend) {
+		/*
+		 * If obj + len extends past the last frame, this
+		 * check won't pass and the next frame will be 0,
+		 * causing us to bail out and correctly report
+		 * the copy as invalid.
+		 */
+		if (obj + len <= frame)
+			return obj >= oldframe + 2 * sizeof(void *) ?
+				GOOD_FRAME : BAD_STACK;
+		oldframe = frame;
+		frame = *(const void * const *)frame;
+	}
+	return BAD_STACK;
+#else
+	return NOT_STACK;
+#endif
+}
+
+#ifdef CONFIG_STACKTRACE
+
 static int save_stack_address(struct stack_trace *trace, unsigned long addr,
 			      bool nosched)
 {
@@ -241,3 +289,4 @@ void save_stack_trace_user(struct stack_trace *trace)
 	if (trace->nr_entries < trace->max_entries)
 		trace->entries[trace->nr_entries++] = ULONG_MAX;
 }
+#endif /* CONFIG_STACKTRACE */
diff --git a/include/linux/page_ext.h b/include/linux/page_ext.h
index ca5461e..f3b7dd9 100644
--- a/include/linux/page_ext.h
+++ b/include/linux/page_ext.h
@@ -3,7 +3,6 @@
 #define __LINUX_PAGE_EXT_H
 
 #include <linux/types.h>
-#include <linux/stacktrace.h>
 #include <linux/stackdepot.h>
 
 struct pglist_data;
diff --git a/include/linux/stacktrace.h b/include/linux/stacktrace.h
index ba29a06..60bb988 100644
--- a/include/linux/stacktrace.h
+++ b/include/linux/stacktrace.h
@@ -7,6 +7,30 @@
 struct task_struct;
 struct pt_regs;
 
+/*
+ * For per-arch arch_within_stack_frames() implementations, defined in
+ * kernel/stacktrace.c.
+ */
+enum {
+	BAD_STACK = -1,
+	NOT_STACK = 0,
+	GOOD_FRAME,
+	GOOD_STACK,
+};
+
+#ifdef CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES
+extern int arch_within_stack_frames(const void * const stack,
+				    const void * const stackend,
+				    const void *obj, unsigned long len);
+#else
+static inline int arch_within_stack_frames(const void * const stack,
+					   const void * const stackend,
+					   const void *obj, unsigned long len)
+{
+	return NOT_STACK;
+}
+#endif
+
 #ifdef CONFIG_STACKTRACE
 struct stack_trace {
 	unsigned int nr_entries, max_entries;
diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index 34f053a..5403851 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -23,18 +23,6 @@
 #endif
 
 #include <linux/bitops.h>
-
-/*
- * For per-arch arch_within_stack_frames() implementations, defined in
- * asm/thread_info.h.
- */
-enum {
-	BAD_STACK = -1,
-	NOT_STACK = 0,
-	GOOD_FRAME,
-	GOOD_STACK,
-};
-
 #include <asm/thread_info.h>
 
 #ifdef __KERNEL__
@@ -92,15 +80,6 @@ static inline int test_ti_thread_flag(struct thread_info *ti, int flag)
 
 #define tif_need_resched() test_thread_flag(TIF_NEED_RESCHED)
 
-#ifndef CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES
-static inline int arch_within_stack_frames(const void * const stack,
-					   const void * const stackend,
-					   const void *obj, unsigned long len)
-{
-	return 0;
-}
-#endif
-
 #ifdef CONFIG_HARDENED_USERCOPY
 extern void __check_object_size(const void *ptr, unsigned long n,
 					bool to_user);
diff --git a/mm/usercopy.c b/mm/usercopy.c
index e9e9325..6a74776 100644
--- a/mm/usercopy.c
+++ b/mm/usercopy.c
@@ -19,7 +19,7 @@
 #include <linux/sched.h>
 #include <linux/sched/task.h>
 #include <linux/sched/task_stack.h>
-#include <linux/thread_info.h>
+#include <linux/stacktrace.h>
 #include <asm/sections.h>
 
 /*
-- 
2.7.4
