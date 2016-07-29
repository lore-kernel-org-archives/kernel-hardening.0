Reply-To: kernel-hardening@lists.openwall.com
From: Elena Reshetova <elena.reshetova@intel.com>
Date: Fri, 29 Jul 2016 10:34:36 +0300
Message-Id: <1469777680-3687-2-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1469777680-3687-1-git-send-email-elena.reshetova@intel.com>
References: <1469777680-3687-1-git-send-email-elena.reshetova@intel.com>
Subject: [kernel-hardening] [RFC] [PATCH 1/5] path_fchdir and path_fhandle LSM hooks
To: kernel-hardening@lists.openwall.com
Cc: linux-security-module@vger.kernel.org, keescook@chromium.org, spender@grsecurity.net, jmorris@namei.org, casey.schaufler@intel.com, michael.leibowitz@intel.com, william.c.roberts@intel.com, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

This introduces two new LSM hooks operating on paths.

  - security_path_fchdir() checks for permission on
    changing working directory. It can be used by
    LSMs concerned on fchdir system call
  - security_path_fhandle() checks for permission
    before converting file handle to path. It can be
    used by LSMs concerned with file handle transfers

Both hooks are under CONFIG_SECURITY_PATH.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 fs/fhandle.c              |  5 +++++
 fs/open.c                 |  3 +++
 include/linux/lsm_hooks.h | 12 ++++++++++++
 include/linux/security.h  | 13 +++++++++++++
 security/security.c       | 11 +++++++++++
 5 files changed, 44 insertions(+)

diff --git a/fs/fhandle.c b/fs/fhandle.c
index ca3c3dd..6e8aba5 100644
--- a/fs/fhandle.c
+++ b/fs/fhandle.c
@@ -8,6 +8,7 @@
 #include <linux/fs_struct.h>
 #include <linux/fsnotify.h>
 #include <linux/personality.h>
+#include <linux/security.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 #include "mount.h"
@@ -179,6 +180,10 @@ static int handle_to_path(int mountdirfd, struct file_handle __user *ufh,
 		retval = -EPERM;
 		goto out_err;
 	}
+	retval = security_path_fhandle(path);
+	if (retval)
+		goto out_err;
+
 	if (copy_from_user(&f_handle, ufh, sizeof(struct file_handle))) {
 		retval = -EFAULT;
 		goto out_err;
diff --git a/fs/open.c b/fs/open.c
index 93ae3cd..9c260d4 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -458,6 +458,9 @@ SYSCALL_DEFINE1(fchdir, unsigned int, fd)
 		goto out_putf;
 
 	error = inode_permission(inode, MAY_EXEC | MAY_CHDIR);
+	if (error)
+		goto out_putf;
+	error = security_path_fchdir(&f.file->f_path);
 	if (!error)
 		set_fs_pwd(current->fs, &f.file->f_path);
 out_putf:
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 7ae3976..25164b6 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -308,6 +308,14 @@
  *	Check for permission to change root directory.
  *	@path contains the path structure.
  *	Return 0 if permission is granted.
+ * @path_fchdir:
+ *	Check for permission to change working directory.
+ *	@path contains the path structure.
+ *	Return 0 if permission is granted.
+ * @path_fhandle:
+ *	Check for permission to convert handle to path.
+ *	@path contains the path structure.
+ *	Return 0 if permission is granted.
  * @inode_readlink:
  *	Check the permission to read the symbolic link.
  *	@dentry contains the dentry structure for the file link.
@@ -1378,6 +1386,8 @@ union security_list_options {
 	int (*path_chmod)(const struct path *path, umode_t mode);
 	int (*path_chown)(const struct path *path, kuid_t uid, kgid_t gid);
 	int (*path_chroot)(const struct path *path);
+	int (*path_fchdir)(const struct path *path);
+	int (*path_fhandle)(const struct path *path);
 #endif
 
 	int (*inode_alloc_security)(struct inode *inode);
@@ -1668,6 +1678,8 @@ struct security_hook_heads {
 	struct list_head path_chmod;
 	struct list_head path_chown;
 	struct list_head path_chroot;
+	struct list_head path_fchdir;
+	struct list_head path_fhandle;
 #endif
 	struct list_head inode_alloc_security;
 	struct list_head inode_free_security;
diff --git a/include/linux/security.h b/include/linux/security.h
index 14df373..6745c06 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1472,6 +1472,9 @@ int security_path_rename(const struct path *old_dir, struct dentry *old_dentry,
 int security_path_chmod(const struct path *path, umode_t mode);
 int security_path_chown(const struct path *path, kuid_t uid, kgid_t gid);
 int security_path_chroot(const struct path *path);
+int security_path_fchdir(const struct path *path);
+int security_path_fhandle(const struct path *path);
+
 #else	/* CONFIG_SECURITY_PATH */
 static inline int security_path_unlink(const struct path *dir, struct dentry *dentry)
 {
@@ -1536,6 +1539,16 @@ static inline int security_path_chroot(const struct path *path)
 {
 	return 0;
 }
+
+static inline int security_path_fchdir(const struct path *path)
+{
+	return 0;
+}
+
+static inline int security_path_fhandle(const struct path *path)
+{
+	return 0;
+}
 #endif	/* CONFIG_SECURITY_PATH */
 
 #ifdef CONFIG_KEYS
diff --git a/security/security.c b/security/security.c
index 7095693..cd82276 100644
--- a/security/security.c
+++ b/security/security.c
@@ -504,6 +504,15 @@ int security_path_chroot(const struct path *path)
 {
 	return call_int_hook(path_chroot, 0, path);
 }
+
+int security_path_fchdir(const struct path *path)
+{
+	return call_int_hook(path_fchdir, 0, path);
+}
+int security_path_fhandle(const struct path *path)
+{
+	return call_int_hook(path_fhandle, 0, path);
+}
 #endif
 
 int security_inode_create(struct inode *dir, struct dentry *dentry, umode_t mode)
@@ -1615,6 +1624,8 @@ struct security_hook_heads security_hook_heads = {
 	.path_chmod =	LIST_HEAD_INIT(security_hook_heads.path_chmod),
 	.path_chown =	LIST_HEAD_INIT(security_hook_heads.path_chown),
 	.path_chroot =	LIST_HEAD_INIT(security_hook_heads.path_chroot),
+	.path_fchdir =	LIST_HEAD_INIT(security_hook_heads.path_fchdir),
+	.path_fhandle =	LIST_HEAD_INIT(security_hook_heads.path_fhandle),
 #endif
 	.inode_alloc_security =
 		LIST_HEAD_INIT(security_hook_heads.inode_alloc_security),
-- 
1.9.1
