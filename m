From: kpark3469@gmail.com
Subject: [PATCH 2/4] arm64: usercopy: implement arch_within_stack_frames
Date: Thu,  1 Mar 2018 14:19:49 +0400
Message-Id: <1519899591-29761-3-git-send-email-kpark3469@gmail.com>
In-Reply-To: <1519899591-29761-2-git-send-email-kpark3469@gmail.com>
References: <1519899591-29761-1-git-send-email-kpark3469@gmail.com>
 <1519899591-29761-2-git-send-email-kpark3469@gmail.com>
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, james.morse@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, mark.rutland@arm.com, keun-o.park@darkmatter.ae
List-ID: <kernel-hardening.lists.openwall.com>

From: James Morse <james.morse@arm.com>

This implements arch_within_stack_frames() for arm64 that should
validate if a given object is contained by a kernel stack frame.

Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Sahara <keun-o.park@darkmatter.ae>
---
 arch/arm64/Kconfig             |  1 +
 arch/arm64/kernel/stacktrace.c | 76 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 77 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 5361287..b6c3b52 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -127,6 +127,7 @@ config ARM64
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
+	select HAVE_ARCH_WITHIN_STACK_FRAMES
 	select IOMMU_DMA if IOMMU_SUPPORT
 	select IRQ_DOMAIN
 	select IRQ_FORCED_THREADING
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index fbc366d..6d37fad 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -26,6 +26,11 @@
 #include <asm/irq.h>
 #include <asm/stack_pointer.h>
 
+#define FAKE_FRAME(frame, my_func) do {				\
+	frame.fp = (unsigned long)__builtin_frame_address(0);	\
+	frame.pc = (unsigned long)my_func;			\
+} while (0)
+
 /*
  * AArch64 PCS assigns the frame pointer to x29.
  *
@@ -94,6 +99,77 @@ void notrace walk_stackframe(struct task_struct *tsk, struct stackframe *frame,
 	}
 }
 
+struct check_frame_arg {
+	unsigned long obj_start;
+	unsigned long obj_end;
+	unsigned long frame_start;
+	int discard_frames;
+	int err;
+};
+
+static int check_frame(struct stackframe *frame, void *d)
+{
+	struct check_frame_arg *arg = d;
+	unsigned long frame_end = frame->fp;
+
+	/* object overlaps multiple frames */
+	if (arg->obj_start < frame->fp && frame->fp < arg->obj_end) {
+		arg->err = BAD_STACK;
+		return 1;
+	}
+
+	/*
+	 * Discard frames and check object is in a frame written early
+	 * enough.
+	 */
+	if (arg->discard_frames)
+		arg->discard_frames--;
+	else if ((arg->frame_start <= arg->obj_start &&
+			arg->obj_start < frame_end) &&
+		(arg->frame_start < arg->obj_end && arg->obj_end <= frame_end))
+		return 1;
+
+	/* object exists in a previous frame */
+	if (arg->obj_end < arg->frame_start) {
+		arg->err = BAD_STACK;
+		return 1;
+	}
+
+	arg->frame_start = frame_end + 0x10;
+
+	return 0;
+}
+
+/* Check obj doesn't overlap a stack frame record */
+int arch_within_stack_frames(const void *stack,
+			     const void *stack_end,
+			     const void *obj, unsigned long obj_len)
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
+	arg.frame_start = frame.fp;
+
+	/*
+	 * Skip 4 non-inlined frames: <fake frame>,
+	 * arch_within_stack_frames(), check_stack_object() and
+	 * __check_object_size().
+	 */
+	arg.discard_frames = 4;
+
+	walk_stackframe(current, &frame, check_frame, &arg);
+
+	return arg.err;
+}
+
 #ifdef CONFIG_STACKTRACE
 struct stack_trace_data {
 	struct stack_trace *trace;
-- 
2.7.4
