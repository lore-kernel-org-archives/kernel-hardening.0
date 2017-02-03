From: Kees Cook <keescook@chromium.org>
Date: Fri,  3 Feb 2017 15:26:51 -0800
Message-Id: <1486164412-7338-4-git-send-email-keescook@chromium.org>
In-Reply-To: <1486164412-7338-1-git-send-email-keescook@chromium.org>
References: <1486164412-7338-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 3/4] bug: Switch data corruption check to __must_check
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kees Cook <keescook@chromium.org>, elena.reshetova@intel.com, gregkh@linuxfoundation.org, arnd@arndb.de, tglx@linutronix.de, mingo@kernel.org, h.peter.anvin@intel.com, will.deacon@arm.com, dwindsor@gmail.com, Hans Liljestrand <ishkamiel@gmail.com>, dhowells@redhat.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

The CHECK_DATA_CORRUPTION() macro was designed to have callers do
something meaningful/protective on failure. However, using "return false"
in the macro too strictly limits the design patterns of callers. Instead,
let callers handle the logic test directly, but make sure that the result
IS checked by forcing __must_check (which appears to not be able to be
used directly on macro expressions).

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/bug.h | 12 +++++++-----
 lib/list_debug.c    | 45 ++++++++++++++++++++++++---------------------
 2 files changed, 31 insertions(+), 26 deletions(-)

diff --git a/include/linux/bug.h b/include/linux/bug.h
index baff2e8fc8a8..5828489309bb 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -124,18 +124,20 @@ static inline enum bug_trap_type report_bug(unsigned long bug_addr,
 
 /*
  * Since detected data corruption should stop operation on the affected
- * structures, this returns false if the corruption condition is found.
+ * structures. Return value must be checked and sanely acted on by caller.
  */
+static inline __must_check bool check_data_corruption(bool v) { return v; }
 #define CHECK_DATA_CORRUPTION(condition, fmt, ...)			 \
-	do {								 \
-		if (unlikely(condition)) {				 \
+	check_data_corruption(({					 \
+		bool corruption = unlikely(condition);			 \
+		if (corruption) {					 \
 			if (IS_ENABLED(CONFIG_BUG_ON_DATA_CORRUPTION)) { \
 				pr_err(fmt, ##__VA_ARGS__);		 \
 				BUG();					 \
 			} else						 \
 				WARN(1, fmt, ##__VA_ARGS__);		 \
-			return false;					 \
 		}							 \
-	} while (0)
+		corruption;						 \
+	}))
 
 #endif	/* _LINUX_BUG_H */
diff --git a/lib/list_debug.c b/lib/list_debug.c
index 7f7bfa55eb6d..a34db8d27667 100644
--- a/lib/list_debug.c
+++ b/lib/list_debug.c
@@ -20,15 +20,16 @@
 bool __list_add_valid(struct list_head *new, struct list_head *prev,
 		      struct list_head *next)
 {
-	CHECK_DATA_CORRUPTION(next->prev != prev,
-		"list_add corruption. next->prev should be prev (%p), but was %p. (next=%p).\n",
-		prev, next->prev, next);
-	CHECK_DATA_CORRUPTION(prev->next != next,
-		"list_add corruption. prev->next should be next (%p), but was %p. (prev=%p).\n",
-		next, prev->next, prev);
-	CHECK_DATA_CORRUPTION(new == prev || new == next,
-		"list_add double add: new=%p, prev=%p, next=%p.\n",
-		new, prev, next);
+	if (CHECK_DATA_CORRUPTION(next->prev != prev,
+			"list_add corruption. next->prev should be prev (%p), but was %p. (next=%p).\n",
+			prev, next->prev, next) ||
+	    CHECK_DATA_CORRUPTION(prev->next != next,
+			"list_add corruption. prev->next should be next (%p), but was %p. (prev=%p).\n",
+			next, prev->next, prev) ||
+	    CHECK_DATA_CORRUPTION(new == prev || new == next,
+			"list_add double add: new=%p, prev=%p, next=%p.\n",
+			new, prev, next))
+		return false;
 
 	return true;
 }
@@ -41,18 +42,20 @@ bool __list_del_entry_valid(struct list_head *entry)
 	prev = entry->prev;
 	next = entry->next;
 
-	CHECK_DATA_CORRUPTION(next == LIST_POISON1,
-		"list_del corruption, %p->next is LIST_POISON1 (%p)\n",
-		entry, LIST_POISON1);
-	CHECK_DATA_CORRUPTION(prev == LIST_POISON2,
-		"list_del corruption, %p->prev is LIST_POISON2 (%p)\n",
-		entry, LIST_POISON2);
-	CHECK_DATA_CORRUPTION(prev->next != entry,
-		"list_del corruption. prev->next should be %p, but was %p\n",
-		entry, prev->next);
-	CHECK_DATA_CORRUPTION(next->prev != entry,
-		"list_del corruption. next->prev should be %p, but was %p\n",
-		entry, next->prev);
+	if (CHECK_DATA_CORRUPTION(next == LIST_POISON1,
+			"list_del corruption, %p->next is LIST_POISON1 (%p)\n",
+			entry, LIST_POISON1) ||
+	    CHECK_DATA_CORRUPTION(prev == LIST_POISON2,
+			"list_del corruption, %p->prev is LIST_POISON2 (%p)\n",
+			entry, LIST_POISON2) ||
+	    CHECK_DATA_CORRUPTION(prev->next != entry,
+			"list_del corruption. prev->next should be %p, but was %p\n",
+			entry, prev->next) ||
+	    CHECK_DATA_CORRUPTION(next->prev != entry,
+			"list_del corruption. next->prev should be %p, but was %p\n",
+			entry, next->prev))
+		return false;
+
 	return true;
 
 }
-- 
2.7.4
