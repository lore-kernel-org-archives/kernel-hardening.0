Reply-To: kernel-hardening@lists.openwall.com
From: Elena Reshetova <elena.reshetova@intel.com>
Date: Fri, 29 Jul 2016 10:34:37 +0300
Message-Id: <1469777680-3687-3-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1469777680-3687-1-git-send-email-elena.reshetova@intel.com>
References: <1469777680-3687-1-git-send-email-elena.reshetova@intel.com>
Subject: [kernel-hardening] [RFC] [PATCH 2/5] task_unshare LSM hook
To: kernel-hardening@lists.openwall.com
Cc: linux-security-module@vger.kernel.org, keescook@chromium.org, spender@grsecurity.net, jmorris@namei.org, casey.schaufler@intel.com, michael.leibowitz@intel.com, william.c.roberts@intel.com, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

This adds a new security_task_unshare() LSM hook.
It can be used by LSMs concerned about unshare
system call.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 include/linux/lsm_hooks.h | 14 ++++++++++++++
 include/linux/security.h  |  5 +++++
 kernel/fork.c             |  5 +++++
 security/security.c       | 11 +++++++++++
 4 files changed, 35 insertions(+)

diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 25164b6..e8b839e 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -667,6 +667,14 @@
  *	security attributes, e.g. for /proc/pid inodes.
  *	@p contains the task_struct for the task.
  *	@inode contains the inode structure for the inode.
+ * @task_unshare:
+ *	Check if process is allowed to unshare its namespaces
+ *	@unshare_flags flags
+ *	@new_fs contains the new fs_struct if created.
+ *	@new_fd contains the new files_struct if created.
+ *	@new_creds contains the new cred if created.
+ *	@new_nsproxy contains the new nsproxy if created.
+ *	Return 0 if permission is granted.
  *
  * Security hooks for Netlink messaging.
  *
@@ -1489,6 +1497,11 @@ union security_list_options {
 	int (*task_prctl)(int option, unsigned long arg2, unsigned long arg3,
 				unsigned long arg4, unsigned long arg5);
 	void (*task_to_inode)(struct task_struct *p, struct inode *inode);
+	int (*task_unshare)(unsigned long unshare_flags,
+				const struct fs_struct *new_fs,
+				const struct files_struct *new_fd,
+				const struct cred *new_cred,
+				const struct nsproxy *new_nsproxy);
 
 	int (*ipc_permission)(struct kern_ipc_perm *ipcp, short flag);
 	void (*ipc_getsecid)(struct kern_ipc_perm *ipcp, u32 *secid);
@@ -1748,6 +1761,7 @@ struct security_hook_heads {
 	struct list_head task_wait;
 	struct list_head task_prctl;
 	struct list_head task_to_inode;
+	struct list_head task_unshare;
 	struct list_head ipc_permission;
 	struct list_head ipc_getsecid;
 	struct list_head msg_msg_alloc_security;
diff --git a/include/linux/security.h b/include/linux/security.h
index 6745c06..6f935dc 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -331,6 +331,11 @@ int security_task_wait(struct task_struct *p);
 int security_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 			unsigned long arg4, unsigned long arg5);
 void security_task_to_inode(struct task_struct *p, struct inode *inode);
+int security_task_unshare(unsigned long unshare_flags,
+			const struct fs_struct *new_fs,
+			const struct files_struct *new_fd,
+			const struct cred *new_cred,
+			const struct nsproxy *new_nsproxy);
 int security_ipc_permission(struct kern_ipc_perm *ipcp, short flag);
 void security_ipc_getsecid(struct kern_ipc_perm *ipcp, u32 *secid);
 int security_msg_msg_alloc(struct msg_msg *msg);
diff --git a/kernel/fork.c b/kernel/fork.c
index 4a7ec0c..24cfd66 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2052,6 +2052,11 @@ SYSCALL_DEFINE1(unshare, unsigned long, unshare_flags)
 	if (err)
 		goto bad_unshare_cleanup_cred;
 
+	err = security_task_unshare(unshare_flags, new_fs, new_fd,
+			new_cred, new_nsproxy);
+	if (err)
+		goto bad_unshare_cleanup_cred;
+
 	if (new_fs || new_fd || do_sysvsem || new_cred || new_nsproxy) {
 		if (do_sysvsem) {
 			/*
diff --git a/security/security.c b/security/security.c
index cd82276..0e9544c 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1020,6 +1020,16 @@ void security_task_to_inode(struct task_struct *p, struct inode *inode)
 	call_void_hook(task_to_inode, p, inode);
 }
 
+int security_task_unshare(unsigned long unshare_flags,
+			const struct fs_struct *new_fs,
+			const struct files_struct *new_fd,
+			const struct cred *new_cred,
+			const struct nsproxy *new_nsproxy)
+{
+	return call_int_hook(task_unshare, 0, unshare_flags, new_fs,
+				new_fd, new_cred, new_nsproxy);
+}
+
 int security_ipc_permission(struct kern_ipc_perm *ipcp, short flag)
 {
 	return call_int_hook(ipc_permission, 0, ipcp, flag);
@@ -1736,6 +1746,7 @@ struct security_hook_heads security_hook_heads = {
 	.task_prctl =	LIST_HEAD_INIT(security_hook_heads.task_prctl),
 	.task_to_inode =
 		LIST_HEAD_INIT(security_hook_heads.task_to_inode),
+	.task_unshare = LIST_HEAD_INIT(security_hook_heads.task_unshare),
 	.ipc_permission =
 		LIST_HEAD_INIT(security_hook_heads.ipc_permission),
 	.ipc_getsecid =	LIST_HEAD_INIT(security_hook_heads.ipc_getsecid),
-- 
1.9.1
