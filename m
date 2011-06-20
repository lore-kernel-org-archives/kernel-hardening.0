Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 20 Jun 2011 10:00:01 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
Message-ID: <20110620150001.GF12469@mail.hallyn.com>
References: <20110617171152.GA1389@albatros>
 <4DFF5795.9080609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFF5795.9080609@redhat.com>
Subject: [kernel-hardening] Re: [RFC v2] security: intoduce ptrace_task_may_access_current
To: Eric Paris <eparis@redhat.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, apparmor@lists.ubuntu.com, "selinux@tycho.nsa.gov Stephen Smalley" <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>, John Johansen <john.johansen@canonical.com>, kernel-hardening@lists.openwall.com, serge@hallyn.com
List-ID: <kernel-hardening.lists.openwall.com>

Quoting Eric Paris (eparis@redhat.com):
> Ahhhh, I feel so unhappy with capability code these days.  Serge can
> you come to the rescue?  I'm really really starting to dislike the
> fact that we have lots of code flows that goes
> kernel->kernel/capablities->LSM->security/capabilities.  Which is a
> very strange calling convention.  I'd like to stop adding any calls
> to kernel/capability.c and everything from now on needs to be done
> with an LSM function named security_*.  I'd really like to see
> kernel/capabilities stripped back to nothing but syscall handling
> and move all of has_capability, has_ns_capability, ns_capable,
> task_ns_capable, and all that crap moved to normal LSM calls.

I can see why you'd feel that way, but I'd like to hold off on that
until we get targeted capabilities and VFS user namespace support ironed
out.  I'm working on it right now (at
http://kernel.ubuntu.com/git?p=serge/userns-2.6.git;a=summary)

I certainly do not want the targeted stuff duplicated in every LSM.
Maybe we can move that stuff into security/security.c though.

Anyway I'm just coming back after leave, and only ever took a
quick glance at this patch.  I'll look again.

> (I'm
> happy to leave just 'capable' as it's been around way to long and is
> used 1000's of places, but we should stop adding new calls to it as
> well in my mind)
> 
> serge even if you disagree with all of that, you are definitely
> going to need to review the capability changes added here.
> Personally I'd like to see all of the capability changes done as a
> separate patch from the ptrace changes.
> 
> On 06/17/2011 01:11 PM, Vasiliy Kulikov wrote:
> >This patch adds ptrace_task_may_access_current() function.  It behaves
> >like ptrace_may_access(), but checks whether a specific task may ptrace
> >current.  The patch adds some new *capable*() functions with additional
> >task argument (instead of default current task_struct).  It also changes
> >security_ops->ptrace_access_check() by adding new argument and fixing
> >related LSM handlers in SELinux, AppArmor and SMACK.
> >
> >v2 - renamed ptrace_access_check() back, added missing functions in
> >      headers, introduced actual ptrace_task_may_access_current().
> >
> >Signed-off-by: Vasiliy Kulikov<segoon@openwall.com>
> >---
> >  include/linux/capability.h    |    2 ++
> >  include/linux/ptrace.h        |    3 ++-
> >  include/linux/security.h      |   31 +++++++++++++++++++++++++++----
> >  kernel/capability.c           |   35 +++++++++++++++++++++++++----------
> >  kernel/ptrace.c               |   30 +++++++++++++++++++++++-------
> >  security/apparmor/lsm.c       |    8 ++++----
> >  security/commoncap.c          |    7 ++++---
> >  security/security.c           |   17 ++++++++++++++---
> >  security/selinux/hooks.c      |   11 +++++------
> >  security/smack/smack.h        |    1 +
> >  security/smack/smack_access.c |   25 +++++++++++++++++++++----
> >  security/smack/smack_lsm.c    |    7 ++++---
> >  12 files changed, 132 insertions(+), 45 deletions(-)
> >
> >---
> >diff --git a/include/linux/capability.h b/include/linux/capability.h
> >index c421123..cc0bcfe 100644
> >--- a/include/linux/capability.h
> >+++ b/include/linux/capability.h
> >@@ -544,7 +544,9 @@ extern bool has_ns_capability(struct task_struct *t,
> >  			      struct user_namespace *ns, int cap);
> >  extern bool has_capability_noaudit(struct task_struct *t, int cap);
> >  extern bool capable(int cap);
> >+extern bool task_capable(struct task_struct *task, int cap);
> >  extern bool ns_capable(struct user_namespace *ns, int cap);
> >+extern bool ns_task_capable(struct task_struct *t, struct user_namespace *ns, int cap);
> >  extern bool task_ns_capable(struct task_struct *t, int cap);
> 
> now we have ns_task_capable() and task_ns_capable() ?  What is the
> difference?  Why do I have 2?  Which one do I choose where?
> 
> >  extern bool nsown_capable(int cap);
> >
> >diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
> >index 9178d5c..bb59e43 100644
> >--- a/include/linux/ptrace.h
> >+++ b/include/linux/ptrace.h
> >@@ -116,9 +116,10 @@ extern void exit_ptrace(struct task_struct *tracer);
> >  #define PTRACE_MODE_READ   1
> >  #define PTRACE_MODE_ATTACH 2
> >  /* Returns 0 on success, -errno on denial. */
> >-extern int __ptrace_may_access(struct task_struct *task, unsigned int mode);
> >+extern int __ptrace_may_access(struct task_struct *who, struct task_struct *task, unsigned int mode);
> >  /* Returns true on success, false on denial. */
> >  extern bool ptrace_may_access(struct task_struct *task, unsigned int mode);
> >+extern bool ptrace_task_may_access_current(struct task_struct *task, unsigned int mode);
> >
> >  static inline int ptrace_reparented(struct task_struct *child)
> >  {
> >diff --git a/include/linux/security.h b/include/linux/security.h
> >index 8ce59ef..fb79dd5 100644
> >--- a/include/linux/security.h
> >+++ b/include/linux/security.h
> >@@ -56,7 +56,8 @@ struct user_namespace;
> >  extern int cap_capable(struct task_struct *tsk, const struct cred *cred,
> >  		       struct user_namespace *ns, int cap, int audit);
> >  extern int cap_settime(const struct timespec *ts, const struct timezone *tz);
> >-extern int cap_ptrace_access_check(struct task_struct *child, unsigned int mode);
> >+extern int cap_ptrace_access_check(struct task_struct *task, struct task_struct *child,
> >+	unsigned int mode);
> >  extern int cap_ptrace_traceme(struct task_struct *parent);
> >  extern int cap_capget(struct task_struct *target, kernel_cap_t *effective, kernel_cap_t *inheritable, kernel_cap_t *permitted);
> >  extern int cap_capset(struct cred *new, const struct cred *old,
> >@@ -1375,7 +1376,9 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
> >  struct security_operations {
> >  	char name[SECURITY_NAME_MAX + 1];
> >
> >-	int (*ptrace_access_check) (struct task_struct *child, unsigned int mode);
> >+	int (*ptrace_access_check) (struct task_struct *task,
> >+					 struct task_struct *child,
> >+					 unsigned int mode);
> 
> formatting nit, this patch lines up args, it doesn't just use tabs
> for the 2nd/3rd line.
> 
> >  	int (*ptrace_traceme) (struct task_struct *parent);
> >  	int (*capget) (struct task_struct *target,
> >  		       kernel_cap_t *effective,
> >@@ -1657,6 +1660,8 @@ extern int security_module_enable(struct security_operations *ops);
> >  extern int register_security(struct security_operations *ops);
> >
> >  /* Security operations */
> >+int security_ptrace_task_access_check(struct task_struct *task,
> >+		 struct task_struct *child, unsigned int mode);
> 
> I thought we agreed to not add a new ptrace_task_access_check(),
> just fix security_ptrace_access_check() to take the new argument.
> 
> >  int security_ptrace_access_check(struct task_struct *child, unsigned int mode);
> >  int security_ptrace_traceme(struct task_struct *parent);
> >  int security_capget(struct task_struct *target,
> >@@ -1667,6 +1672,10 @@ int security_capset(struct cred *new, const struct cred *old,
> >  		    const kernel_cap_t *effective,
> >  		    const kernel_cap_t *inheritable,
> >  		    const kernel_cap_t *permitted);
> >+int security_task_capable(struct task_struct *task,
> >+			struct user_namespace *ns,
> >+			const struct cred *cred,
> >+			int cap);
> 
> Personally I don't love this either and think we should just
> redefine security_capable.
> 
> >  int security_capable(struct user_namespace *ns, const struct cred *cred,
> >  			int cap);
> >  int security_real_capable(struct task_struct *tsk, struct user_namespace *ns,
> >@@ -1837,10 +1846,16 @@ static inline int security_init(void)
> >  	return 0;
> >  }
> >
> >+static inline int security_ptrace_task_access_check(struct task_struct *task,
> >+		 struct task_struct *child, unsigned int mode)
> >+{
> >+	return cap_ptrace_access_check(task, child, mode);
> >+}
> >+
> >  static inline int security_ptrace_access_check(struct task_struct *child,
> >  					     unsigned int mode)
> >  {
> >-	return cap_ptrace_access_check(child, mode);
> >+	return cap_ptrace_access_check(current, child, mode);
> >  }
> 
> Lets not introduce security_ptrace_task_access_check() at all.  Just
> add the new argument to security_ptrace_access_check() and fix the
> single caller (it looks to me like  security_ptrace_access_check()
> has no users after this patch)
> 
> >
> >  static inline int security_ptrace_traceme(struct task_struct *parent)
> >@@ -1865,10 +1880,18 @@ static inline int security_capset(struct cred *new,
> >  	return cap_capset(new, old, effective, inheritable, permitted);
> >  }
> >
> >+static inline int security_task_capable(struct task_struct *task,
> >+					struct user_namespace *ns,
> >+					const struct cred *cred,
> >+					int cap)
> >+{
> >+	return cap_capable(task, cred, ns, cap, SECURITY_CAP_AUDIT);
> >+}
> >+
> >  static inline int security_capable(struct user_namespace *ns,
> >  				   const struct cred *cred, int cap)
> >  {
> >-	return cap_capable(current, cred, ns, cap, SECURITY_CAP_AUDIT);
> >+	return security_task_capable(current, ns, cred, cap);
> >  }
> 
> There is only one caller of security_capable outside in the kernel.
> Can we just add the task argument rather than make a new function?
> Even if you want to retain security_capable, define it exactly like
> this up where you declared the function and remove it everywhere
> else in the code base.
> >  static inline int security_real_capable(struct task_struct *tsk, struct user_namespace *ns, int cap)
> >diff --git a/kernel/capability.c b/kernel/capability.c
> >index 283c529..bc9b07f 100644
> >--- a/kernel/capability.c
> >+++ b/kernel/capability.c
> >@@ -356,6 +356,30 @@ bool capable(int cap)
> >  }
> >  EXPORT_SYMBOL(capable);
> >
> >+bool task_capable(struct task_struct *task, int cap)
> >+{
> >+	return ns_task_capable(task,&init_user_ns, cap);
> >+}
> >+EXPORT_SYMBOL(task_capable);
> 
> Why do we keep adding things like task_capable?  Can't we just stop
> adding non-lsm functions and just call the right LSM functions from
> now on?  This is my original comments mostly directed at Serge.  I'm
> to the point where I want to NAK anything new in kernel/capability.c
> (and yes, I know i'm guilty in the paste)
> 
> >+bool ns_task_capable(struct task_struct *task, struct user_namespace *ns, int cap)

Can you just use has_ns_capability() at the places where you wanted to
use your new ns_task_capable()?  It won't set PF_SUPERPRIV, but you
can't set that on another task anyway IIRC.

Can you point to the user for this?

> >+{
> >+	if (unlikely(!cap_valid(cap))) {
> >+		printk(KERN_CRIT "capable() called with invalid cap=%u\n", cap);
> >+		BUG();
> >+	}
> >+
> >+	rcu_read_lock();
> >+	if (security_task_capable(task, ns, __task_cred(task), cap) == 0) {
> >+		rcu_read_unlock();
> >+		current->flags |= PF_SUPERPRIV;

You are setting current->flags, but aren't checking current's perms.
That is certainly wrong.

> >+		return true;
> >+	}
> >+	rcu_read_unlock();
> >+	return false;
> >+}
> >+EXPORT_SYMBOL(ns_task_capable);
