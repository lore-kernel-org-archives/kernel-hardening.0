Reply-To: kernel-hardening@lists.openwall.com
From: Elena Reshetova <elena.reshetova@intel.com>
Date: Wed, 18 Jan 2017 11:11:44 +0200
Message-Id: <1484730707-29313-16-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1484730707-29313-1-git-send-email-elena.reshetova@intel.com>
References: <1484730707-29313-1-git-send-email-elena.reshetova@intel.com>
Subject: [kernel-hardening] [RFCv2 PATCH 15/18] block: convert from atomic_t to refcount_t
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, peterz@infradead.org, will.deacon@arm.com, dwindsor@gmail.com, gregkh@linuxfoundation.org, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. Convert the cases found.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 block/bio.c                |  6 +++---
 block/blk-cgroup.c         |  2 +-
 block/blk-ioc.c            |  4 ++--
 block/blk-tag.c            |  8 ++++----
 block/bsg.c                |  9 +++++----
 block/cfq-iosched.c        |  4 ++--
 fs/btrfs/volumes.c         |  2 +-
 include/linux/bio.h        |  4 ++--
 include/linux/blk-cgroup.h | 11 ++++++-----
 include/linux/blk_types.h  |  3 ++-
 include/linux/blkdev.h     |  3 ++-
 include/linux/iocontext.h  |  7 ++++---
 12 files changed, 34 insertions(+), 29 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 2b37502..a8cdd62 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -275,7 +275,7 @@ void bio_init(struct bio *bio, struct bio_vec *table,
 {
 	memset(bio, 0, sizeof(*bio));
 	atomic_set(&bio->__bi_remaining, 1);
-	atomic_set(&bio->__bi_cnt, 1);
+	refcount_set(&bio->__bi_cnt, 1);
 
 	bio->bi_io_vec = table;
 	bio->bi_max_vecs = max_vecs;
@@ -543,12 +543,12 @@ void bio_put(struct bio *bio)
 	if (!bio_flagged(bio, BIO_REFFED))
 		bio_free(bio);
 	else {
-		BIO_BUG_ON(!atomic_read(&bio->__bi_cnt));
+		BIO_BUG_ON(!refcount_read(&bio->__bi_cnt));
 
 		/*
 		 * last put frees it
 		 */
-		if (atomic_dec_and_test(&bio->__bi_cnt))
+		if (refcount_dec_and_test(&bio->__bi_cnt))
 			bio_free(bio);
 	}
 }
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 8ba0af7..c3f1756 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -106,7 +106,7 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct request_queue *q,
 	blkg->q = q;
 	INIT_LIST_HEAD(&blkg->q_node);
 	blkg->blkcg = blkcg;
-	atomic_set(&blkg->refcnt, 1);
+	refcount_set(&blkg->refcnt, 1);
 
 	/* root blkg uses @q->root_rl, init rl only for !root blkgs */
 	if (blkcg != &blkcg_root) {
diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index 381cb50..36e4418 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -167,7 +167,7 @@ void put_io_context_active(struct io_context *ioc)
 	unsigned long flags;
 	struct io_cq *icq;
 
-	if (!atomic_dec_and_test(&ioc->active_ref)) {
+	if (!refcount_dec_and_test(&ioc->active_ref)) {
 		put_io_context(ioc);
 		return;
 	}
@@ -244,7 +244,7 @@ int create_task_io_context(struct task_struct *task, gfp_t gfp_flags, int node)
 	/* initialize */
 	atomic_long_set(&ioc->refcount, 1);
 	atomic_set(&ioc->nr_tasks, 1);
-	atomic_set(&ioc->active_ref, 1);
+	refcount_set(&ioc->active_ref, 1);
 	spin_lock_init(&ioc->lock);
 	INIT_RADIX_TREE(&ioc->icq_tree, GFP_ATOMIC | __GFP_HIGH);
 	INIT_HLIST_HEAD(&ioc->icq_list);
diff --git a/block/blk-tag.c b/block/blk-tag.c
index bae1dec..95bcd77 100644
--- a/block/blk-tag.c
+++ b/block/blk-tag.c
@@ -35,7 +35,7 @@ EXPORT_SYMBOL(blk_queue_find_tag);
  */
 void blk_free_tags(struct blk_queue_tag *bqt)
 {
-	if (atomic_dec_and_test(&bqt->refcnt)) {
+	if (refcount_dec_and_test(&bqt->refcnt)) {
 		BUG_ON(find_first_bit(bqt->tag_map, bqt->max_depth) <
 							bqt->max_depth);
 
@@ -130,7 +130,7 @@ static struct blk_queue_tag *__blk_queue_init_tags(struct request_queue *q,
 	if (init_tag_map(q, tags, depth))
 		goto fail;
 
-	atomic_set(&tags->refcnt, 1);
+	refcount_set(&tags->refcnt, 1);
 	tags->alloc_policy = alloc_policy;
 	tags->next_tag = 0;
 	return tags;
@@ -180,7 +180,7 @@ int blk_queue_init_tags(struct request_queue *q, int depth,
 		queue_flag_set(QUEUE_FLAG_QUEUED, q);
 		return 0;
 	} else
-		atomic_inc(&tags->refcnt);
+		refcount_inc(&tags->refcnt);
 
 	/*
 	 * assign it, all done
@@ -225,7 +225,7 @@ int blk_queue_resize_tags(struct request_queue *q, int new_depth)
 	 * Currently cannot replace a shared tag map with a new
 	 * one, so error out if this is the case
 	 */
-	if (atomic_read(&bqt->refcnt) != 1)
+	if (refcount_read(&bqt->refcnt) != 1)
 		return -EBUSY;
 
 	/*
diff --git a/block/bsg.c b/block/bsg.c
index a57046d..987ac5f 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -21,6 +21,7 @@
 #include <linux/idr.h>
 #include <linux/bsg.h>
 #include <linux/slab.h>
+#include <linux/refcount.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_ioctl.h>
@@ -38,7 +39,7 @@ struct bsg_device {
 	struct list_head busy_list;
 	struct list_head done_list;
 	struct hlist_node dev_list;
-	atomic_t ref_count;
+	refcount_t ref_count;
 	int queued_cmds;
 	int done_cmds;
 	wait_queue_head_t wq_done;
@@ -716,7 +717,7 @@ static int bsg_put_device(struct bsg_device *bd)
 
 	mutex_lock(&bsg_mutex);
 
-	do_free = atomic_dec_and_test(&bd->ref_count);
+	do_free = refcount_dec_and_test(&bd->ref_count);
 	if (!do_free) {
 		mutex_unlock(&bsg_mutex);
 		goto out;
@@ -768,7 +769,7 @@ static struct bsg_device *bsg_add_device(struct inode *inode,
 
 	bsg_set_block(bd, file);
 
-	atomic_set(&bd->ref_count, 1);
+	refcount_set(&bd->ref_count, 1);
 	mutex_lock(&bsg_mutex);
 	hlist_add_head(&bd->dev_list, bsg_dev_idx_hash(iminor(inode)));
 
@@ -788,7 +789,7 @@ static struct bsg_device *__bsg_get_device(int minor, struct request_queue *q)
 
 	hlist_for_each_entry(bd, bsg_dev_idx_hash(minor), dev_list) {
 		if (bd->queue == q) {
-			atomic_inc(&bd->ref_count);
+			refcount_inc(&bd->ref_count);
 			goto found;
 		}
 	}
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index c73a6fc..cc3dd60 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2957,7 +2957,7 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 	 * task has exited, don't wait
 	 */
 	cic = cfqd->active_cic;
-	if (!cic || !atomic_read(&cic->icq.ioc->active_ref))
+	if (!cic || !refcount_read(&cic->icq.ioc->active_ref))
 		return;
 
 	/*
@@ -3955,7 +3955,7 @@ cfq_update_idle_window(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 
 	if (cfqq->next_rq && req_noidle(cfqq->next_rq))
 		enable_idle = 0;
-	else if (!atomic_read(&cic->icq.ioc->active_ref) ||
+	else if (!refcount_read(&cic->icq.ioc->active_ref) ||
 		 !cfqd->cfq_slice_idle ||
 		 (!cfq_cfqq_deep(cfqq) && CFQQ_SEEKY(cfqq)))
 		enable_idle = 0;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c6b0424..1d0a7f9 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -442,7 +442,7 @@ static noinline void run_scheduled_bios(struct btrfs_device *device)
 		    waitqueue_active(&fs_info->async_submit_wait))
 			wake_up(&fs_info->async_submit_wait);
 
-		BUG_ON(atomic_read(&cur->__bi_cnt) == 0);
+		BUG_ON(refcount_read(&cur->__bi_cnt) == 0);
 
 		/*
 		 * if we're doing the sync list, record that our
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 7cf8a6c..6f7b865 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -229,7 +229,7 @@ static inline void bio_get(struct bio *bio)
 {
 	bio->bi_flags |= (1 << BIO_REFFED);
 	smp_mb__before_atomic();
-	atomic_inc(&bio->__bi_cnt);
+	refcount_inc(&bio->__bi_cnt);
 }
 
 static inline void bio_cnt_set(struct bio *bio, unsigned int count)
@@ -238,7 +238,7 @@ static inline void bio_cnt_set(struct bio *bio, unsigned int count)
 		bio->bi_flags |= (1 << BIO_REFFED);
 		smp_mb__before_atomic();
 	}
-	atomic_set(&bio->__bi_cnt, count);
+	refcount_set(&bio->__bi_cnt, count);
 }
 
 static inline bool bio_flagged(struct bio *bio, unsigned int bit)
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 01b62e7..0d3efa9 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -19,6 +19,7 @@
 #include <linux/radix-tree.h>
 #include <linux/blkdev.h>
 #include <linux/atomic.h>
+#include <linux/refcount.h>
 
 /* percpu_counter batch for blkg_[rw]stats, per-cpu drift doesn't matter */
 #define BLKG_STAT_CPU_BATCH	(INT_MAX / 2)
@@ -122,7 +123,7 @@ struct blkcg_gq {
 	struct request_list		rl;
 
 	/* reference count */
-	atomic_t			refcnt;
+	refcount_t			refcnt;
 
 	/* is this blkg online? protected by both blkcg and q locks */
 	bool				online;
@@ -354,8 +355,8 @@ static inline int blkg_path(struct blkcg_gq *blkg, char *buf, int buflen)
  */
 static inline void blkg_get(struct blkcg_gq *blkg)
 {
-	WARN_ON_ONCE(atomic_read(&blkg->refcnt) <= 0);
-	atomic_inc(&blkg->refcnt);
+	WARN_ON_ONCE(refcount_read(&blkg->refcnt) == 0);
+	refcount_inc(&blkg->refcnt);
 }
 
 void __blkg_release_rcu(struct rcu_head *rcu);
@@ -366,8 +367,8 @@ void __blkg_release_rcu(struct rcu_head *rcu);
  */
 static inline void blkg_put(struct blkcg_gq *blkg)
 {
-	WARN_ON_ONCE(atomic_read(&blkg->refcnt) <= 0);
-	if (atomic_dec_and_test(&blkg->refcnt))
+	WARN_ON_ONCE(refcount_read(&blkg->refcnt) == 0);
+	if (refcount_dec_and_test(&blkg->refcnt))
 		call_rcu(&blkg->rcu_head, __blkg_release_rcu);
 }
 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 519ea2c..baeec02 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -7,6 +7,7 @@
 
 #include <linux/types.h>
 #include <linux/bvec.h>
+#include <linux/refcount.h>
 
 struct bio_set;
 struct bio;
@@ -73,7 +74,7 @@ struct bio {
 
 	unsigned short		bi_max_vecs;	/* max bvl_vecs we can hold */
 
-	atomic_t		__bi_cnt;	/* pin count */
+	refcount_t		__bi_cnt;	/* pin count */
 
 	struct bio_vec		*bi_io_vec;	/* the actual vec list */
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 8369564..c39b0fb 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -25,6 +25,7 @@
 #include <linux/percpu-refcount.h>
 #include <linux/scatterlist.h>
 #include <linux/blkzoned.h>
+#include <linux/refcount.h>
 
 struct module;
 struct scsi_ioctl_command;
@@ -290,7 +291,7 @@ struct blk_queue_tag {
 	unsigned long *tag_map;		/* bit map of free/busy tags */
 	int max_depth;			/* what we will send to device */
 	int real_max_depth;		/* what the array can hold */
-	atomic_t refcnt;		/* map can be shared */
+	refcount_t refcnt;		/* map can be shared */
 	int alloc_policy;		/* tag allocation policy */
 	int next_tag;			/* next tag */
 };
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index df38db2..a1e28c3 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -3,6 +3,7 @@
 
 #include <linux/radix-tree.h>
 #include <linux/rcupdate.h>
+#include <linux/refcount.h>
 #include <linux/workqueue.h>
 
 enum {
@@ -96,7 +97,7 @@ struct io_cq {
  */
 struct io_context {
 	atomic_long_t refcount;
-	atomic_t active_ref;
+	refcount_t active_ref;
 	atomic_t nr_tasks;
 
 	/* all the fields below are protected by this lock */
@@ -128,9 +129,9 @@ struct io_context {
 static inline void get_io_context_active(struct io_context *ioc)
 {
 	WARN_ON_ONCE(atomic_long_read(&ioc->refcount) <= 0);
-	WARN_ON_ONCE(atomic_read(&ioc->active_ref) <= 0);
+	WARN_ON_ONCE(refcount_read(&ioc->active_ref) == 0);
 	atomic_long_inc(&ioc->refcount);
-	atomic_inc(&ioc->active_ref);
+	refcount_inc(&ioc->active_ref);
 }
 
 static inline void ioc_task_link(struct io_context *ioc)
-- 
2.7.4
