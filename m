Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Wed, 17 Aug 2016 14:42:12 -0700
Message-Id: <1471470132-29499-6-git-send-email-keescook@chromium.org>
In-Reply-To: <1471470132-29499-1-git-send-email-keescook@chromium.org>
References: <1471470132-29499-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v3 5/5] lkdtm: Add tests for struct list corruption
To: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Daniel Micay <danielmicay@gmail.com>, Joe Perches <joe@perches.com>, Stephen Boyd <sboyd@codeaurora.org>, Syed Rameez Mustafa <rameezmustafa@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Josh Triplett <josh@joshtriplett.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Michael Ellerman <mpe@ellerman.id.au>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Thomas Gleixner <tglx@linutronix.de>, Josef Bacik <jbacik@fb.com>, Ingo Molnar <mingo@kernel.org>, Tejun Heo <tj@kernel.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Nikolay Aleksandrov <nikolay@cumulusnetworks.com>, Dmitry Vyukov <dvyukov@google.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

When building under CONFIG_DEBUG_LIST, list addition and removal will be
sanity-checked. This validates that the check is working as expected by
setting up classic corruption attacks against list manipulations, available
with the new lkdtm tests CORRUPT_LIST_ADD and CORRUPT_LIST_DEL.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/misc/lkdtm.h      |  2 ++
 drivers/misc/lkdtm_bugs.c | 68 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/misc/lkdtm_core.c |  2 ++
 3 files changed, 72 insertions(+)

diff --git a/drivers/misc/lkdtm.h b/drivers/misc/lkdtm.h
index fdf954c2107f..cfa1039c62e7 100644
--- a/drivers/misc/lkdtm.h
+++ b/drivers/misc/lkdtm.h
@@ -21,6 +21,8 @@ void lkdtm_SPINLOCKUP(void);
 void lkdtm_HUNG_TASK(void);
 void lkdtm_ATOMIC_UNDERFLOW(void);
 void lkdtm_ATOMIC_OVERFLOW(void);
+void lkdtm_CORRUPT_LIST_ADD(void);
+void lkdtm_CORRUPT_LIST_DEL(void);
 
 /* lkdtm_heap.c */
 void lkdtm_OVERWRITE_ALLOCATION(void);
diff --git a/drivers/misc/lkdtm_bugs.c b/drivers/misc/lkdtm_bugs.c
index 182ae1894b32..f336206d4b1f 100644
--- a/drivers/misc/lkdtm_bugs.c
+++ b/drivers/misc/lkdtm_bugs.c
@@ -5,8 +5,13 @@
  * test source files.
  */
 #include "lkdtm.h"
+#include <linux/list.h>
 #include <linux/sched.h>
 
+struct lkdtm_list {
+	struct list_head node;
+};
+
 /*
  * Make sure our attempts to over run the kernel stack doesn't trigger
  * a compiler warning when CONFIG_FRAME_WARN is set. Then make sure we
@@ -146,3 +151,66 @@ void lkdtm_ATOMIC_OVERFLOW(void)
 	pr_info("attempting bad atomic overflow\n");
 	atomic_inc(&over);
 }
+
+void lkdtm_CORRUPT_LIST_ADD(void)
+{
+	/*
+	 * Initially, an empty list via LIST_HEAD:
+	 *	test_head.next = &test_head
+	 *	test_head.prev = &test_head
+	 */
+	LIST_HEAD(test_head);
+	struct lkdtm_list good, bad;
+	void *target[2] = { };
+	void *redirection = &target;
+
+	pr_info("attempting good list addition\n");
+
+	/*
+	 * Adding to the list performs these actions:
+	 *	test_head.next->prev = &good.node
+	 *	good.node.next = test_head.next
+	 *	good.node.prev = test_head
+	 *	test_head.next = good.node
+	 */
+	list_add(&good.node, &test_head);
+
+	pr_info("attempting corrupted list addition\n");
+	/*
+	 * In simulating this "write what where" primitive, the "what" is
+	 * the address of &bad.node, and the "where" is the address held
+	 * by "redirection".
+	 */
+	test_head.next = redirection;
+	list_add(&bad.node, &test_head);
+
+	if (target[0] == NULL && target[1] == NULL)
+		pr_err("Overwrite did not happen, but no BUG?!\n");
+	else
+		pr_err("list_add() corruption not detected!\n");
+}
+
+void lkdtm_CORRUPT_LIST_DEL(void)
+{
+	LIST_HEAD(test_head);
+	struct lkdtm_list item;
+	void *target[2] = { };
+	void *redirection = &target;
+
+	list_add(&item.node, &test_head);
+
+	pr_info("attempting good list removal\n");
+	list_del(&item.node);
+
+	pr_info("attempting corrupted list removal\n");
+	list_add(&item.node, &test_head);
+
+	/* As with the list_add() test above, this corrupts "next". */
+	item.node.next = redirection;
+	list_del(&item.node);
+
+	if (target[0] == NULL && target[1] == NULL)
+		pr_err("Overwrite did not happen, but no BUG?!\n");
+	else
+		pr_err("list_del() corruption not detected!\n");
+}
diff --git a/drivers/misc/lkdtm_core.c b/drivers/misc/lkdtm_core.c
index f9154b8d67f6..7eeb71a75549 100644
--- a/drivers/misc/lkdtm_core.c
+++ b/drivers/misc/lkdtm_core.c
@@ -197,6 +197,8 @@ struct crashtype crashtypes[] = {
 	CRASHTYPE(EXCEPTION),
 	CRASHTYPE(LOOP),
 	CRASHTYPE(OVERFLOW),
+	CRASHTYPE(CORRUPT_LIST_ADD),
+	CRASHTYPE(CORRUPT_LIST_DEL),
 	CRASHTYPE(CORRUPT_STACK),
 	CRASHTYPE(UNALIGNED_LOAD_STORE_WRITE),
 	CRASHTYPE(OVERWRITE_ALLOCATION),
-- 
2.7.4
