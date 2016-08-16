Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Tue, 16 Aug 2016 14:11:04 -0700
Message-Id: <1471381865-25724-5-git-send-email-keescook@chromium.org>
In-Reply-To: <1471381865-25724-1-git-send-email-keescook@chromium.org>
References: <1471381865-25724-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 4/5] bug: Provide toggle for BUG on data corruption
To: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Kees Cook <keescook@chromium.org>, Stephen Boyd <sboyd@codeaurora.org>, Daniel Micay <danielmicay@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Josh Triplett <josh@joshtriplett.org>, Steven Rostedt <rostedt@goodmis.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Josef Bacik <jbacik@fb.com>, Thomas Gleixner <tglx@linutronix.de>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Nikolay Aleksandrov <nikolay@cumulusnetworks.com>, Dmitry Vyukov <dvyukov@google.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

The kernel checks for several cases of data structure corruption under
either normal runtime, or under various CONFIG_DEBUG_* settings. When
corruption is detected, some systems may want to BUG() immediately instead
of letting the corruption continue. Many of these manipulation primitives
can be used by security flaws to gain arbitrary memory write control. This
provides CONFIG_BUG_ON_CORRUPTION to control newly added BUG() locations.

This is inspired by similar hardening in PaX and Grsecurity, and by
Stephen Boyd in MSM kernels.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/bug.h             |  7 +++++++
 kernel/locking/spinlock_debug.c |  1 +
 kernel/workqueue.c              |  2 ++
 lib/Kconfig.debug               | 10 ++++++++++
 lib/list_debug.c                |  7 +++++++
 5 files changed, 27 insertions(+)

diff --git a/include/linux/bug.h b/include/linux/bug.h
index e51b0709e78d..7e69758dd798 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -118,4 +118,11 @@ static inline enum bug_trap_type report_bug(unsigned long bug_addr,
 }
 
 #endif	/* CONFIG_GENERIC_BUG */
+
+#ifdef CONFIG_BUG_ON_CORRUPTION
+# define CORRUPTED_DATA_STRUCTURE	true
+#else
+# define CORRUPTED_DATA_STRUCTURE	false
+#endif
+
 #endif	/* _LINUX_BUG_H */
diff --git a/kernel/locking/spinlock_debug.c b/kernel/locking/spinlock_debug.c
index 0374a596cffa..d5f833769feb 100644
--- a/kernel/locking/spinlock_debug.c
+++ b/kernel/locking/spinlock_debug.c
@@ -64,6 +64,7 @@ static void spin_dump(raw_spinlock_t *lock, const char *msg)
 		owner ? owner->comm : "<none>",
 		owner ? task_pid_nr(owner) : -1,
 		lock->owner_cpu);
+	BUG_ON(CORRUPTED_DATA_STRUCTURE);
 	dump_stack();
 }
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index ef071ca73fc3..ea0132b55eca 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -48,6 +48,7 @@
 #include <linux/nodemask.h>
 #include <linux/moduleparam.h>
 #include <linux/uaccess.h>
+#include <linux/bug.h>
 
 #include "workqueue_internal.h"
 
@@ -2108,6 +2109,7 @@ __acquires(&pool->lock)
 		       current->comm, preempt_count(), task_pid_nr(current),
 		       worker->current_func);
 		debug_show_held_locks(current);
+		BUG_ON(CORRUPTED_DATA_STRUCTURE);
 		dump_stack();
 	}
 
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 2307d7c89dac..d64bd6b6fd45 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1987,6 +1987,16 @@ config TEST_STATIC_KEYS
 
 	  If unsure, say N.
 
+config BUG_ON_CORRUPTION
+	bool "Trigger a BUG when data corruption is detected"
+	help
+	  Select this option if the kernel should BUG when it encounters
+	  data corruption in various kernel memory structures during checks
+	  added by options like CONFIG_DEBUG_LIST, CONFIG_DEBUG_SPINLOCK,
+	  etc.
+
+	  If unsure, say N.
+
 source "samples/Kconfig"
 
 source "lib/Kconfig.kgdb"
diff --git a/lib/list_debug.c b/lib/list_debug.c
index 80e2e40a6a4e..161c7e7d3478 100644
--- a/lib/list_debug.c
+++ b/lib/list_debug.c
@@ -26,16 +26,19 @@ bool __list_add_debug(struct list_head *new,
 	if (unlikely(next->prev != prev)) {
 		WARN(1, "list_add corruption. next->prev should be prev (%p), but was %p. (next=%p).\n",
 			prev, next->prev, next);
+		BUG_ON(CORRUPTED_DATA_STRUCTURE);
 		return false;
 	}
 	if (unlikely(prev->next != next)) {
 		WARN(1, "list_add corruption. prev->next should be next (%p), but was %p. (prev=%p).\n",
 			next, prev->next, prev);
+		BUG_ON(CORRUPTED_DATA_STRUCTURE);
 		return false;
 	}
 	if (unlikely(new == prev || new == next)) {
 		WARN(1, "list_add double add: new=%p, prev=%p, next=%p.\n",
 			new, prev, next);
+		BUG_ON(CORRUPTED_DATA_STRUCTURE);
 		return false;
 	}
 	return true;
@@ -52,21 +55,25 @@ bool __list_del_entry_debug(struct list_head *entry)
 	if (unlikely(next == LIST_POISON1)) {
 		WARN(1, "list_del corruption, %p->next is LIST_POISON1 (%p)\n",
 			entry, LIST_POISON1);
+		BUG_ON(CORRUPTED_DATA_STRUCTURE);
 		return false;
 	}
 	if (unlikely(prev == LIST_POISON2)) {
 		WARN(1, "list_del corruption, %p->prev is LIST_POISON2 (%p)\n",
 			entry, LIST_POISON2);
+		BUG_ON(CORRUPTED_DATA_STRUCTURE);
 		return false;
 	}
 	if (unlikely(prev->next != entry)) {
 		WARN(1, "list_del corruption. prev->next should be %p, but was %p\n",
 			entry, prev->next);
+		BUG_ON(CORRUPTED_DATA_STRUCTURE);
 		return false;
 	}
 	if (unlikely(next->prev != entry)) {
 		WARN(1, "list_del corruption. next->prev should be %p, but was %p\n",
 			entry, next->prev);
+		BUG_ON(CORRUPTED_DATA_STRUCTURE);
 		return false;
 	}
 	return true;
-- 
2.7.4
