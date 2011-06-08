Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Wed, 8 Jun 2011 21:23:08 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110608172307.GA3380@albatros>
References: <20110604054758.GA4063@albatros>
 <20110604132054.GC2583@openwall.com>
 <20110604200948.GA5850@shinshilla>
 <20110604205955.GA5972@openwall.com>
 <20110605182430.GA5789@albatros>
 <20110605192641.GA9240@openwall.com>
 <20110605194746.GA6484@albatros>
 <20110605201025.GA9541@openwall.com>
 <20110606180806.GA3986@albatros>
 <20110606183358.GA14711@openwall.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
In-Reply-To: <20110606183358.GA14711@openwall.com>
Subject: [kernel-hardening] [RFC v2] procfs mount options
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

In this version I've completely discarded grsecurity way to chech
permissions.  Implementing customized inode_operations->permission() is
MUCH simplier.  The problem with old way, changing gid, is not
backward-compatible - procfs files have tricky owners depending on their
permissions, and some programs depend on perms AND uid/gid.  So, in this
version I don't actually change gid, but match with this gid in runtime
(proc_pid_permission()).

Additionally it solves the problem with suid binaries, but only for
operations that use permissions checks like readdir(), open(),
but not read(), write(), etc.  *stat*() are denied too.  The generic
problem is not solved, though.

This patch is as much compatible with the current behaviour as possible.
It leaves permissions and changes runtime behaviour only.  Nothing
should be broken.


The only problem with the patch is using net namespaces.  If
CONFIG_NET_NS=3Dn then fake_net is created, but it is blank.  So, in this
case /proc/PID/net doesn't contain common files and netstat and other
programs might spit with warnings.


I think this version of the patch is ready for LKML review.


diff --git a/fs/proc/base.c b/fs/proc/base.c
index 9d096e8..78fbcdc 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -568,8 +568,38 @@ static int proc_setattr(struct dentry *dentry, struct =
iattr *attr)
 	return 0;
 }
=20
+static int proc_pid_permission(struct inode *inode, int mask, unsigned int=
 flags)
+{
+	struct pid_namespace *pid =3D inode->i_sb->s_fs_info;
+	struct task_struct *task =3D get_proc_task(inode);
+
+	if (pid->hide_pid &&
+	    !ptrace_may_access(task, PTRACE_MODE_READ) &&
+	    !in_group_p(pid->pid_gid)) {
+		if (pid->hide_pid =3D=3D 2)
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
+
 static const struct inode_operations proc_def_inode_operations =3D {
 	.setattr	=3D proc_setattr,
+	.permission	=3D proc_pid_permission,
 };
=20
 static int mounts_open_common(struct inode *inode, struct file *file,
@@ -1662,6 +1692,7 @@ static const struct inode_operations proc_pid_link_in=
ode_operations =3D {
 	.readlink	=3D proc_pid_readlink,
 	.follow_link	=3D proc_pid_follow_link,
 	.setattr	=3D proc_setattr,
+	.permission	=3D proc_pid_permission,
 };
=20
=20
@@ -1730,6 +1761,7 @@ static int pid_getattr(struct vfsmount *mnt, struct d=
entry *dentry, struct kstat
 	struct inode *inode =3D dentry->d_inode;
 	struct task_struct *task;
 	const struct cred *cred;
+	struct pid_namespace *pid =3D dentry->d_sb->s_fs_info;
=20
 	generic_fillattr(inode, stat);
=20
@@ -1738,6 +1770,14 @@ static int pid_getattr(struct vfsmount *mnt, struct =
dentry *dentry, struct kstat
 	stat->gid =3D 0;
 	task =3D pid_task(proc_pid(inode), PIDTYPE_PID);
 	if (task) {
+		if (!proc_pid_may_getattr(pid, task)) {
+			rcu_read_unlock();
+			/*
+			 * This doesn't prevent learning whether PID exists,
+			 * it only makes getattr() consistent with readdir().
+			 */
+			return -ENOENT;
+		}
 		if ((inode->i_mode =3D=3D (S_IFDIR|S_IRUGO|S_IXUGO)) ||
 		    task_dumpable(task)) {
 			cred =3D __task_cred(task);
@@ -2184,6 +2224,7 @@ static const struct inode_operations proc_fd_inode_op=
erations =3D {
 	.lookup		=3D proc_lookupfd,
 	.permission	=3D proc_fd_permission,
 	.setattr	=3D proc_setattr,
+	.permission	=3D proc_pid_permission,
 };
=20
 static struct dentry *proc_fdinfo_instantiate(struct inode *dir,
@@ -2236,6 +2277,7 @@ static const struct file_operations proc_fdinfo_opera=
tions =3D {
 static const struct inode_operations proc_fdinfo_inode_operations =3D {
 	.lookup		=3D proc_lookupfdinfo,
 	.setattr	=3D proc_setattr,
+	.permission	=3D proc_pid_permission,
 };
=20
=20
@@ -2473,6 +2515,7 @@ static const struct inode_operations proc_attr_dir_in=
ode_operations =3D {
 	.lookup		=3D proc_attr_dir_lookup,
 	.getattr	=3D pid_getattr,
 	.setattr	=3D proc_setattr,
+	.permission	=3D proc_pid_permission,
 };
=20
 #endif
@@ -2890,6 +2933,7 @@ static const struct inode_operations proc_tgid_base_i=
node_operations =3D {
 	.lookup		=3D proc_tgid_base_lookup,
 	.getattr	=3D pid_getattr,
 	.setattr	=3D proc_setattr,
+	.permission	=3D proc_pid_permission,
 };
=20
 static void proc_flush_task_mnt(struct vfsmount *mnt, pid_t pid, pid_t tgi=
d)
@@ -3093,6 +3137,11 @@ static int proc_pid_fill_cache(struct file *filp, vo=
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
@@ -3100,6 +3149,7 @@ int proc_pid_readdir(struct file * filp, void * diren=
t, filldir_t filldir)
 	struct task_struct *reaper =3D get_proc_task(filp->f_path.dentry->d_inode=
);
 	struct tgid_iter iter;
 	struct pid_namespace *ns;
+	filldir_t __filldir;
=20
 	if (!reaper)
 		goto out_no_task;
@@ -3116,8 +3166,13 @@ int proc_pid_readdir(struct file * filp, void * dire=
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
@@ -3223,6 +3278,7 @@ static const struct inode_operations proc_tid_base_in=
ode_operations =3D {
 	.lookup		=3D proc_tid_base_lookup,
 	.getattr	=3D pid_getattr,
 	.setattr	=3D proc_setattr,
+	.permission	=3D proc_pid_permission,
 };
=20
 static struct dentry *proc_task_instantiate(struct inode *dir,
@@ -3448,6 +3504,7 @@ static const struct inode_operations proc_task_inode_=
operations =3D {
 	.lookup		=3D proc_task_lookup,
 	.getattr	=3D proc_task_getattr,
 	.setattr	=3D proc_setattr,
+	.permission	=3D proc_pid_permission,
 };
=20
 static const struct file_operations proc_task_operations =3D {
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 176ce4c..e4452bf 100644
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
@@ -423,6 +443,7 @@ struct inode *proc_get_inode(struct super_block *sb, st=
ruct proc_dir_entry *de)
 	inode =3D iget_locked(sb, de->low_ino);
 	if (!inode)
 		return NULL;
+
 	if (inode->i_state & I_NEW) {
 		inode->i_mtime =3D inode->i_atime =3D inode->i_ctime =3D CURRENT_TIME;
 		PROC_I(inode)->fd =3D 0;
@@ -468,7 +489,7 @@ int proc_fill_super(struct super_block *s)
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
index 9020ac1..3b4e89e 100644
--- a/fs/proc/proc_net.c
+++ b/fs/proc/proc_net.c
@@ -22,10 +22,13 @@
 #include <linux/mount.h>
 #include <linux/nsproxy.h>
 #include <net/net_namespace.h>
+#include <linux/pid_namespace.h>
 #include <linux/seq_file.h>
=20
 #include "internal.h"
=20
+static struct net *fake_net;
+
=20
 static struct net *get_proc_net(const struct inode *inode)
 {
@@ -105,6 +108,13 @@ static struct net *get_proc_task_net(struct inode *dir)
 	struct task_struct *task;
 	struct nsproxy *ns;
 	struct net *net =3D NULL;
+	struct pid_namespace *pid =3D dir->i_sb->s_fs_info;
+
+	if (pid->hide_net &&
+	    (!capable(CAP_NET_ADMIN) && !in_group_p(pid->pid_gid))) {
+		pr_err("return fake_net =3D %p\n", fake_net);
+		return get_net(fake_net);
+	}
=20
 	rcu_read_lock();
 	task =3D pid_task(proc_pid(dir), PIDTYPE_PID);
@@ -236,6 +246,18 @@ static struct pernet_operations __net_initdata proc_ne=
t_ns_ops =3D {
 int __init proc_net_init(void)
 {
 	proc_symlink("net", NULL, "self/net");
-
 	return register_pernet_subsys(&proc_net_ns_ops);
 }
+
+int __init proc_net_initcall(void)
+{
+	fake_net =3D net_create();
+	pr_err("fake_net =3D %p\n", fake_net);
+	if (fake_net =3D=3D NULL)
+		return -ENOMEM;
+
+	get_net(fake_net);
+	return 0;
+}
+
+late_initcall(proc_net_initcall);
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
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 1bf812b..d40c61c 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -113,6 +113,8 @@ static inline struct net *copy_net_ns(unsigned long fla=
gs, struct net *net_ns)
 }
 #endif /* CONFIG_NET */
=20
+extern struct net *net_create(void);
+
=20
 extern struct list_head net_namespace_list;
=20
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 3f86026..51c3442 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -177,6 +177,7 @@ static struct net_generic *net_alloc_generic(void)
 	return ng;
 }
=20
+
 #ifdef CONFIG_NET_NS
 static struct kmem_cache *net_cachep;
 static struct workqueue_struct *netns_wq;
@@ -216,7 +217,7 @@ static void net_free(struct net *net)
 	kmem_cache_free(net_cachep, net);
 }
=20
-static struct net *net_create(void)
+struct net *net_create(void)
 {
 	struct net *net;
 	int rv;
@@ -315,6 +316,64 @@ void __put_net(struct net *net)
 EXPORT_SYMBOL_GPL(__put_net);
=20
 #else
+static struct net *net_alloc(void)
+{
+	struct net *net =3D NULL;
+	struct net_generic *ng;
+
+	ng =3D net_alloc_generic();
+	if (!ng)
+		goto out;
+
+	net =3D kzalloc(sizeof(*net), GFP_KERNEL);
+	if (!net)
+		goto out_free;
+
+	rcu_assign_pointer(net->gen, ng);
+out:
+	return net;
+
+out_free:
+	kfree(ng);
+	goto out;
+}
+
+static void net_free(struct net *net)
+{
+#ifdef NETNS_REFCNT_DEBUG
+	if (unlikely(atomic_read(&net->use_count) !=3D 0)) {
+		printk(KERN_EMERG "network namespace not free! Usage: %d\n",
+			atomic_read(&net->use_count));
+		return;
+	}
+#endif
+	kfree(net->gen);
+	kfree(net);
+}
+
+struct net *net_create(void)
+{
+	struct net *net;
+	int rv;
+
+	net =3D net_alloc();
+	if (!net)
+		return ERR_PTR(-ENOMEM);
+	mutex_lock(&net_mutex);
+	rv =3D setup_net(net);
+	if (rv =3D=3D 0) {
+		rtnl_lock();
+		list_add_tail_rcu(&net->list, &net_namespace_list);
+		rtnl_unlock();
+	}
+	mutex_unlock(&net_mutex);
+	if (rv < 0) {
+		net_free(net);
+		return ERR_PTR(rv);
+	}
+	return net;
+}
+
 struct net *copy_net_ns(unsigned long flags, struct net *old_net)
 {
 	if (flags & CLONE_NEWNET)
--

--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJN76/3AAoJEBoUx9gkVaZcP/YQAMbtq/AIWf0iJa07eV4T0WmC
qi5Z3JDoG93VtkAse9C0iwl5ESE1pWnAy0vBQ/UmwhHksUvULEthlYyqGPrpxrQF
FVwa1/Jrls1OlSJ6w0RiCWEM2xRooO1mpvA8iwuPUtD6pj2oTowLxKkD0nVvk27f
8LHoGsMy5yOy0cLbPfdCawYoDeqlSWP0+YEYV9+72gbnyYo6lM2L/HIdAF0ME07/
RZ/lcJXZ+87GRKPgvsqH/3tNkKAFJvYVlIiWdx8a7B3lmcRGczHQcVvE6MJQOWuI
VcT078IdfhNKh7A4z/aDZslyYOdWgdNkJAosbN8gWqyn2VWy4ipzBnNSRZzrxAVA
cdYBsgQ+CDosmknIbeczjvOg0SKQR4rbZbQNlsae8AaXWRSaNv6UzeHDIbrZaj/8
zgt8ipBFWa8u/ngsg1SfiekrWELCxU7FjmM5HJf0ev761jA2KtRgue/c/Ql1E41Z
HXRqwxsPwczAx6GIfhNPYCGmA/c23hv4z8mH26aXKyTtEBf1qmbzO483ElfKi77j
ogP5J2e/K4SQKEsP88gOCIbuRwRs5e5BFIgfNpnrdRGesVEidOZHP4jp6k0mXPwP
j+hiQTN3Gsb+Qjl2j3A4bZv5VPGo4cWytTLfFNsp9RtthYcRvewHGJQofdlhxFHl
mGMB5vzIfJVkc1Fk9FIe
=nQ48
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
