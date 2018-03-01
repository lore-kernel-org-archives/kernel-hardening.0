From: kpark3469@gmail.com
Subject: [PATCH 4/4] x86: usercopy: reimplement arch_within_stack_frames with unwinder
Date: Thu,  1 Mar 2018 14:19:51 +0400
Message-Id: <1519899591-29761-5-git-send-email-kpark3469@gmail.com>
In-Reply-To: <1519899591-29761-4-git-send-email-kpark3469@gmail.com>
References: <1519899591-29761-1-git-send-email-kpark3469@gmail.com>
 <1519899591-29761-2-git-send-email-kpark3469@gmail.com>
 <1519899591-29761-3-git-send-email-kpark3469@gmail.com>
 <1519899591-29761-4-git-send-email-kpark3469@gmail.com>
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, james.morse@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, mark.rutland@arm.com, keun-o.park@darkmatter.ae
List-ID: <kernel-hardening.lists.openwall.com>

From: Sahara <keun-o.park@darkmatter.ae>

The old arch_within_stack_frames which used the frame pointer is
now reimplemented to use frame pointer unwinder apis. So the main
functionality is same as before.

Signed-off-by: Sahara <keun-o.park@darkmatter.ae>
---
 arch/x86/include/asm/unwind.h  |  5 +++
 arch/x86/kernel/stacktrace.c   | 77 +++++++++++++++++++++++++++++-------------
 arch/x86/kernel/unwind_frame.c |  4 +--
 3 files changed, 60 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/unwind.h b/arch/x86/include/asm/unwind.h
index 1f86e1b..6f04906f 100644
--- a/arch/x86/include/asm/unwind.h
+++ b/arch/x86/include/asm/unwind.h
@@ -87,6 +87,11 @@ void unwind_init(void);
 void unwind_module_init(struct module *mod, void *orc_ip, size_t orc_ip_size,
 			void *orc, size_t orc_size);
 #else
+#ifdef CONFIG_UNWINDER_FRAME_POINTER
+#define FRAME_HEADER_SIZE (sizeof(long) * 2)
+size_t regs_size(struct pt_regs *regs);
+#endif
+
 static inline void unwind_init(void) {}
 static inline
 void unwind_module_init(struct module *mod, void *orc_ip, size_t orc_ip_size,
diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index f433a33..c26eb55 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -12,6 +12,37 @@
 #include <asm/unwind.h>
 
 
+static inline void *get_cur_frame(struct unwind_state *state)
+{
+	void *frame = NULL;
+
+#if defined(CONFIG_UNWINDER_ORC)
+#elif defined(CONFIG_UNWINDER_FRAME_POINTER)
+	if (state->regs)
+		frame = (void *)state->regs;
+	else
+		frame = (void *)state->bp;
+#else
+#endif
+	return frame;
+}
+
+static inline void *get_frame_end(struct unwind_state *state)
+{
+	void *frame_end = NULL;
+
+#if defined(CONFIG_UNWINDER_ORC)
+#elif defined(CONFIG_UNWINDER_FRAME_POINTER)
+	if (state->regs) {
+		frame_end = (void *)state->regs + regs_size(state->regs);
+	} else {
+		frame_end = (void *)state->bp + FRAME_HEADER_SIZE;
+	}
+#else
+#endif
+	return frame_end;
+}
+
 /*
  * Walks up the stack frames to make sure that the specified object is
  * entirely contained by a single stack frame.
@@ -25,31 +56,31 @@ int arch_within_stack_frames(const void * const stack,
 			     const void * const stackend,
 			     const void *obj, unsigned long len)
 {
-#if defined(CONFIG_FRAME_POINTER)
-	const void *frame = NULL;
-	const void *oldframe;
-
-	oldframe = __builtin_frame_address(2);
-	if (oldframe)
-		frame = __builtin_frame_address(3);
+#if defined(CONFIG_UNWINDER_FRAME_POINTER)
+	struct unwind_state state;
+	void *prev_frame_end = NULL;
 	/*
-	 * low ----------------------------------------------> high
-	 * [saved bp][saved ip][args][local vars][saved bp][saved ip]
-	 *                     ^----------------^
-	 *               allow copies only within here
+	 * Skip 3 non-inlined frames: arch_within_stack_frames(),
+	 * check_stack_object() and __check_object_size().
+	 *
 	 */
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
+	unsigned int discard_frames = 3;
+
+	for (unwind_start(&state, current, NULL, NULL); !unwind_done(&state);
+	     unwind_next_frame(&state)) {
+		if (discard_frames) {
+			discard_frames--;
+		} else {
+			void *frame = get_cur_frame(&state);
+
+			if (!frame || !prev_frame_end)
+				return NOT_STACK;
+			if (obj + len <= frame)
+				return obj >= prev_frame_end ?
+						GOOD_FRAME : BAD_STACK;
+		}
+		/* save current frame end before move to next frame */
+		prev_frame_end = get_frame_end(&state);
 	}
 	return BAD_STACK;
 #else
diff --git a/arch/x86/kernel/unwind_frame.c b/arch/x86/kernel/unwind_frame.c
index 3dc26f9..c8bfa5c 100644
--- a/arch/x86/kernel/unwind_frame.c
+++ b/arch/x86/kernel/unwind_frame.c
@@ -8,8 +8,6 @@
 #include <asm/stacktrace.h>
 #include <asm/unwind.h>
 
-#define FRAME_HEADER_SIZE (sizeof(long) * 2)
-
 unsigned long unwind_get_return_address(struct unwind_state *state)
 {
 	if (unwind_done(state))
@@ -69,7 +67,7 @@ static void unwind_dump(struct unwind_state *state)
 	}
 }
 
-static size_t regs_size(struct pt_regs *regs)
+size_t regs_size(struct pt_regs *regs)
 {
 	/* x86_32 regs from kernel mode are two words shorter: */
 	if (IS_ENABLED(CONFIG_X86_32) && !user_mode(regs))
-- 
2.7.4
