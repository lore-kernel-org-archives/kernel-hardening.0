From: Kees Cook <keescook@chromium.org>
Date: Tue,  4 Apr 2017 15:12:18 -0700
Message-Id: <1491343938-75336-8-git-send-email-keescook@chromium.org>
In-Reply-To: <1491343938-75336-1-git-send-email-keescook@chromium.org>
References: <1491343938-75336-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v2 7/7] refcount: Check bad states with CHECK_DATA_CORRUPTION()
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Kalle Valo <kvalo@codeaurora.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Viresh Kumar <viresh.kumar@linaro.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Olof Johansson <olof@lixom.net>, Chris Wilson <chris@chris-wilson.co.uk>, George Spelvin <linux@sciencehorizons.net>, Thomas Gleixner <tglx@linutronix.de>, Josh Poimboeuf <jpoimboe@redhat.com>, David Windsor <dwindsor@gmail.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This converts from WARN_ONCE() to CHECK_DATA_CORRUPTION() (so that system
builders can choose between WARN and BUG). Additionally moves refcount_t
sanity-check conditionals into regular function flow.

Now when built with CONFIG_BUG_ON_DATA_CORRUPTION, the LKDTM REFCOUNT_*
tests correctly kill offending processes.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 lib/refcount.c | 33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/lib/refcount.c b/lib/refcount.c
index f42124ccf295..88289210d9fd 100644
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
 /**
  * refcount_add_not_zero - add a value to a refcount unless it is 0
  * @i: the value to add to the refcount
@@ -72,7 +79,8 @@ bool refcount_add_not_zero(unsigned int i, refcount_t *r)
 
 	} while (!atomic_try_cmpxchg_relaxed(&r->refs, &val, new));
 
-	WARN_ONCE(new == UINT_MAX, "refcount_t: saturated; leaking memory.\n");
+	REFCOUNT_CHECK(new == UINT_MAX,
+			"refcount_t: add saturated; leaking memory.\n");
 
 	return true;
 }
@@ -96,7 +104,8 @@ EXPORT_SYMBOL_GPL(refcount_add_not_zero);
  */
 void refcount_add(unsigned int i, refcount_t *r)
 {
-	WARN_ONCE(!refcount_add_not_zero(i, r), "refcount_t: addition on 0; use-after-free.\n");
+	REFCOUNT_CHECK(!refcount_add_not_zero(i, r),
+			"refcount_t: addition on 0; use-after-free.\n");
 }
 EXPORT_SYMBOL_GPL(refcount_add);
 
@@ -127,7 +136,8 @@ bool refcount_inc_not_zero(refcount_t *r)
 
 	} while (!atomic_try_cmpxchg_relaxed(&r->refs, &val, new));
 
-	WARN_ONCE(new == UINT_MAX, "refcount_t: saturated; leaking memory.\n");
+	REFCOUNT_CHECK(new == UINT_MAX,
+			"refcount_t: inc saturated; leaking memory.\n");
 
 	return true;
 }
@@ -147,7 +157,8 @@ EXPORT_SYMBOL_GPL(refcount_inc_not_zero);
  */
 void refcount_inc(refcount_t *r)
 {
-	WARN_ONCE(!refcount_inc_not_zero(r), "refcount_t: increment on 0; use-after-free.\n");
+	REFCOUNT_CHECK(!refcount_inc_not_zero(r),
+			"refcount_t: increment on 0; use-after-free.\n");
 }
 EXPORT_SYMBOL_GPL(refcount_inc);
 
@@ -180,10 +191,9 @@ bool refcount_sub_and_test(unsigned int i, refcount_t *r)
 			return false;
 
 		new = val - i;
-		if (new > val) {
-			WARN_ONCE(new > val, "refcount_t: underflow; use-after-free.\n");
+		if (REFCOUNT_CHECK(new > val,
+				"refcount_t: sub underflow; use-after-free.\n"))
 			return false;
-		}
 
 	} while (!atomic_try_cmpxchg_release(&r->refs, &val, new));
 
@@ -222,7 +232,8 @@ EXPORT_SYMBOL_GPL(refcount_dec_and_test);
  */
 void refcount_dec(refcount_t *r)
 {
-	WARN_ONCE(refcount_dec_and_test(r), "refcount_t: decrement hit 0; leaking memory.\n");
+	REFCOUNT_CHECK(refcount_dec_and_test(r),
+			"refcount_t: decrement hit 0; leaking memory.\n");
 }
 EXPORT_SYMBOL_GPL(refcount_dec);
 
@@ -273,10 +284,9 @@ bool refcount_dec_not_one(refcount_t *r)
 			return false;
 
 		new = val - 1;
-		if (new > val) {
-			WARN_ONCE(new > val, "refcount_t: underflow; use-after-free.\n");
+		if (REFCOUNT_CHECK(new > val,
+				"refcount_t: dec underflow; use-after-free.\n"))
 			return true;
-		}
 
 	} while (!atomic_try_cmpxchg_release(&r->refs, &val, new));
 
@@ -345,4 +355,3 @@ bool refcount_dec_and_lock(refcount_t *r, spinlock_t *lock)
 	return true;
 }
 EXPORT_SYMBOL_GPL(refcount_dec_and_lock);
-
-- 
2.7.4
