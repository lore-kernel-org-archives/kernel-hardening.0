Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Fri, 17 Jun 2011 19:29:12 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110617152912.GA21885@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [RFC v1] security: introduce ptrace_task_access_check()
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, apparmor@lists.ubuntu.com, "selinux@tycho.nsa.gov Stephen Smalley" <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>, John Johansen <john.johansen@canonical.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

This patch introduces ptrace_task_access_check() to be able to check
whether a specific task (not current) is able to ptrace another task
(might be current).  I need it to call "reversed" ptrace_may_access()
with swapped current and target task.

Specifically, I need it to filter taskstats and proc connector requests
for a restriction of getting other processes' information:

http://permalink.gmane.org/gmane.linux.kernel/1155354


Please help me to figure out how such patch should be divided to be
applied.  I think about such scheme:

1) add generic security/* functions.
2-4) add ptrace_task_access_check() for SMACK, AppArmor and SELinux.
5) change ptrace_access_check() in security ops and all LSMs to
    ptrace_task_access_check().

But I'd like to hear maintainers' oppinions not to put useless efforts.

Thanks,

---

 include/linux/capability.h    |    2 +
 include/linux/security.h      |   20 +++++++++++++++++-
 kernel/capability.c           |   24 ++++++++++++++++++++++
 security/apparmor/lsm.c       |   10 ++++----
 security/capability.c         |    2 +-
 security/commoncap.c          |   20 +++++++++++++++++++
 security/security.c           |   11 +++++++--
 security/selinux/hooks.c      |   13 +++++------
 security/smack/smack.h        |    1 +
 security/smack/smack_access.c |   43 +++++++++++++++++++++++++++++++++++++++++
 security/smack/smack_lsm.c    |    9 ++++---
 11 files changed, 133 insertions(+), 22 deletions(-)

diff --git a/include/linux/capability.h b/include/linux/capability.h
index c421123..cc0bcfe 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -544,7 +544,9 @@ extern bool has_ns_capability(struct task_struct *t,
 			      struct user_namespace *ns, int cap);
 extern bool has_capability_noaudit(struct task_struct *t, int cap);
 extern bool capable(int cap);
+extern bool task_capable(struct task_struct *task, int cap);
 extern bool ns_capable(struct user_namespace *ns, int cap);
+extern bool ns_task_capable(struct task_struct *t, struct user_namespace *ns, int cap);
 extern bool task_ns_capable(struct task_struct *t, int cap);
 extern bool nsown_capable(int cap);
 
diff --git a/include/linux/security.h b/include/linux/security.h
index 8ce59ef..88a2351 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -57,6 +57,8 @@ extern int cap_capable(struct task_struct *tsk, const struct cred *cred,
 		       struct user_namespace *ns, int cap, int audit);
 extern int cap_settime(const struct timespec *ts, const struct timezone *tz);
 extern int cap_ptrace_access_check(struct task_struct *child, unsigned int mode);
+extern int cap_ptrace_task_access_check(struct task_struct *task, struct task_struct *child,
+	unsigned int mode);
 extern int cap_ptrace_traceme(struct task_struct *parent);
 extern int cap_capget(struct task_struct *target, kernel_cap_t *effective, kernel_cap_t *inheritable, kernel_cap_t *permitted);
 extern int cap_capset(struct cred *new, const struct cred *old,
@@ -1375,7 +1377,9 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
 struct security_operations {
 	char name[SECURITY_NAME_MAX + 1];
 
-	int (*ptrace_access_check) (struct task_struct *child, unsigned int mode);
+	int (*ptrace_task_access_check) (struct task_struct *task,
+					 struct task_struct *child,
+					 unsigned int mode);
 	int (*ptrace_traceme) (struct task_struct *parent);
 	int (*capget) (struct task_struct *target,
 		       kernel_cap_t *effective,
@@ -1667,6 +1671,10 @@ int security_capset(struct cred *new, const struct cred *old,
 		    const kernel_cap_t *effective,
 		    const kernel_cap_t *inheritable,
 		    const kernel_cap_t *permitted);
+int security_task_capable(struct task_struct *task,
+			struct user_namespace *ns,
+			const struct cred *cred,
+			int cap);
 int security_capable(struct user_namespace *ns, const struct cred *cred,
 			int cap);
 int security_real_capable(struct task_struct *tsk, struct user_namespace *ns,
@@ -1865,10 +1873,18 @@ static inline int security_capset(struct cred *new,
 	return cap_capset(new, old, effective, inheritable, permitted);
 }
 
+static inline int security_task_capable(struct task_struct *task,
+					struct user_namespace *ns,
+					const struct cred *cred,
+					int cap)
+{
+	return cap_capable(task, cred, ns, cap, SECURITY_CAP_AUDIT);
+}
+
 static inline int security_capable(struct user_namespace *ns,
 				   const struct cred *cred, int cap)
 {
-	return cap_capable(current, cred, ns, cap, SECURITY_CAP_AUDIT);
+	return security_task_capable(current, ns, cred, cap);
 }
 
 static inline int security_real_capable(struct task_struct *tsk, struct user_namespace *ns, int cap)
diff --git a/kernel/capability.c b/kernel/capability.c
index 283c529..6a2d636 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -356,6 +356,30 @@ bool capable(int cap)
 }
 EXPORT_SYMBOL(capable);
 
+bool task_capable(struct task_struct *task, int cap)
+{
+	return ns_task_capable(task, &init_user_ns, cap);
+}
+EXPORT_SYMBOL(capable);
+
+bool ns_task_capable(struct task_struct *task, struct user_namespace *ns, int cap)
+{
+	if (unlikely(!cap_valid(cap))) {
+		printk(KERN_CRIT "capable() called with invalid cap=%u\n", cap);
+		BUG();
+	}
+
+	rcu_read_lock();
+	if (security_task_capable(task, ns, __task_cred(task), cap) == 0) {
+		rcu_read_unlock();
+		current->flags |= PF_SUPERPRIV;
+		return true;
+	}
+	rcu_read_unlock();
+	return false;
+}
+EXPORT_SYMBOL(ns_task_capable);
+
 /**
  * ns_capable - Determine if the current task has a superior capability in effect
  * @ns:  The usernamespace we want the capability in
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index ec1bcec..707f087 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -93,14 +93,14 @@ static void apparmor_cred_transfer(struct cred *new, const struct cred *old)
 	aa_dup_task_context(new_cxt, old_cxt);
 }
 
-static int apparmor_ptrace_access_check(struct task_struct *child,
-					unsigned int mode)
+static int apparmor_ptrace_task_access_check(struct task_struct *task,
+			    struct task_struct *child, unsigned int mode)
 {
-	int error = cap_ptrace_access_check(child, mode);
+	int error = cap_ptrace_task_access_check(task, child, mode);
 	if (error)
 		return error;
 
-	return aa_ptrace(current, child, mode);
+	return aa_ptrace(task, child, mode);
 }
 
 static int apparmor_ptrace_traceme(struct task_struct *parent)
@@ -624,7 +624,7 @@ static int apparmor_task_setrlimit(struct task_struct *task,
 static struct security_operations apparmor_ops = {
 	.name =				"apparmor",
 
-	.ptrace_access_check =		apparmor_ptrace_access_check,
+	.ptrace_task_access_check =	apparmor_ptrace_task_access_check,
 	.ptrace_traceme =		apparmor_ptrace_traceme,
 	.capget =			apparmor_capget,
 	.capable =			apparmor_capable,
diff --git a/security/capability.c b/security/capability.c
index bbb5115..1bdbe44 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -874,7 +874,7 @@ static void cap_audit_rule_free(void *lsmrule)
 
 void __init security_fixup_ops(struct security_operations *ops)
 {
-	set_to_cap_if_null(ops, ptrace_access_check);
+	set_to_cap_if_null(ops, ptrace_task_access_check);
 	set_to_cap_if_null(ops, ptrace_traceme);
 	set_to_cap_if_null(ops, capget);
 	set_to_cap_if_null(ops, capset);
diff --git a/security/commoncap.c b/security/commoncap.c
index a93b3b7..aa76791 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -155,6 +155,26 @@ out:
 	return ret;
 }
 
+int cap_ptrace_task_access_check(struct task_struct *task, struct task_struct *child,
+	unsigned int mode)
+{
+	int ret = 0;
+	const struct cred *cred, *child_cred;
+
+	rcu_read_lock();
+	cred = __task_cred(task);
+	child_cred = __task_cred(child);
+	if (cred->user->user_ns == child_cred->user->user_ns &&
+	    cap_issubset(child_cred->cap_permitted, cred->cap_permitted))
+		goto out;
+	if (ns_task_capable(task, child_cred->user->user_ns, CAP_SYS_PTRACE))
+		goto out;
+	ret = -EPERM;
+out:
+	rcu_read_unlock();
+	return ret;
+}
+
 /**
  * cap_ptrace_traceme - Determine whether another process may trace the current
  * @parent: The task proposed to be the tracer
diff --git a/security/security.c b/security/security.c
index 4ba6d4c..d51330b 100644
--- a/security/security.c
+++ b/security/security.c
@@ -129,7 +129,7 @@ int __init register_security(struct security_operations *ops)
 
 int security_ptrace_access_check(struct task_struct *child, unsigned int mode)
 {
-	return security_ops->ptrace_access_check(child, mode);
+	return security_ops->ptrace_task_access_check(current, child, mode);
 }
 
 int security_ptrace_traceme(struct task_struct *parent)
@@ -154,11 +154,16 @@ int security_capset(struct cred *new, const struct cred *old,
 				    effective, inheritable, permitted);
 }
 
+int security_task_capable(struct task_struct *task, struct user_namespace *ns,
+	const struct cred *cred, int cap)
+{
+	return security_ops->capable(task, cred, ns, cap, SECURITY_CAP_AUDIT);
+}
+
 int security_capable(struct user_namespace *ns, const struct cred *cred,
 		     int cap)
 {
-	return security_ops->capable(current, cred, ns, cap,
-				     SECURITY_CAP_AUDIT);
+	return security_task_capable(current, ns, cred, cap);
 }
 
 int security_real_capable(struct task_struct *tsk, struct user_namespace *ns,
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 20219ef..ee963d1 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1804,23 +1804,22 @@ static inline u32 open_file_to_av(struct file *file)
 }
 
 /* Hook functions begin here. */
-
-static int selinux_ptrace_access_check(struct task_struct *child,
-				     unsigned int mode)
+static int selinux_ptrace_task_access_check(struct task_struct *task,
+		struct task_struct *child, unsigned int mode)
 {
 	int rc;
 
-	rc = cap_ptrace_access_check(child, mode);
+	rc = cap_ptrace_task_access_check(task, child, mode);
 	if (rc)
 		return rc;
 
 	if (mode == PTRACE_MODE_READ) {
-		u32 sid = current_sid();
+		u32 sid = task_sid(task);
 		u32 csid = task_sid(child);
 		return avc_has_perm(sid, csid, SECCLASS_FILE, FILE__READ, NULL);
 	}
 
-	return current_has_perm(child, PROCESS__PTRACE);
+	return task_has_perm(task, child, PROCESS__PTRACE);
 }
 
 static int selinux_ptrace_traceme(struct task_struct *parent)
@@ -5457,7 +5456,7 @@ static int selinux_key_getsecurity(struct key *key, char **_buffer)
 static struct security_operations selinux_ops = {
 	.name =				"selinux",
 
-	.ptrace_access_check =		selinux_ptrace_access_check,
+	.ptrace_task_access_check =	selinux_ptrace_task_access_check,
 	.ptrace_traceme =		selinux_ptrace_traceme,
 	.capget =			selinux_capget,
 	.capset =			selinux_capset,
diff --git a/security/smack/smack.h b/security/smack/smack.h
index 2b6c6a5..4d9fb0f 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -199,6 +199,7 @@ struct inode_smack *new_inode_smack(char *);
  */
 int smk_access_entry(char *, char *, struct list_head *);
 int smk_access(char *, char *, int, struct smk_audit_info *);
+int smk_taskacc(struct task_struct *, char *, u32, struct smk_audit_info *);
 int smk_curacc(char *, u32, struct smk_audit_info *);
 int smack_to_cipso(const char *, struct smack_cipso *);
 void smack_from_cipso(u32, char *, char *);
diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
index 9637e10..f6582a7 100644
--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -200,6 +200,49 @@ out_audit:
 	return rc;
 }
 
+int smk_taskacc(struct task_struct *task, char *obj_label, u32 mode, struct smk_audit_info *a)
+{
+	struct task_smack *tsp = task_cred_xxx(task, security);
+	char *subject_label = smk_of_task(tsp);
+	int may;
+	int rc;
+
+	/*
+	 * Check the global rule list
+	 */
+	rc = smk_access(subject_label, obj_label, mode, NULL);
+	if (rc == 0) {
+		/*
+		 * If there is an entry in the task's rule list
+		 * it can further restrict access.
+		 */
+		may = smk_access_entry(subject_label, obj_label, &tsp->smk_rules);
+		if (may < 0)
+			goto out_audit;
+		if ((mode & may) == mode)
+			goto out_audit;
+		rc = -EACCES;
+	}
+
+	/*
+	 * Return if a specific label has been designated as the
+	 * only one that gets privilege and current does not
+	 * have that label.
+	 */
+	if (smack_onlycap != NULL && smack_onlycap != subject_label)
+		goto out_audit;
+
+	if (task_capable(task, CAP_MAC_OVERRIDE))
+		rc = 0;
+
+out_audit:
+#ifdef CONFIG_AUDIT
+	if (a)
+		smack_log(subject_label, obj_label, mode, rc, a);
+#endif
+	return rc;
+}
+
 /**
  * smk_curacc - determine if current has a specific access to an object
  * @obj_label: a pointer to the object's Smack label
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 9831a39..d168974 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -149,13 +149,14 @@ static int smk_copy_rules(struct list_head *nhead, struct list_head *ohead,
  *
  * Do the capability checks, and require read and write.
  */
-static int smack_ptrace_access_check(struct task_struct *ctp, unsigned int mode)
+static int smack_ptrace_task_access_check(struct task_struct *task,
+			struct task_struct *ctp, unsigned int mode)
 {
 	int rc;
 	struct smk_audit_info ad;
 	char *tsp;
 
-	rc = cap_ptrace_access_check(ctp, mode);
+	rc = cap_ptrace_task_access_check(task, ctp, mode);
 	if (rc != 0)
 		return rc;
 
@@ -163,7 +164,7 @@ static int smack_ptrace_access_check(struct task_struct *ctp, unsigned int mode)
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
 	smk_ad_setfield_u_tsk(&ad, ctp);
 
-	rc = smk_curacc(tsp, MAY_READWRITE, &ad);
+	rc = smk_taskacc(task, tsp, MAY_READWRITE, &ad);
 	return rc;
 }
 
@@ -3395,7 +3396,7 @@ static int smack_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen)
 struct security_operations smack_ops = {
 	.name =				"smack",
 
-	.ptrace_access_check =		smack_ptrace_access_check,
+	.ptrace_task_access_check =	smack_ptrace_task_access_check,
 	.ptrace_traceme =		smack_ptrace_traceme,
 	.syslog = 			smack_syslog,
 
---
