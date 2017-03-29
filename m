From: Kees Cook <keescook@chromium.org>
Date: Wed, 29 Mar 2017 11:16:01 -0700
Message-Id: <1490811363-93944-10-git-send-email-keescook@chromium.org>
In-Reply-To: <1490811363-93944-1-git-send-email-keescook@chromium.org>
References: <1490811363-93944-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [RFC v2][PATCH 09/11] list: add rare_write() list helpers
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>, Hoeun Ryu <hoeun.ryu@gmail.com>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
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
 lib/list_debug.c     | 37 +++++++++++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/include/linux/list.h b/include/linux/list.h
index ae537fa46216..50fdd5b737aa 100644
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
index 320ac46a8725..cd64fd8f7a21 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -83,7 +83,7 @@ obj-$(CONFIG_BTREE) += btree.o
 obj-$(CONFIG_INTERVAL_TREE) += interval_tree.o
 obj-$(CONFIG_ASSOCIATIVE_ARRAY) += assoc_array.o
 obj-$(CONFIG_DEBUG_PREEMPT) += smp_processor_id.o
-obj-$(CONFIG_DEBUG_LIST) += list_debug.o
+obj-y += list_debug.o
 obj-$(CONFIG_DEBUG_OBJECTS) += debugobjects.o
 
 ifneq ($(CONFIG_HAVE_DEC_LOCK),y)
diff --git a/lib/list_debug.c b/lib/list_debug.c
index a34db8d27667..1add73f9479a 100644
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
@@ -60,3 +62,38 @@ bool __list_del_entry_valid(struct list_head *entry)
 
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
+	rare_write_begin();
+	__rare_write(next->prev, new);
+	__rare_write(new->next, next);
+	__rare_write(new->prev, prev);
+	__rare_write(prev->next, new);
+	rare_write_end();
+}
+EXPORT_SYMBOL(__rare_list_add);
+
+void rare_list_del(__wr_rare_type struct list_head *entry_const)
+{
+	struct list_head *entry = (struct list_head *)entry_const;
+	struct list_head *prev = entry->prev;
+	struct list_head *next = entry->next;
+
+	if (!__list_del_entry_valid(entry))
+		return;
+
+	rare_write_begin();
+	__rare_write(next->prev, prev);
+	__rare_write(prev->next, next);
+	__rare_write(entry->next, LIST_POISON1);
+	__rare_write(entry->prev, LIST_POISON2);
+	rare_write_end();
+}
+EXPORT_SYMBOL(rare_list_del);
-- 
2.7.4
