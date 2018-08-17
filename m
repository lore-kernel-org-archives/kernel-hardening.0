From: Casey Schaufler <casey.schaufler@intel.com>
Subject: [PATCH RFC v2 1/5] LSM: Introduce a hook for side-channel danger
Date: Fri, 17 Aug 2018 15:16:20 -0700
Message-Id: <20180817221624.10232-2-casey.schaufler@intel.com>
In-Reply-To: <20180817221624.10232-1-casey.schaufler@intel.com>
References: <20180817221624.10232-1-casey.schaufler@intel.com>
To: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, casey.schaufler@intel.com, dave.hansen@intel.com, deneen.t.dock@intel.com, kristen@linux.intel.com, arjan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

From: Casey Schaufler <cschaufler@localhost.localdomain>

There may be cases where the data maintained for
security controls is more sensitive than general
process information and that may be subjected to
side-channel attacks. An LSM hook is provided so
that this can be check for where the system would
take action should the current task have potential
access to the passed task.

Signed-off-by: Casey Schaufler <casey.schaufler@intel.com>
---
 include/linux/lsm_hooks.h | 7 +++++++
 include/linux/security.h  | 1 +
 security/security.c       | 5 +++++
 3 files changed, 13 insertions(+)

diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index a08bc2587b96..fd2a7e6beb01 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -698,6 +698,11 @@
  *	security attributes, e.g. for /proc/pid inodes.
  *	@p contains the task_struct for the task.
  *	@inode contains the inode structure for the inode.
+ * @task_safe_sidechannel:
+ *	Check if a side channel attack is harmless for the current task and @p.
+ *	The caller may have determined that no attack is possible, in which
+ *	case this hook won't get called.
+ *	@p contains the task_struct for the task.
  *
  * Security hooks for Netlink messaging.
  *
@@ -1611,6 +1616,7 @@ union security_list_options {
 	int (*task_prctl)(int option, unsigned long arg2, unsigned long arg3,
 				unsigned long arg4, unsigned long arg5);
 	void (*task_to_inode)(struct task_struct *p, struct inode *inode);
+	int (*task_safe_sidechannel)(struct task_struct *p);
 
 	int (*ipc_permission)(struct kern_ipc_perm *ipcp, short flag);
 	void (*ipc_getsecid)(struct kern_ipc_perm *ipcp, u32 *secid);
@@ -1897,6 +1903,7 @@ struct security_hook_heads {
 	struct hlist_head task_kill;
 	struct hlist_head task_prctl;
 	struct hlist_head task_to_inode;
+	struct hlist_head task_safe_sidechannel;
 	struct hlist_head ipc_permission;
 	struct hlist_head ipc_getsecid;
 	struct hlist_head msg_msg_alloc_security;
diff --git a/include/linux/security.h b/include/linux/security.h
index 3410acfe139c..69a5526f789f 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -366,6 +366,7 @@ int security_task_kill(struct task_struct *p, struct siginfo *info,
 int security_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 			unsigned long arg4, unsigned long arg5);
 void security_task_to_inode(struct task_struct *p, struct inode *inode);
+int security_task_safe_sidechannel(struct task_struct *p);
 int security_ipc_permission(struct kern_ipc_perm *ipcp, short flag);
 void security_ipc_getsecid(struct kern_ipc_perm *ipcp, u32 *secid);
 int security_msg_msg_alloc(struct msg_msg *msg);
diff --git a/security/security.c b/security/security.c
index 4927e7cc7d96..353b711e635a 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1165,6 +1165,11 @@ void security_task_to_inode(struct task_struct *p, struct inode *inode)
 	call_void_hook(task_to_inode, p, inode);
 }
 
+int security_task_safe_sidechannel(struct task_struct *p)
+{
+	return call_int_hook(task_safe_sidechannel, 0, p);
+}
+
 int security_ipc_permission(struct kern_ipc_perm *ipcp, short flag)
 {
 	return call_int_hook(ipc_permission, 0, ipcp, flag);
-- 
2.17.1
