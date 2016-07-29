Reply-To: kernel-hardening@lists.openwall.com
From: Elena Reshetova <elena.reshetova@intel.com>
Date: Fri, 29 Jul 2016 10:34:38 +0300
Message-Id: <1469777680-3687-4-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1469777680-3687-1-git-send-email-elena.reshetova@intel.com>
References: <1469777680-3687-1-git-send-email-elena.reshetova@intel.com>
Subject: [kernel-hardening] [RFC] [PATCH 3/5] sb_unsharefs LSM hook
To: kernel-hardening@lists.openwall.com
Cc: linux-security-module@vger.kernel.org, keescook@chromium.org, spender@grsecurity.net, jmorris@namei.org, casey.schaufler@intel.com, michael.leibowitz@intel.com, william.c.roberts@intel.com, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

This adds a new security_sb_unsharefs() LSM hook.
It can be used by LSMs concerned about unsharefs()
system call.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 fs/fs_struct.c            | 7 ++++++-
 include/linux/lsm_hooks.h | 6 ++++++
 include/linux/security.h  | 1 +
 security/security.c       | 7 +++++++
 4 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/fs/fs_struct.c b/fs/fs_struct.c
index 7dca743..eba0fda 100644
--- a/fs/fs_struct.c
+++ b/fs/fs_struct.c
@@ -4,6 +4,7 @@
 #include <linux/path.h>
 #include <linux/slab.h>
 #include <linux/fs_struct.h>
+#include <linux/security.h>
 #include "internal.h"
 
 /*
@@ -132,11 +133,15 @@ int unshare_fs_struct(void)
 {
 	struct fs_struct *fs = current->fs;
 	struct fs_struct *new_fs = copy_fs_struct(fs);
-	int kill;
+	int kill, retval;
 
 	if (!new_fs)
 		return -ENOMEM;
 
+	retval = security_sb_unsharefs(&new_fs->root);
+	if (retval)
+		return retval;
+
 	task_lock(current);
 	spin_lock(&fs->lock);
 	kill = !--fs->users;
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index e8b839e..f30cf47 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -143,6 +143,10 @@
  *	Parse a string of security data filling in the opts structure
  *	@options string containing all mount options known by the LSM
  *	@opts binary data structure usable by the LSM
+ * @sb_unsharefs:
+ *	Check permission before allowing to unshare fs_struct from process.
+ *	@path contains the path for the new root structure.
+ *	Return 0 if permission is granted.
  * @dentry_init_security:
  *	Compute a context for a dentry as the inode is not yet available
  *	since NFSv4 has no label backed by an EA anyway.
@@ -1371,6 +1375,7 @@ union security_list_options {
 	int (*sb_clone_mnt_opts)(const struct super_block *oldsb,
 					struct super_block *newsb);
 	int (*sb_parse_opts_str)(char *options, struct security_mnt_opts *opts);
+	int (*sb_unsharefs)(const struct path *path);
 	int (*dentry_init_security)(struct dentry *dentry, int mode,
 					struct qstr *name, void **ctx,
 					u32 *ctxlen);
@@ -1678,6 +1683,7 @@ struct security_hook_heads {
 	struct list_head sb_set_mnt_opts;
 	struct list_head sb_clone_mnt_opts;
 	struct list_head sb_parse_opts_str;
+	struct list_head sb_unsharefs;
 	struct list_head dentry_init_security;
 #ifdef CONFIG_SECURITY_PATH
 	struct list_head path_unlink;
diff --git a/include/linux/security.h b/include/linux/security.h
index 6f935dc..5ad746f 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -239,6 +239,7 @@ int security_sb_set_mnt_opts(struct super_block *sb,
 int security_sb_clone_mnt_opts(const struct super_block *oldsb,
 				struct super_block *newsb);
 int security_sb_parse_opts_str(char *options, struct security_mnt_opts *opts);
+int security_sb_unsharefs(const struct path *path);
 int security_dentry_init_security(struct dentry *dentry, int mode,
 					struct qstr *name, void **ctx,
 					u32 *ctxlen);
diff --git a/security/security.c b/security/security.c
index 0e9544c..95487b9 100644
--- a/security/security.c
+++ b/security/security.c
@@ -343,6 +343,11 @@ int security_sb_parse_opts_str(char *options, struct security_mnt_opts *opts)
 }
 EXPORT_SYMBOL(security_sb_parse_opts_str);
 
+int security_sb_unsharefs(const struct path *path)
+{
+	return call_int_hook(sb_unsharefs, 0, path);
+}
+
 int security_inode_alloc(struct inode *inode)
 {
 	inode->i_security = NULL;
@@ -1619,6 +1624,8 @@ struct security_hook_heads security_hook_heads = {
 		LIST_HEAD_INIT(security_hook_heads.sb_clone_mnt_opts),
 	.sb_parse_opts_str =
 		LIST_HEAD_INIT(security_hook_heads.sb_parse_opts_str),
+	.sb_unsharefs =
+		LIST_HEAD_INIT(security_hook_heads.sb_unsharefs),
 	.dentry_init_security =
 		LIST_HEAD_INIT(security_hook_heads.dentry_init_security),
 #ifdef CONFIG_SECURITY_PATH
-- 
1.9.1
