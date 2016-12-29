Reply-To: kernel-hardening@lists.openwall.com
From: Elena Reshetova <elena.reshetova@intel.com>
Date: Thu, 29 Dec 2016 08:56:09 +0200
Message-Id: <1482994571-18687-18-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1482994571-18687-1-git-send-email-elena.reshetova@intel.com>
References: <1482994571-18687-1-git-send-email-elena.reshetova@intel.com>
Subject: [kernel-hardening] [RFC PATCH 17/19] drivers: misc convert from atomic_t to refcount_t
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, peterz@infradead.org, will.deacon@arm.com, dwindsor@gmail.com, gregkh@linuxfoundation.org, ishkamiel@gmail.com, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. Convert the cases found.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
---
 drivers/block/xen-blkback/common.h             |  7 +--
 drivers/block/xen-blkback/xenbus.c             |  2 +-
 drivers/char/mspec.c                           |  9 ++--
 drivers/connector/cn_queue.c                   |  4 +-
 drivers/connector/connector.c                  |  2 +-
 drivers/firewire/core-topology.c               |  2 +-
 drivers/firewire/core.h                        |  8 ++--
 drivers/gpu/drm/amd/amdkfd/kfd_process.c       |  4 +-
 drivers/gpu/drm/i915/i915_gem_object.h         |  2 +-
 drivers/md/bcache/alloc.c                      |  2 +-
 drivers/md/bcache/bcache.h                     |  9 ++--
 drivers/md/bcache/btree.c                      |  8 ++--
 drivers/md/bcache/super.c                      |  6 +--
 drivers/md/bcache/writeback.h                  |  2 +-
 drivers/md/dm-cache-metadata.c                 |  9 ++--
 drivers/md/dm-core.h                           |  3 +-
 drivers/md/dm-table.c                          |  6 +--
 drivers/md/dm.c                                | 19 ++++----
 drivers/md/dm.h                                |  3 +-
 drivers/md/md.c                                |  6 +--
 drivers/md/md.h                                |  3 +-
 drivers/md/raid5-cache.c                       |  8 ++--
 drivers/md/raid5.c                             | 66 +++++++++++++-------------
 drivers/md/raid5.h                             |  3 +-
 drivers/media/pci/cx88/cx88-cards.c            |  2 +-
 drivers/media/pci/cx88/cx88-core.c             |  4 +-
 drivers/media/pci/cx88/cx88.h                  |  3 +-
 drivers/media/usb/s2255/s2255drv.c             | 21 ++++----
 drivers/media/usb/uvc/uvc_ctrl.c               |  7 +--
 drivers/media/usb/uvc/uvc_driver.c             | 12 ++---
 drivers/media/usb/uvc/uvcvideo.h               |  5 +-
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 11 +++--
 drivers/media/v4l2-core/videobuf2-dma-sg.c     | 11 +++--
 drivers/media/v4l2-core/videobuf2-memops.c     |  6 +--
 drivers/media/v4l2-core/videobuf2-vmalloc.c    | 11 +++--
 drivers/pci/host/pci-hyperv.c                  |  7 +--
 drivers/s390/char/vmur.c                       |  8 ++--
 drivers/s390/char/vmur.h                       |  4 +-
 drivers/s390/net/lcs.c                         | 10 ++--
 drivers/s390/net/lcs.h                         |  3 +-
 drivers/s390/net/qeth_core.h                   |  3 +-
 drivers/s390/net/qeth_core_main.c              | 10 ++--
 drivers/scsi/libfc/fc_exch.c                   | 10 ++--
 drivers/scsi/libfc/fc_fcp.c                    |  6 +--
 drivers/scsi/libiscsi.c                        |  8 ++--
 drivers/staging/vme/devices/vme_user.c         | 10 ++--
 drivers/target/target_core_iblock.c            | 12 ++---
 drivers/target/target_core_iblock.h            |  3 +-
 drivers/tty/serial/dz.c                        | 31 +++++-------
 drivers/tty/serial/sb1250-duart.c              | 18 +++----
 drivers/usb/gadget/function/f_fs.c             |  8 ++--
 drivers/usb/gadget/function/u_fs.h             |  3 +-
 drivers/usb/gadget/legacy/inode.c              | 17 +++----
 drivers/xen/gntdev.c                           | 11 +++--
 include/linux/connector.h                      |  4 +-
 include/media/videobuf2-memops.h               |  3 +-
 include/scsi/libfc.h                           |  5 +-
 include/scsi/libiscsi.h                        |  3 +-
 include/trace/events/bcache.h                  |  2 +-
 59 files changed, 251 insertions(+), 234 deletions(-)

diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index dea61f6..2ccfd62 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -35,6 +35,7 @@
 #include <linux/wait.h>
 #include <linux/io.h>
 #include <linux/rbtree.h>
+#include <linux/refcount.h>
 #include <asm/setup.h>
 #include <asm/pgalloc.h>
 #include <asm/hypervisor.h>
@@ -333,7 +334,7 @@ struct xen_blkif {
 	struct xen_vbd		vbd;
 	/* Back pointer to the backend_info. */
 	struct backend_info	*be;
-	atomic_t		refcnt;
+	refcount_t		refcnt;
 	/* for barrier (drain) requests */
 	struct completion	drain_complete;
 	atomic_t		drain;
@@ -386,10 +387,10 @@ struct pending_req {
 			 (_v)->bdev->bd_part->nr_sects : \
 			  get_capacity((_v)->bdev->bd_disk))
 
-#define xen_blkif_get(_b) (atomic_inc(&(_b)->refcnt))
+#define xen_blkif_get(_b) (refcount_inc(&(_b)->refcnt))
 #define xen_blkif_put(_b)				\
 	do {						\
-		if (atomic_dec_and_test(&(_b)->refcnt))	\
+		if (refcount_dec_and_test(&(_b)->refcnt))	\
 			schedule_work(&(_b)->free_work);\
 	} while (0)
 
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 415e79b..4b22e47 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -176,7 +176,7 @@ static struct xen_blkif *xen_blkif_alloc(domid_t domid)
 		return ERR_PTR(-ENOMEM);
 
 	blkif->domid = domid;
-	atomic_set(&blkif->refcnt, 1);
+	refcount_set(&blkif->refcnt, 1);
 	init_completion(&blkif->drain_complete);
 	INIT_WORK(&blkif->free_work, xen_blkif_deferred_free);
 
diff --git a/drivers/char/mspec.c b/drivers/char/mspec.c
index a697ca0..6c164cc 100644
--- a/drivers/char/mspec.c
+++ b/drivers/char/mspec.c
@@ -43,6 +43,7 @@
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/numa.h>
+#include <linux/refcount.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <linux/atomic.h>
@@ -89,7 +90,7 @@ static int is_sn2;
  * protect in fork case where multiple tasks share the vma_data.
  */
 struct vma_data {
-	atomic_t refcnt;	/* Number of vmas sharing the data. */
+	refcount_t refcnt;	/* Number of vmas sharing the data. */
 	spinlock_t lock;	/* Serialize access to this structure. */
 	int count;		/* Number of pages allocated. */
 	enum mspec_page_type type; /* Type of pages allocated. */
@@ -144,7 +145,7 @@ mspec_open(struct vm_area_struct *vma)
 	struct vma_data *vdata;
 
 	vdata = vma->vm_private_data;
-	atomic_inc(&vdata->refcnt);
+	refcount_inc(&vdata->refcnt);
 }
 
 /*
@@ -162,7 +163,7 @@ mspec_close(struct vm_area_struct *vma)
 
 	vdata = vma->vm_private_data;
 
-	if (!atomic_dec_and_test(&vdata->refcnt))
+	if (!refcount_dec_and_test(&vdata->refcnt))
 		return;
 
 	last_index = (vdata->vm_end - vdata->vm_start) >> PAGE_SHIFT;
@@ -274,7 +275,7 @@ mspec_mmap(struct file *file, struct vm_area_struct *vma,
 	vdata->vm_end = vma->vm_end;
 	vdata->type = type;
 	spin_lock_init(&vdata->lock);
-	atomic_set(&vdata->refcnt, 1);
+	refcount_set(&vdata->refcnt, 1);
 	vma->vm_private_data = vdata;
 
 	vma->vm_flags |= VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP;
diff --git a/drivers/connector/cn_queue.c b/drivers/connector/cn_queue.c
index 1f8bf05..9c54fdf 100644
--- a/drivers/connector/cn_queue.c
+++ b/drivers/connector/cn_queue.c
@@ -45,7 +45,7 @@ cn_queue_alloc_callback_entry(struct cn_queue_dev *dev, const char *name,
 		return NULL;
 	}
 
-	atomic_set(&cbq->refcnt, 1);
+	refcount_set(&cbq->refcnt, 1);
 
 	atomic_inc(&dev->refcnt);
 	cbq->pdev = dev;
@@ -58,7 +58,7 @@ cn_queue_alloc_callback_entry(struct cn_queue_dev *dev, const char *name,
 
 void cn_queue_release_callback(struct cn_callback_entry *cbq)
 {
-	if (!atomic_dec_and_test(&cbq->refcnt))
+	if (!refcount_dec_and_test(&cbq->refcnt))
 		return;
 
 	atomic_dec(&cbq->pdev->refcnt);
diff --git a/drivers/connector/connector.c b/drivers/connector/connector.c
index 25693b0..8615594b 100644
--- a/drivers/connector/connector.c
+++ b/drivers/connector/connector.c
@@ -157,7 +157,7 @@ static int cn_call_callback(struct sk_buff *skb)
 	spin_lock_bh(&dev->cbdev->queue_lock);
 	list_for_each_entry(i, &dev->cbdev->queue_list, callback_entry) {
 		if (cn_cb_equal(&i->id.id, &msg->id)) {
-			atomic_inc(&i->refcnt);
+			refcount_inc(&i->refcnt);
 			cbq = i;
 			break;
 		}
diff --git a/drivers/firewire/core-topology.c b/drivers/firewire/core-topology.c
index 0de8350..939d259 100644
--- a/drivers/firewire/core-topology.c
+++ b/drivers/firewire/core-topology.c
@@ -124,7 +124,7 @@ static struct fw_node *fw_node_create(u32 sid, int port_count, int color)
 	node->initiated_reset = SELF_ID_PHY_INITIATOR(sid);
 	node->port_count = port_count;
 
-	atomic_set(&node->ref_count, 1);
+	refcount_set(&node->ref_count, 1);
 	INIT_LIST_HEAD(&node->link);
 
 	return node;
diff --git a/drivers/firewire/core.h b/drivers/firewire/core.h
index e1480ff6..c07962e 100644
--- a/drivers/firewire/core.h
+++ b/drivers/firewire/core.h
@@ -12,7 +12,7 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 
-#include <linux/atomic.h>
+#include <linux/refcount.h>
 
 struct device;
 struct fw_card;
@@ -184,7 +184,7 @@ struct fw_node {
 			 * local node to this node. */
 	u8 max_depth:4;	/* Maximum depth to any leaf node */
 	u8 max_hops:4;	/* Max hops in this sub tree */
-	atomic_t ref_count;
+	refcount_t ref_count;
 
 	/* For serializing node topology into a list. */
 	struct list_head link;
@@ -197,14 +197,14 @@ struct fw_node {
 
 static inline struct fw_node *fw_node_get(struct fw_node *node)
 {
-	atomic_inc(&node->ref_count);
+	refcount_inc(&node->ref_count);
 
 	return node;
 }
 
 static inline void fw_node_put(struct fw_node *node)
 {
-	if (atomic_dec_and_test(&node->ref_count))
+	if (refcount_dec_and_test(&node->ref_count))
 		kfree(node);
 }
 
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process.c b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
index ef7c8de..04115fc 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -204,7 +204,7 @@ static void kfd_process_destroy_delayed(struct rcu_head *rcu)
 	BUG_ON(!kfd_process_wq);
 
 	p = container_of(rcu, struct kfd_process, rcu);
-	BUG_ON(atomic_read(&p->mm->mm_count) <= 0);
+	BUG_ON(refcount_read(&p->mm->mm_count) == 0);
 
 	mmdrop(p->mm);
 
@@ -262,7 +262,7 @@ static void kfd_process_notifier_release(struct mmu_notifier *mn,
 	 * and because the mmu_notifier_unregister function also drop
 	 * mm_count we need to take an extra count here.
 	 */
-	atomic_inc(&p->mm->mm_count);
+	refcount_inc(&p->mm->mm_count);
 	mmu_notifier_unregister_no_release(&p->mmu_notifier, p->mm);
 	mmu_notifier_call_srcu(&p->rcu, &kfd_process_destroy_delayed);
 }
diff --git a/drivers/gpu/drm/i915/i915_gem_object.h b/drivers/gpu/drm/i915/i915_gem_object.h
index 6a368de..ecfefb9 100644
--- a/drivers/gpu/drm/i915/i915_gem_object.h
+++ b/drivers/gpu/drm/i915/i915_gem_object.h
@@ -256,7 +256,7 @@ extern void drm_gem_object_unreference_unlocked(struct drm_gem_object *);
 static inline bool
 i915_gem_object_is_dead(const struct drm_i915_gem_object *obj)
 {
-	return atomic_read(&obj->base.refcount.refcount) == 0;
+	return kref_read(&obj->base.refcount) == 0;
 }
 
 static inline bool
diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index ca4abe1..705933a 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -353,7 +353,7 @@ static int bch_allocator_thread(void *arg)
 		 * Now, we write their new gens to disk so we can start writing
 		 * new stuff to them:
 		 */
-		allocator_wait(ca, !atomic_read(&ca->set->prio_blocked));
+		allocator_wait(ca, !refcount_read(&ca->set->prio_blocked));
 		if (CACHE_SYNC(&ca->set->sb)) {
 			/*
 			 * This could deadlock if an allocation with a btree
diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index c3ea03c..031c03e 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -184,6 +184,7 @@
 #include <linux/mutex.h>
 #include <linux/rbtree.h>
 #include <linux/rwsem.h>
+#include <linux/refcount.h>
 #include <linux/types.h>
 #include <linux/workqueue.h>
 
@@ -299,7 +300,7 @@ struct cached_dev {
 	struct semaphore	sb_write_mutex;
 
 	/* Refcount on the cache set. Always nonzero when we're caching. */
-	atomic_t		count;
+	refcount_t		count;
 	struct work_struct	detach;
 
 	/*
@@ -557,7 +558,7 @@ struct cache_set {
 	 * This is a refcount that blocks prio_write() until the new keys are
 	 * written.
 	 */
-	atomic_t		prio_blocked;
+	refcount_t		prio_blocked;
 	wait_queue_head_t	bucket_wait;
 
 	/*
@@ -805,13 +806,13 @@ do {									\
 
 static inline void cached_dev_put(struct cached_dev *dc)
 {
-	if (atomic_dec_and_test(&dc->count))
+	if (refcount_dec_and_test(&dc->count))
 		schedule_work(&dc->detach);
 }
 
 static inline bool cached_dev_get(struct cached_dev *dc)
 {
-	if (!atomic_inc_not_zero(&dc->count))
+	if (!refcount_inc_not_zero(&dc->count))
 		return false;
 
 	/* Paired with the mb in cached_dev_attach */
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index a43eedd..7ee76f3 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -324,8 +324,8 @@ static void bch_btree_node_read(struct btree *b)
 static void btree_complete_write(struct btree *b, struct btree_write *w)
 {
 	if (w->prio_blocked &&
-	    !atomic_sub_return(w->prio_blocked, &b->c->prio_blocked))
-		wake_up_allocators(b->c);
+		refcount_sub_and_test(w->prio_blocked, &b->c->prio_blocked))
+				wake_up_allocators(b->c);
 
 	if (w->journal) {
 		atomic_dec_bug(w->journal);
@@ -1126,7 +1126,7 @@ static void make_btree_freeing_key(struct btree *b, struct bkey *k)
 
 	mutex_lock(&b->c->bucket_lock);
 
-	atomic_inc(&b->c->prio_blocked);
+	refcount_inc(&b->c->prio_blocked);
 
 	bkey_copy(k, &b->key);
 	bkey_copy_key(k, &ZERO_KEY);
@@ -1446,7 +1446,7 @@ static int btree_gc_coalesce(struct btree *b, struct btree_op *op,
 
 	while ((k = bch_keylist_pop(&keylist)))
 		if (!bkey_cmp(k, &ZERO_KEY))
-			atomic_dec(&b->c->prio_blocked);
+			refcount_dec(&b->c->prio_blocked);
 
 	for (i = 0; i < nodes; i++)
 		if (!IS_ERR_OR_NULL(new_nodes[i])) {
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 3a19cbc..e04621f 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -891,7 +891,7 @@ static void cached_dev_detach_finish(struct work_struct *w)
 	closure_init_stack(&cl);
 
 	BUG_ON(!test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags));
-	BUG_ON(atomic_read(&dc->count));
+	BUG_ON(refcount_read(&dc->count));
 
 	mutex_lock(&bch_register_lock);
 
@@ -1018,7 +1018,7 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c)
 	 * dc->c must be set before dc->count != 0 - paired with the mb in
 	 * cached_dev_get()
 	 */
-	atomic_set(&dc->count, 1);
+	refcount_set(&dc->count, 1);
 
 	/* Block writeback thread, but spawn it */
 	down_write(&dc->writeback_lock);
@@ -1030,7 +1030,7 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c)
 	if (BDEV_STATE(&dc->sb) == BDEV_STATE_DIRTY) {
 		bch_sectors_dirty_init(dc);
 		atomic_set(&dc->has_dirty, 1);
-		atomic_inc(&dc->count);
+		refcount_inc(&dc->count);
 		bch_writeback_queue(dc);
 	}
 
diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
index 629bd1a..5bac1b0 100644
--- a/drivers/md/bcache/writeback.h
+++ b/drivers/md/bcache/writeback.h
@@ -70,7 +70,7 @@ static inline void bch_writeback_add(struct cached_dev *dc)
 {
 	if (!atomic_read(&dc->has_dirty) &&
 	    !atomic_xchg(&dc->has_dirty, 1)) {
-		atomic_inc(&dc->count);
+		refcount_inc(&dc->count);
 
 		if (BDEV_STATE(&dc->sb) != BDEV_STATE_DIRTY) {
 			SET_BDEV_STATE(&dc->sb, BDEV_STATE_DIRTY);
diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index 624fe43..d20cc79 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -13,6 +13,7 @@
 #include "persistent-data/dm-transaction-manager.h"
 
 #include <linux/device-mapper.h>
+#include <linux/refcount.h>
 
 /*----------------------------------------------------------------*/
 
@@ -96,7 +97,7 @@ struct cache_disk_superblock {
 } __packed;
 
 struct dm_cache_metadata {
-	atomic_t ref_count;
+	refcount_t ref_count;
 	struct list_head list;
 
 	struct block_device *bdev;
@@ -709,7 +710,7 @@ static struct dm_cache_metadata *metadata_open(struct block_device *bdev,
 		return ERR_PTR(-ENOMEM);
 	}
 
-	atomic_set(&cmd->ref_count, 1);
+	refcount_set(&cmd->ref_count, 1);
 	init_rwsem(&cmd->root_lock);
 	cmd->bdev = bdev;
 	cmd->data_block_size = data_block_size;
@@ -747,7 +748,7 @@ static struct dm_cache_metadata *lookup(struct block_device *bdev)
 
 	list_for_each_entry(cmd, &table, list)
 		if (cmd->bdev == bdev) {
-			atomic_inc(&cmd->ref_count);
+			refcount_inc(&cmd->ref_count);
 			return cmd;
 		}
 
@@ -815,7 +816,7 @@ struct dm_cache_metadata *dm_cache_metadata_open(struct block_device *bdev,
 
 void dm_cache_metadata_close(struct dm_cache_metadata *cmd)
 {
-	if (atomic_dec_and_test(&cmd->ref_count)) {
+	if (refcount_dec_and_test(&cmd->ref_count)) {
 		mutex_lock(&table_lock);
 		list_del(&cmd->list);
 		mutex_unlock(&table_lock);
diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 40ceba1..3fa0ac9 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -12,6 +12,7 @@
 #include <linux/kthread.h>
 #include <linux/ktime.h>
 #include <linux/blk-mq.h>
+#include <linux/refcount.h>
 
 #include <trace/events/block.h>
 
@@ -52,7 +53,7 @@ struct mapped_device {
 	struct mutex type_lock;
 
 	atomic_t holders;
-	atomic_t open_count;
+	refcount_t open_count;
 
 	struct dm_target *immutable_target;
 	struct target_type *immutable_target_type;
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 0a427de..d2ba05a 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -416,7 +416,7 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
 			return r;
 		}
 
-		atomic_set(&dd->count, 0);
+		refcount_set(&dd->count, 0);
 		list_add(&dd->list, &t->devices);
 
 	} else if (dd->dm_dev->mode != (mode | dd->dm_dev->mode)) {
@@ -424,7 +424,7 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
 		if (r)
 			return r;
 	}
-	atomic_inc(&dd->count);
+	refcount_inc(&dd->count);
 
 	*result = dd->dm_dev;
 	return 0;
@@ -478,7 +478,7 @@ void dm_put_device(struct dm_target *ti, struct dm_dev *d)
 		       dm_device_name(ti->table->md), d->name);
 		return;
 	}
-	if (atomic_dec_and_test(&dd->count)) {
+	if (refcount_dec_and_test(&dd->count)) {
 		dm_put_table_device(ti->table->md, d);
 		list_del(&dd->list);
 		kfree(dd);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3086da5..6c891e4 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -21,6 +21,7 @@
 #include <linux/delay.h>
 #include <linux/wait.h>
 #include <linux/pr.h>
+#include <linux/refcount.h>
 
 #define DM_MSG_PREFIX "core"
 
@@ -97,7 +98,7 @@ struct dm_md_mempools {
 
 struct table_device {
 	struct list_head list;
-	atomic_t count;
+	refcount_t count;
 	struct dm_dev dm_dev;
 };
 
@@ -313,7 +314,7 @@ static int dm_blk_open(struct block_device *bdev, fmode_t mode)
 	}
 
 	dm_get(md);
-	atomic_inc(&md->open_count);
+	refcount_inc(&md->open_count);
 out:
 	spin_unlock(&_minor_lock);
 
@@ -330,7 +331,7 @@ static void dm_blk_close(struct gendisk *disk, fmode_t mode)
 	if (WARN_ON(!md))
 		goto out;
 
-	if (atomic_dec_and_test(&md->open_count) &&
+	if (refcount_dec_and_test(&md->open_count) &&
 	    (test_bit(DMF_DEFERRED_REMOVE, &md->flags)))
 		queue_work(deferred_remove_workqueue, &deferred_remove_work);
 
@@ -341,7 +342,7 @@ static void dm_blk_close(struct gendisk *disk, fmode_t mode)
 
 int dm_open_count(struct mapped_device *md)
 {
-	return atomic_read(&md->open_count);
+	return refcount_read(&md->open_count);
 }
 
 /*
@@ -678,10 +679,10 @@ int dm_get_table_device(struct mapped_device *md, dev_t dev, fmode_t mode,
 
 		format_dev_t(td->dm_dev.name, dev);
 
-		atomic_set(&td->count, 0);
+		refcount_set(&td->count, 0);
 		list_add(&td->list, &md->table_devices);
 	}
-	atomic_inc(&td->count);
+	refcount_inc(&td->count);
 	mutex_unlock(&md->table_devices_lock);
 
 	*result = &td->dm_dev;
@@ -694,7 +695,7 @@ void dm_put_table_device(struct mapped_device *md, struct dm_dev *d)
 	struct table_device *td = container_of(d, struct table_device, dm_dev);
 
 	mutex_lock(&md->table_devices_lock);
-	if (atomic_dec_and_test(&td->count)) {
+	if (refcount_dec_and_test(&td->count)) {
 		close_table_device(td, md);
 		list_del(&td->list);
 		kfree(td);
@@ -711,7 +712,7 @@ static void free_table_devices(struct list_head *devices)
 		struct table_device *td = list_entry(tmp, struct table_device, list);
 
 		DMWARN("dm_destroy: %s still exists with %d references",
-		       td->dm_dev.name, atomic_read(&td->count));
+		       td->dm_dev.name, refcount_read(&td->count));
 		kfree(td);
 	}
 }
@@ -1483,7 +1484,7 @@ static struct mapped_device *alloc_dev(int minor)
 	mutex_init(&md->table_devices_lock);
 	spin_lock_init(&md->deferred_lock);
 	atomic_set(&md->holders, 1);
-	atomic_set(&md->open_count, 0);
+	refcount_set(&md->open_count, 0);
 	atomic_set(&md->event_nr, 0);
 	atomic_set(&md->uevent_seq, 0);
 	INIT_LIST_HEAD(&md->uevent_list);
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index f0aad08..26e560a 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -19,6 +19,7 @@
 #include <linux/hdreg.h>
 #include <linux/completion.h>
 #include <linux/kobject.h>
+#include <linux/refcount.h>
 
 #include "dm-stats.h"
 
@@ -38,7 +39,7 @@
  */
 struct dm_dev_internal {
 	struct list_head list;
-	atomic_t count;
+	refcount_t count;
 	struct dm_dev *dm_dev;
 };
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 82821ee..6c9b9ff 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -459,7 +459,7 @@ EXPORT_SYMBOL(md_unplug);
 
 static inline struct mddev *mddev_get(struct mddev *mddev)
 {
-	atomic_inc(&mddev->active);
+	refcount_inc(&mddev->active);
 	return mddev;
 }
 
@@ -469,7 +469,7 @@ static void mddev_put(struct mddev *mddev)
 {
 	struct bio_set *bs = NULL;
 
-	if (!atomic_dec_and_lock(&mddev->active, &all_mddevs_lock))
+	if (!refcount_dec_and_lock(&mddev->active, &all_mddevs_lock))
 		return;
 	if (!mddev->raid_disks && list_empty(&mddev->disks) &&
 	    mddev->ctime == 0 && !mddev->hold_active) {
@@ -505,7 +505,7 @@ void mddev_init(struct mddev *mddev)
 	INIT_LIST_HEAD(&mddev->all_mddevs);
 	setup_timer(&mddev->safemode_timer, md_safemode_timeout,
 		    (unsigned long) mddev);
-	atomic_set(&mddev->active, 1);
+	refcount_set(&mddev->active, 1);
 	atomic_set(&mddev->openers, 0);
 	atomic_set(&mddev->active_io, 0);
 	spin_lock_init(&mddev->lock);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index e38936d..0c1ec5f 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -22,6 +22,7 @@
 #include <linux/list.h>
 #include <linux/mm.h>
 #include <linux/mutex.h>
+#include <linux/refcount.h>
 #include <linux/timer.h>
 #include <linux/wait.h>
 #include <linux/workqueue.h>
@@ -359,7 +360,7 @@ struct mddev {
 	 */
 	struct mutex			open_mutex;
 	struct mutex			reconfig_mutex;
-	atomic_t			active;		/* general refcount */
+	refcount_t			active;		/* general refcount */
 	atomic_t			openers;	/* number of active opens */
 
 	int				changed;	/* True if we might need to
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index d7bfb6f..a647d4b 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -906,7 +906,7 @@ int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 	 * don't delay.
 	 */
 	clear_bit(STRIPE_DELAYED, &sh->state);
-	atomic_inc(&sh->count);
+	refcount_inc(&sh->count);
 
 	mutex_lock(&log->io_mutex);
 	/* meta + data */
@@ -1248,7 +1248,7 @@ static void r5c_flush_stripe(struct r5conf *conf, struct stripe_head *sh)
 	assert_spin_locked(&conf->device_lock);
 
 	list_del_init(&sh->lru);
-	atomic_inc(&sh->count);
+	refcount_inc(&sh->count);
 
 	set_bit(STRIPE_HANDLE, &sh->state);
 	atomic_inc(&conf->active_stripes);
@@ -1343,7 +1343,7 @@ static void r5c_do_reclaim(struct r5conf *conf)
 			 */
 			if (!list_empty(&sh->lru) &&
 			    !test_bit(STRIPE_HANDLE, &sh->state) &&
-			    atomic_read(&sh->count) == 0) {
+			    refcount_read(&sh->count) == 0) {
 				r5c_flush_stripe(conf, sh);
 			}
 			if (count++ >= R5C_RECLAIM_STRIPE_GROUP)
@@ -2459,7 +2459,7 @@ r5c_cache_data(struct r5l_log *log, struct stripe_head *sh,
 	 * don't delay.
 	 */
 	clear_bit(STRIPE_DELAYED, &sh->state);
-	atomic_inc(&sh->count);
+	refcount_inc(&sh->count);
 
 	mutex_lock(&log->io_mutex);
 	/* meta + data */
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 06d7279..40d87bb 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -294,7 +294,7 @@ static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh,
 static void __release_stripe(struct r5conf *conf, struct stripe_head *sh,
 			     struct list_head *temp_inactive_list)
 {
-	if (atomic_dec_and_test(&sh->count))
+	if (refcount_dec_and_test(&sh->count))
 		do_release_stripe(conf, sh, temp_inactive_list);
 }
 
@@ -388,7 +388,7 @@ void raid5_release_stripe(struct stripe_head *sh)
 
 	/* Avoid release_list until the last reference.
 	 */
-	if (atomic_add_unless(&sh->count, -1, 1))
+	if (refcount_dec_not_one(&sh->count))
 		return;
 
 	if (unlikely(!conf->mddev->thread) ||
@@ -401,7 +401,7 @@ void raid5_release_stripe(struct stripe_head *sh)
 slow_path:
 	local_irq_save(flags);
 	/* we are ok here if STRIPE_ON_RELEASE_LIST is set or not */
-	if (atomic_dec_and_lock(&sh->count, &conf->device_lock)) {
+	if (refcount_dec_and_lock(&sh->count, &conf->device_lock)) {
 		INIT_LIST_HEAD(&list);
 		hash = sh->hash_lock_index;
 		do_release_stripe(conf, sh, &list);
@@ -491,7 +491,7 @@ static void init_stripe(struct stripe_head *sh, sector_t sector, int previous)
 	struct r5conf *conf = sh->raid_conf;
 	int i, seq;
 
-	BUG_ON(atomic_read(&sh->count) != 0);
+	BUG_ON(refcount_read(&sh->count) != 0);
 	BUG_ON(test_bit(STRIPE_HANDLE, &sh->state));
 	BUG_ON(stripe_operations_active(sh));
 	BUG_ON(sh->batch_head);
@@ -668,11 +668,11 @@ raid5_get_active_stripe(struct r5conf *conf, sector_t sector,
 					  &conf->cache_state);
 			} else {
 				init_stripe(sh, sector, previous);
-				atomic_inc(&sh->count);
+				refcount_inc(&sh->count);
 			}
-		} else if (!atomic_inc_not_zero(&sh->count)) {
+		} else if (!refcount_inc_not_zero(&sh->count)) {
 			spin_lock(&conf->device_lock);
-			if (!atomic_read(&sh->count)) {
+			if (!refcount_read(&sh->count)) {
 				if (!test_bit(STRIPE_HANDLE, &sh->state))
 					atomic_inc(&conf->active_stripes);
 				BUG_ON(list_empty(&sh->lru) &&
@@ -688,7 +688,7 @@ raid5_get_active_stripe(struct r5conf *conf, sector_t sector,
 					sh->group = NULL;
 				}
 			}
-			atomic_inc(&sh->count);
+			refcount_inc(&sh->count);
 			spin_unlock(&conf->device_lock);
 		}
 	} while (sh == NULL);
@@ -752,9 +752,9 @@ static void stripe_add_to_batch_list(struct r5conf *conf, struct stripe_head *sh
 	hash = stripe_hash_locks_hash(head_sector);
 	spin_lock_irq(conf->hash_locks + hash);
 	head = __find_stripe(conf, head_sector, conf->generation);
-	if (head && !atomic_inc_not_zero(&head->count)) {
+	if (head && !refcount_inc_not_zero(&head->count)) {
 		spin_lock(&conf->device_lock);
-		if (!atomic_read(&head->count)) {
+		if (!refcount_read(&head->count)) {
 			if (!test_bit(STRIPE_HANDLE, &head->state))
 				atomic_inc(&conf->active_stripes);
 			BUG_ON(list_empty(&head->lru) &&
@@ -770,7 +770,7 @@ static void stripe_add_to_batch_list(struct r5conf *conf, struct stripe_head *sh
 				head->group = NULL;
 			}
 		}
-		atomic_inc(&head->count);
+		refcount_inc(&head->count);
 		spin_unlock(&conf->device_lock);
 	}
 	spin_unlock_irq(conf->hash_locks + hash);
@@ -833,7 +833,7 @@ static void stripe_add_to_batch_list(struct r5conf *conf, struct stripe_head *sh
 		sh->batch_head->bm_seq = seq;
 	}
 
-	atomic_inc(&sh->count);
+	refcount_inc(&sh->count);
 unlock_out:
 	unlock_two_stripes(head, sh);
 out:
@@ -999,9 +999,9 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 			pr_debug("%s: for %llu schedule op %d on disc %d\n",
 				__func__, (unsigned long long)sh->sector,
 				bi->bi_opf, i);
-			atomic_inc(&sh->count);
+			refcount_inc(&sh->count);
 			if (sh != head_sh)
-				atomic_inc(&head_sh->count);
+				refcount_inc(&head_sh->count);
 			if (use_new_offset(conf, sh))
 				bi->bi_iter.bi_sector = (sh->sector
 						 + rdev->new_data_offset);
@@ -1050,9 +1050,9 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 				 "replacement disc %d\n",
 				__func__, (unsigned long long)sh->sector,
 				rbi->bi_opf, i);
-			atomic_inc(&sh->count);
+			refcount_inc(&sh->count);
 			if (sh != head_sh)
-				atomic_inc(&head_sh->count);
+				refcount_inc(&head_sh->count);
 			if (use_new_offset(conf, sh))
 				rbi->bi_iter.bi_sector = (sh->sector
 						  + rrdev->new_data_offset);
@@ -1228,7 +1228,7 @@ static void ops_run_biofill(struct stripe_head *sh)
 		}
 	}
 
-	atomic_inc(&sh->count);
+	refcount_inc(&sh->count);
 	init_async_submit(&submit, ASYNC_TX_ACK, tx, ops_complete_biofill, sh, NULL);
 	async_trigger_callback(&submit);
 }
@@ -1306,7 +1306,7 @@ ops_run_compute5(struct stripe_head *sh, struct raid5_percpu *percpu)
 		if (i != target)
 			xor_srcs[count++] = sh->dev[i].page;
 
-	atomic_inc(&sh->count);
+	refcount_inc(&sh->count);
 
 	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST, NULL,
 			  ops_complete_compute, sh, to_addr_conv(sh, percpu, 0));
@@ -1394,7 +1394,7 @@ ops_run_compute6_1(struct stripe_head *sh, struct raid5_percpu *percpu)
 	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
 	dest = tgt->page;
 
-	atomic_inc(&sh->count);
+	refcount_inc(&sh->count);
 
 	if (target == qd_idx) {
 		count = set_syndrome_sources(blocks, sh, SYNDROME_SRC_ALL);
@@ -1469,7 +1469,7 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
 	pr_debug("%s: stripe: %llu faila: %d failb: %d\n",
 		 __func__, (unsigned long long)sh->sector, faila, failb);
 
-	atomic_inc(&sh->count);
+	refcount_inc(&sh->count);
 
 	if (failb == syndrome_disks+1) {
 		/* Q disk is one of the missing disks */
@@ -1737,7 +1737,7 @@ ops_run_reconstruct5(struct stripe_head *sh, struct raid5_percpu *percpu,
 			break;
 	}
 	if (i >= sh->disks) {
-		atomic_inc(&sh->count);
+		refcount_inc(&sh->count);
 		set_bit(R5_Discard, &sh->dev[pd_idx].flags);
 		ops_complete_reconstruct(sh);
 		return;
@@ -1778,7 +1778,7 @@ ops_run_reconstruct5(struct stripe_head *sh, struct raid5_percpu *percpu,
 		flags = ASYNC_TX_ACK |
 			(prexor ? ASYNC_TX_XOR_DROP_DST : ASYNC_TX_XOR_ZERO_DST);
 
-		atomic_inc(&head_sh->count);
+		refcount_inc(&head_sh->count);
 		init_async_submit(&submit, flags, tx, ops_complete_reconstruct, head_sh,
 				  to_addr_conv(sh, percpu, j));
 	} else {
@@ -1820,7 +1820,7 @@ ops_run_reconstruct6(struct stripe_head *sh, struct raid5_percpu *percpu,
 			break;
 	}
 	if (i >= sh->disks) {
-		atomic_inc(&sh->count);
+		refcount_inc(&sh->count);
 		set_bit(R5_Discard, &sh->dev[sh->pd_idx].flags);
 		set_bit(R5_Discard, &sh->dev[sh->qd_idx].flags);
 		ops_complete_reconstruct(sh);
@@ -1844,7 +1844,7 @@ ops_run_reconstruct6(struct stripe_head *sh, struct raid5_percpu *percpu,
 				 struct stripe_head, batch_list) == head_sh;
 
 	if (last_stripe) {
-		atomic_inc(&head_sh->count);
+		refcount_inc(&head_sh->count);
 		init_async_submit(&submit, txflags, tx, ops_complete_reconstruct,
 				  head_sh, to_addr_conv(sh, percpu, j));
 	} else
@@ -1901,7 +1901,7 @@ static void ops_run_check_p(struct stripe_head *sh, struct raid5_percpu *percpu)
 	tx = async_xor_val(xor_dest, xor_srcs, 0, count, STRIPE_SIZE,
 			   &sh->ops.zero_sum_result, &submit);
 
-	atomic_inc(&sh->count);
+	refcount_inc(&sh->count);
 	init_async_submit(&submit, ASYNC_TX_ACK, tx, ops_complete_check, sh, NULL);
 	tx = async_trigger_callback(&submit);
 }
@@ -1920,7 +1920,7 @@ static void ops_run_check_pq(struct stripe_head *sh, struct raid5_percpu *percpu
 	if (!checkp)
 		srcs[count] = NULL;
 
-	atomic_inc(&sh->count);
+	refcount_inc(&sh->count);
 	init_async_submit(&submit, ASYNC_TX_ACK, NULL, ops_complete_check,
 			  sh, to_addr_conv(sh, percpu, 0));
 	async_syndrome_val(srcs, 0, count+2, STRIPE_SIZE,
@@ -2010,7 +2010,7 @@ static struct stripe_head *alloc_stripe(struct kmem_cache *sc, gfp_t gfp,
 		INIT_LIST_HEAD(&sh->lru);
 		INIT_LIST_HEAD(&sh->r5c);
 		INIT_LIST_HEAD(&sh->log_list);
-		atomic_set(&sh->count, 1);
+		refcount_set(&sh->count, 1);
 		sh->log_start = MaxSector;
 		for (i = 0; i < disks; i++) {
 			struct r5dev *dev = &sh->dev[i];
@@ -2307,7 +2307,7 @@ static int drop_one_stripe(struct r5conf *conf)
 	spin_unlock_irq(conf->hash_locks + hash);
 	if (!sh)
 		return 0;
-	BUG_ON(atomic_read(&sh->count));
+	BUG_ON(refcount_read(&sh->count));
 	shrink_buffers(sh);
 	kmem_cache_free(conf->slab_cache, sh);
 	atomic_dec(&conf->active_stripes);
@@ -2339,7 +2339,7 @@ static void raid5_end_read_request(struct bio * bi)
 			break;
 
 	pr_debug("end_read_request %llu/%d, count: %d, error %d.\n",
-		(unsigned long long)sh->sector, i, atomic_read(&sh->count),
+		(unsigned long long)sh->sector, i, refcount_read(&sh->count),
 		bi->bi_error);
 	if (i == disks) {
 		bio_reset(bi);
@@ -2469,7 +2469,7 @@ static void raid5_end_write_request(struct bio *bi)
 		}
 	}
 	pr_debug("end_write_request %llu/%d, count %d, error: %d.\n",
-		(unsigned long long)sh->sector, i, atomic_read(&sh->count),
+		(unsigned long long)sh->sector, i, refcount_read(&sh->count),
 		bi->bi_error);
 	if (i == disks) {
 		bio_reset(bi);
@@ -4417,7 +4417,7 @@ static void handle_stripe(struct stripe_head *sh)
 	pr_debug("handling stripe %llu, state=%#lx cnt=%d, "
 		"pd_idx=%d, qd_idx=%d\n, check:%d, reconstruct:%d\n",
 	       (unsigned long long)sh->sector, sh->state,
-	       atomic_read(&sh->count), sh->pd_idx, sh->qd_idx,
+	       refcount_read(&sh->count), sh->pd_idx, sh->qd_idx,
 	       sh->check_state, sh->reconstruct_state);
 
 	analyse_stripe(sh, &s);
@@ -4796,7 +4796,7 @@ static void activate_bit_delay(struct r5conf *conf,
 		struct stripe_head *sh = list_entry(head.next, struct stripe_head, lru);
 		int hash;
 		list_del_init(&sh->lru);
-		atomic_inc(&sh->count);
+		refcount_inc(&sh->count);
 		hash = sh->hash_lock_index;
 		__release_stripe(conf, sh, &temp_inactive_list[hash]);
 	}
@@ -5105,7 +5105,7 @@ static struct stripe_head *__get_priority_stripe(struct r5conf *conf, int group)
 		sh->group = NULL;
 	}
 	list_del_init(&sh->lru);
-	BUG_ON(atomic_inc_return(&sh->count) != 1);
+	refcount_inc_not_zero(&sh->count);
 	return sh;
 }
 
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index ed8e136..178f842 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -3,6 +3,7 @@
 
 #include <linux/raid/xor.h>
 #include <linux/dmaengine.h>
+#include <linux/refcount.h>
 
 /*
  *
@@ -207,7 +208,7 @@ struct stripe_head {
 	short			ddf_layout;/* use DDF ordering to calculate Q */
 	short			hash_lock_index;
 	unsigned long		state;		/* state flags */
-	atomic_t		count;	      /* nr of active thread/requests */
+	refcount_t		count;	      /* nr of active thread/requests */
 	int			bm_seq;	/* sequence number for bitmap flushes */
 	int			disks;		/* disks in stripe */
 	int			overwrite_disks; /* total overwrite disks in stripe,
diff --git a/drivers/media/pci/cx88/cx88-cards.c b/drivers/media/pci/cx88/cx88-cards.c
index cdfbde2..7537dc4 100644
--- a/drivers/media/pci/cx88/cx88-cards.c
+++ b/drivers/media/pci/cx88/cx88-cards.c
@@ -3670,7 +3670,7 @@ struct cx88_core *cx88_core_create(struct pci_dev *pci, int nr)
 	if (!core)
 		return NULL;
 
-	atomic_inc(&core->refcount);
+	refcount_inc(&core->refcount);
 	core->pci_bus  = pci->bus->number;
 	core->pci_slot = PCI_SLOT(pci->devfn);
 	core->pci_irqmask = PCI_INT_RISC_RD_BERRINT | PCI_INT_RISC_WR_BERRINT |
diff --git a/drivers/media/pci/cx88/cx88-core.c b/drivers/media/pci/cx88/cx88-core.c
index 973a9cd4..8bfa5b7 100644
--- a/drivers/media/pci/cx88/cx88-core.c
+++ b/drivers/media/pci/cx88/cx88-core.c
@@ -1052,7 +1052,7 @@ struct cx88_core *cx88_core_get(struct pci_dev *pci)
 			mutex_unlock(&devlist);
 			return NULL;
 		}
-		atomic_inc(&core->refcount);
+		refcount_inc(&core->refcount);
 		mutex_unlock(&devlist);
 		return core;
 	}
@@ -1073,7 +1073,7 @@ void cx88_core_put(struct cx88_core *core, struct pci_dev *pci)
 	release_mem_region(pci_resource_start(pci, 0),
 			   pci_resource_len(pci, 0));
 
-	if (!atomic_dec_and_test(&core->refcount))
+	if (!refcount_dec_and_test(&core->refcount))
 		return;
 
 	mutex_lock(&devlist);
diff --git a/drivers/media/pci/cx88/cx88.h b/drivers/media/pci/cx88/cx88.h
index 115414c..16c1313 100644
--- a/drivers/media/pci/cx88/cx88.h
+++ b/drivers/media/pci/cx88/cx88.h
@@ -24,6 +24,7 @@
 #include <linux/i2c-algo-bit.h>
 #include <linux/videodev2.h>
 #include <linux/kdev_t.h>
+#include <linux/refcount.h>
 
 #include <media/v4l2-device.h>
 #include <media/v4l2-fh.h>
@@ -339,7 +340,7 @@ struct cx8802_dev;
 
 struct cx88_core {
 	struct list_head           devlist;
-	atomic_t                   refcount;
+	refcount_t                   refcount;
 
 	/* board name */
 	int                        nr;
diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index f7bb78c..d682fb4b 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -40,6 +40,7 @@
 #include <linux/firmware.h>
 #include <linux/kernel.h>
 #include <linux/mutex.h>
+#include <linux/refcount.h>
 #include <linux/slab.h>
 #include <linux/videodev2.h>
 #include <linux/mm.h>
@@ -260,7 +261,7 @@ struct s2255_vc {
 struct s2255_dev {
 	struct s2255_vc         vc[MAX_CHANNELS];
 	struct v4l2_device      v4l2_dev;
-	atomic_t                num_channels;
+	refcount_t                num_channels;
 	int			frames;
 	struct mutex		lock;	/* channels[].vdev.lock */
 	struct mutex		cmdlock; /* protects cmdbuf */
@@ -1585,11 +1586,11 @@ static void s2255_video_device_release(struct video_device *vdev)
 		container_of(vdev, struct s2255_vc, vdev);
 
 	dprintk(dev, 4, "%s, chnls: %d\n", __func__,
-		atomic_read(&dev->num_channels));
+		refcount_read(&dev->num_channels));
 
 	v4l2_ctrl_handler_free(&vc->hdl);
 
-	if (atomic_dec_and_test(&dev->num_channels))
+	if (refcount_dec_and_test(&dev->num_channels))
 		s2255_destroy(dev);
 	return;
 }
@@ -1692,7 +1693,7 @@ static int s2255_probe_v4l(struct s2255_dev *dev)
 				"failed to register video device!\n");
 			break;
 		}
-		atomic_inc(&dev->num_channels);
+		refcount_inc(&dev->num_channels);
 		v4l2_info(&dev->v4l2_dev, "V4L2 device registered as %s\n",
 			  video_device_node_name(&vc->vdev));
 
@@ -1700,11 +1701,11 @@ static int s2255_probe_v4l(struct s2255_dev *dev)
 	pr_info("Sensoray 2255 V4L driver Revision: %s\n",
 		S2255_VERSION);
 	/* if no channels registered, return error and probe will fail*/
-	if (atomic_read(&dev->num_channels) == 0) {
+	if (refcount_read(&dev->num_channels) == 0) {
 		v4l2_device_unregister(&dev->v4l2_dev);
 		return ret;
 	}
-	if (atomic_read(&dev->num_channels) != MAX_CHANNELS)
+	if (refcount_read(&dev->num_channels) != MAX_CHANNELS)
 		pr_warn("s2255: Not all channels available.\n");
 	return 0;
 }
@@ -2252,7 +2253,7 @@ static int s2255_probe(struct usb_interface *interface,
 		goto errorFWDATA1;
 	}
 
-	atomic_set(&dev->num_channels, 0);
+	refcount_set(&dev->num_channels, 0);
 	dev->pid = id->idProduct;
 	dev->fw_data = kzalloc(sizeof(struct s2255_fw), GFP_KERNEL);
 	if (!dev->fw_data)
@@ -2372,12 +2373,12 @@ static void s2255_disconnect(struct usb_interface *interface)
 {
 	struct s2255_dev *dev = to_s2255_dev(usb_get_intfdata(interface));
 	int i;
-	int channels = atomic_read(&dev->num_channels);
+	int channels = refcount_read(&dev->num_channels);
 	mutex_lock(&dev->lock);
 	v4l2_device_disconnect(&dev->v4l2_dev);
 	mutex_unlock(&dev->lock);
 	/*see comments in the uvc_driver.c usb disconnect function */
-	atomic_inc(&dev->num_channels);
+	refcount_inc(&dev->num_channels);
 	/* unregister each video device. */
 	for (i = 0; i < channels; i++)
 		video_unregister_device(&dev->vc[i].vdev);
@@ -2390,7 +2391,7 @@ static void s2255_disconnect(struct usb_interface *interface)
 		dev->vc[i].vidstatus_ready = 1;
 		wake_up(&dev->vc[i].wait_vidstatus);
 	}
-	if (atomic_dec_and_test(&dev->num_channels))
+	if (refcount_dec_and_test(&dev->num_channels))
 		s2255_destroy(dev);
 	dev_info(&interface->dev, "%s\n", __func__);
 }
diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index c2ee6e3..b96d8c1 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -2012,9 +2012,10 @@ int uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
 		}
 	}
 
+	refcount_inc(&dev->nmappings);
 	/* Prevent excess memory consumption */
-	if (atomic_inc_return(&dev->nmappings) > UVC_MAX_CONTROL_MAPPINGS) {
-		atomic_dec(&dev->nmappings);
+	if (refcount_read(&dev->nmappings) > UVC_MAX_CONTROL_MAPPINGS) {
+		refcount_dec(&dev->nmappings);
 		uvc_trace(UVC_TRACE_CONTROL, "Can't add mapping '%s', maximum "
 			"mappings count (%u) exceeded.\n", mapping->name,
 			UVC_MAX_CONTROL_MAPPINGS);
@@ -2024,7 +2025,7 @@ int uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
 
 	ret = __uvc_ctrl_add_mapping(dev, ctrl, mapping);
 	if (ret < 0)
-		atomic_dec(&dev->nmappings);
+		refcount_dec(&dev->nmappings);
 
 done:
 	mutex_unlock(&chain->ctrl_mutex);
diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 04bf350..9d6258e 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1842,7 +1842,7 @@ static void uvc_release(struct video_device *vdev)
 	/* Decrement the registered streams count and delete the device when it
 	 * reaches zero.
 	 */
-	if (atomic_dec_and_test(&dev->nstreams))
+	if (refcount_dec_and_test(&dev->nstreams))
 		uvc_delete(dev);
 }
 
@@ -1858,7 +1858,7 @@ static void uvc_unregister_video(struct uvc_device *dev)
 	 * that, increment the stream count before iterating over the streams
 	 * and decrement it when done.
 	 */
-	atomic_inc(&dev->nstreams);
+	refcount_inc(&dev->nstreams);
 
 	list_for_each_entry(stream, &dev->streams, list) {
 		if (!video_is_registered(&stream->vdev))
@@ -1872,7 +1872,7 @@ static void uvc_unregister_video(struct uvc_device *dev)
 	/* Decrement the stream count and call uvc_delete explicitly if there
 	 * are no stream left.
 	 */
-	if (atomic_dec_and_test(&dev->nstreams))
+	if (refcount_dec_and_test(&dev->nstreams))
 		uvc_delete(dev);
 }
 
@@ -1931,7 +1931,7 @@ static int uvc_register_video(struct uvc_device *dev,
 	else
 		stream->chain->caps |= V4L2_CAP_VIDEO_OUTPUT;
 
-	atomic_inc(&dev->nstreams);
+	refcount_inc(&dev->nstreams);
 	return 0;
 }
 
@@ -2015,8 +2015,8 @@ static int uvc_probe(struct usb_interface *intf,
 	INIT_LIST_HEAD(&dev->entities);
 	INIT_LIST_HEAD(&dev->chains);
 	INIT_LIST_HEAD(&dev->streams);
-	atomic_set(&dev->nstreams, 0);
-	atomic_set(&dev->nmappings, 0);
+	refcount_set(&dev->nstreams, 0);
+	refcount_set(&dev->nmappings, 0);
 	mutex_init(&dev->lock);
 
 	dev->udev = usb_get_dev(udev);
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 3d6cc62..289321e 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -7,6 +7,7 @@
 
 #include <linux/kernel.h>
 #include <linux/poll.h>
+#include <linux/refcount.h>
 #include <linux/usb.h>
 #include <linux/usb/video.h>
 #include <linux/uvcvideo.h>
@@ -551,7 +552,7 @@ struct uvc_device {
 
 	struct mutex lock;		/* Protects users */
 	unsigned int users;
-	atomic_t nmappings;
+	refcount_t nmappings;
 
 	/* Video control interface */
 #ifdef CONFIG_MEDIA_CONTROLLER
@@ -566,7 +567,7 @@ struct uvc_device {
 
 	/* Video Streaming interfaces */
 	struct list_head streams;
-	atomic_t nstreams;
+	refcount_t nstreams;
 
 	/* Status Interrupt Endpoint */
 	struct usb_host_endpoint *int_ep;
diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index fb6a177..ed2176e 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -12,6 +12,7 @@
 
 #include <linux/dma-buf.h>
 #include <linux/module.h>
+#include <linux/refcount.h>
 #include <linux/scatterlist.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -34,7 +35,7 @@ struct vb2_dc_buf {
 
 	/* MMAP related */
 	struct vb2_vmarea_handler	handler;
-	atomic_t			refcount;
+	refcount_t			refcount;
 	struct sg_table			*sgt_base;
 
 	/* DMABUF related */
@@ -86,7 +87,7 @@ static unsigned int vb2_dc_num_users(void *buf_priv)
 {
 	struct vb2_dc_buf *buf = buf_priv;
 
-	return atomic_read(&buf->refcount);
+	return refcount_read(&buf->refcount);
 }
 
 static void vb2_dc_prepare(void *buf_priv)
@@ -122,7 +123,7 @@ static void vb2_dc_put(void *buf_priv)
 {
 	struct vb2_dc_buf *buf = buf_priv;
 
-	if (!atomic_dec_and_test(&buf->refcount))
+	if (!refcount_dec_and_test(&buf->refcount))
 		return;
 
 	if (buf->sgt_base) {
@@ -170,7 +171,7 @@ static void *vb2_dc_alloc(struct device *dev, unsigned long attrs,
 	buf->handler.put = vb2_dc_put;
 	buf->handler.arg = buf;
 
-	atomic_inc(&buf->refcount);
+	refcount_inc(&buf->refcount);
 
 	return buf;
 }
@@ -407,7 +408,7 @@ static struct dma_buf *vb2_dc_get_dmabuf(void *buf_priv, unsigned long flags)
 		return NULL;
 
 	/* dmabuf keeps reference to vb2 buffer */
-	atomic_inc(&buf->refcount);
+	refcount_inc(&buf->refcount);
 
 	return dbuf;
 }
diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index ecff8f4..f5ab6c2 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -12,6 +12,7 @@
 
 #include <linux/module.h>
 #include <linux/mm.h>
+#include <linux/refcount.h>
 #include <linux/scatterlist.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -46,7 +47,7 @@ struct vb2_dma_sg_buf {
 	struct sg_table			*dma_sgt;
 	size_t				size;
 	unsigned int			num_pages;
-	atomic_t			refcount;
+	refcount_t			refcount;
 	struct vb2_vmarea_handler	handler;
 
 	struct dma_buf_attachment	*db_attach;
@@ -150,7 +151,7 @@ static void *vb2_dma_sg_alloc(struct device *dev, unsigned long dma_attrs,
 	buf->handler.put = vb2_dma_sg_put;
 	buf->handler.arg = buf;
 
-	atomic_inc(&buf->refcount);
+	refcount_inc(&buf->refcount);
 
 	dprintk(1, "%s: Allocated buffer of %d pages\n",
 		__func__, buf->num_pages);
@@ -176,7 +177,7 @@ static void vb2_dma_sg_put(void *buf_priv)
 	struct sg_table *sgt = &buf->sg_table;
 	int i = buf->num_pages;
 
-	if (atomic_dec_and_test(&buf->refcount)) {
+	if (refcount_dec_and_test(&buf->refcount)) {
 		dprintk(1, "%s: Freeing buffer of %d pages\n", __func__,
 			buf->num_pages);
 		dma_unmap_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents,
@@ -320,7 +321,7 @@ static unsigned int vb2_dma_sg_num_users(void *buf_priv)
 {
 	struct vb2_dma_sg_buf *buf = buf_priv;
 
-	return atomic_read(&buf->refcount);
+	return refcount_read(&buf->refcount);
 }
 
 static int vb2_dma_sg_mmap(void *buf_priv, struct vm_area_struct *vma)
@@ -530,7 +531,7 @@ static struct dma_buf *vb2_dma_sg_get_dmabuf(void *buf_priv, unsigned long flags
 		return NULL;
 
 	/* dmabuf keeps reference to vb2 buffer */
-	atomic_inc(&buf->refcount);
+	refcount_inc(&buf->refcount);
 
 	return dbuf;
 }
diff --git a/drivers/media/v4l2-core/videobuf2-memops.c b/drivers/media/v4l2-core/videobuf2-memops.c
index 1cd322e..4bb8424 100644
--- a/drivers/media/v4l2-core/videobuf2-memops.c
+++ b/drivers/media/v4l2-core/videobuf2-memops.c
@@ -96,10 +96,10 @@ static void vb2_common_vm_open(struct vm_area_struct *vma)
 	struct vb2_vmarea_handler *h = vma->vm_private_data;
 
 	pr_debug("%s: %p, refcount: %d, vma: %08lx-%08lx\n",
-	       __func__, h, atomic_read(h->refcount), vma->vm_start,
+	       __func__, h, refcount_read(h->refcount), vma->vm_start,
 	       vma->vm_end);
 
-	atomic_inc(h->refcount);
+	refcount_inc(h->refcount);
 }
 
 /**
@@ -114,7 +114,7 @@ static void vb2_common_vm_close(struct vm_area_struct *vma)
 	struct vb2_vmarea_handler *h = vma->vm_private_data;
 
 	pr_debug("%s: %p, refcount: %d, vma: %08lx-%08lx\n",
-	       __func__, h, atomic_read(h->refcount), vma->vm_start,
+	       __func__, h, refcount_read(h->refcount), vma->vm_start,
 	       vma->vm_end);
 
 	h->put(h->arg);
diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
index 3f77814..b00eea4 100644
--- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
+++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
@@ -13,6 +13,7 @@
 #include <linux/io.h>
 #include <linux/module.h>
 #include <linux/mm.h>
+#include <linux/refcount.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
@@ -26,7 +27,7 @@ struct vb2_vmalloc_buf {
 	struct frame_vector		*vec;
 	enum dma_data_direction		dma_dir;
 	unsigned long			size;
-	atomic_t			refcount;
+	refcount_t			refcount;
 	struct vb2_vmarea_handler	handler;
 	struct dma_buf			*dbuf;
 };
@@ -56,7 +57,7 @@ static void *vb2_vmalloc_alloc(struct device *dev, unsigned long attrs,
 		return ERR_PTR(-ENOMEM);
 	}
 
-	atomic_inc(&buf->refcount);
+	refcount_inc(&buf->refcount);
 	return buf;
 }
 
@@ -64,7 +65,7 @@ static void vb2_vmalloc_put(void *buf_priv)
 {
 	struct vb2_vmalloc_buf *buf = buf_priv;
 
-	if (atomic_dec_and_test(&buf->refcount)) {
+	if (refcount_dec_and_test(&buf->refcount)) {
 		vfree(buf->vaddr);
 		kfree(buf);
 	}
@@ -161,7 +162,7 @@ static void *vb2_vmalloc_vaddr(void *buf_priv)
 static unsigned int vb2_vmalloc_num_users(void *buf_priv)
 {
 	struct vb2_vmalloc_buf *buf = buf_priv;
-	return atomic_read(&buf->refcount);
+	return refcount_read(&buf->refcount);
 }
 
 static int vb2_vmalloc_mmap(void *buf_priv, struct vm_area_struct *vma)
@@ -368,7 +369,7 @@ static struct dma_buf *vb2_vmalloc_get_dmabuf(void *buf_priv, unsigned long flag
 		return NULL;
 
 	/* dmabuf keeps reference to vb2 buffer */
-	atomic_inc(&buf->refcount);
+	refcount_inc(&buf->refcount);
 
 	return dbuf;
 }
diff --git a/drivers/pci/host/pci-hyperv.c b/drivers/pci/host/pci-hyperv.c
index 3efcc7b..3a3ed2b 100644
--- a/drivers/pci/host/pci-hyperv.c
+++ b/drivers/pci/host/pci-hyperv.c
@@ -56,6 +56,7 @@
 #include <asm/apic.h>
 #include <linux/msi.h>
 #include <linux/hyperv.h>
+#include <linux/refcount.h>
 #include <asm/mshyperv.h>
 
 /*
@@ -420,7 +421,7 @@ enum hv_pcidev_ref_reason {
 struct hv_pci_dev {
 	/* List protected by pci_rescan_remove_lock */
 	struct list_head list_entry;
-	atomic_t refs;
+	refcount_t refs;
 	enum hv_pcichild_state state;
 	struct pci_function_description desc;
 	bool reported_missing;
@@ -1252,13 +1253,13 @@ static void q_resource_requirements(void *context, struct pci_response *resp,
 static void get_pcichild(struct hv_pci_dev *hpdev,
 			    enum hv_pcidev_ref_reason reason)
 {
-	atomic_inc(&hpdev->refs);
+	refcount_inc(&hpdev->refs);
 }
 
 static void put_pcichild(struct hv_pci_dev *hpdev,
 			    enum hv_pcidev_ref_reason reason)
 {
-	if (atomic_dec_and_test(&hpdev->refs))
+	if (refcount_dec_and_test(&hpdev->refs))
 		kfree(hpdev);
 }
 
diff --git a/drivers/s390/char/vmur.c b/drivers/s390/char/vmur.c
index ff18f37..7de1f6c 100644
--- a/drivers/s390/char/vmur.c
+++ b/drivers/s390/char/vmur.c
@@ -110,7 +110,7 @@ static struct urdev *urdev_alloc(struct ccw_device *cdev)
 	mutex_init(&urd->io_mutex);
 	init_waitqueue_head(&urd->wait);
 	spin_lock_init(&urd->open_lock);
-	atomic_set(&urd->ref_count,  1);
+	refcount_set(&urd->ref_count,  1);
 	urd->cdev = cdev;
 	get_device(&cdev->dev);
 	return urd;
@@ -126,7 +126,7 @@ static void urdev_free(struct urdev *urd)
 
 static void urdev_get(struct urdev *urd)
 {
-	atomic_inc(&urd->ref_count);
+	refcount_inc(&urd->ref_count);
 }
 
 static struct urdev *urdev_get_from_cdev(struct ccw_device *cdev)
@@ -159,7 +159,7 @@ static struct urdev *urdev_get_from_devno(u16 devno)
 
 static void urdev_put(struct urdev *urd)
 {
-	if (atomic_dec_and_test(&urd->ref_count))
+	if (refcount_dec_and_test(&urd->ref_count))
 		urdev_free(urd);
 }
 
@@ -946,7 +946,7 @@ static int ur_set_offline_force(struct ccw_device *cdev, int force)
 		rc = -EBUSY;
 		goto fail_urdev_put;
 	}
-	if (!force && (atomic_read(&urd->ref_count) > 2)) {
+	if (!force && (refcount_read(&urd->ref_count) > 2)) {
 		/* There is still a user of urd (e.g. ur_open) */
 		TRACE("ur_set_offline: BUSY\n");
 		rc = -EBUSY;
diff --git a/drivers/s390/char/vmur.h b/drivers/s390/char/vmur.h
index fa320ad..35ea9d1 100644
--- a/drivers/s390/char/vmur.h
+++ b/drivers/s390/char/vmur.h
@@ -11,6 +11,8 @@
 #ifndef _VMUR_H_
 #define _VMUR_H_
 
+#include <linux/refcount.h>
+
 #define DEV_CLASS_UR_I 0x20 /* diag210 unit record input device class */
 #define DEV_CLASS_UR_O 0x10 /* diag210 unit record output device class */
 /*
@@ -69,7 +71,7 @@ struct urdev {
 	size_t reclen;			/* Record length for *write* CCWs */
 	int class;			/* VM device class */
 	int io_request_rc;		/* return code from I/O request */
-	atomic_t ref_count;		/* reference counter */
+	refcount_t ref_count;		/* reference counter */
 	wait_queue_head_t wait;		/* wait queue to serialize open */
 	int open_flag;			/* "urdev is open" flag */
 	spinlock_t open_lock;		/* serialize critical sections */
diff --git a/drivers/s390/net/lcs.c b/drivers/s390/net/lcs.c
index 211b31d..fd68f67 100644
--- a/drivers/s390/net/lcs.c
+++ b/drivers/s390/net/lcs.c
@@ -774,15 +774,15 @@ lcs_get_lancmd(struct lcs_card *card, int count)
 static void
 lcs_get_reply(struct lcs_reply *reply)
 {
-	WARN_ON(atomic_read(&reply->refcnt) <= 0);
-	atomic_inc(&reply->refcnt);
+	WARN_ON(refcount_read(&reply->refcnt) == 0);
+	refcount_inc(&reply->refcnt);
 }
 
 static void
 lcs_put_reply(struct lcs_reply *reply)
 {
-        WARN_ON(atomic_read(&reply->refcnt) <= 0);
-        if (atomic_dec_and_test(&reply->refcnt)) {
+        WARN_ON(refcount_read(&reply->refcnt) == 0);
+        if (refcount_dec_and_test(&reply->refcnt)) {
 		kfree(reply);
 	}
 
@@ -798,7 +798,7 @@ lcs_alloc_reply(struct lcs_cmd *cmd)
 	reply = kzalloc(sizeof(struct lcs_reply), GFP_ATOMIC);
 	if (!reply)
 		return NULL;
-	atomic_set(&reply->refcnt,1);
+	refcount_set(&reply->refcnt,1);
 	reply->sequence_no = cmd->sequence_no;
 	reply->received = 0;
 	reply->rc = 0;
diff --git a/drivers/s390/net/lcs.h b/drivers/s390/net/lcs.h
index 150fcb4..3802f4f 100644
--- a/drivers/s390/net/lcs.h
+++ b/drivers/s390/net/lcs.h
@@ -4,6 +4,7 @@
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
 #include <linux/workqueue.h>
+#include <linux/refcount.h>
 #include <asm/ccwdev.h>
 
 #define LCS_DBF_TEXT(level, name, text) \
@@ -270,7 +271,7 @@ struct lcs_buffer {
 struct lcs_reply {
 	struct list_head list;
 	__u16 sequence_no;
-	atomic_t refcnt;
+	refcount_t refcnt;
 	/* Callback for completion notification. */
 	void (*callback)(struct lcs_card *, struct lcs_cmd *);
 	wait_queue_head_t wait_q;
diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 6d4b68c4..99cdcfc 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -20,6 +20,7 @@
 #include <linux/ethtool.h>
 #include <linux/hashtable.h>
 #include <linux/ip.h>
+#include <linux/refcount.h>
 
 #include <net/ipv6.h>
 #include <net/if_inet6.h>
@@ -643,7 +644,7 @@ struct qeth_reply {
 	int rc;
 	void *param;
 	struct qeth_card *card;
-	atomic_t refcnt;
+	refcount_t refcnt;
 };
 
 
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index e6ebcd7..efd92fb 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -555,7 +555,7 @@ static struct qeth_reply *qeth_alloc_reply(struct qeth_card *card)
 
 	reply = kzalloc(sizeof(struct qeth_reply), GFP_ATOMIC);
 	if (reply) {
-		atomic_set(&reply->refcnt, 1);
+		refcount_set(&reply->refcnt, 1);
 		atomic_set(&reply->received, 0);
 		reply->card = card;
 	}
@@ -564,14 +564,14 @@ static struct qeth_reply *qeth_alloc_reply(struct qeth_card *card)
 
 static void qeth_get_reply(struct qeth_reply *reply)
 {
-	WARN_ON(atomic_read(&reply->refcnt) <= 0);
-	atomic_inc(&reply->refcnt);
+	WARN_ON(refcount_read(&reply->refcnt) == 0);
+	refcount_inc(&reply->refcnt);
 }
 
 static void qeth_put_reply(struct qeth_reply *reply)
 {
-	WARN_ON(atomic_read(&reply->refcnt) <= 0);
-	if (atomic_dec_and_test(&reply->refcnt))
+	WARN_ON(refcount_read(&reply->refcnt) == 0);
+	if (refcount_dec_and_test(&reply->refcnt))
 		kfree(reply);
 }
 
diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 42bcf7f..cff268b 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -257,7 +257,7 @@ static const char *fc_exch_rctl_name(unsigned int op)
  */
 static inline void fc_exch_hold(struct fc_exch *ep)
 {
-	atomic_inc(&ep->ex_refcnt);
+	refcount_inc(&ep->ex_refcnt);
 }
 
 /**
@@ -323,7 +323,7 @@ static void fc_exch_release(struct fc_exch *ep)
 {
 	struct fc_exch_mgr *mp;
 
-	if (atomic_dec_and_test(&ep->ex_refcnt)) {
+	if (refcount_dec_and_test(&ep->ex_refcnt)) {
 		mp = ep->em;
 		if (ep->destructor)
 			ep->destructor(&ep->seq, ep->arg);
@@ -340,7 +340,7 @@ static inline void fc_exch_timer_cancel(struct fc_exch *ep)
 {
 	if (cancel_delayed_work(&ep->timeout_work)) {
 		FC_EXCH_DBG(ep, "Exchange timer canceled\n");
-		atomic_dec(&ep->ex_refcnt); /* drop hold for timer */
+		refcount_dec(&ep->ex_refcnt); /* drop hold for timer */
 	}
 }
 
@@ -1899,7 +1899,7 @@ static void fc_exch_reset(struct fc_exch *ep)
 	ep->state |= FC_EX_RST_CLEANUP;
 	fc_exch_timer_cancel(ep);
 	if (ep->esb_stat & ESB_ST_REC_QUAL)
-		atomic_dec(&ep->ex_refcnt);	/* drop hold for rec_qual */
+		refcount_dec(&ep->ex_refcnt);	/* drop hold for rec_qual */
 	ep->esb_stat &= ~ESB_ST_REC_QUAL;
 	sp = &ep->seq;
 	rc = fc_exch_done_locked(ep);
@@ -2328,7 +2328,7 @@ static void fc_exch_els_rrq(struct fc_frame *fp)
 	 */
 	if (ep->esb_stat & ESB_ST_REC_QUAL) {
 		ep->esb_stat &= ~ESB_ST_REC_QUAL;
-		atomic_dec(&ep->ex_refcnt);	/* drop hold for rec qual */
+		refcount_dec(&ep->ex_refcnt);	/* drop hold for rec qual */
 	}
 	if (ep->esb_stat & ESB_ST_COMPLETE)
 		fc_exch_timer_cancel(ep);
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 0e67621..a808e8e 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -154,7 +154,7 @@ static struct fc_fcp_pkt *fc_fcp_pkt_alloc(struct fc_lport *lport, gfp_t gfp)
 		memset(fsp, 0, sizeof(*fsp));
 		fsp->lp = lport;
 		fsp->xfer_ddp = FC_XID_UNKNOWN;
-		atomic_set(&fsp->ref_cnt, 1);
+		refcount_set(&fsp->ref_cnt, 1);
 		init_timer(&fsp->timer);
 		fsp->timer.data = (unsigned long)fsp;
 		INIT_LIST_HEAD(&fsp->list);
@@ -175,7 +175,7 @@ static struct fc_fcp_pkt *fc_fcp_pkt_alloc(struct fc_lport *lport, gfp_t gfp)
  */
 static void fc_fcp_pkt_release(struct fc_fcp_pkt *fsp)
 {
-	if (atomic_dec_and_test(&fsp->ref_cnt)) {
+	if (refcount_dec_and_test(&fsp->ref_cnt)) {
 		struct fc_fcp_internal *si = fc_get_scsi_internal(fsp->lp);
 
 		mempool_free(fsp, si->scsi_pkt_pool);
@@ -188,7 +188,7 @@ static void fc_fcp_pkt_release(struct fc_fcp_pkt *fsp)
  */
 static void fc_fcp_pkt_hold(struct fc_fcp_pkt *fsp)
 {
-	atomic_inc(&fsp->ref_cnt);
+	refcount_inc(&fsp->ref_cnt);
 }
 
 /**
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index f9b6fba..400b978 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -516,13 +516,13 @@ static void iscsi_free_task(struct iscsi_task *task)
 
 void __iscsi_get_task(struct iscsi_task *task)
 {
-	atomic_inc(&task->refcount);
+	refcount_inc(&task->refcount);
 }
 EXPORT_SYMBOL_GPL(__iscsi_get_task);
 
 void __iscsi_put_task(struct iscsi_task *task)
 {
-	if (atomic_dec_and_test(&task->refcount))
+	if (refcount_dec_and_test(&task->refcount))
 		iscsi_free_task(task);
 }
 EXPORT_SYMBOL_GPL(__iscsi_put_task);
@@ -744,7 +744,7 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	 * released by the lld when it has transmitted the task for
 	 * pdus we do not expect a response for.
 	 */
-	atomic_set(&task->refcount, 1);
+	refcount_set(&task->refcount, 1);
 	task->conn = conn;
 	task->sc = NULL;
 	INIT_LIST_HEAD(&task->running);
@@ -1616,7 +1616,7 @@ static inline struct iscsi_task *iscsi_alloc_task(struct iscsi_conn *conn,
 	sc->SCp.phase = conn->session->age;
 	sc->SCp.ptr = (char *) task;
 
-	atomic_set(&task->refcount, 1);
+	refcount_set(&task->refcount, 1);
 	task->state = ISCSI_TASK_PENDING;
 	task->conn = conn;
 	task->sc = sc;
diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index 87aa517..f2a3c17 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -17,7 +17,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/atomic.h>
+#include <linux/refcount.h>
 #include <linux/cdev.h>
 #include <linux/delay.h>
 #include <linux/device.h>
@@ -117,7 +117,7 @@ static const int type[VME_DEVS] = {	MASTER_MINOR,	MASTER_MINOR,
 
 struct vme_user_vma_priv {
 	unsigned int minor;
-	atomic_t refcnt;
+	refcount_t refcnt;
 };
 
 static ssize_t resource_to_user(int minor, char __user *buf, size_t count,
@@ -429,7 +429,7 @@ static void vme_user_vm_open(struct vm_area_struct *vma)
 {
 	struct vme_user_vma_priv *vma_priv = vma->vm_private_data;
 
-	atomic_inc(&vma_priv->refcnt);
+	refcount_inc(&vma_priv->refcnt);
 }
 
 static void vme_user_vm_close(struct vm_area_struct *vma)
@@ -437,7 +437,7 @@ static void vme_user_vm_close(struct vm_area_struct *vma)
 	struct vme_user_vma_priv *vma_priv = vma->vm_private_data;
 	unsigned int minor = vma_priv->minor;
 
-	if (!atomic_dec_and_test(&vma_priv->refcnt))
+	if (!refcount_dec_and_test(&vma_priv->refcnt))
 		return;
 
 	mutex_lock(&image[minor].mutex);
@@ -472,7 +472,7 @@ static int vme_user_master_mmap(unsigned int minor, struct vm_area_struct *vma)
 	}
 
 	vma_priv->minor = minor;
-	atomic_set(&vma_priv->refcnt, 1);
+	refcount_set(&vma_priv->refcnt, 1);
 	vma->vm_ops = &vme_user_vm_ops;
 	vma->vm_private_data = vma_priv;
 
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index d316ed5..bb069eb 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -279,7 +279,7 @@ static void iblock_complete_cmd(struct se_cmd *cmd)
 	struct iblock_req *ibr = cmd->priv;
 	u8 status;
 
-	if (!atomic_dec_and_test(&ibr->pending))
+	if (!refcount_dec_and_test(&ibr->pending))
 		return;
 
 	if (atomic_read(&ibr->ib_bio_err_cnt))
@@ -487,7 +487,7 @@ iblock_execute_write_same(struct se_cmd *cmd)
 	bio_list_init(&list);
 	bio_list_add(&list, bio);
 
-	atomic_set(&ibr->pending, 1);
+	refcount_set(&ibr->pending, 1);
 
 	while (sectors) {
 		while (bio_add_page(bio, sg_page(sg), sg->length, sg->offset)
@@ -498,7 +498,7 @@ iblock_execute_write_same(struct se_cmd *cmd)
 			if (!bio)
 				goto fail_put_bios;
 
-			atomic_inc(&ibr->pending);
+			refcount_inc(&ibr->pending);
 			bio_list_add(&list, bio);
 		}
 
@@ -706,7 +706,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	cmd->priv = ibr;
 
 	if (!sgl_nents) {
-		atomic_set(&ibr->pending, 1);
+		refcount_set(&ibr->pending, 1);
 		iblock_complete_cmd(cmd);
 		return 0;
 	}
@@ -719,7 +719,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	bio_list_init(&list);
 	bio_list_add(&list, bio);
 
-	atomic_set(&ibr->pending, 2);
+	refcount_set(&ibr->pending, 2);
 	bio_cnt = 1;
 
 	for_each_sg(sgl, sg, sgl_nents, i) {
@@ -740,7 +740,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 			if (!bio)
 				goto fail_put_bios;
 
-			atomic_inc(&ibr->pending);
+			refcount_inc(&ibr->pending);
 			bio_list_add(&list, bio);
 			bio_cnt++;
 		}
diff --git a/drivers/target/target_core_iblock.h b/drivers/target/target_core_iblock.h
index 718d3fc..f2a5797 100644
--- a/drivers/target/target_core_iblock.h
+++ b/drivers/target/target_core_iblock.h
@@ -2,6 +2,7 @@
 #define TARGET_CORE_IBLOCK_H
 
 #include <linux/atomic.h>
+#include <linux/refcount.h>
 #include <target/target_core_base.h>
 
 #define IBLOCK_VERSION		"4.0"
@@ -10,7 +11,7 @@
 #define IBLOCK_LBA_SHIFT	9
 
 struct iblock_req {
-	atomic_t pending;
+	refcount_t pending;
 	atomic_t ib_bio_err_cnt;
 } ____cacheline_aligned;
 
diff --git a/drivers/tty/serial/dz.c b/drivers/tty/serial/dz.c
index c121f16..5b5358f 100644
--- a/drivers/tty/serial/dz.c
+++ b/drivers/tty/serial/dz.c
@@ -49,7 +49,7 @@
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 
-#include <linux/atomic.h>
+#include <linux/refcount.h>
 #include <asm/bootinfo.h>
 #include <asm/io.h>
 
@@ -78,8 +78,8 @@ struct dz_port {
 
 struct dz_mux {
 	struct dz_port		dport[DZ_NB_PORT];
-	atomic_t		map_guard;
-	atomic_t		irq_guard;
+	refcount_t		map_guard;
+	refcount_t		irq_guard;
 	int			initialised;
 };
 
@@ -403,18 +403,17 @@ static int dz_startup(struct uart_port *uport)
 	struct dz_port *dport = to_dport(uport);
 	struct dz_mux *mux = dport->mux;
 	unsigned long flags;
-	int irq_guard;
 	int ret;
 	u16 tmp;
 
-	irq_guard = atomic_add_return(1, &mux->irq_guard);
-	if (irq_guard != 1)
+	refcount_inc(&mux->irq_guard);
+	if (refcount_read(&mux->irq_guard) != 1)
 		return 0;
 
 	ret = request_irq(dport->port.irq, dz_interrupt,
 			  IRQF_SHARED, "dz", mux);
 	if (ret) {
-		atomic_add(-1, &mux->irq_guard);
+		refcount_dec(&mux->irq_guard);
 		printk(KERN_ERR "dz: Cannot get IRQ %d!\n", dport->port.irq);
 		return ret;
 	}
@@ -444,15 +443,13 @@ static void dz_shutdown(struct uart_port *uport)
 	struct dz_port *dport = to_dport(uport);
 	struct dz_mux *mux = dport->mux;
 	unsigned long flags;
-	int irq_guard;
 	u16 tmp;
 
 	spin_lock_irqsave(&dport->port.lock, flags);
 	dz_stop_tx(&dport->port);
 	spin_unlock_irqrestore(&dport->port.lock, flags);
 
-	irq_guard = atomic_add_return(-1, &mux->irq_guard);
-	if (!irq_guard) {
+	if (refcount_dec_and_test(&mux->irq_guard)) {
 		/* Disable interrupts.  */
 		tmp = dz_in(dport, DZ_CSR);
 		tmp &= ~(DZ_RIE | DZ_TIE);
@@ -663,13 +660,11 @@ static const char *dz_type(struct uart_port *uport)
 static void dz_release_port(struct uart_port *uport)
 {
 	struct dz_mux *mux = to_dport(uport)->mux;
-	int map_guard;
 
 	iounmap(uport->membase);
 	uport->membase = NULL;
 
-	map_guard = atomic_add_return(-1, &mux->map_guard);
-	if (!map_guard)
+	if (refcount_dec_and_test(&mux->map_guard))
 		release_mem_region(uport->mapbase, dec_kn_slot_size);
 }
 
@@ -688,14 +683,13 @@ static int dz_map_port(struct uart_port *uport)
 static int dz_request_port(struct uart_port *uport)
 {
 	struct dz_mux *mux = to_dport(uport)->mux;
-	int map_guard;
 	int ret;
 
-	map_guard = atomic_add_return(1, &mux->map_guard);
-	if (map_guard == 1) {
+	refcount_inc(&mux->map_guard);
+	if (refcount_read(&mux->map_guard) == 1) {
 		if (!request_mem_region(uport->mapbase, dec_kn_slot_size,
 					"dz")) {
-			atomic_add(-1, &mux->map_guard);
+			refcount_dec(&mux->map_guard);
 			printk(KERN_ERR
 			       "dz: Unable to reserve MMIO resource\n");
 			return -EBUSY;
@@ -703,8 +697,7 @@ static int dz_request_port(struct uart_port *uport)
 	}
 	ret = dz_map_port(uport);
 	if (ret) {
-		map_guard = atomic_add_return(-1, &mux->map_guard);
-		if (!map_guard)
+		if (refcount_dec_and_test(&mux->map_guard))
 			release_mem_region(uport->mapbase, dec_kn_slot_size);
 		return ret;
 	}
diff --git a/drivers/tty/serial/sb1250-duart.c b/drivers/tty/serial/sb1250-duart.c
index 771f361..041625c 100644
--- a/drivers/tty/serial/sb1250-duart.c
+++ b/drivers/tty/serial/sb1250-duart.c
@@ -41,7 +41,7 @@
 #include <linux/tty_flip.h>
 #include <linux/types.h>
 
-#include <linux/atomic.h>
+#include <linux/refcount.h>
 #include <asm/io.h>
 #include <asm/war.h>
 
@@ -103,7 +103,7 @@ struct sbd_port {
 struct sbd_duart {
 	struct sbd_port		sport[2];
 	unsigned long		mapctrl;
-	atomic_t		map_guard;
+	refcount_t		map_guard;
 };
 
 #define to_sport(uport) container_of(uport, struct sbd_port, port)
@@ -654,15 +654,13 @@ static void sbd_release_port(struct uart_port *uport)
 {
 	struct sbd_port *sport = to_sport(uport);
 	struct sbd_duart *duart = sport->duart;
-	int map_guard;
 
 	iounmap(sport->memctrl);
 	sport->memctrl = NULL;
 	iounmap(uport->membase);
 	uport->membase = NULL;
 
-	map_guard = atomic_add_return(-1, &duart->map_guard);
-	if (!map_guard)
+	if(refcount_dec_and_test(&duart->map_guard))
 		release_mem_region(duart->mapctrl, DUART_CHANREG_SPACING);
 	release_mem_region(uport->mapbase, DUART_CHANREG_SPACING);
 }
@@ -698,7 +696,6 @@ static int sbd_request_port(struct uart_port *uport)
 {
 	const char *err = KERN_ERR "sbd: Unable to reserve MMIO resource\n";
 	struct sbd_duart *duart = to_sport(uport)->duart;
-	int map_guard;
 	int ret = 0;
 
 	if (!request_mem_region(uport->mapbase, DUART_CHANREG_SPACING,
@@ -706,11 +703,11 @@ static int sbd_request_port(struct uart_port *uport)
 		printk(err);
 		return -EBUSY;
 	}
-	map_guard = atomic_add_return(1, &duart->map_guard);
-	if (map_guard == 1) {
+	refcount_inc(&duart->map_guard);
+	if (refcount_read(&duart->map_guard) == 1) {
 		if (!request_mem_region(duart->mapctrl, DUART_CHANREG_SPACING,
 					"sb1250-duart")) {
-			atomic_add(-1, &duart->map_guard);
+			refcount_dec(&duart->map_guard);
 			printk(err);
 			ret = -EBUSY;
 		}
@@ -718,8 +715,7 @@ static int sbd_request_port(struct uart_port *uport)
 	if (!ret) {
 		ret = sbd_map_port(uport);
 		if (ret) {
-			map_guard = atomic_add_return(-1, &duart->map_guard);
-			if (!map_guard)
+			if (refcount_dec_and_test(&duart->map_guard))
 				release_mem_region(duart->mapctrl,
 						   DUART_CHANREG_SPACING);
 		}
diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 1eeb319..485d6b1 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1570,14 +1570,14 @@ static void ffs_data_get(struct ffs_data *ffs)
 {
 	ENTER();
 
-	atomic_inc(&ffs->ref);
+	refcount_inc(&ffs->ref);
 }
 
 static void ffs_data_opened(struct ffs_data *ffs)
 {
 	ENTER();
 
-	atomic_inc(&ffs->ref);
+	refcount_inc(&ffs->ref);
 	if (atomic_add_return(1, &ffs->opened) == 1 &&
 			ffs->state == FFS_DEACTIVATED) {
 		ffs->state = FFS_CLOSING;
@@ -1589,7 +1589,7 @@ static void ffs_data_put(struct ffs_data *ffs)
 {
 	ENTER();
 
-	if (unlikely(atomic_dec_and_test(&ffs->ref))) {
+	if (unlikely(refcount_dec_and_test(&ffs->ref))) {
 		pr_info("%s(): freeing\n", __func__);
 		ffs_data_clear(ffs);
 		BUG_ON(waitqueue_active(&ffs->ev.waitq) ||
@@ -1634,7 +1634,7 @@ static struct ffs_data *ffs_data_new(void)
 
 	ENTER();
 
-	atomic_set(&ffs->ref, 1);
+	refcount_set(&ffs->ref, 1);
 	atomic_set(&ffs->opened, 0);
 	ffs->state = FFS_READ_DESCRIPTORS;
 	mutex_init(&ffs->mutex);
diff --git a/drivers/usb/gadget/function/u_fs.h b/drivers/usb/gadget/function/u_fs.h
index 6013985..7b690a2 100644
--- a/drivers/usb/gadget/function/u_fs.h
+++ b/drivers/usb/gadget/function/u_fs.h
@@ -20,6 +20,7 @@
 #include <linux/list.h>
 #include <linux/mutex.h>
 #include <linux/workqueue.h>
+#include <linux/refcount.h>
 
 #ifdef VERBOSE_DEBUG
 #ifndef pr_vdebug
@@ -177,7 +178,7 @@ struct ffs_data {
 	struct completion		ep0req_completion;	/* P: mutex */
 
 	/* reference counter */
-	atomic_t			ref;
+	refcount_t			ref;
 	/* how many files are opened (EP0 and others) */
 	atomic_t			opened;
 
diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legacy/inode.c
index 10b2576..8b133d8 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -27,6 +27,7 @@
 #include <linux/mmu_context.h>
 #include <linux/aio.h>
 #include <linux/uio.h>
+#include <linux/refcount.h>
 
 #include <linux/device.h>
 #include <linux/moduleparam.h>
@@ -115,7 +116,7 @@ enum ep0_state {
 
 struct dev_data {
 	spinlock_t			lock;
-	atomic_t			count;
+	refcount_t			count;
 	enum ep0_state			state;		/* P: lock */
 	struct usb_gadgetfs_event	event [N_EVENT];
 	unsigned			ev_next;
@@ -151,12 +152,12 @@ struct dev_data {
 
 static inline void get_dev (struct dev_data *data)
 {
-	atomic_inc (&data->count);
+	refcount_inc (&data->count);
 }
 
 static void put_dev (struct dev_data *data)
 {
-	if (likely (!atomic_dec_and_test (&data->count)))
+	if (likely (!refcount_dec_and_test (&data->count)))
 		return;
 	/* needs no more cleanup */
 	BUG_ON (waitqueue_active (&data->wait));
@@ -171,7 +172,7 @@ static struct dev_data *dev_new (void)
 	if (!dev)
 		return NULL;
 	dev->state = STATE_DEV_DISABLED;
-	atomic_set (&dev->count, 1);
+	refcount_set (&dev->count, 1);
 	spin_lock_init (&dev->lock);
 	INIT_LIST_HEAD (&dev->epfiles);
 	init_waitqueue_head (&dev->wait);
@@ -191,7 +192,7 @@ enum ep_state {
 struct ep_data {
 	struct mutex			lock;
 	enum ep_state			state;
-	atomic_t			count;
+	refcount_t			count;
 	struct dev_data			*dev;
 	/* must hold dev->lock before accessing ep or req */
 	struct usb_ep			*ep;
@@ -206,12 +207,12 @@ struct ep_data {
 
 static inline void get_ep (struct ep_data *data)
 {
-	atomic_inc (&data->count);
+	refcount_inc (&data->count);
 }
 
 static void put_ep (struct ep_data *data)
 {
-	if (likely (!atomic_dec_and_test (&data->count)))
+	if (likely (!refcount_dec_and_test (&data->count)))
 		return;
 	put_dev (data->dev);
 	/* needs no more cleanup */
@@ -1562,7 +1563,7 @@ static int activate_ep_files (struct dev_data *dev)
 		init_waitqueue_head (&data->wait);
 
 		strncpy (data->name, ep->name, sizeof (data->name) - 1);
-		atomic_set (&data->count, 1);
+		refcount_set (&data->count, 1);
 		data->dev = dev;
 		get_dev (dev);
 
diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 2ef2b61..b183cb2 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -35,6 +35,7 @@
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
+#include <linux/refcount.h>
 
 #include <xen/xen.h>
 #include <xen/grant_table.h>
@@ -85,7 +86,7 @@ struct grant_map {
 	int index;
 	int count;
 	int flags;
-	atomic_t users;
+	refcount_t users;
 	struct unmap_notify notify;
 	struct ioctl_gntdev_grant_ref *grants;
 	struct gnttab_map_grant_ref   *map_ops;
@@ -165,7 +166,7 @@ static struct grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count)
 
 	add->index = 0;
 	add->count = count;
-	atomic_set(&add->users, 1);
+	refcount_set(&add->users, 1);
 
 	return add;
 
@@ -211,7 +212,7 @@ static void gntdev_put_map(struct gntdev_priv *priv, struct grant_map *map)
 	if (!map)
 		return;
 
-	if (!atomic_dec_and_test(&map->users))
+	if (!refcount_dec_and_test(&map->users))
 		return;
 
 	atomic_sub(map->count, &pages_mapped);
@@ -399,7 +400,7 @@ static void gntdev_vma_open(struct vm_area_struct *vma)
 	struct grant_map *map = vma->vm_private_data;
 
 	pr_debug("gntdev_vma_open %p\n", vma);
-	atomic_inc(&map->users);
+	refcount_inc(&map->users);
 }
 
 static void gntdev_vma_close(struct vm_area_struct *vma)
@@ -1003,7 +1004,7 @@ static int gntdev_mmap(struct file *flip, struct vm_area_struct *vma)
 		goto unlock_out;
 	}
 
-	atomic_inc(&map->users);
+	refcount_inc(&map->users);
 
 	vma->vm_ops = &gntdev_vmops;
 
diff --git a/include/linux/connector.h b/include/linux/connector.h
index f8fe863..032102b 100644
--- a/include/linux/connector.h
+++ b/include/linux/connector.h
@@ -22,7 +22,7 @@
 #define __CONNECTOR_H
 
 
-#include <linux/atomic.h>
+#include <linux/refcount.h>
 
 #include <linux/list.h>
 #include <linux/workqueue.h>
@@ -49,7 +49,7 @@ struct cn_callback_id {
 
 struct cn_callback_entry {
 	struct list_head callback_entry;
-	atomic_t refcnt;
+	refcount_t refcnt;
 	struct cn_queue_dev *pdev;
 
 	struct cn_callback_id id;
diff --git a/include/media/videobuf2-memops.h b/include/media/videobuf2-memops.h
index 36565c7a..a6ed091 100644
--- a/include/media/videobuf2-memops.h
+++ b/include/media/videobuf2-memops.h
@@ -16,6 +16,7 @@
 
 #include <media/videobuf2-v4l2.h>
 #include <linux/mm.h>
+#include <linux/refcount.h>
 
 /**
  * struct vb2_vmarea_handler - common vma refcount tracking handler
@@ -25,7 +26,7 @@
  * @arg:	argument for @put callback
  */
 struct vb2_vmarea_handler {
-	atomic_t		*refcount;
+	refcount_t		*refcount;
 	void			(*put)(void *arg);
 	void			*arg;
 };
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 96dd0b3..53d2747 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -23,6 +23,7 @@
 #include <linux/timer.h>
 #include <linux/if.h>
 #include <linux/percpu.h>
+#include <linux/refcount.h>
 
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_fc.h>
@@ -321,7 +322,7 @@ struct fc_seq_els_data {
  */
 struct fc_fcp_pkt {
 	spinlock_t	  scsi_pkt_lock;
-	atomic_t	  ref_cnt;
+	refcount_t	  ref_cnt;
 
 	/* SCSI command and data transfer information */
 	u32		  data_len;
@@ -434,7 +435,7 @@ struct fc_seq {
  */
 struct fc_exch {
 	spinlock_t	    ex_lock;
-	atomic_t	    ex_refcnt;
+	refcount_t	    ex_refcnt;
 	enum fc_class	    class;
 	struct fc_exch_mgr  *em;
 	struct fc_exch_pool *pool;
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 4d1c46a..854ee17 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -29,6 +29,7 @@
 #include <linux/timer.h>
 #include <linux/workqueue.h>
 #include <linux/kfifo.h>
+#include <linux/refcount.h>
 #include <scsi/iscsi_proto.h>
 #include <scsi/iscsi_if.h>
 #include <scsi/scsi_transport_iscsi.h>
@@ -139,7 +140,7 @@ struct iscsi_task {
 
 	/* state set/tested under session->lock */
 	int			state;
-	atomic_t		refcount;
+	refcount_t		refcount;
 	struct list_head	running;	/* running cmd list */
 	void			*dd_data;	/* driver/transport data */
 };
diff --git a/include/trace/events/bcache.h b/include/trace/events/bcache.h
index df3e9ae..3c664ff 100644
--- a/include/trace/events/bcache.h
+++ b/include/trace/events/bcache.h
@@ -456,7 +456,7 @@ TRACE_EVENT(bcache_alloc_fail,
 		__entry->dev		= ca->bdev->bd_dev;
 		__entry->free		= fifo_used(&ca->free[reserve]);
 		__entry->free_inc	= fifo_used(&ca->free_inc);
-		__entry->blocked	= atomic_read(&ca->set->prio_blocked);
+		__entry->blocked	= refcount_read(&ca->set->prio_blocked);
 	),
 
 	TP_printk("alloc fail %d,%d free %u free_inc %u blocked %u",
-- 
2.7.4
