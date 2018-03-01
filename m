From: kpark3469@gmail.com
Subject: [PATCH 1/4] stacktrace: move arch_within_stack_frames from thread_info.h
Date: Thu,  1 Mar 2018 14:19:48 +0400
Message-Id: <1519899591-29761-2-git-send-email-kpark3469@gmail.com>
In-Reply-To: <1519899591-29761-1-git-send-email-kpark3469@gmail.com>
References: <1519899591-29761-1-git-send-email-kpark3469@gmail.com>
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, james.morse@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, mark.rutland@arm.com, keun-o.park@darkmatter.ae
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
And, linux/stacktrace.h includes asm/stacktrace.h from now on.

Signed-off-by: Sahara <keun-o.park@darkmatter.ae>
---
 arch/arm/kernel/stacktrace.c       |  1 -
 arch/arm64/kernel/stacktrace.c     |  1 -
 arch/cris/kernel/stacktrace.c      |  1 -
 arch/metag/kernel/stacktrace.c     |  2 --
 arch/mips/kernel/stacktrace.c      |  1 -
 arch/sh/kernel/stacktrace.c        |  1 -
 arch/sparc/kernel/stacktrace.c     |  1 -
 arch/um/kernel/stacktrace.c        |  1 -
 arch/unicore32/kernel/process.c    |  1 -
 arch/unicore32/kernel/stacktrace.c |  2 --
 arch/x86/include/asm/thread_info.h | 51 +-------------------------------------
 arch/x86/kernel/Makefile           |  2 +-
 arch/x86/kernel/stacktrace.c       | 50 ++++++++++++++++++++++++++++++++++++-
 arch/xtensa/kernel/stacktrace.c    |  1 -
 include/linux/page_ext.h           |  1 -
 include/linux/stacktrace.h         | 25 +++++++++++++++++++
 include/linux/thread_info.h        | 21 ----------------
 kernel/sysctl.c                    |  1 -
 mm/usercopy.c                      |  2 +-
 19 files changed, 77 insertions(+), 89 deletions(-)

diff --git a/arch/arm/kernel/stacktrace.c b/arch/arm/kernel/stacktrace.c
index a56e7c8..d7d629b 100644
--- a/arch/arm/kernel/stacktrace.c
+++ b/arch/arm/kernel/stacktrace.c
@@ -4,7 +4,6 @@
 #include <linux/stacktrace.h>
 
 #include <asm/sections.h>
-#include <asm/stacktrace.h>
 #include <asm/traps.h>
 
 #if defined(CONFIG_FRAME_POINTER) && !defined(CONFIG_ARM_UNWIND)
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 76809cc..fbc366d 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -25,7 +25,6 @@
 
 #include <asm/irq.h>
 #include <asm/stack_pointer.h>
-#include <asm/stacktrace.h>
 
 /*
  * AArch64 PCS assigns the frame pointer to x29.
diff --git a/arch/cris/kernel/stacktrace.c b/arch/cris/kernel/stacktrace.c
index f1cc3aa..aae4196 100644
--- a/arch/cris/kernel/stacktrace.c
+++ b/arch/cris/kernel/stacktrace.c
@@ -1,7 +1,6 @@
 #include <linux/sched.h>
 #include <linux/sched/debug.h>
 #include <linux/stacktrace.h>
-#include <asm/stacktrace.h>
 
 void walk_stackframe(unsigned long sp,
 		     int (*fn)(unsigned long addr, void *data),
diff --git a/arch/metag/kernel/stacktrace.c b/arch/metag/kernel/stacktrace.c
index 09d67b7..9502a29 100644
--- a/arch/metag/kernel/stacktrace.c
+++ b/arch/metag/kernel/stacktrace.c
@@ -4,8 +4,6 @@
 #include <linux/sched/task_stack.h>
 #include <linux/stacktrace.h>
 
-#include <asm/stacktrace.h>
-
 #if defined(CONFIG_FRAME_POINTER)
 
 #ifdef CONFIG_KALLSYMS
diff --git a/arch/mips/kernel/stacktrace.c b/arch/mips/kernel/stacktrace.c
index 7c7c902..0b44e10 100644
--- a/arch/mips/kernel/stacktrace.c
+++ b/arch/mips/kernel/stacktrace.c
@@ -8,7 +8,6 @@
 #include <linux/sched/task_stack.h>
 #include <linux/stacktrace.h>
 #include <linux/export.h>
-#include <asm/stacktrace.h>
 
 /*
  * Save stack-backtrace addresses into a stack_trace buffer:
diff --git a/arch/sh/kernel/stacktrace.c b/arch/sh/kernel/stacktrace.c
index 7a73d27..7a7ac4c 100644
--- a/arch/sh/kernel/stacktrace.c
+++ b/arch/sh/kernel/stacktrace.c
@@ -16,7 +16,6 @@
 #include <linux/module.h>
 #include <asm/unwinder.h>
 #include <asm/ptrace.h>
-#include <asm/stacktrace.h>
 
 static int save_stack_stack(void *data, char *name)
 {
diff --git a/arch/sparc/kernel/stacktrace.c b/arch/sparc/kernel/stacktrace.c
index be4c14c..42cdf86 100644
--- a/arch/sparc/kernel/stacktrace.c
+++ b/arch/sparc/kernel/stacktrace.c
@@ -5,7 +5,6 @@
 #include <linux/ftrace.h>
 #include <linux/export.h>
 #include <asm/ptrace.h>
-#include <asm/stacktrace.h>
 
 #include "kstack.h"
 
diff --git a/arch/um/kernel/stacktrace.c b/arch/um/kernel/stacktrace.c
index ebe7bcf..a0d556e 100644
--- a/arch/um/kernel/stacktrace.c
+++ b/arch/um/kernel/stacktrace.c
@@ -14,7 +14,6 @@
 #include <linux/stacktrace.h>
 #include <linux/module.h>
 #include <linux/uaccess.h>
-#include <asm/stacktrace.h>
 
 void dump_trace(struct task_struct *tsk,
 		const struct stacktrace_ops *ops,
diff --git a/arch/unicore32/kernel/process.c b/arch/unicore32/kernel/process.c
index 2bc10b8..ffca651 100644
--- a/arch/unicore32/kernel/process.c
+++ b/arch/unicore32/kernel/process.c
@@ -36,7 +36,6 @@
 
 #include <asm/cacheflush.h>
 #include <asm/processor.h>
-#include <asm/stacktrace.h>
 
 #include "setup.h"
 
diff --git a/arch/unicore32/kernel/stacktrace.c b/arch/unicore32/kernel/stacktrace.c
index 9976e76..f9cd2a4 100644
--- a/arch/unicore32/kernel/stacktrace.c
+++ b/arch/unicore32/kernel/stacktrace.c
@@ -14,8 +14,6 @@
 #include <linux/sched/debug.h>
 #include <linux/stacktrace.h>
 
-#include <asm/stacktrace.h>
-
 #if defined(CONFIG_FRAME_POINTER)
 /*
  * Unwind the current stack frame and store the new register values in the
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
index 29786c8..3a906c3 100644
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
index 093f2ea..f433a33 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -9,9 +9,56 @@
 #include <linux/stacktrace.h>
 #include <linux/export.h>
 #include <linux/uaccess.h>
-#include <asm/stacktrace.h>
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
@@ -241,3 +288,4 @@ void save_stack_trace_user(struct stack_trace *trace)
 	if (trace->nr_entries < trace->max_entries)
 		trace->entries[trace->nr_entries++] = ULONG_MAX;
 }
+#endif /* CONFIG_STACKTRACE */
diff --git a/arch/xtensa/kernel/stacktrace.c b/arch/xtensa/kernel/stacktrace.c
index 0df4080..ab831d8 100644
--- a/arch/xtensa/kernel/stacktrace.c
+++ b/arch/xtensa/kernel/stacktrace.c
@@ -12,7 +12,6 @@
 #include <linux/sched.h>
 #include <linux/stacktrace.h>
 
-#include <asm/stacktrace.h>
 #include <asm/traps.h>
 #include <linux/uaccess.h>
 
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
index ba29a06..4fd061e 100644
--- a/include/linux/stacktrace.h
+++ b/include/linux/stacktrace.h
@@ -3,10 +3,35 @@
 #define __LINUX_STACKTRACE_H
 
 #include <linux/types.h>
+#include <asm/stacktrace.h>
 
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
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 2fb4e27..a1ee965 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -73,7 +73,6 @@
 
 #ifdef CONFIG_X86
 #include <asm/nmi.h>
-#include <asm/stacktrace.h>
 #include <asm/io.h>
 #endif
 #ifdef CONFIG_SPARC
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
