From: Tycho Andersen <tycho@tycho.ws>
Subject: [PATCH v3] ima: drop vla in ima_audit_measurement()
Date: Thu,  8 Mar 2018 16:08:36 -0700
Message-Id: <20180308230836.24329-1-tycho@tycho.ws>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Tycho Andersen <tycho@tycho.ws>
List-ID: <kernel-hardening.lists.openwall.com>

In keeping with the directive to get rid of VLAs [1], let's drop the VLA
from ima_audit_measurement(). We need to adjust the return type of
ima_audit_measurement, because now this function can fail if an allocation
fails.

[1]: https://lkml.org/lkml/2018/3/7/621

v2: just use audit_log_format instead of doing a second allocation
v3: ignore failures in ima_audit_measurement()

Signed-off-by: Tycho Andersen <tycho@tycho.ws>
---
 security/integrity/ima/ima_api.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 08fe405338e1..2aab9170ef68 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -308,14 +308,17 @@ void ima_audit_measurement(struct integrity_iint_cache *iint,
 			   const unsigned char *filename)
 {
 	struct audit_buffer *ab;
-	char hash[(iint->ima_hash->length * 2) + 1];
+	char *hash;
 	const char *algo_name = hash_algo_name[iint->ima_hash->algo];
-	char algo_hash[sizeof(hash) + strlen(algo_name) + 2];
 	int i;
 
 	if (iint->flags & IMA_AUDITED)
 		return;
 
+	hash = kzalloc((iint->ima_hash->length * 2) + 1, GFP_KERNEL);
+	if (!hash)
+		return;
+
 	for (i = 0; i < iint->ima_hash->length; i++)
 		hex_byte_pack(hash + (i * 2), iint->ima_hash->digest[i]);
 	hash[i * 2] = '\0';
@@ -323,18 +326,19 @@ void ima_audit_measurement(struct integrity_iint_cache *iint,
 	ab = audit_log_start(current->audit_context, GFP_KERNEL,
 			     AUDIT_INTEGRITY_RULE);
 	if (!ab)
-		return;
+		goto out;
 
 	audit_log_format(ab, "file=");
 	audit_log_untrustedstring(ab, filename);
-	audit_log_format(ab, " hash=");
-	snprintf(algo_hash, sizeof(algo_hash), "%s:%s", algo_name, hash);
-	audit_log_untrustedstring(ab, algo_hash);
+	audit_log_format(ab, " hash=\"%s:%s\"", algo_name, hash);
 
 	audit_log_task_info(ab, current);
 	audit_log_end(ab);
 
 	iint->flags |= IMA_AUDITED;
+out:
+	kfree(hash);
+	return;
 }
 
 /*
-- 
2.14.1
