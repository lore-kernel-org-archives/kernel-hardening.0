From: Casey Schaufler <casey.schaufler@intel.com>
Subject: [PATCH v6 4/5] Capability: Complete PTRACE_MODE_SCHED
Date: Mon,  5 Nov 2018 11:05:03 -0800
Message-Id: <20181105190504.500-5-casey.schaufler@intel.com>
In-Reply-To: <20181105190504.500-1-casey.schaufler@intel.com>
References: <20181105190504.500-1-casey.schaufler@intel.com>
To: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, casey.schaufler@intel.com, dave.hansen@intel.com, deneen.t.dock@intel.com, kristen@linux.intel.com, arjan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

From: Casey Schaufler <casey@schaufler-ca.com>

Allow a complete ptrace access check with mode PTRACE_MODE_SCHED.
Disable the inappropriate privilege check in the capability code
that does incompatible locking.

Signed-off-by: Casey Schaufler <casey.schaufler@intel.com>
---
 kernel/ptrace.c      | 2 --
 security/commoncap.c | 3 ++-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 99cfddde6a55..0b6a9df51c3b 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -331,8 +331,6 @@ static int __ptrace_may_access(struct task_struct *task, unsigned int mode)
 	     !ptrace_has_cap(mm->user_ns, mode)))
 	    return -EPERM;
 
-	if (mode & PTRACE_MODE_SCHED)
-		return 0;
 	return security_ptrace_access_check(task, mode);
 }
 
diff --git a/security/commoncap.c b/security/commoncap.c
index 2e489d6a3ac8..70a7e3d19c16 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -152,7 +152,8 @@ int cap_ptrace_access_check(struct task_struct *child, unsigned int mode)
 	if (cred->user_ns == child_cred->user_ns &&
 	    cap_issubset(child_cred->cap_permitted, *caller_caps))
 		goto out;
-	if (ns_capable(child_cred->user_ns, CAP_SYS_PTRACE))
+	if (!(mode & PTRACE_MODE_SCHED) &&
+	    ns_capable(child_cred->user_ns, CAP_SYS_PTRACE))
 		goto out;
 	ret = -EPERM;
 out:
-- 
2.17.1
