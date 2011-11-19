Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 19 Nov 2011 15:02:12 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
Message-ID: <20111119110212.GB11468@albatros>
References: <20111119110126.GA11468@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111119110126.GA11468@albatros>
Subject: [kernel-hardening] [RFC v2 2/3] procfs: add hidepid= and gid= mount options
To: kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Greg KH <greg@kroah.com>, Theodore Tso <tytso@MIT.EDU>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

This patch adds support of mount options to restrict access to
/proc/PID/ directories.  The default backward-compatible "relaxed"
behaviour is left untouched.

The first mount option is called "hidepid" and its value defines how much
info about processes we want to be available for non-owners:

hidepid=0 (default) means the old behavior - anybody may read all
world-readable /proc/PID/* files.

hidepid=1 means users may not access any /proc/<pid>/ directories, but
their own.  Sensitive files like cmdline, sched*, status are now
protected against other users.  As permission checking done in
proc_pid_permission() and files' permissions are left untouched,
programs expecting specific files' modes are not confused.

hidepid=2 means hidepid=1 plus all /proc/PID/ will be invisible to
other users.  It doesn't mean that it hides whether a process
exists (it can be learned by other means, e.g. by kill -0 $PID), but
it hides process' euid and egid.  It compicates intruder's task of
gathering info about running processes, whether some daemon runs with
elevated privileges, whether another user runs some sensitive program,
whether other users run any program at all, etc.

gid=XXX defines a group that will be able to gather all processes' info
(as in hidepid=0 mode).  This group should be used instead of putting
nonroot user in sudoers file or something.  However, untrusted users
(like daemons, etc.) which are not supposed to monitor the tasks in the
whole system should not be added to the group.

hidepid=1 or higher is designed to restrict access to procfs files, which
might reveal some sensitive private information like precise keystrokes
timings:

http://www.openwall.com/lists/oss-security/2011/11/05/3

hidepid=1/2 doesn't break monitoring userspace tools.  ps, top, pgrep, and
conky gracefully handle EPERM/ENOENT and behave as if the current user is
the only user running processes.  pstree shows the process subtree which
contains "pstree" process.

Note: the patch doesn't deal with setuid/setgid issues of keeping preopened
descriptors of procfs files (like https://lkml.org/lkml/2011/2/7/368).
We rely on that the leaked information like the scheduling counters of setuid
apps doesn't threaten anybody's privacy - only the user started the setuid
program may read the counters.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 fs/proc/base.c                |   64 ++++++++++++++++++++++++++++++++++++++++-
 fs/proc/inode.c               |    8 +++++
 fs/proc/root.c                |   19 +++++++++++-
 include/linux/pid_namespace.h |    2 +
 4 files changed, 91 insertions(+), 2 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 2db1bd3..8caf5cb 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -627,6 +627,45 @@ int proc_setattr(struct dentry *dentry, struct iattr *attr)
 	return 0;
 }
 
+/*
+ * May current process learn task's sched/cmdline info (for hide_pid_min=1)
+ * or euid/egid (for hide_pid_min=2)?
+ */
+static bool has_pid_permissions(struct pid_namespace *pid,
+				 struct task_struct *task,
+				 int hide_pid_min)
+{
+	if (pid->hide_pid < hide_pid_min)
+		return true;
+	if (in_group_p(pid->pid_gid))
+		return true;
+	return ptrace_may_access(task, PTRACE_MODE_READ);
+}
+
+
+static int proc_pid_permission(struct inode *inode, int mask)
+{
+	struct pid_namespace *pid = inode->i_sb->s_fs_info;
+	struct task_struct *task = get_proc_task(inode);
+
+	if (!has_pid_permissions(pid, task, 1)) {
+		if (pid->hide_pid == 2) {
+			/*
+			 * Let's make getdents(), stat(), and open()
+			 * consistent with each other.  If a process
+			 * may not stat() a file, it shouldn't be seen
+			 * in procfs at all.
+			 */
+			return -ENOENT;
+		}
+
+		return -EPERM;
+	}
+	return generic_permission(inode, mask);
+}
+
+
+
 static const struct inode_operations proc_def_inode_operations = {
 	.setattr	= proc_setattr,
 };
@@ -1757,6 +1796,7 @@ int pid_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
 	struct inode *inode = dentry->d_inode;
 	struct task_struct *task;
 	const struct cred *cred;
+	struct pid_namespace *pid = dentry->d_sb->s_fs_info;
 
 	generic_fillattr(inode, stat);
 
@@ -1765,6 +1805,14 @@ int pid_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
 	stat->gid = 0;
 	task = pid_task(proc_pid(inode), PIDTYPE_PID);
 	if (task) {
+		if (!has_pid_permissions(pid, task, 2)) {
+			rcu_read_unlock();
+			/*
+			 * This doesn't prevent learning whether PID exists,
+			 * it only makes getattr() consistent with readdir().
+			 */
+			return -ENOENT;
+		}
 		if ((inode->i_mode == (S_IFDIR|S_IRUGO|S_IXUGO)) ||
 		    task_dumpable(task)) {
 			cred = __task_cred(task);
@@ -2935,6 +2983,7 @@ static const struct inode_operations proc_tgid_base_inode_operations = {
 	.lookup		= proc_tgid_base_lookup,
 	.getattr	= pid_getattr,
 	.setattr	= proc_setattr,
+	.permission	= proc_pid_permission,
 };
 
 static void proc_flush_task_mnt(struct vfsmount *mnt, pid_t pid, pid_t tgid)
@@ -3138,6 +3187,12 @@ static int proc_pid_fill_cache(struct file *filp, void *dirent, filldir_t filldi
 				proc_pid_instantiate, iter.task, NULL);
 }
 
+static int fake_filldir(void *buf, const char *name, int namelen,
+			loff_t offset, u64 ino, unsigned d_type)
+{
+	return 0;
+}
+
 /* for the /proc/ directory itself, after non-process stuff has been done */
 int proc_pid_readdir(struct file * filp, void * dirent, filldir_t filldir)
 {
@@ -3145,6 +3200,7 @@ int proc_pid_readdir(struct file * filp, void * dirent, filldir_t filldir)
 	struct task_struct *reaper;
 	struct tgid_iter iter;
 	struct pid_namespace *ns;
+	filldir_t __filldir;
 
 	if (filp->f_pos >= PID_MAX_LIMIT + TGID_OFFSET)
 		goto out_no_task;
@@ -3166,8 +3222,13 @@ int proc_pid_readdir(struct file * filp, void * dirent, filldir_t filldir)
 	for (iter = next_tgid(ns, iter);
 	     iter.task;
 	     iter.tgid += 1, iter = next_tgid(ns, iter)) {
+		if (has_pid_permissions(ns, iter.task, 2))
+			__filldir = filldir;
+		else
+			__filldir = fake_filldir;
+
 		filp->f_pos = iter.tgid + TGID_OFFSET;
-		if (proc_pid_fill_cache(filp, dirent, filldir, iter) < 0) {
+		if (proc_pid_fill_cache(filp, dirent, __filldir, iter) < 0) {
 			put_task_struct(iter.task);
 			goto out;
 		}
@@ -3502,6 +3563,7 @@ static const struct inode_operations proc_task_inode_operations = {
 	.lookup		= proc_task_lookup,
 	.getattr	= proc_task_getattr,
 	.setattr	= proc_setattr,
+	.permission	= proc_pid_permission,
 };
 
 static const struct file_operations proc_task_operations = {
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 9b9f92a..6b5d927 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -107,6 +107,14 @@ void __init proc_init_inodecache(void)
 
 static int proc_show_options(struct seq_file *seq, struct vfsmount *vfs)
 {
+	struct super_block *sb = vfs->mnt_sb;
+	struct pid_namespace *pid = sb->s_fs_info;
+
+	if (pid->pid_gid)
+		seq_printf(seq, ",gid=%lu", (unsigned long)pid->pid_gid);
+	if (pid->hide_pid != 0)
+		seq_printf(seq, ",hidepid=%u", pid->hide_pid);
+
 	return 0;
 }
 
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 165a0d1..73af7b2 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -38,10 +38,12 @@ static int proc_set_super(struct super_block *sb, void *data)
 }
 
 enum {
-	Opt_err,
+	Opt_gid, Opt_hidepid, Opt_err,
 };
 
 static const match_table_t tokens = {
+	{Opt_hidepid, "hidepid=%u"},
+	{Opt_gid, "gid=%u"},
 	{Opt_err, NULL},
 };
 
@@ -49,6 +51,7 @@ static int proc_parse_options(char *options, struct pid_namespace *pid)
 {
 	char *p;
 	substring_t args[MAX_OPT_ARGS];
+	int option;
 
 	pr_debug("proc: options = %s\n", options);
 
@@ -63,6 +66,20 @@ static int proc_parse_options(char *options, struct pid_namespace *pid)
 		args[0].to = args[0].from = 0;
 		token = match_token(p, tokens, args);
 		switch (token) {
+		case Opt_gid:
+			if (match_int(&args[0], &option))
+				return 0;
+			pid->pid_gid = option;
+			break;
+		case Opt_hidepid:
+			if (match_int(&args[0], &option))
+				return 0;
+			if (option < 0 || option > 2) {
+				pr_err("proc: hidepid value must be between 0 and 2.\n");
+				return 0;
+			}
+			pid->hide_pid = option;
+			break;
 		default:
 			pr_err("proc: unrecognized mount option \"%s\" "
 			       "or missing value\n", p);
diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index 38d1032..e7cf666 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -30,6 +30,8 @@ struct pid_namespace {
 #ifdef CONFIG_BSD_PROCESS_ACCT
 	struct bsd_acct_struct *bacct;
 #endif
+	gid_t pid_gid;
+	int hide_pid;
 };
 
 extern struct pid_namespace init_pid_ns;
-- 
1.7.0.4
