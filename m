From: Igor Stoppa <igor.stoppa@gmail.com>
Subject: [RFC PATCH v4 12/12] IMA: turn ima_policy_flags into __wr_after_init
Date: Tue, 12 Feb 2019 01:27:49 +0200
Message-Id: <93a44c8854b914fb9558fd37b7c4c9ee6051c20c.1549927666.git.igor.stoppa@huawei.com>
In-Reply-To: <cover.1549927666.git.igor.stoppa@huawei.com>
References: <cover.1549927666.git.igor.stoppa@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: Igor Stoppa <igor.stoppa@huawei.com>, Andy Lutomirski <luto@amacapital.net>, Nadav Amit <nadav.amit@gmail.com>, Matthew Wilcox <willy@infradead.org>, Peter Zijlstra <peterz@infradead.org>, Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@linux.intel.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Thiago Jung Bauermann <bauerman@linux.ibm.com>, Ahmed Soliman <ahmedsoliman@mena.vt.edu>, linux-integrity@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

The policy flags could be targeted by an attacker aiming at disabling IMA,
so that there would be no trace of a file system modification in the
measurement list.

Since the flags can be altered at runtime, it is not possible to make
them become fully read-only, for example with __ro_after_init.

__wr_after_init can still provide some protection, at least against
simple memory overwrite attacks

Signed-off-by: Igor Stoppa <igor.stoppa@huawei.com>

CC: Andy Lutomirski <luto@amacapital.net>
CC: Nadav Amit <nadav.amit@gmail.com>
CC: Matthew Wilcox <willy@infradead.org>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Kees Cook <keescook@chromium.org>
CC: Dave Hansen <dave.hansen@linux.intel.com>
CC: Mimi Zohar <zohar@linux.vnet.ibm.com>
CC: Thiago Jung Bauermann <bauerman@linux.ibm.com>
CC: Ahmed Soliman <ahmedsoliman@mena.vt.edu>
CC: linux-integrity@vger.kernel.org
CC: kernel-hardening@lists.openwall.com
CC: linux-mm@kvack.org
CC: linux-kernel@vger.kernel.org
---
 security/integrity/ima/ima.h        | 3 ++-
 security/integrity/ima/ima_policy.c | 9 +++++----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index cc12f3449a72..297c25f5122e 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -24,6 +24,7 @@
 #include <linux/hash.h>
 #include <linux/tpm.h>
 #include <linux/audit.h>
+#include <linux/prmem.h>
 #include <crypto/hash_info.h>
 
 #include "../integrity.h"
@@ -50,7 +51,7 @@ enum tpm_pcrs { TPM_PCR0 = 0, TPM_PCR8 = 8 };
 #define IMA_TEMPLATE_IMA_FMT "d|n"
 
 /* current content of the policy */
-extern int ima_policy_flag;
+extern int ima_policy_flag __wr_after_init;
 
 /* set during initialization */
 extern int ima_hash_algo;
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 8bc8a1c8cb3f..d49c545b9cfb 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -48,7 +48,7 @@
 #define INVALID_PCR(a) (((a) < 0) || \
 	(a) >= (FIELD_SIZEOF(struct integrity_iint_cache, measured_pcrs) * 8))
 
-int ima_policy_flag;
+int ima_policy_flag __wr_after_init;
 static int temp_ima_appraise;
 static int build_ima_appraise __ro_after_init;
 
@@ -460,12 +460,13 @@ void ima_update_policy_flag(void)
 
 	list_for_each_entry(entry, ima_rules, list) {
 		if (entry->action & IMA_DO_MASK)
-			ima_policy_flag |= entry->action;
+			wr_assign(ima_policy_flag,
+				  ima_policy_flag | entry->action);
 	}
 
 	ima_appraise |= (build_ima_appraise | temp_ima_appraise);
 	if (!ima_appraise)
-		ima_policy_flag &= ~IMA_APPRAISE;
+		wr_assign(ima_policy_flag, ima_policy_flag & ~IMA_APPRAISE);
 }
 
 static int ima_appraise_flag(enum ima_hooks func)
@@ -651,7 +652,7 @@ void ima_update_policy(void)
 	list_splice_tail_init_rcu(&ima_temp_rules, policy, synchronize_rcu);
 
 	if (ima_rules != policy) {
-		ima_policy_flag = 0;
+		wr_assign(ima_policy_flag, 0);
 		ima_rules = policy;
 
 		/*
-- 
2.19.1
