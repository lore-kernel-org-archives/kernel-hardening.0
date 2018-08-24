From: Casey Schaufler <casey.schaufler@intel.com>
Subject: [PATCH v4 4/5] Smack: Support determination of side-channel
Date: Fri, 24 Aug 2018 15:41:16 -0700
Message-Id: <20180824224117.3356-5-casey.schaufler@intel.com>
In-Reply-To: <20180824224117.3356-1-casey.schaufler@intel.com>
References: <20180824224117.3356-1-casey.schaufler@intel.com>
To: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, casey.schaufler@intel.com, dave.hansen@intel.com, deneen.t.dock@intel.com, kristen@linux.intel.com, arjan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

Smack considers its private task data safe if the current task
has read access to the passed task.

Signed-off-by: Casey Schaufler <casey.schaufler@intel.com>
---
 security/smack/smack_lsm.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 91750205a5de..85dc053e610c 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2299,6 +2299,23 @@ static void smack_task_to_inode(struct task_struct *p, struct inode *inode)
 	isp->smk_inode = skp;
 }
 
+/**
+ * smack_task_safe_sidechannel - Are the task and current sidechannel safe?
+ * @p: task to check on
+ *
+ * A crude value for sidechannel safety is that the current task is
+ * already allowed to read from the other.
+ *
+ * Returns 0 if the tasks are sidechannel safe, -EACCES otherwise.
+ */
+static int smack_task_safe_sidechannel(struct task_struct *p)
+{
+	struct smack_known *skp = smk_of_task_struct(p);
+	struct smack_known *ckp = smk_of_task_struct(current);
+
+	return smk_access(ckp, skp, MAY_READ, NULL);
+}
+
 /*
  * Socket hooks.
  */
@@ -4718,6 +4735,7 @@ static struct security_hook_list smack_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(task_movememory, smack_task_movememory),
 	LSM_HOOK_INIT(task_kill, smack_task_kill),
 	LSM_HOOK_INIT(task_to_inode, smack_task_to_inode),
+	LSM_HOOK_INIT(task_safe_sidechannel, smack_task_safe_sidechannel),
 
 	LSM_HOOK_INIT(ipc_permission, smack_ipc_permission),
 	LSM_HOOK_INIT(ipc_getsecid, smack_ipc_getsecid),
-- 
2.17.1
