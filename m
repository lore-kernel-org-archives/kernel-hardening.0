Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 20 Jun 2011 18:40:35 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110620144035.GB11750@albatros>
References: <20110617171152.GA1389@albatros>
 <4DFF5795.9080609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFF5795.9080609@redhat.com>
Subject: [kernel-hardening] Re: [RFC v2] security: intoduce ptrace_task_may_access_current
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, apparmor@lists.ubuntu.com, "selinux@tycho.nsa.gov Stephen Smalley" <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>, John Johansen <john.johansen@canonical.com>, kernel-hardening@lists.openwall.com, serge@hallyn.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Eric,

On Mon, Jun 20, 2011 at 10:22 -0400, Eric Paris wrote:
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

Hmmm, agreed, I didn't spot it.

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

OK.

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

I did it for security ops, will do it for security_ptrace_access_check()
too.

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

OK.

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

OK.

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

OK.

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

(fixing my 2 copy-paste bugs, here and below)
s/current/task/

> >+		return true;
> >+	}
> >+	rcu_read_unlock();
> >+	return false;
> >+}
> >+EXPORT_SYMBOL(ns_task_capable);
> 
> Ok, NAK.  I just can' stomache having a ns_task_capable() and a
> task_ns_capable().  One of them has to be wrong.

I'm a bit confused with numerous capable funtions too, but I thought
they are needed for some abstraction level.  I'll remove ns_task_capable().

> >+
> >  /**
> >   * ns_capable - Determine if the current task has a superior capability in effect
> >   * @ns:  The usernamespace we want the capability in
> >@@ -369,16 +393,7 @@ EXPORT_SYMBOL(capable);
> >   */
> >  bool ns_capable(struct user_namespace *ns, int cap)
> >  {
> >-	if (unlikely(!cap_valid(cap))) {
> >-		printk(KERN_CRIT "capable() called with invalid cap=%u\n", cap);
> >-		BUG();
> >-	}
> >-
> >-	if (security_capable(ns, current_cred(), cap) == 0) {
> >-		current->flags |= PF_SUPERPRIV;
> >-		return true;
> >-	}
> >-	return false;
> >+	return ns_task_capable(current, ns, cap);
> >  }
> >  EXPORT_SYMBOL(ns_capable);
> >
> >diff --git a/kernel/ptrace.c b/kernel/ptrace.c
> >index 2df1157..df8fe32 100644
> >--- a/kernel/ptrace.c
> >+++ b/kernel/ptrace.c
> >@@ -132,9 +132,9 @@ int ptrace_check_attach(struct task_struct *child, int kill)
> >  	return ret;
> >  }
> >
> >-int __ptrace_may_access(struct task_struct *task, unsigned int mode)
> >+int __ptrace_may_access(struct task_struct *who, struct task_struct *task, unsigned int mode)
> >  {
> >-	const struct cred *cred = current_cred(), *tcred;
> >+	const struct cred *cred, *tcred;
> >
> >  	/* May we inspect the given task?
> >  	 * This check is used both for attaching with ptrace
> >@@ -149,6 +149,7 @@ int __ptrace_may_access(struct task_struct *task, unsigned int mode)
> >  	if (task == current)

s/current/who/


-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
