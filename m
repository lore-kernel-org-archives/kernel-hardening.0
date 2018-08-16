From: Alexander Popov <alex.popov@linux.com>
Subject: [PATCH v15 3/7] lkdtm: Add a test for STACKLEAK
Date: Fri, 17 Aug 2018 01:17:00 +0300
Message-Id: <1534457824-7211-4-git-send-email-alex.popov@linux.com>
In-Reply-To: <1534457824-7211-1-git-send-email-alex.popov@linux.com>
References: <1534457824-7211-1-git-send-email-alex.popov@linux.com>
To: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, Florian Weimer <fweimer@redhat.com>, Boris Lukashev <blukashev@sempervictus.com>, Andrey Konovalov <andreyknvl@google.com>, x86@kernel.org, linux-kernel@vger.kernel.org, alex.popov@linux.com
List-ID: <kernel-hardening.lists.openwall.com>

Introduce an lkdtm test for the STACKLEAK feature: check that the
current task stack is properly erased (filled with STACKLEAK_POISON).

Signed-off-by: Alexander Popov <alex.popov@linux.com>
Signed-off-by: Tycho Andersen <tycho@tycho.ws>
---
 drivers/misc/lkdtm/Makefile    |  2 ++
 drivers/misc/lkdtm/core.c      |  1 +
 drivers/misc/lkdtm/lkdtm.h     |  3 ++
 drivers/misc/lkdtm/stackleak.c | 73 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 79 insertions(+)
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
index 2154d1b..aca26d8 100644
--- a/drivers/misc/lkdtm/core.c
+++ b/drivers/misc/lkdtm/core.c
@@ -183,6 +183,7 @@ static const struct crashtype crashtypes[] = {
 	CRASHTYPE(USERCOPY_STACK_FRAME_FROM),
 	CRASHTYPE(USERCOPY_STACK_BEYOND),
 	CRASHTYPE(USERCOPY_KERNEL),
+	CRASHTYPE(STACKLEAK_ERASING),
 };
 
 
diff --git a/drivers/misc/lkdtm/lkdtm.h b/drivers/misc/lkdtm/lkdtm.h
index 9e513dc..b611b15 100644
--- a/drivers/misc/lkdtm/lkdtm.h
+++ b/drivers/misc/lkdtm/lkdtm.h
@@ -83,4 +83,7 @@ void lkdtm_USERCOPY_STACK_FRAME_FROM(void);
 void lkdtm_USERCOPY_STACK_BEYOND(void);
 void lkdtm_USERCOPY_KERNEL(void);
 
+/* lkdtm_stackleak.c */
+void lkdtm_STACKLEAK_ERASING(void);
+
 #endif
diff --git a/drivers/misc/lkdtm/stackleak.c b/drivers/misc/lkdtm/stackleak.c
new file mode 100644
index 0000000..d5a0844
--- /dev/null
+++ b/drivers/misc/lkdtm/stackleak.c
@@ -0,0 +1,73 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * This code tests that the current task stack is properly erased (filled
+ * with STACKLEAK_POISON).
+ *
+ * Authors:
+ *   Alexander Popov <alex.popov@linux.com>
+ *   Tycho Andersen <tycho@tycho.ws>
+ */
+
+#include "lkdtm.h"
+#include <linux/stackleak.h>
+
+void lkdtm_STACKLEAK_ERASING(void)
+{
+	unsigned long *sp, left, found, i;
+	const unsigned long check_depth =
+			STACKLEAK_SEARCH_DEPTH / sizeof(unsigned long);
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
+	if (left > 1) {
+		left--;
+	} else {
+		pr_err("FAIL: not enough stack space for the test\n");
+		return;
+	}
+
+	pr_info("checking unused part of the thread stack (%lu bytes)...\n",
+					left * sizeof(unsigned long));
+
+	/*
+	 * Search for 'check_depth' poison values in a row (just like
+	 * stackleak_erase() does).
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
+		return;
+	}
+
+	pr_info("first %lu bytes are unpoisoned\n",
+				(i - found) * sizeof(unsigned long));
+
+	/* The rest of thread stack should be erased */
+	for (; i < left; i++) {
+		if (*(sp - i) != STACKLEAK_POISON) {
+			pr_err("FAIL: thread stack is NOT properly erased\n");
+			return;
+		}
+	}
+
+	pr_info("OK: the rest of the thread stack is properly erased\n");
+	return;
+}
-- 
2.7.4
