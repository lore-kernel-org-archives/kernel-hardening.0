Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Wed, 17 Aug 2016 14:42:10 -0700
Message-Id: <1471470132-29499-4-git-send-email-keescook@chromium.org>
In-Reply-To: <1471470132-29499-1-git-send-email-keescook@chromium.org>
References: <1471470132-29499-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v3 3/5] list: Split list_del() debug checking into separate function
To: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Daniel Micay <danielmicay@gmail.com>, Joe Perches <joe@perches.com>, Stephen Boyd <sboyd@codeaurora.org>, Syed Rameez Mustafa <rameezmustafa@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Josh Triplett <josh@joshtriplett.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Michael Ellerman <mpe@ellerman.id.au>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Thomas Gleixner <tglx@linutronix.de>, Josef Bacik <jbacik@fb.com>, Ingo Molnar <mingo@kernel.org>, Tejun Heo <tj@kernel.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Nikolay Aleksandrov <nikolay@cumulusnetworks.com>, Dmitry Vyukov <dvyukov@google.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Similar to the list_add() debug consolidation, this consolidates the
debug checking performed during CONFIG_DEBUG_LIST, and stops list
updates when corruption is found.

Refactored from same hardening in PaX and Grsecurity.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/list.h | 15 +++++++++------
 lib/list_debug.c     | 53 +++++++++++++++++++++++-----------------------------
 2 files changed, 32 insertions(+), 36 deletions(-)

diff --git a/include/linux/list.h b/include/linux/list.h
index 0ed58591538e..569c1cf80c64 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -32,6 +32,7 @@ static inline void INIT_LIST_HEAD(struct list_head *list)
 extern bool __list_add_valid(struct list_head *new,
 			      struct list_head *prev,
 			      struct list_head *next);
+extern bool __list_del_entry_valid(struct list_head *entry);
 #else
 static inline bool __list_add_valid(struct list_head *new,
 				struct list_head *prev,
@@ -39,6 +40,10 @@ static inline bool __list_add_valid(struct list_head *new,
 {
 	return true;
 }
+static inline bool __list_del_entry_valid(struct list_head *entry)
+{
+	return true;
+}
 #endif
 
 /*
@@ -106,22 +111,20 @@ static inline void __list_del(struct list_head * prev, struct list_head * next)
  * Note: list_empty() on entry does not return true after this, the entry is
  * in an undefined state.
  */
-#ifndef CONFIG_DEBUG_LIST
 static inline void __list_del_entry(struct list_head *entry)
 {
+	if (!__list_del_entry_valid(entry))
+		return;
+
 	__list_del(entry->prev, entry->next);
 }
 
 static inline void list_del(struct list_head *entry)
 {
-	__list_del(entry->prev, entry->next);
+	__list_del_entry(entry);
 	entry->next = LIST_POISON1;
 	entry->prev = LIST_POISON2;
 }
-#else
-extern void __list_del_entry(struct list_head *entry);
-extern void list_del(struct list_head *entry);
-#endif
 
 /**
  * list_replace - replace old entry by new one
diff --git a/lib/list_debug.c b/lib/list_debug.c
index d0b89b9d0736..276565fca2a6 100644
--- a/lib/list_debug.c
+++ b/lib/list_debug.c
@@ -39,41 +39,34 @@ bool __list_add_valid(struct list_head *new, struct list_head *prev,
 }
 EXPORT_SYMBOL(__list_add_valid);
 
-void __list_del_entry(struct list_head *entry)
+bool __list_del_entry_valid(struct list_head *entry)
 {
 	struct list_head *prev, *next;
 
 	prev = entry->prev;
 	next = entry->next;
 
-	if (WARN(next == LIST_POISON1,
-		"list_del corruption, %p->next is LIST_POISON1 (%p)\n",
-		entry, LIST_POISON1) ||
-	    WARN(prev == LIST_POISON2,
-		"list_del corruption, %p->prev is LIST_POISON2 (%p)\n",
-		entry, LIST_POISON2) ||
-	    WARN(prev->next != entry,
-		"list_del corruption. prev->next should be %p, "
-		"but was %p\n", entry, prev->next) ||
-	    WARN(next->prev != entry,
-		"list_del corruption. next->prev should be %p, "
-		"but was %p\n", entry, next->prev))
-		return;
-
-	__list_del(prev, next);
-}
-EXPORT_SYMBOL(__list_del_entry);
+	if (unlikely(next == LIST_POISON1)) {
+		WARN(1, "list_del corruption, %p->next is LIST_POISON1 (%p)\n",
+			entry, LIST_POISON1);
+		return false;
+	}
+	if (unlikely(prev == LIST_POISON2)) {
+		WARN(1, "list_del corruption, %p->prev is LIST_POISON2 (%p)\n",
+			entry, LIST_POISON2);
+		return false;
+	}
+	if (unlikely(prev->next != entry)) {
+		WARN(1, "list_del corruption. prev->next should be %p, but was %p\n",
+			entry, prev->next);
+		return false;
+	}
+	if (unlikely(next->prev != entry)) {
+		WARN(1, "list_del corruption. next->prev should be %p, but was %p\n",
+			entry, next->prev);
+		return false;
+	}
+	return true;
 
-/**
- * list_del - deletes entry from list.
- * @entry: the element to delete from the list.
- * Note: list_empty on entry does not return true after this, the entry is
- * in an undefined state.
- */
-void list_del(struct list_head *entry)
-{
-	__list_del_entry(entry);
-	entry->next = LIST_POISON1;
-	entry->prev = LIST_POISON2;
 }
-EXPORT_SYMBOL(list_del);
+EXPORT_SYMBOL(__list_del_entry_valid);
-- 
2.7.4
