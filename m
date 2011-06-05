Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sun, 5 Jun 2011 22:24:31 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110605182430.GA5789@albatros>
References: <20110603191153.GB514@openwall.com>
 <20110604054758.GA4063@albatros>
 <20110604132054.GC2583@openwall.com>
 <20110604200948.GA5850@shinshilla>
 <20110604205955.GA5972@openwall.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
In-Reply-To: <20110604205955.GA5972@openwall.com>
Subject: [kernel-hardening] [RFC v1] procfs mount options
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This patch introduces support of procfs mount options and adds mount
options to restrict access to /proc/PID/ directories and /proc/PID/net/
contents.  The default backward-compatible behaviour is left untouched.

The first mount option is called "hidepid" and its value defines how much
info about processes we want to be available for non-owners:

hidepid=3D0 (default) means the current behaviour - anybody may read all
/proc/PID/* files.

hidepid=3D1 means all files not running as current user and group are
unaccessible (directories' permissions are 0550).  Sensitive files like
cmdline, io, sched*, status, wchan are now protected against other
users.

hidepid=3D2 means hidepid=3D1 plus all /proc/PID/ will be invisible to
other users.  It doesn't mean that it hides a fact whether a process
exists (it can be learned by other means, e.g. by sending signals), but
it hides process' uid and gid.  It greatly compicates intruder's task of
gathering info about running processes, whether some daemon runs with
elevated privileges, whether other user runs some sensitive program,
whether other users run any program at all, etc.

hidenet means /proc/PID/net will be accessible to processes with
CAP_NET_ADMIN capability or to members of a special group.

gid=3DXXX defines a group that will be able to gather all processes' info
and network connections info.

TODO/thoughs:
  - /proc/pid/net/ currently doesn't show ANYTHING, even "." and "..".
    This is confusing :)
  - copy options description to Documenataion/filesystems/procfs.txt
  - need to alter "(inode->i_mode =3D=3D (S_IFDIR|S_IRUGO|S_IXUGO))" checks
    to honour non-pid directories.
  - what if one keeps open /proc/PID/ while executing set*id/capable
    binary?
  - maybe hidenet belongs to net namespace, not pid?  However, it is
    seen through procfs, which is per-pid_namespace.

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 9d096e8..dd28832 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1688,6 +1688,7 @@ static struct inode *proc_pid_make_inode(struct super=
_block * sb, struct task_st
 	struct inode * inode;
 	struct proc_inode *ei;
 	const struct cred *cred;
+	struct nsproxy *ns;
=20
 	/* We need a new inode */
=20
@@ -1712,7 +1713,12 @@ static struct inode *proc_pid_make_inode(struct supe=
r_block * sb, struct task_st
 		rcu_read_lock();
 		cred =3D __task_cred(task);
 		inode->i_uid =3D cred->euid;
-		inode->i_gid =3D cred->egid;
+		ns =3D task_nsproxy(task);
+		if (ns && ns->pid_ns->hide_pid) {
+			inode->i_gid =3D ns->pid_ns->pid_gid;
+		} else {
+			inode->i_gid =3D cred->egid;
+		}
 		rcu_read_unlock();
 	}
 	security_task_to_inode(task, inode);
@@ -1725,11 +1731,22 @@ out_unlock:
 	return NULL;
 }
=20
+/* TODO: ugly, need something more generic */
+static bool proc_pid_may_getattr(struct pid_namespace* pid, struct task_st=
ruct *task)
+{
+	if (pid->hide_pid < 2)
+		return true;
+	if (ptrace_may_access(task, PTRACE_MODE_READ))
+		return true;
+	return in_group_p(pid->pid_gid);
+}
+
 static int pid_getattr(struct vfsmount *mnt, struct dentry *dentry, struct=
 kstat *stat)
 {
 	struct inode *inode =3D dentry->d_inode;
 	struct task_struct *task;
 	const struct cred *cred;
+	struct pid_namespace *pid =3D dentry->d_sb->s_fs_info;
=20
 	generic_fillattr(inode, stat);
=20
@@ -1738,11 +1755,17 @@ static int pid_getattr(struct vfsmount *mnt, struct=
 dentry *dentry, struct kstat
 	stat->gid =3D 0;
 	task =3D pid_task(proc_pid(inode), PIDTYPE_PID);
 	if (task) {
-		if ((inode->i_mode =3D=3D (S_IFDIR|S_IRUGO|S_IXUGO)) ||
-		    task_dumpable(task)) {
+		/* TODO: if ((inode->i_mode =3D=3D (S_IFDIR|S_IRUGO|S_IXUGO)) */
+		if ((((inode->i_mode & S_IFDIR) =3D=3D S_IFDIR) ||
+		    task_dumpable(task))) {
 			cred =3D __task_cred(task);
-			stat->uid =3D cred->euid;
-			stat->gid =3D cred->egid;
+	 		if (proc_pid_may_getattr(pid, task)) {
+				stat->uid =3D cred->euid;
+				if (pid->hide_pid)
+					stat->gid =3D pid->pid_gid;
+				else
+					stat->gid =3D cred->egid;
+			}
 		}
 	}
 	rcu_read_unlock();
@@ -1771,6 +1794,7 @@ static int pid_revalidate(struct dentry *dentry, stru=
ct nameidata *nd)
 	struct inode *inode;
 	struct task_struct *task;
 	const struct cred *cred;
+	struct pid_namespace *pid =3D dentry->d_sb->s_fs_info;
=20
 	if (nd && nd->flags & LOOKUP_RCU)
 		return -ECHILD;
@@ -1779,12 +1803,16 @@ static int pid_revalidate(struct dentry *dentry, st=
ruct nameidata *nd)
 	task =3D get_proc_task(inode);
=20
 	if (task) {
-		if ((inode->i_mode =3D=3D (S_IFDIR|S_IRUGO|S_IXUGO)) ||
+		/* TODO: if ((inode->i_mode =3D=3D (S_IFDIR|S_IRUGO|S_IXUGO)) */
+		if (((inode->i_mode & S_IFDIR) =3D=3D S_IFDIR) ||
 		    task_dumpable(task)) {
 			rcu_read_lock();
 			cred =3D __task_cred(task);
 			inode->i_uid =3D cred->euid;
-			inode->i_gid =3D cred->egid;
+			if (pid->hide_pid)
+				inode->i_gid =3D pid->pid_gid;
+			else
+				inode->i_gid =3D cred->egid;
 			rcu_read_unlock();
 		} else {
 			inode->i_uid =3D 0;
@@ -2986,12 +3014,21 @@ static struct dentry *proc_pid_instantiate(struct i=
node *dir,
 {
 	struct dentry *error =3D ERR_PTR(-ENOENT);
 	struct inode *inode;
+	struct nsproxy *ns;
+	unsigned int mode;
=20
 	inode =3D proc_pid_make_inode(dir->i_sb, task);
 	if (!inode)
 		goto out;
=20
-	inode->i_mode =3D S_IFDIR|S_IRUGO|S_IXUGO;
+	rcu_read_lock();
+	ns =3D task_nsproxy(task);
+	if (ns && ns->pid_ns->hide_pid)
+		mode =3D 07;
+	else
+		mode =3D 0;
+	rcu_read_unlock();
+	inode->i_mode =3D S_IFDIR | ((S_IRUGO|S_IXUGO) & ~mode);
 	inode->i_op =3D &proc_tgid_base_inode_operations;
 	inode->i_fop =3D &proc_tgid_base_operations;
 	inode->i_flags|=3DS_IMMUTABLE;
@@ -3093,6 +3130,11 @@ static int proc_pid_fill_cache(struct file *filp, vo=
id *dirent, filldir_t filldi
 				proc_pid_instantiate, iter.task, NULL);
 }
=20
+static int fake_filldir(void *buf, const char *name, int namelen, loff_t o=
ffset, u64 ino, unsigned d_type)
+{
+	return 0;
+}
+
 /* for the /proc/ directory itself, after non-process stuff has been done =
*/
 int proc_pid_readdir(struct file * filp, void * dirent, filldir_t filldir)
 {
@@ -3100,6 +3142,7 @@ int proc_pid_readdir(struct file * filp, void * diren=
t, filldir_t filldir)
 	struct task_struct *reaper =3D get_proc_task(filp->f_path.dentry->d_inode=
);
 	struct tgid_iter iter;
 	struct pid_namespace *ns;
+	filldir_t __filldir;
=20
 	if (!reaper)
 		goto out_no_task;
@@ -3116,8 +3159,13 @@ int proc_pid_readdir(struct file * filp, void * dire=
nt, filldir_t filldir)
 	for (iter =3D next_tgid(ns, iter);
 	     iter.task;
 	     iter.tgid +=3D 1, iter =3D next_tgid(ns, iter)) {
+		if (proc_pid_may_getattr(ns, iter.task))
+			__filldir =3D filldir;
+		else
+			__filldir =3D fake_filldir;
+
 		filp->f_pos =3D iter.tgid + TGID_OFFSET;
-		if (proc_pid_fill_cache(filp, dirent, filldir, iter) < 0) {
+		if (proc_pid_fill_cache(filp, dirent, __filldir, iter) < 0) {
 			put_task_struct(iter.task);
 			goto out;
 		}
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 176ce4c..698fb41 100644
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
=20
 #include <asm/system.h>
 #include <asm/uaccess.h>
@@ -93,12 +96,29 @@ void __init proc_init_inodecache(void)
 					     init_once);
 }
=20
+static int proc_show_options(struct seq_file *seq, struct vfsmount *vfs)
+{
+	struct super_block *sb =3D vfs->mnt_sb;
+	struct pid_namespace *pid =3D sb->s_fs_info;
+
+	if (pid->pid_gid)
+		seq_printf(seq, ",gid=3D%lu", (unsigned long)pid->pid_gid);
+	if (pid->hide_pid !=3D 0)
+		seq_printf(seq, ",hidepid=3D%u", pid->hide_pid);
+	if (pid->hide_net)
+		seq_printf(seq, ",hidenet");
+
+	return 0;
+}
+
 static const struct super_operations proc_sops =3D {
 	.alloc_inode	=3D proc_alloc_inode,
 	.destroy_inode	=3D proc_destroy_inode,
 	.drop_inode	=3D generic_delete_inode,
 	.evict_inode	=3D proc_evict_inode,
 	.statfs		=3D simple_statfs,
+	.remount_fs	=3D proc_remount,
+	.show_options	=3D proc_show_options,
 };
=20
 static void __pde_users_dec(struct proc_dir_entry *pde)
@@ -468,7 +488,7 @@ int proc_fill_super(struct super_block *s)
 	s->s_magic =3D PROC_SUPER_MAGIC;
 	s->s_op =3D &proc_sops;
 	s->s_time_gran =3D 1;
-=09
+
 	pde_get(&proc_root);
 	root_inode =3D proc_get_inode(s, &proc_root);
 	if (!root_inode)
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 9ad561d..1cacb6a 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -110,6 +110,7 @@ void pde_put(struct proc_dir_entry *pde);
 extern struct vfsmount *proc_mnt;
 int proc_fill_super(struct super_block *);
 struct inode *proc_get_inode(struct super_block *, struct proc_dir_entry *=
);
+int proc_remount(struct super_block *sb, int *flags, char *data);
=20
 /*
  * These are generic /proc routines that use the internal
diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
index 9020ac1..7dc0b96 100644
--- a/fs/proc/proc_net.c
+++ b/fs/proc/proc_net.c
@@ -22,6 +22,7 @@
 #include <linux/mount.h>
 #include <linux/nsproxy.h>
 #include <net/net_namespace.h>
+#include <linux/pid_namespace.h>
 #include <linux/seq_file.h>
=20
 #include "internal.h"
@@ -105,6 +106,11 @@ static struct net *get_proc_task_net(struct inode *dir)
 	struct task_struct *task;
 	struct nsproxy *ns;
 	struct net *net =3D NULL;
+	struct pid_namespace *pid =3D dir->i_sb->s_fs_info;
+
+	if (pid->hide_net &&
+	    (!capable(CAP_NET_ADMIN) && !in_group_p(pid->pid_gid)))
+		return net;
=20
 	rcu_read_lock();
 	task =3D pid_task(proc_pid(dir), PIDTYPE_PID);
@@ -162,7 +168,7 @@ static int proc_tgid_net_readdir(struct file *filp, voi=
d *dirent,
 	int ret;
 	struct net *net;
=20
-	ret =3D -EINVAL;
+	ret =3D -ENOENT;
 	net =3D get_proc_task_net(filp->f_path.dentry->d_inode);
 	if (net !=3D NULL) {
 		ret =3D proc_readdir_de(net->proc_net, filp, dirent, filldir);
diff --git a/fs/proc/root.c b/fs/proc/root.c
index ef9fa8e..269067c 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -18,6 +18,7 @@
 #include <linux/bitops.h>
 #include <linux/mount.h>
 #include <linux/pid_namespace.h>
+#include <linux/parser.h>
=20
 #include "internal.h"
=20
@@ -35,6 +36,75 @@ static int proc_set_super(struct super_block *sb, void *=
data)
 	return set_anon_super(sb, NULL);
 }
=20
+enum {
+	Opt_gid, Opt_hidepid, Opt_hidenet, Opt_nohidenet, Opt_err,
+};
+
+static const match_table_t tokens =3D {
+	{Opt_hidepid, "hidepid=3D%u"},
+	{Opt_gid, "gid=3D%u"},
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
+	pr_debug("proc: options =3D %s\n", options);
+
+	if (!options)
+		return 1;
+
+	while ((p =3D strsep(&options, ",")) !=3D NULL) {
+		int token;
+		if (!*p)
+			continue;
+
+		args[0].to =3D args[0].from =3D 0;
+		token =3D match_token(p, tokens, args);
+		switch (token) {
+		case Opt_gid:
+			if (match_int(&args[0], &option))
+				return 0;
+			pid->pid_gid =3D option;
+			break;
+		case Opt_hidepid:
+			if (match_int(&args[0], &option))
+				return 0;
+			if (option < 0 || option > 2) {
+				pr_err("proc: hidepid value must be between 0 and 2.\n");
+				return 0;
+			}
+			pid->hide_pid =3D option;
+			break;
+		case Opt_hidenet:
+			pid->hide_net =3D true;
+			break;
+		case Opt_nohidenet:
+			pid->hide_net =3D false;
+			break;
+		default:
+			pr_err("proc: unrecognized mount option \"%s\" "
+			       "or missing value", p);
+			return 0;
+		}
+	}
+
+	pr_debug("proc: gid =3D %u, hidepid =3D %o, hidenet =3D %d\n", pid->pid_g=
id, pid->hide_pid, (int)pid->hide_net);
+
+	return 1;
+}
+
+int proc_remount(struct super_block *sb, int *flags, char *data)
+{
+	struct pid_namespace *pid =3D sb->s_fs_info;
+	return !proc_parse_options(data, pid);
+}
+
 static struct dentry *proc_mount(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data)
 {
@@ -42,6 +112,7 @@ static struct dentry *proc_mount(struct file_system_type=
 *fs_type,
 	struct super_block *sb;
 	struct pid_namespace *ns;
 	struct proc_inode *ei;
+	char *options;
=20
 	if (proc_mnt) {
 		/* Seed the root directory with a pid so it doesn't need
@@ -54,10 +125,13 @@ static struct dentry *proc_mount(struct file_system_ty=
pe *fs_type,
 			ei->pid =3D find_get_pid(1);
 	}
=20
-	if (flags & MS_KERNMOUNT)
+	if (flags & MS_KERNMOUNT) {
 		ns =3D (struct pid_namespace *)data;
-	else
+		options =3D NULL;
+	} else {
 		ns =3D current->nsproxy->pid_ns;
+		options =3D data;
+	}
=20
 	sb =3D sget(fs_type, proc_test_super, proc_set_super, ns);
 	if (IS_ERR(sb))
@@ -65,6 +139,10 @@ static struct dentry *proc_mount(struct file_system_typ=
e *fs_type,
=20
 	if (!sb->s_root) {
 		sb->s_flags =3D flags;
+		if (!proc_parse_options(options, ns)) {
+			deactivate_locked_super(sb);
+			return ERR_PTR(-EINVAL);
+		}
 		err =3D proc_fill_super(sb);
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
=20
 extern struct pid_namespace init_pid_ns;
--

--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJN68nZAAoJEBoUx9gkVaZc8gsQALNTqIqRaT5FMiysx4/HcV76
hXBwodXGwrEs/bqI4NRSy5LAs9OrAkm5j0NALxgH/kJdWPGhyHWclC11MTiV/3Sl
mNmrBbV49iAu2I2EDh0+hgsT/sdImxWQoyIMz0EkK/ikQnh+RgUGxwdHZ/KZwWDD
cikBn8URJ809SOtNQ2toMha8CTBI9RKXX87rmYztCHdjDYMM87z4Gkof3ExCh5gl
ATDULW96OJPo+fXcVvMPBG5K/VocWjB8a9IkLR0AWK4IodMXCHrkpbJ/PHZLfrvT
VTPK1ylq785al3/69enzuspToSuOXDfUpXN1X8hLoB3PVGvb4DLroDRiZf5SCNmn
rPundDVqhv9rzQiCCXgbLmICMcOFAkUtQ+1pp1rjpkVZa72ziCy4Qd/Qfr0KGkiA
pmE9K2gWkxbBPPdj7alR/NOJDdQFYnBZwAFHZ0hBHoTg+/j550qmcCmYNI/lywJ1
ts1pJwEp9RlQAe72s4dZ7PjxrD45gErGo2CmyIEiEoIbvKuUtcTEbZjclVOoOiJX
KRsQbWg2KTR6RcGAHHPOQXRjJ5aqSqTM148CW8qnx2qyovVyKJXm/hRERoQr9tXb
1H3YCQAWHGbOA+oKurTRRsY+OwVgtdKYywB3NZWjQRnPVvWU6OlgOXxCyZIM2LwU
GVp7qdjvIpH8fBj7tVYd
=Gidf
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
