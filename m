Reply-To: kernel-hardening@lists.openwall.com
From: "Reshetova, Elena" <elena.reshetova@intel.com>
Date: Fri, 29 Jul 2016 12:15:53 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41B6FB4C@IRSMSX102.ger.corp.intel.com>
References: <1469777680-3687-1-git-send-email-elena.reshetova@intel.com>
 <1469777680-3687-6-git-send-email-elena.reshetova@intel.com>
 <20160729114430.GA22708@grsecurity.net>
In-Reply-To: <20160729114430.GA22708@grsecurity.net>
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
	micalg=SHA1; boundary="----=_NextPart_000_0117_01D1E9AC.17F899B0"
MIME-Version: 1.0
Subject: [kernel-hardening] RE: [RFC] [PATCH 5/5] Hardchroot LSM
To: Brad Spengler <spender@grsecurity.net>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "keescook@chromium.org" <keescook@chromium.org>, "jmorris@namei.org" <jmorris@namei.org>, "Schaufler, Casey" <casey.schaufler@intel.com>, "Leibowitz, Michael" <michael.leibowitz@intel.com>, "Roberts, William C" <william.c.roberts@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

------=_NextPart_000_0117_01D1E9AC.17F899B0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

>This again is completely unacceptable.

>> + * Copyright (c) 2016, Intel Corporation

>You know full well several functions in this code are completely
>copy+pasted from grsecurity, keeping unnecessary types, same exact
>variable names, same exact casts, same exact code structure.  In other
cases you've simply renamed variables.  Last time I had to mention this, the
entirety of my RANDSTRUCT plugin had been copy+pasted by an Intel employee
with Intel's copyright >placed alone on the top of it.
>Why does Intel have such a problem with plagiarism?

I am not sure how to handle the copyright statement in this case. Part of
code comes from your code (and acknowledgment provided), task management
done based on Yama (also acknowledged), part of code is modified, new and
etc. 
I will ask lawyers on this to clarify since this is not really my choice. I
am not interested to take credit for this, I was just interested to make the
feature work inside LSM and be accepted to upstream.

>Yes, there are some original changes in here, but this doesn't seem to have
been tested at all -- I see obvious ways of bypassing it, and some of the
checks that have been modified (aka single lines that weren't copy+pasted)
are now wrong and simply >won't work at all.

It was actually tested, I won't send untested code for review. I have tested
this on Ubuntu and Fedora, as well as with Ubuntu standard chroot. I don't
have any automatic tests done yet and there are couple of corner cases that
I omitted now, as I don't mark process from init_mount_tree(), don't
restrict filename lookup yet, don't cover mount with MS_MOVE flag and etc.
This is beginning of the work to bring all these features in place, and I
figured I would get initial comments earlier than later on this. 

>I'm sure Kees will save the day though by repeating the flaw I just
mentioned on IRC.  For the rest, Intel will have to do some actual original
work for a change.

This was actually the main point of sending these patches now, I want
feedback and I am grateful for it. So, thank you! Anything you can point out
is valuable. 


> +#include <linux/lsm_hooks.h>
> +#include <linux/sysctl.h>
> +#include <linux/fs_struct.h>
> +#include <linux/nsproxy.h>
> +#include <linux/pid_namespace.h>
> +#include <linux/printk.h>
> +#include "../fs/mount.h"
> +
> +/* describe a hardchroot info for a task */ struct hardchroot_info {
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
> +static void hardchroot_info_cleanup(struct work_struct *work); static 
> +DECLARE_WORK(hardchroot_info_work, hardchroot_info_cleanup);
> +
> +/**
> + * hardchroot_info_cleanup - remove invalid entries from
> + * the hardchroot info list.
> + */
> +static void hardchroot_info_cleanup(struct work_struct *work) {
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
> +	added = kmalloc(sizeof(*added), GFP_KERNEL);
> +	if (!added)
> +		return -ENOMEM;
> +
> +	added->task = task;
> +	added->dentry = dentry;
> +	added->invalid = false;
> +
> +	spin_lock(&hardchroot_infos_lock);
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(entry, &hardchroot_infos, node) {
> +		if (entry->invalid)
> +			continue;
> +		if (entry->task == task) {
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
> + * @dentry: remove any relation where dentry matches  */ static void 
> +hardchroot_info_del(struct task_struct *task,
> +				struct dentry *dentry)
> +{
> +	struct hardchroot_info *entry;
> +	bool marked = false;
> +
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(entry, &hardchroot_infos, node) {
> +		if (entry->invalid)
> +			continue;
> +		if (entry->task == task ||
> +			(dentry && entry->dentry == dentry)) {
> +			entry->invalid = true;
> +			marked = true;
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
> +void hardchroot_task_free(struct task_struct *task) {
> +	hardchroot_info_del(task, NULL);
> +}
> +
> +/**
> + * task_is_descendant - walk up a process family tree looking for a 
> +match
> + * The function is taken from Yama LSM
> + * @parent: the process to compare against while walking up from 
> +child
> + * @child: the process to start from while looking upwards for parent
> + *
> + * Returns 1 if child is a descendant of parent, 0 if not.
> + */
> +static int task_is_descendant(struct task_struct *parent,
> +				  struct task_struct *child)
> +{
> +	int rc = 0;
> +	struct task_struct *walker = child;
> +
> +	if (!parent || !child)
> +		return 0;
> +
> +	rcu_read_lock();
> +	if (!thread_group_leader(parent))
> +		parent = rcu_dereference(parent->group_leader);
> +	while (walker->pid > 0) {
> +		if (!thread_group_leader(walker))
> +			walker = rcu_dereference(walker->group_leader);
> +		if (walker == parent) {
> +			rc = 1;
> +			break;
> +		}
> +		walker = rcu_dereference(walker->real_parent);
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
> +static int is_process_chrooted(struct task_struct *task) {
> +	int rc = 0;
> +	struct hardchroot_info *entry;
> +
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(entry, &hardchroot_infos, node) {
> +		if (entry->invalid)
> +			continue;
> +		if ((entry->task == task) ||
> +			(task_is_descendant(entry->task, task))) {
> +			rc = 1;
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
> +static int is_same_root(struct task_struct *task1, struct task_struct 
> +*task2) {
> +	int rc = 0;
> +	struct hardchroot_info *entry;
> +	struct dentry *dentry1 = NULL;
> +	struct dentry *dentry2 = NULL;
> +
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(entry, &hardchroot_infos, node) {
> +		if (entry->invalid)
> +			continue;
> +		if (entry->task == task1)
> +			dentry1 = entry->dentry;
> +		if (entry->task == task2)
> +			dentry2 = entry->dentry;
> +	}
> +	if (dentry1 && (dentry1 == dentry2)) {
> +		rc = 1;
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
> +	int ret = 0;
> +
> +	path.dentry = (struct dentry *)u_dentry;
> +	path.mnt = (struct vfsmount *)u_mnt;
> +	get_fs_root(current->fs, &currentroot);
> +	if (path_is_under(&path, &currentroot))
> +		ret = 1;
> +	else
> +		pr_info("HCRT: dentry %lu is outside current task %d
root\n",
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
> +static int hardchroot_path_chroot(const struct path *path) {
> +	int rc = 0;
> +	struct task_struct *myself = current;
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
> +		path->dentry != init_task.fs->root.dentry &&
> +		path->dentry != myself->nsproxy->mnt_ns->root->mnt.mnt_root)
{
> +		/* task is attempting to chroot, add it to the list */
> +		rc = hardchroot_info_add(myself, path->dentry);
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
> +	int rc = 0;
> +	struct task_struct *myself = current;
> +	const struct nsproxy *tnsproxy = new_nsproxy;
> +
> +	pr_info("HCRT, unshare: unshare_flags %lu and pid %d\n",
> +			unshare_flags, task_pid_nr(myself));
> +	if (new_fs)
> +		pr_info("HCRT, unshare: new_fs->root.dentry inode%lu\n",
> +			d_backing_inode(new_fs->root.dentry)->i_ino);
> +
> +	if (!tnsproxy)
> +		tnsproxy = myself->nsproxy;
> +
> +	if (new_fs && task_pid_nr(myself) > 1 &&
> +		new_fs->root.dentry != init_task.fs->root.dentry &&
> +		new_fs->root.dentry != tnsproxy->mnt_ns->root->mnt.mnt_root)
{
> +		rc = hardchroot_info_add(myself, new_fs->root.dentry);
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
> +static int hardchroot_sb_unsharefs(const struct path *path) {
> +	int rc = 0;
> +	struct task_struct *myself = current;
> +
> +	pr_info("HCRT, unsharefs: inode %lu and pid %d\n",
> +			d_backing_inode(path->dentry)->i_ino,
> +			task_pid_nr(myself));
> +
> +	if (task_pid_nr(myself) > 1 &&
> +		path->dentry != init_task.fs->root.dentry &&
> +		path->dentry != myself->nsproxy->mnt_ns->root->mnt.mnt_root)
{
> +		rc = hardchroot_info_add(myself, path->dentry);
> +		pr_info("HCRT, unsharefs: adding %d to chrooted task
list\n",
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
> +static int hardchroot_path_chmod(const struct path *path, umode_t 
> +mode) {
> +	int rc = 0;
> +	struct task_struct *myself = current;
> +
> +	pr_info("HCRT, chmod: inode %lu, pid %d\n",
> +			d_backing_inode(path->dentry)->i_ino,
> +			task_pid_nr(myself));
> +
> +	/* allow chmod +s on directories, but not files */
> +	if (!S_ISDIR(path->dentry->d_inode->i_mode) && ((mode & S_ISUID) ||
> +		((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP))) &&
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
> +static int hardchroot_path_fchdir(const struct path *path) {
> +	int rc = 0;
> +	struct task_struct *myself = current;
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
> +static int hardchroot_path_fhandle(const struct path *path) {
> +	int rc = 0;
> +	struct task_struct *myself = current;
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
> +static int hardchroot_task_setnice(struct task_struct *task, int 
> +nice) {
> +	int rc = 0;
> +	struct task_struct *myself = current;
> +
> +	pr_info("HCRT, setnice: current %d, nice %d, for pid %d and current
nice %d\n",
> +			task_pid_nr(myself), nice,
> +			task_pid_nr(task), task_nice(task));
> +
> +	if (is_process_chrooted(myself) && (nice < task_nice(task))) {
> +		pr_info("HCRT, setnice denied: current %d, nice %d, for pid
%d and current nice %d\n",
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
> + * @dev contains the undecoded device number. Use new_decode_dev() to 
> +get
> + * the decoded device number.
> + *
> + * Return 0 if allowed, -ve on error.
> + */
> +static int hardchroot_path_mknod(const struct path *dir, struct dentry
*dentry,
> +			umode_t mode, unsigned int dev)
> +{
> +	int rc = 0;
> +	struct task_struct *myself = current;
> +
> +	pr_info("HCRT, mknod: dir %lu, mode %d pid %d\n",
> +				d_backing_inode(dir->dentry)->i_ino,
> +				mode, task_pid_nr(myself));
> +
> +	if (!S_ISFIFO(mode) && !S_ISREG(mode) &&
is_process_chrooted(myself)) {
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
> +static int hardchroot_sb_mount(const char *dev_name, const struct path
*path,
> +			const char *type, unsigned long flags, void *data) {
> +	int rc = 0;
> +	struct task_struct *myself = current;
> +
> +	pr_info("HCRT, mount: dev %s, inode %lu, flags %lu pid %d\n",
> +			dev_name, d_backing_inode(path->dentry)->i_ino,
> +			flags, task_pid_nr(myself));
> +
> +	if (is_process_chrooted(myself)) {
> +		pr_info("HCRT, mount denied: dev %s, inode %lu, flags %lu,
pid %d\n",
> +				dev_name,
d_backing_inode(path->dentry)->i_ino,
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
> +	int rc = 0;
> +	struct task_struct *myself = current;
> +
> +	pr_info("HCRT, pivotroot: old %lu, new %lu, pid %d\n",
> +			d_backing_inode(old_path->dentry)->i_ino,
> +			d_backing_inode(new_path->dentry)->i_ino,
> +			task_pid_nr(myself));
> +
> +	if (is_process_chrooted(myself)) {
> +		pr_info("HCRT, pivotroot denied: old %lu, new %lu, pid
%d\n",
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
> +	int rc = 0;
> +	struct task_struct *p;
> +	struct task_struct *myself = current;
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
> +	p = find_task_by_vpid(shp->shm_cprid);
> +	if (p) {
> +		st = p->start_time;
> +		ct = shp->shm_ctim;
> +		if (time_before_eq((unsigned long)st, (unsigned long)ct)) {
> +			if (is_same_root(myself, p))
> +				goto allow;
> +			else {
> +				read_unlock(&tasklist_lock);
> +				rcu_read_unlock();
> +				pr_info("HCRT, shmat denied: shp %d, shmflg
%d, pid %d\n",
> +						shp->shm_perm.id, shmflg,
> +						task_pid_nr(myself));
> +				return -EACCES;
> +			}
> +		}
> +		/* creator exited, pid reuse, fall through to next check */
> +	}
> +	p = find_task_by_vpid(shp->shm_lprid);
> +	if (p) {
> +		if (unlikely(!is_same_root(myself, p))) {
> +			read_unlock(&tasklist_lock);
> +			rcu_read_unlock();
> +			pr_info("HCRT, shmat denied: shp %d, shmflg %d, pid
%d\n",
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
> +static struct security_hook_list hardchroot_hooks[] = {
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
> +	LSM_HOOK_INIT(shm_shmat, hardchroot_shm_shmat), };
> +
> +static inline void hardchroot_init_sysctl(void) { }
> +
> +void __init hardchroot_add_hooks(void) {
> +	pr_info("Hardchroot: Getting stronger.\n");
> +	security_add_hooks(hardchroot_hooks, ARRAY_SIZE(hardchroot_hooks));
> +	hardchroot_init_sysctl();
> +}
> diff --git a/security/security.c b/security/security.c index 
> 95487b9..ff65f06 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -61,6 +61,7 @@ int __init security_init(void)
>  	capability_add_hooks();
>  	yama_add_hooks();
>  	loadpin_add_hooks();
> +	hardchroot_add_hooks();
>  
>  	/*
>  	 * Load all the remaining security modules.
> --
> 1.9.1

------=_NextPart_000_0117_01D1E9AC.17F899B0
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"

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
VMv3yxHO8jex40LgMIIFgjCCBGqgAwIBAgITMwAAD3rg031j5++L1QAAAAAPejANBgkqhkiG9w0B
AQUFADB5MQswCQYDVQQGEwJVUzELMAkGA1UECBMCQ0ExFDASBgNVBAcTC1NhbnRhIENsYXJhMRow
GAYDVQQKExFJbnRlbCBDb3Jwb3JhdGlvbjErMCkGA1UEAxMiSW50ZWwgRXh0ZXJuYWwgQmFzaWMg
SXNzdWluZyBDQSA0QjAeFw0xNTAyMTIyMzMzMTJaFw0xODAxMjcyMzMzMTJaMEUxGTAXBgNVBAMT
EFJlc2hldG92YSwgRWxlbmExKDAmBgkqhkiG9w0BCQEWGWVsZW5hLnJlc2hldG92YUBpbnRlbC5j
b20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC8zCTf8cWZZUKtxwMUvSAnw+W43aFU
UojRptAkTEnxL7PPHdqDP9F4q/6oIcHWhlxca0/lopd2l7h1bzb8bRdTWJwQ9Hf67xLNnhRW5Xtu
A6RW88jOU4ALNkktravhIfru5oQ9SatQOJlkRpZWid5ByI4qUe/G3PmCMdOAHFfUQDZ+CpwexUYJ
FUvDcCVAcqRTx4g/jbhAMfmJQ1RnFXj5Wxq3H0PrH7Tsb9bqXSWGxE6Vr5VQI776dWxwWSbu82CF
uUY2j6Qq902bui4Wg0pRUlG66wFbQ9YujkrrhPSScCWOkycSVUy1tguk5L1WHtj2DelrG5We/Z7T
z3IaYQsTAgMBAAGjggI1MIICMTALBgNVHQ8EBAMCB4AwPAYJKwYBBAGCNxUHBC8wLQYlKwYBBAGC
NxUIhsOMdYSZ5VGD/YEohY6fU4KRwAlngd69OZXwQwIBZAIBCDAdBgNVHQ4EFgQUojQGvJU2345o
mYdTt1O7CESK1YYwHwYDVR0jBBgwFoAU2kEjnFqPca9Xgz4g0+Nl2wzLC9swZQYDVR0fBF4wXDBa
oFigVoZUaHR0cDovL3d3dy5pbnRlbC5jb20vcmVwb3NpdG9yeS9DUkwvSW50ZWwlMjBFeHRlcm5h
bCUyMEJhc2ljJTIwSXNzdWluZyUyMENBJTIwNEIuY3JsMIGfBggrBgEFBQcBAQSBkjCBjzAiBggr
BgEFBQcwAYYWaHR0cDovL29jc3AuaW50ZWwuY29tLzBpBggrBgEFBQcwAoZdaHR0cDovL3d3dy5p
bnRlbC5jb20vcmVwb3NpdG9yeS9jZXJ0aWZpY2F0ZXMvSW50ZWwlMjBFeHRlcm5hbCUyMEJhc2lj
JTIwSXNzdWluZyUyMENBJTIwNEIuY3J0MB8GA1UdJQQYMBYGCCsGAQUFBwMEBgorBgEEAYI3CgMM
MCkGCSsGAQQBgjcVCgQcMBowCgYIKwYBBQUHAwQwDAYKKwYBBAGCNwoDDDBPBgNVHREESDBGoCkG
CisGAQQBgjcUAgOgGwwZZWxlbmEucmVzaGV0b3ZhQGludGVsLmNvbYEZZWxlbmEucmVzaGV0b3Zh
QGludGVsLmNvbTANBgkqhkiG9w0BAQUFAAOCAQEAod197fPvlvz23dBvvgrjTi/LUl8J8o1fmbNG
YjdquDdvPNDJ4FL8t9MpeqRc+63IgyitnmvmiD+lzTibTwDSt2MY9Mck8VJDF60h7dnFFhr3k1B6
yt6cwxvdadOVB0UVwORYw+9LWvnNyhqsMz7YZtEksDkFqtTE7+vZhVDBAjhTTjtMeDz+l9JOWnkx
bJcp/RbxD3m16kRaXq5xHQQ4TfjSRw0GjZq2FafF8yrv+vcVlXYLaKT0DXKT/mCksU7aN4BE5tUx
H55A48baN+GMUI75Gk3rzh/kdNmYtJhYs63kZ8+2u/hkxEc1/wKM5h714s2+dcCznTAuLF6mXVUp
6jCCBckwggSxoAMCAQICEzMAAGceyeUJ4F3k0k4AAAAAZx4wDQYJKoZIhvcNAQEFBQAweTELMAkG
A1UEBhMCVVMxCzAJBgNVBAgTAkNBMRQwEgYDVQQHEwtTYW50YSBDbGFyYTEaMBgGA1UEChMRSW50
ZWwgQ29ycG9yYXRpb24xKzApBgNVBAMTIkludGVsIEV4dGVybmFsIEJhc2ljIElzc3VpbmcgQ0Eg
NEEwHhcNMTUwMjEyMjMzMjMzWhcNMTgwMTI3MjMzMjMzWjBFMRkwFwYDVQQDExBSZXNoZXRvdmEs
IEVsZW5hMSgwJgYJKoZIhvcNAQkBFhllbGVuYS5yZXNoZXRvdmFAaW50ZWwuY29tMIIBIjANBgkq
hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAri/J5YL4ajWEtrCcoBdZhjVXDBMbhSL9Sa+oL2KXVmCc
gNNGSkyw9GS6QnkkJq0i7DQooSuI0ymSvWu4dhotg8SytCXuxMH0Q3WRapVw9K73ZDKz3cbFFeps
FiSAjOZ3qflZt5ZiweR/XJq8PNwgTnvajNdC+jXeEPzJV4vEsaHpBmf1xhx2SqkQhJAlb6sa2dgR
bGMLdMKR9SE+3LVNBVDyx39lSY92S+8W4iRLfLpQiN1k2hL10ubFrOchsKz2tQZt9dc7ekZLgmmy
/rxBFY70hsqjiwA5KVestkdZmUkj5bRwOL0sjOqVJaAoNkrNZGVdzpsuVz7ybt/G9ulDWwIDAQAB
o4ICfDCCAngwCwYDVR0PBAQDAgQwMD0GCSsGAQQBgjcVBwQwMC4GJisGAQQBgjcVCIbDjHWEmeVR
g/2BKIWOn1OCkcAJZ4S52UGHhP9OAgFkAgENMEQGCSqGSIb3DQEJDwQ3MDUwDgYIKoZIhvcNAwIC
AgCAMA4GCCqGSIb3DQMEAgIAgDAHBgUrDgMCBzAKBggqhkiG9w0DBzAdBgNVHQ4EFgQUXy7oFxt5
z1FFlAs9UeyFV0CwbF4wHwYDVR0jBBgwFoAUHmkqtNwo/kcYTiELP7ysES/wmPUwZQYDVR0fBF4w
XDBaoFigVoZUaHR0cDovL3d3dy5pbnRlbC5jb20vcmVwb3NpdG9yeS9DUkwvSW50ZWwlMjBFeHRl
cm5hbCUyMEJhc2ljJTIwSXNzdWluZyUyMENBJTIwNEEuY3JsMIGfBggrBgEFBQcBAQSBkjCBjzBp
BggrBgEFBQcwAoZdaHR0cDovL3d3dy5pbnRlbC5jb20vcmVwb3NpdG9yeS9jZXJ0aWZpY2F0ZXMv
SW50ZWwlMjBFeHRlcm5hbCUyMEJhc2ljJTIwSXNzdWluZyUyMENBJTIwNEEuY3J0MCIGCCsGAQUF
BzABhhZodHRwOi8vb2NzcC5pbnRlbC5jb20vMB8GA1UdJQQYMBYGCCsGAQUFBwMEBgorBgEEAYI3
CgMEMCkGCSsGAQQBgjcVCgQcMBowCgYIKwYBBQUHAwQwDAYKKwYBBAGCNwoDBDBPBgNVHREESDBG
oCkGCisGAQQBgjcUAgOgGwwZZWxlbmEucmVzaGV0b3ZhQGludGVsLmNvbYEZZWxlbmEucmVzaGV0
b3ZhQGludGVsLmNvbTANBgkqhkiG9w0BAQUFAAOCAQEAoQFBFD/YZhrNEYTXYuZkKHYE+KJ5cF4m
bYlT8LAVpVtdWYj3uDWMVX0aJASNa01fZNNp8FVacHQkH6RqMAO9zu8q71Y/fTZLq/wTA5mXyiER
9x+U3BvF/WPfnfzxZ1DlamT6EhkPNpR2zkWxHuI5Wz5H0TGYCcmkTJ+z7ERTBV5RvTMcBRFY4F6I
rLlcj+S616J74ohWv6QK8gZ894Jl/D0XyKYRxEhu5VGwfmRC8fXfCDL9v5zLWEcdjwwhkTGWWNB2
WOJYZCer+SGEGCYldn7YSPDOmlxpd8XlO3M1m1gAfsmnU/AjacOYnKyp/THuGC97/7NcWHfkR9vD
z1fq9jGCA/kwggP1AgEBMIGQMHkxCzAJBgNVBAYTAlVTMQswCQYDVQQIEwJDQTEUMBIGA1UEBxML
U2FudGEgQ2xhcmExGjAYBgNVBAoTEUludGVsIENvcnBvcmF0aW9uMSswKQYDVQQDEyJJbnRlbCBF
eHRlcm5hbCBCYXNpYyBJc3N1aW5nIENBIDRCAhMzAAAPeuDTfWPn74vVAAAAAA96MAkGBSsOAwIa
BQCgggI9MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE2MDcyOTEy
MTU1MVowIwYJKoZIhvcNAQkEMRYEFLvT9S2/ZW0dtmoHpM+3excLm23eMIGTBgkqhkiG9w0BCQ8x
gYUwgYIwCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBFjAKBggqhkiG9w0DBzALBglghkgBZQMEAQIw
DgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFAMAcGBSsOAwIaMAsGCWCGSAFlAwQCAzALBglg
hkgBZQMEAgIwCwYJYIZIAWUDBAIBMIGhBgkrBgEEAYI3EAQxgZMwgZAweTELMAkGA1UEBhMCVVMx
CzAJBgNVBAgTAkNBMRQwEgYDVQQHEwtTYW50YSBDbGFyYTEaMBgGA1UEChMRSW50ZWwgQ29ycG9y
YXRpb24xKzApBgNVBAMTIkludGVsIEV4dGVybmFsIEJhc2ljIElzc3VpbmcgQ0EgNEECEzMAAGce
yeUJ4F3k0k4AAAAAZx4wgaMGCyqGSIb3DQEJEAILMYGToIGQMHkxCzAJBgNVBAYTAlVTMQswCQYD
VQQIEwJDQTEUMBIGA1UEBxMLU2FudGEgQ2xhcmExGjAYBgNVBAoTEUludGVsIENvcnBvcmF0aW9u
MSswKQYDVQQDEyJJbnRlbCBFeHRlcm5hbCBCYXNpYyBJc3N1aW5nIENBIDRBAhMzAABnHsnlCeBd
5NJOAAAAAGceMA0GCSqGSIb3DQEBAQUABIIBAGTNrGrnbKhQeT8dDhnwM4Q7fD1NBESHNaSreftm
nXY2ebiTrqzTDgW0dtXsZ3m7we86DltcJjXaawZLWyvxe17EF89FR3LzDaVu1VYkczhTiye9N1Ae
nswxryQS+hyoI12nefTkHBFB308LzzYWHYyxHDzY0/8WVg3mMoNGTRnzWUOSY1+VC5R9i60c555u
K3et7yc9poqJkPfLxO9DbDfG3EYYPygBdA+X2gij2JQLNwakhcl0tqd1f7EbVVXgEuR50Pds7Psp
r31hAGfDwsrVhVf1bq+BKIg9GbWINbh8Pf90rJ9ok3/RCy7wpvR3M4bqR1SpKkY2x6S/2LyWaxgA
AAAAAAA=

------=_NextPart_000_0117_01D1E9AC.17F899B0--
