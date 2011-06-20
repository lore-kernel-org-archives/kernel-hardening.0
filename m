Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <4DFF5795.9080609@redhat.com>
Date: Mon, 20 Jun 2011 10:22:13 -0400
From: Eric Paris <eparis@redhat.com>
MIME-Version: 1.0
References: <20110617171152.GA1389@albatros>
In-Reply-To: <20110617171152.GA1389@albatros>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC v2] security: intoduce ptrace_task_may_access_current
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, apparmor@lists.ubuntu.com, "selinux@tycho.nsa.gov Stephen Smalley" <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>, John Johansen <john.johansen@canonical.com>, kernel-hardening@lists.openwall.comStephen Smalley <sds@tycho.nsa.gov>, serge@hallyn.com
List-ID: <kernel-hardening.lists.openwall.com>

Ahhhh, I feel so unhappy with capability code these days.  Serge can you 
come to the rescue?  I'm really really starting to dislike the fact that 
we have lots of code flows that goes 
kernel->kernel/capablities->LSM->security/capabilities.  Which is a very 
strange calling convention.  I'd like to stop adding any calls to 
kernel/capability.c and everything from now on needs to be done with an 
LSM function named security_*.  I'd really like to see 
kernel/capabilities stripped back to nothing but syscall handling and 
move all of has_capability, has_ns_capability, ns_capable, 
task_ns_capable, and all that crap moved to normal LSM calls.  (I'm 
happy to leave just 'capable' as it's been around way to long and is 
used 1000's of places, but we should stop adding new calls to it as well 
in my mind)

serge even if you disagree with all of that, you are definitely going to 
need to review the capability changes added here.  Personally I'd like 
to see all of the capability changes done as a separate patch from the 
ptrace changes.

On 06/17/2011 01:11 PM, Vasiliy Kulikov wrote:
> This patch adds ptrace_task_may_access_current() function.  It behaves
> like ptrace_may_access(), but checks whether a specific task may ptrace
> current.  The patch adds some new *capable*() functions with additional
> task argument (instead of default current task_struct).  It also changes
> security_ops->ptrace_access_check() by adding new argument and fixing
> related LSM handlers in SELinux, AppArmor and SMACK.
>
> v2 - renamed ptrace_access_check() back, added missing functions in
>       headers, introduced actual ptrace_task_may_access_current().
>
> Signed-off-by: Vasiliy Kulikov<segoon@openwall.com>
> ---
>   include/linux/capability.h    |    2 ++
>   include/linux/ptrace.h        |    3 ++-
>   include/linux/security.h      |   31 +++++++++++++++++++++++++++----
>   kernel/capability.c           |   35 +++++++++++++++++++++++++----------
>   kernel/ptrace.c               |   30 +++++++++++++++++++++++-------
>   security/apparmor/lsm.c       |    8 ++++----
>   security/commoncap.c          |    7 ++++---
>   security/security.c           |   17 ++++++++++++++---
>   security/selinux/hooks.c      |   11 +++++------
>   security/smack/smack.h        |    1 +
>   security/smack/smack_access.c |   25 +++++++++++++++++++++----
>   security/smack/smack_lsm.c    |    7 ++++---
>   12 files changed, 132 insertions(+), 45 deletions(-)
>
> ---
> diff --git a/include/linux/capability.h b/include/linux/capability.h
> index c421123..cc0bcfe 100644
> --- a/include/linux/capability.h
> +++ b/include/linux/capability.h
> @@ -544,7 +544,9 @@ extern bool has_ns_capability(struct task_struct *t,
>   			      struct user_namespace *ns, int cap);
>   extern bool has_capability_noaudit(struct task_struct *t, int cap);
>   extern bool capable(int cap);
> +extern bool task_capable(struct task_struct *task, int cap);
>   extern bool ns_capable(struct user_namespace *ns, int cap);
> +extern bool ns_task_capable(struct task_struct *t, struct user_namespace *ns, int cap);
>   extern bool task_ns_capable(struct task_struct *t, int cap);

now we have ns_task_capable() and task_ns_capable() ?  What is the 
difference?  Why do I have 2?  Which one do I choose where?

>   extern bool nsown_capable(int cap);
>
> diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
> index 9178d5c..bb59e43 100644
> --- a/include/linux/ptrace.h
> +++ b/include/linux/ptrace.h
> @@ -116,9 +116,10 @@ extern void exit_ptrace(struct task_struct *tracer);
>   #define PTRACE_MODE_READ   1
>   #define PTRACE_MODE_ATTACH 2
>   /* Returns 0 on success, -errno on denial. */
> -extern int __ptrace_may_access(struct task_struct *task, unsigned int mode);
> +extern int __ptrace_may_access(struct task_struct *who, struct task_struct *task, unsigned int mode);
>   /* Returns true on success, false on denial. */
>   extern bool ptrace_may_access(struct task_struct *task, unsigned int mode);
> +extern bool ptrace_task_may_access_current(struct task_struct *task, unsigned int mode);
>
>   static inline int ptrace_reparented(struct task_struct *child)
>   {
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 8ce59ef..fb79dd5 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -56,7 +56,8 @@ struct user_namespace;
>   extern int cap_capable(struct task_struct *tsk, const struct cred *cred,
>   		       struct user_namespace *ns, int cap, int audit);
>   extern int cap_settime(const struct timespec *ts, const struct timezone *tz);
> -extern int cap_ptrace_access_check(struct task_struct *child, unsigned int mode);
> +extern int cap_ptrace_access_check(struct task_struct *task, struct task_struct *child,
> +	unsigned int mode);
>   extern int cap_ptrace_traceme(struct task_struct *parent);
>   extern int cap_capget(struct task_struct *target, kernel_cap_t *effective, kernel_cap_t *inheritable, kernel_cap_t *permitted);
>   extern int cap_capset(struct cred *new, const struct cred *old,
> @@ -1375,7 +1376,9 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
>   struct security_operations {
>   	char name[SECURITY_NAME_MAX + 1];
>
> -	int (*ptrace_access_check) (struct task_struct *child, unsigned int mode);
> +	int (*ptrace_access_check) (struct task_struct *task,
> +					 struct task_struct *child,
> +					 unsigned int mode);

formatting nit, this patch lines up args, it doesn't just use tabs for 
the 2nd/3rd line.

>   	int (*ptrace_traceme) (struct task_struct *parent);
>   	int (*capget) (struct task_struct *target,
>   		       kernel_cap_t *effective,
> @@ -1657,6 +1660,8 @@ extern int security_module_enable(struct security_operations *ops);
>   extern int register_security(struct security_operations *ops);
>
>   /* Security operations */
> +int security_ptrace_task_access_check(struct task_struct *task,
> +		 struct task_struct *child, unsigned int mode);

I thought we agreed to not add a new ptrace_task_access_check(), just 
fix security_ptrace_access_check() to take the new argument.

>   int security_ptrace_access_check(struct task_struct *child, unsigned int mode);
>   int security_ptrace_traceme(struct task_struct *parent);
>   int security_capget(struct task_struct *target,
> @@ -1667,6 +1672,10 @@ int security_capset(struct cred *new, const struct cred *old,
>   		    const kernel_cap_t *effective,
>   		    const kernel_cap_t *inheritable,
>   		    const kernel_cap_t *permitted);
> +int security_task_capable(struct task_struct *task,
> +			struct user_namespace *ns,
> +			const struct cred *cred,
> +			int cap);

Personally I don't love this either and think we should just redefine 
security_capable.

>   int security_capable(struct user_namespace *ns, const struct cred *cred,
>   			int cap);
>   int security_real_capable(struct task_struct *tsk, struct user_namespace *ns,
> @@ -1837,10 +1846,16 @@ static inline int security_init(void)
>   	return 0;
>   }
>
> +static inline int security_ptrace_task_access_check(struct task_struct *task,
> +		 struct task_struct *child, unsigned int mode)
> +{
> +	return cap_ptrace_access_check(task, child, mode);
> +}
> +
>   static inline int security_ptrace_access_check(struct task_struct *child,
>   					     unsigned int mode)
>   {
> -	return cap_ptrace_access_check(child, mode);
> +	return cap_ptrace_access_check(current, child, mode);
>   }

Lets not introduce security_ptrace_task_access_check() at all.  Just add 
the new argument to security_ptrace_access_check() and fix the single 
caller (it looks to me like  security_ptrace_access_check() has no users 
after this patch)

>
>   static inline int security_ptrace_traceme(struct task_struct *parent)
> @@ -1865,10 +1880,18 @@ static inline int security_capset(struct cred *new,
>   	return cap_capset(new, old, effective, inheritable, permitted);
>   }
>
> +static inline int security_task_capable(struct task_struct *task,
> +					struct user_namespace *ns,
> +					const struct cred *cred,
> +					int cap)
> +{
> +	return cap_capable(task, cred, ns, cap, SECURITY_CAP_AUDIT);
> +}
> +
>   static inline int security_capable(struct user_namespace *ns,
>   				   const struct cred *cred, int cap)
>   {
> -	return cap_capable(current, cred, ns, cap, SECURITY_CAP_AUDIT);
> +	return security_task_capable(current, ns, cred, cap);
>   }

There is only one caller of security_capable outside in the kernel.  Can 
we just add the task argument rather than make a new function?  Even if 
you want to retain security_capable, define it exactly like this up 
where you declared the function and remove it everywhere else in the 
code base.
>   static inline int security_real_capable(struct task_struct *tsk, struct user_namespace *ns, int cap)
> diff --git a/kernel/capability.c b/kernel/capability.c
> index 283c529..bc9b07f 100644
> --- a/kernel/capability.c
> +++ b/kernel/capability.c
> @@ -356,6 +356,30 @@ bool capable(int cap)
>   }
>   EXPORT_SYMBOL(capable);
>
> +bool task_capable(struct task_struct *task, int cap)
> +{
> +	return ns_task_capable(task,&init_user_ns, cap);
> +}
> +EXPORT_SYMBOL(task_capable);

Why do we keep adding things like task_capable?  Can't we just stop 
adding non-lsm functions and just call the right LSM functions from now 
on?  This is my original comments mostly directed at Serge.  I'm to the 
point where I want to NAK anything new in kernel/capability.c (and yes, 
I know i'm guilty in the paste)

> +bool ns_task_capable(struct task_struct *task, struct user_namespace *ns, int cap)
> +{
> +	if (unlikely(!cap_valid(cap))) {
> +		printk(KERN_CRIT "capable() called with invalid cap=%u\n", cap);
> +		BUG();
> +	}
> +
> +	rcu_read_lock();
> +	if (security_task_capable(task, ns, __task_cred(task), cap) == 0) {
> +		rcu_read_unlock();
> +		current->flags |= PF_SUPERPRIV;
> +		return true;
> +	}
> +	rcu_read_unlock();
> +	return false;
> +}
> +EXPORT_SYMBOL(ns_task_capable);

Ok, NAK.  I just can' stomache having a ns_task_capable() and a 
task_ns_capable().  One of them has to be wrong.

> +
>   /**
>    * ns_capable - Determine if the current task has a superior capability in effect
>    * @ns:  The usernamespace we want the capability in
> @@ -369,16 +393,7 @@ EXPORT_SYMBOL(capable);
>    */
>   bool ns_capable(struct user_namespace *ns, int cap)
>   {
> -	if (unlikely(!cap_valid(cap))) {
> -		printk(KERN_CRIT "capable() called with invalid cap=%u\n", cap);
> -		BUG();
> -	}
> -
> -	if (security_capable(ns, current_cred(), cap) == 0) {
> -		current->flags |= PF_SUPERPRIV;
> -		return true;
> -	}
> -	return false;
> +	return ns_task_capable(current, ns, cap);
>   }
>   EXPORT_SYMBOL(ns_capable);
>
> diff --git a/kernel/ptrace.c b/kernel/ptrace.c
> index 2df1157..df8fe32 100644
> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -132,9 +132,9 @@ int ptrace_check_attach(struct task_struct *child, int kill)
>   	return ret;
>   }
>
> -int __ptrace_may_access(struct task_struct *task, unsigned int mode)
> +int __ptrace_may_access(struct task_struct *who, struct task_struct *task, unsigned int mode)
>   {
> -	const struct cred *cred = current_cred(), *tcred;
> +	const struct cred *cred, *tcred;
>
>   	/* May we inspect the given task?
>   	 * This check is used both for attaching with ptrace
> @@ -149,6 +149,7 @@ int __ptrace_may_access(struct task_struct *task, unsigned int mode)
>   	if (task == current)
>   		return 0;
>   	rcu_read_lock();
> +	cred = __task_cred(who);
>   	tcred = __task_cred(task);
>   	if (cred->user->user_ns == tcred->user->user_ns&&
>   	(cred->uid == tcred->euid&&
> @@ -158,7 +159,7 @@ int __ptrace_may_access(struct task_struct *task, unsigned int mode)
>   	     cred->gid == tcred->sgid&&
>   	cred->gid == tcred->gid))
>   		goto ok;
> -	if (ns_capable(tcred->user->user_ns, CAP_SYS_PTRACE))
> +	if (ns_task_capable(who, tcred->user->user_ns, CAP_SYS_PTRACE))
>   		goto ok;
>   	rcu_read_unlock();
>   	return -EPERM;
> @@ -167,17 +168,32 @@ ok:
>   	smp_rmb();
>   	if (task->mm)
>   		dumpable = get_dumpable(task->mm);
> -	if (!dumpable&&  !task_ns_capable(task, CAP_SYS_PTRACE))
> +	if (!dumpable&&
> +	    !ns_task_capable(who, task_cred_xxx(task, user)->user_ns,
> +		 CAP_SYS_PTRACE))
>   		return -EPERM;
>
> -	return security_ptrace_access_check(task, mode);
> +	return security_ptrace_task_access_check(who, task, mode);
>   }
>
>   bool ptrace_may_access(struct task_struct *task, unsigned int mode)
>   {
>   	int err;
>   	task_lock(task);
> -	err = __ptrace_may_access(task, mode);
> +	err = __ptrace_may_access(current, task, mode);
> +	task_unlock(task);
> +	return !err;
> +}
> +
> +/*
> + * Generic task_may_access_task cannot be implemented because we have to
> + * hold task_locks of both tasks.  It would lead to a deadlock.
> + */
> +bool ptrace_task_may_access_current(struct task_struct *task, unsigned int mode)
> +{
> +	int err;
> +	task_lock(task);
> +	err = __ptrace_may_access(task, current, mode);
>   	task_unlock(task);
>   	return !err;
>   }
> @@ -205,7 +221,7 @@ static int ptrace_attach(struct task_struct *task)
>   		goto out;
>
>   	task_lock(task);
> -	retval = __ptrace_may_access(task, PTRACE_MODE_ATTACH);
> +	retval = __ptrace_may_access(current, task, PTRACE_MODE_ATTACH);
>   	task_unlock(task);
>   	if (retval)
>   		goto unlock_creds;
> diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
> index ec1bcec..dc3a4aa 100644
> --- a/security/apparmor/lsm.c
> +++ b/security/apparmor/lsm.c
> @@ -93,14 +93,14 @@ static void apparmor_cred_transfer(struct cred *new, const struct cred *old)
>   	aa_dup_task_context(new_cxt, old_cxt);
>   }
>
> -static int apparmor_ptrace_access_check(struct task_struct *child,
> -					unsigned int mode)
> +static int apparmor_ptrace_access_check(struct task_struct *task,
> +			    struct task_struct *child, unsigned int mode)
>   {
> -	int error = cap_ptrace_access_check(child, mode);
> +	int error = cap_ptrace_access_check(task, child, mode);
>   	if (error)
>   		return error;
>
> -	return aa_ptrace(current, child, mode);
> +	return aa_ptrace(task, child, mode);
>   }
>
>   static int apparmor_ptrace_traceme(struct task_struct *parent)
> diff --git a/security/commoncap.c b/security/commoncap.c
> index a93b3b7..31ca991 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -136,18 +136,19 @@ int cap_settime(const struct timespec *ts, const struct timezone *tz)
>    * Determine whether a process may access another, returning 0 if permission
>    * granted, -ve if denied.
>    */
> -int cap_ptrace_access_check(struct task_struct *child, unsigned int mode)
> +int cap_ptrace_access_check(struct task_struct *task, struct task_struct *child,
> +	unsigned int mode)
>   {
>   	int ret = 0;
>   	const struct cred *cred, *child_cred;
>
>   	rcu_read_lock();
> -	cred = current_cred();
> +	cred = __task_cred(task);
>   	child_cred = __task_cred(child);
>   	if (cred->user->user_ns == child_cred->user->user_ns&&
>   	cap_issubset(child_cred->cap_permitted, cred->cap_permitted))
>   		goto out;
> -	if (ns_capable(child_cred->user->user_ns, CAP_SYS_PTRACE))
> +	if (ns_task_capable(task, child_cred->user->user_ns, CAP_SYS_PTRACE))
>   		goto out;
>   	ret = -EPERM;
>   out:
> diff --git a/security/security.c b/security/security.c
> index 4ba6d4c..0760e81 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -127,9 +127,15 @@ int __init register_security(struct security_operations *ops)
>
>   /* Security operations */
>
> +int security_ptrace_task_access_check(struct task_struct *task,
> +		 struct task_struct *child, unsigned int mode)
> +{
> +	return security_ops->ptrace_access_check(task, child, mode);
> +}
> +
>   int security_ptrace_access_check(struct task_struct *child, unsigned int mode)
>   {
> -	return security_ops->ptrace_access_check(child, mode);
> +	return security_ops->ptrace_access_check(current, child, mode);
>   }
>
>   int security_ptrace_traceme(struct task_struct *parent)
> @@ -154,11 +160,16 @@ int security_capset(struct cred *new, const struct cred *old,
>   				    effective, inheritable, permitted);
>   }
>
> +int security_task_capable(struct task_struct *task, struct user_namespace *ns,
> +	const struct cred *cred, int cap)
> +{
> +	return security_ops->capable(task, cred, ns, cap, SECURITY_CAP_AUDIT);
> +}
> +
>   int security_capable(struct user_namespace *ns, const struct cred *cred,
>   		     int cap)
>   {
> -	return security_ops->capable(current, cred, ns, cap,
> -				     SECURITY_CAP_AUDIT);
> +	return security_task_capable(current, ns, cred, cap);
>   }
>
>   int security_real_capable(struct task_struct *tsk, struct user_namespace *ns,
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 20219ef..0130255 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -1804,23 +1804,22 @@ static inline u32 open_file_to_av(struct file *file)
>   }
>
>   /* Hook functions begin here. */
> -
> -static int selinux_ptrace_access_check(struct task_struct *child,
> -				     unsigned int mode)
> +static int selinux_ptrace_access_check(struct task_struct *task,
> +		struct task_struct *child, unsigned int mode)
>   {
>   	int rc;
>
> -	rc = cap_ptrace_access_check(child, mode);
> +	rc = cap_ptrace_access_check(task, child, mode);
>   	if (rc)
>   		return rc;
>
>   	if (mode == PTRACE_MODE_READ) {
> -		u32 sid = current_sid();
> +		u32 sid = task_sid(task);
>   		u32 csid = task_sid(child);
>   		return avc_has_perm(sid, csid, SECCLASS_FILE, FILE__READ, NULL);
>   	}
>
> -	return current_has_perm(child, PROCESS__PTRACE);
> +	return task_has_perm(task, child, PROCESS__PTRACE);
>   }
>
>   static int selinux_ptrace_traceme(struct task_struct *parent)
> diff --git a/security/smack/smack.h b/security/smack/smack.h
> index 2b6c6a5..4d9fb0f 100644
> --- a/security/smack/smack.h
> +++ b/security/smack/smack.h
> @@ -199,6 +199,7 @@ struct inode_smack *new_inode_smack(char *);
>    */
>   int smk_access_entry(char *, char *, struct list_head *);
>   int smk_access(char *, char *, int, struct smk_audit_info *);
> +int smk_taskacc(struct task_struct *, char *, u32, struct smk_audit_info *);
>   int smk_curacc(char *, u32, struct smk_audit_info *);
>   int smack_to_cipso(const char *, struct smack_cipso *);
>   void smack_from_cipso(u32, char *, char *);
> diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
> index 9637e10..766dccd 100644
> --- a/security/smack/smack_access.c
> +++ b/security/smack/smack_access.c
> @@ -201,7 +201,8 @@ out_audit:
>   }
>
>   /**
> - * smk_curacc - determine if current has a specific access to an object
> + * smk_curacc - determine if subject has a specific access to an object
> + * @task: a pointer to the subject's task struct
>    * @obj_label: a pointer to the object's Smack label
>    * @mode: the access requested, in "MAY" format
>    * @a : common audit data
> @@ -211,9 +212,9 @@ out_audit:
>    * non zero otherwise. It allows that current may have the capability
>    * to override the rules.
>    */
> -int smk_curacc(char *obj_label, u32 mode, struct smk_audit_info *a)
> +int smk_taskacc(struct task_struct *task, char *obj_label, u32 mode, struct smk_audit_info *a)
>   {
> -	struct task_smack *tsp = current_security();
> +	struct task_smack *tsp = task_cred_xxx(task, security);
>   	char *sp = smk_of_task(tsp);
>   	int may;
>   	int rc;
> @@ -243,7 +244,7 @@ int smk_curacc(char *obj_label, u32 mode, struct smk_audit_info *a)
>   	if (smack_onlycap != NULL&&  smack_onlycap != sp)
>   		goto out_audit;
>
> -	if (capable(CAP_MAC_OVERRIDE))
> +	if (task_capable(task, CAP_MAC_OVERRIDE))
>   		rc = 0;
>
>   out_audit:
> @@ -254,6 +255,22 @@ out_audit:
>   	return rc;
>   }
>
> +/**
> + * smk_curacc - determine if current has a specific access to an object
> + * @obj_label: a pointer to the object's Smack label
> + * @mode: the access requested, in "MAY" format
> + * @a : common audit data
> + *
> + * This function checks the current subject label/object label pair
> + * in the access rule list and returns 0 if the access is permitted,
> + * non zero otherwise. It allows that current may have the capability
> + * to override the rules.
> + */
> +int smk_curacc(char *obj_label, u32 mode, struct smk_audit_info *a)
> +{
> +	return smk_taskacc(current, obj_label, mode, a);
> +}
> +
>   #ifdef CONFIG_AUDIT
>   /**
>    * smack_str_from_perm : helper to transalate an int to a
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 9831a39..ee1c5cb 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -149,13 +149,14 @@ static int smk_copy_rules(struct list_head *nhead, struct list_head *ohead,
>    *
>    * Do the capability checks, and require read and write.
>    */
> -static int smack_ptrace_access_check(struct task_struct *ctp, unsigned int mode)
> +static int smack_ptrace_access_check(struct task_struct *task,
> +			struct task_struct *ctp, unsigned int mode)
>   {
>   	int rc;
>   	struct smk_audit_info ad;
>   	char *tsp;
>
> -	rc = cap_ptrace_access_check(ctp, mode);
> +	rc = cap_ptrace_access_check(task, ctp, mode);
>   	if (rc != 0)
>   		return rc;
>
> @@ -163,7 +164,7 @@ static int smack_ptrace_access_check(struct task_struct *ctp, unsigned int mode)
>   	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
>   	smk_ad_setfield_u_tsk(&ad, ctp);
>
> -	rc = smk_curacc(tsp, MAY_READWRITE,&ad);
> +	rc = smk_taskacc(task, tsp, MAY_READWRITE,&ad);
>   	return rc;
>   }
>
> ---
