From: kpark3469@gmail.com
Date: Sun,  5 Feb 2017 16:14:09 +0400
Message-Id: <1486296850-16045-2-git-send-email-kpark3469@gmail.com>
In-Reply-To: <1486296850-16045-1-git-send-email-kpark3469@gmail.com>
References: <1486296850-16045-1-git-send-email-kpark3469@gmail.com>
Subject: [kernel-hardening] [PATCH v3 2/3] arm64: usercopy: Implement stack frame object validation
To: kernel-hardening@lists.openwall.com
Cc: catalin.marinas@arm.com, keescook@chromium.org, will.deacon@arm.com, mark.rutland@arm.com, james.morse@arm.com, panand@redhat.com, keun-o.park@darkmatter.ae
List-ID: <kernel-hardening.lists.openwall.com>

From: Sahara <keun-o.park@darkmatter.ae>

This implements arch_within_stack_frames() for arm64 that should
validate if a given object is contained by a kernel stack frame.

Signed-off-by: Sahara <keun-o.park@darkmatter.ae>
Reviewed-by: James Morse <james.morse@arm.com>
---
 arch/arm64/Kconfig                   |  1 +
 arch/arm64/include/asm/thread_info.h | 64 ++++++++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+)

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
index 46c3b93..70baad3 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -68,7 +68,71 @@ struct thread_info {
 #define thread_saved_fp(tsk)	\
 	((unsigned long)(tsk->thread.cpu_context.fp))
 
+#define get_stack_start(fp) (fp + 2 * sizeof(void *))
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
+
+static inline enum stack_type arch_within_stack_frames(const void * const stack,
+					const void * const stackend,
+					const void *obj, unsigned long len)
+{
+#ifdef CONFIG_FRAME_POINTER
+	const void *callee_fp = NULL;
+	const void *caller_fp = NULL;
+
+	callee_fp = __builtin_frame_address(1);
+	if (callee_fp)
+		caller_fp = *(const void * const *)callee_fp;
+	/*
+	 * Case #1:
+	 * low ----------------------------------------------> high
+	 * [callee_fp][lr][args][local vars][caller_fp'][lr']
+	 *                ^----------------^
+	 *               allow copies only within here
+	 *
+	 * Case #2:
+	 * low ----------------------------------------------> high
+	 * [check_object_size_fp][lr][args][local vars][callee_fp][lr]
+	 *                           ^----------------^
+	 *                     dynamically allocated stack variable of
+	 *                     callee frame copies are allowed within here
+	 *
+	 * < example code snippet for Case#2 >
+	 * array_size = get_random_int() & 0x0f;
+	 * if (to_user) {
+	 *         unsigned char array[array_size];
+	 *         if (copy_to_user((void __user *)user_addr, array,
+	 *                          unconst + sizeof(array))) {
+	 */
+	while (stack <= callee_fp && callee_fp < stackend &&
+			!((unsigned long)caller_fp & 0xf)) {
+		/*
+		 * If obj + len extends past the caller frame, this
+		 * check won't pass and the next frame will be 0,
+		 * causing us to bail out and correctly report
+		 * the copy as invalid.
+		 */
+		if (!caller_fp || (obj + len <= caller_fp))
+			return (obj >= get_stack_start(callee_fp)) ?
+				GOOD_FRAME : BAD_STACK;
+		callee_fp = caller_fp;
+		caller_fp = *(const void * const *)caller_fp;
+	}
+	return BAD_STACK;
+#else
+	return NOT_STACK;
 #endif
+}
+
+#endif /* !__ASSEMBLY__ */
 
 /*
  * thread information flags:
-- 
2.7.4
