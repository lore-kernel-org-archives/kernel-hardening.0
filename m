From: Casey Schaufler <casey.schaufler@intel.com>
Subject: [PATCH v5 3/5] SELinux: Prepare for PTRACE_MODE_SCHED
Date: Wed, 26 Sep 2018 13:34:44 -0700
Message-Id: <20180926203446.2004-4-casey.schaufler@intel.com>
In-Reply-To: <20180926203446.2004-1-casey.schaufler@intel.com>
References: <20180926203446.2004-1-casey.schaufler@intel.com>
To: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, casey.schaufler@intel.com, dave.hansen@intel.com, deneen.t.dock@intel.com, kristen@linux.intel.com, arjan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

From: Casey Schaufler <casey@schaufler-ca.com>

A ptrace access check with mode PTRACE_MODE_SCHED gets called
from process switching code. This precludes the use of audit or avc,
as the locking is incompatible. The only available check that
can be made without using avc is a comparison of the secids.
This is not very satisfactory as it will indicate possible
vulnerabilies much too aggressively.

Signed-off-by: Casey Schaufler <casey.schaufler@intel.com>
---
 security/selinux/hooks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index ad9a9b8e9979..160239791007 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2267,6 +2267,8 @@ static int selinux_ptrace_access_check(struct task_struct *child,
 	u32 sid = current_sid();
 	u32 csid = task_sid(child);
 
+	if (mode & PTRACE_MODE_SCHED)
+		return sid == csid ? 0 : -EACCES;
 	if (mode & PTRACE_MODE_READ)
 		return avc_has_perm(&selinux_state,
 				    sid, csid, SECCLASS_FILE, FILE__READ, NULL);
-- 
2.17.1
