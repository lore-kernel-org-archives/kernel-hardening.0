Reply-To: kernel-hardening@lists.openwall.com
From: David Windsor <dave@progbits.org>
Date: Thu, 17 Dec 2015 09:57:41 -0500
Message-Id: <1450364270-12687-4-git-send-email-dave@progbits.org>
In-Reply-To: <1450364270-12687-1-git-send-email-dave@progbits.org>
References: <1450364270-12687-1-git-send-email-dave@progbits.org>
Subject: [kernel-hardening][RFC PATCH v2 03/12] kernel: opt out of PAX_REFCOUNT protection
To: kernel-hardening@lists.openwall.com
Cc: David Windsor <dave@progbits.org>
List-ID: <kernel-hardening.lists.openwall.com>

Signed-off-by: David Windsor <dave@progbits.org>
---
 include/linux/blktrace_api.h         |  2 +-
 include/linux/irqdesc.h              |  2 +-
 include/linux/kgdb.h                 |  2 +-
 include/linux/oprofile.h             |  4 +-
 include/linux/padata.h               |  2 +-
 include/linux/perf_event.h           |  8 +--
 include/linux/sched.h                |  2 +-
 include/video/udlfb.h                |  8 +--
 kernel/audit.c                       |  8 +--
 kernel/auditsc.c                     |  4 +-
 kernel/debug/debug_core.c            | 16 +++---
 kernel/events/core.c                 | 22 ++++-----
 kernel/irq/manage.c                  |  2 +-
 kernel/irq/spurious.c                |  2 +-
 kernel/locking/lockdep.c             |  2 +-
 kernel/locking/rtmutex-tester.c      | 24 ++++-----
 kernel/padata.c                      |  4 +-
 kernel/profile.c                     | 14 +++---
 kernel/rcu/rcutorture.c              | 60 +++++++++++-----------
 kernel/rcu/tree.c                    | 64 ++++++++++++------------
 kernel/rcu/tree.h                    | 26 +++++-----
 kernel/rcu/tree_plugin.h             | 12 ++---
 kernel/rcu/tree_trace.c              | 22 ++++-----
 kernel/sched/auto_group.c            |  4 +-
 kernel/time/timer_stats.c            | 10 ++--
 kernel/trace/blktrace.c              |  6 +--
 kernel/trace/ftrace.c                |  4 +-
 kernel/trace/ring_buffer.c           | 96 ++++++++++++++++++------------------
 kernel/trace/trace_clock.c           |  4 +-
 kernel/trace/trace_functions_graph.c |  4 +-
 kernel/trace/trace_mmiotrace.c       |  8 +--
 31 files changed, 224 insertions(+), 224 deletions(-)

diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index afc1343..9735539 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -25,7 +25,7 @@ struct blk_trace {
 	struct dentry *dropped_file;
 	struct dentry *msg_file;
 	struct list_head running_list;
-	atomic_t dropped;
+	atomic_unchecked_t dropped;
 };
 
 extern int blk_trace_ioctl(struct block_device *, unsigned, char __user *);
diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index fcea4e4..cff381d 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -59,7 +59,7 @@ struct irq_desc {
 	unsigned int		irq_count;	/* For detecting broken IRQs */
 	unsigned long		last_unhandled;	/* Aging timer for unhandled count */
 	unsigned int		irqs_unhandled;
-	atomic_t		threads_handled;
+	atomic_unchecked_t	threads_handled;
 	int			threads_handled_last;
 	raw_spinlock_t		lock;
 	struct cpumask		*percpu_enabled;
diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index e465bb1..9226a23 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -52,7 +52,7 @@ extern int kgdb_connected;
 extern int kgdb_io_module_registered;
 
 extern atomic_t			kgdb_setting_breakpoint;
-extern atomic_t			kgdb_cpu_doing_single_step;
+extern atomic_unchecked_t	kgdb_cpu_doing_single_step;
 
 extern struct task_struct	*kgdb_usethread;
 extern struct task_struct	*kgdb_contthread;
diff --git a/include/linux/oprofile.h b/include/linux/oprofile.h
index b2a0f15..4d7da32 100644
--- a/include/linux/oprofile.h
+++ b/include/linux/oprofile.h
@@ -138,9 +138,9 @@ int oprofilefs_create_ulong(struct dentry * root,
 int oprofilefs_create_ro_ulong(struct dentry * root,
 	char const * name, ulong * val);
  
-/** Create a file for read-only access to an atomic_t. */
+/** Create a file for read-only access to an atomic_unchecked_t. */
 int oprofilefs_create_ro_atomic(struct dentry * root,
-	char const * name, atomic_t * val);
+	char const * name, atomic_unchecked_t * val);
  
 /** create a directory */
 struct dentry *oprofilefs_mkdir(struct dentry *parent, char const *name);
diff --git a/include/linux/padata.h b/include/linux/padata.h
index 4386946..f50c615 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -129,7 +129,7 @@ struct parallel_data {
 	struct padata_serial_queue	__percpu *squeue;
 	atomic_t			reorder_objects;
 	atomic_t			refcnt;
-	atomic_t			seq_nr;
+	atomic_unchecked_t		seq_nr;
 	struct padata_cpumask		cpumask;
 	spinlock_t                      lock ____cacheline_aligned;
 	unsigned int			processed;
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 2027809..7e35ed1 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -385,7 +385,7 @@ struct perf_event {
 	enum perf_event_active_state	state;
 	unsigned int			attach_state;
 	local64_t			count;
-	atomic64_t			child_count;
+	atomic64_unchecked_t		child_count;
 
 	/*
 	 * These are the total time in nanoseconds that the event
@@ -436,8 +436,8 @@ struct perf_event {
 	 * These accumulate total time (in nanoseconds) that children
 	 * events have been enabled and running, respectively.
 	 */
-	atomic64_t			child_total_time_enabled;
-	atomic64_t			child_total_time_running;
+	atomic64_unchecked_t		child_total_time_enabled;
+	atomic64_unchecked_t		child_total_time_running;
 
 	/*
 	 * Protect attach/detach and child_list:
@@ -859,7 +859,7 @@ static inline void perf_event_task_sched_out(struct task_struct *prev,
 
 static inline u64 __perf_event_count(struct perf_event *event)
 {
-	return local64_read(&event->count) + atomic64_read(&event->child_count);
+	return local64_read(&event->count) + atomic64_read_unchecked(&event->child_count);
 }
 
 extern void perf_event_mmap(struct vm_area_struct *vma);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 20cf887..549ddc7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1770,7 +1770,7 @@ struct task_struct {
 	 * Number of functions that haven't been traced
 	 * because of depth overrun.
 	 */
-	atomic_t trace_overrun;
+	atomic_unchecked_t trace_overrun;
 	/* Pause for the tracing */
 	atomic_t tracing_graph_pause;
 #endif
diff --git a/include/video/udlfb.h b/include/video/udlfb.h
index f9466fa..f4e2b81 100644
--- a/include/video/udlfb.h
+++ b/include/video/udlfb.h
@@ -53,10 +53,10 @@ struct dlfb_data {
 	u32 pseudo_palette[256];
 	int blank_mode; /*one of FB_BLANK_ */
 	/* blit-only rendering path metrics, exposed through sysfs */
-	atomic_t bytes_rendered; /* raw pixel-bytes driver asked to render */
-	atomic_t bytes_identical; /* saved effort with backbuffer comparison */
-	atomic_t bytes_sent; /* to usb, after compression including overhead */
-	atomic_t cpu_kcycles_used; /* transpired during pixel processing */
+	atomic_unchecked_t bytes_rendered; /* raw pixel-bytes driver asked to render */
+	atomic_unchecked_t bytes_identical; /* saved effort with backbuffer comparison */
+	atomic_unchecked_t bytes_sent; /* to usb, after compression including overhead */
+	atomic_unchecked_t cpu_kcycles_used; /* transpired during pixel processing */
 };
 
 #define NR_USB_REQUEST_I2C_SUB_IO 0x02
diff --git a/kernel/audit.c b/kernel/audit.c
index f9e6065..3fcb6ab 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -124,7 +124,7 @@ u32		audit_sig_sid = 0;
    3) suppressed due to audit_rate_limit
    4) suppressed due to audit_backlog_limit
 */
-static atomic_t    audit_lost = ATOMIC_INIT(0);
+static atomic_unchecked_t    audit_lost = ATOMIC_INIT(0);
 
 /* The netlink socket. */
 static struct sock *audit_sock;
@@ -258,7 +258,7 @@ void audit_log_lost(const char *message)
 	unsigned long		now;
 	int			print;
 
-	atomic_inc(&audit_lost);
+	atomic_inc_unchecked(&audit_lost);
 
 	print = (audit_failure == AUDIT_FAIL_PANIC || !audit_rate_limit);
 
@@ -275,7 +275,7 @@ void audit_log_lost(const char *message)
 	if (print) {
 		if (printk_ratelimit())
 			pr_warn("audit_lost=%u audit_rate_limit=%u audit_backlog_limit=%u\n",
-				atomic_read(&audit_lost),
+				atomic_read_unchecked(&audit_lost),
 				audit_rate_limit,
 				audit_backlog_limit);
 		audit_panic(message);
@@ -833,7 +833,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		s.pid			= audit_pid;
 		s.rate_limit		= audit_rate_limit;
 		s.backlog_limit		= audit_backlog_limit;
-		s.lost			= atomic_read(&audit_lost);
+		s.lost			= atomic_read_unchecked(&audit_lost);
 		s.backlog		= skb_queue_len(&audit_skb_queue);
 		s.feature_bitmap	= AUDIT_FEATURE_BITMAP_ALL;
 		s.backlog_wait_time	= audit_backlog_wait_time_master;
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index e85bdfd..f964d33 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1952,7 +1952,7 @@ int auditsc_get_stamp(struct audit_context *ctx,
 }
 
 /* global counter which is incremented every time something logs in */
-static atomic_t session_id = ATOMIC_INIT(0);
+static atomic_unchecked_t session_id = ATOMIC_INIT(0);
 
 static int audit_set_loginuid_perm(kuid_t loginuid)
 {
@@ -2019,7 +2019,7 @@ int audit_set_loginuid(kuid_t loginuid)
 
 	/* are we setting or clearing? */
 	if (uid_valid(loginuid))
-		sessionid = (unsigned int)atomic_inc_return(&session_id);
+		sessionid = (unsigned int)atomic_inc_return_unchecked(&session_id);
 
 	task->sessionid = sessionid;
 	task->loginuid = loginuid;
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 0874e2e..5b32cc9 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -127,7 +127,7 @@ static DEFINE_RAW_SPINLOCK(dbg_slave_lock);
  */
 static atomic_t			masters_in_kgdb;
 static atomic_t			slaves_in_kgdb;
-static atomic_t			kgdb_break_tasklet_var;
+static atomic_unchecked_t	kgdb_break_tasklet_var;
 atomic_t			kgdb_setting_breakpoint;
 
 struct task_struct		*kgdb_usethread;
@@ -137,7 +137,7 @@ int				kgdb_single_step;
 static pid_t			kgdb_sstep_pid;
 
 /* to keep track of the CPU which is doing the single stepping*/
-atomic_t			kgdb_cpu_doing_single_step = ATOMIC_INIT(-1);
+atomic_unchecked_t		kgdb_cpu_doing_single_step = ATOMIC_INIT(-1);
 
 /*
  * If you are debugging a problem where roundup (the collection of
@@ -552,7 +552,7 @@ return_normal:
 	 * kernel will only try for the value of sstep_tries before
 	 * giving up and continuing on.
 	 */
-	if (atomic_read(&kgdb_cpu_doing_single_step) != -1 &&
+	if (atomic_read_unchecked(&kgdb_cpu_doing_single_step) != -1 &&
 	    (kgdb_info[cpu].task &&
 	     kgdb_info[cpu].task->pid != kgdb_sstep_pid) && --sstep_tries) {
 		atomic_set(&kgdb_active, -1);
@@ -654,8 +654,8 @@ cpu_master_loop:
 	}
 
 kgdb_restore:
-	if (atomic_read(&kgdb_cpu_doing_single_step) != -1) {
-		int sstep_cpu = atomic_read(&kgdb_cpu_doing_single_step);
+	if (atomic_read_unchecked(&kgdb_cpu_doing_single_step) != -1) {
+		int sstep_cpu = atomic_read_unchecked(&kgdb_cpu_doing_single_step);
 		if (kgdb_info[sstep_cpu].task)
 			kgdb_sstep_pid = kgdb_info[sstep_cpu].task->pid;
 		else
@@ -949,18 +949,18 @@ static void kgdb_unregister_callbacks(void)
 static void kgdb_tasklet_bpt(unsigned long ing)
 {
 	kgdb_breakpoint();
-	atomic_set(&kgdb_break_tasklet_var, 0);
+	atomic_set_unchecked(&kgdb_break_tasklet_var, 0);
 }
 
 static DECLARE_TASKLET(kgdb_tasklet_breakpoint, kgdb_tasklet_bpt, 0);
 
 void kgdb_schedule_breakpoint(void)
 {
-	if (atomic_read(&kgdb_break_tasklet_var) ||
+	if (atomic_read_unchecked(&kgdb_break_tasklet_var) ||
 		atomic_read(&kgdb_active) != -1 ||
 		atomic_read(&kgdb_setting_breakpoint))
 		return;
-	atomic_inc(&kgdb_break_tasklet_var);
+	atomic_inc_unchecked(&kgdb_break_tasklet_var);
 	tasklet_schedule(&kgdb_tasklet_breakpoint);
 }
 EXPORT_SYMBOL_GPL(kgdb_schedule_breakpoint);
diff --git a/kernel/events/core.c b/kernel/events/core.c
index e6feb51..b83b393 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -307,7 +307,7 @@ void perf_sample_event_took(u64 sample_len_ns)
 	}
 }
 
-static atomic64_t perf_event_id;
+static atomic64_unchecked_t perf_event_id;
 
 static void cpu_ctx_sched_out(struct perf_cpu_context *cpuctx,
 			      enum event_type_t event_type);
@@ -3753,9 +3753,9 @@ u64 perf_event_read_value(struct perf_event *event, u64 *enabled, u64 *running)
 	mutex_lock(&event->child_mutex);
 	total += perf_event_read(event);
 	*enabled += event->total_time_enabled +
-			atomic64_read(&event->child_total_time_enabled);
+			atomic64_read_unchecked(&event->child_total_time_enabled);
 	*running += event->total_time_running +
-			atomic64_read(&event->child_total_time_running);
+			atomic64_read_unchecked(&event->child_total_time_running);
 
 	list_for_each_entry(child, &event->child_list, child_list) {
 		total += perf_event_read(child);
@@ -4285,10 +4285,10 @@ void perf_event_update_userpage(struct perf_event *event)
 		userpg->offset -= local64_read(&event->hw.prev_count);
 
 	userpg->time_enabled = enabled +
-			atomic64_read(&event->child_total_time_enabled);
+			atomic64_read_unchecked(&event->child_total_time_enabled);
 
 	userpg->time_running = running +
-			atomic64_read(&event->child_total_time_running);
+			atomic64_read_unchecked(&event->child_total_time_running);
 
 	arch_perf_update_userpage(event, userpg, now);
 
@@ -5054,11 +5054,11 @@ static void perf_output_read_one(struct perf_output_handle *handle,
 	values[n++] = perf_event_count(event);
 	if (read_format & PERF_FORMAT_TOTAL_TIME_ENABLED) {
 		values[n++] = enabled +
-			atomic64_read(&event->child_total_time_enabled);
+			atomic64_read_unchecked(&event->child_total_time_enabled);
 	}
 	if (read_format & PERF_FORMAT_TOTAL_TIME_RUNNING) {
 		values[n++] = running +
-			atomic64_read(&event->child_total_time_running);
+			atomic64_read_unchecked(&event->child_total_time_running);
 	}
 	if (read_format & PERF_FORMAT_ID)
 		values[n++] = primary_event_id(event);
@@ -7588,7 +7588,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	event->parent		= parent_event;
 
 	event->ns		= get_pid_ns(task_active_pid_ns(current));
-	event->id		= atomic64_inc_return(&perf_event_id);
+	event->id		= atomic64_inc_return_unchecked(&perf_event_id);
 
 	event->state		= PERF_EVENT_STATE_INACTIVE;
 
@@ -8395,10 +8395,10 @@ static void sync_child_event(struct perf_event *child_event,
 	/*
 	 * Add back the child's count to the parent's count:
 	 */
-	atomic64_add(child_val, &parent_event->child_count);
-	atomic64_add(child_event->total_time_enabled,
+	atomic64_add_unchecked(child_val, &parent_event->child_count);
+	atomic64_add_unchecked(child_event->total_time_enabled,
 		     &parent_event->child_total_time_enabled);
-	atomic64_add(child_event->total_time_running,
+	atomic64_add_unchecked(child_event->total_time_running,
 		     &parent_event->child_total_time_running);
 
 	/*
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index f974485..c5b8afd 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -937,7 +937,7 @@ static int irq_thread(void *data)
 
 		action_ret = handler_fn(desc, action);
 		if (action_ret == IRQ_HANDLED)
-			atomic_inc(&desc->threads_handled);
+			atomic_inc_unchecked(&desc->threads_handled);
 
 		wake_threads_waitq(desc);
 	}
diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index e2514b0..de3dfe0 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -337,7 +337,7 @@ void note_interrupt(unsigned int irq, struct irq_desc *desc,
 			 * count. We just care about the count being
 			 * different than the one we saw before.
 			 */
-			handled = atomic_read(&desc->threads_handled);
+			handled = atomic_read_unchecked(&desc->threads_handled);
 			handled |= SPURIOUS_DEFERRED;
 			if (handled != desc->threads_handled_last) {
 				action_ret = IRQ_HANDLED;
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 8acfbf7..b9c128d 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -3102,7 +3102,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 		if (!class)
 			return 0;
 	}
-	atomic_inc((atomic_t *)&class->ops);
+	atomic_long_inc_unchecked((atomic_long_unchecked_t *)&class->ops);
 	if (very_verbose(class)) {
 		printk("\nacquire class [%p] %s", class->key, class->name);
 		if (class->name_version > 1)
diff --git a/kernel/locking/rtmutex-tester.c b/kernel/locking/rtmutex-tester.c
index 1d96dd0..994ff19 100644
--- a/kernel/locking/rtmutex-tester.c
+++ b/kernel/locking/rtmutex-tester.c
@@ -22,7 +22,7 @@
 #define MAX_RT_TEST_MUTEXES	8
 
 static spinlock_t rttest_lock;
-static atomic_t rttest_event;
+static atomic_unchecked_t rttest_event;
 
 struct test_thread_data {
 	int			opcode;
@@ -63,7 +63,7 @@ static int handle_op(struct test_thread_data *td, int lockwakeup)
 
 	case RTTEST_LOCKCONT:
 		td->mutexes[td->opdata] = 1;
-		td->event = atomic_add_return(1, &rttest_event);
+		td->event = atomic_add_return_unchecked(1, &rttest_event);
 		return 0;
 
 	case RTTEST_RESET:
@@ -76,7 +76,7 @@ static int handle_op(struct test_thread_data *td, int lockwakeup)
 		return 0;
 
 	case RTTEST_RESETEVENT:
-		atomic_set(&rttest_event, 0);
+		atomic_set_unchecked(&rttest_event, 0);
 		return 0;
 
 	default:
@@ -93,9 +93,9 @@ static int handle_op(struct test_thread_data *td, int lockwakeup)
 			return ret;
 
 		td->mutexes[id] = 1;
-		td->event = atomic_add_return(1, &rttest_event);
+		td->event = atomic_add_return_unchecked(1, &rttest_event);
 		rt_mutex_lock(&mutexes[id]);
-		td->event = atomic_add_return(1, &rttest_event);
+		td->event = atomic_add_return_unchecked(1, &rttest_event);
 		td->mutexes[id] = 4;
 		return 0;
 
@@ -106,9 +106,9 @@ static int handle_op(struct test_thread_data *td, int lockwakeup)
 			return ret;
 
 		td->mutexes[id] = 1;
-		td->event = atomic_add_return(1, &rttest_event);
+		td->event = atomic_add_return_unchecked(1, &rttest_event);
 		ret = rt_mutex_lock_interruptible(&mutexes[id], 0);
-		td->event = atomic_add_return(1, &rttest_event);
+		td->event = atomic_add_return_unchecked(1, &rttest_event);
 		td->mutexes[id] = ret ? 0 : 4;
 		return ret ? -EINTR : 0;
 
@@ -117,9 +117,9 @@ static int handle_op(struct test_thread_data *td, int lockwakeup)
 		if (id < 0 || id >= MAX_RT_TEST_MUTEXES || td->mutexes[id] != 4)
 			return ret;
 
-		td->event = atomic_add_return(1, &rttest_event);
+		td->event = atomic_add_return_unchecked(1, &rttest_event);
 		rt_mutex_unlock(&mutexes[id]);
-		td->event = atomic_add_return(1, &rttest_event);
+		td->event = atomic_add_return_unchecked(1, &rttest_event);
 		td->mutexes[id] = 0;
 		return 0;
 
@@ -166,7 +166,7 @@ void schedule_rt_mutex_test(struct rt_mutex *mutex)
 			break;
 
 		td->mutexes[dat] = 2;
-		td->event = atomic_add_return(1, &rttest_event);
+		td->event = atomic_add_return_unchecked(1, &rttest_event);
 		break;
 
 	default:
@@ -186,7 +186,7 @@ void schedule_rt_mutex_test(struct rt_mutex *mutex)
 			return;
 
 		td->mutexes[dat] = 3;
-		td->event = atomic_add_return(1, &rttest_event);
+		td->event = atomic_add_return_unchecked(1, &rttest_event);
 		break;
 
 	case RTTEST_LOCKNOWAIT:
@@ -198,7 +198,7 @@ void schedule_rt_mutex_test(struct rt_mutex *mutex)
 			return;
 
 		td->mutexes[dat] = 1;
-		td->event = atomic_add_return(1, &rttest_event);
+		td->event = atomic_add_return_unchecked(1, &rttest_event);
 		return;
 
 	default:
diff --git a/kernel/padata.c b/kernel/padata.c
index b38bea9..91acfbe 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -54,7 +54,7 @@ static int padata_cpu_hash(struct parallel_data *pd)
 	 * seq_nr mod. number of cpus in use.
 	 */
 
-	seq_nr = atomic_inc_return(&pd->seq_nr);
+	seq_nr = atomic_inc_return_unchecked(&pd->seq_nr);
 	cpu_index = seq_nr % cpumask_weight(pd->cpumask.pcpu);
 
 	return padata_index_to_cpu(pd, cpu_index);
@@ -428,7 +428,7 @@ static struct parallel_data *padata_alloc_pd(struct padata_instance *pinst,
 	padata_init_pqueues(pd);
 	padata_init_squeues(pd);
 	setup_timer(&pd->timer, padata_reorder_timer, (unsigned long)pd);
-	atomic_set(&pd->seq_nr, -1);
+	atomic_set_unchecked(&pd->seq_nr, -1);
 	atomic_set(&pd->reorder_objects, 0);
 	atomic_set(&pd->refcnt, 0);
 	pd->pinst = pinst;
diff --git a/kernel/profile.c b/kernel/profile.c
index a7bcd28..5b368fa 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -37,7 +37,7 @@ struct profile_hit {
 #define NR_PROFILE_HIT		(PAGE_SIZE/sizeof(struct profile_hit))
 #define NR_PROFILE_GRP		(NR_PROFILE_HIT/PROFILE_GRPSZ)
 
-static atomic_t *prof_buffer;
+static atomic_unchecked_t *prof_buffer;
 static unsigned long prof_len, prof_shift;
 
 int prof_on __read_mostly;
@@ -256,7 +256,7 @@ static void profile_flip_buffers(void)
 					hits[i].pc = 0;
 				continue;
 			}
-			atomic_add(hits[i].hits, &prof_buffer[hits[i].pc]);
+			atomic_add_unchecked(hits[i].hits, &prof_buffer[hits[i].pc]);
 			hits[i].hits = hits[i].pc = 0;
 		}
 	}
@@ -317,9 +317,9 @@ static void do_profile_hits(int type, void *__pc, unsigned int nr_hits)
 	 * Add the current hit(s) and flush the write-queue out
 	 * to the global buffer:
 	 */
-	atomic_add(nr_hits, &prof_buffer[pc]);
+	atomic_add_unchecked(nr_hits, &prof_buffer[pc]);
 	for (i = 0; i < NR_PROFILE_HIT; ++i) {
-		atomic_add(hits[i].hits, &prof_buffer[hits[i].pc]);
+		atomic_add_unchecked(hits[i].hits, &prof_buffer[hits[i].pc]);
 		hits[i].pc = hits[i].hits = 0;
 	}
 out:
@@ -394,7 +394,7 @@ static void do_profile_hits(int type, void *__pc, unsigned int nr_hits)
 {
 	unsigned long pc;
 	pc = ((unsigned long)__pc - (unsigned long)_stext) >> prof_shift;
-	atomic_add(nr_hits, &prof_buffer[min(pc, prof_len - 1)]);
+	atomic_add_unchecked(nr_hits, &prof_buffer[min(pc, prof_len - 1)]);
 }
 #endif /* !CONFIG_SMP */
 
@@ -489,7 +489,7 @@ read_profile(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 			return -EFAULT;
 		buf++; p++; count--; read++;
 	}
-	pnt = (char *)prof_buffer + p - sizeof(atomic_t);
+	pnt = (char *)prof_buffer + p - sizeof(atomic_unchecked_t);
 	if (copy_to_user(buf, (void *)pnt, count))
 		return -EFAULT;
 	read += count;
@@ -520,7 +520,7 @@ static ssize_t write_profile(struct file *file, const char __user *buf,
 	}
 #endif
 	profile_discard_flip_buffers();
-	memset(prof_buffer, 0, prof_len * sizeof(atomic_t));
+	memset(prof_buffer, 0, prof_len * sizeof(atomic_unchecked_t));
 	return count;
 }
 
diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 59e3268..d2eb3d9 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -134,12 +134,12 @@ static DEFINE_PER_CPU(long [RCU_TORTURE_PIPE_LEN + 1],
 		      rcu_torture_count) = { 0 };
 static DEFINE_PER_CPU(long [RCU_TORTURE_PIPE_LEN + 1],
 		      rcu_torture_batch) = { 0 };
-static atomic_t rcu_torture_wcount[RCU_TORTURE_PIPE_LEN + 1];
-static atomic_t n_rcu_torture_alloc;
-static atomic_t n_rcu_torture_alloc_fail;
-static atomic_t n_rcu_torture_free;
-static atomic_t n_rcu_torture_mberror;
-static atomic_t n_rcu_torture_error;
+static atomic_unchecked_t rcu_torture_wcount[RCU_TORTURE_PIPE_LEN + 1];
+static atomic_unchecked_t n_rcu_torture_alloc;
+static atomic_unchecked_t n_rcu_torture_alloc_fail;
+static atomic_unchecked_t n_rcu_torture_free;
+static atomic_unchecked_t n_rcu_torture_mberror;
+static atomic_unchecked_t n_rcu_torture_error;
 static long n_rcu_torture_barrier_error;
 static long n_rcu_torture_boost_ktrerror;
 static long n_rcu_torture_boost_rterror;
@@ -148,7 +148,7 @@ static long n_rcu_torture_boosts;
 static long n_rcu_torture_timers;
 static long n_barrier_attempts;
 static long n_barrier_successes;
-static atomic_long_t n_cbfloods;
+static atomic_long_unchecked_t n_cbfloods;
 static struct list_head rcu_torture_removed;
 
 static int rcu_torture_writer_state;
@@ -211,11 +211,11 @@ rcu_torture_alloc(void)
 
 	spin_lock_bh(&rcu_torture_lock);
 	if (list_empty(&rcu_torture_freelist)) {
-		atomic_inc(&n_rcu_torture_alloc_fail);
+		atomic_inc_unchecked(&n_rcu_torture_alloc_fail);
 		spin_unlock_bh(&rcu_torture_lock);
 		return NULL;
 	}
-	atomic_inc(&n_rcu_torture_alloc);
+	atomic_inc_unchecked(&n_rcu_torture_alloc);
 	p = rcu_torture_freelist.next;
 	list_del_init(p);
 	spin_unlock_bh(&rcu_torture_lock);
@@ -228,7 +228,7 @@ rcu_torture_alloc(void)
 static void
 rcu_torture_free(struct rcu_torture *p)
 {
-	atomic_inc(&n_rcu_torture_free);
+	atomic_inc_unchecked(&n_rcu_torture_free);
 	spin_lock_bh(&rcu_torture_lock);
 	list_add_tail(&p->rtort_free, &rcu_torture_freelist);
 	spin_unlock_bh(&rcu_torture_lock);
@@ -309,7 +309,7 @@ rcu_torture_pipe_update_one(struct rcu_torture *rp)
 	i = rp->rtort_pipe_count;
 	if (i > RCU_TORTURE_PIPE_LEN)
 		i = RCU_TORTURE_PIPE_LEN;
-	atomic_inc(&rcu_torture_wcount[i]);
+	atomic_inc_unchecked(&rcu_torture_wcount[i]);
 	if (++rp->rtort_pipe_count >= RCU_TORTURE_PIPE_LEN) {
 		rp->rtort_mbtest = 0;
 		return true;
@@ -830,7 +830,7 @@ rcu_torture_cbflood(void *arg)
 	VERBOSE_TOROUT_STRING("rcu_torture_cbflood task started");
 	do {
 		schedule_timeout_interruptible(cbflood_inter_holdoff);
-		atomic_long_inc(&n_cbfloods);
+		atomic_long_inc_unchecked(&n_cbfloods);
 		WARN_ON(signal_pending(current));
 		for (i = 0; i < cbflood_n_burst; i++) {
 			for (j = 0; j < cbflood_n_per_burst; j++) {
@@ -957,7 +957,7 @@ rcu_torture_writer(void *arg)
 			i = old_rp->rtort_pipe_count;
 			if (i > RCU_TORTURE_PIPE_LEN)
 				i = RCU_TORTURE_PIPE_LEN;
-			atomic_inc(&rcu_torture_wcount[i]);
+			atomic_inc_unchecked(&rcu_torture_wcount[i]);
 			old_rp->rtort_pipe_count++;
 			switch (synctype[torture_random(&rand) % nsynctypes]) {
 			case RTWS_DEF_FREE:
@@ -1095,7 +1095,7 @@ static void rcu_torture_timer(unsigned long unused)
 		return;
 	}
 	if (p->rtort_mbtest == 0)
-		atomic_inc(&n_rcu_torture_mberror);
+		atomic_inc_unchecked(&n_rcu_torture_mberror);
 	spin_lock(&rand_lock);
 	cur_ops->read_delay(&rand);
 	n_rcu_torture_timers++;
@@ -1170,7 +1170,7 @@ rcu_torture_reader(void *arg)
 			continue;
 		}
 		if (p->rtort_mbtest == 0)
-			atomic_inc(&n_rcu_torture_mberror);
+			atomic_inc_unchecked(&n_rcu_torture_mberror);
 		cur_ops->read_delay(&rand);
 		preempt_disable();
 		pipe_count = p->rtort_pipe_count;
@@ -1239,11 +1239,11 @@ rcu_torture_stats_print(void)
 		rcu_torture_current,
 		rcu_torture_current_version,
 		list_empty(&rcu_torture_freelist),
-		atomic_read(&n_rcu_torture_alloc),
-		atomic_read(&n_rcu_torture_alloc_fail),
-		atomic_read(&n_rcu_torture_free));
+		atomic_read_unchecked(&n_rcu_torture_alloc),
+		atomic_read_unchecked(&n_rcu_torture_alloc_fail),
+		atomic_read_unchecked(&n_rcu_torture_free));
 	pr_cont("rtmbe: %d rtbke: %ld rtbre: %ld ",
-		atomic_read(&n_rcu_torture_mberror),
+		atomic_read_unchecked(&n_rcu_torture_mberror),
 		n_rcu_torture_boost_ktrerror,
 		n_rcu_torture_boost_rterror);
 	pr_cont("rtbf: %ld rtb: %ld nt: %ld ",
@@ -1255,17 +1255,17 @@ rcu_torture_stats_print(void)
 		n_barrier_successes,
 		n_barrier_attempts,
 		n_rcu_torture_barrier_error);
-	pr_cont("cbflood: %ld\n", atomic_long_read(&n_cbfloods));
+	pr_cont("cbflood: %ld\n", atomic_long_read_unchecked(&n_cbfloods));
 
 	pr_alert("%s%s ", torture_type, TORTURE_FLAG);
-	if (atomic_read(&n_rcu_torture_mberror) != 0 ||
+	if (atomic_read_unchecked(&n_rcu_torture_mberror) != 0 ||
 	    n_rcu_torture_barrier_error != 0 ||
 	    n_rcu_torture_boost_ktrerror != 0 ||
 	    n_rcu_torture_boost_rterror != 0 ||
 	    n_rcu_torture_boost_failure != 0 ||
 	    i > 1) {
 		pr_cont("%s", "!!! ");
-		atomic_inc(&n_rcu_torture_error);
+		atomic_inc_unchecked(&n_rcu_torture_error);
 		WARN_ON_ONCE(1);
 	}
 	pr_cont("Reader Pipe: ");
@@ -1282,7 +1282,7 @@ rcu_torture_stats_print(void)
 	pr_alert("%s%s ", torture_type, TORTURE_FLAG);
 	pr_cont("Free-Block Circulation: ");
 	for (i = 0; i < RCU_TORTURE_PIPE_LEN + 1; i++) {
-		pr_cont(" %d", atomic_read(&rcu_torture_wcount[i]));
+		pr_cont(" %d", atomic_read_unchecked(&rcu_torture_wcount[i]));
 	}
 	pr_cont("\n");
 
@@ -1636,7 +1636,7 @@ rcu_torture_cleanup(void)
 
 	rcu_torture_stats_print();  /* -After- the stats thread is stopped! */
 
-	if (atomic_read(&n_rcu_torture_error) || n_rcu_torture_barrier_error)
+	if (atomic_read_unchecked(&n_rcu_torture_error) || n_rcu_torture_barrier_error)
 		rcu_torture_print_module_parms(cur_ops, "End of test: FAILURE");
 	else if (torture_onoff_failures())
 		rcu_torture_print_module_parms(cur_ops,
@@ -1761,18 +1761,18 @@ rcu_torture_init(void)
 
 	rcu_torture_current = NULL;
 	rcu_torture_current_version = 0;
-	atomic_set(&n_rcu_torture_alloc, 0);
-	atomic_set(&n_rcu_torture_alloc_fail, 0);
-	atomic_set(&n_rcu_torture_free, 0);
-	atomic_set(&n_rcu_torture_mberror, 0);
-	atomic_set(&n_rcu_torture_error, 0);
+	atomic_set_unchecked(&n_rcu_torture_alloc, 0);
+	atomic_set_unchecked(&n_rcu_torture_alloc_fail, 0);
+	atomic_set_unchecked(&n_rcu_torture_free, 0);
+	atomic_set_unchecked(&n_rcu_torture_mberror, 0);
+	atomic_set_unchecked(&n_rcu_torture_error, 0);
 	n_rcu_torture_barrier_error = 0;
 	n_rcu_torture_boost_ktrerror = 0;
 	n_rcu_torture_boost_rterror = 0;
 	n_rcu_torture_boost_failure = 0;
 	n_rcu_torture_boosts = 0;
 	for (i = 0; i < RCU_TORTURE_PIPE_LEN + 1; i++)
-		atomic_set(&rcu_torture_wcount[i], 0);
+		atomic_set_unchecked(&rcu_torture_wcount[i], 0);
 	for_each_possible_cpu(cpu) {
 		for (i = 0; i < RCU_TORTURE_PIPE_LEN + 1; i++) {
 			per_cpu(rcu_torture_count, cpu)[i] = 0;
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 65137bc..0827851 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -326,7 +326,7 @@ static void rcu_momentary_dyntick_idle(void)
 		 */
 		rdtp = this_cpu_ptr(&rcu_dynticks);
 		smp_mb__before_atomic(); /* Earlier stuff before QS. */
-		atomic_add(2, &rdtp->dynticks);  /* QS. */
+		atomic_add_unchecked(2, &rdtp->dynticks);  /* QS. */
 		smp_mb__after_atomic(); /* Later stuff after QS. */
 		break;
 	}
@@ -639,10 +639,10 @@ static void rcu_eqs_enter_common(long long oldval, bool user)
 	rcu_prepare_for_idle();
 	/* CPUs seeing atomic_inc() must see prior RCU read-side crit sects */
 	smp_mb__before_atomic();  /* See above. */
-	atomic_inc(&rdtp->dynticks);
+	atomic_inc_unchecked(&rdtp->dynticks);
 	smp_mb__after_atomic();  /* Force ordering with next sojourn. */
 	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) &&
-		     atomic_read(&rdtp->dynticks) & 0x1);
+		     atomic_read_unchecked(&rdtp->dynticks) & 0x1);
 	rcu_dynticks_task_enter();
 
 	/*
@@ -765,11 +765,11 @@ static void rcu_eqs_exit_common(long long oldval, int user)
 
 	rcu_dynticks_task_exit();
 	smp_mb__before_atomic();  /* Force ordering w/previous sojourn. */
-	atomic_inc(&rdtp->dynticks);
+	atomic_inc_unchecked(&rdtp->dynticks);
 	/* CPUs seeing atomic_inc() must see later RCU read-side crit sects */
 	smp_mb__after_atomic();  /* See above. */
 	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) &&
-		     !(atomic_read(&rdtp->dynticks) & 0x1));
+		     !(atomic_read_unchecked(&rdtp->dynticks) & 0x1));
 	rcu_cleanup_after_idle();
 	trace_rcu_dyntick(TPS("End"), oldval, rdtp->dynticks_nesting);
 	if (IS_ENABLED(CONFIG_RCU_EQS_DEBUG) &&
@@ -905,12 +905,12 @@ void rcu_nmi_enter(void)
 	 * to be in the outermost NMI handler that interrupted an RCU-idle
 	 * period (observation due to Andy Lutomirski).
 	 */
-	if (!(atomic_read(&rdtp->dynticks) & 0x1)) {
+	if (!(atomic_read_unchecked(&rdtp->dynticks) & 0x1)) {
 		smp_mb__before_atomic();  /* Force delay from prior write. */
-		atomic_inc(&rdtp->dynticks);
+		atomic_inc_unchecked(&rdtp->dynticks);
 		/* atomic_inc() before later RCU read-side crit sects */
 		smp_mb__after_atomic();  /* See above. */
-		WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
+		WARN_ON_ONCE(!(atomic_read_unchecked(&rdtp->dynticks) & 0x1));
 		incby = 1;
 	}
 	rdtp->dynticks_nmi_nesting += incby;
@@ -935,7 +935,7 @@ void rcu_nmi_exit(void)
 	 * to us!)
 	 */
 	WARN_ON_ONCE(rdtp->dynticks_nmi_nesting <= 0);
-	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
+	WARN_ON_ONCE(!(atomic_read_unchecked(&rdtp->dynticks) & 0x1));
 
 	/*
 	 * If the nesting level is not 1, the CPU wasn't RCU-idle, so
@@ -950,9 +950,9 @@ void rcu_nmi_exit(void)
 	rdtp->dynticks_nmi_nesting = 0;
 	/* CPUs seeing atomic_inc() must see prior RCU read-side crit sects */
 	smp_mb__before_atomic();  /* See above. */
-	atomic_inc(&rdtp->dynticks);
+	atomic_inc_unchecked(&rdtp->dynticks);
 	smp_mb__after_atomic();  /* Force delay to next write. */
-	WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);
+	WARN_ON_ONCE(atomic_read_unchecked(&rdtp->dynticks) & 0x1);
 }
 
 /**
@@ -965,7 +965,7 @@ void rcu_nmi_exit(void)
  */
 bool notrace __rcu_is_watching(void)
 {
-	return atomic_read(this_cpu_ptr(&rcu_dynticks.dynticks)) & 0x1;
+	return atomic_read_unchecked(this_cpu_ptr(&rcu_dynticks.dynticks)) & 0x1;
 }
 
 /**
@@ -1048,7 +1048,7 @@ static int rcu_is_cpu_rrupt_from_idle(void)
 static int dyntick_save_progress_counter(struct rcu_data *rdp,
 					 bool *isidle, unsigned long *maxj)
 {
-	rdp->dynticks_snap = atomic_add_return(0, &rdp->dynticks->dynticks);
+	rdp->dynticks_snap = atomic_add_return_unchecked(0, &rdp->dynticks->dynticks);
 	rcu_sysidle_check_cpu(rdp, isidle, maxj);
 	if ((rdp->dynticks_snap & 0x1) == 0) {
 		trace_rcu_fqs(rdp->rsp->name, rdp->gpnum, rdp->cpu, TPS("dti"));
@@ -1074,7 +1074,7 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp,
 	int *rcrmp;
 	unsigned int snap;
 
-	curr = (unsigned int)atomic_add_return(0, &rdp->dynticks->dynticks);
+	curr = (unsigned int)atomic_add_return_unchecked(0, &rdp->dynticks->dynticks);
 	snap = (unsigned int)rdp->dynticks_snap;
 
 	/*
@@ -3319,11 +3319,11 @@ void synchronize_sched_expedited(void)
 	 * counter wrap on a 32-bit system.  Quite a few more CPUs would of
 	 * course be required on a 64-bit system.
 	 */
-	if (ULONG_CMP_GE((ulong)atomic_long_read(&rsp->expedited_start),
+	if (ULONG_CMP_GE((ulong)atomic_long_read_unchecked(&rsp->expedited_start),
 			 (ulong)atomic_long_read(&rsp->expedited_done) +
 			 ULONG_MAX / 8)) {
 		wait_rcu_gp(call_rcu_sched);
-		atomic_long_inc(&rsp->expedited_wrap);
+		atomic_long_inc_return_unchecked(&rsp->expedited_wrap);
 		return;
 	}
 
@@ -3331,12 +3331,12 @@ void synchronize_sched_expedited(void)
 	 * Take a ticket.  Note that atomic_inc_return() implies a
 	 * full memory barrier.
 	 */
-	snap = atomic_long_inc_return(&rsp->expedited_start);
+	snap = atomic_long_inc_return_unchecked(&rsp->expedited_start);
 	firstsnap = snap;
 	if (!try_get_online_cpus()) {
 		/* CPU hotplug operation in flight, fall back to normal GP. */
 		wait_rcu_gp(call_rcu_sched);
-		atomic_long_inc(&rsp->expedited_normal);
+		atomic_long_inc_unchecked(&rsp->expedited_normal);
 		return;
 	}
 	WARN_ON_ONCE(cpu_is_offline(raw_smp_processor_id()));
@@ -3349,7 +3349,7 @@ void synchronize_sched_expedited(void)
 		for_each_cpu(cpu, cm) {
 			struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
 
-			if (!(atomic_add_return(0, &rdtp->dynticks) & 0x1))
+			if (!(atomic_add_return_unchecked(0, &rdtp->dynticks) & 0x1))
 				cpumask_clear_cpu(cpu, cm);
 		}
 		if (cpumask_weight(cm) == 0)
@@ -3364,14 +3364,14 @@ void synchronize_sched_expedited(void)
 			     synchronize_sched_expedited_cpu_stop,
 			     NULL) == -EAGAIN) {
 		put_online_cpus();
-		atomic_long_inc(&rsp->expedited_tryfail);
+		atomic_long_inc_unchecked(&rsp->expedited_tryfail);
 
 		/* Check to see if someone else did our work for us. */
 		s = atomic_long_read(&rsp->expedited_done);
 		if (ULONG_CMP_GE((ulong)s, (ulong)firstsnap)) {
 			/* ensure test happens before caller kfree */
 			smp_mb__before_atomic(); /* ^^^ */
-			atomic_long_inc(&rsp->expedited_workdone1);
+			atomic_long_inc_unchecked(&rsp->expedited_workdone1);
 			free_cpumask_var(cm);
 			return;
 		}
@@ -3381,7 +3381,7 @@ void synchronize_sched_expedited(void)
 			udelay(trycount * num_online_cpus());
 		} else {
 			wait_rcu_gp(call_rcu_sched);
-			atomic_long_inc(&rsp->expedited_normal);
+			atomic_long_inc_unchecked(&rsp->expedited_normal);
 			free_cpumask_var(cm);
 			return;
 		}
@@ -3391,7 +3391,7 @@ void synchronize_sched_expedited(void)
 		if (ULONG_CMP_GE((ulong)s, (ulong)firstsnap)) {
 			/* ensure test happens before caller kfree */
 			smp_mb__before_atomic(); /* ^^^ */
-			atomic_long_inc(&rsp->expedited_workdone2);
+			atomic_long_inc_unchecked(&rsp->expedited_workdone2);
 			free_cpumask_var(cm);
 			return;
 		}
@@ -3406,14 +3406,14 @@ void synchronize_sched_expedited(void)
 		if (!try_get_online_cpus()) {
 			/* CPU hotplug operation in flight, use normal GP. */
 			wait_rcu_gp(call_rcu_sched);
-			atomic_long_inc(&rsp->expedited_normal);
+			atomic_long_inc_unchecked(&rsp->expedited_normal);
 			free_cpumask_var(cm);
 			return;
 		}
-		snap = atomic_long_read(&rsp->expedited_start);
+		snap = atomic_long_read_unchecked(&rsp->expedited_start);
 		smp_mb(); /* ensure read is before try_stop_cpus(). */
 	}
-	atomic_long_inc(&rsp->expedited_stoppedcpus);
+	atomic_long_inc_unchecked(&rsp->expedited_stoppedcpus);
 
 all_cpus_idle:
 	free_cpumask_var(cm);
@@ -3425,16 +3425,16 @@ all_cpus_idle:
 	 * than we did already did their update.
 	 */
 	do {
-		atomic_long_inc(&rsp->expedited_done_tries);
+		atomic_long_inc_unchecked(&rsp->expedited_done_tries);
 		s = atomic_long_read(&rsp->expedited_done);
 		if (ULONG_CMP_GE((ulong)s, (ulong)snap)) {
 			/* ensure test happens before caller kfree */
 			smp_mb__before_atomic(); /* ^^^ */
-			atomic_long_inc(&rsp->expedited_done_lost);
+			atomic_long_inc_unchecked(&rsp->expedited_done_lost);
 			break;
 		}
 	} while (atomic_long_cmpxchg(&rsp->expedited_done, s, snap) != s);
-	atomic_long_inc(&rsp->expedited_done_exit);
+	atomic_long_inc_unchecked(&rsp->expedited_done_exit);
 
 	put_online_cpus();
 }
@@ -3767,7 +3767,7 @@ rcu_boot_init_percpu_data(int cpu, struct rcu_state *rsp)
 	rdp->grpmask = 1UL << (cpu - rdp->mynode->grplo);
 	rdp->dynticks = &per_cpu(rcu_dynticks, cpu);
 	WARN_ON_ONCE(rdp->dynticks->dynticks_nesting != DYNTICK_TASK_EXIT_IDLE);
-	WARN_ON_ONCE(atomic_read(&rdp->dynticks->dynticks) != 1);
+	WARN_ON_ONCE(atomic_read_unchecked(&rdp->dynticks->dynticks) != 1);
 	rdp->cpu = cpu;
 	rdp->rsp = rsp;
 	rcu_boot_init_nocb_percpu_data(rdp);
@@ -3798,8 +3798,8 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp)
 		init_callback_list(rdp);  /* Re-enable callbacks on this CPU. */
 	rdp->dynticks->dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
 	rcu_sysidle_init_percpu_data(rdp->dynticks);
-	atomic_set(&rdp->dynticks->dynticks,
-		   (atomic_read(&rdp->dynticks->dynticks) & ~0x1) + 1);
+	atomic_set_unchecked(&rdp->dynticks->dynticks,
+		   (atomic_read_unchecked(&rdp->dynticks->dynticks) & ~0x1) + 1);
 	raw_spin_unlock(&rnp->lock);		/* irqs remain disabled. */
 
 	/*
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 4adb7ca..20910e6 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -108,11 +108,11 @@ struct rcu_dynticks {
 	long long dynticks_nesting; /* Track irq/process nesting level. */
 				    /* Process level is worth LLONG_MAX/2. */
 	int dynticks_nmi_nesting;   /* Track NMI nesting level. */
-	atomic_t dynticks;	    /* Even value for idle, else odd. */
+	atomic_unchecked_t dynticks;/* Even value for idle, else odd. */
 #ifdef CONFIG_NO_HZ_FULL_SYSIDLE
 	long long dynticks_idle_nesting;
 				    /* irq/process nesting level from idle. */
-	atomic_t dynticks_idle;	    /* Even value for idle, else odd. */
+	atomic_unchecked_t dynticks_idle;/* Even value for idle, else odd. */
 				    /*  "Idle" excludes userspace execution. */
 	unsigned long dynticks_idle_jiffies;
 				    /* End of last non-NMI non-idle period. */
@@ -483,17 +483,17 @@ struct rcu_state {
 						/*  _rcu_barrier(). */
 	/* End of fields guarded by barrier_mutex. */
 
-	atomic_long_t expedited_start;		/* Starting ticket. */
-	atomic_long_t expedited_done;		/* Done ticket. */
-	atomic_long_t expedited_wrap;		/* # near-wrap incidents. */
-	atomic_long_t expedited_tryfail;	/* # acquisition failures. */
-	atomic_long_t expedited_workdone1;	/* # done by others #1. */
-	atomic_long_t expedited_workdone2;	/* # done by others #2. */
-	atomic_long_t expedited_normal;		/* # fallbacks to normal. */
-	atomic_long_t expedited_stoppedcpus;	/* # successful stop_cpus. */
-	atomic_long_t expedited_done_tries;	/* # tries to update _done. */
-	atomic_long_t expedited_done_lost;	/* # times beaten to _done. */
-	atomic_long_t expedited_done_exit;	/* # times exited _done loop. */
+	atomic_long_unchecked_t expedited_start;	/* Starting ticket. */
+	atomic_long_t expedited_done;			/* Done ticket. */
+	atomic_long_unchecked_t expedited_wrap;		/* # near-wrap incidents. */
+	atomic_long_unchecked_t expedited_tryfail;	/* # acquisition failures. */
+	atomic_long_unchecked_t expedited_workdone1;	/* # done by others #1. */
+	atomic_long_unchecked_t expedited_workdone2;	/* # done by others #2. */
+	atomic_long_unchecked_t expedited_normal;	/* # fallbacks to normal. */
+	atomic_long_unchecked_t expedited_stoppedcpus;	/* # successful stop_cpus. */
+	atomic_long_unchecked_t expedited_done_tries;	/* # tries to update _done. */
+	atomic_long_unchecked_t expedited_done_lost;	/* # times beaten to _done. */
+	atomic_long_unchecked_t expedited_done_exit;	/* # times exited _done loop. */
 
 	unsigned long jiffies_force_qs;		/* Time at which to invoke */
 						/*  force_quiescent_state(). */
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 013485f..a9fa510 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1767,7 +1767,7 @@ static void print_cpu_stall_info(struct rcu_state *rsp, int cpu)
 	print_cpu_stall_fast_no_hz(fast_no_hz, cpu);
 	pr_err("\t%d: (%lu %s) idle=%03x/%llx/%d softirq=%u/%u fqs=%ld %s\n",
 	       cpu, ticks_value, ticks_title,
-	       atomic_read(&rdtp->dynticks) & 0xfff,
+	       atomic_read_unchecked(&rdtp->dynticks) & 0xfff,
 	       rdtp->dynticks_nesting, rdtp->dynticks_nmi_nesting,
 	       rdp->softirq_snap, kstat_softirqs_cpu(RCU_SOFTIRQ, cpu),
 	       READ_ONCE(rsp->n_force_qs) - rsp->n_force_qs_gpstart,
@@ -2675,9 +2675,9 @@ static void rcu_sysidle_enter(int irq)
 	j = jiffies;
 	WRITE_ONCE(rdtp->dynticks_idle_jiffies, j);
 	smp_mb__before_atomic();
-	atomic_inc(&rdtp->dynticks_idle);
+	atomic_inc_unchecked(&rdtp->dynticks_idle);
 	smp_mb__after_atomic();
-	WARN_ON_ONCE(atomic_read(&rdtp->dynticks_idle) & 0x1);
+	WARN_ON_ONCE(atomic_read_unchecked(&rdtp->dynticks_idle) & 0x1);
 }
 
 /*
@@ -2748,9 +2748,9 @@ static void rcu_sysidle_exit(int irq)
 
 	/* Record end of idle period. */
 	smp_mb__before_atomic();
-	atomic_inc(&rdtp->dynticks_idle);
+	atomic_inc_unchecked(&rdtp->dynticks_idle);
 	smp_mb__after_atomic();
-	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks_idle) & 0x1));
+	WARN_ON_ONCE(!(atomic_read_unchecked(&rdtp->dynticks_idle) & 0x1));
 
 	/*
 	 * If we are the timekeeping CPU, we are permitted to be non-idle
@@ -2796,7 +2796,7 @@ static void rcu_sysidle_check_cpu(struct rcu_data *rdp, bool *isidle,
 	WARN_ON_ONCE(smp_processor_id() != tick_do_timer_cpu);
 
 	/* Pick up current idle and NMI-nesting counter and check. */
-	cur = atomic_read(&rdtp->dynticks_idle);
+	cur = atomic_read_unchecked(&rdtp->dynticks_idle);
 	if (cur & 0x1) {
 		*isidle = false; /* We are not idle! */
 		return;
diff --git a/kernel/rcu/tree_trace.c b/kernel/rcu/tree_trace.c
index 3ea7ffc..cb06f2d 100644
--- a/kernel/rcu/tree_trace.c
+++ b/kernel/rcu/tree_trace.c
@@ -125,7 +125,7 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->rcu_qs_ctr_snap == per_cpu(rcu_qs_ctr, rdp->cpu),
 		   rdp->qs_pending);
 	seq_printf(m, " dt=%d/%llx/%d df=%lu",
-		   atomic_read(&rdp->dynticks->dynticks),
+		   atomic_read_unchecked(&rdp->dynticks->dynticks),
 		   rdp->dynticks->dynticks_nesting,
 		   rdp->dynticks->dynticks_nmi_nesting,
 		   rdp->dynticks_fqs);
@@ -186,17 +186,17 @@ static int show_rcuexp(struct seq_file *m, void *v)
 	struct rcu_state *rsp = (struct rcu_state *)m->private;
 
 	seq_printf(m, "s=%lu d=%lu w=%lu tf=%lu wd1=%lu wd2=%lu n=%lu sc=%lu dt=%lu dl=%lu dx=%lu\n",
-		   atomic_long_read(&rsp->expedited_start),
+		   atomic_long_read_unchecked(&rsp->expedited_start),
 		   atomic_long_read(&rsp->expedited_done),
-		   atomic_long_read(&rsp->expedited_wrap),
-		   atomic_long_read(&rsp->expedited_tryfail),
-		   atomic_long_read(&rsp->expedited_workdone1),
-		   atomic_long_read(&rsp->expedited_workdone2),
-		   atomic_long_read(&rsp->expedited_normal),
-		   atomic_long_read(&rsp->expedited_stoppedcpus),
-		   atomic_long_read(&rsp->expedited_done_tries),
-		   atomic_long_read(&rsp->expedited_done_lost),
-		   atomic_long_read(&rsp->expedited_done_exit));
+		   atomic_long_read_unchecked(&rsp->expedited_wrap),
+		   atomic_long_read_unchecked(&rsp->expedited_tryfail),
+		   atomic_long_read_unchecked(&rsp->expedited_workdone1),
+		   atomic_long_read_unchecked(&rsp->expedited_workdone2),
+		   atomic_long_read_unchecked(&rsp->expedited_normal),
+		   atomic_long_read_unchecked(&rsp->expedited_stoppedcpus),
+		   atomic_long_read_unchecked(&rsp->expedited_done_tries),
+		   atomic_long_read_unchecked(&rsp->expedited_done_lost),
+		   atomic_long_read_unchecked(&rsp->expedited_done_exit));
 	return 0;
 }
 
diff --git a/kernel/sched/auto_group.c b/kernel/sched/auto_group.c
index 750ed60..eb01466 100644
--- a/kernel/sched/auto_group.c
+++ b/kernel/sched/auto_group.c
@@ -9,7 +9,7 @@
 
 unsigned int __read_mostly sysctl_sched_autogroup_enabled = 1;
 static struct autogroup autogroup_default;
-static atomic_t autogroup_seq_nr;
+static atomic_unchecked_t autogroup_seq_nr;
 
 void __init autogroup_init(struct task_struct *init_task)
 {
@@ -77,7 +77,7 @@ static inline struct autogroup *autogroup_create(void)
 
 	kref_init(&ag->kref);
 	init_rwsem(&ag->lock);
-	ag->id = atomic_inc_return(&autogroup_seq_nr);
+	ag->id = atomic_inc_return_unchecked(&autogroup_seq_nr);
 	ag->tg = tg;
 #ifdef CONFIG_RT_GROUP_SCHED
 	/*
diff --git a/kernel/time/timer_stats.c b/kernel/time/timer_stats.c
index 1adecb4..56bce1f 100644
--- a/kernel/time/timer_stats.c
+++ b/kernel/time/timer_stats.c
@@ -116,7 +116,7 @@ static ktime_t time_start, time_stop;
 static unsigned long nr_entries;
 static struct entry entries[MAX_ENTRIES];
 
-static atomic_t overflow_count;
+static atomic_unchecked_t overflow_count;
 
 /*
  * The entries are in a hash-table, for fast lookup:
@@ -140,7 +140,7 @@ static void reset_entries(void)
 	nr_entries = 0;
 	memset(entries, 0, sizeof(entries));
 	memset(tstat_hash_table, 0, sizeof(tstat_hash_table));
-	atomic_set(&overflow_count, 0);
+	atomic_set_unchecked(&overflow_count, 0);
 }
 
 static struct entry *alloc_entry(void)
@@ -261,7 +261,7 @@ void timer_stats_update_stats(void *timer, pid_t pid, void *startf,
 	if (likely(entry))
 		entry->count++;
 	else
-		atomic_inc(&overflow_count);
+		atomic_inc_unchecked(&overflow_count);
 
  out_unlock:
 	raw_spin_unlock_irqrestore(lock, flags);
@@ -300,8 +300,8 @@ static int tstats_show(struct seq_file *m, void *v)
 
 	seq_puts(m, "Timer Stats Version: v0.3\n");
 	seq_printf(m, "Sample period: %ld.%03ld s\n", period.tv_sec, ms);
-	if (atomic_read(&overflow_count))
-		seq_printf(m, "Overflow: %d entries\n", atomic_read(&overflow_count));
+	if (atomic_read_unchecked(&overflow_count))
+		seq_printf(m, "Overflow: %d entries\n", atomic_read_unchecked(&overflow_count));
 	seq_printf(m, "Collection: %s\n", timer_stats_active ? "active" : "inactive");
 
 	for (i = 0; i < nr_entries; i++) {
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index b3e6b39..719099b 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -328,7 +328,7 @@ static ssize_t blk_dropped_read(struct file *filp, char __user *buffer,
 	struct blk_trace *bt = filp->private_data;
 	char buf[16];
 
-	snprintf(buf, sizeof(buf), "%u\n", atomic_read(&bt->dropped));
+	snprintf(buf, sizeof(buf), "%u\n", atomic_read_unchecked(&bt->dropped));
 
 	return simple_read_from_buffer(buffer, count, ppos, buf, strlen(buf));
 }
@@ -386,7 +386,7 @@ static int blk_subbuf_start_callback(struct rchan_buf *buf, void *subbuf,
 		return 1;
 
 	bt = buf->chan->private_data;
-	atomic_inc(&bt->dropped);
+	atomic_inc_unchecked(&bt->dropped);
 	return 0;
 }
 
@@ -485,7 +485,7 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 
 	bt->dir = dir;
 	bt->dev = dev;
-	atomic_set(&bt->dropped, 0);
+	atomic_set_unchecked(&bt->dropped, 0);
 	INIT_LIST_HEAD(&bt->running_list);
 
 	ret = -EIO;
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index eb11011..07bf7ce 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5675,7 +5675,7 @@ static int alloc_retstack_tasklist(struct ftrace_ret_stack **ret_stack_list)
 
 		if (t->ret_stack == NULL) {
 			atomic_set(&t->tracing_graph_pause, 0);
-			atomic_set(&t->trace_overrun, 0);
+			atomic_set_unchecked(&t->trace_overrun, 0);
 			t->curr_ret_stack = -1;
 			/* Make sure the tasks see the -1 first: */
 			smp_wmb();
@@ -5898,7 +5898,7 @@ static void
 graph_init_task(struct task_struct *t, struct ftrace_ret_stack *ret_stack)
 {
 	atomic_set(&t->tracing_graph_pause, 0);
-	atomic_set(&t->trace_overrun, 0);
+	atomic_set_unchecked(&t->trace_overrun, 0);
 	t->ftrace_timestamp = 0;
 	/* make curr_ret_stack visible before we add the ret_stack */
 	smp_wmb();
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 6260717..b9bd83c 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -296,9 +296,9 @@ struct buffer_data_page {
  */
 struct buffer_page {
 	struct list_head list;		/* list of buffer pages */
-	local_t		 write;		/* index for next write */
+	local_unchecked_t	 write;		/* index for next write */
 	unsigned	 read;		/* index for next read */
-	local_t		 entries;	/* entries on this page */
+	local_unchecked_t	 entries;	/* entries on this page */
 	unsigned long	 real_end;	/* real end of data */
 	struct buffer_data_page *page;	/* Actual data page */
 };
@@ -437,11 +437,11 @@ struct ring_buffer_per_cpu {
 	unsigned long			last_overrun;
 	local_t				entries_bytes;
 	local_t				entries;
-	local_t				overrun;
-	local_t				commit_overrun;
-	local_t				dropped_events;
+	local_unchecked_t		overrun;
+	local_unchecked_t		commit_overrun;
+	local_unchecked_t		dropped_events;
 	local_t				committing;
-	local_t				commits;
+	local_unchecked_t		commits;
 	unsigned long			read;
 	unsigned long			read_bytes;
 	u64				write_stamp;
@@ -1011,8 +1011,8 @@ static int rb_tail_page_update(struct ring_buffer_per_cpu *cpu_buffer,
 	 *
 	 * We add a counter to the write field to denote this.
 	 */
-	old_write = local_add_return(RB_WRITE_INTCNT, &next_page->write);
-	old_entries = local_add_return(RB_WRITE_INTCNT, &next_page->entries);
+	old_write = local_add_return_unchecked(RB_WRITE_INTCNT, &next_page->write);
+	old_entries = local_add_return_unchecked(RB_WRITE_INTCNT, &next_page->entries);
 
 	/*
 	 * Just make sure we have seen our old_write and synchronize
@@ -1040,8 +1040,8 @@ static int rb_tail_page_update(struct ring_buffer_per_cpu *cpu_buffer,
 		 * cmpxchg to only update if an interrupt did not already
 		 * do it for us. If the cmpxchg fails, we don't care.
 		 */
-		(void)local_cmpxchg(&next_page->write, old_write, val);
-		(void)local_cmpxchg(&next_page->entries, old_entries, eval);
+		(void)local_cmpxchg_unchecked(&next_page->write, old_write, val);
+		(void)local_cmpxchg_unchecked(&next_page->entries, old_entries, eval);
 
 		/*
 		 * No need to worry about races with clearing out the commit.
@@ -1409,12 +1409,12 @@ static void rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer);
 
 static inline unsigned long rb_page_entries(struct buffer_page *bpage)
 {
-	return local_read(&bpage->entries) & RB_WRITE_MASK;
+	return local_read_unchecked(&bpage->entries) & RB_WRITE_MASK;
 }
 
 static inline unsigned long rb_page_write(struct buffer_page *bpage)
 {
-	return local_read(&bpage->write) & RB_WRITE_MASK;
+	return local_read_unchecked(&bpage->write) & RB_WRITE_MASK;
 }
 
 static int
@@ -1509,7 +1509,7 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned int nr_pages)
 			 * bytes consumed in ring buffer from here.
 			 * Increment overrun to account for the lost events.
 			 */
-			local_add(page_entries, &cpu_buffer->overrun);
+			local_add_unchecked(page_entries, &cpu_buffer->overrun);
 			local_sub(BUF_PAGE_SIZE, &cpu_buffer->entries_bytes);
 		}
 
@@ -2071,7 +2071,7 @@ rb_handle_head_page(struct ring_buffer_per_cpu *cpu_buffer,
 		 * it is our responsibility to update
 		 * the counters.
 		 */
-		local_add(entries, &cpu_buffer->overrun);
+		local_add_unchecked(entries, &cpu_buffer->overrun);
 		local_sub(BUF_PAGE_SIZE, &cpu_buffer->entries_bytes);
 
 		/*
@@ -2221,7 +2221,7 @@ rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
 		if (tail == BUF_PAGE_SIZE)
 			tail_page->real_end = 0;
 
-		local_sub(length, &tail_page->write);
+		local_sub_unchecked(length, &tail_page->write);
 		return;
 	}
 
@@ -2256,7 +2256,7 @@ rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
 		rb_event_set_padding(event);
 
 		/* Set the write back to the previous setting */
-		local_sub(length, &tail_page->write);
+		local_sub_unchecked(length, &tail_page->write);
 		return;
 	}
 
@@ -2268,7 +2268,7 @@ rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
 
 	/* Set write to end of buffer */
 	length = (tail + length) - BUF_PAGE_SIZE;
-	local_sub(length, &tail_page->write);
+	local_sub_unchecked(length, &tail_page->write);
 }
 
 /*
@@ -2294,7 +2294,7 @@ rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
 	 * about it.
 	 */
 	if (unlikely(next_page == commit_page)) {
-		local_inc(&cpu_buffer->commit_overrun);
+		local_inc_unchecked(&cpu_buffer->commit_overrun);
 		goto out_reset;
 	}
 
@@ -2324,7 +2324,7 @@ rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
 			 * this is easy, just stop here.
 			 */
 			if (!(buffer->flags & RB_FL_OVERWRITE)) {
-				local_inc(&cpu_buffer->dropped_events);
+				local_inc_unchecked(&cpu_buffer->dropped_events);
 				goto out_reset;
 			}
 
@@ -2350,7 +2350,7 @@ rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
 				      cpu_buffer->tail_page) &&
 				     (cpu_buffer->commit_page ==
 				      cpu_buffer->reader_page))) {
-				local_inc(&cpu_buffer->commit_overrun);
+				local_inc_unchecked(&cpu_buffer->commit_overrun);
 				goto out_reset;
 			}
 		}
@@ -2398,7 +2398,7 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 		length += RB_LEN_TIME_EXTEND;
 
 	tail_page = cpu_buffer->tail_page;
-	write = local_add_return(length, &tail_page->write);
+	write = local_add_return_unchecked(length, &tail_page->write);
 
 	/* set write to only the index of the write */
 	write &= RB_WRITE_MASK;
@@ -2422,7 +2422,7 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 	kmemcheck_annotate_bitfield(event, bitfield);
 	rb_update_event(cpu_buffer, event, length, add_timestamp, delta);
 
-	local_inc(&tail_page->entries);
+	local_inc_unchecked(&tail_page->entries);
 
 	/*
 	 * If this is the first commit on the page, then update
@@ -2455,7 +2455,7 @@ rb_try_to_discard(struct ring_buffer_per_cpu *cpu_buffer,
 
 	if (bpage->page == (void *)addr && rb_page_write(bpage) == old_index) {
 		unsigned long write_mask =
-			local_read(&bpage->write) & ~RB_WRITE_MASK;
+			local_read_unchecked(&bpage->write) & ~RB_WRITE_MASK;
 		unsigned long event_length = rb_event_length(event);
 		/*
 		 * This is on the tail page. It is possible that
@@ -2465,7 +2465,7 @@ rb_try_to_discard(struct ring_buffer_per_cpu *cpu_buffer,
 		 */
 		old_index += write_mask;
 		new_index += write_mask;
-		index = local_cmpxchg(&bpage->write, old_index, new_index);
+		index = local_cmpxchg_unchecked(&bpage->write, old_index, new_index);
 		if (index == old_index) {
 			/* update counters */
 			local_sub(event_length, &cpu_buffer->entries_bytes);
@@ -2480,7 +2480,7 @@ rb_try_to_discard(struct ring_buffer_per_cpu *cpu_buffer,
 static void rb_start_commit(struct ring_buffer_per_cpu *cpu_buffer)
 {
 	local_inc(&cpu_buffer->committing);
-	local_inc(&cpu_buffer->commits);
+	local_inc_unchecked(&cpu_buffer->commits);
 }
 
 static inline void rb_end_commit(struct ring_buffer_per_cpu *cpu_buffer)
@@ -2492,7 +2492,7 @@ static inline void rb_end_commit(struct ring_buffer_per_cpu *cpu_buffer)
 		return;
 
  again:
-	commits = local_read(&cpu_buffer->commits);
+	commits = local_read_unchecked(&cpu_buffer->commits);
 	/* synchronize with interrupts */
 	barrier();
 	if (local_read(&cpu_buffer->committing) == 1)
@@ -2508,7 +2508,7 @@ static inline void rb_end_commit(struct ring_buffer_per_cpu *cpu_buffer)
 	 * updating of the commit page and the clearing of the
 	 * committing counter.
 	 */
-	if (unlikely(local_read(&cpu_buffer->commits) != commits) &&
+	if (unlikely(local_read_unchecked(&cpu_buffer->commits) != commits) &&
 	    !local_read(&cpu_buffer->committing)) {
 		local_inc(&cpu_buffer->committing);
 		goto again;
@@ -2538,7 +2538,7 @@ rb_reserve_next_event(struct ring_buffer *buffer,
 	barrier();
 	if (unlikely(ACCESS_ONCE(cpu_buffer->buffer) != buffer)) {
 		local_dec(&cpu_buffer->committing);
-		local_dec(&cpu_buffer->commits);
+		local_dec_unchecked(&cpu_buffer->commits);
 		return NULL;
 	}
 #endif
@@ -2852,7 +2852,7 @@ rb_decrement_entry(struct ring_buffer_per_cpu *cpu_buffer,
 
 	/* Do the likely case first */
 	if (likely(bpage->page == (void *)addr)) {
-		local_dec(&bpage->entries);
+		local_dec_unchecked(&bpage->entries);
 		return;
 	}
 
@@ -2864,7 +2864,7 @@ rb_decrement_entry(struct ring_buffer_per_cpu *cpu_buffer,
 	start = bpage;
 	do {
 		if (bpage->page == (void *)addr) {
-			local_dec(&bpage->entries);
+			local_dec_unchecked(&bpage->entries);
 			return;
 		}
 		rb_inc_page(cpu_buffer, &bpage);
@@ -3152,7 +3152,7 @@ static inline unsigned long
 rb_num_of_entries(struct ring_buffer_per_cpu *cpu_buffer)
 {
 	return local_read(&cpu_buffer->entries) -
-		(local_read(&cpu_buffer->overrun) + cpu_buffer->read);
+		(local_read_unchecked(&cpu_buffer->overrun) + cpu_buffer->read);
 }
 
 /**
@@ -3241,7 +3241,7 @@ unsigned long ring_buffer_overrun_cpu(struct ring_buffer *buffer, int cpu)
 		return 0;
 
 	cpu_buffer = buffer->buffers[cpu];
-	ret = local_read(&cpu_buffer->overrun);
+	ret = local_read_unchecked(&cpu_buffer->overrun);
 
 	return ret;
 }
@@ -3264,7 +3264,7 @@ ring_buffer_commit_overrun_cpu(struct ring_buffer *buffer, int cpu)
 		return 0;
 
 	cpu_buffer = buffer->buffers[cpu];
-	ret = local_read(&cpu_buffer->commit_overrun);
+	ret = local_read_unchecked(&cpu_buffer->commit_overrun);
 
 	return ret;
 }
@@ -3286,7 +3286,7 @@ ring_buffer_dropped_events_cpu(struct ring_buffer *buffer, int cpu)
 		return 0;
 
 	cpu_buffer = buffer->buffers[cpu];
-	ret = local_read(&cpu_buffer->dropped_events);
+	ret = local_read_unchecked(&cpu_buffer->dropped_events);
 
 	return ret;
 }
@@ -3349,7 +3349,7 @@ unsigned long ring_buffer_overruns(struct ring_buffer *buffer)
 	/* if you care about this being correct, lock the buffer */
 	for_each_buffer_cpu(buffer, cpu) {
 		cpu_buffer = buffer->buffers[cpu];
-		overruns += local_read(&cpu_buffer->overrun);
+		overruns += local_read_unchecked(&cpu_buffer->overrun);
 	}
 
 	return overruns;
@@ -3520,8 +3520,8 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	/*
 	 * Reset the reader page to size zero.
 	 */
-	local_set(&cpu_buffer->reader_page->write, 0);
-	local_set(&cpu_buffer->reader_page->entries, 0);
+	local_set_unchecked(&cpu_buffer->reader_page->write, 0);
+	local_set_unchecked(&cpu_buffer->reader_page->entries, 0);
 	local_set(&cpu_buffer->reader_page->page->commit, 0);
 	cpu_buffer->reader_page->real_end = 0;
 
@@ -3555,7 +3555,7 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	 * want to compare with the last_overrun.
 	 */
 	smp_mb();
-	overwrite = local_read(&(cpu_buffer->overrun));
+	overwrite = local_read_unchecked(&(cpu_buffer->overrun));
 
 	/*
 	 * Here's the tricky part.
@@ -4137,8 +4137,8 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
 
 	cpu_buffer->head_page
 		= list_entry(cpu_buffer->pages, struct buffer_page, list);
-	local_set(&cpu_buffer->head_page->write, 0);
-	local_set(&cpu_buffer->head_page->entries, 0);
+	local_set_unchecked(&cpu_buffer->head_page->write, 0);
+	local_set_unchecked(&cpu_buffer->head_page->entries, 0);
 	local_set(&cpu_buffer->head_page->page->commit, 0);
 
 	cpu_buffer->head_page->read = 0;
@@ -4148,18 +4148,18 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
 
 	INIT_LIST_HEAD(&cpu_buffer->reader_page->list);
 	INIT_LIST_HEAD(&cpu_buffer->new_pages);
-	local_set(&cpu_buffer->reader_page->write, 0);
-	local_set(&cpu_buffer->reader_page->entries, 0);
+	local_set_unchecked(&cpu_buffer->reader_page->write, 0);
+	local_set_unchecked(&cpu_buffer->reader_page->entries, 0);
 	local_set(&cpu_buffer->reader_page->page->commit, 0);
 	cpu_buffer->reader_page->read = 0;
 
 	local_set(&cpu_buffer->entries_bytes, 0);
-	local_set(&cpu_buffer->overrun, 0);
-	local_set(&cpu_buffer->commit_overrun, 0);
-	local_set(&cpu_buffer->dropped_events, 0);
+	local_set_unchecked(&cpu_buffer->overrun, 0);
+	local_set_unchecked(&cpu_buffer->commit_overrun, 0);
+	local_set_unchecked(&cpu_buffer->dropped_events, 0);
 	local_set(&cpu_buffer->entries, 0);
 	local_set(&cpu_buffer->committing, 0);
-	local_set(&cpu_buffer->commits, 0);
+	local_set_unchecked(&cpu_buffer->commits, 0);
 	cpu_buffer->read = 0;
 	cpu_buffer->read_bytes = 0;
 
@@ -4549,8 +4549,8 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 		rb_init_page(bpage);
 		bpage = reader->page;
 		reader->page = *data_page;
-		local_set(&reader->write, 0);
-		local_set(&reader->entries, 0);
+		local_set_unchecked(&reader->write, 0);
+		local_set_unchecked(&reader->entries, 0);
 		reader->read = 0;
 		*data_page = bpage;
 
diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index 0f06532..247c8e7 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -127,7 +127,7 @@ u64 notrace trace_clock_global(void)
 }
 EXPORT_SYMBOL_GPL(trace_clock_global);
 
-static atomic64_t trace_counter;
+static atomic64_unchecked_t trace_counter;
 
 /*
  * trace_clock_counter(): simply an atomic counter.
@@ -136,5 +136,5 @@ static atomic64_t trace_counter;
  */
 u64 notrace trace_clock_counter(void)
 {
-	return atomic64_add_return(1, &trace_counter);
+	return atomic64_inc_return_unchecked(&trace_counter);
 }
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 8968bf7..e6623fc 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -132,7 +132,7 @@ ftrace_push_return_trace(unsigned long ret, unsigned long func, int *depth,
 
 	/* The return trace stack is full */
 	if (current->curr_ret_stack == FTRACE_RETFUNC_DEPTH - 1) {
-		atomic_inc(&current->trace_overrun);
+		atomic_inc_unchecked(&current->trace_overrun);
 		return -EBUSY;
 	}
 
@@ -229,7 +229,7 @@ ftrace_pop_return_trace(struct ftrace_graph_ret *trace, unsigned long *ret,
 	*ret = current->ret_stack[index].ret;
 	trace->func = current->ret_stack[index].func;
 	trace->calltime = current->ret_stack[index].calltime;
-	trace->overrun = atomic_read(&current->trace_overrun);
+	trace->overrun = atomic_read_unchecked(&current->trace_overrun);
 	trace->depth = index;
 }
 
diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index 638e110..99b73b2 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -24,7 +24,7 @@ struct header_iter {
 static struct trace_array *mmio_trace_array;
 static bool overrun_detected;
 static unsigned long prev_overruns;
-static atomic_t dropped_count;
+static atomic_unchecked_t dropped_count;
 
 static void mmio_reset_data(struct trace_array *tr)
 {
@@ -124,7 +124,7 @@ static void mmio_close(struct trace_iterator *iter)
 
 static unsigned long count_overruns(struct trace_iterator *iter)
 {
-	unsigned long cnt = atomic_xchg(&dropped_count, 0);
+	unsigned long cnt = atomic_xchg_unchecked(&dropped_count, 0);
 	unsigned long over = ring_buffer_overruns(iter->trace_buffer->buffer);
 
 	if (over > prev_overruns)
@@ -307,7 +307,7 @@ static void __trace_mmiotrace_rw(struct trace_array *tr,
 	event = trace_buffer_lock_reserve(buffer, TRACE_MMIO_RW,
 					  sizeof(*entry), 0, pc);
 	if (!event) {
-		atomic_inc(&dropped_count);
+		atomic_inc_unchecked(&dropped_count);
 		return;
 	}
 	entry	= ring_buffer_event_data(event);
@@ -337,7 +337,7 @@ static void __trace_mmiotrace_map(struct trace_array *tr,
 	event = trace_buffer_lock_reserve(buffer, TRACE_MMIO_MAP,
 					  sizeof(*entry), 0, pc);
 	if (!event) {
-		atomic_inc(&dropped_count);
+		atomic_inc_unchecked(&dropped_count);
 		return;
 	}
 	entry	= ring_buffer_event_data(event);
-- 
2.5.0
