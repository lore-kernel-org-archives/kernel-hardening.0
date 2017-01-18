Reply-To: kernel-hardening@lists.openwall.com
From: Elena Reshetova <elena.reshetova@intel.com>
Date: Wed, 18 Jan 2017 11:11:39 +0200
Message-Id: <1484730707-29313-11-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1484730707-29313-1-git-send-email-elena.reshetova@intel.com>
References: <1484730707-29313-1-git-send-email-elena.reshetova@intel.com>
Subject: [kernel-hardening] [RFCv2 PATCH 10/18] fs: convert from atomic_t to refcount_t
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
 arch/powerpc/platforms/cell/spufs/file.c        |  2 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c |  2 +-
 fs/afs/cell.c                                   | 20 +++---
 fs/afs/internal.h                               | 18 ++---
 fs/afs/proc.c                                   |  6 +-
 fs/afs/server.c                                 | 20 +++---
 fs/afs/vlocation.c                              | 16 ++---
 fs/afs/volume.c                                 |  6 +-
 fs/btrfs/backref.c                              |  2 +-
 fs/btrfs/compression.c                          | 18 ++---
 fs/btrfs/ctree.c                                |  2 +-
 fs/btrfs/ctree.h                                |  7 +-
 fs/btrfs/delayed-inode.c                        | 46 ++++++-------
 fs/btrfs/delayed-inode.h                        |  5 +-
 fs/btrfs/delayed-ref.c                          |  8 +--
 fs/btrfs/delayed-ref.h                          |  8 ++-
 fs/btrfs/disk-io.c                              | 14 ++--
 fs/btrfs/disk-io.h                              |  4 +-
 fs/btrfs/extent-tree.c                          | 28 ++++----
 fs/btrfs/extent_io.c                            | 91 ++++++++++++-------------
 fs/btrfs/extent_io.h                            |  9 +--
 fs/btrfs/extent_map.c                           | 10 +--
 fs/btrfs/extent_map.h                           |  3 +-
 fs/btrfs/free-space-cache.c                     |  4 +-
 fs/btrfs/ordered-data.c                         | 20 +++---
 fs/btrfs/ordered-data.h                         |  2 +-
 fs/btrfs/raid56.c                               | 19 +++---
 fs/btrfs/scrub.c                                | 42 ++++++------
 fs/btrfs/transaction.c                          | 20 +++---
 fs/btrfs/transaction.h                          |  3 +-
 fs/btrfs/tree-log.c                             |  2 +-
 fs/btrfs/volumes.c                              | 10 +--
 fs/btrfs/volumes.h                              |  2 +-
 fs/cachefiles/bind.c                            |  2 +-
 fs/cachefiles/interface.c                       | 18 ++---
 fs/cachefiles/internal.h                        |  3 +-
 fs/cachefiles/namei.c                           |  2 +-
 fs/cachefiles/rdwr.c                            |  2 +-
 fs/ceph/caps.c                                  |  4 +-
 fs/ceph/file.c                                  |  7 +-
 fs/ceph/mds_client.c                            | 20 +++---
 fs/ceph/mds_client.h                            |  5 +-
 fs/ceph/snap.c                                  |  2 +-
 fs/ceph/super.h                                 |  5 +-
 fs/cifs/cifsfs.c                                |  2 +-
 fs/cifs/cifsglob.h                              |  5 +-
 fs/cifs/connect.c                               |  4 +-
 fs/cifs/inode.c                                 |  2 +-
 fs/devpts/inode.c                               |  2 +-
 fs/f2fs/acl.c                                   |  2 +-
 fs/fscache/cache.c                              |  8 +--
 fs/fscache/operation.c                          | 38 +++++------
 fs/fscache/page.c                               |  2 +-
 fs/fuse/dev.c                                   | 10 +--
 fs/fuse/file.c                                  |  8 +--
 fs/fuse/fuse_i.h                                |  7 +-
 fs/fuse/inode.c                                 |  6 +-
 fs/gfs2/super.c                                 |  2 +-
 fs/hfs/bnode.c                                  | 14 ++--
 fs/hfs/btree.c                                  |  4 +-
 fs/hfs/btree.h                                  |  3 +-
 fs/hfs/inode.c                                  |  4 +-
 fs/hfsplus/bnode.c                              | 14 ++--
 fs/hfsplus/btree.c                              |  4 +-
 fs/hfsplus/dir.c                                |  4 +-
 fs/hfsplus/hfsplus_fs.h                         |  5 +-
 fs/hfsplus/inode.c                              | 10 +--
 fs/hfsplus/super.c                              |  2 +-
 fs/inode.c                                      |  3 +-
 fs/kernfs/dir.c                                 | 10 +--
 fs/kernfs/mount.c                               |  2 +-
 fs/lockd/clntproc.c                             | 14 ++--
 fs/lockd/host.c                                 | 16 ++---
 fs/lockd/mon.c                                  | 14 ++--
 fs/lockd/svcproc.c                              |  2 +-
 fs/mbcache.c                                    | 16 ++---
 fs/mount.h                                      |  5 +-
 fs/namespace.c                                  |  8 +--
 fs/ncpfs/sock.c                                 |  9 +--
 fs/nfs/cache_lib.c                              |  6 +-
 fs/nfs/cache_lib.h                              |  2 +-
 fs/nfs/client.c                                 | 12 ++--
 fs/nfs/dir.c                                    |  8 +--
 fs/nfs/filelayout/filelayout.c                  | 12 ++--
 fs/nfs/flexfilelayout/flexfilelayout.c          | 20 +++---
 fs/nfs/flexfilelayout/flexfilelayout.h          |  3 +-
 fs/nfs/inode.c                                  | 12 ++--
 fs/nfs/nfs4_fs.h                                |  7 +-
 fs/nfs/nfs4client.c                             | 16 ++---
 fs/nfs/nfs4proc.c                               | 26 +++----
 fs/nfs/nfs4state.c                              | 36 +++++-----
 fs/nfs/pnfs.c                                   | 32 ++++-----
 fs/nfs/pnfs.h                                   |  9 +--
 fs/nfs/pnfs_nfs.c                               | 10 +--
 fs/nfs/super.c                                  |  4 +-
 fs/nfsd/nfs4layouts.c                           |  4 +-
 fs/nfsd/nfs4state.c                             | 72 +++++++++----------
 fs/nfsd/state.h                                 | 15 ++--
 fs/nilfs2/the_nilfs.c                           |  8 +--
 fs/nilfs2/the_nilfs.h                           |  5 +-
 fs/notify/group.c                               |  6 +-
 fs/notify/inotify/inotify_user.c                |  4 +-
 fs/notify/mark.c                                |  6 +-
 fs/ntfs/aops.c                                  |  2 +-
 fs/ntfs/inode.c                                 |  6 +-
 fs/ntfs/inode.h                                 |  4 +-
 fs/ntfs/mft.c                                   | 36 +++++-----
 fs/ocfs2/filecheck.c                            | 17 +++--
 fs/posix_acl.c                                  |  6 +-
 fs/proc/generic.c                               |  4 +-
 fs/proc/internal.h                              |  5 +-
 fs/proc/root.c                                  |  2 +-
 fs/super.c                                      | 10 +--
 fs/userfaultfd.c                                |  9 +--
 fs/xfs/xfs_bmap_item.c                          |  4 +-
 fs/xfs/xfs_bmap_item.h                          |  4 +-
 fs/xfs/xfs_buf.c                                | 34 ++++-----
 fs/xfs/xfs_buf.h                                |  7 +-
 fs/xfs/xfs_buf_item.c                           | 16 ++---
 fs/xfs/xfs_buf_item.h                           |  4 +-
 fs/xfs/xfs_extfree_item.c                       |  4 +-
 fs/xfs/xfs_extfree_item.h                       |  4 +-
 fs/xfs/xfs_inode.h                              |  2 +-
 fs/xfs/xfs_log.c                                | 37 +++++-----
 fs/xfs/xfs_log_priv.h                           |  6 +-
 fs/xfs/xfs_refcount_item.c                      |  4 +-
 fs/xfs/xfs_refcount_item.h                      |  4 +-
 fs/xfs/xfs_rmap_item.c                          |  4 +-
 fs/xfs/xfs_rmap_item.h                          |  4 +-
 fs/xfs/xfs_trace.h                              | 10 +--
 fs/xfs/xfs_trans_buf.c                          | 32 ++++-----
 include/linux/fs.h                              |  3 +-
 include/linux/fscache-cache.h                   |  7 +-
 include/linux/fsnotify_backend.h                |  5 +-
 include/linux/kernfs.h                          |  3 +-
 include/linux/lockd/lockd.h                     |  9 +--
 include/linux/mbcache.h                         |  6 +-
 include/linux/nfs_fs.h                          |  3 +-
 include/linux/nfs_fs_sb.h                       |  5 +-
 include/linux/posix_acl.h                       |  7 +-
 include/trace/events/btrfs.h                    |  6 +-
 ipc/msgutil.c                                   |  2 +-
 142 files changed, 760 insertions(+), 712 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spufs/file.c b/arch/powerpc/platforms/cell/spufs/file.c
index a35e2c2..01218a7 100644
--- a/arch/powerpc/platforms/cell/spufs/file.c
+++ b/arch/powerpc/platforms/cell/spufs/file.c
@@ -1492,7 +1492,7 @@ static int spufs_mfc_open(struct inode *inode, struct file *file)
 	if (ctx->owner != current->mm)
 		return -EINVAL;
 
-	if (atomic_read(&inode->i_count) != 1)
+	if (refcount_read(&inode->i_count) != 1)
 		return -EBUSY;
 
 	mutex_lock(&ctx->mapping_lock);
diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index 25f5aed..3b8aff9 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -2000,7 +2000,7 @@ void ll_umount_begin(struct super_block *sb)
 	struct obd_ioctl_data *ioc_data;
 
 	CDEBUG(D_VFSTRACE, "VFS Op: superblock %p count %d active %d\n", sb,
-	       sb->s_count, atomic_read(&sb->s_active));
+	       sb->s_count, refcount_read(&sb->s_active));
 
 	obd = class_exp2obd(sbi->ll_md_exp);
 	if (!obd) {
diff --git a/fs/afs/cell.c b/fs/afs/cell.c
index ca0a3cf..e0440c0 100644
--- a/fs/afs/cell.c
+++ b/fs/afs/cell.c
@@ -60,7 +60,7 @@ static struct afs_cell *afs_cell_alloc(const char *name, unsigned namelen,
 	memcpy(cell->name, name, namelen);
 	cell->name[namelen] = 0;
 
-	atomic_set(&cell->usage, 1);
+	refcount_set(&cell->usage, 1);
 	INIT_LIST_HEAD(&cell->link);
 	rwlock_init(&cell->servers_lock);
 	INIT_LIST_HEAD(&cell->servers);
@@ -345,15 +345,15 @@ void afs_put_cell(struct afs_cell *cell)
 	if (!cell)
 		return;
 
-	_enter("%p{%d,%s}", cell, atomic_read(&cell->usage), cell->name);
+	_enter("%p{%d,%s}", cell, refcount_read(&cell->usage), cell->name);
 
-	ASSERTCMP(atomic_read(&cell->usage), >, 0);
+	ASSERTCMP(refcount_read(&cell->usage), >, 0);
 
 	/* to prevent a race, the decrement and the dequeue must be effectively
 	 * atomic */
 	write_lock(&afs_cells_lock);
 
-	if (likely(!atomic_dec_and_test(&cell->usage))) {
+	if (likely(!refcount_dec_and_test(&cell->usage))) {
 		write_unlock(&afs_cells_lock);
 		_leave("");
 		return;
@@ -376,20 +376,20 @@ void afs_put_cell(struct afs_cell *cell)
  */
 static void afs_cell_destroy(struct afs_cell *cell)
 {
-	_enter("%p{%d,%s}", cell, atomic_read(&cell->usage), cell->name);
+	_enter("%p{%d,%s}", cell, refcount_read(&cell->usage), cell->name);
 
-	ASSERTCMP(atomic_read(&cell->usage), >=, 0);
+	ASSERTCMP(refcount_read(&cell->usage), >=, 0);
 	ASSERT(list_empty(&cell->link));
 
 	/* wait for everyone to stop using the cell */
-	if (atomic_read(&cell->usage) > 0) {
+	if (refcount_read(&cell->usage) > 0) {
 		DECLARE_WAITQUEUE(myself, current);
 
 		_debug("wait for cell %s", cell->name);
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		add_wait_queue(&afs_cells_freeable_wq, &myself);
 
-		while (atomic_read(&cell->usage) > 0) {
+		while (refcount_read(&cell->usage) > 0) {
 			schedule();
 			set_current_state(TASK_UNINTERRUPTIBLE);
 		}
@@ -399,7 +399,7 @@ static void afs_cell_destroy(struct afs_cell *cell)
 	}
 
 	_debug("cell dead");
-	ASSERTCMP(atomic_read(&cell->usage), ==, 0);
+	ASSERTCMP(refcount_read(&cell->usage), ==, 0);
 	ASSERT(list_empty(&cell->servers));
 	ASSERT(list_empty(&cell->vl_list));
 
@@ -448,7 +448,7 @@ void afs_cell_purge(void)
 
 		if (cell) {
 			_debug("PURGING CELL %s (%d)",
-			       cell->name, atomic_read(&cell->usage));
+			       cell->name, refcount_read(&cell->usage));
 
 			/* now the cell should be left with no references */
 			afs_cell_destroy(cell);
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 535a38d..0699072 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -187,7 +187,7 @@ struct afs_cache_cell {
  * AFS cell record
  */
 struct afs_cell {
-	atomic_t		usage;
+	refcount_t		usage;
 	struct list_head	link;		/* main cell list link */
 	struct key		*anonymous_key;	/* anonymous user key for this cell */
 	struct list_head	proc_link;	/* /proc cell list link */
@@ -241,7 +241,7 @@ struct afs_cache_vhash {
  * AFS volume location record
  */
 struct afs_vlocation {
-	atomic_t		usage;
+	refcount_t		usage;
 	time_t			time_of_death;	/* time at which put reduced usage to 0 */
 	struct list_head	link;		/* link in cell volume location list */
 	struct list_head	grave;		/* link in master graveyard list */
@@ -265,7 +265,7 @@ struct afs_vlocation {
  * AFS fileserver record
  */
 struct afs_server {
-	atomic_t		usage;
+	refcount_t		usage;
 	time_t			time_of_death;	/* time at which put reduced usage to 0 */
 	struct in_addr		addr;		/* server address */
 	struct afs_cell		*cell;		/* cell in which server resides */
@@ -297,7 +297,7 @@ struct afs_server {
  * AFS volume access record
  */
 struct afs_volume {
-	atomic_t		usage;
+	refcount_t		usage;
 	struct afs_cell		*cell;		/* cell to which belongs (unrefd ptr) */
 	struct afs_vlocation	*vlocation;	/* volume location */
 #ifdef CONFIG_AFS_FSCACHE
@@ -464,7 +464,7 @@ extern void afs_callback_update_kill(void);
 extern struct rw_semaphore afs_proc_cells_sem;
 extern struct list_head afs_proc_cells;
 
-#define afs_get_cell(C) do { atomic_inc(&(C)->usage); } while(0)
+#define afs_get_cell(C) do { refcount_inc(&(C)->usage); } while(0)
 extern int afs_cell_init(char *);
 extern struct afs_cell *afs_cell_create(const char *, unsigned, char *, bool);
 extern struct afs_cell *afs_cell_lookup(const char *, unsigned, bool);
@@ -636,8 +636,8 @@ extern spinlock_t afs_server_peer_lock;
 
 #define afs_get_server(S)					\
 do {								\
-	_debug("GET SERVER %d", atomic_read(&(S)->usage));	\
-	atomic_inc(&(S)->usage);				\
+	_debug("GET SERVER %d", refcount_read(&(S)->usage));	\
+	refcount_inc(&(S)->usage);				\
 } while(0)
 
 extern struct afs_server *afs_lookup_server(struct afs_cell *,
@@ -672,7 +672,7 @@ extern int afs_vl_get_entry_by_id(struct in_addr *, struct key *,
 /*
  * vlocation.c
  */
-#define afs_get_vlocation(V) do { atomic_inc(&(V)->usage); } while(0)
+#define afs_get_vlocation(V) do { refcount_inc(&(V)->usage); } while(0)
 
 extern int __init afs_vlocation_update_init(void);
 extern struct afs_vlocation *afs_vlocation_lookup(struct afs_cell *,
@@ -725,7 +725,7 @@ extern int afs_vnode_release_lock(struct afs_vnode *, struct key *);
 /*
  * volume.c
  */
-#define afs_get_volume(V) do { atomic_inc(&(V)->usage); } while(0)
+#define afs_get_volume(V) do { refcount_inc(&(V)->usage); } while(0)
 
 extern void afs_put_volume(struct afs_volume *);
 extern struct afs_volume *afs_volume_lookup(struct afs_mount_params *);
diff --git a/fs/afs/proc.c b/fs/afs/proc.c
index 35efb9a..57bf6fb 100644
--- a/fs/afs/proc.c
+++ b/fs/afs/proc.c
@@ -212,7 +212,7 @@ static int afs_proc_cells_show(struct seq_file *m, void *v)
 
 	/* display one cell per line on subsequent lines */
 	seq_printf(m, "%3d %s\n",
-		   atomic_read(&cell->usage), cell->name);
+		   refcount_read(&cell->usage), cell->name);
 	return 0;
 }
 
@@ -461,7 +461,7 @@ static int afs_proc_cell_volumes_show(struct seq_file *m, void *v)
 
 	/* display one cell per line on subsequent lines */
 	seq_printf(m, "%3d %s %08x %08x %08x %s\n",
-		   atomic_read(&vlocation->usage),
+		   refcount_read(&vlocation->usage),
 		   afs_vlocation_states[vlocation->state],
 		   vlocation->vldb.vid[0],
 		   vlocation->vldb.vid[1],
@@ -647,7 +647,7 @@ static int afs_proc_cell_servers_show(struct seq_file *m, void *v)
 	/* display one cell per line on subsequent lines */
 	sprintf(ipaddr, "%pI4", &server->addr);
 	seq_printf(m, "%3d %-15.15s %5d\n",
-		   atomic_read(&server->usage), ipaddr, server->fs_state);
+		   refcount_read(&server->usage), ipaddr, server->fs_state);
 
 	return 0;
 }
diff --git a/fs/afs/server.c b/fs/afs/server.c
index d4066ab..958f63b 100644
--- a/fs/afs/server.c
+++ b/fs/afs/server.c
@@ -75,7 +75,7 @@ static struct afs_server *afs_alloc_server(struct afs_cell *cell,
 
 	server = kzalloc(sizeof(struct afs_server), GFP_KERNEL);
 	if (server) {
-		atomic_set(&server->usage, 1);
+		refcount_set(&server->usage, 1);
 		server->cell = cell;
 
 		INIT_LIST_HEAD(&server->link);
@@ -91,7 +91,7 @@ static struct afs_server *afs_alloc_server(struct afs_cell *cell,
 
 		memcpy(&server->addr, addr, sizeof(struct in_addr));
 		server->addr.s_addr = addr->s_addr;
-		_leave(" = %p{%d}", server, atomic_read(&server->usage));
+		_leave(" = %p{%d}", server, refcount_read(&server->usage));
 	} else {
 		_leave(" = NULL [nomem]");
 	}
@@ -140,7 +140,7 @@ struct afs_server *afs_lookup_server(struct afs_cell *cell,
 	list_add_tail(&server->link, &cell->servers);
 
 	write_unlock(&cell->servers_lock);
-	_leave(" = %p{%d}", server, atomic_read(&server->usage));
+	_leave(" = %p{%d}", server, refcount_read(&server->usage));
 	return server;
 
 	/* found a matching server quickly */
@@ -154,7 +154,7 @@ struct afs_server *afs_lookup_server(struct afs_cell *cell,
 		list_del_init(&server->grave);
 		spin_unlock(&afs_server_graveyard_lock);
 	}
-	_leave(" = %p{%d}", server, atomic_read(&server->usage));
+	_leave(" = %p{%d}", server, refcount_read(&server->usage));
 	return server;
 
 	/* found a matching server on the second pass */
@@ -226,13 +226,13 @@ void afs_put_server(struct afs_server *server)
 	if (!server)
 		return;
 
-	_enter("%p{%d}", server, atomic_read(&server->usage));
+	_enter("%p{%d}", server, refcount_read(&server->usage));
 
-	_debug("PUT SERVER %d", atomic_read(&server->usage));
+	_debug("PUT SERVER %d", refcount_read(&server->usage));
 
-	ASSERTCMP(atomic_read(&server->usage), >, 0);
+	ASSERTCMP(refcount_read(&server->usage), >, 0);
 
-	if (likely(!atomic_dec_and_test(&server->usage))) {
+	if (likely(!refcount_dec_and_test(&server->usage))) {
 		_leave("");
 		return;
 	}
@@ -240,7 +240,7 @@ void afs_put_server(struct afs_server *server)
 	afs_flush_callback_breaks(server);
 
 	spin_lock(&afs_server_graveyard_lock);
-	if (atomic_read(&server->usage) == 0) {
+	if (refcount_read(&server->usage) == 0) {
 		list_move_tail(&server->grave, &afs_server_graveyard);
 		server->time_of_death = get_seconds();
 		queue_delayed_work(afs_wq, &afs_server_reaper,
@@ -296,7 +296,7 @@ static void afs_reap_server(struct work_struct *work)
 
 		write_lock(&server->cell->servers_lock);
 		write_lock(&afs_servers_lock);
-		if (atomic_read(&server->usage) > 0) {
+		if (refcount_read(&server->usage) > 0) {
 			list_del_init(&server->grave);
 		} else {
 			list_move_tail(&server->grave, &corpses);
diff --git a/fs/afs/vlocation.c b/fs/afs/vlocation.c
index 45a8639..8e10011 100644
--- a/fs/afs/vlocation.c
+++ b/fs/afs/vlocation.c
@@ -176,7 +176,7 @@ static struct afs_vlocation *afs_vlocation_alloc(struct afs_cell *cell,
 	if (vl) {
 		vl->cell = cell;
 		vl->state = AFS_VL_NEW;
-		atomic_set(&vl->usage, 1);
+		refcount_set(&vl->usage, 1);
 		INIT_LIST_HEAD(&vl->link);
 		INIT_LIST_HEAD(&vl->grave);
 		INIT_LIST_HEAD(&vl->update);
@@ -432,7 +432,7 @@ struct afs_vlocation *afs_vlocation_lookup(struct afs_cell *cell,
 found_in_memory:
 	/* found in memory */
 	_debug("found in memory");
-	atomic_inc(&vl->usage);
+	refcount_inc(&vl->usage);
 	spin_unlock(&cell->vl_lock);
 	if (!list_empty(&vl->grave)) {
 		spin_lock(&afs_vlocation_graveyard_lock);
@@ -495,15 +495,15 @@ void afs_put_vlocation(struct afs_vlocation *vl)
 
 	_enter("%s", vl->vldb.name);
 
-	ASSERTCMP(atomic_read(&vl->usage), >, 0);
+	ASSERTCMP(refcount_read(&vl->usage), >, 0);
 
-	if (likely(!atomic_dec_and_test(&vl->usage))) {
+	if (likely(!refcount_dec_and_test(&vl->usage))) {
 		_leave("");
 		return;
 	}
 
 	spin_lock(&afs_vlocation_graveyard_lock);
-	if (atomic_read(&vl->usage) == 0) {
+	if (refcount_read(&vl->usage) == 0) {
 		_debug("buried");
 		list_move_tail(&vl->grave, &afs_vlocation_graveyard);
 		vl->time_of_death = get_seconds();
@@ -566,7 +566,7 @@ static void afs_vlocation_reaper(struct work_struct *work)
 		}
 
 		spin_lock(&vl->cell->vl_lock);
-		if (atomic_read(&vl->usage) > 0) {
+		if (refcount_read(&vl->usage) > 0) {
 			_debug("no reap");
 			list_del_init(&vl->grave);
 		} else {
@@ -641,7 +641,7 @@ static void afs_vlocation_updater(struct work_struct *work)
 
 		vl = list_entry(afs_vlocation_updates.next,
 				struct afs_vlocation, update);
-		if (atomic_read(&vl->usage) > 0)
+		if (refcount_read(&vl->usage) > 0)
 			break;
 		list_del_init(&vl->update);
 	}
@@ -656,7 +656,7 @@ static void afs_vlocation_updater(struct work_struct *work)
 	}
 
 	list_del_init(&vl->update);
-	atomic_inc(&vl->usage);
+	refcount_inc(&vl->usage);
 	spin_unlock(&afs_vlocation_updates_lock);
 
 	/* we can now perform the update */
diff --git a/fs/afs/volume.c b/fs/afs/volume.c
index d142a24..22414fd 100644
--- a/fs/afs/volume.c
+++ b/fs/afs/volume.c
@@ -100,7 +100,7 @@ struct afs_volume *afs_volume_lookup(struct afs_mount_params *params)
 	if (!volume)
 		goto error_up;
 
-	atomic_set(&volume->usage, 1);
+	refcount_set(&volume->usage, 1);
 	volume->type		= params->type;
 	volume->type_force	= params->force;
 	volume->cell		= params->cell;
@@ -179,7 +179,7 @@ void afs_put_volume(struct afs_volume *volume)
 
 	_enter("%p", volume);
 
-	ASSERTCMP(atomic_read(&volume->usage), >, 0);
+	ASSERTCMP(refcount_read(&volume->usage), >, 0);
 
 	vlocation = volume->vlocation;
 
@@ -187,7 +187,7 @@ void afs_put_volume(struct afs_volume *volume)
 	 * atomic */
 	down_write(&vlocation->cell->vl_sem);
 
-	if (likely(!atomic_dec_and_test(&volume->usage))) {
+	if (likely(!refcount_dec_and_test(&volume->usage))) {
 		up_write(&vlocation->cell->vl_sem);
 		_leave("");
 		return;
diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 8299601..f285cb0 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1287,7 +1287,7 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 		head = btrfs_find_delayed_ref_head(trans, bytenr);
 		if (head) {
 			if (!mutex_trylock(&head->mutex)) {
-				atomic_inc(&head->node.refs);
+				refcount_inc(&head->node.refs);
 				spin_unlock(&delayed_refs->lock);
 
 				btrfs_release_path(path);
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 7f39084..133a890 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -44,7 +44,7 @@
 
 struct compressed_bio {
 	/* number of bios pending for this compressed extent */
-	atomic_t pending_bios;
+	refcount_t pending_bios;
 
 	/* the pages with the compressed data on them */
 	struct page **compressed_pages;
@@ -163,7 +163,7 @@ static void end_compressed_bio_read(struct bio *bio)
 	/* if there are more bios still pending for this compressed
 	 * extent, just exit
 	 */
-	if (!atomic_dec_and_test(&cb->pending_bios))
+	if (!refcount_dec_and_test(&cb->pending_bios))
 		goto out;
 
 	inode = cb->inode;
@@ -276,7 +276,7 @@ static void end_compressed_bio_write(struct bio *bio)
 	/* if there are more bios still pending for this compressed
 	 * extent, just exit
 	 */
-	if (!atomic_dec_and_test(&cb->pending_bios))
+	if (!refcount_dec_and_test(&cb->pending_bios))
 		goto out;
 
 	/* ok, we're the last bio for this extent, step one is to
@@ -344,7 +344,7 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 	cb = kmalloc(compressed_bio_size(fs_info, compressed_len), GFP_NOFS);
 	if (!cb)
 		return -ENOMEM;
-	atomic_set(&cb->pending_bios, 0);
+	refcount_set(&cb->pending_bios, 0);
 	cb->errors = 0;
 	cb->inode = inode;
 	cb->start = start;
@@ -365,7 +365,7 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 	bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 	bio->bi_private = cb;
 	bio->bi_end_io = end_compressed_bio_write;
-	atomic_inc(&cb->pending_bios);
+	refcount_inc(&cb->pending_bios);
 
 	/* create and submit bios for the compressed pages */
 	bytes_left = compressed_len;
@@ -390,7 +390,7 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 			 * we inc the count.  Otherwise, the cb might get
 			 * freed before we're done setting it up
 			 */
-			atomic_inc(&cb->pending_bios);
+			refcount_inc(&cb->pending_bios);
 			ret = btrfs_bio_wq_end_io(fs_info, bio,
 						  BTRFS_WQ_ENDIO_DATA);
 			BUG_ON(ret); /* -ENOMEM */
@@ -609,7 +609,7 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	if (!cb)
 		goto out;
 
-	atomic_set(&cb->pending_bios, 0);
+	refcount_set(&cb->pending_bios, 0);
 	cb->errors = 0;
 	cb->inode = inode;
 	cb->mirror_num = mirror_num;
@@ -658,7 +658,7 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	bio_set_op_attrs (comp_bio, REQ_OP_READ, 0);
 	comp_bio->bi_private = cb;
 	comp_bio->bi_end_io = end_compressed_bio_read;
-	atomic_inc(&cb->pending_bios);
+	refcount_inc(&cb->pending_bios);
 
 	for (pg_index = 0; pg_index < nr_pages; pg_index++) {
 		page = cb->compressed_pages[pg_index];
@@ -687,7 +687,7 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 			 * we inc the count.  Otherwise, the cb might get
 			 * freed before we're done setting it up
 			 */
-			atomic_inc(&cb->pending_bios);
+			refcount_inc(&cb->pending_bios);
 
 			if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)) {
 				ret = btrfs_lookup_bio_sums(inode, comp_bio,
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index a426dc8..ff70466 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -159,7 +159,7 @@ struct extent_buffer *btrfs_root_node(struct btrfs_root *root)
 		 * the inc_not_zero dance and if it doesn't work then
 		 * synchronize_rcu and try again.
 		 */
-		if (atomic_inc_not_zero(&eb->refs)) {
+		if (refcount_inc_not_zero(&eb->refs)) {
 			rcu_read_unlock();
 			break;
 		}
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 6a82371..c8b2b3b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -38,6 +38,7 @@
 #include <linux/security.h>
 #include <linux/sizes.h>
 #include <linux/dynamic_debug.h>
+#include <linux/refcount.h>
 #include "extent_io.h"
 #include "extent_map.h"
 #include "async-thread.h"
@@ -509,7 +510,7 @@ struct btrfs_caching_control {
 	struct btrfs_work work;
 	struct btrfs_block_group_cache *block_group;
 	u64 progress;
-	atomic_t count;
+	refcount_t count;
 };
 
 /* Once caching_thread() finds this much free space, it will wake up waiters. */
@@ -589,7 +590,7 @@ struct btrfs_block_group_cache {
 	struct list_head list;
 
 	/* usage count */
-	atomic_t count;
+	refcount_t count;
 
 	/* List of struct btrfs_free_clusters for this block group.
 	 * Today it will only have one thing on it, but that may change
@@ -1212,7 +1213,7 @@ struct btrfs_root {
 	dev_t anon_dev;
 
 	spinlock_t root_item_lock;
-	atomic_t refs;
+	refcount_t refs;
 
 	struct mutex delalloc_mutex;
 	spinlock_t delalloc_lock;
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 80982a8..d469d5b0 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -52,7 +52,7 @@ static inline void btrfs_init_delayed_node(
 {
 	delayed_node->root = root;
 	delayed_node->inode_id = inode_id;
-	atomic_set(&delayed_node->refs, 0);
+	refcount_set(&delayed_node->refs, 0);
 	delayed_node->ins_root = RB_ROOT;
 	delayed_node->del_root = RB_ROOT;
 	mutex_init(&delayed_node->mutex);
@@ -81,7 +81,7 @@ static struct btrfs_delayed_node *btrfs_get_delayed_node(struct inode *inode)
 
 	node = ACCESS_ONCE(btrfs_inode->delayed_node);
 	if (node) {
-		atomic_inc(&node->refs);
+		refcount_inc(&node->refs);
 		return node;
 	}
 
@@ -89,14 +89,14 @@ static struct btrfs_delayed_node *btrfs_get_delayed_node(struct inode *inode)
 	node = radix_tree_lookup(&root->delayed_nodes_tree, ino);
 	if (node) {
 		if (btrfs_inode->delayed_node) {
-			atomic_inc(&node->refs);	/* can be accessed */
+			refcount_inc(&node->refs);	/* can be accessed */
 			BUG_ON(btrfs_inode->delayed_node != node);
 			spin_unlock(&root->inode_lock);
 			return node;
 		}
 		btrfs_inode->delayed_node = node;
 		/* can be accessed and cached in the inode */
-		atomic_add(2, &node->refs);
+		refcount_add(2, &node->refs);
 		spin_unlock(&root->inode_lock);
 		return node;
 	}
@@ -126,7 +126,7 @@ static struct btrfs_delayed_node *btrfs_get_or_create_delayed_node(
 	btrfs_init_delayed_node(node, root, ino);
 
 	/* cached in the btrfs inode and can be accessed */
-	atomic_add(2, &node->refs);
+	refcount_add(2, &node->refs);
 
 	ret = radix_tree_preload(GFP_NOFS);
 	if (ret) {
@@ -167,7 +167,7 @@ static void btrfs_queue_delayed_node(struct btrfs_delayed_root *root,
 	} else {
 		list_add_tail(&node->n_list, &root->node_list);
 		list_add_tail(&node->p_list, &root->prepare_list);
-		atomic_inc(&node->refs);	/* inserted into list */
+		refcount_inc(&node->refs);	/* inserted into list */
 		root->nodes++;
 		set_bit(BTRFS_DELAYED_NODE_IN_LIST, &node->flags);
 	}
@@ -181,7 +181,7 @@ static void btrfs_dequeue_delayed_node(struct btrfs_delayed_root *root,
 	spin_lock(&root->lock);
 	if (test_bit(BTRFS_DELAYED_NODE_IN_LIST, &node->flags)) {
 		root->nodes--;
-		atomic_dec(&node->refs);	/* not in the list */
+		refcount_dec(&node->refs);	/* not in the list */
 		list_del_init(&node->n_list);
 		if (!list_empty(&node->p_list))
 			list_del_init(&node->p_list);
@@ -202,7 +202,7 @@ static struct btrfs_delayed_node *btrfs_first_delayed_node(
 
 	p = delayed_root->node_list.next;
 	node = list_entry(p, struct btrfs_delayed_node, n_list);
-	atomic_inc(&node->refs);
+	refcount_inc(&node->refs);
 out:
 	spin_unlock(&delayed_root->lock);
 
@@ -229,7 +229,7 @@ static struct btrfs_delayed_node *btrfs_next_delayed_node(
 		p = node->n_list.next;
 
 	next = list_entry(p, struct btrfs_delayed_node, n_list);
-	atomic_inc(&next->refs);
+	refcount_inc(&next->refs);
 out:
 	spin_unlock(&delayed_root->lock);
 
@@ -254,11 +254,11 @@ static void __btrfs_release_delayed_node(
 		btrfs_dequeue_delayed_node(delayed_root, delayed_node);
 	mutex_unlock(&delayed_node->mutex);
 
-	if (atomic_dec_and_test(&delayed_node->refs)) {
+	if (refcount_dec_and_test(&delayed_node->refs)) {
 		bool free = false;
 		struct btrfs_root *root = delayed_node->root;
 		spin_lock(&root->inode_lock);
-		if (atomic_read(&delayed_node->refs) == 0) {
+		if (refcount_read(&delayed_node->refs) == 0) {
 			radix_tree_delete(&root->delayed_nodes_tree,
 					  delayed_node->inode_id);
 			free = true;
@@ -287,7 +287,7 @@ static struct btrfs_delayed_node *btrfs_first_prepared_delayed_node(
 	p = delayed_root->prepare_list.next;
 	list_del_init(p);
 	node = list_entry(p, struct btrfs_delayed_node, p_list);
-	atomic_inc(&node->refs);
+	refcount_inc(&node->refs);
 out:
 	spin_unlock(&delayed_root->lock);
 
@@ -309,7 +309,7 @@ static struct btrfs_delayed_item *btrfs_alloc_delayed_item(u32 data_len)
 		item->ins_or_del = 0;
 		item->bytes_reserved = 0;
 		item->delayed_node = NULL;
-		atomic_set(&item->refs, 1);
+		refcount_set(&item->refs, 1);
 	}
 	return item;
 }
@@ -484,7 +484,7 @@ static void btrfs_release_delayed_item(struct btrfs_delayed_item *item)
 {
 	if (item) {
 		__btrfs_remove_delayed_item(item);
-		if (atomic_dec_and_test(&item->refs))
+		if (refcount_dec_and_test(&item->refs))
 			kfree(item);
 	}
 }
@@ -1601,14 +1601,14 @@ bool btrfs_readdir_get_delayed_items(struct inode *inode,
 	mutex_lock(&delayed_node->mutex);
 	item = __btrfs_first_delayed_insertion_item(delayed_node);
 	while (item) {
-		atomic_inc(&item->refs);
+		refcount_inc(&item->refs);
 		list_add_tail(&item->readdir_list, ins_list);
 		item = __btrfs_next_delayed_item(item);
 	}
 
 	item = __btrfs_first_delayed_deletion_item(delayed_node);
 	while (item) {
-		atomic_inc(&item->refs);
+		refcount_inc(&item->refs);
 		list_add_tail(&item->readdir_list, del_list);
 		item = __btrfs_next_delayed_item(item);
 	}
@@ -1622,7 +1622,7 @@ bool btrfs_readdir_get_delayed_items(struct inode *inode,
 	 * insert/delete delayed items in this period. So we also needn't
 	 * requeue or dequeue this delayed node.
 	 */
-	atomic_dec(&delayed_node->refs);
+	refcount_dec(&delayed_node->refs);
 
 	return true;
 }
@@ -1635,13 +1635,13 @@ void btrfs_readdir_put_delayed_items(struct inode *inode,
 
 	list_for_each_entry_safe(curr, next, ins_list, readdir_list) {
 		list_del(&curr->readdir_list);
-		if (atomic_dec_and_test(&curr->refs))
+		if (refcount_dec_and_test(&curr->refs))
 			kfree(curr);
 	}
 
 	list_for_each_entry_safe(curr, next, del_list, readdir_list) {
 		list_del(&curr->readdir_list);
-		if (atomic_dec_and_test(&curr->refs))
+		if (refcount_dec_and_test(&curr->refs))
 			kfree(curr);
 	}
 
@@ -1668,7 +1668,7 @@ int btrfs_should_delete_dir_index(struct list_head *del_list,
 		list_del(&curr->readdir_list);
 		ret = (curr->key.offset == index);
 
-		if (atomic_dec_and_test(&curr->refs))
+		if (refcount_dec_and_test(&curr->refs))
 			kfree(curr);
 
 		if (ret)
@@ -1706,7 +1706,7 @@ int btrfs_readdir_delayed_dir_index(struct dir_context *ctx,
 		list_del(&curr->readdir_list);
 
 		if (curr->key.offset < ctx->pos) {
-			if (atomic_dec_and_test(&curr->refs))
+			if (refcount_dec_and_test(&curr->refs))
 				kfree(curr);
 			continue;
 		}
@@ -1723,7 +1723,7 @@ int btrfs_readdir_delayed_dir_index(struct dir_context *ctx,
 		over = !dir_emit(ctx, name, name_len,
 			       location.objectid, d_type);
 
-		if (atomic_dec_and_test(&curr->refs))
+		if (refcount_dec_and_test(&curr->refs))
 			kfree(curr);
 
 		if (over)
@@ -1964,7 +1964,7 @@ void btrfs_kill_all_delayed_nodes(struct btrfs_root *root)
 		inode_id = delayed_nodes[n - 1]->inode_id + 1;
 
 		for (i = 0; i < n; i++)
-			atomic_inc(&delayed_nodes[i]->refs);
+			refcount_inc(&delayed_nodes[i]->refs);
 		spin_unlock(&root->inode_lock);
 
 		for (i = 0; i < n; i++) {
diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
index 8a2bf5e..45545ca 100644
--- a/fs/btrfs/delayed-inode.h
+++ b/fs/btrfs/delayed-inode.h
@@ -26,6 +26,7 @@
 #include <linux/list.h>
 #include <linux/wait.h>
 #include <linux/atomic.h>
+#include <linux/refcount.h>
 
 #include "ctree.h"
 
@@ -67,7 +68,7 @@ struct btrfs_delayed_node {
 	struct rb_root del_root;
 	struct mutex mutex;
 	struct btrfs_inode_item inode_item;
-	atomic_t refs;
+	refcount_t refs;
 	u64 index_cnt;
 	unsigned long flags;
 	int count;
@@ -80,7 +81,7 @@ struct btrfs_delayed_item {
 	struct list_head readdir_list;	/* used for readdir items */
 	u64 bytes_reserved;
 	struct btrfs_delayed_node *delayed_node;
-	atomic_t refs;
+	refcount_t refs;
 	int ins_or_del;
 	u32 data_len;
 	char data[0];
diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index ef724a5..f8b09e5 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -164,7 +164,7 @@ int btrfs_delayed_ref_lock(struct btrfs_trans_handle *trans,
 	if (mutex_trylock(&head->mutex))
 		return 0;
 
-	atomic_inc(&head->node.refs);
+	refcount_inc(&head->node.refs);
 	spin_unlock(&delayed_refs->lock);
 
 	mutex_lock(&head->mutex);
@@ -589,7 +589,7 @@ add_delayed_ref_head(struct btrfs_fs_info *fs_info,
 	delayed_refs = &trans->transaction->delayed_refs;
 
 	/* first set the basic ref node struct up */
-	atomic_set(&ref->refs, 1);
+	refcount_set(&ref->refs, 1);
 	ref->bytenr = bytenr;
 	ref->num_bytes = num_bytes;
 	ref->ref_mod = count_mod;
@@ -677,7 +677,7 @@ add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 	delayed_refs = &trans->transaction->delayed_refs;
 
 	/* first set the basic ref node struct up */
-	atomic_set(&ref->refs, 1);
+	refcount_set(&ref->refs, 1);
 	ref->bytenr = bytenr;
 	ref->num_bytes = num_bytes;
 	ref->ref_mod = 1;
@@ -734,7 +734,7 @@ add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 		seq = atomic64_read(&fs_info->tree_mod_seq);
 
 	/* first set the basic ref node struct up */
-	atomic_set(&ref->refs, 1);
+	refcount_set(&ref->refs, 1);
 	ref->bytenr = bytenr;
 	ref->num_bytes = num_bytes;
 	ref->ref_mod = 1;
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index 50947b5..a96032a 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -18,6 +18,8 @@
 #ifndef __DELAYED_REF__
 #define __DELAYED_REF__
 
+#include <linux/refcount.h>
+
 /* these are the possible values of struct btrfs_delayed_ref_node->action */
 #define BTRFS_ADD_DELAYED_REF    1 /* add one backref to the tree */
 #define BTRFS_DROP_DELAYED_REF   2 /* delete one backref from the tree */
@@ -53,7 +55,7 @@ struct btrfs_delayed_ref_node {
 	u64 seq;
 
 	/* ref count on this data structure */
-	atomic_t refs;
+	refcount_t refs;
 
 	/*
 	 * how many refs is this entry adding or deleting.  For
@@ -220,8 +222,8 @@ btrfs_free_delayed_extent_op(struct btrfs_delayed_extent_op *op)
 
 static inline void btrfs_put_delayed_ref(struct btrfs_delayed_ref_node *ref)
 {
-	WARN_ON(atomic_read(&ref->refs) == 0);
-	if (atomic_dec_and_test(&ref->refs)) {
+	WARN_ON(refcount_read(&ref->refs) == 0);
+	if (refcount_dec_and_test(&ref->refs)) {
 		WARN_ON(ref->in_tree);
 		switch (ref->type) {
 		case BTRFS_TREE_BLOCK_REF_KEY:
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 1800416..b15275c 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -707,7 +707,7 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 	 */
 	extent_buffer_get(eb);
 
-	reads_done = atomic_dec_and_test(&eb->io_pages);
+	reads_done = refcount_dec_and_test(&eb->io_pages);
 	if (!reads_done)
 		goto err;
 
@@ -771,7 +771,7 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 		 * again, we have to make sure it has something
 		 * to decrement
 		 */
-		atomic_inc(&eb->io_pages);
+		refcount_inc(&eb->io_pages);
 		clear_extent_buffer_uptodate(eb);
 	}
 	free_extent_buffer(eb);
@@ -786,7 +786,7 @@ static int btree_io_failed_hook(struct page *page, int failed_mirror)
 	eb = (struct extent_buffer *)page->private;
 	set_bit(EXTENT_BUFFER_READ_ERR, &eb->bflags);
 	eb->read_mirror = failed_mirror;
-	atomic_dec(&eb->io_pages);
+	refcount_dec(&eb->io_pages);
 	if (test_and_clear_bit(EXTENT_BUFFER_READAHEAD, &eb->bflags))
 		btree_readahead_hook(eb->fs_info, eb, -EIO);
 	return -EIO;	/* we fixed nothing */
@@ -1145,7 +1145,7 @@ static int btree_set_page_dirty(struct page *page)
 	eb = (struct extent_buffer *)page->private;
 	BUG_ON(!eb);
 	BUG_ON(!test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
-	BUG_ON(!atomic_read(&eb->refs));
+	BUG_ON(!refcount_read(&eb->refs));
 	btrfs_assert_tree_locked(eb);
 #endif
 	return __set_page_dirty_nobuffers(page);
@@ -1342,7 +1342,7 @@ static void __setup_root(struct btrfs_root *root, struct btrfs_fs_info *fs_info,
 	atomic_set(&root->log_writers, 0);
 	atomic_set(&root->log_batch, 0);
 	atomic_set(&root->orphan_inodes, 0);
-	atomic_set(&root->refs, 1);
+	refcount_set(&root->refs, 1);
 	atomic_set(&root->will_be_snapshoted, 0);
 	atomic_set(&root->qgroup_meta_rsv, 0);
 	root->log_transid = 0;
@@ -4347,7 +4347,7 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 		head = rb_entry(node, struct btrfs_delayed_ref_head,
 				href_node);
 		if (!mutex_trylock(&head->mutex)) {
-			atomic_inc(&head->node.refs);
+			refcount_inc(&head->node.refs);
 			spin_unlock(&delayed_refs->lock);
 
 			mutex_lock(&head->mutex);
@@ -4619,7 +4619,7 @@ static int btrfs_cleanup_transaction(struct btrfs_fs_info *fs_info)
 		t = list_first_entry(&fs_info->trans_list,
 				     struct btrfs_transaction, list);
 		if (t->state >= TRANS_STATE_COMMIT_START) {
-			atomic_inc(&t->use_count);
+			refcount_inc(&t->use_count);
 			spin_unlock(&fs_info->trans_lock);
 			btrfs_wait_for_commit(fs_info, t->transid);
 			btrfs_put_transaction(t);
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 44dcd9a..74d554c 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -103,14 +103,14 @@ struct btrfs_root *btrfs_alloc_dummy_root(struct btrfs_fs_info *fs_info);
  */
 static inline struct btrfs_root *btrfs_grab_fs_root(struct btrfs_root *root)
 {
-	if (atomic_inc_not_zero(&root->refs))
+	if (refcount_inc_not_zero(&root->refs))
 		return root;
 	return NULL;
 }
 
 static inline void btrfs_put_fs_root(struct btrfs_root *root)
 {
-	if (atomic_dec_and_test(&root->refs))
+	if (refcount_dec_and_test(&root->refs))
 		kfree(root);
 }
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e97302f..2fe4ee3 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -122,12 +122,12 @@ static int block_group_bits(struct btrfs_block_group_cache *cache, u64 bits)
 
 void btrfs_get_block_group(struct btrfs_block_group_cache *cache)
 {
-	atomic_inc(&cache->count);
+	refcount_inc(&cache->count);
 }
 
 void btrfs_put_block_group(struct btrfs_block_group_cache *cache)
 {
-	if (atomic_dec_and_test(&cache->count)) {
+	if (refcount_dec_and_test(&cache->count)) {
 		WARN_ON(cache->pinned > 0);
 		WARN_ON(cache->reserved > 0);
 		kfree(cache->free_space_ctl);
@@ -315,14 +315,14 @@ get_caching_control(struct btrfs_block_group_cache *cache)
 	}
 
 	ctl = cache->caching_ctl;
-	atomic_inc(&ctl->count);
+	refcount_inc(&ctl->count);
 	spin_unlock(&cache->lock);
 	return ctl;
 }
 
 static void put_caching_control(struct btrfs_caching_control *ctl)
 {
-	if (atomic_dec_and_test(&ctl->count))
+	if (refcount_dec_and_test(&ctl->count))
 		kfree(ctl);
 }
 
@@ -598,7 +598,7 @@ static int cache_block_group(struct btrfs_block_group_cache *cache,
 	init_waitqueue_head(&caching_ctl->wait);
 	caching_ctl->block_group = cache;
 	caching_ctl->progress = cache->key.objectid;
-	atomic_set(&caching_ctl->count, 1);
+	refcount_set(&caching_ctl->count, 1);
 	btrfs_init_work(&caching_ctl->work, btrfs_cache_helper,
 			caching_thread, NULL, NULL);
 
@@ -619,7 +619,7 @@ static int cache_block_group(struct btrfs_block_group_cache *cache,
 		struct btrfs_caching_control *ctl;
 
 		ctl = cache->caching_ctl;
-		atomic_inc(&ctl->count);
+		refcount_inc(&ctl->count);
 		prepare_to_wait(&ctl->wait, &wait, TASK_UNINTERRUPTIBLE);
 		spin_unlock(&cache->lock);
 
@@ -706,7 +706,7 @@ static int cache_block_group(struct btrfs_block_group_cache *cache,
 	}
 
 	down_write(&fs_info->commit_root_sem);
-	atomic_inc(&caching_ctl->count);
+	refcount_inc(&caching_ctl->count);
 	list_add_tail(&caching_ctl->list, &fs_info->caching_block_groups);
 	up_write(&fs_info->commit_root_sem);
 
@@ -891,7 +891,7 @@ int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
 	head = btrfs_find_delayed_ref_head(trans, bytenr);
 	if (head) {
 		if (!mutex_trylock(&head->mutex)) {
-			atomic_inc(&head->node.refs);
+			refcount_inc(&head->node.refs);
 			spin_unlock(&delayed_refs->lock);
 
 			btrfs_release_path(path);
@@ -2972,7 +2972,7 @@ int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 				struct btrfs_delayed_ref_node *ref;
 
 				ref = &head->node;
-				atomic_inc(&ref->refs);
+				refcount_inc(&ref->refs);
 
 				spin_unlock(&delayed_refs->lock);
 				/*
@@ -3045,7 +3045,7 @@ static noinline int check_delayed_ref(struct btrfs_trans_handle *trans,
 	}
 
 	if (!mutex_trylock(&head->mutex)) {
-		atomic_inc(&head->node.refs);
+		refcount_inc(&head->node.refs);
 		spin_unlock(&delayed_refs->lock);
 
 		btrfs_release_path(path);
@@ -9792,7 +9792,7 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 		ASSERT(list_empty(&block_group->dirty_list));
 		ASSERT(list_empty(&block_group->io_list));
 		ASSERT(list_empty(&block_group->bg_list));
-		ASSERT(atomic_read(&block_group->count) == 1);
+		ASSERT(refcount_read(&block_group->count) == 1);
 		btrfs_put_block_group(block_group);
 
 		spin_lock(&info->block_group_cache_lock);
@@ -9904,7 +9904,7 @@ btrfs_create_block_group_cache(struct btrfs_fs_info *fs_info,
 						       start);
 	set_free_space_tree_thresholds(cache);
 
-	atomic_set(&cache->count, 1);
+	refcount_set(&cache->count, 1);
 	spin_lock_init(&cache->lock);
 	init_rwsem(&cache->data_rwsem);
 	INIT_LIST_HEAD(&cache->list);
@@ -10415,7 +10415,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 				    &fs_info->caching_block_groups, list)
 				if (ctl->block_group == block_group) {
 					caching_ctl = ctl;
-					atomic_inc(&caching_ctl->count);
+					refcount_inc(&caching_ctl->count);
 					break;
 				}
 		}
@@ -10849,7 +10849,7 @@ static int btrfs_trim_free_extents(struct btrfs_device *device,
 		spin_lock(&fs_info->trans_lock);
 		trans = fs_info->running_transaction;
 		if (trans)
-			atomic_inc(&trans->use_count);
+			refcount_inc(&trans->use_count);
 		spin_unlock(&fs_info->trans_lock);
 
 		ret = find_free_dev_extent_start(trans, device, minlen, start,
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 4ac383a..b6b27c9 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -68,7 +68,7 @@ void btrfs_leak_debug_check(void)
 		pr_err("BTRFS: state leak: start %llu end %llu state %u in tree %d refs %d\n",
 		       state->start, state->end, state->state,
 		       extent_state_in_tree(state),
-		       atomic_read(&state->refs));
+		       refcount_read(&state->refs));
 		list_del(&state->leak_list);
 		kmem_cache_free(extent_state_cache, state);
 	}
@@ -76,7 +76,7 @@ void btrfs_leak_debug_check(void)
 	while (!list_empty(&buffers)) {
 		eb = list_entry(buffers.next, struct extent_buffer, leak_list);
 		pr_err("BTRFS: buffer leak start %llu len %lu refs %d\n",
-		       eb->start, eb->len, atomic_read(&eb->refs));
+		       eb->start, eb->len, refcount_read(&eb->refs));
 		list_del(&eb->leak_list);
 		kmem_cache_free(extent_buffer_cache, eb);
 	}
@@ -233,7 +233,7 @@ static struct extent_state *alloc_extent_state(gfp_t mask)
 	state->failrec = NULL;
 	RB_CLEAR_NODE(&state->rb_node);
 	btrfs_leak_debug_add(&state->leak_list, &states);
-	atomic_set(&state->refs, 1);
+	refcount_set(&state->refs, 1);
 	init_waitqueue_head(&state->wq);
 	trace_alloc_extent_state(state, mask, _RET_IP_);
 	return state;
@@ -243,7 +243,7 @@ void free_extent_state(struct extent_state *state)
 {
 	if (!state)
 		return;
-	if (atomic_dec_and_test(&state->refs)) {
+	if (refcount_dec_and_test(&state->refs)) {
 		WARN_ON(extent_state_in_tree(state));
 		btrfs_leak_debug_del(&state->leak_list);
 		trace_free_extent_state(state, _RET_IP_);
@@ -635,7 +635,7 @@ static int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		if (cached && extent_state_in_tree(cached) &&
 		    cached->start <= start && cached->end > start) {
 			if (clear)
-				atomic_dec(&cached->refs);
+				refcount_dec(&cached->refs);
 			state = cached;
 			goto hit_next;
 		}
@@ -787,7 +787,7 @@ static void wait_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 
 		if (state->state & bits) {
 			start = state->start;
-			atomic_inc(&state->refs);
+			refcount_inc(&state->refs);
 			wait_on_state(tree, state);
 			free_extent_state(state);
 			goto again;
@@ -828,7 +828,7 @@ static void cache_state_if_flags(struct extent_state *state,
 	if (cached_ptr && !(*cached_ptr)) {
 		if (!flags || (state->state & flags)) {
 			*cached_ptr = state;
-			atomic_inc(&state->refs);
+			refcount_inc(&state->refs);
 		}
 	}
 }
@@ -1532,7 +1532,7 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
 		if (!found) {
 			*start = state->start;
 			*cached_state = state;
-			atomic_inc(&state->refs);
+			refcount_inc(&state->refs);
 		}
 		found++;
 		*end = state->end;
@@ -2856,7 +2856,7 @@ __get_extent_map(struct inode *inode, struct page *page, size_t pg_offset,
 		em = *em_cached;
 		if (extent_map_in_tree(em) && start >= em->start &&
 		    start < extent_map_end(em)) {
-			atomic_inc(&em->refs);
+			refcount_inc(&em->refs);
 			return em;
 		}
 
@@ -2867,7 +2867,7 @@ __get_extent_map(struct inode *inode, struct page *page, size_t pg_offset,
 	em = get_extent(inode, page, pg_offset, start, len, 0);
 	if (em_cached && !IS_ERR_OR_NULL(em)) {
 		BUG_ON(*em_cached);
-		atomic_inc(&em->refs);
+		refcount_inc(&em->refs);
 		*em_cached = em;
 	}
 	return em;
@@ -3698,7 +3698,7 @@ static void end_bio_extent_buffer_writepage(struct bio *bio)
 
 		eb = (struct extent_buffer *)page->private;
 		BUG_ON(!eb);
-		done = atomic_dec_and_test(&eb->io_pages);
+		done = refcount_dec_and_test(&eb->io_pages);
 
 		if (bio->bi_error ||
 		    test_bit(EXTENT_BUFFER_WRITE_ERR, &eb->bflags)) {
@@ -3734,7 +3734,7 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
 
 	clear_bit(EXTENT_BUFFER_WRITE_ERR, &eb->bflags);
 	num_pages = num_extent_pages(eb->start, eb->len);
-	atomic_set(&eb->io_pages, num_pages);
+	refcount_set(&eb->io_pages, num_pages);
 	if (btrfs_header_owner(eb) == BTRFS_TREE_LOG_OBJECTID)
 		bio_flags = EXTENT_BIO_TREE_LOG;
 
@@ -3768,7 +3768,7 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
 		if (ret) {
 			set_btree_ioerr(p);
 			end_page_writeback(p);
-			if (atomic_sub_and_test(num_pages - i, &eb->io_pages))
+			if (refcount_sub_and_test(num_pages - i, &eb->io_pages))
 				end_extent_buffer_writeback(eb);
 			ret = -EIO;
 			break;
@@ -3868,7 +3868,7 @@ int btree_write_cache_pages(struct address_space *mapping,
 				continue;
 			}
 
-			ret = atomic_inc_not_zero(&eb->refs);
+			ret = refcount_inc_not_zero(&eb->refs);
 			spin_unlock(&mapping->private_lock);
 			if (!ret)
 				continue;
@@ -4594,7 +4594,7 @@ static void __free_extent_buffer(struct extent_buffer *eb)
 
 int extent_buffer_under_io(struct extent_buffer *eb)
 {
-	return (atomic_read(&eb->io_pages) ||
+	return (refcount_read(&eb->io_pages) ||
 		test_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags) ||
 		test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
 }
@@ -4685,8 +4685,8 @@ __alloc_extent_buffer(struct btrfs_fs_info *fs_info, u64 start,
 	btrfs_leak_debug_add(&eb->leak_list, &buffers);
 
 	spin_lock_init(&eb->refs_lock);
-	atomic_set(&eb->refs, 1);
-	atomic_set(&eb->io_pages, 0);
+	refcount_set(&eb->refs, 1);
+	refcount_set(&eb->io_pages, 0);
 
 	/*
 	 * Sanity checks, currently the maximum is 64k covered by 16x 4k pages
@@ -4787,13 +4787,13 @@ static void check_buffer_tree_ref(struct extent_buffer *eb)
 	 * So bump the ref count first, then set the bit.  If someone
 	 * beat us to it, drop the ref we added.
 	 */
-	refs = atomic_read(&eb->refs);
+	refs = refcount_read(&eb->refs);
 	if (refs >= 2 && test_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags))
 		return;
 
 	spin_lock(&eb->refs_lock);
 	if (!test_and_set_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags))
-		atomic_inc(&eb->refs);
+		refcount_inc(&eb->refs);
 	spin_unlock(&eb->refs_lock);
 }
 
@@ -4821,7 +4821,7 @@ struct extent_buffer *find_extent_buffer(struct btrfs_fs_info *fs_info,
 	rcu_read_lock();
 	eb = radix_tree_lookup(&fs_info->buffer_radix,
 			       start >> PAGE_SHIFT);
-	if (eb && atomic_inc_not_zero(&eb->refs)) {
+	if (eb && refcount_inc_not_zero(&eb->refs)) {
 		rcu_read_unlock();
 		/*
 		 * Lock our eb's refs_lock to avoid races with
@@ -4889,7 +4889,7 @@ struct extent_buffer *alloc_test_extent_buffer(struct btrfs_fs_info *fs_info,
 	 * want the buffers to stay in memory until we're done with them, so
 	 * bump the ref count again.
 	 */
-	atomic_inc(&eb->refs);
+	refcount_inc(&eb->refs);
 	return eb;
 free_eb:
 	btrfs_release_extent_buffer(eb);
@@ -4941,7 +4941,7 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 			 * overwrite page->private.
 			 */
 			exists = (struct extent_buffer *)p->private;
-			if (atomic_inc_not_zero(&exists->refs)) {
+			if (refcount_inc_not_zero(&exists->refs)) {
 				spin_unlock(&mapping->private_lock);
 				unlock_page(p);
 				put_page(p);
@@ -5014,7 +5014,7 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 	return eb;
 
 free_eb:
-	WARN_ON(!atomic_dec_and_test(&eb->refs));
+	WARN_ON(!refcount_dec_and_test(&eb->refs));
 	for (i = 0; i < num_pages; i++) {
 		if (eb->pages[i])
 			unlock_page(eb->pages[i]);
@@ -5035,8 +5035,8 @@ static inline void btrfs_release_extent_buffer_rcu(struct rcu_head *head)
 /* Expects to have eb->eb_lock already held */
 static int release_extent_buffer(struct extent_buffer *eb)
 {
-	WARN_ON(atomic_read(&eb->refs) == 0);
-	if (atomic_dec_and_test(&eb->refs)) {
+	WARN_ON(refcount_read(&eb->refs) == 0);
+	if (refcount_dec_and_test(&eb->refs)) {
 		if (test_and_clear_bit(EXTENT_BUFFER_IN_TREE, &eb->bflags)) {
 			struct btrfs_fs_info *fs_info = eb->fs_info;
 
@@ -5068,30 +5068,29 @@ static int release_extent_buffer(struct extent_buffer *eb)
 
 void free_extent_buffer(struct extent_buffer *eb)
 {
-	int refs;
-	int old;
+	unsigned int refs;
 	if (!eb)
 		return;
 
-	while (1) {
-		refs = atomic_read(&eb->refs);
-		if (refs <= 3)
-			break;
-		old = atomic_cmpxchg(&eb->refs, refs, refs - 1);
-		if (old == refs)
+	/* ATTENTION: please review me */
+
+	spin_lock(&eb->refs_lock);
+	refs = refcount_read(&eb->refs);
+	if (refs > 3) {
+			refcount_set(&eb->refs, refs - 1);
+			spin_unlock(&eb->refs_lock);
 			return;
 	}
 
-	spin_lock(&eb->refs_lock);
-	if (atomic_read(&eb->refs) == 2 &&
+	if (refcount_read(&eb->refs) == 2 &&
 	    test_bit(EXTENT_BUFFER_DUMMY, &eb->bflags))
-		atomic_dec(&eb->refs);
+		refcount_dec(&eb->refs);
 
-	if (atomic_read(&eb->refs) == 2 &&
+	if (refcount_read(&eb->refs) == 2 &&
 	    test_bit(EXTENT_BUFFER_STALE, &eb->bflags) &&
 	    !extent_buffer_under_io(eb) &&
 	    test_and_clear_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags))
-		atomic_dec(&eb->refs);
+		refcount_dec(&eb->refs);
 
 	/*
 	 * I know this is terrible, but it's temporary until we stop tracking
@@ -5108,9 +5107,9 @@ void free_extent_buffer_stale(struct extent_buffer *eb)
 	spin_lock(&eb->refs_lock);
 	set_bit(EXTENT_BUFFER_STALE, &eb->bflags);
 
-	if (atomic_read(&eb->refs) == 2 && !extent_buffer_under_io(eb) &&
+	if (refcount_read(&eb->refs) == 2 && !extent_buffer_under_io(eb) &&
 	    test_and_clear_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags))
-		atomic_dec(&eb->refs);
+		refcount_dec(&eb->refs);
 	release_extent_buffer(eb);
 }
 
@@ -5141,7 +5140,7 @@ void clear_extent_buffer_dirty(struct extent_buffer *eb)
 		ClearPageError(page);
 		unlock_page(page);
 	}
-	WARN_ON(atomic_read(&eb->refs) == 0);
+	WARN_ON(refcount_read(&eb->refs) == 0);
 }
 
 int set_extent_buffer_dirty(struct extent_buffer *eb)
@@ -5155,7 +5154,7 @@ int set_extent_buffer_dirty(struct extent_buffer *eb)
 	was_dirty = test_and_set_bit(EXTENT_BUFFER_DIRTY, &eb->bflags);
 
 	num_pages = num_extent_pages(eb->start, eb->len);
-	WARN_ON(atomic_read(&eb->refs) == 0);
+	WARN_ON(refcount_read(&eb->refs) == 0);
 	WARN_ON(!test_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags));
 
 	for (i = 0; i < num_pages; i++)
@@ -5246,13 +5245,13 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 
 	clear_bit(EXTENT_BUFFER_READ_ERR, &eb->bflags);
 	eb->read_mirror = 0;
-	atomic_set(&eb->io_pages, num_reads);
+	refcount_set(&eb->io_pages, num_reads);
 	for (i = 0; i < num_pages; i++) {
 		page = eb->pages[i];
 
 		if (!PageUptodate(page)) {
 			if (ret) {
-				atomic_dec(&eb->io_pages);
+				refcount_dec(&eb->io_pages);
 				unlock_page(page);
 				continue;
 			}
@@ -5272,7 +5271,7 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 				 *
 				 * We must dec io_pages by ourselves.
 				 */
-				atomic_dec(&eb->io_pages);
+				refcount_dec(&eb->io_pages);
 			}
 		} else {
 			unlock_page(page);
@@ -5905,7 +5904,7 @@ int try_release_extent_buffer(struct page *page)
 	 * this page.
 	 */
 	spin_lock(&eb->refs_lock);
-	if (atomic_read(&eb->refs) != 1 || extent_buffer_under_io(eb)) {
+	if (refcount_read(&eb->refs) != 1 || extent_buffer_under_io(eb)) {
 		spin_unlock(&eb->refs_lock);
 		spin_unlock(&page->mapping->private_lock);
 		return 0;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 17f9ce47..1b69727 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -2,6 +2,7 @@
 #define __EXTENTIO__
 
 #include <linux/rbtree.h>
+#include <linux/refcount.h>
 #include "ulist.h"
 
 /* bits for the extent state */
@@ -131,7 +132,7 @@ struct extent_state {
 
 	/* ADD NEW ELEMENTS AFTER THIS */
 	wait_queue_head_t wq;
-	atomic_t refs;
+	refcount_t refs;
 	unsigned state;
 
 	struct io_failure_record *failrec;
@@ -149,8 +150,8 @@ struct extent_buffer {
 	unsigned long bflags;
 	struct btrfs_fs_info *fs_info;
 	spinlock_t refs_lock;
-	atomic_t refs;
-	atomic_t io_pages;
+	refcount_t refs;
+	refcount_t io_pages;
 	int read_mirror;
 	struct rcu_head rcu_head;
 	pid_t lock_owner;
@@ -393,7 +394,7 @@ static inline unsigned long num_extent_pages(u64 start, u64 len)
 
 static inline void extent_buffer_get(struct extent_buffer *eb)
 {
-	atomic_inc(&eb->refs);
+	refcount_inc(&eb->refs);
 }
 
 int memcmp_extent_buffer(struct extent_buffer *eb, const void *ptrv,
diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 26f9ac7..6985015 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -55,7 +55,7 @@ struct extent_map *alloc_extent_map(void)
 	em->flags = 0;
 	em->compress_type = BTRFS_COMPRESS_NONE;
 	em->generation = 0;
-	atomic_set(&em->refs, 1);
+	refcount_set(&em->refs, 1);
 	INIT_LIST_HEAD(&em->list);
 	return em;
 }
@@ -71,8 +71,8 @@ void free_extent_map(struct extent_map *em)
 {
 	if (!em)
 		return;
-	WARN_ON(atomic_read(&em->refs) == 0);
-	if (atomic_dec_and_test(&em->refs)) {
+	WARN_ON(refcount_read(&em->refs) == 0);
+	if (refcount_dec_and_test(&em->refs)) {
 		WARN_ON(extent_map_in_tree(em));
 		WARN_ON(!list_empty(&em->list));
 		if (test_bit(EXTENT_FLAG_FS_MAPPING, &em->flags))
@@ -322,7 +322,7 @@ static inline void setup_extent_mapping(struct extent_map_tree *tree,
 					struct extent_map *em,
 					int modified)
 {
-	atomic_inc(&em->refs);
+	refcount_inc(&em->refs);
 	em->mod_start = em->start;
 	em->mod_len = em->len;
 
@@ -381,7 +381,7 @@ __lookup_extent_mapping(struct extent_map_tree *tree,
 	if (strict && !(end > em->start && start < extent_map_end(em)))
 		return NULL;
 
-	atomic_inc(&em->refs);
+	refcount_inc(&em->refs);
 	return em;
 }
 
diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
index eb8b8fa..a67b2de 100644
--- a/fs/btrfs/extent_map.h
+++ b/fs/btrfs/extent_map.h
@@ -2,6 +2,7 @@
 #define __EXTENTMAP__
 
 #include <linux/rbtree.h>
+#include <linux/refcount.h>
 
 #define EXTENT_MAP_LAST_BYTE ((u64)-4)
 #define EXTENT_MAP_HOLE ((u64)-3)
@@ -41,7 +42,7 @@ struct extent_map {
 		 */
 		struct map_lookup *map_lookup;
 	};
-	atomic_t refs;
+	refcount_t refs;
 	unsigned int compress_type;
 	struct list_head list;
 };
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 7015892..e8f8de4 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2677,7 +2677,7 @@ int btrfs_return_cluster_to_free_space(
 		spin_unlock(&cluster->lock);
 		return 0;
 	}
-	atomic_inc(&block_group->count);
+	refcount_inc(&block_group->count);
 	spin_unlock(&cluster->lock);
 
 	ctl = block_group->free_space_ctl;
@@ -3095,7 +3095,7 @@ int btrfs_find_space_cluster(struct btrfs_fs_info *fs_info,
 		list_del_init(&entry->list);
 
 	if (!ret) {
-		atomic_inc(&block_group->count);
+		refcount_inc(&block_group->count);
 		list_add_tail(&cluster->block_group_list,
 			      &block_group->cluster_list);
 		cluster->block_group = block_group;
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 041c332..963f6fe 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -212,7 +212,7 @@ static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 		set_bit(BTRFS_ORDERED_DIRECT, &entry->flags);
 
 	/* one ref for the tree */
-	atomic_set(&entry->refs, 1);
+	refcount_set(&entry->refs, 1);
 	init_waitqueue_head(&entry->wait);
 	INIT_LIST_HEAD(&entry->list);
 	INIT_LIST_HEAD(&entry->root_extent_list);
@@ -358,7 +358,7 @@ int btrfs_dec_test_first_ordered_pending(struct inode *inode,
 out:
 	if (!ret && cached && entry) {
 		*cached = entry;
-		atomic_inc(&entry->refs);
+		refcount_inc(&entry->refs);
 	}
 	spin_unlock_irqrestore(&tree->lock, flags);
 	return ret == 0;
@@ -425,7 +425,7 @@ int btrfs_dec_test_ordered_pending(struct inode *inode,
 out:
 	if (!ret && cached && entry) {
 		*cached = entry;
-		atomic_inc(&entry->refs);
+		refcount_inc(&entry->refs);
 	}
 	spin_unlock_irqrestore(&tree->lock, flags);
 	return ret == 0;
@@ -456,7 +456,7 @@ void btrfs_get_logged_extents(struct inode *inode,
 		if (test_and_set_bit(BTRFS_ORDERED_LOGGED, &ordered->flags))
 			continue;
 		list_add(&ordered->log_list, logged_list);
-		atomic_inc(&ordered->refs);
+		refcount_inc(&ordered->refs);
 	}
 	spin_unlock_irq(&tree->lock);
 }
@@ -565,7 +565,7 @@ void btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry)
 
 	trace_btrfs_ordered_extent_put(entry->inode, entry);
 
-	if (atomic_dec_and_test(&entry->refs)) {
+	if (refcount_dec_and_test(&entry->refs)) {
 		ASSERT(list_empty(&entry->log_list));
 		ASSERT(list_empty(&entry->trans_list));
 		ASSERT(list_empty(&entry->root_extent_list));
@@ -623,7 +623,7 @@ void btrfs_remove_ordered_extent(struct inode *inode,
 		spin_lock(&fs_info->trans_lock);
 		trans = fs_info->running_transaction;
 		if (trans)
-			atomic_inc(&trans->use_count);
+			refcount_inc(&trans->use_count);
 		spin_unlock(&fs_info->trans_lock);
 
 		ASSERT(trans);
@@ -690,7 +690,7 @@ int btrfs_wait_ordered_extents(struct btrfs_root *root, int nr,
 
 		list_move_tail(&ordered->root_extent_list,
 			       &root->ordered_extents);
-		atomic_inc(&ordered->refs);
+		refcount_inc(&ordered->refs);
 		spin_unlock(&root->ordered_extent_lock);
 
 		btrfs_init_work(&ordered->flush_work,
@@ -870,7 +870,7 @@ struct btrfs_ordered_extent *btrfs_lookup_ordered_extent(struct inode *inode,
 	if (!offset_in_entry(entry, file_offset))
 		entry = NULL;
 	if (entry)
-		atomic_inc(&entry->refs);
+		refcount_inc(&entry->refs);
 out:
 	spin_unlock_irq(&tree->lock);
 	return entry;
@@ -912,7 +912,7 @@ struct btrfs_ordered_extent *btrfs_lookup_ordered_range(struct inode *inode,
 	}
 out:
 	if (entry)
-		atomic_inc(&entry->refs);
+		refcount_inc(&entry->refs);
 	spin_unlock_irq(&tree->lock);
 	return entry;
 }
@@ -949,7 +949,7 @@ btrfs_lookup_first_ordered_extent(struct inode *inode, u64 file_offset)
 		goto out;
 
 	entry = rb_entry(node, struct btrfs_ordered_extent, rb_node);
-	atomic_inc(&entry->refs);
+	refcount_inc(&entry->refs);
 out:
 	spin_unlock_irq(&tree->lock);
 	return entry;
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 5f2b0ca..926bc22 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -111,7 +111,7 @@ struct btrfs_ordered_extent {
 	int compress_type;
 
 	/* reference count */
-	atomic_t refs;
+	refcount_t refs;
 
 	/* the inode we belong to */
 	struct inode *inode;
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index d2a9a1e..31125ab 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -149,7 +149,7 @@ struct btrfs_raid_bio {
 
 	int generic_bio_cnt;
 
-	atomic_t refs;
+	refcount_t refs;
 
 	atomic_t stripes_pending;
 
@@ -389,7 +389,7 @@ static void __remove_rbio_from_cache(struct btrfs_raid_bio *rbio)
 		if (bio_list_empty(&rbio->bio_list)) {
 			if (!list_empty(&rbio->hash_list)) {
 				list_del_init(&rbio->hash_list);
-				atomic_dec(&rbio->refs);
+				refcount_dec(&rbio->refs);
 				BUG_ON(!list_empty(&rbio->plug_list));
 			}
 		}
@@ -480,7 +480,7 @@ static void cache_rbio(struct btrfs_raid_bio *rbio)
 
 	/* bump our ref if we were not in the list before */
 	if (!test_and_set_bit(RBIO_CACHE_BIT, &rbio->flags))
-		atomic_inc(&rbio->refs);
+		refcount_inc(&rbio->refs);
 
 	if (!list_empty(&rbio->stripe_cache)){
 		list_move(&rbio->stripe_cache, &table->stripe_cache);
@@ -691,7 +691,7 @@ static noinline int lock_stripe_add(struct btrfs_raid_bio *rbio)
 			    test_bit(RBIO_CACHE_BIT, &cur->flags) &&
 			    !test_bit(RBIO_RMW_LOCKED_BIT, &cur->flags)) {
 				list_del_init(&cur->hash_list);
-				atomic_dec(&cur->refs);
+				refcount_dec(&cur->refs);
 
 				steal_rbio(cur, rbio);
 				cache_drop = cur;
@@ -740,7 +740,7 @@ static noinline int lock_stripe_add(struct btrfs_raid_bio *rbio)
 		}
 	}
 lockit:
-	atomic_inc(&rbio->refs);
+	refcount_inc(&rbio->refs);
 	list_add(&rbio->hash_list, &h->hash_list);
 out:
 	spin_unlock_irqrestore(&h->lock, flags);
@@ -786,7 +786,7 @@ static noinline void unlock_stripe(struct btrfs_raid_bio *rbio)
 		}
 
 		list_del_init(&rbio->hash_list);
-		atomic_dec(&rbio->refs);
+		refcount_dec(&rbio->refs);
 
 		/*
 		 * we use the plug list to hold all the rbios
@@ -803,7 +803,7 @@ static noinline void unlock_stripe(struct btrfs_raid_bio *rbio)
 			list_del_init(&rbio->plug_list);
 
 			list_add(&next->hash_list, &h->hash_list);
-			atomic_inc(&next->refs);
+			refcount_inc(&next->refs);
 			spin_unlock(&rbio->bio_list_lock);
 			spin_unlock_irqrestore(&h->lock, flags);
 
@@ -845,8 +845,7 @@ static void __free_raid_bio(struct btrfs_raid_bio *rbio)
 {
 	int i;
 
-	WARN_ON(atomic_read(&rbio->refs) < 0);
-	if (!atomic_dec_and_test(&rbio->refs))
+	if (!refcount_dec_and_test(&rbio->refs))
 		return;
 
 	WARN_ON(!list_empty(&rbio->stripe_cache));
@@ -999,7 +998,7 @@ static struct btrfs_raid_bio *alloc_rbio(struct btrfs_fs_info *fs_info,
 	rbio->stripe_npages = stripe_npages;
 	rbio->faila = -1;
 	rbio->failb = -1;
-	atomic_set(&rbio->refs, 1);
+	refcount_set(&rbio->refs, 1);
 	atomic_set(&rbio->error, 0);
 	atomic_set(&rbio->stripes_pending, 0);
 
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 9a94670..454518c 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -64,7 +64,7 @@ struct scrub_ctx;
 #define SCRUB_MAX_PAGES_PER_BLOCK	16	/* 64k per node/leaf/sector */
 
 struct scrub_recover {
-	atomic_t		refs;
+	refcount_t		refs;
 	struct btrfs_bio	*bbio;
 	u64			map_length;
 };
@@ -79,7 +79,7 @@ struct scrub_page {
 	u64			logical;
 	u64			physical;
 	u64			physical_for_dev_replace;
-	atomic_t		refs;
+	refcount_t		refs;
 	struct {
 		unsigned int	mirror_num:8;
 		unsigned int	have_csum:1;
@@ -112,7 +112,7 @@ struct scrub_block {
 	struct scrub_page	*pagev[SCRUB_MAX_PAGES_PER_BLOCK];
 	int			page_count;
 	atomic_t		outstanding_pages;
-	atomic_t		refs; /* free mem on transition to zero */
+	refcount_t		refs; /* free mem on transition to zero */
 	struct scrub_ctx	*sctx;
 	struct scrub_parity	*sparity;
 	struct {
@@ -142,7 +142,7 @@ struct scrub_parity {
 
 	int			stripe_len;
 
-	atomic_t		refs;
+	refcount_t		refs;
 
 	struct list_head	spages;
 
@@ -202,7 +202,7 @@ struct scrub_ctx {
 	 * doesn't free the scrub context before or while the workers are
 	 * doing the wakeup() call.
 	 */
-	atomic_t                refs;
+	refcount_t                refs;
 };
 
 struct scrub_fixup_nodatasum {
@@ -307,7 +307,7 @@ static void scrub_put_ctx(struct scrub_ctx *sctx);
 
 static void scrub_pending_bio_inc(struct scrub_ctx *sctx)
 {
-	atomic_inc(&sctx->refs);
+	refcount_inc(&sctx->refs);
 	atomic_inc(&sctx->bios_in_flight);
 }
 
@@ -358,7 +358,7 @@ static void scrub_pending_trans_workers_inc(struct scrub_ctx *sctx)
 {
 	struct btrfs_fs_info *fs_info = sctx->fs_info;
 
-	atomic_inc(&sctx->refs);
+	refcount_inc(&sctx->refs);
 	/*
 	 * increment scrubs_running to prevent cancel requests from
 	 * completing as long as a worker is running. we must also
@@ -449,7 +449,7 @@ static noinline_for_stack void scrub_free_ctx(struct scrub_ctx *sctx)
 
 static void scrub_put_ctx(struct scrub_ctx *sctx)
 {
-	if (atomic_dec_and_test(&sctx->refs))
+	if (refcount_dec_and_test(&sctx->refs))
 		scrub_free_ctx(sctx);
 }
 
@@ -464,7 +464,7 @@ struct scrub_ctx *scrub_setup_ctx(struct btrfs_device *dev, int is_dev_replace)
 	sctx = kzalloc(sizeof(*sctx), GFP_KERNEL);
 	if (!sctx)
 		goto nomem;
-	atomic_set(&sctx->refs, 1);
+	refcount_set(&sctx->refs, 1);
 	sctx->is_dev_replace = is_dev_replace;
 	sctx->pages_per_rd_bio = SCRUB_PAGES_PER_RD_BIO;
 	sctx->curr = -1;
@@ -859,12 +859,12 @@ static void scrub_fixup_nodatasum(struct btrfs_work *work)
 
 static inline void scrub_get_recover(struct scrub_recover *recover)
 {
-	atomic_inc(&recover->refs);
+	refcount_inc(&recover->refs);
 }
 
 static inline void scrub_put_recover(struct scrub_recover *recover)
 {
-	if (atomic_dec_and_test(&recover->refs)) {
+	if (refcount_dec_and_test(&recover->refs)) {
 		btrfs_put_bbio(recover->bbio);
 		kfree(recover);
 	}
@@ -1345,7 +1345,7 @@ static int scrub_setup_recheck_block(struct scrub_block *original_sblock,
 			return -ENOMEM;
 		}
 
-		atomic_set(&recover->refs, 1);
+		refcount_set(&recover->refs, 1);
 		recover->bbio = bbio;
 		recover->map_length = mapped_length;
 
@@ -2000,12 +2000,12 @@ static int scrub_checksum_super(struct scrub_block *sblock)
 
 static void scrub_block_get(struct scrub_block *sblock)
 {
-	atomic_inc(&sblock->refs);
+	refcount_inc(&sblock->refs);
 }
 
 static void scrub_block_put(struct scrub_block *sblock)
 {
-	if (atomic_dec_and_test(&sblock->refs)) {
+	if (refcount_dec_and_test(&sblock->refs)) {
 		int i;
 
 		if (sblock->sparity)
@@ -2019,12 +2019,12 @@ static void scrub_block_put(struct scrub_block *sblock)
 
 static void scrub_page_get(struct scrub_page *spage)
 {
-	atomic_inc(&spage->refs);
+	refcount_inc(&spage->refs);
 }
 
 static void scrub_page_put(struct scrub_page *spage)
 {
-	if (atomic_dec_and_test(&spage->refs)) {
+	if (refcount_dec_and_test(&spage->refs)) {
 		if (spage->page)
 			__free_page(spage->page);
 		kfree(spage);
@@ -2257,7 +2257,7 @@ static int scrub_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
 
 	/* one ref inside this function, plus one for each page added to
 	 * a bio later on */
-	atomic_set(&sblock->refs, 1);
+	refcount_set(&sblock->refs, 1);
 	sblock->sctx = sctx;
 	sblock->no_io_error_seen = 1;
 
@@ -2557,7 +2557,7 @@ static int scrub_pages_for_parity(struct scrub_parity *sparity,
 
 	/* one ref inside this function, plus one for each page added to
 	 * a bio later on */
-	atomic_set(&sblock->refs, 1);
+	refcount_set(&sblock->refs, 1);
 	sblock->sctx = sctx;
 	sblock->no_io_error_seen = 1;
 	sblock->sparity = sparity;
@@ -2824,12 +2824,12 @@ static inline int scrub_calc_parity_bitmap_len(int nsectors)
 
 static void scrub_parity_get(struct scrub_parity *sparity)
 {
-	atomic_inc(&sparity->refs);
+	refcount_inc(&sparity->refs);
 }
 
 static void scrub_parity_put(struct scrub_parity *sparity)
 {
-	if (!atomic_dec_and_test(&sparity->refs))
+	if (!refcount_dec_and_test(&sparity->refs))
 		return;
 
 	scrub_parity_check_and_repair(sparity);
@@ -2881,7 +2881,7 @@ static noinline_for_stack int scrub_raid56_parity(struct scrub_ctx *sctx,
 	sparity->scrub_dev = sdev;
 	sparity->logic_start = logic_start;
 	sparity->logic_end = logic_end;
-	atomic_set(&sparity->refs, 1);
+	refcount_set(&sparity->refs, 1);
 	INIT_LIST_HEAD(&sparity->spages);
 	sparity->dbitmap = sparity->bitmap;
 	sparity->ebitmap = (void *)sparity->bitmap + bitmap_len;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 0e0508f..d586fd6 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -60,8 +60,8 @@ static const unsigned int btrfs_blocked_trans_types[TRANS_STATE_MAX] = {
 
 void btrfs_put_transaction(struct btrfs_transaction *transaction)
 {
-	WARN_ON(atomic_read(&transaction->use_count) == 0);
-	if (atomic_dec_and_test(&transaction->use_count)) {
+	WARN_ON(refcount_read(&transaction->use_count) == 0);
+	if (refcount_dec_and_test(&transaction->use_count)) {
 		BUG_ON(!list_empty(&transaction->list));
 		WARN_ON(!RB_EMPTY_ROOT(&transaction->delayed_refs.href_root));
 		if (transaction->delayed_refs.pending_csums)
@@ -207,7 +207,7 @@ static noinline int join_transaction(struct btrfs_fs_info *fs_info,
 			spin_unlock(&fs_info->trans_lock);
 			return -EBUSY;
 		}
-		atomic_inc(&cur_trans->use_count);
+		refcount_inc(&cur_trans->use_count);
 		atomic_inc(&cur_trans->num_writers);
 		extwriter_counter_inc(cur_trans, type);
 		spin_unlock(&fs_info->trans_lock);
@@ -257,7 +257,7 @@ static noinline int join_transaction(struct btrfs_fs_info *fs_info,
 	 * One for this trans handle, one so it will live on until we
 	 * commit the transaction.
 	 */
-	atomic_set(&cur_trans->use_count, 2);
+	refcount_set(&cur_trans->use_count, 2);
 	atomic_set(&cur_trans->pending_ordered, 0);
 	cur_trans->flags = 0;
 	cur_trans->start_time = get_seconds();
@@ -432,7 +432,7 @@ static void wait_current_trans(struct btrfs_fs_info *fs_info)
 	spin_lock(&fs_info->trans_lock);
 	cur_trans = fs_info->running_transaction;
 	if (cur_trans && is_transaction_blocked(cur_trans)) {
-		atomic_inc(&cur_trans->use_count);
+		refcount_inc(&cur_trans->use_count);
 		spin_unlock(&fs_info->trans_lock);
 
 		wait_event(fs_info->transaction_wait,
@@ -734,7 +734,7 @@ int btrfs_wait_for_commit(struct btrfs_fs_info *fs_info, u64 transid)
 		list_for_each_entry(t, &fs_info->trans_list, list) {
 			if (t->transid == transid) {
 				cur_trans = t;
-				atomic_inc(&cur_trans->use_count);
+				refcount_inc(&cur_trans->use_count);
 				ret = 0;
 				break;
 			}
@@ -763,7 +763,7 @@ int btrfs_wait_for_commit(struct btrfs_fs_info *fs_info, u64 transid)
 				if (t->state == TRANS_STATE_COMPLETED)
 					break;
 				cur_trans = t;
-				atomic_inc(&cur_trans->use_count);
+				refcount_inc(&cur_trans->use_count);
 				break;
 			}
 		}
@@ -1833,7 +1833,7 @@ int btrfs_commit_transaction_async(struct btrfs_trans_handle *trans,
 
 	/* take transaction reference */
 	cur_trans = trans->transaction;
-	atomic_inc(&cur_trans->use_count);
+	refcount_inc(&cur_trans->use_count);
 
 	btrfs_end_transaction(trans);
 
@@ -2009,7 +2009,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	spin_lock(&fs_info->trans_lock);
 	if (cur_trans->state >= TRANS_STATE_COMMIT_START) {
 		spin_unlock(&fs_info->trans_lock);
-		atomic_inc(&cur_trans->use_count);
+		refcount_inc(&cur_trans->use_count);
 		ret = btrfs_end_transaction(trans);
 
 		wait_for_commit(cur_trans);
@@ -2029,7 +2029,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 		prev_trans = list_entry(cur_trans->list.prev,
 					struct btrfs_transaction, list);
 		if (prev_trans->state != TRANS_STATE_COMPLETED) {
-			atomic_inc(&prev_trans->use_count);
+			refcount_inc(&prev_trans->use_count);
 			spin_unlock(&fs_info->trans_lock);
 
 			wait_for_commit(prev_trans);
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 5dfb559..2d9ad36 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -18,6 +18,7 @@
 
 #ifndef __BTRFS_TRANSACTION__
 #define __BTRFS_TRANSACTION__
+#include <linux/refcount.h>
 #include "btrfs_inode.h"
 #include "delayed-ref.h"
 #include "ctree.h"
@@ -49,7 +50,7 @@ struct btrfs_transaction {
 	 * transaction can end
 	 */
 	atomic_t num_writers;
-	atomic_t use_count;
+	refcount_t use_count;
 	atomic_t pending_ordered;
 
 	unsigned long flags;
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index f10bf52..fdcc03e 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4187,7 +4187,7 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 		if (em->generation <= test_gen)
 			continue;
 		/* Need a ref to keep it from getting evicted from cache */
-		atomic_inc(&em->refs);
+		refcount_inc(&em->refs);
 		set_bit(EXTENT_FLAG_LOGGING, &em->flags);
 		list_add_tail(&em->list, &extents);
 		num++;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 3c3c69c..c6b0424 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4833,7 +4833,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	ret = add_extent_mapping(em_tree, em, 0);
 	if (!ret) {
 		list_add_tail(&em->list, &trans->transaction->pending_chunks);
-		atomic_inc(&em->refs);
+		refcount_inc(&em->refs);
 	}
 	write_unlock(&em_tree->lock);
 	if (ret) {
@@ -5297,22 +5297,22 @@ static struct btrfs_bio *alloc_btrfs_bio(int total_stripes, int real_stripes)
 		GFP_NOFS|__GFP_NOFAIL);
 
 	atomic_set(&bbio->error, 0);
-	atomic_set(&bbio->refs, 1);
+	refcount_set(&bbio->refs, 1);
 
 	return bbio;
 }
 
 void btrfs_get_bbio(struct btrfs_bio *bbio)
 {
-	WARN_ON(!atomic_read(&bbio->refs));
-	atomic_inc(&bbio->refs);
+	WARN_ON(!refcount_read(&bbio->refs));
+	refcount_inc(&bbio->refs);
 }
 
 void btrfs_put_bbio(struct btrfs_bio *bbio)
 {
 	if (!bbio)
 		return;
-	if (atomic_dec_and_test(&bbio->refs))
+	if (refcount_dec_and_test(&bbio->refs))
 		kfree(bbio);
 }
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 24ba6bc..0ef3f5c 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -298,7 +298,7 @@ struct btrfs_bio;
 typedef void (btrfs_bio_end_io_t) (struct btrfs_bio *bio, int err);
 
 struct btrfs_bio {
-	atomic_t refs;
+	refcount_t refs;
 	atomic_t stripes_pending;
 	struct btrfs_fs_info *fs_info;
 	u64 map_type; /* get from map_lookup->type */
diff --git a/fs/cachefiles/bind.c b/fs/cachefiles/bind.c
index 3ff867f..341864e 100644
--- a/fs/cachefiles/bind.c
+++ b/fs/cachefiles/bind.c
@@ -109,7 +109,7 @@ static int cachefiles_daemon_add_cache(struct cachefiles_cache *cache)
 
 	ASSERTCMP(fsdef->backer, ==, NULL);
 
-	atomic_set(&fsdef->usage, 1);
+	refcount_set(&fsdef->usage, 1);
 	fsdef->type = FSCACHE_COOKIE_TYPE_INDEX;
 
 	_debug("- fsdef %p", fsdef);
diff --git a/fs/cachefiles/interface.c b/fs/cachefiles/interface.c
index e7f16a7..d3f87c3 100644
--- a/fs/cachefiles/interface.c
+++ b/fs/cachefiles/interface.c
@@ -51,7 +51,7 @@ static struct fscache_object *cachefiles_alloc_object(
 	ASSERTCMP(object->backer, ==, NULL);
 
 	BUG_ON(test_bit(CACHEFILES_OBJECT_ACTIVE, &object->flags));
-	atomic_set(&object->usage, 1);
+	refcount_set(&object->usage, 1);
 
 	fscache_object_init(&object->fscache, cookie, &cache->cache);
 
@@ -182,13 +182,13 @@ struct fscache_object *cachefiles_grab_object(struct fscache_object *_object)
 	struct cachefiles_object *object =
 		container_of(_object, struct cachefiles_object, fscache);
 
-	_enter("{OBJ%x,%d}", _object->debug_id, atomic_read(&object->usage));
+	_enter("{OBJ%x,%d}", _object->debug_id, refcount_read(&object->usage));
 
 #ifdef CACHEFILES_DEBUG_SLAB
-	ASSERT((atomic_read(&object->usage) & 0xffff0000) != 0x6b6b0000);
+	ASSERT((refcount_read(&object->usage) & 0xffff0000) != 0x6b6b0000);
 #endif
 
-	atomic_inc(&object->usage);
+	refcount_inc(&object->usage);
 	return &object->fscache;
 }
 
@@ -261,13 +261,13 @@ static void cachefiles_drop_object(struct fscache_object *_object)
 	object = container_of(_object, struct cachefiles_object, fscache);
 
 	_enter("{OBJ%x,%d}",
-	       object->fscache.debug_id, atomic_read(&object->usage));
+	       object->fscache.debug_id, refcount_read(&object->usage));
 
 	cache = container_of(object->fscache.cache,
 			     struct cachefiles_cache, cache);
 
 #ifdef CACHEFILES_DEBUG_SLAB
-	ASSERT((atomic_read(&object->usage) & 0xffff0000) != 0x6b6b0000);
+	ASSERT((refcount_read(&object->usage) & 0xffff0000) != 0x6b6b0000);
 #endif
 
 	/* We need to tidy the object up if we did in fact manage to open it.
@@ -319,16 +319,16 @@ static void cachefiles_put_object(struct fscache_object *_object)
 	object = container_of(_object, struct cachefiles_object, fscache);
 
 	_enter("{OBJ%x,%d}",
-	       object->fscache.debug_id, atomic_read(&object->usage));
+	       object->fscache.debug_id, refcount_read(&object->usage));
 
 #ifdef CACHEFILES_DEBUG_SLAB
-	ASSERT((atomic_read(&object->usage) & 0xffff0000) != 0x6b6b0000);
+	ASSERT((refcount_read(&object->usage) & 0xffff0000) != 0x6b6b0000);
 #endif
 
 	ASSERTIFCMP(object->fscache.parent,
 		    object->fscache.parent->n_children, >, 0);
 
-	if (atomic_dec_and_test(&object->usage)) {
+	if (refcount_dec_and_test(&object->usage)) {
 		_debug("- kill object OBJ%x", object->fscache.debug_id);
 
 		ASSERT(!test_bit(CACHEFILES_OBJECT_ACTIVE, &object->flags));
diff --git a/fs/cachefiles/internal.h b/fs/cachefiles/internal.h
index cd1effe..61771e6 100644
--- a/fs/cachefiles/internal.h
+++ b/fs/cachefiles/internal.h
@@ -21,6 +21,7 @@
 #include <linux/wait.h>
 #include <linux/workqueue.h>
 #include <linux/security.h>
+#include <linux/refcount.h>
 
 struct cachefiles_cache;
 struct cachefiles_object;
@@ -43,7 +44,7 @@ struct cachefiles_object {
 	loff_t				i_size;		/* object size */
 	unsigned long			flags;
 #define CACHEFILES_OBJECT_ACTIVE	0		/* T if marked active */
-	atomic_t			usage;		/* object usage count */
+	refcount_t			usage;		/* object usage count */
 	uint8_t				type;		/* object type */
 	uint8_t				new;		/* T if object new */
 	spinlock_t			work_lock;
diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index 41df8a2..e3bc512 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -197,7 +197,7 @@ static int cachefiles_mark_object_active(struct cachefiles_cache *cache,
 		cachefiles_printk_object(object, xobject);
 		BUG();
 	}
-	atomic_inc(&xobject->usage);
+	refcount_inc(&xobject->usage);
 	write_unlock(&cache->active_lock);
 
 	if (test_bit(CACHEFILES_OBJECT_ACTIVE, &xobject->flags)) {
diff --git a/fs/cachefiles/rdwr.c b/fs/cachefiles/rdwr.c
index afbdc41..c987de6 100644
--- a/fs/cachefiles/rdwr.c
+++ b/fs/cachefiles/rdwr.c
@@ -692,7 +692,7 @@ int cachefiles_read_or_alloc_pages(struct fscache_retrieval *op,
 			     struct cachefiles_cache, cache);
 
 	_enter("{OBJ%x,%d},,%d,,",
-	       object->fscache.debug_id, atomic_read(&op->op.usage),
+	       object->fscache.debug_id, refcount_read(&op->op.usage),
 	       *nr_pages);
 
 	if (!object->backer)
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index baea866..e3a84a0 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1382,7 +1382,7 @@ static void __ceph_flush_snaps(struct ceph_inode_info *ci,
 		first_tid = cf->tid + 1;
 
 		capsnap = container_of(cf, struct ceph_cap_snap, cap_flush);
-		atomic_inc(&capsnap->nref);
+		refcount_inc(&capsnap->nref);
 		spin_unlock(&ci->i_ceph_lock);
 
 		dout("__flush_snaps %p capsnap %p tid %llu %s\n",
@@ -2197,7 +2197,7 @@ static void __kick_flushing_caps(struct ceph_mds_client *mdsc,
 			     inode, capsnap, cf->tid,
 			     ceph_cap_string(capsnap->dirty));
 
-			atomic_inc(&capsnap->nref);
+			refcount_inc(&capsnap->nref);
 			spin_unlock(&ci->i_ceph_lock);
 
 			ret = __send_flush_snap(inode, session, capsnap, cap->mseq,
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 045d30d..3e2055b 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -8,6 +8,7 @@
 #include <linux/namei.h>
 #include <linux/writeback.h>
 #include <linux/falloc.h>
+#include <linux/refcount.h>
 
 #include "super.h"
 #include "mds_client.h"
@@ -609,7 +610,7 @@ struct ceph_aio_request {
 	int error;
 	struct list_head osd_reqs;
 	unsigned num_reqs;
-	atomic_t pending_reqs;
+	refcount_t pending_reqs;
 	struct timespec mtime;
 	struct ceph_cap_flush *prealloc_cf;
 };
@@ -627,7 +628,7 @@ static void ceph_aio_complete(struct inode *inode,
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	int ret;
 
-	if (!atomic_dec_and_test(&aio_req->pending_reqs))
+	if (!refcount_dec_and_test(&aio_req->pending_reqs))
 		return;
 
 	ret = aio_req->error;
@@ -988,7 +989,7 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 		if (aio_req) {
 			aio_req->total_len += len;
 			aio_req->num_reqs++;
-			atomic_inc(&aio_req->pending_reqs);
+			refcount_inc(&aio_req->pending_reqs);
 
 			req->r_callback = ceph_aio_complete_req;
 			req->r_inode = inode;
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 4f49253..939359f 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -377,9 +377,9 @@ const char *ceph_session_state_name(int s)
 
 static struct ceph_mds_session *get_session(struct ceph_mds_session *s)
 {
-	if (atomic_inc_not_zero(&s->s_ref)) {
+	if (refcount_inc_not_zero(&s->s_ref)) {
 		dout("mdsc get_session %p %d -> %d\n", s,
-		     atomic_read(&s->s_ref)-1, atomic_read(&s->s_ref));
+		     refcount_read(&s->s_ref)-1, refcount_read(&s->s_ref));
 		return s;
 	} else {
 		dout("mdsc get_session %p 0 -- FAIL", s);
@@ -390,8 +390,8 @@ static struct ceph_mds_session *get_session(struct ceph_mds_session *s)
 void ceph_put_mds_session(struct ceph_mds_session *s)
 {
 	dout("mdsc put_session %p %d -> %d\n", s,
-	     atomic_read(&s->s_ref), atomic_read(&s->s_ref)-1);
-	if (atomic_dec_and_test(&s->s_ref)) {
+	     refcount_read(&s->s_ref), refcount_read(&s->s_ref)-1);
+	if (refcount_dec_and_test(&s->s_ref)) {
 		if (s->s_auth.authorizer)
 			ceph_auth_destroy_authorizer(s->s_auth.authorizer);
 		kfree(s);
@@ -410,7 +410,7 @@ struct ceph_mds_session *__ceph_lookup_mds_session(struct ceph_mds_client *mdsc,
 		return NULL;
 	session = mdsc->sessions[mds];
 	dout("lookup_mds_session %p %d\n", session,
-	     atomic_read(&session->s_ref));
+	     refcount_read(&session->s_ref));
 	get_session(session);
 	return session;
 }
@@ -465,7 +465,7 @@ static struct ceph_mds_session *register_session(struct ceph_mds_client *mdsc,
 	INIT_LIST_HEAD(&s->s_caps);
 	s->s_nr_caps = 0;
 	s->s_trim_caps = 0;
-	atomic_set(&s->s_ref, 1);
+	refcount_set(&s->s_ref, 1);
 	INIT_LIST_HEAD(&s->s_waiting);
 	INIT_LIST_HEAD(&s->s_unsafe);
 	s->s_num_cap_releases = 0;
@@ -493,7 +493,7 @@ static struct ceph_mds_session *register_session(struct ceph_mds_client *mdsc,
 	}
 	mdsc->sessions[mds] = s;
 	atomic_inc(&mdsc->num_sessions);
-	atomic_inc(&s->s_ref);  /* one ref to sessions[], one to caller */
+	refcount_inc(&s->s_ref);  /* one ref to sessions[], one to caller */
 
 	ceph_con_open(&s->s_con, CEPH_ENTITY_TYPE_MDS, mds,
 		      ceph_mdsmap_get_addr(mdsc->mdsmap, mds));
@@ -1955,7 +1955,7 @@ static struct ceph_msg *create_request_message(struct ceph_mds_client *mdsc,
 
 	if (req->r_pagelist) {
 		struct ceph_pagelist *pagelist = req->r_pagelist;
-		atomic_inc(&pagelist->refcnt);
+		refcount_inc(&pagelist->refcnt);
 		ceph_msg_data_add_pagelist(msg, pagelist);
 		msg->hdr.data_len = cpu_to_le32(pagelist->length);
 	} else {
@@ -3840,7 +3840,7 @@ static struct ceph_connection *con_get(struct ceph_connection *con)
 	struct ceph_mds_session *s = con->private;
 
 	if (get_session(s)) {
-		dout("mdsc con_get %p ok (%d)\n", s, atomic_read(&s->s_ref));
+		dout("mdsc con_get %p ok (%d)\n", s, refcount_read(&s->s_ref));
 		return con;
 	}
 	dout("mdsc con_get %p FAIL\n", s);
@@ -3851,7 +3851,7 @@ static void con_put(struct ceph_connection *con)
 {
 	struct ceph_mds_session *s = con->private;
 
-	dout("mdsc con_put %p (%d)\n", s, atomic_read(&s->s_ref) - 1);
+	dout("mdsc con_put %p (%d)\n", s, refcount_read(&s->s_ref) - 1);
 	ceph_put_mds_session(s);
 }
 
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 3c6f77b..d55da01 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -7,6 +7,7 @@
 #include <linux/mutex.h>
 #include <linux/rbtree.h>
 #include <linux/spinlock.h>
+#include <linux/refcount.h>
 
 #include <linux/ceph/types.h>
 #include <linux/ceph/messenger.h>
@@ -156,7 +157,7 @@ struct ceph_mds_session {
 	unsigned long     s_renew_requested; /* last time we sent a renew req */
 	u64               s_renew_seq;
 
-	atomic_t          s_ref;
+	refcount_t          s_ref;
 	struct list_head  s_waiting;  /* waiting requests */
 	struct list_head  s_unsafe;   /* unsafe requests */
 };
@@ -368,7 +369,7 @@ __ceph_lookup_mds_session(struct ceph_mds_client *, int mds);
 static inline struct ceph_mds_session *
 ceph_get_mds_session(struct ceph_mds_session *s)
 {
-	atomic_inc(&s->s_ref);
+	refcount_inc(&s->s_ref);
 	return s;
 }
 
diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index 8f8b41c..dab5d67 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -519,7 +519,7 @@ void ceph_queue_cap_snap(struct ceph_inode_info *ci)
 	     capsnap->need_flush ? "" : "no_flush");
 	ihold(inode);
 
-	atomic_set(&capsnap->nref, 1);
+	refcount_set(&capsnap->nref, 1);
 	INIT_LIST_HEAD(&capsnap->ci_item);
 
 	capsnap->follows = old_snapc->seq;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 3373b61..bda6326 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -14,6 +14,7 @@
 #include <linux/writeback.h>
 #include <linux/slab.h>
 #include <linux/posix_acl.h>
+#include <linux/refcount.h>
 
 #include <linux/ceph/libceph.h>
 
@@ -162,7 +163,7 @@ struct ceph_cap_flush {
  * data before flushing the snapped state (tracked here) back to the MDS.
  */
 struct ceph_cap_snap {
-	atomic_t nref;
+	refcount_t nref;
 	struct list_head ci_item;
 
 	struct ceph_cap_flush cap_flush;
@@ -191,7 +192,7 @@ struct ceph_cap_snap {
 
 static inline void ceph_put_cap_snap(struct ceph_cap_snap *capsnap)
 {
-	if (atomic_dec_and_test(&capsnap->nref)) {
+	if (refcount_dec_and_test(&capsnap->nref)) {
 		if (capsnap->xattr_blob)
 			ceph_buffer_put(capsnap->xattr_blob);
 		kfree(capsnap);
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 70f4e65..8e20e00 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -101,7 +101,7 @@ cifs_sb_active(struct super_block *sb)
 	struct cifs_sb_info *server = CIFS_SB(sb);
 
 	if (atomic_inc_return(&server->active) == 1)
-		atomic_inc(&sb->s_active);
+		refcount_inc(&sb->s_active);
 }
 
 void
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 7ea8a33..14c534d 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -28,6 +28,7 @@
 #include "cifsacl.h"
 #include <crypto/internal/hash.h>
 #include <linux/scatterlist.h>
+#include <linux/refcount.h>
 #include <uapi/linux/cifs/cifs_mount.h>
 #ifdef CONFIG_CIFS_SMB2
 #include "smb2pdu.h"
@@ -968,7 +969,7 @@ struct tcon_link {
 #define TCON_LINK_PENDING	1
 #define TCON_LINK_IN_TREE	2
 	unsigned long		tl_time;
-	atomic_t		tl_count;
+	refcount_t		tl_count;
 	struct cifs_tcon	*tl_tcon;
 };
 
@@ -986,7 +987,7 @@ static inline struct tcon_link *
 cifs_get_tlink(struct tcon_link *tlink)
 {
 	if (tlink && !IS_ERR(tlink))
-		atomic_inc(&tlink->tl_count);
+		refcount_inc(&tlink->tl_count);
 	return tlink;
 }
 
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 35ae49e..b18920f 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2808,7 +2808,7 @@ cifs_put_tlink(struct tcon_link *tlink)
 	if (!tlink || IS_ERR(tlink))
 		return;
 
-	if (!atomic_dec_and_test(&tlink->tl_count) ||
+	if (!refcount_dec_and_test(&tlink->tl_count) ||
 	    test_bit(TCON_LINK_IN_TREE, &tlink->tl_flags)) {
 		tlink->tl_time = jiffies;
 		return;
@@ -4349,7 +4349,7 @@ cifs_prune_tlinks(struct work_struct *work)
 		tlink = rb_entry(tmp, struct tcon_link, tl_rbnode);
 
 		if (test_bit(TCON_LINK_MASTER, &tlink->tl_flags) ||
-		    atomic_read(&tlink->tl_count) != 0 ||
+		    refcount_read(&tlink->tl_count) != 0 ||
 		    time_after(tlink->tl_time + TLINK_IDLE_EXPIRE, jiffies))
 			continue;
 
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 7ab5be7..c6ab340 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1950,7 +1950,7 @@ int cifs_revalidate_dentry_attr(struct dentry *dentry)
 	}
 
 	cifs_dbg(FYI, "Update attributes: %s inode 0x%p count %d dentry: 0x%p d_time %ld jiffies %ld\n",
-		 full_path, inode, inode->i_count.counter,
+		 full_path, inode, atomic_read(&inode->i_count),
 		 dentry, cifs_get_time(dentry), jiffies);
 
 	if (cifs_sb_master_tcon(CIFS_SB(sb))->unix_ext)
diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index 108df2e..fba89ab 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -164,7 +164,7 @@ struct pts_fs_info *devpts_acquire(struct file *filp)
 	/*
 	 * pty code needs to hold extra references in case of last /dev/tty close
 	 */
-	atomic_inc(&sb->s_active);
+	refcount_inc(&sb->s_active);
 	result = DEVPTS_SB(sb);
 
 out:
diff --git a/fs/f2fs/acl.c b/fs/f2fs/acl.c
index 8f48769..b9fc36d 100644
--- a/fs/f2fs/acl.c
+++ b/fs/f2fs/acl.c
@@ -266,7 +266,7 @@ static struct posix_acl *f2fs_acl_clone(const struct posix_acl *acl,
 				sizeof(struct posix_acl_entry);
 		clone = kmemdup(acl, size, flags);
 		if (clone)
-			atomic_set(&clone->a_refcount, 1);
+			refcount_set(&clone->a_refcount, 1);
 	}
 	return clone;
 }
diff --git a/fs/fscache/cache.c b/fs/fscache/cache.c
index 56cce7f..ca6e282 100644
--- a/fs/fscache/cache.c
+++ b/fs/fscache/cache.c
@@ -33,7 +33,7 @@ struct fscache_cache_tag *__fscache_lookup_cache_tag(const char *name)
 
 	list_for_each_entry(tag, &fscache_cache_tag_list, link) {
 		if (strcmp(tag->name, name) == 0) {
-			atomic_inc(&tag->usage);
+			refcount_inc(&tag->usage);
 			up_read(&fscache_addremove_sem);
 			return tag;
 		}
@@ -47,7 +47,7 @@ struct fscache_cache_tag *__fscache_lookup_cache_tag(const char *name)
 		/* return a dummy tag if out of memory */
 		return ERR_PTR(-ENOMEM);
 
-	atomic_set(&xtag->usage, 1);
+	refcount_set(&xtag->usage, 1);
 	strcpy(xtag->name, name);
 
 	/* write lock, search again and add if still not present */
@@ -55,7 +55,7 @@ struct fscache_cache_tag *__fscache_lookup_cache_tag(const char *name)
 
 	list_for_each_entry(tag, &fscache_cache_tag_list, link) {
 		if (strcmp(tag->name, name) == 0) {
-			atomic_inc(&tag->usage);
+			refcount_inc(&tag->usage);
 			up_write(&fscache_addremove_sem);
 			kfree(xtag);
 			return tag;
@@ -75,7 +75,7 @@ void __fscache_release_cache_tag(struct fscache_cache_tag *tag)
 	if (tag != ERR_PTR(-ENOMEM)) {
 		down_write(&fscache_addremove_sem);
 
-		if (atomic_dec_and_test(&tag->usage))
+		if (refcount_dec_and_test(&tag->usage))
 			list_del_init(&tag->link);
 		else
 			tag = NULL;
diff --git a/fs/fscache/operation.c b/fs/fscache/operation.c
index de67745..eb84c95 100644
--- a/fs/fscache/operation.c
+++ b/fs/fscache/operation.c
@@ -38,7 +38,7 @@ void fscache_operation_init(struct fscache_operation *op,
 			    fscache_operation_release_t release)
 {
 	INIT_WORK(&op->work, fscache_op_work_func);
-	atomic_set(&op->usage, 1);
+	refcount_set(&op->usage, 1);
 	op->state = FSCACHE_OP_ST_INITIALISED;
 	op->debug_id = atomic_inc_return(&fscache_op_debug_id);
 	op->processor = processor;
@@ -60,19 +60,19 @@ EXPORT_SYMBOL(fscache_operation_init);
 void fscache_enqueue_operation(struct fscache_operation *op)
 {
 	_enter("{OBJ%x OP%x,%u}",
-	       op->object->debug_id, op->debug_id, atomic_read(&op->usage));
+	       op->object->debug_id, op->debug_id, refcount_read(&op->usage));
 
 	ASSERT(list_empty(&op->pend_link));
 	ASSERT(op->processor != NULL);
 	ASSERT(fscache_object_is_available(op->object));
-	ASSERTCMP(atomic_read(&op->usage), >, 0);
+	ASSERTCMP(refcount_read(&op->usage), >, 0);
 	ASSERTCMP(op->state, ==, FSCACHE_OP_ST_IN_PROGRESS);
 
 	fscache_stat(&fscache_n_op_enqueue);
 	switch (op->flags & FSCACHE_OP_TYPE) {
 	case FSCACHE_OP_ASYNC:
 		_debug("queue async");
-		atomic_inc(&op->usage);
+		refcount_inc(&op->usage);
 		if (!queue_work(fscache_op_wq, &op->work))
 			fscache_put_operation(op);
 		break;
@@ -156,7 +156,7 @@ int fscache_submit_exclusive_op(struct fscache_object *object,
 	_enter("{OBJ%x OP%x},", object->debug_id, op->debug_id);
 
 	ASSERTCMP(op->state, ==, FSCACHE_OP_ST_INITIALISED);
-	ASSERTCMP(atomic_read(&op->usage), >, 0);
+	ASSERTCMP(refcount_read(&op->usage), >, 0);
 
 	spin_lock(&object->lock);
 	ASSERTCMP(object->n_ops, >=, object->n_in_progress);
@@ -183,11 +183,11 @@ int fscache_submit_exclusive_op(struct fscache_object *object,
 		object->n_exclusive++;	/* reads and writes must wait */
 
 		if (object->n_in_progress > 0) {
-			atomic_inc(&op->usage);
+			refcount_inc(&op->usage);
 			list_add_tail(&op->pend_link, &object->pending_ops);
 			fscache_stat(&fscache_n_op_pend);
 		} else if (!list_empty(&object->pending_ops)) {
-			atomic_inc(&op->usage);
+			refcount_inc(&op->usage);
 			list_add_tail(&op->pend_link, &object->pending_ops);
 			fscache_stat(&fscache_n_op_pend);
 			fscache_start_operations(object);
@@ -203,7 +203,7 @@ int fscache_submit_exclusive_op(struct fscache_object *object,
 		op->object = object;
 		object->n_ops++;
 		object->n_exclusive++;	/* reads and writes must wait */
-		atomic_inc(&op->usage);
+		refcount_inc(&op->usage);
 		list_add_tail(&op->pend_link, &object->pending_ops);
 		fscache_stat(&fscache_n_op_pend);
 		ret = 0;
@@ -238,10 +238,10 @@ int fscache_submit_op(struct fscache_object *object,
 	int ret;
 
 	_enter("{OBJ%x OP%x},{%u}",
-	       object->debug_id, op->debug_id, atomic_read(&op->usage));
+	       object->debug_id, op->debug_id, refcount_read(&op->usage));
 
 	ASSERTCMP(op->state, ==, FSCACHE_OP_ST_INITIALISED);
-	ASSERTCMP(atomic_read(&op->usage), >, 0);
+	ASSERTCMP(refcount_read(&op->usage), >, 0);
 
 	spin_lock(&object->lock);
 	ASSERTCMP(object->n_ops, >=, object->n_in_progress);
@@ -267,11 +267,11 @@ int fscache_submit_op(struct fscache_object *object,
 		object->n_ops++;
 
 		if (object->n_exclusive > 0) {
-			atomic_inc(&op->usage);
+			refcount_inc(&op->usage);
 			list_add_tail(&op->pend_link, &object->pending_ops);
 			fscache_stat(&fscache_n_op_pend);
 		} else if (!list_empty(&object->pending_ops)) {
-			atomic_inc(&op->usage);
+			refcount_inc(&op->usage);
 			list_add_tail(&op->pend_link, &object->pending_ops);
 			fscache_stat(&fscache_n_op_pend);
 			fscache_start_operations(object);
@@ -283,7 +283,7 @@ int fscache_submit_op(struct fscache_object *object,
 	} else if (flags & BIT(FSCACHE_OBJECT_IS_LOOKED_UP)) {
 		op->object = object;
 		object->n_ops++;
-		atomic_inc(&op->usage);
+		refcount_inc(&op->usage);
 		list_add_tail(&op->pend_link, &object->pending_ops);
 		fscache_stat(&fscache_n_op_pend);
 		ret = 0;
@@ -359,7 +359,7 @@ int fscache_cancel_op(struct fscache_operation *op,
 
 	ASSERTCMP(op->state, >=, FSCACHE_OP_ST_PENDING);
 	ASSERTCMP(op->state, !=, FSCACHE_OP_ST_CANCELLED);
-	ASSERTCMP(atomic_read(&op->usage), >, 0);
+	ASSERTCMP(refcount_read(&op->usage), >, 0);
 
 	spin_lock(&object->lock);
 
@@ -481,11 +481,11 @@ void fscache_put_operation(struct fscache_operation *op)
 	struct fscache_cache *cache;
 
 	_enter("{OBJ%x OP%x,%d}",
-	       op->object->debug_id, op->debug_id, atomic_read(&op->usage));
+	       op->object->debug_id, op->debug_id, refcount_read(&op->usage));
 
-	ASSERTCMP(atomic_read(&op->usage), >, 0);
+	ASSERTCMP(refcount_read(&op->usage), >, 0);
 
-	if (!atomic_dec_and_test(&op->usage))
+	if (!refcount_dec_and_test(&op->usage))
 		return;
 
 	_debug("PUT OP");
@@ -569,7 +569,7 @@ void fscache_operation_gc(struct work_struct *work)
 		       object->debug_id, op->debug_id);
 		fscache_stat(&fscache_n_op_gc);
 
-		ASSERTCMP(atomic_read(&op->usage), ==, 0);
+		ASSERTCMP(refcount_read(&op->usage), ==, 0);
 		ASSERTCMP(op->state, ==, FSCACHE_OP_ST_DEAD);
 
 		ASSERTCMP(object->n_ops, >, 0);
@@ -599,7 +599,7 @@ void fscache_op_work_func(struct work_struct *work)
 	unsigned long start;
 
 	_enter("{OBJ%x OP%x,%d}",
-	       op->object->debug_id, op->debug_id, atomic_read(&op->usage));
+	       op->object->debug_id, op->debug_id, refcount_read(&op->usage));
 
 	ASSERT(op->processor != NULL);
 	start = jiffies;
diff --git a/fs/fscache/page.c b/fs/fscache/page.c
index c8c4f79..352393c 100644
--- a/fs/fscache/page.c
+++ b/fs/fscache/page.c
@@ -774,7 +774,7 @@ static void fscache_write_op(struct fscache_operation *_op)
 	void *results[1];
 	int ret;
 
-	_enter("{OP%x,%d}", op->op.debug_id, atomic_read(&op->op.usage));
+	_enter("{OP%x,%d}", op->op.debug_id, refcount_read(&op->op.usage));
 
 	spin_lock(&object->lock);
 	cookie = object->cookie;
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 70ea57c..a01e042 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -44,7 +44,7 @@ static void fuse_request_init(struct fuse_req *req, struct page **pages,
 	INIT_LIST_HEAD(&req->list);
 	INIT_LIST_HEAD(&req->intr_entry);
 	init_waitqueue_head(&req->waitq);
-	atomic_set(&req->count, 1);
+	refcount_set(&req->count, 1);
 	req->pages = pages;
 	req->page_descs = page_descs;
 	req->max_pages = npages;
@@ -101,14 +101,14 @@ void fuse_request_free(struct fuse_req *req)
 
 void __fuse_get_request(struct fuse_req *req)
 {
-	atomic_inc(&req->count);
+	refcount_inc(&req->count);
 }
 
 /* Must be called with > 1 refcount */
 static void __fuse_put_request(struct fuse_req *req)
 {
-	BUG_ON(atomic_read(&req->count) < 2);
-	atomic_dec(&req->count);
+	BUG_ON(refcount_read(&req->count) < 2);
+	refcount_dec(&req->count);
 }
 
 static void fuse_req_init_context(struct fuse_req *req)
@@ -263,7 +263,7 @@ struct fuse_req *fuse_get_req_nofail_nopages(struct fuse_conn *fc,
 
 void fuse_put_request(struct fuse_conn *fc, struct fuse_req *req)
 {
-	if (atomic_dec_and_test(&req->count)) {
+	if (refcount_dec_and_test(&req->count)) {
 		if (test_bit(FR_BACKGROUND, &req->flags)) {
 			/*
 			 * We get here in the unlikely case that a background
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 2401c5d..af9c53f 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -58,7 +58,7 @@ struct fuse_file *fuse_file_alloc(struct fuse_conn *fc)
 	}
 
 	INIT_LIST_HEAD(&ff->write_entry);
-	atomic_set(&ff->count, 0);
+	refcount_set(&ff->count, 0);
 	RB_CLEAR_NODE(&ff->polled_node);
 	init_waitqueue_head(&ff->poll_wait);
 
@@ -77,7 +77,7 @@ void fuse_file_free(struct fuse_file *ff)
 
 struct fuse_file *fuse_file_get(struct fuse_file *ff)
 {
-	atomic_inc(&ff->count);
+	refcount_inc(&ff->count);
 	return ff;
 }
 
@@ -88,7 +88,7 @@ static void fuse_release_end(struct fuse_conn *fc, struct fuse_req *req)
 
 static void fuse_file_put(struct fuse_file *ff, bool sync)
 {
-	if (atomic_dec_and_test(&ff->count)) {
+	if (refcount_dec_and_test(&ff->count)) {
 		struct fuse_req *req = ff->reserved_req;
 
 		if (ff->fc->no_open) {
@@ -297,7 +297,7 @@ static int fuse_release(struct inode *inode, struct file *file)
 
 void fuse_sync_release(struct fuse_file *ff, int flags)
 {
-	WARN_ON(atomic_read(&ff->count) > 1);
+	WARN_ON(refcount_read(&ff->count) > 1);
 	fuse_prepare_release(ff, flags, FUSE_RELEASE);
 	__set_bit(FR_FORCE, &ff->reserved_req->flags);
 	__clear_bit(FR_BACKGROUND, &ff->reserved_req->flags);
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 052f8d3..e2769a1 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -24,6 +24,7 @@
 #include <linux/workqueue.h>
 #include <linux/kref.h>
 #include <linux/xattr.h>
+#include <linux/refcount.h>
 
 /** Max number of pages that can be used in a single read request */
 #define FUSE_MAX_PAGES_PER_REQ 32
@@ -137,7 +138,7 @@ struct fuse_file {
 	u64 nodeid;
 
 	/** Refcount */
-	atomic_t count;
+	refcount_t count;
 
 	/** FOPEN_* flags returned by open */
 	u32 open_flags;
@@ -306,7 +307,7 @@ struct fuse_req {
 	struct list_head intr_entry;
 
 	/** refcount */
-	atomic_t count;
+	refcount_t count;
 
 	/** Unique ID for the interrupt request */
 	u64 intr_unique;
@@ -448,7 +449,7 @@ struct fuse_conn {
 	spinlock_t lock;
 
 	/** Refcount */
-	atomic_t count;
+	refcount_t count;
 
 	/** Number of fuse_dev's */
 	atomic_t dev_count;
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 6fe6a88..3961c5f 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -608,7 +608,7 @@ void fuse_conn_init(struct fuse_conn *fc)
 	memset(fc, 0, sizeof(*fc));
 	spin_lock_init(&fc->lock);
 	init_rwsem(&fc->killsb);
-	atomic_set(&fc->count, 1);
+	refcount_set(&fc->count, 1);
 	atomic_set(&fc->dev_count, 1);
 	init_waitqueue_head(&fc->blocked_waitq);
 	init_waitqueue_head(&fc->reserved_req_waitq);
@@ -631,7 +631,7 @@ EXPORT_SYMBOL_GPL(fuse_conn_init);
 
 void fuse_conn_put(struct fuse_conn *fc)
 {
-	if (atomic_dec_and_test(&fc->count)) {
+	if (refcount_dec_and_test(&fc->count)) {
 		if (fc->destroy_req)
 			fuse_request_free(fc->destroy_req);
 		fc->release(fc);
@@ -641,7 +641,7 @@ EXPORT_SYMBOL_GPL(fuse_conn_put);
 
 struct fuse_conn *fuse_conn_get(struct fuse_conn *fc)
 {
-	atomic_inc(&fc->count);
+	refcount_inc(&fc->count);
 	return fc;
 }
 EXPORT_SYMBOL_GPL(fuse_conn_get);
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index e3ee387..49af2ef 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -954,7 +954,7 @@ void gfs2_freeze_func(struct work_struct *work)
 	struct gfs2_sbd *sdp = container_of(work, struct gfs2_sbd, sd_freeze_work);
 	struct super_block *sb = sdp->sd_vfs;
 
-	atomic_inc(&sb->s_active);
+	refcount_inc(&sb->s_active);
 	error = gfs2_glock_nq_init(sdp->sd_freeze_gl, LM_ST_SHARED, 0,
 				   &freeze_gh);
 	if (error) {
diff --git a/fs/hfs/bnode.c b/fs/hfs/bnode.c
index d77d844..7b822e4 100644
--- a/fs/hfs/bnode.c
+++ b/fs/hfs/bnode.c
@@ -257,7 +257,7 @@ static struct hfs_bnode *__hfs_bnode_create(struct hfs_btree *tree, u32 cnid)
 	node->tree = tree;
 	node->this = cnid;
 	set_bit(HFS_BNODE_NEW, &node->flags);
-	atomic_set(&node->refcnt, 1);
+	refcount_set(&node->refcnt, 1);
 	hfs_dbg(BNODE_REFS, "new_node(%d:%d): 1\n",
 		node->tree->cnid, node->this);
 	init_waitqueue_head(&node->lock_wq);
@@ -302,7 +302,7 @@ void hfs_bnode_unhash(struct hfs_bnode *node)
 	struct hfs_bnode **p;
 
 	hfs_dbg(BNODE_REFS, "remove_node(%d:%d): %d\n",
-		node->tree->cnid, node->this, atomic_read(&node->refcnt));
+		node->tree->cnid, node->this, refcount_read(&node->refcnt));
 	for (p = &node->tree->node_hash[hfs_bnode_hash(node->this)];
 	     *p && *p != node; p = &(*p)->next_hash)
 		;
@@ -446,10 +446,10 @@ struct hfs_bnode *hfs_bnode_create(struct hfs_btree *tree, u32 num)
 void hfs_bnode_get(struct hfs_bnode *node)
 {
 	if (node) {
-		atomic_inc(&node->refcnt);
+		refcount_inc(&node->refcnt);
 		hfs_dbg(BNODE_REFS, "get_node(%d:%d): %d\n",
 			node->tree->cnid, node->this,
-			atomic_read(&node->refcnt));
+			refcount_read(&node->refcnt));
 	}
 }
 
@@ -462,9 +462,9 @@ void hfs_bnode_put(struct hfs_bnode *node)
 
 		hfs_dbg(BNODE_REFS, "put_node(%d:%d): %d\n",
 			node->tree->cnid, node->this,
-			atomic_read(&node->refcnt));
-		BUG_ON(!atomic_read(&node->refcnt));
-		if (!atomic_dec_and_lock(&node->refcnt, &tree->hash_lock))
+			refcount_read(&node->refcnt));
+		BUG_ON(!refcount_read(&node->refcnt));
+		if (!refcount_dec_and_lock(&node->refcnt, &tree->hash_lock))
 			return;
 		for (i = 0; i < tree->pages_per_bnode; i++) {
 			if (!node->page[i])
diff --git a/fs/hfs/btree.c b/fs/hfs/btree.c
index 37cdd95..5758e5e 100644
--- a/fs/hfs/btree.c
+++ b/fs/hfs/btree.c
@@ -144,10 +144,10 @@ void hfs_btree_close(struct hfs_btree *tree)
 	for (i = 0; i < NODE_HASH_SIZE; i++) {
 		while ((node = tree->node_hash[i])) {
 			tree->node_hash[i] = node->next_hash;
-			if (atomic_read(&node->refcnt))
+			if (refcount_read(&node->refcnt))
 				pr_err("node %d:%d still has %d user(s)!\n",
 				       node->tree->cnid, node->this,
-				       atomic_read(&node->refcnt));
+				       refcount_read(&node->refcnt));
 			hfs_bnode_free(node);
 			tree->node_hash_cnt--;
 		}
diff --git a/fs/hfs/btree.h b/fs/hfs/btree.h
index f6bd266..99b5fd3 100644
--- a/fs/hfs/btree.h
+++ b/fs/hfs/btree.h
@@ -6,6 +6,7 @@
  * (C) 2003 Ardis Technologies <roman@ardistech.com>
  */
 
+#include <linux/refcount.h>
 #include "hfs_fs.h"
 
 typedef int (*btree_keycmp)(const btree_key *, const btree_key *);
@@ -57,7 +58,7 @@ struct hfs_bnode {
 	struct hfs_bnode *next_hash;
 	unsigned long flags;
 	wait_queue_head_t lock_wq;
-	atomic_t refcnt;
+	refcount_t refcnt;
 	unsigned int page_offset;
 	struct page *page[0];
 };
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index f776acf..8ac61e4 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -98,7 +98,7 @@ static int hfs_releasepage(struct page *page, gfp_t mask)
 		node = hfs_bnode_findhash(tree, nidx);
 		if (!node)
 			;
-		else if (atomic_read(&node->refcnt))
+		else if (refcount_read(&node->refcnt))
 			res = 0;
 		if (res && node) {
 			hfs_bnode_unhash(node);
@@ -113,7 +113,7 @@ static int hfs_releasepage(struct page *page, gfp_t mask)
 			node = hfs_bnode_findhash(tree, nidx++);
 			if (!node)
 				continue;
-			if (atomic_read(&node->refcnt)) {
+			if (refcount_read(&node->refcnt)) {
 				res = 0;
 				break;
 			}
diff --git a/fs/hfsplus/bnode.c b/fs/hfsplus/bnode.c
index ce014ce..9abaf14 100644
--- a/fs/hfsplus/bnode.c
+++ b/fs/hfsplus/bnode.c
@@ -422,7 +422,7 @@ static struct hfs_bnode *__hfs_bnode_create(struct hfs_btree *tree, u32 cnid)
 	node->tree = tree;
 	node->this = cnid;
 	set_bit(HFS_BNODE_NEW, &node->flags);
-	atomic_set(&node->refcnt, 1);
+	refcount_set(&node->refcnt, 1);
 	hfs_dbg(BNODE_REFS, "new_node(%d:%d): 1\n",
 		node->tree->cnid, node->this);
 	init_waitqueue_head(&node->lock_wq);
@@ -468,7 +468,7 @@ void hfs_bnode_unhash(struct hfs_bnode *node)
 	struct hfs_bnode **p;
 
 	hfs_dbg(BNODE_REFS, "remove_node(%d:%d): %d\n",
-		node->tree->cnid, node->this, atomic_read(&node->refcnt));
+		node->tree->cnid, node->this, refcount_read(&node->refcnt));
 	for (p = &node->tree->node_hash[hfs_bnode_hash(node->this)];
 	     *p && *p != node; p = &(*p)->next_hash)
 		;
@@ -614,10 +614,10 @@ struct hfs_bnode *hfs_bnode_create(struct hfs_btree *tree, u32 num)
 void hfs_bnode_get(struct hfs_bnode *node)
 {
 	if (node) {
-		atomic_inc(&node->refcnt);
+		refcount_inc(&node->refcnt);
 		hfs_dbg(BNODE_REFS, "get_node(%d:%d): %d\n",
 			node->tree->cnid, node->this,
-			atomic_read(&node->refcnt));
+			refcount_read(&node->refcnt));
 	}
 }
 
@@ -630,9 +630,9 @@ void hfs_bnode_put(struct hfs_bnode *node)
 
 		hfs_dbg(BNODE_REFS, "put_node(%d:%d): %d\n",
 			node->tree->cnid, node->this,
-			atomic_read(&node->refcnt));
-		BUG_ON(!atomic_read(&node->refcnt));
-		if (!atomic_dec_and_lock(&node->refcnt, &tree->hash_lock))
+			refcount_read(&node->refcnt));
+		BUG_ON(!refcount_read(&node->refcnt));
+		if (!refcount_dec_and_lock(&node->refcnt, &tree->hash_lock))
 			return;
 		for (i = 0; i < tree->pages_per_bnode; i++) {
 			if (!node->page[i])
diff --git a/fs/hfsplus/btree.c b/fs/hfsplus/btree.c
index d9d1a36..0823dca 100644
--- a/fs/hfsplus/btree.c
+++ b/fs/hfsplus/btree.c
@@ -265,11 +265,11 @@ void hfs_btree_close(struct hfs_btree *tree)
 	for (i = 0; i < NODE_HASH_SIZE; i++) {
 		while ((node = tree->node_hash[i])) {
 			tree->node_hash[i] = node->next_hash;
-			if (atomic_read(&node->refcnt))
+			if (refcount_read(&node->refcnt))
 				pr_crit("node %d:%d "
 						"still has %d user(s)!\n",
 					node->tree->cnid, node->this,
-					atomic_read(&node->refcnt));
+					refcount_read(&node->refcnt));
 			hfs_bnode_free(node);
 			tree->node_hash_cnt--;
 		}
diff --git a/fs/hfsplus/dir.c b/fs/hfsplus/dir.c
index 31d5e3f..44825c9 100644
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -371,7 +371,7 @@ static int hfsplus_unlink(struct inode *dir, struct dentry *dentry)
 	mutex_lock(&sbi->vh_mutex);
 	cnid = (u32)(unsigned long)dentry->d_fsdata;
 	if (inode->i_ino == cnid &&
-	    atomic_read(&HFSPLUS_I(inode)->opencnt)) {
+	    refcount_read(&HFSPLUS_I(inode)->opencnt)) {
 		str.name = name;
 		str.len = sprintf(name, "temp%lu", inode->i_ino);
 		res = hfsplus_rename_cat(inode->i_ino,
@@ -394,7 +394,7 @@ static int hfsplus_unlink(struct inode *dir, struct dentry *dentry)
 	if (!inode->i_nlink) {
 		if (inode->i_ino != cnid) {
 			sbi->file_count--;
-			if (!atomic_read(&HFSPLUS_I(inode)->opencnt)) {
+			if (!refcount_read(&HFSPLUS_I(inode)->opencnt)) {
 				res = hfsplus_delete_cat(inode->i_ino,
 							 sbi->hidden_dir,
 							 NULL);
diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
index a3f03b2..8adb343 100644
--- a/fs/hfsplus/hfsplus_fs.h
+++ b/fs/hfsplus/hfsplus_fs.h
@@ -20,6 +20,7 @@
 #include <linux/mutex.h>
 #include <linux/buffer_head.h>
 #include <linux/blkdev.h>
+#include <linux/refcount.h>
 #include "hfsplus_raw.h"
 
 #define DBG_BNODE_REFS	0x00000001
@@ -115,7 +116,7 @@ struct hfs_bnode {
 	struct hfs_bnode *next_hash;
 	unsigned long flags;
 	wait_queue_head_t lock_wq;
-	atomic_t refcnt;
+	refcount_t refcnt;
 	unsigned int page_offset;
 	struct page *page[0];
 };
@@ -206,7 +207,7 @@ static inline struct hfsplus_sb_info *HFSPLUS_SB(struct super_block *sb)
 
 
 struct hfsplus_inode_info {
-	atomic_t opencnt;
+	refcount_t opencnt;
 
 	/*
 	 * Extent allocation information, protected by extents_lock.
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 2e796f8..b7d74bb 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -94,7 +94,7 @@ static int hfsplus_releasepage(struct page *page, gfp_t mask)
 		node = hfs_bnode_findhash(tree, nidx);
 		if (!node)
 			;
-		else if (atomic_read(&node->refcnt))
+		else if (refcount_read(&node->refcnt))
 			res = 0;
 		if (res && node) {
 			hfs_bnode_unhash(node);
@@ -110,7 +110,7 @@ static int hfsplus_releasepage(struct page *page, gfp_t mask)
 			node = hfs_bnode_findhash(tree, nidx++);
 			if (!node)
 				continue;
-			if (atomic_read(&node->refcnt)) {
+			if (refcount_read(&node->refcnt)) {
 				res = 0;
 				break;
 			}
@@ -217,7 +217,7 @@ static int hfsplus_file_open(struct inode *inode, struct file *file)
 		inode = HFSPLUS_I(inode)->rsrc_inode;
 	if (!(file->f_flags & O_LARGEFILE) && i_size_read(inode) > MAX_NON_LFS)
 		return -EOVERFLOW;
-	atomic_inc(&HFSPLUS_I(inode)->opencnt);
+	refcount_inc(&HFSPLUS_I(inode)->opencnt);
 	return 0;
 }
 
@@ -227,7 +227,7 @@ static int hfsplus_file_release(struct inode *inode, struct file *file)
 
 	if (HFSPLUS_IS_RSRC(inode))
 		inode = HFSPLUS_I(inode)->rsrc_inode;
-	if (atomic_dec_and_test(&HFSPLUS_I(inode)->opencnt)) {
+	if (refcount_dec_and_test(&HFSPLUS_I(inode)->opencnt)) {
 		inode_lock(inode);
 		hfsplus_file_truncate(inode);
 		if (inode->i_flags & S_DEAD) {
@@ -372,7 +372,7 @@ struct inode *hfsplus_new_inode(struct super_block *sb, umode_t mode)
 	INIT_LIST_HEAD(&hip->open_dir_list);
 	spin_lock_init(&hip->open_dir_lock);
 	mutex_init(&hip->extents_lock);
-	atomic_set(&hip->opencnt, 0);
+	refcount_set(&hip->opencnt, 0);
 	hip->extent_state = 0;
 	hip->flags = 0;
 	hip->userflags = 0;
diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index 67aedf4..004e246 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -72,7 +72,7 @@ struct inode *hfsplus_iget(struct super_block *sb, unsigned long ino)
 	HFSPLUS_I(inode)->flags = 0;
 	HFSPLUS_I(inode)->extent_state = 0;
 	HFSPLUS_I(inode)->rsrc_inode = NULL;
-	atomic_set(&HFSPLUS_I(inode)->opencnt, 0);
+	refcount_set(&HFSPLUS_I(inode)->opencnt, 0);
 
 	if (inode->i_ino >= HFSPLUS_FIRSTUSER_CNID ||
 	    inode->i_ino == HFSPLUS_ROOT_CNID) {
diff --git a/fs/inode.c b/fs/inode.c
index 88110fd..2aa022c 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -397,7 +397,8 @@ void __iget(struct inode *inode)
  */
 void ihold(struct inode *inode)
 {
-	WARN_ON(atomic_inc_return(&inode->i_count) < 2);
+	atomic_inc(&inode->i_count);
+	WARN_ON(atomic_read(&inode->i_count) < 2);
 }
 EXPORT_SYMBOL(ihold);
 
diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index cf4c636..2227fea 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -480,8 +480,8 @@ static void kernfs_drain(struct kernfs_node *kn)
 void kernfs_get(struct kernfs_node *kn)
 {
 	if (kn) {
-		WARN_ON(!atomic_read(&kn->count));
-		atomic_inc(&kn->count);
+		WARN_ON(!refcount_read(&kn->count));
+		refcount_inc(&kn->count);
 	}
 }
 EXPORT_SYMBOL_GPL(kernfs_get);
@@ -497,7 +497,7 @@ void kernfs_put(struct kernfs_node *kn)
 	struct kernfs_node *parent;
 	struct kernfs_root *root;
 
-	if (!kn || !atomic_dec_and_test(&kn->count))
+	if (!kn || !refcount_dec_and_test(&kn->count))
 		return;
 	root = kernfs_root(kn);
  repeat:
@@ -528,7 +528,7 @@ void kernfs_put(struct kernfs_node *kn)
 
 	kn = parent;
 	if (kn) {
-		if (atomic_dec_and_test(&kn->count))
+		if (refcount_dec_and_test(&kn->count))
 			goto repeat;
 	} else {
 		/* just released the root kn, free @root too */
@@ -625,7 +625,7 @@ static struct kernfs_node *__kernfs_new_node(struct kernfs_root *root,
 		goto err_out2;
 	kn->ino = ret;
 
-	atomic_set(&kn->count, 1);
+	refcount_set(&kn->count, 1);
 	atomic_set(&kn->active, KN_DEACTIVATED_BIAS);
 	RB_CLEAR_NODE(&kn->rb);
 
diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index d5b149a..8d61bcf 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -319,7 +319,7 @@ struct super_block *kernfs_pin_sb(struct kernfs_root *root, const void *ns)
 	list_for_each_entry(info, &root->supers, node) {
 		if (info->ns == ns) {
 			sb = info->sb;
-			if (!atomic_inc_not_zero(&info->sb->s_active))
+			if (!refcount_inc_not_zero(&info->sb->s_active))
 				sb = ERR_PTR(-EINVAL);
 			break;
 		}
diff --git a/fs/lockd/clntproc.c b/fs/lockd/clntproc.c
index 1129520..d9991da 100644
--- a/fs/lockd/clntproc.c
+++ b/fs/lockd/clntproc.c
@@ -48,13 +48,13 @@ void nlmclnt_next_cookie(struct nlm_cookie *c)
 
 static struct nlm_lockowner *nlm_get_lockowner(struct nlm_lockowner *lockowner)
 {
-	atomic_inc(&lockowner->count);
+	refcount_inc(&lockowner->count);
 	return lockowner;
 }
 
 static void nlm_put_lockowner(struct nlm_lockowner *lockowner)
 {
-	if (!atomic_dec_and_lock(&lockowner->count, &lockowner->host->h_lock))
+	if (!refcount_dec_and_lock(&lockowner->count, &lockowner->host->h_lock))
 		return;
 	list_del(&lockowner->list);
 	spin_unlock(&lockowner->host->h_lock);
@@ -105,7 +105,7 @@ static struct nlm_lockowner *nlm_find_lockowner(struct nlm_host *host, fl_owner_
 		res = __nlm_find_lockowner(host, owner);
 		if (res == NULL && new != NULL) {
 			res = new;
-			atomic_set(&new->count, 1);
+			refcount_set(&new->count, 1);
 			new->owner = owner;
 			new->pid = __nlm_alloc_pid(host);
 			new->host = nlm_get_host(host);
@@ -198,7 +198,7 @@ struct nlm_rqst *nlm_alloc_call(struct nlm_host *host)
 	for(;;) {
 		call = kzalloc(sizeof(*call), GFP_KERNEL);
 		if (call != NULL) {
-			atomic_set(&call->a_count, 1);
+			refcount_set(&call->a_count, 1);
 			locks_init_lock(&call->a_args.lock.fl);
 			locks_init_lock(&call->a_res.lock.fl);
 			call->a_host = nlm_get_host(host);
@@ -214,7 +214,7 @@ struct nlm_rqst *nlm_alloc_call(struct nlm_host *host)
 
 void nlmclnt_release_call(struct nlm_rqst *call)
 {
-	if (!atomic_dec_and_test(&call->a_count))
+	if (!refcount_dec_and_test(&call->a_count))
 		return;
 	nlmclnt_release_host(call->a_host);
 	nlmclnt_release_lockargs(call);
@@ -668,7 +668,7 @@ nlmclnt_unlock(struct nlm_rqst *req, struct file_lock *fl)
 		goto out;
 	}
 
-	atomic_inc(&req->a_count);
+	refcount_inc(&req->a_count);
 	status = nlmclnt_async_call(nfs_file_cred(fl->fl_file), req,
 			NLMPROC_UNLOCK, &nlmclnt_unlock_ops);
 	if (status < 0)
@@ -745,7 +745,7 @@ static int nlmclnt_cancel(struct nlm_host *host, int block, struct file_lock *fl
 	nlmclnt_setlockargs(req, fl);
 	req->a_args.block = block;
 
-	atomic_inc(&req->a_count);
+	refcount_inc(&req->a_count);
 	status = nlmclnt_async_call(nfs_file_cred(fl->fl_file), req,
 			NLMPROC_CANCEL, &nlmclnt_cancel_ops);
 	if (status == 0 && req->a_res.status == nlm_lck_denied)
diff --git a/fs/lockd/host.c b/fs/lockd/host.c
index d716c99..c38f43e 100644
--- a/fs/lockd/host.c
+++ b/fs/lockd/host.c
@@ -113,7 +113,7 @@ static struct nlm_host *nlm_alloc_host(struct nlm_lookup_host_info *ni,
 	unsigned long now = jiffies;
 
 	if (nsm != NULL)
-		atomic_inc(&nsm->sm_count);
+		refcount_inc(&nsm->sm_count);
 	else {
 		host = NULL;
 		nsm = nsm_get_handle(ni->net, ni->sap, ni->salen,
@@ -150,7 +150,7 @@ static struct nlm_host *nlm_alloc_host(struct nlm_lookup_host_info *ni,
 	host->h_state      = 0;
 	host->h_nsmstate   = 0;
 	host->h_pidcount   = 0;
-	atomic_set(&host->h_count, 1);
+	refcount_set(&host->h_count, 1);
 	mutex_init(&host->h_mutex);
 	host->h_nextrebind = now + NLM_HOST_REBIND;
 	host->h_expires    = now + NLM_HOST_EXPIRE;
@@ -289,7 +289,7 @@ void nlmclnt_release_host(struct nlm_host *host)
 
 	WARN_ON_ONCE(host->h_server);
 
-	if (atomic_dec_and_test(&host->h_count)) {
+	if (refcount_dec_and_test(&host->h_count)) {
 		WARN_ON_ONCE(!list_empty(&host->h_lockowners));
 		WARN_ON_ONCE(!list_empty(&host->h_granted));
 		WARN_ON_ONCE(!list_empty(&host->h_reclaim));
@@ -409,7 +409,7 @@ void nlmsvc_release_host(struct nlm_host *host)
 	dprintk("lockd: release server host %s\n", host->h_name);
 
 	WARN_ON_ONCE(!host->h_server);
-	atomic_dec(&host->h_count);
+	refcount_dec(&host->h_count);
 }
 
 /*
@@ -503,7 +503,7 @@ struct nlm_host * nlm_get_host(struct nlm_host *host)
 {
 	if (host) {
 		dprintk("lockd: get host %s\n", host->h_name);
-		atomic_inc(&host->h_count);
+		refcount_inc(&host->h_count);
 		host->h_expires = jiffies + NLM_HOST_EXPIRE;
 	}
 	return host;
@@ -590,7 +590,7 @@ static void nlm_complain_hosts(struct net *net)
 		if (net && host->net != net)
 			continue;
 		dprintk("       %s (cnt %d use %d exp %ld net %p)\n",
-			host->h_name, atomic_read(&host->h_count),
+			host->h_name, refcount_read(&host->h_count),
 			host->h_inuse, host->h_expires, host->net);
 	}
 }
@@ -658,11 +658,11 @@ nlm_gc_hosts(struct net *net)
 	for_each_host_safe(host, next, chain, nlm_server_hosts) {
 		if (net && host->net != net)
 			continue;
-		if (atomic_read(&host->h_count) || host->h_inuse
+		if (refcount_read(&host->h_count) || host->h_inuse
 		 || time_before(jiffies, host->h_expires)) {
 			dprintk("nlm_gc_hosts skipping %s "
 				"(cnt %d use %d exp %ld net %p)\n",
-				host->h_name, atomic_read(&host->h_count),
+				host->h_name, refcount_read(&host->h_count),
 				host->h_inuse, host->h_expires, host->net);
 			continue;
 		}
diff --git a/fs/lockd/mon.c b/fs/lockd/mon.c
index 19166d4..0fcbcd6 100644
--- a/fs/lockd/mon.c
+++ b/fs/lockd/mon.c
@@ -189,7 +189,7 @@ void nsm_unmonitor(const struct nlm_host *host)
 	struct nsm_res	res;
 	int status;
 
-	if (atomic_read(&nsm->sm_count) == 1
+	if (refcount_read(&nsm->sm_count) == 1
 	 && nsm->sm_monitored && !nsm->sm_sticky) {
 		dprintk("lockd: nsm_unmonitor(%s)\n", nsm->sm_name);
 
@@ -277,7 +277,7 @@ static struct nsm_handle *nsm_create_handle(const struct sockaddr *sap,
 	if (unlikely(new == NULL))
 		return NULL;
 
-	atomic_set(&new->sm_count, 1);
+	refcount_set(&new->sm_count, 1);
 	new->sm_name = (char *)(new + 1);
 	memcpy(nsm_addr(new), sap, salen);
 	new->sm_addrlen = salen;
@@ -335,13 +335,13 @@ struct nsm_handle *nsm_get_handle(const struct net *net,
 		cached = nsm_lookup_addr(&ln->nsm_handles, sap);
 
 	if (cached != NULL) {
-		atomic_inc(&cached->sm_count);
+		refcount_inc(&cached->sm_count);
 		spin_unlock(&nsm_lock);
 		kfree(new);
 		dprintk("lockd: found nsm_handle for %s (%s), "
 				"cnt %d\n", cached->sm_name,
 				cached->sm_addrbuf,
-				atomic_read(&cached->sm_count));
+				refcount_read(&cached->sm_count));
 		return cached;
 	}
 
@@ -386,12 +386,12 @@ struct nsm_handle *nsm_reboot_lookup(const struct net *net,
 		return cached;
 	}
 
-	atomic_inc(&cached->sm_count);
+	refcount_inc(&cached->sm_count);
 	spin_unlock(&nsm_lock);
 
 	dprintk("lockd: host %s (%s) rebooted, cnt %d\n",
 			cached->sm_name, cached->sm_addrbuf,
-			atomic_read(&cached->sm_count));
+			refcount_read(&cached->sm_count));
 	return cached;
 }
 
@@ -402,7 +402,7 @@ struct nsm_handle *nsm_reboot_lookup(const struct net *net,
  */
 void nsm_release(struct nsm_handle *nsm)
 {
-	if (atomic_dec_and_lock(&nsm->sm_count, &nsm_lock)) {
+	if (refcount_dec_and_lock(&nsm->sm_count, &nsm_lock)) {
 		list_del(&nsm->sm_link);
 		spin_unlock(&nsm_lock);
 		dprintk("lockd: destroyed nsm_handle for %s (%s)\n",
diff --git a/fs/lockd/svcproc.c b/fs/lockd/svcproc.c
index fb26b9f..c1ffd6a 100644
--- a/fs/lockd/svcproc.c
+++ b/fs/lockd/svcproc.c
@@ -263,7 +263,7 @@ static void nlmsvc_callback_exit(struct rpc_task *task, void *data)
 
 void nlmsvc_release_call(struct nlm_rqst *call)
 {
-	if (!atomic_dec_and_test(&call->a_count))
+	if (!refcount_dec_and_test(&call->a_count))
 		return;
 	nlmsvc_release_host(call->a_host);
 	kfree(call);
diff --git a/fs/mbcache.c b/fs/mbcache.c
index b19be42..57a82de 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -89,7 +89,7 @@ int mb_cache_entry_create(struct mb_cache *cache, gfp_t mask, u32 key,
 
 	INIT_LIST_HEAD(&entry->e_list);
 	/* One ref for hash, one ref returned */
-	atomic_set(&entry->e_refcnt, 1);
+	refcount_set(&entry->e_refcnt, 1);
 	entry->e_key = key;
 	entry->e_block = block;
 	entry->e_reusable = reusable;
@@ -108,7 +108,7 @@ int mb_cache_entry_create(struct mb_cache *cache, gfp_t mask, u32 key,
 	spin_lock(&cache->c_list_lock);
 	list_add_tail(&entry->e_list, &cache->c_list);
 	/* Grab ref for LRU list */
-	atomic_inc(&entry->e_refcnt);
+	refcount_inc(&entry->e_refcnt);
 	cache->c_entry_count++;
 	spin_unlock(&cache->c_list_lock);
 
@@ -140,7 +140,7 @@ static struct mb_cache_entry *__entry_find(struct mb_cache *cache,
 		entry = hlist_bl_entry(node, struct mb_cache_entry,
 				       e_hash_list);
 		if (entry->e_key == key && entry->e_reusable) {
-			atomic_inc(&entry->e_refcnt);
+			refcount_inc(&entry->e_refcnt);
 			goto out;
 		}
 		node = node->next;
@@ -203,7 +203,7 @@ struct mb_cache_entry *mb_cache_entry_get(struct mb_cache *cache, u32 key,
 	hlist_bl_lock(head);
 	hlist_bl_for_each_entry(entry, node, head, e_hash_list) {
 		if (entry->e_key == key && entry->e_block == block) {
-			atomic_inc(&entry->e_refcnt);
+			refcount_inc(&entry->e_refcnt);
 			goto out;
 		}
 	}
@@ -239,7 +239,7 @@ void mb_cache_entry_delete_block(struct mb_cache *cache, u32 key,
 			if (!list_empty(&entry->e_list)) {
 				list_del_init(&entry->e_list);
 				cache->c_entry_count--;
-				atomic_dec(&entry->e_refcnt);
+				refcount_dec(&entry->e_refcnt);
 			}
 			spin_unlock(&cache->c_list_lock);
 			mb_cache_entry_put(cache, entry);
@@ -300,7 +300,7 @@ static unsigned long mb_cache_shrink(struct mb_cache *cache,
 		hlist_bl_lock(head);
 		if (!hlist_bl_unhashed(&entry->e_hash_list)) {
 			hlist_bl_del_init(&entry->e_hash_list);
-			atomic_dec(&entry->e_refcnt);
+			refcount_dec(&entry->e_refcnt);
 		}
 		hlist_bl_unlock(head);
 		if (mb_cache_entry_put(cache, entry))
@@ -397,11 +397,11 @@ void mb_cache_destroy(struct mb_cache *cache)
 	list_for_each_entry_safe(entry, next, &cache->c_list, e_list) {
 		if (!hlist_bl_unhashed(&entry->e_hash_list)) {
 			hlist_bl_del_init(&entry->e_hash_list);
-			atomic_dec(&entry->e_refcnt);
+			refcount_dec(&entry->e_refcnt);
 		} else
 			WARN_ON(1);
 		list_del(&entry->e_list);
-		WARN_ON(atomic_read(&entry->e_refcnt) != 1);
+		WARN_ON(refcount_read(&entry->e_refcnt) != 1);
 		mb_cache_entry_put(cache, entry);
 	}
 	kfree(cache->c_hash);
diff --git a/fs/mount.h b/fs/mount.h
index 2c856fc..4e77900 100644
--- a/fs/mount.h
+++ b/fs/mount.h
@@ -3,9 +3,10 @@
 #include <linux/poll.h>
 #include <linux/ns_common.h>
 #include <linux/fs_pin.h>
+#include <linux/refcount.h>
 
 struct mnt_namespace {
-	atomic_t		count;
+	refcount_t		count;
 	struct ns_common	ns;
 	struct mount *	root;
 	struct list_head	list;
@@ -111,7 +112,7 @@ static inline void detach_mounts(struct dentry *dentry)
 
 static inline void get_mnt_ns(struct mnt_namespace *ns)
 {
-	atomic_inc(&ns->count);
+	refcount_inc(&ns->count);
 }
 
 extern seqlock_t mount_lock;
diff --git a/fs/namespace.c b/fs/namespace.c
index b5b1259..550cff9 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1010,7 +1010,7 @@ static struct mount *clone_mnt(struct mount *old, struct dentry *root,
 	    (!(flag & CL_EXPIRE) || list_empty(&old->mnt_expire)))
 		mnt->mnt.mnt_flags |= MNT_LOCKED;
 
-	atomic_inc(&sb->s_active);
+	refcount_inc(&sb->s_active);
 	mnt->mnt.mnt_sb = sb;
 	mnt->mnt.mnt_root = dget(root);
 	mnt->mnt_mountpoint = mnt->mnt.mnt_root;
@@ -2837,7 +2837,7 @@ static struct mnt_namespace *alloc_mnt_ns(struct user_namespace *user_ns)
 	}
 	new_ns->ns.ops = &mntns_operations;
 	new_ns->seq = atomic64_add_return(1, &mnt_ns_seq);
-	atomic_set(&new_ns->count, 1);
+	refcount_set(&new_ns->count, 1);
 	new_ns->root = NULL;
 	INIT_LIST_HEAD(&new_ns->list);
 	init_waitqueue_head(&new_ns->poll);
@@ -2964,7 +2964,7 @@ struct dentry *mount_subtree(struct vfsmount *mnt, const char *name)
 
 	/* trade a vfsmount reference for active sb one */
 	s = path.mnt->mnt_sb;
-	atomic_inc(&s->s_active);
+	refcount_inc(&s->s_active);
 	mntput(path.mnt);
 	/* lock the sucker */
 	down_write(&s->s_umount);
@@ -3227,7 +3227,7 @@ void __init mnt_init(void)
 
 void put_mnt_ns(struct mnt_namespace *ns)
 {
-	if (!atomic_dec_and_test(&ns->count))
+	if (!refcount_dec_and_test(&ns->count))
 		return;
 	drop_collected_mounts(&ns->root->mnt);
 	free_mnt_ns(ns);
diff --git a/fs/ncpfs/sock.c b/fs/ncpfs/sock.c
index f32f272..1bfb544 100644
--- a/fs/ncpfs/sock.c
+++ b/fs/ncpfs/sock.c
@@ -28,6 +28,7 @@
 #include <linux/ipx.h>
 #include <linux/poll.h>
 #include <linux/file.h>
+#include <linux/refcount.h>
 
 #include "ncp_fs.h"
 
@@ -58,7 +59,7 @@ static int _send(struct socket *sock, const void *buff, int len)
 struct ncp_request_reply {
 	struct list_head req;
 	wait_queue_head_t wq;
-	atomic_t refs;
+	refcount_t refs;
 	unsigned char* reply_buf;
 	size_t datalen;
 	int result;
@@ -80,7 +81,7 @@ static inline struct ncp_request_reply* ncp_alloc_req(void)
 		return NULL;
 
 	init_waitqueue_head(&req->wq);
-	atomic_set(&req->refs, (1));
+	refcount_set(&req->refs, (1));
 	req->status = RQ_IDLE;
 
 	return req;
@@ -88,12 +89,12 @@ static inline struct ncp_request_reply* ncp_alloc_req(void)
 
 static void ncp_req_get(struct ncp_request_reply *req)
 {
-	atomic_inc(&req->refs);
+	refcount_inc(&req->refs);
 }
 
 static void ncp_req_put(struct ncp_request_reply *req)
 {
-	if (atomic_dec_and_test(&req->refs))
+	if (refcount_dec_and_test(&req->refs))
 		kfree(req);
 }
 
diff --git a/fs/nfs/cache_lib.c b/fs/nfs/cache_lib.c
index 6de1570..cf8ccb6 100644
--- a/fs/nfs/cache_lib.c
+++ b/fs/nfs/cache_lib.c
@@ -66,7 +66,7 @@ int nfs_cache_upcall(struct cache_detail *cd, char *entry_name)
  */
 void nfs_cache_defer_req_put(struct nfs_cache_defer_req *dreq)
 {
-	if (atomic_dec_and_test(&dreq->count))
+	if (refcount_dec_and_test(&dreq->count))
 		kfree(dreq);
 }
 
@@ -86,7 +86,7 @@ static struct cache_deferred_req *nfs_dns_cache_defer(struct cache_req *req)
 
 	dreq = container_of(req, struct nfs_cache_defer_req, req);
 	dreq->deferred_req.revisit = nfs_dns_cache_revisit;
-	atomic_inc(&dreq->count);
+	refcount_inc(&dreq->count);
 
 	return &dreq->deferred_req;
 }
@@ -98,7 +98,7 @@ struct nfs_cache_defer_req *nfs_cache_defer_req_alloc(void)
 	dreq = kzalloc(sizeof(*dreq), GFP_KERNEL);
 	if (dreq) {
 		init_completion(&dreq->completion);
-		atomic_set(&dreq->count, 1);
+		refcount_set(&dreq->count, 1);
 		dreq->req.defer = nfs_dns_cache_defer;
 	}
 	return dreq;
diff --git a/fs/nfs/cache_lib.h b/fs/nfs/cache_lib.h
index 4116d2c..02b378c 100644
--- a/fs/nfs/cache_lib.h
+++ b/fs/nfs/cache_lib.h
@@ -15,7 +15,7 @@ struct nfs_cache_defer_req {
 	struct cache_req req;
 	struct cache_deferred_req deferred_req;
 	struct completion completion;
-	atomic_t count;
+	refcount_t count;
 };
 
 extern int nfs_cache_upcall(struct cache_detail *cd, char *entry_name);
diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 91a8d61..6c67d2e 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -163,7 +163,7 @@ struct nfs_client *nfs_alloc_client(const struct nfs_client_initdata *cl_init)
 
 	clp->rpc_ops = clp->cl_nfs_mod->rpc_ops;
 
-	atomic_set(&clp->cl_count, 1);
+	refcount_set(&clp->cl_count, 1);
 	clp->cl_cons_state = NFS_CS_INITING;
 
 	memcpy(&clp->cl_addr, cl_init->addr, cl_init->addrlen);
@@ -271,10 +271,10 @@ void nfs_put_client(struct nfs_client *clp)
 	if (!clp)
 		return;
 
-	dprintk("--> nfs_put_client({%d})\n", atomic_read(&clp->cl_count));
+	dprintk("--> nfs_put_client({%d})\n", refcount_read(&clp->cl_count));
 	nn = net_generic(clp->cl_net, nfs_net_id);
 
-	if (atomic_dec_and_lock(&clp->cl_count, &nn->nfs_client_lock)) {
+	if (refcount_dec_and_lock(&clp->cl_count, &nn->nfs_client_lock)) {
 		list_del(&clp->cl_share_link);
 		nfs_cb_idr_remove_locked(clp);
 		spin_unlock(&nn->nfs_client_lock);
@@ -319,7 +319,7 @@ static struct nfs_client *nfs_match_client(const struct nfs_client_initdata *dat
 							   sap))
 				continue;
 
-		atomic_inc(&clp->cl_count);
+		refcount_inc(&clp->cl_count);
 		return clp;
 	}
 	return NULL;
@@ -1029,7 +1029,7 @@ struct nfs_server *nfs_clone_server(struct nfs_server *source,
 	/* Copy data from the source */
 	server->nfs_client = source->nfs_client;
 	server->destroy = source->destroy;
-	atomic_inc(&server->nfs_client->cl_count);
+	refcount_inc(&server->nfs_client->cl_count);
 	nfs_server_copy_userdata(server, source);
 
 	server->fsid = fattr->fsid;
@@ -1195,7 +1195,7 @@ static int nfs_server_list_show(struct seq_file *m, void *v)
 		   clp->rpc_ops->version,
 		   rpc_peeraddr2str(clp->cl_rpcclient, RPC_DISPLAY_HEX_ADDR),
 		   rpc_peeraddr2str(clp->cl_rpcclient, RPC_DISPLAY_HEX_PORT),
-		   atomic_read(&clp->cl_count),
+		   refcount_read(&clp->cl_count),
 		   clp->cl_hostname);
 	rcu_read_unlock();
 
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index fad8104..0c95d2b 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -145,7 +145,7 @@ struct nfs_cache_array_entry {
 };
 
 struct nfs_cache_array {
-	atomic_t refcount;
+	refcount_t refcount;
 	int size;
 	int eof_index;
 	u64 last_cookie;
@@ -201,7 +201,7 @@ void nfs_readdir_clear_array(struct page *page)
 	int i;
 
 	array = kmap_atomic(page);
-	if (atomic_dec_and_test(&array->refcount))
+	if (refcount_dec_and_test(&array->refcount))
 		for (i = 0; i < array->size; i++)
 			kfree(array->array[i].string.name);
 	kunmap_atomic(array);
@@ -210,7 +210,7 @@ void nfs_readdir_clear_array(struct page *page)
 static bool grab_page(struct page *page)
 {
 	struct nfs_cache_array *array = kmap_atomic(page);
-	bool res = atomic_inc_not_zero(&array->refcount);
+	bool res = refcount_inc_not_zero(&array->refcount);
 	kunmap_atomic(array);
 	return res;
 }
@@ -680,7 +680,7 @@ int nfs_readdir_xdr_to_array(nfs_readdir_descriptor_t *desc, struct page *page,
 		goto out_label_free;
 	}
 	memset(array, 0, sizeof(struct nfs_cache_array));
-	atomic_set(&array->refcount, 1);
+	refcount_set(&array->refcount, 1);
 	array->eof_index = -1;
 
 	status = nfs_readdir_alloc_pages(pages, array_size);
diff --git a/fs/nfs/filelayout/filelayout.c b/fs/nfs/filelayout/filelayout.c
index a3fc48b..cf82247 100644
--- a/fs/nfs/filelayout/filelayout.c
+++ b/fs/nfs/filelayout/filelayout.c
@@ -498,10 +498,10 @@ filelayout_read_pagelist(struct nfs_pgio_header *hdr)
 		return PNFS_NOT_ATTEMPTED;
 
 	dprintk("%s USE DS: %s cl_count %d\n", __func__,
-		ds->ds_remotestr, atomic_read(&ds->ds_clp->cl_count));
+		ds->ds_remotestr, refcount_read(&ds->ds_clp->cl_count));
 
 	/* No multipath support. Use first DS */
-	atomic_inc(&ds->ds_clp->cl_count);
+	refcount_inc(&ds->ds_clp->cl_count);
 	hdr->ds_clp = ds->ds_clp;
 	hdr->ds_commit_idx = idx;
 	fh = nfs4_fl_select_ds_fh(lseg, j);
@@ -542,10 +542,10 @@ filelayout_write_pagelist(struct nfs_pgio_header *hdr, int sync)
 
 	dprintk("%s ino %lu sync %d req %Zu@%llu DS: %s cl_count %d\n",
 		__func__, hdr->inode->i_ino, sync, (size_t) hdr->args.count,
-		offset, ds->ds_remotestr, atomic_read(&ds->ds_clp->cl_count));
+		offset, ds->ds_remotestr, refcount_read(&ds->ds_clp->cl_count));
 
 	hdr->pgio_done_cb = filelayout_write_done_cb;
-	atomic_inc(&ds->ds_clp->cl_count);
+	refcount_inc(&ds->ds_clp->cl_count);
 	hdr->ds_clp = ds->ds_clp;
 	hdr->ds_commit_idx = idx;
 	fh = nfs4_fl_select_ds_fh(lseg, j);
@@ -1038,9 +1038,9 @@ static int filelayout_initiate_commit(struct nfs_commit_data *data, int how)
 		goto out_err;
 
 	dprintk("%s ino %lu, how %d cl_count %d\n", __func__,
-		data->inode->i_ino, how, atomic_read(&ds->ds_clp->cl_count));
+		data->inode->i_ino, how, refcount_read(&ds->ds_clp->cl_count));
 	data->commit_done_cb = filelayout_commit_done_cb;
-	atomic_inc(&ds->ds_clp->cl_count);
+	refcount_inc(&ds->ds_clp->cl_count);
 	data->ds_clp = ds->ds_clp;
 	fh = select_ds_fh_from_commit(lseg, data->ds_commit_index);
 	if (fh)
diff --git a/fs/nfs/flexfilelayout/flexfilelayout.c b/fs/nfs/flexfilelayout/flexfilelayout.c
index 0ca4af8..9be6afc 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -187,7 +187,7 @@ ff_layout_add_mirror(struct pnfs_layout_hdr *lo,
 			continue;
 		if (!ff_mirror_match_fh(mirror, pos))
 			continue;
-		if (atomic_inc_not_zero(&pos->ref)) {
+		if (refcount_inc_not_zero(&pos->ref)) {
 			spin_unlock(&inode->i_lock);
 			return pos;
 		}
@@ -218,7 +218,7 @@ static struct nfs4_ff_layout_mirror *ff_layout_alloc_mirror(gfp_t gfp_flags)
 	mirror = kzalloc(sizeof(*mirror), gfp_flags);
 	if (mirror != NULL) {
 		spin_lock_init(&mirror->lock);
-		atomic_set(&mirror->ref, 1);
+		refcount_set(&mirror->ref, 1);
 		INIT_LIST_HEAD(&mirror->mirrors);
 	}
 	return mirror;
@@ -242,7 +242,7 @@ static void ff_layout_free_mirror(struct nfs4_ff_layout_mirror *mirror)
 
 static void ff_layout_put_mirror(struct nfs4_ff_layout_mirror *mirror)
 {
-	if (mirror != NULL && atomic_dec_and_test(&mirror->ref))
+	if (mirror != NULL && refcount_dec_and_test(&mirror->ref))
 		ff_layout_free_mirror(mirror);
 }
 
@@ -1771,10 +1771,10 @@ ff_layout_read_pagelist(struct nfs_pgio_header *hdr)
 	vers = nfs4_ff_layout_ds_version(lseg, idx);
 
 	dprintk("%s USE DS: %s cl_count %d vers %d\n", __func__,
-		ds->ds_remotestr, atomic_read(&ds->ds_clp->cl_count), vers);
+		ds->ds_remotestr, refcount_read(&ds->ds_clp->cl_count), vers);
 
 	hdr->pgio_done_cb = ff_layout_read_done_cb;
-	atomic_inc(&ds->ds_clp->cl_count);
+	refcount_inc(&ds->ds_clp->cl_count);
 	hdr->ds_clp = ds->ds_clp;
 	fh = nfs4_ff_layout_select_ds_fh(lseg, idx);
 	if (fh)
@@ -1830,11 +1830,11 @@ ff_layout_write_pagelist(struct nfs_pgio_header *hdr, int sync)
 
 	dprintk("%s ino %lu sync %d req %Zu@%llu DS: %s cl_count %d vers %d\n",
 		__func__, hdr->inode->i_ino, sync, (size_t) hdr->args.count,
-		offset, ds->ds_remotestr, atomic_read(&ds->ds_clp->cl_count),
+		offset, ds->ds_remotestr, refcount_read(&ds->ds_clp->cl_count),
 		vers);
 
 	hdr->pgio_done_cb = ff_layout_write_done_cb;
-	atomic_inc(&ds->ds_clp->cl_count);
+	refcount_inc(&ds->ds_clp->cl_count);
 	hdr->ds_clp = ds->ds_clp;
 	hdr->ds_commit_idx = idx;
 	fh = nfs4_ff_layout_select_ds_fh(lseg, idx);
@@ -1899,11 +1899,11 @@ static int ff_layout_initiate_commit(struct nfs_commit_data *data, int how)
 	vers = nfs4_ff_layout_ds_version(lseg, idx);
 
 	dprintk("%s ino %lu, how %d cl_count %d vers %d\n", __func__,
-		data->inode->i_ino, how, atomic_read(&ds->ds_clp->cl_count),
+		data->inode->i_ino, how, refcount_read(&ds->ds_clp->cl_count),
 		vers);
 	data->commit_done_cb = ff_layout_commit_done_cb;
 	data->cred = ds_cred;
-	atomic_inc(&ds->ds_clp->cl_count);
+	refcount_inc(&ds->ds_clp->cl_count);
 	data->ds_clp = ds->ds_clp;
 	fh = select_ds_fh_from_commit(lseg, data->ds_commit_index);
 	if (fh)
@@ -2325,7 +2325,7 @@ ff_layout_mirror_prepare_stats(struct pnfs_layout_hdr *lo,
 		if (!test_and_clear_bit(NFS4_FF_MIRROR_STAT_AVAIL, &mirror->flags))
 			continue;
 		/* mirror refcount put in cleanup_layoutstats */
-		if (!atomic_inc_not_zero(&mirror->ref))
+		if (!refcount_inc_not_zero(&mirror->ref))
 			continue;
 		dev = &mirror->mirror_ds->id_node; 
 		memcpy(&devinfo->dev_id, &dev->deviceid, NFS4_DEVICEID4_SIZE);
diff --git a/fs/nfs/flexfilelayout/flexfilelayout.h b/fs/nfs/flexfilelayout/flexfilelayout.h
index f4f39b0..1b5d60b 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.h
+++ b/fs/nfs/flexfilelayout/flexfilelayout.h
@@ -13,6 +13,7 @@
 #define FF_FLAGS_NO_IO_THRU_MDS  2
 #define FF_FLAGS_NO_READ_IO      4
 
+#include <linux/refcount.h>
 #include "../pnfs.h"
 
 /* XXX: Let's filter out insanely large mirror count for now to avoid oom
@@ -81,7 +82,7 @@ struct nfs4_ff_layout_mirror {
 	nfs4_stateid			stateid;
 	struct rpc_cred	__rcu		*ro_cred;
 	struct rpc_cred	__rcu		*rw_cred;
-	atomic_t			ref;
+	refcount_t			ref;
 	spinlock_t			lock;
 	unsigned long			flags;
 	struct nfs4_ff_layoutstat	read_stat;
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 5ca4d96..2c29da9 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -751,7 +751,7 @@ EXPORT_SYMBOL_GPL(nfs_getattr);
 
 static void nfs_init_lock_context(struct nfs_lock_context *l_ctx)
 {
-	atomic_set(&l_ctx->count, 1);
+	refcount_set(&l_ctx->count, 1);
 	l_ctx->lockowner = current->files;
 	INIT_LIST_HEAD(&l_ctx->list);
 	atomic_set(&l_ctx->io_count, 0);
@@ -765,7 +765,7 @@ static struct nfs_lock_context *__nfs_find_lock_context(struct nfs_open_context
 	do {
 		if (pos->lockowner != current->files)
 			continue;
-		atomic_inc(&pos->count);
+		refcount_inc(&pos->count);
 		return pos;
 	} while ((pos = list_entry(pos->list.next, typeof(*pos), list)) != head);
 	return NULL;
@@ -804,7 +804,7 @@ void nfs_put_lock_context(struct nfs_lock_context *l_ctx)
 	struct nfs_open_context *ctx = l_ctx->open_context;
 	struct inode *inode = d_inode(ctx->dentry);
 
-	if (!atomic_dec_and_lock(&l_ctx->count, &inode->i_lock))
+	if (!refcount_dec_and_lock(&l_ctx->count, &inode->i_lock))
 		return;
 	list_del(&l_ctx->list);
 	spin_unlock(&inode->i_lock);
@@ -881,7 +881,7 @@ EXPORT_SYMBOL_GPL(alloc_nfs_open_context);
 struct nfs_open_context *get_nfs_open_context(struct nfs_open_context *ctx)
 {
 	if (ctx != NULL)
-		atomic_inc(&ctx->lock_context.count);
+		refcount_inc(&ctx->lock_context.count);
 	return ctx;
 }
 EXPORT_SYMBOL_GPL(get_nfs_open_context);
@@ -892,11 +892,11 @@ static void __put_nfs_open_context(struct nfs_open_context *ctx, int is_sync)
 	struct super_block *sb = ctx->dentry->d_sb;
 
 	if (!list_empty(&ctx->list)) {
-		if (!atomic_dec_and_lock(&ctx->lock_context.count, &inode->i_lock))
+		if (!refcount_dec_and_lock(&ctx->lock_context.count, &inode->i_lock))
 			return;
 		list_del(&ctx->list);
 		spin_unlock(&inode->i_lock);
-	} else if (!atomic_dec_and_test(&ctx->lock_context.count))
+	} else if (!refcount_dec_and_test(&ctx->lock_context.count))
 		return;
 	if (inode != NULL)
 		NFS_PROTO(inode)->close_context(ctx, is_sync);
diff --git a/fs/nfs/nfs4_fs.h b/fs/nfs/nfs4_fs.h
index 6651658..8b1db33 100644
--- a/fs/nfs/nfs4_fs.h
+++ b/fs/nfs/nfs4_fs.h
@@ -22,6 +22,7 @@
 #define NFS4_MAX_LOOP_ON_RECOVER (10)
 
 #include <linux/seqlock.h>
+#include <linux/refcount.h>
 
 struct idmap;
 
@@ -107,7 +108,7 @@ struct nfs4_state_owner {
 	struct rpc_cred	     *so_cred;	 /* Associated cred */
 
 	spinlock_t	     so_lock;
-	atomic_t	     so_count;
+	refcount_t	     so_count;
 	unsigned long	     so_flags;
 	struct list_head     so_states;
 	struct nfs_seqid_counter so_seqid;
@@ -144,7 +145,7 @@ struct nfs4_lock_state {
 	unsigned long		ls_flags;
 	struct nfs_seqid_counter	ls_seqid;
 	nfs4_stateid		ls_stateid;
-	atomic_t		ls_count;
+	refcount_t		ls_count;
 	fl_owner_t		ls_owner;
 };
 
@@ -183,7 +184,7 @@ struct nfs4_state {
 	unsigned int n_wronly;		/* Number of write-only references */
 	unsigned int n_rdwr;		/* Number of read/write references */
 	fmode_t state;			/* State on the server (R,W, or RW) */
-	atomic_t count;
+	refcount_t count;
 };
 
 
diff --git a/fs/nfs/nfs4client.c b/fs/nfs/nfs4client.c
index 5ae9d64..6984760 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -506,7 +506,7 @@ int nfs40_walk_client_list(struct nfs_client *new,
 		/* If "pos" isn't marked ready, we can't trust the
 		 * remaining fields in "pos" */
 		if (pos->cl_cons_state > NFS_CS_READY) {
-			atomic_inc(&pos->cl_count);
+			refcount_inc(&pos->cl_count);
 			spin_unlock(&nn->nfs_client_lock);
 
 			nfs_put_client(prev);
@@ -541,7 +541,7 @@ int nfs40_walk_client_list(struct nfs_client *new,
 		 * way that a SETCLIENTID_CONFIRM to pos can succeed is
 		 * if new and pos point to the same server:
 		 */
-		atomic_inc(&pos->cl_count);
+		refcount_inc(&pos->cl_count);
 		spin_unlock(&nn->nfs_client_lock);
 
 		nfs_put_client(prev);
@@ -558,7 +558,7 @@ int nfs40_walk_client_list(struct nfs_client *new,
 			prev = NULL;
 			*result = pos;
 			dprintk("NFS: <-- %s using nfs_client = %p ({%d})\n",
-				__func__, pos, atomic_read(&pos->cl_count));
+				__func__, pos, refcount_read(&pos->cl_count));
 			goto out;
 		case -ERESTARTSYS:
 		case -ETIMEDOUT:
@@ -750,7 +750,7 @@ int nfs41_walk_client_list(struct nfs_client *new,
 		 * ID and serverowner fields.  Wait for CREATE_SESSION
 		 * to finish. */
 		if (pos->cl_cons_state > NFS_CS_READY) {
-			atomic_inc(&pos->cl_count);
+			refcount_inc(&pos->cl_count);
 			spin_unlock(&nn->nfs_client_lock);
 
 			nfs_put_client(prev);
@@ -784,11 +784,11 @@ int nfs41_walk_client_list(struct nfs_client *new,
 		if (!nfs4_match_client_owner_id(pos, new))
 			continue;
 found:
-		atomic_inc(&pos->cl_count);
+		refcount_inc(&pos->cl_count);
 		*result = pos;
 		status = 0;
 		dprintk("NFS: <-- %s using nfs_client = %p ({%d})\n",
-			__func__, pos, atomic_read(&pos->cl_count));
+			__func__, pos, refcount_read(&pos->cl_count));
 		break;
 	}
 
@@ -820,7 +820,7 @@ nfs4_find_client_ident(struct net *net, int cb_ident)
 	spin_lock(&nn->nfs_client_lock);
 	clp = idr_find(&nn->cb_ident_idr, cb_ident);
 	if (clp)
-		atomic_inc(&clp->cl_count);
+		refcount_inc(&clp->cl_count);
 	spin_unlock(&nn->nfs_client_lock);
 	return clp;
 }
@@ -875,7 +875,7 @@ nfs4_find_client_sessionid(struct net *net, const struct sockaddr *addr,
 		    sid->data, NFS4_MAX_SESSIONID_LEN) != 0)
 			continue;
 
-		atomic_inc(&clp->cl_count);
+		refcount_inc(&clp->cl_count);
 		spin_unlock(&nn->nfs_client_lock);
 		return clp;
 	}
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 6dcbc5d..d285ec9 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1228,7 +1228,7 @@ static struct nfs4_opendata *nfs4_opendata_alloc(struct dentry *dentry,
 	p->dentry = dget(dentry);
 	p->dir = parent;
 	p->owner = sp;
-	atomic_inc(&sp->so_count);
+	refcount_inc(&sp->so_count);
 	p->o_arg.open_flags = flags;
 	p->o_arg.fmode = fmode & (FMODE_READ|FMODE_WRITE);
 	p->o_arg.umask = current_umask();
@@ -1682,7 +1682,7 @@ static struct nfs4_state *nfs4_try_open_cached(struct nfs4_opendata *opendata)
 out:
 	return ERR_PTR(ret);
 out_return_state:
-	atomic_inc(&state->count);
+	refcount_inc(&state->count);
 	return state;
 }
 
@@ -1748,7 +1748,7 @@ _nfs4_opendata_reclaim_to_nfs4_state(struct nfs4_opendata *data)
 update:
 	update_open_stateid(state, &data->o_res.stateid, NULL,
 			    data->o_arg.fmode);
-	atomic_inc(&state->count);
+	refcount_inc(&state->count);
 
 	return state;
 err:
@@ -1834,7 +1834,7 @@ static struct nfs4_opendata *nfs4_open_recoverdata_alloc(struct nfs_open_context
 	if (opendata == NULL)
 		return ERR_PTR(-ENOMEM);
 	opendata->state = state;
-	atomic_inc(&state->count);
+	refcount_inc(&state->count);
 	return opendata;
 }
 
@@ -2594,7 +2594,7 @@ static int nfs41_check_expired_locks(struct nfs4_state *state)
 		if (test_bit(NFS_LOCK_INITIALIZED, &lsp->ls_flags)) {
 			struct rpc_cred *cred = lsp->ls_state->owner->so_cred;
 
-			atomic_inc(&lsp->ls_count);
+			refcount_inc(&lsp->ls_count);
 			spin_unlock(&state->state_lock);
 
 			nfs4_put_lock_state(prev);
@@ -4863,7 +4863,7 @@ static void nfs4_renew_release(void *calldata)
 	struct nfs4_renewdata *data = calldata;
 	struct nfs_client *clp = data->client;
 
-	if (atomic_read(&clp->cl_count) > 1)
+	if (refcount_read(&clp->cl_count) > 1)
 		nfs4_schedule_state_renewal(clp);
 	nfs_put_client(clp);
 	kfree(data);
@@ -4911,7 +4911,7 @@ static int nfs4_proc_async_renew(struct nfs_client *clp, struct rpc_cred *cred,
 
 	if (renew_flags == 0)
 		return 0;
-	if (!atomic_inc_not_zero(&clp->cl_count))
+	if (!refcount_inc_not_zero(&clp->cl_count))
 		return -EIO;
 	data = kmalloc(sizeof(*data), GFP_NOFS);
 	if (data == NULL)
@@ -5917,7 +5917,7 @@ static struct nfs4_unlockdata *nfs4_alloc_unlockdata(struct file_lock *fl,
 	p->arg.seqid = seqid;
 	p->res.seqid = seqid;
 	p->lsp = lsp;
-	atomic_inc(&lsp->ls_count);
+	refcount_inc(&lsp->ls_count);
 	/* Ensure we don't close file until we're done freeing locks! */
 	p->ctx = get_nfs_open_context(ctx);
 	memcpy(&p->fl, fl, sizeof(p->fl));
@@ -6125,7 +6125,7 @@ static struct nfs4_lockdata *nfs4_alloc_lockdata(struct file_lock *fl,
 	p->res.lock_seqid = p->arg.lock_seqid;
 	p->lsp = lsp;
 	p->server = server;
-	atomic_inc(&lsp->ls_count);
+	refcount_inc(&lsp->ls_count);
 	p->ctx = get_nfs_open_context(ctx);
 	get_file(fl->fl_file);
 	memcpy(&p->fl, fl, sizeof(p->fl));
@@ -7580,7 +7580,7 @@ static int _nfs4_proc_exchange_id(struct nfs_client *clp, struct rpc_cred *cred,
 	struct rpc_task *task;
 	int status = -EIO;
 
-	if (!atomic_inc_not_zero(&clp->cl_count))
+	if (!refcount_inc_not_zero(&clp->cl_count))
 		goto out;
 
 	status = -ENOMEM;
@@ -8142,7 +8142,7 @@ static void nfs41_sequence_release(void *data)
 	struct nfs4_sequence_data *calldata = data;
 	struct nfs_client *clp = calldata->clp;
 
-	if (atomic_read(&clp->cl_count) > 1)
+	if (refcount_read(&clp->cl_count) > 1)
 		nfs4_schedule_state_renewal(clp);
 	nfs_put_client(clp);
 	kfree(calldata);
@@ -8171,7 +8171,7 @@ static void nfs41_sequence_call_done(struct rpc_task *task, void *data)
 	trace_nfs4_sequence(clp, task->tk_status);
 	if (task->tk_status < 0) {
 		dprintk("%s ERROR %d\n", __func__, task->tk_status);
-		if (atomic_read(&clp->cl_count) == 1)
+		if (refcount_read(&clp->cl_count) == 1)
 			goto out;
 
 		if (nfs41_sequence_handle_errors(task, clp) == -EAGAIN) {
@@ -8219,7 +8219,7 @@ static struct rpc_task *_nfs41_proc_sequence(struct nfs_client *clp,
 		.flags = RPC_TASK_ASYNC | RPC_TASK_TIMEOUT,
 	};
 
-	if (!atomic_inc_not_zero(&clp->cl_count))
+	if (!refcount_inc_not_zero(&clp->cl_count))
 		return ERR_PTR(-EIO);
 	calldata = kzalloc(sizeof(*calldata), GFP_NOFS);
 	if (calldata == NULL) {
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 1d152f4..80cf185 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -400,7 +400,7 @@ nfs4_find_state_owner_locked(struct nfs_server *server, struct rpc_cred *cred)
 		else {
 			if (!list_empty(&sp->so_lru))
 				list_del_init(&sp->so_lru);
-			atomic_inc(&sp->so_count);
+			refcount_inc(&sp->so_count);
 			return sp;
 		}
 	}
@@ -427,7 +427,7 @@ nfs4_insert_state_owner_locked(struct nfs4_state_owner *new)
 		else {
 			if (!list_empty(&sp->so_lru))
 				list_del_init(&sp->so_lru);
-			atomic_inc(&sp->so_count);
+			refcount_inc(&sp->so_count);
 			return sp;
 		}
 	}
@@ -486,7 +486,7 @@ nfs4_alloc_state_owner(struct nfs_server *server,
 	spin_lock_init(&sp->so_lock);
 	INIT_LIST_HEAD(&sp->so_states);
 	nfs4_init_seqid_counter(&sp->so_seqid);
-	atomic_set(&sp->so_count, 1);
+	refcount_set(&sp->so_count, 1);
 	INIT_LIST_HEAD(&sp->so_lru);
 	seqcount_init(&sp->so_reclaim_seqcount);
 	mutex_init(&sp->so_delegreturn_mutex);
@@ -593,7 +593,7 @@ void nfs4_put_state_owner(struct nfs4_state_owner *sp)
 	struct nfs_server *server = sp->so_server;
 	struct nfs_client *clp = server->nfs_client;
 
-	if (!atomic_dec_and_lock(&sp->so_count, &clp->cl_lock))
+	if (!refcount_dec_and_lock(&sp->so_count, &clp->cl_lock))
 		return;
 
 	sp->so_expires = jiffies;
@@ -635,7 +635,7 @@ nfs4_alloc_open_state(void)
 	state = kzalloc(sizeof(*state), GFP_NOFS);
 	if (!state)
 		return NULL;
-	atomic_set(&state->count, 1);
+	refcount_set(&state->count, 1);
 	INIT_LIST_HEAD(&state->lock_states);
 	spin_lock_init(&state->state_lock);
 	seqlock_init(&state->seqlock);
@@ -668,7 +668,7 @@ __nfs4_find_state_byowner(struct inode *inode, struct nfs4_state_owner *owner)
 			continue;
 		if (!nfs4_valid_open_stateid(state))
 			continue;
-		if (atomic_inc_not_zero(&state->count))
+		if (refcount_inc_not_zero(&state->count))
 			return state;
 	}
 	return NULL;
@@ -698,7 +698,7 @@ nfs4_get_open_state(struct inode *inode, struct nfs4_state_owner *owner)
 	if (state == NULL && new != NULL) {
 		state = new;
 		state->owner = owner;
-		atomic_inc(&owner->so_count);
+		refcount_inc(&owner->so_count);
 		list_add(&state->inode_states, &nfsi->open_states);
 		ihold(inode);
 		state->inode = inode;
@@ -722,7 +722,7 @@ void nfs4_put_open_state(struct nfs4_state *state)
 	struct inode *inode = state->inode;
 	struct nfs4_state_owner *owner = state->owner;
 
-	if (!atomic_dec_and_lock(&state->count, &owner->so_lock))
+	if (!refcount_dec_and_lock(&state->count, &owner->so_lock))
 		return;
 	spin_lock(&inode->i_lock);
 	list_del(&state->inode_states);
@@ -744,7 +744,7 @@ static void __nfs4_close(struct nfs4_state *state,
 	int call_close = 0;
 	fmode_t newstate;
 
-	atomic_inc(&owner->so_count);
+	refcount_inc(&owner->so_count);
 	/* Protect against nfs4_find_state() */
 	spin_lock(&owner->so_lock);
 	switch (fmode & (FMODE_READ | FMODE_WRITE)) {
@@ -819,7 +819,7 @@ __nfs4_find_lock_state(struct nfs4_state *state,
 			ret = pos;
 	}
 	if (ret)
-		atomic_inc(&ret->ls_count);
+		refcount_inc(&ret->ls_count);
 	return ret;
 }
 
@@ -837,7 +837,7 @@ static struct nfs4_lock_state *nfs4_alloc_lock_state(struct nfs4_state *state, f
 	if (lsp == NULL)
 		return NULL;
 	nfs4_init_seqid_counter(&lsp->ls_seqid);
-	atomic_set(&lsp->ls_count, 1);
+	refcount_set(&lsp->ls_count, 1);
 	lsp->ls_state = state;
 	lsp->ls_owner = fl_owner;
 	lsp->ls_seqid.owner_id = ida_simple_get(&server->lockowner_id, 0, 0, GFP_NOFS);
@@ -901,7 +901,7 @@ void nfs4_put_lock_state(struct nfs4_lock_state *lsp)
 	if (lsp == NULL)
 		return;
 	state = lsp->ls_state;
-	if (!atomic_dec_and_lock(&lsp->ls_count, &state->state_lock))
+	if (!refcount_dec_and_lock(&lsp->ls_count, &state->state_lock))
 		return;
 	list_del(&lsp->ls_locks);
 	if (list_empty(&state->lock_states))
@@ -921,7 +921,7 @@ static void nfs4_fl_copy_lock(struct file_lock *dst, struct file_lock *src)
 	struct nfs4_lock_state *lsp = src->fl_u.nfs4_fl.owner;
 
 	dst->fl_u.nfs4_fl.owner = lsp;
-	atomic_inc(&lsp->ls_count);
+	refcount_inc(&lsp->ls_count);
 }
 
 static void nfs4_fl_release_lock(struct file_lock *fl)
@@ -1170,7 +1170,7 @@ void nfs4_schedule_state_manager(struct nfs_client *clp)
 	if (test_and_set_bit(NFS4CLNT_MANAGER_RUNNING, &clp->cl_state) != 0)
 		return;
 	__module_get(THIS_MODULE);
-	atomic_inc(&clp->cl_count);
+	refcount_inc(&clp->cl_count);
 
 	/* The rcu_read_lock() is not strictly necessary, as the state
 	 * manager is the only thread that ever changes the rpc_xprt
@@ -1262,7 +1262,7 @@ int nfs4_wait_clnt_recover(struct nfs_client *clp)
 
 	might_sleep();
 
-	atomic_inc(&clp->cl_count);
+	refcount_inc(&clp->cl_count);
 	res = wait_on_bit_action(&clp->cl_state, NFS4CLNT_MANAGER_RUNNING,
 				 nfs_wait_bit_killable, TASK_KILLABLE);
 	if (res)
@@ -1519,7 +1519,7 @@ static int nfs4_reclaim_open_state(struct nfs4_state_owner *sp, const struct nfs
 			continue;
 		if (state->state == 0)
 			continue;
-		atomic_inc(&state->count);
+		refcount_inc(&state->count);
 		spin_unlock(&sp->so_lock);
 		status = ops->recover_open(sp, state);
 		if (status >= 0) {
@@ -1778,7 +1778,7 @@ static int nfs4_do_reclaim(struct nfs_client *clp, const struct nfs4_state_recov
 			if (!test_and_clear_bit(ops->owner_flag_bit,
 							&sp->so_flags))
 				continue;
-			if (!atomic_inc_not_zero(&sp->so_count))
+			if (!refcount_inc_not_zero(&sp->so_count))
 				continue;
 			spin_unlock(&clp->cl_lock);
 			rcu_read_unlock();
@@ -2498,7 +2498,7 @@ static void nfs4_state_manager(struct nfs_client *clp)
 			break;
 		if (test_and_set_bit(NFS4CLNT_MANAGER_RUNNING, &clp->cl_state) != 0)
 			break;
-	} while (atomic_read(&clp->cl_count) > 1);
+	} while (refcount_read(&clp->cl_count) > 1);
 	return;
 out_error:
 	if (strlen(section))
diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 59554f3..3064bda 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -98,7 +98,7 @@ unset_pnfs_layoutdriver(struct nfs_server *nfss)
 		if (nfss->pnfs_curr_ld->clear_layoutdriver)
 			nfss->pnfs_curr_ld->clear_layoutdriver(nfss);
 		/* Decrement the MDS count. Purge the deviceid cache if zero */
-		if (atomic_dec_and_test(&nfss->nfs_client->cl_mds_count))
+		if (refcount_dec_and_test(&nfss->nfs_client->cl_mds_count))
 			nfs4_deviceid_purge_client(nfss->nfs_client);
 		module_put(nfss->pnfs_curr_ld->owner);
 	}
@@ -190,7 +190,7 @@ set_pnfs_layoutdriver(struct nfs_server *server, const struct nfs_fh *mntfh,
 		goto out_no_driver;
 	}
 	/* Bump the MDS count */
-	atomic_inc(&server->nfs_client->cl_mds_count);
+	refcount_inc(&server->nfs_client->cl_mds_count);
 
 	dprintk("%s: pNFS module for %u set\n", __func__, id);
 	return;
@@ -251,7 +251,7 @@ EXPORT_SYMBOL_GPL(pnfs_unregister_layoutdriver);
 void
 pnfs_get_layout_hdr(struct pnfs_layout_hdr *lo)
 {
-	atomic_inc(&lo->plh_refcount);
+	refcount_inc(&lo->plh_refcount);
 }
 
 static struct pnfs_layout_hdr *
@@ -296,7 +296,7 @@ pnfs_put_layout_hdr(struct pnfs_layout_hdr *lo)
 
 	pnfs_layoutreturn_before_put_layout_hdr(lo);
 
-	if (atomic_dec_and_lock(&lo->plh_refcount, &inode->i_lock)) {
+	if (refcount_dec_and_lock(&lo->plh_refcount, &inode->i_lock)) {
 		if (!list_empty(&lo->plh_segs))
 			WARN_ONCE(1, "NFS: BUG unfreed layout segments.\n");
 		pnfs_detach_layout_hdr(lo);
@@ -389,14 +389,14 @@ pnfs_layout_set_fail_bit(struct pnfs_layout_hdr *lo, int fail_bit)
 {
 	lo->plh_retry_timestamp = jiffies;
 	if (!test_and_set_bit(fail_bit, &lo->plh_flags))
-		atomic_inc(&lo->plh_refcount);
+		refcount_inc(&lo->plh_refcount);
 }
 
 static void
 pnfs_layout_clear_fail_bit(struct pnfs_layout_hdr *lo, int fail_bit)
 {
 	if (test_and_clear_bit(fail_bit, &lo->plh_flags))
-		atomic_dec(&lo->plh_refcount);
+		refcount_dec(&lo->plh_refcount);
 }
 
 static void
@@ -444,7 +444,7 @@ pnfs_init_lseg(struct pnfs_layout_hdr *lo, struct pnfs_layout_segment *lseg,
 {
 	INIT_LIST_HEAD(&lseg->pls_list);
 	INIT_LIST_HEAD(&lseg->pls_lc_list);
-	atomic_set(&lseg->pls_refcount, 1);
+	refcount_set(&lseg->pls_refcount, 1);
 	set_bit(NFS_LSEG_VALID, &lseg->pls_flags);
 	lseg->pls_layout = lo;
 	lseg->pls_range = *range;
@@ -466,7 +466,7 @@ pnfs_layout_remove_lseg(struct pnfs_layout_hdr *lo,
 	WARN_ON(test_bit(NFS_LSEG_VALID, &lseg->pls_flags));
 	list_del_init(&lseg->pls_list);
 	/* Matched by pnfs_get_layout_hdr in pnfs_layout_insert_lseg */
-	atomic_dec(&lo->plh_refcount);
+	refcount_dec(&lo->plh_refcount);
 	if (test_bit(NFS_LSEG_LAYOUTRETURN, &lseg->pls_flags))
 		return;
 	if (list_empty(&lo->plh_segs) &&
@@ -501,13 +501,13 @@ pnfs_put_lseg(struct pnfs_layout_segment *lseg)
 		return;
 
 	dprintk("%s: lseg %p ref %d valid %d\n", __func__, lseg,
-		atomic_read(&lseg->pls_refcount),
+		refcount_read(&lseg->pls_refcount),
 		test_bit(NFS_LSEG_VALID, &lseg->pls_flags));
 
 	lo = lseg->pls_layout;
 	inode = lo->plh_inode;
 
-	if (atomic_dec_and_lock(&lseg->pls_refcount, &inode->i_lock)) {
+	if (refcount_dec_and_lock(&lseg->pls_refcount, &inode->i_lock)) {
 		if (test_bit(NFS_LSEG_VALID, &lseg->pls_flags)) {
 			spin_unlock(&inode->i_lock);
 			return;
@@ -550,9 +550,9 @@ pnfs_put_lseg_locked(struct pnfs_layout_segment *lseg)
 	assert_spin_locked(&lseg->pls_layout->plh_inode->i_lock);
 
 	dprintk("%s: lseg %p ref %d valid %d\n", __func__, lseg,
-		atomic_read(&lseg->pls_refcount),
+		refcount_read(&lseg->pls_refcount),
 		test_bit(NFS_LSEG_VALID, &lseg->pls_flags));
-	if (atomic_dec_and_test(&lseg->pls_refcount)) {
+	if (refcount_dec_and_test(&lseg->pls_refcount)) {
 		struct pnfs_layout_hdr *lo = lseg->pls_layout;
 		if (test_bit(NFS_LSEG_VALID, &lseg->pls_flags))
 			return;
@@ -587,7 +587,7 @@ pnfs_lseg_range_contained(const struct pnfs_layout_range *l1,
 static bool pnfs_lseg_dec_and_remove_zero(struct pnfs_layout_segment *lseg,
 		struct list_head *tmp_list)
 {
-	if (!atomic_dec_and_test(&lseg->pls_refcount))
+	if (!refcount_dec_and_test(&lseg->pls_refcount))
 		return false;
 	pnfs_layout_remove_lseg(lseg->pls_layout, lseg);
 	list_add(&lseg->pls_list, tmp_list);
@@ -606,7 +606,7 @@ static int mark_lseg_invalid(struct pnfs_layout_segment *lseg,
 		 * outstanding io is finished.
 		 */
 		dprintk("%s: lseg %p ref %d\n", __func__, lseg,
-			atomic_read(&lseg->pls_refcount));
+			refcount_read(&lseg->pls_refcount));
 		if (pnfs_lseg_dec_and_remove_zero(lseg, tmp_list))
 			rv = 1;
 	}
@@ -1487,7 +1487,7 @@ alloc_init_layout_hdr(struct inode *ino,
 	lo = pnfs_alloc_layout_hdr(ino, gfp_flags);
 	if (!lo)
 		return NULL;
-	atomic_set(&lo->plh_refcount, 1);
+	refcount_set(&lo->plh_refcount, 1);
 	INIT_LIST_HEAD(&lo->plh_layouts);
 	INIT_LIST_HEAD(&lo->plh_segs);
 	INIT_LIST_HEAD(&lo->plh_return_segs);
@@ -1582,7 +1582,7 @@ pnfs_find_lseg(struct pnfs_layout_hdr *lo,
 	}
 
 	dprintk("%s:Return lseg %p ref %d\n",
-		__func__, ret, ret ? atomic_read(&ret->pls_refcount) : 0);
+		__func__, ret, ret ? refcount_read(&ret->pls_refcount) : 0);
 	return ret;
 }
 
diff --git a/fs/nfs/pnfs.h b/fs/nfs/pnfs.h
index 63f77b4..61cafea 100644
--- a/fs/nfs/pnfs.h
+++ b/fs/nfs/pnfs.h
@@ -30,6 +30,7 @@
 #ifndef FS_NFS_PNFS_H
 #define FS_NFS_PNFS_H
 
+#include <linux/refcount.h>
 #include <linux/nfs_fs.h>
 #include <linux/nfs_page.h>
 #include <linux/workqueue.h>
@@ -54,7 +55,7 @@ struct nfs4_pnfs_ds {
 	char			*ds_remotestr;	/* comma sep list of addrs */
 	struct list_head	ds_addrs;
 	struct nfs_client	*ds_clp;
-	atomic_t		ds_count;
+	refcount_t		ds_count;
 	unsigned long		ds_state;
 #define NFS4DS_CONNECTING	0	/* ds is establishing connection */
 };
@@ -63,7 +64,7 @@ struct pnfs_layout_segment {
 	struct list_head pls_list;
 	struct list_head pls_lc_list;
 	struct pnfs_layout_range pls_range;
-	atomic_t pls_refcount;
+	refcount_t pls_refcount;
 	u32 pls_seq;
 	unsigned long pls_flags;
 	struct pnfs_layout_hdr *pls_layout;
@@ -185,7 +186,7 @@ struct pnfs_layoutdriver_type {
 };
 
 struct pnfs_layout_hdr {
-	atomic_t		plh_refcount;
+	refcount_t		plh_refcount;
 	atomic_t		plh_outstanding; /* number of RPCs out */
 	struct list_head	plh_layouts;   /* other client layouts */
 	struct list_head	plh_bulk_destroy;
@@ -399,7 +400,7 @@ static inline struct pnfs_layout_segment *
 pnfs_get_lseg(struct pnfs_layout_segment *lseg)
 {
 	if (lseg) {
-		atomic_inc(&lseg->pls_refcount);
+		refcount_inc(&lseg->pls_refcount);
 		smp_mb__after_atomic();
 	}
 	return lseg;
diff --git a/fs/nfs/pnfs_nfs.c b/fs/nfs/pnfs_nfs.c
index 9414b49..13bd1fe 100644
--- a/fs/nfs/pnfs_nfs.c
+++ b/fs/nfs/pnfs_nfs.c
@@ -359,7 +359,7 @@ print_ds(struct nfs4_pnfs_ds *ds)
 		"        client %p\n"
 		"        cl_exchange_flags %x\n",
 		ds->ds_remotestr,
-		atomic_read(&ds->ds_count), ds->ds_clp,
+		refcount_read(&ds->ds_count), ds->ds_clp,
 		ds->ds_clp ? ds->ds_clp->cl_exchange_flags : 0);
 }
 
@@ -472,7 +472,7 @@ static void destroy_ds(struct nfs4_pnfs_ds *ds)
 
 void nfs4_pnfs_ds_put(struct nfs4_pnfs_ds *ds)
 {
-	if (atomic_dec_and_lock(&ds->ds_count,
+	if (refcount_dec_and_lock(&ds->ds_count,
 				&nfs4_ds_cache_lock)) {
 		list_del_init(&ds->ds_node);
 		spin_unlock(&nfs4_ds_cache_lock);
@@ -558,7 +558,7 @@ nfs4_pnfs_ds_add(struct list_head *dsaddrs, gfp_t gfp_flags)
 		INIT_LIST_HEAD(&ds->ds_addrs);
 		list_splice_init(dsaddrs, &ds->ds_addrs);
 		ds->ds_remotestr = remotestr;
-		atomic_set(&ds->ds_count, 1);
+		refcount_set(&ds->ds_count, 1);
 		INIT_LIST_HEAD(&ds->ds_node);
 		ds->ds_clp = NULL;
 		list_add(&ds->ds_node, &nfs4_data_server_cache);
@@ -567,10 +567,10 @@ nfs4_pnfs_ds_add(struct list_head *dsaddrs, gfp_t gfp_flags)
 	} else {
 		kfree(remotestr);
 		kfree(ds);
-		atomic_inc(&tmp_ds->ds_count);
+		refcount_inc(&tmp_ds->ds_count);
 		dprintk("%s data server %s found, inc'ed ds_count to %d\n",
 			__func__, tmp_ds->ds_remotestr,
-			atomic_read(&tmp_ds->ds_count));
+			refcount_read(&tmp_ds->ds_count));
 		ds = tmp_ds;
 	}
 	spin_unlock(&nfs4_ds_cache_lock);
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 6bca178..58e4b51 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -412,10 +412,10 @@ bool nfs_sb_active(struct super_block *sb)
 {
 	struct nfs_server *server = NFS_SB(sb);
 
-	if (!atomic_inc_not_zero(&sb->s_active))
+	if (!refcount_inc_not_zero(&sb->s_active))
 		return false;
 	if (atomic_inc_return(&server->active) != 1)
-		atomic_dec(&sb->s_active);
+		refcount_dec(&sb->s_active);
 	return true;
 }
 EXPORT_SYMBOL_GPL(nfs_sb_active);
diff --git a/fs/nfsd/nfs4layouts.c b/fs/nfsd/nfs4layouts.c
index 596205d..5a83aea 100644
--- a/fs/nfsd/nfs4layouts.c
+++ b/fs/nfsd/nfs4layouts.c
@@ -334,7 +334,7 @@ nfsd4_recall_file_layout(struct nfs4_layout_stateid *ls)
 
 	trace_layout_recall(&ls->ls_stid.sc_stateid);
 
-	atomic_inc(&ls->ls_stid.sc_count);
+	refcount_inc(&ls->ls_stid.sc_count);
 	nfsd4_run_cb(&ls->ls_recall);
 
 out_unlock:
@@ -439,7 +439,7 @@ nfsd4_insert_layout(struct nfsd4_layoutget *lgp, struct nfs4_layout_stateid *ls)
 			goto done;
 	}
 
-	atomic_inc(&ls->ls_stid.sc_count);
+	refcount_inc(&ls->ls_stid.sc_count);
 	list_add_tail(&new->lo_perstate, &ls->ls_layouts);
 	new = NULL;
 done:
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 4b4beaa..c3f17be 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -108,7 +108,7 @@ static bool is_session_dead(struct nfsd4_session *ses)
 
 static __be32 mark_session_dead_locked(struct nfsd4_session *ses, int ref_held_by_me)
 {
-	if (atomic_read(&ses->se_ref) > ref_held_by_me)
+	if (refcount_read(&ses->se_ref) > ref_held_by_me)
 		return nfserr_jukebox;
 	ses->se_flags |= NFS4_SESSION_DEAD;
 	return nfs_ok;
@@ -127,7 +127,7 @@ static __be32 get_client_locked(struct nfs4_client *clp)
 
 	if (is_client_expired(clp))
 		return nfserr_expired;
-	atomic_inc(&clp->cl_refcount);
+	refcount_inc(&clp->cl_refcount);
 	return nfs_ok;
 }
 
@@ -159,7 +159,7 @@ static void put_client_renew_locked(struct nfs4_client *clp)
 
 	lockdep_assert_held(&nn->client_lock);
 
-	if (!atomic_dec_and_test(&clp->cl_refcount))
+	if (!refcount_dec_and_test(&clp->cl_refcount))
 		return;
 	if (!is_client_expired(clp))
 		renew_client_locked(clp);
@@ -169,7 +169,7 @@ static void put_client_renew(struct nfs4_client *clp)
 {
 	struct nfsd_net *nn = net_generic(clp->net, nfsd_net_id);
 
-	if (!atomic_dec_and_lock(&clp->cl_refcount, &nn->client_lock))
+	if (!refcount_dec_and_lock(&clp->cl_refcount, &nn->client_lock))
 		return;
 	if (!is_client_expired(clp))
 		renew_client_locked(clp);
@@ -185,7 +185,7 @@ static __be32 nfsd4_get_session_locked(struct nfsd4_session *ses)
 	status = get_client_locked(ses->se_client);
 	if (status)
 		return status;
-	atomic_inc(&ses->se_ref);
+	refcount_inc(&ses->se_ref);
 	return nfs_ok;
 }
 
@@ -196,7 +196,7 @@ static void nfsd4_put_session_locked(struct nfsd4_session *ses)
 
 	lockdep_assert_held(&nn->client_lock);
 
-	if (atomic_dec_and_test(&ses->se_ref) && is_session_dead(ses))
+	if (refcount_dec_and_test(&ses->se_ref) && is_session_dead(ses))
 		free_session(ses);
 	put_client_renew_locked(clp);
 }
@@ -293,7 +293,7 @@ static const struct nfsd4_callback_ops nfsd4_cb_notify_lock_ops = {
 static inline struct nfs4_stateowner *
 nfs4_get_stateowner(struct nfs4_stateowner *sop)
 {
-	atomic_inc(&sop->so_count);
+	refcount_inc(&sop->so_count);
 	return sop;
 }
 
@@ -359,7 +359,7 @@ put_nfs4_file(struct nfs4_file *fi)
 {
 	might_lock(&state_lock);
 
-	if (atomic_dec_and_lock(&fi->fi_ref, &state_lock)) {
+	if (refcount_dec_and_lock(&fi->fi_ref, &state_lock)) {
 		hlist_del_rcu(&fi->fi_hash);
 		spin_unlock(&state_lock);
 		WARN_ON_ONCE(!list_empty(&fi->fi_clnt_odstate));
@@ -568,7 +568,7 @@ alloc_clnt_odstate(struct nfs4_client *clp)
 	co = kmem_cache_zalloc(odstate_slab, GFP_KERNEL);
 	if (co) {
 		co->co_client = clp;
-		atomic_set(&co->co_odcount, 1);
+		refcount_set(&co->co_odcount, 1);
 	}
 	return co;
 }
@@ -586,7 +586,7 @@ static inline void
 get_clnt_odstate(struct nfs4_clnt_odstate *co)
 {
 	if (co)
-		atomic_inc(&co->co_odcount);
+		refcount_inc(&co->co_odcount);
 }
 
 static void
@@ -598,7 +598,7 @@ put_clnt_odstate(struct nfs4_clnt_odstate *co)
 		return;
 
 	fp = co->co_file;
-	if (atomic_dec_and_lock(&co->co_odcount, &fp->fi_lock)) {
+	if (refcount_dec_and_lock(&co->co_odcount, &fp->fi_lock)) {
 		list_del(&co->co_perfile);
 		spin_unlock(&fp->fi_lock);
 
@@ -654,7 +654,7 @@ struct nfs4_stid *nfs4_alloc_stid(struct nfs4_client *cl,
 	stid->sc_stateid.si_opaque.so_id = new_id;
 	stid->sc_stateid.si_opaque.so_clid = cl->cl_clientid;
 	/* Will be incremented before return to client: */
-	atomic_set(&stid->sc_count, 1);
+	refcount_set(&stid->sc_count, 1);
 	spin_lock_init(&stid->sc_lock);
 
 	/*
@@ -815,7 +815,7 @@ nfs4_put_stid(struct nfs4_stid *s)
 
 	might_lock(&clp->cl_lock);
 
-	if (!atomic_dec_and_lock(&s->sc_count, &clp->cl_lock)) {
+	if (!refcount_dec_and_lock(&s->sc_count, &clp->cl_lock)) {
 		wake_up_all(&close_wq);
 		return;
 	}
@@ -915,7 +915,7 @@ hash_delegation_locked(struct nfs4_delegation *dp, struct nfs4_file *fp)
 	if (status)
 		return status;
 	++fp->fi_delegees;
-	atomic_inc(&dp->dl_stid.sc_count);
+	refcount_inc(&dp->dl_stid.sc_count);
 	dp->dl_stid.sc_type = NFS4_DELEG_STID;
 	list_add(&dp->dl_perfile, &fp->fi_delegations);
 	list_add(&dp->dl_perclnt, &clp->cl_delegations);
@@ -1155,7 +1155,7 @@ static void nfs4_put_stateowner(struct nfs4_stateowner *sop)
 
 	might_lock(&clp->cl_lock);
 
-	if (!atomic_dec_and_lock(&sop->so_count, &clp->cl_lock))
+	if (!refcount_dec_and_lock(&sop->so_count, &clp->cl_lock))
 		return;
 	sop->so_ops->so_unhash(sop);
 	spin_unlock(&clp->cl_lock);
@@ -1216,7 +1216,7 @@ static void put_ol_stateid_locked(struct nfs4_ol_stateid *stp,
 
 	WARN_ON_ONCE(!list_empty(&stp->st_locks));
 
-	if (!atomic_dec_and_test(&s->sc_count)) {
+	if (!refcount_dec_and_test(&s->sc_count)) {
 		wake_up_all(&close_wq);
 		return;
 	}
@@ -1647,7 +1647,7 @@ static void init_session(struct svc_rqst *rqstp, struct nfsd4_session *new, stru
 	new->se_flags = cses->flags;
 	new->se_cb_prog = cses->callback_prog;
 	new->se_cb_sec = cses->cb_sec;
-	atomic_set(&new->se_ref, 0);
+	refcount_set(&new->se_ref, 0);
 	idx = hash_sessionid(&new->se_sessionid);
 	list_add(&new->se_hash, &nn->sessionid_hashtbl[idx]);
 	spin_lock(&clp->cl_lock);
@@ -1766,7 +1766,7 @@ static struct nfs4_client *alloc_client(struct xdr_netobj name)
 	clp->cl_name.len = name.len;
 	INIT_LIST_HEAD(&clp->cl_sessions);
 	idr_init(&clp->cl_stateids);
-	atomic_set(&clp->cl_refcount, 0);
+	refcount_set(&clp->cl_refcount, 0);
 	clp->cl_cb_state = NFSD4_CB_UNKNOWN;
 	INIT_LIST_HEAD(&clp->cl_idhash);
 	INIT_LIST_HEAD(&clp->cl_openowners);
@@ -1794,7 +1794,7 @@ free_client(struct nfs4_client *clp)
 		ses = list_entry(clp->cl_sessions.next, struct nfsd4_session,
 				se_perclnt);
 		list_del(&ses->se_perclnt);
-		WARN_ON_ONCE(atomic_read(&ses->se_ref));
+		WARN_ON_ONCE(refcount_read(&ses->se_ref));
 		free_session(ses);
 	}
 	rpc_destroy_wait_queue(&clp->cl_cb_waitq);
@@ -1843,7 +1843,7 @@ unhash_client(struct nfs4_client *clp)
 
 static __be32 mark_client_expired_locked(struct nfs4_client *clp)
 {
-	if (atomic_read(&clp->cl_refcount))
+	if (refcount_read(&clp->cl_refcount))
 		return nfserr_jukebox;
 	unhash_client_locked(clp);
 	return nfs_ok;
@@ -2087,7 +2087,7 @@ find_stateid_by_type(struct nfs4_client *cl, stateid_t *t, char typemask)
 	s = find_stateid_locked(cl, t);
 	if (s != NULL) {
 		if (typemask & s->sc_type)
-			atomic_inc(&s->sc_count);
+			refcount_inc(&s->sc_count);
 		else
 			s = NULL;
 	}
@@ -3354,7 +3354,7 @@ static void nfsd4_init_file(struct knfsd_fh *fh, unsigned int hashval,
 {
 	lockdep_assert_held(&state_lock);
 
-	atomic_set(&fp->fi_ref, 1);
+	refcount_set(&fp->fi_ref, 1);
 	spin_lock_init(&fp->fi_lock);
 	INIT_LIST_HEAD(&fp->fi_stateids);
 	INIT_LIST_HEAD(&fp->fi_delegations);
@@ -3473,7 +3473,7 @@ static inline void *alloc_stateowner(struct kmem_cache *slab, struct xdr_netobj
 	INIT_LIST_HEAD(&sop->so_stateids);
 	sop->so_client = clp;
 	init_nfs4_replay(&sop->so_replay);
-	atomic_set(&sop->so_count, 1);
+	refcount_set(&sop->so_count, 1);
 	return sop;
 }
 
@@ -3517,7 +3517,7 @@ nfsd4_find_existing_open(struct nfs4_file *fp, struct nfsd4_open *open)
 			continue;
 		if (local->st_stateowner == &oo->oo_owner) {
 			ret = local;
-			atomic_inc(&ret->st_stid.sc_count);
+			refcount_inc(&ret->st_stid.sc_count);
 			break;
 		}
 	}
@@ -3576,7 +3576,7 @@ init_open_stateid(struct nfs4_file *fp, struct nfsd4_open *open)
 		goto out_unlock;
 
 	open->op_stp = NULL;
-	atomic_inc(&stp->st_stid.sc_count);
+	refcount_inc(&stp->st_stid.sc_count);
 	stp->st_stid.sc_type = NFS4_OPEN_STID;
 	INIT_LIST_HEAD(&stp->st_locks);
 	stp->st_stateowner = nfs4_get_stateowner(&oo->oo_owner);
@@ -3624,7 +3624,7 @@ move_to_close_lru(struct nfs4_ol_stateid *s, struct net *net)
 	 * there should be no danger of the refcount going back up again at
 	 * this point.
 	 */
-	wait_event(close_wq, atomic_read(&s->st_stid.sc_count) == 2);
+	wait_event(close_wq, refcount_read(&s->st_stid.sc_count) == 2);
 
 	release_all_access(s);
 	if (s->st_stid.sc_file) {
@@ -3650,7 +3650,7 @@ find_file_locked(struct knfsd_fh *fh, unsigned int hashval)
 
 	hlist_for_each_entry_rcu(fp, &file_hashtbl[hashval], fi_hash) {
 		if (fh_match(&fp->fi_fhandle, fh)) {
-			if (atomic_inc_not_zero(&fp->fi_ref))
+			if (refcount_inc_not_zero(&fp->fi_ref))
 				return fp;
 		}
 	}
@@ -3786,7 +3786,7 @@ static void nfsd_break_one_deleg(struct nfs4_delegation *dp)
 	 * lock) we know the server hasn't removed the lease yet, we know
 	 * it's safe to take a reference.
 	 */
-	atomic_inc(&dp->dl_stid.sc_count);
+	refcount_inc(&dp->dl_stid.sc_count);
 	nfsd4_run_cb(&dp->dl_recall);
 }
 
@@ -3882,7 +3882,7 @@ static __be32 lookup_clientid(clientid_t *clid,
 		spin_unlock(&nn->client_lock);
 		return nfserr_expired;
 	}
-	atomic_inc(&found->cl_refcount);
+	refcount_inc(&found->cl_refcount);
 	spin_unlock(&nn->client_lock);
 
 	/* Cache the nfs4_client in cstate! */
@@ -5071,7 +5071,7 @@ nfsd4_free_stateid(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		ret = nfserr_locks_held;
 		break;
 	case NFS4_LOCK_STID:
-		atomic_inc(&s->sc_count);
+		refcount_inc(&s->sc_count);
 		spin_unlock(&cl->cl_lock);
 		ret = nfsd4_free_lock_stateid(stateid, s);
 		goto out;
@@ -5575,7 +5575,7 @@ init_lock_stateid(struct nfs4_ol_stateid *stp, struct nfs4_lockowner *lo,
 
 	lockdep_assert_held(&clp->cl_lock);
 
-	atomic_inc(&stp->st_stid.sc_count);
+	refcount_inc(&stp->st_stid.sc_count);
 	stp->st_stid.sc_type = NFS4_LOCK_STID;
 	stp->st_stateowner = nfs4_get_stateowner(&lo->lo_owner);
 	get_nfs4_file(fp);
@@ -5602,7 +5602,7 @@ find_lock_stateid(struct nfs4_lockowner *lo, struct nfs4_file *fp)
 
 	list_for_each_entry(lst, &lo->lo_owner.so_stateids, st_perstateowner) {
 		if (lst->st_stid.sc_file == fp) {
-			atomic_inc(&lst->st_stid.sc_count);
+			refcount_inc(&lst->st_stid.sc_count);
 			return lst;
 		}
 	}
@@ -6305,7 +6305,7 @@ nfs4_check_open_reclaim(clientid_t *clid,
 static inline void
 put_client(struct nfs4_client *clp)
 {
-	atomic_dec(&clp->cl_refcount);
+	refcount_dec(&clp->cl_refcount);
 }
 
 static struct nfs4_client *
@@ -6423,7 +6423,7 @@ nfsd_inject_add_lock_to_list(struct nfs4_ol_stateid *lst,
 		return;
 
 	lockdep_assert_held(&nn->client_lock);
-	atomic_inc(&clp->cl_refcount);
+	refcount_inc(&clp->cl_refcount);
 	list_add(&lst->st_locks, collect);
 }
 
@@ -6576,7 +6576,7 @@ nfsd_foreach_client_openowner(struct nfs4_client *clp, u64 max,
 		if (func) {
 			func(oop);
 			if (collect) {
-				atomic_inc(&clp->cl_refcount);
+				refcount_inc(&clp->cl_refcount);
 				list_add(&oop->oo_perclient, collect);
 			}
 		}
@@ -6714,7 +6714,7 @@ static u64 nfsd_find_all_delegations(struct nfs4_client *clp, u64 max,
 			if (dp->dl_time != 0)
 				continue;
 
-			atomic_inc(&clp->cl_refcount);
+			refcount_inc(&clp->cl_refcount);
 			WARN_ON(!unhash_delegation_locked(dp));
 			list_add(&dp->dl_recall_lru, victims);
 		}
diff --git a/fs/nfsd/state.h b/fs/nfsd/state.h
index c939936..74b7ff8 100644
--- a/fs/nfsd/state.h
+++ b/fs/nfsd/state.h
@@ -36,6 +36,7 @@
 #define _NFSD4_STATE_H
 
 #include <linux/idr.h>
+#include <linux/refcount.h>
 #include <linux/sunrpc/svc_xprt.h>
 #include "nfsfh.h"
 
@@ -83,7 +84,7 @@ struct nfsd4_callback_ops {
  * fields that are of general use to any stateid.
  */
 struct nfs4_stid {
-	atomic_t		sc_count;
+	refcount_t		sc_count;
 #define NFS4_OPEN_STID 1
 #define NFS4_LOCK_STID 2
 #define NFS4_DELEG_STID 4
@@ -238,7 +239,7 @@ struct nfsd4_conn {
  * working on the object (primarily during the processing of compounds).
  */
 struct nfsd4_session {
-	atomic_t		se_ref;
+	refcount_t		se_ref;
 	struct list_head	se_hash;	/* hash by sessionid */
 	struct list_head	se_perclnt;
 /* See SESSION4_PERSIST, etc. for standard flags; this is internal-only: */
@@ -343,7 +344,7 @@ struct nfs4_client {
 	struct nfsd4_clid_slot	cl_cs_slot;	/* create_session slot */
 	u32			cl_exchange_flags;
 	/* number of rpc's in progress over an associated session: */
-	atomic_t		cl_refcount;
+	refcount_t		cl_refcount;
 	struct nfs4_op_map      cl_spo_must_allow;
 
 	/* for nfs41 callbacks */
@@ -407,7 +408,7 @@ struct nfs4_stateowner {
 	const struct nfs4_stateowner_operations	*so_ops;
 	/* after increment in nfsd4_bump_seqid, represents the next
 	 * sequence id expected from the client: */
-	atomic_t				so_count;
+	refcount_t				so_count;
 	u32					so_seqid;
 	struct xdr_netobj			so_owner; /* open owner name */
 	struct nfs4_replay			so_replay;
@@ -465,7 +466,7 @@ struct nfs4_clnt_odstate {
 	struct nfs4_client	*co_client;
 	struct nfs4_file	*co_file;
 	struct list_head	co_perfile;
-	atomic_t		co_odcount;
+	refcount_t		co_odcount;
 };
 
 /*
@@ -481,7 +482,7 @@ struct nfs4_clnt_odstate {
  * the global state_lock spinlock.
  */
 struct nfs4_file {
-	atomic_t		fi_ref;
+	refcount_t		fi_ref;
 	spinlock_t		fi_lock;
 	struct hlist_node       fi_hash;	/* hash on fi_fhandle */
 	struct list_head        fi_stateids;
@@ -633,7 +634,7 @@ struct nfs4_file *find_file(struct knfsd_fh *fh);
 void put_nfs4_file(struct nfs4_file *fi);
 static inline void get_nfs4_file(struct nfs4_file *fi)
 {
-	atomic_inc(&fi->fi_ref);
+	refcount_inc(&fi->fi_ref);
 }
 struct file *find_any_file(struct nfs4_file *f);
 
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 2dd75bf..afebb50 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -737,7 +737,7 @@ struct nilfs_root *nilfs_lookup_root(struct the_nilfs *nilfs, __u64 cno)
 		} else if (cno > root->cno) {
 			n = n->rb_right;
 		} else {
-			atomic_inc(&root->count);
+			refcount_inc(&root->count);
 			spin_unlock(&nilfs->ns_cptree_lock);
 			return root;
 		}
@@ -776,7 +776,7 @@ nilfs_find_or_create_root(struct the_nilfs *nilfs, __u64 cno)
 		} else if (cno > root->cno) {
 			p = &(*p)->rb_right;
 		} else {
-			atomic_inc(&root->count);
+			refcount_inc(&root->count);
 			spin_unlock(&nilfs->ns_cptree_lock);
 			kfree(new);
 			return root;
@@ -786,7 +786,7 @@ nilfs_find_or_create_root(struct the_nilfs *nilfs, __u64 cno)
 	new->cno = cno;
 	new->ifile = NULL;
 	new->nilfs = nilfs;
-	atomic_set(&new->count, 1);
+	refcount_set(&new->count, 1);
 	atomic64_set(&new->inodes_count, 0);
 	atomic64_set(&new->blocks_count, 0);
 
@@ -806,7 +806,7 @@ nilfs_find_or_create_root(struct the_nilfs *nilfs, __u64 cno)
 
 void nilfs_put_root(struct nilfs_root *root)
 {
-	if (atomic_dec_and_test(&root->count)) {
+	if (refcount_dec_and_test(&root->count)) {
 		struct the_nilfs *nilfs = root->nilfs;
 
 		nilfs_sysfs_delete_snapshot_group(root);
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index b305c6f..883d732 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -27,6 +27,7 @@
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
 #include <linux/slab.h>
+#include <linux/refcount.h>
 
 struct nilfs_sc_info;
 struct nilfs_sysfs_dev_subgroups;
@@ -246,7 +247,7 @@ struct nilfs_root {
 	__u64 cno;
 	struct rb_node rb_node;
 
-	atomic_t count;
+	refcount_t count;
 	struct the_nilfs *nilfs;
 	struct inode *ifile;
 
@@ -299,7 +300,7 @@ void nilfs_swap_super_block(struct the_nilfs *);
 
 static inline void nilfs_get_root(struct nilfs_root *root)
 {
-	atomic_inc(&root->count);
+	refcount_inc(&root->count);
 }
 
 static inline int nilfs_valid_fs(struct the_nilfs *nilfs)
diff --git a/fs/notify/group.c b/fs/notify/group.c
index fbe3cbe..81356c1 100644
--- a/fs/notify/group.c
+++ b/fs/notify/group.c
@@ -98,7 +98,7 @@ void fsnotify_destroy_group(struct fsnotify_group *group)
  */
 void fsnotify_get_group(struct fsnotify_group *group)
 {
-	atomic_inc(&group->refcnt);
+	refcount_inc(&group->refcnt);
 }
 
 /*
@@ -106,7 +106,7 @@ void fsnotify_get_group(struct fsnotify_group *group)
  */
 void fsnotify_put_group(struct fsnotify_group *group)
 {
-	if (atomic_dec_and_test(&group->refcnt))
+	if (refcount_dec_and_test(&group->refcnt))
 		fsnotify_final_destroy_group(group);
 }
 
@@ -122,7 +122,7 @@ struct fsnotify_group *fsnotify_alloc_group(const struct fsnotify_ops *ops)
 		return ERR_PTR(-ENOMEM);
 
 	/* set to 0 when there a no external references to this group */
-	atomic_set(&group->refcnt, 1);
+	refcount_set(&group->refcnt, 1);
 	atomic_set(&group->num_marks, 0);
 
 	spin_lock_init(&group->notification_lock);
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 69d1ea3..115bea0 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -378,7 +378,7 @@ static struct inotify_inode_mark *inotify_idr_find_locked(struct fsnotify_group
 
 		fsnotify_get_mark(fsn_mark);
 		/* One ref for being in the idr, one ref we just took */
-		BUG_ON(atomic_read(&fsn_mark->refcnt) < 2);
+		BUG_ON(refcount_read(&fsn_mark->refcnt) < 2);
 	}
 
 	return i_mark;
@@ -467,7 +467,7 @@ static void inotify_remove_from_idr(struct fsnotify_group *group,
 	 * one ref held by the caller trying to kill us
 	 * one ref grabbed by inotify_idr_find
 	 */
-	if (unlikely(atomic_read(&i_mark->fsn_mark.refcnt) < 3)) {
+	if (unlikely(refcount_read(&i_mark->fsn_mark.refcnt) < 3)) {
 		printk(KERN_ERR "%s: i_mark=%p i_mark->wd=%d i_mark->group=%p"
 			" i_mark->inode=%p\n", __func__, i_mark, i_mark->wd,
 			i_mark->fsn_mark.group, i_mark->fsn_mark.inode);
diff --git a/fs/notify/mark.c b/fs/notify/mark.c
index d3fea0b..48e9944 100644
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -102,12 +102,12 @@ static DECLARE_DELAYED_WORK(reaper_work, fsnotify_mark_destroy_workfn);
 
 void fsnotify_get_mark(struct fsnotify_mark *mark)
 {
-	atomic_inc(&mark->refcnt);
+	refcount_inc(&mark->refcnt);
 }
 
 void fsnotify_put_mark(struct fsnotify_mark *mark)
 {
-	if (atomic_dec_and_test(&mark->refcnt)) {
+	if (refcount_dec_and_test(&mark->refcnt)) {
 		if (mark->group)
 			fsnotify_put_group(mark->group);
 		mark->free_mark(mark);
@@ -530,7 +530,7 @@ void fsnotify_init_mark(struct fsnotify_mark *mark,
 {
 	memset(mark, 0, sizeof(*mark));
 	spin_lock_init(&mark->lock);
-	atomic_set(&mark->refcnt, 1);
+	refcount_set(&mark->refcnt, 1);
 	mark->free_mark = free_mark;
 }
 
diff --git a/fs/ntfs/aops.c b/fs/ntfs/aops.c
index cc91856..d5c52d1 100644
--- a/fs/ntfs/aops.c
+++ b/fs/ntfs/aops.c
@@ -1290,7 +1290,7 @@ static int ntfs_write_mst_block(struct page *page,
 				tni == base_tni ? "base" : "extent",
 				tni->mft_no);
 		mutex_unlock(&tni->mrec_lock);
-		atomic_dec(&tni->count);
+		refcount_dec(&tni->count);
 		iput(VFS_I(base_tni));
 	}
 	SetPageUptodate(page);
diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index 7c410f8..7facd1a 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -344,7 +344,7 @@ void ntfs_destroy_big_inode(struct inode *inode)
 
 	ntfs_debug("Entering.");
 	BUG_ON(ni->page);
-	if (!atomic_dec_and_test(&ni->count))
+	if (!refcount_dec_and_test(&ni->count))
 		BUG();
 	call_rcu(&inode->i_rcu, ntfs_i_callback);
 }
@@ -367,7 +367,7 @@ static void ntfs_destroy_extent_inode(ntfs_inode *ni)
 {
 	ntfs_debug("Entering.");
 	BUG_ON(ni->page);
-	if (!atomic_dec_and_test(&ni->count))
+	if (!refcount_dec_and_test(&ni->count))
 		BUG();
 	kmem_cache_free(ntfs_inode_cache, ni);
 }
@@ -396,7 +396,7 @@ void __ntfs_init_inode(struct super_block *sb, ntfs_inode *ni)
 	rwlock_init(&ni->size_lock);
 	ni->initialized_size = ni->allocated_size = 0;
 	ni->seq_no = 0;
-	atomic_set(&ni->count, 1);
+	refcount_set(&ni->count, 1);
 	ni->vol = NTFS_SB(sb);
 	ntfs_init_runlist(&ni->runlist);
 	mutex_init(&ni->mrec_lock);
diff --git a/fs/ntfs/inode.h b/fs/ntfs/inode.h
index b3c3469..9058f14 100644
--- a/fs/ntfs/inode.h
+++ b/fs/ntfs/inode.h
@@ -24,7 +24,7 @@
 #ifndef _LINUX_NTFS_INODE_H
 #define _LINUX_NTFS_INODE_H
 
-#include <linux/atomic.h>
+#include <linux/refcount.h>
 
 #include <linux/fs.h>
 #include <linux/list.h>
@@ -52,7 +52,7 @@ struct _ntfs_inode {
 				   See ntfs_inode_state_bits below. */
 	unsigned long mft_no;	/* Number of the mft record / inode. */
 	u16 seq_no;		/* Sequence number of the mft record. */
-	atomic_t count;		/* Inode reference count for book keeping. */
+	refcount_t count;	/* Inode reference count for book keeping. */
 	ntfs_volume *vol;	/* Pointer to the ntfs volume of this inode. */
 	/*
 	 * If NInoAttr() is true, the below fields describe the attribute which
diff --git a/fs/ntfs/mft.c b/fs/ntfs/mft.c
index b6f4021..aad8654 100644
--- a/fs/ntfs/mft.c
+++ b/fs/ntfs/mft.c
@@ -160,7 +160,7 @@ MFT_RECORD *map_mft_record(ntfs_inode *ni)
 	ntfs_debug("Entering for mft_no 0x%lx.", ni->mft_no);
 
 	/* Make sure the ntfs inode doesn't go away. */
-	atomic_inc(&ni->count);
+	refcount_inc(&ni->count);
 
 	/* Serialize access to this mft record. */
 	mutex_lock(&ni->mrec_lock);
@@ -170,7 +170,7 @@ MFT_RECORD *map_mft_record(ntfs_inode *ni)
 		return m;
 
 	mutex_unlock(&ni->mrec_lock);
-	atomic_dec(&ni->count);
+	refcount_dec(&ni->count);
 	ntfs_error(ni->vol->sb, "Failed with error code %lu.", -PTR_ERR(m));
 	return m;
 }
@@ -221,7 +221,7 @@ void unmap_mft_record(ntfs_inode *ni)
 
 	unmap_mft_record_page(ni);
 	mutex_unlock(&ni->mrec_lock);
-	atomic_dec(&ni->count);
+	refcount_dec(&ni->count);
 	/*
 	 * If pure ntfs_inode, i.e. no vfs inode attached, we leave it to
 	 * ntfs_clear_extent_inode() in the extent inode case, and to the
@@ -258,7 +258,7 @@ MFT_RECORD *map_extent_mft_record(ntfs_inode *base_ni, MFT_REF mref,
 	ntfs_debug("Mapping extent mft record 0x%lx (base mft record 0x%lx).",
 			mft_no, base_ni->mft_no);
 	/* Make sure the base ntfs inode doesn't go away. */
-	atomic_inc(&base_ni->count);
+	refcount_inc(&base_ni->count);
 	/*
 	 * Check if this extent inode has already been added to the base inode,
 	 * in which case just return it. If not found, add it to the base
@@ -272,17 +272,17 @@ MFT_RECORD *map_extent_mft_record(ntfs_inode *base_ni, MFT_REF mref,
 				continue;
 			ni = extent_nis[i];
 			/* Make sure the ntfs inode doesn't go away. */
-			atomic_inc(&ni->count);
+			refcount_inc(&ni->count);
 			break;
 		}
 	}
 	if (likely(ni != NULL)) {
 		mutex_unlock(&base_ni->extent_lock);
-		atomic_dec(&base_ni->count);
+		refcount_dec(&base_ni->count);
 		/* We found the record; just have to map and return it. */
 		m = map_mft_record(ni);
 		/* map_mft_record() has incremented this on success. */
-		atomic_dec(&ni->count);
+		refcount_dec(&ni->count);
 		if (likely(!IS_ERR(m))) {
 			/* Verify the sequence number. */
 			if (likely(le16_to_cpu(m->sequence_number) == seq_no)) {
@@ -305,7 +305,7 @@ MFT_RECORD *map_extent_mft_record(ntfs_inode *base_ni, MFT_REF mref,
 	ni = ntfs_new_extent_inode(base_ni->vol->sb, mft_no);
 	if (unlikely(!ni)) {
 		mutex_unlock(&base_ni->extent_lock);
-		atomic_dec(&base_ni->count);
+		refcount_dec(&base_ni->count);
 		return ERR_PTR(-ENOMEM);
 	}
 	ni->vol = base_ni->vol;
@@ -316,7 +316,7 @@ MFT_RECORD *map_extent_mft_record(ntfs_inode *base_ni, MFT_REF mref,
 	m = map_mft_record(ni);
 	if (IS_ERR(m)) {
 		mutex_unlock(&base_ni->extent_lock);
-		atomic_dec(&base_ni->count);
+		refcount_dec(&base_ni->count);
 		ntfs_clear_extent_inode(ni);
 		goto map_err_out;
 	}
@@ -351,14 +351,14 @@ MFT_RECORD *map_extent_mft_record(ntfs_inode *base_ni, MFT_REF mref,
 	}
 	base_ni->ext.extent_ntfs_inos[base_ni->nr_extents++] = ni;
 	mutex_unlock(&base_ni->extent_lock);
-	atomic_dec(&base_ni->count);
+	refcount_dec(&base_ni->count);
 	ntfs_debug("Done 2.");
 	*ntfs_ino = ni;
 	return m;
 unm_err_out:
 	unmap_mft_record(ni);
 	mutex_unlock(&base_ni->extent_lock);
-	atomic_dec(&base_ni->count);
+	refcount_dec(&base_ni->count);
 	/*
 	 * If the extent inode was not attached to the base inode we need to
 	 * release it or we will leak memory.
@@ -971,12 +971,12 @@ bool ntfs_may_write_mft_record(ntfs_volume *vol, const unsigned long mft_no,
 		/* The inode is in icache. */
 		ni = NTFS_I(vi);
 		/* Take a reference to the ntfs inode. */
-		atomic_inc(&ni->count);
+		refcount_inc(&ni->count);
 		/* If the inode is dirty, do not write this record. */
 		if (NInoDirty(ni)) {
 			ntfs_debug("Inode 0x%lx is dirty, do not write it.",
 					mft_no);
-			atomic_dec(&ni->count);
+			refcount_dec(&ni->count);
 			iput(vi);
 			return false;
 		}
@@ -985,7 +985,7 @@ bool ntfs_may_write_mft_record(ntfs_volume *vol, const unsigned long mft_no,
 		if (unlikely(!mutex_trylock(&ni->mrec_lock))) {
 			ntfs_debug("Mft record 0x%lx is already locked, do "
 					"not write it.", mft_no);
-			atomic_dec(&ni->count);
+			refcount_dec(&ni->count);
 			iput(vi);
 			return false;
 		}
@@ -1081,14 +1081,14 @@ bool ntfs_may_write_mft_record(ntfs_volume *vol, const unsigned long mft_no,
 	ntfs_debug("Extent inode 0x%lx is attached to its base inode 0x%lx.",
 			mft_no, na.mft_no);
 	/* Take a reference to the extent ntfs inode. */
-	atomic_inc(&eni->count);
+	refcount_inc(&eni->count);
 	mutex_unlock(&ni->extent_lock);
 	/*
 	 * Found the extent inode coresponding to this extent mft record.
 	 * Try to take the mft record lock.
 	 */
 	if (unlikely(!mutex_trylock(&eni->mrec_lock))) {
-		atomic_dec(&eni->count);
+		refcount_dec(&eni->count);
 		iput(vi);
 		ntfs_debug("Extent mft record 0x%lx is already locked, do "
 				"not write it.", mft_no);
@@ -2707,7 +2707,7 @@ ntfs_inode *ntfs_mft_record_alloc(ntfs_volume *vol, const int mode,
 		 * Manually map, pin, and lock the mft record as we already
 		 * have its page mapped and it is very easy to do.
 		 */
-		atomic_inc(&ni->count);
+		refcount_inc(&ni->count);
 		mutex_lock(&ni->mrec_lock);
 		ni->page = page;
 		ni->page_ofs = ofs;
@@ -2807,7 +2807,7 @@ int ntfs_extent_mft_record_free(ntfs_inode *ni, MFT_RECORD *m)
 	mutex_lock(&base_ni->extent_lock);
 
 	/* Make sure we are holding the only reference to the extent inode. */
-	if (atomic_read(&ni->count) > 2) {
+	if (refcount_read(&ni->count) > 2) {
 		ntfs_error(vol->sb, "Tried to free busy extent inode 0x%lx, "
 				"not freeing.", base_ni->mft_no);
 		mutex_unlock(&base_ni->extent_lock);
diff --git a/fs/ocfs2/filecheck.c b/fs/ocfs2/filecheck.c
index 2cabbcf..98835e8 100644
--- a/fs/ocfs2/filecheck.c
+++ b/fs/ocfs2/filecheck.c
@@ -26,6 +26,7 @@
 #include <linux/kobject.h>
 #include <linux/sysfs.h>
 #include <linux/sysctl.h>
+#include <linux/refcount.h>
 #include <cluster/masklog.h>
 
 #include "ocfs2.h"
@@ -66,7 +67,7 @@ struct ocfs2_filecheck {
 
 struct ocfs2_filecheck_sysfs_entry {	/* sysfs entry per mounting */
 	struct list_head fs_list;
-	atomic_t fs_count;
+	refcount_t fs_count;
 	struct super_block *fs_sb;
 	struct kset *fs_devicekset;
 	struct kset *fs_fcheckkset;
@@ -140,8 +141,10 @@ ocfs2_filecheck_sysfs_free(struct ocfs2_filecheck_sysfs_entry *entry)
 {
 	struct ocfs2_filecheck_entry *p;
 
-	if (!atomic_dec_and_test(&entry->fs_count))
-		wait_on_atomic_t(&entry->fs_count, ocfs2_filecheck_sysfs_wait,
+	if (!refcount_dec_and_test(&entry->fs_count))
+		/* FIXME: Exposes refcount_t internals! */
+		wait_on_atomic_t(&entry->fs_count.refs,
+				 ocfs2_filecheck_sysfs_wait,
 				 TASK_UNINTERRUPTIBLE);
 
 	spin_lock(&entry->fs_fcheck->fc_lock);
@@ -188,8 +191,8 @@ static int ocfs2_filecheck_sysfs_del(const char *devname)
 static void
 ocfs2_filecheck_sysfs_put(struct ocfs2_filecheck_sysfs_entry *entry)
 {
-	if (atomic_dec_and_test(&entry->fs_count))
-		wake_up_atomic_t(&entry->fs_count);
+	if (refcount_dec_and_test(&entry->fs_count))
+		wake_up_atomic_t(&entry->fs_count.refs);
 }
 
 static struct ocfs2_filecheck_sysfs_entry *
@@ -200,7 +203,7 @@ ocfs2_filecheck_sysfs_get(const char *devname)
 	spin_lock(&ocfs2_filecheck_sysfs_lock);
 	list_for_each_entry(p, &ocfs2_filecheck_sysfs_list, fs_list) {
 		if (!strcmp(p->fs_sb->s_id, devname)) {
-			atomic_inc(&p->fs_count);
+			refcount_inc(&p->fs_count);
 			spin_unlock(&ocfs2_filecheck_sysfs_lock);
 			return p;
 		}
@@ -276,7 +279,7 @@ int ocfs2_filecheck_create_sysfs(struct super_block *sb)
 		ret = -ENOMEM;
 		goto error;
 	} else {
-		atomic_set(&entry->fs_count, 1);
+		refcount_set(&entry->fs_count, 1);
 		entry->fs_sb = sb;
 		entry->fs_devicekset = device_kset;
 		entry->fs_fcheckkset = fcheck_kset;
diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index 5955220..71d0774 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -42,7 +42,7 @@ struct posix_acl *get_cached_acl(struct inode *inode, int type)
 		rcu_read_lock();
 		acl = rcu_dereference(*p);
 		if (!acl || is_uncached_acl(acl) ||
-		    atomic_inc_not_zero(&acl->a_refcount))
+		    refcount_inc_not_zero(&acl->a_refcount))
 			break;
 		rcu_read_unlock();
 		cpu_relax();
@@ -163,7 +163,7 @@ EXPORT_SYMBOL(get_acl);
 void
 posix_acl_init(struct posix_acl *acl, int count)
 {
-	atomic_set(&acl->a_refcount, 1);
+	refcount_set(&acl->a_refcount, 1);
 	acl->a_count = count;
 }
 EXPORT_SYMBOL(posix_acl_init);
@@ -196,7 +196,7 @@ posix_acl_clone(const struct posix_acl *acl, gfp_t flags)
 		           sizeof(struct posix_acl_entry);
 		clone = kmemdup(acl, size, flags);
 		if (clone)
-			atomic_set(&clone->a_refcount, 1);
+			refcount_set(&clone->a_refcount, 1);
 	}
 	return clone;
 }
diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index f6a01f0..f7d462d 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -387,7 +387,7 @@ static struct proc_dir_entry *__proc_create(struct proc_dir_entry **parent,
 	ent->mode = mode;
 	ent->nlink = nlink;
 	ent->subdir = RB_ROOT;
-	atomic_set(&ent->count, 1);
+	refcount_set(&ent->count, 1);
 	spin_lock_init(&ent->pde_unload_lock);
 	INIT_LIST_HEAD(&ent->pde_openers);
 	proc_set_user(ent, (*parent)->uid, (*parent)->gid);
@@ -539,7 +539,7 @@ static void free_proc_entry(struct proc_dir_entry *de)
 
 void pde_put(struct proc_dir_entry *pde)
 {
-	if (atomic_dec_and_test(&pde->count))
+	if (refcount_dec_and_test(&pde->count))
 		free_proc_entry(pde);
 }
 
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 2de5194..1943a9b 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -13,6 +13,7 @@
 #include <linux/proc_ns.h>
 #include <linux/spinlock.h>
 #include <linux/atomic.h>
+#include <linux/refcount.h>
 #include <linux/binfmts.h>
 
 struct ctl_table_header;
@@ -41,7 +42,7 @@ struct proc_dir_entry {
 	struct rb_root subdir;
 	struct rb_node subdir_node;
 	void *data;
-	atomic_t count;		/* use count */
+	refcount_t count;	/* use count */
 	atomic_t in_use;	/* number of callers into module in progress; */
 			/* negative -> it's going away RSN */
 	struct completion *pde_unload_completion;
@@ -186,7 +187,7 @@ extern int proc_readdir_de(struct proc_dir_entry *, struct file *, struct dir_co
 
 static inline struct proc_dir_entry *pde_get(struct proc_dir_entry *pde)
 {
-	atomic_inc(&pde->count);
+	refcount_inc(&pde->count);
 	return pde;
 }
 extern void pde_put(struct proc_dir_entry *);
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 1988440..ade9bd5 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -203,7 +203,7 @@ struct proc_dir_entry proc_root = {
 	.namelen	= 5, 
 	.mode		= S_IFDIR | S_IRUGO | S_IXUGO, 
 	.nlink		= 2, 
-	.count		= ATOMIC_INIT(1),
+	.count		= REFCOUNT_INIT(1),
 	.proc_iops	= &proc_root_inode_operations, 
 	.proc_fops	= &proc_root_operations,
 	.parent		= &proc_root,
diff --git a/fs/super.c b/fs/super.c
index 1709ed0..917995c 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -240,7 +240,7 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags,
 	 */
 	down_write_nested(&s->s_umount, SINGLE_DEPTH_NESTING);
 	s->s_count = 1;
-	atomic_set(&s->s_active, 1);
+	refcount_set(&s->s_active, 1);
 	mutex_init(&s->s_vfs_rename_mutex);
 	lockdep_set_class(&s->s_vfs_rename_mutex, &type->s_vfs_rename_key);
 	mutex_init(&s->s_dquot.dqio_mutex);
@@ -303,7 +303,7 @@ static void put_super(struct super_block *sb)
 void deactivate_locked_super(struct super_block *s)
 {
 	struct file_system_type *fs = s->s_type;
-	if (atomic_dec_and_test(&s->s_active)) {
+	if (refcount_dec_and_test(&s->s_active)) {
 		cleancache_invalidate_fs(s);
 		unregister_shrinker(&s->s_shrink);
 		fs->kill_sb(s);
@@ -335,7 +335,7 @@ EXPORT_SYMBOL(deactivate_locked_super);
  */
 void deactivate_super(struct super_block *s)
 {
-        if (!atomic_add_unless(&s->s_active, -1, 1)) {
+	if (!refcount_dec_not_one(&s->s_active)) {
 		down_write(&s->s_umount);
 		deactivate_locked_super(s);
 	}
@@ -361,7 +361,7 @@ static int grab_super(struct super_block *s) __releases(sb_lock)
 	s->s_count++;
 	spin_unlock(&sb_lock);
 	down_write(&s->s_umount);
-	if ((s->s_flags & MS_BORN) && atomic_inc_not_zero(&s->s_active)) {
+	if ((s->s_flags & MS_BORN) && refcount_inc_not_zero(&s->s_active)) {
 		put_super(s);
 		return 1;
 	}
@@ -1378,7 +1378,7 @@ int freeze_super(struct super_block *sb)
 {
 	int ret;
 
-	atomic_inc(&sb->s_active);
+	refcount_inc(&sb->s_active);
 	down_write(&sb->s_umount);
 	if (sb->s_writers.frozen != SB_UNFROZEN) {
 		deactivate_locked_super(sb);
diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index a866d9a..2c14206 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -26,6 +26,7 @@
 #include <linux/mempolicy.h>
 #include <linux/ioctl.h>
 #include <linux/security.h>
+#include <linux/refcount.h>
 
 static struct kmem_cache *userfaultfd_ctx_cachep __read_mostly;
 
@@ -48,7 +49,7 @@ struct userfaultfd_ctx {
 	/* a refile sequence protected by fault_pending_wqh lock */
 	struct seqcount refile_seq;
 	/* pseudo fd refcounting */
-	atomic_t refcount;
+	refcount_t refcount;
 	/* userfaultfd syscall flags */
 	unsigned int flags;
 	/* state machine */
@@ -116,7 +117,7 @@ static int userfaultfd_wake_function(wait_queue_t *wq, unsigned mode,
  */
 static void userfaultfd_ctx_get(struct userfaultfd_ctx *ctx)
 {
-	if (!atomic_inc_not_zero(&ctx->refcount))
+	if (!refcount_inc_not_zero(&ctx->refcount))
 		BUG();
 }
 
@@ -130,7 +131,7 @@ static void userfaultfd_ctx_get(struct userfaultfd_ctx *ctx)
  */
 static void userfaultfd_ctx_put(struct userfaultfd_ctx *ctx)
 {
-	if (atomic_dec_and_test(&ctx->refcount)) {
+	if (refcount_dec_and_test(&ctx->refcount)) {
 		VM_BUG_ON(spin_is_locked(&ctx->fault_pending_wqh.lock));
 		VM_BUG_ON(waitqueue_active(&ctx->fault_pending_wqh));
 		VM_BUG_ON(spin_is_locked(&ctx->fault_wqh.lock));
@@ -1300,7 +1301,7 @@ static struct file *userfaultfd_file_create(int flags)
 	if (!ctx)
 		goto out;
 
-	atomic_set(&ctx->refcount, 1);
+	refcount_set(&ctx->refcount, 1);
 	ctx->flags = flags;
 	ctx->state = UFFD_STATE_WAIT_API;
 	ctx->released = false;
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 9bf57c7..33104ad 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -199,7 +199,7 @@ xfs_bui_init(
 	buip->bui_format.bui_nextents = XFS_BUI_MAX_FAST_EXTENTS;
 	buip->bui_format.bui_id = (uintptr_t)(void *)buip;
 	atomic_set(&buip->bui_next_extent, 0);
-	atomic_set(&buip->bui_refcount, 2);
+	refcount_set(&buip->bui_refcount, 2);
 
 	return buip;
 }
@@ -215,7 +215,7 @@ void
 xfs_bui_release(
 	struct xfs_bui_log_item	*buip)
 {
-	if (atomic_dec_and_test(&buip->bui_refcount)) {
+	if (refcount_dec_and_test(&buip->bui_refcount)) {
 		xfs_trans_ail_remove(&buip->bui_item, SHUTDOWN_LOG_IO_ERROR);
 		xfs_bui_item_free(buip);
 	}
diff --git a/fs/xfs/xfs_bmap_item.h b/fs/xfs/xfs_bmap_item.h
index c867daa..988a6ae 100644
--- a/fs/xfs/xfs_bmap_item.h
+++ b/fs/xfs/xfs_bmap_item.h
@@ -20,6 +20,8 @@
 #ifndef	__XFS_BMAP_ITEM_H__
 #define	__XFS_BMAP_ITEM_H__
 
+#include <linux/refcount.h>
+
 /*
  * There are (currently) two pairs of bmap btree redo item types: map & unmap.
  * The common abbreviations for these are BUI (bmap update intent) and BUD
@@ -61,7 +63,7 @@ struct kmem_zone;
  */
 struct xfs_bui_log_item {
 	struct xfs_log_item		bui_item;
-	atomic_t			bui_refcount;
+	refcount_t			bui_refcount;
 	atomic_t			bui_next_extent;
 	unsigned long			bui_flags;	/* misc flags */
 	struct xfs_bui_log_format	bui_format;
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 7f0a01f..7f13c4b 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -151,12 +151,12 @@ xfs_buf_stale(
 	xfs_buf_ioacct_dec(bp);
 
 	spin_lock(&bp->b_lock);
-	atomic_set(&bp->b_lru_ref, 0);
+	refcount_set(&bp->b_lru_ref, 0);
 	if (!(bp->b_state & XFS_BSTATE_DISPOSE) &&
 	    (list_lru_del(&bp->b_target->bt_lru, &bp->b_lru)))
-		atomic_dec(&bp->b_hold);
+		refcount_dec(&bp->b_hold);
 
-	ASSERT(atomic_read(&bp->b_hold) >= 1);
+	ASSERT(refcount_read(&bp->b_hold) >= 1);
 	spin_unlock(&bp->b_lock);
 }
 
@@ -214,8 +214,8 @@ _xfs_buf_alloc(
 	 */
 	flags &= ~(XBF_UNMAPPED | XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD);
 
-	atomic_set(&bp->b_hold, 1);
-	atomic_set(&bp->b_lru_ref, 1);
+	refcount_set(&bp->b_hold, 1);
+	refcount_set(&bp->b_lru_ref, 1);
 	init_completion(&bp->b_iowait);
 	INIT_LIST_HEAD(&bp->b_lru);
 	INIT_LIST_HEAD(&bp->b_list);
@@ -580,7 +580,7 @@ _xfs_buf_find(
 	bp = rhashtable_lookup_fast(&pag->pag_buf_hash, &cmap,
 				    xfs_buf_hash_params);
 	if (bp) {
-		atomic_inc(&bp->b_hold);
+		refcount_inc(&bp->b_hold);
 		goto found;
 	}
 
@@ -939,7 +939,7 @@ xfs_buf_hold(
 	xfs_buf_t		*bp)
 {
 	trace_xfs_buf_hold(bp, _RET_IP_);
-	atomic_inc(&bp->b_hold);
+	refcount_inc(&bp->b_hold);
 }
 
 /*
@@ -958,16 +958,16 @@ xfs_buf_rele(
 
 	if (!pag) {
 		ASSERT(list_empty(&bp->b_lru));
-		if (atomic_dec_and_test(&bp->b_hold)) {
+		if (refcount_dec_and_test(&bp->b_hold)) {
 			xfs_buf_ioacct_dec(bp);
 			xfs_buf_free(bp);
 		}
 		return;
 	}
 
-	ASSERT(atomic_read(&bp->b_hold) > 0);
+	ASSERT(refcount_read(&bp->b_hold) > 0);
 
-	release = atomic_dec_and_lock(&bp->b_hold, &pag->pag_buf_lock);
+	release = refcount_dec_and_lock(&bp->b_hold, &pag->pag_buf_lock);
 	spin_lock(&bp->b_lock);
 	if (!release) {
 		/*
@@ -976,14 +976,14 @@ xfs_buf_rele(
 		 * haven't acquired the pag lock, but the use of _XBF_IN_FLIGHT
 		 * ensures the decrement occurs only once per-buf.
 		 */
-		if ((atomic_read(&bp->b_hold) == 1) && !list_empty(&bp->b_lru))
+		if ((refcount_read(&bp->b_hold) == 1) && !list_empty(&bp->b_lru))
 			xfs_buf_ioacct_dec(bp);
 		goto out_unlock;
 	}
 
 	/* the last reference has been dropped ... */
 	xfs_buf_ioacct_dec(bp);
-	if (!(bp->b_flags & XBF_STALE) && atomic_read(&bp->b_lru_ref)) {
+	if (!(bp->b_flags & XBF_STALE) && refcount_read(&bp->b_lru_ref)) {
 		/*
 		 * If the buffer is added to the LRU take a new reference to the
 		 * buffer for the LRU and clear the (now stale) dispose list
@@ -991,7 +991,7 @@ xfs_buf_rele(
 		 */
 		if (list_lru_add(&bp->b_target->bt_lru, &bp->b_lru)) {
 			bp->b_state &= ~XFS_BSTATE_DISPOSE;
-			atomic_inc(&bp->b_hold);
+			refcount_inc(&bp->b_hold);
 		}
 		spin_unlock(&pag->pag_buf_lock);
 	} else {
@@ -1597,7 +1597,7 @@ xfs_buftarg_wait_rele(
 	struct xfs_buf		*bp = container_of(item, struct xfs_buf, b_lru);
 	struct list_head	*dispose = arg;
 
-	if (atomic_read(&bp->b_hold) > 1) {
+	if (refcount_read(&bp->b_hold) > 1) {
 		/* need to wait, so skip it this pass */
 		trace_xfs_buf_wait_buftarg(bp, _RET_IP_);
 		return LRU_SKIP;
@@ -1609,7 +1609,7 @@ xfs_buftarg_wait_rele(
 	 * clear the LRU reference count so the buffer doesn't get
 	 * ignored in xfs_buf_rele().
 	 */
-	atomic_set(&bp->b_lru_ref, 0);
+	refcount_set(&bp->b_lru_ref, 0);
 	bp->b_state |= XFS_BSTATE_DISPOSE;
 	list_lru_isolate_move(lru, item, dispose);
 	spin_unlock(&bp->b_lock);
@@ -1683,7 +1683,7 @@ xfs_buftarg_isolate(
 	 * zero. If the value is already zero, we need to reclaim the
 	 * buffer, otherwise it gets another trip through the LRU.
 	 */
-	if (!atomic_add_unless(&bp->b_lru_ref, -1, 0)) {
+	if (!refcount_dec_and_test(&bp->b_lru_ref)) {
 		spin_unlock(&bp->b_lock);
 		return LRU_ROTATE;
 	}
@@ -1854,7 +1854,7 @@ xfs_buf_delwri_queue(
 	 */
 	bp->b_flags |= _XBF_DELWRI_Q;
 	if (list_empty(&bp->b_list)) {
-		atomic_inc(&bp->b_hold);
+		refcount_inc(&bp->b_hold);
 		list_add_tail(&bp->b_list, list);
 	}
 
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 8a9d3a9..76acf28 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -27,6 +27,7 @@
 #include <linux/buffer_head.h>
 #include <linux/uio.h>
 #include <linux/list_lru.h>
+#include <linux/refcount.h>
 
 /*
  *	Base types
@@ -154,8 +155,8 @@ typedef struct xfs_buf {
 	struct rhash_head	b_rhash_head;	/* pag buffer hash node */
 	xfs_daddr_t		b_bn;		/* block number of buffer */
 	int			b_length;	/* size of buffer in BBs */
-	atomic_t		b_hold;		/* reference count */
-	atomic_t		b_lru_ref;	/* lru reclaim ref count */
+	refcount_t		b_hold;		/* reference count */
+	refcount_t		b_lru_ref;	/* lru reclaim ref count */
 	xfs_buf_flags_t		b_flags;	/* status flags */
 	struct semaphore	b_sema;		/* semaphore for lockables */
 
@@ -354,7 +355,7 @@ extern void xfs_buf_terminate(void);
 
 static inline void xfs_buf_set_ref(struct xfs_buf *bp, int lru_ref)
 {
-	atomic_set(&bp->b_lru_ref, lru_ref);
+	refcount_set(&bp->b_lru_ref, lru_ref);
 }
 
 static inline int xfs_buf_ispinned(struct xfs_buf *bp)
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 2975cb2..7de4b72 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -137,7 +137,7 @@ xfs_buf_item_size(
 	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
 	int			i;
 
-	ASSERT(atomic_read(&bip->bli_refcount) > 0);
+	ASSERT(refcount_read(&bip->bli_refcount) > 0);
 	if (bip->bli_flags & XFS_BLI_STALE) {
 		/*
 		 * The buffer is stale, so all we need to log
@@ -316,7 +316,7 @@ xfs_buf_item_format(
 	uint			offset = 0;
 	int			i;
 
-	ASSERT(atomic_read(&bip->bli_refcount) > 0);
+	ASSERT(refcount_read(&bip->bli_refcount) > 0);
 	ASSERT((bip->bli_flags & XFS_BLI_LOGGED) ||
 	       (bip->bli_flags & XFS_BLI_STALE));
 	ASSERT((bip->bli_flags & XFS_BLI_STALE) ||
@@ -383,14 +383,14 @@ xfs_buf_item_pin(
 {
 	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
 
-	ASSERT(atomic_read(&bip->bli_refcount) > 0);
+	ASSERT(refcount_read(&bip->bli_refcount) > 0);
 	ASSERT((bip->bli_flags & XFS_BLI_LOGGED) ||
 	       (bip->bli_flags & XFS_BLI_ORDERED) ||
 	       (bip->bli_flags & XFS_BLI_STALE));
 
 	trace_xfs_buf_item_pin(bip);
 
-	atomic_inc(&bip->bli_refcount);
+	refcount_inc(&bip->bli_refcount);
 	atomic_inc(&bip->bli_buf->b_pin_count);
 }
 
@@ -419,11 +419,11 @@ xfs_buf_item_unpin(
 	int		freed;
 
 	ASSERT(bp->b_fspriv == bip);
-	ASSERT(atomic_read(&bip->bli_refcount) > 0);
+	ASSERT(refcount_read(&bip->bli_refcount) > 0);
 
 	trace_xfs_buf_item_unpin(bip);
 
-	freed = atomic_dec_and_test(&bip->bli_refcount);
+	freed = refcount_dec_and_test(&bip->bli_refcount);
 
 	if (atomic_dec_and_test(&bp->b_pin_count))
 		wake_up_all(&bp->b_waiters);
@@ -605,7 +605,7 @@ xfs_buf_item_unlock(
 		trace_xfs_buf_item_unlock_stale(bip);
 		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
 		if (!aborted) {
-			atomic_dec(&bip->bli_refcount);
+			refcount_dec(&bip->bli_refcount);
 			return;
 		}
 	}
@@ -642,7 +642,7 @@ xfs_buf_item_unlock(
 	 * it in this case, because an aborted transaction has already shut the
 	 * filesystem down and this is the last chance we will have to do so.
 	 */
-	if (atomic_dec_and_test(&bip->bli_refcount)) {
+	if (refcount_dec_and_test(&bip->bli_refcount)) {
 		if (clean)
 			xfs_buf_item_relse(bp);
 		else if (aborted) {
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index f7eba99..7bbdef7 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -18,6 +18,8 @@
 #ifndef	__XFS_BUF_ITEM_H__
 #define	__XFS_BUF_ITEM_H__
 
+#include <linux/refcount.h>
+
 /* kernel only definitions */
 
 /* buf log item flags */
@@ -55,7 +57,7 @@ typedef struct xfs_buf_log_item {
 	struct xfs_buf		*bli_buf;	/* real buffer pointer */
 	unsigned int		bli_flags;	/* misc flags */
 	unsigned int		bli_recur;	/* lock recursion count */
-	atomic_t		bli_refcount;	/* cnt of tp refs */
+	refcount_t		bli_refcount;	/* cnt of tp refs */
 	int			bli_format_count;	/* count of headers */
 	struct xfs_buf_log_format *bli_formats;	/* array of in-log header ptrs */
 	struct xfs_buf_log_format __bli_format;	/* embedded in-log header */
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index d7bc149..4e0acf0 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -220,7 +220,7 @@ xfs_efi_init(
 	efip->efi_format.efi_nextents = nextents;
 	efip->efi_format.efi_id = (uintptr_t)(void *)efip;
 	atomic_set(&efip->efi_next_extent, 0);
-	atomic_set(&efip->efi_refcount, 2);
+	refcount_set(&efip->efi_refcount, 2);
 
 	return efip;
 }
@@ -290,7 +290,7 @@ void
 xfs_efi_release(
 	struct xfs_efi_log_item	*efip)
 {
-	if (atomic_dec_and_test(&efip->efi_refcount)) {
+	if (refcount_dec_and_test(&efip->efi_refcount)) {
 		xfs_trans_ail_remove(&efip->efi_item, SHUTDOWN_LOG_IO_ERROR);
 		xfs_efi_item_free(efip);
 	}
diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index a32c794..e6da63d 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -18,6 +18,8 @@
 #ifndef	__XFS_EXTFREE_ITEM_H__
 #define	__XFS_EXTFREE_ITEM_H__
 
+#include <linux/refcount.h>
+
 /* kernel only EFI/EFD definitions */
 
 struct xfs_mount;
@@ -64,7 +66,7 @@ struct kmem_zone;
  */
 typedef struct xfs_efi_log_item {
 	xfs_log_item_t		efi_item;
-	atomic_t		efi_refcount;
+	refcount_t		efi_refcount;
 	atomic_t		efi_next_extent;
 	unsigned long		efi_flags;	/* misc flags */
 	xfs_efi_log_format_t	efi_format;
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 10dcf27..75d7ca6 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -475,7 +475,7 @@ static inline void xfs_setup_existing_inode(struct xfs_inode *ip)
 
 #define IHOLD(ip) \
 do { \
-	ASSERT(atomic_read(&VFS_I(ip)->i_count) > 0) ; \
+	ASSERT(refcount_read(&VFS_I(ip)->i_count) > 0) ; \
 	ihold(VFS_I(ip)); \
 	trace_xfs_ihold(ip, _THIS_IP_); \
 } while (0)
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index c39ac14..1215a45 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -859,7 +859,7 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 
 		spin_lock(&log->l_icloglock);
 		iclog = log->l_iclog;
-		atomic_inc(&iclog->ic_refcnt);
+		refcount_inc(&iclog->ic_refcnt);
 		xlog_state_want_sync(log, iclog);
 		spin_unlock(&log->l_icloglock);
 		error = xlog_state_release_iclog(log, iclog);
@@ -897,7 +897,7 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 		 */
 		spin_lock(&log->l_icloglock);
 		iclog = log->l_iclog;
-		atomic_inc(&iclog->ic_refcnt);
+		refcount_inc(&iclog->ic_refcnt);
 
 		xlog_state_want_sync(log, iclog);
 		spin_unlock(&log->l_icloglock);
@@ -1483,7 +1483,7 @@ xlog_alloc_log(
 		iclog->ic_size = BBTOB(bp->b_length) - log->l_iclog_hsize;
 		iclog->ic_state = XLOG_STATE_ACTIVE;
 		iclog->ic_log = log;
-		atomic_set(&iclog->ic_refcnt, 0);
+		refcount_set(&iclog->ic_refcnt, 0);
 		spin_lock_init(&iclog->ic_callback_lock);
 		iclog->ic_callback_tail = &(iclog->ic_callback);
 		iclog->ic_datap = (char *)iclog->ic_data + log->l_iclog_hsize;
@@ -1773,7 +1773,7 @@ xlog_sync(
 	int		size;
 
 	XFS_STATS_INC(log->l_mp, xs_log_writes);
-	ASSERT(atomic_read(&iclog->ic_refcnt) == 0);
+	ASSERT(refcount_read(&iclog->ic_refcnt) == 0);
 
 	/* Add for LR header */
 	count_init = log->l_iclog_hsize + iclog->ic_offset;
@@ -2826,7 +2826,7 @@ xlog_state_done_syncing(
 
 	ASSERT(iclog->ic_state == XLOG_STATE_SYNCING ||
 	       iclog->ic_state == XLOG_STATE_IOERROR);
-	ASSERT(atomic_read(&iclog->ic_refcnt) == 0);
+	ASSERT(refcount_read(&iclog->ic_refcnt) == 0);
 	ASSERT(iclog->ic_bwritecnt == 1 || iclog->ic_bwritecnt == 2);
 
 
@@ -2905,7 +2905,7 @@ xlog_state_get_iclog_space(
 
 	head = &iclog->ic_header;
 
-	atomic_inc(&iclog->ic_refcnt);	/* prevents sync */
+	refcount_inc(&iclog->ic_refcnt);	/* prevents sync */
 	log_offset = iclog->ic_offset;
 
 	/* On the 1st write to an iclog, figure out lsn.  This works
@@ -2943,7 +2943,8 @@ xlog_state_get_iclog_space(
 		 * xlog_state_release_iclog() when there is more than one
 		 * reference to the iclog.
 		 */
-		if (!atomic_add_unless(&iclog->ic_refcnt, -1, 1)) {
+
+		if (!refcount_dec_not_one(&iclog->ic_refcnt)) {
 			/* we are the only one */
 			spin_unlock(&log->l_icloglock);
 			error = xlog_state_release_iclog(log, iclog);
@@ -3081,8 +3082,8 @@ xlog_state_release_iclog(
 	if (iclog->ic_state & XLOG_STATE_IOERROR)
 		return -EIO;
 
-	ASSERT(atomic_read(&iclog->ic_refcnt) > 0);
-	if (!atomic_dec_and_lock(&iclog->ic_refcnt, &log->l_icloglock))
+	ASSERT(refcount_read(&iclog->ic_refcnt) > 0);
+	if (!refcount_dec_and_lock(&iclog->ic_refcnt, &log->l_icloglock))
 		return 0;
 
 	if (iclog->ic_state & XLOG_STATE_IOERROR) {
@@ -3228,7 +3229,7 @@ _xfs_log_force(
 		 * previous iclog and go to sleep.
 		 */
 		if (iclog->ic_state == XLOG_STATE_DIRTY ||
-		    (atomic_read(&iclog->ic_refcnt) == 0
+		    (refcount_read(&iclog->ic_refcnt) == 0
 		     && iclog->ic_offset == 0)) {
 			iclog = iclog->ic_prev;
 			if (iclog->ic_state == XLOG_STATE_ACTIVE ||
@@ -3237,14 +3238,14 @@ _xfs_log_force(
 			else
 				goto maybe_sleep;
 		} else {
-			if (atomic_read(&iclog->ic_refcnt) == 0) {
+			if (refcount_read(&iclog->ic_refcnt) == 0) {
 				/* We are the only one with access to this
 				 * iclog.  Flush it out now.  There should
 				 * be a roundoff of zero to show that someone
 				 * has already taken care of the roundoff from
 				 * the previous sync.
 				 */
-				atomic_inc(&iclog->ic_refcnt);
+				refcount_inc(&iclog->ic_refcnt);
 				lsn = be64_to_cpu(iclog->ic_header.h_lsn);
 				xlog_state_switch_iclogs(log, iclog, 0);
 				spin_unlock(&log->l_icloglock);
@@ -3411,7 +3412,7 @@ _xfs_log_force_lsn(
 				already_slept = 1;
 				goto try_again;
 			}
-			atomic_inc(&iclog->ic_refcnt);
+			refcount_inc(&iclog->ic_refcnt);
 			xlog_state_switch_iclogs(log, iclog, 0);
 			spin_unlock(&log->l_icloglock);
 			if (xlog_state_release_iclog(log, iclog))
@@ -3508,8 +3509,8 @@ void
 xfs_log_ticket_put(
 	xlog_ticket_t	*ticket)
 {
-	ASSERT(atomic_read(&ticket->t_ref) > 0);
-	if (atomic_dec_and_test(&ticket->t_ref))
+	ASSERT(refcount_read(&ticket->t_ref) > 0);
+	if (refcount_dec_and_test(&ticket->t_ref))
 		kmem_zone_free(xfs_log_ticket_zone, ticket);
 }
 
@@ -3517,8 +3518,8 @@ xlog_ticket_t *
 xfs_log_ticket_get(
 	xlog_ticket_t	*ticket)
 {
-	ASSERT(atomic_read(&ticket->t_ref) > 0);
-	atomic_inc(&ticket->t_ref);
+	ASSERT(refcount_read(&ticket->t_ref) > 0);
+	refcount_inc(&ticket->t_ref);
 	return ticket;
 }
 
@@ -3640,7 +3641,7 @@ xlog_ticket_alloc(
 
 	unit_res = xfs_log_calc_unit_res(log->l_mp, unit_bytes);
 
-	atomic_set(&tic->t_ref, 1);
+	refcount_set(&tic->t_ref, 1);
 	tic->t_task		= current;
 	INIT_LIST_HEAD(&tic->t_queue);
 	tic->t_unit_res		= unit_res;
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 2b6eec5..c94444c 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -18,6 +18,8 @@
 #ifndef	__XFS_LOG_PRIV_H__
 #define __XFS_LOG_PRIV_H__
 
+#include <linux/refcount.h>
+
 struct xfs_buf;
 struct xlog;
 struct xlog_ticket;
@@ -168,7 +170,7 @@ typedef struct xlog_ticket {
 	struct list_head   t_queue;	 /* reserve/write queue */
 	struct task_struct *t_task;	 /* task that owns this ticket */
 	xlog_tid_t	   t_tid;	 /* transaction identifier	 : 4  */
-	atomic_t	   t_ref;	 /* ticket reference count       : 4  */
+	refcount_t	   t_ref;	 /* ticket reference count       : 4  */
 	int		   t_curr_res;	 /* current reservation in bytes : 4  */
 	int		   t_unit_res;	 /* unit reservation in bytes    : 4  */
 	char		   t_ocnt;	 /* original count		 : 1  */
@@ -232,7 +234,7 @@ typedef struct xlog_in_core {
 	struct xfs_log_callback	**ic_callback_tail;
 
 	/* reference counts need their own cacheline */
-	atomic_t		ic_refcnt ____cacheline_aligned_in_smp;
+	refcount_t		ic_refcnt ____cacheline_aligned_in_smp;
 	xlog_in_core_2_t	*ic_data;
 #define ic_header	ic_data->hic_header
 } xlog_in_core_t;
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index fe86a66..3bd4866 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -205,7 +205,7 @@ xfs_cui_init(
 	cuip->cui_format.cui_nextents = nextents;
 	cuip->cui_format.cui_id = (uintptr_t)(void *)cuip;
 	atomic_set(&cuip->cui_next_extent, 0);
-	atomic_set(&cuip->cui_refcount, 2);
+	refcount_set(&cuip->cui_refcount, 2);
 
 	return cuip;
 }
@@ -221,7 +221,7 @@ void
 xfs_cui_release(
 	struct xfs_cui_log_item	*cuip)
 {
-	if (atomic_dec_and_test(&cuip->cui_refcount)) {
+	if (refcount_dec_and_test(&cuip->cui_refcount)) {
 		xfs_trans_ail_remove(&cuip->cui_item, SHUTDOWN_LOG_IO_ERROR);
 		xfs_cui_item_free(cuip);
 	}
diff --git a/fs/xfs/xfs_refcount_item.h b/fs/xfs/xfs_refcount_item.h
index 5b74ddd..7f23ff8 100644
--- a/fs/xfs/xfs_refcount_item.h
+++ b/fs/xfs/xfs_refcount_item.h
@@ -20,6 +20,8 @@
 #ifndef	__XFS_REFCOUNT_ITEM_H__
 #define	__XFS_REFCOUNT_ITEM_H__
 
+#include <linux/refcount.h>
+
 /*
  * There are (currently) two pairs of refcount btree redo item types:
  * increase and decrease.  The log items for these are CUI (refcount
@@ -63,7 +65,7 @@ struct kmem_zone;
  */
 struct xfs_cui_log_item {
 	struct xfs_log_item		cui_item;
-	atomic_t			cui_refcount;
+	refcount_t			cui_refcount;
 	atomic_t			cui_next_extent;
 	unsigned long			cui_flags;	/* misc flags */
 	struct xfs_cui_log_format	cui_format;
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 73c8278..5e1664a 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -204,7 +204,7 @@ xfs_rui_init(
 	ruip->rui_format.rui_nextents = nextents;
 	ruip->rui_format.rui_id = (uintptr_t)(void *)ruip;
 	atomic_set(&ruip->rui_next_extent, 0);
-	atomic_set(&ruip->rui_refcount, 2);
+	refcount_set(&ruip->rui_refcount, 2);
 
 	return ruip;
 }
@@ -243,7 +243,7 @@ void
 xfs_rui_release(
 	struct xfs_rui_log_item	*ruip)
 {
-	if (atomic_dec_and_test(&ruip->rui_refcount)) {
+	if (refcount_dec_and_test(&ruip->rui_refcount)) {
 		xfs_trans_ail_remove(&ruip->rui_item, SHUTDOWN_LOG_IO_ERROR);
 		xfs_rui_item_free(ruip);
 	}
diff --git a/fs/xfs/xfs_rmap_item.h b/fs/xfs/xfs_rmap_item.h
index 340c968..2529a35 100644
--- a/fs/xfs/xfs_rmap_item.h
+++ b/fs/xfs/xfs_rmap_item.h
@@ -20,6 +20,8 @@
 #ifndef	__XFS_RMAP_ITEM_H__
 #define	__XFS_RMAP_ITEM_H__
 
+#include <linux/refcount.h>
+
 /*
  * There are (currently) three pairs of rmap btree redo item types: map, unmap,
  * and convert.  The common abbreviations for these are RUI (rmap update
@@ -64,7 +66,7 @@ struct kmem_zone;
  */
 struct xfs_rui_log_item {
 	struct xfs_log_item		rui_item;
-	atomic_t			rui_refcount;
+	refcount_t			rui_refcount;
 	atomic_t			rui_next_extent;
 	unsigned long			rui_flags;	/* misc flags */
 	struct xfs_rui_log_format	rui_format;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 69c5bcd..ba22888 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -326,7 +326,7 @@ DECLARE_EVENT_CLASS(xfs_buf_class,
 		__entry->dev = bp->b_target->bt_dev;
 		__entry->bno = bp->b_bn;
 		__entry->nblks = bp->b_length;
-		__entry->hold = atomic_read(&bp->b_hold);
+		__entry->hold = refcount_read(&bp->b_hold);
 		__entry->pincount = atomic_read(&bp->b_pin_count);
 		__entry->lockval = bp->b_sema.count;
 		__entry->flags = bp->b_flags;
@@ -395,7 +395,7 @@ DECLARE_EVENT_CLASS(xfs_buf_flags_class,
 		__entry->bno = bp->b_bn;
 		__entry->buffer_length = BBTOB(bp->b_length);
 		__entry->flags = flags;
-		__entry->hold = atomic_read(&bp->b_hold);
+		__entry->hold = refcount_read(&bp->b_hold);
 		__entry->pincount = atomic_read(&bp->b_pin_count);
 		__entry->lockval = bp->b_sema.count;
 		__entry->caller_ip = caller_ip;
@@ -438,7 +438,7 @@ TRACE_EVENT(xfs_buf_ioerror,
 		__entry->dev = bp->b_target->bt_dev;
 		__entry->bno = bp->b_bn;
 		__entry->buffer_length = BBTOB(bp->b_length);
-		__entry->hold = atomic_read(&bp->b_hold);
+		__entry->hold = refcount_read(&bp->b_hold);
 		__entry->pincount = atomic_read(&bp->b_pin_count);
 		__entry->lockval = bp->b_sema.count;
 		__entry->error = error;
@@ -479,11 +479,11 @@ DECLARE_EVENT_CLASS(xfs_buf_item_class,
 		__entry->dev = bip->bli_buf->b_target->bt_dev;
 		__entry->bli_flags = bip->bli_flags;
 		__entry->bli_recur = bip->bli_recur;
-		__entry->bli_refcount = atomic_read(&bip->bli_refcount);
+		__entry->bli_refcount = refcount_read(&bip->bli_refcount);
 		__entry->buf_bno = bip->bli_buf->b_bn;
 		__entry->buf_len = BBTOB(bip->bli_buf->b_length);
 		__entry->buf_flags = bip->bli_buf->b_flags;
-		__entry->buf_hold = atomic_read(&bip->bli_buf->b_hold);
+		__entry->buf_hold = refcount_read(&bip->bli_buf->b_hold);
 		__entry->buf_pincount = atomic_read(&bip->bli_buf->b_pin_count);
 		__entry->buf_lockval = bip->bli_buf->b_sema.count;
 		__entry->li_desc = bip->bli_item.li_desc;
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 8ee29ca..fa7f213 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -97,7 +97,7 @@ _xfs_trans_bjoin(
 	/*
 	 * Take a reference for this transaction on the buf item.
 	 */
-	atomic_inc(&bip->bli_refcount);
+	refcount_inc(&bip->bli_refcount);
 
 	/*
 	 * Get a log_item_desc to point at the new item.
@@ -161,7 +161,7 @@ xfs_trans_get_buf_map(
 		ASSERT(bp->b_transp == tp);
 		bip = bp->b_fspriv;
 		ASSERT(bip != NULL);
-		ASSERT(atomic_read(&bip->bli_refcount) > 0);
+		ASSERT(refcount_read(&bip->bli_refcount) > 0);
 		bip->bli_recur++;
 		trace_xfs_trans_get_buf_recur(bip);
 		return bp;
@@ -212,7 +212,7 @@ xfs_trans_getsb(xfs_trans_t	*tp,
 	if (bp->b_transp == tp) {
 		bip = bp->b_fspriv;
 		ASSERT(bip != NULL);
-		ASSERT(atomic_read(&bip->bli_refcount) > 0);
+		ASSERT(refcount_read(&bip->bli_refcount) > 0);
 		bip->bli_recur++;
 		trace_xfs_trans_getsb_recur(bip);
 		return bp;
@@ -282,7 +282,7 @@ xfs_trans_read_buf_map(
 		bip = bp->b_fspriv;
 		bip->bli_recur++;
 
-		ASSERT(atomic_read(&bip->bli_refcount) > 0);
+		ASSERT(refcount_read(&bip->bli_refcount) > 0);
 		trace_xfs_trans_read_buf_recur(bip);
 		*bpp = bp;
 		return 0;
@@ -371,7 +371,7 @@ xfs_trans_brelse(xfs_trans_t	*tp,
 	ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
 	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
 	ASSERT(!(bip->__bli_format.blf_flags & XFS_BLF_CANCEL));
-	ASSERT(atomic_read(&bip->bli_refcount) > 0);
+	ASSERT(refcount_read(&bip->bli_refcount) > 0);
 
 	trace_xfs_trans_brelse(bip);
 
@@ -419,7 +419,7 @@ xfs_trans_brelse(xfs_trans_t	*tp,
 	/*
 	 * Drop our reference to the buf log item.
 	 */
-	atomic_dec(&bip->bli_refcount);
+	refcount_dec(&bip->bli_refcount);
 
 	/*
 	 * If the buf item is not tracking data in the log, then
@@ -432,7 +432,7 @@ xfs_trans_brelse(xfs_trans_t	*tp,
 /***
 		ASSERT(bp->b_pincount == 0);
 ***/
-		ASSERT(atomic_read(&bip->bli_refcount) == 0);
+		ASSERT(refcount_read(&bip->bli_refcount) == 0);
 		ASSERT(!(bip->bli_item.li_flags & XFS_LI_IN_AIL));
 		ASSERT(!(bip->bli_flags & XFS_BLI_INODE_ALLOC_BUF));
 		xfs_buf_item_relse(bp);
@@ -458,7 +458,7 @@ xfs_trans_bhold(xfs_trans_t	*tp,
 	ASSERT(bip != NULL);
 	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
 	ASSERT(!(bip->__bli_format.blf_flags & XFS_BLF_CANCEL));
-	ASSERT(atomic_read(&bip->bli_refcount) > 0);
+	ASSERT(refcount_read(&bip->bli_refcount) > 0);
 
 	bip->bli_flags |= XFS_BLI_HOLD;
 	trace_xfs_trans_bhold(bip);
@@ -478,7 +478,7 @@ xfs_trans_bhold_release(xfs_trans_t	*tp,
 	ASSERT(bip != NULL);
 	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
 	ASSERT(!(bip->__bli_format.blf_flags & XFS_BLF_CANCEL));
-	ASSERT(atomic_read(&bip->bli_refcount) > 0);
+	ASSERT(refcount_read(&bip->bli_refcount) > 0);
 	ASSERT(bip->bli_flags & XFS_BLI_HOLD);
 
 	bip->bli_flags &= ~XFS_BLI_HOLD;
@@ -520,7 +520,7 @@ xfs_trans_log_buf(xfs_trans_t	*tp,
 	 */
 	bp->b_flags |= XBF_DONE;
 
-	ASSERT(atomic_read(&bip->bli_refcount) > 0);
+	ASSERT(refcount_read(&bip->bli_refcount) > 0);
 	bp->b_iodone = xfs_buf_iodone_callbacks;
 	bip->bli_item.li_cb = xfs_buf_iodone;
 
@@ -591,7 +591,7 @@ xfs_trans_binval(
 
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
-	ASSERT(atomic_read(&bip->bli_refcount) > 0);
+	ASSERT(refcount_read(&bip->bli_refcount) > 0);
 
 	trace_xfs_trans_binval(bip);
 
@@ -645,7 +645,7 @@ xfs_trans_inode_buf(
 
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
-	ASSERT(atomic_read(&bip->bli_refcount) > 0);
+	ASSERT(refcount_read(&bip->bli_refcount) > 0);
 
 	bip->bli_flags |= XFS_BLI_INODE_BUF;
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
@@ -669,7 +669,7 @@ xfs_trans_stale_inode_buf(
 
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
-	ASSERT(atomic_read(&bip->bli_refcount) > 0);
+	ASSERT(refcount_read(&bip->bli_refcount) > 0);
 
 	bip->bli_flags |= XFS_BLI_STALE_INODE;
 	bip->bli_item.li_cb = xfs_buf_iodone;
@@ -694,7 +694,7 @@ xfs_trans_inode_alloc_buf(
 
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
-	ASSERT(atomic_read(&bip->bli_refcount) > 0);
+	ASSERT(refcount_read(&bip->bli_refcount) > 0);
 
 	bip->bli_flags |= XFS_BLI_INODE_ALLOC_BUF;
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
@@ -717,7 +717,7 @@ xfs_trans_ordered_buf(
 
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
-	ASSERT(atomic_read(&bip->bli_refcount) > 0);
+	ASSERT(refcount_read(&bip->bli_refcount) > 0);
 
 	bip->bli_flags |= XFS_BLI_ORDERED;
 	trace_xfs_buf_item_ordered(bip);
@@ -740,7 +740,7 @@ xfs_trans_buf_set_type(
 
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
-	ASSERT(atomic_read(&bip->bli_refcount) > 0);
+	ASSERT(refcount_read(&bip->bli_refcount) > 0);
 
 	xfs_blft_to_flags(&bip->__bli_format, type);
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2ba0743..8b81c1e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -31,6 +31,7 @@
 #include <linux/workqueue.h>
 #include <linux/percpu-rwsem.h>
 #include <linux/delayed_call.h>
+#include <linux/refcount.h>
 
 #include <asm/byteorder.h>
 #include <uapi/linux/fs.h>
@@ -1301,7 +1302,7 @@ struct super_block {
 	struct dentry		*s_root;
 	struct rw_semaphore	s_umount;
 	int			s_count;
-	atomic_t		s_active;
+	refcount_t		s_active;
 #ifdef CONFIG_SECURITY
 	void                    *s_security;
 #endif
diff --git a/include/linux/fscache-cache.h b/include/linux/fscache-cache.h
index 13ba552..c0d4188 100644
--- a/include/linux/fscache-cache.h
+++ b/include/linux/fscache-cache.h
@@ -21,6 +21,7 @@
 #include <linux/fscache.h>
 #include <linux/sched.h>
 #include <linux/workqueue.h>
+#include <linux/refcount.h>
 
 #define NR_MAXCACHES BITS_PER_LONG
 
@@ -37,7 +38,7 @@ struct fscache_cache_tag {
 	struct fscache_cache	*cache;		/* cache referred to by this tag */
 	unsigned long		flags;
 #define FSCACHE_TAG_RESERVED	0		/* T if tag is reserved for a cache */
-	atomic_t		usage;
+	refcount_t		usage;
 	char			name[0];	/* tag name */
 };
 
@@ -102,7 +103,7 @@ struct fscache_operation {
 #define FSCACHE_OP_KEEP_FLAGS	0x00f0	/* flags to keep when repurposing an op */
 
 	enum fscache_operation_state state;
-	atomic_t		usage;
+	refcount_t		usage;
 	unsigned		debug_id;	/* debugging ID */
 
 	/* operation processor callback
@@ -160,7 +161,7 @@ typedef int (*fscache_pages_retrieval_func_t)(struct fscache_retrieval *op,
 static inline
 struct fscache_retrieval *fscache_get_retrieval(struct fscache_retrieval *op)
 {
-	atomic_inc(&op->op.usage);
+	refcount_inc(&op->op.usage);
 	return op;
 }
 
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 0cf34d6..c9014a7 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -16,6 +16,7 @@
 #include <linux/spinlock.h>
 #include <linux/types.h>
 #include <linux/atomic.h>
+#include <linux/refcount.h>
 
 /*
  * IN_* from inotfy.h lines up EXACTLY with FS_*, this is so we can easily
@@ -130,7 +131,7 @@ struct fsnotify_group {
 	 * inotify_init() and the refcnt will hit 0 only when that fd has been
 	 * closed.
 	 */
-	atomic_t refcnt;		/* things with interest in this group */
+	refcount_t refcnt;		/* things with interest in this group */
 
 	const struct fsnotify_ops *ops;	/* how this group handles things */
 
@@ -212,7 +213,7 @@ struct fsnotify_mark {
 	__u32 mask;
 	/* We hold one for presence in g_list. Also one ref for each 'thing'
 	 * in kernel that found and may be using this mark. */
-	atomic_t refcnt;
+	refcount_t refcnt;
 	/* Group this mark is for. Set on mark creation, stable until last ref
 	 * is dropped */
 	struct fsnotify_group *group;
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 7056238..58997b8 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -15,6 +15,7 @@
 #include <linux/lockdep.h>
 #include <linux/rbtree.h>
 #include <linux/atomic.h>
+#include <linux/refcount.h>
 #include <linux/wait.h>
 
 struct file;
@@ -104,7 +105,7 @@ struct kernfs_elem_attr {
  * active reference.
  */
 struct kernfs_node {
-	atomic_t		count;
+	refcount_t		count;
 	atomic_t		active;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
diff --git a/include/linux/lockd/lockd.h b/include/linux/lockd/lockd.h
index c153738..850240f 100644
--- a/include/linux/lockd/lockd.h
+++ b/include/linux/lockd/lockd.h
@@ -16,6 +16,7 @@
 #include <net/ipv6.h>
 #include <linux/fs.h>
 #include <linux/kref.h>
+#include <linux/refcount.h>
 #include <linux/utsname.h>
 #include <linux/lockd/bind.h>
 #include <linux/lockd/xdr.h>
@@ -57,7 +58,7 @@ struct nlm_host {
 	u32			h_state;	/* pseudo-state counter */
 	u32			h_nsmstate;	/* true remote NSM state */
 	u32			h_pidcount;	/* Pseudopids */
-	atomic_t		h_count;	/* reference count */
+	refcount_t		h_count;	/* reference count */
 	struct mutex		h_mutex;	/* mutex for pmap binding */
 	unsigned long		h_nextrebind;	/* next portmap call */
 	unsigned long		h_expires;	/* eligible for GC */
@@ -81,7 +82,7 @@ struct nlm_host {
 
 struct nsm_handle {
 	struct list_head	sm_link;
-	atomic_t		sm_count;
+	refcount_t		sm_count;
 	char			*sm_mon_name;
 	char			*sm_name;
 	struct sockaddr_storage	sm_addr;
@@ -120,7 +121,7 @@ static inline struct sockaddr *nlm_srcaddr(const struct nlm_host *host)
  */
 struct nlm_lockowner {
 	struct list_head list;
-	atomic_t count;
+	refcount_t count;
 
 	struct nlm_host *host;
 	fl_owner_t owner;
@@ -134,7 +135,7 @@ struct nlm_wait;
  */
 #define NLMCLNT_OHSIZE		((__NEW_UTS_LEN) + 10u)
 struct nlm_rqst {
-	atomic_t		a_count;
+	refcount_t		a_count;
 	unsigned int		a_flags;	/* initial RPC task flags */
 	struct nlm_host *	a_host;		/* host handle */
 	struct nlm_args		a_args;		/* arguments */
diff --git a/include/linux/mbcache.h b/include/linux/mbcache.h
index 86c9a8b..251e268 100644
--- a/include/linux/mbcache.h
+++ b/include/linux/mbcache.h
@@ -4,7 +4,7 @@
 #include <linux/hash.h>
 #include <linux/list_bl.h>
 #include <linux/list.h>
-#include <linux/atomic.h>
+#include <linux/refcount.h>
 #include <linux/fs.h>
 
 struct mb_cache;
@@ -14,7 +14,7 @@ struct mb_cache_entry {
 	struct list_head	e_list;
 	/* Hash table list - protected by hash chain bitlock */
 	struct hlist_bl_node	e_hash_list;
-	atomic_t		e_refcnt;
+	refcount_t		e_refcnt;
 	/* Key in hash - stable during lifetime of the entry */
 	u32			e_key;
 	u32			e_referenced:1;
@@ -32,7 +32,7 @@ void __mb_cache_entry_free(struct mb_cache_entry *entry);
 static inline int mb_cache_entry_put(struct mb_cache *cache,
 				     struct mb_cache_entry *entry)
 {
-	if (!atomic_dec_and_test(&entry->e_refcnt))
+	if (!refcount_dec_and_test(&entry->e_refcnt))
 		return 0;
 	__mb_cache_entry_free(entry);
 	return 1;
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index f1da8c8..0437374 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -22,6 +22,7 @@
 #include <linux/mm.h>
 #include <linux/pagemap.h>
 #include <linux/rbtree.h>
+#include <linux/refcount.h>
 #include <linux/rwsem.h>
 #include <linux/wait.h>
 
@@ -56,7 +57,7 @@ struct nfs_access_entry {
 };
 
 struct nfs_lock_context {
-	atomic_t count;
+	refcount_t count;
 	struct list_head list;
 	struct nfs_open_context *open_context;
 	fl_owner_t lockowner;
diff --git a/include/linux/nfs_fs_sb.h b/include/linux/nfs_fs_sb.h
index b34097c..116b140 100644
--- a/include/linux/nfs_fs_sb.h
+++ b/include/linux/nfs_fs_sb.h
@@ -9,6 +9,7 @@
 #include <linux/sunrpc/xprt.h>
 
 #include <linux/atomic.h>
+#include <linux/refcount.h>
 
 struct nfs4_session;
 struct nfs_iostats;
@@ -24,8 +25,8 @@ struct nfs41_impl_id;
  * The nfs_client identifies our client state to the server.
  */
 struct nfs_client {
-	atomic_t		cl_count;
-	atomic_t		cl_mds_count;
+	refcount_t		cl_count;
+	refcount_t		cl_mds_count;
 	int			cl_cons_state;	/* current construction state (-ve: init error) */
 #define NFS_CS_READY		0		/* ready to be used */
 #define NFS_CS_INITING		1		/* busy initialising */
diff --git a/include/linux/posix_acl.h b/include/linux/posix_acl.h
index 5a9a739..e3a4fc9 100644
--- a/include/linux/posix_acl.h
+++ b/include/linux/posix_acl.h
@@ -11,6 +11,7 @@
 #include <linux/bug.h>
 #include <linux/slab.h>
 #include <linux/rcupdate.h>
+#include <linux/refcount.h>
 #include <uapi/linux/posix_acl.h>
 
 struct posix_acl_entry {
@@ -23,7 +24,7 @@ struct posix_acl_entry {
 };
 
 struct posix_acl {
-	atomic_t		a_refcount;
+	refcount_t		a_refcount;
 	struct rcu_head		a_rcu;
 	unsigned int		a_count;
 	struct posix_acl_entry	a_entries[0];
@@ -40,7 +41,7 @@ static inline struct posix_acl *
 posix_acl_dup(struct posix_acl *acl)
 {
 	if (acl)
-		atomic_inc(&acl->a_refcount);
+		refcount_inc(&acl->a_refcount);
 	return acl;
 }
 
@@ -50,7 +51,7 @@ posix_acl_dup(struct posix_acl *acl)
 static inline void
 posix_acl_release(struct posix_acl *acl)
 {
-	if (acl && atomic_dec_and_test(&acl->a_refcount))
+	if (acl && refcount_dec_and_test(&acl->a_refcount))
 		kfree_rcu(acl, a_rcu);
 }
 
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index c14bed4..ce97ce7 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -210,7 +210,7 @@ TRACE_EVENT_CONDITION(btrfs_get_extent,
 		__entry->block_start	= map->block_start;
 		__entry->block_len	= map->block_len;
 		__entry->flags		= map->flags;
-		__entry->refs		= atomic_read(&map->refs);
+		__entry->refs		= refcount_read(&map->refs);
 		__entry->compress_type	= map->compress_type;
 	),
 
@@ -270,7 +270,7 @@ DECLARE_EVENT_CLASS(btrfs__ordered_extent,
 		__entry->bytes_left	= ordered->bytes_left;
 		__entry->flags		= ordered->flags;
 		__entry->compress_type	= ordered->compress_type;
-		__entry->refs		= atomic_read(&ordered->refs);
+		__entry->refs		= refcount_read(&ordered->refs);
 		__entry->root_objectid	=
 				BTRFS_I(inode)->root->root_key.objectid;
 	),
@@ -765,7 +765,7 @@ TRACE_EVENT(btrfs_cow_block,
 	TP_fast_assign_btrfs(root->fs_info,
 		__entry->root_objectid	= root->root_key.objectid;
 		__entry->buf_start	= buf->start;
-		__entry->refs		= atomic_read(&buf->refs);
+		__entry->refs		= refcount_read(&buf->refs);
 		__entry->cow_start	= cow->start;
 		__entry->buf_level	= btrfs_header_level(buf);
 		__entry->cow_level	= btrfs_header_level(cow);
diff --git a/ipc/msgutil.c b/ipc/msgutil.c
index bf74eaa..8459802 100644
--- a/ipc/msgutil.c
+++ b/ipc/msgutil.c
@@ -29,7 +29,7 @@ DEFINE_SPINLOCK(mq_lock);
  * and not CONFIG_IPC_NS.
  */
 struct ipc_namespace init_ipc_ns = {
-	.count		= ATOMIC_INIT(1),
+	.count		= REFCOUNT_INIT(1),
 	.user_ns = &init_user_ns,
 	.ns.inum = PROC_IPC_INIT_INO,
 #ifdef CONFIG_IPC_NS
-- 
2.7.4
