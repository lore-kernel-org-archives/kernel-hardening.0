From: Alexander Popov <alex.popov@linux.com>
Subject: [PATCH v13 (resend) 4/6] lkdtm: Add a test for STACKLEAK
Date: Fri, 22 Jun 2018 19:58:35 +0300
Message-Id: <1529686717-16017-5-git-send-email-alex.popov@linux.com>
In-Reply-To: <1529686717-16017-1-git-send-email-alex.popov@linux.com>
References: <1529686717-16017-1-git-send-email-alex.popov@linux.com>
To: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, Florian Weimer <fweimer@redhat.com>, Boris Lukashev <blukashev@sempervictus.com>, Andrey Konovalov <andreyknvl@google.com>, x86@kernel.org, linux-kernel@vger.kernel.org, alex.popov@linux.com
List-ID: <kernel-hardening.lists.openwall.com>

Introduce lkdtm tests for the STACKLEAK feature.

First, all of them check that the current task stack is properly erased
(filled with STACKLEAK_POISON).

STACKLEAK_DEEP_RECURSION tests that exhausting the current task stack
with deep recursion is detected by CONFIG_VMAP_STACK (which is implied
by CONFIG_GCC_PLUGIN_STACKLEAK).

STACKLEAK_BIG_ALLOCA and STACKLEAK_RECURSION_WITH_ALLOCA test that
alloca calls which overflow the kernel stack hit BUG()/panic() in
stackleak_check_alloca().

Signed-off-by: Alexander Popov <alex.popov@linux.com>
Signed-off-by: Tycho Andersen <tycho@tycho.ws>
---
 drivers/misc/lkdtm/Makefile    |   2 +
 drivers/misc/lkdtm/core.c      |   3 +
 drivers/misc/lkdtm/lkdtm.h     |   5 ++
 drivers/misc/lkdtm/stackleak.c | 146 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 156 insertions(+)
 create mode 100644 drivers/misc/lkdtm/stackleak.c

diff --git a/drivers/misc/lkdtm/Makefile b/drivers/misc/lkdtm/Makefile
index 3370a41..951c984 100644
--- a/drivers/misc/lkdtm/Makefile
+++ b/drivers/misc/lkdtm/Makefile
@@ -8,7 +8,9 @@ lkdtm-$(CONFIG_LKDTM)		+= perms.o
 lkdtm-$(CONFIG_LKDTM)		+= refcount.o
 lkdtm-$(CONFIG_LKDTM)		+= rodata_objcopy.o
 lkdtm-$(CONFIG_LKDTM)		+= usercopy.o
+lkdtm-$(CONFIG_LKDTM)		+= stackleak.o
 
+KASAN_SANITIZE_stackleak.o	:= n
 KCOV_INSTRUMENT_rodata.o	:= n
 
 OBJCOPYFLAGS :=
diff --git a/drivers/misc/lkdtm/core.c b/drivers/misc/lkdtm/core.c
index 2154d1b..9d0324a 100644
--- a/drivers/misc/lkdtm/core.c
+++ b/drivers/misc/lkdtm/core.c
@@ -183,6 +183,9 @@ static const struct crashtype crashtypes[] = {
 	CRASHTYPE(USERCOPY_STACK_FRAME_FROM),
 	CRASHTYPE(USERCOPY_STACK_BEYOND),
 	CRASHTYPE(USERCOPY_KERNEL),
+	CRASHTYPE(STACKLEAK_BIG_ALLOCA),
+	CRASHTYPE(STACKLEAK_DEEP_RECURSION),
+	CRASHTYPE(STACKLEAK_RECURSION_WITH_ALLOCA),
 };
 
 
diff --git a/drivers/misc/lkdtm/lkdtm.h b/drivers/misc/lkdtm/lkdtm.h
index 9e513dc..865a6c3 100644
--- a/drivers/misc/lkdtm/lkdtm.h
+++ b/drivers/misc/lkdtm/lkdtm.h
@@ -83,4 +83,9 @@ void lkdtm_USERCOPY_STACK_FRAME_FROM(void);
 void lkdtm_USERCOPY_STACK_BEYOND(void);
 void lkdtm_USERCOPY_KERNEL(void);
 
+/* lkdtm_stackleak.c */
+void lkdtm_STACKLEAK_BIG_ALLOCA(void);
+void lkdtm_STACKLEAK_DEEP_RECURSION(void);
+void lkdtm_STACKLEAK_RECURSION_WITH_ALLOCA(void);
+
 #endif
diff --git a/drivers/misc/lkdtm/stackleak.c b/drivers/misc/lkdtm/stackleak.c
new file mode 100644
index 0000000..38963ff
--- /dev/null
+++ b/drivers/misc/lkdtm/stackleak.c
@@ -0,0 +1,146 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * This code tests several aspects of the STACKLEAK feature:
+ *  - the current task stack is properly erased (filled with STACKLEAK_POISON);
+ *  - exhausting the current task stack with deep recursion is detected by
+ *     CONFIG_VMAP_STACK (which is implied by CONFIG_GCC_PLUGIN_STACKLEAK);
+ *  - alloca calls which overflow the kernel stack hit BUG()/panic() in
+ *     stackleak_check_alloca().
+ *
+ * Authors:
+ *   Alexander Popov <alex.popov@linux.com>
+ *   Tycho Andersen <tycho@tycho.ws>
+ */
+
+#include "lkdtm.h"
+#include <linux/stackleak.h>
+
+static noinline bool stack_is_erased(void)
+{
+	unsigned long *sp, left, found, i;
+	const unsigned long check_depth = STACKLEAK_POISON_CHECK_DEPTH /
+							sizeof(unsigned long);
+
+	/*
+	 * For the details about the alignment of the poison values, see
+	 * the comment in stackleak_track_stack().
+	 */
+	sp = PTR_ALIGN(&i, sizeof(unsigned long));
+
+	left = ((unsigned long)sp & (THREAD_SIZE - 1)) / sizeof(unsigned long);
+	sp--;
+
+	/*
+	 * One 'long int' at the bottom of the thread stack is reserved
+	 * and not poisoned.
+	 */
+	if (left > 1)
+		left--;
+	else
+		return false;
+
+	pr_info("checking unused part of the thread stack (%lu bytes)...\n",
+					left * sizeof(unsigned long));
+
+	/*
+	 * Search for 'check_depth' poison values in a row (just like
+	 * stackleak_erase_kstack() does).
+	 */
+	for (i = 0, found = 0; i < left && found <= check_depth; i++) {
+		if (*(sp - i) == STACKLEAK_POISON)
+			found++;
+		else
+			found = 0;
+	}
+
+	if (found <= check_depth) {
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
+	snprintf(buf, size, "testing alloca...\n");
+}
+
+void lkdtm_STACKLEAK_BIG_ALLOCA(void)
+{
+	if (!stack_is_erased())
+		return;
+
+	pr_info("try a small alloca of 16 bytes...\n");
+	do_alloca(16);
+	pr_info("small alloca is successful\n");
+
+	pr_info("try alloca over the thread stack boundary...\n");
+	do_alloca(THREAD_SIZE);
+	pr_err("FAIL: alloca over the thread stack boundary is not detected\n");
+}
+
+static noinline unsigned long recursion(unsigned long prev_sp, bool with_alloca)
+{
+	char buf[400];
+	unsigned long sp = (unsigned long)&sp;
+
+	snprintf(buf, sizeof(buf), "testing deep recursion...\n");
+
+	if (with_alloca)
+		do_alloca(400);
+
+	if (prev_sp < sp + THREAD_SIZE)
+		sp = recursion(prev_sp, with_alloca);
+
+	return sp;
+}
+
+void lkdtm_STACKLEAK_DEEP_RECURSION(void)
+{
+	unsigned long sp = (unsigned long)&sp;
+
+	if (!stack_is_erased())
+		return;
+
+	/*
+	 * Overflow the thread stack using deep recursion. It should hit the
+	 * guard page provided by CONFIG_VMAP_STACK (which is implied by
+	 * CONFIG_GCC_PLUGIN_STACKLEAK).
+	 */
+	pr_info("try to overflow the thread stack using deep recursion...\n");
+	pr_err("FAIL: stack depth overflow (%lu bytes) is not detected\n",
+							sp - recursion(sp, 0));
+}
+
+void lkdtm_STACKLEAK_RECURSION_WITH_ALLOCA(void)
+{
+	unsigned long sp = (unsigned long)&sp;
+
+	if (!stack_is_erased())
+		return;
+
+	/*
+	 * Overflow the thread stack using deep recursion with alloca.
+	 * It should hit BUG()/panic() in stackleak_check_alloca().
+	 */
+	pr_info("try to overflow the thread stack using recursion & alloca\n");
+	recursion(sp, 1);
+	pr_err("FAIL: stack depth overflow is not detected\n");
+}
-- 
2.7.4
