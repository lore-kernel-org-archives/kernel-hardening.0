Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 27 Jul 2011 03:27:30 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110726232730.GA28171@openwall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] Fwd: [patch 36/64] ipc: introduce shm_rmid_forced sysctl
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This is being applied.

----- Forwarded message from akpm@linux-foundation.org -----

Subject: [patch 36/64] ipc: introduce shm_rmid_forced sysctl
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, segoon@openwall.com, alan@lxorguk.ukuu.org.uk,
        daniel.lezcano@free.fr, ebiederm@xmission.com, mingo@elte.hu,
        oleg@redhat.com, rdunlap@xenotime.net, serge.hallyn@canonical.com,
        solar@openwall.com, tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 26 Jul 2011 16:08:48 -0700

From: Vasiliy Kulikov <segoon@openwall.com>

Add support for the shm_rmid_forced sysctl.  If set to 1, all
shared memory objects in current ipc namespace will be automatically
forced to use IPC_RMID.

The POSIX way of handling shmem allows one to create shm objects and call
shmdt(), leaving shm object associated with no process, thus consuming
memory not counted via rlimits.

With shm_rmid_forced=1 the shared memory object is counted at least for
one process, so OOM killer may effectively kill the fat process holding
the shared memory.

It obviously breaks POSIX - some programs relying on the feature would
stop working.  So set shm_rmid_forced=1 only if you're sure nobody uses
"orphaned" memory.  Use shm_rmid_forced=0 by default for compatability
reasons.

The feature was previously impemented in -ow as a configure option.

[akpm@linux-foundation.org: fix documentation, per Randy]
[akpm@linux-foundation.org: fix warning]
[akpm@linux-foundation.org: readability/conventionality tweaks]
[akpm@linux-foundation.org: fix shm_rmid_forced/shm_forced_rmid confusion, use standard comment layout]
Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge.hallyn@canonical.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Solar Designer <solar@openwall.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/kernel.txt |   22 ++++++
 include/linux/ipc_namespace.h   |    7 ++
 include/linux/shm.h             |    4 +
 ipc/ipc_sysctl.c                |   36 +++++++++++
 ipc/shm.c                       |   97 ++++++++++++++++++++++++++++--
 kernel/exit.c                   |    1 
 6 files changed, 163 insertions(+), 4 deletions(-)

diff -puN Documentation/sysctl/kernel.txt~ipc-introduce-shm_rmid_forced-sysctl Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~ipc-introduce-shm_rmid_forced-sysctl
+++ a/Documentation/sysctl/kernel.txt
@@ -61,6 +61,7 @@ show up in /proc/sys/kernel:
 - rtsig-nr
 - sem
 - sg-big-buff                 [ generic SCSI device (sg) ]
+- shm_rmid_forced
 - shmall
 - shmmax                      [ sysv ipc ]
 - shmmni
@@ -518,6 +519,27 @@ kernel.  This value defaults to SHMMAX.
 
 ==============================================================
 
+shm_rmid_forced:
+
+Linux lets you set resource limits, including how much memory one
+process can consume, via setrlimit(2).  Unfortunately, shared memory
+segments are allowed to exist without association with any process, and
+thus might not be counted against any resource limits.  If enabled,
+shared memory segments are automatically destroyed when their attach
+count becomes zero after a detach or a process termination.  It will
+also destroy segments that were created, but never attached to, on exit
+from the process.  The only use left for IPC_RMID is to immediately
+destroy an unattached segment.  Of course, this breaks the way things are
+defined, so some applications might stop working.  Note that this
+feature will do you no good unless you also configure your resource
+limits (in particular, RLIMIT_AS and RLIMIT_NPROC).  Most systems don't
+need this.
+
+Note that if you change this from 0 to 1, already created segments
+without users and with a dead originative process will be destroyed.
+
+==============================================================
+
 softlockup_thresh:
 
 This value can be used to lower the softlockup tolerance threshold.  The
diff -puN include/linux/ipc_namespace.h~ipc-introduce-shm_rmid_forced-sysctl include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~ipc-introduce-shm_rmid_forced-sysctl
+++ a/include/linux/ipc_namespace.h
@@ -44,6 +44,11 @@ struct ipc_namespace {
 	size_t		shm_ctlall;
 	int		shm_ctlmni;
 	int		shm_tot;
+	/*
+	 * Defines whether IPC_RMID is forced for _all_ shm segments regardless
+	 * of shmctl()
+	 */
+	int		shm_rmid_forced;
 
 	struct notifier_block ipcns_nb;
 
@@ -72,6 +77,7 @@ extern int register_ipcns_notifier(struc
 extern int cond_register_ipcns_notifier(struct ipc_namespace *);
 extern void unregister_ipcns_notifier(struct ipc_namespace *);
 extern int ipcns_notify(unsigned long);
+extern void shm_destroy_orphaned(struct ipc_namespace *ns);
 #else /* CONFIG_SYSVIPC */
 static inline int register_ipcns_notifier(struct ipc_namespace *ns)
 { return 0; }
@@ -79,6 +85,7 @@ static inline int cond_register_ipcns_no
 { return 0; }
 static inline void unregister_ipcns_notifier(struct ipc_namespace *ns) { }
 static inline int ipcns_notify(unsigned long l) { return 0; }
+static inline void shm_destroy_orphaned(struct ipc_namespace *ns) {}
 #endif /* CONFIG_SYSVIPC */
 
 #ifdef CONFIG_POSIX_MQUEUE
diff -puN include/linux/shm.h~ipc-introduce-shm_rmid_forced-sysctl include/linux/shm.h
--- a/include/linux/shm.h~ipc-introduce-shm_rmid_forced-sysctl
+++ a/include/linux/shm.h
@@ -106,6 +106,7 @@ struct shmid_kernel /* private to the ke
 #ifdef CONFIG_SYSVIPC
 long do_shmat(int shmid, char __user *shmaddr, int shmflg, unsigned long *addr);
 extern int is_file_shm_hugepages(struct file *file);
+extern void exit_shm(struct task_struct *task);
 #else
 static inline long do_shmat(int shmid, char __user *shmaddr,
 				int shmflg, unsigned long *addr)
@@ -116,6 +117,9 @@ static inline int is_file_shm_hugepages(
 {
 	return 0;
 }
+static inline void exit_shm(struct task_struct *task)
+{
+}
 #endif
 
 #endif /* __KERNEL__ */
diff -puN ipc/ipc_sysctl.c~ipc-introduce-shm_rmid_forced-sysctl ipc/ipc_sysctl.c
--- a/ipc/ipc_sysctl.c~ipc-introduce-shm_rmid_forced-sysctl
+++ a/ipc/ipc_sysctl.c
@@ -31,12 +31,37 @@ static int proc_ipc_dointvec(ctl_table *
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table ipc_table;
+
 	memcpy(&ipc_table, table, sizeof(ipc_table));
 	ipc_table.data = get_ipc(table);
 
 	return proc_dointvec(&ipc_table, write, buffer, lenp, ppos);
 }
 
+static int proc_ipc_dointvec_minmax(ctl_table *table, int write,
+	void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table ipc_table;
+
+	memcpy(&ipc_table, table, sizeof(ipc_table));
+	ipc_table.data = get_ipc(table);
+
+	return proc_dointvec_minmax(&ipc_table, write, buffer, lenp, ppos);
+}
+
+static int proc_ipc_dointvec_minmax_orphans(ctl_table *table, int write,
+	void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct ipc_namespace *ns = current->nsproxy->ipc_ns;
+	int err = proc_ipc_dointvec_minmax(table, write, buffer, lenp, ppos);
+
+	if (err < 0)
+		return err;
+	if (ns->shm_rmid_forced)
+		shm_destroy_orphaned(ns);
+	return err;
+}
+
 static int proc_ipc_callback_dointvec(ctl_table *table, int write,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -125,6 +150,8 @@ static int proc_ipcauto_dointvec_minmax(
 #else
 #define proc_ipc_doulongvec_minmax NULL
 #define proc_ipc_dointvec	   NULL
+#define proc_ipc_dointvec_minmax   NULL
+#define proc_ipc_dointvec_minmax_orphans   NULL
 #define proc_ipc_callback_dointvec NULL
 #define proc_ipcauto_dointvec_minmax NULL
 #endif
@@ -155,6 +182,15 @@ static struct ctl_table ipc_kern_table[]
 		.proc_handler	= proc_ipc_dointvec,
 	},
 	{
+		.procname	= "shm_rmid_forced",
+		.data		= &init_ipc_ns.shm_rmid_forced,
+		.maxlen		= sizeof(init_ipc_ns.shm_rmid_forced),
+		.mode		= 0644,
+		.proc_handler	= proc_ipc_dointvec_minmax_orphans,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
+	{
 		.procname	= "msgmax",
 		.data		= &init_ipc_ns.msg_ctlmax,
 		.maxlen		= sizeof (init_ipc_ns.msg_ctlmax),
diff -puN ipc/shm.c~ipc-introduce-shm_rmid_forced-sysctl ipc/shm.c
--- a/ipc/shm.c~ipc-introduce-shm_rmid_forced-sysctl
+++ a/ipc/shm.c
@@ -74,6 +74,7 @@ void shm_init_ns(struct ipc_namespace *n
 	ns->shm_ctlmax = SHMMAX;
 	ns->shm_ctlall = SHMALL;
 	ns->shm_ctlmni = SHMMNI;
+	ns->shm_rmid_forced = 0;
 	ns->shm_tot = 0;
 	ipc_init_ids(&shm_ids(ns));
 }
@@ -187,6 +188,23 @@ static void shm_destroy(struct ipc_names
 }
 
 /*
+ * shm_may_destroy - identifies whether shm segment should be destroyed now
+ *
+ * Returns true if and only if there are no active users of the segment and
+ * one of the following is true:
+ *
+ * 1) shmctl(id, IPC_RMID, NULL) was called for this shp
+ *
+ * 2) sysctl kernel.shm_rmid_forced is set to 1.
+ */
+static bool shm_may_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
+{
+	return (shp->shm_nattch == 0) &&
+	       (ns->shm_rmid_forced ||
+		(shp->shm_perm.mode & SHM_DEST));
+}
+
+/*
  * remove the attach descriptor vma.
  * free memory for segment if it is marked destroyed.
  * The descriptor has already been removed from the current->mm->mmap list
@@ -206,11 +224,83 @@ static void shm_close(struct vm_area_str
 	shp->shm_lprid = task_tgid_vnr(current);
 	shp->shm_dtim = get_seconds();
 	shp->shm_nattch--;
-	if(shp->shm_nattch == 0 &&
-	   shp->shm_perm.mode & SHM_DEST)
+	if (shm_may_destroy(ns, shp))
+		shm_destroy(ns, shp);
+	else
+		shm_unlock(shp);
+	up_write(&shm_ids(ns).rw_mutex);
+}
+
+static int shm_try_destroy_current(int id, void *p, void *data)
+{
+	struct ipc_namespace *ns = data;
+	struct shmid_kernel *shp = shm_lock(ns, id);
+
+	if (IS_ERR(shp))
+		return 0;
+
+	if (shp->shm_cprid != task_tgid_vnr(current)) {
+		shm_unlock(shp);
+		return 0;
+	}
+
+	if (shm_may_destroy(ns, shp))
+		shm_destroy(ns, shp);
+	else
+		shm_unlock(shp);
+	return 0;
+}
+
+static int shm_try_destroy_orphaned(int id, void *p, void *data)
+{
+	struct ipc_namespace *ns = data;
+	struct shmid_kernel *shp = shm_lock(ns, id);
+	struct task_struct *task;
+
+	if (IS_ERR(shp))
+		return 0;
+
+	/*
+	 * We want to destroy segments without users and with already
+	 * exit'ed originating process.
+	 *
+	 * XXX: the originating process may exist in another pid namespace.
+	 */
+	task = find_task_by_vpid(shp->shm_cprid);
+	if (task != NULL) {
+		shm_unlock(shp);
+		return 0;
+	}
+
+	if (shm_may_destroy(ns, shp))
 		shm_destroy(ns, shp);
 	else
 		shm_unlock(shp);
+	return 0;
+}
+
+void shm_destroy_orphaned(struct ipc_namespace *ns)
+{
+	down_write(&shm_ids(ns).rw_mutex);
+	idr_for_each(&shm_ids(ns).ipcs_idr, &shm_try_destroy_orphaned, ns);
+	up_write(&shm_ids(ns).rw_mutex);
+}
+
+
+void exit_shm(struct task_struct *task)
+{
+	struct nsproxy *nsp = task->nsproxy;
+	struct ipc_namespace *ns;
+
+	if (!nsp)
+		return;
+	ns = nsp->ipc_ns;
+	if (!ns || !ns->shm_rmid_forced)
+		return;
+
+	/* Destroy all already created segments, but not mapped yet */
+	down_write(&shm_ids(ns).rw_mutex);
+	idr_for_each(&shm_ids(ns).ipcs_idr, &shm_try_destroy_current, ns);
 	up_write(&shm_ids(ns).rw_mutex);
 }
 
@@ -950,8 +1040,7 @@ out_nattch:
 	shp = shm_lock(ns, shmid);
 	BUG_ON(IS_ERR(shp));
 	shp->shm_nattch--;
-	if(shp->shm_nattch == 0 &&
-	   shp->shm_perm.mode & SHM_DEST)
+	if (shm_may_destroy(ns, shp))
 		shm_destroy(ns, shp);
 	else
 		shm_unlock(shp);
diff -puN kernel/exit.c~ipc-introduce-shm_rmid_forced-sysctl kernel/exit.c
--- a/kernel/exit.c~ipc-introduce-shm_rmid_forced-sysctl
+++ a/kernel/exit.c
@@ -980,6 +980,7 @@ NORET_TYPE void do_exit(long code)
 	trace_sched_process_exit(tsk);
 
 	exit_sem(tsk);
+	exit_shm(tsk);
 	exit_files(tsk);
 	exit_fs(tsk);
 	check_stack_usage();
_

----- End forwarded message -----
