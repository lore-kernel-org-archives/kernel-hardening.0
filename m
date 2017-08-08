Date: Mon, 7 Aug 2017 17:33:45 -0700
From: Kees Cook <keescook@chromium.org>
Message-ID: <20170808003345.GA107289@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [RFC][PATCH] timer: Add function-change canary
To: kernel-hardening@lists.openwall.com
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>, Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

This introduces canaries to struct timer_list in an effort to protect the
function callback pointer from getting rewritten during stack or heap
overflow attacks. The struct timer_list has become a recent target for
security flaw exploitation because it includes the "data" argument in
the structure, along with the function callback. This provides attackers
with a ROP-like primitive for performing limited kernel function calls
without needing all the prerequisites to stage a ROP attack.

Recent examples of exploits using struct timer_list attacks:

http://www.openwall.com/lists/oss-security/2016/12/06/1
(https://www.exploit-db.com/exploits/40871/)

https://googleprojectzero.blogspot.com/2017/05/exploiting-linux-kernel-via-packet.html
(https://www.exploit-db.com/exploits/41458/)

Timers normally have their callback functions initialized either via
the setup_timer_*() macros or manually before calls to add_timer(). The
per-timer canary gets set in either case, and then checked at timer
expiration time before calling the function.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/timer.h |  6 ++++--
 kernel/time/timer.c   | 45 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 48 insertions(+), 3 deletions(-)

diff --git a/include/linux/timer.h b/include/linux/timer.h
index e6789b8757d5..9aac0da9d2ec 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -16,6 +16,7 @@ struct timer_list {
 	 */
 	struct hlist_node	entry;
 	unsigned long		expires;
+	unsigned long		canary;
 	void			(*function)(unsigned long);
 	unsigned long		data;
 	u32			flags;
@@ -91,6 +92,7 @@ struct timer_list {
 
 void init_timer_key(struct timer_list *timer, unsigned int flags,
 		    const char *name, struct lock_class_key *key);
+void init_timer_func(struct timer_list *timer, void (*func)(unsigned long));
 
 #ifdef CONFIG_DEBUG_OBJECTS_TIMERS
 extern void init_timer_on_stack_key(struct timer_list *timer,
@@ -140,14 +142,14 @@ static inline void init_timer_on_stack_key(struct timer_list *timer,
 #define __setup_timer(_timer, _fn, _data, _flags)			\
 	do {								\
 		__init_timer((_timer), (_flags));			\
-		(_timer)->function = (_fn);				\
+		init_timer_func((_timer), (_fn));			\
 		(_timer)->data = (_data);				\
 	} while (0)
 
 #define __setup_timer_on_stack(_timer, _fn, _data, _flags)		\
 	do {								\
 		__init_timer_on_stack((_timer), (_flags));		\
-		(_timer)->function = (_fn);				\
+		init_timer_func((_timer), (_fn));			\
 		(_timer)->data = (_data);				\
 	} while (0)
 
diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index 71ce3f4eead3..bc8ae8ef9106 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -44,6 +44,7 @@
 #include <linux/sched/debug.h>
 #include <linux/slab.h>
 #include <linux/compat.h>
+#include <linux/random.h>
 
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
@@ -1060,6 +1061,34 @@ int mod_timer(struct timer_list *timer, unsigned long expires)
 }
 EXPORT_SYMBOL(mod_timer);
 
+static DEFINE_MUTEX(timer_canary_mutex);
+static unsigned long timer_canary __ro_after_init;
+
+/**
+ * init_timer_func - set the function used for the timer
+ * @timer: the timer to be updated
+ * @func: the function to be called by the timer
+ *
+ * This should only be called once per timer creation to set the function.
+ * Normally used via the setup_timer_*() macros or add_timer().
+ */
+void init_timer_func(struct timer_list *timer, void (*func)(unsigned long))
+{
+	/* Initialize the global timer canary on first use. */
+	if (!timer_canary) {
+		mutex_lock(&timer_canary_mutex);
+		if (!timer_canary)
+			timer_canary = get_random_long();
+		mutex_unlock(&timer_canary_mutex);
+	}
+
+	/* Record timer canary for this timer function. */
+	timer->function = func;
+	timer->canary = (unsigned long)timer->function ^
+			(unsigned long)timer ^ timer_canary;
+}
+EXPORT_SYMBOL(init_timer_func);
+
 /**
  * add_timer - start a timer
  * @timer: the timer to be added
@@ -1077,6 +1106,7 @@ EXPORT_SYMBOL(mod_timer);
 void add_timer(struct timer_list *timer)
 {
 	BUG_ON(timer_pending(timer));
+	init_timer_func(timer, timer->function);
 	mod_timer(timer, timer->expires);
 }
 EXPORT_SYMBOL(add_timer);
@@ -1095,6 +1125,7 @@ void add_timer_on(struct timer_list *timer, int cpu)
 
 	BUG_ON(timer_pending(timer) || !timer->function);
 
+	init_timer_func(timer, timer->function);
 	new_base = get_timer_cpu_base(timer->flags, cpu);
 
 	/*
@@ -1244,6 +1275,7 @@ static void call_timer_fn(struct timer_list *timer, void (*fn)(unsigned long),
 			  unsigned long data)
 {
 	int count = preempt_count();
+	void (*badfn)(unsigned long) = NULL;
 
 #ifdef CONFIG_LOCKDEP
 	/*
@@ -1265,7 +1297,14 @@ static void call_timer_fn(struct timer_list *timer, void (*fn)(unsigned long),
 	lock_map_acquire(&lockdep_map);
 
 	trace_timer_expire_entry(timer);
-	fn(data);
+
+	/* Make sure the timer function hasn't changed since canary set. */
+	if (((unsigned long)fn ^ (unsigned long)timer ^ timer->canary) !=
+	    timer_canary) {
+		badfn = fn;
+	} else
+		fn(data);
+
 	trace_timer_expire_exit(timer);
 
 	lock_map_release(&lockdep_map);
@@ -1281,6 +1320,10 @@ static void call_timer_fn(struct timer_list *timer, void (*fn)(unsigned long),
 		 */
 		preempt_count_set(count);
 	}
+
+	WARN_RATELIMIT(badfn,
+		"timer: corrupt timer function (was %pF)\n",
+		(void *)((unsigned long)timer ^ timer->canary ^ timer_canary));
 }
 
 static void expire_timers(struct timer_base *base, struct hlist_head *head)
-- 
2.7.4


-- 
Kees Cook
Pixel Security
