Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 29 Jul 2016 20:53:17 +0200
From: Jann Horn <jann@thejh.net>
Message-ID: <20160729185317.GF11621@pc.thejh.net>
References: <1469777680-3687-1-git-send-email-elena.reshetova@intel.com>
 <1469777680-3687-6-git-send-email-elena.reshetova@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rWhLK7VZz0iBluhq"
Content-Disposition: inline
In-Reply-To: <1469777680-3687-6-git-send-email-elena.reshetova@intel.com>
Subject: Re: [kernel-hardening] [RFC] [PATCH 5/5] Hardchroot LSM
To: kernel-hardening@lists.openwall.com
Cc: linux-security-module@vger.kernel.org, keescook@chromium.org, spender@grsecurity.net, jmorris@namei.org, casey.schaufler@intel.com, michael.leibowitz@intel.com, william.c.roberts@intel.com, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>


--rWhLK7VZz0iBluhq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 29, 2016 at 10:34:40AM +0300, Elena Reshetova wrote:
> This adds a new Hardchroot LSM that is intended to make
> classical chroot more secure. It is based on
> GRKERNSEC_CHROOT feature with necessary changes needed to
> make it fit inside LSM. Currently not all GRKERNSEC_CHROOT
> features are supported, but support is planned to be added
> on granular basis.
>=20
> The credits for feature itself should go to the original
> authors of GRKERNSEC_CHROOT. Since there is no way to share
> security metadata between LSMs yet, the Hardchroot info task
> management is done based on Yama LSM. When support is added,
> the required info can be stored as part of task struct and it
> can drastically simplify the internal management.

I really don't like this series.

First off: On Linux, as far as I know, chroots were never meant
to be a security feature, and chroot "jails" break in a number
of different ways. A lot of effort went into making bind mounts
actually secure with reasonable performance, and I doubt that
something like this can provide anything close to that, at least
not without gigantic runtime overhead. Instead of making people
believe that it's now okay to use chroot for security, I would
very much prefer to keep the "never use this for security
purposes" warning in the chroot() manpage and encourage people
to use namespaces with bind mounts instead.

I think that a somewhat more formal specification of what this
is supposed to be good for might help.

As far as I can tell, you haven't done anything to restrict
the access to unix domain sockets or ptrace, which are probably
the main tricks people would actually use to break out of a
chroot "jail". Instead, you add support for some weird edgecase
things like "if you are privileged and inside a chroot, you can
renice processes outside the chroot".


>     Note: this feature currently prevents rtkit daemon from
>     normal operation.

And it probably also prevents people from using chroot() for
what it's actually intended to do.

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

Wait, what? Is this really a function that has execution time linear
in the number of running processes and that is called for every
fchdir()? That seems slow. Did you benchmark this on a system with
lots of processes?


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

You're comparing dentries, not paths? So using the same directory
through different bind mounts as root directories will still count
as "same root" even though for chroot breakouts, it's like having
different roots?


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

That seems pretty broken, considering the possibility of open
file descriptors pointing to the old root or so.

And again, chroot only works if the current process is privileged.
If it is, there are probably other ways to break out.


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

Hm? You're accessing the fs_struct of init_task without any explicit lockin=
g?


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

Not exactly your fault, but this is broken when PID namespaces are involved.

--rWhLK7VZz0iBluhq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXm6YdAAoJED4KNFJOeCOoXxkP/3lDmIOCWegB1FSsDg6rxYmq
Owl5bEKW8i88H+Ei4sMMKs8oYsYG/ZfzF1QyDqbBN591DVBDMyqcFR8clPyfIixc
Gp/FVNC1HSfWNY4W8qHQcwi0RvXyEAM47YYfLMWE5SKyTkhYZocM1pQWnOEywtH8
CRuPn5eN6/rleTXPtkiGIOUbKw5QsMQtXSzUpaGKvCvK7QoKdMQ3KJyFXlFsuxVL
B6Q31ggOaMThg20NULlcPG7v05TqIZFZSH3Rqv2tJ2DNE8dFO7nPA0o6pKSOeUhe
MggKHA2mpxcmzI8YIalgIanUcY7QpgeuRfQS74bcYfjkKXB44wlmUDN+Vzb6ewlI
VjZAq6cSvJcxo+kVXJcZk7bOzRzIQr6ZZ7t1ziWB0CJJccbpTZExZ34V8YqLg23s
BWH2Mujxa9NazSiKcgexV9QpJi9hd4jgO0BOXEuTXptjjW4+yAzTInQgfjlYYLJB
q4cytbqcV6FGtySowpsd9kblYzjwOKLeG3OdjPVKXB3Egr3XiFZWDWFDD9m46N6Y
CaCBPLkFKj3tNyLBPYeviLs9pDy6W0dRKjPERR8aaPHhi66sf1NhpbFKlL+ztbcD
X+bOd59gMeL+gT4j5uNiKUe/lx+5zR7FwNUnPyekTpqC5fv1IfIFEPrYpmS4ExZ7
8qYaCol+WhwLstFQGPyk
=m9WG
-----END PGP SIGNATURE-----

--rWhLK7VZz0iBluhq--
