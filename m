Date: Mon, 7 Aug 2017 13:39:48 -0700
From: Kees Cook <keescook@chromium.org>
Message-ID: <20170807203948.GA22298@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [PATCH] lkdtm: Test VMAP_STACK allocates leading/trailing guard pages
To: linux-kernel@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>, ard.biesheuvel@linaro.org, catalin.marinas@arm.com, james.morse@arm.com, labbott@redhat.com, luto@amacapital.net, matt@codeblueprint.co.uk, will.deacon@arm.com, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org
List-ID: <kernel-hardening.lists.openwall.com>

Two new tests STACK_GUARD_PAGE_LEADING and STACK_GUARD_PAGE_TRAILING
attempt to read the byte before and after, respectively, of the current
stack frame, which should fault under VMAP_STACK.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
Do these tests both trip with the new arm64 VMAP_STACK code?
---
 drivers/misc/lkdtm.h      |  2 ++
 drivers/misc/lkdtm_bugs.c | 30 ++++++++++++++++++++++++++++++
 drivers/misc/lkdtm_core.c |  2 ++
 3 files changed, 34 insertions(+)

diff --git a/drivers/misc/lkdtm.h b/drivers/misc/lkdtm.h
index 063f5d651076..3c8627ca5f42 100644
--- a/drivers/misc/lkdtm.h
+++ b/drivers/misc/lkdtm.h
@@ -22,6 +22,8 @@ void lkdtm_HUNG_TASK(void);
 void lkdtm_CORRUPT_LIST_ADD(void);
 void lkdtm_CORRUPT_LIST_DEL(void);
 void lkdtm_CORRUPT_USER_DS(void);
+void lkdtm_STACK_GUARD_PAGE_LEADING(void);
+void lkdtm_STACK_GUARD_PAGE_TRAILING(void);
 
 /* lkdtm_heap.c */
 void lkdtm_OVERWRITE_ALLOCATION(void);
diff --git a/drivers/misc/lkdtm_bugs.c b/drivers/misc/lkdtm_bugs.c
index ef3d06f901fc..041fe6e9532a 100644
--- a/drivers/misc/lkdtm_bugs.c
+++ b/drivers/misc/lkdtm_bugs.c
@@ -8,6 +8,7 @@
 #include <linux/list.h>
 #include <linux/sched.h>
 #include <linux/sched/signal.h>
+#include <linux/sched/task_stack.h>
 #include <linux/uaccess.h>
 
 struct lkdtm_list {
@@ -199,6 +200,7 @@ void lkdtm_CORRUPT_LIST_DEL(void)
 		pr_err("list_del() corruption not detected!\n");
 }
 
+/* Test if unbalanced set_fs(KERNEL_DS)/set_fs(USER_DS) check exists. */
 void lkdtm_CORRUPT_USER_DS(void)
 {
 	pr_info("setting bad task size limit\n");
@@ -207,3 +209,31 @@ void lkdtm_CORRUPT_USER_DS(void)
 	/* Make sure we do not keep running with a KERNEL_DS! */
 	force_sig(SIGKILL, current);
 }
+
+/* Test that VMAP_STACK is actually allocating with a leading guard page */
+void lkdtm_STACK_GUARD_PAGE_LEADING(void)
+{
+	const unsigned char *stack = task_stack_page(current);
+	const unsigned char *ptr = stack - 1;
+	volatile unsigned char byte;
+
+	pr_info("attempting bad read from page below current stack\n");
+
+	byte = *ptr;
+
+	pr_err("FAIL: accessed page before stack!\n");
+}
+
+/* Test that VMAP_STACK is actually allocating with a trailing guard page */
+void lkdtm_STACK_GUARD_PAGE_TRAILING(void)
+{
+	const unsigned char *stack = task_stack_page(current);
+	const unsigned char *ptr = stack + THREAD_SIZE;
+	volatile unsigned char byte;
+
+	pr_info("attempting bad read from page above current stack\n");
+
+	byte = *ptr;
+
+	pr_err("FAIL: accessed page after stack!\n");
+}
diff --git a/drivers/misc/lkdtm_core.c b/drivers/misc/lkdtm_core.c
index 51decc07eeda..9e98d7ef5503 100644
--- a/drivers/misc/lkdtm_core.c
+++ b/drivers/misc/lkdtm_core.c
@@ -201,6 +201,8 @@ struct crashtype crashtypes[] = {
 	CRASHTYPE(CORRUPT_LIST_DEL),
 	CRASHTYPE(CORRUPT_USER_DS),
 	CRASHTYPE(CORRUPT_STACK),
+	CRASHTYPE(STACK_GUARD_PAGE_LEADING),
+	CRASHTYPE(STACK_GUARD_PAGE_TRAILING),
 	CRASHTYPE(UNALIGNED_LOAD_STORE_WRITE),
 	CRASHTYPE(OVERWRITE_ALLOCATION),
 	CRASHTYPE(WRITE_AFTER_FREE),
-- 
2.7.4


-- 
Kees Cook
Pixel Security
