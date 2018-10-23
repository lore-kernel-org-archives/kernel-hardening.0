From: Igor Stoppa <igor.stoppa@gmail.com>
Subject: [PATCH 17/17] prmem: ima: turn the measurements list write rare
Date: Wed, 24 Oct 2018 00:35:04 +0300
Message-Id: <20181023213504.28905-18-igor.stoppa@huawei.com>
In-Reply-To: <20181023213504.28905-1-igor.stoppa@huawei.com>
References: <20181023213504.28905-1-igor.stoppa@huawei.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>, Matthew Wilcox <willy@infradead.org>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, kernel-hardening@lists.openwall.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: igor.stoppa@huawei.com, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

The measurement list is moved to write rare memory, including
related data structures.

Various boilerplate linux data structures and related functions are
replaced by their write-rare counterpart.

Signed-off-by: Igor Stoppa <igor.stoppa@huawei.com>
CC: Mimi Zohar <zohar@linux.vnet.ibm.com>
CC: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
CC: James Morris <jmorris@namei.org>
CC: "Serge E. Hallyn" <serge@hallyn.com>
CC: linux-integrity@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---
 security/integrity/ima/ima.h              | 18 ++++++++------
 security/integrity/ima/ima_api.c          | 29 +++++++++++++----------
 security/integrity/ima/ima_fs.c           | 12 +++++-----
 security/integrity/ima/ima_main.c         |  6 +++++
 security/integrity/ima/ima_queue.c        | 28 +++++++++++++---------
 security/integrity/ima/ima_template.c     | 14 ++++++-----
 security/integrity/ima/ima_template_lib.c | 14 +++++++----
 7 files changed, 74 insertions(+), 47 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 67db9d9454ca..5f5959753bf5 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -24,6 +24,8 @@
 #include <linux/hash.h>
 #include <linux/tpm.h>
 #include <linux/audit.h>
+#include <linux/prlist.h>
+#include <linux/pratomic-long.h>
 #include <crypto/hash_info.h>
 
 #include "../integrity.h"
@@ -84,7 +86,7 @@ struct ima_template_field {
 
 /* IMA template descriptor definition */
 struct ima_template_desc {
-	struct list_head list;
+	union prlist_head list;
 	char *name;
 	char *fmt;
 	int num_fields;
@@ -100,11 +102,13 @@ struct ima_template_entry {
 };
 
 struct ima_queue_entry {
-	struct hlist_node hnext;	/* place in hash collision list */
-	struct list_head later;		/* place in ima_measurements list */
+	union prhlist_node hnext;	/* place in hash collision list */
+	union prlist_head later;	/* place in ima_measurements list */
 	struct ima_template_entry *entry;
 };
-extern struct list_head ima_measurements;	/* list of all measurements */
+
+/* list of all measurements */
+extern union prlist_head ima_measurements __wr_after_init;
 
 /* Some details preceding the binary serialized measurement list */
 struct ima_kexec_hdr {
@@ -160,9 +164,9 @@ void ima_init_template_list(void);
 extern spinlock_t ima_queue_lock;
 
 struct ima_h_table {
-	atomic_long_t len;	/* number of stored measurements in the list */
-	atomic_long_t violations;
-	struct hlist_head queue[IMA_MEASURE_HTABLE_SIZE];
+	struct pratomic_long_t len;	/* # of measurements in the list */
+	struct pratomic_long_t violations;
+	union prhlist_head queue[IMA_MEASURE_HTABLE_SIZE];
 };
 extern struct ima_h_table ima_htable;
 
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index a02c5acfd403..4fc28c2478b0 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -19,9 +19,12 @@
 #include <linux/xattr.h>
 #include <linux/evm.h>
 #include <linux/iversion.h>
+#include <linux/prmemextra.h>
+#include <linux/pratomic-long.h>
 
 #include "ima.h"
 
+extern struct pmalloc_pool ima_pool;
 /*
  * ima_free_template_entry - free an existing template entry
  */
@@ -29,10 +32,10 @@ void ima_free_template_entry(struct ima_template_entry *entry)
 {
 	int i;
 
-	for (i = 0; i < entry->template_desc->num_fields; i++)
-		kfree(entry->template_data[i].data);
+//	for (i = 0; i < entry->template_desc->num_fields; i++)
+//		kfree(entry->template_data[i].data);
 
-	kfree(entry);
+//	kfree(entry);
 }
 
 /*
@@ -44,12 +47,13 @@ int ima_alloc_init_template(struct ima_event_data *event_data,
 	struct ima_template_desc *template_desc = ima_template_desc_current();
 	int i, result = 0;
 
-	*entry = kzalloc(sizeof(**entry) + template_desc->num_fields *
-			 sizeof(struct ima_field_data), GFP_NOFS);
+	*entry = pzalloc(&ima_pool,
+			 sizeof(**entry) + template_desc->num_fields *
+			 sizeof(struct ima_field_data));
 	if (!*entry)
 		return -ENOMEM;
 
-	(*entry)->template_desc = template_desc;
+	wr_ptr(&((*entry)->template_desc), template_desc);
 	for (i = 0; i < template_desc->num_fields; i++) {
 		struct ima_template_field *field = template_desc->fields[i];
 		u32 len;
@@ -59,9 +63,10 @@ int ima_alloc_init_template(struct ima_event_data *event_data,
 		if (result != 0)
 			goto out;
 
-		len = (*entry)->template_data[i].len;
-		(*entry)->template_data_len += sizeof(len);
-		(*entry)->template_data_len += len;
+		len = (*entry)->template_data_len + sizeof(len) +
+			(*entry)->template_data[i].len;
+		wr_memcpy(&(*entry)->template_data_len, &len,
+			  sizeof(len));
 	}
 	return 0;
 out:
@@ -113,9 +118,9 @@ int ima_store_template(struct ima_template_entry *entry,
 					    audit_cause, result, 0);
 			return result;
 		}
-		memcpy(entry->digest, hash.hdr.digest, hash.hdr.length);
+		wr_memcpy(entry->digest, hash.hdr.digest, hash.hdr.length);
 	}
-	entry->pcr = pcr;
+	wr_int(&entry->pcr, pcr);
 	result = ima_add_template_entry(entry, violation, op, inode, filename);
 	return result;
 }
@@ -139,7 +144,7 @@ void ima_add_violation(struct file *file, const unsigned char *filename,
 	int result;
 
 	/* can overflow, only indicator */
-	atomic_long_inc(&ima_htable.violations);
+	pratomic_long_inc(&ima_htable.violations);
 
 	result = ima_alloc_init_template(&event_data, &entry);
 	if (result < 0) {
diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
index ae9d5c766a3c..ab20da1161c7 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -57,7 +57,8 @@ static ssize_t ima_show_htable_violations(struct file *filp,
 					  char __user *buf,
 					  size_t count, loff_t *ppos)
 {
-	return ima_show_htable_value(buf, count, ppos, &ima_htable.violations);
+	return ima_show_htable_value(buf, count, ppos,
+				     &ima_htable.violations.l);
 }
 
 static const struct file_operations ima_htable_violations_ops = {
@@ -69,8 +70,7 @@ static ssize_t ima_show_measurements_count(struct file *filp,
 					   char __user *buf,
 					   size_t count, loff_t *ppos)
 {
-	return ima_show_htable_value(buf, count, ppos, &ima_htable.len);
-
+	return ima_show_htable_value(buf, count, ppos, &ima_htable.len.l);
 }
 
 static const struct file_operations ima_measurements_count_ops = {
@@ -86,7 +86,7 @@ static void *ima_measurements_start(struct seq_file *m, loff_t *pos)
 
 	/* we need a lock since pos could point beyond last element */
 	rcu_read_lock();
-	list_for_each_entry_rcu(qe, &ima_measurements, later) {
+	list_for_each_entry_rcu(qe, &ima_measurements.list, later.list) {
 		if (!l--) {
 			rcu_read_unlock();
 			return qe;
@@ -303,7 +303,7 @@ static ssize_t ima_read_policy(char *path)
 		size -= rc;
 	}
 
-	vfree(data);
+//	vfree(data);
 	if (rc < 0)
 		return rc;
 	else if (size)
@@ -350,7 +350,7 @@ static ssize_t ima_write_policy(struct file *file, const char __user *buf,
 	}
 	mutex_unlock(&ima_write_mutex);
 out_free:
-	kfree(data);
+//	kfree(data);
 out:
 	if (result < 0)
 		valid_policy = 0;
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 2d31921fbda4..d52e59006781 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -29,6 +29,7 @@
 #include <linux/ima.h>
 #include <linux/iversion.h>
 #include <linux/fs.h>
+#include <linux/prlist.h>
 
 #include "ima.h"
 
@@ -536,10 +537,15 @@ int ima_load_data(enum kernel_load_data_id id)
 	return 0;
 }
 
+struct pmalloc_pool ima_pool;
+
+#define IMA_POOL_ALLOC_CHUNK (16 * PAGE_SIZE)
 static int __init init_ima(void)
 {
 	int error;
 
+	pmalloc_init_custom_pool(&ima_pool, IMA_POOL_ALLOC_CHUNK, 3,
+				 PMALLOC_MODE_START_WR);
 	ima_init_template_list();
 	hash_setup(CONFIG_IMA_DEFAULT_HASH);
 	error = ima_init();
diff --git a/security/integrity/ima/ima_queue.c b/security/integrity/ima/ima_queue.c
index b186819bd5aa..444c47b745d8 100644
--- a/security/integrity/ima/ima_queue.c
+++ b/security/integrity/ima/ima_queue.c
@@ -24,11 +24,14 @@
 #include <linux/module.h>
 #include <linux/rculist.h>
 #include <linux/slab.h>
+#include <linux/prmemextra.h>
+#include <linux/prlist.h>
+#include <linux/pratomic-long.h>
 #include "ima.h"
 
 #define AUDIT_CAUSE_LEN_MAX 32
 
-LIST_HEAD(ima_measurements);	/* list of all measurements */
+PRLIST_HEAD(ima_measurements);	/* list of all measurements */
 #ifdef CONFIG_IMA_KEXEC
 static unsigned long binary_runtime_size;
 #else
@@ -36,9 +39,9 @@ static unsigned long binary_runtime_size = ULONG_MAX;
 #endif
 
 /* key: inode (before secure-hashing a file) */
-struct ima_h_table ima_htable = {
-	.len = ATOMIC_LONG_INIT(0),
-	.violations = ATOMIC_LONG_INIT(0),
+struct ima_h_table ima_htable __wr_after_init = {
+	.len = PRATOMIC_LONG_INIT(0),
+	.violations = PRATOMIC_LONG_INIT(0),
 	.queue[0 ... IMA_MEASURE_HTABLE_SIZE - 1] = HLIST_HEAD_INIT
 };
 
@@ -58,7 +61,7 @@ static struct ima_queue_entry *ima_lookup_digest_entry(u8 *digest_value,
 
 	key = ima_hash_key(digest_value);
 	rcu_read_lock();
-	hlist_for_each_entry_rcu(qe, &ima_htable.queue[key], hnext) {
+	hlist_for_each_entry_rcu(qe, &ima_htable.queue[key], hnext.node) {
 		rc = memcmp(qe->entry->digest, digest_value, TPM_DIGEST_SIZE);
 		if ((rc == 0) && (qe->entry->pcr == pcr)) {
 			ret = qe;
@@ -87,6 +90,8 @@ static int get_binary_runtime_size(struct ima_template_entry *entry)
 	return size;
 }
 
+extern struct pmalloc_pool ima_pool;
+
 /* ima_add_template_entry helper function:
  * - Add template entry to the measurement list and hash table, for
  *   all entries except those carried across kexec.
@@ -99,20 +104,21 @@ static int ima_add_digest_entry(struct ima_template_entry *entry,
 	struct ima_queue_entry *qe;
 	unsigned int key;
 
-	qe = kmalloc(sizeof(*qe), GFP_KERNEL);
+	qe = pmalloc(&ima_pool, sizeof(*qe));
 	if (qe == NULL) {
 		pr_err("OUT OF MEMORY ERROR creating queue entry\n");
 		return -ENOMEM;
 	}
-	qe->entry = entry;
+	wr_ptr(&qe->entry, entry);
+	INIT_PRLIST_HEAD(&qe->later);
+	prlist_add_tail_rcu(&qe->later, &ima_measurements);
+
 
-	INIT_LIST_HEAD(&qe->later);
-	list_add_tail_rcu(&qe->later, &ima_measurements);
+	pratomic_long_inc(&ima_htable.len);
 
-	atomic_long_inc(&ima_htable.len);
 	if (update_htable) {
 		key = ima_hash_key(entry->digest);
-		hlist_add_head_rcu(&qe->hnext, &ima_htable.queue[key]);
+		prhlist_add_head_rcu(&qe->hnext, &ima_htable.queue[key]);
 	}
 
 	if (binary_runtime_size != ULONG_MAX) {
diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index 30db39b23804..40ae57a17d89 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -22,14 +22,15 @@
 enum header_fields { HDR_PCR, HDR_DIGEST, HDR_TEMPLATE_NAME,
 		     HDR_TEMPLATE_DATA, HDR__LAST };
 
-static struct ima_template_desc builtin_templates[] = {
+static struct ima_template_desc builtin_templates[] __wr_after_init = {
 	{.name = IMA_TEMPLATE_IMA_NAME, .fmt = IMA_TEMPLATE_IMA_FMT},
 	{.name = "ima-ng", .fmt = "d-ng|n-ng"},
 	{.name = "ima-sig", .fmt = "d-ng|n-ng|sig"},
 	{.name = "", .fmt = ""},	/* placeholder for a custom format */
 };
 
-static LIST_HEAD(defined_templates);
+static PRLIST_HEAD(defined_templates);
+
 static DEFINE_SPINLOCK(template_list);
 
 static struct ima_template_field supported_fields[] = {
@@ -114,7 +115,8 @@ static struct ima_template_desc *lookup_template_desc(const char *name)
 	int found = 0;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(template_desc, &defined_templates, list) {
+	list_for_each_entry_rcu(template_desc, &defined_templates.list,
+				list.list) {
 		if ((strcmp(template_desc->name, name) == 0) ||
 		    (strcmp(template_desc->fmt, name) == 0)) {
 			found = 1;
@@ -207,12 +209,12 @@ void ima_init_template_list(void)
 {
 	int i;
 
-	if (!list_empty(&defined_templates))
+	if (!list_empty(&defined_templates.list))
 		return;
 
 	spin_lock(&template_list);
 	for (i = 0; i < ARRAY_SIZE(builtin_templates); i++) {
-		list_add_tail_rcu(&builtin_templates[i].list,
+		prlist_add_tail_rcu(&builtin_templates[i].list,
 				  &defined_templates);
 	}
 	spin_unlock(&template_list);
@@ -266,7 +268,7 @@ static struct ima_template_desc *restore_template_fmt(char *template_name)
 		goto out;
 
 	spin_lock(&template_list);
-	list_add_tail_rcu(&template_desc->list, &defined_templates);
+	prlist_add_tail_rcu(&template_desc->list, &defined_templates);
 	spin_unlock(&template_list);
 out:
 	return template_desc;
diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
index 43752002c222..a6d10eabf0e5 100644
--- a/security/integrity/ima/ima_template_lib.c
+++ b/security/integrity/ima/ima_template_lib.c
@@ -15,8 +15,12 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
+#include <linux/prmemextra.h>
 #include "ima_template_lib.h"
 
+extern struct pmalloc_pool ima_pool;
+
 static bool ima_template_hash_algo_allowed(u8 algo)
 {
 	if (algo == HASH_ALGO_SHA1 || algo == HASH_ALGO_MD5)
@@ -42,11 +46,11 @@ static int ima_write_template_field_data(const void *data, const u32 datalen,
 	if (datafmt == DATA_FMT_STRING)
 		buflen = datalen + 1;
 
-	buf = kzalloc(buflen, GFP_KERNEL);
+	buf = pzalloc(&ima_pool, buflen);
 	if (!buf)
 		return -ENOMEM;
 
-	memcpy(buf, data, datalen);
+	wr_memcpy(buf, data, datalen);
 
 	/*
 	 * Replace all space characters with underscore for event names and
@@ -58,11 +62,11 @@ static int ima_write_template_field_data(const void *data, const u32 datalen,
 	if (datafmt == DATA_FMT_STRING) {
 		for (buf_ptr = buf; buf_ptr - buf < datalen; buf_ptr++)
 			if (*buf_ptr == ' ')
-				*buf_ptr = '_';
+				wr_char(buf_ptr, '_');
 	}
 
-	field_data->data = buf;
-	field_data->len = buflen;
+	wr_ptr(&field_data->data, buf);
+	wr_memcpy(&field_data->len, &buflen, sizeof(buflen));
 	return 0;
 }
 
-- 
2.17.1
