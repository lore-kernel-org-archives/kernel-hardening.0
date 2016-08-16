Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Tue, 16 Aug 2016 14:11:01 -0700
Message-Id: <1471381865-25724-2-git-send-email-keescook@chromium.org>
In-Reply-To: <1471381865-25724-1-git-send-email-keescook@chromium.org>
References: <1471381865-25724-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 1/5] list: Split list_add() debug checking into separate function
To: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Kees Cook <keescook@chromium.org>, Stephen Boyd <sboyd@codeaurora.org>, Daniel Micay <danielmicay@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Josh Triplett <josh@joshtriplett.org>, Steven Rostedt <rostedt@goodmis.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Josef Bacik <jbacik@fb.com>, Thomas Gleixner <tglx@linutronix.de>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Nikolay Aleksandrov <nikolay@cumulusnetworks.com>, Dmitry Vyukov <dvyukov@google.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Right now, __list_add() code is repeated either in list.h or in
list_debug.c, but only the debug checks are the different part. This
extracts the checking into a separate function and consolidates
__list_add(). Additionally this __list_add_debug() will stop list
manipulations if a corruption is detected, instead of allowing for further
corruption that may lead to even worse conditions.

This is slight refactoring of the same hardening done in PaX and Grsecurity.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/list.h | 22 ++++++++++++++++------
 lib/list_debug.c     | 35 ++++++++++++++++++-----------------
 2 files changed, 34 insertions(+), 23 deletions(-)

diff --git a/include/linux/list.h b/include/linux/list.h
index 5183138aa932..c38ff652ab59 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -28,27 +28,37 @@ static inline void INIT_LIST_HEAD(struct list_head *list)
 	list->prev = list;
 }
 
+#ifdef CONFIG_DEBUG_LIST
+extern bool __list_add_debug(struct list_head *new,
+			      struct list_head *prev,
+			      struct list_head *next);
+#else
+static inline bool __list_add_debug(struct list_head *new,
+				struct list_head *prev,
+				struct list_head *next)
+{
+	return true;
+}
+#endif
+
 /*
  * Insert a new entry between two known consecutive entries.
  *
  * This is only for internal list manipulation where we know
  * the prev/next entries already!
  */
-#ifndef CONFIG_DEBUG_LIST
 static inline void __list_add(struct list_head *new,
 			      struct list_head *prev,
 			      struct list_head *next)
 {
+	if (!__list_add_debug(new, prev, next))
+		return;
+
 	next->prev = new;
 	new->next = next;
 	new->prev = prev;
 	WRITE_ONCE(prev->next, new);
 }
-#else
-extern void __list_add(struct list_head *new,
-			      struct list_head *prev,
-			      struct list_head *next);
-#endif
 
 /**
  * list_add - add a new entry
diff --git a/lib/list_debug.c b/lib/list_debug.c
index 3859bf63561c..5d78982eeb99 100644
--- a/lib/list_debug.c
+++ b/lib/list_debug.c
@@ -19,27 +19,28 @@
  * the prev/next entries already!
  */
 
-void __list_add(struct list_head *new,
+bool __list_add_debug(struct list_head *new,
 			      struct list_head *prev,
 			      struct list_head *next)
 {
-	WARN(next->prev != prev,
-		"list_add corruption. next->prev should be "
-		"prev (%p), but was %p. (next=%p).\n",
-		prev, next->prev, next);
-	WARN(prev->next != next,
-		"list_add corruption. prev->next should be "
-		"next (%p), but was %p. (prev=%p).\n",
-		next, prev->next, prev);
-	WARN(new == prev || new == next,
-	     "list_add double add: new=%p, prev=%p, next=%p.\n",
-	     new, prev, next);
-	next->prev = new;
-	new->next = next;
-	new->prev = prev;
-	WRITE_ONCE(prev->next, new);
+	if (unlikely(next->prev != prev)) {
+		WARN(1, "list_add corruption. next->prev should be prev (%p), but was %p. (next=%p).\n",
+			prev, next->prev, next);
+		return false;
+	}
+	if (unlikely(prev->next != next)) {
+		WARN(1, "list_add corruption. prev->next should be next (%p), but was %p. (prev=%p).\n",
+			next, prev->next, prev);
+		return false;
+	}
+	if (unlikely(new == prev || new == next)) {
+		WARN(1, "list_add double add: new=%p, prev=%p, next=%p.\n",
+			new, prev, next);
+		return false;
+	}
+	return true;
 }
-EXPORT_SYMBOL(__list_add);
+EXPORT_SYMBOL(__list_add_debug);
 
 void __list_del_entry(struct list_head *entry)
 {
-- 
2.7.4
