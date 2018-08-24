From: Casey Schaufler <casey.schaufler@intel.com>
Subject: [PATCH v4 5/5] SELinux: Support SELinux determination of side-channel
Date: Fri, 24 Aug 2018 15:41:17 -0700
Message-Id: <20180824224117.3356-6-casey.schaufler@intel.com>
In-Reply-To: <20180824224117.3356-1-casey.schaufler@intel.com>
References: <20180824224117.3356-1-casey.schaufler@intel.com>
To: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, casey.schaufler@intel.com, dave.hansen@intel.com, deneen.t.dock@intel.com, kristen@linux.intel.com, arjan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

SELinux considers tasks to be side-channel safe if they
have FILE__READ access.

Signed-off-by: Casey Schaufler <casey.schaufler@intel.com>
---
 security/selinux/hooks.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index a8bf324130f5..992f2402edaa 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4219,6 +4219,14 @@ static void selinux_task_to_inode(struct task_struct *p,
 	spin_unlock(&isec->lock);
 }
 
+static int selinux_task_safe_sidechannel(struct task_struct *p)
+{
+	struct av_decision avd;
+
+	return avc_has_perm_noaudit(&selinux_state, current_sid(), task_sid(p),
+				    SECCLASS_FILE, FILE__READ, 0, &avd);
+}
+
 /* Returns error only if unable to parse addresses */
 static int selinux_parse_skb_ipv4(struct sk_buff *skb,
 			struct common_audit_data *ad, u8 *proto)
@@ -7002,6 +7010,7 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(task_movememory, selinux_task_movememory),
 	LSM_HOOK_INIT(task_kill, selinux_task_kill),
 	LSM_HOOK_INIT(task_to_inode, selinux_task_to_inode),
+	LSM_HOOK_INIT(task_safe_sidechannel, selinux_task_safe_sidechannel),
 
 	LSM_HOOK_INIT(ipc_permission, selinux_ipc_permission),
 	LSM_HOOK_INIT(ipc_getsecid, selinux_ipc_getsecid),
-- 
2.17.1
