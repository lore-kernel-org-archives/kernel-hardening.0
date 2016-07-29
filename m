Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 29 Jul 2016 07:44:31 -0400
From: Brad Spengler <spender@grsecurity.net>
Message-ID: <20160729114430.GA22708@grsecurity.net>
References: <1469777680-3687-1-git-send-email-elena.reshetova@intel.com>
 <1469777680-3687-6-git-send-email-elena.reshetova@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <1469777680-3687-6-git-send-email-elena.reshetova@intel.com>
Subject: [kernel-hardening] Re: [RFC] [PATCH 5/5] Hardchroot LSM
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, keescook@chromium.org, jmorris@namei.org, casey.schaufler@intel.com, michael.leibowitz@intel.com, william.c.roberts@intel.com
List-ID: <kernel-hardening.lists.openwall.com>


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

This again is completely unacceptable.

> + * Copyright (c) 2016, Intel Corporation

You know full well several functions in this code are completely
copy+pasted from grsecurity, keeping unnecessary types, same exact
variable names, same exact casts, same exact code structure.  In other
cases you've simply renamed variables.  Last time I had to mention
this, the entirety of my RANDSTRUCT plugin had been copy+pasted by
an Intel employee with Intel's copyright placed alone on the top of it.
Why does Intel have such a problem with plagiarism?

Yes, there are some original changes in here, but this doesn't seem
to have been tested at all -- I see obvious ways of bypassing it,
and some of the checks that have been modified (aka single lines
that weren't copy+pasted) are now wrong and simply won't work at all.
I'm sure Kees will save the day though by repeating the flaw I just
mentioned on IRC.  For the rest, Intel will have to do some actual
original work for a change.

-Brad

> +#include <linux/lsm_hooks.h>
> +#include <linux/sysctl.h>
> +#include <linux/fs_struct.h>
> +#include <linux/nsproxy.h>
> +#include <linux/pid_namespace.h>
> +#include <linux/printk.h>
> +#include "../fs/mount.h"
> +
> +/* describe a hardchroot info for a task */
> +struct hardchroot_info {
> +	struct task_struct *task;
> +	struct dentry *dentry;
> +	bool invalid;
> +	struct list_head node;
> +	struct rcu_head rcu;
> +};
> +
> +static LIST_HEAD(hardchroot_infos);
> +static DEFINE_SPINLOCK(hardchroot_infos_lock);
> +
> +static void hardchroot_info_cleanup(struct work_struct *work);
> +static DECLARE_WORK(hardchroot_info_work, hardchroot_info_cleanup);
> +
> +/**
> + * hardchroot_info_cleanup - remove invalid entries from
> + * the hardchroot info list.
> + */
> +static void hardchroot_info_cleanup(struct work_struct *work)
> +{
> +	struct hardchroot_info *entry;
> +
> +	spin_lock(&hardchroot_infos_lock);
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(entry, &hardchroot_infos, node) {
> +		if (entry->invalid) {
> +			list_del_rcu(&entry->node);
> +			kfree_rcu(entry, rcu);
> +		}
> +	}
> +	rcu_read_unlock();
> +	spin_unlock(&hardchroot_infos_lock);
> +}
> +
> +/**
> + * hardchroot_info_add - add/replace
> + * @task: the task_struct of the process entering chroot
> + * @dentry: the chroot dentry
> + *
> + * Returns 0 if info was added, -ve on error.
> + */
> +static int hardchroot_info_add(struct task_struct *task,
> +				struct dentry *dentry)
> +{
> +	struct hardchroot_info *entry;
> +	struct hardchroot_info *added;
> +
> +	added =3D kmalloc(sizeof(*added), GFP_KERNEL);
> +	if (!added)
> +		return -ENOMEM;
> +
> +	added->task =3D task;
> +	added->dentry =3D dentry;
> +	added->invalid =3D false;
> +
> +	spin_lock(&hardchroot_infos_lock);
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(entry, &hardchroot_infos, node) {
> +		if (entry->invalid)
> +			continue;
> +		if (entry->task =3D=3D task) {
> +			list_replace_rcu(&entry->node, &added->node);
> +			kfree_rcu(entry, rcu);
> +			goto out;
> +		}
> +	}
> +
> +	list_add_rcu(&added->node, &hardchroot_infos);
> +
> +out:
> +	rcu_read_unlock();
> +	spin_unlock(&hardchroot_infos_lock);
> +	return 0;
> +}
> +
> +/**
> + * hardchroot_info_del - remove hardchroot info for a given task
> + * @task: remove any relation where task matches
> + * @dentry: remove any relation where dentry matches
> + */
> +static void hardchroot_info_del(struct task_struct *task,
> +				struct dentry *dentry)
> +{
> +	struct hardchroot_info *entry;
> +	bool marked =3D false;
> +
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(entry, &hardchroot_infos, node) {
> +		if (entry->invalid)
> +			continue;
> +		if (entry->task =3D=3D task ||
> +			(dentry && entry->dentry =3D=3D dentry)) {
> +			entry->invalid =3D true;
> +			marked =3D true;
> +		}
> +	}
> +	rcu_read_unlock();
> +
> +	if (marked)
> +		schedule_work(&hardchroot_info_work);
> +}
> +
> +/**
> + * hardchroot_task_free - remove task from exception list
> + * @task: task being removed
> + */
> +void hardchroot_task_free(struct task_struct *task)
> +{
> +	hardchroot_info_del(task, NULL);
> +}
> +
> +/**
> + * task_is_descendant - walk up a process family tree looking for a match
> + * The function is taken from Yama LSM
> + * @parent: the process to compare against while walking up from child
> + * @child: the process to start from while looking upwards for parent
> + *
> + * Returns 1 if child is a descendant of parent, 0 if not.
> + */
> +static int task_is_descendant(struct task_struct *parent,
> +				  struct task_struct *child)
> +{
> +	int rc =3D 0;
> +	struct task_struct *walker =3D child;
> +
> +	if (!parent || !child)
> +		return 0;
> +
> +	rcu_read_lock();
> +	if (!thread_group_leader(parent))
> +		parent =3D rcu_dereference(parent->group_leader);
> +	while (walker->pid > 0) {
> +		if (!thread_group_leader(walker))
> +			walker =3D rcu_dereference(walker->group_leader);
> +		if (walker =3D=3D parent) {
> +			rc =3D 1;
> +			break;
> +		}
> +		walker =3D rcu_dereference(walker->real_parent);
> +	}
> +	rcu_read_unlock();
> +
> +	return rc;
> +}
> +
> +/**
> + * is_process_chrooted - process is inside chroot
> + * @task: the task_struct of the process to be checked
> + *
> + * Returns 1 if task is inside chroot.
> + */
> +static int is_process_chrooted(struct task_struct *task)
> +{
> +	int rc =3D 0;
> +	struct hardchroot_info *entry;
> +
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(entry, &hardchroot_infos, node) {
> +		if (entry->invalid)
> +			continue;
> +		if ((entry->task =3D=3D task) ||
> +			(task_is_descendant(entry->task, task))) {
> +			rc =3D 1;
> +			pr_info("HCRT: pid %d is already chrooted\n",
> +			task_pid_nr(entry->task));
> +			break;
> +		}
> +	}
> +	rcu_read_unlock();
> +	return rc;
> +}
> +
> +/**
> + * is_same_root - check if two tasks share the same root
> + * @task1: the task_struct of the first task to be checked
> + * @task2: the task_struct of the second task to be checked
> + *
> + * Returns 1 if tasks share the same root.
> + */
> +static int is_same_root(struct task_struct *task1, struct task_struct *t=
ask2)
> +{
> +	int rc =3D 0;
> +	struct hardchroot_info *entry;
> +	struct dentry *dentry1 =3D NULL;
> +	struct dentry *dentry2 =3D NULL;
> +
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(entry, &hardchroot_infos, node) {
> +		if (entry->invalid)
> +			continue;
> +		if (entry->task =3D=3D task1)
> +			dentry1 =3D entry->dentry;
> +		if (entry->task =3D=3D task2)
> +			dentry2 =3D entry->dentry;
> +	}
> +	if (dentry1 && (dentry1 =3D=3D dentry2)) {
> +		rc =3D 1;
> +		pr_info("HCRT: pids %d and %d have the same root\n",
> +				task_pid_nr(task1), task_pid_nr(task2));
> +	}
> +	rcu_read_unlock();
> +	return rc;
> +}
> +
> +/**
> + * is_inside_chroot - check if dentry and mount
> + * are inside the current process fs root
> + * @u_dentry: dentry to be checked
> + * @u_mnt: mnt to be checked
> + *
> + * Returns 1 if dentry and mount are under fs root.
> + */
> +int is_inside_chroot(const struct dentry *u_dentry,
> +			const struct vfsmount *u_mnt)
> +{
> +	struct path path;
> +	struct path currentroot;
> +	int ret =3D 0;
> +
> +	path.dentry =3D (struct dentry *)u_dentry;
> +	path.mnt =3D (struct vfsmount *)u_mnt;
> +	get_fs_root(current->fs, &currentroot);
> +	if (path_is_under(&path, &currentroot))
> +		ret =3D 1;
> +	else
> +		pr_info("HCRT: dentry %lu is outside current task %d root\n",
> +				d_backing_inode(u_dentry)->i_ino,
> +				task_pid_nr(current));
> +	path_put(&currentroot);
> +	return ret;
> +}
> +
> +/**
> + * hardchroot_path_chroot - validate chroot entry
> + * @path contains the path structure.
> + *
> + * Returns 0 if chroot is allowed, -ve on error.
> + */
> +static int hardchroot_path_chroot(const struct path *path)
> +{
> +	int rc =3D 0;
> +	struct task_struct *myself =3D current;
> +
> +	pr_info("HCRT, chroot: inode %lu and pid %d\n",
> +			d_backing_inode(path->dentry)->i_ino,
> +			task_pid_nr(myself));
> +
> +	get_task_struct(myself);
> +	if (is_process_chrooted(myself) &&
> +		!is_inside_chroot(path->dentry, path->mnt)) {
> +		put_task_struct(myself);
> +		pr_info("HCRT, chroot denied: for inode %lu and pid %d\n",
> +				d_backing_inode(path->dentry)->i_ino,
> +				task_pid_nr(myself));
> +		return -EACCES;
> +	}
> +
> +	if (task_pid_nr(myself) > 1 &&
> +		path->dentry !=3D init_task.fs->root.dentry &&
> +		path->dentry !=3D myself->nsproxy->mnt_ns->root->mnt.mnt_root) {
> +		/* task is attempting to chroot, add it to the list */
> +		rc =3D hardchroot_info_add(myself, path->dentry);
> +		pr_info("HCRT, chroot: adding %d to chrooted task list\n",
> +			task_pid_nr(myself));
> +	}
> +
> +	/* set the current working directory of all newly-chrooted
> +	 * processes to the the root directory of the chroot
> +	 */
> +	set_fs_pwd(myself->fs, path);
> +	put_task_struct(myself);
> +
> +	return rc;
> +}
> +
> +/**
> + * hardchroot_task_unshare - check if process is
> + * allowed to unshare its namespaces
> + * @unshare_flags flags
> + * @new_fs contains the new fs_struct if created.
> + * @new_fd contains the new files_struct if created.
> + * @new_creds contains the new cred if created.
> + * @new_nsproxy contains the new nsproxy if created.
> + *
> + * Returns 0 if unshare is allowed, -ve on error.
> + */
> +static int hardchroot_task_unshare(unsigned long unshare_flags,
> +		const struct fs_struct *new_fs,
> +		const struct files_struct *new_fd,
> +		const struct cred *new_cred,
> +		const struct nsproxy *new_nsproxy)
> +{
> +	int rc =3D 0;
> +	struct task_struct *myself =3D current;
> +	const struct nsproxy *tnsproxy =3D new_nsproxy;
> +
> +	pr_info("HCRT, unshare: unshare_flags %lu and pid %d\n",
> +			unshare_flags, task_pid_nr(myself));
> +	if (new_fs)
> +		pr_info("HCRT, unshare: new_fs->root.dentry inode%lu\n",
> +			d_backing_inode(new_fs->root.dentry)->i_ino);
> +
> +	if (!tnsproxy)
> +		tnsproxy =3D myself->nsproxy;
> +
> +	if (new_fs && task_pid_nr(myself) > 1 &&
> +		new_fs->root.dentry !=3D init_task.fs->root.dentry &&
> +		new_fs->root.dentry !=3D tnsproxy->mnt_ns->root->mnt.mnt_root) {
> +		rc =3D hardchroot_info_add(myself, new_fs->root.dentry);
> +		pr_info("HCRT, unshare: adding %d to chrooted task list\n",
> +			task_pid_nr(myself));
> +	}
> +
> +	return rc;
> +}
> +
> +/**
> + * hardchroot_sb_unsharefs - check if process is
> + * allowed to unshare fs_struct
> + * @path contains the path for the new root structure.
> + *
> + * Returns 0 if unsharefs is allowed, -ve on error.
> + */
> +static int hardchroot_sb_unsharefs(const struct path *path)
> +{
> +	int rc =3D 0;
> +	struct task_struct *myself =3D current;
> +
> +	pr_info("HCRT, unsharefs: inode %lu and pid %d\n",
> +			d_backing_inode(path->dentry)->i_ino,
> +			task_pid_nr(myself));
> +
> +	if (task_pid_nr(myself) > 1 &&
> +		path->dentry !=3D init_task.fs->root.dentry &&
> +		path->dentry !=3D myself->nsproxy->mnt_ns->root->mnt.mnt_root) {
> +		rc =3D hardchroot_info_add(myself, path->dentry);
> +		pr_info("HCRT, unsharefs: adding %d to chrooted task list\n",
> +			task_pid_nr(myself));
> +	}
> +
> +	return rc;
> +}
> +
> +/**
> + * hardchroot_path_chmod - validate if chmod is allowed
> + * @mnt contains the vfsmnt structure.
> + * @mode contains DAC's mode
> + *
> + * Returns 0 if allowed, -ve on error.
> + */
> +static int hardchroot_path_chmod(const struct path *path, umode_t mode)
> +{
> +	int rc =3D 0;
> +	struct task_struct *myself =3D current;
> +
> +	pr_info("HCRT, chmod: inode %lu, pid %d\n",
> +			d_backing_inode(path->dentry)->i_ino,
> +			task_pid_nr(myself));
> +
> +	/* allow chmod +s on directories, but not files */
> +	if (!S_ISDIR(path->dentry->d_inode->i_mode) && ((mode & S_ISUID) ||
> +		((mode & (S_ISGID | S_IXGRP)) =3D=3D (S_ISGID | S_IXGRP))) &&
> +		is_process_chrooted(myself)) {
> +		pr_info("HCRT, chmod denied: inode %lu, pid %d\n",
> +				d_backing_inode(path->dentry)->i_ino,
> +				task_pid_nr(myself));
> +		return -EACCES;
> +	}
> +
> +	return rc;
> +
> +}
> +
> +/**
> + * hardchroot_path_fchdir - validate if fchdir is allowed
> + * @path: contains the path structure
> + *
> + * Returns 0 if allowed, -ve on error.
> + */
> +static int hardchroot_path_fchdir(const struct path *path)
> +{
> +	int rc =3D 0;
> +	struct task_struct *myself =3D current;
> +
> +	pr_info("HCRT, fchdir: pid %d, path %lu",
> +			task_pid_nr(myself),
> +			d_backing_inode(path->dentry)->i_ino);
> +
> +	if (!is_process_chrooted(myself))
> +		return rc;
> +	if (!is_inside_chroot(path->dentry, path->mnt)) {
> +		pr_info("HCRT, fchdir denied: pid %d, path %lu",
> +			task_pid_nr(myself),
> +			d_backing_inode(path->dentry)->i_ino);
> +		return -EACCES;
> +	}
> +
> +	return rc;
> +}
> +
> +/**
> + * hardchroot_path_fhandle - validate if converting
> + * handle to path is allowed
> + * @path: contains the path structure
> + *
> + * Returns 0 if allowed, -ve on error.
> + */
> +static int hardchroot_path_fhandle(const struct path *path)
> +{
> +	int rc =3D 0;
> +	struct task_struct *myself =3D current;
> +
> +	pr_info("HCRT, fhandle: pid %d, path %lu",
> +			task_pid_nr(myself),
> +			d_backing_inode(path->dentry)->i_ino);
> +
> +	if (is_process_chrooted(myself)) {
> +		pr_info("HCRT, fhandle denied: pid %d, path %lu",
> +			task_pid_nr(myself),
> +			d_backing_inode(path->dentry)->i_ino);
> +		return -EACCES;
> +	}
> +
> +	return rc;
> +}
> +
> +/**
> + * hardchroot_task_setnice - check if setting nice is allowed
> + * @task contains the task_struct of process.
> + * @nice contains the new nice value.
> + *
> + * Return 0 if allowed, -ve on error.
> + */
> +static int hardchroot_task_setnice(struct task_struct *task, int nice)
> +{
> +	int rc =3D 0;
> +	struct task_struct *myself =3D current;
> +
> +	pr_info("HCRT, setnice: current %d, nice %d, for pid %d and current nic=
e %d\n",
> +			task_pid_nr(myself), nice,
> +			task_pid_nr(task), task_nice(task));
> +
> +	if (is_process_chrooted(myself) && (nice < task_nice(task))) {
> +		pr_info("HCRT, setnice denied: current %d, nice %d, for pid %d and cur=
rent nice %d\n",
> +			task_pid_nr(myself), nice,
> +			task_pid_nr(task), task_nice(task));
> +		return -EACCES;
> +	}
> +	return rc;
> +}
> +
> +/**
> + * hardchroot_path_mknod - check if mknod is allowed
> + * @dir contains the path structure of parent of the new file.
> + * @dentry contains the dentry structure of the new file.
> + * @mode contains the mode of the new file.
> + * @dev contains the undecoded device number. Use new_decode_dev() to get
> + * the decoded device number.
> + *
> + * Return 0 if allowed, -ve on error.
> + */
> +static int hardchroot_path_mknod(const struct path *dir, struct dentry *=
dentry,
> +			umode_t mode, unsigned int dev)
> +{
> +	int rc =3D 0;
> +	struct task_struct *myself =3D current;
> +
> +	pr_info("HCRT, mknod: dir %lu, mode %d pid %d\n",
> +				d_backing_inode(dir->dentry)->i_ino,
> +				mode, task_pid_nr(myself));
> +
> +	if (!S_ISFIFO(mode) && !S_ISREG(mode) && is_process_chrooted(myself)) {
> +		pr_info("HCRT, mknod denied: dir %lu, mode %d pid %d\n",
> +				d_backing_inode(dir->dentry)->i_ino,
> +				mode, task_pid_nr(myself));
> +		return -EACCES;
> +	}
> +	return rc;
> +}
> +
> +/**
> + * hardchroot_sb_mount - check if mount is allowed
> + * @dev_name contains the name for object being mounted.
> + * @path contains the path for mount point object.
> + * @type contains the filesystem type.
> + * @flags contains the mount flags.
> + * @data contains the filesystem-specific data.
> + *
> + * Return 0 if allowed, -ve on error.
> + */
> +static int hardchroot_sb_mount(const char *dev_name, const struct path *=
path,
> +			const char *type, unsigned long flags, void *data)
> +{
> +	int rc =3D 0;
> +	struct task_struct *myself =3D current;
> +
> +	pr_info("HCRT, mount: dev %s, inode %lu, flags %lu pid %d\n",
> +			dev_name, d_backing_inode(path->dentry)->i_ino,
> +			flags, task_pid_nr(myself));
> +
> +	if (is_process_chrooted(myself)) {
> +		pr_info("HCRT, mount denied: dev %s, inode %lu, flags %lu, pid %d\n",
> +				dev_name, d_backing_inode(path->dentry)->i_ino,
> +				flags, task_pid_nr(myself));
> +		return -EACCES;
> +	}
> +	return rc;
> +}
> +
> +/**
> + * hardchroot_sb_pivotroot - check if pivotroot is allowed
> + * @old_path contains the path for the new location of the
> + * current root (put_old).
> + * @new_path contains the path for the new root (new_root).
> + *
> + * Return 0 if allowed, -ve on error.
> + */
> +static int hardchroot_sb_pivotroot(const struct path *old_path,
> +			const struct path *new_path)
> +{
> +	int rc =3D 0;
> +	struct task_struct *myself =3D current;
> +
> +	pr_info("HCRT, pivotroot: old %lu, new %lu, pid %d\n",
> +			d_backing_inode(old_path->dentry)->i_ino,
> +			d_backing_inode(new_path->dentry)->i_ino,
> +			task_pid_nr(myself));
> +
> +	if (is_process_chrooted(myself)) {
> +		pr_info("HCRT, pivotroot denied: old %lu, new %lu, pid %d\n",
> +				d_backing_inode(old_path->dentry)->i_ino,
> +				d_backing_inode(new_path->dentry)->i_ino,
> +				task_pid_nr(myself));
> +		return -EACCES;
> +	}
> +	return rc;
> +}
> +
> +/**
> + * hardchroot_shm_shmat - check if shmat is allowed
> + * @shp contains the shared memory structure to be modified.
> + * @shmaddr contains the address to attach memory region to.
> + * @shmflg contains the operational flags.
> + *
> + * Return 0 if allowed, -ve on error.
> + */
> +int hardchroot_shm_shmat(struct shmid_kernel *shp, char __user *shmaddr,
> +			int shmflg)
> +{
> +	int rc =3D 0;
> +	struct task_struct *p;
> +	struct task_struct *myself =3D current;
> +	u64 st;
> +	time_t ct;
> +
> +	pr_info("HCRT, shmat: shp %d, shmflg %d, pid %d\n",
> +			shp->shm_perm.id, shmflg,
> +			task_pid_nr(myself));
> +
> +	if (likely(!is_process_chrooted(myself)))
> +		return rc;
> +
> +	rcu_read_lock();
> +	read_lock(&tasklist_lock);
> +
> +	p =3D find_task_by_vpid(shp->shm_cprid);
> +	if (p) {
> +		st =3D p->start_time;
> +		ct =3D shp->shm_ctim;
> +		if (time_before_eq((unsigned long)st, (unsigned long)ct)) {
> +			if (is_same_root(myself, p))
> +				goto allow;
> +			else {
> +				read_unlock(&tasklist_lock);
> +				rcu_read_unlock();
> +				pr_info("HCRT, shmat denied: shp %d, shmflg %d, pid %d\n",
> +						shp->shm_perm.id, shmflg,
> +						task_pid_nr(myself));
> +				return -EACCES;
> +			}
> +		}
> +		/* creator exited, pid reuse, fall through to next check */
> +	}
> +	p =3D find_task_by_vpid(shp->shm_lprid);
> +	if (p) {
> +		if (unlikely(!is_same_root(myself, p))) {
> +			read_unlock(&tasklist_lock);
> +			rcu_read_unlock();
> +			pr_info("HCRT, shmat denied: shp %d, shmflg %d, pid %d\n",
> +					shp->shm_perm.id, shmflg,
> +					task_pid_nr(myself));
> +			return -EACCES;
> +		}
> +	}
> +
> +allow:
> +	read_unlock(&tasklist_lock);
> +	rcu_read_unlock();
> +
> +	return rc;
> +
> +
> +}
> +
> +static struct security_hook_list hardchroot_hooks[] =3D {
> +	LSM_HOOK_INIT(path_chroot, hardchroot_path_chroot),
> +	LSM_HOOK_INIT(path_chmod, hardchroot_path_chmod),
> +	LSM_HOOK_INIT(path_mknod, hardchroot_path_mknod),
> +	LSM_HOOK_INIT(path_fchdir, hardchroot_path_fchdir),
> +	LSM_HOOK_INIT(path_fhandle, hardchroot_path_fhandle),
> +	LSM_HOOK_INIT(sb_mount, hardchroot_sb_mount),
> +	LSM_HOOK_INIT(sb_pivotroot, hardchroot_sb_pivotroot),
> +	LSM_HOOK_INIT(sb_unsharefs, hardchroot_sb_unsharefs),
> +	LSM_HOOK_INIT(task_setnice, hardchroot_task_setnice),
> +	LSM_HOOK_INIT(task_free, hardchroot_task_free),
> +	LSM_HOOK_INIT(task_unshare, hardchroot_task_unshare),
> +	LSM_HOOK_INIT(shm_shmat, hardchroot_shm_shmat),
> +};
> +
> +static inline void hardchroot_init_sysctl(void) { }
> +
> +void __init hardchroot_add_hooks(void)
> +{
> +	pr_info("Hardchroot: Getting stronger.\n");
> +	security_add_hooks(hardchroot_hooks, ARRAY_SIZE(hardchroot_hooks));
> +	hardchroot_init_sysctl();
> +}
> diff --git a/security/security.c b/security/security.c
> index 95487b9..ff65f06 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -61,6 +61,7 @@ int __init security_init(void)
>  	capability_add_hooks();
>  	yama_add_hooks();
>  	loadpin_add_hooks();
> +	hardchroot_add_hooks();
> =20
>  	/*
>  	 * Load all the remaining security modules.
> --=20
> 1.9.1

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJXm0GXAAoJEETRwPglJf5JWZUQAIFXMFuZeULU+8BzDpwfN/Jt
pDHeIkvZIK4Tc24D1sqXyoSokgzp5DWy1XhzEw3eHxutK/1NNK/q3GRJd3GZKpF2
HbdOTNxrJWXCDUH3d/W8bi0Hdb1eh1FjHgerVsu1fTYTyoY/1NiVANnb0UtalbzK
3kbS3IJIY5fRK9wkfKCGHFe/K6pVxh7Wh9OFtzutKUzYKnF+w+VdCqZpAM8VzKvd
IdbEZS+3FS02RrQ0kupkDg2szVpFHCT6tqe7YycTgrpjBrhylD5XYc1oHkF7Iq+W
VJr8XlmZ6rUS0/hfzR16wp89Rwvyv0FNLzAIWpxpt2zVhii795LxPZ8o9kOCnhnD
FulyxjSyNvKq4KUHwU7hbC+FpqedO6T1uxQGPCsVOeveACjyJhcuo6gzLO+P3FKe
zqvAvetNlP1EZTF/25H2iv3B6fpAovtcCh/vIQzBgPWa67JW80TjfJhCKn0XoI5q
ghXkO3HWREkKsG0tHsPOpgqRO3A/fchw7Wt+BYVg/rawHyOhMiC8cxhFSYvfyBiK
8ULdU/dnKe/IZ0tRQB0nYUigFzyy44enN5VcWXEC5HwgA1ZOCQokpH+47TLHr5V8
z/ME3wsnShjwCsiQ3LNMqPPhGF6QQ/KMhQXq0lv6np2VZCOGebGxLCDG9hv/Xnmr
o3GQIRxgMpd83rcfEmu6
=yGTn
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
