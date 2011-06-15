Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
From: Vasiliy Kulikov <segoon@openwall.com>
Date: Wed, 15 Jun 2011 17:58:05 +0400
Message-Id: <1308146286-12840-1-git-send-email-segoon@openwall.com>
Subject: [kernel-hardening] [RFC 2/5 v3] procfs: add hidepid= and gid= mount options
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>, David Rientjes <rientjes@google.com>, Stephen Wilson <wilsons@start.ca>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Daniel Lezcano <daniel.lezcano@free.fr>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge@hallyn.com>
List-ID: <kernel-hardening.lists.openwall.com>

This patch adds support of mount options to restrict access to
/proc/PID/ directories.  The default backward-compatible 'relaxed'
behaviour is left untouched.

The first mount option is called "hidepid" and its value defines how much
info about processes we want to be available for non-owners:

hidepid=0 (default) means the current behaviour - anybody may read all
world-readable /proc/PID/* files.

hidepid=1 means users may not access any /proc/<pid>/ directories, but their
own.  Sensitive files like cmdline, io, sched*, status, wchan are now
protected against other users.  As permission checking done in
proc_pid_permission() and files' permissions are left untouched,
programs expecting specific files' permissions are not confused.

hidepid=2 means hidepid=1 plus all /proc/PID/ will be invisible to
other users.  It doesn't mean that it hides a fact whether a process
exists (it can be learned by other means, e.g. by sending signals), but
it hides process' euid and egid.  It greatly compicates intruder's task of
gathering info about running processes, whether some daemon runs with
elevated privileges, whether other user runs some sensitive program,
whether other users run any program at all, etc.

gid=XXX defines a group that will be able to gather all processes' info.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 fs/proc/base.c                |   62 ++++++++++++++++++++++++++++++++++++++++-
 fs/proc/inode.c               |    8 +++++
 fs/proc/root.c                |   18 +++++++++++-
 include/linux/pid_namespace.h |    2 +
 4 files changed, 88 insertions(+), 2 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 14def99..b1562a3 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -627,8 +627,40 @@ int proc_setattr(struct dentry *dentry, struct iattr *attr)
 	return 0;
 }
 
+static int proc_pid_permission(struct inode *inode, int mask,
+			       unsigned int flags)
+{
+	struct pid_namespace *pid = inode->i_sb->s_fs_info;
+	struct task_struct *task = get_proc_task(inode);
+
+	if (pid->hide_pid &&
+	    !ptrace_may_access(task, PTRACE_MODE_READ) &&
+	    !in_group_p(pid->pid_gid)) {
+		if (pid->hide_pid == 2)
+			return -ENOENT;
+		else
+			return -EPERM;
+	}
+	return generic_permission(inode, mask, flags, NULL);
+}
+
+/*
+ * May current process learn task's euid/egid?
+ */
+static bool proc_pid_may_getattr(struct pid_namespace *pid,
+				 struct task_struct *task)
+{
+	if (pid->hide_pid < 2)
+		return true;
+	if (ptrace_may_access(task, PTRACE_MODE_READ))
+		return true;
+	return in_group_p(pid->pid_gid);
+}
+
+
 static const struct inode_operations proc_def_inode_operations = {
 	.setattr	= proc_setattr,
+	.permission	= proc_pid_permission,
 };
 
 static int mounts_open_common(struct inode *inode, struct file *file,
@@ -1670,6 +1702,7 @@ static const struct inode_operations proc_pid_link_inode_operations = {
 	.readlink	= proc_pid_readlink,
 	.follow_link	= proc_pid_follow_link,
 	.setattr	= proc_setattr,
+	.permission	= proc_pid_permission,
 };
 
 
@@ -1737,6 +1770,7 @@ int pid_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
 	struct inode *inode = dentry->d_inode;
 	struct task_struct *task;
 	const struct cred *cred;
+	struct pid_namespace *pid = dentry->d_sb->s_fs_info;
 
 	generic_fillattr(inode, stat);
 
@@ -1745,6 +1779,14 @@ int pid_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
 	stat->gid = 0;
 	task = pid_task(proc_pid(inode), PIDTYPE_PID);
 	if (task) {
+		if (!proc_pid_may_getattr(pid, task)) {
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
@@ -2188,6 +2230,7 @@ static const struct inode_operations proc_fd_inode_operations = {
 	.lookup		= proc_lookupfd,
 	.permission	= proc_fd_permission,
 	.setattr	= proc_setattr,
+	.permission	= proc_pid_permission,
 };
 
 static struct dentry *proc_fdinfo_instantiate(struct inode *dir,
@@ -2240,6 +2283,7 @@ static const struct file_operations proc_fdinfo_operations = {
 static const struct inode_operations proc_fdinfo_inode_operations = {
 	.lookup		= proc_lookupfdinfo,
 	.setattr	= proc_setattr,
+	.permission	= proc_pid_permission,
 };
 
 
@@ -2477,6 +2521,7 @@ static const struct inode_operations proc_attr_dir_inode_operations = {
 	.lookup		= proc_attr_dir_lookup,
 	.getattr	= pid_getattr,
 	.setattr	= proc_setattr,
+	.permission	= proc_pid_permission,
 };
 
 #endif
@@ -2872,6 +2917,7 @@ static const struct inode_operations proc_tgid_base_inode_operations = {
 	.lookup		= proc_tgid_base_lookup,
 	.getattr	= pid_getattr,
 	.setattr	= proc_setattr,
+	.permission	= proc_pid_permission,
 };
 
 static void proc_flush_task_mnt(struct vfsmount *mnt, pid_t pid, pid_t tgid)
@@ -3075,6 +3121,12 @@ static int proc_pid_fill_cache(struct file *filp, void *dirent, filldir_t filldi
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
@@ -3082,6 +3134,7 @@ int proc_pid_readdir(struct file * filp, void * dirent, filldir_t filldir)
 	struct task_struct *reaper;
 	struct tgid_iter iter;
 	struct pid_namespace *ns;
+	filldir_t __filldir;
 
 	if (filp->f_pos >= PID_MAX_LIMIT + TGID_OFFSET)
 		goto out_no_task;
@@ -3103,8 +3156,13 @@ int proc_pid_readdir(struct file * filp, void * dirent, filldir_t filldir)
 	for (iter = next_tgid(ns, iter);
 	     iter.task;
 	     iter.tgid += 1, iter = next_tgid(ns, iter)) {
+		if (proc_pid_may_getattr(ns, iter.task))
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
@@ -3214,6 +3272,7 @@ static const struct inode_operations proc_tid_base_inode_operations = {
 	.lookup		= proc_tid_base_lookup,
 	.getattr	= pid_getattr,
 	.setattr	= proc_setattr,
+	.permission	= proc_pid_permission,
 };
 
 static struct dentry *proc_task_instantiate(struct inode *dir,
@@ -3439,6 +3498,7 @@ static const struct inode_operations proc_task_inode_operations = {
 	.lookup		= proc_task_lookup,
 	.getattr	= proc_task_getattr,
 	.setattr	= proc_setattr,
+	.permission	= proc_pid_permission,
 };
 
 static const struct file_operations proc_task_operations = {
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index b5f49eb..34ab842 100644
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
index b2571fe..fe6f2c1 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -37,10 +37,12 @@ static int proc_set_super(struct super_block *sb, void *data)
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
 
@@ -63,6 +65,20 @@ static int proc_parse_options(char *options, struct pid_namespace *pid)
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
 			       "or missing value", p);
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
