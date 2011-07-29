Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Fri, 29 Jul 2011 21:47:25 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110729174725.GA2339@albatros>
References: <20110605182430.GA5789@albatros>
 <20110605192641.GA9240@openwall.com>
 <20110605194746.GA6484@albatros>
 <20110605201025.GA9541@openwall.com>
 <20110606180806.GA3986@albatros>
 <20110606183358.GA14711@openwall.com>
 <20110608172307.GA3380@albatros>
 <20110612023916.GC14976@openwall.com>
 <20110724185036.GC3510@albatros>
 <20110726145016.GA8583@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110726145016.GA8583@albatros>
Subject: [kernel-hardening] procfs {tid,tgid,attr}_allowed mount options
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On Tue, Jul 26, 2011 at 18:50 +0400, Vasiliy Kulikov wrote:
> This is a demonstration of procfs feature I'm writing now.  It is not
> yet fully ready (need more clean code and need to divide the patch into
> series), however, it's ready for some demonstration:

Now the patch seems rather stable, more or less clean.  It lacks some
testing, after that I'll send it as RFC to LKML.

BTW, it fully solves the problem of procfs files kept across execve()
(CVE-2011-1020).

---
 fs/proc/Makefile              |    2 +-
 fs/proc/base.c                |  253 ++++++++++++++++-----------------
 fs/proc/base_perms.c          |  314 +++++++++++++++++++++++++++++++++++++++++
 fs/proc/inode.c               |   18 +++
 fs/proc/internal.h            |   24 +++
 fs/proc/root.c                |  121 ++++++++++++++++-
 fs/proc/task_nommu.c          |    2 +-
 include/linux/pid_namespace.h |   13 ++
 include/linux/proc_fs.h       |   12 ++
 kernel/pid.c                  |    2 +
 kernel/pid_namespace.c        |   10 ++-
 kernel/sysctl.c               |    1 +
 12 files changed, 635 insertions(+), 137 deletions(-)

--
diff --git a/fs/proc/Makefile b/fs/proc/Makefile
index c1c7293..81020f9 100644
--- a/fs/proc/Makefile
+++ b/fs/proc/Makefile
@@ -8,7 +8,7 @@ proc-y			:= nommu.o task_nommu.o
 proc-$(CONFIG_MMU)	:= mmu.o task_mmu.o
 
 proc-y       += inode.o root.o base.o generic.o array.o \
-		proc_tty.o
+		proc_tty.o base_perms.o
 proc-y	+= cmdline.o
 proc-y	+= consoles.o
 proc-y	+= cpuinfo.o
diff --git a/fs/proc/base.c b/fs/proc/base.c
index fc5bc27..0af542e 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -98,40 +98,43 @@
  *	in /proc for a task before it execs a suid executable.
  */
 
-struct pid_entry {
-	char *name;
-	int len;
-	mode_t mode;
-	const struct inode_operations *iop;
-	const struct file_operations *fop;
-	union proc_op op;
-};
-
-#define NOD(NAME, MODE, IOP, FOP, OP) {			\
+#define NOD(NAME, MODE, IOP, FOP, OP, PERMS) {			\
 	.name = (NAME),					\
 	.len  = sizeof(NAME) - 1,			\
 	.mode = MODE,					\
 	.iop  = IOP,					\
 	.fop  = FOP,					\
 	.op   = OP,					\
+	.need_perms_check = PERMS,			\
 }
 
+/*
+ * XX_PERMS() are files without any ptrace() check.
+ * However, they have updated uid/gid and permissions on each file operation.
+ */
 #define DIR(NAME, MODE, iops, fops)	\
-	NOD(NAME, (S_IFDIR|(MODE)), &iops, &fops, {} )
+	NOD(NAME, (S_IFDIR|(MODE)), &iops, &fops, {}, true)
 #define LNK(NAME, get_link)					\
 	NOD(NAME, (S_IFLNK|S_IRWXUGO),				\
 		&proc_pid_link_inode_operations, NULL,		\
-		{ .proc_get_link = get_link } )
+		{ .proc_get_link = get_link }, false)
 #define REG(NAME, MODE, fops)				\
-	NOD(NAME, (S_IFREG|(MODE)), NULL, &fops, {})
+	NOD(NAME, (S_IFREG|(MODE)), NULL, &fops, {}, true)
+#define REG_PERMS(NAME, MODE, fops)				\
+	NOD(NAME, (S_IFREG|(MODE)), NULL, &fops, {}, false)
 #define INF(NAME, MODE, read)				\
 	NOD(NAME, (S_IFREG|(MODE)), 			\
 		NULL, &proc_info_file_operations,	\
-		{ .proc_read = read } )
+		{ .proc_read = read }, true )
+#define INF_PERMS(NAME, MODE, read)				\
+	NOD(NAME, (S_IFREG|(MODE)), 			\
+		NULL, &proc_info_file_operations,	\
+		{ .proc_read = read }, false )
 #define ONE(NAME, MODE, show)				\
 	NOD(NAME, (S_IFREG|(MODE)), 			\
 		NULL, &proc_single_file_operations,	\
-		{ .proc_show = show } )
+		{ .proc_show = show }, true )
+
 
 /*
  * Count the number of hardlinks for the pid_entry table, excluding the .
@@ -229,35 +232,12 @@ static struct mm_struct *__check_mem_permission(struct task_struct *task)
 	return ERR_PTR(-EPERM);
 }
 
-/*
- * If current may access user memory in @task return a reference to the
- * corresponding mm, otherwise ERR_PTR.
- */
-static struct mm_struct *check_mem_permission(struct task_struct *task)
-{
-	struct mm_struct *mm;
-	int err;
-
-	/*
-	 * Avoid racing if task exec's as we might get a new mm but validate
-	 * against old credentials.
-	 */
-	err = mutex_lock_killable(&task->signal->cred_guard_mutex);
-	if (err)
-		return ERR_PTR(err);
-
-	mm = __check_mem_permission(task);
-	mutex_unlock(&task->signal->cred_guard_mutex);
-
-	return mm;
-}
-
 struct mm_struct *mm_for_maps(struct task_struct *task)
 {
 	struct mm_struct *mm;
 	int err;
 
-	err =  mutex_lock_killable(&task->signal->cred_guard_mutex);
+	err = mutex_lock_killable(&task->signal->cred_guard_mutex);
 	if (err)
 		return ERR_PTR(err);
 
@@ -327,7 +307,6 @@ static int proc_pid_auxv(struct task_struct *task, char *buffer)
 	return res;
 }
 
-
 #ifdef CONFIG_KALLSYMS
 /*
  * Provides a wchan file via kallsyms in a proper one-value-per-file format.
@@ -350,23 +329,6 @@ static int proc_pid_wchan(struct task_struct *task, char *buffer)
 }
 #endif /* CONFIG_KALLSYMS */
 
-static int lock_trace(struct task_struct *task)
-{
-	int err = mutex_lock_killable(&task->signal->cred_guard_mutex);
-	if (err)
-		return err;
-	if (!ptrace_may_access(task, PTRACE_MODE_ATTACH)) {
-		mutex_unlock(&task->signal->cred_guard_mutex);
-		return -EPERM;
-	}
-	return 0;
-}
-
-static void unlock_trace(struct task_struct *task)
-{
-	mutex_unlock(&task->signal->cred_guard_mutex);
-}
-
 #ifdef CONFIG_STACKTRACE
 
 #define MAX_STACK_TRACE_DEPTH	64
@@ -388,16 +350,13 @@ static int proc_pid_stack(struct seq_file *m, struct pid_namespace *ns,
 	trace.entries		= entries;
 	trace.skip		= 0;
 
-	err = lock_trace(task);
-	if (!err) {
-		save_stack_trace_tsk(task, &trace);
+	save_stack_trace_tsk(task, &trace);
 
-		for (i = 0; i < trace.nr_entries; i++) {
-			seq_printf(m, "[<%pK>] %pS\n",
-				   (void *)entries[i], (void *)entries[i]);
-		}
-		unlock_trace(task);
+	for (i = 0; i < trace.nr_entries; i++) {
+		seq_printf(m, "[<%pK>] %pS\n",
+			   (void *)entries[i], (void *)entries[i]);
 	}
+
 	kfree(entries);
 
 	return err;
@@ -563,9 +522,7 @@ static int proc_pid_syscall(struct task_struct *task, char *buffer)
 {
 	long nr;
 	unsigned long args[6], sp, pc;
-	int res = lock_trace(task);
-	if (res)
-		return res;
+	int res;
 
 	if (task_current_syscall(task, &nr, args, 6, &sp, &pc))
 		res = sprintf(buffer, "running\n");
@@ -577,7 +534,7 @@ static int proc_pid_syscall(struct task_struct *task, char *buffer)
 		       nr,
 		       args[0], args[1], args[2], args[3], args[4], args[5],
 		       sp, pc);
-	unlock_trace(task);
+
 	return res;
 }
 #endif /* CONFIG_HAVE_ARCH_TRACEHOOK */
@@ -586,23 +543,6 @@ static int proc_pid_syscall(struct task_struct *task, char *buffer)
 /*                       Here the fs part begins                        */
 /************************************************************************/
 
-/* permission checks */
-static int proc_fd_access_allowed(struct inode *inode)
-{
-	struct task_struct *task;
-	int allowed = 0;
-	/* Allow access to a task's file descriptors if it is us or we
-	 * may use ptrace attach to the process and find out that
-	 * information.
-	 */
-	task = get_proc_task(inode);
-	if (task) {
-		allowed = ptrace_may_access(task, PTRACE_MODE_READ);
-		put_task_struct(task);
-	}
-	return allowed;
-}
-
 int proc_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	int error;
@@ -839,7 +779,7 @@ static ssize_t mem_read(struct file * file, char __user * buf,
 	if (!page)
 		goto out;
 
-	mm = check_mem_permission(task);
+	mm = __check_mem_permission(task);
 	ret = PTR_ERR(mm);
 	if (IS_ERR(mm))
 		goto out_free;
@@ -902,7 +842,7 @@ static ssize_t mem_write(struct file * file, const char __user *buf,
 	if (!page)
 		goto out_task;
 
-	mm = check_mem_permission(task);
+	mm = __check_mem_permission(task);
 	copied = PTR_ERR(mm);
 	if (IS_ERR(mm))
 		goto out_free;
@@ -1613,12 +1553,7 @@ static void *proc_pid_follow_link(struct dentry *dentry, struct nameidata *nd)
 	/* We don't need a base pointer in the /proc filesystem */
 	path_put(&nd->path);
 
-	/* Are we allowed to snoop on the tasks file descriptors? */
-	if (!proc_fd_access_allowed(inode))
-		goto out;
-
 	error = PROC_I(inode)->op.proc_get_link(inode, &nd->path);
-out:
 	return ERR_PTR(error);
 }
 
@@ -1652,9 +1587,6 @@ static int proc_pid_readlink(struct dentry * dentry, char __user * buffer, int b
 	struct inode *inode = dentry->d_inode;
 	struct path path;
 
-	/* Are we allowed to snoop on the tasks file descriptors? */
-	if (!proc_fd_access_allowed(inode))
-		goto out;
 
 	error = PROC_I(inode)->op.proc_get_link(inode, &path);
 	if (error)
@@ -1758,6 +1690,8 @@ int pid_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
 
 /* dentry stuff */
 
+static void pid_revalidate_perms(struct dentry *dentry);
+
 /*
  *	Exceptional case: normally we are not allowed to unhash a busy
  * directory. In this case, however, we can do it - no aliasing problems
@@ -1785,6 +1719,8 @@ int pid_revalidate(struct dentry *dentry, struct nameidata *nd)
 	inode = dentry->d_inode;
 	task = get_proc_task(inode);
 
+	pid_revalidate_perms(dentry);
+
 	if (task) {
 		if ((inode->i_mode == (S_IFDIR|S_IRUGO|S_IXUGO)) ||
 		    task_dumpable(task)) {
@@ -2200,7 +2136,9 @@ static struct dentry *proc_fdinfo_instantiate(struct inode *dir,
 	ei = PROC_I(inode);
 	ei->fd = fd;
 	inode->i_mode = S_IFREG | S_IRUSR;
-	inode->i_fop = &proc_fdinfo_file_operations;
+	ei->real_fops = &proc_fdinfo_file_operations;
+	inode->i_fop = &proc_pid_perms_fops;
+
 	d_set_d_op(dentry, &tid_fd_dentry_operations);
 	d_add(dentry, inode);
 	/* Close the race of the process dying before we return the dentry */
@@ -2238,7 +2176,6 @@ static const struct inode_operations proc_fdinfo_inode_operations = {
 	.setattr	= proc_setattr,
 };
 
-
 static struct dentry *proc_pident_instantiate(struct inode *dir,
 	struct dentry *dentry, struct task_struct *task, const void *ptr)
 {
@@ -2255,11 +2192,16 @@ static struct dentry *proc_pident_instantiate(struct inode *dir,
 	inode->i_mode = p->mode;
 	if (S_ISDIR(inode->i_mode))
 		inode->i_nlink = 2;	/* Use getattr to fix if necessary */
+
 	if (p->iop)
 		inode->i_op = p->iop;
 	if (p->fop)
-		inode->i_fop = p->fop;
+		ei->real_fops = p->fop;
 	ei->op = p->op;
+	inode->i_fop = &proc_pid_perms_fops;
+
+	ei->dirent = p;
+
 	d_set_d_op(dentry, &pid_dentry_operations);
 	d_add(dentry, inode);
 	/* Close the race of the process dying before we return the dentry */
@@ -2417,15 +2359,9 @@ static ssize_t proc_pid_attr_write(struct file * file, const char __user * buf,
 	if (copy_from_user(page, buf, count))
 		goto out_free;
 
-	/* Guard against adverse ptrace interaction */
-	length = mutex_lock_interruptible(&task->signal->cred_guard_mutex);
-	if (length < 0)
-		goto out_free;
-
 	length = security_setprocattr(task,
 				      (char*)file->f_path.dentry->d_name.name,
 				      (void*)page, count);
-	mutex_unlock(&task->signal->cred_guard_mutex);
 out_free:
 	free_page((unsigned long) page);
 out:
@@ -2469,7 +2405,7 @@ static struct dentry *proc_attr_dir_lookup(struct inode *dir,
 				  attr_dir_stuff, ARRAY_SIZE(attr_dir_stuff));
 }
 
-static const struct inode_operations proc_attr_dir_inode_operations = {
+const struct inode_operations proc_attr_dir_inode_operations = {
 	.lookup		= proc_attr_dir_lookup,
 	.getattr	= pid_getattr,
 	.setattr	= proc_setattr,
@@ -2617,7 +2553,7 @@ static const struct inode_operations proc_self_inode_operations = {
  */
 static const struct pid_entry proc_base_stuff[] = {
 	NOD("self", S_IFLNK|S_IRWXUGO,
-		&proc_self_inode_operations, NULL, {}),
+		&proc_self_inode_operations, NULL, {}, false),
 };
 
 static struct dentry *proc_base_instantiate(struct inode *dir,
@@ -2653,9 +2589,12 @@ static struct dentry *proc_base_instantiate(struct inode *dir,
 		inode->i_size = 64;
 	if (p->iop)
 		inode->i_op = p->iop;
+
 	if (p->fop)
-		inode->i_fop = p->fop;
+		ei->real_fops = p->fop;
 	ei->op = p->op;
+	inode->i_fop = &proc_pid_perms_fops;
+
 	d_add(dentry, inode);
 	error = NULL;
 out:
@@ -2708,9 +2647,6 @@ static int do_io_accounting(struct task_struct *task, char *buffer, int whole)
 	struct task_io_accounting acct = task->ioac;
 	unsigned long flags;
 
-	if (!ptrace_may_access(task, PTRACE_MODE_READ))
-		return -EACCES;
-
 	if (whole && lock_task_sighand(task, &flags)) {
 		struct task_struct *t = task;
 
@@ -2751,12 +2687,8 @@ static int proc_tgid_io_accounting(struct task_struct *task, char *buffer)
 static int proc_pid_personality(struct seq_file *m, struct pid_namespace *ns,
 				struct pid *pid, struct task_struct *task)
 {
-	int err = lock_trace(task);
-	if (!err) {
-		seq_printf(m, "%08x\n", task->personality);
-		unlock_trace(task);
-	}
-	return err;
+	seq_printf(m, "%08x\n", task->personality);
+	return 0;
 }
 
 /*
@@ -2773,8 +2705,8 @@ static const struct pid_entry tgid_base_stuff[] = {
 #ifdef CONFIG_NET
 	DIR("net",        S_IRUGO|S_IXUGO, proc_net_inode_operations, proc_net_operations),
 #endif
-	REG("environ",    S_IRUSR, proc_environ_operations),
-	INF("auxv",       S_IRUSR, proc_pid_auxv),
+	REG_PERMS("environ",    S_IRUSR, proc_environ_operations),
+	INF_PERMS("auxv",       S_IRUSR, proc_pid_auxv),
 	ONE("status",     S_IRUGO, proc_pid_status),
 	ONE("personality", S_IRUGO, proc_pid_personality),
 	INF("limits",	  S_IRUGO, proc_pid_limits),
@@ -2791,9 +2723,9 @@ static const struct pid_entry tgid_base_stuff[] = {
 	INF("cmdline",    S_IRUGO, proc_pid_cmdline),
 	ONE("stat",       S_IRUGO, proc_tgid_stat),
 	ONE("statm",      S_IRUGO, proc_pid_statm),
-	REG("maps",       S_IRUGO, proc_maps_operations),
+	REG_PERMS("maps",       S_IRUGO, proc_maps_operations),
 #ifdef CONFIG_NUMA
-	REG("numa_maps",  S_IRUGO, proc_numa_maps_operations),
+	REG_PERMS("numa_maps",  S_IRUGO, proc_numa_maps_operations),
 #endif
 	REG("mem",        S_IRUSR|S_IWUSR, proc_mem_operations),
 	LNK("cwd",        proc_cwd_link),
@@ -2804,7 +2736,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	REG("mountstats", S_IRUSR, proc_mountstats_operations),
 #ifdef CONFIG_PROC_PAGE_MONITOR
 	REG("clear_refs", S_IWUSR, proc_clear_refs_operations),
-	REG("smaps",      S_IRUGO, proc_smaps_operations),
+	REG_PERMS("smaps",      S_IRUGO, proc_smaps_operations),
 	REG("pagemap",    S_IRUGO, proc_pagemap_operations),
 #endif
 #ifdef CONFIG_SECURITY
@@ -2867,7 +2799,7 @@ static struct dentry *proc_tgid_base_lookup(struct inode *dir, struct dentry *de
 				  tgid_base_stuff, ARRAY_SIZE(tgid_base_stuff));
 }
 
-static const struct inode_operations proc_tgid_base_inode_operations = {
+const struct inode_operations proc_tgid_base_inode_operations = {
 	.lookup		= proc_tgid_base_lookup,
 	.getattr	= pid_getattr,
 	.setattr	= proc_setattr,
@@ -2972,9 +2904,10 @@ static struct dentry *proc_pid_instantiate(struct inode *dir,
 	if (!inode)
 		goto out;
 
-	inode->i_mode = S_IFDIR|S_IRUGO|S_IXUGO;
+	inode->i_mode = S_IFDIR | S_IRUGO | S_IXUGO;
 	inode->i_op = &proc_tgid_base_inode_operations;
-	inode->i_fop = &proc_tgid_base_operations;
+	inode->i_fop = &proc_pid_perms_fops;
+	PROC_I(inode)->real_fops = &proc_tgid_base_operations;
 	inode->i_flags|=S_IMMUTABLE;
 
 	inode->i_nlink = 2 + pid_entry_count_dirs(tgid_base_stuff,
@@ -3122,8 +3055,8 @@ static const struct pid_entry tid_base_stuff[] = {
 	DIR("fd",        S_IRUSR|S_IXUSR, proc_fd_inode_operations, proc_fd_operations),
 	DIR("fdinfo",    S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fdinfo_operations),
 	DIR("ns",	 S_IRUSR|S_IXUGO, proc_ns_dir_inode_operations, proc_ns_dir_operations),
-	REG("environ",   S_IRUSR, proc_environ_operations),
-	INF("auxv",      S_IRUSR, proc_pid_auxv),
+	REG_PERMS("environ",   S_IRUSR, proc_environ_operations),
+	INF_PERMS("auxv",      S_IRUSR, proc_pid_auxv),
 	ONE("status",    S_IRUGO, proc_pid_status),
 	ONE("personality", S_IRUGO, proc_pid_personality),
 	INF("limits",	 S_IRUGO, proc_pid_limits),
@@ -3137,9 +3070,9 @@ static const struct pid_entry tid_base_stuff[] = {
 	INF("cmdline",   S_IRUGO, proc_pid_cmdline),
 	ONE("stat",      S_IRUGO, proc_tid_stat),
 	ONE("statm",     S_IRUGO, proc_pid_statm),
-	REG("maps",      S_IRUGO, proc_maps_operations),
+	REG_PERMS("maps",      S_IRUGO, proc_maps_operations),
 #ifdef CONFIG_NUMA
-	REG("numa_maps", S_IRUGO, proc_numa_maps_operations),
+	REG_PERMS("numa_maps", S_IRUGO, proc_numa_maps_operations),
 #endif
 	REG("mem",       S_IRUSR|S_IWUSR, proc_mem_operations),
 	LNK("cwd",       proc_cwd_link),
@@ -3149,7 +3082,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	REG("mountinfo",  S_IRUGO, proc_mountinfo_operations),
 #ifdef CONFIG_PROC_PAGE_MONITOR
 	REG("clear_refs", S_IWUSR, proc_clear_refs_operations),
-	REG("smaps",     S_IRUGO, proc_smaps_operations),
+	REG_PERMS("smaps",     S_IRUGO, proc_smaps_operations),
 	REG("pagemap",    S_IRUGO, proc_pagemap_operations),
 #endif
 #ifdef CONFIG_SECURITY
@@ -3209,7 +3142,7 @@ static const struct file_operations proc_tid_base_operations = {
 	.llseek		= default_llseek,
 };
 
-static const struct inode_operations proc_tid_base_inode_operations = {
+const struct inode_operations proc_tid_base_inode_operations = {
 	.lookup		= proc_tid_base_lookup,
 	.getattr	= pid_getattr,
 	.setattr	= proc_setattr,
@@ -3226,7 +3159,8 @@ static struct dentry *proc_task_instantiate(struct inode *dir,
 		goto out;
 	inode->i_mode = S_IFDIR|S_IRUGO|S_IXUGO;
 	inode->i_op = &proc_tid_base_inode_operations;
-	inode->i_fop = &proc_tid_base_operations;
+	inode->i_fop = &proc_pid_perms_fops;
+	PROC_I(inode)->real_fops = &proc_tid_base_operations;
 	inode->i_flags|=S_IMMUTABLE;
 
 	inode->i_nlink = 2 + pid_entry_count_dirs(tid_base_stuff,
@@ -3445,3 +3379,58 @@ static const struct file_operations proc_task_operations = {
 	.readdir	= proc_task_readdir,
 	.llseek		= default_llseek,
 };
+
+const int perms_size[] = {
+	[PROC_PERMS_NTID] = ARRAY_SIZE(tid_base_stuff),
+	[PROC_PERMS_NTGID] = ARRAY_SIZE(tgid_base_stuff),
+	[PROC_PERMS_NATTR] = ARRAY_SIZE(attr_dir_stuff),
+};
+
+const struct pid_entry *dir_ents[] = {
+	[PROC_PERMS_NTID] = tid_base_stuff,
+	[PROC_PERMS_NTGID] = tgid_base_stuff,
+	[PROC_PERMS_NATTR] = attr_dir_stuff,
+};
+
+static void pid_revalidate_perms(struct dentry *dentry)
+{
+	struct inode *inode;
+	struct pid_namespace *pid_ns;
+	struct proc_perms *perms;
+	const struct inode_operations *parent_op;
+	struct proc_inode *ei;
+
+	pid_ns = dentry->d_sb->s_fs_info;
+	perms = &pid_ns->proc_perms;
+	inode = dentry->d_inode;
+	parent_op = dentry->d_parent->d_inode->i_op;
+	ei = PROC_I(inode);
+
+	/* We never ever chmod symlinks (XXX: symlinks must be protected too) */
+	if (S_ISLNK(inode->i_mode))
+		return;
+
+	if (inode->i_op == &proc_tgid_base_inode_operations ||
+	    inode->i_op == &proc_tid_base_inode_operations) {
+		mode_t mode = S_IFDIR | S_IRUGO | S_IXUGO;
+		mode_t mask = perms->proc_pid_allowed ? ~0 : ~077;
+		inode->i_mode = mode & mask;
+	} else if (parent_op == &proc_tgid_base_inode_operations) {
+		inode->i_mode = get_ent_perms(ei->dirent,
+						perms,
+						PROC_PERMS_NTGID,
+						(const struct pid_entry *)ei->dirent - &tgid_base_stuff[0]);
+	} else if (parent_op == &proc_tid_base_inode_operations) {
+		inode->i_mode = get_ent_perms(ei->dirent,
+						perms,
+						PROC_PERMS_NTID,
+						(const struct pid_entry *)ei->dirent - &tid_base_stuff[0]);
+	} else if (parent_op == &proc_attr_dir_inode_operations) {
+		inode->i_mode = get_ent_perms(ei->dirent,
+						perms,
+						PROC_PERMS_NATTR,
+						(struct pid_entry *)ei->dirent - &attr_dir_stuff[0]);
+	} else {
+		pr_err("other not found (%s)\n", dentry->d_name.name);
+	}
+}
diff --git a/fs/proc/base_perms.c b/fs/proc/base_perms.c
new file mode 100644
index 0000000..9d05e7a
--- /dev/null
+++ b/fs/proc/base_perms.c
@@ -0,0 +1,314 @@
+/*
+ *  linux/fs/proc/base_perms.c
+ *
+ *  Copyright (C) 2011 Vasiliy Kulikov
+ *
+ *  proc base directory permissions handling functions
+ */
+
+#include <asm/uaccess.h>
+#include <linux/proc_fs.h>
+#include <linux/string.h>
+#include <linux/ptrace.h>
+#include <linux/poll.h>
+#include <linux/pid_namespace.h>
+#include "internal.h"
+
+
+/* Similar to acl_permission_check(), but with procfs specific changes */
+static int proc_permission_check(struct task_struct *task, struct inode *inode, int mask)
+{
+	mode_t mode = inode->i_mode;
+	uid_t uid = inode->i_uid;
+	gid_t gid = inode->i_gid;
+
+	if (mode & mask)
+		return 0;
+
+	/* XXX: This should be updated conformably to user ns code changes.
+	 * Or maybe just remove it as ns users may not have any access to procfs? */
+	if (current_user_ns() != inode_userns(inode))
+		return -EACCES;
+
+	if (in_group_p(gid) && ((mode >> 3) & mask))
+		return 0;
+
+	/*
+	 * The major changes compared to acl_permission_check():
+	 * 1) we check euid, not fsuid
+	 * 2) we additionally check ptrace ability
+	 */
+	if (current_euid() == uid) {
+		int pmode = (mask == MAY_WRITE) ? PTRACE_MODE_ATTACH : PTRACE_MODE_READ;
+		if (ptrace_may_access(task, pmode))
+			return 0;
+	}
+
+	return -EACCES;
+}
+
+static void unlock_pid_trace(struct task_struct *task);
+
+/*
+ * All operations with /proc/PID/ directory MUST be processed
+ * under lock_pid_trace() to avoid execve() races.
+ *
+ * It checks permissions similar to acl_permission_check() and probably holds
+ * (*task)->signal->cred_guard_mutex.  If so, *task would point to the target
+ * task, NULL otherwise.  To unlock the mutex call unlock_pid_trace() with the
+ * same *task argument.
+ */
+static int lock_pid_trace(struct dentry *dentry,
+			  int mask,
+			  struct task_struct **task)
+{
+	int err;
+	struct inode *inode = dentry->d_inode;
+	const struct pid_entry *pe = PROC_I(inode)->dirent;
+
+	*task = get_proc_task(inode);
+	if (*task == NULL)
+		return -ESRCH;
+
+	err = mutex_lock_killable(&(*task)->signal->cred_guard_mutex);
+	if (err)
+		goto put_task;
+
+	/*
+	 * We have to revalidate both uid/gid and permissions.
+	 * uid/gid revalidation is racy against execve(), so we do it under
+	 * ->cred_guard_mutex.
+	 *
+	 * We cannot just update uid/gid because of LSM.
+	 */
+	/* XXX: locking? */
+#if 1
+	err = -ESRCH;
+	if (pid_revalidate(dentry, NULL) == 0)
+		goto free_mutex;
+#endif
+
+	if (!pe->need_perms_check) {
+		/* OK, the file checks permissions on his own */
+		unlock_pid_trace(*task);
+		*task = NULL;
+		return 0;
+	}
+
+	err = -EACCES;
+	if (proc_permission_check(*task, inode, mask))
+		goto free_mutex;
+
+	err = 0;
+	goto exit;
+
+free_mutex:
+	mutex_unlock(&(*task)->signal->cred_guard_mutex);
+put_task:
+	put_task_struct(*task);
+	*task = NULL;
+exit:
+	return err;
+}
+
+static void unlock_pid_trace(struct task_struct *task)
+{
+	if (task) {
+		mutex_unlock(&task->signal->cred_guard_mutex);
+		put_task_struct(task);
+	}
+}
+
+static int proc_pid_perms_open(struct inode *inode, struct file *file)
+{
+	struct proc_inode *pi = PROC_I(inode);
+
+	/* No ptrace check here.  All checks should be located
+	 * in read/write/readdir/etc. */
+
+	if (pi->real_fops->open)
+		return pi->real_fops->open(inode, file);
+	return 0;
+}
+
+static int proc_pid_perms_release(struct inode *inode, struct file *file)
+{
+	struct proc_inode *pi = PROC_I(inode);
+
+	if (pi->real_fops->release)
+		return pi->real_fops->release(inode, file);
+	return 0;
+}
+
+static ssize_t proc_pid_perms_read(struct file * file, char __user * buf,
+			  size_t count, loff_t *ppos)
+{
+	struct dentry *dentry = file->f_dentry;
+	struct proc_inode *pi = PROC_I(dentry->d_inode);
+	int rc;
+	struct task_struct *task;
+
+	if (pi->real_fops->read) {
+		rc = lock_pid_trace(dentry, MAY_READ, &task);
+		if (!rc)
+			rc = pi->real_fops->read(file, buf, count, ppos);
+		unlock_pid_trace(task);
+		return rc;
+	}
+
+	/* Should never happen, but better safe than sorry */
+	return -EPERM;
+}
+
+static ssize_t proc_pid_perms_write(struct file *file, const char __user *buf,
+			    size_t count, loff_t *offs)
+{
+	struct dentry *dentry = file->f_dentry;
+	struct proc_inode *pi = PROC_I(dentry->d_inode);
+	int rc;
+	struct task_struct *task;
+
+	if (pi->real_fops->write) {
+		rc = lock_pid_trace(dentry, MAY_WRITE, &task);
+		if (!rc)
+			rc = pi->real_fops->write(file, buf, count, offs);
+		unlock_pid_trace(task);
+		return rc;
+	}
+
+	/* Should never happen, but better safe than sorry */
+	return -EPERM;
+}
+
+static int proc_pid_perms_readdir(struct file *file, void *dirent, filldir_t filldir)
+{
+	struct dentry *dentry = file->f_dentry;
+	struct proc_inode *pi = PROC_I(dentry->d_inode);
+	int rc;
+	struct task_struct *task;
+
+	if (pi->real_fops->readdir) {
+		rc = lock_pid_trace(dentry, MAY_READ, &task);
+		if (!rc)
+			rc = pi->real_fops->readdir(file, dirent, filldir);
+		unlock_pid_trace(task);
+		return rc;
+	}
+
+	/* Should never happen, but better safe than sorry */
+	return -ENOTDIR;
+}
+
+static unsigned proc_pid_perms_poll(struct file *file, poll_table *wait)
+{
+	struct dentry *dentry = file->f_dentry;
+	struct proc_inode *pi = PROC_I(dentry->d_inode);
+	struct task_struct *task;
+	int rc;
+
+	/* Check perms before the poll.  There is a race against execve(),
+	 * but hopefuly the infoleak is very minor */
+	rc = lock_pid_trace(dentry, MAY_READ, &task);
+	unlock_pid_trace(task);
+	if (rc)
+		return rc;
+
+	if (pi->real_fops->poll)
+		return pi->real_fops->poll(file, wait);
+
+	/* The fallback for files not implementing poll */
+	return DEFAULT_POLLMASK;
+}
+
+static loff_t proc_pid_perms_llseek(struct file *file, loff_t offset, int orig)
+{
+	struct proc_inode *pi = PROC_I(file->f_dentry->d_inode);
+
+	/* Looks like llseek() doesn't need any ptrace protection */
+
+	if (pi->real_fops->llseek)
+		return pi->real_fops->llseek(file, offset, orig);
+
+	return no_llseek(file, offset, orig);
+}
+
+/*
+ * Global wrapper fops for _ALL_ files inside /proc/PID/.
+ *
+ * It checks the permissions (including ptrace() check) of the current
+ * task on all file ops.  The runtime checks protect from holding any fd
+ * across execve() of set*id binaries.  task->signal->cred_guard_mutex
+ * is held during read(), readdir(), and write().  open(), release(),
+ * llseek() are not protected as they are harmless anyway.  It makes
+ * effort to check permissions on poll(), but it doesn't hold the
+ * mutex during actual fops->poll() as poll() might sleep for much time. 
+ *
+ * It makes sense to use proc_pid_perms_fops even for files doing their
+ * own checks (e.g. REG_PERMS()).
+ */
+const struct file_operations proc_pid_perms_fops = {
+	.open		= proc_pid_perms_open,
+	.read		= proc_pid_perms_read,
+	.readdir	= proc_pid_perms_readdir,
+	.write		= proc_pid_perms_write,
+	.llseek		= proc_pid_perms_llseek,
+	.poll		= proc_pid_perms_poll,
+	.release	= proc_pid_perms_release,
+};
+
+mode_t get_ent_perms(const struct pid_entry *p,
+		struct proc_perms *perms,
+		int ndir,
+		int nent)
+{
+	mode_t umask = perms->proc_ent_allowed[ndir][nent] ? 0 : 077;
+	return p->mode & ~umask;
+}
+
+int init_proc_perms(struct proc_perms *p)
+{
+	int i;
+
+	p->proc_pid_allowed = true;
+	for (i = 0; i < PROC_PERMS_NMAX; i++) {
+		size_t size = perms_size[i]*sizeof(bool);
+		p->proc_ent_allowed[i] = kzalloc(size, GFP_KERNEL);
+		if (p->proc_ent_allowed[i] == NULL)
+			goto err;
+	}
+
+	return 0;
+err:
+	for (i-- ; i >= 0; i--)
+		kfree(p->proc_ent_allowed[i]);
+	return -ENOMEM;
+}
+
+void free_proc_perms(struct proc_perms *p)
+{
+	int i;
+
+	for (i = 0; i < PROC_PERMS_NMAX; i++)
+		kfree(p->proc_ent_allowed[i]);
+}
+
+void fill_proc_perms_ent(struct proc_perms *p, int ndir, bool val)
+{
+	int i;
+	for (i = 0; i < perms_size[ndir]; i++)
+		p->proc_ent_allowed[ndir][i] = val;
+}
+
+bool set_proc_perms_ent(struct proc_perms *p, int ndir, const char *fname, bool val)
+{
+	int i;
+	for (i = 0; i < perms_size[ndir]; i++)
+		if (!strcmp(dir_ents[ndir][i].name, fname)) {
+			pr_err("found %s (%d)\n", fname, i);
+			p->proc_ent_allowed[ndir][i] = val;
+			return true;
+		}
+
+	pr_err("not found %s (%d)\n", fname, i);
+	return false;
+}
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 74b48cf..0a02c79 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -18,6 +18,10 @@
 #include <linux/module.h>
 #include <linux/sysctl.h>
 #include <linux/slab.h>
+#include <linux/pid_namespace.h>
+#include <linux/seq_file.h>
+#include <linux/mount.h>
+
 
 #include <asm/system.h>
 #include <asm/uaccess.h>
@@ -69,6 +73,7 @@ static struct inode *proc_alloc_inode(struct super_block *sb)
 	ei->sysctl_entry = NULL;
 	ei->ns = NULL;
 	ei->ns_ops = NULL;
+	ei->real_fops = NULL;
 	inode = &ei->vfs_inode;
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
 	return inode;
@@ -102,12 +107,25 @@ void __init proc_init_inodecache(void)
 					     init_once);
 }
 
+static int proc_show_options(struct seq_file *seq, struct vfsmount *vfs)
+{
+       struct super_block *sb = vfs->mnt_sb;
+       struct pid_namespace *pid = sb->s_fs_info;
+
+       if (pid->proc_perms.proc_pid_allowed)
+               seq_printf(seq, ",proc_pid_allowed=.");
+
+       return 0;
+}
+
 static const struct super_operations proc_sops = {
 	.alloc_inode	= proc_alloc_inode,
 	.destroy_inode	= proc_destroy_inode,
 	.drop_inode	= generic_delete_inode,
 	.evict_inode	= proc_evict_inode,
 	.statfs		= simple_statfs,
+	.remount_fs     = proc_remount,
+	.show_options   = proc_show_options,
 };
 
 static void __pde_users_dec(struct proc_dir_entry *pde)
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 7838e5c..35c760a 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -141,7 +141,31 @@ struct inode *proc_pid_make_inode(struct super_block * sb, struct task_struct *t
 extern const struct dentry_operations pid_dentry_operations;
 int pid_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat);
 int proc_setattr(struct dentry *dentry, struct iattr *attr);
+int proc_remount(struct super_block *sb, int *flags, char *data);
 
 extern const struct inode_operations proc_ns_dir_inode_operations;
 extern const struct file_operations proc_ns_dir_operations;
 
+extern const struct inode_operations proc_tgid_base_inode_operations;
+extern const struct inode_operations proc_tid_base_inode_operations;
+extern const struct inode_operations proc_attr_dir_inode_operations;
+
+extern const struct file_operations proc_pid_perms_fops;
+extern const int perms_size[];
+extern const struct pid_entry *dir_ents[];
+
+extern mode_t get_ent_perms(const struct pid_entry *p,
+		struct proc_perms *perms,
+		int ndir,
+		int nent);
+
+struct pid_entry {
+	char *name;
+	int len;
+	mode_t mode;
+	const struct inode_operations *iop;
+	const struct file_operations *fop;
+	union proc_op op;
+	bool need_perms_check;
+};
+
diff --git a/fs/proc/root.c b/fs/proc/root.c
index d6c3b41..9193fa1 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -18,6 +18,7 @@
 #include <linux/bitops.h>
 #include <linux/mount.h>
 #include <linux/pid_namespace.h>
+#include <linux/parser.h>
 
 #include "internal.h"
 
@@ -36,6 +37,112 @@ static int proc_set_super(struct super_block *sb, void *data)
 	return err;
 }
 
+enum {
+       Opt_err, Opt_tid_allowed, Opt_tgid_allowed, Opt_attr_allowed,
+};
+
+static const match_table_t tokens = {
+       {Opt_tgid_allowed, "tgid_allowed=%s"},
+       {Opt_tid_allowed, "tid_allowed=%s"},
+       {Opt_attr_allowed, "attr_allowed=%s"},
+       {Opt_err, NULL},
+};
+
+static bool proc_parse_xallowed(struct proc_perms *p, int ndir, char *val, bool set_pid_allowed)
+{
+	char *field;
+
+	fill_proc_perms_ent(p, ndir, false);
+
+	if (strcmp(val, "none") == 0) {
+		if (set_pid_allowed)
+			p->proc_pid_allowed = false;
+		return true;
+	}
+	if (strcmp(val, "all") == 0) {
+		fill_proc_perms_ent(p, ndir, true);
+		if (set_pid_allowed)
+			p->proc_pid_allowed = true;
+		return true;
+	}
+
+	while ((field = strsep(&val, ";")) != NULL) {
+		if (!set_proc_perms_ent(p, ndir, field, true))
+			return false;
+	}
+
+	if (set_pid_allowed)
+		p->proc_pid_allowed = true;
+	return true;
+}
+
+static int proc_parse_options(char *options, struct pid_namespace *pid)
+{
+	char *p, *val;
+	substring_t args[MAX_OPT_ARGS];
+
+	pr_debug("proc: options = %s\n", options);
+
+	if (!options)
+		return 1;
+
+	while ((p = strsep(&options, ",")) != NULL) {
+		int token;
+		if (!*p)
+			continue;
+
+		args[0].to = args[0].from = 0;
+		token = match_token(p, tokens, args);
+		switch (token) {
+			case Opt_tgid_allowed:
+				val = match_strdup(&args[0]);
+				if (!val)
+					return 0;
+				if (!proc_parse_xallowed(&pid->proc_perms, PROC_PERMS_NTGID, val, true)) {
+					kfree(val);
+					return 0;
+				}
+				kfree(val);
+				break;
+			case Opt_tid_allowed:
+				val = match_strdup(&args[0]);
+				if (!val)
+					return 0;
+				if (!proc_parse_xallowed(&pid->proc_perms, PROC_PERMS_NTID, val, false)) {
+					kfree(val);
+					return 0;
+				}
+				kfree(val);
+				break;
+			case Opt_attr_allowed:
+				val = match_strdup(&args[0]);
+				if (!val)
+					return 0;
+				if (!proc_parse_xallowed(&pid->proc_perms, PROC_PERMS_NATTR, val, false)) {
+					kfree(val);
+					return 0;
+				}
+				kfree(val);
+				break;
+			default:
+				pr_err("proc: unrecognized mount option \"%s\" "
+						"or missing value", p);
+				return 0;
+		}
+	}
+
+	//pr_debug("proc: gid = %u, hidepid = %o, hidenet = %d\n", pid->pid_gid, pid->hide_pid, (int)pid->hide_net);
+
+	return 1;
+}
+
+int proc_remount(struct super_block *sb, int *flags, char *data)
+{
+       struct pid_namespace *pid = sb->s_fs_info;
+       return !proc_parse_options(data, pid);
+}
+
+
 static struct dentry *proc_mount(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data)
 {
@@ -43,11 +150,16 @@ static struct dentry *proc_mount(struct file_system_type *fs_type,
 	struct super_block *sb;
 	struct pid_namespace *ns;
 	struct proc_inode *ei;
+	char *options;
 
-	if (flags & MS_KERNMOUNT)
+
+	if (flags & MS_KERNMOUNT) {
 		ns = (struct pid_namespace *)data;
-	else
+		options = NULL;
+	} else {
 		ns = current->nsproxy->pid_ns;
+		options = data;
+	}
 
 	sb = sget(fs_type, proc_test_super, proc_set_super, ns);
 	if (IS_ERR(sb))
@@ -55,6 +167,10 @@ static struct dentry *proc_mount(struct file_system_type *fs_type,
 
 	if (!sb->s_root) {
 		sb->s_flags = flags;
+		if (!proc_parse_options(options, ns)) {
+			deactivate_locked_super(sb);
+			return ERR_PTR(-EINVAL);
+		}
 		err = proc_fill_super(sb);
 		if (err) {
 			deactivate_locked_super(sb);
@@ -74,6 +190,7 @@ static struct dentry *proc_mount(struct file_system_type *fs_type,
 	return dget(sb->s_root);
 }
 
+
 static void proc_kill_sb(struct super_block *sb)
 {
 	struct pid_namespace *ns;
diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index 980de54..da98ba2 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -201,7 +201,7 @@ static void *m_start(struct seq_file *m, loff_t *pos)
 	if (!priv->task)
 		return ERR_PTR(-ESRCH);
 
-	mm = mm_for_maps(priv->task);
+	mm = get_task_mm(priv->task);
 	if (!mm || IS_ERR(mm)) {
 		put_task_struct(priv->task);
 		priv->task = NULL;
diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index 38d1032..ed10329 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -16,6 +16,18 @@ struct pidmap {
 
 struct bsd_acct_struct;
 
+enum {
+	PROC_PERMS_NTID,
+	PROC_PERMS_NTGID,
+	PROC_PERMS_NATTR,
+	PROC_PERMS_NMAX
+};
+
+struct proc_perms {
+	bool proc_pid_allowed;
+	bool *proc_ent_allowed[PROC_PERMS_NMAX];
+};
+
 struct pid_namespace {
 	struct kref kref;
 	struct pidmap pidmap[PIDMAP_ENTRIES];
@@ -30,6 +42,7 @@ struct pid_namespace {
 #ifdef CONFIG_BSD_PROCESS_ACCT
 	struct bsd_acct_struct *bacct;
 #endif
+	struct proc_perms proc_perms;
 };
 
 extern struct pid_namespace init_pid_ns;
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index e7576cf..a1525d7 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -115,10 +115,17 @@ struct proc_dir_entry *proc_create_data(const char *name, mode_t mode,
 extern void remove_proc_entry(const char *name, struct proc_dir_entry *parent);
 
 struct pid_namespace;
+struct proc_perms;
 
 extern int pid_ns_prepare_proc(struct pid_namespace *ns);
 extern void pid_ns_release_proc(struct pid_namespace *ns);
 
+extern int init_proc_perms(struct proc_perms *p);
+extern void free_proc_perms(struct proc_perms *p);
+
+extern void fill_proc_perms_ent(struct proc_perms *p, int ndir, bool val);
+extern bool set_proc_perms_ent(struct proc_perms *p, int ndir, const char *fname, bool val);
+
 /*
  * proc_tty.c
  */
@@ -267,6 +274,11 @@ struct proc_inode {
 	struct pid *pid;
 	int fd;
 	union proc_op op;
+
+	/* Used by files inside /proc/PID/ only */
+	const struct file_operations *real_fops;
+	const void *dirent;
+
 	struct proc_dir_entry *pde;
 	struct ctl_table_header *sysctl;
 	struct ctl_table *sysctl_entry;
diff --git a/kernel/pid.c b/kernel/pid.c
index 57a8346..ffa8b37 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -565,6 +565,8 @@ void __init pidmap_init(void)
 	set_bit(0, init_pid_ns.pidmap[0].page);
 	atomic_dec(&init_pid_ns.pidmap[0].nr_free);
 
+	BUG_ON(init_proc_perms(&init_pid_ns.proc_perms));
+
 	init_pid_ns.pid_cachep = KMEM_CACHE(pid,
 			SLAB_HWCACHE_ALIGN | SLAB_PANIC);
 }
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index e9c9adc..ab4261c 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -97,12 +97,18 @@ static struct pid_namespace *create_pid_namespace(struct pid_namespace *parent_p
 	for (i = 1; i < PIDMAP_ENTRIES; i++)
 		atomic_set(&ns->pidmap[i].nr_free, BITS_PER_PAGE);
 
-	err = pid_ns_prepare_proc(ns);
+	err = init_proc_perms(&ns->proc_perms);
 	if (err)
 		goto out_put_parent_pid_ns;
 
+	err = pid_ns_prepare_proc(ns);
+	if (err)
+		goto out_free_proc_perms;
+
 	return ns;
 
+out_free_proc_perms:
+	free_proc_perms(&ns->proc_perms);
 out_put_parent_pid_ns:
 	put_pid_ns(parent_pid_ns);
 out_free_map:
@@ -119,6 +125,8 @@ static void destroy_pid_namespace(struct pid_namespace *ns)
 
 	for (i = 0; i < PIDMAP_ENTRIES; i++)
 		kfree(ns->pidmap[i].page);
+	
+	free_proc_perms(&ns->proc_perms);
 	kmem_cache_free(pid_ns_cachep, ns);
 }
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index f175d98..745b71e 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -57,6 +57,7 @@
 #include <linux/pipe_fs_i.h>
 #include <linux/oom.h>
 #include <linux/kmod.h>
+#include <linux/pid_namespace.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
--
