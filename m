Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Tue, 5 Jul 2011 21:42:00 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110705174200.GC6102@albatros>
References: <201106292214.p5TMEtHg015372@imap1.linux-foundation.org>
 <20110630134855.GA6165@mail.hallyn.com>
 <20110630135718.GA13406@albatros>
 <20110703180028.GA26742@albatros>
 <20110704115523.GA11252@albatros>
 <20110705142659.GA18290@peqn>
 <20110705145033.GA3052@albatros>
 <20110705155755.GB14784@peqn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110705155755.GB14784@peqn>
Subject: [kernel-hardening] Re: [PATCH] shm: handle separate PID namespaces case
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: akpm@linux-foundation.org, daniel.lezcano@free.fr, ebiederm@xmission.com, mingo@elte.hu, oleg@redhat.com, rdunlap@xenotime.net, tj@kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jul 05, 2011 at 10:57 -0500, Serge Hallyn wrote:
> Do you have all of these patches applied in one git tree?  Could
> you do a quick 'git diff master..' (assuming master is Linus' tree)
> and send the result (or send a git url), and I'll take a last closer
> look at the patch tomorrow?

These patches are against 3.0-rc2, it should be simple to rebase to -rc5
since ipc/ is not heavily changed nowadays.  The patches are stored in
-mm tree.  The blob against -rc2 is as follows:

---

 Documentation/sysctl/kernel.txt |   22 ++++++++
 include/linux/ipc_namespace.h   |    7 +++
 include/linux/shm.h             |    7 +++
 ipc/ipc_sysctl.c                |   36 +++++++++++++
 ipc/shm.c                       |  105 +++++++++++++++++++++++++++++++++++++--
 kernel/exit.c                   |    1 +
 6 files changed, 174 insertions(+), 4 deletions(-)
---
diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 5e7cb39..4d7b866 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -62,6 +62,7 @@ show up in /proc/sys/kernel:
 - shmall
 - shmmax                      [ sysv ipc ]
 - shmmni
+- shm_rmid_forced
 - stop-a                      [ SPARC only ]
 - sysrq                       ==> Documentation/sysrq.txt
 - tainted
@@ -475,6 +476,27 @@ kernel.  This value defaults to SHMMAX.
 
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
diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
index a6d1655..8a297a5 100644
--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
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
 
@@ -72,6 +77,7 @@ extern int register_ipcns_notifier(struct ipc_namespace *);
 extern int cond_register_ipcns_notifier(struct ipc_namespace *);
 extern void unregister_ipcns_notifier(struct ipc_namespace *);
 extern int ipcns_notify(unsigned long);
+extern void shm_destroy_orphaned(struct ipc_namespace *ns);
 #else /* CONFIG_SYSVIPC */
 static inline int register_ipcns_notifier(struct ipc_namespace *ns)
 { return 0; }
@@ -79,6 +85,7 @@ static inline int cond_register_ipcns_notifier(struct ipc_namespace *ns)
 { return 0; }
 static inline void unregister_ipcns_notifier(struct ipc_namespace *ns) { }
 static inline int ipcns_notify(unsigned long l) { return 0; }
+static inline void shm_destroy_orphaned(struct ipc_namespace *ns) {}
 #endif /* CONFIG_SYSVIPC */
 
 #ifdef CONFIG_POSIX_MQUEUE
diff --git a/include/linux/shm.h b/include/linux/shm.h
index eca6235..92808b8 100644
--- a/include/linux/shm.h
+++ b/include/linux/shm.h
@@ -95,6 +95,9 @@ struct shmid_kernel /* private to the kernel */
 	pid_t			shm_cprid;
 	pid_t			shm_lprid;
 	struct user_struct	*mlock_user;
+
+	/* The task created the shm object.  NULL if the task is dead. */
+	struct task_struct	*shm_creator;
 };
 
 /* shm_mode upper byte flags */
@@ -106,6 +109,7 @@ struct shmid_kernel /* private to the kernel */
 #ifdef CONFIG_SYSVIPC
 long do_shmat(int shmid, char __user *shmaddr, int shmflg, unsigned long *addr);
 extern int is_file_shm_hugepages(struct file *file);
+extern void exit_shm(struct task_struct *task);
 #else
 static inline long do_shmat(int shmid, char __user *shmaddr,
 				int shmflg, unsigned long *addr)
@@ -116,6 +120,9 @@ static inline int is_file_shm_hugepages(struct file *file)
 {
 	return 0;
 }
+static inline void exit_shm(struct task_struct *task)
+{
+}
 #endif
 
 #endif /* __KERNEL__ */
diff --git a/ipc/ipc_sysctl.c b/ipc/ipc_sysctl.c
index 56410fa..00fba2b 100644
--- a/ipc/ipc_sysctl.c
+++ b/ipc/ipc_sysctl.c
@@ -31,12 +31,37 @@ static int proc_ipc_dointvec(ctl_table *table, int write,
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
@@ -125,6 +150,8 @@ static int proc_ipcauto_dointvec_minmax(ctl_table *table, int write,
 #else
 #define proc_ipc_doulongvec_minmax NULL
 #define proc_ipc_dointvec	   NULL
+#define proc_ipc_dointvec_minmax   NULL
+#define proc_ipc_dointvec_minmax_orphans   NULL
 #define proc_ipc_callback_dointvec NULL
 #define proc_ipcauto_dointvec_minmax NULL
 #endif
@@ -155,6 +182,15 @@ static struct ctl_table ipc_kern_table[] = {
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
diff --git a/ipc/shm.c b/ipc/shm.c
index ab3385a..bf46636 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -74,6 +74,7 @@ void shm_init_ns(struct ipc_namespace *ns)
 	ns->shm_ctlmax = SHMMAX;
 	ns->shm_ctlall = SHMALL;
 	ns->shm_ctlmni = SHMMNI;
+	ns->shm_rmid_forced = 1;
 	ns->shm_tot = 0;
 	ipc_init_ids(&shm_ids(ns));
 }
@@ -130,6 +131,12 @@ static inline struct shmid_kernel *shm_lock(struct ipc_namespace *ns, int id)
 	return container_of(ipcp, struct shmid_kernel, shm_perm);
 }
 
+static inline void shm_lock_by_ptr(struct shmid_kernel *ipcp)
+{
+	rcu_read_lock();
+	spin_lock(&ipcp->shm_perm.lock);
+}
+
 static inline struct shmid_kernel *shm_lock_check(struct ipc_namespace *ns,
 						int id)
 {
@@ -187,6 +194,23 @@ static void shm_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
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
@@ -206,14 +230,87 @@ static void shm_close(struct vm_area_struct *vma)
 	shp->shm_lprid = task_tgid_vnr(current);
 	shp->shm_dtim = get_seconds();
 	shp->shm_nattch--;
-	if(shp->shm_nattch == 0 &&
-	   shp->shm_perm.mode & SHM_DEST)
+	if (shm_may_destroy(ns, shp))
 		shm_destroy(ns, shp);
 	else
 		shm_unlock(shp);
 	up_write(&shm_ids(ns).rw_mutex);
 }
 
+/* Called with ns->shm_ids(ns).rw_mutex locked */
+static int shm_try_destroy_current(int id, void *p, void *data)
+{
+	struct ipc_namespace *ns = data;
+	struct kern_ipc_perm *ipcp = p;
+	struct shmid_kernel *shp = container_of(ipcp, struct shmid_kernel, shm_perm);
+
+	if (shp->shm_creator != current)
+		return 0;
+
+	/*
+	 * Mark it as orphaned to destroy the segment when
+	 * kernel.shm_rmid_forced is changed.
+	 * It is noop if the following shm_may_destroy() returns true.
+	 */
+	shp->shm_creator = NULL;
+
+	/*
+	 * Don't even try to destroy it.  If shm_rmid_forced=0 and IPC_RMID
+	 * is not set, it shouldn't be deleted here.
+	 */
+	if (!ns->shm_rmid_forced)
+		return 0;
+
+	if (shm_may_destroy(ns, shp)) {
+		shm_lock_by_ptr(shp);
+		shm_destroy(ns, shp);
+	}
+	return 0;
+}
+
+/* Called with ns->shm_ids(ns).rw_mutex locked */
+static int shm_try_destroy_orphaned(int id, void *p, void *data)
+{
+	struct ipc_namespace *ns = data;
+	struct kern_ipc_perm *ipcp = p;
+	struct shmid_kernel *shp = container_of(ipcp, struct shmid_kernel, shm_perm);
+
+	/*
+	 * We want to destroy segments without users and with already
+	 * exit'ed originating process.
+	 *
+	 * As shp->* are changed under rw_mutex, it's safe to skip shp locking.
+	 */
+	if (shp->shm_creator != NULL)
+		return 0;
+
+	if (shm_may_destroy(ns, shp)) {
+		shm_lock_by_ptr(shp);
+		shm_destroy(ns, shp);
+	}
+	return 0;
+}
+
+void shm_destroy_orphaned(struct ipc_namespace *ns)
+{
+	down_write(&shm_ids(ns).rw_mutex);
+	if (&shm_ids(ns).in_use)
+		idr_for_each(&shm_ids(ns).ipcs_idr, &shm_try_destroy_orphaned, ns);
+	up_write(&shm_ids(ns).rw_mutex);
+}
+
+
+void exit_shm(struct task_struct *task)
+{
+	struct ipc_namespace *ns = task->nsproxy->ipc_ns;
+
+	/* Destroy all already created segments, but not mapped yet */
+	down_write(&shm_ids(ns).rw_mutex);
+	if (&shm_ids(ns).in_use)
+		idr_for_each(&shm_ids(ns).ipcs_idr, &shm_try_destroy_current, ns);
+	up_write(&shm_ids(ns).rw_mutex);
+}
+
 static int shm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct file *file = vma->vm_file;
@@ -404,6 +501,7 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 	shp->shm_segsz = size;
 	shp->shm_nattch = 0;
 	shp->shm_file = file;
+	shp->shm_creator = current;
 	/*
 	 * shmid gets reported as "inode#" in /proc/pid/maps.
 	 * proc-ps tools use this. Changing this will break them.
@@ -950,8 +1048,7 @@ out_nattch:
 	shp = shm_lock(ns, shmid);
 	BUG_ON(IS_ERR(shp));
 	shp->shm_nattch--;
-	if(shp->shm_nattch == 0 &&
-	   shp->shm_perm.mode & SHM_DEST)
+	if (shm_may_destroy(ns, shp))
 		shm_destroy(ns, shp);
 	else
 		shm_unlock(shp);
diff --git a/kernel/exit.c b/kernel/exit.c
index 20a4064..816c610 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -991,6 +991,7 @@ NORET_TYPE void do_exit(long code)
 	trace_sched_process_exit(tsk);
 
 	exit_sem(tsk);
+	exit_shm(tsk);
 	exit_files(tsk);
 	exit_fs(tsk);
 	check_stack_usage();
--
