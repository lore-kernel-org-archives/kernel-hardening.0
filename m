Reply-To: kernel-hardening@lists.openwall.com
From: David Windsor <dave@progbits.org>
Date: Thu, 17 Dec 2015 09:57:43 -0500
Message-Id: <1450364270-12687-6-git-send-email-dave@progbits.org>
In-Reply-To: <1450364270-12687-1-git-send-email-dave@progbits.org>
References: <1450364270-12687-1-git-send-email-dave@progbits.org>
Subject: [kernel-hardening][RFC PATCH v2 05/12] fs: opt out of PAX_REFCOUNT protection
To: kernel-hardening@lists.openwall.com
Cc: David Windsor <dave@progbits.org>
List-ID: <kernel-hardening.lists.openwall.com>

Signed-off-by: David Windsor <dave@progbits.org>
---
 fs/afs/inode.c                |   4 +-
 fs/btrfs/delayed-inode.c      |   6 +-
 fs/btrfs/delayed-inode.h      |   4 +-
 fs/cachefiles/internal.h      |  12 +-
 fs/cachefiles/namei.c         |   2 +-
 fs/cachefiles/proc.c          |  12 +-
 fs/ceph/super.c               |   4 +-
 fs/cifs/cifs_debug.c          |  12 +-
 fs/cifs/cifsfs.c              |   4 +-
 fs/cifs/cifsglob.h            |  54 +++----
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
 fs/inode.c                    |   4 +-
 fs/kernfs/file.c              |  12 +-
 fs/lockd/clntproc.c           |   4 +-
 fs/namespace.c                |   4 +-
 fs/nfs/inode.c                |   6 +-
 fs/notify/notification.c      |   4 +-
 fs/ocfs2/localalloc.c         |   2 +-
 fs/ocfs2/ocfs2.h              |  10 +-
 fs/ocfs2/suballoc.c           |  12 +-
 fs/ocfs2/super.c              |  20 +--
 fs/proc/meminfo.c             |   2 +-
 fs/quota/netlink.c            |   4 +-
 fs/reiserfs/do_balan.c        |   2 +-
 fs/reiserfs/procfs.c          |   2 +-
 fs/reiserfs/reiserfs.h        |   4 +-
 include/linux/fscache-cache.h |   2 +-
 39 files changed, 613 insertions(+), 607 deletions(-)

diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index e06f5a2..81d07ac 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -141,7 +141,7 @@ struct inode *afs_iget_autocell(struct inode *dir, const char *dev_name,
 	struct afs_vnode *vnode;
 	struct super_block *sb;
 	struct inode *inode;
-	static atomic_t afs_autocell_ino;
+	static atomic_unchecked_t afs_autocell_ino;
 
 	_enter("{%x:%u},%*.*s,",
 	       AFS_FS_I(dir)->fid.vid, AFS_FS_I(dir)->fid.vnode,
@@ -154,7 +154,7 @@ struct inode *afs_iget_autocell(struct inode *dir, const char *dev_name,
 	data.fid.unique = 0;
 	data.fid.vnode = 0;
 
-	inode = iget5_locked(sb, atomic_inc_return(&afs_autocell_ino),
+	inode = iget5_locked(sb, atomic_inc_return_unchecked(&afs_autocell_ino),
 			     afs_iget5_autocell_test, afs_iget5_set,
 			     &data);
 	if (!inode) {
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index a2ae427..53c2e98 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -462,7 +462,7 @@ static int __btrfs_add_delayed_deletion_item(struct btrfs_delayed_node *node,
 
 static void finish_one_item(struct btrfs_delayed_root *delayed_root)
 {
-	int seq = atomic_inc_return(&delayed_root->items_seq);
+	int seq = atomic_inc_return_unchecked(&delayed_root->items_seq);
 	if ((atomic_dec_return(&delayed_root->items) <
 	    BTRFS_DELAYED_BACKGROUND || seq % BTRFS_DELAYED_BATCH == 0) &&
 	    waitqueue_active(&delayed_root->wait))
@@ -1412,7 +1412,7 @@ void btrfs_assert_delayed_root_empty(struct btrfs_root *root)
 
 static int could_end_wait(struct btrfs_delayed_root *delayed_root, int seq)
 {
-	int val = atomic_read(&delayed_root->items_seq);
+	int val = atomic_read_unchecked(&delayed_root->items_seq);
 
 	if (val < seq || val >= seq + BTRFS_DELAYED_BATCH)
 		return 1;
@@ -1437,7 +1437,7 @@ void btrfs_balance_delayed_items(struct btrfs_root *root)
 		int seq;
 		int ret;
 
-		seq = atomic_read(&delayed_root->items_seq);
+		seq = atomic_read_unchecked(&delayed_root->items_seq);
 
 		ret = btrfs_wq_run_delayed_node(delayed_root, fs_info, 0);
 		if (ret)
diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
index f70119f..ab5894d 100644
--- a/fs/btrfs/delayed-inode.h
+++ b/fs/btrfs/delayed-inode.h
@@ -43,7 +43,7 @@ struct btrfs_delayed_root {
 	 */
 	struct list_head prepare_list;
 	atomic_t items;		/* for delayed items */
-	atomic_t items_seq;	/* for delayed items */
+	atomic_unchecked_t items_seq;	/* for delayed items */
 	int nodes;		/* for delayed nodes */
 	wait_queue_head_t wait;
 };
@@ -90,7 +90,7 @@ static inline void btrfs_init_delayed_root(
 				struct btrfs_delayed_root *delayed_root)
 {
 	atomic_set(&delayed_root->items, 0);
-	atomic_set(&delayed_root->items_seq, 0);
+	atomic_set_unchecked(&delayed_root->items_seq, 0);
 	delayed_root->nodes = 0;
 	spin_lock_init(&delayed_root->lock);
 	init_waitqueue_head(&delayed_root->wait);
diff --git a/fs/cachefiles/internal.h b/fs/cachefiles/internal.h
index aecd085..3584e2f 100644
--- a/fs/cachefiles/internal.h
+++ b/fs/cachefiles/internal.h
@@ -65,7 +65,7 @@ struct cachefiles_cache {
 	wait_queue_head_t		daemon_pollwq;	/* poll waitqueue for daemon */
 	struct rb_root			active_nodes;	/* active nodes (can't be culled) */
 	rwlock_t			active_lock;	/* lock for active_nodes */
-	atomic_t			gravecounter;	/* graveyard uniquifier */
+	atomic_unchecked_t		gravecounter;	/* graveyard uniquifier */
 	unsigned			frun_percent;	/* when to stop culling (% files) */
 	unsigned			fcull_percent;	/* when to start culling (% files) */
 	unsigned			fstop_percent;	/* when to stop allocating (% files) */
@@ -177,19 +177,19 @@ extern int cachefiles_check_in_use(struct cachefiles_cache *cache,
  * proc.c
  */
 #ifdef CONFIG_CACHEFILES_HISTOGRAM
-extern atomic_t cachefiles_lookup_histogram[HZ];
-extern atomic_t cachefiles_mkdir_histogram[HZ];
-extern atomic_t cachefiles_create_histogram[HZ];
+extern atomic_unchecked_t cachefiles_lookup_histogram[HZ];
+extern atomic_unchecked_t cachefiles_mkdir_histogram[HZ];
+extern atomic_unchecked_t cachefiles_create_histogram[HZ];
 
 extern int __init cachefiles_proc_init(void);
 extern void cachefiles_proc_cleanup(void);
 static inline
-void cachefiles_hist(atomic_t histogram[], unsigned long start_jif)
+void cachefiles_hist(atomic_unchecked_t histogram[], unsigned long start_jif)
 {
 	unsigned long jif = jiffies - start_jif;
 	if (jif >= HZ)
 		jif = HZ - 1;
-	atomic_inc(&histogram[jif]);
+	atomic_inc_unchecked(&histogram[jif]);
 }
 
 #else
diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index fc1056f..501a546 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -312,7 +312,7 @@ try_again:
 	/* first step is to make up a grave dentry in the graveyard */
 	sprintf(nbuffer, "%08x%08x",
 		(uint32_t) get_seconds(),
-		(uint32_t) atomic_inc_return(&cache->gravecounter));
+		(uint32_t) atomic_inc_return_unchecked(&cache->gravecounter));
 
 	/* do the multiway lock magic */
 	trap = lock_rename(cache->graveyard, dir);
diff --git a/fs/cachefiles/proc.c b/fs/cachefiles/proc.c
index eccd339..4c1d995 100644
--- a/fs/cachefiles/proc.c
+++ b/fs/cachefiles/proc.c
@@ -14,9 +14,9 @@
 #include <linux/seq_file.h>
 #include "internal.h"
 
-atomic_t cachefiles_lookup_histogram[HZ];
-atomic_t cachefiles_mkdir_histogram[HZ];
-atomic_t cachefiles_create_histogram[HZ];
+atomic_unchecked_t cachefiles_lookup_histogram[HZ];
+atomic_unchecked_t cachefiles_mkdir_histogram[HZ];
+atomic_unchecked_t cachefiles_create_histogram[HZ];
 
 /*
  * display the latency histogram
@@ -35,9 +35,9 @@ static int cachefiles_histogram_show(struct seq_file *m, void *v)
 		return 0;
 	default:
 		index = (unsigned long) v - 3;
-		x = atomic_read(&cachefiles_lookup_histogram[index]);
-		y = atomic_read(&cachefiles_mkdir_histogram[index]);
-		z = atomic_read(&cachefiles_create_histogram[index]);
+		x = atomic_read_unchecked(&cachefiles_lookup_histogram[index]);
+		y = atomic_read_unchecked(&cachefiles_mkdir_histogram[index]);
+		z = atomic_read_unchecked(&cachefiles_create_histogram[index]);
 		if (x == 0 && y == 0 && z == 0)
 			return 0;
 
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 7b6bfcb..f8d5416 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -906,7 +906,7 @@ static int ceph_compare_super(struct super_block *sb, void *data)
 /*
  * construct our own bdi so we can control readahead, etc.
  */
-static atomic_long_t bdi_seq = ATOMIC_LONG_INIT(0);
+static atomic_long_unchecked_t bdi_seq = ATOMIC_LONG_INIT(0);
 
 static int ceph_register_bdi(struct super_block *sb,
 			     struct ceph_fs_client *fsc)
@@ -923,7 +923,7 @@ static int ceph_register_bdi(struct super_block *sb,
 			VM_MAX_READAHEAD * 1024 / PAGE_CACHE_SIZE;
 
 	err = bdi_register(&fsc->backing_dev_info, NULL, "ceph-%ld",
-			   atomic_long_inc_return(&bdi_seq));
+			   atomic_long_inc_return_unchecked(&bdi_seq));
 	if (!err)
 		sb->s_bdi = &fsc->backing_dev_info;
 	return err;
diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 7febcf2..62a5721 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -269,8 +269,8 @@ static ssize_t cifs_stats_proc_write(struct file *file,
 
 	if (strtobool(&c, &bv) == 0) {
 #ifdef CONFIG_CIFS_STATS2
-		atomic_set(&totBufAllocCount, 0);
-		atomic_set(&totSmBufAllocCount, 0);
+		atomic_set_unchecked(&totBufAllocCount, 0);
+		atomic_set_unchecked(&totSmBufAllocCount, 0);
 #endif /* CONFIG_CIFS_STATS2 */
 		spin_lock(&cifs_tcp_ses_lock);
 		list_for_each(tmp1, &cifs_tcp_ses_list) {
@@ -283,7 +283,7 @@ static ssize_t cifs_stats_proc_write(struct file *file,
 					tcon = list_entry(tmp3,
 							  struct cifs_tcon,
 							  tcon_list);
-					atomic_set(&tcon->num_smbs_sent, 0);
+					atomic_set_unchecked(&tcon->num_smbs_sent, 0);
 					if (server->ops->clear_stats)
 						server->ops->clear_stats(tcon);
 				}
@@ -315,8 +315,8 @@ static int cifs_stats_proc_show(struct seq_file *m, void *v)
 			smBufAllocCount.counter, cifs_min_small);
 #ifdef CONFIG_CIFS_STATS2
 	seq_printf(m, "Total Large %d Small %d Allocations\n",
-				atomic_read(&totBufAllocCount),
-				atomic_read(&totSmBufAllocCount));
+				atomic_read_unchecked(&totBufAllocCount),
+				atomic_read_unchecked(&totSmBufAllocCount));
 #endif /* CONFIG_CIFS_STATS2 */
 
 	seq_printf(m, "Operations (MIDs): %d\n", atomic_read(&midCount));
@@ -345,7 +345,7 @@ static int cifs_stats_proc_show(struct seq_file *m, void *v)
 				if (tcon->need_reconnect)
 					seq_puts(m, "\tDISCONNECTED ");
 				seq_printf(m, "\nSMBs: %d",
-					   atomic_read(&tcon->num_smbs_sent));
+					   atomic_read_unchecked(&tcon->num_smbs_sent));
 				if (server->ops->print_stats)
 					server->ops->print_stats(m, tcon);
 			}
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 6a1119e..b29f3b3 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1194,8 +1194,8 @@ init_cifs(void)
 	atomic_set(&bufAllocCount, 0);
 	atomic_set(&smBufAllocCount, 0);
 #ifdef CONFIG_CIFS_STATS2
-	atomic_set(&totBufAllocCount, 0);
-	atomic_set(&totSmBufAllocCount, 0);
+	atomic_set_unchecked(&totBufAllocCount, 0);
+	atomic_set_unchecked(&totSmBufAllocCount, 0);
 #endif /* CONFIG_CIFS_STATS2 */
 
 	atomic_set(&midCount, 0);
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index b406a32..243eb1c 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -832,35 +832,35 @@ struct cifs_tcon {
 	__u16 Flags;		/* optional support bits */
 	enum statusEnum tidStatus;
 #ifdef CONFIG_CIFS_STATS
-	atomic_t num_smbs_sent;
+	atomic_unchecked_t num_smbs_sent;
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
+			atomic_unchecked_t num_writes;
+			atomic_unchecked_t num_reads;
+			atomic_unchecked_t num_flushes;
+			atomic_unchecked_t num_oplock_brks;
+			atomic_unchecked_t num_opens;
+			atomic_unchecked_t num_closes;
+			atomic_unchecked_t num_deletes;
+			atomic_unchecked_t num_mkdirs;
+			atomic_unchecked_t num_posixopens;
+			atomic_unchecked_t num_posixmkdirs;
+			atomic_unchecked_t num_rmdirs;
+			atomic_unchecked_t num_renames;
+			atomic_unchecked_t num_t2renames;
+			atomic_unchecked_t num_ffirst;
+			atomic_unchecked_t num_fnext;
+			atomic_unchecked_t num_fclose;
+			atomic_unchecked_t num_hardlinks;
+			atomic_unchecked_t num_symlinks;
+			atomic_unchecked_t num_locks;
+			atomic_unchecked_t num_acl_get;
+			atomic_unchecked_t num_acl_set;
 		} cifs_stats;
 #ifdef CONFIG_CIFS_SMB2
 		struct {
-			atomic_t smb2_com_sent[NUMBER_OF_SMB2_COMMANDS];
-			atomic_t smb2_com_failed[NUMBER_OF_SMB2_COMMANDS];
+			atomic_unchecked_t smb2_com_sent[NUMBER_OF_SMB2_COMMANDS];
+			atomic_unchecked_t smb2_com_failed[NUMBER_OF_SMB2_COMMANDS];
 		} smb2_stats;
 #endif /* CONFIG_CIFS_SMB2 */
 	} stats;
@@ -1207,7 +1207,7 @@ convert_delimiter(char *path, char delim)
 }
 
 #ifdef CONFIG_CIFS_STATS
-#define cifs_stats_inc atomic_inc
+#define cifs_stats_inc atomic_inc_unchecked
 
 static inline void cifs_stats_bytes_written(struct cifs_tcon *tcon,
 					    unsigned int bytes)
@@ -1574,8 +1574,8 @@ GLOBAL_EXTERN atomic_t tconInfoReconnectCount;
 /* Various Debug counters */
 GLOBAL_EXTERN atomic_t bufAllocCount;    /* current number allocated  */
 #ifdef CONFIG_CIFS_STATS2
-GLOBAL_EXTERN atomic_t totBufAllocCount; /* total allocated over all time */
-GLOBAL_EXTERN atomic_t totSmBufAllocCount;
+GLOBAL_EXTERN atomic_unchecked_t totBufAllocCount; /* total allocated over all time */
+GLOBAL_EXTERN atomic_unchecked_t totSmBufAllocCount;
 #endif
 GLOBAL_EXTERN atomic_t smBufAllocCount;
 GLOBAL_EXTERN atomic_t midCount;
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 8442b8b..ea6986f 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -170,7 +170,7 @@ cifs_buf_get(void)
 		memset(ret_buf, 0, buf_size + 3);
 		atomic_inc(&bufAllocCount);
 #ifdef CONFIG_CIFS_STATS2
-		atomic_inc(&totBufAllocCount);
+		atomic_inc_unchecked(&totBufAllocCount);
 #endif /* CONFIG_CIFS_STATS2 */
 	}
 
@@ -205,7 +205,7 @@ cifs_small_buf_get(void)
 	/*	memset(ret_buf, 0, sizeof(struct smb_hdr) + 27);*/
 		atomic_inc(&smBufAllocCount);
 #ifdef CONFIG_CIFS_STATS2
-		atomic_inc(&totSmBufAllocCount);
+		atomic_inc_unchecked(&totSmBufAllocCount);
 #endif /* CONFIG_CIFS_STATS2 */
 
 	}
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index fc537c2..47d654c 100644
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
+	atomic_set_unchecked(&tcon->stats.cifs_stats.num_writes, 0);
+	atomic_set_unchecked(&tcon->stats.cifs_stats.num_reads, 0);
+	atomic_set_unchecked(&tcon->stats.cifs_stats.num_flushes, 0);
+	atomic_set_unchecked(&tcon->stats.cifs_stats.num_oplock_brks, 0);
+	atomic_set_unchecked(&tcon->stats.cifs_stats.num_opens, 0);
+	atomic_set_unchecked(&tcon->stats.cifs_stats.num_posixopens, 0);
+	atomic_set_unchecked(&tcon->stats.cifs_stats.num_posixmkdirs, 0);
+	atomic_set_unchecked(&tcon->stats.cifs_stats.num_closes, 0);
+	atomic_set_unchecked(&tcon->stats.cifs_stats.num_deletes, 0);
+	atomic_set_unchecked(&tcon->stats.cifs_stats.num_mkdirs, 0);
+	atomic_set_unchecked(&tcon->stats.cifs_stats.num_rmdirs, 0);
+	atomic_set_unchecked(&tcon->stats.cifs_stats.num_renames, 0);
+	atomic_set_unchecked(&tcon->stats.cifs_stats.num_t2renames, 0);
+	atomic_set_unchecked(&tcon->stats.cifs_stats.num_ffirst, 0);
+	atomic_set_unchecked(&tcon->stats.cifs_stats.num_fnext, 0);
+	atomic_set_unchecked(&tcon->stats.cifs_stats.num_fclose, 0);
+	atomic_set_unchecked(&tcon->stats.cifs_stats.num_hardlinks, 0);
+	atomic_set_unchecked(&tcon->stats.cifs_stats.num_symlinks, 0);
+	atomic_set_unchecked(&tcon->stats.cifs_stats.num_locks, 0);
+	atomic_set_unchecked(&tcon->stats.cifs_stats.num_acl_get, 0);
+	atomic_set_unchecked(&tcon->stats.cifs_stats.num_acl_set, 0);
 #endif
 }
 
@@ -651,36 +651,36 @@ cifs_print_stats(struct seq_file *m, struct cifs_tcon *tcon)
 {
 #ifdef CONFIG_CIFS_STATS
 	seq_printf(m, " Oplocks breaks: %d",
-		   atomic_read(&tcon->stats.cifs_stats.num_oplock_brks));
+		   atomic_read_unchecked(&tcon->stats.cifs_stats.num_oplock_brks));
 	seq_printf(m, "\nReads:  %d Bytes: %llu",
-		   atomic_read(&tcon->stats.cifs_stats.num_reads),
+		   atomic_read_unchecked(&tcon->stats.cifs_stats.num_reads),
 		   (long long)(tcon->bytes_read));
 	seq_printf(m, "\nWrites: %d Bytes: %llu",
-		   atomic_read(&tcon->stats.cifs_stats.num_writes),
+		   atomic_read_unchecked(&tcon->stats.cifs_stats.num_writes),
 		   (long long)(tcon->bytes_written));
 	seq_printf(m, "\nFlushes: %d",
-		   atomic_read(&tcon->stats.cifs_stats.num_flushes));
+		   atomic_read_unchecked(&tcon->stats.cifs_stats.num_flushes));
 	seq_printf(m, "\nLocks: %d HardLinks: %d Symlinks: %d",
-		   atomic_read(&tcon->stats.cifs_stats.num_locks),
-		   atomic_read(&tcon->stats.cifs_stats.num_hardlinks),
-		   atomic_read(&tcon->stats.cifs_stats.num_symlinks));
+		   atomic_read_unchecked(&tcon->stats.cifs_stats.num_locks),
+		   atomic_read_unchecked(&tcon->stats.cifs_stats.num_hardlinks),
+		   atomic_read_unchecked(&tcon->stats.cifs_stats.num_symlinks));
 	seq_printf(m, "\nOpens: %d Closes: %d Deletes: %d",
-		   atomic_read(&tcon->stats.cifs_stats.num_opens),
-		   atomic_read(&tcon->stats.cifs_stats.num_closes),
-		   atomic_read(&tcon->stats.cifs_stats.num_deletes));
+		   atomic_read_unchecked(&tcon->stats.cifs_stats.num_opens),
+		   atomic_read_unchecked(&tcon->stats.cifs_stats.num_closes),
+		   atomic_read_unchecked(&tcon->stats.cifs_stats.num_deletes));
 	seq_printf(m, "\nPosix Opens: %d Posix Mkdirs: %d",
-		   atomic_read(&tcon->stats.cifs_stats.num_posixopens),
-		   atomic_read(&tcon->stats.cifs_stats.num_posixmkdirs));
+		   atomic_read_unchecked(&tcon->stats.cifs_stats.num_posixopens),
+		   atomic_read_unchecked(&tcon->stats.cifs_stats.num_posixmkdirs));
 	seq_printf(m, "\nMkdirs: %d Rmdirs: %d",
-		   atomic_read(&tcon->stats.cifs_stats.num_mkdirs),
-		   atomic_read(&tcon->stats.cifs_stats.num_rmdirs));
+		   atomic_read_unchecked(&tcon->stats.cifs_stats.num_mkdirs),
+		   atomic_read_unchecked(&tcon->stats.cifs_stats.num_rmdirs));
 	seq_printf(m, "\nRenames: %d T2 Renames %d",
-		   atomic_read(&tcon->stats.cifs_stats.num_renames),
-		   atomic_read(&tcon->stats.cifs_stats.num_t2renames));
+		   atomic_read_unchecked(&tcon->stats.cifs_stats.num_renames),
+		   atomic_read_unchecked(&tcon->stats.cifs_stats.num_t2renames));
 	seq_printf(m, "\nFindFirst: %d FNext %d FClose %d",
-		   atomic_read(&tcon->stats.cifs_stats.num_ffirst),
-		   atomic_read(&tcon->stats.cifs_stats.num_fnext),
-		   atomic_read(&tcon->stats.cifs_stats.num_fclose));
+		   atomic_read_unchecked(&tcon->stats.cifs_stats.num_ffirst),
+		   atomic_read_unchecked(&tcon->stats.cifs_stats.num_fnext),
+		   atomic_read_unchecked(&tcon->stats.cifs_stats.num_fclose));
 #endif
 }
 
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 18da19f..38a3a79 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -422,8 +422,8 @@ smb2_clear_stats(struct cifs_tcon *tcon)
 #ifdef CONFIG_CIFS_STATS
 	int i;
 	for (i = 0; i < NUMBER_OF_SMB2_COMMANDS; i++) {
-		atomic_set(&tcon->stats.smb2_stats.smb2_com_sent[i], 0);
-		atomic_set(&tcon->stats.smb2_stats.smb2_com_failed[i], 0);
+		atomic_set_unchecked(&tcon->stats.smb2_stats.smb2_com_sent[i], 0);
+		atomic_set_unchecked(&tcon->stats.smb2_stats.smb2_com_failed[i], 0);
 	}
 #endif
 }
@@ -463,65 +463,65 @@ static void
 smb2_print_stats(struct seq_file *m, struct cifs_tcon *tcon)
 {
 #ifdef CONFIG_CIFS_STATS
-	atomic_t *sent = tcon->stats.smb2_stats.smb2_com_sent;
-	atomic_t *failed = tcon->stats.smb2_stats.smb2_com_failed;
+	atomic_unchecked_t *sent = tcon->stats.smb2_stats.smb2_com_sent;
+	atomic_unchecked_t *failed = tcon->stats.smb2_stats.smb2_com_failed;
 	seq_printf(m, "\nNegotiates: %d sent %d failed",
-		   atomic_read(&sent[SMB2_NEGOTIATE_HE]),
-		   atomic_read(&failed[SMB2_NEGOTIATE_HE]));
+		   atomic_read_unchecked(&sent[SMB2_NEGOTIATE_HE]),
+		   atomic_read_unchecked(&failed[SMB2_NEGOTIATE_HE]));
 	seq_printf(m, "\nSessionSetups: %d sent %d failed",
-		   atomic_read(&sent[SMB2_SESSION_SETUP_HE]),
-		   atomic_read(&failed[SMB2_SESSION_SETUP_HE]));
+		   atomic_read_unchecked(&sent[SMB2_SESSION_SETUP_HE]),
+		   atomic_read_unchecked(&failed[SMB2_SESSION_SETUP_HE]));
 	seq_printf(m, "\nLogoffs: %d sent %d failed",
-		   atomic_read(&sent[SMB2_LOGOFF_HE]),
-		   atomic_read(&failed[SMB2_LOGOFF_HE]));
+		   atomic_read_unchecked(&sent[SMB2_LOGOFF_HE]),
+		   atomic_read_unchecked(&failed[SMB2_LOGOFF_HE]));
 	seq_printf(m, "\nTreeConnects: %d sent %d failed",
-		   atomic_read(&sent[SMB2_TREE_CONNECT_HE]),
-		   atomic_read(&failed[SMB2_TREE_CONNECT_HE]));
+		   atomic_read_unchecked(&sent[SMB2_TREE_CONNECT_HE]),
+		   atomic_read_unchecked(&failed[SMB2_TREE_CONNECT_HE]));
 	seq_printf(m, "\nTreeDisconnects: %d sent %d failed",
-		   atomic_read(&sent[SMB2_TREE_DISCONNECT_HE]),
-		   atomic_read(&failed[SMB2_TREE_DISCONNECT_HE]));
+		   atomic_read_unchecked(&sent[SMB2_TREE_DISCONNECT_HE]),
+		   atomic_read_unchecked(&failed[SMB2_TREE_DISCONNECT_HE]));
 	seq_printf(m, "\nCreates: %d sent %d failed",
-		   atomic_read(&sent[SMB2_CREATE_HE]),
-		   atomic_read(&failed[SMB2_CREATE_HE]));
+		   atomic_read_unchecked(&sent[SMB2_CREATE_HE]),
+		   atomic_read_unchecked(&failed[SMB2_CREATE_HE]));
 	seq_printf(m, "\nCloses: %d sent %d failed",
-		   atomic_read(&sent[SMB2_CLOSE_HE]),
-		   atomic_read(&failed[SMB2_CLOSE_HE]));
+		   atomic_read_unchecked(&sent[SMB2_CLOSE_HE]),
+		   atomic_read_unchecked(&failed[SMB2_CLOSE_HE]));
 	seq_printf(m, "\nFlushes: %d sent %d failed",
-		   atomic_read(&sent[SMB2_FLUSH_HE]),
-		   atomic_read(&failed[SMB2_FLUSH_HE]));
+		   atomic_read_unchecked(&sent[SMB2_FLUSH_HE]),
+		   atomic_read_unchecked(&failed[SMB2_FLUSH_HE]));
 	seq_printf(m, "\nReads: %d sent %d failed",
-		   atomic_read(&sent[SMB2_READ_HE]),
-		   atomic_read(&failed[SMB2_READ_HE]));
+		   atomic_read_unchecked(&sent[SMB2_READ_HE]),
+		   atomic_read_unchecked(&failed[SMB2_READ_HE]));
 	seq_printf(m, "\nWrites: %d sent %d failed",
-		   atomic_read(&sent[SMB2_WRITE_HE]),
-		   atomic_read(&failed[SMB2_WRITE_HE]));
+		   atomic_read_unchecked(&sent[SMB2_WRITE_HE]),
+		   atomic_read_unchecked(&failed[SMB2_WRITE_HE]));
 	seq_printf(m, "\nLocks: %d sent %d failed",
-		   atomic_read(&sent[SMB2_LOCK_HE]),
-		   atomic_read(&failed[SMB2_LOCK_HE]));
+		   atomic_read_unchecked(&sent[SMB2_LOCK_HE]),
+		   atomic_read_unchecked(&failed[SMB2_LOCK_HE]));
 	seq_printf(m, "\nIOCTLs: %d sent %d failed",
-		   atomic_read(&sent[SMB2_IOCTL_HE]),
-		   atomic_read(&failed[SMB2_IOCTL_HE]));
+		   atomic_read_unchecked(&sent[SMB2_IOCTL_HE]),
+		   atomic_read_unchecked(&failed[SMB2_IOCTL_HE]));
 	seq_printf(m, "\nCancels: %d sent %d failed",
-		   atomic_read(&sent[SMB2_CANCEL_HE]),
-		   atomic_read(&failed[SMB2_CANCEL_HE]));
+		   atomic_read_unchecked(&sent[SMB2_CANCEL_HE]),
+		   atomic_read_unchecked(&failed[SMB2_CANCEL_HE]));
 	seq_printf(m, "\nEchos: %d sent %d failed",
-		   atomic_read(&sent[SMB2_ECHO_HE]),
-		   atomic_read(&failed[SMB2_ECHO_HE]));
+		   atomic_read_unchecked(&sent[SMB2_ECHO_HE]),
+		   atomic_read_unchecked(&failed[SMB2_ECHO_HE]));
 	seq_printf(m, "\nQueryDirectories: %d sent %d failed",
-		   atomic_read(&sent[SMB2_QUERY_DIRECTORY_HE]),
-		   atomic_read(&failed[SMB2_QUERY_DIRECTORY_HE]));
+		   atomic_read_unchecked(&sent[SMB2_QUERY_DIRECTORY_HE]),
+		   atomic_read_unchecked(&failed[SMB2_QUERY_DIRECTORY_HE]));
 	seq_printf(m, "\nChangeNotifies: %d sent %d failed",
-		   atomic_read(&sent[SMB2_CHANGE_NOTIFY_HE]),
-		   atomic_read(&failed[SMB2_CHANGE_NOTIFY_HE]));
+		   atomic_read_unchecked(&sent[SMB2_CHANGE_NOTIFY_HE]),
+		   atomic_read_unchecked(&failed[SMB2_CHANGE_NOTIFY_HE]));
 	seq_printf(m, "\nQueryInfos: %d sent %d failed",
-		   atomic_read(&sent[SMB2_QUERY_INFO_HE]),
-		   atomic_read(&failed[SMB2_QUERY_INFO_HE]));
+		   atomic_read_unchecked(&sent[SMB2_QUERY_INFO_HE]),
+		   atomic_read_unchecked(&failed[SMB2_QUERY_INFO_HE]));
 	seq_printf(m, "\nSetInfos: %d sent %d failed",
-		   atomic_read(&sent[SMB2_SET_INFO_HE]),
-		   atomic_read(&failed[SMB2_SET_INFO_HE]));
+		   atomic_read_unchecked(&sent[SMB2_SET_INFO_HE]),
+		   atomic_read_unchecked(&failed[SMB2_SET_INFO_HE]));
 	seq_printf(m, "\nOplockBreaks: %d sent %d failed",
-		   atomic_read(&sent[SMB2_OPLOCK_BREAK_HE]),
-		   atomic_read(&failed[SMB2_OPLOCK_BREAK_HE]));
+		   atomic_read_unchecked(&sent[SMB2_OPLOCK_BREAK_HE]),
+		   atomic_read_unchecked(&failed[SMB2_OPLOCK_BREAK_HE]));
 #endif
 }
 
diff --git a/fs/coda/cache.c b/fs/coda/cache.c
index 5bb630a..043dc70 100644
--- a/fs/coda/cache.c
+++ b/fs/coda/cache.c
@@ -24,7 +24,7 @@
 #include "coda_linux.h"
 #include "coda_cache.h"
 
-static atomic_t permission_epoch = ATOMIC_INIT(0);
+static atomic_unchecked_t permission_epoch = ATOMIC_INIT(0);
 
 /* replace or extend an acl cache hit */
 void coda_cache_enter(struct inode *inode, int mask)
@@ -32,7 +32,7 @@ void coda_cache_enter(struct inode *inode, int mask)
 	struct coda_inode_info *cii = ITOC(inode);
 
 	spin_lock(&cii->c_lock);
-	cii->c_cached_epoch = atomic_read(&permission_epoch);
+	cii->c_cached_epoch = atomic_read_unchecked(&permission_epoch);
 	if (!uid_eq(cii->c_uid, current_fsuid())) {
 		cii->c_uid = current_fsuid();
                 cii->c_cached_perm = mask;
@@ -46,14 +46,14 @@ void coda_cache_clear_inode(struct inode *inode)
 {
 	struct coda_inode_info *cii = ITOC(inode);
 	spin_lock(&cii->c_lock);
-	cii->c_cached_epoch = atomic_read(&permission_epoch) - 1;
+	cii->c_cached_epoch = atomic_read_unchecked(&permission_epoch) - 1;
 	spin_unlock(&cii->c_lock);
 }
 
 /* remove all acl caches */
 void coda_cache_clear_all(struct super_block *sb)
 {
-	atomic_inc(&permission_epoch);
+	atomic_inc_unchecked(&permission_epoch);
 }
 
 
@@ -66,7 +66,7 @@ int coda_cache_check(struct inode *inode, int mask)
 	spin_lock(&cii->c_lock);
 	hit = (mask & cii->c_cached_perm) == mask &&
 	    uid_eq(cii->c_uid, current_fsuid()) &&
-	    cii->c_cached_epoch == atomic_read(&permission_epoch);
+	    cii->c_cached_epoch == atomic_read_unchecked(&permission_epoch);
 	spin_unlock(&cii->c_lock);
 
 	return hit;
diff --git a/fs/coredump.c b/fs/coredump.c
index a8f7564..488c681 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -518,7 +518,7 @@ void do_coredump(const siginfo_t *siginfo)
 	/* require nonrelative corefile path and be extra careful */
 	bool need_suid_safe = false;
 	bool core_dumped = false;
-	static atomic_t core_dump_count = ATOMIC_INIT(0);
+	static atomic_unchecked_t core_dump_count = ATOMIC_INIT(0);
 	struct coredump_params cprm = {
 		.siginfo = siginfo,
 		.regs = signal_pt_regs(),
@@ -597,7 +597,7 @@ void do_coredump(const siginfo_t *siginfo)
 		}
 		cprm.limit = RLIM_INFINITY;
 
-		dump_count = atomic_inc_return(&core_dump_count);
+		dump_count = atomic_inc_return_unchecked(&core_dump_count);
 		if (core_pipe_limit && (core_pipe_limit < dump_count)) {
 			printk(KERN_WARNING "Pid %d(%s) over core_pipe_limit\n",
 			       task_tgid_vnr(current), current->comm);
@@ -718,7 +718,7 @@ close_fail:
 		filp_close(cprm.file, NULL);
 fail_dropcount:
 	if (ispipe)
-		atomic_dec(&core_dump_count);
+		atomic_dec_unchecked(&core_dump_count);
 fail_unlock:
 	kfree(cn.corename);
 	coredump_finish(mm, core_dumped);
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index f5e9f04..91296b9 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1305,19 +1305,19 @@ struct ext4_sb_info {
 	unsigned long s_mb_last_start;
 
 	/* stats for buddy allocator */
-	atomic_t s_bal_reqs;	/* number of reqs with len > 1 */
-	atomic_t s_bal_success;	/* we found long enough chunks */
-	atomic_t s_bal_allocated;	/* in blocks */
-	atomic_t s_bal_ex_scanned;	/* total extents scanned */
-	atomic_t s_bal_goals;	/* goal hits */
-	atomic_t s_bal_breaks;	/* too long searches */
-	atomic_t s_bal_2orders;	/* 2^order hits */
+	atomic_unchecked_t s_bal_reqs;	/* number of reqs with len > 1 */
+	atomic_unchecked_t s_bal_success;	/* we found long enough chunks */
+	atomic_unchecked_t s_bal_allocated;	/* in blocks */
+	atomic_unchecked_t s_bal_ex_scanned;	/* total extents scanned */
+	atomic_unchecked_t s_bal_goals;	/* goal hits */
+	atomic_unchecked_t s_bal_breaks;	/* too long searches */
+	atomic_unchecked_t s_bal_2orders;	/* 2^order hits */
 	spinlock_t s_bal_lock;
 	unsigned long s_mb_buddies_generated;
 	unsigned long long s_mb_generation_time;
-	atomic_t s_mb_lost_chunks;
-	atomic_t s_mb_preallocated;
-	atomic_t s_mb_discarded;
+	atomic_unchecked_t s_mb_lost_chunks;
+	atomic_unchecked_t s_mb_preallocated;
+	atomic_unchecked_t s_mb_discarded;
 	atomic_t s_lock_busy;
 
 	/* locality groups */
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 34b610e..ecc47cb 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1905,7 +1905,7 @@ void ext4_mb_simple_scan_group(struct ext4_allocation_context *ac,
 		BUG_ON(ac->ac_b_ex.fe_len != ac->ac_g_ex.fe_len);
 
 		if (EXT4_SB(sb)->s_mb_stats)
-			atomic_inc(&EXT4_SB(sb)->s_bal_2orders);
+			atomic_inc_unchecked(&EXT4_SB(sb)->s_bal_2orders);
 
 		break;
 	}
@@ -2228,7 +2228,7 @@ repeat:
 			ac->ac_status = AC_STATUS_CONTINUE;
 			ac->ac_flags |= EXT4_MB_HINT_FIRST;
 			cr = 3;
-			atomic_inc(&sbi->s_mb_lost_chunks);
+			atomic_inc_unchecked(&sbi->s_mb_lost_chunks);
 			goto repeat;
 		}
 	}
@@ -2732,25 +2732,25 @@ int ext4_mb_release(struct super_block *sb)
 	if (sbi->s_mb_stats) {
 		ext4_msg(sb, KERN_INFO,
 		       "mballoc: %u blocks %u reqs (%u success)",
-				atomic_read(&sbi->s_bal_allocated),
-				atomic_read(&sbi->s_bal_reqs),
-				atomic_read(&sbi->s_bal_success));
+				atomic_read_unchecked(&sbi->s_bal_allocated),
+				atomic_read_unchecked(&sbi->s_bal_reqs),
+				atomic_read_unchecked(&sbi->s_bal_success));
 		ext4_msg(sb, KERN_INFO,
 		      "mballoc: %u extents scanned, %u goal hits, "
 				"%u 2^N hits, %u breaks, %u lost",
-				atomic_read(&sbi->s_bal_ex_scanned),
-				atomic_read(&sbi->s_bal_goals),
-				atomic_read(&sbi->s_bal_2orders),
-				atomic_read(&sbi->s_bal_breaks),
-				atomic_read(&sbi->s_mb_lost_chunks));
+				atomic_read_unchecked(&sbi->s_bal_ex_scanned),
+				atomic_read_unchecked(&sbi->s_bal_goals),
+				atomic_read_unchecked(&sbi->s_bal_2orders),
+				atomic_read_unchecked(&sbi->s_bal_breaks),
+				atomic_read_unchecked(&sbi->s_mb_lost_chunks));
 		ext4_msg(sb, KERN_INFO,
 		       "mballoc: %lu generated and it took %Lu",
 				sbi->s_mb_buddies_generated,
 				sbi->s_mb_generation_time);
 		ext4_msg(sb, KERN_INFO,
 		       "mballoc: %u preallocated, %u discarded",
-				atomic_read(&sbi->s_mb_preallocated),
-				atomic_read(&sbi->s_mb_discarded));
+				atomic_read_unchecked(&sbi->s_mb_preallocated),
+				atomic_read_unchecked(&sbi->s_mb_discarded));
 	}
 
 	free_percpu(sbi->s_locality_groups);
@@ -3206,16 +3206,16 @@ static void ext4_mb_collect_stats(struct ext4_allocation_context *ac)
 	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
 
 	if (sbi->s_mb_stats && ac->ac_g_ex.fe_len > 1) {
-		atomic_inc(&sbi->s_bal_reqs);
-		atomic_add(ac->ac_b_ex.fe_len, &sbi->s_bal_allocated);
+		atomic_inc_unchecked(&sbi->s_bal_reqs);
+		atomic_add_unchecked(ac->ac_b_ex.fe_len, &sbi->s_bal_allocated);
 		if (ac->ac_b_ex.fe_len >= ac->ac_o_ex.fe_len)
-			atomic_inc(&sbi->s_bal_success);
-		atomic_add(ac->ac_found, &sbi->s_bal_ex_scanned);
+			atomic_inc_unchecked(&sbi->s_bal_success);
+		atomic_add_unchecked(ac->ac_found, &sbi->s_bal_ex_scanned);
 		if (ac->ac_g_ex.fe_start == ac->ac_b_ex.fe_start &&
 				ac->ac_g_ex.fe_group == ac->ac_b_ex.fe_group)
-			atomic_inc(&sbi->s_bal_goals);
+			atomic_inc_unchecked(&sbi->s_bal_goals);
 		if (ac->ac_found > sbi->s_mb_max_to_scan)
-			atomic_inc(&sbi->s_bal_breaks);
+			atomic_inc_unchecked(&sbi->s_bal_breaks);
 	}
 
 	if (ac->ac_op == EXT4_MB_HISTORY_ALLOC)
@@ -3642,7 +3642,7 @@ ext4_mb_new_inode_pa(struct ext4_allocation_context *ac)
 	trace_ext4_mb_new_inode_pa(ac, pa);
 
 	ext4_mb_use_inode_pa(ac, pa);
-	atomic_add(pa->pa_free, &sbi->s_mb_preallocated);
+	atomic_add_unchecked(pa->pa_free, &sbi->s_mb_preallocated);
 
 	ei = EXT4_I(ac->ac_inode);
 	grp = ext4_get_group_info(sb, ac->ac_b_ex.fe_group);
@@ -3702,7 +3702,7 @@ ext4_mb_new_group_pa(struct ext4_allocation_context *ac)
 	trace_ext4_mb_new_group_pa(ac, pa);
 
 	ext4_mb_use_group_pa(ac, pa);
-	atomic_add(pa->pa_free, &EXT4_SB(sb)->s_mb_preallocated);
+	atomic_add_unchecked(pa->pa_free, &EXT4_SB(sb)->s_mb_preallocated);
 
 	grp = ext4_get_group_info(sb, ac->ac_b_ex.fe_group);
 	lg = ac->ac_lg;
@@ -3791,7 +3791,7 @@ ext4_mb_release_inode_pa(struct ext4_buddy *e4b, struct buffer_head *bitmap_bh,
 		 * from the bitmap and continue.
 		 */
 	}
-	atomic_add(free, &sbi->s_mb_discarded);
+	atomic_add_unchecked(free, &sbi->s_mb_discarded);
 
 	return err;
 }
@@ -3809,7 +3809,7 @@ ext4_mb_release_group_pa(struct ext4_buddy *e4b,
 	ext4_get_group_no_and_offset(sb, pa->pa_pstart, &group, &bit);
 	BUG_ON(group != e4b->bd_group && pa->pa_len != 0);
 	mb_free_blocks(pa->pa_inode, e4b, bit, pa->pa_len);
-	atomic_add(pa->pa_len, &EXT4_SB(sb)->s_mb_discarded);
+	atomic_add_unchecked(pa->pa_len, &EXT4_SB(sb)->s_mb_discarded);
 	trace_ext4_mballoc_discard(sb, NULL, group, bit, pa->pa_len);
 
 	return 0;
diff --git a/fs/fscache/cookie.c b/fs/fscache/cookie.c
index d403c69..30be0a9 100644
--- a/fs/fscache/cookie.c
+++ b/fs/fscache/cookie.c
@@ -19,7 +19,7 @@
 
 struct kmem_cache *fscache_cookie_jar;
 
-static atomic_t fscache_object_debug_id = ATOMIC_INIT(0);
+static atomic_unchecked_t fscache_object_debug_id = ATOMIC_INIT(0);
 
 static int fscache_acquire_non_index_cookie(struct fscache_cookie *cookie);
 static int fscache_alloc_object(struct fscache_cache *cache,
@@ -69,11 +69,11 @@ struct fscache_cookie *__fscache_acquire_cookie(
 	       parent ? (char *) parent->def->name : "<no-parent>",
 	       def->name, netfs_data, enable);
 
-	fscache_stat(&fscache_n_acquires);
+	fscache_stat_unchecked(&fscache_n_acquires);
 
 	/* if there's no parent cookie, then we don't create one here either */
 	if (!parent) {
-		fscache_stat(&fscache_n_acquires_null);
+		fscache_stat_unchecked(&fscache_n_acquires_null);
 		_leave(" [no parent]");
 		return NULL;
 	}
@@ -88,7 +88,7 @@ struct fscache_cookie *__fscache_acquire_cookie(
 	/* allocate and initialise a cookie */
 	cookie = kmem_cache_alloc(fscache_cookie_jar, GFP_KERNEL);
 	if (!cookie) {
-		fscache_stat(&fscache_n_acquires_oom);
+		fscache_stat_unchecked(&fscache_n_acquires_oom);
 		_leave(" [ENOMEM]");
 		return NULL;
 	}
@@ -115,13 +115,13 @@ struct fscache_cookie *__fscache_acquire_cookie(
 
 	switch (cookie->def->type) {
 	case FSCACHE_COOKIE_TYPE_INDEX:
-		fscache_stat(&fscache_n_cookie_index);
+		fscache_stat_unchecked(&fscache_n_cookie_index);
 		break;
 	case FSCACHE_COOKIE_TYPE_DATAFILE:
-		fscache_stat(&fscache_n_cookie_data);
+		fscache_stat_unchecked(&fscache_n_cookie_data);
 		break;
 	default:
-		fscache_stat(&fscache_n_cookie_special);
+		fscache_stat_unchecked(&fscache_n_cookie_special);
 		break;
 	}
 
@@ -135,7 +135,7 @@ struct fscache_cookie *__fscache_acquire_cookie(
 			} else {
 				atomic_dec(&parent->n_children);
 				__fscache_cookie_put(cookie);
-				fscache_stat(&fscache_n_acquires_nobufs);
+				fscache_stat_unchecked(&fscache_n_acquires_nobufs);
 				_leave(" = NULL");
 				return NULL;
 			}
@@ -144,7 +144,7 @@ struct fscache_cookie *__fscache_acquire_cookie(
 		}
 	}
 
-	fscache_stat(&fscache_n_acquires_ok);
+	fscache_stat_unchecked(&fscache_n_acquires_ok);
 	_leave(" = %p", cookie);
 	return cookie;
 }
@@ -213,7 +213,7 @@ static int fscache_acquire_non_index_cookie(struct fscache_cookie *cookie)
 	cache = fscache_select_cache_for_object(cookie->parent);
 	if (!cache) {
 		up_read(&fscache_addremove_sem);
-		fscache_stat(&fscache_n_acquires_no_cache);
+		fscache_stat_unchecked(&fscache_n_acquires_no_cache);
 		_leave(" = -ENOMEDIUM [no cache]");
 		return -ENOMEDIUM;
 	}
@@ -297,14 +297,14 @@ static int fscache_alloc_object(struct fscache_cache *cache,
 	object = cache->ops->alloc_object(cache, cookie);
 	fscache_stat_d(&fscache_n_cop_alloc_object);
 	if (IS_ERR(object)) {
-		fscache_stat(&fscache_n_object_no_alloc);
+		fscache_stat_unchecked(&fscache_n_object_no_alloc);
 		ret = PTR_ERR(object);
 		goto error;
 	}
 
-	fscache_stat(&fscache_n_object_alloc);
+	fscache_stat_unchecked(&fscache_n_object_alloc);
 
-	object->debug_id = atomic_inc_return(&fscache_object_debug_id);
+	object->debug_id = atomic_inc_return_unchecked(&fscache_object_debug_id);
 
 	_debug("ALLOC OBJ%x: %s {%lx}",
 	       object->debug_id, cookie->def->name, object->events);
@@ -419,7 +419,7 @@ void __fscache_invalidate(struct fscache_cookie *cookie)
 
 	_enter("{%s}", cookie->def->name);
 
-	fscache_stat(&fscache_n_invalidates);
+	fscache_stat_unchecked(&fscache_n_invalidates);
 
 	/* Only permit invalidation of data files.  Invalidating an index will
 	 * require the caller to release all its attachments to the tree rooted
@@ -477,10 +477,10 @@ void __fscache_update_cookie(struct fscache_cookie *cookie)
 {
 	struct fscache_object *object;
 
-	fscache_stat(&fscache_n_updates);
+	fscache_stat_unchecked(&fscache_n_updates);
 
 	if (!cookie) {
-		fscache_stat(&fscache_n_updates_null);
+		fscache_stat_unchecked(&fscache_n_updates_null);
 		_leave(" [no cookie]");
 		return;
 	}
@@ -581,12 +581,12 @@ EXPORT_SYMBOL(__fscache_disable_cookie);
  */
 void __fscache_relinquish_cookie(struct fscache_cookie *cookie, bool retire)
 {
-	fscache_stat(&fscache_n_relinquishes);
+	fscache_stat_unchecked(&fscache_n_relinquishes);
 	if (retire)
-		fscache_stat(&fscache_n_relinquishes_retire);
+		fscache_stat_unchecked(&fscache_n_relinquishes_retire);
 
 	if (!cookie) {
-		fscache_stat(&fscache_n_relinquishes_null);
+		fscache_stat_unchecked(&fscache_n_relinquishes_null);
 		_leave(" [no cookie]");
 		return;
 	}
@@ -687,7 +687,7 @@ int __fscache_check_consistency(struct fscache_cookie *cookie)
 	if (test_bit(FSCACHE_IOERROR, &object->cache->flags))
 		goto inconsistent;
 
-	op->debug_id = atomic_inc_return(&fscache_op_debug_id);
+	op->debug_id = atomic_inc_return_unchecked(&fscache_op_debug_id);
 
 	__fscache_use_cookie(cookie);
 	if (fscache_submit_op(object, op) < 0)
diff --git a/fs/fscache/internal.h b/fs/fscache/internal.h
index 97ec451..f722cee 100644
--- a/fs/fscache/internal.h
+++ b/fs/fscache/internal.h
@@ -136,8 +136,8 @@ extern void fscache_operation_gc(struct work_struct *);
 extern int fscache_wait_for_deferred_lookup(struct fscache_cookie *);
 extern int fscache_wait_for_operation_activation(struct fscache_object *,
 						 struct fscache_operation *,
-						 atomic_t *,
-						 atomic_t *);
+						 atomic_unchecked_t *,
+						 atomic_unchecked_t *);
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
+extern atomic_unchecked_t fscache_n_ops_processed[FSCACHE_MAX_THREADS];
+extern atomic_unchecked_t fscache_n_objs_processed[FSCACHE_MAX_THREADS];
+
+extern atomic_unchecked_t fscache_n_op_pend;
+extern atomic_unchecked_t fscache_n_op_run;
+extern atomic_unchecked_t fscache_n_op_enqueue;
+extern atomic_unchecked_t fscache_n_op_deferred_release;
+extern atomic_unchecked_t fscache_n_op_initialised;
+extern atomic_unchecked_t fscache_n_op_release;
+extern atomic_unchecked_t fscache_n_op_gc;
+extern atomic_unchecked_t fscache_n_op_cancelled;
+extern atomic_unchecked_t fscache_n_op_rejected;
+
+extern atomic_unchecked_t fscache_n_attr_changed;
+extern atomic_unchecked_t fscache_n_attr_changed_ok;
+extern atomic_unchecked_t fscache_n_attr_changed_nobufs;
+extern atomic_unchecked_t fscache_n_attr_changed_nomem;
+extern atomic_unchecked_t fscache_n_attr_changed_calls;
+
+extern atomic_unchecked_t fscache_n_allocs;
+extern atomic_unchecked_t fscache_n_allocs_ok;
+extern atomic_unchecked_t fscache_n_allocs_wait;
+extern atomic_unchecked_t fscache_n_allocs_nobufs;
+extern atomic_unchecked_t fscache_n_allocs_intr;
+extern atomic_unchecked_t fscache_n_allocs_object_dead;
+extern atomic_unchecked_t fscache_n_alloc_ops;
+extern atomic_unchecked_t fscache_n_alloc_op_waits;
+
+extern atomic_unchecked_t fscache_n_retrievals;
+extern atomic_unchecked_t fscache_n_retrievals_ok;
+extern atomic_unchecked_t fscache_n_retrievals_wait;
+extern atomic_unchecked_t fscache_n_retrievals_nodata;
+extern atomic_unchecked_t fscache_n_retrievals_nobufs;
+extern atomic_unchecked_t fscache_n_retrievals_intr;
+extern atomic_unchecked_t fscache_n_retrievals_nomem;
+extern atomic_unchecked_t fscache_n_retrievals_object_dead;
+extern atomic_unchecked_t fscache_n_retrieval_ops;
+extern atomic_unchecked_t fscache_n_retrieval_op_waits;
+
+extern atomic_unchecked_t fscache_n_stores;
+extern atomic_unchecked_t fscache_n_stores_ok;
+extern atomic_unchecked_t fscache_n_stores_again;
+extern atomic_unchecked_t fscache_n_stores_nobufs;
+extern atomic_unchecked_t fscache_n_stores_oom;
+extern atomic_unchecked_t fscache_n_store_ops;
+extern atomic_unchecked_t fscache_n_store_calls;
+extern atomic_unchecked_t fscache_n_store_pages;
+extern atomic_unchecked_t fscache_n_store_radix_deletes;
+extern atomic_unchecked_t fscache_n_store_pages_over_limit;
+
+extern atomic_unchecked_t fscache_n_store_vmscan_not_storing;
+extern atomic_unchecked_t fscache_n_store_vmscan_gone;
+extern atomic_unchecked_t fscache_n_store_vmscan_busy;
+extern atomic_unchecked_t fscache_n_store_vmscan_cancelled;
+extern atomic_unchecked_t fscache_n_store_vmscan_wait;
+
+extern atomic_unchecked_t fscache_n_marks;
+extern atomic_unchecked_t fscache_n_uncaches;
+
+extern atomic_unchecked_t fscache_n_acquires;
+extern atomic_unchecked_t fscache_n_acquires_null;
+extern atomic_unchecked_t fscache_n_acquires_no_cache;
+extern atomic_unchecked_t fscache_n_acquires_ok;
+extern atomic_unchecked_t fscache_n_acquires_nobufs;
+extern atomic_unchecked_t fscache_n_acquires_oom;
+
+extern atomic_unchecked_t fscache_n_invalidates;
+extern atomic_unchecked_t fscache_n_invalidates_run;
+
+extern atomic_unchecked_t fscache_n_updates;
+extern atomic_unchecked_t fscache_n_updates_null;
+extern atomic_unchecked_t fscache_n_updates_run;
+
+extern atomic_unchecked_t fscache_n_relinquishes;
+extern atomic_unchecked_t fscache_n_relinquishes_null;
+extern atomic_unchecked_t fscache_n_relinquishes_waitcrt;
+extern atomic_unchecked_t fscache_n_relinquishes_retire;
+
+extern atomic_unchecked_t fscache_n_cookie_index;
+extern atomic_unchecked_t fscache_n_cookie_data;
+extern atomic_unchecked_t fscache_n_cookie_special;
+
+extern atomic_unchecked_t fscache_n_object_alloc;
+extern atomic_unchecked_t fscache_n_object_no_alloc;
+extern atomic_unchecked_t fscache_n_object_lookups;
+extern atomic_unchecked_t fscache_n_object_lookups_negative;
+extern atomic_unchecked_t fscache_n_object_lookups_positive;
+extern atomic_unchecked_t fscache_n_object_lookups_timed_out;
+extern atomic_unchecked_t fscache_n_object_created;
+extern atomic_unchecked_t fscache_n_object_avail;
+extern atomic_unchecked_t fscache_n_object_dead;
+
+extern atomic_unchecked_t fscache_n_checkaux_none;
+extern atomic_unchecked_t fscache_n_checkaux_okay;
+extern atomic_unchecked_t fscache_n_checkaux_update;
+extern atomic_unchecked_t fscache_n_checkaux_obsolete;
 
 extern atomic_t fscache_n_cop_alloc_object;
 extern atomic_t fscache_n_cop_lookup_object;
@@ -280,6 +280,11 @@ static inline void fscache_stat(atomic_t *stat)
 	atomic_inc(stat);
 }
 
+static inline void fscache_stat_unchecked(atomic_unchecked_t *stat)
+{
+	atomic_inc_unchecked(stat);
+}
+
 static inline void fscache_stat_d(atomic_t *stat)
 {
 	atomic_dec(stat);
@@ -292,6 +297,7 @@ extern const struct file_operations fscache_stats_fops;
 
 #define __fscache_stat(stat) (NULL)
 #define fscache_stat(stat) do {} while (0)
+#define fscache_stat_unchecked(stat) do {} while (0)
 #define fscache_stat_d(stat) do {} while (0)
 #endif
 
diff --git a/fs/fscache/object.c b/fs/fscache/object.c
index 9e792e3..6b2affb 100644
--- a/fs/fscache/object.c
+++ b/fs/fscache/object.c
@@ -465,7 +465,7 @@ static const struct fscache_state *fscache_look_up_object(struct fscache_object
 	_debug("LOOKUP \"%s\" in \"%s\"",
 	       cookie->def->name, object->cache->tag->name);
 
-	fscache_stat(&fscache_n_object_lookups);
+	fscache_stat_unchecked(&fscache_n_object_lookups);
 	fscache_stat(&fscache_n_cop_lookup_object);
 	ret = object->cache->ops->lookup_object(object);
 	fscache_stat_d(&fscache_n_cop_lookup_object);
@@ -475,7 +475,7 @@ static const struct fscache_state *fscache_look_up_object(struct fscache_object
 	if (ret == -ETIMEDOUT) {
 		/* probably stuck behind another object, so move this one to
 		 * the back of the queue */
-		fscache_stat(&fscache_n_object_lookups_timed_out);
+		fscache_stat_unchecked(&fscache_n_object_lookups_timed_out);
 		_leave(" [timeout]");
 		return NO_TRANSIT;
 	}
@@ -503,7 +503,7 @@ void fscache_object_lookup_negative(struct fscache_object *object)
 	_enter("{OBJ%x,%s}", object->debug_id, object->state->name);
 
 	if (!test_and_set_bit(FSCACHE_OBJECT_IS_LOOKED_UP, &object->flags)) {
-		fscache_stat(&fscache_n_object_lookups_negative);
+		fscache_stat_unchecked(&fscache_n_object_lookups_negative);
 
 		/* Allow write requests to begin stacking up and read requests to begin
 		 * returning ENODATA.
@@ -538,7 +538,7 @@ void fscache_obtained_object(struct fscache_object *object)
 	/* if we were still looking up, then we must have a positive lookup
 	 * result, in which case there may be data available */
 	if (!test_and_set_bit(FSCACHE_OBJECT_IS_LOOKED_UP, &object->flags)) {
-		fscache_stat(&fscache_n_object_lookups_positive);
+		fscache_stat_unchecked(&fscache_n_object_lookups_positive);
 
 		/* We do (presumably) have data */
 		clear_bit_unlock(FSCACHE_COOKIE_NO_DATA_YET, &cookie->flags);
@@ -550,7 +550,7 @@ void fscache_obtained_object(struct fscache_object *object)
 		clear_bit_unlock(FSCACHE_COOKIE_LOOKING_UP, &cookie->flags);
 		wake_up_bit(&cookie->flags, FSCACHE_COOKIE_LOOKING_UP);
 	} else {
-		fscache_stat(&fscache_n_object_created);
+		fscache_stat_unchecked(&fscache_n_object_created);
 	}
 
 	set_bit(FSCACHE_OBJECT_IS_AVAILABLE, &object->flags);
@@ -586,7 +586,7 @@ static const struct fscache_state *fscache_object_available(struct fscache_objec
 	fscache_stat_d(&fscache_n_cop_lookup_complete);
 
 	fscache_hist(fscache_obj_instantiate_histogram, object->lookup_jif);
-	fscache_stat(&fscache_n_object_avail);
+	fscache_stat_unchecked(&fscache_n_object_avail);
 
 	_leave("");
 	return transit_to(JUMPSTART_DEPS);
@@ -735,7 +735,7 @@ static const struct fscache_state *fscache_drop_object(struct fscache_object *ob
 
 	/* this just shifts the object release to the work processor */
 	fscache_put_object(object);
-	fscache_stat(&fscache_n_object_dead);
+	fscache_stat_unchecked(&fscache_n_object_dead);
 
 	_leave("");
 	return transit_to(OBJECT_DEAD);
@@ -900,7 +900,7 @@ enum fscache_checkaux fscache_check_aux(struct fscache_object *object,
 	enum fscache_checkaux result;
 
 	if (!object->cookie->def->check_aux) {
-		fscache_stat(&fscache_n_checkaux_none);
+		fscache_stat_unchecked(&fscache_n_checkaux_none);
 		return FSCACHE_CHECKAUX_OKAY;
 	}
 
@@ -909,17 +909,17 @@ enum fscache_checkaux fscache_check_aux(struct fscache_object *object,
 	switch (result) {
 		/* entry okay as is */
 	case FSCACHE_CHECKAUX_OKAY:
-		fscache_stat(&fscache_n_checkaux_okay);
+		fscache_stat_unchecked(&fscache_n_checkaux_okay);
 		break;
 
 		/* entry requires update */
 	case FSCACHE_CHECKAUX_NEEDS_UPDATE:
-		fscache_stat(&fscache_n_checkaux_update);
+		fscache_stat_unchecked(&fscache_n_checkaux_update);
 		break;
 
 		/* entry requires deletion */
 	case FSCACHE_CHECKAUX_OBSOLETE:
-		fscache_stat(&fscache_n_checkaux_obsolete);
+		fscache_stat_unchecked(&fscache_n_checkaux_obsolete);
 		break;
 
 	default:
@@ -1007,7 +1007,7 @@ static const struct fscache_state *fscache_invalidate_object(struct fscache_obje
 {
 	const struct fscache_state *s;
 
-	fscache_stat(&fscache_n_invalidates_run);
+	fscache_stat_unchecked(&fscache_n_invalidates_run);
 	fscache_stat(&fscache_n_cop_invalidate_object);
 	s = _fscache_invalidate_object(object, event);
 	fscache_stat_d(&fscache_n_cop_invalidate_object);
@@ -1022,7 +1022,7 @@ static const struct fscache_state *fscache_update_object(struct fscache_object *
 {
 	_enter("{OBJ%x},%d", object->debug_id, event);
 
-	fscache_stat(&fscache_n_updates_run);
+	fscache_stat_unchecked(&fscache_n_updates_run);
 	fscache_stat(&fscache_n_cop_update_object);
 	object->cache->ops->update_object(object);
 	fscache_stat_d(&fscache_n_cop_update_object);
diff --git a/fs/fscache/operation.c b/fs/fscache/operation.c
index de67745..6a3a9b6 100644
--- a/fs/fscache/operation.c
+++ b/fs/fscache/operation.c
@@ -17,7 +17,7 @@
 #include <linux/slab.h>
 #include "internal.h"
 
-atomic_t fscache_op_debug_id;
+atomic_unchecked_t fscache_op_debug_id;
 EXPORT_SYMBOL(fscache_op_debug_id);
 
 static void fscache_operation_dummy_cancel(struct fscache_operation *op)
@@ -40,12 +40,12 @@ void fscache_operation_init(struct fscache_operation *op,
 	INIT_WORK(&op->work, fscache_op_work_func);
 	atomic_set(&op->usage, 1);
 	op->state = FSCACHE_OP_ST_INITIALISED;
-	op->debug_id = atomic_inc_return(&fscache_op_debug_id);
+	op->debug_id = atomic_inc_return_unchecked(&fscache_op_debug_id);
 	op->processor = processor;
 	op->cancel = cancel ?: fscache_operation_dummy_cancel;
 	op->release = release;
 	INIT_LIST_HEAD(&op->pend_link);
-	fscache_stat(&fscache_n_op_initialised);
+	fscache_stat_unchecked(&fscache_n_op_initialised);
 }
 EXPORT_SYMBOL(fscache_operation_init);
 
@@ -68,7 +68,7 @@ void fscache_enqueue_operation(struct fscache_operation *op)
 	ASSERTCMP(atomic_read(&op->usage), >, 0);
 	ASSERTCMP(op->state, ==, FSCACHE_OP_ST_IN_PROGRESS);
 
-	fscache_stat(&fscache_n_op_enqueue);
+	fscache_stat_unchecked(&fscache_n_op_enqueue);
 	switch (op->flags & FSCACHE_OP_TYPE) {
 	case FSCACHE_OP_ASYNC:
 		_debug("queue async");
@@ -101,7 +101,7 @@ static void fscache_run_op(struct fscache_object *object,
 		wake_up_bit(&op->flags, FSCACHE_OP_WAITING);
 	if (op->processor)
 		fscache_enqueue_operation(op);
-	fscache_stat(&fscache_n_op_run);
+	fscache_stat_unchecked(&fscache_n_op_run);
 }
 
 /*
@@ -169,7 +169,7 @@ int fscache_submit_exclusive_op(struct fscache_object *object,
 	op->state = FSCACHE_OP_ST_PENDING;
 	flags = READ_ONCE(object->flags);
 	if (unlikely(!(flags & BIT(FSCACHE_OBJECT_IS_LIVE)))) {
-		fscache_stat(&fscache_n_op_rejected);
+		fscache_stat_unchecked(&fscache_n_op_rejected);
 		op->cancel(op);
 		op->state = FSCACHE_OP_ST_CANCELLED;
 		ret = -ENOBUFS;
@@ -185,11 +185,11 @@ int fscache_submit_exclusive_op(struct fscache_object *object,
 		if (object->n_in_progress > 0) {
 			atomic_inc(&op->usage);
 			list_add_tail(&op->pend_link, &object->pending_ops);
-			fscache_stat(&fscache_n_op_pend);
+			fscache_stat_unchecked(&fscache_n_op_pend);
 		} else if (!list_empty(&object->pending_ops)) {
 			atomic_inc(&op->usage);
 			list_add_tail(&op->pend_link, &object->pending_ops);
-			fscache_stat(&fscache_n_op_pend);
+			fscache_stat_unchecked(&fscache_n_op_pend);
 			fscache_start_operations(object);
 		} else {
 			ASSERTCMP(object->n_in_progress, ==, 0);
@@ -205,7 +205,7 @@ int fscache_submit_exclusive_op(struct fscache_object *object,
 		object->n_exclusive++;	/* reads and writes must wait */
 		atomic_inc(&op->usage);
 		list_add_tail(&op->pend_link, &object->pending_ops);
-		fscache_stat(&fscache_n_op_pend);
+		fscache_stat_unchecked(&fscache_n_op_pend);
 		ret = 0;
 	} else if (flags & BIT(FSCACHE_OBJECT_KILLED_BY_CACHE)) {
 		op->cancel(op);
@@ -254,7 +254,7 @@ int fscache_submit_op(struct fscache_object *object,
 	op->state = FSCACHE_OP_ST_PENDING;
 	flags = READ_ONCE(object->flags);
 	if (unlikely(!(flags & BIT(FSCACHE_OBJECT_IS_LIVE)))) {
-		fscache_stat(&fscache_n_op_rejected);
+		fscache_stat_unchecked(&fscache_n_op_rejected);
 		op->cancel(op);
 		op->state = FSCACHE_OP_ST_CANCELLED;
 		ret = -ENOBUFS;
@@ -269,11 +269,11 @@ int fscache_submit_op(struct fscache_object *object,
 		if (object->n_exclusive > 0) {
 			atomic_inc(&op->usage);
 			list_add_tail(&op->pend_link, &object->pending_ops);
-			fscache_stat(&fscache_n_op_pend);
+			fscache_stat_unchecked(&fscache_n_op_pend);
 		} else if (!list_empty(&object->pending_ops)) {
 			atomic_inc(&op->usage);
 			list_add_tail(&op->pend_link, &object->pending_ops);
-			fscache_stat(&fscache_n_op_pend);
+			fscache_stat_unchecked(&fscache_n_op_pend);
 			fscache_start_operations(object);
 		} else {
 			ASSERTCMP(object->n_exclusive, ==, 0);
@@ -285,7 +285,7 @@ int fscache_submit_op(struct fscache_object *object,
 		object->n_ops++;
 		atomic_inc(&op->usage);
 		list_add_tail(&op->pend_link, &object->pending_ops);
-		fscache_stat(&fscache_n_op_pend);
+		fscache_stat_unchecked(&fscache_n_op_pend);
 		ret = 0;
 	} else if (flags & BIT(FSCACHE_OBJECT_KILLED_BY_CACHE)) {
 		op->cancel(op);
@@ -369,7 +369,7 @@ int fscache_cancel_op(struct fscache_operation *op,
 		list_del_init(&op->pend_link);
 		put = true;
 
-		fscache_stat(&fscache_n_op_cancelled);
+		fscache_stat_unchecked(&fscache_n_op_cancelled);
 		op->cancel(op);
 		op->state = FSCACHE_OP_ST_CANCELLED;
 		if (test_bit(FSCACHE_OP_EXCLUSIVE, &op->flags))
@@ -385,7 +385,7 @@ int fscache_cancel_op(struct fscache_operation *op,
 		if (object->n_in_progress == 0)
 			fscache_start_operations(object);
 
-		fscache_stat(&fscache_n_op_cancelled);
+		fscache_stat_unchecked(&fscache_n_op_cancelled);
 		op->cancel(op);
 		op->state = FSCACHE_OP_ST_CANCELLED;
 		if (test_bit(FSCACHE_OP_EXCLUSIVE, &op->flags))
@@ -416,7 +416,7 @@ void fscache_cancel_all_ops(struct fscache_object *object)
 	while (!list_empty(&object->pending_ops)) {
 		op = list_entry(object->pending_ops.next,
 				struct fscache_operation, pend_link);
-		fscache_stat(&fscache_n_op_cancelled);
+		fscache_stat_unchecked(&fscache_n_op_cancelled);
 		list_del_init(&op->pend_link);
 
 		ASSERTCMP(op->state, ==, FSCACHE_OP_ST_PENDING);
@@ -493,7 +493,7 @@ void fscache_put_operation(struct fscache_operation *op)
 		    op->state != FSCACHE_OP_ST_COMPLETE,
 		    op->state, ==, FSCACHE_OP_ST_CANCELLED);
 
-	fscache_stat(&fscache_n_op_release);
+	fscache_stat_unchecked(&fscache_n_op_release);
 
 	if (op->release) {
 		op->release(op);
@@ -513,7 +513,7 @@ void fscache_put_operation(struct fscache_operation *op)
 		 * lock, and defer it otherwise */
 		if (!spin_trylock(&object->lock)) {
 			_debug("defer put");
-			fscache_stat(&fscache_n_op_deferred_release);
+			fscache_stat_unchecked(&fscache_n_op_deferred_release);
 
 			cache = object->cache;
 			spin_lock(&cache->op_gc_list_lock);
@@ -567,7 +567,7 @@ void fscache_operation_gc(struct work_struct *work)
 
 		_debug("GC DEFERRED REL OBJ%x OP%x",
 		       object->debug_id, op->debug_id);
-		fscache_stat(&fscache_n_op_gc);
+		fscache_stat_unchecked(&fscache_n_op_gc);
 
 		ASSERTCMP(atomic_read(&op->usage), ==, 0);
 		ASSERTCMP(op->state, ==, FSCACHE_OP_ST_DEAD);
diff --git a/fs/fscache/page.c b/fs/fscache/page.c
index 483bbc6..ba36737 100644
--- a/fs/fscache/page.c
+++ b/fs/fscache/page.c
@@ -74,7 +74,7 @@ try_again:
 	val = radix_tree_lookup(&cookie->stores, page->index);
 	if (!val) {
 		rcu_read_unlock();
-		fscache_stat(&fscache_n_store_vmscan_not_storing);
+		fscache_stat_unchecked(&fscache_n_store_vmscan_not_storing);
 		__fscache_uncache_page(cookie, page);
 		return true;
 	}
@@ -104,11 +104,11 @@ try_again:
 	spin_unlock(&cookie->stores_lock);
 
 	if (xpage) {
-		fscache_stat(&fscache_n_store_vmscan_cancelled);
-		fscache_stat(&fscache_n_store_radix_deletes);
+		fscache_stat_unchecked(&fscache_n_store_vmscan_cancelled);
+		fscache_stat_unchecked(&fscache_n_store_radix_deletes);
 		ASSERTCMP(xpage, ==, page);
 	} else {
-		fscache_stat(&fscache_n_store_vmscan_gone);
+		fscache_stat_unchecked(&fscache_n_store_vmscan_gone);
 	}
 
 	wake_up_bit(&cookie->flags, 0);
@@ -123,11 +123,11 @@ page_busy:
 	 * sleeping on memory allocation, so we may need to impose a timeout
 	 * too. */
 	if (!(gfp & __GFP_WAIT) || !(gfp & __GFP_FS)) {
-		fscache_stat(&fscache_n_store_vmscan_busy);
+		fscache_stat_unchecked(&fscache_n_store_vmscan_busy);
 		return false;
 	}
 
-	fscache_stat(&fscache_n_store_vmscan_wait);
+	fscache_stat_unchecked(&fscache_n_store_vmscan_wait);
 	if (!release_page_wait_timeout(cookie, page))
 		_debug("fscache writeout timeout page: %p{%lx}",
 			page, page->index);
@@ -156,7 +156,7 @@ static void fscache_end_page_write(struct fscache_object *object,
 				     FSCACHE_COOKIE_STORING_TAG);
 		if (!radix_tree_tag_get(&cookie->stores, page->index,
 					FSCACHE_COOKIE_PENDING_TAG)) {
-			fscache_stat(&fscache_n_store_radix_deletes);
+			fscache_stat_unchecked(&fscache_n_store_radix_deletes);
 			xpage = radix_tree_delete(&cookie->stores, page->index);
 		}
 		spin_unlock(&cookie->stores_lock);
@@ -177,7 +177,7 @@ static void fscache_attr_changed_op(struct fscache_operation *op)
 
 	_enter("{OBJ%x OP%x}", object->debug_id, op->debug_id);
 
-	fscache_stat(&fscache_n_attr_changed_calls);
+	fscache_stat_unchecked(&fscache_n_attr_changed_calls);
 
 	if (fscache_object_is_active(object)) {
 		fscache_stat(&fscache_n_cop_attr_changed);
@@ -204,11 +204,11 @@ int __fscache_attr_changed(struct fscache_cookie *cookie)
 
 	ASSERTCMP(cookie->def->type, !=, FSCACHE_COOKIE_TYPE_INDEX);
 
-	fscache_stat(&fscache_n_attr_changed);
+	fscache_stat_unchecked(&fscache_n_attr_changed);
 
 	op = kzalloc(sizeof(*op), GFP_KERNEL);
 	if (!op) {
-		fscache_stat(&fscache_n_attr_changed_nomem);
+		fscache_stat_unchecked(&fscache_n_attr_changed_nomem);
 		_leave(" = -ENOMEM");
 		return -ENOMEM;
 	}
@@ -230,7 +230,7 @@ int __fscache_attr_changed(struct fscache_cookie *cookie)
 	if (fscache_submit_exclusive_op(object, op) < 0)
 		goto nobufs_dec;
 	spin_unlock(&cookie->lock);
-	fscache_stat(&fscache_n_attr_changed_ok);
+	fscache_stat_unchecked(&fscache_n_attr_changed_ok);
 	fscache_put_operation(op);
 	_leave(" = 0");
 	return 0;
@@ -242,7 +242,7 @@ nobufs:
 	fscache_put_operation(op);
 	if (wake_cookie)
 		__fscache_wake_unused_cookie(cookie);
-	fscache_stat(&fscache_n_attr_changed_nobufs);
+	fscache_stat_unchecked(&fscache_n_attr_changed_nobufs);
 	_leave(" = %d", -ENOBUFS);
 	return -ENOBUFS;
 }
@@ -293,7 +293,7 @@ static struct fscache_retrieval *fscache_alloc_retrieval(
 	/* allocate a retrieval operation and attempt to submit it */
 	op = kzalloc(sizeof(*op), GFP_NOIO);
 	if (!op) {
-		fscache_stat(&fscache_n_retrievals_nomem);
+		fscache_stat_unchecked(&fscache_n_retrievals_nomem);
 		return NULL;
 	}
 
@@ -332,12 +332,12 @@ int fscache_wait_for_deferred_lookup(struct fscache_cookie *cookie)
 		return 0;
 	}
 
-	fscache_stat(&fscache_n_retrievals_wait);
+	fscache_stat_unchecked(&fscache_n_retrievals_wait);
 
 	jif = jiffies;
 	if (wait_on_bit(&cookie->flags, FSCACHE_COOKIE_LOOKING_UP,
 			TASK_INTERRUPTIBLE) != 0) {
-		fscache_stat(&fscache_n_retrievals_intr);
+		fscache_stat_unchecked(&fscache_n_retrievals_intr);
 		_leave(" = -ERESTARTSYS");
 		return -ERESTARTSYS;
 	}
@@ -355,8 +355,8 @@ int fscache_wait_for_deferred_lookup(struct fscache_cookie *cookie)
  */
 int fscache_wait_for_operation_activation(struct fscache_object *object,
 					  struct fscache_operation *op,
-					  atomic_t *stat_op_waits,
-					  atomic_t *stat_object_dead)
+					  atomic_unchecked_t *stat_op_waits,
+					  atomic_unchecked_t *stat_object_dead)
 {
 	int ret;
 
@@ -365,7 +365,7 @@ int fscache_wait_for_operation_activation(struct fscache_object *object,
 
 	_debug(">>> WT");
 	if (stat_op_waits)
-		fscache_stat(stat_op_waits);
+		fscache_stat_unchecked(stat_op_waits);
 	if (wait_on_bit(&op->flags, FSCACHE_OP_WAITING,
 			TASK_INTERRUPTIBLE) != 0) {
 		ret = fscache_cancel_op(op, false);
@@ -382,7 +382,7 @@ int fscache_wait_for_operation_activation(struct fscache_object *object,
 check_if_dead:
 	if (op->state == FSCACHE_OP_ST_CANCELLED) {
 		if (stat_object_dead)
-			fscache_stat(stat_object_dead);
+			fscache_stat_unchecked(stat_object_dead);
 		_leave(" = -ENOBUFS [cancelled]");
 		return -ENOBUFS;
 	}
@@ -391,7 +391,7 @@ check_if_dead:
 		enum fscache_operation_state state = op->state;
 		fscache_cancel_op(op, true);
 		if (stat_object_dead)
-			fscache_stat(stat_object_dead);
+			fscache_stat_unchecked(stat_object_dead);
 		_leave(" = -ENOBUFS [obj dead %d]", state);
 		return -ENOBUFS;
 	}
@@ -420,7 +420,7 @@ int __fscache_read_or_alloc_page(struct fscache_cookie *cookie,
 
 	_enter("%p,%p,,,", cookie, page);
 
-	fscache_stat(&fscache_n_retrievals);
+	fscache_stat_unchecked(&fscache_n_retrievals);
 
 	if (hlist_empty(&cookie->backing_objects))
 		goto nobufs;
@@ -462,7 +462,7 @@ int __fscache_read_or_alloc_page(struct fscache_cookie *cookie,
 		goto nobufs_unlock_dec;
 	spin_unlock(&cookie->lock);
 
-	fscache_stat(&fscache_n_retrieval_ops);
+	fscache_stat_unchecked(&fscache_n_retrieval_ops);
 
 	/* we wait for the operation to become active, and then process it
 	 * *here*, in this thread, and not in the thread pool */
@@ -488,15 +488,15 @@ int __fscache_read_or_alloc_page(struct fscache_cookie *cookie,
 
 error:
 	if (ret == -ENOMEM)
-		fscache_stat(&fscache_n_retrievals_nomem);
+		fscache_stat_unchecked(&fscache_n_retrievals_nomem);
 	else if (ret == -ERESTARTSYS)
-		fscache_stat(&fscache_n_retrievals_intr);
+		fscache_stat_unchecked(&fscache_n_retrievals_intr);
 	else if (ret == -ENODATA)
-		fscache_stat(&fscache_n_retrievals_nodata);
+		fscache_stat_unchecked(&fscache_n_retrievals_nodata);
 	else if (ret < 0)
-		fscache_stat(&fscache_n_retrievals_nobufs);
+		fscache_stat_unchecked(&fscache_n_retrievals_nobufs);
 	else
-		fscache_stat(&fscache_n_retrievals_ok);
+		fscache_stat_unchecked(&fscache_n_retrievals_ok);
 
 	fscache_put_retrieval(op);
 	_leave(" = %d", ret);
@@ -511,7 +511,7 @@ nobufs_unlock:
 		__fscache_wake_unused_cookie(cookie);
 	fscache_put_retrieval(op);
 nobufs:
-	fscache_stat(&fscache_n_retrievals_nobufs);
+	fscache_stat_unchecked(&fscache_n_retrievals_nobufs);
 	_leave(" = -ENOBUFS");
 	return -ENOBUFS;
 }
@@ -550,7 +550,7 @@ int __fscache_read_or_alloc_pages(struct fscache_cookie *cookie,
 
 	_enter("%p,,%d,,,", cookie, *nr_pages);
 
-	fscache_stat(&fscache_n_retrievals);
+	fscache_stat_unchecked(&fscache_n_retrievals);
 
 	if (hlist_empty(&cookie->backing_objects))
 		goto nobufs;
@@ -588,7 +588,7 @@ int __fscache_read_or_alloc_pages(struct fscache_cookie *cookie,
 		goto nobufs_unlock_dec;
 	spin_unlock(&cookie->lock);
 
-	fscache_stat(&fscache_n_retrieval_ops);
+	fscache_stat_unchecked(&fscache_n_retrieval_ops);
 
 	/* we wait for the operation to become active, and then process it
 	 * *here*, in this thread, and not in the thread pool */
@@ -614,15 +614,15 @@ int __fscache_read_or_alloc_pages(struct fscache_cookie *cookie,
 
 error:
 	if (ret == -ENOMEM)
-		fscache_stat(&fscache_n_retrievals_nomem);
+		fscache_stat_unchecked(&fscache_n_retrievals_nomem);
 	else if (ret == -ERESTARTSYS)
-		fscache_stat(&fscache_n_retrievals_intr);
+		fscache_stat_unchecked(&fscache_n_retrievals_intr);
 	else if (ret == -ENODATA)
-		fscache_stat(&fscache_n_retrievals_nodata);
+		fscache_stat_unchecked(&fscache_n_retrievals_nodata);
 	else if (ret < 0)
-		fscache_stat(&fscache_n_retrievals_nobufs);
+		fscache_stat_unchecked(&fscache_n_retrievals_nobufs);
 	else
-		fscache_stat(&fscache_n_retrievals_ok);
+		fscache_stat_unchecked(&fscache_n_retrievals_ok);
 
 	fscache_put_retrieval(op);
 	_leave(" = %d", ret);
@@ -637,7 +637,7 @@ nobufs_unlock:
 	if (wake_cookie)
 		__fscache_wake_unused_cookie(cookie);
 nobufs:
-	fscache_stat(&fscache_n_retrievals_nobufs);
+	fscache_stat_unchecked(&fscache_n_retrievals_nobufs);
 	_leave(" = -ENOBUFS");
 	return -ENOBUFS;
 }
@@ -662,7 +662,7 @@ int __fscache_alloc_page(struct fscache_cookie *cookie,
 
 	_enter("%p,%p,,,", cookie, page);
 
-	fscache_stat(&fscache_n_allocs);
+	fscache_stat_unchecked(&fscache_n_allocs);
 
 	if (hlist_empty(&cookie->backing_objects))
 		goto nobufs;
@@ -696,7 +696,7 @@ int __fscache_alloc_page(struct fscache_cookie *cookie,
 		goto nobufs_unlock_dec;
 	spin_unlock(&cookie->lock);
 
-	fscache_stat(&fscache_n_alloc_ops);
+	fscache_stat_unchecked(&fscache_n_alloc_ops);
 
 	ret = fscache_wait_for_operation_activation(
 		object, &op->op,
@@ -712,11 +712,11 @@ int __fscache_alloc_page(struct fscache_cookie *cookie,
 
 error:
 	if (ret == -ERESTARTSYS)
-		fscache_stat(&fscache_n_allocs_intr);
+		fscache_stat_unchecked(&fscache_n_allocs_intr);
 	else if (ret < 0)
-		fscache_stat(&fscache_n_allocs_nobufs);
+		fscache_stat_unchecked(&fscache_n_allocs_nobufs);
 	else
-		fscache_stat(&fscache_n_allocs_ok);
+		fscache_stat_unchecked(&fscache_n_allocs_ok);
 
 	fscache_put_retrieval(op);
 	_leave(" = %d", ret);
@@ -730,7 +730,7 @@ nobufs_unlock:
 	if (wake_cookie)
 		__fscache_wake_unused_cookie(cookie);
 nobufs:
-	fscache_stat(&fscache_n_allocs_nobufs);
+	fscache_stat_unchecked(&fscache_n_allocs_nobufs);
 	_leave(" = -ENOBUFS");
 	return -ENOBUFS;
 }
@@ -806,7 +806,7 @@ static void fscache_write_op(struct fscache_operation *_op)
 
 	spin_lock(&cookie->stores_lock);
 
-	fscache_stat(&fscache_n_store_calls);
+	fscache_stat_unchecked(&fscache_n_store_calls);
 
 	/* find a page to store */
 	page = NULL;
@@ -817,7 +817,7 @@ static void fscache_write_op(struct fscache_operation *_op)
 	page = results[0];
 	_debug("gang %d [%lx]", n, page->index);
 	if (page->index > op->store_limit) {
-		fscache_stat(&fscache_n_store_pages_over_limit);
+		fscache_stat_unchecked(&fscache_n_store_pages_over_limit);
 		goto superseded;
 	}
 
@@ -829,7 +829,7 @@ static void fscache_write_op(struct fscache_operation *_op)
 	spin_unlock(&cookie->stores_lock);
 	spin_unlock(&object->lock);
 
-	fscache_stat(&fscache_n_store_pages);
+	fscache_stat_unchecked(&fscache_n_store_pages);
 	fscache_stat(&fscache_n_cop_write_page);
 	ret = object->cache->ops->write_page(op, page);
 	fscache_stat_d(&fscache_n_cop_write_page);
@@ -933,7 +933,7 @@ int __fscache_write_page(struct fscache_cookie *cookie,
 	ASSERTCMP(cookie->def->type, !=, FSCACHE_COOKIE_TYPE_INDEX);
 	ASSERT(PageFsCache(page));
 
-	fscache_stat(&fscache_n_stores);
+	fscache_stat_unchecked(&fscache_n_stores);
 
 	if (test_bit(FSCACHE_COOKIE_INVALIDATING, &cookie->flags)) {
 		_leave(" = -ENOBUFS [invalidating]");
@@ -992,7 +992,7 @@ int __fscache_write_page(struct fscache_cookie *cookie,
 	spin_unlock(&cookie->stores_lock);
 	spin_unlock(&object->lock);
 
-	op->op.debug_id	= atomic_inc_return(&fscache_op_debug_id);
+	op->op.debug_id	= atomic_inc_return_unchecked(&fscache_op_debug_id);
 	op->store_limit = object->store_limit;
 
 	__fscache_use_cookie(cookie);
@@ -1001,8 +1001,8 @@ int __fscache_write_page(struct fscache_cookie *cookie,
 
 	spin_unlock(&cookie->lock);
 	radix_tree_preload_end();
-	fscache_stat(&fscache_n_store_ops);
-	fscache_stat(&fscache_n_stores_ok);
+	fscache_stat_unchecked(&fscache_n_store_ops);
+	fscache_stat_unchecked(&fscache_n_stores_ok);
 
 	/* the work queue now carries its own ref on the object */
 	fscache_put_operation(&op->op);
@@ -1010,14 +1010,14 @@ int __fscache_write_page(struct fscache_cookie *cookie,
 	return 0;
 
 already_queued:
-	fscache_stat(&fscache_n_stores_again);
+	fscache_stat_unchecked(&fscache_n_stores_again);
 already_pending:
 	spin_unlock(&cookie->stores_lock);
 	spin_unlock(&object->lock);
 	spin_unlock(&cookie->lock);
 	radix_tree_preload_end();
 	fscache_put_operation(&op->op);
-	fscache_stat(&fscache_n_stores_ok);
+	fscache_stat_unchecked(&fscache_n_stores_ok);
 	_leave(" = 0");
 	return 0;
 
@@ -1039,14 +1039,14 @@ nobufs:
 	fscache_put_operation(&op->op);
 	if (wake_cookie)
 		__fscache_wake_unused_cookie(cookie);
-	fscache_stat(&fscache_n_stores_nobufs);
+	fscache_stat_unchecked(&fscache_n_stores_nobufs);
 	_leave(" = -ENOBUFS");
 	return -ENOBUFS;
 
 nomem_free:
 	fscache_put_operation(&op->op);
 nomem:
-	fscache_stat(&fscache_n_stores_oom);
+	fscache_stat_unchecked(&fscache_n_stores_oom);
 	_leave(" = -ENOMEM");
 	return -ENOMEM;
 }
@@ -1064,7 +1064,7 @@ void __fscache_uncache_page(struct fscache_cookie *cookie, struct page *page)
 	ASSERTCMP(cookie->def->type, !=, FSCACHE_COOKIE_TYPE_INDEX);
 	ASSERTCMP(page, !=, NULL);
 
-	fscache_stat(&fscache_n_uncaches);
+	fscache_stat_unchecked(&fscache_n_uncaches);
 
 	/* cache withdrawal may beat us to it */
 	if (!PageFsCache(page))
@@ -1115,7 +1115,7 @@ void fscache_mark_page_cached(struct fscache_retrieval *op, struct page *page)
 	struct fscache_cookie *cookie = op->op.object->cookie;
 
 #ifdef CONFIG_FSCACHE_STATS
-	atomic_inc(&fscache_n_marks);
+	atomic_inc_unchecked(&fscache_n_marks);
 #endif
 
 	_debug("- mark %p{%lx}", page, page->index);
diff --git a/fs/fscache/stats.c b/fs/fscache/stats.c
index 7cfa0aa..d5ef97b7 100644
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
+atomic_unchecked_t fscache_n_op_pend;
+atomic_unchecked_t fscache_n_op_run;
+atomic_unchecked_t fscache_n_op_enqueue;
+atomic_unchecked_t fscache_n_op_requeue;
+atomic_unchecked_t fscache_n_op_deferred_release;
+atomic_unchecked_t fscache_n_op_initialised;
+atomic_unchecked_t fscache_n_op_release;
+atomic_unchecked_t fscache_n_op_gc;
+atomic_unchecked_t fscache_n_op_cancelled;
+atomic_unchecked_t fscache_n_op_rejected;
+
+atomic_unchecked_t fscache_n_attr_changed;
+atomic_unchecked_t fscache_n_attr_changed_ok;
+atomic_unchecked_t fscache_n_attr_changed_nobufs;
+atomic_unchecked_t fscache_n_attr_changed_nomem;
+atomic_unchecked_t fscache_n_attr_changed_calls;
+
+atomic_unchecked_t fscache_n_allocs;
+atomic_unchecked_t fscache_n_allocs_ok;
+atomic_unchecked_t fscache_n_allocs_wait;
+atomic_unchecked_t fscache_n_allocs_nobufs;
+atomic_unchecked_t fscache_n_allocs_intr;
+atomic_unchecked_t fscache_n_allocs_object_dead;
+atomic_unchecked_t fscache_n_alloc_ops;
+atomic_unchecked_t fscache_n_alloc_op_waits;
+
+atomic_unchecked_t fscache_n_retrievals;
+atomic_unchecked_t fscache_n_retrievals_ok;
+atomic_unchecked_t fscache_n_retrievals_wait;
+atomic_unchecked_t fscache_n_retrievals_nodata;
+atomic_unchecked_t fscache_n_retrievals_nobufs;
+atomic_unchecked_t fscache_n_retrievals_intr;
+atomic_unchecked_t fscache_n_retrievals_nomem;
+atomic_unchecked_t fscache_n_retrievals_object_dead;
+atomic_unchecked_t fscache_n_retrieval_ops;
+atomic_unchecked_t fscache_n_retrieval_op_waits;
+
+atomic_unchecked_t fscache_n_stores;
+atomic_unchecked_t fscache_n_stores_ok;
+atomic_unchecked_t fscache_n_stores_again;
+atomic_unchecked_t fscache_n_stores_nobufs;
+atomic_unchecked_t fscache_n_stores_oom;
+atomic_unchecked_t fscache_n_store_ops;
+atomic_unchecked_t fscache_n_store_calls;
+atomic_unchecked_t fscache_n_store_pages;
+atomic_unchecked_t fscache_n_store_radix_deletes;
+atomic_unchecked_t fscache_n_store_pages_over_limit;
+
+atomic_unchecked_t fscache_n_store_vmscan_not_storing;
+atomic_unchecked_t fscache_n_store_vmscan_gone;
+atomic_unchecked_t fscache_n_store_vmscan_busy;
+atomic_unchecked_t fscache_n_store_vmscan_cancelled;
+atomic_unchecked_t fscache_n_store_vmscan_wait;
+
+atomic_unchecked_t fscache_n_marks;
+atomic_unchecked_t fscache_n_uncaches;
+
+atomic_unchecked_t fscache_n_acquires;
+atomic_unchecked_t fscache_n_acquires_null;
+atomic_unchecked_t fscache_n_acquires_no_cache;
+atomic_unchecked_t fscache_n_acquires_ok;
+atomic_unchecked_t fscache_n_acquires_nobufs;
+atomic_unchecked_t fscache_n_acquires_oom;
+
+atomic_unchecked_t fscache_n_invalidates;
+atomic_unchecked_t fscache_n_invalidates_run;
+
+atomic_unchecked_t fscache_n_updates;
+atomic_unchecked_t fscache_n_updates_null;
+atomic_unchecked_t fscache_n_updates_run;
+
+atomic_unchecked_t fscache_n_relinquishes;
+atomic_unchecked_t fscache_n_relinquishes_null;
+atomic_unchecked_t fscache_n_relinquishes_waitcrt;
+atomic_unchecked_t fscache_n_relinquishes_retire;
+
+atomic_unchecked_t fscache_n_cookie_index;
+atomic_unchecked_t fscache_n_cookie_data;
+atomic_unchecked_t fscache_n_cookie_special;
+
+atomic_unchecked_t fscache_n_object_alloc;
+atomic_unchecked_t fscache_n_object_no_alloc;
+atomic_unchecked_t fscache_n_object_lookups;
+atomic_unchecked_t fscache_n_object_lookups_negative;
+atomic_unchecked_t fscache_n_object_lookups_positive;
+atomic_unchecked_t fscache_n_object_lookups_timed_out;
+atomic_unchecked_t fscache_n_object_created;
+atomic_unchecked_t fscache_n_object_avail;
+atomic_unchecked_t fscache_n_object_dead;
+
+atomic_unchecked_t fscache_n_checkaux_none;
+atomic_unchecked_t fscache_n_checkaux_okay;
+atomic_unchecked_t fscache_n_checkaux_update;
+atomic_unchecked_t fscache_n_checkaux_obsolete;
 
 atomic_t fscache_n_cop_alloc_object;
 atomic_t fscache_n_cop_lookup_object;
@@ -144,119 +144,119 @@ static int fscache_stats_show(struct seq_file *m, void *v)
 	seq_puts(m, "FS-Cache statistics\n");
 
 	seq_printf(m, "Cookies: idx=%u dat=%u spc=%u\n",
-		   atomic_read(&fscache_n_cookie_index),
-		   atomic_read(&fscache_n_cookie_data),
-		   atomic_read(&fscache_n_cookie_special));
+		   atomic_read_unchecked(&fscache_n_cookie_index),
+		   atomic_read_unchecked(&fscache_n_cookie_data),
+		   atomic_read_unchecked(&fscache_n_cookie_special));
 
 	seq_printf(m, "Objects: alc=%u nal=%u avl=%u ded=%u\n",
-		   atomic_read(&fscache_n_object_alloc),
-		   atomic_read(&fscache_n_object_no_alloc),
-		   atomic_read(&fscache_n_object_avail),
-		   atomic_read(&fscache_n_object_dead));
+		   atomic_read_unchecked(&fscache_n_object_alloc),
+		   atomic_read_unchecked(&fscache_n_object_no_alloc),
+		   atomic_read_unchecked(&fscache_n_object_avail),
+		   atomic_read_unchecked(&fscache_n_object_dead));
 	seq_printf(m, "ChkAux : non=%u ok=%u upd=%u obs=%u\n",
-		   atomic_read(&fscache_n_checkaux_none),
-		   atomic_read(&fscache_n_checkaux_okay),
-		   atomic_read(&fscache_n_checkaux_update),
-		   atomic_read(&fscache_n_checkaux_obsolete));
+		   atomic_read_unchecked(&fscache_n_checkaux_none),
+		   atomic_read_unchecked(&fscache_n_checkaux_okay),
+		   atomic_read_unchecked(&fscache_n_checkaux_update),
+		   atomic_read_unchecked(&fscache_n_checkaux_obsolete));
 
 	seq_printf(m, "Pages  : mrk=%u unc=%u\n",
-		   atomic_read(&fscache_n_marks),
-		   atomic_read(&fscache_n_uncaches));
+		   atomic_read_unchecked(&fscache_n_marks),
+		   atomic_read_unchecked(&fscache_n_uncaches));
 
 	seq_printf(m, "Acquire: n=%u nul=%u noc=%u ok=%u nbf=%u"
 		   " oom=%u\n",
-		   atomic_read(&fscache_n_acquires),
-		   atomic_read(&fscache_n_acquires_null),
-		   atomic_read(&fscache_n_acquires_no_cache),
-		   atomic_read(&fscache_n_acquires_ok),
-		   atomic_read(&fscache_n_acquires_nobufs),
-		   atomic_read(&fscache_n_acquires_oom));
+		   atomic_read_unchecked(&fscache_n_acquires),
+		   atomic_read_unchecked(&fscache_n_acquires_null),
+		   atomic_read_unchecked(&fscache_n_acquires_no_cache),
+		   atomic_read_unchecked(&fscache_n_acquires_ok),
+		   atomic_read_unchecked(&fscache_n_acquires_nobufs),
+		   atomic_read_unchecked(&fscache_n_acquires_oom));
 
 	seq_printf(m, "Lookups: n=%u neg=%u pos=%u crt=%u tmo=%u\n",
-		   atomic_read(&fscache_n_object_lookups),
-		   atomic_read(&fscache_n_object_lookups_negative),
-		   atomic_read(&fscache_n_object_lookups_positive),
-		   atomic_read(&fscache_n_object_created),
-		   atomic_read(&fscache_n_object_lookups_timed_out));
+		   atomic_read_unchecked(&fscache_n_object_lookups),
+		   atomic_read_unchecked(&fscache_n_object_lookups_negative),
+		   atomic_read_unchecked(&fscache_n_object_lookups_positive),
+		   atomic_read_unchecked(&fscache_n_object_created),
+		   atomic_read_unchecked(&fscache_n_object_lookups_timed_out));
 
 	seq_printf(m, "Invals : n=%u run=%u\n",
-		   atomic_read(&fscache_n_invalidates),
-		   atomic_read(&fscache_n_invalidates_run));
+		   atomic_read_unchecked(&fscache_n_invalidates),
+		   atomic_read_unchecked(&fscache_n_invalidates_run));
 
 	seq_printf(m, "Updates: n=%u nul=%u run=%u\n",
-		   atomic_read(&fscache_n_updates),
-		   atomic_read(&fscache_n_updates_null),
-		   atomic_read(&fscache_n_updates_run));
+		   atomic_read_unchecked(&fscache_n_updates),
+		   atomic_read_unchecked(&fscache_n_updates_null),
+		   atomic_read_unchecked(&fscache_n_updates_run));
 
 	seq_printf(m, "Relinqs: n=%u nul=%u wcr=%u rtr=%u\n",
-		   atomic_read(&fscache_n_relinquishes),
-		   atomic_read(&fscache_n_relinquishes_null),
-		   atomic_read(&fscache_n_relinquishes_waitcrt),
-		   atomic_read(&fscache_n_relinquishes_retire));
+		   atomic_read_unchecked(&fscache_n_relinquishes),
+		   atomic_read_unchecked(&fscache_n_relinquishes_null),
+		   atomic_read_unchecked(&fscache_n_relinquishes_waitcrt),
+		   atomic_read_unchecked(&fscache_n_relinquishes_retire));
 
 	seq_printf(m, "AttrChg: n=%u ok=%u nbf=%u oom=%u run=%u\n",
-		   atomic_read(&fscache_n_attr_changed),
-		   atomic_read(&fscache_n_attr_changed_ok),
-		   atomic_read(&fscache_n_attr_changed_nobufs),
-		   atomic_read(&fscache_n_attr_changed_nomem),
-		   atomic_read(&fscache_n_attr_changed_calls));
+		   atomic_read_unchecked(&fscache_n_attr_changed),
+		   atomic_read_unchecked(&fscache_n_attr_changed_ok),
+		   atomic_read_unchecked(&fscache_n_attr_changed_nobufs),
+		   atomic_read_unchecked(&fscache_n_attr_changed_nomem),
+		   atomic_read_unchecked(&fscache_n_attr_changed_calls));
 
 	seq_printf(m, "Allocs : n=%u ok=%u wt=%u nbf=%u int=%u\n",
-		   atomic_read(&fscache_n_allocs),
-		   atomic_read(&fscache_n_allocs_ok),
-		   atomic_read(&fscache_n_allocs_wait),
-		   atomic_read(&fscache_n_allocs_nobufs),
-		   atomic_read(&fscache_n_allocs_intr));
+		   atomic_read_unchecked(&fscache_n_allocs),
+		   atomic_read_unchecked(&fscache_n_allocs_ok),
+		   atomic_read_unchecked(&fscache_n_allocs_wait),
+		   atomic_read_unchecked(&fscache_n_allocs_nobufs),
+		   atomic_read_unchecked(&fscache_n_allocs_intr));
 	seq_printf(m, "Allocs : ops=%u owt=%u abt=%u\n",
-		   atomic_read(&fscache_n_alloc_ops),
-		   atomic_read(&fscache_n_alloc_op_waits),
-		   atomic_read(&fscache_n_allocs_object_dead));
+		   atomic_read_unchecked(&fscache_n_alloc_ops),
+		   atomic_read_unchecked(&fscache_n_alloc_op_waits),
+		   atomic_read_unchecked(&fscache_n_allocs_object_dead));
 
 	seq_printf(m, "Retrvls: n=%u ok=%u wt=%u nod=%u nbf=%u"
 		   " int=%u oom=%u\n",
-		   atomic_read(&fscache_n_retrievals),
-		   atomic_read(&fscache_n_retrievals_ok),
-		   atomic_read(&fscache_n_retrievals_wait),
-		   atomic_read(&fscache_n_retrievals_nodata),
-		   atomic_read(&fscache_n_retrievals_nobufs),
-		   atomic_read(&fscache_n_retrievals_intr),
-		   atomic_read(&fscache_n_retrievals_nomem));
+		   atomic_read_unchecked(&fscache_n_retrievals),
+		   atomic_read_unchecked(&fscache_n_retrievals_ok),
+		   atomic_read_unchecked(&fscache_n_retrievals_wait),
+		   atomic_read_unchecked(&fscache_n_retrievals_nodata),
+		   atomic_read_unchecked(&fscache_n_retrievals_nobufs),
+		   atomic_read_unchecked(&fscache_n_retrievals_intr),
+		   atomic_read_unchecked(&fscache_n_retrievals_nomem));
 	seq_printf(m, "Retrvls: ops=%u owt=%u abt=%u\n",
-		   atomic_read(&fscache_n_retrieval_ops),
-		   atomic_read(&fscache_n_retrieval_op_waits),
-		   atomic_read(&fscache_n_retrievals_object_dead));
+		   atomic_read_unchecked(&fscache_n_retrieval_ops),
+		   atomic_read_unchecked(&fscache_n_retrieval_op_waits),
+		   atomic_read_unchecked(&fscache_n_retrievals_object_dead));
 
 	seq_printf(m, "Stores : n=%u ok=%u agn=%u nbf=%u oom=%u\n",
-		   atomic_read(&fscache_n_stores),
-		   atomic_read(&fscache_n_stores_ok),
-		   atomic_read(&fscache_n_stores_again),
-		   atomic_read(&fscache_n_stores_nobufs),
-		   atomic_read(&fscache_n_stores_oom));
+		   atomic_read_unchecked(&fscache_n_stores),
+		   atomic_read_unchecked(&fscache_n_stores_ok),
+		   atomic_read_unchecked(&fscache_n_stores_again),
+		   atomic_read_unchecked(&fscache_n_stores_nobufs),
+		   atomic_read_unchecked(&fscache_n_stores_oom));
 	seq_printf(m, "Stores : ops=%u run=%u pgs=%u rxd=%u olm=%u\n",
-		   atomic_read(&fscache_n_store_ops),
-		   atomic_read(&fscache_n_store_calls),
-		   atomic_read(&fscache_n_store_pages),
-		   atomic_read(&fscache_n_store_radix_deletes),
-		   atomic_read(&fscache_n_store_pages_over_limit));
+		   atomic_read_unchecked(&fscache_n_store_ops),
+		   atomic_read_unchecked(&fscache_n_store_calls),
+		   atomic_read_unchecked(&fscache_n_store_pages),
+		   atomic_read_unchecked(&fscache_n_store_radix_deletes),
+		   atomic_read_unchecked(&fscache_n_store_pages_over_limit));
 
 	seq_printf(m, "VmScan : nos=%u gon=%u bsy=%u can=%u wt=%u\n",
-		   atomic_read(&fscache_n_store_vmscan_not_storing),
-		   atomic_read(&fscache_n_store_vmscan_gone),
-		   atomic_read(&fscache_n_store_vmscan_busy),
-		   atomic_read(&fscache_n_store_vmscan_cancelled),
-		   atomic_read(&fscache_n_store_vmscan_wait));
+		   atomic_read_unchecked(&fscache_n_store_vmscan_not_storing),
+		   atomic_read_unchecked(&fscache_n_store_vmscan_gone),
+		   atomic_read_unchecked(&fscache_n_store_vmscan_busy),
+		   atomic_read_unchecked(&fscache_n_store_vmscan_cancelled),
+		   atomic_read_unchecked(&fscache_n_store_vmscan_wait));
 
 	seq_printf(m, "Ops    : pend=%u run=%u enq=%u can=%u rej=%u\n",
-		   atomic_read(&fscache_n_op_pend),
-		   atomic_read(&fscache_n_op_run),
-		   atomic_read(&fscache_n_op_enqueue),
-		   atomic_read(&fscache_n_op_cancelled),
-		   atomic_read(&fscache_n_op_rejected));
+		   atomic_read_unchecked(&fscache_n_op_pend),
+		   atomic_read_unchecked(&fscache_n_op_run),
+		   atomic_read_unchecked(&fscache_n_op_enqueue),
+		   atomic_read_unchecked(&fscache_n_op_cancelled),
+		   atomic_read_unchecked(&fscache_n_op_rejected));
 	seq_printf(m, "Ops    : ini=%u dfr=%u rel=%u gc=%u\n",
-		   atomic_read(&fscache_n_op_initialised),
-		   atomic_read(&fscache_n_op_deferred_release),
-		   atomic_read(&fscache_n_op_release),
-		   atomic_read(&fscache_n_op_gc));
+		   atomic_read_unchecked(&fscache_n_op_initialised),
+		   atomic_read_unchecked(&fscache_n_op_deferred_release),
+		   atomic_read_unchecked(&fscache_n_op_release),
+		   atomic_read_unchecked(&fscache_n_op_gc));
 
 	seq_printf(m, "CacheOp: alo=%d luo=%d luc=%d gro=%d\n",
 		   atomic_read(&fscache_n_cop_alloc_object),
diff --git a/fs/inode.c b/fs/inode.c
index d30640f..df4be97 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -834,8 +834,8 @@ unsigned int get_next_ino(void)
 
 #ifdef CONFIG_SMP
 	if (unlikely((res & (LAST_INO_BATCH-1)) == 0)) {
-		static atomic_t shared_last_ino;
-		int next = atomic_add_return(LAST_INO_BATCH, &shared_last_ino);
+		static atomic_unchecked_t shared_last_ino;
+		int next = atomic_add_return_unchecked(LAST_INO_BATCH, &shared_last_ino);
 
 		res = next - LAST_INO_BATCH;
 	}
diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index 7247252..9c58009 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -34,7 +34,7 @@ static DEFINE_MUTEX(kernfs_open_file_mutex);
 
 struct kernfs_open_node {
 	atomic_t		refcnt;
-	atomic_t		event;
+	atomic_unchecked_t	event;
 	wait_queue_head_t	poll;
 	struct list_head	files; /* goes through kernfs_open_file.list */
 };
@@ -163,7 +163,7 @@ static int kernfs_seq_show(struct seq_file *sf, void *v)
 {
 	struct kernfs_open_file *of = sf->private;
 
-	of->event = atomic_read(&of->kn->attr.open->event);
+	of->event = atomic_read_unchecked(&of->kn->attr.open->event);
 
 	return of->kn->attr.ops->seq_show(sf, v);
 }
@@ -207,7 +207,7 @@ static ssize_t kernfs_file_direct_read(struct kernfs_open_file *of,
 		goto out_free;
 	}
 
-	of->event = atomic_read(&of->kn->attr.open->event);
+	of->event = atomic_read_unchecked(&of->kn->attr.open->event);
 	ops = kernfs_ops(of->kn);
 	if (ops->read)
 		len = ops->read(of, buf, len, *ppos);
@@ -569,7 +569,7 @@ static int kernfs_get_open_node(struct kernfs_node *kn,
 		return -ENOMEM;
 
 	atomic_set(&new_on->refcnt, 0);
-	atomic_set(&new_on->event, 1);
+	atomic_set_unchecked(&new_on->event, 1);
 	init_waitqueue_head(&new_on->poll);
 	INIT_LIST_HEAD(&new_on->files);
 	goto retry;
@@ -792,7 +792,7 @@ static unsigned int kernfs_fop_poll(struct file *filp, poll_table *wait)
 
 	kernfs_put_active(kn);
 
-	if (of->event != atomic_read(&on->event))
+	if (of->event != atomic_read_unchecked(&on->event))
 		goto trigger;
 
 	return DEFAULT_POLLMASK;
@@ -823,7 +823,7 @@ repeat:
 
 	on = kn->attr.open;
 	if (on) {
-		atomic_inc(&on->event);
+		atomic_inc_unchecked(&on->event);
 		wake_up_interruptible(&on->poll);
 	}
 
diff --git a/fs/lockd/clntproc.c b/fs/lockd/clntproc.c
index acd3947..1f896e2 100644
--- a/fs/lockd/clntproc.c
+++ b/fs/lockd/clntproc.c
@@ -36,11 +36,11 @@ static const struct rpc_call_ops nlmclnt_cancel_ops;
 /*
  * Cookie counter for NLM requests
  */
-static atomic_t	nlm_cookie = ATOMIC_INIT(0x1234);
+static atomic_unchecked_t	nlm_cookie = ATOMIC_INIT(0x1234);
 
 void nlmclnt_next_cookie(struct nlm_cookie *c)
 {
-	u32	cookie = atomic_inc_return(&nlm_cookie);
+	u32	cookie = atomic_inc_return_unchecked(&nlm_cookie);
 
 	memcpy(c->data, &cookie, 4);
 	c->len=4;
diff --git a/fs/namespace.c b/fs/namespace.c
index 2b8aa15..4e94d1a 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2743,7 +2743,7 @@ static void free_mnt_ns(struct mnt_namespace *ns)
  * number incrementing at 10Ghz will take 12,427 years to wrap which
  * is effectively never, so we can ignore the possibility.
  */
-static atomic64_t mnt_ns_seq = ATOMIC64_INIT(1);
+static atomic64_unchecked_t mnt_ns_seq = ATOMIC64_INIT(1);
 
 static struct mnt_namespace *alloc_mnt_ns(struct user_namespace *user_ns)
 {
@@ -2759,7 +2759,7 @@ static struct mnt_namespace *alloc_mnt_ns(struct user_namespace *user_ns)
 		return ERR_PTR(ret);
 	}
 	new_ns->ns.ops = &mntns_operations;
-	new_ns->seq = atomic64_add_return(1, &mnt_ns_seq);
+	new_ns->seq = atomic64_add_return_unchecked(1, &mnt_ns_seq);
 	atomic_set(&new_ns->count, 1);
 	new_ns->root = NULL;
 	INIT_LIST_HEAD(&new_ns->list);
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 4afbe13..a6a26ce 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1273,16 +1273,16 @@ static int nfs_check_inode_attributes(struct inode *inode, struct nfs_fattr *fat
 	return 0;
 }
 
-static atomic_long_t nfs_attr_generation_counter;
+static atomic_long_unchecked_t nfs_attr_generation_counter;
 
 static unsigned long nfs_read_attr_generation_counter(void)
 {
-	return atomic_long_read(&nfs_attr_generation_counter);
+	return atomic_long_read_unchecked(&nfs_attr_generation_counter);
 }
 
 unsigned long nfs_inc_attr_generation_counter(void)
 {
-	return atomic_long_inc_return(&nfs_attr_generation_counter);
+	return atomic_long_inc_return_unchecked(&nfs_attr_generation_counter);
 }
 EXPORT_SYMBOL_GPL(nfs_inc_attr_generation_counter);
 
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index a95d8e0..a91a5fd 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -48,7 +48,7 @@
 #include <linux/fsnotify_backend.h>
 #include "fsnotify.h"
 
-static atomic_t fsnotify_sync_cookie = ATOMIC_INIT(0);
+static atomic_unchecked_t fsnotify_sync_cookie = ATOMIC_INIT(0);
 
 /**
  * fsnotify_get_cookie - return a unique cookie for use in synchronizing events.
@@ -56,7 +56,7 @@ static atomic_t fsnotify_sync_cookie = ATOMIC_INIT(0);
  */
 u32 fsnotify_get_cookie(void)
 {
-	return atomic_inc_return(&fsnotify_sync_cookie);
+	return atomic_inc_return_unchecked(&fsnotify_sync_cookie);
 }
 EXPORT_SYMBOL_GPL(fsnotify_get_cookie);
 
diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 857bbbc..3c47d15 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -1320,7 +1320,7 @@ static int ocfs2_local_alloc_slide_window(struct ocfs2_super *osb,
 		goto bail;
 	}
 
-	atomic_inc(&osb->alloc_stats.moves);
+	atomic_inc_unchecked(&osb->alloc_stats.moves);
 
 bail:
 	if (handle)
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 690ddc6..f2d4c4d 100644
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
+	atomic_unchecked_t moves;
+	atomic_unchecked_t local_data;
+	atomic_unchecked_t bitmap_data;
+	atomic_unchecked_t bg_allocs;
+	atomic_unchecked_t bg_extends;
 };
 
 enum ocfs2_local_alloc_state
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 4479029..5de740b 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -867,7 +867,7 @@ static int ocfs2_reserve_suballoc_bits(struct ocfs2_super *osb,
 				mlog_errno(status);
 			goto bail;
 		}
-		atomic_inc(&osb->alloc_stats.bg_extends);
+		atomic_inc_unchecked(&osb->alloc_stats.bg_extends);
 
 		/* You should never ask for this much metadata */
 		BUG_ON(bits_wanted >
@@ -2014,7 +2014,7 @@ int ocfs2_claim_metadata(handle_t *handle,
 		mlog_errno(status);
 		goto bail;
 	}
-	atomic_inc(&OCFS2_SB(ac->ac_inode->i_sb)->alloc_stats.bg_allocs);
+	atomic_inc_unchecked(&OCFS2_SB(ac->ac_inode->i_sb)->alloc_stats.bg_allocs);
 
 	*suballoc_loc = res.sr_bg_blkno;
 	*suballoc_bit_start = res.sr_bit_offset;
@@ -2180,7 +2180,7 @@ int ocfs2_claim_new_inode_at_loc(handle_t *handle,
 	trace_ocfs2_claim_new_inode_at_loc((unsigned long long)di_blkno,
 					   res->sr_bits);
 
-	atomic_inc(&OCFS2_SB(ac->ac_inode->i_sb)->alloc_stats.bg_allocs);
+	atomic_inc_unchecked(&OCFS2_SB(ac->ac_inode->i_sb)->alloc_stats.bg_allocs);
 
 	BUG_ON(res->sr_bits != 1);
 
@@ -2222,7 +2222,7 @@ int ocfs2_claim_new_inode(handle_t *handle,
 		mlog_errno(status);
 		goto bail;
 	}
-	atomic_inc(&OCFS2_SB(ac->ac_inode->i_sb)->alloc_stats.bg_allocs);
+	atomic_inc_unchecked(&OCFS2_SB(ac->ac_inode->i_sb)->alloc_stats.bg_allocs);
 
 	BUG_ON(res.sr_bits != 1);
 
@@ -2326,7 +2326,7 @@ int __ocfs2_claim_clusters(handle_t *handle,
 						      cluster_start,
 						      num_clusters);
 		if (!status)
-			atomic_inc(&osb->alloc_stats.local_data);
+			atomic_inc_unchecked(&osb->alloc_stats.local_data);
 	} else {
 		if (min_clusters > (osb->bitmap_cpg - 1)) {
 			/* The only paths asking for contiguousness
@@ -2352,7 +2352,7 @@ int __ocfs2_claim_clusters(handle_t *handle,
 				ocfs2_desc_bitmap_to_cluster_off(ac->ac_inode,
 								 res.sr_bg_blkno,
 								 res.sr_bit_offset);
-			atomic_inc(&osb->alloc_stats.bitmap_data);
+			atomic_inc_unchecked(&osb->alloc_stats.bitmap_data);
 			*num_clusters = res.sr_bits;
 		}
 	}
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index a482e31..81b251d 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -308,11 +308,11 @@ static int ocfs2_osb_dump(struct ocfs2_super *osb, char *buf, int len)
 			"%10s => GlobalAllocs: %d  LocalAllocs: %d  "
 			"SubAllocs: %d  LAWinMoves: %d  SAExtends: %d\n",
 			"Stats",
-			atomic_read(&osb->alloc_stats.bitmap_data),
-			atomic_read(&osb->alloc_stats.local_data),
-			atomic_read(&osb->alloc_stats.bg_allocs),
-			atomic_read(&osb->alloc_stats.moves),
-			atomic_read(&osb->alloc_stats.bg_extends));
+			atomic_read_unchecked(&osb->alloc_stats.bitmap_data),
+			atomic_read_unchecked(&osb->alloc_stats.local_data),
+			atomic_read_unchecked(&osb->alloc_stats.bg_allocs),
+			atomic_read_unchecked(&osb->alloc_stats.moves),
+			atomic_read_unchecked(&osb->alloc_stats.bg_extends));
 
 	out += snprintf(buf + out, len - out,
 			"%10s => State: %u  Descriptor: %llu  Size: %u bits  "
@@ -2095,11 +2095,11 @@ static int ocfs2_initialize_super(struct super_block *sb,
 
 	mutex_init(&osb->system_file_mutex);
 
-	atomic_set(&osb->alloc_stats.moves, 0);
-	atomic_set(&osb->alloc_stats.local_data, 0);
-	atomic_set(&osb->alloc_stats.bitmap_data, 0);
-	atomic_set(&osb->alloc_stats.bg_allocs, 0);
-	atomic_set(&osb->alloc_stats.bg_extends, 0);
+	atomic_set_unchecked(&osb->alloc_stats.moves, 0);
+	atomic_set_unchecked(&osb->alloc_stats.local_data, 0);
+	atomic_set_unchecked(&osb->alloc_stats.bitmap_data, 0);
+	atomic_set_unchecked(&osb->alloc_stats.bg_allocs, 0);
+	atomic_set_unchecked(&osb->alloc_stats.bg_extends, 0);
 
 	/* Copy the blockcheck stats from the superblock probe */
 	osb->osb_ecc_stats = *stats;
diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index d3ebf2e..6ad42d1 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -194,7 +194,7 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 		vmi.used >> 10,
 		vmi.largest_chunk >> 10
 #ifdef CONFIG_MEMORY_FAILURE
-		, atomic_long_read(&num_poisoned_pages) << (PAGE_SHIFT - 10)
+		, atomic_long_read_unchecked(&num_poisoned_pages) << (PAGE_SHIFT - 10)
 #endif
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 		, K(global_page_state(NR_ANON_TRANSPARENT_HUGEPAGES) *
diff --git a/fs/quota/netlink.c b/fs/quota/netlink.c
index bb2869f..d34ada8 100644
--- a/fs/quota/netlink.c
+++ b/fs/quota/netlink.c
@@ -44,7 +44,7 @@ static struct genl_family quota_genl_family = {
 void quota_send_warning(struct kqid qid, dev_t dev,
 			const char warntype)
 {
-	static atomic_t seq;
+	static atomic_unchecked_t seq;
 	struct sk_buff *skb;
 	void *msg_head;
 	int ret;
@@ -60,7 +60,7 @@ void quota_send_warning(struct kqid qid, dev_t dev,
 		  "VFS: Not enough memory to send quota warning.\n");
 		return;
 	}
-	msg_head = genlmsg_put(skb, 0, atomic_add_return(1, &seq),
+	msg_head = genlmsg_put(skb, 0, atomic_add_return_unchecked(1, &seq),
 			&quota_genl_family, 0, QUOTA_NL_C_WARNING);
 	if (!msg_head) {
 		printk(KERN_ERR
diff --git a/fs/reiserfs/do_balan.c b/fs/reiserfs/do_balan.c
index 9c02d96..6562c10 100644
--- a/fs/reiserfs/do_balan.c
+++ b/fs/reiserfs/do_balan.c
@@ -1887,7 +1887,7 @@ void do_balance(struct tree_balance *tb, struct item_head *ih,
 		return;
 	}
 
-	atomic_inc(&fs_generation(tb->tb_sb));
+	atomic_inc_unchecked(&fs_generation(tb->tb_sb));
 	do_balance_starts(tb);
 
 	/*
diff --git a/fs/reiserfs/procfs.c b/fs/reiserfs/procfs.c
index 621b9f3..af527fd 100644
--- a/fs/reiserfs/procfs.c
+++ b/fs/reiserfs/procfs.c
@@ -114,7 +114,7 @@ static int show_super(struct seq_file *m, void *unused)
 		   "SMALL_TAILS " : "NO_TAILS ",
 		   replay_only(sb) ? "REPLAY_ONLY " : "",
 		   convert_reiserfs(sb) ? "CONV " : "",
-		   atomic_read(&r->s_generation_counter),
+		   atomic_read_unchecked(&r->s_generation_counter),
 		   SF(s_disk_reads), SF(s_disk_writes), SF(s_fix_nodes),
 		   SF(s_do_balance), SF(s_unneeded_left_neighbor),
 		   SF(s_good_search_by_key_reada), SF(s_bmaps),
diff --git a/fs/reiserfs/reiserfs.h b/fs/reiserfs/reiserfs.h
index 2adcde1..7d27bc8 100644
--- a/fs/reiserfs/reiserfs.h
+++ b/fs/reiserfs/reiserfs.h
@@ -580,7 +580,7 @@ struct reiserfs_sb_info {
 	/* Comment? -Hans */
 	wait_queue_head_t s_wait;
 	/* increased by one every time the  tree gets re-balanced */
-	atomic_t s_generation_counter;
+	atomic_unchecked_t s_generation_counter;
 
 	/* File system properties. Currently holds on-disk FS format */
 	unsigned long s_properties;
@@ -2300,7 +2300,7 @@ static inline loff_t max_reiserfs_offset(struct inode *inode)
 #define REISERFS_USER_MEM		1	/* user memory mode */
 
 #define fs_generation(s) (REISERFS_SB(s)->s_generation_counter)
-#define get_generation(s) atomic_read (&fs_generation(s))
+#define get_generation(s) atomic_read_unchecked (&fs_generation(s))
 #define FILESYSTEM_CHANGED_TB(tb)  (get_generation((tb)->tb_sb) != (tb)->fs_gen)
 #define __fs_changed(gen,s) (gen != get_generation (s))
 #define fs_changed(gen,s)		\
diff --git a/include/linux/fscache-cache.h b/include/linux/fscache-cache.h
index 604e152..5954d0d 100644
--- a/include/linux/fscache-cache.h
+++ b/include/linux/fscache-cache.h
@@ -117,7 +117,7 @@ struct fscache_operation {
 	fscache_operation_release_t release;
 };
 
-extern atomic_t fscache_op_debug_id;
+extern atomic_unchecked_t fscache_op_debug_id;
 extern void fscache_op_work_func(struct work_struct *work);
 
 extern void fscache_enqueue_operation(struct fscache_operation *);
-- 
2.5.0
