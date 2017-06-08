References: <59cec608-608e-6de6-21d9-bdec7b0ded3b@schaufler-ca.com>
From: Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <3cb05c5f-a8b1-9bdd-5db6-dd21bdcd4d22@schaufler-ca.com>
Date: Thu, 8 Jun 2017 13:49:52 -0700
MIME-Version: 1.0
In-Reply-To: <59cec608-608e-6de6-21d9-bdec7b0ded3b@schaufler-ca.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH 3/6] LSM: Manage file security blobs
To: LSM <linux-security-module@vger.kernel.org>, James Morris <jmorris@namei.org>
Cc: John Johansen <john.johansen@canonical.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKLM <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Subject: [PATCH 3/6] LSM: Manage file security blobs

Move the management of file security blobs from the individual
security modules to the security infrastructure. The security modules
using file blobs have been updated accordingly. Modules are required
to identify the space they need at module initialization. In some
cases a module no longer needs to supply a blob management hook, in
which case the hook has been removed.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
---
 include/linux/lsm_hooks.h           |  1 +
 security/apparmor/include/context.h |  6 ++++++
 security/apparmor/lsm.c             | 26 ++++-------------------
 security/security.c                 | 32 +++++++++++++++++++++++++++++
 security/selinux/hooks.c            | 41 +++++++++----------------------------
 security/selinux/include/objsec.h   |  5 +++++
 security/smack/smack.h              |  5 +++++
 security/smack/smack_lsm.c          | 26 ++++++++---------------
 8 files changed, 72 insertions(+), 70 deletions(-)

diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 41f01e2..dc012eb 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1894,6 +1894,7 @@ struct security_hook_list {
  */
 struct lsm_blob_sizes {
 	int	lbs_cred;
+	int	lbs_file;
 };
 
 /*
diff --git a/security/apparmor/include/context.h b/security/apparmor/include/context.h
index f35ad39..3ff3879 100644
--- a/security/apparmor/include/context.h
+++ b/security/apparmor/include/context.h
@@ -25,6 +25,7 @@
 
 #define cred_ctx(X) apparmor_cred(X)
 #define current_ctx() cred_ctx(current_cred())
+#define file_ctx(X) apparmor_file(X)
 
 /* struct aa_file_ctx - the AppArmor context the file was opened in
  * @perms: the permission the file was opened with
@@ -92,6 +93,11 @@ static inline struct aa_task_ctx *apparmor_cred(const struct cred *cred)
 	return cred->security;
 }
 
+static inline struct aa_file_ctx *apparmor_file(const struct file *file)
+{
+	return file->f_security;
+}
+
 /**
  * aa_cred_profile - obtain cred's profiles
  * @cred: cred to obtain profiles from  (NOT NULL)
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index eef5551..12a0265 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -329,7 +329,7 @@ static int apparmor_inode_getattr(const struct path *path)
 
 static int apparmor_file_open(struct file *file, const struct cred *cred)
 {
-	struct aa_file_ctx *fctx = file->f_security;
+	struct aa_file_ctx *fctx = file_ctx(file);
 	struct aa_profile *profile;
 	int error = 0;
 
@@ -360,26 +360,9 @@ static int apparmor_file_open(struct file *file, const struct cred *cred)
 	return error;
 }
 
-static int apparmor_file_alloc_security(struct file *file)
-{
-	/* freed by apparmor_file_free_security */
-	file->f_security = aa_alloc_file_context(GFP_KERNEL);
-	if (!file->f_security)
-		return -ENOMEM;
-	return 0;
-
-}
-
-static void apparmor_file_free_security(struct file *file)
-{
-	struct aa_file_ctx *ctx = file->f_security;
-
-	aa_free_file_context(ctx);
-}
-
 static int common_file_perm(const char *op, struct file *file, u32 mask)
 {
-	struct aa_file_ctx *fctx = file->f_security;
+	struct aa_file_ctx *fctx = file_ctx(file);
 	struct aa_profile *profile, *fprofile = aa_cred_profile(file->f_cred);
 	int error = 0;
 
@@ -425,7 +408,7 @@ static int common_mmap(const char *op, struct file *file, unsigned long prot,
 {
 	int mask = 0;
 
-	if (!file || !file->f_security)
+	if (!file || file_ctx(file) == NULL)
 		return 0;
 
 	if (prot & PROT_READ)
@@ -566,6 +549,7 @@ static int apparmor_task_setrlimit(struct task_struct *task,
 
 struct lsm_blob_sizes apparmor_blob_sizes = {
 	.lbs_cred = sizeof(struct aa_task_ctx),
+	.lbs_file = sizeof(struct aa_file_ctx),
 };
 
 static struct security_hook_list apparmor_hooks[] __lsm_ro_after_init = {
@@ -588,8 +572,6 @@ static struct security_hook_list apparmor_hooks[] __lsm_ro_after_init = {
 
 	LSM_HOOK_INIT(file_open, apparmor_file_open),
 	LSM_HOOK_INIT(file_permission, apparmor_file_permission),
-	LSM_HOOK_INIT(file_alloc_security, apparmor_file_alloc_security),
-	LSM_HOOK_INIT(file_free_security, apparmor_file_free_security),
 	LSM_HOOK_INIT(mmap_file, apparmor_mmap_file),
 	LSM_HOOK_INIT(file_mprotect, apparmor_file_mprotect),
 	LSM_HOOK_INIT(file_lock, apparmor_file_lock),
diff --git a/security/security.c b/security/security.c
index 062a9e4..3c22fb1 100644
--- a/security/security.c
+++ b/security/security.c
@@ -88,6 +88,7 @@ int __init security_init(void)
 
 #ifdef CONFIG_SECURITY_LSM_DEBUG
 	pr_info("LSM: cred blob size       = %d\n", blob_sizes.lbs_cred);
+	pr_info("LSM: file blob size       = %d\n", blob_sizes.lbs_file);
 #endif
 
 	return 0;
@@ -246,6 +247,30 @@ static void __init lsm_set_size(int *need, int *lbs)
 void __init security_add_blobs(struct lsm_blob_sizes *needed)
 {
 	lsm_set_size(&needed->lbs_cred, &blob_sizes.lbs_cred);
+	lsm_set_size(&needed->lbs_file, &blob_sizes.lbs_file);
+}
+
+/**
+ * lsm_file_alloc - allocate a composite file blob
+ * @file: the file that needs a blob
+ *
+ * Allocate the file blob for all the modules
+ *
+ * Returns 0, or -ENOMEM if memory can't be allocated.
+ */
+int lsm_file_alloc(struct file *file)
+{
+#ifdef CONFIG_SECURITY_LSM_DEBUG
+	if (file->f_security)
+		pr_info("%s: Inbound file blob is not NULL.\n", __func__);
+#endif
+	if (blob_sizes.lbs_file == 0)
+		return 0;
+
+	file->f_security = kzalloc(blob_sizes.lbs_file, GFP_KERNEL);
+	if (file->f_security == NULL)
+		return -ENOMEM;
+	return 0;
 }
 
 /*
@@ -933,12 +958,19 @@ int security_file_permission(struct file *file, int mask)
 
 int security_file_alloc(struct file *file)
 {
+	int rc = lsm_file_alloc(file);
+
+	if (rc)
+		return rc;
 	return call_int_hook(file_alloc_security, 0, file);
 }
 
 void security_file_free(struct file *file)
 {
 	call_void_hook(file_free_security, file);
+
+	kfree(file->f_security);
+	file->f_security = NULL;
 }
 
 int security_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 00156c6..223a178 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -127,7 +127,6 @@ int selinux_enabled = 1;
 #endif
 
 static struct kmem_cache *sel_inode_cache;
-static struct kmem_cache *file_security_cache;
 
 /**
  * selinux_secmark_enabled - Check to see if SECMARK is currently enabled
@@ -347,27 +346,15 @@ static void inode_free_security(struct inode *inode)
 
 static int file_alloc_security(struct file *file)
 {
-	struct file_security_struct *fsec;
+	struct file_security_struct *fsec = selinux_file(file);
 	u32 sid = current_sid();
 
-	fsec = kmem_cache_zalloc(file_security_cache, GFP_KERNEL);
-	if (!fsec)
-		return -ENOMEM;
-
 	fsec->sid = sid;
 	fsec->fown_sid = sid;
-	file->f_security = fsec;
 
 	return 0;
 }
 
-static void file_free_security(struct file *file)
-{
-	struct file_security_struct *fsec = file->f_security;
-	file->f_security = NULL;
-	kmem_cache_free(file_security_cache, fsec);
-}
-
 static int superblock_alloc_security(struct super_block *sb)
 {
 	struct superblock_security_struct *sbsec;
@@ -1793,7 +1780,7 @@ static int file_has_perm(const struct cred *cred,
 			 struct file *file,
 			 u32 av)
 {
-	struct file_security_struct *fsec = file->f_security;
+	struct file_security_struct *fsec = selinux_file(file);
 	struct inode *inode = file_inode(file);
 	struct common_audit_data ad;
 	u32 sid = cred_sid(cred);
@@ -2112,7 +2099,7 @@ static int selinux_binder_transfer_file(struct task_struct *from,
 					struct file *file)
 {
 	u32 sid = task_sid(to);
-	struct file_security_struct *fsec = file->f_security;
+	struct file_security_struct *fsec = selinux_file(file);
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode_security_struct *isec;
 	struct common_audit_data ad;
@@ -3376,7 +3363,7 @@ static int selinux_revalidate_file_permission(struct file *file, int mask)
 static int selinux_file_permission(struct file *file, int mask)
 {
 	struct inode *inode = file_inode(file);
-	struct file_security_struct *fsec = file->f_security;
+	struct file_security_struct *fsec = selinux_file(file);
 	struct inode_security_struct *isec;
 	u32 sid = current_sid();
 
@@ -3398,11 +3385,6 @@ static int selinux_file_alloc_security(struct file *file)
 	return file_alloc_security(file);
 }
 
-static void selinux_file_free_security(struct file *file)
-{
-	file_free_security(file);
-}
-
 /*
  * Check whether a task has the ioctl permission and cmd
  * operation to an inode.
@@ -3411,7 +3393,7 @@ static int ioctl_has_perm(const struct cred *cred, struct file *file,
 		u32 requested, u16 cmd)
 {
 	struct common_audit_data ad;
-	struct file_security_struct *fsec = file->f_security;
+	struct file_security_struct *fsec = selinux_file(file);
 	struct inode *inode = file_inode(file);
 	struct inode_security_struct *isec;
 	struct lsm_ioctlop_audit ioctl;
@@ -3645,7 +3627,7 @@ static void selinux_file_set_fowner(struct file *file)
 {
 	struct file_security_struct *fsec;
 
-	fsec = file->f_security;
+	fsec = selinux_file(file);
 	fsec->fown_sid = current_sid();
 }
 
@@ -3660,7 +3642,7 @@ static int selinux_file_send_sigiotask(struct task_struct *tsk,
 	/* struct fown_struct is never outside the context of a struct file */
 	file = container_of(fown, struct file, f_owner);
 
-	fsec = file->f_security;
+	fsec = selinux_file(file);
 
 	if (!signum)
 		perm = signal_to_av(SIGIO); /* as per send_sigio_to_task */
@@ -3683,7 +3665,7 @@ static int selinux_file_open(struct file *file, const struct cred *cred)
 	struct file_security_struct *fsec;
 	struct inode_security_struct *isec;
 
-	fsec = file->f_security;
+	fsec = selinux_file(file);
 	isec = inode_security(file_inode(file));
 	/*
 	 * Save inode label and policy sequence number
@@ -3812,7 +3794,7 @@ static int selinux_kernel_module_from_file(struct file *file)
 	ad.type = LSM_AUDIT_DATA_FILE;
 	ad.u.file = file;
 
-	fsec = file->f_security;
+	fsec = selinux_file(file);
 	if (sid != fsec->sid) {
 		rc = avc_has_perm(sid, fsec->sid, SECCLASS_FD, FD__USE, &ad);
 		if (rc)
@@ -6094,6 +6076,7 @@ static int selinux_key_getsecurity(struct key *key, char **_buffer)
 
 struct lsm_blob_sizes selinux_blob_sizes = {
 	.lbs_cred = sizeof(struct task_security_struct),
+	.lbs_file = sizeof(struct file_security_struct),
 };
 
 static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
@@ -6165,7 +6148,6 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 
 	LSM_HOOK_INIT(file_permission, selinux_file_permission),
 	LSM_HOOK_INIT(file_alloc_security, selinux_file_alloc_security),
-	LSM_HOOK_INIT(file_free_security, selinux_file_free_security),
 	LSM_HOOK_INIT(file_ioctl, selinux_file_ioctl),
 	LSM_HOOK_INIT(mmap_file, selinux_mmap_file),
 	LSM_HOOK_INIT(mmap_addr, selinux_mmap_addr),
@@ -6340,9 +6322,6 @@ static __init int selinux_init(void)
 	sel_inode_cache = kmem_cache_create("selinux_inode_security",
 					    sizeof(struct inode_security_struct),
 					    0, SLAB_PANIC, NULL);
-	file_security_cache = kmem_cache_create("selinux_file_security",
-					    sizeof(struct file_security_struct),
-					    0, SLAB_PANIC, NULL);
 	avc_init();
 
 	security_add_hooks(selinux_hooks, ARRAY_SIZE(selinux_hooks), "selinux");
diff --git a/security/selinux/include/objsec.h b/security/selinux/include/objsec.h
index 48132cc..6a638da 100644
--- a/security/selinux/include/objsec.h
+++ b/security/selinux/include/objsec.h
@@ -150,4 +150,9 @@ static inline struct task_security_struct *selinux_cred(const struct cred *cred)
 	return cred->security;
 }
 
+static inline struct file_security_struct *selinux_file(const struct file *file)
+{
+	return file->f_security;
+}
+
 #endif /* _SELINUX_OBJSEC_H_ */
diff --git a/security/smack/smack.h b/security/smack/smack.h
index 17949ec..9e704a6 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -361,6 +361,11 @@ static inline struct task_smack *smack_cred(const struct cred *cred)
 	return cred->security;
 }
 
+static inline struct smack_known **smack_file(const struct file *file)
+{
+	return file->f_security;
+}
+
 /*
  * Is the directory transmuting?
  */
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 3ee5a14..3c95c1f 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1601,25 +1601,13 @@ static void smack_inode_getsecid(struct inode *inode, u32 *secid)
  */
 static int smack_file_alloc_security(struct file *file)
 {
-	struct smack_known *skp = smk_of_current();
+	struct smack_known **blob = smack_file(file);
 
-	file->f_security = skp;
+	*blob = smk_of_current();
 	return 0;
 }
 
 /**
- * smack_file_free_security - clear a file security blob
- * @file: the object
- *
- * The security blob for a file is a pointer to the master
- * label list, so no memory is freed.
- */
-static void smack_file_free_security(struct file *file)
-{
-	file->f_security = NULL;
-}
-
-/**
  * smack_file_ioctl - Smack check on ioctls
  * @file: the object
  * @cmd: what to do
@@ -1843,7 +1831,9 @@ static int smack_mmap_file(struct file *file,
  */
 static void smack_file_set_fowner(struct file *file)
 {
-	file->f_security = smk_of_current();
+	struct smack_known **blob = smack_file(file);
+
+	*blob = smk_of_current();
 }
 
 /**
@@ -1860,6 +1850,7 @@ static void smack_file_set_fowner(struct file *file)
 static int smack_file_send_sigiotask(struct task_struct *tsk,
 				     struct fown_struct *fown, int signum)
 {
+	struct smack_known **blob;
 	struct smack_known *skp;
 	struct smack_known *tkp = smk_of_task(smack_cred(tsk->cred));
 	struct file *file;
@@ -1872,7 +1863,8 @@ static int smack_file_send_sigiotask(struct task_struct *tsk,
 	file = container_of(fown, struct file, f_owner);
 
 	/* we don't log here as rc can be overriden */
-	skp = file->f_security;
+	blob = smack_file(file);
+	skp = *blob;
 	rc = smk_access(skp, tkp, MAY_DELIVER, NULL);
 	rc = smk_bu_note("sigiotask", skp, tkp, MAY_DELIVER, rc);
 	if (rc != 0 && has_capability(tsk, CAP_MAC_OVERRIDE))
@@ -4604,6 +4596,7 @@ static int smack_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen)
 
 struct lsm_blob_sizes smack_blob_sizes = {
 	.lbs_cred = sizeof(struct task_smack),
+	.lbs_file = sizeof(struct smack_known *),
 };
 
 static struct security_hook_list smack_hooks[] __lsm_ro_after_init = {
@@ -4643,7 +4636,6 @@ static struct security_hook_list smack_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(inode_getsecid, smack_inode_getsecid),
 
 	LSM_HOOK_INIT(file_alloc_security, smack_file_alloc_security),
-	LSM_HOOK_INIT(file_free_security, smack_file_free_security),
 	LSM_HOOK_INIT(file_ioctl, smack_file_ioctl),
 	LSM_HOOK_INIT(file_lock, smack_file_lock),
 	LSM_HOOK_INIT(file_fcntl, smack_file_fcntl),
-- 
2.5.5
