Reply-To: kernel-hardening@lists.openwall.com
References: <1469777680-3687-1-git-send-email-elena.reshetova@intel.com>
 <1469777680-3687-6-git-send-email-elena.reshetova@intel.com>
 <20160729185317.GF11621@pc.thejh.net>
From: Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <f2fcb76e-f843-cd78-0552-6709b34827e3@schaufler-ca.com>
Date: Fri, 29 Jul 2016 12:20:56 -0700
MIME-Version: 1.0
In-Reply-To: <20160729185317.GF11621@pc.thejh.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [RFC] [PATCH 5/5] Hardchroot LSM
To: Jann Horn <jann@thejh.net>, kernel-hardening@lists.openwall.com
Cc: linux-security-module@vger.kernel.org, keescook@chromium.org, spender@grsecurity.net, jmorris@namei.org, casey.schaufler@intel.com, michael.leibowitz@intel.com, william.c.roberts@intel.com, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 7/29/2016 11:53 AM, Jann Horn wrote:
> On Fri, Jul 29, 2016 at 10:34:40AM +0300, Elena Reshetova wrote:
>> This adds a new Hardchroot LSM that is intended to make
>> classical chroot more secure. It is based on
>> GRKERNSEC_CHROOT feature with necessary changes needed to
>> make it fit inside LSM. Currently not all GRKERNSEC_CHROOT
>> features are supported, but support is planned to be added
>> on granular basis.
>>
>> The credits for feature itself should go to the original
>> authors of GRKERNSEC_CHROOT. Since there is no way to share
>> security metadata between LSMs yet, the Hardchroot info task
>> management is done based on Yama LSM. When support is added,
>> the required info can be stored as part of task struct and it
>> can drastically simplify the internal management.
> I really don't like this series.
>
> First off: On Linux, as far as I know, chroots were never meant
> to be a security feature,

This is a common misconception. When chroot was introduced circa 1979
(the exact date is subject to interpretation and your skill with sccs)
security, especially in the form of protecting the system from
accidental corruption, was an important concern.

> and chroot "jails" break in a number
> of different ways.

All of which were introduced after the fact, and most of which
have been introduced in spite of the objections of the security
community. Even sockets, which are the biggest single breakage
(followed closely by the process namespace and SVIPC) came along
well after chroot and really should have taken the "root" into
account.

> A lot of effort went into making bind mounts
> actually secure with reasonable performance, and I doubt that
> something like this can provide anything close to that, at least
> not without gigantic runtime overhead. Instead of making people
> believe that it's now okay to use chroot for security, I would
> very much prefer to keep the "never use this for security
> purposes" warning in the chroot() manpage and encourage people
> to use namespaces with bind mounts instead.

There is merit to the argument that namespaces are better than
chroot jails. Nonetheless, we're all aware of just how much
legacy code we're going to have to deal with for the next
forever, and some of that can benefit from this work.

>
> I think that a somewhat more formal specification of what this
> is supposed to be good for might help.
>
> As far as I can tell, you haven't done anything to restrict
> the access to unix domain sockets or ptrace, which are probably
> the main tricks people would actually use to break out of a
> chroot "jail". Instead, you add support for some weird edgecase
> things like "if you are privileged and inside a chroot, you can
> renice processes outside the chroot".
>
>
>>     Note: this feature currently prevents rtkit daemon from
>>     normal operation.
> And it probably also prevents people from using chroot() for
> what it's actually intended to do.
>
>> +/**
>> + * is_process_chrooted - process is inside chroot
>> + * @task: the task_struct of the process to be checked
>> + *
>> + * Returns 1 if task is inside chroot.
>> + */
>> +static int is_process_chrooted(struct task_struct *task)
>> +{
>> +	int rc = 0;
>> +	struct hardchroot_info *entry;
>> +
>> +	rcu_read_lock();
>> +	list_for_each_entry_rcu(entry, &hardchroot_infos, node) {
> Wait, what? Is this really a function that has execution time linear
> in the number of running processes and that is called for every
> fchdir()? That seems slow. Did you benchmark this on a system with
> lots of processes?
>
>
>> +/**
>> + * is_same_root - check if two tasks share the same root
>> + * @task1: the task_struct of the first task to be checked
>> + * @task2: the task_struct of the second task to be checked
>> + *
>> + * Returns 1 if tasks share the same root.
>> + */
>> +static int is_same_root(struct task_struct *task1, struct task_struct *task2)
>> +{
>> +	int rc = 0;
>> +	struct hardchroot_info *entry;
>> +	struct dentry *dentry1 = NULL;
>> +	struct dentry *dentry2 = NULL;
>> +
>> +	rcu_read_lock();
>> +	list_for_each_entry_rcu(entry, &hardchroot_infos, node) {
>> +		if (entry->invalid)
>> +			continue;
>> +		if (entry->task == task1)
>> +			dentry1 = entry->dentry;
>> +		if (entry->task == task2)
>> +			dentry2 = entry->dentry;
>> +	}
>> +	if (dentry1 && (dentry1 == dentry2)) {
>> +		rc = 1;
>> +		pr_info("HCRT: pids %d and %d have the same root\n",
>> +				task_pid_nr(task1), task_pid_nr(task2));
>> +	}
> You're comparing dentries, not paths? So using the same directory
> through different bind mounts as root directories will still count
> as "same root" even though for chroot breakouts, it's like having
> different roots?
>
>
>> +/**
>> + * hardchroot_path_chroot - validate chroot entry
>> + * @path contains the path structure.
>> + *
>> + * Returns 0 if chroot is allowed, -ve on error.
>> + */
>> +static int hardchroot_path_chroot(const struct path *path)
>> +{
>> +	int rc = 0;
>> +	struct task_struct *myself = current;
>> +
>> +	pr_info("HCRT, chroot: inode %lu and pid %d\n",
>> +			d_backing_inode(path->dentry)->i_ino,
>> +			task_pid_nr(myself));
>> +
>> +	get_task_struct(myself);
>> +	if (is_process_chrooted(myself) &&
>> +		!is_inside_chroot(path->dentry, path->mnt)) {
>> +		put_task_struct(myself);
>> +		pr_info("HCRT, chroot denied: for inode %lu and pid %d\n",
>> +				d_backing_inode(path->dentry)->i_ino,
>> +				task_pid_nr(myself));
>> +		return -EACCES;
>> +	}
>> +
>> +	if (task_pid_nr(myself) > 1 &&
>> +		path->dentry != init_task.fs->root.dentry &&
>> +		path->dentry != myself->nsproxy->mnt_ns->root->mnt.mnt_root) {
>> +		/* task is attempting to chroot, add it to the list */
>> +		rc = hardchroot_info_add(myself, path->dentry);
>> +		pr_info("HCRT, chroot: adding %d to chrooted task list\n",
>> +			task_pid_nr(myself));
>> +	}
>> +
>> +	/* set the current working directory of all newly-chrooted
>> +	 * processes to the the root directory of the chroot
>> +	 */
>> +	set_fs_pwd(myself->fs, path);
> That seems pretty broken, considering the possibility of open
> file descriptors pointing to the old root or so.
>
> And again, chroot only works if the current process is privileged.
> If it is, there are probably other ways to break out.
>
>
>> +/**
>> + * hardchroot_task_unshare - check if process is
>> + * allowed to unshare its namespaces
>> + * @unshare_flags flags
>> + * @new_fs contains the new fs_struct if created.
>> + * @new_fd contains the new files_struct if created.
>> + * @new_creds contains the new cred if created.
>> + * @new_nsproxy contains the new nsproxy if created.
>> + *
>> + * Returns 0 if unshare is allowed, -ve on error.
>> + */
>> +static int hardchroot_task_unshare(unsigned long unshare_flags,
>> +		const struct fs_struct *new_fs,
>> +		const struct files_struct *new_fd,
>> +		const struct cred *new_cred,
>> +		const struct nsproxy *new_nsproxy)
>> +{
>> +	int rc = 0;
>> +	struct task_struct *myself = current;
>> +	const struct nsproxy *tnsproxy = new_nsproxy;
>> +
>> +	pr_info("HCRT, unshare: unshare_flags %lu and pid %d\n",
>> +			unshare_flags, task_pid_nr(myself));
>> +	if (new_fs)
>> +		pr_info("HCRT, unshare: new_fs->root.dentry inode%lu\n",
>> +			d_backing_inode(new_fs->root.dentry)->i_ino);
>> +
>> +	if (!tnsproxy)
>> +		tnsproxy = myself->nsproxy;
>> +
>> +	if (new_fs && task_pid_nr(myself) > 1 &&
>> +		new_fs->root.dentry != init_task.fs->root.dentry &&
> Hm? You're accessing the fs_struct of init_task without any explicit locking?
>
>
>> +/**
>> + * hardchroot_shm_shmat - check if shmat is allowed
>> + * @shp contains the shared memory structure to be modified.
>> + * @shmaddr contains the address to attach memory region to.
>> + * @shmflg contains the operational flags.
>> + *
>> + * Return 0 if allowed, -ve on error.
>> + */
>> +int hardchroot_shm_shmat(struct shmid_kernel *shp, char __user *shmaddr,
>> +			int shmflg)
>> +{
>> +	int rc = 0;
>> +	struct task_struct *p;
>> +	struct task_struct *myself = current;
>> +	u64 st;
>> +	time_t ct;
>> +
>> +	pr_info("HCRT, shmat: shp %d, shmflg %d, pid %d\n",
>> +			shp->shm_perm.id, shmflg,
>> +			task_pid_nr(myself));
>> +
>> +	if (likely(!is_process_chrooted(myself)))
>> +		return rc;
>> +
>> +	rcu_read_lock();
>> +	read_lock(&tasklist_lock);
>> +
>> +	p = find_task_by_vpid(shp->shm_cprid);
> Not exactly your fault, but this is broken when PID namespaces are involved.
