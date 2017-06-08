References: <59cec608-608e-6de6-21d9-bdec7b0ded3b@schaufler-ca.com>
From: Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <9913b7e8-93e5-c962-4b67-7ad3db62ba8a@schaufler-ca.com>
Date: Thu, 8 Jun 2017 13:49:47 -0700
MIME-Version: 1.0
In-Reply-To: <59cec608-608e-6de6-21d9-bdec7b0ded3b@schaufler-ca.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH 2/6] LSM-manage-credential-security-blobs
To: LSM <linux-security-module@vger.kernel.org>, James Morris <jmorris@namei.org>
Cc: John Johansen <john.johansen@canonical.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKLM <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Subject: [PATCH 2/6] LSM-manage-credential-security-blobs

Move the management of credential security blobs from the
individual security modules to the security infrastructure.
The security modules using credential blobs have been updated
accordingly. Modules are required to identify the space they
require at module initialization. In some cases a module no
longer needs to supply blob management hook, in which case
the hook has been removed.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
---
 include/linux/lsm_hooks.h           |  14 ++++
 kernel/cred.c                       |  13 ----
 security/Kconfig                    |  11 +++
 security/apparmor/context.c         |   2 -
 security/apparmor/include/context.h |   9 ++-
 security/apparmor/lsm.c             |  44 ++++--------
 security/security.c                 |  98 +++++++++++++++++++++++++-
 security/selinux/hooks.c            | 115 ++++++++++++-------------------
 security/selinux/include/objsec.h   |   9 +++
 security/selinux/selinuxfs.c        |   1 +
 security/selinux/xfrm.c             |   4 +-
 security/smack/smack.h              |  15 +++-
 security/smack/smack_access.c       |   2 +-
 security/smack/smack_lsm.c          | 134 +++++++++++++++---------------------
 security/smack/smackfs.c            |  18 ++---
 security/tomoyo/common.h            |  20 +++++-
 security/tomoyo/domain.c            |   4 +-
 security/tomoyo/securityfs_if.c     |  13 ++--
 security/tomoyo/tomoyo.c            |  49 ++++++++++---
 19 files changed, 346 insertions(+), 229 deletions(-)

diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 080f34e..41f01e2 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1890,6 +1890,13 @@ struct security_hook_list {
 };
 
 /*
+ * Security blob size or offset data.
+ */
+struct lsm_blob_sizes {
+	int	lbs_cred;
+};
+
+/*
  * Initializing a security_hook_list structure takes
  * up a lot of space in a source file. This macro takes
  * care of the common case and reduces the amount of
@@ -1901,6 +1908,7 @@ struct security_hook_list {
 extern struct security_hook_heads security_hook_heads;
 extern char *lsm_names;
 
+extern void security_add_blobs(struct lsm_blob_sizes *needed);
 extern void security_add_hooks(struct security_hook_list *hooks, int count,
 				char *lsm);
 
@@ -1947,4 +1955,10 @@ void __init loadpin_add_hooks(void);
 static inline void loadpin_add_hooks(void) { };
 #endif
 
+extern int lsm_cred_alloc(struct cred *cred, gfp_t gfp);
+
+#ifdef CONFIG_SECURITY
+void lsm_early_cred(struct cred *cred);
+#endif
+
 #endif /* ! __LINUX_LSM_HOOKS_H */
diff --git a/kernel/cred.c b/kernel/cred.c
index 2bc6607..ac73851 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -704,19 +704,6 @@ bool creds_are_invalid(const struct cred *cred)
 {
 	if (cred->magic != CRED_MAGIC)
 		return true;
-#ifdef CONFIG_SECURITY_SELINUX
-	/*
-	 * cred->security == NULL if security_cred_alloc_blank() or
-	 * security_prepare_creds() returned an error.
-	 */
-	if (selinux_is_enabled() && cred->security) {
-		if ((unsigned long) cred->security < PAGE_SIZE)
-			return true;
-		if ((*(u32 *)cred->security & 0xffffff00) ==
-		    (POISON_FREE << 24 | POISON_FREE << 16 | POISON_FREE << 8))
-			return true;
-	}
-#endif
 	return false;
 }
 EXPORT_SYMBOL(creds_are_invalid);
diff --git a/security/Kconfig b/security/Kconfig
index bdcbb92..999509d8 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -36,6 +36,17 @@ config SECURITY_WRITABLE_HOOKS
 	bool
 	default n
 
+config SECURITY_LSM_DEBUG
+	bool "Enable debugging of the LSM infrastructure"
+	depends on SECURITY
+	help
+	  This allows you to choose debug messages related to
+	  security modules configured into your kernel. These
+	  messages may be helpful in determining how a security
+	  module is using security blobs.
+
+	  If you are unsure how to answer this question, answer N.
+
 config SECURITYFS
 	bool "Enable the securityfs filesystem"
 	help
diff --git a/security/apparmor/context.c b/security/apparmor/context.c
index 1fc16b8..140bdce 100644
--- a/security/apparmor/context.c
+++ b/security/apparmor/context.c
@@ -50,8 +50,6 @@ void aa_free_task_context(struct aa_task_ctx *ctx)
 		aa_put_profile(ctx->profile);
 		aa_put_profile(ctx->previous);
 		aa_put_profile(ctx->onexec);
-
-		kzfree(ctx);
 	}
 }
 
diff --git a/security/apparmor/include/context.h b/security/apparmor/include/context.h
index 5b18fed..f35ad39 100644
--- a/security/apparmor/include/context.h
+++ b/security/apparmor/include/context.h
@@ -18,11 +18,12 @@
 #include <linux/cred.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/lsm_hooks.h>
 
 #include "policy.h"
 #include "policy_ns.h"
 
-#define cred_ctx(X) ((X)->security)
+#define cred_ctx(X) apparmor_cred(X)
 #define current_ctx() cred_ctx(current_cred())
 
 /* struct aa_file_ctx - the AppArmor context the file was opened in
@@ -86,6 +87,10 @@ int aa_set_current_hat(struct aa_profile *profile, u64 token);
 int aa_restore_previous_profile(u64 cookie);
 struct aa_profile *aa_get_task_profile(struct task_struct *task);
 
+static inline struct aa_task_ctx *apparmor_cred(const struct cred *cred)
+{
+	return cred->security;
+}
 
 /**
  * aa_cred_profile - obtain cred's profiles
@@ -97,7 +102,7 @@ struct aa_profile *aa_get_task_profile(struct task_struct *task);
  */
 static inline struct aa_profile *aa_cred_profile(const struct cred *cred)
 {
-	struct aa_task_ctx *ctx = cred_ctx(cred);
+	struct aa_task_ctx *ctx = apparmor_cred(cred);
 
 	AA_BUG(!ctx || !ctx->profile);
 	return ctx->profile;
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 8f3c0f7..eef5551 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -54,22 +54,6 @@ DEFINE_PER_CPU(struct aa_buffers, aa_buffers);
 static void apparmor_cred_free(struct cred *cred)
 {
 	aa_free_task_context(cred_ctx(cred));
-	cred_ctx(cred) = NULL;
-}
-
-/*
- * allocate the apparmor part of blank credentials
- */
-static int apparmor_cred_alloc_blank(struct cred *cred, gfp_t gfp)
-{
-	/* freed by apparmor_cred_free */
-	struct aa_task_ctx *ctx = aa_alloc_task_context(gfp);
-
-	if (!ctx)
-		return -ENOMEM;
-
-	cred_ctx(cred) = ctx;
-	return 0;
 }
 
 /*
@@ -78,14 +62,7 @@ static int apparmor_cred_alloc_blank(struct cred *cred, gfp_t gfp)
 static int apparmor_cred_prepare(struct cred *new, const struct cred *old,
 				 gfp_t gfp)
 {
-	/* freed by apparmor_cred_free */
-	struct aa_task_ctx *ctx = aa_alloc_task_context(gfp);
-
-	if (!ctx)
-		return -ENOMEM;
-
-	aa_dup_task_context(ctx, cred_ctx(old));
-	cred_ctx(new) = ctx;
+	aa_dup_task_context(cred_ctx(new), cred_ctx(old));
 	return 0;
 }
 
@@ -587,6 +564,10 @@ static int apparmor_task_setrlimit(struct task_struct *task,
 	return error;
 }
 
+struct lsm_blob_sizes apparmor_blob_sizes = {
+	.lbs_cred = sizeof(struct aa_task_ctx),
+};
+
 static struct security_hook_list apparmor_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(ptrace_access_check, apparmor_ptrace_access_check),
 	LSM_HOOK_INIT(ptrace_traceme, apparmor_ptrace_traceme),
@@ -616,7 +597,6 @@ static struct security_hook_list apparmor_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(getprocattr, apparmor_getprocattr),
 	LSM_HOOK_INIT(setprocattr, apparmor_setprocattr),
 
-	LSM_HOOK_INIT(cred_alloc_blank, apparmor_cred_alloc_blank),
 	LSM_HOOK_INIT(cred_free, apparmor_cred_free),
 	LSM_HOOK_INIT(cred_prepare, apparmor_cred_prepare),
 	LSM_HOOK_INIT(cred_transfer, apparmor_cred_transfer),
@@ -865,12 +845,10 @@ static int __init set_init_ctx(void)
 	struct cred *cred = (struct cred *)current->real_cred;
 	struct aa_task_ctx *ctx;
 
-	ctx = aa_alloc_task_context(GFP_KERNEL);
-	if (!ctx)
-		return -ENOMEM;
+	lsm_early_cred(cred);
+	ctx = apparmor_cred(cred);
 
 	ctx->profile = aa_get_profile(root_ns->unconfined);
-	cred_ctx(cred) = ctx;
 
 	return 0;
 }
@@ -954,8 +932,16 @@ static inline int apparmor_init_sysctl(void)
 
 static int __init apparmor_init(void)
 {
+	static int finish;
 	int error;
 
+	if (!finish) {
+		if (apparmor_enabled && security_module_enable("apparmor"))
+			security_add_blobs(&apparmor_blob_sizes);
+		finish = 1;
+		return 0;
+	}
+
 	if (!apparmor_enabled || !security_module_enable("apparmor")) {
 		aa_info_message("AppArmor disabled by boot time parameter");
 		apparmor_enabled = 0;
diff --git a/security/security.c b/security/security.c
index e50484c..062a9e4 100644
--- a/security/security.c
+++ b/security/security.c
@@ -35,6 +35,8 @@
 
 struct security_hook_heads security_hook_heads __lsm_ro_after_init;
 char *lsm_names;
+static struct lsm_blob_sizes blob_sizes;
+
 /* Boot-time LSM user choice */
 static __initdata char chosen_lsm[SECURITY_NAME_MAX + 1] =
 	CONFIG_DEFAULT_SECURITY;
@@ -72,10 +74,22 @@ int __init security_init(void)
 	loadpin_add_hooks();
 
 	/*
-	 * Load all the remaining security modules.
+	 * The first call to a module specific init function
+	 * updates the blob size requirements.
+	 */
+	do_security_initcalls();
+
+	/*
+	 * The second call to a module specific init function
+	 * adds hooks to the hook lists and does any other early
+	 * initializations required.
 	 */
 	do_security_initcalls();
 
+#ifdef CONFIG_SECURITY_LSM_DEBUG
+	pr_info("LSM: cred blob size       = %d\n", blob_sizes.lbs_cred);
+#endif
+
 	return 0;
 }
 
@@ -165,6 +179,75 @@ void __init security_add_hooks(struct security_hook_list *hooks, int count,
 		panic("%s - Cannot get early memory.\n", __func__);
 }
 
+/**
+ * lsm_cred_alloc - allocate a composite cred blob
+ * @cred: the cred that needs a blob
+ * @gfp: allocation type
+ *
+ * Allocate the cred blob for all the modules
+ *
+ * Returns 0, or -ENOMEM if memory can't be allocated.
+ */
+int lsm_cred_alloc(struct cred *cred, gfp_t gfp)
+{
+#ifdef CONFIG_SECURITY_LSM_DEBUG
+	if (cred->security)
+		pr_info("%s: Inbound cred blob is not NULL.\n", __func__);
+#endif
+	if (blob_sizes.lbs_cred == 0)
+		return 0;
+
+	cred->security = kzalloc(blob_sizes.lbs_cred, gfp);
+	if (cred->security == NULL)
+		return -ENOMEM;
+	return 0;
+}
+
+/**
+ * lsm_early_cred - during initialization allocate a composite cred blob
+ * @cred: the cred that needs a blob
+ *
+ * Allocate the cred blob for all the modules if it's not already there
+ */
+void lsm_early_cred(struct cred *cred)
+{
+	int rc;
+
+	if (cred == NULL)
+		panic("%s: NULL cred.\n", __func__);
+	if (cred->security != NULL)
+		return;
+	rc = lsm_cred_alloc(cred, GFP_KERNEL);
+	if (rc)
+		panic("%s: Early cred alloc failed.\n", __func__);
+}
+
+static void __init lsm_set_size(int *need, int *lbs)
+{
+	int offset;
+
+	if (*need > 0) {
+		offset = *lbs;
+		*lbs += *need;
+		*need = offset;
+	}
+}
+
+/**
+ * security_add_blobs - Report blob sizes
+ * @needed: the size of blobs needed by the module
+ *
+ * Each LSM has to register its blobs with the infrastructure.
+ * The "needed" data tells the infrastructure how much memory
+ * the module requires for each of its blobs. On return the
+ * structure is filled with the offset that module should use
+ * from the blob pointer.
+ */
+void __init security_add_blobs(struct lsm_blob_sizes *needed)
+{
+	lsm_set_size(&needed->lbs_cred, &blob_sizes.lbs_cred);
+}
+
 /*
  * Hook list operation macros.
  *
@@ -972,16 +1055,29 @@ void security_task_free(struct task_struct *task)
 
 int security_cred_alloc_blank(struct cred *cred, gfp_t gfp)
 {
+	int rc = lsm_cred_alloc(cred, gfp);
+
+	if (rc)
+		return rc;
+
 	return call_int_hook(cred_alloc_blank, 0, cred, gfp);
 }
 
 void security_cred_free(struct cred *cred)
 {
 	call_void_hook(cred_free, cred);
+
+	kfree(cred->security);
+	cred->security = NULL;
 }
 
 int security_prepare_creds(struct cred *new, const struct cred *old, gfp_t gfp)
 {
+	int rc = lsm_cred_alloc(new, gfp);
+
+	if (rc)
+		return rc;
+
 	return call_int_hook(cred_prepare, 0, new, old, gfp);
 }
 
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index e67a526..00156c6 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -179,12 +179,9 @@ static void cred_init_security(void)
 	struct cred *cred = (struct cred *) current->real_cred;
 	struct task_security_struct *tsec;
 
-	tsec = kzalloc(sizeof(struct task_security_struct), GFP_KERNEL);
-	if (!tsec)
-		panic("SELinux:  Failed to initialize initial task.\n");
-
+	lsm_early_cred(cred);
+	tsec = selinux_cred(cred);
 	tsec->osid = tsec->sid = SECINITSID_KERNEL;
-	cred->security = tsec;
 }
 
 /*
@@ -194,7 +191,7 @@ static inline u32 cred_sid(const struct cred *cred)
 {
 	const struct task_security_struct *tsec;
 
-	tsec = cred->security;
+	tsec = selinux_cred(cred);
 	return tsec->sid;
 }
 
@@ -442,7 +439,7 @@ static int may_context_mount_sb_relabel(u32 sid,
 			struct superblock_security_struct *sbsec,
 			const struct cred *cred)
 {
-	const struct task_security_struct *tsec = cred->security;
+	const struct task_security_struct *tsec = selinux_cred(cred);
 	int rc;
 
 	rc = avc_has_perm(tsec->sid, sbsec->sid, SECCLASS_FILESYSTEM,
@@ -459,7 +456,7 @@ static int may_context_mount_inode_relabel(u32 sid,
 			struct superblock_security_struct *sbsec,
 			const struct cred *cred)
 {
-	const struct task_security_struct *tsec = cred->security;
+	const struct task_security_struct *tsec = selinux_cred(cred);
 	int rc;
 	rc = avc_has_perm(tsec->sid, sbsec->sid, SECCLASS_FILESYSTEM,
 			  FILESYSTEM__RELABELFROM, NULL);
@@ -1854,7 +1851,7 @@ static int may_create(struct inode *dir,
 		      struct dentry *dentry,
 		      u16 tclass)
 {
-	const struct task_security_struct *tsec = current_security();
+	const struct task_security_struct *tsec = selinux_cred(current_cred());
 	struct inode_security_struct *dsec;
 	struct superblock_security_struct *sbsec;
 	u32 sid, newsid;
@@ -1875,7 +1872,7 @@ static int may_create(struct inode *dir,
 	if (rc)
 		return rc;
 
-	rc = selinux_determine_inode_label(current_security(), dir,
+	rc = selinux_determine_inode_label(selinux_cred(current_cred()), dir,
 					   &dentry->d_name, tclass, &newsid);
 	if (rc)
 		return rc;
@@ -2331,8 +2328,8 @@ static int selinux_bprm_set_creds(struct linux_binprm *bprm)
 	if (bprm->cred_prepared)
 		return 0;
 
-	old_tsec = current_security();
-	new_tsec = bprm->cred->security;
+	old_tsec = selinux_cred(current_cred());
+	new_tsec = selinux_cred(bprm->cred);
 	isec = inode_security(inode);
 
 	/* Default to the current task SID. */
@@ -2421,7 +2418,7 @@ static int selinux_bprm_set_creds(struct linux_binprm *bprm)
 
 static int selinux_bprm_secureexec(struct linux_binprm *bprm)
 {
-	const struct task_security_struct *tsec = current_security();
+	const struct task_security_struct *tsec = selinux_cred(current_cred());
 	u32 sid, osid;
 	int atsecure = 0;
 
@@ -2503,7 +2500,7 @@ static void selinux_bprm_committing_creds(struct linux_binprm *bprm)
 	struct rlimit *rlim, *initrlim;
 	int rc, i;
 
-	new_tsec = bprm->cred->security;
+	new_tsec = selinux_cred(bprm->cred);
 	if (new_tsec->sid == new_tsec->osid)
 		return;
 
@@ -2545,7 +2542,7 @@ static void selinux_bprm_committing_creds(struct linux_binprm *bprm)
  */
 static void selinux_bprm_committed_creds(struct linux_binprm *bprm)
 {
-	const struct task_security_struct *tsec = current_security();
+	const struct task_security_struct *tsec = selinux_cred(current_cred());
 	struct itimerval itimer;
 	u32 osid, sid;
 	int rc, i;
@@ -2845,7 +2842,7 @@ static int selinux_dentry_init_security(struct dentry *dentry, int mode,
 	u32 newsid;
 	int rc;
 
-	rc = selinux_determine_inode_label(current_security(),
+	rc = selinux_determine_inode_label(selinux_cred(current_cred()),
 					   d_inode(dentry->d_parent), name,
 					   inode_mode_to_security_class(mode),
 					   &newsid);
@@ -2864,14 +2861,14 @@ static int selinux_dentry_create_files_as(struct dentry *dentry, int mode,
 	int rc;
 	struct task_security_struct *tsec;
 
-	rc = selinux_determine_inode_label(old->security,
+	rc = selinux_determine_inode_label(selinux_cred(old),
 					   d_inode(dentry->d_parent), name,
 					   inode_mode_to_security_class(mode),
 					   &newsid);
 	if (rc)
 		return rc;
 
-	tsec = new->security;
+	tsec = selinux_cred(new);
 	tsec->create_sid = newsid;
 	return 0;
 }
@@ -2881,7 +2878,7 @@ static int selinux_inode_init_security(struct inode *inode, struct inode *dir,
 				       const char **name,
 				       void **value, size_t *len)
 {
-	const struct task_security_struct *tsec = current_security();
+	const struct task_security_struct *tsec = selinux_cred(current_cred());
 	struct superblock_security_struct *sbsec;
 	u32 sid, newsid, clen;
 	int rc;
@@ -2892,7 +2889,7 @@ static int selinux_inode_init_security(struct inode *inode, struct inode *dir,
 	sid = tsec->sid;
 	newsid = tsec->create_sid;
 
-	rc = selinux_determine_inode_label(current_security(),
+	rc = selinux_determine_inode_label(selinux_cred(current_cred()),
 		dir, qstr,
 		inode_mode_to_security_class(inode->i_mode),
 		&newsid);
@@ -3338,7 +3335,7 @@ static int selinux_inode_copy_up(struct dentry *src, struct cred **new)
 			return -ENOMEM;
 	}
 
-	tsec = new_creds->security;
+	tsec = selinux_cred(new_creds);
 	/* Get label from overlay inode and set it in create_sid */
 	selinux_inode_getsecid(d_inode(src), &sid);
 	tsec->create_sid = sid;
@@ -3718,52 +3715,16 @@ static int selinux_task_create(unsigned long clone_flags)
 }
 
 /*
- * allocate the SELinux part of blank credentials
- */
-static int selinux_cred_alloc_blank(struct cred *cred, gfp_t gfp)
-{
-	struct task_security_struct *tsec;
-
-	tsec = kzalloc(sizeof(struct task_security_struct), gfp);
-	if (!tsec)
-		return -ENOMEM;
-
-	cred->security = tsec;
-	return 0;
-}
-
-/*
- * detach and free the LSM part of a set of credentials
- */
-static void selinux_cred_free(struct cred *cred)
-{
-	struct task_security_struct *tsec = cred->security;
-
-	/*
-	 * cred->security == NULL if security_cred_alloc_blank() or
-	 * security_prepare_creds() returned an error.
-	 */
-	BUG_ON(cred->security && (unsigned long) cred->security < PAGE_SIZE);
-	cred->security = (void *) 0x7UL;
-	kfree(tsec);
-}
-
-/*
  * prepare a new set of credentials for modification
  */
 static int selinux_cred_prepare(struct cred *new, const struct cred *old,
 				gfp_t gfp)
 {
-	const struct task_security_struct *old_tsec;
-	struct task_security_struct *tsec;
+	const struct task_security_struct *old_tsec = selinux_cred(old);
+	struct task_security_struct *tsec = selinux_cred(new);
 
-	old_tsec = old->security;
-
-	tsec = kmemdup(old_tsec, sizeof(struct task_security_struct), gfp);
-	if (!tsec)
-		return -ENOMEM;
+	*tsec = *old_tsec;
 
-	new->security = tsec;
 	return 0;
 }
 
@@ -3772,8 +3733,8 @@ static int selinux_cred_prepare(struct cred *new, const struct cred *old,
  */
 static void selinux_cred_transfer(struct cred *new, const struct cred *old)
 {
-	const struct task_security_struct *old_tsec = old->security;
-	struct task_security_struct *tsec = new->security;
+	const struct task_security_struct *old_tsec = selinux_cred(old);
+	struct task_security_struct *tsec = selinux_cred(new);
 
 	*tsec = *old_tsec;
 }
@@ -3784,7 +3745,7 @@ static void selinux_cred_transfer(struct cred *new, const struct cred *old)
  */
 static int selinux_kernel_act_as(struct cred *new, u32 secid)
 {
-	struct task_security_struct *tsec = new->security;
+	struct task_security_struct *tsec = selinux_cred(new);
 	u32 sid = current_sid();
 	int ret;
 
@@ -3808,7 +3769,7 @@ static int selinux_kernel_act_as(struct cred *new, u32 secid)
 static int selinux_kernel_create_files_as(struct cred *new, struct inode *inode)
 {
 	struct inode_security_struct *isec = inode_security(inode);
-	struct task_security_struct *tsec = new->security;
+	struct task_security_struct *tsec = selinux_cred(new);
 	u32 sid = current_sid();
 	int ret;
 
@@ -4290,7 +4251,7 @@ static int sock_has_perm(struct sock *sk, u32 perms)
 static int selinux_socket_create(int family, int type,
 				 int protocol, int kern)
 {
-	const struct task_security_struct *tsec = current_security();
+	const struct task_security_struct *tsec = selinux_cred(current_cred());
 	u32 newsid;
 	u16 secclass;
 	int rc;
@@ -4309,7 +4270,7 @@ static int selinux_socket_create(int family, int type,
 static int selinux_socket_post_create(struct socket *sock, int family,
 				      int type, int protocol, int kern)
 {
-	const struct task_security_struct *tsec = current_security();
+	const struct task_security_struct *tsec = selinux_cred(current_cred());
 	struct inode_security_struct *isec = inode_security_novalidate(SOCK_INODE(sock));
 	struct sk_security_struct *sksec;
 	u16 sclass = socket_type_to_security_class(family, type, protocol);
@@ -4932,7 +4893,7 @@ static int selinux_secmark_relabel_packet(u32 sid)
 	const struct task_security_struct *__tsec;
 	u32 tsid;
 
-	__tsec = current_security();
+	__tsec = selinux_cred(current_cred());
 	tsid = __tsec->sid;
 
 	return avc_has_perm(tsid, sid, SECCLASS_PACKET, PACKET__RELABELTO, NULL);
@@ -5839,7 +5800,7 @@ static int selinux_getprocattr(struct task_struct *p,
 	unsigned len;
 
 	rcu_read_lock();
-	__tsec = __task_cred(p)->security;
+	__tsec = selinux_cred(__task_cred(p));
 
 	if (current != p) {
 		error = avc_has_perm(current_sid(), __tsec->sid,
@@ -5952,7 +5913,7 @@ static int selinux_setprocattr(const char *name, void *value, size_t size)
 	   operation.  See selinux_bprm_set_creds for the execve
 	   checks and may_create for the file creation checks. The
 	   operation will then fail if the context is not permitted. */
-	tsec = new->security;
+	tsec = selinux_cred(new);
 	if (!strcmp(name, "exec")) {
 		tsec->exec_sid = sid;
 	} else if (!strcmp(name, "fscreate")) {
@@ -6075,7 +6036,7 @@ static int selinux_key_alloc(struct key *k, const struct cred *cred,
 	if (!ksec)
 		return -ENOMEM;
 
-	tsec = cred->security;
+	tsec = selinux_cred(cred);
 	if (tsec->keycreate_sid)
 		ksec->sid = tsec->keycreate_sid;
 	else
@@ -6131,6 +6092,10 @@ static int selinux_key_getsecurity(struct key *key, char **_buffer)
 
 #endif
 
+struct lsm_blob_sizes selinux_blob_sizes = {
+	.lbs_cred = sizeof(struct task_security_struct),
+};
+
 static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(binder_set_context_mgr, selinux_binder_set_context_mgr),
 	LSM_HOOK_INIT(binder_transaction, selinux_binder_transaction),
@@ -6214,8 +6179,6 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(file_open, selinux_file_open),
 
 	LSM_HOOK_INIT(task_create, selinux_task_create),
-	LSM_HOOK_INIT(cred_alloc_blank, selinux_cred_alloc_blank),
-	LSM_HOOK_INIT(cred_free, selinux_cred_free),
 	LSM_HOOK_INIT(cred_prepare, selinux_cred_prepare),
 	LSM_HOOK_INIT(cred_transfer, selinux_cred_transfer),
 	LSM_HOOK_INIT(kernel_act_as, selinux_kernel_act_as),
@@ -6349,11 +6312,19 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 
 static __init int selinux_init(void)
 {
+	static int finish;
+
 	if (!security_module_enable("selinux")) {
 		selinux_enabled = 0;
 		return 0;
 	}
 
+	if (!finish) {
+		security_add_blobs(&selinux_blob_sizes);
+		finish = 1;
+		return 0;
+	}
+
 	if (!selinux_enabled) {
 		printk(KERN_INFO "SELinux:  Disabled at boot.\n");
 		return 0;
diff --git a/security/selinux/include/objsec.h b/security/selinux/include/objsec.h
index c03cdcd..48132cc 100644
--- a/security/selinux/include/objsec.h
+++ b/security/selinux/include/objsec.h
@@ -24,6 +24,9 @@
 #include <linux/binfmts.h>
 #include <linux/in.h>
 #include <linux/spinlock.h>
+#include <linux/lsm_hooks.h>
+#include <linux/msg.h>
+#include <net/sock.h>
 #include <net/net_namespace.h>
 #include "flask.h"
 #include "avc.h"
@@ -140,5 +143,11 @@ struct key_security_struct {
 };
 
 extern unsigned int selinux_checkreqprot;
+extern struct lsm_blob_sizes selinux_blob_sizes;
+
+static inline struct task_security_struct *selinux_cred(const struct cred *cred)
+{
+	return cred->security;
+}
 
 #endif /* _SELINUX_OBJSEC_H_ */
diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index 50062e7..75c1a68 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -30,6 +30,7 @@
 #include <linux/uaccess.h>
 #include <linux/kobject.h>
 #include <linux/ctype.h>
+#include <linux/lsm_hooks.h>
 
 /* selinuxfs pseudo filesystem for exporting the security policy API.
    Based on the proc code and the fs/nfsd/nfsctl.c code. */
diff --git a/security/selinux/xfrm.c b/security/selinux/xfrm.c
index 56e354f..789d07b 100644
--- a/security/selinux/xfrm.c
+++ b/security/selinux/xfrm.c
@@ -79,7 +79,7 @@ static int selinux_xfrm_alloc_user(struct xfrm_sec_ctx **ctxp,
 				   gfp_t gfp)
 {
 	int rc;
-	const struct task_security_struct *tsec = current_security();
+	const struct task_security_struct *tsec = selinux_cred(current_cred());
 	struct xfrm_sec_ctx *ctx = NULL;
 	u32 str_len;
 
@@ -136,7 +136,7 @@ static void selinux_xfrm_free(struct xfrm_sec_ctx *ctx)
  */
 static int selinux_xfrm_delete(struct xfrm_sec_ctx *ctx)
 {
-	const struct task_security_struct *tsec = current_security();
+	const struct task_security_struct *tsec = selinux_cred(current_cred());
 
 	if (!ctx)
 		return 0;
diff --git a/security/smack/smack.h b/security/smack/smack.h
index 612b810..17949ec 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -24,6 +24,7 @@
 #include <linux/list.h>
 #include <linux/rculist.h>
 #include <linux/lsm_audit.h>
+#include <linux/msg.h>
 
 /*
  * Use IPv6 port labeling if IPv6 is enabled and secmarks
@@ -355,6 +356,11 @@ extern struct list_head smack_onlycap_list;
 #define SMACK_HASH_SLOTS 16
 extern struct hlist_head smack_known_hash[SMACK_HASH_SLOTS];
 
+static inline struct task_smack *smack_cred(const struct cred *cred)
+{
+	return cred->security;
+}
+
 /*
  * Is the directory transmuting?
  */
@@ -381,13 +387,16 @@ static inline struct smack_known *smk_of_task(const struct task_smack *tsp)
 	return tsp->smk_task;
 }
 
-static inline struct smack_known *smk_of_task_struct(const struct task_struct *t)
+static inline struct smack_known *smk_of_task_struct(
+						const struct task_struct *t)
 {
 	struct smack_known *skp;
+	const struct cred *cred;
 
 	rcu_read_lock();
-	skp = smk_of_task(__task_cred(t)->security);
+	cred = __task_cred(t);
 	rcu_read_unlock();
+	skp = smk_of_task(smack_cred(cred));
 	return skp;
 }
 
@@ -404,7 +413,7 @@ static inline struct smack_known *smk_of_forked(const struct task_smack *tsp)
  */
 static inline struct smack_known *smk_of_current(void)
 {
-	return smk_of_task(current_security());
+	return smk_of_task(smack_cred(current_cred()));
 }
 
 /*
diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
index a4b2e6b..1b9b744 100644
--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -275,7 +275,7 @@ int smk_tskacc(struct task_smack *tsp, struct smack_known *obj_known,
 int smk_curacc(struct smack_known *obj_known,
 	       u32 mode, struct smk_audit_info *a)
 {
-	struct task_smack *tsp = current_security();
+	struct task_smack *tsp = smack_cred(current_cred());
 
 	return smk_tskacc(tsp, obj_known, mode, a);
 }
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 658f5d8..3ee5a14 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -121,7 +121,7 @@ static int smk_bu_note(char *note, struct smack_known *sskp,
 static int smk_bu_current(char *note, struct smack_known *oskp,
 			  int mode, int rc)
 {
-	struct task_smack *tsp = current_security();
+	struct task_smack *tsp = smack_cred(current_cred());
 	char acc[SMK_NUM_ACCESS_TYPE + 1];
 
 	if (rc <= 0)
@@ -142,7 +142,7 @@ static int smk_bu_current(char *note, struct smack_known *oskp,
 #ifdef CONFIG_SECURITY_SMACK_BRINGUP
 static int smk_bu_task(struct task_struct *otp, int mode, int rc)
 {
-	struct task_smack *tsp = current_security();
+	struct task_smack *tsp = smack_cred(current_cred());
 	struct smack_known *smk_task = smk_of_task_struct(otp);
 	char acc[SMK_NUM_ACCESS_TYPE + 1];
 
@@ -164,7 +164,7 @@ static int smk_bu_task(struct task_struct *otp, int mode, int rc)
 #ifdef CONFIG_SECURITY_SMACK_BRINGUP
 static int smk_bu_inode(struct inode *inode, int mode, int rc)
 {
-	struct task_smack *tsp = current_security();
+	struct task_smack *tsp = smack_cred(current_cred());
 	struct inode_smack *isp = inode->i_security;
 	char acc[SMK_NUM_ACCESS_TYPE + 1];
 
@@ -194,7 +194,7 @@ static int smk_bu_inode(struct inode *inode, int mode, int rc)
 #ifdef CONFIG_SECURITY_SMACK_BRINGUP
 static int smk_bu_file(struct file *file, int mode, int rc)
 {
-	struct task_smack *tsp = current_security();
+	struct task_smack *tsp = smack_cred(current_cred());
 	struct smack_known *sskp = tsp->smk_task;
 	struct inode *inode = file_inode(file);
 	struct inode_smack *isp = inode->i_security;
@@ -224,7 +224,7 @@ static int smk_bu_file(struct file *file, int mode, int rc)
 static int smk_bu_credfile(const struct cred *cred, struct file *file,
 				int mode, int rc)
 {
-	struct task_smack *tsp = cred->security;
+	struct task_smack *tsp = smack_cred(cred);
 	struct smack_known *sskp = tsp->smk_task;
 	struct inode *inode = file_inode(file);
 	struct inode_smack *isp = inode->i_security;
@@ -308,29 +308,20 @@ static struct inode_smack *new_inode_smack(struct smack_known *skp)
 }
 
 /**
- * new_task_smack - allocate a task security blob
+ * init_task_smack - initialize a task security blob
+ * @tsp: blob to initialize
  * @task: a pointer to the Smack label for the running task
  * @forked: a pointer to the Smack label for the forked task
- * @gfp: type of the memory for the allocation
  *
- * Returns the new blob or NULL if there's no memory available
  */
-static struct task_smack *new_task_smack(struct smack_known *task,
-					struct smack_known *forked, gfp_t gfp)
+static void init_task_smack(struct task_smack *tsp, struct smack_known *task,
+					struct smack_known *forked)
 {
-	struct task_smack *tsp;
-
-	tsp = kzalloc(sizeof(struct task_smack), gfp);
-	if (tsp == NULL)
-		return NULL;
-
 	tsp->smk_task = task;
 	tsp->smk_forked = forked;
 	INIT_LIST_HEAD(&tsp->smk_rules);
 	INIT_LIST_HEAD(&tsp->smk_relabel);
 	mutex_init(&tsp->smk_rules_lock);
-
-	return tsp;
 }
 
 /**
@@ -428,7 +419,7 @@ static int smk_ptrace_rule_check(struct task_struct *tracer,
 	}
 
 	rcu_read_lock();
-	tsp = __task_cred(tracer)->security;
+	tsp = smack_cred(__task_cred(tracer));
 	tracer_known = smk_of_task(tsp);
 
 	if ((mode & PTRACE_MODE_ATTACH) &&
@@ -495,7 +486,7 @@ static int smack_ptrace_traceme(struct task_struct *ptp)
 	int rc;
 	struct smack_known *skp;
 
-	skp = smk_of_task(current_security());
+	skp = smk_of_task(smack_cred(current_cred()));
 
 	rc = smk_ptrace_rule_check(ptp, skp, PTRACE_MODE_ATTACH, __func__);
 	return rc;
@@ -912,7 +903,7 @@ static int smack_sb_statfs(struct dentry *dentry)
 static int smack_bprm_set_creds(struct linux_binprm *bprm)
 {
 	struct inode *inode = file_inode(bprm->file);
-	struct task_smack *bsp = bprm->cred->security;
+	struct task_smack *bsp = smack_cred(bprm->cred);
 	struct inode_smack *isp;
 	struct superblock_smack *sbsp;
 	int rc;
@@ -961,7 +952,7 @@ static int smack_bprm_set_creds(struct linux_binprm *bprm)
  */
 static void smack_bprm_committing_creds(struct linux_binprm *bprm)
 {
-	struct task_smack *bsp = bprm->cred->security;
+	struct task_smack *bsp = smack_cred(bprm->cred);
 
 	if (bsp->smk_task != bsp->smk_forked)
 		current->pdeath_signal = 0;
@@ -975,7 +966,7 @@ static void smack_bprm_committing_creds(struct linux_binprm *bprm)
  */
 static int smack_bprm_secureexec(struct linux_binprm *bprm)
 {
-	struct task_smack *tsp = current_security();
+	struct task_smack *tsp = smack_cred(current_cred());
 
 	if (tsp->smk_task != tsp->smk_forked)
 		return 1;
@@ -1774,7 +1765,7 @@ static int smack_mmap_file(struct file *file,
 		return -EACCES;
 	mkp = isp->smk_mmap;
 
-	tsp = current_security();
+	tsp = smack_cred(current_cred());
 	skp = smk_of_current();
 	rc = 0;
 
@@ -1870,7 +1861,7 @@ static int smack_file_send_sigiotask(struct task_struct *tsk,
 				     struct fown_struct *fown, int signum)
 {
 	struct smack_known *skp;
-	struct smack_known *tkp = smk_of_task(tsk->cred->security);
+	struct smack_known *tkp = smk_of_task(smack_cred(tsk->cred));
 	struct file *file;
 	int rc;
 	struct smk_audit_info ad;
@@ -1918,7 +1909,7 @@ static int smack_file_receive(struct file *file)
 	if (S_ISSOCK(inode->i_mode)) {
 		sock = SOCKET_I(inode);
 		ssp = sock->sk->sk_security;
-		tsp = current_security();
+		tsp = smack_cred(current_cred());
 		/*
 		 * If the receiving process can't write to the
 		 * passed socket or if the passed socket can't
@@ -1960,7 +1951,7 @@ static int smack_file_receive(struct file *file)
  */
 static int smack_file_open(struct file *file, const struct cred *cred)
 {
-	struct task_smack *tsp = cred->security;
+	struct task_smack *tsp = smack_cred(cred);
 	struct inode *inode = file_inode(file);
 	struct smk_audit_info ad;
 	int rc;
@@ -1988,14 +1979,7 @@ static int smack_file_open(struct file *file, const struct cred *cred)
  */
 static int smack_cred_alloc_blank(struct cred *cred, gfp_t gfp)
 {
-	struct task_smack *tsp;
-
-	tsp = new_task_smack(NULL, NULL, gfp);
-	if (tsp == NULL)
-		return -ENOMEM;
-
-	cred->security = tsp;
-
+	init_task_smack(smack_cred(cred), NULL, NULL);
 	return 0;
 }
 
@@ -2007,15 +1991,11 @@ static int smack_cred_alloc_blank(struct cred *cred, gfp_t gfp)
  */
 static void smack_cred_free(struct cred *cred)
 {
-	struct task_smack *tsp = cred->security;
+	struct task_smack *tsp = smack_cred(cred);
 	struct smack_rule *rp;
 	struct list_head *l;
 	struct list_head *n;
 
-	if (tsp == NULL)
-		return;
-	cred->security = NULL;
-
 	smk_destroy_label_list(&tsp->smk_relabel);
 
 	list_for_each_safe(l, n, &tsp->smk_rules) {
@@ -2023,7 +2003,6 @@ static void smack_cred_free(struct cred *cred)
 		list_del(&rp->list);
 		kfree(rp);
 	}
-	kfree(tsp);
 }
 
 /**
@@ -2037,15 +2016,11 @@ static void smack_cred_free(struct cred *cred)
 static int smack_cred_prepare(struct cred *new, const struct cred *old,
 			      gfp_t gfp)
 {
-	struct task_smack *old_tsp = old->security;
-	struct task_smack *new_tsp;
+	struct task_smack *old_tsp = smack_cred(old);
+	struct task_smack *new_tsp = smack_cred(new);
 	int rc;
 
-	new_tsp = new_task_smack(old_tsp->smk_task, old_tsp->smk_task, gfp);
-	if (new_tsp == NULL)
-		return -ENOMEM;
-
-	new->security = new_tsp;
+	init_task_smack(new_tsp, old_tsp->smk_task, old_tsp->smk_task);
 
 	rc = smk_copy_rules(&new_tsp->smk_rules, &old_tsp->smk_rules, gfp);
 	if (rc != 0)
@@ -2053,10 +2028,7 @@ static int smack_cred_prepare(struct cred *new, const struct cred *old,
 
 	rc = smk_copy_relabel(&new_tsp->smk_relabel, &old_tsp->smk_relabel,
 				gfp);
-	if (rc != 0)
-		return rc;
-
-	return 0;
+	return rc;
 }
 
 /**
@@ -2068,15 +2040,14 @@ static int smack_cred_prepare(struct cred *new, const struct cred *old,
  */
 static void smack_cred_transfer(struct cred *new, const struct cred *old)
 {
-	struct task_smack *old_tsp = old->security;
-	struct task_smack *new_tsp = new->security;
+	struct task_smack *old_tsp = smack_cred(old);
+	struct task_smack *new_tsp = smack_cred(new);
 
 	new_tsp->smk_task = old_tsp->smk_task;
 	new_tsp->smk_forked = old_tsp->smk_task;
 	mutex_init(&new_tsp->smk_rules_lock);
 	INIT_LIST_HEAD(&new_tsp->smk_rules);
 
-
 	/* cbs copy rule list */
 }
 
@@ -2089,7 +2060,7 @@ static void smack_cred_transfer(struct cred *new, const struct cred *old)
  */
 static int smack_kernel_act_as(struct cred *new, u32 secid)
 {
-	struct task_smack *new_tsp = new->security;
+	struct task_smack *new_tsp = smack_cred(new);
 
 	new_tsp->smk_task = smack_from_secid(secid);
 	return 0;
@@ -2107,7 +2078,7 @@ static int smack_kernel_create_files_as(struct cred *new,
 					struct inode *inode)
 {
 	struct inode_smack *isp = inode->i_security;
-	struct task_smack *tsp = new->security;
+	struct task_smack *tsp = smack_cred(new);
 
 	tsp->smk_forked = isp->smk_inode;
 	tsp->smk_task = tsp->smk_forked;
@@ -3670,7 +3641,7 @@ static int smack_getprocattr(struct task_struct *p, char *name, char **value)
  */
 static int smack_setprocattr(const char *name, void *value, size_t size)
 {
-	struct task_smack *tsp = current_security();
+	struct task_smack *tsp = smack_cred(current_cred());
 	struct cred *new;
 	struct smack_known *skp;
 	struct smack_known_list_elem *sklep;
@@ -3711,7 +3682,7 @@ static int smack_setprocattr(const char *name, void *value, size_t size)
 	if (new == NULL)
 		return -ENOMEM;
 
-	tsp = new->security;
+	tsp = smack_cred(new);
 	tsp->smk_task = skp;
 	/*
 	 * process can change its label only once
@@ -4347,7 +4318,7 @@ static void smack_inet_csk_clone(struct sock *sk,
 static int smack_key_alloc(struct key *key, const struct cred *cred,
 			   unsigned long flags)
 {
-	struct smack_known *skp = smk_of_task(cred->security);
+	struct smack_known *skp = smk_of_task(smack_cred(cred));
 
 	key->security = skp;
 	return 0;
@@ -4378,7 +4349,7 @@ static int smack_key_permission(key_ref_t key_ref,
 {
 	struct key *keyp;
 	struct smk_audit_info ad;
-	struct smack_known *tkp = smk_of_task(cred->security);
+	struct smack_known *tkp = smk_of_task(smack_cred(cred));
 	int request = 0;
 	int rc;
 
@@ -4631,6 +4602,10 @@ static int smack_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen)
 	return 0;
 }
 
+struct lsm_blob_sizes smack_blob_sizes = {
+	.lbs_cred = sizeof(struct task_smack),
+};
+
 static struct security_hook_list smack_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(ptrace_access_check, smack_ptrace_access_check),
 	LSM_HOOK_INIT(ptrace_traceme, smack_ptrace_traceme),
@@ -4806,23 +4781,35 @@ static __init void init_smack_known_list(void)
  */
 static __init int smack_init(void)
 {
-	struct cred *cred;
+	static int finish;
+	struct cred *cred = (struct cred *) current->cred;
 	struct task_smack *tsp;
 
 	if (!security_module_enable("smack"))
 		return 0;
 
+	if (!finish) {
+		security_add_blobs(&smack_blob_sizes);
+		finish = 1;
+		return 0;
+	}
+
 	smack_inode_cache = KMEM_CACHE(inode_smack, 0);
 	if (!smack_inode_cache)
 		return -ENOMEM;
 
-	tsp = new_task_smack(&smack_known_floor, &smack_known_floor,
-				GFP_KERNEL);
-	if (tsp == NULL) {
-		kmem_cache_destroy(smack_inode_cache);
-		return -ENOMEM;
-	}
+	lsm_early_cred(cred);
 
+	/*
+	 * Set the security state for the initial task.
+	 */
+	tsp = smack_cred(cred);
+	init_task_smack(tsp, &smack_known_floor, &smack_known_floor);
+
+	/*
+	 * Register with LSM
+	 */
+	security_add_hooks(smack_hooks, ARRAY_SIZE(smack_hooks), "smack");
 	smack_enabled = 1;
 
 	pr_info("Smack:  Initializing.\n");
@@ -4836,20 +4823,9 @@ static __init int smack_init(void)
 	pr_info("Smack:  IPv6 Netfilter enabled.\n");
 #endif
 
-	/*
-	 * Set the security state for the initial task.
-	 */
-	cred = (struct cred *) current->cred;
-	cred->security = tsp;
-
 	/* initialize the smack_known_list */
 	init_smack_known_list();
 
-	/*
-	 * Register with LSM
-	 */
-	security_add_hooks(smack_hooks, ARRAY_SIZE(smack_hooks), "smack");
-
 	return 0;
 }
 
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index f6482e5..9d2dde6 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -2208,14 +2208,14 @@ static const struct file_operations smk_logging_ops = {
 
 static void *load_self_seq_start(struct seq_file *s, loff_t *pos)
 {
-	struct task_smack *tsp = current_security();
+	struct task_smack *tsp = smack_cred(current_cred());
 
 	return smk_seq_start(s, pos, &tsp->smk_rules);
 }
 
 static void *load_self_seq_next(struct seq_file *s, void *v, loff_t *pos)
 {
-	struct task_smack *tsp = current_security();
+	struct task_smack *tsp = smack_cred(current_cred());
 
 	return smk_seq_next(s, v, pos, &tsp->smk_rules);
 }
@@ -2262,7 +2262,7 @@ static int smk_open_load_self(struct inode *inode, struct file *file)
 static ssize_t smk_write_load_self(struct file *file, const char __user *buf,
 			      size_t count, loff_t *ppos)
 {
-	struct task_smack *tsp = current_security();
+	struct task_smack *tsp = smack_cred(current_cred());
 
 	return smk_write_rules_list(file, buf, count, ppos, &tsp->smk_rules,
 				    &tsp->smk_rules_lock, SMK_FIXED24_FMT);
@@ -2414,14 +2414,14 @@ static const struct file_operations smk_load2_ops = {
 
 static void *load_self2_seq_start(struct seq_file *s, loff_t *pos)
 {
-	struct task_smack *tsp = current_security();
+	struct task_smack *tsp = smack_cred(current_cred());
 
 	return smk_seq_start(s, pos, &tsp->smk_rules);
 }
 
 static void *load_self2_seq_next(struct seq_file *s, void *v, loff_t *pos)
 {
-	struct task_smack *tsp = current_security();
+	struct task_smack *tsp = smack_cred(current_cred());
 
 	return smk_seq_next(s, v, pos, &tsp->smk_rules);
 }
@@ -2467,7 +2467,7 @@ static int smk_open_load_self2(struct inode *inode, struct file *file)
 static ssize_t smk_write_load_self2(struct file *file, const char __user *buf,
 			      size_t count, loff_t *ppos)
 {
-	struct task_smack *tsp = current_security();
+	struct task_smack *tsp = smack_cred(current_cred());
 
 	return smk_write_rules_list(file, buf, count, ppos, &tsp->smk_rules,
 				    &tsp->smk_rules_lock, SMK_LONG_FMT);
@@ -2681,14 +2681,14 @@ static const struct file_operations smk_syslog_ops = {
 
 static void *relabel_self_seq_start(struct seq_file *s, loff_t *pos)
 {
-	struct task_smack *tsp = current_security();
+	struct task_smack *tsp = smack_cred(current_cred());
 
 	return smk_seq_start(s, pos, &tsp->smk_relabel);
 }
 
 static void *relabel_self_seq_next(struct seq_file *s, void *v, loff_t *pos)
 {
-	struct task_smack *tsp = current_security();
+	struct task_smack *tsp = smack_cred(current_cred());
 
 	return smk_seq_next(s, v, pos, &tsp->smk_relabel);
 }
@@ -2736,7 +2736,7 @@ static int smk_open_relabel_self(struct inode *inode, struct file *file)
 static ssize_t smk_write_relabel_self(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos)
 {
-	struct task_smack *tsp = current_security();
+	struct task_smack *tsp = smack_cred(current_cred());
 	char *data;
 	int rc;
 	LIST_HEAD(list_tmp);
diff --git a/security/tomoyo/common.h b/security/tomoyo/common.h
index 361e7a2..cbcfccc 100644
--- a/security/tomoyo/common.h
+++ b/security/tomoyo/common.h
@@ -28,6 +28,7 @@
 #include <linux/in.h>
 #include <linux/in6.h>
 #include <linux/un.h>
+#include <linux/lsm_hooks.h>
 #include <net/sock.h>
 #include <net/af_unix.h>
 #include <net/ip.h>
@@ -1196,13 +1197,26 @@ static inline void tomoyo_put_group(struct tomoyo_group *group)
 }
 
 /**
+ * tomoyo_cred - Get a pointer to the tomoyo cred security blob
+ * @cred - the relevant cred
+ *
+ * Returns pointer to the tomoyo cred blob.
+ */
+static inline struct tomoyo_domain_info **tomoyo_cred(const struct cred *cred)
+{
+	return cred->security;
+}
+
+/**
  * tomoyo_domain - Get "struct tomoyo_domain_info" for current thread.
  *
  * Returns pointer to "struct tomoyo_domain_info" for current thread.
  */
 static inline struct tomoyo_domain_info *tomoyo_domain(void)
 {
-	return current_cred()->security;
+	struct tomoyo_domain_info **blob = tomoyo_cred(current_cred());
+
+	return *blob;
 }
 
 /**
@@ -1215,7 +1229,9 @@ static inline struct tomoyo_domain_info *tomoyo_domain(void)
 static inline struct tomoyo_domain_info *tomoyo_real_domain(struct task_struct
 							    *task)
 {
-	return task_cred_xxx(task, security);
+	struct tomoyo_domain_info **blob = tomoyo_cred(get_task_cred(task));
+
+	return *blob;
 }
 
 /**
diff --git a/security/tomoyo/domain.c b/security/tomoyo/domain.c
index 00d223e..80ebb42 100644
--- a/security/tomoyo/domain.c
+++ b/security/tomoyo/domain.c
@@ -677,6 +677,7 @@ static int tomoyo_environ(struct tomoyo_execve *ee)
  */
 int tomoyo_find_next_domain(struct linux_binprm *bprm)
 {
+	struct tomoyo_domain_info **blob;
 	struct tomoyo_domain_info *old_domain = tomoyo_domain();
 	struct tomoyo_domain_info *domain = NULL;
 	const char *original_name = bprm->filename;
@@ -842,7 +843,8 @@ int tomoyo_find_next_domain(struct linux_binprm *bprm)
 		domain = old_domain;
 	/* Update reference count on "struct tomoyo_domain_info". */
 	atomic_inc(&domain->users);
-	bprm->cred->security = domain;
+	blob = tomoyo_cred(bprm->cred);
+	*blob = domain;
 	kfree(exename.name);
 	if (!retval) {
 		ee->r.domain = domain;
diff --git a/security/tomoyo/securityfs_if.c b/security/tomoyo/securityfs_if.c
index 06ab41b1..9289f2a 100644
--- a/security/tomoyo/securityfs_if.c
+++ b/security/tomoyo/securityfs_if.c
@@ -70,9 +70,12 @@ static ssize_t tomoyo_write_self(struct file *file, const char __user *buf,
 				if (!cred) {
 					error = -ENOMEM;
 				} else {
-					struct tomoyo_domain_info *old_domain =
-						cred->security;
-					cred->security = new_domain;
+					struct tomoyo_domain_info **blob;
+					struct tomoyo_domain_info *old_domain;
+
+					blob = tomoyo_cred(cred);
+					old_domain = *blob;
+					*blob = new_domain;
 					atomic_inc(&new_domain->users);
 					atomic_dec(&old_domain->users);
 					commit_creds(cred);
@@ -233,10 +236,12 @@ static void __init tomoyo_create_entry(const char *name, const umode_t mode,
  */
 static int __init tomoyo_initerface_init(void)
 {
+	struct tomoyo_domain_info *domain;
 	struct dentry *tomoyo_dir;
 
+	domain = tomoyo_domain();
 	/* Don't create securityfs entries unless registered. */
-	if (current_cred()->security != &tomoyo_kernel_domain)
+	if (domain != &tomoyo_kernel_domain)
 		return 0;
 
 	tomoyo_dir = securityfs_create_dir("tomoyo", NULL);
diff --git a/security/tomoyo/tomoyo.c b/security/tomoyo/tomoyo.c
index 130b4fa..901fa78 100644
--- a/security/tomoyo/tomoyo.c
+++ b/security/tomoyo/tomoyo.c
@@ -17,7 +17,9 @@
  */
 static int tomoyo_cred_alloc_blank(struct cred *new, gfp_t gfp)
 {
-	new->security = NULL;
+	struct tomoyo_domain_info **blob = tomoyo_cred(new);
+
+	*blob = NULL;
 	return 0;
 }
 
@@ -33,8 +35,13 @@ static int tomoyo_cred_alloc_blank(struct cred *new, gfp_t gfp)
 static int tomoyo_cred_prepare(struct cred *new, const struct cred *old,
 			       gfp_t gfp)
 {
-	struct tomoyo_domain_info *domain = old->security;
-	new->security = domain;
+	struct tomoyo_domain_info **old_blob = tomoyo_cred(old);
+	struct tomoyo_domain_info **new_blob = tomoyo_cred(new);
+	struct tomoyo_domain_info *domain;
+
+	domain = *old_blob;
+	*new_blob = domain;
+
 	if (domain)
 		atomic_inc(&domain->users);
 	return 0;
@@ -58,7 +65,9 @@ static void tomoyo_cred_transfer(struct cred *new, const struct cred *old)
  */
 static void tomoyo_cred_free(struct cred *cred)
 {
-	struct tomoyo_domain_info *domain = cred->security;
+	struct tomoyo_domain_info **blob = tomoyo_cred(cred);
+	struct tomoyo_domain_info *domain = *blob;
+
 	if (domain)
 		atomic_dec(&domain->users);
 }
@@ -72,6 +81,9 @@ static void tomoyo_cred_free(struct cred *cred)
  */
 static int tomoyo_bprm_set_creds(struct linux_binprm *bprm)
 {
+	struct tomoyo_domain_info **blob;
+	struct tomoyo_domain_info *domain;
+
 	/*
 	 * Do only if this function is called for the first time of an execve
 	 * operation.
@@ -92,13 +104,14 @@ static int tomoyo_bprm_set_creds(struct linux_binprm *bprm)
 	 * stored inside "bprm->cred->security" will be acquired later inside
 	 * tomoyo_find_next_domain().
 	 */
-	atomic_dec(&((struct tomoyo_domain_info *)
-		     bprm->cred->security)->users);
+	blob = tomoyo_cred(bprm->cred);
+	domain = *blob;
+	atomic_dec(&domain->users);
 	/*
 	 * Tell tomoyo_bprm_check_security() is called for the first time of an
 	 * execve operation.
 	 */
-	bprm->cred->security = NULL;
+	*blob = NULL;
 	return 0;
 }
 
@@ -111,8 +124,11 @@ static int tomoyo_bprm_set_creds(struct linux_binprm *bprm)
  */
 static int tomoyo_bprm_check_security(struct linux_binprm *bprm)
 {
-	struct tomoyo_domain_info *domain = bprm->cred->security;
+	struct tomoyo_domain_info **blob;
+	struct tomoyo_domain_info *domain;
 
+	blob = tomoyo_cred(bprm->cred);
+	domain = *blob;
 	/*
 	 * Execute permission is checked against pathname passed to do_execve()
 	 * using current domain.
@@ -492,6 +508,10 @@ static int tomoyo_socket_sendmsg(struct socket *sock, struct msghdr *msg,
 	return tomoyo_socket_sendmsg_permission(sock, msg, size);
 }
 
+struct lsm_blob_sizes tomoyo_blob_sizes = {
+	.lbs_cred = sizeof(struct tomoyo_domain_info *),
+};
+
 /*
  * tomoyo_security_ops is a "struct security_operations" which is used for
  * registering TOMOYO.
@@ -537,14 +557,25 @@ DEFINE_SRCU(tomoyo_ss);
  */
 static int __init tomoyo_init(void)
 {
+	static int finish;
 	struct cred *cred = (struct cred *) current_cred();
+	struct tomoyo_domain_info **blob;
 
 	if (!security_module_enable("tomoyo"))
 		return 0;
+
+	if (!finish) {
+		security_add_blobs(&tomoyo_blob_sizes);
+		finish = 1;
+		return 0;
+	}
+
 	/* register ourselves with the security framework */
 	security_add_hooks(tomoyo_hooks, ARRAY_SIZE(tomoyo_hooks), "tomoyo");
 	printk(KERN_INFO "TOMOYO Linux initialized\n");
-	cred->security = &tomoyo_kernel_domain;
+	lsm_early_cred(cred);
+	blob = tomoyo_cred(cred);
+	*blob = &tomoyo_kernel_domain;
 	tomoyo_mm_init();
 	return 0;
 }
-- 
2.5.5
