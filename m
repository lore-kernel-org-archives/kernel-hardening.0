From: Alexander Popov <alex.popov@linux.com>
Date: Fri, 12 Jan 2018 17:19:27 +0300
Message-Id: <1515766769-9120-5-git-send-email-alex.popov@linux.com>
In-Reply-To: <1515766769-9120-1-git-send-email-alex.popov@linux.com>
References: <1515766769-9120-1-git-send-email-alex.popov@linux.com>
Subject: [kernel-hardening] [PATCH RFC v7 4/6] lkdtm: Add a test for STACKLEAK
To: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, x86@kernel.org, alex.popov@linux.com
List-ID: <kernel-hardening.lists.openwall.com>

Introduce two lkdtm tests for the STACKLEAK feature: STACKLEAK_CHECK_ALLOCA
and STACKLEAK_TRACK_STACK. Both of them check that the current task stack
is properly erased (filled with STACKLEAK_POISON).

STACKLEAK_CHECK_ALLOCA tests that:
 - check_alloca() allows alloca calls which don't exhaust the kernel stack;
 - alloca calls which exhaust/overflow the kernel stack hit BUG() in
    check_alloca().

STACKLEAK_TRACK_STACK tests that exhausting the thread stack with a
recursion hits the guard page provided by CONFIG_VMAP_STACK.

Signed-off-by: Tycho Andersen <tycho@docker.com>
Signed-off-by: Alexander Popov <alex.popov@linux.com>
---
 drivers/misc/Makefile          |   3 +
 drivers/misc/lkdtm.h           |   4 ++
 drivers/misc/lkdtm_core.c      |   2 +
 drivers/misc/lkdtm_stackleak.c | 139 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 148 insertions(+)
 create mode 100644 drivers/misc/lkdtm_stackleak.c

diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 5ca5f64..66c3605 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -63,6 +63,9 @@ lkdtm-$(CONFIG_LKDTM)		+= lkdtm_perms.o
 lkdtm-$(CONFIG_LKDTM)		+= lkdtm_refcount.o
 lkdtm-$(CONFIG_LKDTM)		+= lkdtm_rodata_objcopy.o
 lkdtm-$(CONFIG_LKDTM)		+= lkdtm_usercopy.o
+lkdtm-$(CONFIG_LKDTM)		+= lkdtm_stackleak.o
+
+KASAN_SANITIZE_lkdtm_stackleak.o := n
 
 KCOV_INSTRUMENT_lkdtm_rodata.o	:= n
 
diff --git a/drivers/misc/lkdtm.h b/drivers/misc/lkdtm.h
index 687a0db..2a0cd0d 100644
--- a/drivers/misc/lkdtm.h
+++ b/drivers/misc/lkdtm.h
@@ -83,4 +83,8 @@ void lkdtm_USERCOPY_STACK_FRAME_FROM(void);
 void lkdtm_USERCOPY_STACK_BEYOND(void);
 void lkdtm_USERCOPY_KERNEL(void);
 
+/* lkdtm_stackleak.c */
+void lkdtm_STACKLEAK_CHECK_ALLOCA(void);
+void lkdtm_STACKLEAK_TRACK_STACK(void);
+
 #endif
diff --git a/drivers/misc/lkdtm_core.c b/drivers/misc/lkdtm_core.c
index ba92291..3a22ffa 100644
--- a/drivers/misc/lkdtm_core.c
+++ b/drivers/misc/lkdtm_core.c
@@ -183,6 +183,8 @@ static const struct crashtype crashtypes[] = {
 	CRASHTYPE(USERCOPY_STACK_FRAME_FROM),
 	CRASHTYPE(USERCOPY_STACK_BEYOND),
 	CRASHTYPE(USERCOPY_KERNEL),
+	CRASHTYPE(STACKLEAK_CHECK_ALLOCA),
+	CRASHTYPE(STACKLEAK_TRACK_STACK),
 };
 
 
diff --git a/drivers/misc/lkdtm_stackleak.c b/drivers/misc/lkdtm_stackleak.c
new file mode 100644
index 0000000..1f95ee3
--- /dev/null
+++ b/drivers/misc/lkdtm_stackleak.c
@@ -0,0 +1,139 @@
+/*
+ * This file tests a few aspects of the STACKLEAK feature:
+ *   - the current task stack is properly erased (filled with STACKLEAK_POISON);
+ *   - check_alloca() allows alloca calls which don't exhaust the kernel stack;
+ *   - alloca calls which exhaust/overflow the kernel stack hit BUG() in
+ *    check_alloca();
+ *   - exhausting the thread stack with a recursion is detected: it hits the
+ *    BUG() in track_stack() if CONFIG_VMAP_STACK is not enabled, or hits the
+ *    guard page otherwise.
+ *
+ * Copyright (C) Docker, Inc. 2017
+ *
+ * Authors:
+ *   Tycho Andersen <tycho@docker.com>
+ *   Alexander Popov <alex.popov@linux.com>
+ */
+
+#include "lkdtm.h"
+#include <linux/sched.h>
+#include <linux/compiler.h>
+
+#ifndef CONFIG_GCC_PLUGIN_STACKLEAK
+# define STACKLEAK_POISON -0xBEEF
+# define CONFIG_STACKLEAK_TRACK_MIN_SIZE 100
+#endif
+
+static noinline bool stack_is_erased(void)
+{
+	unsigned long *sp, left, found, i;
+
+	/*
+	 * For the details about the alignment of the poison values, see
+	 * the comment in track_stack().
+	 */
+	sp = PTR_ALIGN(&i, sizeof(unsigned long));
+
+	left = ((unsigned long)sp & (THREAD_SIZE - 1)) / sizeof(unsigned long);
+	sp--;
+
+	/*
+	 * Two unsigned long ints at the bottom of the thread stack are
+	 * reserved and not poisoned.
+	 */
+	if (left <= 2)
+		return false;
+
+	left -= 2;
+	pr_info("checking unused part of the thread stack (%lu bytes)...\n",
+					left * sizeof(unsigned long));
+
+	/* Search for 17 poison values in a row (like erase_kstack() does) */
+	for (i = 0, found = 0; i < left && found < 17; i++) {
+		if (*(sp - i) == STACKLEAK_POISON)
+			found++;
+		else
+			found = 0;
+	}
+
+	if (found < 17) {
+		pr_err("FAIL: thread stack is not erased (checked %lu bytes)\n",
+						i * sizeof(unsigned long));
+		return false;
+	}
+
+	pr_info("first %lu bytes are unpoisoned\n",
+				(i - found) * sizeof(unsigned long));
+
+	/* The rest of thread stack should be erased */
+	for (; i < left; i++) {
+		if (*(sp - i) != STACKLEAK_POISON) {
+			pr_err("FAIL: thread stack is NOT properly erased\n");
+			return false;
+		}
+	}
+
+	pr_info("the rest of the thread stack is properly erased\n");
+	return true;
+}
+
+static noinline void do_alloca(unsigned long size)
+{
+	char buf[size];
+
+	/* So this doesn't get inlined or optimized out */
+	snprintf(buf, size, "hello world\n");
+}
+
+void lkdtm_STACKLEAK_CHECK_ALLOCA(void)
+{
+	unsigned long left = (unsigned long)&left & (THREAD_SIZE - 1);
+
+	if (!stack_is_erased())
+		return;
+
+	/* Try a small alloca to see if it works */
+	pr_info("try a small alloca of 16 bytes...\n");
+	do_alloca(16);
+	pr_info("small alloca is successful\n");
+
+	/* Try to hit the BUG() in check_alloca() */
+	pr_info("try a large alloca of %lu bytes (stack overflow)...\n", left);
+	do_alloca(left);
+	pr_err("FAIL: large alloca overstepped the thread stack boundary\n");
+}
+
+/*
+ * The stack frame size of recursion() is bigger than the
+ * CONFIG_STACKLEAK_TRACK_MIN_SIZE, hence that function is instrumented
+ * by the STACKLEAK gcc plugin and it calls track_stack() at the beginning.
+ */
+static noinline unsigned long recursion(unsigned long prev_sp)
+{
+	char buf[CONFIG_STACKLEAK_TRACK_MIN_SIZE + 42];
+	unsigned long sp = (unsigned long)&sp;
+
+	snprintf(buf, sizeof(buf), "hello world\n");
+
+	if (prev_sp < sp + THREAD_SIZE)
+		sp = recursion(prev_sp);
+
+	return sp;
+}
+
+void lkdtm_STACKLEAK_TRACK_STACK(void)
+{
+	unsigned long sp = (unsigned long)&sp;
+
+	if (!stack_is_erased())
+		return;
+
+	/*
+	 * Exhaust the thread stack with a recursion. It should hit the
+	 * BUG() in track_stack() if CONFIG_VMAP_STACK is not enabled, or
+	 * access the guard page otherwise.
+	 */
+	pr_info("try to exhaust the thread stack with the recursion...\n");
+	pr_err("FAIL: thread stack exhaustion (%lu bytes) is not detected\n",
+							sp - recursion(sp));
+}
-- 
2.7.4
