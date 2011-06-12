Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
From: Vasiliy Kulikov <segoon@openwall.com>
Date: Sun, 12 Jun 2011 18:45:00 +0400
Message-Id: <1307889901-6226-1-git-send-email-segoon@openwall.com>
Subject: [kernel-hardening] [RFC v2 02/04] procfs: add hidepid modes as mount options
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, "David S. Miller" <davem@davemloft.net>, David Rientjes <rientjes@google.com>, Al Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@kernel.dk>, Miklos Szeredi <mszeredi@suse.cz>, Arnd Bergmann <arnd@arndb.de>, Alexey Dobriyan <adobriyan@gmail.com>, Frederic Weisbecker <fweisbec@gmail.com>, WANG Cong <xiyou.wangcong@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

This patch introduces support of procfs mount options and adds mount
options to restrict access to /proc/PID/ directories.  The default
backward-compatible 'relaxed' behaviour is left untouched.

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

Similar features are implemented for old kernels in -ow patches (for
Linux 2.2 and 2.4) and for Linux 2.6 in -grsecurity (but both of them
are implemented as a configure options, not cofigurable in runtime).

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 fs/proc/base.c                |   62 ++++++++++++++++++++++++++++++-
 fs/proc/inode.c               |   20 ++++++++++
 fs/proc/internal.h            |    1 +
 fs/proc/root.c                |   83 ++++++++++++++++++++++++++++++++++++++++-
 include/linux/pid_namespace.h |    3 +
 5 files changed, 166 insertions(+), 3 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 9d096e8..ff2feee 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -568,8 +568,40 @@ static int proc_setattr(struct dentry *dentry, struct iattr *attr)
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
@@ -1662,6 +1694,7 @@ static const struct inode_operations proc_pid_link_inode_operations = {
 	.readlink	= proc_pid_readlink,
 	.follow_link	= proc_pid_follow_link,
 	.setattr	= proc_setattr,
+	.permission	= proc_pid_permission,
 };
 
 
@@ -1730,6 +1763,7 @@ static int pid_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat
 	struct inode *inode = dentry->d_inode;
 	struct task_struct *task;
 	const struct cred *cred;
+	struct pid_namespace *pid = dentry->d_sb->s_fs_info;
 
 	generic_fillattr(inode, stat);
 
@@ -1738,6 +1772,14 @@ static int pid_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat
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
@@ -2184,6 +2226,7 @@ static const struct inode_operations proc_fd_inode_operations = {
 	.lookup		= proc_lookupfd,
 	.permission	= proc_fd_permission,
 	.setattr	= proc_setattr,
+	.permission	= proc_pid_permission,
 };
 
 static struct dentry *proc_fdinfo_instantiate(struct inode *dir,
@@ -2236,6 +2279,7 @@ static const struct file_operations proc_fdinfo_operations = {
 static const struct inode_operations proc_fdinfo_inode_operations = {
 	.lookup		= proc_lookupfdinfo,
 	.setattr	= proc_setattr,
+	.permission	= proc_pid_permission,
 };
 
 
@@ -2473,6 +2517,7 @@ static const struct inode_operations proc_attr_dir_inode_operations = {
 	.lookup		= proc_attr_dir_lookup,
 	.getattr	= pid_getattr,
 	.setattr	= proc_setattr,
+	.permission	= proc_pid_permission,
 };
 
 #endif
@@ -2890,6 +2935,7 @@ static const struct inode_operations proc_tgid_base_inode_operations = {
 	.lookup		= proc_tgid_base_lookup,
 	.getattr	= pid_getattr,
 	.setattr	= proc_setattr,
+	.permission	= proc_pid_permission,
 };
 
 static void proc_flush_task_mnt(struct vfsmount *mnt, pid_t pid, pid_t tgid)
@@ -3093,6 +3139,12 @@ static int proc_pid_fill_cache(struct file *filp, void *dirent, filldir_t filldi
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
@@ -3100,6 +3152,7 @@ int proc_pid_readdir(struct file * filp, void * dirent, filldir_t filldir)
 	struct task_struct *reaper = get_proc_task(filp->f_path.dentry->d_inode);
 	struct tgid_iter iter;
 	struct pid_namespace *ns;
+	filldir_t __filldir;
 
 	if (!reaper)
 		goto out_no_task;
@@ -3116,8 +3169,13 @@ int proc_pid_readdir(struct file * filp, void * dirent, filldir_t filldir)
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
@@ -3223,6 +3281,7 @@ static const struct inode_operations proc_tid_base_inode_operations = {
 	.lookup		= proc_tid_base_lookup,
 	.getattr	= pid_getattr,
 	.setattr	= proc_setattr,
+	.permission	= proc_pid_permission,
 };
 
 static struct dentry *proc_task_instantiate(struct inode *dir,
@@ -3448,6 +3507,7 @@ static const struct inode_operations proc_task_inode_operations = {
 	.lookup		= proc_task_lookup,
 	.getattr	= proc_task_getattr,
 	.setattr	= proc_setattr,
+	.permission	= proc_pid_permission,
 };
 
 static const struct file_operations proc_task_operations = {
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 176ce4c..895e3b1 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -7,6 +7,7 @@
 #include <linux/time.h>
 #include <linux/proc_fs.h>
 #include <linux/kernel.h>
+#include <linux/pid_namespace.h>
 #include <linux/mm.h>
 #include <linux/string.h>
 #include <linux/stat.h>
@@ -17,7 +18,9 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/sysctl.h>
+#include <linux/seq_file.h>
 #include <linux/slab.h>
+#include <linux/mount.h>
 
 #include <asm/system.h>
 #include <asm/uaccess.h>
@@ -93,12 +96,29 @@ void __init proc_init_inodecache(void)
 					     init_once);
 }
 
+static int proc_show_options(struct seq_file *seq, struct vfsmount *vfs)
+{
+	struct super_block *sb = vfs->mnt_sb;
+	struct pid_namespace *pid = sb->s_fs_info;
+
+	if (pid->pid_gid)
+		seq_printf(seq, ",gid=%lu", (unsigned long)pid->pid_gid);
+	if (pid->hide_pid != 0)
+		seq_printf(seq, ",hidepid=%u", pid->hide_pid);
+	if (pid->hide_net)
+		seq_printf(seq, ",hidenet");
+
+	return 0;
+}
+
 static const struct super_operations proc_sops = {
 	.alloc_inode	= proc_alloc_inode,
 	.destroy_inode	= proc_destroy_inode,
 	.drop_inode	= generic_delete_inode,
 	.evict_inode	= proc_evict_inode,
 	.statfs		= simple_statfs,
+	.remount_fs	= proc_remount,
+	.show_options	= proc_show_options,
 };
 
 static void __pde_users_dec(struct proc_dir_entry *pde)
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 9ad561d..1cacb6a 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -110,6 +110,7 @@ void pde_put(struct proc_dir_entry *pde);
 extern struct vfsmount *proc_mnt;
 int proc_fill_super(struct super_block *);
 struct inode *proc_get_inode(struct super_block *, struct proc_dir_entry *);
+int proc_remount(struct super_block *sb, int *flags, char *data);
 
 /*
  * These are generic /proc routines that use the internal
diff --git a/fs/proc/root.c b/fs/proc/root.c
index ef9fa8e..10cc071 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -18,6 +18,7 @@
 #include <linux/bitops.h>
 #include <linux/mount.h>
 #include <linux/pid_namespace.h>
+#include <linux/parser.h>
 
 #include "internal.h"
 
@@ -35,6 +36,76 @@ static int proc_set_super(struct super_block *sb, void *data)
 	return set_anon_super(sb, NULL);
 }
 
+enum {
+	Opt_gid, Opt_hidepid, Opt_hidenet, Opt_nohidenet, Opt_err,
+};
+
+static const match_table_t tokens = {
+	{Opt_hidepid, "hidepid=%u"},
+	{Opt_gid, "gid=%u"},
+	{Opt_hidenet, "hidenet"},
+	{Opt_nohidenet, "nohidenet"},
+	{Opt_err, NULL},
+};
+
+static int proc_parse_options(char *options, struct pid_namespace *pid)
+{
+	char *p;
+	substring_t args[MAX_OPT_ARGS];
+	int option;
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
+		case Opt_hidenet:
+			pid->hide_net = true;
+			break;
+		case Opt_nohidenet:
+			pid->hide_net = false;
+			break;
+		default:
+			pr_err("proc: unrecognized mount option \"%s\" "
+			       "or missing value", p);
+			return 0;
+		}
+	}
+
+	pr_debug("proc: gid = %u, hidepid = %o, hidenet = %d\n",
+		pid->pid_gid, pid->hide_pid, (int)pid->hide_net);
+
+	return 1;
+}
+
+int proc_remount(struct super_block *sb, int *flags, char *data)
+{
+	struct pid_namespace *pid = sb->s_fs_info;
+	return !proc_parse_options(data, pid);
+}
+
 static struct dentry *proc_mount(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data)
 {
@@ -42,6 +113,7 @@ static struct dentry *proc_mount(struct file_system_type *fs_type,
 	struct super_block *sb;
 	struct pid_namespace *ns;
 	struct proc_inode *ei;
+	char *options;
 
 	if (proc_mnt) {
 		/* Seed the root directory with a pid so it doesn't need
@@ -54,10 +126,13 @@ static struct dentry *proc_mount(struct file_system_type *fs_type,
 			ei->pid = find_get_pid(1);
 	}
 
-	if (flags & MS_KERNMOUNT)
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
@@ -65,6 +140,10 @@ static struct dentry *proc_mount(struct file_system_type *fs_type,
 
 	if (!sb->s_root) {
 		sb->s_flags = flags;
+		if (!proc_parse_options(options, ns)) {
+			deactivate_locked_super(sb);
+			return ERR_PTR(-EINVAL);
+		}
 		err = proc_fill_super(sb);
 		if (err) {
 			deactivate_locked_super(sb);
diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index 38d1032..1c33094 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -30,6 +30,9 @@ struct pid_namespace {
 #ifdef CONFIG_BSD_PROCESS_ACCT
 	struct bsd_acct_struct *bacct;
 #endif
+	gid_t pid_gid;
+	int hide_pid;
+	bool hide_net;
 };
 
 extern struct pid_namespace init_pid_ns;
