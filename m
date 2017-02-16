From: James Morse <james.morse@arm.com>
Date: Thu, 16 Feb 2017 18:29:16 +0000
Message-Id: <20170216182917.19637-3-james.morse@arm.com>
In-Reply-To: <20170216182917.19637-1-james.morse@arm.com>
References: <20170216182917.19637-1-james.morse@arm.com>
Subject: [kernel-hardening] [PATCH v4 2/3] arm64: Add arch_within_stack_frames() for hardened usercopy
To: kernel-hardening@lists.openwall.com
Cc: linux-arm-kernel@lists.infradead.org, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, keescook@chromium.org, Mark Rutland <mark.rutland@arm.com>, panand@redhat.com, keun-o.park@darkmatter.ae
List-ID: <kernel-hardening.lists.openwall.com>

Hardened usercopy tests that an object being copied to/from userspace
doesn't overlap multiple stack frames.

Add arch_within_stack_frames() to do this using arm64's stackwalker. The
callback looks for 'fp' appearing with the range occupied by the object.

(This isn't enough to trip the lkdtm tests on arm64)

CC: Sahara <keun-o.park@darkmatter.ae>
Based-on-a-patch-from: Sahara <keun-o.park@darkmatter.ae>
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/Kconfig                   |  1 +
 arch/arm64/include/asm/thread_info.h |  7 ++++-
 arch/arm64/kernel/stacktrace.c       | 54 ++++++++++++++++++++++++++++++++++--
 3 files changed, 58 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 111742126897..378caa9c0563 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -67,6 +67,7 @@ config ARM64
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	select HAVE_ARM_SMCCC
+	select HAVE_ARCH_WITHIN_STACK_FRAMES
 	select HAVE_EBPF_JIT
 	select HAVE_C_RECORDMCOUNT
 	select HAVE_CC_STACKPROTECTOR
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 46c3b93cf865..3540c46027fc 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -68,7 +68,12 @@ struct thread_info {
 #define thread_saved_fp(tsk)	\
 	((unsigned long)(tsk->thread.cpu_context.fp))
 
-#endif
+
+extern enum stack_type arch_within_stack_frames(const void * const stack,
+						const void * const stackend,
+						const void *obj,
+						unsigned long len);
+#endif /* !__ASSEMBLY__ */
 
 /*
  * thread information flags:
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 8a552a33c6ef..5591f325729e 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -25,6 +25,12 @@
 #include <asm/stack_pointer.h>
 #include <asm/stacktrace.h>
 
+#define FAKE_FRAME(frame, my_func) do {			\
+	frame.fp = (unsigned long)__builtin_frame_address(0);	\
+	frame.sp = current_stack_pointer;		\
+	frame.pc = (unsigned long)my_func;		\
+} while (0)
+
 /*
  * AArch64 PCS assigns the frame pointer to x29.
  *
@@ -194,9 +200,7 @@ void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
 		frame.pc = thread_saved_pc(tsk);
 	} else {
 		data.no_sched_functions = 0;
-		frame.fp = (unsigned long)__builtin_frame_address(0);
-		frame.sp = current_stack_pointer;
-		frame.pc = (unsigned long)save_stack_trace_tsk;
+		FAKE_FRAME(frame, save_stack_trace_tsk);
 	}
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	frame.graph = tsk->curr_ret_stack;
@@ -215,3 +219,47 @@ void save_stack_trace(struct stack_trace *trace)
 }
 EXPORT_SYMBOL_GPL(save_stack_trace);
 #endif
+
+struct check_frame_arg {
+	unsigned long obj_start;
+	unsigned long obj_end;
+	int err;
+};
+
+static int check_frame(struct stackframe *frame, void *d)
+{
+	struct check_frame_arg *arg = d;
+
+	/* object overlaps multiple frames */
+	if (arg->obj_start < (frame->fp + 0x10) && frame->fp < arg->obj_end) {
+		arg->err = BAD_STACK;
+		return 1;
+	}
+
+	/* walked past the object */
+	if (arg->obj_end < frame->fp)
+		return 1;
+
+	return 0;
+}
+
+/* Check obj doesn't overlap a stack frame record */
+enum stack_type arch_within_stack_frames(const void *stack,
+					 const void *stack_end,
+					 const void *obj, unsigned long obj_len)
+{
+	struct stackframe frame;
+	struct check_frame_arg arg;
+
+	if (!IS_ENABLED(CONFIG_FRAME_POINTER))
+		return NOT_STACK;
+
+	arg.err = GOOD_FRAME;
+	arg.obj_start = (unsigned long)obj;
+	arg.obj_end = arg.obj_start + obj_len;
+
+	FAKE_FRAME(frame, arch_within_stack_frames);
+	walk_stackframe(current, &frame, check_frame, &arg);
+
+	return arg.err;
+}
-- 
2.10.1
