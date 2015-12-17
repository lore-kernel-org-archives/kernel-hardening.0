Reply-To: kernel-hardening@lists.openwall.com
From: David Windsor <dave@progbits.org>
Date: Thu, 17 Dec 2015 09:57:45 -0500
Message-Id: <1450364270-12687-8-git-send-email-dave@progbits.org>
In-Reply-To: <1450364270-12687-1-git-send-email-dave@progbits.org>
References: <1450364270-12687-1-git-send-email-dave@progbits.org>
Subject: [kernel-hardening][RFC PATCH v2 07/12] security: opt out of PAX_REFCOUNT protection
To: kernel-hardening@lists.openwall.com
Cc: David Windsor <dave@progbits.org>
List-ID: <kernel-hardening.lists.openwall.com>

Signed-off-by: David Windsor <dave@progbits.org>
---
 security/integrity/ima/ima.h       | 4 ++--
 security/integrity/ima/ima_api.c   | 2 +-
 security/integrity/ima/ima_fs.c    | 4 ++--
 security/integrity/ima/ima_queue.c | 2 +-
 security/selinux/avc.c             | 6 +++---
 security/selinux/include/xfrm.h    | 2 +-
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index e2a60c3..2e41dd3 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -125,8 +125,8 @@ int ima_init_template(void);
 extern spinlock_t ima_queue_lock;
 
 struct ima_h_table {
-	atomic_long_t len;	/* number of stored measurements in the list */
-	atomic_long_t violations;
+	atomic_long_unchecked_t len;	/* number of stored measurements in the list */
+	atomic_long_unchecked_t violations;
 	struct hlist_head queue[IMA_MEASURE_HTABLE_SIZE];
 };
 extern struct ima_h_table ima_htable;
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 1d950fb..a8f4eab 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -137,7 +137,7 @@ void ima_add_violation(struct file *file, const unsigned char *filename,
 	int result;
 
 	/* can overflow, only indicator */
-	atomic_long_inc(&ima_htable.violations);
+	atomic_long_inc_unchecked(&ima_htable.violations);
 
 	result = ima_alloc_init_template(&event_data, &entry);
 	if (result < 0) {
diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
index 816d175..20079ae 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -28,12 +28,12 @@
 static int valid_policy = 1;
 #define TMPBUFLEN 12
 static ssize_t ima_show_htable_value(char __user *buf, size_t count,
-				     loff_t *ppos, atomic_long_t *val)
+				     loff_t *ppos, atomic_long_unchecked_t *val)
 {
 	char tmpbuf[TMPBUFLEN];
 	ssize_t len;
 
-	len = scnprintf(tmpbuf, TMPBUFLEN, "%li\n", atomic_long_read(val));
+	len = scnprintf(tmpbuf, TMPBUFLEN, "%li\n", atomic_long_read_unchecked(val));
 	return simple_read_from_buffer(buf, count, ppos, tmpbuf, len);
 }
 
diff --git a/security/integrity/ima/ima_queue.c b/security/integrity/ima/ima_queue.c
index 552705d..9920f4fb 100644
--- a/security/integrity/ima/ima_queue.c
+++ b/security/integrity/ima/ima_queue.c
@@ -83,7 +83,7 @@ static int ima_add_digest_entry(struct ima_template_entry *entry)
 	INIT_LIST_HEAD(&qe->later);
 	list_add_tail_rcu(&qe->later, &ima_measurements);
 
-	atomic_long_inc(&ima_htable.len);
+	atomic_long_inc_unchecked(&ima_htable.len);
 	key = ima_hash_key(entry->digest);
 	hlist_add_head_rcu(&qe->hnext, &ima_htable.queue[key]);
 	return 0;
diff --git a/security/selinux/avc.c b/security/selinux/avc.c
index 0b122b1..d9f9568 100644
--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -59,7 +59,7 @@ struct avc_node {
 struct avc_cache {
 	struct hlist_head	slots[AVC_CACHE_SLOTS]; /* head for avc_node->list */
 	spinlock_t		slots_lock[AVC_CACHE_SLOTS]; /* lock for writes */
-	atomic_t		lru_hint;	/* LRU hint for reclaim scan */
+	atomic_unchecked_t	lru_hint;	/* LRU hint for reclaim scan */
 	atomic_t		active_nodes;
 	u32			latest_notif;	/* latest revocation notification */
 };
@@ -167,7 +167,7 @@ void __init avc_init(void)
 		spin_lock_init(&avc_cache.slots_lock[i]);
 	}
 	atomic_set(&avc_cache.active_nodes, 0);
-	atomic_set(&avc_cache.lru_hint, 0);
+	atomic_set_unchecked(&avc_cache.lru_hint, 0);
 
 	avc_node_cachep = kmem_cache_create("avc_node", sizeof(struct avc_node),
 					     0, SLAB_PANIC, NULL);
@@ -242,7 +242,7 @@ static inline int avc_reclaim_node(void)
 	spinlock_t *lock;
 
 	for (try = 0, ecx = 0; try < AVC_CACHE_SLOTS; try++) {
-		hvalue = atomic_inc_return(&avc_cache.lru_hint) & (AVC_CACHE_SLOTS - 1);
+		hvalue = atomic_inc_return_unchecked(&avc_cache.lru_hint) & (AVC_CACHE_SLOTS - 1);
 		head = &avc_cache.slots[hvalue];
 		lock = &avc_cache.slots_lock[hvalue];
 
diff --git a/security/selinux/include/xfrm.h b/security/selinux/include/xfrm.h
index 1450f85..a91e0bc 100644
--- a/security/selinux/include/xfrm.h
+++ b/security/selinux/include/xfrm.h
@@ -48,7 +48,7 @@ static inline void selinux_xfrm_notify_policyload(void)
 
 	rtnl_lock();
 	for_each_net(net) {
-		atomic_inc(&net->xfrm.flow_cache_genid);
+		atomic_inc_unchecked(&net->xfrm.flow_cache_genid);
 		rt_genid_bump_all(net);
 	}
 	rtnl_unlock();
-- 
2.5.0
