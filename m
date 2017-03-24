Date: Fri, 24 Mar 2017 10:51:25 -0700
From: Kees Cook <keescook@chromium.org>
Message-ID: <20170324175125.GA108985@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [PATCH v2] lkdtm: add bad USER_DS test
To: Thomas Garnier <thgarnie@google.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

This adds CORRUPT_USER_DS to check that the get_fs() test on syscall
return (via __VERIFY_PRE_USERMODE_STATE) still sees USER_DS. Since
trying to deal with values other than USER_DS and KERNEL_DS across all
architectures in a safe way is not sensible, this sets KERNEL_DS, but
since that could be extremely dangerous if the protection is not present,
it also raises SIGKILL for current, so that no matter what, the process
will die. A successful test will be visible with a BUG(), like all the
other LKDTM tests.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/misc/lkdtm.h      |  1 +
 drivers/misc/lkdtm_bugs.c | 11 +++++++++++
 drivers/misc/lkdtm_core.c |  1 +
 3 files changed, 13 insertions(+)

diff --git a/drivers/misc/lkdtm.h b/drivers/misc/lkdtm.h
index 67d27be60405..3b4976396ec4 100644
--- a/drivers/misc/lkdtm.h
+++ b/drivers/misc/lkdtm.h
@@ -27,6 +27,7 @@ void lkdtm_REFCOUNT_ZERO_SUB(void);
 void lkdtm_REFCOUNT_ZERO_ADD(void);
 void lkdtm_CORRUPT_LIST_ADD(void);
 void lkdtm_CORRUPT_LIST_DEL(void);
+void lkdtm_CORRUPT_USER_DS(void);
 
 /* lkdtm_heap.c */
 void lkdtm_OVERWRITE_ALLOCATION(void);
diff --git a/drivers/misc/lkdtm_bugs.c b/drivers/misc/lkdtm_bugs.c
index e3f4cd8876b5..ed4f4c56c796 100644
--- a/drivers/misc/lkdtm_bugs.c
+++ b/drivers/misc/lkdtm_bugs.c
@@ -8,6 +8,8 @@
 #include <linux/list.h>
 #include <linux/refcount.h>
 #include <linux/sched.h>
+#include <linux/sched/signal.h>
+#include <linux/uaccess.h>
 
 struct lkdtm_list {
 	struct list_head node;
@@ -279,3 +281,12 @@ void lkdtm_CORRUPT_LIST_DEL(void)
 	else
 		pr_err("list_del() corruption not detected!\n");
 }
+
+void lkdtm_CORRUPT_USER_DS(void)
+{
+	pr_info("setting bad task size limit\n");
+	set_fs(KERNEL_DS);
+
+	/* Make sure we do not keep running with a KERNEL_DS! */
+	force_sig(SIGKILL, current);
+}
diff --git a/drivers/misc/lkdtm_core.c b/drivers/misc/lkdtm_core.c
index b9a4cd4a9b68..42d2b8e31e6b 100644
--- a/drivers/misc/lkdtm_core.c
+++ b/drivers/misc/lkdtm_core.c
@@ -199,6 +199,7 @@ struct crashtype crashtypes[] = {
 	CRASHTYPE(OVERFLOW),
 	CRASHTYPE(CORRUPT_LIST_ADD),
 	CRASHTYPE(CORRUPT_LIST_DEL),
+	CRASHTYPE(CORRUPT_USER_DS),
 	CRASHTYPE(CORRUPT_STACK),
 	CRASHTYPE(UNALIGNED_LOAD_STORE_WRITE),
 	CRASHTYPE(OVERWRITE_ALLOCATION),
-- 
2.7.4


-- 
Kees Cook
Pixel Security
