Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 20 Jun 2011 23:11:03 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110620191103.GA11121@albatros>
References: <20110620191007.GA10978@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110620191007.GA10978@albatros>
Subject: [kernel-hardening] [RFC v3 2/2] security: add ptrace_task_may_access_current()
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, apparmor@lists.ubuntu.com, "selinux@tycho.nsa.gov Stephen Smalley" <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>, John Johansen <john.johansen@canonical.com>, kernel-hardening@lists.openwall.com, serge@hallyn.com
List-ID: <kernel-hardening.lists.openwall.com>

ptrace_task_may_access_current() is needed to check whether another
process may ptrace current.  LSM hook and related functions now have
"tracer" as the first argument instead of implicit "current".

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 include/linux/ptrace.h        |    6 +++++-
 include/linux/security.h      |   22 +++++++++++++++-------
 kernel/ptrace.c               |   30 ++++++++++++++++++++++--------
 security/apparmor/lsm.c       |    7 ++++---
 security/commoncap.c          |    8 +++++---
 security/security.c           |    6 ++++--
 security/selinux/hooks.c      |   11 ++++++-----
 security/smack/smack.h        |    1 +
 security/smack/smack_access.c |   15 +++++++++++----
 security/smack/smack_lsm.c    |    9 ++++++---
 10 files changed, 79 insertions(+), 36 deletions(-)

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 9178d5c..e68ff58 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -116,9 +116,13 @@ extern void exit_ptrace(struct task_struct *tracer);
 #define PTRACE_MODE_READ   1
 #define PTRACE_MODE_ATTACH 2
 /* Returns 0 on success, -errno on denial. */
-extern int __ptrace_may_access(struct task_struct *task, unsigned int mode);
+extern int __ptrace_may_access(struct task_struct *tracer,
+			       struct task_struct *task,
+			       unsigned int mode);
 /* Returns true on success, false on denial. */
 extern bool ptrace_may_access(struct task_struct *task, unsigned int mode);
+extern bool ptrace_task_may_access_current(struct task_struct *task,
+					   unsigned int mode);
 
 static inline int ptrace_reparented(struct task_struct *child)
 {
diff --git a/include/linux/security.h b/include/linux/security.h
index 8509dbf..8998fd6 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -56,7 +56,9 @@ struct user_namespace;
 extern int cap_capable(struct task_struct *tsk, const struct cred *cred,
 		       struct user_namespace *ns, int cap, int audit);
 extern int cap_settime(const struct timespec *ts, const struct timezone *tz);
-extern int cap_ptrace_access_check(struct task_struct *child, unsigned int mode);
+extern int cap_ptrace_access_check(struct task_struct *tracer,
+				   struct task_struct *child,
+				   unsigned int mode);
 extern int cap_ptrace_traceme(struct task_struct *parent);
 extern int cap_capget(struct task_struct *target, kernel_cap_t *effective, kernel_cap_t *inheritable, kernel_cap_t *permitted);
 extern int cap_capset(struct cred *new, const struct cred *old,
@@ -1221,13 +1223,14 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	Return 0 if permission is granted.
  *
  * @ptrace_access_check:
- *	Check permission before allowing the current process to trace the
+ *	Check permission before allowing the @tracer process to trace the
  *	@child process.
  *	Security modules may also want to perform a process tracing check
  *	during an execve in the set_security or apply_creds hooks of
  *	tracing check during an execve in the bprm_set_creds hook of
  *	binprm_security_ops if the process is being traced and its security
  *	attributes would be changed by the execve.
+ *	@tracer contains the task_struct structure for the tracer process.
  *	@child contains the task_struct structure for the target process.
  *	@mode contains the PTRACE_MODE flags indicating the form of access.
  *	Return 0 if permission is granted.
@@ -1375,7 +1378,9 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
 struct security_operations {
 	char name[SECURITY_NAME_MAX + 1];
 
-	int (*ptrace_access_check) (struct task_struct *child, unsigned int mode);
+	int (*ptrace_access_check) (struct task_struct *tracer,
+				    struct task_struct *child,
+				    unsigned int mode);
 	int (*ptrace_traceme) (struct task_struct *parent);
 	int (*capget) (struct task_struct *target,
 		       kernel_cap_t *effective,
@@ -1657,7 +1662,9 @@ extern int security_module_enable(struct security_operations *ops);
 extern int register_security(struct security_operations *ops);
 
 /* Security operations */
-int security_ptrace_access_check(struct task_struct *child, unsigned int mode);
+int security_ptrace_access_check(struct task_struct *tracer,
+				 struct task_struct *child,
+				 unsigned int mode);
 int security_ptrace_traceme(struct task_struct *parent);
 int security_capget(struct task_struct *target,
 		    kernel_cap_t *effective,
@@ -1837,10 +1844,11 @@ static inline int security_init(void)
 	return 0;
 }
 
-static inline int security_ptrace_access_check(struct task_struct *child,
-					     unsigned int mode)
+static inline int security_ptrace_access_check(struct task_struct *tracer,
+					       struct task_struct *child,
+					       unsigned int mode)
 {
-	return cap_ptrace_access_check(child, mode);
+	return cap_ptrace_access_check(tracer, child, mode);
 }
 
 static inline int security_ptrace_traceme(struct task_struct *parent)
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 2df1157..7b40b24 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -132,9 +132,11 @@ int ptrace_check_attach(struct task_struct *child, int kill)
 	return ret;
 }
 
-int __ptrace_may_access(struct task_struct *task, unsigned int mode)
+int __ptrace_may_access(struct task_struct *tracer,
+			struct task_struct *task,
+			unsigned int mode)
 {
-	const struct cred *cred = current_cred(), *tcred;
+	const struct cred *cred, *tcred;
 
 	/* May we inspect the given task?
 	 * This check is used both for attaching with ptrace
@@ -146,9 +148,10 @@ int __ptrace_may_access(struct task_struct *task, unsigned int mode)
 	 */
 	int dumpable = 0;
 	/* Don't let security modules deny introspection */
-	if (task == current)
+	if (task == tracer)
 		return 0;
 	rcu_read_lock();
+	cred = __task_cred(tracer);
 	tcred = __task_cred(task);
 	if (cred->user->user_ns == tcred->user->user_ns &&
 	    (cred->uid == tcred->euid &&
@@ -158,7 +161,7 @@ int __ptrace_may_access(struct task_struct *task, unsigned int mode)
 	     cred->gid == tcred->sgid &&
 	     cred->gid == tcred->gid))
 		goto ok;
-	if (ns_capable(tcred->user->user_ns, CAP_SYS_PTRACE))
+	if (has_ns_capability(tracer, tcred->user->user_ns, CAP_SYS_PTRACE))
 		goto ok;
 	rcu_read_unlock();
 	return -EPERM;
@@ -167,17 +170,28 @@ ok:
 	smp_rmb();
 	if (task->mm)
 		dumpable = get_dumpable(task->mm);
-	if (!dumpable && !task_ns_capable(task, CAP_SYS_PTRACE))
+	if (!dumpable && !has_ns_capability(tracer,
+					    task_cred_xxx(task, user)->user_ns,
+					    CAP_SYS_PTRACE))
 		return -EPERM;
 
-	return security_ptrace_access_check(task, mode);
+	return security_ptrace_access_check(tracer, task, mode);
 }
 
 bool ptrace_may_access(struct task_struct *task, unsigned int mode)
 {
 	int err;
 	task_lock(task);
-	err = __ptrace_may_access(task, mode);
+	err = __ptrace_may_access(current, task, mode);
+	task_unlock(task);
+	return !err;
+}
+
+bool ptrace_task_may_access_current(struct task_struct *task, unsigned int mode)
+{
+	int err;
+	task_lock(task);
+	err = __ptrace_may_access(task, current, mode);
 	task_unlock(task);
 	return !err;
 }
@@ -205,7 +219,7 @@ static int ptrace_attach(struct task_struct *task)
 		goto out;
 
 	task_lock(task);
-	retval = __ptrace_may_access(task, PTRACE_MODE_ATTACH);
+	retval = __ptrace_may_access(current, task, PTRACE_MODE_ATTACH);
 	task_unlock(task);
 	if (retval)
 		goto unlock_creds;
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index ec1bcec..e78112a 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -93,14 +93,15 @@ static void apparmor_cred_transfer(struct cred *new, const struct cred *old)
 	aa_dup_task_context(new_cxt, old_cxt);
 }
 
-static int apparmor_ptrace_access_check(struct task_struct *child,
+static int apparmor_ptrace_access_check(struct task_struct *tracer,
+					struct task_struct *child,
 					unsigned int mode)
 {
-	int error = cap_ptrace_access_check(child, mode);
+	int error = cap_ptrace_access_check(tracer, child, mode);
 	if (error)
 		return error;
 
-	return aa_ptrace(current, child, mode);
+	return aa_ptrace(tracer, child, mode);
 }
 
 static int apparmor_ptrace_traceme(struct task_struct *parent)
diff --git a/security/commoncap.c b/security/commoncap.c
index a93b3b7..d02eb58 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -136,18 +136,20 @@ int cap_settime(const struct timespec *ts, const struct timezone *tz)
  * Determine whether a process may access another, returning 0 if permission
  * granted, -ve if denied.
  */
-int cap_ptrace_access_check(struct task_struct *child, unsigned int mode)
+int cap_ptrace_access_check(struct task_struct *tracer,
+			    struct task_struct *child,
+			    unsigned int mode)
 {
 	int ret = 0;
 	const struct cred *cred, *child_cred;
 
 	rcu_read_lock();
-	cred = current_cred();
+	cred = __task_cred(tracer);
 	child_cred = __task_cred(child);
 	if (cred->user->user_ns == child_cred->user->user_ns &&
 	    cap_issubset(child_cred->cap_permitted, cred->cap_permitted))
 		goto out;
-	if (ns_capable(child_cred->user->user_ns, CAP_SYS_PTRACE))
+	if (has_ns_capability(tracer, child_cred->user->user_ns, CAP_SYS_PTRACE))
 		goto out;
 	ret = -EPERM;
 out:
diff --git a/security/security.c b/security/security.c
index dd16397..4ec7e04 100644
--- a/security/security.c
+++ b/security/security.c
@@ -127,9 +127,11 @@ int __init register_security(struct security_operations *ops)
 
 /* Security operations */
 
-int security_ptrace_access_check(struct task_struct *child, unsigned int mode)
+int security_ptrace_access_check(struct task_struct *tracer,
+				 struct task_struct *child,
+				 unsigned int mode)
 {
-	return security_ops->ptrace_access_check(child, mode);
+	return security_ops->ptrace_access_check(tracer, child, mode);
 }
 
 int security_ptrace_traceme(struct task_struct *parent)
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index a0d3845..eb46b15 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1800,22 +1800,23 @@ static inline u32 open_file_to_av(struct file *file)
 
 /* Hook functions begin here. */
 
-static int selinux_ptrace_access_check(struct task_struct *child,
-				     unsigned int mode)
+static int selinux_ptrace_access_check(struct task_struct *tracer,
+				       struct task_struct *child,
+				       unsigned int mode)
 {
 	int rc;
 
-	rc = cap_ptrace_access_check(child, mode);
+	rc = cap_ptrace_access_check(tracer, child, mode);
 	if (rc)
 		return rc;
 
 	if (mode == PTRACE_MODE_READ) {
-		u32 sid = current_sid();
+		u32 sid = task_sid(tracer);
 		u32 csid = task_sid(child);
 		return avc_has_perm(sid, csid, SECCLASS_FILE, FILE__READ, NULL);
 	}
 
-	return current_has_perm(child, PROCESS__PTRACE);
+	return task_has_perm(tracer, child, PROCESS__PTRACE);
 }
 
 static int selinux_ptrace_traceme(struct task_struct *parent)
diff --git a/security/smack/smack.h b/security/smack/smack.h
index 2b6c6a5..0170b24 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -200,6 +200,7 @@ struct inode_smack *new_inode_smack(char *);
 int smk_access_entry(char *, char *, struct list_head *);
 int smk_access(char *, char *, int, struct smk_audit_info *);
 int smk_curacc(char *, u32, struct smk_audit_info *);
+int smk_taskacc(struct task_struct *task, char *, u32, struct smk_audit_info *);
 int smack_to_cipso(const char *, struct smack_cipso *);
 void smack_from_cipso(u32, char *, char *);
 char *smack_from_secid(const u32);
diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
index 9637e10..4075755 100644
--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -201,7 +201,8 @@ out_audit:
 }
 
 /**
- * smk_curacc - determine if current has a specific access to an object
+ * smk_taskacc - determine if task has a specific access to an object
+ * @task: a pointer to the subject's task struct
  * @obj_label: a pointer to the object's Smack label
  * @mode: the access requested, in "MAY" format
  * @a : common audit data
@@ -211,9 +212,10 @@ out_audit:
  * non zero otherwise. It allows that current may have the capability
  * to override the rules.
  */
-int smk_curacc(char *obj_label, u32 mode, struct smk_audit_info *a)
+int smk_taskacc(struct task_struct *task, char *obj_label,
+		u32 mode, struct smk_audit_info *a)
 {
-	struct task_smack *tsp = current_security();
+	struct task_smack *tsp = task_cred_xxx(task, security);
 	char *sp = smk_of_task(tsp);
 	int may;
 	int rc;
@@ -243,7 +245,7 @@ int smk_curacc(char *obj_label, u32 mode, struct smk_audit_info *a)
 	if (smack_onlycap != NULL && smack_onlycap != sp)
 		goto out_audit;
 
-	if (capable(CAP_MAC_OVERRIDE))
+	if (has_capability(task, CAP_MAC_OVERRIDE))
 		rc = 0;
 
 out_audit:
@@ -254,6 +256,11 @@ out_audit:
 	return rc;
 }
 
+int smk_curacc(char *obj_label, u32 mode, struct smk_audit_info *a)
+{
+	return smk_taskacc(current, obj_label, mode, a);
+}
+
 #ifdef CONFIG_AUDIT
 /**
  * smack_str_from_perm : helper to transalate an int to a
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 9831a39..bb18fda 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -142,6 +142,7 @@ static int smk_copy_rules(struct list_head *nhead, struct list_head *ohead,
 
 /**
  * smack_ptrace_access_check - Smack approval on PTRACE_ATTACH
+ * @ttp: tracer task pointer
  * @ctp: child task pointer
  * @mode: ptrace attachment mode
  *
@@ -149,13 +150,15 @@ static int smk_copy_rules(struct list_head *nhead, struct list_head *ohead,
  *
  * Do the capability checks, and require read and write.
  */
-static int smack_ptrace_access_check(struct task_struct *ctp, unsigned int mode)
+static int smack_ptrace_access_check(struct task_struct *ttp,
+				     struct task_struct *ctp,
+				     unsigned int mode)
 {
 	int rc;
 	struct smk_audit_info ad;
 	char *tsp;
 
-	rc = cap_ptrace_access_check(ctp, mode);
+	rc = cap_ptrace_access_check(ttp, ctp, mode);
 	if (rc != 0)
 		return rc;
 
@@ -163,7 +166,7 @@ static int smack_ptrace_access_check(struct task_struct *ctp, unsigned int mode)
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
 	smk_ad_setfield_u_tsk(&ad, ctp);
 
-	rc = smk_curacc(tsp, MAY_READWRITE, &ad);
+	rc = smk_taskacc(ttp, tsp, MAY_READWRITE, &ad);
 	return rc;
 }
 
---
