From: Kees Cook <keescook@chromium.org>
Date: Mon,  6 Mar 2017 11:09:46 -0800
Message-Id: <1488827386-87193-7-git-send-email-keescook@chromium.org>
In-Reply-To: <1488827386-87193-1-git-send-email-keescook@chromium.org>
References: <1488827386-87193-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 6/6] refcount: Check bad states with CHECK_DATA_CORRUPTION
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Viresh Kumar <viresh.kumar@linaro.org>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Dmitry Vyukov <dvyukov@google.com>, Olof Johansson <olof@lixom.net>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

This converts from WARN() to CHECK_DATA_CORRUPTION() (so that system
builders can choose between WARN and BUG). Additionally moves refcount_t
sanity-check conditionals into regular function flow.

Now when built with CONFIG_BUG_ON_DATA_CORRUPTION, the LKDTM REFCOUNT_*
tests correctly kill offending processes.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 lib/refcount.c | 33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/lib/refcount.c b/lib/refcount.c
index 1d33366189d1..54aff1e0582f 100644
--- a/lib/refcount.c
+++ b/lib/refcount.c
@@ -37,6 +37,13 @@
 #include <linux/refcount.h>
 #include <linux/bug.h>
 
+/*
+ * CHECK_DATA_CORRUPTION() is defined with __must_check, but we have a
+ * couple places where we want to report a condition that has already
+ * been checked, so this lets us cheat __must_check.
+ */
+#define REFCOUNT_CHECK(cond, str) unlikely(CHECK_DATA_CORRUPTION(cond, str))
+
 bool refcount_add_not_zero(unsigned int i, refcount_t *r)
 {
 	unsigned int old, new, val = atomic_read(&r->refs);
@@ -58,7 +65,8 @@ bool refcount_add_not_zero(unsigned int i, refcount_t *r)
 		val = old;
 	}
 
-	WARN(new == UINT_MAX, "refcount_t: saturated; leaking memory.\n");
+	REFCOUNT_CHECK(new == UINT_MAX,
+			"refcount_t: add saturated; leaking memory.\n");
 
 	return true;
 }
@@ -66,7 +74,8 @@ EXPORT_SYMBOL_GPL(refcount_add_not_zero);
 
 void refcount_add(unsigned int i, refcount_t *r)
 {
-	WARN(!refcount_add_not_zero(i, r), "refcount_t: addition on 0; use-after-free.\n");
+	REFCOUNT_CHECK(!refcount_add_not_zero(i, r),
+			"refcount_t: addition on 0; use-after-free.\n");
 }
 EXPORT_SYMBOL_GPL(refcount_add);
 
@@ -97,7 +106,8 @@ bool refcount_inc_not_zero(refcount_t *r)
 		val = old;
 	}
 
-	WARN(new == UINT_MAX, "refcount_t: saturated; leaking memory.\n");
+	REFCOUNT_CHECK(new == UINT_MAX,
+			"refcount_t: inc saturated; leaking memory.\n");
 
 	return true;
 }
@@ -111,7 +121,8 @@ EXPORT_SYMBOL_GPL(refcount_inc_not_zero);
  */
 void refcount_inc(refcount_t *r)
 {
-	WARN(!refcount_inc_not_zero(r), "refcount_t: increment on 0; use-after-free.\n");
+	REFCOUNT_CHECK(!refcount_inc_not_zero(r),
+			"refcount_t: increment on 0; use-after-free.\n");
 }
 EXPORT_SYMBOL_GPL(refcount_inc);
 
@@ -124,10 +135,9 @@ bool refcount_sub_and_test(unsigned int i, refcount_t *r)
 			return false;
 
 		new = val - i;
-		if (new > val) {
-			WARN(new > val, "refcount_t: underflow; use-after-free.\n");
+		if (REFCOUNT_CHECK(new > val,
+				"refcount_t: sub underflow; use-after-free.\n"))
 			return false;
-		}
 
 		old = atomic_cmpxchg_release(&r->refs, val, new);
 		if (old == val)
@@ -164,7 +174,8 @@ EXPORT_SYMBOL_GPL(refcount_dec_and_test);
 
 void refcount_dec(refcount_t *r)
 {
-	WARN(refcount_dec_and_test(r), "refcount_t: decrement hit 0; leaking memory.\n");
+	REFCOUNT_CHECK(refcount_dec_and_test(r),
+			"refcount_t: decrement hit 0; leaking memory.\n");
 }
 EXPORT_SYMBOL_GPL(refcount_dec);
 
@@ -203,10 +214,9 @@ bool refcount_dec_not_one(refcount_t *r)
 			return false;
 
 		new = val - 1;
-		if (new > val) {
-			WARN(new > val, "refcount_t: underflow; use-after-free.\n");
+		if (REFCOUNT_CHECK(new > val,
+				"refcount_t: dec underflow; use-after-free.\n"))
 			return true;
-		}
 
 		old = atomic_cmpxchg_release(&r->refs, val, new);
 		if (old == val)
@@ -264,4 +274,3 @@ bool refcount_dec_and_lock(refcount_t *r, spinlock_t *lock)
 	return true;
 }
 EXPORT_SYMBOL_GPL(refcount_dec_and_lock);
-
-- 
2.7.4
