Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Wed, 30 Nov 2011 15:01:37 -0800
Message-Id: <1322694098-21872-2-git-send-email-keescook@chromium.org>
In-Reply-To: <1322694098-21872-1-git-send-email-keescook@chromium.org>
References: <1322694098-21872-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 1/2] security: create task_free security callback
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, Roland McGrath <roland@hack.frob.com>, James Morris <jmorris@namei.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

The current LSM interface to cred_free is not sufficient for allowing
an LSM to track the life and death of a task. This patch adds the
task_free hook so that an LSM can clean up resources on task death.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/security.h |    9 +++++++++
 kernel/fork.c            |    1 +
 security/capability.c    |    4 ++++
 security/security.c      |    5 +++++
 4 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 19d8e04..256befc 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -650,6 +650,10 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	manual page for definitions of the @clone_flags.
  *	@clone_flags contains the flags indicating what should be shared.
  *	Return 0 if permission is granted.
+ * @task_free:
+ *	@task task being freed
+ *	Handle release of task-related resources. (Note that this can be called
+ *  from interrupt context.)
  * @cred_alloc_blank:
  *	@cred points to the credentials.
  *	@gfp indicates the atomicity of any memory allocations.
@@ -1500,6 +1504,7 @@ struct security_operations {
 	int (*dentry_open) (struct file *file, const struct cred *cred);
 
 	int (*task_create) (unsigned long clone_flags);
+	void (*task_free) (struct task_struct *task);
 	int (*cred_alloc_blank) (struct cred *cred, gfp_t gfp);
 	void (*cred_free) (struct cred *cred);
 	int (*cred_prepare)(struct cred *new, const struct cred *old,
@@ -1762,6 +1767,7 @@ int security_file_send_sigiotask(struct task_struct *tsk,
 int security_file_receive(struct file *file);
 int security_dentry_open(struct file *file, const struct cred *cred);
 int security_task_create(unsigned long clone_flags);
+void security_task_free(struct task_struct *task);
 int security_cred_alloc_blank(struct cred *cred, gfp_t gfp);
 void security_cred_free(struct cred *cred);
 int security_prepare_creds(struct cred *new, const struct cred *old, gfp_t gfp);
@@ -2273,6 +2279,9 @@ static inline int security_task_create(unsigned long clone_flags)
 	return 0;
 }
 
+static inline void security_task_free(struct task_struct *task)
+{ }
+
 static inline int security_cred_alloc_blank(struct cred *cred, gfp_t gfp)
 {
 	return 0;
diff --git a/kernel/fork.c b/kernel/fork.c
index da4a6a1..d707601 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -189,6 +189,7 @@ void __put_task_struct(struct task_struct *tsk)
 	WARN_ON(atomic_read(&tsk->usage));
 	WARN_ON(tsk == current);
 
+	security_task_free(tsk);
 	exit_creds(tsk);
 	delayacct_tsk_free(tsk);
 	put_signal_struct(tsk->signal);
diff --git a/security/capability.c b/security/capability.c
index 2984ea4..e4206b5 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -359,6 +359,9 @@ static int cap_task_create(unsigned long clone_flags)
 	return 0;
 }
 
+static void cap_task_free(struct task_struct *task)
+{ }
+
 static int cap_cred_alloc_blank(struct cred *cred, gfp_t gfp)
 {
 	return 0;
@@ -955,6 +958,7 @@ void __init security_fixup_ops(struct security_operations *ops)
 	set_to_cap_if_null(ops, file_receive);
 	set_to_cap_if_null(ops, dentry_open);
 	set_to_cap_if_null(ops, task_create);
+	set_to_cap_if_null(ops, task_free);
 	set_to_cap_if_null(ops, cred_alloc_blank);
 	set_to_cap_if_null(ops, cred_free);
 	set_to_cap_if_null(ops, cred_prepare);
diff --git a/security/security.c b/security/security.c
index 0c6cc69..49a7227 100644
--- a/security/security.c
+++ b/security/security.c
@@ -749,6 +749,11 @@ int security_task_create(unsigned long clone_flags)
 	return security_ops->task_create(clone_flags);
 }
 
+void security_task_free(struct task_struct *task)
+{
+	security_ops->task_free(task);
+}
+
 int security_cred_alloc_blank(struct cred *cred, gfp_t gfp)
 {
 	return security_ops->cred_alloc_blank(cred, gfp);
-- 
1.7.0.4
