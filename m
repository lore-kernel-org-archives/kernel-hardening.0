Reply-To: kernel-hardening@lists.openwall.com
From: Elena Reshetova <elena.reshetova@intel.com>
Date: Mon,  3 Oct 2016 09:41:21 +0300
Message-Id: <1475476886-26232-9-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1475476886-26232-1-git-send-email-elena.reshetova@intel.com>
References: <1475476886-26232-1-git-send-email-elena.reshetova@intel.com>
Subject: [kernel-hardening] [RFC PATCH 08/13] security: identify wrapping atomic usage
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, David Windsor <dwindsor@gmail.com>, Hans Liljestrand <ishkamiel@gmail.com>, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: David Windsor <dwindsor@gmail.com>

In some cases atomic is not used for reference
counting and therefore should be allowed to overflow.
Identify such cases and make a switch to non-hardened
atomic version.

Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 security/integrity/ima/ima.h       | 4 ++--
 security/integrity/ima/ima_api.c   | 2 +-
 security/integrity/ima/ima_fs.c    | 4 ++--
 security/integrity/ima/ima_queue.c | 2 +-
 security/selinux/avc.c             | 7 ++++---
 5 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index eb0f4dd..0ffb025 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -158,8 +158,8 @@ static inline void ima_load_kexec_buffer(void)
 extern spinlock_t ima_queue_lock;
 
 struct ima_h_table {
-	atomic_long_t len;	/* number of stored measurements in the list */
-	atomic_long_t violations;
+	atomic_long_wrap_t len;	/* number of stored measurements in the list */
+	atomic_long_wrap_t violations;
 	struct hlist_head queue[IMA_MEASURE_HTABLE_SIZE];
 };
 extern struct ima_h_table ima_htable;
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 9df26a2..097bd47 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -138,7 +138,7 @@ void ima_add_violation(struct file *file, const unsigned char *filename,
 	int result;
 
 	/* can overflow, only indicator */
-	atomic_long_inc(&ima_htable.violations);
+	atomic_long_inc_wrap(&ima_htable.violations);
 
 	result = ima_alloc_init_template(&event_data, &entry);
 	if (result < 0) {
diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
index 2bcad99..d7a6c02 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -41,12 +41,12 @@ __setup("ima_canonical_fmt", default_canonical_fmt_setup);
 static int valid_policy = 1;
 #define TMPBUFLEN 12
 static ssize_t ima_show_htable_value(char __user *buf, size_t count,
-				     loff_t *ppos, atomic_long_t *val)
+				     loff_t *ppos, atomic_long_wrap_t *val)
 {
 	char tmpbuf[TMPBUFLEN];
 	ssize_t len;
 
-	len = scnprintf(tmpbuf, TMPBUFLEN, "%li\n", atomic_long_read(val));
+	len = scnprintf(tmpbuf, TMPBUFLEN, "%li\n", atomic_long_read_wrap(val));
 	return simple_read_from_buffer(buf, count, ppos, tmpbuf, len);
 }
 
diff --git a/security/integrity/ima/ima_queue.c b/security/integrity/ima/ima_queue.c
index 3a3cc2a..d634253 100644
--- a/security/integrity/ima/ima_queue.c
+++ b/security/integrity/ima/ima_queue.c
@@ -108,7 +108,7 @@ static int ima_add_digest_entry(struct ima_template_entry *entry, int flags)
 	INIT_LIST_HEAD(&qe->later);
 	list_add_tail_rcu(&qe->later, &ima_measurements);
 
-	atomic_long_inc(&ima_htable.len);
+	atomic_long_inc_wrap(&ima_htable.len);
 	if (flags) {
 		key = ima_hash_key(entry->digest);
 		hlist_add_head_rcu(&qe->hnext, &ima_htable.queue[key]);
diff --git a/security/selinux/avc.c b/security/selinux/avc.c
index e60c79d..6fa5ace 100644
--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -71,7 +71,7 @@ struct avc_xperms_node {
 struct avc_cache {
 	struct hlist_head	slots[AVC_CACHE_SLOTS]; /* head for avc_node->list */
 	spinlock_t		slots_lock[AVC_CACHE_SLOTS]; /* lock for writes */
-	atomic_t		lru_hint;	/* LRU hint for reclaim scan */
+	atomic_wrap_t		lru_hint;	/* LRU hint for reclaim scan */
 	atomic_t		active_nodes;
 	u32			latest_notif;	/* latest revocation notification */
 };
@@ -183,7 +183,7 @@ void __init avc_init(void)
 		spin_lock_init(&avc_cache.slots_lock[i]);
 	}
 	atomic_set(&avc_cache.active_nodes, 0);
-	atomic_set(&avc_cache.lru_hint, 0);
+	atomic_set_wrap(&avc_cache.lru_hint, 0);
 
 	avc_node_cachep = kmem_cache_create("avc_node", sizeof(struct avc_node),
 					0, SLAB_PANIC, NULL);
@@ -521,7 +521,8 @@ static inline int avc_reclaim_node(void)
 	spinlock_t *lock;
 
 	for (try = 0, ecx = 0; try < AVC_CACHE_SLOTS; try++) {
-		hvalue = atomic_inc_return(&avc_cache.lru_hint) & (AVC_CACHE_SLOTS - 1);
+		hvalue = atomic_inc_return_wrap(&avc_cache.lru_hint) &
+			(AVC_CACHE_SLOTS - 1);
 		head = &avc_cache.slots[hvalue];
 		lock = &avc_cache.slots_lock[hvalue];
 
-- 
2.7.4
