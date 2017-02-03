From: Kees Cook <keescook@chromium.org>
Date: Fri,  3 Feb 2017 15:26:52 -0800
Message-Id: <1486164412-7338-5-git-send-email-keescook@chromium.org>
In-Reply-To: <1486164412-7338-1-git-send-email-keescook@chromium.org>
References: <1486164412-7338-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 4/4] refcount: Report failures through CHECK_DATA_CORRUPTION
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kees Cook <keescook@chromium.org>, elena.reshetova@intel.com, gregkh@linuxfoundation.org, arnd@arndb.de, tglx@linutronix.de, mingo@kernel.org, h.peter.anvin@intel.com, will.deacon@arm.com, dwindsor@gmail.com, Hans Liljestrand <ishkamiel@gmail.com>, dhowells@redhat.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This converts from WARN_ON() to CHECK_DATA_CORRUPTION() in the
CONFIG_DEBUG_REFCOUNT case. Additionally moves refcount_t sanity check
conditionals into regular function flow. Since CHECK_DATA_CORRUPTION()
is marked __much_check, we override few cases where the failure has
already been handled but we want to explicitly report it.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/refcount.h | 35 ++++++++++++++++++++++-------------
 lib/Kconfig.debug        |  2 ++
 2 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/include/linux/refcount.h b/include/linux/refcount.h
index 5b89cad62237..ef32910c7dd8 100644
--- a/include/linux/refcount.h
+++ b/include/linux/refcount.h
@@ -43,10 +43,10 @@
 #include <linux/spinlock.h>
 
 #if CONFIG_DEBUG_REFCOUNT
-#define REFCOUNT_WARN(cond, str) WARN_ON(cond)
+#define REFCOUNT_CHECK(cond, str) CHECK_DATA_CORRUPTION(cond, str)
 #define __refcount_check	__must_check
 #else
-#define REFCOUNT_WARN(cond, str) (void)(cond)
+#define REFCOUNT_CHECK(cond, str) (!!(cond))
 #define __refcount_check
 #endif
 
@@ -86,14 +86,18 @@ bool refcount_add_not_zero(unsigned int i, refcount_t *r)
 			break;
 	}
 
-	REFCOUNT_WARN(new == UINT_MAX, "refcount_t: saturated; leaking memory.\n");
+	val = REFCOUNT_CHECK(new == UINT_MAX,
+			     "refcount_t: add saturated; leaking memory.\n");
 
 	return true;
 }
 
 static inline void refcount_add(unsigned int i, refcount_t *r)
 {
-	REFCOUNT_WARN(!refcount_add_not_zero(i, r), "refcount_t: addition on 0; use-after-free.\n");
+	bool __always_unused b;
+
+	b = REFCOUNT_CHECK(!refcount_add_not_zero(i, r),
+			   "refcount_t: addition on 0; use-after-free.\n");
 }
 
 /*
@@ -121,7 +125,8 @@ bool refcount_inc_not_zero(refcount_t *r)
 			break;
 	}
 
-	REFCOUNT_WARN(new == UINT_MAX, "refcount_t: saturated; leaking memory.\n");
+	val = REFCOUNT_CHECK(new == UINT_MAX,
+			     "refcount_t: inc saturated; leaking memory.\n");
 
 	return true;
 }
@@ -134,7 +139,10 @@ bool refcount_inc_not_zero(refcount_t *r)
  */
 static inline void refcount_inc(refcount_t *r)
 {
-	REFCOUNT_WARN(!refcount_inc_not_zero(r), "refcount_t: increment on 0; use-after-free.\n");
+	bool __always_unused b;
+
+	b = REFCOUNT_CHECK(!refcount_inc_not_zero(r),
+			   "refcount_t: increment on 0; use-after-free.\n");
 }
 
 /*
@@ -155,10 +163,9 @@ bool refcount_sub_and_test(unsigned int i, refcount_t *r)
 			return false;
 
 		new = val - i;
-		if (new > val) {
-			REFCOUNT_WARN(new > val, "refcount_t: underflow; use-after-free.\n");
+		if (REFCOUNT_CHECK(new > val,
+				"refcount_t: sub underflow; use-after-free.\n"))
 			return false;
-		}
 
 		if (atomic_try_cmpxchg_release(&r->refs, &val, new))
 			break;
@@ -183,7 +190,10 @@ bool refcount_dec_and_test(refcount_t *r)
 static inline
 void refcount_dec(refcount_t *r)
 {
-	REFCOUNT_WARN(refcount_dec_and_test(r), "refcount_t: decrement hit 0; leaking memory.\n");
+	bool __always_unused b;
+
+	b = REFCOUNT_CHECK(refcount_dec_and_test(r),
+			   "refcount_t: decrement hit 0; leaking memory.\n");
 }
 
 /*
@@ -224,10 +234,9 @@ bool refcount_dec_not_one(refcount_t *r)
 			return false;
 
 		new = val - 1;
-		if (new > val) {
-			REFCOUNT_WARN(new > val, "refcount_t: underflow; use-after-free.\n");
+		if (REFCOUNT_CHECK(new > val,
+				"refcount_t: dec underflow; use-after-free.\n"))
 			return true;
-		}
 
 		if (atomic_try_cmpxchg_release(&r->refs, &val, new))
 			break;
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 20fde8d4523a..01e7aa578456 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -731,6 +731,7 @@ source "lib/Kconfig.kasan"
 
 config DEBUG_REFCOUNT
 	bool "Verbose refcount checks"
+	depends on DEBUG_KERNEL || BUG_ON_DATA_CORRUPTION
 	help
 	  Say Y here if you want reference counters (refcount_t and kref) to
 	  generate WARNs on dubious usage. Without this refcount_t will still
@@ -2011,6 +2012,7 @@ config TEST_STATIC_KEYS
 config BUG_ON_DATA_CORRUPTION
 	bool "Trigger a BUG when data corruption is detected"
 	select DEBUG_LIST
+	select DEBUG_REFCOUNT
 	help
 	  Select this option if the kernel should BUG when it encounters
 	  data corruption in kernel memory structures when they get checked
-- 
2.7.4
