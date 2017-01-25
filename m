From: kpark3469@gmail.com
Date: Wed, 25 Jan 2017 17:46:23 +0400
Message-Id: <1485351983-13873-1-git-send-email-kpark3469@gmail.com>
Subject: [kernel-hardening] [PATCH] arm64: usercopy: Implement stack frame object validation
To: kernel-hardening@lists.openwall.com
Cc: catalin.marinas@arm.com, keescook@chromium.org, will.deacon@arm.com, mark.rutland@arm.com, james.morse@arm.com, panand@redhat.com, keun-o.park@darkmatter.ae
List-ID: <kernel-hardening.lists.openwall.com>

From: Sahara <keun-o.park@darkmatter.ae>

This implements arch_within_stack_frames() for arm64 that should
validate if a given object is contained by a kernel stack frame.

Signed-off-by: Sahara <keun-o.park@darkmatter.ae>
---
 arch/arm64/Kconfig                   |  1 +
 arch/arm64/include/asm/thread_info.h | 55 ++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 1117421..8bf70b4 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -97,6 +97,7 @@ config ARM64
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES if HAVE_KPROBES
+	select HAVE_ARCH_WITHIN_STACK_FRAMES
 	select IOMMU_DMA if IOMMU_SUPPORT
 	select IRQ_DOMAIN
 	select IRQ_FORCED_THREADING
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 46c3b93..f610c44 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -68,7 +68,62 @@ struct thread_info {
 #define thread_saved_fp(tsk)	\
 	((unsigned long)(tsk->thread.cpu_context.fp))
 
+/*
+ * Walks up the stack frames to make sure that the specified object is
+ * entirely contained by a single stack frame.
+ *
+ * Returns:
+ *		 1 if within a frame
+ *		-1 if placed across a frame boundary (or outside stack)
+ *		 0 unable to determine (no frame pointers, etc)
+ */
+static inline int arch_within_stack_frames(const void * const stack,
+					   const void * const stackend,
+					   const void *obj, unsigned long len)
+{
+#if defined(CONFIG_FRAME_POINTER)
+	const void *oldframe;
+	const void *callee_fp = NULL;
+	const void *caller_fp = NULL;
+
+	oldframe = __builtin_frame_address(1);
+	if (oldframe) {
+		callee_fp = __builtin_frame_address(2);
+		if (callee_fp)
+			caller_fp = __builtin_frame_address(3);
+	}
+	/*
+	 * low ----------------------------------------------> high
+	 * [callee_fp][lr][args][local vars][caller_fp'][lr']
+	 *                ^----------------^
+	 *               allow copies only within here
+	 */
+	while (stack <= callee_fp && callee_fp < stackend) {
+		/*
+		 * If obj + len extends past the caller frame, this
+		 * check won't pass and the next frame will be 0,
+		 * causing us to bail out and correctly report
+		 * the copy as invalid.
+		 */
+		if (!caller_fp) {
+			if (obj + len <= stackend)
+				return (obj >= callee_fp + 2 * sizeof(void *)) ?
+					1 : -1;
+			else
+				return -1;
+		}
+		if (obj + len <= caller_fp)
+			return (obj >= callee_fp + 2 * sizeof(void *)) ? 1 : -1;
+		callee_fp = caller_fp;
+		caller_fp = *(const void * const *)caller_fp;
+	}
+	return -1;
+#else
+	return 0;
 #endif
+}
+
+#endif /* !__ASSEMBLY__ */
 
 /*
  * thread information flags:
-- 
2.7.4
