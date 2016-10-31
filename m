Reply-To: kernel-hardening@lists.openwall.com
From: Elena Reshetova <elena.reshetova@intel.com>
Date: Mon, 31 Oct 2016 13:43:37 +0200
Message-Id: <1477914225-11298-6-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1477914225-11298-1-git-send-email-elena.reshetova@intel.com>
References: <1477914225-11298-1-git-send-email-elena.reshetova@intel.com>
Subject: [kernel-hardening] [RFC v3 PATCH 05/13] fs: identify wrapping atomic usage
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, David Windsor <dwindsor@gmail.com>, Hans Liljestrand <ishkamiel@gmail.com>, Elena Reshetova <elena.reshetova@intel.com>
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
 fs/afs/inode.c                |   4 +-
 fs/btrfs/delayed-inode.c      |   6 +-
 fs/btrfs/delayed-inode.h      |   4 +-
 fs/cachefiles/daemon.c        |   4 +-
 fs/cachefiles/internal.h      |  16 +-
 fs/cachefiles/namei.c         |   6 +-
 fs/cachefiles/proc.c          |  12 +-
 fs/ceph/super.c               |   4 +-
 fs/cifs/cifs_debug.c          |  14 +-
 fs/cifs/cifsfs.c              |   4 +-
 fs/cifs/cifsglob.h            |  55 +++----
 fs/cifs/misc.c                |   4 +-
 fs/cifs/smb1ops.c             |  80 +++++-----
 fs/cifs/smb2ops.c             |  84 +++++-----
 fs/coda/cache.c               |  10 +-
 fs/coredump.c                 |   6 +-
 fs/ext4/ext4.h                |  20 +--
 fs/ext4/mballoc.c             |  44 +++---
 fs/fscache/cookie.c           |  40 ++---
 fs/fscache/internal.h         | 202 ++++++++++++------------
 fs/fscache/object.c           |  26 ++--
 fs/fscache/operation.c        |  38 ++---
 fs/fscache/page.c             | 110 ++++++-------
 fs/fscache/stats.c            | 348 +++++++++++++++++++++---------------------
 fs/inode.c                    |   5 +-
 fs/kernfs/file.c              |  12 +-
 fs/lockd/clntproc.c           |   4 +-
 fs/namespace.c                |   4 +-
 fs/nfs/inode.c                |   6 +-
 fs/notify/notification.c      |   4 +-
 fs/ocfs2/localalloc.c         |   2 +-
 fs/ocfs2/ocfs2.h              |  10 +-
 fs/ocfs2/suballoc.c           |  12 +-
 fs/ocfs2/super.c              |  20 +--
 fs/quota/netlink.c            |   4 +-
 fs/reiserfs/do_balan.c        |   2 +-
 fs/reiserfs/procfs.c          |   2 +-
 fs/reiserfs/reiserfs.h        |   4 +-
 include/linux/fscache-cache.h |   2 +-
 39 files changed, 622 insertions(+), 612 deletions(-)

diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index 86cc726..d600c1b 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -142,7 +142,7 @@ struct inode *afs_iget_autocell(struct inode *dir, const char *dev_name,
 	struct afs_vnode *vnode;
 	struct super_block *sb;
 	struct inode *inode;
-	static atomic_t afs_autocell_ino;
+	static atomic_wrap_t afs_autocell_ino;
 
 	_enter("{%x:%u},%*.*s,",
 	       AFS_FS_I(dir)->fid.vid, AFS_FS_I(dir)->fid.vnode,
@@ -155,7 +155,7 @@ struct inode *afs_iget_autocell(struct inode *dir, const char *dev_name,
 	data.fid.unique = 0;
 	data.fid.vnode = 0;
 
-	inode = iget5_locked(sb, atomic_inc_return(&afs_autocell_ino),
+	inode = iget5_locked(sb, atomic_inc_return_wrap(&afs_autocell_ino),
 			     afs_iget5_autocell_test, afs_iget5_set,
 			     &data);
 	if (!inode) {
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 0fcf5f2..9ad1063 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -453,7 +453,7 @@ static int __btrfs_add_delayed_deletion_item(struct btrfs_delayed_node *node,
 
 static void finish_one_item(struct btrfs_delayed_root *delayed_root)
 {
-	int seq = atomic_inc_return(&delayed_root->items_seq);
+	int seq = atomic_inc_return_wrap(&delayed_root->items_seq);
 
 	/*
 	 * atomic_dec_return implies a barrier for waitqueue_active
@@ -1394,7 +1394,7 @@ void btrfs_assert_delayed_root_empty(struct btrfs_root *root)
 
 static int could_end_wait(struct btrfs_delayed_root *delayed_root, int seq)
 {
-	int val = atomic_read(&delayed_root->items_seq);
+	int val = atomic_read_wrap(&delayed_root->items_seq);
 
 	if (val < seq || val >= seq + BTRFS_DELAYED_BATCH)
 		return 1;
@@ -1419,7 +1419,7 @@ void btrfs_balance_delayed_items(struct btrfs_root *root)
 		int seq;
 		int ret;
 
-		seq = atomic_read(&delayed_root->items_seq);
+		seq = atomic_read_wrap(&delayed_root->items_seq);
 
 		ret = btrfs_wq_run_delayed_node(delayed_root, fs_info, 0);
 		if (ret)
diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
index 2495b3d..983f0ba 100644
--- a/fs/btrfs/delayed-inode.h
+++ b/fs/btrfs/delayed-inode.h
@@ -43,7 +43,7 @@ struct btrfs_delayed_root {
 	 */
 	struct list_head prepare_list;
 	atomic_t items;		/* for delayed items */
-	atomic_t items_seq;	/* for delayed items */
+	atomic_wrap_t items_seq;	/* for delayed items */
 	int nodes;		/* for delayed nodes */
 	wait_queue_head_t wait;
 };
@@ -90,7 +90,7 @@ static inline void btrfs_init_delayed_root(
 				struct btrfs_delayed_root *delayed_root)
 {
 	atomic_set(&delayed_root->items, 0);
-	atomic_set(&delayed_root->items_seq, 0);
+	atomic_set_wrap(&delayed_root->items_seq, 0);
 	delayed_root->nodes = 0;
 	spin_lock_init(&delayed_root->lock);
 	init_waitqueue_head(&delayed_root->wait);
diff --git a/fs/cachefiles/daemon.c b/fs/cachefiles/daemon.c
index 1ee54ff..fbf3322 100644
--- a/fs/cachefiles/daemon.c
+++ b/fs/cachefiles/daemon.c
@@ -176,8 +176,8 @@ static ssize_t cachefiles_daemon_read(struct file *file, char __user *_buffer,
 	cachefiles_has_space(cache, 0, 0);
 
 	/* summarise */
-	f_released = atomic_xchg(&cache->f_released, 0);
-	b_released = atomic_long_xchg(&cache->b_released, 0);
+	f_released = atomic_xchg_wrap(&cache->f_released, 0);
+	b_released = atomic_long_xchg_wrap(&cache->b_released, 0);
 	clear_bit(CACHEFILES_STATE_CHANGED, &cache->flags);
 
 	n = snprintf(buffer, sizeof(buffer),
diff --git a/fs/cachefiles/internal.h b/fs/cachefiles/internal.h
index cd1effe..668cfc5 100644
--- a/fs/cachefiles/internal.h
+++ b/fs/cachefiles/internal.h
@@ -65,9 +65,9 @@ struct cachefiles_cache {
 	wait_queue_head_t		daemon_pollwq;	/* poll waitqueue for daemon */
 	struct rb_root			active_nodes;	/* active nodes (can't be culled) */
 	rwlock_t			active_lock;	/* lock for active_nodes */
-	atomic_t			gravecounter;	/* graveyard uniquifier */
-	atomic_t			f_released;	/* number of objects released lately */
-	atomic_long_t			b_released;	/* number of blocks released lately */
+	atomic_wrap_t			gravecounter;	/* graveyard uniquifier */
+	atomic_wrap_t			f_released;	/* number of objects released lately */
+	atomic_long_wrap_t		b_released;	/* number of blocks released lately */
 	unsigned			frun_percent;	/* when to stop culling (% files) */
 	unsigned			fcull_percent;	/* when to start culling (% files) */
 	unsigned			fstop_percent;	/* when to stop allocating (% files) */
@@ -182,19 +182,19 @@ extern int cachefiles_check_in_use(struct cachefiles_cache *cache,
  * proc.c
  */
 #ifdef CONFIG_CACHEFILES_HISTOGRAM
-extern atomic_t cachefiles_lookup_histogram[HZ];
-extern atomic_t cachefiles_mkdir_histogram[HZ];
-extern atomic_t cachefiles_create_histogram[HZ];
+extern atomic_wrap_t cachefiles_lookup_histogram[HZ];
+extern atomic_wrap_t cachefiles_mkdir_histogram[HZ];
+extern atomic_wrap_t cachefiles_create_histogram[HZ];
 
 extern int __init cachefiles_proc_init(void);
 extern void cachefiles_proc_cleanup(void);
 static inline
-void cachefiles_hist(atomic_t histogram[], unsigned long start_jif)
+void cachefiles_hist(atomic_wrap_t histogram[], unsigned long start_jif)
 {
 	unsigned long jif = jiffies - start_jif;
 	if (jif >= HZ)
 		jif = HZ - 1;
-	atomic_inc(&histogram[jif]);
+	atomic_inc_wrap(&histogram[jif]);
 }
 
 #else
diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index 41df8a2..9e4342f 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -275,8 +275,8 @@ void cachefiles_mark_object_inactive(struct cachefiles_cache *cache,
 	/* This object can now be culled, so we need to let the daemon know
 	 * that there is something it can remove if it needs to.
 	 */
-	atomic_long_add(i_blocks, &cache->b_released);
-	if (atomic_inc_return(&cache->f_released))
+	atomic_long_add_wrap(i_blocks, &cache->b_released);
+	if (atomic_inc_return_wrap(&cache->f_released))
 		cachefiles_state_changed(cache);
 }
 
@@ -335,7 +335,7 @@ static int cachefiles_bury_object(struct cachefiles_cache *cache,
 	/* first step is to make up a grave dentry in the graveyard */
 	sprintf(nbuffer, "%08x%08x",
 		(uint32_t) get_seconds(),
-		(uint32_t) atomic_inc_return(&cache->gravecounter));
+		(uint32_t) atomic_inc_return_wrap(&cache->gravecounter));
 
 	/* do the multiway lock magic */
 	trap = lock_rename(cache->graveyard, dir);
diff --git a/fs/cachefiles/proc.c b/fs/cachefiles/proc.c
index 125b90f..2264edf 100644
--- a/fs/cachefiles/proc.c
+++ b/fs/cachefiles/proc.c
@@ -14,9 +14,9 @@
 #include <linux/seq_file.h>
 #include "internal.h"
 
-atomic_t cachefiles_lookup_histogram[HZ];
-atomic_t cachefiles_mkdir_histogram[HZ];
-atomic_t cachefiles_create_histogram[HZ];
+atomic_wrap_t cachefiles_lookup_histogram[HZ];
+atomic_wrap_t cachefiles_mkdir_histogram[HZ];
+atomic_wrap_t cachefiles_create_histogram[HZ];
 
 /*
  * display the latency histogram
@@ -35,9 +35,9 @@ static int cachefiles_histogram_show(struct seq_file *m, void *v)
 		return 0;
 	default:
 		index = (unsigned long) v - 3;
-		x = atomic_read(&cachefiles_lookup_histogram[index]);
-		y = atomic_read(&cachefiles_mkdir_histogram[index]);
-		z = atomic_read(&cachefiles_create_histogram[index]);
+		x = atomic_read_wrap(&cachefiles_lookup_histogram[index]);
+		y = atomic_read_wrap(&cachefiles_mkdir_histogram[index]);
+		z = atomic_read_wrap(&cachefiles_create_histogram[index]);
 		if (x == 0 && y == 0 && z == 0)
 			return 0;
 
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index b382e59..3c30925 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -926,7 +926,7 @@ static int ceph_compare_super(struct super_block *sb, void *data)
 /*
  * construct our own bdi so we can control readahead, etc.
  */
-static atomic_long_t bdi_seq = ATOMIC_LONG_INIT(0);
+static atomic_long_wrap_t bdi_seq = ATOMIC_LONG_INIT(0);
 
 static int ceph_register_bdi(struct super_block *sb,
 			     struct ceph_fs_client *fsc)
@@ -943,7 +943,7 @@ static int ceph_register_bdi(struct super_block *sb,
 			VM_MAX_READAHEAD * 1024 / PAGE_SIZE;
 
 	err = bdi_register(&fsc->backing_dev_info, NULL, "ceph-%ld",
-			   atomic_long_inc_return(&bdi_seq));
+			   atomic_long_inc_return_wrap(&bdi_seq));
 	if (!err)
 		sb->s_bdi = &fsc->backing_dev_info;
 	return err;
diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 3d03e48..d5df3b6 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -265,8 +265,8 @@ static ssize_t cifs_stats_proc_write(struct file *file,
 	rc = kstrtobool_from_user(buffer, count, &bv);
 	if (rc == 0) {
 #ifdef CONFIG_CIFS_STATS2
-		atomic_set(&totBufAllocCount, 0);
-		atomic_set(&totSmBufAllocCount, 0);
+		atomic_set_wrap(&totBufAllocCount, 0);
+		atomic_set_wrap(&totSmBufAllocCount, 0);
 #endif /* CONFIG_CIFS_STATS2 */
 		spin_lock(&cifs_tcp_ses_lock);
 		list_for_each(tmp1, &cifs_tcp_ses_list) {
@@ -279,7 +279,8 @@ static ssize_t cifs_stats_proc_write(struct file *file,
 					tcon = list_entry(tmp3,
 							  struct cifs_tcon,
 							  tcon_list);
-					atomic_set(&tcon->num_smbs_sent, 0);
+					atomic_set_wrap(&tcon->num_smbs_sent,
+							0);
 					if (server->ops->clear_stats)
 						server->ops->clear_stats(tcon);
 				}
@@ -313,8 +314,8 @@ static int cifs_stats_proc_show(struct seq_file *m, void *v)
 			smBufAllocCount.counter, cifs_min_small);
 #ifdef CONFIG_CIFS_STATS2
 	seq_printf(m, "Total Large %d Small %d Allocations\n",
-				atomic_read(&totBufAllocCount),
-				atomic_read(&totSmBufAllocCount));
+				atomic_read_wrap(&totBufAllocCount),
+				atomic_read_wrap(&totSmBufAllocCount));
 #endif /* CONFIG_CIFS_STATS2 */
 
 	seq_printf(m, "Operations (MIDs): %d\n", atomic_read(&midCount));
@@ -343,7 +344,8 @@ static int cifs_stats_proc_show(struct seq_file *m, void *v)
 				if (tcon->need_reconnect)
 					seq_puts(m, "\tDISCONNECTED ");
 				seq_printf(m, "\nSMBs: %d",
-					   atomic_read(&tcon->num_smbs_sent));
+					   atomic_read_wrap(&tcon->
+						   num_smbs_sent));
 				if (server->ops->print_stats)
 					server->ops->print_stats(m, tcon);
 			}
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 15261ba..010ffec 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1255,8 +1255,8 @@ init_cifs(void)
 	atomic_set(&bufAllocCount, 0);
 	atomic_set(&smBufAllocCount, 0);
 #ifdef CONFIG_CIFS_STATS2
-	atomic_set(&totBufAllocCount, 0);
-	atomic_set(&totSmBufAllocCount, 0);
+	atomic_set_wrap(&totBufAllocCount, 0);
+	atomic_set_wrap(&totSmBufAllocCount, 0);
 #endif /* CONFIG_CIFS_STATS2 */
 
 	atomic_set(&midCount, 0);
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 1f17f6b..47663f2 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -859,35 +859,35 @@ struct cifs_tcon {
 	__u16 Flags;		/* optional support bits */
 	enum statusEnum tidStatus;
 #ifdef CONFIG_CIFS_STATS
-	atomic_t num_smbs_sent;
+	atomic_wrap_t num_smbs_sent;
 	union {
 		struct {
-			atomic_t num_writes;
-			atomic_t num_reads;
-			atomic_t num_flushes;
-			atomic_t num_oplock_brks;
-			atomic_t num_opens;
-			atomic_t num_closes;
-			atomic_t num_deletes;
-			atomic_t num_mkdirs;
-			atomic_t num_posixopens;
-			atomic_t num_posixmkdirs;
-			atomic_t num_rmdirs;
-			atomic_t num_renames;
-			atomic_t num_t2renames;
-			atomic_t num_ffirst;
-			atomic_t num_fnext;
-			atomic_t num_fclose;
-			atomic_t num_hardlinks;
-			atomic_t num_symlinks;
-			atomic_t num_locks;
-			atomic_t num_acl_get;
-			atomic_t num_acl_set;
+			atomic_wrap_t num_writes;
+			atomic_wrap_t num_reads;
+			atomic_wrap_t num_flushes;
+			atomic_wrap_t num_oplock_brks;
+			atomic_wrap_t num_opens;
+			atomic_wrap_t num_closes;
+			atomic_wrap_t num_deletes;
+			atomic_wrap_t num_mkdirs;
+			atomic_wrap_t num_posixopens;
+			atomic_wrap_t num_posixmkdirs;
+			atomic_wrap_t num_rmdirs;
+			atomic_wrap_t num_renames;
+			atomic_wrap_t num_t2renames;
+			atomic_wrap_t num_ffirst;
+			atomic_wrap_t num_fnext;
+			atomic_wrap_t num_fclose;
+			atomic_wrap_t num_hardlinks;
+			atomic_wrap_t num_symlinks;
+			atomic_wrap_t num_locks;
+			atomic_wrap_t num_acl_get;
+			atomic_wrap_t num_acl_set;
 		} cifs_stats;
 #ifdef CONFIG_CIFS_SMB2
 		struct {
-			atomic_t smb2_com_sent[NUMBER_OF_SMB2_COMMANDS];
-			atomic_t smb2_com_failed[NUMBER_OF_SMB2_COMMANDS];
+			atomic_wrap_t smb2_com_sent[NUMBER_OF_SMB2_COMMANDS];
+			atomic_wrap_t smb2_com_failed[NUMBER_OF_SMB2_COMMANDS];
 		} smb2_stats;
 #endif /* CONFIG_CIFS_SMB2 */
 	} stats;
@@ -1241,7 +1241,7 @@ convert_delimiter(char *path, char delim)
 }
 
 #ifdef CONFIG_CIFS_STATS
-#define cifs_stats_inc atomic_inc
+#define cifs_stats_inc atomic_inc_wrap
 
 static inline void cifs_stats_bytes_written(struct cifs_tcon *tcon,
 					    unsigned int bytes)
@@ -1604,8 +1604,9 @@ GLOBAL_EXTERN atomic_t tconInfoReconnectCount;
 /* Various Debug counters */
 GLOBAL_EXTERN atomic_t bufAllocCount;    /* current number allocated  */
 #ifdef CONFIG_CIFS_STATS2
-GLOBAL_EXTERN atomic_t totBufAllocCount; /* total allocated over all time */
-GLOBAL_EXTERN atomic_t totSmBufAllocCount;
+GLOBAL_EXTERN atomic_wrap_t totBufAllocCount;
+					/* total allocated over all time */
+GLOBAL_EXTERN atomic_wrap_t totSmBufAllocCount;
 #endif
 GLOBAL_EXTERN atomic_t smBufAllocCount;
 GLOBAL_EXTERN atomic_t midCount;
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index c672915..e244789 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -171,7 +171,7 @@ cifs_buf_get(void)
 		memset(ret_buf, 0, buf_size + 3);
 		atomic_inc(&bufAllocCount);
 #ifdef CONFIG_CIFS_STATS2
-		atomic_inc(&totBufAllocCount);
+		atomic_inc_wrap(&totBufAllocCount);
 #endif /* CONFIG_CIFS_STATS2 */
 	}
 
@@ -206,7 +206,7 @@ cifs_small_buf_get(void)
 	/*	memset(ret_buf, 0, sizeof(struct smb_hdr) + 27);*/
 		atomic_inc(&smBufAllocCount);
 #ifdef CONFIG_CIFS_STATS2
-		atomic_inc(&totSmBufAllocCount);
+		atomic_inc_wrap(&totSmBufAllocCount);
 #endif /* CONFIG_CIFS_STATS2 */
 
 	}
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index fc537c2..1a37358 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -622,27 +622,27 @@ static void
 cifs_clear_stats(struct cifs_tcon *tcon)
 {
 #ifdef CONFIG_CIFS_STATS
-	atomic_set(&tcon->stats.cifs_stats.num_writes, 0);
-	atomic_set(&tcon->stats.cifs_stats.num_reads, 0);
-	atomic_set(&tcon->stats.cifs_stats.num_flushes, 0);
-	atomic_set(&tcon->stats.cifs_stats.num_oplock_brks, 0);
-	atomic_set(&tcon->stats.cifs_stats.num_opens, 0);
-	atomic_set(&tcon->stats.cifs_stats.num_posixopens, 0);
-	atomic_set(&tcon->stats.cifs_stats.num_posixmkdirs, 0);
-	atomic_set(&tcon->stats.cifs_stats.num_closes, 0);
-	atomic_set(&tcon->stats.cifs_stats.num_deletes, 0);
-	atomic_set(&tcon->stats.cifs_stats.num_mkdirs, 0);
-	atomic_set(&tcon->stats.cifs_stats.num_rmdirs, 0);
-	atomic_set(&tcon->stats.cifs_stats.num_renames, 0);
-	atomic_set(&tcon->stats.cifs_stats.num_t2renames, 0);
-	atomic_set(&tcon->stats.cifs_stats.num_ffirst, 0);
-	atomic_set(&tcon->stats.cifs_stats.num_fnext, 0);
-	atomic_set(&tcon->stats.cifs_stats.num_fclose, 0);
-	atomic_set(&tcon->stats.cifs_stats.num_hardlinks, 0);
-	atomic_set(&tcon->stats.cifs_stats.num_symlinks, 0);
-	atomic_set(&tcon->stats.cifs_stats.num_locks, 0);
-	atomic_set(&tcon->stats.cifs_stats.num_acl_get, 0);
-	atomic_set(&tcon->stats.cifs_stats.num_acl_set, 0);
+	atomic_set_wrap(&tcon->stats.cifs_stats.num_writes, 0);
+	atomic_set_wrap(&tcon->stats.cifs_stats.num_reads, 0);
+	atomic_set_wrap(&tcon->stats.cifs_stats.num_flushes, 0);
+	atomic_set_wrap(&tcon->stats.cifs_stats.num_oplock_brks, 0);
+	atomic_set_wrap(&tcon->stats.cifs_stats.num_opens, 0);
+	atomic_set_wrap(&tcon->stats.cifs_stats.num_posixopens, 0);
+	atomic_set_wrap(&tcon->stats.cifs_stats.num_posixmkdirs, 0);
+	atomic_set_wrap(&tcon->stats.cifs_stats.num_closes, 0);
+	atomic_set_wrap(&tcon->stats.cifs_stats.num_deletes, 0);
+	atomic_set_wrap(&tcon->stats.cifs_stats.num_mkdirs, 0);
+	atomic_set_wrap(&tcon->stats.cifs_stats.num_rmdirs, 0);
+	atomic_set_wrap(&tcon->stats.cifs_stats.num_renames, 0);
+	atomic_set_wrap(&tcon->stats.cifs_stats.num_t2renames, 0);
+	atomic_set_wrap(&tcon->stats.cifs_stats.num_ffirst, 0);
+	atomic_set_wrap(&tcon->stats.cifs_stats.num_fnext, 0);
+	atomic_set_wrap(&tcon->stats.cifs_stats.num_fclose, 0);
+	atomic_set_wrap(&tcon->stats.cifs_stats.num_hardlinks, 0);
+	atomic_set_wrap(&tcon->stats.cifs_stats.num_symlinks, 0);
+	atomic_set_wrap(&tcon->stats.cifs_stats.num_locks, 0);
+	atomic_set_wrap(&tcon->stats.cifs_stats.num_acl_get, 0);
+	atomic_set_wrap(&tcon->stats.cifs_stats.num_acl_set, 0);
 #endif
 }
 
@@ -651,36 +651,36 @@ cifs_print_stats(struct seq_file *m, struct cifs_tcon *tcon)
 {
 #ifdef CONFIG_CIFS_STATS
 	seq_printf(m, " Oplocks breaks: %d",
-		   atomic_read(&tcon->stats.cifs_stats.num_oplock_brks));
+		   atomic_read_wrap(&tcon->stats.cifs_stats.num_oplock_brks));
 	seq_printf(m, "\nReads:  %d Bytes: %llu",
-		   atomic_read(&tcon->stats.cifs_stats.num_reads),
+		   atomic_read_wrap(&tcon->stats.cifs_stats.num_reads),
 		   (long long)(tcon->bytes_read));
 	seq_printf(m, "\nWrites: %d Bytes: %llu",
-		   atomic_read(&tcon->stats.cifs_stats.num_writes),
+		   atomic_read_wrap(&tcon->stats.cifs_stats.num_writes),
 		   (long long)(tcon->bytes_written));
 	seq_printf(m, "\nFlushes: %d",
-		   atomic_read(&tcon->stats.cifs_stats.num_flushes));
+		   atomic_read_wrap(&tcon->stats.cifs_stats.num_flushes));
 	seq_printf(m, "\nLocks: %d HardLinks: %d Symlinks: %d",
-		   atomic_read(&tcon->stats.cifs_stats.num_locks),
-		   atomic_read(&tcon->stats.cifs_stats.num_hardlinks),
-		   atomic_read(&tcon->stats.cifs_stats.num_symlinks));
+		   atomic_read_wrap(&tcon->stats.cifs_stats.num_locks),
+		   atomic_read_wrap(&tcon->stats.cifs_stats.num_hardlinks),
+		   atomic_read_wrap(&tcon->stats.cifs_stats.num_symlinks));
 	seq_printf(m, "\nOpens: %d Closes: %d Deletes: %d",
-		   atomic_read(&tcon->stats.cifs_stats.num_opens),
-		   atomic_read(&tcon->stats.cifs_stats.num_closes),
-		   atomic_read(&tcon->stats.cifs_stats.num_deletes));
+		   atomic_read_wrap(&tcon->stats.cifs_stats.num_opens),
+		   atomic_read_wrap(&tcon->stats.cifs_stats.num_closes),
+		   atomic_read_wrap(&tcon->stats.cifs_stats.num_deletes));
 	seq_printf(m, "\nPosix Opens: %d Posix Mkdirs: %d",
-		   atomic_read(&tcon->stats.cifs_stats.num_posixopens),
-		   atomic_read(&tcon->stats.cifs_stats.num_posixmkdirs));
+		   atomic_read_wrap(&tcon->stats.cifs_stats.num_posixopens),
+		   atomic_read_wrap(&tcon->stats.cifs_stats.num_posixmkdirs));
 	seq_printf(m, "\nMkdirs: %d Rmdirs: %d",
-		   atomic_read(&tcon->stats.cifs_stats.num_mkdirs),
-		   atomic_read(&tcon->stats.cifs_stats.num_rmdirs));
+		   atomic_read_wrap(&tcon->stats.cifs_stats.num_mkdirs),
+		   atomic_read_wrap(&tcon->stats.cifs_stats.num_rmdirs));
 	seq_printf(m, "\nRenames: %d T2 Renames %d",
-		   atomic_read(&tcon->stats.cifs_stats.num_renames),
-		   atomic_read(&tcon->stats.cifs_stats.num_t2renames));
+		   atomic_read_wrap(&tcon->stats.cifs_stats.num_renames),
+		   atomic_read_wrap(&tcon->stats.cifs_stats.num_t2renames));
 	seq_printf(m, "\nFindFirst: %d FNext %d FClose %d",
-		   atomic_read(&tcon->stats.cifs_stats.num_ffirst),
-		   atomic_read(&tcon->stats.cifs_stats.num_fnext),
-		   atomic_read(&tcon->stats.cifs_stats.num_fclose));
+		   atomic_read_wrap(&tcon->stats.cifs_stats.num_ffirst),
+		   atomic_read_wrap(&tcon->stats.cifs_stats.num_fnext),
+		   atomic_read_wrap(&tcon->stats.cifs_stats.num_fclose));
 #endif
 }
 
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 5d456eb..159be2f 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -432,8 +432,8 @@ smb2_clear_stats(struct cifs_tcon *tcon)
 #ifdef CONFIG_CIFS_STATS
 	int i;
 	for (i = 0; i < NUMBER_OF_SMB2_COMMANDS; i++) {
-		atomic_set(&tcon->stats.smb2_stats.smb2_com_sent[i], 0);
-		atomic_set(&tcon->stats.smb2_stats.smb2_com_failed[i], 0);
+		atomic_set_wrap(&tcon->stats.smb2_stats.smb2_com_sent[i], 0);
+		atomic_set_wrap(&tcon->stats.smb2_stats.smb2_com_failed[i], 0);
 	}
 #endif
 }
@@ -473,65 +473,65 @@ static void
 smb2_print_stats(struct seq_file *m, struct cifs_tcon *tcon)
 {
 #ifdef CONFIG_CIFS_STATS
-	atomic_t *sent = tcon->stats.smb2_stats.smb2_com_sent;
-	atomic_t *failed = tcon->stats.smb2_stats.smb2_com_failed;
+	atomic_wrap_t *sent = tcon->stats.smb2_stats.smb2_com_sent;
+	atomic_wrap_t *failed = tcon->stats.smb2_stats.smb2_com_failed;
 	seq_printf(m, "\nNegotiates: %d sent %d failed",
-		   atomic_read(&sent[SMB2_NEGOTIATE_HE]),
-		   atomic_read(&failed[SMB2_NEGOTIATE_HE]));
+		   atomic_read_wrap(&sent[SMB2_NEGOTIATE_HE]),
+		   atomic_read_wrap(&failed[SMB2_NEGOTIATE_HE]));
 	seq_printf(m, "\nSessionSetups: %d sent %d failed",
-		   atomic_read(&sent[SMB2_SESSION_SETUP_HE]),
-		   atomic_read(&failed[SMB2_SESSION_SETUP_HE]));
+		   atomic_read_wrap(&sent[SMB2_SESSION_SETUP_HE]),
+		   atomic_read_wrap(&failed[SMB2_SESSION_SETUP_HE]));
 	seq_printf(m, "\nLogoffs: %d sent %d failed",
-		   atomic_read(&sent[SMB2_LOGOFF_HE]),
-		   atomic_read(&failed[SMB2_LOGOFF_HE]));
+		   atomic_read_wrap(&sent[SMB2_LOGOFF_HE]),
+		   atomic_read_wrap(&failed[SMB2_LOGOFF_HE]));
 	seq_printf(m, "\nTreeConnects: %d sent %d failed",
-		   atomic_read(&sent[SMB2_TREE_CONNECT_HE]),
-		   atomic_read(&failed[SMB2_TREE_CONNECT_HE]));
+		   atomic_read_wrap(&sent[SMB2_TREE_CONNECT_HE]),
+		   atomic_read_wrap(&failed[SMB2_TREE_CONNECT_HE]));
 	seq_printf(m, "\nTreeDisconnects: %d sent %d failed",
-		   atomic_read(&sent[SMB2_TREE_DISCONNECT_HE]),
-		   atomic_read(&failed[SMB2_TREE_DISCONNECT_HE]));
+		   atomic_read_wrap(&sent[SMB2_TREE_DISCONNECT_HE]),
+		   atomic_read_wrap(&failed[SMB2_TREE_DISCONNECT_HE]));
 	seq_printf(m, "\nCreates: %d sent %d failed",
-		   atomic_read(&sent[SMB2_CREATE_HE]),
-		   atomic_read(&failed[SMB2_CREATE_HE]));
+		   atomic_read_wrap(&sent[SMB2_CREATE_HE]),
+		   atomic_read_wrap(&failed[SMB2_CREATE_HE]));
 	seq_printf(m, "\nCloses: %d sent %d failed",
-		   atomic_read(&sent[SMB2_CLOSE_HE]),
-		   atomic_read(&failed[SMB2_CLOSE_HE]));
+		   atomic_read_wrap(&sent[SMB2_CLOSE_HE]),
+		   atomic_read_wrap(&failed[SMB2_CLOSE_HE]));
 	seq_printf(m, "\nFlushes: %d sent %d failed",
-		   atomic_read(&sent[SMB2_FLUSH_HE]),
-		   atomic_read(&failed[SMB2_FLUSH_HE]));
+		   atomic_read_wrap(&sent[SMB2_FLUSH_HE]),
+		   atomic_read_wrap(&failed[SMB2_FLUSH_HE]));
 	seq_printf(m, "\nReads: %d sent %d failed",
-		   atomic_read(&sent[SMB2_READ_HE]),
-		   atomic_read(&failed[SMB2_READ_HE]));
+		   atomic_read_wrap(&sent[SMB2_READ_HE]),
+		   atomic_read_wrap(&failed[SMB2_READ_HE]));
 	seq_printf(m, "\nWrites: %d sent %d failed",
-		   atomic_read(&sent[SMB2_WRITE_HE]),
-		   atomic_read(&failed[SMB2_WRITE_HE]));
+		   atomic_read_wrap(&sent[SMB2_WRITE_HE]),
+		   atomic_read_wrap(&failed[SMB2_WRITE_HE]));
 	seq_printf(m, "\nLocks: %d sent %d failed",
-		   atomic_read(&sent[SMB2_LOCK_HE]),
-		   atomic_read(&failed[SMB2_LOCK_HE]));
+		   atomic_read_wrap(&sent[SMB2_LOCK_HE]),
+		   atomic_read_wrap(&failed[SMB2_LOCK_HE]));
 	seq_printf(m, "\nIOCTLs: %d sent %d failed",
-		   atomic_read(&sent[SMB2_IOCTL_HE]),
-		   atomic_read(&failed[SMB2_IOCTL_HE]));
+		   atomic_read_wrap(&sent[SMB2_IOCTL_HE]),
+		   atomic_read_wrap(&failed[SMB2_IOCTL_HE]));
 	seq_printf(m, "\nCancels: %d sent %d failed",
-		   atomic_read(&sent[SMB2_CANCEL_HE]),
-		   atomic_read(&failed[SMB2_CANCEL_HE]));
+		   atomic_read_wrap(&sent[SMB2_CANCEL_HE]),
+		   atomic_read_wrap(&failed[SMB2_CANCEL_HE]));
 	seq_printf(m, "\nEchos: %d sent %d failed",
-		   atomic_read(&sent[SMB2_ECHO_HE]),
-		   atomic_read(&failed[SMB2_ECHO_HE]));
+		   atomic_read_wrap(&sent[SMB2_ECHO_HE]),
+		   atomic_read_wrap(&failed[SMB2_ECHO_HE]));
 	seq_printf(m, "\nQueryDirectories: %d sent %d failed",
-		   atomic_read(&sent[SMB2_QUERY_DIRECTORY_HE]),
-		   atomic_read(&failed[SMB2_QUERY_DIRECTORY_HE]));
+		   atomic_read_wrap(&sent[SMB2_QUERY_DIRECTORY_HE]),
+		   atomic_read_wrap(&failed[SMB2_QUERY_DIRECTORY_HE]));
 	seq_printf(m, "\nChangeNotifies: %d sent %d failed",
-		   atomic_read(&sent[SMB2_CHANGE_NOTIFY_HE]),
-		   atomic_read(&failed[SMB2_CHANGE_NOTIFY_HE]));
+		   atomic_read_wrap(&sent[SMB2_CHANGE_NOTIFY_HE]),
+		   atomic_read_wrap(&failed[SMB2_CHANGE_NOTIFY_HE]));
 	seq_printf(m, "\nQueryInfos: %d sent %d failed",
-		   atomic_read(&sent[SMB2_QUERY_INFO_HE]),
-		   atomic_read(&failed[SMB2_QUERY_INFO_HE]));
+		   atomic_read_wrap(&sent[SMB2_QUERY_INFO_HE]),
+		   atomic_read_wrap(&failed[SMB2_QUERY_INFO_HE]));
 	seq_printf(m, "\nSetInfos: %d sent %d failed",
-		   atomic_read(&sent[SMB2_SET_INFO_HE]),
-		   atomic_read(&failed[SMB2_SET_INFO_HE]));
+		   atomic_read_wrap(&sent[SMB2_SET_INFO_HE]),
+		   atomic_read_wrap(&failed[SMB2_SET_INFO_HE]));
 	seq_printf(m, "\nOplockBreaks: %d sent %d failed",
-		   atomic_read(&sent[SMB2_OPLOCK_BREAK_HE]),
-		   atomic_read(&failed[SMB2_OPLOCK_BREAK_HE]));
+		   atomic_read_wrap(&sent[SMB2_OPLOCK_BREAK_HE]),
+		   atomic_read_wrap(&failed[SMB2_OPLOCK_BREAK_HE]));
 #endif
 }
 
diff --git a/fs/coda/cache.c b/fs/coda/cache.c
index 5bb630a..43303b5 100644
--- a/fs/coda/cache.c
+++ b/fs/coda/cache.c
@@ -24,7 +24,7 @@
 #include "coda_linux.h"
 #include "coda_cache.h"
 
-static atomic_t permission_epoch = ATOMIC_INIT(0);
+static atomic_wrap_t permission_epoch = ATOMIC_INIT(0);
 
 /* replace or extend an acl cache hit */
 void coda_cache_enter(struct inode *inode, int mask)
@@ -32,7 +32,7 @@ void coda_cache_enter(struct inode *inode, int mask)
 	struct coda_inode_info *cii = ITOC(inode);
 
 	spin_lock(&cii->c_lock);
-	cii->c_cached_epoch = atomic_read(&permission_epoch);
+	cii->c_cached_epoch = atomic_read_wrap(&permission_epoch);
 	if (!uid_eq(cii->c_uid, current_fsuid())) {
 		cii->c_uid = current_fsuid();
                 cii->c_cached_perm = mask;
@@ -46,14 +46,14 @@ void coda_cache_clear_inode(struct inode *inode)
 {
 	struct coda_inode_info *cii = ITOC(inode);
 	spin_lock(&cii->c_lock);
-	cii->c_cached_epoch = atomic_read(&permission_epoch) - 1;
+	cii->c_cached_epoch = atomic_read_wrap(&permission_epoch) - 1;
 	spin_unlock(&cii->c_lock);
 }
 
 /* remove all acl caches */
 void coda_cache_clear_all(struct super_block *sb)
 {
-	atomic_inc(&permission_epoch);
+	atomic_inc_wrap(&permission_epoch);
 }
 
 
@@ -66,7 +66,7 @@ int coda_cache_check(struct inode *inode, int mask)
 	spin_lock(&cii->c_lock);
 	hit = (mask & cii->c_cached_perm) == mask &&
 	    uid_eq(cii->c_uid, current_fsuid()) &&
-	    cii->c_cached_epoch == atomic_read(&permission_epoch);
+	    cii->c_cached_epoch == atomic_read_wrap(&permission_epoch);
 	spin_unlock(&cii->c_lock);
 
 	return hit;
diff --git a/fs/coredump.c b/fs/coredump.c
index 281b768..8d323b4 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -544,7 +544,7 @@ void do_coredump(const siginfo_t *siginfo)
 	/* require nonrelative corefile path and be extra careful */
 	bool need_suid_safe = false;
 	bool core_dumped = false;
-	static atomic_t core_dump_count = ATOMIC_INIT(0);
+	static atomic_wrap_t core_dump_count = ATOMIC_INIT(0);
 	struct coredump_params cprm = {
 		.siginfo = siginfo,
 		.regs = signal_pt_regs(),
@@ -623,7 +623,7 @@ void do_coredump(const siginfo_t *siginfo)
 		}
 		cprm.limit = RLIM_INFINITY;
 
-		dump_count = atomic_inc_return(&core_dump_count);
+		dump_count = atomic_inc_return_wrap(&core_dump_count);
 		if (core_pipe_limit && (core_pipe_limit < dump_count)) {
 			printk(KERN_WARNING "Pid %d(%s) over core_pipe_limit\n",
 			       task_tgid_vnr(current), current->comm);
@@ -763,7 +763,7 @@ void do_coredump(const siginfo_t *siginfo)
 		filp_close(cprm.file, NULL);
 fail_dropcount:
 	if (ispipe)
-		atomic_dec(&core_dump_count);
+		atomic_dec_wrap(&core_dump_count);
 fail_unlock:
 	kfree(cn.corename);
 	coredump_finish(mm, core_dumped);
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 282a51b..debbff4 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1448,19 +1448,19 @@ struct ext4_sb_info {
 	unsigned long s_mb_last_start;
 
 	/* stats for buddy allocator */
-	atomic_t s_bal_reqs;	/* number of reqs with len > 1 */
-	atomic_t s_bal_success;	/* we found long enough chunks */
-	atomic_t s_bal_allocated;	/* in blocks */
-	atomic_t s_bal_ex_scanned;	/* total extents scanned */
-	atomic_t s_bal_goals;	/* goal hits */
-	atomic_t s_bal_breaks;	/* too long searches */
-	atomic_t s_bal_2orders;	/* 2^order hits */
+	atomic_wrap_t s_bal_reqs;	/* number of reqs with len > 1 */
+	atomic_wrap_t s_bal_success;	/* we found long enough chunks */
+	atomic_wrap_t s_bal_allocated;	/* in blocks */
+	atomic_wrap_t s_bal_ex_scanned;	/* total extents scanned */
+	atomic_wrap_t s_bal_goals;	/* goal hits */
+	atomic_wrap_t s_bal_breaks;	/* too long searches */
+	atomic_wrap_t s_bal_2orders;	/* 2^order hits */
 	spinlock_t s_bal_lock;
 	unsigned long s_mb_buddies_generated;
 	unsigned long long s_mb_generation_time;
-	atomic_t s_mb_lost_chunks;
-	atomic_t s_mb_preallocated;
-	atomic_t s_mb_discarded;
+	atomic_wrap_t s_mb_lost_chunks;
+	atomic_wrap_t s_mb_preallocated;
+	atomic_wrap_t s_mb_discarded;
 	atomic_t s_lock_busy;
 
 	/* locality groups */
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index f418f55..2dc1d6d 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1921,7 +1921,7 @@ void ext4_mb_simple_scan_group(struct ext4_allocation_context *ac,
 		BUG_ON(ac->ac_b_ex.fe_len != ac->ac_g_ex.fe_len);
 
 		if (EXT4_SB(sb)->s_mb_stats)
-			atomic_inc(&EXT4_SB(sb)->s_bal_2orders);
+			atomic_inc_wrap(&EXT4_SB(sb)->s_bal_2orders);
 
 		break;
 	}
@@ -2244,7 +2244,7 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 			ac->ac_status = AC_STATUS_CONTINUE;
 			ac->ac_flags |= EXT4_MB_HINT_FIRST;
 			cr = 3;
-			atomic_inc(&sbi->s_mb_lost_chunks);
+			atomic_inc_wrap(&sbi->s_mb_lost_chunks);
 			goto repeat;
 		}
 	}
@@ -2743,25 +2743,25 @@ int ext4_mb_release(struct super_block *sb)
 	if (sbi->s_mb_stats) {
 		ext4_msg(sb, KERN_INFO,
 		       "mballoc: %u blocks %u reqs (%u success)",
-				atomic_read(&sbi->s_bal_allocated),
-				atomic_read(&sbi->s_bal_reqs),
-				atomic_read(&sbi->s_bal_success));
+				atomic_read_wrap(&sbi->s_bal_allocated),
+				atomic_read_wrap(&sbi->s_bal_reqs),
+				atomic_read_wrap(&sbi->s_bal_success));
 		ext4_msg(sb, KERN_INFO,
 		      "mballoc: %u extents scanned, %u goal hits, "
 				"%u 2^N hits, %u breaks, %u lost",
-				atomic_read(&sbi->s_bal_ex_scanned),
-				atomic_read(&sbi->s_bal_goals),
-				atomic_read(&sbi->s_bal_2orders),
-				atomic_read(&sbi->s_bal_breaks),
-				atomic_read(&sbi->s_mb_lost_chunks));
+				atomic_read_wrap(&sbi->s_bal_ex_scanned),
+				atomic_read_wrap(&sbi->s_bal_goals),
+				atomic_read_wrap(&sbi->s_bal_2orders),
+				atomic_read_wrap(&sbi->s_bal_breaks),
+				atomic_read_wrap(&sbi->s_mb_lost_chunks));
 		ext4_msg(sb, KERN_INFO,
 		       "mballoc: %lu generated and it took %Lu",
 				sbi->s_mb_buddies_generated,
 				sbi->s_mb_generation_time);
 		ext4_msg(sb, KERN_INFO,
 		       "mballoc: %u preallocated, %u discarded",
-				atomic_read(&sbi->s_mb_preallocated),
-				atomic_read(&sbi->s_mb_discarded));
+				atomic_read_wrap(&sbi->s_mb_preallocated),
+				atomic_read_wrap(&sbi->s_mb_discarded));
 	}
 
 	free_percpu(sbi->s_locality_groups);
@@ -3222,16 +3222,16 @@ static void ext4_mb_collect_stats(struct ext4_allocation_context *ac)
 	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
 
 	if (sbi->s_mb_stats && ac->ac_g_ex.fe_len > 1) {
-		atomic_inc(&sbi->s_bal_reqs);
-		atomic_add(ac->ac_b_ex.fe_len, &sbi->s_bal_allocated);
+		atomic_inc_wrap(&sbi->s_bal_reqs);
+		atomic_add_wrap(ac->ac_b_ex.fe_len, &sbi->s_bal_allocated);
 		if (ac->ac_b_ex.fe_len >= ac->ac_o_ex.fe_len)
-			atomic_inc(&sbi->s_bal_success);
-		atomic_add(ac->ac_found, &sbi->s_bal_ex_scanned);
+			atomic_inc_wrap(&sbi->s_bal_success);
+		atomic_add_wrap(ac->ac_found, &sbi->s_bal_ex_scanned);
 		if (ac->ac_g_ex.fe_start == ac->ac_b_ex.fe_start &&
 				ac->ac_g_ex.fe_group == ac->ac_b_ex.fe_group)
-			atomic_inc(&sbi->s_bal_goals);
+			atomic_inc_wrap(&sbi->s_bal_goals);
 		if (ac->ac_found > sbi->s_mb_max_to_scan)
-			atomic_inc(&sbi->s_bal_breaks);
+			atomic_inc_wrap(&sbi->s_bal_breaks);
 	}
 
 	if (ac->ac_op == EXT4_MB_HISTORY_ALLOC)
@@ -3658,7 +3658,7 @@ ext4_mb_new_inode_pa(struct ext4_allocation_context *ac)
 	trace_ext4_mb_new_inode_pa(ac, pa);
 
 	ext4_mb_use_inode_pa(ac, pa);
-	atomic_add(pa->pa_free, &sbi->s_mb_preallocated);
+	atomic_add_wrap(pa->pa_free, &sbi->s_mb_preallocated);
 
 	ei = EXT4_I(ac->ac_inode);
 	grp = ext4_get_group_info(sb, ac->ac_b_ex.fe_group);
@@ -3718,7 +3718,7 @@ ext4_mb_new_group_pa(struct ext4_allocation_context *ac)
 	trace_ext4_mb_new_group_pa(ac, pa);
 
 	ext4_mb_use_group_pa(ac, pa);
-	atomic_add(pa->pa_free, &EXT4_SB(sb)->s_mb_preallocated);
+	atomic_add_wrap(pa->pa_free, &EXT4_SB(sb)->s_mb_preallocated);
 
 	grp = ext4_get_group_info(sb, ac->ac_b_ex.fe_group);
 	lg = ac->ac_lg;
@@ -3807,7 +3807,7 @@ ext4_mb_release_inode_pa(struct ext4_buddy *e4b, struct buffer_head *bitmap_bh,
 		 * from the bitmap and continue.
 		 */
 	}
-	atomic_add(free, &sbi->s_mb_discarded);
+	atomic_add_wrap(free, &sbi->s_mb_discarded);
 
 	return err;
 }
@@ -3825,7 +3825,7 @@ ext4_mb_release_group_pa(struct ext4_buddy *e4b,
 	ext4_get_group_no_and_offset(sb, pa->pa_pstart, &group, &bit);
 	BUG_ON(group != e4b->bd_group && pa->pa_len != 0);
 	mb_free_blocks(pa->pa_inode, e4b, bit, pa->pa_len);
-	atomic_add(pa->pa_len, &EXT4_SB(sb)->s_mb_discarded);
+	atomic_add_wrap(pa->pa_len, &EXT4_SB(sb)->s_mb_discarded);
 	trace_ext4_mballoc_discard(sb, NULL, group, bit, pa->pa_len);
 
 	return 0;
diff --git a/fs/fscache/cookie.c b/fs/fscache/cookie.c
index 43040721..e3d750c 100644
--- a/fs/fscache/cookie.c
+++ b/fs/fscache/cookie.c
@@ -19,7 +19,7 @@
 
 struct kmem_cache *fscache_cookie_jar;
 
-static atomic_t fscache_object_debug_id = ATOMIC_INIT(0);
+static atomic_wrap_t fscache_object_debug_id = ATOMIC_INIT(0);
 
 static int fscache_acquire_non_index_cookie(struct fscache_cookie *cookie);
 static int fscache_alloc_object(struct fscache_cache *cache,
@@ -69,11 +69,11 @@ struct fscache_cookie *__fscache_acquire_cookie(
 	       parent ? (char *) parent->def->name : "<no-parent>",
 	       def->name, netfs_data, enable);
 
-	fscache_stat(&fscache_n_acquires);
+	fscache_stat_wrap(&fscache_n_acquires);
 
 	/* if there's no parent cookie, then we don't create one here either */
 	if (!parent) {
-		fscache_stat(&fscache_n_acquires_null);
+		fscache_stat_wrap(&fscache_n_acquires_null);
 		_leave(" [no parent]");
 		return NULL;
 	}
@@ -88,7 +88,7 @@ struct fscache_cookie *__fscache_acquire_cookie(
 	/* allocate and initialise a cookie */
 	cookie = kmem_cache_alloc(fscache_cookie_jar, GFP_KERNEL);
 	if (!cookie) {
-		fscache_stat(&fscache_n_acquires_oom);
+		fscache_stat_wrap(&fscache_n_acquires_oom);
 		_leave(" [ENOMEM]");
 		return NULL;
 	}
@@ -115,13 +115,13 @@ struct fscache_cookie *__fscache_acquire_cookie(
 
 	switch (cookie->def->type) {
 	case FSCACHE_COOKIE_TYPE_INDEX:
-		fscache_stat(&fscache_n_cookie_index);
+		fscache_stat_wrap(&fscache_n_cookie_index);
 		break;
 	case FSCACHE_COOKIE_TYPE_DATAFILE:
-		fscache_stat(&fscache_n_cookie_data);
+		fscache_stat_wrap(&fscache_n_cookie_data);
 		break;
 	default:
-		fscache_stat(&fscache_n_cookie_special);
+		fscache_stat_wrap(&fscache_n_cookie_special);
 		break;
 	}
 
@@ -135,7 +135,7 @@ struct fscache_cookie *__fscache_acquire_cookie(
 			} else {
 				atomic_dec(&parent->n_children);
 				__fscache_cookie_put(cookie);
-				fscache_stat(&fscache_n_acquires_nobufs);
+				fscache_stat_wrap(&fscache_n_acquires_nobufs);
 				_leave(" = NULL");
 				return NULL;
 			}
@@ -144,7 +144,7 @@ struct fscache_cookie *__fscache_acquire_cookie(
 		}
 	}
 
-	fscache_stat(&fscache_n_acquires_ok);
+	fscache_stat_wrap(&fscache_n_acquires_ok);
 	_leave(" = %p", cookie);
 	return cookie;
 }
@@ -213,7 +213,7 @@ static int fscache_acquire_non_index_cookie(struct fscache_cookie *cookie)
 	cache = fscache_select_cache_for_object(cookie->parent);
 	if (!cache) {
 		up_read(&fscache_addremove_sem);
-		fscache_stat(&fscache_n_acquires_no_cache);
+		fscache_stat_wrap(&fscache_n_acquires_no_cache);
 		_leave(" = -ENOMEDIUM [no cache]");
 		return -ENOMEDIUM;
 	}
@@ -297,14 +297,14 @@ static int fscache_alloc_object(struct fscache_cache *cache,
 	object = cache->ops->alloc_object(cache, cookie);
 	fscache_stat_d(&fscache_n_cop_alloc_object);
 	if (IS_ERR(object)) {
-		fscache_stat(&fscache_n_object_no_alloc);
+		fscache_stat_wrap(&fscache_n_object_no_alloc);
 		ret = PTR_ERR(object);
 		goto error;
 	}
 
-	fscache_stat(&fscache_n_object_alloc);
+	fscache_stat_wrap(&fscache_n_object_alloc);
 
-	object->debug_id = atomic_inc_return(&fscache_object_debug_id);
+	object->debug_id = atomic_inc_return_wrap(&fscache_object_debug_id);
 
 	_debug("ALLOC OBJ%x: %s {%lx}",
 	       object->debug_id, cookie->def->name, object->events);
@@ -419,7 +419,7 @@ void __fscache_invalidate(struct fscache_cookie *cookie)
 
 	_enter("{%s}", cookie->def->name);
 
-	fscache_stat(&fscache_n_invalidates);
+	fscache_stat_wrap(&fscache_n_invalidates);
 
 	/* Only permit invalidation of data files.  Invalidating an index will
 	 * require the caller to release all its attachments to the tree rooted
@@ -477,10 +477,10 @@ void __fscache_update_cookie(struct fscache_cookie *cookie)
 {
 	struct fscache_object *object;
 
-	fscache_stat(&fscache_n_updates);
+	fscache_stat_wrap(&fscache_n_updates);
 
 	if (!cookie) {
-		fscache_stat(&fscache_n_updates_null);
+		fscache_stat_wrap(&fscache_n_updates_null);
 		_leave(" [no cookie]");
 		return;
 	}
@@ -581,12 +581,12 @@ EXPORT_SYMBOL(__fscache_disable_cookie);
  */
 void __fscache_relinquish_cookie(struct fscache_cookie *cookie, bool retire)
 {
-	fscache_stat(&fscache_n_relinquishes);
+	fscache_stat_wrap(&fscache_n_relinquishes);
 	if (retire)
-		fscache_stat(&fscache_n_relinquishes_retire);
+		fscache_stat_wrap(&fscache_n_relinquishes_retire);
 
 	if (!cookie) {
-		fscache_stat(&fscache_n_relinquishes_null);
+		fscache_stat_wrap(&fscache_n_relinquishes_null);
 		_leave(" [no cookie]");
 		return;
 	}
@@ -687,7 +687,7 @@ int __fscache_check_consistency(struct fscache_cookie *cookie)
 	if (test_bit(FSCACHE_IOERROR, &object->cache->flags))
 		goto inconsistent;
 
-	op->debug_id = atomic_inc_return(&fscache_op_debug_id);
+	op->debug_id = atomic_inc_return_wrap(&fscache_op_debug_id);
 
 	__fscache_use_cookie(cookie);
 	if (fscache_submit_op(object, op) < 0)
diff --git a/fs/fscache/internal.h b/fs/fscache/internal.h
index 97ec451..f56d965 100644
--- a/fs/fscache/internal.h
+++ b/fs/fscache/internal.h
@@ -136,8 +136,8 @@ extern void fscache_operation_gc(struct work_struct *);
 extern int fscache_wait_for_deferred_lookup(struct fscache_cookie *);
 extern int fscache_wait_for_operation_activation(struct fscache_object *,
 						 struct fscache_operation *,
-						 atomic_t *,
-						 atomic_t *);
+						 atomic_wrap_t *,
+						 atomic_wrap_t *);
 extern void fscache_invalidate_writes(struct fscache_cookie *);
 
 /*
@@ -155,102 +155,102 @@ extern void fscache_proc_cleanup(void);
  * stats.c
  */
 #ifdef CONFIG_FSCACHE_STATS
-extern atomic_t fscache_n_ops_processed[FSCACHE_MAX_THREADS];
-extern atomic_t fscache_n_objs_processed[FSCACHE_MAX_THREADS];
-
-extern atomic_t fscache_n_op_pend;
-extern atomic_t fscache_n_op_run;
-extern atomic_t fscache_n_op_enqueue;
-extern atomic_t fscache_n_op_deferred_release;
-extern atomic_t fscache_n_op_initialised;
-extern atomic_t fscache_n_op_release;
-extern atomic_t fscache_n_op_gc;
-extern atomic_t fscache_n_op_cancelled;
-extern atomic_t fscache_n_op_rejected;
-
-extern atomic_t fscache_n_attr_changed;
-extern atomic_t fscache_n_attr_changed_ok;
-extern atomic_t fscache_n_attr_changed_nobufs;
-extern atomic_t fscache_n_attr_changed_nomem;
-extern atomic_t fscache_n_attr_changed_calls;
-
-extern atomic_t fscache_n_allocs;
-extern atomic_t fscache_n_allocs_ok;
-extern atomic_t fscache_n_allocs_wait;
-extern atomic_t fscache_n_allocs_nobufs;
-extern atomic_t fscache_n_allocs_intr;
-extern atomic_t fscache_n_allocs_object_dead;
-extern atomic_t fscache_n_alloc_ops;
-extern atomic_t fscache_n_alloc_op_waits;
-
-extern atomic_t fscache_n_retrievals;
-extern atomic_t fscache_n_retrievals_ok;
-extern atomic_t fscache_n_retrievals_wait;
-extern atomic_t fscache_n_retrievals_nodata;
-extern atomic_t fscache_n_retrievals_nobufs;
-extern atomic_t fscache_n_retrievals_intr;
-extern atomic_t fscache_n_retrievals_nomem;
-extern atomic_t fscache_n_retrievals_object_dead;
-extern atomic_t fscache_n_retrieval_ops;
-extern atomic_t fscache_n_retrieval_op_waits;
-
-extern atomic_t fscache_n_stores;
-extern atomic_t fscache_n_stores_ok;
-extern atomic_t fscache_n_stores_again;
-extern atomic_t fscache_n_stores_nobufs;
-extern atomic_t fscache_n_stores_oom;
-extern atomic_t fscache_n_store_ops;
-extern atomic_t fscache_n_store_calls;
-extern atomic_t fscache_n_store_pages;
-extern atomic_t fscache_n_store_radix_deletes;
-extern atomic_t fscache_n_store_pages_over_limit;
-
-extern atomic_t fscache_n_store_vmscan_not_storing;
-extern atomic_t fscache_n_store_vmscan_gone;
-extern atomic_t fscache_n_store_vmscan_busy;
-extern atomic_t fscache_n_store_vmscan_cancelled;
-extern atomic_t fscache_n_store_vmscan_wait;
-
-extern atomic_t fscache_n_marks;
-extern atomic_t fscache_n_uncaches;
-
-extern atomic_t fscache_n_acquires;
-extern atomic_t fscache_n_acquires_null;
-extern atomic_t fscache_n_acquires_no_cache;
-extern atomic_t fscache_n_acquires_ok;
-extern atomic_t fscache_n_acquires_nobufs;
-extern atomic_t fscache_n_acquires_oom;
-
-extern atomic_t fscache_n_invalidates;
-extern atomic_t fscache_n_invalidates_run;
-
-extern atomic_t fscache_n_updates;
-extern atomic_t fscache_n_updates_null;
-extern atomic_t fscache_n_updates_run;
-
-extern atomic_t fscache_n_relinquishes;
-extern atomic_t fscache_n_relinquishes_null;
-extern atomic_t fscache_n_relinquishes_waitcrt;
-extern atomic_t fscache_n_relinquishes_retire;
-
-extern atomic_t fscache_n_cookie_index;
-extern atomic_t fscache_n_cookie_data;
-extern atomic_t fscache_n_cookie_special;
-
-extern atomic_t fscache_n_object_alloc;
-extern atomic_t fscache_n_object_no_alloc;
-extern atomic_t fscache_n_object_lookups;
-extern atomic_t fscache_n_object_lookups_negative;
-extern atomic_t fscache_n_object_lookups_positive;
-extern atomic_t fscache_n_object_lookups_timed_out;
-extern atomic_t fscache_n_object_created;
-extern atomic_t fscache_n_object_avail;
-extern atomic_t fscache_n_object_dead;
-
-extern atomic_t fscache_n_checkaux_none;
-extern atomic_t fscache_n_checkaux_okay;
-extern atomic_t fscache_n_checkaux_update;
-extern atomic_t fscache_n_checkaux_obsolete;
+extern atomic_wrap_t fscache_n_ops_processed[FSCACHE_MAX_THREADS];
+extern atomic_wrap_t fscache_n_objs_processed[FSCACHE_MAX_THREADS];
+
+extern atomic_wrap_t fscache_n_op_pend;
+extern atomic_wrap_t fscache_n_op_run;
+extern atomic_wrap_t fscache_n_op_enqueue;
+extern atomic_wrap_t fscache_n_op_deferred_release;
+extern atomic_wrap_t fscache_n_op_initialised;
+extern atomic_wrap_t fscache_n_op_release;
+extern atomic_wrap_t fscache_n_op_gc;
+extern atomic_wrap_t fscache_n_op_cancelled;
+extern atomic_wrap_t fscache_n_op_rejected;
+
+extern atomic_wrap_t fscache_n_attr_changed;
+extern atomic_wrap_t fscache_n_attr_changed_ok;
+extern atomic_wrap_t fscache_n_attr_changed_nobufs;
+extern atomic_wrap_t fscache_n_attr_changed_nomem;
+extern atomic_wrap_t fscache_n_attr_changed_calls;
+
+extern atomic_wrap_t fscache_n_allocs;
+extern atomic_wrap_t fscache_n_allocs_ok;
+extern atomic_wrap_t fscache_n_allocs_wait;
+extern atomic_wrap_t fscache_n_allocs_nobufs;
+extern atomic_wrap_t fscache_n_allocs_intr;
+extern atomic_wrap_t fscache_n_allocs_object_dead;
+extern atomic_wrap_t fscache_n_alloc_ops;
+extern atomic_wrap_t fscache_n_alloc_op_waits;
+
+extern atomic_wrap_t fscache_n_retrievals;
+extern atomic_wrap_t fscache_n_retrievals_ok;
+extern atomic_wrap_t fscache_n_retrievals_wait;
+extern atomic_wrap_t fscache_n_retrievals_nodata;
+extern atomic_wrap_t fscache_n_retrievals_nobufs;
+extern atomic_wrap_t fscache_n_retrievals_intr;
+extern atomic_wrap_t fscache_n_retrievals_nomem;
+extern atomic_wrap_t fscache_n_retrievals_object_dead;
+extern atomic_wrap_t fscache_n_retrieval_ops;
+extern atomic_wrap_t fscache_n_retrieval_op_waits;
+
+extern atomic_wrap_t fscache_n_stores;
+extern atomic_wrap_t fscache_n_stores_ok;
+extern atomic_wrap_t fscache_n_stores_again;
+extern atomic_wrap_t fscache_n_stores_nobufs;
+extern atomic_wrap_t fscache_n_stores_oom;
+extern atomic_wrap_t fscache_n_store_ops;
+extern atomic_wrap_t fscache_n_store_calls;
+extern atomic_wrap_t fscache_n_store_pages;
+extern atomic_wrap_t fscache_n_store_radix_deletes;
+extern atomic_wrap_t fscache_n_store_pages_over_limit;
+
+extern atomic_wrap_t fscache_n_store_vmscan_not_storing;
+extern atomic_wrap_t fscache_n_store_vmscan_gone;
+extern atomic_wrap_t fscache_n_store_vmscan_busy;
+extern atomic_wrap_t fscache_n_store_vmscan_cancelled;
+extern atomic_wrap_t fscache_n_store_vmscan_wait;
+
+extern atomic_wrap_t fscache_n_marks;
+extern atomic_wrap_t fscache_n_uncaches;
+
+extern atomic_wrap_t fscache_n_acquires;
+extern atomic_wrap_t fscache_n_acquires_null;
+extern atomic_wrap_t fscache_n_acquires_no_cache;
+extern atomic_wrap_t fscache_n_acquires_ok;
+extern atomic_wrap_t fscache_n_acquires_nobufs;
+extern atomic_wrap_t fscache_n_acquires_oom;
+
+extern atomic_wrap_t fscache_n_invalidates;
+extern atomic_wrap_t fscache_n_invalidates_run;
+
+extern atomic_wrap_t fscache_n_updates;
+extern atomic_wrap_t fscache_n_updates_null;
+extern atomic_wrap_t fscache_n_updates_run;
+
+extern atomic_wrap_t fscache_n_relinquishes;
+extern atomic_wrap_t fscache_n_relinquishes_null;
+extern atomic_wrap_t fscache_n_relinquishes_waitcrt;
+extern atomic_wrap_t fscache_n_relinquishes_retire;
+
+extern atomic_wrap_t fscache_n_cookie_index;
+extern atomic_wrap_t fscache_n_cookie_data;
+extern atomic_wrap_t fscache_n_cookie_special;
+
+extern atomic_wrap_t fscache_n_object_alloc;
+extern atomic_wrap_t fscache_n_object_no_alloc;
+extern atomic_wrap_t fscache_n_object_lookups;
+extern atomic_wrap_t fscache_n_object_lookups_negative;
+extern atomic_wrap_t fscache_n_object_lookups_positive;
+extern atomic_wrap_t fscache_n_object_lookups_timed_out;
+extern atomic_wrap_t fscache_n_object_created;
+extern atomic_wrap_t fscache_n_object_avail;
+extern atomic_wrap_t fscache_n_object_dead;
+
+extern atomic_wrap_t fscache_n_checkaux_none;
+extern atomic_wrap_t fscache_n_checkaux_okay;
+extern atomic_wrap_t fscache_n_checkaux_update;
+extern atomic_wrap_t fscache_n_checkaux_obsolete;
 
 extern atomic_t fscache_n_cop_alloc_object;
 extern atomic_t fscache_n_cop_lookup_object;
@@ -280,6 +280,11 @@ static inline void fscache_stat(atomic_t *stat)
 	atomic_inc(stat);
 }
 
+static inline void fscache_stat_wrap(atomic_wrap_t *stat)
+{
+	atomic_inc_wrap(stat);
+}
+
 static inline void fscache_stat_d(atomic_t *stat)
 {
 	atomic_dec(stat);
@@ -292,6 +297,7 @@ extern const struct file_operations fscache_stats_fops;
 
 #define __fscache_stat(stat) (NULL)
 #define fscache_stat(stat) do {} while (0)
+#define fscache_stat_wrap(stat) do {} while (0)
 #define fscache_stat_d(stat) do {} while (0)
 #endif
 
diff --git a/fs/fscache/object.c b/fs/fscache/object.c
index 9e792e3..6a7e3e0 100644
--- a/fs/fscache/object.c
+++ b/fs/fscache/object.c
@@ -465,7 +465,7 @@ static const struct fscache_state *fscache_look_up_object(struct fscache_object
 	_debug("LOOKUP \"%s\" in \"%s\"",
 	       cookie->def->name, object->cache->tag->name);
 
-	fscache_stat(&fscache_n_object_lookups);
+	fscache_stat_wrap(&fscache_n_object_lookups);
 	fscache_stat(&fscache_n_cop_lookup_object);
 	ret = object->cache->ops->lookup_object(object);
 	fscache_stat_d(&fscache_n_cop_lookup_object);
@@ -475,7 +475,7 @@ static const struct fscache_state *fscache_look_up_object(struct fscache_object
 	if (ret == -ETIMEDOUT) {
 		/* probably stuck behind another object, so move this one to
 		 * the back of the queue */
-		fscache_stat(&fscache_n_object_lookups_timed_out);
+		fscache_stat_wrap(&fscache_n_object_lookups_timed_out);
 		_leave(" [timeout]");
 		return NO_TRANSIT;
 	}
@@ -503,7 +503,7 @@ void fscache_object_lookup_negative(struct fscache_object *object)
 	_enter("{OBJ%x,%s}", object->debug_id, object->state->name);
 
 	if (!test_and_set_bit(FSCACHE_OBJECT_IS_LOOKED_UP, &object->flags)) {
-		fscache_stat(&fscache_n_object_lookups_negative);
+		fscache_stat_wrap(&fscache_n_object_lookups_negative);
 
 		/* Allow write requests to begin stacking up and read requests to begin
 		 * returning ENODATA.
@@ -538,7 +538,7 @@ void fscache_obtained_object(struct fscache_object *object)
 	/* if we were still looking up, then we must have a positive lookup
 	 * result, in which case there may be data available */
 	if (!test_and_set_bit(FSCACHE_OBJECT_IS_LOOKED_UP, &object->flags)) {
-		fscache_stat(&fscache_n_object_lookups_positive);
+		fscache_stat_wrap(&fscache_n_object_lookups_positive);
 
 		/* We do (presumably) have data */
 		clear_bit_unlock(FSCACHE_COOKIE_NO_DATA_YET, &cookie->flags);
@@ -550,7 +550,7 @@ void fscache_obtained_object(struct fscache_object *object)
 		clear_bit_unlock(FSCACHE_COOKIE_LOOKING_UP, &cookie->flags);
 		wake_up_bit(&cookie->flags, FSCACHE_COOKIE_LOOKING_UP);
 	} else {
-		fscache_stat(&fscache_n_object_created);
+		fscache_stat_wrap(&fscache_n_object_created);
 	}
 
 	set_bit(FSCACHE_OBJECT_IS_AVAILABLE, &object->flags);
@@ -586,7 +586,7 @@ static const struct fscache_state *fscache_object_available(struct fscache_objec
 	fscache_stat_d(&fscache_n_cop_lookup_complete);
 
 	fscache_hist(fscache_obj_instantiate_histogram, object->lookup_jif);
-	fscache_stat(&fscache_n_object_avail);
+	fscache_stat_wrap(&fscache_n_object_avail);
 
 	_leave("");
 	return transit_to(JUMPSTART_DEPS);
@@ -735,7 +735,7 @@ static const struct fscache_state *fscache_drop_object(struct fscache_object *ob
 
 	/* this just shifts the object release to the work processor */
 	fscache_put_object(object);
-	fscache_stat(&fscache_n_object_dead);
+	fscache_stat_wrap(&fscache_n_object_dead);
 
 	_leave("");
 	return transit_to(OBJECT_DEAD);
@@ -900,7 +900,7 @@ enum fscache_checkaux fscache_check_aux(struct fscache_object *object,
 	enum fscache_checkaux result;
 
 	if (!object->cookie->def->check_aux) {
-		fscache_stat(&fscache_n_checkaux_none);
+		fscache_stat_wrap(&fscache_n_checkaux_none);
 		return FSCACHE_CHECKAUX_OKAY;
 	}
 
@@ -909,17 +909,17 @@ enum fscache_checkaux fscache_check_aux(struct fscache_object *object,
 	switch (result) {
 		/* entry okay as is */
 	case FSCACHE_CHECKAUX_OKAY:
-		fscache_stat(&fscache_n_checkaux_okay);
+		fscache_stat_wrap(&fscache_n_checkaux_okay);
 		break;
 
 		/* entry requires update */
 	case FSCACHE_CHECKAUX_NEEDS_UPDATE:
-		fscache_stat(&fscache_n_checkaux_update);
+		fscache_stat_wrap(&fscache_n_checkaux_update);
 		break;
 
 		/* entry requires deletion */
 	case FSCACHE_CHECKAUX_OBSOLETE:
-		fscache_stat(&fscache_n_checkaux_obsolete);
+		fscache_stat_wrap(&fscache_n_checkaux_obsolete);
 		break;
 
 	default:
@@ -1007,7 +1007,7 @@ static const struct fscache_state *fscache_invalidate_object(struct fscache_obje
 {
 	const struct fscache_state *s;
 
-	fscache_stat(&fscache_n_invalidates_run);
+	fscache_stat_wrap(&fscache_n_invalidates_run);
 	fscache_stat(&fscache_n_cop_invalidate_object);
 	s = _fscache_invalidate_object(object, event);
 	fscache_stat_d(&fscache_n_cop_invalidate_object);
@@ -1022,7 +1022,7 @@ static const struct fscache_state *fscache_update_object(struct fscache_object *
 {
 	_enter("{OBJ%x},%d", object->debug_id, event);
 
-	fscache_stat(&fscache_n_updates_run);
+	fscache_stat_wrap(&fscache_n_updates_run);
 	fscache_stat(&fscache_n_cop_update_object);
 	object->cache->ops->update_object(object);
 	fscache_stat_d(&fscache_n_cop_update_object);
diff --git a/fs/fscache/operation.c b/fs/fscache/operation.c
index de67745..e405c41 100644
--- a/fs/fscache/operation.c
+++ b/fs/fscache/operation.c
@@ -17,7 +17,7 @@
 #include <linux/slab.h>
 #include "internal.h"
 
-atomic_t fscache_op_debug_id;
+atomic_wrap_t fscache_op_debug_id;
 EXPORT_SYMBOL(fscache_op_debug_id);
 
 static void fscache_operation_dummy_cancel(struct fscache_operation *op)
@@ -40,12 +40,12 @@ void fscache_operation_init(struct fscache_operation *op,
 	INIT_WORK(&op->work, fscache_op_work_func);
 	atomic_set(&op->usage, 1);
 	op->state = FSCACHE_OP_ST_INITIALISED;
-	op->debug_id = atomic_inc_return(&fscache_op_debug_id);
+	op->debug_id = atomic_inc_return_wrap(&fscache_op_debug_id);
 	op->processor = processor;
 	op->cancel = cancel ?: fscache_operation_dummy_cancel;
 	op->release = release;
 	INIT_LIST_HEAD(&op->pend_link);
-	fscache_stat(&fscache_n_op_initialised);
+	fscache_stat_wrap(&fscache_n_op_initialised);
 }
 EXPORT_SYMBOL(fscache_operation_init);
 
@@ -68,7 +68,7 @@ void fscache_enqueue_operation(struct fscache_operation *op)
 	ASSERTCMP(atomic_read(&op->usage), >, 0);
 	ASSERTCMP(op->state, ==, FSCACHE_OP_ST_IN_PROGRESS);
 
-	fscache_stat(&fscache_n_op_enqueue);
+	fscache_stat_wrap(&fscache_n_op_enqueue);
 	switch (op->flags & FSCACHE_OP_TYPE) {
 	case FSCACHE_OP_ASYNC:
 		_debug("queue async");
@@ -101,7 +101,7 @@ static void fscache_run_op(struct fscache_object *object,
 		wake_up_bit(&op->flags, FSCACHE_OP_WAITING);
 	if (op->processor)
 		fscache_enqueue_operation(op);
-	fscache_stat(&fscache_n_op_run);
+	fscache_stat_wrap(&fscache_n_op_run);
 }
 
 /*
@@ -169,7 +169,7 @@ int fscache_submit_exclusive_op(struct fscache_object *object,
 	op->state = FSCACHE_OP_ST_PENDING;
 	flags = READ_ONCE(object->flags);
 	if (unlikely(!(flags & BIT(FSCACHE_OBJECT_IS_LIVE)))) {
-		fscache_stat(&fscache_n_op_rejected);
+		fscache_stat_wrap(&fscache_n_op_rejected);
 		op->cancel(op);
 		op->state = FSCACHE_OP_ST_CANCELLED;
 		ret = -ENOBUFS;
@@ -185,11 +185,11 @@ int fscache_submit_exclusive_op(struct fscache_object *object,
 		if (object->n_in_progress > 0) {
 			atomic_inc(&op->usage);
 			list_add_tail(&op->pend_link, &object->pending_ops);
-			fscache_stat(&fscache_n_op_pend);
+			fscache_stat_wrap(&fscache_n_op_pend);
 		} else if (!list_empty(&object->pending_ops)) {
 			atomic_inc(&op->usage);
 			list_add_tail(&op->pend_link, &object->pending_ops);
-			fscache_stat(&fscache_n_op_pend);
+			fscache_stat_wrap(&fscache_n_op_pend);
 			fscache_start_operations(object);
 		} else {
 			ASSERTCMP(object->n_in_progress, ==, 0);
@@ -205,7 +205,7 @@ int fscache_submit_exclusive_op(struct fscache_object *object,
 		object->n_exclusive++;	/* reads and writes must wait */
 		atomic_inc(&op->usage);
 		list_add_tail(&op->pend_link, &object->pending_ops);
-		fscache_stat(&fscache_n_op_pend);
+		fscache_stat_wrap(&fscache_n_op_pend);
 		ret = 0;
 	} else if (flags & BIT(FSCACHE_OBJECT_KILLED_BY_CACHE)) {
 		op->cancel(op);
@@ -254,7 +254,7 @@ int fscache_submit_op(struct fscache_object *object,
 	op->state = FSCACHE_OP_ST_PENDING;
 	flags = READ_ONCE(object->flags);
 	if (unlikely(!(flags & BIT(FSCACHE_OBJECT_IS_LIVE)))) {
-		fscache_stat(&fscache_n_op_rejected);
+		fscache_stat_wrap(&fscache_n_op_rejected);
 		op->cancel(op);
 		op->state = FSCACHE_OP_ST_CANCELLED;
 		ret = -ENOBUFS;
@@ -269,11 +269,11 @@ int fscache_submit_op(struct fscache_object *object,
 		if (object->n_exclusive > 0) {
 			atomic_inc(&op->usage);
 			list_add_tail(&op->pend_link, &object->pending_ops);
-			fscache_stat(&fscache_n_op_pend);
+			fscache_stat_wrap(&fscache_n_op_pend);
 		} else if (!list_empty(&object->pending_ops)) {
 			atomic_inc(&op->usage);
 			list_add_tail(&op->pend_link, &object->pending_ops);
-			fscache_stat(&fscache_n_op_pend);
+			fscache_stat_wrap(&fscache_n_op_pend);
 			fscache_start_operations(object);
 		} else {
 			ASSERTCMP(object->n_exclusive, ==, 0);
@@ -285,7 +285,7 @@ int fscache_submit_op(struct fscache_object *object,
 		object->n_ops++;
 		atomic_inc(&op->usage);
 		list_add_tail(&op->pend_link, &object->pending_ops);
-		fscache_stat(&fscache_n_op_pend);
+		fscache_stat_wrap(&fscache_n_op_pend);
 		ret = 0;
 	} else if (flags & BIT(FSCACHE_OBJECT_KILLED_BY_CACHE)) {
 		op->cancel(op);
@@ -369,7 +369,7 @@ int fscache_cancel_op(struct fscache_operation *op,
 		list_del_init(&op->pend_link);
 		put = true;
 
-		fscache_stat(&fscache_n_op_cancelled);
+		fscache_stat_wrap(&fscache_n_op_cancelled);
 		op->cancel(op);
 		op->state = FSCACHE_OP_ST_CANCELLED;
 		if (test_bit(FSCACHE_OP_EXCLUSIVE, &op->flags))
@@ -385,7 +385,7 @@ int fscache_cancel_op(struct fscache_operation *op,
 		if (object->n_in_progress == 0)
 			fscache_start_operations(object);
 
-		fscache_stat(&fscache_n_op_cancelled);
+		fscache_stat_wrap(&fscache_n_op_cancelled);
 		op->cancel(op);
 		op->state = FSCACHE_OP_ST_CANCELLED;
 		if (test_bit(FSCACHE_OP_EXCLUSIVE, &op->flags))
@@ -416,7 +416,7 @@ void fscache_cancel_all_ops(struct fscache_object *object)
 	while (!list_empty(&object->pending_ops)) {
 		op = list_entry(object->pending_ops.next,
 				struct fscache_operation, pend_link);
-		fscache_stat(&fscache_n_op_cancelled);
+		fscache_stat_wrap(&fscache_n_op_cancelled);
 		list_del_init(&op->pend_link);
 
 		ASSERTCMP(op->state, ==, FSCACHE_OP_ST_PENDING);
@@ -493,7 +493,7 @@ void fscache_put_operation(struct fscache_operation *op)
 		    op->state != FSCACHE_OP_ST_COMPLETE,
 		    op->state, ==, FSCACHE_OP_ST_CANCELLED);
 
-	fscache_stat(&fscache_n_op_release);
+	fscache_stat_wrap(&fscache_n_op_release);
 
 	if (op->release) {
 		op->release(op);
@@ -513,7 +513,7 @@ void fscache_put_operation(struct fscache_operation *op)
 		 * lock, and defer it otherwise */
 		if (!spin_trylock(&object->lock)) {
 			_debug("defer put");
-			fscache_stat(&fscache_n_op_deferred_release);
+			fscache_stat_wrap(&fscache_n_op_deferred_release);
 
 			cache = object->cache;
 			spin_lock(&cache->op_gc_list_lock);
@@ -567,7 +567,7 @@ void fscache_operation_gc(struct work_struct *work)
 
 		_debug("GC DEFERRED REL OBJ%x OP%x",
 		       object->debug_id, op->debug_id);
-		fscache_stat(&fscache_n_op_gc);
+		fscache_stat_wrap(&fscache_n_op_gc);
 
 		ASSERTCMP(atomic_read(&op->usage), ==, 0);
 		ASSERTCMP(op->state, ==, FSCACHE_OP_ST_DEAD);
diff --git a/fs/fscache/page.c b/fs/fscache/page.c
index c8c4f79..1bc9466 100644
--- a/fs/fscache/page.c
+++ b/fs/fscache/page.c
@@ -74,7 +74,7 @@ bool __fscache_maybe_release_page(struct fscache_cookie *cookie,
 	val = radix_tree_lookup(&cookie->stores, page->index);
 	if (!val) {
 		rcu_read_unlock();
-		fscache_stat(&fscache_n_store_vmscan_not_storing);
+		fscache_stat_wrap(&fscache_n_store_vmscan_not_storing);
 		__fscache_uncache_page(cookie, page);
 		return true;
 	}
@@ -104,11 +104,11 @@ bool __fscache_maybe_release_page(struct fscache_cookie *cookie,
 	spin_unlock(&cookie->stores_lock);
 
 	if (xpage) {
-		fscache_stat(&fscache_n_store_vmscan_cancelled);
-		fscache_stat(&fscache_n_store_radix_deletes);
+		fscache_stat_wrap(&fscache_n_store_vmscan_cancelled);
+		fscache_stat_wrap(&fscache_n_store_radix_deletes);
 		ASSERTCMP(xpage, ==, page);
 	} else {
-		fscache_stat(&fscache_n_store_vmscan_gone);
+		fscache_stat_wrap(&fscache_n_store_vmscan_gone);
 	}
 
 	wake_up_bit(&cookie->flags, 0);
@@ -123,11 +123,11 @@ bool __fscache_maybe_release_page(struct fscache_cookie *cookie,
 	 * sleeping on memory allocation, so we may need to impose a timeout
 	 * too. */
 	if (!(gfp & __GFP_DIRECT_RECLAIM) || !(gfp & __GFP_FS)) {
-		fscache_stat(&fscache_n_store_vmscan_busy);
+		fscache_stat_wrap(&fscache_n_store_vmscan_busy);
 		return false;
 	}
 
-	fscache_stat(&fscache_n_store_vmscan_wait);
+	fscache_stat_wrap(&fscache_n_store_vmscan_wait);
 	if (!release_page_wait_timeout(cookie, page))
 		_debug("fscache writeout timeout page: %p{%lx}",
 			page, page->index);
@@ -156,7 +156,7 @@ static void fscache_end_page_write(struct fscache_object *object,
 				     FSCACHE_COOKIE_STORING_TAG);
 		if (!radix_tree_tag_get(&cookie->stores, page->index,
 					FSCACHE_COOKIE_PENDING_TAG)) {
-			fscache_stat(&fscache_n_store_radix_deletes);
+			fscache_stat_wrap(&fscache_n_store_radix_deletes);
 			xpage = radix_tree_delete(&cookie->stores, page->index);
 		}
 		spin_unlock(&cookie->stores_lock);
@@ -177,7 +177,7 @@ static void fscache_attr_changed_op(struct fscache_operation *op)
 
 	_enter("{OBJ%x OP%x}", object->debug_id, op->debug_id);
 
-	fscache_stat(&fscache_n_attr_changed_calls);
+	fscache_stat_wrap(&fscache_n_attr_changed_calls);
 
 	if (fscache_object_is_active(object)) {
 		fscache_stat(&fscache_n_cop_attr_changed);
@@ -204,11 +204,11 @@ int __fscache_attr_changed(struct fscache_cookie *cookie)
 
 	ASSERTCMP(cookie->def->type, !=, FSCACHE_COOKIE_TYPE_INDEX);
 
-	fscache_stat(&fscache_n_attr_changed);
+	fscache_stat_wrap(&fscache_n_attr_changed);
 
 	op = kzalloc(sizeof(*op), GFP_KERNEL);
 	if (!op) {
-		fscache_stat(&fscache_n_attr_changed_nomem);
+		fscache_stat_wrap(&fscache_n_attr_changed_nomem);
 		_leave(" = -ENOMEM");
 		return -ENOMEM;
 	}
@@ -230,7 +230,7 @@ int __fscache_attr_changed(struct fscache_cookie *cookie)
 	if (fscache_submit_exclusive_op(object, op) < 0)
 		goto nobufs_dec;
 	spin_unlock(&cookie->lock);
-	fscache_stat(&fscache_n_attr_changed_ok);
+	fscache_stat_wrap(&fscache_n_attr_changed_ok);
 	fscache_put_operation(op);
 	_leave(" = 0");
 	return 0;
@@ -242,7 +242,7 @@ int __fscache_attr_changed(struct fscache_cookie *cookie)
 	fscache_put_operation(op);
 	if (wake_cookie)
 		__fscache_wake_unused_cookie(cookie);
-	fscache_stat(&fscache_n_attr_changed_nobufs);
+	fscache_stat_wrap(&fscache_n_attr_changed_nobufs);
 	_leave(" = %d", -ENOBUFS);
 	return -ENOBUFS;
 }
@@ -293,7 +293,7 @@ static struct fscache_retrieval *fscache_alloc_retrieval(
 	/* allocate a retrieval operation and attempt to submit it */
 	op = kzalloc(sizeof(*op), GFP_NOIO);
 	if (!op) {
-		fscache_stat(&fscache_n_retrievals_nomem);
+		fscache_stat_wrap(&fscache_n_retrievals_nomem);
 		return NULL;
 	}
 
@@ -332,12 +332,12 @@ int fscache_wait_for_deferred_lookup(struct fscache_cookie *cookie)
 		return 0;
 	}
 
-	fscache_stat(&fscache_n_retrievals_wait);
+	fscache_stat_wrap(&fscache_n_retrievals_wait);
 
 	jif = jiffies;
 	if (wait_on_bit(&cookie->flags, FSCACHE_COOKIE_LOOKING_UP,
 			TASK_INTERRUPTIBLE) != 0) {
-		fscache_stat(&fscache_n_retrievals_intr);
+		fscache_stat_wrap(&fscache_n_retrievals_intr);
 		_leave(" = -ERESTARTSYS");
 		return -ERESTARTSYS;
 	}
@@ -355,8 +355,8 @@ int fscache_wait_for_deferred_lookup(struct fscache_cookie *cookie)
  */
 int fscache_wait_for_operation_activation(struct fscache_object *object,
 					  struct fscache_operation *op,
-					  atomic_t *stat_op_waits,
-					  atomic_t *stat_object_dead)
+					  atomic_wrap_t *stat_op_waits,
+					  atomic_wrap_t *stat_object_dead)
 {
 	int ret;
 
@@ -365,7 +365,7 @@ int fscache_wait_for_operation_activation(struct fscache_object *object,
 
 	_debug(">>> WT");
 	if (stat_op_waits)
-		fscache_stat(stat_op_waits);
+		fscache_stat_wrap(stat_op_waits);
 	if (wait_on_bit(&op->flags, FSCACHE_OP_WAITING,
 			TASK_INTERRUPTIBLE) != 0) {
 		ret = fscache_cancel_op(op, false);
@@ -382,7 +382,7 @@ int fscache_wait_for_operation_activation(struct fscache_object *object,
 check_if_dead:
 	if (op->state == FSCACHE_OP_ST_CANCELLED) {
 		if (stat_object_dead)
-			fscache_stat(stat_object_dead);
+			fscache_stat_wrap(stat_object_dead);
 		_leave(" = -ENOBUFS [cancelled]");
 		return -ENOBUFS;
 	}
@@ -391,7 +391,7 @@ int fscache_wait_for_operation_activation(struct fscache_object *object,
 		enum fscache_operation_state state = op->state;
 		fscache_cancel_op(op, true);
 		if (stat_object_dead)
-			fscache_stat(stat_object_dead);
+			fscache_stat_wrap(stat_object_dead);
 		_leave(" = -ENOBUFS [obj dead %d]", state);
 		return -ENOBUFS;
 	}
@@ -420,7 +420,7 @@ int __fscache_read_or_alloc_page(struct fscache_cookie *cookie,
 
 	_enter("%p,%p,,,", cookie, page);
 
-	fscache_stat(&fscache_n_retrievals);
+	fscache_stat_wrap(&fscache_n_retrievals);
 
 	if (hlist_empty(&cookie->backing_objects))
 		goto nobufs;
@@ -462,7 +462,7 @@ int __fscache_read_or_alloc_page(struct fscache_cookie *cookie,
 		goto nobufs_unlock_dec;
 	spin_unlock(&cookie->lock);
 
-	fscache_stat(&fscache_n_retrieval_ops);
+	fscache_stat_wrap(&fscache_n_retrieval_ops);
 
 	/* we wait for the operation to become active, and then process it
 	 * *here*, in this thread, and not in the thread pool */
@@ -488,15 +488,15 @@ int __fscache_read_or_alloc_page(struct fscache_cookie *cookie,
 
 error:
 	if (ret == -ENOMEM)
-		fscache_stat(&fscache_n_retrievals_nomem);
+		fscache_stat_wrap(&fscache_n_retrievals_nomem);
 	else if (ret == -ERESTARTSYS)
-		fscache_stat(&fscache_n_retrievals_intr);
+		fscache_stat_wrap(&fscache_n_retrievals_intr);
 	else if (ret == -ENODATA)
-		fscache_stat(&fscache_n_retrievals_nodata);
+		fscache_stat_wrap(&fscache_n_retrievals_nodata);
 	else if (ret < 0)
-		fscache_stat(&fscache_n_retrievals_nobufs);
+		fscache_stat_wrap(&fscache_n_retrievals_nobufs);
 	else
-		fscache_stat(&fscache_n_retrievals_ok);
+		fscache_stat_wrap(&fscache_n_retrievals_ok);
 
 	fscache_put_retrieval(op);
 	_leave(" = %d", ret);
@@ -511,7 +511,7 @@ int __fscache_read_or_alloc_page(struct fscache_cookie *cookie,
 		__fscache_wake_unused_cookie(cookie);
 	fscache_put_retrieval(op);
 nobufs:
-	fscache_stat(&fscache_n_retrievals_nobufs);
+	fscache_stat_wrap(&fscache_n_retrievals_nobufs);
 	_leave(" = -ENOBUFS");
 	return -ENOBUFS;
 }
@@ -550,7 +550,7 @@ int __fscache_read_or_alloc_pages(struct fscache_cookie *cookie,
 
 	_enter("%p,,%d,,,", cookie, *nr_pages);
 
-	fscache_stat(&fscache_n_retrievals);
+	fscache_stat_wrap(&fscache_n_retrievals);
 
 	if (hlist_empty(&cookie->backing_objects))
 		goto nobufs;
@@ -588,7 +588,7 @@ int __fscache_read_or_alloc_pages(struct fscache_cookie *cookie,
 		goto nobufs_unlock_dec;
 	spin_unlock(&cookie->lock);
 
-	fscache_stat(&fscache_n_retrieval_ops);
+	fscache_stat_wrap(&fscache_n_retrieval_ops);
 
 	/* we wait for the operation to become active, and then process it
 	 * *here*, in this thread, and not in the thread pool */
@@ -614,15 +614,15 @@ int __fscache_read_or_alloc_pages(struct fscache_cookie *cookie,
 
 error:
 	if (ret == -ENOMEM)
-		fscache_stat(&fscache_n_retrievals_nomem);
+		fscache_stat_wrap(&fscache_n_retrievals_nomem);
 	else if (ret == -ERESTARTSYS)
-		fscache_stat(&fscache_n_retrievals_intr);
+		fscache_stat_wrap(&fscache_n_retrievals_intr);
 	else if (ret == -ENODATA)
-		fscache_stat(&fscache_n_retrievals_nodata);
+		fscache_stat_wrap(&fscache_n_retrievals_nodata);
 	else if (ret < 0)
-		fscache_stat(&fscache_n_retrievals_nobufs);
+		fscache_stat_wrap(&fscache_n_retrievals_nobufs);
 	else
-		fscache_stat(&fscache_n_retrievals_ok);
+		fscache_stat_wrap(&fscache_n_retrievals_ok);
 
 	fscache_put_retrieval(op);
 	_leave(" = %d", ret);
@@ -637,7 +637,7 @@ int __fscache_read_or_alloc_pages(struct fscache_cookie *cookie,
 	if (wake_cookie)
 		__fscache_wake_unused_cookie(cookie);
 nobufs:
-	fscache_stat(&fscache_n_retrievals_nobufs);
+	fscache_stat_wrap(&fscache_n_retrievals_nobufs);
 	_leave(" = -ENOBUFS");
 	return -ENOBUFS;
 }
@@ -662,7 +662,7 @@ int __fscache_alloc_page(struct fscache_cookie *cookie,
 
 	_enter("%p,%p,,,", cookie, page);
 
-	fscache_stat(&fscache_n_allocs);
+	fscache_stat_wrap(&fscache_n_allocs);
 
 	if (hlist_empty(&cookie->backing_objects))
 		goto nobufs;
@@ -696,7 +696,7 @@ int __fscache_alloc_page(struct fscache_cookie *cookie,
 		goto nobufs_unlock_dec;
 	spin_unlock(&cookie->lock);
 
-	fscache_stat(&fscache_n_alloc_ops);
+	fscache_stat_wrap(&fscache_n_alloc_ops);
 
 	ret = fscache_wait_for_operation_activation(
 		object, &op->op,
@@ -712,11 +712,11 @@ int __fscache_alloc_page(struct fscache_cookie *cookie,
 
 error:
 	if (ret == -ERESTARTSYS)
-		fscache_stat(&fscache_n_allocs_intr);
+		fscache_stat_wrap(&fscache_n_allocs_intr);
 	else if (ret < 0)
-		fscache_stat(&fscache_n_allocs_nobufs);
+		fscache_stat_wrap(&fscache_n_allocs_nobufs);
 	else
-		fscache_stat(&fscache_n_allocs_ok);
+		fscache_stat_wrap(&fscache_n_allocs_ok);
 
 	fscache_put_retrieval(op);
 	_leave(" = %d", ret);
@@ -730,7 +730,7 @@ int __fscache_alloc_page(struct fscache_cookie *cookie,
 	if (wake_cookie)
 		__fscache_wake_unused_cookie(cookie);
 nobufs:
-	fscache_stat(&fscache_n_allocs_nobufs);
+	fscache_stat_wrap(&fscache_n_allocs_nobufs);
 	_leave(" = -ENOBUFS");
 	return -ENOBUFS;
 }
@@ -806,7 +806,7 @@ static void fscache_write_op(struct fscache_operation *_op)
 
 	spin_lock(&cookie->stores_lock);
 
-	fscache_stat(&fscache_n_store_calls);
+	fscache_stat_wrap(&fscache_n_store_calls);
 
 	/* find a page to store */
 	page = NULL;
@@ -817,7 +817,7 @@ static void fscache_write_op(struct fscache_operation *_op)
 	page = results[0];
 	_debug("gang %d [%lx]", n, page->index);
 	if (page->index >= op->store_limit) {
-		fscache_stat(&fscache_n_store_pages_over_limit);
+		fscache_stat_wrap(&fscache_n_store_pages_over_limit);
 		goto superseded;
 	}
 
@@ -829,7 +829,7 @@ static void fscache_write_op(struct fscache_operation *_op)
 	spin_unlock(&cookie->stores_lock);
 	spin_unlock(&object->lock);
 
-	fscache_stat(&fscache_n_store_pages);
+	fscache_stat_wrap(&fscache_n_store_pages);
 	fscache_stat(&fscache_n_cop_write_page);
 	ret = object->cache->ops->write_page(op, page);
 	fscache_stat_d(&fscache_n_cop_write_page);
@@ -935,7 +935,7 @@ int __fscache_write_page(struct fscache_cookie *cookie,
 	ASSERTCMP(cookie->def->type, !=, FSCACHE_COOKIE_TYPE_INDEX);
 	ASSERT(PageFsCache(page));
 
-	fscache_stat(&fscache_n_stores);
+	fscache_stat_wrap(&fscache_n_stores);
 
 	if (test_bit(FSCACHE_COOKIE_INVALIDATING, &cookie->flags)) {
 		_leave(" = -ENOBUFS [invalidating]");
@@ -994,7 +994,7 @@ int __fscache_write_page(struct fscache_cookie *cookie,
 	spin_unlock(&cookie->stores_lock);
 	spin_unlock(&object->lock);
 
-	op->op.debug_id	= atomic_inc_return(&fscache_op_debug_id);
+	op->op.debug_id	= atomic_inc_return_wrap(&fscache_op_debug_id);
 	op->store_limit = object->store_limit;
 
 	__fscache_use_cookie(cookie);
@@ -1003,8 +1003,8 @@ int __fscache_write_page(struct fscache_cookie *cookie,
 
 	spin_unlock(&cookie->lock);
 	radix_tree_preload_end();
-	fscache_stat(&fscache_n_store_ops);
-	fscache_stat(&fscache_n_stores_ok);
+	fscache_stat_wrap(&fscache_n_store_ops);
+	fscache_stat_wrap(&fscache_n_stores_ok);
 
 	/* the work queue now carries its own ref on the object */
 	fscache_put_operation(&op->op);
@@ -1012,14 +1012,14 @@ int __fscache_write_page(struct fscache_cookie *cookie,
 	return 0;
 
 already_queued:
-	fscache_stat(&fscache_n_stores_again);
+	fscache_stat_wrap(&fscache_n_stores_again);
 already_pending:
 	spin_unlock(&cookie->stores_lock);
 	spin_unlock(&object->lock);
 	spin_unlock(&cookie->lock);
 	radix_tree_preload_end();
 	fscache_put_operation(&op->op);
-	fscache_stat(&fscache_n_stores_ok);
+	fscache_stat_wrap(&fscache_n_stores_ok);
 	_leave(" = 0");
 	return 0;
 
@@ -1041,14 +1041,14 @@ int __fscache_write_page(struct fscache_cookie *cookie,
 	fscache_put_operation(&op->op);
 	if (wake_cookie)
 		__fscache_wake_unused_cookie(cookie);
-	fscache_stat(&fscache_n_stores_nobufs);
+	fscache_stat_wrap(&fscache_n_stores_nobufs);
 	_leave(" = -ENOBUFS");
 	return -ENOBUFS;
 
 nomem_free:
 	fscache_put_operation(&op->op);
 nomem:
-	fscache_stat(&fscache_n_stores_oom);
+	fscache_stat_wrap(&fscache_n_stores_oom);
 	_leave(" = -ENOMEM");
 	return -ENOMEM;
 }
@@ -1066,7 +1066,7 @@ void __fscache_uncache_page(struct fscache_cookie *cookie, struct page *page)
 	ASSERTCMP(cookie->def->type, !=, FSCACHE_COOKIE_TYPE_INDEX);
 	ASSERTCMP(page, !=, NULL);
 
-	fscache_stat(&fscache_n_uncaches);
+	fscache_stat_wrap(&fscache_n_uncaches);
 
 	/* cache withdrawal may beat us to it */
 	if (!PageFsCache(page))
@@ -1117,7 +1117,7 @@ void fscache_mark_page_cached(struct fscache_retrieval *op, struct page *page)
 	struct fscache_cookie *cookie = op->op.object->cookie;
 
 #ifdef CONFIG_FSCACHE_STATS
-	atomic_inc(&fscache_n_marks);
+	atomic_inc_wrap(&fscache_n_marks);
 #endif
 
 	_debug("- mark %p{%lx}", page, page->index);
diff --git a/fs/fscache/stats.c b/fs/fscache/stats.c
index 7ac6e83..29a983e 100644
--- a/fs/fscache/stats.c
+++ b/fs/fscache/stats.c
@@ -18,100 +18,100 @@
 /*
  * operation counters
  */
-atomic_t fscache_n_op_pend;
-atomic_t fscache_n_op_run;
-atomic_t fscache_n_op_enqueue;
-atomic_t fscache_n_op_requeue;
-atomic_t fscache_n_op_deferred_release;
-atomic_t fscache_n_op_initialised;
-atomic_t fscache_n_op_release;
-atomic_t fscache_n_op_gc;
-atomic_t fscache_n_op_cancelled;
-atomic_t fscache_n_op_rejected;
-
-atomic_t fscache_n_attr_changed;
-atomic_t fscache_n_attr_changed_ok;
-atomic_t fscache_n_attr_changed_nobufs;
-atomic_t fscache_n_attr_changed_nomem;
-atomic_t fscache_n_attr_changed_calls;
-
-atomic_t fscache_n_allocs;
-atomic_t fscache_n_allocs_ok;
-atomic_t fscache_n_allocs_wait;
-atomic_t fscache_n_allocs_nobufs;
-atomic_t fscache_n_allocs_intr;
-atomic_t fscache_n_allocs_object_dead;
-atomic_t fscache_n_alloc_ops;
-atomic_t fscache_n_alloc_op_waits;
-
-atomic_t fscache_n_retrievals;
-atomic_t fscache_n_retrievals_ok;
-atomic_t fscache_n_retrievals_wait;
-atomic_t fscache_n_retrievals_nodata;
-atomic_t fscache_n_retrievals_nobufs;
-atomic_t fscache_n_retrievals_intr;
-atomic_t fscache_n_retrievals_nomem;
-atomic_t fscache_n_retrievals_object_dead;
-atomic_t fscache_n_retrieval_ops;
-atomic_t fscache_n_retrieval_op_waits;
-
-atomic_t fscache_n_stores;
-atomic_t fscache_n_stores_ok;
-atomic_t fscache_n_stores_again;
-atomic_t fscache_n_stores_nobufs;
-atomic_t fscache_n_stores_oom;
-atomic_t fscache_n_store_ops;
-atomic_t fscache_n_store_calls;
-atomic_t fscache_n_store_pages;
-atomic_t fscache_n_store_radix_deletes;
-atomic_t fscache_n_store_pages_over_limit;
-
-atomic_t fscache_n_store_vmscan_not_storing;
-atomic_t fscache_n_store_vmscan_gone;
-atomic_t fscache_n_store_vmscan_busy;
-atomic_t fscache_n_store_vmscan_cancelled;
-atomic_t fscache_n_store_vmscan_wait;
-
-atomic_t fscache_n_marks;
-atomic_t fscache_n_uncaches;
-
-atomic_t fscache_n_acquires;
-atomic_t fscache_n_acquires_null;
-atomic_t fscache_n_acquires_no_cache;
-atomic_t fscache_n_acquires_ok;
-atomic_t fscache_n_acquires_nobufs;
-atomic_t fscache_n_acquires_oom;
-
-atomic_t fscache_n_invalidates;
-atomic_t fscache_n_invalidates_run;
-
-atomic_t fscache_n_updates;
-atomic_t fscache_n_updates_null;
-atomic_t fscache_n_updates_run;
-
-atomic_t fscache_n_relinquishes;
-atomic_t fscache_n_relinquishes_null;
-atomic_t fscache_n_relinquishes_waitcrt;
-atomic_t fscache_n_relinquishes_retire;
-
-atomic_t fscache_n_cookie_index;
-atomic_t fscache_n_cookie_data;
-atomic_t fscache_n_cookie_special;
-
-atomic_t fscache_n_object_alloc;
-atomic_t fscache_n_object_no_alloc;
-atomic_t fscache_n_object_lookups;
-atomic_t fscache_n_object_lookups_negative;
-atomic_t fscache_n_object_lookups_positive;
-atomic_t fscache_n_object_lookups_timed_out;
-atomic_t fscache_n_object_created;
-atomic_t fscache_n_object_avail;
-atomic_t fscache_n_object_dead;
-
-atomic_t fscache_n_checkaux_none;
-atomic_t fscache_n_checkaux_okay;
-atomic_t fscache_n_checkaux_update;
-atomic_t fscache_n_checkaux_obsolete;
+atomic_wrap_t fscache_n_op_pend;
+atomic_wrap_t fscache_n_op_run;
+atomic_wrap_t fscache_n_op_enqueue;
+atomic_wrap_t fscache_n_op_requeue;
+atomic_wrap_t fscache_n_op_deferred_release;
+atomic_wrap_t fscache_n_op_initialised;
+atomic_wrap_t fscache_n_op_release;
+atomic_wrap_t fscache_n_op_gc;
+atomic_wrap_t fscache_n_op_cancelled;
+atomic_wrap_t fscache_n_op_rejected;
+
+atomic_wrap_t fscache_n_attr_changed;
+atomic_wrap_t fscache_n_attr_changed_ok;
+atomic_wrap_t fscache_n_attr_changed_nobufs;
+atomic_wrap_t fscache_n_attr_changed_nomem;
+atomic_wrap_t fscache_n_attr_changed_calls;
+
+atomic_wrap_t fscache_n_allocs;
+atomic_wrap_t fscache_n_allocs_ok;
+atomic_wrap_t fscache_n_allocs_wait;
+atomic_wrap_t fscache_n_allocs_nobufs;
+atomic_wrap_t fscache_n_allocs_intr;
+atomic_wrap_t fscache_n_allocs_object_dead;
+atomic_wrap_t fscache_n_alloc_ops;
+atomic_wrap_t fscache_n_alloc_op_waits;
+
+atomic_wrap_t fscache_n_retrievals;
+atomic_wrap_t fscache_n_retrievals_ok;
+atomic_wrap_t fscache_n_retrievals_wait;
+atomic_wrap_t fscache_n_retrievals_nodata;
+atomic_wrap_t fscache_n_retrievals_nobufs;
+atomic_wrap_t fscache_n_retrievals_intr;
+atomic_wrap_t fscache_n_retrievals_nomem;
+atomic_wrap_t fscache_n_retrievals_object_dead;
+atomic_wrap_t fscache_n_retrieval_ops;
+atomic_wrap_t fscache_n_retrieval_op_waits;
+
+atomic_wrap_t fscache_n_stores;
+atomic_wrap_t fscache_n_stores_ok;
+atomic_wrap_t fscache_n_stores_again;
+atomic_wrap_t fscache_n_stores_nobufs;
+atomic_wrap_t fscache_n_stores_oom;
+atomic_wrap_t fscache_n_store_ops;
+atomic_wrap_t fscache_n_store_calls;
+atomic_wrap_t fscache_n_store_pages;
+atomic_wrap_t fscache_n_store_radix_deletes;
+atomic_wrap_t fscache_n_store_pages_over_limit;
+
+atomic_wrap_t fscache_n_store_vmscan_not_storing;
+atomic_wrap_t fscache_n_store_vmscan_gone;
+atomic_wrap_t fscache_n_store_vmscan_busy;
+atomic_wrap_t fscache_n_store_vmscan_cancelled;
+atomic_wrap_t fscache_n_store_vmscan_wait;
+
+atomic_wrap_t fscache_n_marks;
+atomic_wrap_t fscache_n_uncaches;
+
+atomic_wrap_t fscache_n_acquires;
+atomic_wrap_t fscache_n_acquires_null;
+atomic_wrap_t fscache_n_acquires_no_cache;
+atomic_wrap_t fscache_n_acquires_ok;
+atomic_wrap_t fscache_n_acquires_nobufs;
+atomic_wrap_t fscache_n_acquires_oom;
+
+atomic_wrap_t fscache_n_invalidates;
+atomic_wrap_t fscache_n_invalidates_run;
+
+atomic_wrap_t fscache_n_updates;
+atomic_wrap_t fscache_n_updates_null;
+atomic_wrap_t fscache_n_updates_run;
+
+atomic_wrap_t fscache_n_relinquishes;
+atomic_wrap_t fscache_n_relinquishes_null;
+atomic_wrap_t fscache_n_relinquishes_waitcrt;
+atomic_wrap_t fscache_n_relinquishes_retire;
+
+atomic_wrap_t fscache_n_cookie_index;
+atomic_wrap_t fscache_n_cookie_data;
+atomic_wrap_t fscache_n_cookie_special;
+
+atomic_wrap_t fscache_n_object_alloc;
+atomic_wrap_t fscache_n_object_no_alloc;
+atomic_wrap_t fscache_n_object_lookups;
+atomic_wrap_t fscache_n_object_lookups_negative;
+atomic_wrap_t fscache_n_object_lookups_positive;
+atomic_wrap_t fscache_n_object_lookups_timed_out;
+atomic_wrap_t fscache_n_object_created;
+atomic_wrap_t fscache_n_object_avail;
+atomic_wrap_t fscache_n_object_dead;
+
+atomic_wrap_t fscache_n_checkaux_none;
+atomic_wrap_t fscache_n_checkaux_okay;
+atomic_wrap_t fscache_n_checkaux_update;
+atomic_wrap_t fscache_n_checkaux_obsolete;
 
 atomic_t fscache_n_cop_alloc_object;
 atomic_t fscache_n_cop_lookup_object;
@@ -144,119 +144,119 @@ static int fscache_stats_show(struct seq_file *m, void *v)
 	seq_puts(m, "FS-Cache statistics\n");
 
 	seq_printf(m, "Cookies: idx=%u dat=%u spc=%u\n",
-		   atomic_read(&fscache_n_cookie_index),
-		   atomic_read(&fscache_n_cookie_data),
-		   atomic_read(&fscache_n_cookie_special));
+		   atomic_read_wrap(&fscache_n_cookie_index),
+		   atomic_read_wrap(&fscache_n_cookie_data),
+		   atomic_read_wrap(&fscache_n_cookie_special));
 
 	seq_printf(m, "Objects: alc=%u nal=%u avl=%u ded=%u\n",
-		   atomic_read(&fscache_n_object_alloc),
-		   atomic_read(&fscache_n_object_no_alloc),
-		   atomic_read(&fscache_n_object_avail),
-		   atomic_read(&fscache_n_object_dead));
+		   atomic_read_wrap(&fscache_n_object_alloc),
+		   atomic_read_wrap(&fscache_n_object_no_alloc),
+		   atomic_read_wrap(&fscache_n_object_avail),
+		   atomic_read_wrap(&fscache_n_object_dead));
 	seq_printf(m, "ChkAux : non=%u ok=%u upd=%u obs=%u\n",
-		   atomic_read(&fscache_n_checkaux_none),
-		   atomic_read(&fscache_n_checkaux_okay),
-		   atomic_read(&fscache_n_checkaux_update),
-		   atomic_read(&fscache_n_checkaux_obsolete));
+		   atomic_read_wrap(&fscache_n_checkaux_none),
+		   atomic_read_wrap(&fscache_n_checkaux_okay),
+		   atomic_read_wrap(&fscache_n_checkaux_update),
+		   atomic_read_wrap(&fscache_n_checkaux_obsolete));
 
 	seq_printf(m, "Pages  : mrk=%u unc=%u\n",
-		   atomic_read(&fscache_n_marks),
-		   atomic_read(&fscache_n_uncaches));
+		   atomic_read_wrap(&fscache_n_marks),
+		   atomic_read_wrap(&fscache_n_uncaches));
 
 	seq_printf(m, "Acquire: n=%u nul=%u noc=%u ok=%u nbf=%u"
 		   " oom=%u\n",
-		   atomic_read(&fscache_n_acquires),
-		   atomic_read(&fscache_n_acquires_null),
-		   atomic_read(&fscache_n_acquires_no_cache),
-		   atomic_read(&fscache_n_acquires_ok),
-		   atomic_read(&fscache_n_acquires_nobufs),
-		   atomic_read(&fscache_n_acquires_oom));
+		   atomic_read_wrap(&fscache_n_acquires),
+		   atomic_read_wrap(&fscache_n_acquires_null),
+		   atomic_read_wrap(&fscache_n_acquires_no_cache),
+		   atomic_read_wrap(&fscache_n_acquires_ok),
+		   atomic_read_wrap(&fscache_n_acquires_nobufs),
+		   atomic_read_wrap(&fscache_n_acquires_oom));
 
 	seq_printf(m, "Lookups: n=%u neg=%u pos=%u crt=%u tmo=%u\n",
-		   atomic_read(&fscache_n_object_lookups),
-		   atomic_read(&fscache_n_object_lookups_negative),
-		   atomic_read(&fscache_n_object_lookups_positive),
-		   atomic_read(&fscache_n_object_created),
-		   atomic_read(&fscache_n_object_lookups_timed_out));
+		   atomic_read_wrap(&fscache_n_object_lookups),
+		   atomic_read_wrap(&fscache_n_object_lookups_negative),
+		   atomic_read_wrap(&fscache_n_object_lookups_positive),
+		   atomic_read_wrap(&fscache_n_object_created),
+		   atomic_read_wrap(&fscache_n_object_lookups_timed_out));
 
 	seq_printf(m, "Invals : n=%u run=%u\n",
-		   atomic_read(&fscache_n_invalidates),
-		   atomic_read(&fscache_n_invalidates_run));
+		   atomic_read_wrap(&fscache_n_invalidates),
+		   atomic_read_wrap(&fscache_n_invalidates_run));
 
 	seq_printf(m, "Updates: n=%u nul=%u run=%u\n",
-		   atomic_read(&fscache_n_updates),
-		   atomic_read(&fscache_n_updates_null),
-		   atomic_read(&fscache_n_updates_run));
+		   atomic_read_wrap(&fscache_n_updates),
+		   atomic_read_wrap(&fscache_n_updates_null),
+		   atomic_read_wrap(&fscache_n_updates_run));
 
 	seq_printf(m, "Relinqs: n=%u nul=%u wcr=%u rtr=%u\n",
-		   atomic_read(&fscache_n_relinquishes),
-		   atomic_read(&fscache_n_relinquishes_null),
-		   atomic_read(&fscache_n_relinquishes_waitcrt),
-		   atomic_read(&fscache_n_relinquishes_retire));
+		   atomic_read_wrap(&fscache_n_relinquishes),
+		   atomic_read_wrap(&fscache_n_relinquishes_null),
+		   atomic_read_wrap(&fscache_n_relinquishes_waitcrt),
+		   atomic_read_wrap(&fscache_n_relinquishes_retire));
 
 	seq_printf(m, "AttrChg: n=%u ok=%u nbf=%u oom=%u run=%u\n",
-		   atomic_read(&fscache_n_attr_changed),
-		   atomic_read(&fscache_n_attr_changed_ok),
-		   atomic_read(&fscache_n_attr_changed_nobufs),
-		   atomic_read(&fscache_n_attr_changed_nomem),
-		   atomic_read(&fscache_n_attr_changed_calls));
+		   atomic_read_wrap(&fscache_n_attr_changed),
+		   atomic_read_wrap(&fscache_n_attr_changed_ok),
+		   atomic_read_wrap(&fscache_n_attr_changed_nobufs),
+		   atomic_read_wrap(&fscache_n_attr_changed_nomem),
+		   atomic_read_wrap(&fscache_n_attr_changed_calls));
 
 	seq_printf(m, "Allocs : n=%u ok=%u wt=%u nbf=%u int=%u\n",
-		   atomic_read(&fscache_n_allocs),
-		   atomic_read(&fscache_n_allocs_ok),
-		   atomic_read(&fscache_n_allocs_wait),
-		   atomic_read(&fscache_n_allocs_nobufs),
-		   atomic_read(&fscache_n_allocs_intr));
+		   atomic_read_wrap(&fscache_n_allocs),
+		   atomic_read_wrap(&fscache_n_allocs_ok),
+		   atomic_read_wrap(&fscache_n_allocs_wait),
+		   atomic_read_wrap(&fscache_n_allocs_nobufs),
+		   atomic_read_wrap(&fscache_n_allocs_intr));
 	seq_printf(m, "Allocs : ops=%u owt=%u abt=%u\n",
-		   atomic_read(&fscache_n_alloc_ops),
-		   atomic_read(&fscache_n_alloc_op_waits),
-		   atomic_read(&fscache_n_allocs_object_dead));
+		   atomic_read_wrap(&fscache_n_alloc_ops),
+		   atomic_read_wrap(&fscache_n_alloc_op_waits),
+		   atomic_read_wrap(&fscache_n_allocs_object_dead));
 
 	seq_printf(m, "Retrvls: n=%u ok=%u wt=%u nod=%u nbf=%u"
 		   " int=%u oom=%u\n",
-		   atomic_read(&fscache_n_retrievals),
-		   atomic_read(&fscache_n_retrievals_ok),
-		   atomic_read(&fscache_n_retrievals_wait),
-		   atomic_read(&fscache_n_retrievals_nodata),
-		   atomic_read(&fscache_n_retrievals_nobufs),
-		   atomic_read(&fscache_n_retrievals_intr),
-		   atomic_read(&fscache_n_retrievals_nomem));
+		   atomic_read_wrap(&fscache_n_retrievals),
+		   atomic_read_wrap(&fscache_n_retrievals_ok),
+		   atomic_read_wrap(&fscache_n_retrievals_wait),
+		   atomic_read_wrap(&fscache_n_retrievals_nodata),
+		   atomic_read_wrap(&fscache_n_retrievals_nobufs),
+		   atomic_read_wrap(&fscache_n_retrievals_intr),
+		   atomic_read_wrap(&fscache_n_retrievals_nomem));
 	seq_printf(m, "Retrvls: ops=%u owt=%u abt=%u\n",
-		   atomic_read(&fscache_n_retrieval_ops),
-		   atomic_read(&fscache_n_retrieval_op_waits),
-		   atomic_read(&fscache_n_retrievals_object_dead));
+		   atomic_read_wrap(&fscache_n_retrieval_ops),
+		   atomic_read_wrap(&fscache_n_retrieval_op_waits),
+		   atomic_read_wrap(&fscache_n_retrievals_object_dead));
 
 	seq_printf(m, "Stores : n=%u ok=%u agn=%u nbf=%u oom=%u\n",
-		   atomic_read(&fscache_n_stores),
-		   atomic_read(&fscache_n_stores_ok),
-		   atomic_read(&fscache_n_stores_again),
-		   atomic_read(&fscache_n_stores_nobufs),
-		   atomic_read(&fscache_n_stores_oom));
+		   atomic_read_wrap(&fscache_n_stores),
+		   atomic_read_wrap(&fscache_n_stores_ok),
+		   atomic_read_wrap(&fscache_n_stores_again),
+		   atomic_read_wrap(&fscache_n_stores_nobufs),
+		   atomic_read_wrap(&fscache_n_stores_oom));
 	seq_printf(m, "Stores : ops=%u run=%u pgs=%u rxd=%u olm=%u\n",
-		   atomic_read(&fscache_n_store_ops),
-		   atomic_read(&fscache_n_store_calls),
-		   atomic_read(&fscache_n_store_pages),
-		   atomic_read(&fscache_n_store_radix_deletes),
-		   atomic_read(&fscache_n_store_pages_over_limit));
+		   atomic_read_wrap(&fscache_n_store_ops),
+		   atomic_read_wrap(&fscache_n_store_calls),
+		   atomic_read_wrap(&fscache_n_store_pages),
+		   atomic_read_wrap(&fscache_n_store_radix_deletes),
+		   atomic_read_wrap(&fscache_n_store_pages_over_limit));
 
 	seq_printf(m, "VmScan : nos=%u gon=%u bsy=%u can=%u wt=%u\n",
-		   atomic_read(&fscache_n_store_vmscan_not_storing),
-		   atomic_read(&fscache_n_store_vmscan_gone),
-		   atomic_read(&fscache_n_store_vmscan_busy),
-		   atomic_read(&fscache_n_store_vmscan_cancelled),
-		   atomic_read(&fscache_n_store_vmscan_wait));
+		   atomic_read_wrap(&fscache_n_store_vmscan_not_storing),
+		   atomic_read_wrap(&fscache_n_store_vmscan_gone),
+		   atomic_read_wrap(&fscache_n_store_vmscan_busy),
+		   atomic_read_wrap(&fscache_n_store_vmscan_cancelled),
+		   atomic_read_wrap(&fscache_n_store_vmscan_wait));
 
 	seq_printf(m, "Ops    : pend=%u run=%u enq=%u can=%u rej=%u\n",
-		   atomic_read(&fscache_n_op_pend),
-		   atomic_read(&fscache_n_op_run),
-		   atomic_read(&fscache_n_op_enqueue),
-		   atomic_read(&fscache_n_op_cancelled),
-		   atomic_read(&fscache_n_op_rejected));
+		   atomic_read_wrap(&fscache_n_op_pend),
+		   atomic_read_wrap(&fscache_n_op_run),
+		   atomic_read_wrap(&fscache_n_op_enqueue),
+		   atomic_read_wrap(&fscache_n_op_cancelled),
+		   atomic_read_wrap(&fscache_n_op_rejected));
 	seq_printf(m, "Ops    : ini=%u dfr=%u rel=%u gc=%u\n",
-		   atomic_read(&fscache_n_op_initialised),
-		   atomic_read(&fscache_n_op_deferred_release),
-		   atomic_read(&fscache_n_op_release),
-		   atomic_read(&fscache_n_op_gc));
+		   atomic_read_wrap(&fscache_n_op_initialised),
+		   atomic_read_wrap(&fscache_n_op_deferred_release),
+		   atomic_read_wrap(&fscache_n_op_release),
+		   atomic_read_wrap(&fscache_n_op_gc));
 
 	seq_printf(m, "CacheOp: alo=%d luo=%d luc=%d gro=%d\n",
 		   atomic_read(&fscache_n_cop_alloc_object),
diff --git a/fs/inode.c b/fs/inode.c
index 88110fd..46bf8ee1 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -857,8 +857,9 @@ unsigned int get_next_ino(void)
 
 #ifdef CONFIG_SMP
 	if (unlikely((res & (LAST_INO_BATCH-1)) == 0)) {
-		static atomic_t shared_last_ino;
-		int next = atomic_add_return(LAST_INO_BATCH, &shared_last_ino);
+		static atomic_wrap_t shared_last_ino;
+		int next = atomic_add_return_wrap(LAST_INO_BATCH,
+				&shared_last_ino);
 
 		res = next - LAST_INO_BATCH;
 	}
diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index 2bcb86e..5366020 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -34,7 +34,7 @@ static DEFINE_MUTEX(kernfs_open_file_mutex);
 
 struct kernfs_open_node {
 	atomic_t		refcnt;
-	atomic_t		event;
+	atomic_wrap_t		event;
 	wait_queue_head_t	poll;
 	struct list_head	files; /* goes through kernfs_open_file.list */
 };
@@ -163,7 +163,7 @@ static int kernfs_seq_show(struct seq_file *sf, void *v)
 {
 	struct kernfs_open_file *of = sf->private;
 
-	of->event = atomic_read(&of->kn->attr.open->event);
+	of->event = atomic_read_wrap(&of->kn->attr.open->event);
 
 	return of->kn->attr.ops->seq_show(sf, v);
 }
@@ -208,7 +208,7 @@ static ssize_t kernfs_file_direct_read(struct kernfs_open_file *of,
 		goto out_free;
 	}
 
-	of->event = atomic_read(&of->kn->attr.open->event);
+	of->event = atomic_read_wrap(&of->kn->attr.open->event);
 	ops = kernfs_ops(of->kn);
 	if (ops->read)
 		len = ops->read(of, buf, len, *ppos);
@@ -575,7 +575,7 @@ static int kernfs_get_open_node(struct kernfs_node *kn,
 		return -ENOMEM;
 
 	atomic_set(&new_on->refcnt, 0);
-	atomic_set(&new_on->event, 1);
+	atomic_set_wrap(&new_on->event, 1);
 	init_waitqueue_head(&new_on->poll);
 	INIT_LIST_HEAD(&new_on->files);
 	goto retry;
@@ -799,7 +799,7 @@ static unsigned int kernfs_fop_poll(struct file *filp, poll_table *wait)
 
 	kernfs_put_active(kn);
 
-	if (of->event != atomic_read(&on->event))
+	if (of->event != atomic_read_wrap(&on->event))
 		goto trigger;
 
 	return DEFAULT_POLLMASK;
@@ -830,7 +830,7 @@ static void kernfs_notify_workfn(struct work_struct *work)
 
 	on = kn->attr.open;
 	if (on) {
-		atomic_inc(&on->event);
+		atomic_inc_wrap(&on->event);
 		wake_up_interruptible(&on->poll);
 	}
 
diff --git a/fs/lockd/clntproc.c b/fs/lockd/clntproc.c
index 1129520..ca9d834 100644
--- a/fs/lockd/clntproc.c
+++ b/fs/lockd/clntproc.c
@@ -36,11 +36,11 @@ static const struct rpc_call_ops nlmclnt_cancel_ops;
 /*
  * Cookie counter for NLM requests
  */
-static atomic_t	nlm_cookie = ATOMIC_INIT(0x1234);
+static atomic_wrap_t	nlm_cookie = ATOMIC_INIT(0x1234);
 
 void nlmclnt_next_cookie(struct nlm_cookie *c)
 {
-	u32	cookie = atomic_inc_return(&nlm_cookie);
+	u32	cookie = atomic_inc_return_wrap(&nlm_cookie);
 
 	memcpy(c->data, &cookie, 4);
 	c->len=4;
diff --git a/fs/namespace.c b/fs/namespace.c
index e6c234b..5d205f9 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2787,7 +2787,7 @@ static void free_mnt_ns(struct mnt_namespace *ns)
  * number incrementing at 10Ghz will take 12,427 years to wrap which
  * is effectively never, so we can ignore the possibility.
  */
-static atomic64_t mnt_ns_seq = ATOMIC64_INIT(1);
+static atomic64_wrap_t mnt_ns_seq = ATOMIC64_INIT(1);
 
 static struct mnt_namespace *alloc_mnt_ns(struct user_namespace *user_ns)
 {
@@ -2811,7 +2811,7 @@ static struct mnt_namespace *alloc_mnt_ns(struct user_namespace *user_ns)
 		return ERR_PTR(ret);
 	}
 	new_ns->ns.ops = &mntns_operations;
-	new_ns->seq = atomic64_add_return(1, &mnt_ns_seq);
+	new_ns->seq = atomic64_add_return_wrap(1, &mnt_ns_seq);
 	atomic_set(&new_ns->count, 1);
 	new_ns->root = NULL;
 	INIT_LIST_HEAD(&new_ns->list);
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index bf4ec5e..0fc6dbb 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1323,16 +1323,16 @@ static int nfs_check_inode_attributes(struct inode *inode, struct nfs_fattr *fat
 	return 0;
 }
 
-static atomic_long_t nfs_attr_generation_counter;
+static atomic_long_wrap_t nfs_attr_generation_counter;
 
 static unsigned long nfs_read_attr_generation_counter(void)
 {
-	return atomic_long_read(&nfs_attr_generation_counter);
+	return atomic_long_read_wrap(&nfs_attr_generation_counter);
 }
 
 unsigned long nfs_inc_attr_generation_counter(void)
 {
-	return atomic_long_inc_return(&nfs_attr_generation_counter);
+	return atomic_long_inc_return_wrap(&nfs_attr_generation_counter);
 }
 EXPORT_SYMBOL_GPL(nfs_inc_attr_generation_counter);
 
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index 66f85c6..5425201 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -48,7 +48,7 @@
 #include <linux/fsnotify_backend.h>
 #include "fsnotify.h"
 
-static atomic_t fsnotify_sync_cookie = ATOMIC_INIT(0);
+static atomic_wrap_t fsnotify_sync_cookie = ATOMIC_INIT(0);
 
 /**
  * fsnotify_get_cookie - return a unique cookie for use in synchronizing events.
@@ -56,7 +56,7 @@ static atomic_t fsnotify_sync_cookie = ATOMIC_INIT(0);
  */
 u32 fsnotify_get_cookie(void)
 {
-	return atomic_inc_return(&fsnotify_sync_cookie);
+	return atomic_inc_return_wrap(&fsnotify_sync_cookie);
 }
 EXPORT_SYMBOL_GPL(fsnotify_get_cookie);
 
diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index fe0d1f9..7c39a40 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -1317,7 +1317,7 @@ static int ocfs2_local_alloc_slide_window(struct ocfs2_super *osb,
 		goto bail;
 	}
 
-	atomic_inc(&osb->alloc_stats.moves);
+	atomic_inc_wrap(&osb->alloc_stats.moves);
 
 bail:
 	if (handle)
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index e63af7d..4824fea 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -247,11 +247,11 @@ enum ocfs2_vol_state
 
 struct ocfs2_alloc_stats
 {
-	atomic_t moves;
-	atomic_t local_data;
-	atomic_t bitmap_data;
-	atomic_t bg_allocs;
-	atomic_t bg_extends;
+	atomic_wrap_t moves;
+	atomic_wrap_t local_data;
+	atomic_wrap_t bitmap_data;
+	atomic_wrap_t bg_allocs;
+	atomic_wrap_t bg_extends;
 };
 
 enum ocfs2_local_alloc_state
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 6ad3533..eeea79b 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -851,7 +851,7 @@ static int ocfs2_reserve_suballoc_bits(struct ocfs2_super *osb,
 				mlog_errno(status);
 			goto bail;
 		}
-		atomic_inc(&osb->alloc_stats.bg_extends);
+		atomic_inc_wrap(&osb->alloc_stats.bg_extends);
 
 		/* You should never ask for this much metadata */
 		BUG_ON(bits_wanted >
@@ -2026,7 +2026,7 @@ int ocfs2_claim_metadata(handle_t *handle,
 		mlog_errno(status);
 		goto bail;
 	}
-	atomic_inc(&OCFS2_SB(ac->ac_inode->i_sb)->alloc_stats.bg_allocs);
+	atomic_inc_wrap(&OCFS2_SB(ac->ac_inode->i_sb)->alloc_stats.bg_allocs);
 
 	*suballoc_loc = res.sr_bg_blkno;
 	*suballoc_bit_start = res.sr_bit_offset;
@@ -2192,7 +2192,7 @@ int ocfs2_claim_new_inode_at_loc(handle_t *handle,
 	trace_ocfs2_claim_new_inode_at_loc((unsigned long long)di_blkno,
 					   res->sr_bits);
 
-	atomic_inc(&OCFS2_SB(ac->ac_inode->i_sb)->alloc_stats.bg_allocs);
+	atomic_inc_wrap(&OCFS2_SB(ac->ac_inode->i_sb)->alloc_stats.bg_allocs);
 
 	BUG_ON(res->sr_bits != 1);
 
@@ -2234,7 +2234,7 @@ int ocfs2_claim_new_inode(handle_t *handle,
 		mlog_errno(status);
 		goto bail;
 	}
-	atomic_inc(&OCFS2_SB(ac->ac_inode->i_sb)->alloc_stats.bg_allocs);
+	atomic_inc_wrap(&OCFS2_SB(ac->ac_inode->i_sb)->alloc_stats.bg_allocs);
 
 	BUG_ON(res.sr_bits != 1);
 
@@ -2338,7 +2338,7 @@ int __ocfs2_claim_clusters(handle_t *handle,
 						      cluster_start,
 						      num_clusters);
 		if (!status)
-			atomic_inc(&osb->alloc_stats.local_data);
+			atomic_inc_wrap(&osb->alloc_stats.local_data);
 	} else {
 		if (min_clusters > (osb->bitmap_cpg - 1)) {
 			/* The only paths asking for contiguousness
@@ -2364,7 +2364,7 @@ int __ocfs2_claim_clusters(handle_t *handle,
 				ocfs2_desc_bitmap_to_cluster_off(ac->ac_inode,
 								 res.sr_bg_blkno,
 								 res.sr_bit_offset);
-			atomic_inc(&osb->alloc_stats.bitmap_data);
+			atomic_inc_wrap(&osb->alloc_stats.bitmap_data);
 			*num_clusters = res.sr_bits;
 		}
 	}
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index f56fe39..8ad149b 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -306,11 +306,11 @@ static int ocfs2_osb_dump(struct ocfs2_super *osb, char *buf, int len)
 			"%10s => GlobalAllocs: %d  LocalAllocs: %d  "
 			"SubAllocs: %d  LAWinMoves: %d  SAExtends: %d\n",
 			"Stats",
-			atomic_read(&osb->alloc_stats.bitmap_data),
-			atomic_read(&osb->alloc_stats.local_data),
-			atomic_read(&osb->alloc_stats.bg_allocs),
-			atomic_read(&osb->alloc_stats.moves),
-			atomic_read(&osb->alloc_stats.bg_extends));
+			atomic_read_wrap(&osb->alloc_stats.bitmap_data),
+			atomic_read_wrap(&osb->alloc_stats.local_data),
+			atomic_read_wrap(&osb->alloc_stats.bg_allocs),
+			atomic_read_wrap(&osb->alloc_stats.moves),
+			atomic_read_wrap(&osb->alloc_stats.bg_extends));
 
 	out += snprintf(buf + out, len - out,
 			"%10s => State: %u  Descriptor: %llu  Size: %u bits  "
@@ -2087,11 +2087,11 @@ static int ocfs2_initialize_super(struct super_block *sb,
 
 	mutex_init(&osb->system_file_mutex);
 
-	atomic_set(&osb->alloc_stats.moves, 0);
-	atomic_set(&osb->alloc_stats.local_data, 0);
-	atomic_set(&osb->alloc_stats.bitmap_data, 0);
-	atomic_set(&osb->alloc_stats.bg_allocs, 0);
-	atomic_set(&osb->alloc_stats.bg_extends, 0);
+	atomic_set_wrap(&osb->alloc_stats.moves, 0);
+	atomic_set_wrap(&osb->alloc_stats.local_data, 0);
+	atomic_set_wrap(&osb->alloc_stats.bitmap_data, 0);
+	atomic_set_wrap(&osb->alloc_stats.bg_allocs, 0);
+	atomic_set_wrap(&osb->alloc_stats.bg_extends, 0);
 
 	/* Copy the blockcheck stats from the superblock probe */
 	osb->osb_ecc_stats = *stats;
diff --git a/fs/quota/netlink.c b/fs/quota/netlink.c
index 8b25267..719a02b 100644
--- a/fs/quota/netlink.c
+++ b/fs/quota/netlink.c
@@ -42,7 +42,7 @@ static struct genl_family quota_genl_family = {
 void quota_send_warning(struct kqid qid, dev_t dev,
 			const char warntype)
 {
-	static atomic_t seq;
+	static atomic_wrap_t seq;
 	struct sk_buff *skb;
 	void *msg_head;
 	int ret;
@@ -58,7 +58,7 @@ void quota_send_warning(struct kqid qid, dev_t dev,
 		  "VFS: Not enough memory to send quota warning.\n");
 		return;
 	}
-	msg_head = genlmsg_put(skb, 0, atomic_add_return(1, &seq),
+	msg_head = genlmsg_put(skb, 0, atomic_add_return_wrap(1, &seq),
 			&quota_genl_family, 0, QUOTA_NL_C_WARNING);
 	if (!msg_head) {
 		printk(KERN_ERR
diff --git a/fs/reiserfs/do_balan.c b/fs/reiserfs/do_balan.c
index 9c02d96..be87c96 100644
--- a/fs/reiserfs/do_balan.c
+++ b/fs/reiserfs/do_balan.c
@@ -1887,7 +1887,7 @@ void do_balance(struct tree_balance *tb, struct item_head *ih,
 		return;
 	}
 
-	atomic_inc(&fs_generation(tb->tb_sb));
+	atomic_inc_wrap(&fs_generation(tb->tb_sb));
 	do_balance_starts(tb);
 
 	/*
diff --git a/fs/reiserfs/procfs.c b/fs/reiserfs/procfs.c
index fe99915..5c1d84f 100644
--- a/fs/reiserfs/procfs.c
+++ b/fs/reiserfs/procfs.c
@@ -114,7 +114,7 @@ static int show_super(struct seq_file *m, void *unused)
 		   "SMALL_TAILS " : "NO_TAILS ",
 		   replay_only(sb) ? "REPLAY_ONLY " : "",
 		   convert_reiserfs(sb) ? "CONV " : "",
-		   atomic_read(&r->s_generation_counter),
+		   atomic_read_wrap(&r->s_generation_counter),
 		   SF(s_disk_reads), SF(s_disk_writes), SF(s_fix_nodes),
 		   SF(s_do_balance), SF(s_unneeded_left_neighbor),
 		   SF(s_good_search_by_key_reada), SF(s_bmaps),
diff --git a/fs/reiserfs/reiserfs.h b/fs/reiserfs/reiserfs.h
index 2adcde1..ab90b7d 100644
--- a/fs/reiserfs/reiserfs.h
+++ b/fs/reiserfs/reiserfs.h
@@ -580,7 +580,7 @@ struct reiserfs_sb_info {
 	/* Comment? -Hans */
 	wait_queue_head_t s_wait;
 	/* increased by one every time the  tree gets re-balanced */
-	atomic_t s_generation_counter;
+	atomic_wrap_t s_generation_counter;
 
 	/* File system properties. Currently holds on-disk FS format */
 	unsigned long s_properties;
@@ -2300,7 +2300,7 @@ static inline loff_t max_reiserfs_offset(struct inode *inode)
 #define REISERFS_USER_MEM		1	/* user memory mode */
 
 #define fs_generation(s) (REISERFS_SB(s)->s_generation_counter)
-#define get_generation(s) atomic_read (&fs_generation(s))
+#define get_generation(s) atomic_read_wrap(&fs_generation(s))
 #define FILESYSTEM_CHANGED_TB(tb)  (get_generation((tb)->tb_sb) != (tb)->fs_gen)
 #define __fs_changed(gen,s) (gen != get_generation (s))
 #define fs_changed(gen,s)		\
diff --git a/include/linux/fscache-cache.h b/include/linux/fscache-cache.h
index 13ba552..afae1f7 100644
--- a/include/linux/fscache-cache.h
+++ b/include/linux/fscache-cache.h
@@ -117,7 +117,7 @@ struct fscache_operation {
 	fscache_operation_release_t release;
 };
 
-extern atomic_t fscache_op_debug_id;
+extern atomic_wrap_t fscache_op_debug_id;
 extern void fscache_op_work_func(struct work_struct *work);
 
 extern void fscache_enqueue_operation(struct fscache_operation *);
-- 
2.7.4
