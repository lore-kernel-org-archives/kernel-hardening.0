Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Tue, 16 Aug 2016 17:20:26 -0700
Message-Id: <1471393229-27182-3-git-send-email-keescook@chromium.org>
In-Reply-To: <1471393229-27182-1-git-send-email-keescook@chromium.org>
References: <1471393229-27182-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v2 2/5] rculist: Consolidate DEBUG_LIST for list_add_rcu()
To: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Stephen Boyd <sboyd@codeaurora.org>, Daniel Micay <danielmicay@gmail.com>, Joe Perches <joe@perches.com>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Josh Triplett <josh@joshtriplett.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Michael Ellerman <mpe@ellerman.id.au>, Dan Williams <dan.j.williams@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Josef Bacik <jbacik@fb.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Tejun Heo <tj@kernel.org>, Nikolay Aleksandrov <nikolay@cumulusnetworks.com>, Dmitry Vyukov <dvyukov@google.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Consolidates the debug checking for list_add_rcu() into the new single
debug function. Notably, this fixes the sanity check that was added in
 commit 17a801f4bfeb ("list_debug: WARN for adding something already in
the list"). Before, it wasn't being checked for RCU lists.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/rculist.h |  8 +++-----
 lib/list_debug.c        | 19 -------------------
 2 files changed, 3 insertions(+), 24 deletions(-)

diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index 8beb98dcf14f..4f7a9561b8c4 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -45,19 +45,17 @@ static inline void INIT_LIST_HEAD_RCU(struct list_head *list)
  * This is only for internal list manipulation where we know
  * the prev/next entries already!
  */
-#ifndef CONFIG_DEBUG_LIST
 static inline void __list_add_rcu(struct list_head *new,
 		struct list_head *prev, struct list_head *next)
 {
+	if (!__list_add_valid(new, prev, next))
+		return;
+
 	new->next = next;
 	new->prev = prev;
 	rcu_assign_pointer(list_next_rcu(prev), new);
 	next->prev = new;
 }
-#else
-void __list_add_rcu(struct list_head *new,
-		    struct list_head *prev, struct list_head *next);
-#endif
 
 /**
  * list_add_rcu - add a new entry to rcu-protected list
diff --git a/lib/list_debug.c b/lib/list_debug.c
index 149dd57b583b..d0b89b9d0736 100644
--- a/lib/list_debug.c
+++ b/lib/list_debug.c
@@ -77,22 +77,3 @@ void list_del(struct list_head *entry)
 	entry->prev = LIST_POISON2;
 }
 EXPORT_SYMBOL(list_del);
-
-/*
- * RCU variants.
- */
-void __list_add_rcu(struct list_head *new,
-		    struct list_head *prev, struct list_head *next)
-{
-	WARN(next->prev != prev,
-		"list_add_rcu corruption. next->prev should be prev (%p), but was %p. (next=%p).\n",
-		prev, next->prev, next);
-	WARN(prev->next != next,
-		"list_add_rcu corruption. prev->next should be next (%p), but was %p. (prev=%p).\n",
-		next, prev->next, prev);
-	new->next = next;
-	new->prev = prev;
-	rcu_assign_pointer(list_next_rcu(prev), new);
-	next->prev = new;
-}
-EXPORT_SYMBOL(__list_add_rcu);
-- 
2.7.4
