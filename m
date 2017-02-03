From: Kees Cook <keescook@chromium.org>
Date: Fri,  3 Feb 2017 15:26:50 -0800
Message-Id: <1486164412-7338-3-git-send-email-keescook@chromium.org>
In-Reply-To: <1486164412-7338-1-git-send-email-keescook@chromium.org>
References: <1486164412-7338-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 2/4] lkdtm: convert to refcount_t testing
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kees Cook <keescook@chromium.org>, elena.reshetova@intel.com, gregkh@linuxfoundation.org, arnd@arndb.de, tglx@linutronix.de, mingo@kernel.org, h.peter.anvin@intel.com, will.deacon@arm.com, dwindsor@gmail.com, Hans Liljestrand <ishkamiel@gmail.com>, dhowells@redhat.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Since we'll be using refcount_t instead of atomic_t for refcounting,
change the LKDTM tests to reflect the new interface and test conditions.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/misc/lkdtm.h      |  8 +++--
 drivers/misc/lkdtm_bugs.c | 87 +++++++++++++++++++++++++++++++++++++++--------
 drivers/misc/lkdtm_core.c |  8 +++--
 3 files changed, 85 insertions(+), 18 deletions(-)

diff --git a/drivers/misc/lkdtm.h b/drivers/misc/lkdtm.h
index cfa1039c62e7..67d27be60405 100644
--- a/drivers/misc/lkdtm.h
+++ b/drivers/misc/lkdtm.h
@@ -19,8 +19,12 @@ void lkdtm_SOFTLOCKUP(void);
 void lkdtm_HARDLOCKUP(void);
 void lkdtm_SPINLOCKUP(void);
 void lkdtm_HUNG_TASK(void);
-void lkdtm_ATOMIC_UNDERFLOW(void);
-void lkdtm_ATOMIC_OVERFLOW(void);
+void lkdtm_REFCOUNT_SATURATE_INC(void);
+void lkdtm_REFCOUNT_SATURATE_ADD(void);
+void lkdtm_REFCOUNT_ZERO_DEC(void);
+void lkdtm_REFCOUNT_ZERO_INC(void);
+void lkdtm_REFCOUNT_ZERO_SUB(void);
+void lkdtm_REFCOUNT_ZERO_ADD(void);
 void lkdtm_CORRUPT_LIST_ADD(void);
 void lkdtm_CORRUPT_LIST_DEL(void);
 
diff --git a/drivers/misc/lkdtm_bugs.c b/drivers/misc/lkdtm_bugs.c
index bb3bb8ef5f44..e3f4cd8876b5 100644
--- a/drivers/misc/lkdtm_bugs.c
+++ b/drivers/misc/lkdtm_bugs.c
@@ -6,6 +6,7 @@
  */
 #include "lkdtm.h"
 #include <linux/list.h>
+#include <linux/refcount.h>
 #include <linux/sched.h>
 
 struct lkdtm_list {
@@ -134,28 +135,86 @@ void lkdtm_HUNG_TASK(void)
 	schedule();
 }
 
-void lkdtm_ATOMIC_UNDERFLOW(void)
+void lkdtm_REFCOUNT_SATURATE_INC(void)
 {
-	atomic_t under = ATOMIC_INIT(INT_MIN);
+	refcount_t over = REFCOUNT_INIT(UINT_MAX - 1);
 
-	pr_info("attempting good atomic increment\n");
-	atomic_inc(&under);
-	atomic_dec(&under);
+	pr_info("attempting good refcount decrement\n");
+	refcount_dec(&over);
+	refcount_inc(&over);
 
-	pr_info("attempting bad atomic underflow\n");
-	atomic_dec(&under);
+	pr_info("attempting bad refcount inc overflow\n");
+	refcount_inc(&over);
+	refcount_inc(&over);
+	if (refcount_read(&over) == UINT_MAX)
+		pr_err("Correctly stayed saturated, but no BUG?!\n");
+	else
+		pr_err("Fail: refcount wrapped\n");
+}
+
+void lkdtm_REFCOUNT_SATURATE_ADD(void)
+{
+	refcount_t over = REFCOUNT_INIT(UINT_MAX - 1);
+
+	pr_info("attempting good refcount decrement\n");
+	refcount_dec(&over);
+	refcount_inc(&over);
+
+	pr_info("attempting bad refcount add overflow\n");
+	refcount_add(2, &over);
+	if (refcount_read(&over) == UINT_MAX)
+		pr_err("Correctly stayed saturated, but no BUG?!\n");
+	else
+		pr_err("Fail: refcount wrapped\n");
+}
+
+void lkdtm_REFCOUNT_ZERO_DEC(void)
+{
+	refcount_t zero = REFCOUNT_INIT(1);
+
+	pr_info("attempting bad refcount decrement to zero\n");
+	refcount_dec(&zero);
+	if (refcount_read(&zero) == 0)
+		pr_err("Stayed at zero, but no BUG?!\n");
+	else
+		pr_err("Fail: refcount went crazy\n");
 }
 
-void lkdtm_ATOMIC_OVERFLOW(void)
+void lkdtm_REFCOUNT_ZERO_SUB(void)
 {
-	atomic_t over = ATOMIC_INIT(INT_MAX);
+	refcount_t zero = REFCOUNT_INIT(1);
+
+	pr_info("attempting bad refcount subtract past zero\n");
+	if (!refcount_sub_and_test(2, &zero))
+		pr_info("wrap attempt was noticed\n");
+	if (refcount_read(&zero) == 1)
+		pr_err("Correctly stayed above 0, but no BUG?!\n");
+	else
+		pr_err("Fail: refcount wrapped\n");
+}
 
-	pr_info("attempting good atomic decrement\n");
-	atomic_dec(&over);
-	atomic_inc(&over);
+void lkdtm_REFCOUNT_ZERO_INC(void)
+{
+	refcount_t zero = REFCOUNT_INIT(0);
 
-	pr_info("attempting bad atomic overflow\n");
-	atomic_inc(&over);
+	pr_info("attempting bad refcount increment from zero\n");
+	refcount_inc(&zero);
+	if (refcount_read(&zero) == 0)
+		pr_err("Stayed at zero, but no BUG?!\n");
+	else
+		pr_err("Fail: refcount went past zero\n");
+}
+
+void lkdtm_REFCOUNT_ZERO_ADD(void)
+{
+	refcount_t zero = REFCOUNT_INIT(0);
+
+	pr_info("attempting bad refcount addition from zero\n");
+	refcount_add(2, &zero);
+	if (refcount_read(&zero) == 0)
+		pr_err("Stayed at zero, but no BUG?!\n");
+	else
+		pr_err("Fail: refcount went past zero\n");
 }
 
 void lkdtm_CORRUPT_LIST_ADD(void)
diff --git a/drivers/misc/lkdtm_core.c b/drivers/misc/lkdtm_core.c
index 4d44084071d8..b9a4cd4a9b68 100644
--- a/drivers/misc/lkdtm_core.c
+++ b/drivers/misc/lkdtm_core.c
@@ -220,8 +220,12 @@ struct crashtype crashtypes[] = {
 	CRASHTYPE(WRITE_RO),
 	CRASHTYPE(WRITE_RO_AFTER_INIT),
 	CRASHTYPE(WRITE_KERN),
-	CRASHTYPE(ATOMIC_UNDERFLOW),
-	CRASHTYPE(ATOMIC_OVERFLOW),
+	CRASHTYPE(REFCOUNT_SATURATE_INC),
+	CRASHTYPE(REFCOUNT_SATURATE_ADD),
+	CRASHTYPE(REFCOUNT_ZERO_DEC),
+	CRASHTYPE(REFCOUNT_ZERO_INC),
+	CRASHTYPE(REFCOUNT_ZERO_SUB),
+	CRASHTYPE(REFCOUNT_ZERO_ADD),
 	CRASHTYPE(USERCOPY_HEAP_SIZE_TO),
 	CRASHTYPE(USERCOPY_HEAP_SIZE_FROM),
 	CRASHTYPE(USERCOPY_HEAP_FLAG_TO),
-- 
2.7.4
