From: Casey Schaufler <casey.schaufler@intel.com>
Subject: [PATCH v6 2/5] Smack: Prepare for PTRACE_MODE_SCHED
Date: Mon,  5 Nov 2018 11:05:01 -0800
Message-Id: <20181105190504.500-3-casey.schaufler@intel.com>
In-Reply-To: <20181105190504.500-1-casey.schaufler@intel.com>
References: <20181105190504.500-1-casey.schaufler@intel.com>
To: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, casey.schaufler@intel.com, dave.hansen@intel.com, deneen.t.dock@intel.com, kristen@linux.intel.com, arjan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

From: Casey Schaufler <casey@schaufler-ca.com>

A ptrace access check with mode PTRACE_MODE_SCHED gets called
from process switching code. This precludes the use of audit,
as the locking is incompatible. Don't do audit in the PTRACE_MODE_SCHED
case.

Signed-off-by: Casey Schaufler <casey.schaufler@intel.com>
---
 security/smack/smack_lsm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 340fc30ad85d..ffa95bcab599 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -422,7 +422,8 @@ static int smk_ptrace_rule_check(struct task_struct *tracer,
 	struct task_smack *tsp;
 	struct smack_known *tracer_known;
 
-	if ((mode & PTRACE_MODE_NOAUDIT) == 0) {
+	if ((mode & PTRACE_MODE_NOAUDIT) == 0 &&
+	    (mode & PTRACE_MODE_SCHED) == 0) {
 		smk_ad_init(&ad, func, LSM_AUDIT_DATA_TASK);
 		smk_ad_setfield_u_tsk(&ad, tracer);
 		saip = &ad;
-- 
2.17.1
