Reply-To: kernel-hardening@lists.openwall.com
From: "Reshetova, Elena" <elena.reshetova@intel.com>
Date: Sat, 30 Jul 2016 06:10:32 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41B6FFD6@IRSMSX102.ger.corp.intel.com>
References: <1469777680-3687-1-git-send-email-elena.reshetova@intel.com>
 <1469777680-3687-6-git-send-email-elena.reshetova@intel.com>
 <20160729185317.GF11621@pc.thejh.net>
In-Reply-To: <20160729185317.GF11621@pc.thejh.net>
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
	micalg=SHA1; boundary="----=_NextPart_000_01FB_01D1EA42.38AFEE10"
MIME-Version: 1.0
Subject: RE: [kernel-hardening] [RFC] [PATCH 5/5] Hardchroot LSM
To: Jann Horn <jann@thejh.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "keescook@chromium.org" <keescook@chromium.org>, "spender@grsecurity.net" <spender@grsecurity.net>, "jmorris@namei.org" <jmorris@namei.org>, "Schaufler, Casey" <casey.schaufler@intel.com>, "Leibowitz, Michael" <michael.leibowitz@intel.com>, "Roberts, William C" <william.c.roberts@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

------=_NextPart_000_01FB_01D1EA42.38AFEE10
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

First of all, thank you very much for the review! I am still learning with
many things and your feedback is very much appreciated!

>First off: On Linux, as far as I know, chroots were never meant to be a
security feature, and chroot "jails" break in a number of different ways. A
lot of effort went into making bind mounts actually secure with reasonable
performance, and I doubt that >something like this can provide anything
close to that, at least not without gigantic runtime overhead. Instead of
making people believe that it's now okay to use chroot for security, I would
very much prefer to keep the "never use this for security >purposes" warning
in the chroot() manpage and encourage people to use namespaces with bind
mounts instead.

I am aware that chroot jail should not be used for security purposes, but
reality is that it is *used* in many places at least with some intention of
getting a better security. I don't believe there is any person nowadays who
believes that chroot is secure, but because it is super light-weight (even
compare with namespaces setup) and because of legacy concerns, it is still
there. I don't also claim that this LSM make chroot *fully* secure (as you
mentioned below some important features are still missing) and it would
never be as strong as full namespace-based solution, but practical problem
with namespaces is that it isn't that easy to setup them up properly and
possibility of making configuration mistake is still quite high.
About the performance overhead, I actually don't believe it would be that
gigantic (especially when we get proper LSM stacking in place that
eliminates the need to store internal list and do searches), but of course
any LSM has performance impact, especially with the hooks on the filesystem.

And don't take me wrong, I do personally like namespaces very much. Just
usecases  I am trying to address with this are very different. 

> I think that a somewhat more formal specification of what this is supposed
to be good for might help.
Yes, I think this make sense. It would clarify on when you should use this
(in cases when you do need to use chroot only but want to make it a degree
better).

>As far as I can tell, you haven't done anything to restrict the access to
unix domain sockets or ptrace, which are probably the main tricks people
would actually use to break out of a chroot "jail". Instead, you add support
for some weird edgecase things like >"if you are privileged and inside a
chroot, you can renice processes outside the chroot".

Supporting unix domain sockets is in plans, I was looking into all GRKERNSEC
features and working them one by one. I first processed all features that
can be easily moved into existing LSM hooks, and nice was one of them. Then
I started adding new hooks for the rest of features. But at some point I
just exceeded my threshold of confidence with all the changes and hooks I am
making (unix domain sockets might need further new hooks), so I wanted to
bring this out for review earlier than later. 

What about ptrace? I am assume that we have Yama in place for this :)

>     Note: this feature currently prevents rtkit daemon from
>     normal operation.

>And it probably also prevents people from using chroot() for what it's
actually intended to do.
I would not go as far as that. How many cases apart from rtkit daemon who
sets priorities for other processes you know that would suffer from this
behaviour? 
Again, this was an easy feature that fits into existing hook and can be
fully removed if people don't see a value in it. It is certainly not the
main part of it. 
 
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

>Wait, what? Is this really a function that has execution time linear in the
number of running processes and that is called for every fchdir()? That
seems slow. Did you benchmark this on a system with lots of processes?
I haven't done any benchmarking on this yet, but remember that
hardchroot_infos will be quite a short list, which equals number of
processes that explicitly entered chroot (not their children, only first
parent process to do it). 
In Ubuntu and Fedora for example, after the full boot, I only had 3 such
processes in the list, so this gives the size of list I am expecting: 10-20
items absolutely max (normally under 10), not  hundreds. So, list iteration
is quite fast.
So, it doesn't depend on the number of system processes, but it does depend
on number of processes that entered chroot. 

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

>You're comparing dentries, not paths? So using the same directory through
different bind mounts as root directories will still count as "same root"
even though for chroot breakouts, it's like having different roots?
Bind mounts are tricky in this case. From one side yes, it is yes like
having two different roots, but then how to handle legitimate cases when
people bind mount things into chroot to be used there?
Blocking them would make bind mounts not supported inside chroot, which is
not smth that should be done IMO.


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

>That seems pretty broken, considering the possibility of open file
descriptors pointing to the old root or so.
Again, the main use case here is that we have a good process that enters
chroot to minimize the damage in case it gets exploited some later time in
life. 
A good process is supposed to close its file descriptors pointing to the old
root before entering chroot, isn't it?

>And again, chroot only works if the current process is privileged.
>If it is, there are probably other ways to break out.

You need to have privilege to *enter* chroot,  but if you are good process,
you will drop the privilege after you did your setup. 


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

>Hm? You're accessing the fs_struct of init_task without any explicit
locking?
I am quite new to the kernel development and locking. I was reading a lot
recently about locking to understand where it is needed and where not, but
mistakes are obviously still coming. 
I guess I would need to do smth like: task_lock(&init_task) before and
task_unlock(&init_task) after. 

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

>Not exactly your fault, but this is broken when PID namespaces are
involved.
Yes, this has been bothering me also...  Grsecurity has their own version of
this function (find_task_by_vpid_unrestricted) instead that tried to do
global search, I guess I should think on doing smth similar, but I am
wondering if this can be done better. 
I will look into this for the next version. 

------=_NextPart_000_01FB_01D1EA42.38AFEE10
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
BQCgggI9MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE2MDczMDA2
MTAzMVowIwYJKoZIhvcNAQkEMRYEFLUnHxIDfemBTq4w44ipGE+Hfx7cMIGTBgkqhkiG9w0BCQ8x
gYUwgYIwCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBFjAKBggqhkiG9w0DBzALBglghkgBZQMEAQIw
DgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFAMAcGBSsOAwIaMAsGCWCGSAFlAwQCAzALBglg
hkgBZQMEAgIwCwYJYIZIAWUDBAIBMIGhBgkrBgEEAYI3EAQxgZMwgZAweTELMAkGA1UEBhMCVVMx
CzAJBgNVBAgTAkNBMRQwEgYDVQQHEwtTYW50YSBDbGFyYTEaMBgGA1UEChMRSW50ZWwgQ29ycG9y
YXRpb24xKzApBgNVBAMTIkludGVsIEV4dGVybmFsIEJhc2ljIElzc3VpbmcgQ0EgNEECEzMAAGce
yeUJ4F3k0k4AAAAAZx4wgaMGCyqGSIb3DQEJEAILMYGToIGQMHkxCzAJBgNVBAYTAlVTMQswCQYD
VQQIEwJDQTEUMBIGA1UEBxMLU2FudGEgQ2xhcmExGjAYBgNVBAoTEUludGVsIENvcnBvcmF0aW9u
MSswKQYDVQQDEyJJbnRlbCBFeHRlcm5hbCBCYXNpYyBJc3N1aW5nIENBIDRBAhMzAABnHsnlCeBd
5NJOAAAAAGceMA0GCSqGSIb3DQEBAQUABIIBAE4N95UR0e8py0WmftBXBv7HxNYaQqr3srAbihhO
69tTze4NTvJIajoOt4cqZCG+pbrehgmrz+jX2R+TGyBHOPDEJ8lYV+6QDB6dt4ALDkVIYoqsWKCG
D0C3NRcbqml93IpHgGsF8vv53wX+LDICI1XArWfYBHVTP6x9EaoiTf/4Saok727MySRDT2ZoQ0qT
I29SGrCsuYZTutk2gVkWuuARAKcdwjQSZIDk0rUud/RPL5FoO4E3aFNUx+6YZI6IrRj4GcuUOgwo
DzIXo3ji4LF1cgJZYK0PD3smBY72Bkk0XFzSWtg+OHEMGDTJ+hq75oGKK62M0FNjID2mX8uGDo0A
AAAAAAA=

------=_NextPart_000_01FB_01D1EA42.38AFEE10--
