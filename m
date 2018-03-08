From: Tycho Andersen <tycho@tycho.ws>
Subject: [PATCH v2] ima: drop vla in ima_audit_measurement()
Date: Thu,  8 Mar 2018 13:23:47 -0700
Message-Id: <20180308202347.31331-1-tycho@tycho.ws>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Tycho Andersen <tycho@tycho.ws>
List-ID: <kernel-hardening.lists.openwall.com>

In keeping with the directive to get rid of VLAs [1], let's drop the VLA
from ima_audit_measurement(). We need to adjust the return type of
ima_audit_measurement, because now this function can fail if an allocation
fails.

[1]: https://lkml.org/lkml/2018/3/7/621

v2: just use audit_log_format instead of doing a second allocation

Signed-off-by: Tycho Andersen <tycho@tycho.ws>
---
 security/integrity/ima/ima.h      |  4 ++--
 security/integrity/ima/ima_api.c  | 22 +++++++++++++---------
 security/integrity/ima/ima_main.c |  7 +++++--
 3 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index d52b487ad259..8e2470f72f7f 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -201,8 +201,8 @@ void ima_store_measurement(struct integrity_iint_cache *iint, struct file *file,
 			   const unsigned char *filename,
 			   struct evm_ima_xattr_data *xattr_value,
 			   int xattr_len, int pcr);
-void ima_audit_measurement(struct integrity_iint_cache *iint,
-			   const unsigned char *filename);
+int ima_audit_measurement(struct integrity_iint_cache *iint,
+			  const unsigned char *filename);
 int ima_alloc_init_template(struct ima_event_data *event_data,
 			    struct ima_template_entry **entry);
 int ima_store_template(struct ima_template_entry *entry, int violation,
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 08fe405338e1..3a4442405cc8 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -304,17 +304,20 @@ void ima_store_measurement(struct integrity_iint_cache *iint,
 		ima_free_template_entry(entry);
 }
 
-void ima_audit_measurement(struct integrity_iint_cache *iint,
-			   const unsigned char *filename)
+int ima_audit_measurement(struct integrity_iint_cache *iint,
+			  const unsigned char *filename)
 {
 	struct audit_buffer *ab;
-	char hash[(iint->ima_hash->length * 2) + 1];
+	char *hash;
 	const char *algo_name = hash_algo_name[iint->ima_hash->algo];
-	char algo_hash[sizeof(hash) + strlen(algo_name) + 2];
 	int i;
 
 	if (iint->flags & IMA_AUDITED)
-		return;
+		return 0;
+
+	hash = kzalloc((iint->ima_hash->length * 2) + 1, GFP_KERNEL);
+	if (!hash)
+		return -ENOMEM;
 
 	for (i = 0; i < iint->ima_hash->length; i++)
 		hex_byte_pack(hash + (i * 2), iint->ima_hash->digest[i]);
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
+	return 0;
 }
 
 /*
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 2cfb0c714967..356faae6f09c 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -288,8 +288,11 @@ static int process_measurement(struct file *file, char *buf, loff_t size,
 					      xattr_value, xattr_len, opened);
 		inode_unlock(inode);
 	}
-	if (action & IMA_AUDIT)
-		ima_audit_measurement(iint, pathname);
+	if (action & IMA_AUDIT) {
+		rc = ima_audit_measurement(iint, pathname);
+		if (rc < 0)
+			goto out_locked;
+	}
 
 	if ((file->f_flags & O_DIRECT) && (iint->flags & IMA_PERMIT_DIRECTIO))
 		rc = 0;
-- 
2.14.1
