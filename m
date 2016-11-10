Reply-To: kernel-hardening@lists.openwall.com
From: Elena Reshetova <elena.reshetova@intel.com>
Date: Thu, 10 Nov 2016 22:24:43 +0200
Message-Id: <1478809488-18303-9-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
References: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
Subject: [kernel-hardening] [RFC v4 PATCH 08/13] security: identify wrapping atomic usage
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, peterz@infradead.org, will.deacon@arm.com, David Windsor <dwindsor@gmail.com>, Hans Liljestrand <ishkamiel@gmail.com>, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: David Windsor <dwindsor@gmail.com>

In some cases atomic is not used for reference
counting and therefore should be allowed to overflow.
Identify such cases and make a switch to non-hardened
atomic version.

The copyright for the original PAX_REFCOUNT code:
  - all REFCOUNT code in general: PaX Team <pageexec@freemail.hu>
  - various false positive fixes: Mathias Krause <minipli@googlemail.com>

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
index db25f54..4f10f05 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -130,8 +130,8 @@ int ima_init_template(void);
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
index c07a384..675e597 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -31,12 +31,12 @@ static DEFINE_MUTEX(ima_write_mutex);
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
index 32f6ac0..b46999e 100644
--- a/security/integrity/ima/ima_queue.c
+++ b/security/integrity/ima/ima_queue.c
@@ -84,7 +84,7 @@ static int ima_add_digest_entry(struct ima_template_entry *entry)
 	INIT_LIST_HEAD(&qe->later);
 	list_add_tail_rcu(&qe->later, &ima_measurements);
 
-	atomic_long_inc(&ima_htable.len);
+	atomic_long_inc_wrap(&ima_htable.len);
 	key = ima_hash_key(entry->digest);
 	hlist_add_head_rcu(&qe->hnext, &ima_htable.queue[key]);
 	return 0;
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
