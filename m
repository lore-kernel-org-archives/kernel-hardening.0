From: Kees Cook <keescook@chromium.org>
Date: Mon, 27 Feb 2017 12:43:04 -0800
Message-Id: <1488228186-110679-7-git-send-email-keescook@chromium.org>
In-Reply-To: <1488228186-110679-1-git-send-email-keescook@chromium.org>
References: <1488228186-110679-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [RFC][PATCH 6/8] list: add rare_write() list helpers
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>, Hoeun Ryu <hoeun.ryu@gmail.com>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Some structures that are intended to be made write-rarely are designed to
be linked by lists. As a result, there need to be rare_write()-supported
linked list primitives.

As found in PaX, this adds list management helpers for doing updates to
rarely-changed lists.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/list.h | 17 +++++++++++++++++
 lib/Makefile         |  2 +-
 lib/list_debug.c     | 34 ++++++++++++++++++++++++++++++++++
 3 files changed, 52 insertions(+), 1 deletion(-)

diff --git a/include/linux/list.h b/include/linux/list.h
index d1039ecaf94f..548b95546793 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -126,6 +126,23 @@ static inline void list_del(struct list_head *entry)
 	entry->prev = LIST_POISON2;
 }
 
+extern void __rare_list_add(struct list_head *new,
+			    struct list_head *prev,
+			    struct list_head *next);
+
+static inline void
+rare_list_add(__wr_rare_type struct list_head *new, struct list_head *head)
+{
+	__rare_list_add((struct list_head *)new, head, head->next);
+}
+static inline void
+rare_list_add_tail(__wr_rare_type struct list_head *new, struct list_head *head)
+{
+	__rare_list_add((struct list_head *)new, head->prev, head);
+}
+
+extern void rare_list_del(__wr_rare_type struct list_head *entry);
+
 /**
  * list_replace - replace old entry by new one
  * @old : the element to be replaced
diff --git a/lib/Makefile b/lib/Makefile
index bc4073a8cd08..edee0bcc660a 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -76,7 +76,7 @@ obj-$(CONFIG_BTREE) += btree.o
 obj-$(CONFIG_INTERVAL_TREE) += interval_tree.o
 obj-$(CONFIG_ASSOCIATIVE_ARRAY) += assoc_array.o
 obj-$(CONFIG_DEBUG_PREEMPT) += smp_processor_id.o
-obj-$(CONFIG_DEBUG_LIST) += list_debug.o
+obj-y += list_debug.o
 obj-$(CONFIG_DEBUG_OBJECTS) += debugobjects.o
 
 ifneq ($(CONFIG_HAVE_DEC_LOCK),y)
diff --git a/lib/list_debug.c b/lib/list_debug.c
index 7f7bfa55eb6d..1ff3c5bb926a 100644
--- a/lib/list_debug.c
+++ b/lib/list_debug.c
@@ -10,7 +10,9 @@
 #include <linux/bug.h>
 #include <linux/kernel.h>
 #include <linux/rculist.h>
+#include <linux/mm.h>
 
+#ifdef CONFIG_DEBUG_LIST
 /*
  * Check that the data structures for the list manipulations are reasonably
  * valid. Failures here indicate memory corruption (and possibly an exploit
@@ -57,3 +59,35 @@ bool __list_del_entry_valid(struct list_head *entry)
 
 }
 EXPORT_SYMBOL(__list_del_entry_valid);
+
+#endif /* CONFIG_DEBUG_LIST */
+
+void __rare_list_add(struct list_head *new, struct list_head *prev,
+		     struct list_head *next)
+{
+	if (!__list_add_valid(new, prev, next))
+		return;
+
+	rare_write_enable();
+	next->prev = new;
+	new->next = next;
+	new->prev = prev;
+	prev->next = new;
+	rare_write_disable();
+}
+EXPORT_SYMBOL(__rare_list_add);
+
+void rare_list_del(__wr_rare_type struct list_head *entry_const)
+{
+	struct list_head *entry = (struct list_head *)entry_const;
+
+	if (!__list_del_entry_valid(entry))
+		return;
+
+	rare_write_enable();
+	__list_del(entry->prev, entry->next);
+	entry->next = LIST_POISON1;
+	entry->prev = LIST_POISON2;
+	rare_write_disable();
+}
+EXPORT_SYMBOL(rare_list_del);
-- 
2.7.4
