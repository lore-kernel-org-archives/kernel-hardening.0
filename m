Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 3 Mar 2012 01:35:02 +0100
From: Djalal Harouni <tixxdz@opendz.org>
Message-ID: <20120303003502.GA5593@dztty>
References: <20120210020658.GA17709@dztty>
 <20120210143616.GA6100@albatros>
 <20120221145653.GA22597@openwall.com>
 <20120224005613.GA32733@openwall.com>
 <20120225035653.GA5294@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120225035653.GA5294@openwall.com>
Subject: Re: [kernel-hardening] procfs: infoleaks and DAC permissions
To: kernel-hardening@lists.openwall.com
Cc: Brad Spengler <spender@grsecurity.net>, Solar Designer <solar@openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On Sat, Feb 25, 2012 at 07:56:53AM +0400, Solar Designer wrote:
> I am now getting some of this stuff into the RHEL5'ish kernels that we
> use on Owl.
Based on Brad's exec_id I've added (converted) some private structures
which can be used now to protect all the /proc/pid/ files. The patch is
bellow (not finished, the idea is there, just use it for the appropriate
files or all of them ?), this is the cost of protecting the files without
changing their internal logic.


Currently:
Info files (INF) /proc/pid/{hardwall,io,auxv,limits,syscall...} are all
protected by a one hit just before returning results to userspace.

ONE files /proc/pid/{syscall,stack,...} are also protected, every handler
implements its own check as in grsecurity. Please note that we can also
have a single check for all these files, I did not do that since I still
have some concerns (not sure) which perhaps I'll discuss on lkml.

REG files should implement their checks, BTW the
/proc/<pid>/{environ,pagemap} in the attached patch implement the two
protections:
1) self-read protection.
2) DAC bypass protection: the files are 0400 and the PTRACE_MODE_READ is
   checked at open() and read(). open() also need the PTRACE check to
   avoid any other capability bypass which can be allowed by the VFS.

This solution should also be applied to the other files which can leak
sensitive information, and if every thing is ok then /proc/<pid>/mem should
do the same, except for /proc/pid/maps which will break glibc, the
solution for /proc/pid/maps was already given by Vasiliy in the other
thread: 0444 mode and check at open():

if (current != task && !ptrace_may_access(task, PTRACE_MODE_READ))
        return -EACCES;

We may add here:
  if (current->mm == task->mm) then allow

In case both share the same mm, or just do the check with mm_for_maps() or
mm_access().

I must say that even this can't be fully trusted since creds of
current/target may change at any time, and even setuid can't trust its own
/proc/self files. The correct check should be done before returning to
userpsace as it was noted in this 2003/2004 thread [1], BTW you can find
on this 2003 old thread how to exploit this 2011/2012 /proc/self/mem
vulnerability :-)


For the DIR entries I did not have enough time to check them.


I want to add that hopefully the saved exec_id is the id of current
which is an aggressive behaviour. This will protect procfs info files
like the '/proc/pid/auxv' file when it's opened by a CAP_DAC_OVERRIDE
process... and passed to a CAP_SYS_PTRACE process (setuid) since the info
files do not implement the open() operation, so no ptrace checks... seems
like with CAP_DAC_OVERRIDE we can get CAP_SYS_PTRACE...

The patch below adds an open() operation but just to setup the exec_id,
adding the ptrace check will break the info files, unless we change the
logic of 'auxv' and others sensitive files to be a REG file.

I'm mentioning this since the current logic of /proc/self/mem is to attach
and reference the target, which can also be emulated by setting the
exec_id to the target's id ... but in that case we also need proper perms
checks at open(), read() ...


I'll clean the patch, split it and try to submit the series soon.
And sorry for my late response (homeworks done :) and just got some time).

Thanks.

[1] http://lkml.indiana.edu/hypermail/linux/kernel/0407.0/1314.html


procfs: protections for /proc/pid/* files
The exec_id idea was taken from the latest grsecurity patches:
grsecurity-2.9-3.2.8-201202272117.patch

Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---

diff --git a/fs/exec.c b/fs/exec.c
index 92ce83a..42c3fff 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1448,6 +1448,14 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 EXPORT_SYMBOL(search_binary_handler);
 
 /*
+ * A global execve counter that we need to set atomically.
+ * It will be incremented on every do_execve_common() this way we can use
+ * it to check if some special objects belong to the appropriate process
+ * image.
+ */
+static atomic64_t exec_counter = ATOMIC_INIT(0);
+
+/*
  * sys_execve() executes a new program.
  */
 static int do_execve_common(const char *filename,
@@ -1542,6 +1550,7 @@ static int do_execve_common(const char *filename,
 		goto out;
 
 	/* execve succeeded */
+	current->exec_id = atomic64_inc_return(&exec_counter);
 	current->fs->in_exec = 0;
 	current->in_execve = 0;
 	acct_update_integrals(current);
diff --git a/fs/proc/array.c b/fs/proc/array.c
index c602b8d..e861cb2 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -340,8 +340,12 @@ static void task_cpus_allowed(struct seq_file *m, struct task_struct *task)
 int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
 			struct pid *pid, struct task_struct *task)
 {
-	struct mm_struct *mm = get_task_mm(task);
+	struct mm_struct *mm;
+
+	if (!proc_exec_id_ok(current, m->private))
+		return 0;
 
+	mm = get_task_mm(task);
 	task_name(m, task);
 	task_state(m, ns, pid, task);
 
@@ -378,6 +382,9 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 	char tcomm[sizeof(task->comm)];
 	unsigned long flags;
 
+	if (!proc_exec_id_ok(current, m->private))
+		return 0;
+
 	state = *get_task_state(task);
 	vsize = eip = esp = 0;
 	permitted = ptrace_may_access(task, PTRACE_MODE_READ | PTRACE_MODE_NOAUDIT);
@@ -536,8 +543,12 @@ int proc_pid_statm(struct seq_file *m, struct pid_namespace *ns,
 			struct pid *pid, struct task_struct *task)
 {
 	unsigned long size = 0, resident = 0, shared = 0, text = 0, data = 0;
-	struct mm_struct *mm = get_task_mm(task);
+	struct mm_struct *mm;
+
+	if (!proc_exec_id_ok(current, m->private))
+		return 0;
 
+	mm = get_task_mm(task);
 	if (mm) {
 		size = task_statm(mm, &shared, &text, &data, &resident);
 		mmput(mm);
diff --git a/fs/proc/base.c b/fs/proc/base.c
index d4548dd..f68f7fc 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -288,7 +288,7 @@ static int lock_trace(struct task_struct *task)
 		return err;
 	if (!ptrace_may_access(task, PTRACE_MODE_ATTACH)) {
 		mutex_unlock(&task->signal->cred_guard_mutex);
-		return -EPERM;
+		return -EACCES;
 	}
 	return 0;
 }
@@ -305,6 +305,7 @@ static void unlock_trace(struct task_struct *task)
 static int proc_pid_stack(struct seq_file *m, struct pid_namespace *ns,
 			  struct pid *pid, struct task_struct *task)
 {
+	struct proc_file_private *priv = m->private;
 	struct stack_trace trace;
 	unsigned long *entries;
 	int err;
@@ -320,17 +321,24 @@ static int proc_pid_stack(struct seq_file *m, struct pid_namespace *ns,
 	trace.skip		= 0;
 
 	err = lock_trace(task);
-	if (!err) {
-		save_stack_trace_tsk(task, &trace);
+	if (err)
+		goto free;
 
-		for (i = 0; i < trace.nr_entries; i++) {
-			seq_printf(m, "[<%pK>] %pS\n",
-				   (void *)entries[i], (void *)entries[i]);
-		}
-		unlock_trace(task);
+	err = 0;
+	if (!proc_exec_id_ok(current, priv))
+		goto unlock;
+
+	save_stack_trace_tsk(task, &trace);
+
+	for (i = 0; i < trace.nr_entries; i++) {
+		seq_printf(m, "[<%pK>] %pS\n",
+			   (void *)entries[i], (void *)entries[i]);
 	}
-	kfree(entries);
 
+unlock:
+	unlock_trace(task);
+free:
+	kfree(entries);
 	return err;
 }
 #endif
@@ -610,15 +618,35 @@ static const struct inode_operations proc_def_inode_operations = {
 
 #define PROC_BLOCK_SIZE	(3*1024)		/* 4K page size but our output routines use some slack for overruns */
 
+static int proc_info_open(struct inode *inode, struct file *filp)
+{
+	struct proc_file_private *priv;
+	int ret = -ENOMEM;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return ret;
+
+	priv->exec_id = current->exec_id;
+	filp->private_data = priv;
+
+	return 0;
+}
+
 static ssize_t proc_info_read(struct file * file, char __user * buf,
 			  size_t count, loff_t *ppos)
 {
 	struct inode * inode = file->f_path.dentry->d_inode;
+	struct proc_file_private *priv = file->private_data;
 	unsigned long page;
-	ssize_t length;
-	struct task_struct *task = get_proc_task(inode);
+	ssize_t length = 0;
+	struct task_struct *task;
+
+	if (!priv)
+		return length;
 
 	length = -ESRCH;
+	task = get_proc_task(inode);
 	if (!task)
 		goto out_no_task;
 
@@ -631,8 +659,16 @@ static ssize_t proc_info_read(struct file * file, char __user * buf,
 
 	length = PROC_I(inode)->op.proc_read(task, (char*)page);
 
+	/* Check delayed */
+	if (!proc_exec_id_ok(current, priv)) {
+		length = 0;
+		goto out_free;
+	}
+
 	if (length >= 0)
 		length = simple_read_from_buffer(buf, count, ppos, (char *)page, length);
+
+out_free:
 	free_page(page);
 out:
 	put_task_struct(task);
@@ -640,14 +676,25 @@ out_no_task:
 	return length;
 }
 
+static int proc_info_release(struct inode *inode, struct file *filp)
+{
+	struct proc_file_private *priv = filp->private_data;
+
+	kfree(priv);
+	return 0;
+}
+
 static const struct file_operations proc_info_file_operations = {
+	.open		= proc_info_open,
 	.read		= proc_info_read,
 	.llseek		= generic_file_llseek,
+	.release	= proc_info_release,
 };
 
 static int proc_single_show(struct seq_file *m, void *v)
 {
-	struct inode *inode = m->private;
+	struct proc_file_private *priv = m->private;
+	struct inode *inode = priv->inode;
 	struct pid_namespace *ns;
 	struct pid *pid;
 	struct task_struct *task;
@@ -667,14 +714,36 @@ static int proc_single_show(struct seq_file *m, void *v)
 
 static int proc_single_open(struct inode *inode, struct file *filp)
 {
-	return single_open(filp, proc_single_show, inode);
+	struct proc_file_private *priv;
+	int ret = -ENOMEM;
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (priv) {
+		priv->exec_id = current->exec_id;
+		ret = single_open(filp, proc_single_show, priv);
+		if (!ret)
+			priv->inode = inode;
+		else
+			kfree(priv);
+	}
+	return ret;
+}
+
+static int proc_single_release(struct inode *inode, struct file *filp)
+{
+	struct seq_file *seq = filp->private_data;
+	int ret = 0;
+	if (seq) {
+		kfree(seq->private);
+		ret = single_release(inode, filp);
+	}
+	return ret;
 }
 
 static const struct file_operations proc_single_file_operations = {
 	.open		= proc_single_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= single_release,
+	.release	= proc_single_release,
 };
 
 static int mem_open(struct inode* inode, struct file* file)
@@ -801,15 +870,62 @@ static const struct file_operations proc_mem_operations = {
 	.release	= mem_release,
 };
 
+static int environ_open(struct inode *inode, struct file *filp)
+{
+	struct proc_file_private *priv;
+	struct mm_struct *mm;
+	struct task_struct *task;
+	int ret = -ENOMEM;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return ret;
+
+	ret = -ESRCH;
+	task = get_proc_task(filp->f_path.dentry->d_inode);
+	if (!task)
+		goto out_free;
+
+	priv->exec_id = current->exec_id;
+	mm = mm_for_maps(task);
+	put_task_struct(task);
+
+	if (!mm) {
+		ret = -ENOENT;
+		goto out_free;
+	}
+
+	if (IS_ERR(mm)) {
+		ret = PTR_ERR(mm);
+		goto out_free;
+	}
+
+	filp->private_data = priv;
+	/* do not pin mm */
+	mmput(mm);
+
+	return 0;
+
+out_free:
+	kfree(priv);
+	return ret;
+}
+
 static ssize_t environ_read(struct file *file, char __user *buf,
 			size_t count, loff_t *ppos)
 {
-	struct task_struct *task = get_proc_task(file->f_dentry->d_inode);
+	struct proc_file_private *priv = file->private_data;
+	struct task_struct *task;
 	char *page;
 	unsigned long src = *ppos;
-	int ret = -ESRCH;
+	int ret = 0;
 	struct mm_struct *mm;
 
+	if (!priv)
+		return ret;
+
+	ret = -ESRCH;
+	task = get_proc_task(file->f_dentry->d_inode);
 	if (!task)
 		goto out_no_task;
 
@@ -820,11 +936,21 @@ static ssize_t environ_read(struct file *file, char __user *buf,
 
 
 	mm = mm_for_maps(task);
-	ret = PTR_ERR(mm);
-	if (!mm || IS_ERR(mm))
+
+	if (!mm) {
+		ret = -ENOENT;
 		goto out_free;
+	}
+
+	if (IS_ERR(mm)) {
+		ret = PTR_ERR(mm);
+		goto out_free;
+	}
 
 	ret = 0;
+	if (!proc_exec_id_ok(current, priv))
+		goto out_mm;
+
 	while (count > 0) {
 		int this_len, retval, max_len;
 
@@ -856,6 +982,7 @@ static ssize_t environ_read(struct file *file, char __user *buf,
 	}
 	*ppos = src;
 
+out_mm:
 	mmput(mm);
 out_free:
 	free_page((unsigned long) page);
@@ -865,9 +992,19 @@ out_no_task:
 	return ret;
 }
 
+static int environ_release(struct inode *inode, struct file *filp)
+{
+	struct proc_file_private *priv = filp->private_data;
+
+	kfree(priv);
+	return 0;
+}
+
 static const struct file_operations proc_environ_operations = {
+	.open		= environ_open,
 	.read		= environ_read,
 	.llseek		= generic_file_llseek,
+	.release	= environ_release,
 };
 
 static ssize_t oom_adjust_read(struct file *file, char __user *buf,
@@ -2948,10 +3085,14 @@ static int proc_pid_personality(struct seq_file *m, struct pid_namespace *ns,
 				struct pid *pid, struct task_struct *task)
 {
 	int err = lock_trace(task);
-	if (!err) {
+	if (err)
+		return err;
+
+	err = 0;
+	if (proc_exec_id_ok(current, m->private))
 		seq_printf(m, "%08x\n", task->personality);
-		unlock_trace(task);
-	}
+
+	unlock_trace(task);
 	return err;
 }
 
@@ -2975,7 +3116,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	REG("environ",    S_IRUSR, proc_environ_operations),
 	INF("auxv",       S_IRUSR, proc_pid_auxv),
 	ONE("status",     S_IRUGO, proc_pid_status),
-	ONE("personality", S_IRUGO, proc_pid_personality),
+	ONE("personality", S_IRUSR, proc_pid_personality),
 	INF("limits",	  S_IRUGO, proc_pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",      S_IRUGO|S_IWUSR, proc_pid_sched_operations),
@@ -2985,14 +3126,14 @@ static const struct pid_entry tgid_base_stuff[] = {
 #endif
 	REG("comm",      S_IRUGO|S_IWUSR, proc_pid_set_comm_operations),
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
-	INF("syscall",    S_IRUGO, proc_pid_syscall),
+	INF("syscall",    S_IRUSR, proc_pid_syscall),
 #endif
 	INF("cmdline",    S_IRUGO, proc_pid_cmdline),
 	ONE("stat",       S_IRUGO, proc_tgid_stat),
 	ONE("statm",      S_IRUGO, proc_pid_statm),
 	REG("maps",       S_IRUGO, proc_maps_operations),
 #ifdef CONFIG_NUMA
-	REG("numa_maps",  S_IRUGO, proc_numa_maps_operations),
+	REG("numa_maps",  S_IRUSR, proc_numa_maps_operations),
 #endif
 	REG("mem",        S_IRUSR|S_IWUSR, proc_mem_operations),
 	LNK("cwd",        proc_cwd_link),
@@ -3003,8 +3144,8 @@ static const struct pid_entry tgid_base_stuff[] = {
 	REG("mountstats", S_IRUSR, proc_mountstats_operations),
 #ifdef CONFIG_PROC_PAGE_MONITOR
 	REG("clear_refs", S_IWUSR, proc_clear_refs_operations),
-	REG("smaps",      S_IRUGO, proc_smaps_operations),
-	REG("pagemap",    S_IRUGO, proc_pagemap_operations),
+	REG("smaps",      S_IRUSR, proc_smaps_operations),
+	REG("pagemap",    S_IRUSR, proc_pagemap_operations),
 #endif
 #ifdef CONFIG_SECURITY
 	DIR("attr",       S_IRUGO|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
@@ -3013,7 +3154,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	INF("wchan",      S_IRUGO, proc_pid_wchan),
 #endif
 #ifdef CONFIG_STACKTRACE
-	ONE("stack",      S_IRUGO, proc_pid_stack),
+	ONE("stack",      S_IRUSR, proc_pid_stack),
 #endif
 #ifdef CONFIG_SCHEDSTATS
 	INF("schedstat",  S_IRUGO, proc_pid_schedstat),
@@ -3337,21 +3478,21 @@ static const struct pid_entry tid_base_stuff[] = {
 	REG("environ",   S_IRUSR, proc_environ_operations),
 	INF("auxv",      S_IRUSR, proc_pid_auxv),
 	ONE("status",    S_IRUGO, proc_pid_status),
-	ONE("personality", S_IRUGO, proc_pid_personality),
+	ONE("personality", S_IRUSR, proc_pid_personality),
 	INF("limits",	 S_IRUGO, proc_pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",     S_IRUGO|S_IWUSR, proc_pid_sched_operations),
 #endif
 	REG("comm",      S_IRUGO|S_IWUSR, proc_pid_set_comm_operations),
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
-	INF("syscall",   S_IRUGO, proc_pid_syscall),
+	INF("syscall",   S_IRUSR, proc_pid_syscall),
 #endif
 	INF("cmdline",   S_IRUGO, proc_pid_cmdline),
 	ONE("stat",      S_IRUGO, proc_tid_stat),
 	ONE("statm",     S_IRUGO, proc_pid_statm),
 	REG("maps",      S_IRUGO, proc_maps_operations),
 #ifdef CONFIG_NUMA
-	REG("numa_maps", S_IRUGO, proc_numa_maps_operations),
+	REG("numa_maps", S_IRUSR, proc_numa_maps_operations),
 #endif
 	REG("mem",       S_IRUSR|S_IWUSR, proc_mem_operations),
 	LNK("cwd",       proc_cwd_link),
@@ -3361,8 +3502,8 @@ static const struct pid_entry tid_base_stuff[] = {
 	REG("mountinfo",  S_IRUGO, proc_mountinfo_operations),
 #ifdef CONFIG_PROC_PAGE_MONITOR
 	REG("clear_refs", S_IWUSR, proc_clear_refs_operations),
-	REG("smaps",     S_IRUGO, proc_smaps_operations),
-	REG("pagemap",    S_IRUGO, proc_pagemap_operations),
+	REG("smaps",     S_IRUSR, proc_smaps_operations),
+	REG("pagemap",    S_IRUSR, proc_pagemap_operations),
 #endif
 #ifdef CONFIG_SECURITY
 	DIR("attr",      S_IRUGO|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
@@ -3371,7 +3512,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	INF("wchan",     S_IRUGO, proc_pid_wchan),
 #endif
 #ifdef CONFIG_STACKTRACE
-	ONE("stack",      S_IRUGO, proc_pid_stack),
+	ONE("stack",      S_IRUSR, proc_pid_stack),
 #endif
 #ifdef CONFIG_SCHEDSTATS
 	INF("schedstat", S_IRUGO, proc_pid_schedstat),
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 2925775..1828d3b 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -10,6 +10,7 @@
  */
 
 #include <linux/proc_fs.h>
+#include <linux/sched.h>
 
 extern struct proc_dir_entry proc_root;
 #ifdef CONFIG_PROC_SYSCTL
@@ -61,10 +62,19 @@ extern const struct file_operations proc_pagemap_operations;
 extern const struct file_operations proc_net_operations;
 extern const struct inode_operations proc_net_inode_operations;
 
-struct proc_maps_private {
+/*
+ * Internal proc_file_private is used to track procfs files being
+ * processed especially the ones that varies during runtime.
+ */
+struct proc_file_private {
+	/* The Execve ID of the task, use this to protect special procfs
+	 * files. Must be set at open time. */
+	u64 exec_id;
 	struct pid *pid;
+	struct inode *inode;
 	struct task_struct *task;
 #ifdef CONFIG_MMU
+	/* For /proc/pid/{maps,smaps...} */
 	struct vm_area_struct *tail_vma;
 #endif
 };
@@ -86,6 +96,24 @@ static inline int proc_fd(struct inode *inode)
 	return PROC_I(inode)->fd;
 }
 
+/**
+ * proc_exec_id_ok - check if the task's exec_id equals the exec_id of
+ * the proc_file_private.
+ * @task: Task struct to check against.
+ * @proc_private: The proc_file_private struct.
+ *
+ * Check if the exec_id of the two structs are equal. Use it to protect
+ * special procfs files when the fd is passed to a new execve (i.e. suid)
+ *
+ * It will be more effective if the check is delayed as mush as possible
+ * to avoid any new execve surprises.
+ */
+static inline int proc_exec_id_ok(struct task_struct *task,
+				  struct proc_file_private *proc_priv)
+{
+	return task_exec_id_ok(task, proc_priv->exec_id);
+}
+
 struct dentry *proc_lookup_de(struct proc_dir_entry *de, struct inode *ino,
 		struct dentry *dentry);
 int proc_readdir_de(struct proc_dir_entry *de, struct file *filp, void *dirent,
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 7dcd2a2..7e11b69 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -90,7 +90,7 @@ static void pad_len_spaces(struct seq_file *m, int len)
 	seq_printf(m, "%*c", len, ' ');
 }
 
-static void vma_stop(struct proc_maps_private *priv, struct vm_area_struct *vma)
+static void vma_stop(struct proc_file_private *priv, struct vm_area_struct *vma)
 {
 	if (vma && vma != priv->tail_vma) {
 		struct mm_struct *mm = vma->vm_mm;
@@ -101,7 +101,7 @@ static void vma_stop(struct proc_maps_private *priv, struct vm_area_struct *vma)
 
 static void *m_start(struct seq_file *m, loff_t *pos)
 {
-	struct proc_maps_private *priv = m->private;
+	struct proc_file_private *priv = m->private;
 	unsigned long last_addr = m->version;
 	struct mm_struct *mm;
 	struct vm_area_struct *vma, *tail_vma = NULL;
@@ -168,7 +168,7 @@ out:
 
 static void *m_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	struct proc_maps_private *priv = m->private;
+	struct proc_file_private *priv = m->private;
 	struct vm_area_struct *vma = v;
 	struct vm_area_struct *tail_vma = priv->tail_vma;
 
@@ -181,7 +181,7 @@ static void *m_next(struct seq_file *m, void *v, loff_t *pos)
 
 static void m_stop(struct seq_file *m, void *v)
 {
-	struct proc_maps_private *priv = m->private;
+	struct proc_file_private *priv = m->private;
 	struct vm_area_struct *vma = v;
 
 	if (!IS_ERR(vma))
@@ -193,15 +193,16 @@ static void m_stop(struct seq_file *m, void *v)
 static int do_maps_open(struct inode *inode, struct file *file,
 			const struct seq_operations *ops)
 {
-	struct proc_maps_private *priv;
+	struct proc_file_private *priv;
 	int ret = -ENOMEM;
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (priv) {
-		priv->pid = proc_pid(inode);
+		priv->exec_id = current->exec_id;
 		ret = seq_open(file, ops);
 		if (!ret) {
 			struct seq_file *m = file->private_data;
 			m->private = priv;
+			priv->pid = proc_pid(inode);
 		} else {
 			kfree(priv);
 		}
@@ -278,9 +279,12 @@ static void show_map_vma(struct seq_file *m, struct vm_area_struct *vma)
 static int show_map(struct seq_file *m, void *v)
 {
 	struct vm_area_struct *vma = v;
-	struct proc_maps_private *priv = m->private;
+	struct proc_file_private *priv = m->private;
 	struct task_struct *task = priv->task;
 
+	if (!proc_exec_id_ok(current, priv))
+		return 0;
+
 	show_map_vma(m, vma);
 
 	if (m->count < m->size)  /* vma is copied successfully */
@@ -424,7 +428,7 @@ static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 
 static int show_smap(struct seq_file *m, void *v)
 {
-	struct proc_maps_private *priv = m->private;
+	struct proc_file_private *priv = m->private;
 	struct task_struct *task = priv->task;
 	struct vm_area_struct *vma = v;
 	struct mem_size_stats mss;
@@ -434,6 +438,9 @@ static int show_smap(struct seq_file *m, void *v)
 		.private = &mss,
 	};
 
+	if (!proc_exec_id_ok(current, priv))
+		return 0;
+
 	memset(&mss, 0, sizeof mss);
 	mss.vma = vma;
 	/* mmap_sem is held in m_start */
@@ -757,15 +764,58 @@ static int pagemap_hugetlb_range(pte_t *pte, unsigned long hmask,
  * determine which areas of memory are actually mapped and llseek to
  * skip over unmapped regions.
  */
+
 #define PAGEMAP_WALK_SIZE	(PMD_SIZE)
 #define PAGEMAP_WALK_MASK	(PMD_MASK)
+static int pagemap_open(struct inode *inode, struct file *filp)
+{
+	struct proc_file_private *priv;
+	struct mm_struct *mm;
+	struct task_struct *task;
+	int ret = -ENOMEM;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return ret;
+
+	ret = -ESRCH;
+	task = get_proc_task(filp->f_path.dentry->d_inode);
+	if (!task)
+		goto out_free;
+
+	priv->exec_id = current->exec_id;
+	mm = mm_for_maps(task);
+	put_task_struct(task);
+
+	if (!mm) {
+		ret = -ENOENT;
+		goto out_free;
+	}
+
+	if (IS_ERR(mm)) {
+		ret = PTR_ERR(mm);
+		goto out_free;
+	}
+
+	filp->private_data = priv;
+	/* do not pin mm */
+	mmput(mm);
+
+	return 0;
+
+out_free:
+	kfree(priv);
+	return ret;
+}
+
 static ssize_t pagemap_read(struct file *file, char __user *buf,
 			    size_t count, loff_t *ppos)
 {
-	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
+	struct proc_file_private *priv = file->private_data;
+	struct task_struct *task;
 	struct mm_struct *mm;
 	struct pagemapread pm;
-	int ret = -ESRCH;
+	int ret = 0;
 	struct mm_walk pagemap_walk = {};
 	unsigned long src;
 	unsigned long svpfn;
@@ -773,6 +823,11 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
 	unsigned long end_vaddr;
 	int copied = 0;
 
+	if (!priv)
+		return ret;
+
+	ret = -ESRCH;
+	task = get_proc_task(file->f_path.dentry->d_inode);
 	if (!task)
 		goto out;
 
@@ -796,6 +851,12 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
 	if (!mm || IS_ERR(mm))
 		goto out_free;
 
+	if (!proc_exec_id_ok(current, priv)) {
+		/* There was an execve */
+		ret = 0;
+		goto out_mm;
+	}
+
 	pagemap_walk.pmd_entry = pagemap_pte_range;
 	pagemap_walk.pte_hole = pagemap_pte_hole;
 #ifdef CONFIG_HUGETLB_PAGE
@@ -857,9 +918,19 @@ out:
 	return ret;
 }
 
+static int pagemap_release(struct inode *inode, struct file *filp)
+{
+	struct proc_file_private *priv = filp->private_data;
+
+	kfree(priv);
+	return 0;
+}
+
 const struct file_operations proc_pagemap_operations = {
+	.open		= pagemap_open,
 	.llseek		= mem_lseek, /* borrow this */
 	.read		= pagemap_read,
+	.release	= pagemap_release,
 };
 #endif /* CONFIG_PROC_PAGE_MONITOR */
 
@@ -878,7 +949,7 @@ struct numa_maps {
 };
 
 struct numa_maps_private {
-	struct proc_maps_private proc_maps;
+	struct proc_file_private proc_maps;
 	struct numa_maps md;
 };
 
@@ -1005,7 +1076,7 @@ static int gather_hugetbl_stats(pte_t *pte, unsigned long hmask,
 static int show_numa_map(struct seq_file *m, void *v)
 {
 	struct numa_maps_private *numa_priv = m->private;
-	struct proc_maps_private *proc_priv = &numa_priv->proc_maps;
+	struct proc_file_private *proc_priv = &numa_priv->proc_maps;
 	struct vm_area_struct *vma = v;
 	struct numa_maps *md = &numa_priv->md;
 	struct file *file = vma->vm_file;
@@ -1018,6 +1089,9 @@ static int show_numa_map(struct seq_file *m, void *v)
 	if (!mm)
 		return 0;
 
+	if (!proc_exec_id_ok(current, proc_priv))
+		return 0;
+
 	/* Ensure we start with an empty set of numa_maps statistics. */
 	memset(md, 0, sizeof(*md));
 
@@ -1097,11 +1171,12 @@ static int numa_maps_open(struct inode *inode, struct file *file)
 	int ret = -ENOMEM;
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (priv) {
-		priv->proc_maps.pid = proc_pid(inode);
+		priv->proc_maps.exec_id = current->exec_id;
 		ret = seq_open(file, &proc_pid_numa_maps_op);
 		if (!ret) {
 			struct seq_file *m = file->private_data;
 			m->private = priv;
+			priv->proc_maps.pid = proc_pid(inode);
 		} else {
 			kfree(priv);
 		}
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7d379a6..a06a3df 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1420,6 +1420,9 @@ struct task_struct {
 #endif
 	seccomp_t seccomp;
 
+/* Execve counter: will be used to check if objects belong to the appropriate
+ * process image */
+	u64 exec_id;
 /* Thread group tracking */
    	u32 parent_exec_id;
    	u32 self_exec_id;
@@ -1752,6 +1755,23 @@ static inline int is_global_init(struct task_struct *tsk)
 	return tsk->pid == 1;
 }
 
+/**
+ * task_exec_id_ok - check if the task's exec_id equals the provided
+ * exec_id.
+ * @task: Task struct to check against.
+ * @exec_id: Execve ID.
+ *
+ * Check if the task's exec_id equals the provided exec_id. Use it to
+ * protect special objects.
+ *
+ * It will be more effective if the check is delayed as mush as possible
+ * to avoid any new execve surprises.
+ */
+static inline int task_exec_id_ok(struct task_struct *task, u64 exec_id)
+{
+	return task->exec_id == exec_id;
+}
+
 /*
  * is_container_init:
  * check whether in the task is init in its own pid namespace.


-- 
tixxdz
http://opendz.org
