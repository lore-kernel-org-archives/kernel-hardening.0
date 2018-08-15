From: Casey Schaufler <casey.schaufler@intel.com>
Subject: [PATCH RFC 2/5] X86: Support LSM determination of side-channel vulnerability
Date: Wed, 15 Aug 2018 16:53:52 -0700
Message-Id: <20180815235355.14908-3-casey.schaufler@intel.com>
In-Reply-To: <20180815235355.14908-1-casey.schaufler@intel.com>
References: <20180815235355.14908-1-casey.schaufler@intel.com>
To: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, SMACK-discuss@lists.01.org, casey.schaufler@intel.com, dave.hansen@intel.com, deneen.t.dock@intel.com, kristen@linux.intel.com, arjan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

From: Casey Schaufler <cschaufler@localhost.localdomain>

When switching between tasks it may be necessary
to set an indirect branch prediction barrier if the
tasks are potentially vulnerable to side-channel
attacks. This adds a call to security_task_safe_sidechannel
so that security modules can weigh in on the decision.

Signed-off-by: Casey Schaufler <casey.schaufler@intel.com>
---
 arch/x86/mm/tlb.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 6eb1f34c3c85..8714d4af06aa 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -7,6 +7,7 @@
 #include <linux/export.h>
 #include <linux/cpu.h>
 #include <linux/debugfs.h>
+#include <linux/security.h>
 
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
@@ -270,11 +271,14 @@ void switch_mm_irqs_off(struct mm_struct *prev, struct mm_struct *next,
 		 * threads. It will also not flush if we switch to idle
 		 * thread and back to the same process. It will flush if we
 		 * switch to a different non-dumpable process.
+		 * If a security module thinks that the transition
+		 * is unsafe do the flush.
 		 */
-		if (tsk && tsk->mm &&
-		    tsk->mm->context.ctx_id != last_ctx_id &&
-		    get_dumpable(tsk->mm) != SUID_DUMP_USER)
-			indirect_branch_prediction_barrier();
+		if (tsk && tsk->mm && tsk->mm->context.ctx_id != last_ctx_id) {
+			if (get_dumpable(tsk->mm) != SUID_DUMP_USER ||
+			    security_task_safe_sidechannel(tsk) != 0)
+				indirect_branch_prediction_barrier();
+		}
 
 		if (IS_ENABLED(CONFIG_VMAP_STACK)) {
 			/*
-- 
2.17.1
