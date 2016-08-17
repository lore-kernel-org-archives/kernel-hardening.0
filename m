Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Wed, 17 Aug 2016 14:42:11 -0700
Message-Id: <1471470132-29499-5-git-send-email-keescook@chromium.org>
In-Reply-To: <1471470132-29499-1-git-send-email-keescook@chromium.org>
References: <1471470132-29499-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v3 4/5] bug: Provide toggle for BUG on data corruption
To: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Daniel Micay <danielmicay@gmail.com>, Joe Perches <joe@perches.com>, Stephen Boyd <sboyd@codeaurora.org>, Syed Rameez Mustafa <rameezmustafa@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Josh Triplett <josh@joshtriplett.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Michael Ellerman <mpe@ellerman.id.au>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Thomas Gleixner <tglx@linutronix.de>, Josef Bacik <jbacik@fb.com>, Ingo Molnar <mingo@kernel.org>, Tejun Heo <tj@kernel.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Nikolay Aleksandrov <nikolay@cumulusnetworks.com>, Dmitry Vyukov <dvyukov@google.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

The kernel checks for cases of data structure corruption under some
CONFIGs (e.g. CONFIG_DEBUG_LIST). When corruption is detected, some
systems may want to BUG() immediately instead of letting the system run
with known corruption.  Usually these kinds of manipulation primitives can
be used by security flaws to gain arbitrary memory write control. This
provides a new config CONFIG_BUG_ON_DATA_CORRUPTION and a corresponding
macro CHECK_DATA_CORRUPTION for handling these situations. Notably, even
if not BUGing, the kernel should not continue processing the corrupted
structure.

This is inspired by similar hardening by Syed Rameez Mustafa in MSM
kernels, and in PaX and Grsecurity, which is likely in response to earlier
removal of the BUG calls in commit 924d9addb9b1 ("list debugging: use
WARN() instead of BUG()").

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/bug.h | 17 ++++++++++++++++
 lib/Kconfig.debug   | 10 ++++++++++
 lib/list_debug.c    | 57 +++++++++++++++++++++--------------------------------
 3 files changed, 49 insertions(+), 35 deletions(-)

diff --git a/include/linux/bug.h b/include/linux/bug.h
index e51b0709e78d..51a486f4eb4c 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -118,4 +118,21 @@ static inline enum bug_trap_type report_bug(unsigned long bug_addr,
 }
 
 #endif	/* CONFIG_GENERIC_BUG */
+
+/*
+ * Since detected data corruption should stop operation on the affected
+ * structures, this returns false if the corruption condition is found.
+ */
+#define CHECK_DATA_CORRUPTION(condition, fmt, ...)			 \
+	do {								 \
+		if (unlikely(condition)) {				 \
+			if (IS_ENABLED(CONFIG_BUG_ON_DATA_CORRUPTION)) { \
+				pr_err(fmt, ##__VA_ARGS__);		 \
+				BUG();					 \
+			} else						 \
+				WARN(1, fmt, ##__VA_ARGS__);		 \
+			return false;					 \
+		}							 \
+	} while (0)
+
 #endif	/* _LINUX_BUG_H */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 2307d7c89dac..58d358a4c7f3 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1987,6 +1987,16 @@ config TEST_STATIC_KEYS
 
 	  If unsure, say N.
 
+config BUG_ON_DATA_CORRUPTION
+	bool "Trigger a BUG when data corruption is detected"
+	select CONFIG_DEBUG_LIST
+	help
+	  Select this option if the kernel should BUG when it encounters
+	  data corruption in kernel memory structures when they get checked
+	  for validity.
+
+	  If unsure, say N.
+
 source "samples/Kconfig"
 
 source "lib/Kconfig.kgdb"
diff --git a/lib/list_debug.c b/lib/list_debug.c
index 276565fca2a6..7f7bfa55eb6d 100644
--- a/lib/list_debug.c
+++ b/lib/list_debug.c
@@ -20,21 +20,16 @@
 bool __list_add_valid(struct list_head *new, struct list_head *prev,
 		      struct list_head *next)
 {
-	if (unlikely(next->prev != prev)) {
-		WARN(1, "list_add corruption. next->prev should be prev (%p), but was %p. (next=%p).\n",
-			prev, next->prev, next);
-		return false;
-	}
-	if (unlikely(prev->next != next)) {
-		WARN(1, "list_add corruption. prev->next should be next (%p), but was %p. (prev=%p).\n",
-			next, prev->next, prev);
-		return false;
-	}
-	if (unlikely(new == prev || new == next)) {
-		WARN(1, "list_add double add: new=%p, prev=%p, next=%p.\n",
-			new, prev, next);
-		return false;
-	}
+	CHECK_DATA_CORRUPTION(next->prev != prev,
+		"list_add corruption. next->prev should be prev (%p), but was %p. (next=%p).\n",
+		prev, next->prev, next);
+	CHECK_DATA_CORRUPTION(prev->next != next,
+		"list_add corruption. prev->next should be next (%p), but was %p. (prev=%p).\n",
+		next, prev->next, prev);
+	CHECK_DATA_CORRUPTION(new == prev || new == next,
+		"list_add double add: new=%p, prev=%p, next=%p.\n",
+		new, prev, next);
+
 	return true;
 }
 EXPORT_SYMBOL(__list_add_valid);
@@ -46,26 +41,18 @@ bool __list_del_entry_valid(struct list_head *entry)
 	prev = entry->prev;
 	next = entry->next;
 
-	if (unlikely(next == LIST_POISON1)) {
-		WARN(1, "list_del corruption, %p->next is LIST_POISON1 (%p)\n",
-			entry, LIST_POISON1);
-		return false;
-	}
-	if (unlikely(prev == LIST_POISON2)) {
-		WARN(1, "list_del corruption, %p->prev is LIST_POISON2 (%p)\n",
-			entry, LIST_POISON2);
-		return false;
-	}
-	if (unlikely(prev->next != entry)) {
-		WARN(1, "list_del corruption. prev->next should be %p, but was %p\n",
-			entry, prev->next);
-		return false;
-	}
-	if (unlikely(next->prev != entry)) {
-		WARN(1, "list_del corruption. next->prev should be %p, but was %p\n",
-			entry, next->prev);
-		return false;
-	}
+	CHECK_DATA_CORRUPTION(next == LIST_POISON1,
+		"list_del corruption, %p->next is LIST_POISON1 (%p)\n",
+		entry, LIST_POISON1);
+	CHECK_DATA_CORRUPTION(prev == LIST_POISON2,
+		"list_del corruption, %p->prev is LIST_POISON2 (%p)\n",
+		entry, LIST_POISON2);
+	CHECK_DATA_CORRUPTION(prev->next != entry,
+		"list_del corruption. prev->next should be %p, but was %p\n",
+		entry, prev->next);
+	CHECK_DATA_CORRUPTION(next->prev != entry,
+		"list_del corruption. next->prev should be %p, but was %p\n",
+		entry, next->prev);
 	return true;
 
 }
-- 
2.7.4
