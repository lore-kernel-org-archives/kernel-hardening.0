Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sun, 19 Jun 2011 18:18:10 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110619141810.GA3708@albatros>
References: <20110618104207.GA13752@albatros>
 <20110618182812.GA16457@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110618182812.GA16457@albatros>
Subject: [kernel-hardening] Re: proc info restrictions problem
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Jun 18, 2011 at 22:28 +0400, Vasiliy Kulikov wrote:
> Another choise - remove hidepid=2 at all.

The patch for hidepid=1 only is as follows:
(tested with /proc exploring and using a sample taskstats program
Documentation/accounting/getdelays.c)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 5e7cb39..f023e1e 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -52,6 +52,8 @@ show up in /proc/sys/kernel:
 - powersave-nap               [ PPC only ]
 - panic_on_unrecovered_nmi
 - printk
+- procinfo_restricted
+- procinfo_restricted_gid
 - randomize_va_space
 - real-root-dev               ==> Documentation/initrd.txt
 - reboot-cmd                  [ SPARC only ]
@@ -403,6 +405,31 @@ Value from 0 - 10000 is allowed.
 
 ==============================================================
 
+procinfo_restricted:
+
+This option defined how much information about processes we want to be
+available for non-owners:
+
+0 - No process information is additionally restricted.  Common procfs
+    and taskstats access rules are applied.
+
+1 - Users may not get any statistics or debugging information about any
+    processes, but their own.  Process name and command line are
+    restricted too.  Users may not access aliens' /proc/<pid>/
+    directories or get any information about aliens' processes via
+    taskstats.
+
+==============================================================
+
+procinfo_restricted_gid:
+
+Defines a group number.  All members of this group are allowed to gather
+process' information bypassing procinfo_restricted.  If you use identd
+or similar daemon that wants to learn processes information, just add
+the daemon's user to this group.
+
+==============================================================
+
 randomize-va-space:
 
 This option can be used to select the type of process address
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 14def99..5fa8d83 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -627,8 +627,19 @@ int proc_setattr(struct dentry *dentry, struct iattr *attr)
 	return 0;
 }
 
+static int proc_pid_permission(struct inode *inode, int mask,
+                              unsigned int flags)
+{
+       struct task_struct *task = get_proc_task(inode);
+
+       if (!procinfo_may_stat_task(task))
+		return -EACCES;
+       return generic_permission(inode, mask, flags, NULL);
+}
+
 static const struct inode_operations proc_def_inode_operations = {
 	.setattr	= proc_setattr,
+	.permission	= proc_pid_permission,
 };
 
 static int mounts_open_common(struct inode *inode, struct file *file,
@@ -1670,6 +1681,7 @@ static const struct inode_operations proc_pid_link_inode_operations = {
 	.readlink	= proc_pid_readlink,
 	.follow_link	= proc_pid_follow_link,
 	.setattr	= proc_setattr,
+	.permission	= proc_pid_permission,
 };
 
 
@@ -2872,6 +2884,7 @@ static const struct inode_operations proc_tgid_base_inode_operations = {
 	.lookup		= proc_tgid_base_lookup,
 	.getattr	= pid_getattr,
 	.setattr	= proc_setattr,
+	.permission	= proc_pid_permission,
 };
 
 static void proc_flush_task_mnt(struct vfsmount *mnt, pid_t pid, pid_t tgid)
diff --git a/include/linux/capability.h b/include/linux/capability.h
index c421123..cc0bcfe 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -544,7 +544,9 @@ extern bool has_ns_capability(struct task_struct *t,
 			      struct user_namespace *ns, int cap);
 extern bool has_capability_noaudit(struct task_struct *t, int cap);
 extern bool capable(int cap);
+extern bool task_capable(struct task_struct *task, int cap);
 extern bool ns_capable(struct user_namespace *ns, int cap);
+extern bool ns_task_capable(struct task_struct *t, struct user_namespace *ns, int cap);
 extern bool task_ns_capable(struct task_struct *t, int cap);
 extern bool nsown_capable(int cap);
 
diff --git a/include/linux/cred.h b/include/linux/cred.h
index 8260799..e910948 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -73,6 +73,7 @@ extern int groups_search(const struct group_info *, gid_t);
 	((gi)->blocks[(i) / NGROUPS_PER_BLOCK][(i) % NGROUPS_PER_BLOCK])
 
 extern int in_group_p(gid_t);
+extern int task_in_group_p(struct task_struct *task, gid_t grp);
 extern int in_egroup_p(gid_t);
 
 /*
diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index 38d1032..ab937c9 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -6,12 +6,27 @@
 #include <linux/threads.h>
 #include <linux/nsproxy.h>
 #include <linux/kref.h>
+#include <linux/ptrace.h>
 
 struct pidmap {
        atomic_t nr_free;
        void *page;
 };
 
+enum procinfo_restricted {
+	/*
+	 * Classical mode, no process information is additionally restricted.
+	 */
+	PROCINFO_NONE = 0,
+
+	/*
+	 * Users may not learn other users' processess statistics,
+	 * debug information, cmdline and comm.  Credentials information
+	 * is not restricted.
+	 */
+	PROCINFO_STATS = 1,
+};
+
 #define PIDMAP_ENTRIES         ((PID_MAX_LIMIT + 8*PAGE_SIZE - 1)/PAGE_SIZE/8)
 
 struct bsd_acct_struct;
@@ -30,6 +45,8 @@ struct pid_namespace {
 #ifdef CONFIG_BSD_PROCESS_ACCT
 	struct bsd_acct_struct *bacct;
 #endif
+	enum procinfo_restricted procinfo_restricted;
+	gid_t procinfo_restricted_gid;
 };
 
 extern struct pid_namespace init_pid_ns;
@@ -83,4 +100,51 @@ extern struct pid_namespace *task_active_pid_ns(struct task_struct *tsk);
 void pidhash_init(void);
 void pidmap_init(void);
 
+static inline bool procinfo_may_access_task(struct task_struct *tsk, enum procinfo_restricted pr)
+{
+	struct pid_namespace *ns;
+
+	if (current->nsproxy == NULL || current->nsproxy->pid_ns == NULL)
+		return false;
+	ns = current->nsproxy->pid_ns;
+
+	return (ns->procinfo_restricted < pr) ||
+		in_group_p(ns->procinfo_restricted_gid) ||
+		ptrace_may_access(tsk, PTRACE_MODE_READ);
+}
+
+static inline bool procinfo_task_may_access_current(struct task_struct *tsk, enum procinfo_restricted pr)
+{
+	struct pid_namespace *ns;
+
+	if (current->nsproxy == NULL || current->nsproxy->pid_ns == NULL)
+		return false;
+	ns = current->nsproxy->pid_ns;
+
+	return (ns->procinfo_restricted < pr) ||
+		task_in_group_p(tsk, ns->procinfo_restricted_gid) ||
+		ptrace_task_may_access_current(tsk, PTRACE_MODE_READ);
+}
+
+static inline bool procinfo_task_may_stat_current(struct task_struct *tsk)
+{
+	int res;
+	pr_err("check whether %lu may stat %lu...\n",
+		 (unsigned long)tsk->pid, (unsigned long)current->pid);
+	res = procinfo_task_may_access_current(tsk, PROCINFO_STATS);
+	pr_err( "%s\n", res ? "yes" : "no");
+	return res;
+}
+
+static inline bool procinfo_may_stat_task(struct task_struct *tsk)
+{
+	int res;
+	pr_err( "check whether %lu may stat %lu...\n",
+		(unsigned long)current->pid,
+		(unsigned long)tsk->pid);
+	res = procinfo_may_access_task(tsk, PROCINFO_STATS);
+	pr_err( "%s\n", res ? "yes" : "no");
+	return res;
+}
+
 #endif /* _LINUX_PID_NS_H */
diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 9178d5c..bb59e43 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -116,9 +116,10 @@ extern void exit_ptrace(struct task_struct *tracer);
 #define PTRACE_MODE_READ   1
 #define PTRACE_MODE_ATTACH 2
 /* Returns 0 on success, -errno on denial. */
-extern int __ptrace_may_access(struct task_struct *task, unsigned int mode);
+extern int __ptrace_may_access(struct task_struct *who, struct task_struct *task, unsigned int mode);
 /* Returns true on success, false on denial. */
 extern bool ptrace_may_access(struct task_struct *task, unsigned int mode);
+extern bool ptrace_task_may_access_current(struct task_struct *task, unsigned int mode);
 
 static inline int ptrace_reparented(struct task_struct *child)
 {
diff --git a/include/linux/security.h b/include/linux/security.h
index 8ce59ef..fb79dd5 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -56,7 +56,8 @@ struct user_namespace;
 extern int cap_capable(struct task_struct *tsk, const struct cred *cred,
 		       struct user_namespace *ns, int cap, int audit);
 extern int cap_settime(const struct timespec *ts, const struct timezone *tz);
-extern int cap_ptrace_access_check(struct task_struct *child, unsigned int mode);
+extern int cap_ptrace_access_check(struct task_struct *task, struct task_struct *child,
+	unsigned int mode);
 extern int cap_ptrace_traceme(struct task_struct *parent);
 extern int cap_capget(struct task_struct *target, kernel_cap_t *effective, kernel_cap_t *inheritable, kernel_cap_t *permitted);
 extern int cap_capset(struct cred *new, const struct cred *old,
@@ -1375,7 +1376,9 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
 struct security_operations {
 	char name[SECURITY_NAME_MAX + 1];
 
-	int (*ptrace_access_check) (struct task_struct *child, unsigned int mode);
+	int (*ptrace_access_check) (struct task_struct *task,
+					 struct task_struct *child,
+					 unsigned int mode);
 	int (*ptrace_traceme) (struct task_struct *parent);
 	int (*capget) (struct task_struct *target,
 		       kernel_cap_t *effective,
@@ -1657,6 +1660,8 @@ extern int security_module_enable(struct security_operations *ops);
 extern int register_security(struct security_operations *ops);
 
 /* Security operations */
+int security_ptrace_task_access_check(struct task_struct *task,
+		 struct task_struct *child, unsigned int mode);
 int security_ptrace_access_check(struct task_struct *child, unsigned int mode);
 int security_ptrace_traceme(struct task_struct *parent);
 int security_capget(struct task_struct *target,
@@ -1667,6 +1672,10 @@ int security_capset(struct cred *new, const struct cred *old,
 		    const kernel_cap_t *effective,
 		    const kernel_cap_t *inheritable,
 		    const kernel_cap_t *permitted);
+int security_task_capable(struct task_struct *task,
+			struct user_namespace *ns,
+			const struct cred *cred,
+			int cap);
 int security_capable(struct user_namespace *ns, const struct cred *cred,
 			int cap);
 int security_real_capable(struct task_struct *tsk, struct user_namespace *ns,
@@ -1837,10 +1846,16 @@ static inline int security_init(void)
 	return 0;
 }
 
+static inline int security_ptrace_task_access_check(struct task_struct *task,
+		 struct task_struct *child, unsigned int mode)
+{
+	return cap_ptrace_access_check(task, child, mode);
+}
+
 static inline int security_ptrace_access_check(struct task_struct *child,
 					     unsigned int mode)
 {
-	return cap_ptrace_access_check(child, mode);
+	return cap_ptrace_access_check(current, child, mode);
 }
 
 static inline int security_ptrace_traceme(struct task_struct *parent)
@@ -1865,10 +1880,18 @@ static inline int security_capset(struct cred *new,
 	return cap_capset(new, old, effective, inheritable, permitted);
 }
 
+static inline int security_task_capable(struct task_struct *task,
+					struct user_namespace *ns,
+					const struct cred *cred,
+					int cap)
+{
+	return cap_capable(task, cred, ns, cap, SECURITY_CAP_AUDIT);
+}
+
 static inline int security_capable(struct user_namespace *ns,
 				   const struct cred *cred, int cap)
 {
-	return cap_capable(current, cred, ns, cap, SECURITY_CAP_AUDIT);
+	return security_task_capable(current, ns, cred, cap);
 }
 
 static inline int security_real_capable(struct task_struct *tsk, struct user_namespace *ns, int cap)
diff --git a/kernel/capability.c b/kernel/capability.c
index 283c529..93c82fe 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -356,6 +356,30 @@ bool capable(int cap)
 }
 EXPORT_SYMBOL(capable);
 
+bool task_capable(struct task_struct *task, int cap)
+{
+	return ns_task_capable(task, &init_user_ns, cap);
+}
+EXPORT_SYMBOL(task_capable);
+
+bool ns_task_capable(struct task_struct *task, struct user_namespace *ns, int cap)
+{
+	if (unlikely(!cap_valid(cap))) {
+		printk(KERN_CRIT "capable() called with invalid cap=%u\n", cap);
+		BUG();
+	}
+
+	rcu_read_lock();
+	if (security_task_capable(task, ns, __task_cred(task), cap) == 0) {
+		rcu_read_unlock();
+		task->flags |= PF_SUPERPRIV;
+		return true;
+	}
+	rcu_read_unlock();
+	return false;
+}
+EXPORT_SYMBOL(ns_task_capable);
+
 /**
  * ns_capable - Determine if the current task has a superior capability in effect
  * @ns:  The usernamespace we want the capability in
@@ -369,16 +393,7 @@ EXPORT_SYMBOL(capable);
  */
 bool ns_capable(struct user_namespace *ns, int cap)
 {
-	if (unlikely(!cap_valid(cap))) {
-		printk(KERN_CRIT "capable() called with invalid cap=%u\n", cap);
-		BUG();
-	}
-
-	if (security_capable(ns, current_cred(), cap) == 0) {
-		current->flags |= PF_SUPERPRIV;
-		return true;
-	}
-	return false;
+	return ns_task_capable(current, ns, cap);
 }
 EXPORT_SYMBOL(ns_capable);
 
diff --git a/kernel/groups.c b/kernel/groups.c
index 1cc476d..98ed200 100644
--- a/kernel/groups.c
+++ b/kernel/groups.c
@@ -268,6 +268,25 @@ int in_group_p(gid_t grp)
 
 EXPORT_SYMBOL(in_group_p);
 
+/*
+ * Check whether task's fsgid/egid or in the supplemental group..
+ */
+int task_in_group_p(struct task_struct *task, gid_t grp)
+{
+	const struct cred *cred;
+	int retval = 1;
+
+	rcu_read_lock();
+ 	cred = __task_cred(task);
+
+	if (grp != cred->fsgid)
+		retval = groups_search(cred->group_info, grp);
+	rcu_read_unlock();
+	return retval;
+}
+
+EXPORT_SYMBOL(task_in_group_p);
+
 int in_egroup_p(gid_t grp)
 {
 	const struct cred *cred = current_cred();
diff --git a/kernel/pid.c b/kernel/pid.c
index 57a8346..0f692ce 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -78,6 +78,7 @@ struct pid_namespace init_pid_ns = {
 	.last_pid = 0,
 	.level = 0,
 	.child_reaper = &init_task,
+	.procinfo_restricted_gid = -1,
 };
 EXPORT_SYMBOL_GPL(init_pid_ns);
 
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index e9c9adc..24b76c2 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -101,6 +101,8 @@ static struct pid_namespace *create_pid_namespace(struct pid_namespace *parent_p
 	if (err)
 		goto out_put_parent_pid_ns;
 
+	ns->procinfo_restricted_gid = -1;
+
 	return ns;
 
 out_put_parent_pid_ns:
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 2df1157..ccbec73 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -132,9 +132,9 @@ int ptrace_check_attach(struct task_struct *child, int kill)
 	return ret;
 }
 
-int __ptrace_may_access(struct task_struct *task, unsigned int mode)
+int __ptrace_may_access(struct task_struct *who, struct task_struct *task, unsigned int mode)
 {
-	const struct cred *cred = current_cred(), *tcred;
+	const struct cred *cred, *tcred;
 
 	/* May we inspect the given task?
 	 * This check is used both for attaching with ptrace
@@ -146,9 +146,10 @@ int __ptrace_may_access(struct task_struct *task, unsigned int mode)
 	 */
 	int dumpable = 0;
 	/* Don't let security modules deny introspection */
-	if (task == current)
+	if (task == who)
 		return 0;
 	rcu_read_lock();
+	cred = __task_cred(who);
 	tcred = __task_cred(task);
 	if (cred->user->user_ns == tcred->user->user_ns &&
 	    (cred->uid == tcred->euid &&
@@ -158,7 +159,7 @@ int __ptrace_may_access(struct task_struct *task, unsigned int mode)
 	     cred->gid == tcred->sgid &&
 	     cred->gid == tcred->gid))
 		goto ok;
-	if (ns_capable(tcred->user->user_ns, CAP_SYS_PTRACE))
+	if (ns_task_capable(who, tcred->user->user_ns, CAP_SYS_PTRACE))
 		goto ok;
 	rcu_read_unlock();
 	return -EPERM;
@@ -167,17 +168,32 @@ ok:
 	smp_rmb();
 	if (task->mm)
 		dumpable = get_dumpable(task->mm);
-	if (!dumpable && !task_ns_capable(task, CAP_SYS_PTRACE))
+	if (!dumpable &&
+	    !ns_task_capable(who, task_cred_xxx(task, user)->user_ns,
+		 CAP_SYS_PTRACE))
 		return -EPERM;
 
-	return security_ptrace_access_check(task, mode);
+	return security_ptrace_task_access_check(who, task, mode);
 }
 
 bool ptrace_may_access(struct task_struct *task, unsigned int mode)
 {
 	int err;
 	task_lock(task);
-	err = __ptrace_may_access(task, mode);
+	err = __ptrace_may_access(current, task, mode);
+	task_unlock(task);
+	return !err;
+}
+
+/*
+ * Generic task_may_access_task cannot be implemented because we have to
+ * hold task_locks of both tasks.  It would lead to a deadlock.
+ */
+bool ptrace_task_may_access_current(struct task_struct *task, unsigned int mode)
+{
+	int err;
+	task_lock(task);
+	err = __ptrace_may_access(task, current, mode);
 	task_unlock(task);
 	return !err;
 }
@@ -205,7 +221,7 @@ static int ptrace_attach(struct task_struct *task)
 		goto out;
 
 	task_lock(task);
-	retval = __ptrace_may_access(task, PTRACE_MODE_ATTACH);
+	retval = __ptrace_may_access(current, task, PTRACE_MODE_ATTACH);
 	task_unlock(task);
 	if (retval)
 		goto unlock_creds;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index f175d98..da95aab 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -57,6 +57,7 @@
 #include <linux/pipe_fs_i.h>
 #include <linux/oom.h>
 #include <linux/kmod.h>
+#include <linux/pid_namespace.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -984,6 +985,22 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 #endif
+	{
+		.procname	= "procinfo_restricted",
+		.data		= &init_pid_ns.procinfo_restricted,
+		.maxlen		= sizeof(init_pid_ns.procinfo_restricted),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
+	{
+		.procname	= "procinfo_restricted_gid",
+		.data		= &init_pid_ns.procinfo_restricted_gid,
+		.maxlen		= sizeof(init_pid_ns.procinfo_restricted_gid),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
 	{ }
 };
 
diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index 9ffea36..bec6258 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -27,6 +27,7 @@
 #include <linux/cgroup.h>
 #include <linux/fs.h>
 #include <linux/file.h>
+#include <linux/pid_namespace.h>
 #include <net/genetlink.h>
 #include <asm/atomic.h>
 
@@ -132,6 +133,7 @@ static void send_cpu_listeners(struct sk_buff *skb,
 	struct sk_buff *skb_next, *skb_cur = skb;
 	void *reply = genlmsg_data(genlhdr);
 	int rc, delcount = 0;
+	struct task_struct *tsk;
 
 	rc = genlmsg_end(skb, reply);
 	if (rc < 0) {
@@ -143,6 +145,15 @@ static void send_cpu_listeners(struct sk_buff *skb,
 	down_read(&listeners->sem);
 	list_for_each_entry(s, &listeners->list, list) {
 		skb_next = NULL;
+
+		rcu_read_lock();
+		tsk = find_task_by_vpid(s->pid);
+		if (!tsk || !procinfo_task_may_stat_current(tsk)) {
+			rcu_read_unlock();
+			continue;
+		}
+		rcu_read_unlock();
+
 		if (!list_is_last(&s->list, &listeners->list)) {
 			skb_next = skb_clone(skb_cur, GFP_KERNEL);
 			if (!skb_next)
@@ -199,14 +210,20 @@ static void fill_stats(struct task_struct *tsk, struct taskstats *stats)
 static int fill_stats_for_pid(pid_t pid, struct taskstats *stats)
 {
 	struct task_struct *tsk;
+	int err = -ESRCH;
 
 	rcu_read_lock();
 	tsk = find_task_by_vpid(pid);
+	if (tsk && !procinfo_may_stat_task(tsk)) {
+		tsk = NULL;
+		err = -EACCES;
+	}
+
 	if (tsk)
 		get_task_struct(tsk);
 	rcu_read_unlock();
 	if (!tsk)
-		return -ESRCH;
+		return err;
 	fill_stats(tsk, stats);
 	put_task_struct(tsk);
 	return 0;
@@ -217,6 +234,7 @@ static int fill_stats_for_tgid(pid_t tgid, struct taskstats *stats)
 	struct task_struct *tsk, *first;
 	unsigned long flags;
 	int rc = -ESRCH;
+	bool filled;
 
 	/*
 	 * Add additional stats from live tasks except zombie thread group
@@ -228,15 +246,29 @@ static int fill_stats_for_tgid(pid_t tgid, struct taskstats *stats)
 	if (!first || !lock_task_sighand(first, &flags))
 		goto out;
 
-	if (first->signal->stats)
+	if (first->signal->stats && procinfo_may_stat_task(first)) {
 		memcpy(stats, first->signal->stats, sizeof(*stats));
-	else
+		filled = true;
+	} else {
 		memset(stats, 0, sizeof(*stats));
+		filled = false;
+	}
 
 	tsk = first;
 	do {
 		if (tsk->exit_state)
 			continue;
+
+		/*
+		 * As there could be tasks with different creds in the same
+		 * process group, we should check perms for each task
+		 * separately.
+		 */
+		if (!procinfo_may_stat_task(tsk))
+			continue;
+
+		filled = true;
+
 		/*
 		 * Accounting subsystem can call its functions here to
 		 * fill in relevant parts of struct taskstsats as follows
@@ -250,7 +282,11 @@ static int fill_stats_for_tgid(pid_t tgid, struct taskstats *stats)
 	} while_each_thread(first, tsk);
 
 	unlock_task_sighand(first, &flags);
-	rc = 0;
+
+	if (filled)
+		rc = 0;
+	else
+		rc = -EACCES;
 out:
 	rcu_read_unlock();
 
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index ec1bcec..dc3a4aa 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -93,14 +93,14 @@ static void apparmor_cred_transfer(struct cred *new, const struct cred *old)
 	aa_dup_task_context(new_cxt, old_cxt);
 }
 
-static int apparmor_ptrace_access_check(struct task_struct *child,
-					unsigned int mode)
+static int apparmor_ptrace_access_check(struct task_struct *task,
+			    struct task_struct *child, unsigned int mode)
 {
-	int error = cap_ptrace_access_check(child, mode);
+	int error = cap_ptrace_access_check(task, child, mode);
 	if (error)
 		return error;
 
-	return aa_ptrace(current, child, mode);
+	return aa_ptrace(task, child, mode);
 }
 
 static int apparmor_ptrace_traceme(struct task_struct *parent)
diff --git a/security/commoncap.c b/security/commoncap.c
index a93b3b7..31ca991 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -136,18 +136,19 @@ int cap_settime(const struct timespec *ts, const struct timezone *tz)
  * Determine whether a process may access another, returning 0 if permission
  * granted, -ve if denied.
  */
-int cap_ptrace_access_check(struct task_struct *child, unsigned int mode)
+int cap_ptrace_access_check(struct task_struct *task, struct task_struct *child,
+	unsigned int mode)
 {
 	int ret = 0;
 	const struct cred *cred, *child_cred;
 
 	rcu_read_lock();
-	cred = current_cred();
+	cred = __task_cred(task);
 	child_cred = __task_cred(child);
 	if (cred->user->user_ns == child_cred->user->user_ns &&
 	    cap_issubset(child_cred->cap_permitted, cred->cap_permitted))
 		goto out;
-	if (ns_capable(child_cred->user->user_ns, CAP_SYS_PTRACE))
+	if (ns_task_capable(task, child_cred->user->user_ns, CAP_SYS_PTRACE))
 		goto out;
 	ret = -EPERM;
 out:
diff --git a/security/security.c b/security/security.c
index 4ba6d4c..0760e81 100644
--- a/security/security.c
+++ b/security/security.c
@@ -127,9 +127,15 @@ int __init register_security(struct security_operations *ops)
 
 /* Security operations */
 
+int security_ptrace_task_access_check(struct task_struct *task,
+		 struct task_struct *child, unsigned int mode)
+{
+	return security_ops->ptrace_access_check(task, child, mode);
+}
+
 int security_ptrace_access_check(struct task_struct *child, unsigned int mode)
 {
-	return security_ops->ptrace_access_check(child, mode);
+	return security_ops->ptrace_access_check(current, child, mode);
 }
 
 int security_ptrace_traceme(struct task_struct *parent)
@@ -154,11 +160,16 @@ int security_capset(struct cred *new, const struct cred *old,
 				    effective, inheritable, permitted);
 }
 
+int security_task_capable(struct task_struct *task, struct user_namespace *ns,
+	const struct cred *cred, int cap)
+{
+	return security_ops->capable(task, cred, ns, cap, SECURITY_CAP_AUDIT);
+}
+
 int security_capable(struct user_namespace *ns, const struct cred *cred,
 		     int cap)
 {
-	return security_ops->capable(current, cred, ns, cap,
-				     SECURITY_CAP_AUDIT);
+	return security_task_capable(current, ns, cred, cap);
 }
 
 int security_real_capable(struct task_struct *tsk, struct user_namespace *ns,
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 20219ef..0130255 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1804,23 +1804,22 @@ static inline u32 open_file_to_av(struct file *file)
 }
 
 /* Hook functions begin here. */
-
-static int selinux_ptrace_access_check(struct task_struct *child,
-				     unsigned int mode)
+static int selinux_ptrace_access_check(struct task_struct *task,
+		struct task_struct *child, unsigned int mode)
 {
 	int rc;
 
-	rc = cap_ptrace_access_check(child, mode);
+	rc = cap_ptrace_access_check(task, child, mode);
 	if (rc)
 		return rc;
 
 	if (mode == PTRACE_MODE_READ) {
-		u32 sid = current_sid();
+		u32 sid = task_sid(task);
 		u32 csid = task_sid(child);
 		return avc_has_perm(sid, csid, SECCLASS_FILE, FILE__READ, NULL);
 	}
 
-	return current_has_perm(child, PROCESS__PTRACE);
+	return task_has_perm(task, child, PROCESS__PTRACE);
 }
 
 static int selinux_ptrace_traceme(struct task_struct *parent)
diff --git a/security/smack/smack.h b/security/smack/smack.h
index 2b6c6a5..4d9fb0f 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -199,6 +199,7 @@ struct inode_smack *new_inode_smack(char *);
  */
 int smk_access_entry(char *, char *, struct list_head *);
 int smk_access(char *, char *, int, struct smk_audit_info *);
+int smk_taskacc(struct task_struct *, char *, u32, struct smk_audit_info *);
 int smk_curacc(char *, u32, struct smk_audit_info *);
 int smack_to_cipso(const char *, struct smack_cipso *);
 void smack_from_cipso(u32, char *, char *);
diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
index 9637e10..766dccd 100644
--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -201,7 +201,8 @@ out_audit:
 }
 
 /**
- * smk_curacc - determine if current has a specific access to an object
+ * smk_curacc - determine if subject has a specific access to an object
+ * @task: a pointer to the subject's task struct
  * @obj_label: a pointer to the object's Smack label
  * @mode: the access requested, in "MAY" format
  * @a : common audit data
@@ -211,9 +212,9 @@ out_audit:
  * non zero otherwise. It allows that current may have the capability
  * to override the rules.
  */
-int smk_curacc(char *obj_label, u32 mode, struct smk_audit_info *a)
+int smk_taskacc(struct task_struct *task, char *obj_label, u32 mode, struct smk_audit_info *a)
 {
-	struct task_smack *tsp = current_security();
+	struct task_smack *tsp = task_cred_xxx(task, security);
 	char *sp = smk_of_task(tsp);
 	int may;
 	int rc;
@@ -243,7 +244,7 @@ int smk_curacc(char *obj_label, u32 mode, struct smk_audit_info *a)
 	if (smack_onlycap != NULL && smack_onlycap != sp)
 		goto out_audit;
 
-	if (capable(CAP_MAC_OVERRIDE))
+	if (task_capable(task, CAP_MAC_OVERRIDE))
 		rc = 0;
 
 out_audit:
@@ -254,6 +255,22 @@ out_audit:
 	return rc;
 }
 
+/**
+ * smk_curacc - determine if current has a specific access to an object
+ * @obj_label: a pointer to the object's Smack label
+ * @mode: the access requested, in "MAY" format
+ * @a : common audit data
+ *
+ * This function checks the current subject label/object label pair
+ * in the access rule list and returns 0 if the access is permitted,
+ * non zero otherwise. It allows that current may have the capability
+ * to override the rules.
+ */
+int smk_curacc(char *obj_label, u32 mode, struct smk_audit_info *a)
+{
+	return smk_taskacc(current, obj_label, mode, a);
+}
+
 #ifdef CONFIG_AUDIT
 /**
  * smack_str_from_perm : helper to transalate an int to a
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 9831a39..ee1c5cb 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -149,13 +149,14 @@ static int smk_copy_rules(struct list_head *nhead, struct list_head *ohead,
  *
  * Do the capability checks, and require read and write.
  */
-static int smack_ptrace_access_check(struct task_struct *ctp, unsigned int mode)
+static int smack_ptrace_access_check(struct task_struct *task,
+			struct task_struct *ctp, unsigned int mode)
 {
 	int rc;
 	struct smk_audit_info ad;
 	char *tsp;
 
-	rc = cap_ptrace_access_check(ctp, mode);
+	rc = cap_ptrace_access_check(task, ctp, mode);
 	if (rc != 0)
 		return rc;
 
@@ -163,7 +164,7 @@ static int smack_ptrace_access_check(struct task_struct *ctp, unsigned int mode)
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
 	smk_ad_setfield_u_tsk(&ad, ctp);
 
-	rc = smk_curacc(tsp, MAY_READWRITE, &ad);
+	rc = smk_taskacc(task, tsp, MAY_READWRITE, &ad);
 	return rc;
 }
 

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
