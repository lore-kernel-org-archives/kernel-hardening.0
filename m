Reply-To: kernel-hardening@lists.openwall.com
From: Elena Reshetova <elena.reshetova@intel.com>
Date: Thu, 29 Dec 2016 08:55:59 +0200
Message-Id: <1482994571-18687-8-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1482994571-18687-1-git-send-email-elena.reshetova@intel.com>
References: <1482994571-18687-1-git-send-email-elena.reshetova@intel.com>
Subject: [kernel-hardening] [RFC PATCH 07/19] mixed: kref fixes
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, peterz@infradead.org, will.deacon@arm.com, dwindsor@gmail.com, gregkh@linuxfoundation.org, ishkamiel@gmail.com, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

These are mixed fixes caused by the previous kref changes.
These should be merged with earlier changes, but sending them
separately for review.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 drivers/block/drbd/drbd_bitmap.c | 2 +-
 fs/fuse/fuse_i.h                 | 2 +-
 init/version.c                   | 2 +-
 kernel/pid.c                     | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index ab62b81..e8c40c7 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -1070,7 +1070,7 @@ static int bm_rw(struct drbd_device *device, const unsigned int flags, unsigned
 		.done = 0,
 		.flags = flags,
 		.error = 0,
-		.kref = { ATOMIC_INIT(2) },
+		.kref = { REFCOUNT_INIT(2) },
 	};
 
 	if (!get_ldev_if_state(device, D_ATTACHING)) {  /* put is in drbd_bm_aio_ctx_destroy() */
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 9130794..3ccf7f9 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -256,7 +256,7 @@ struct fuse_io_priv {
 
 #define FUSE_IO_PRIV_SYNC(f) \
 {					\
-	.refcnt = { ATOMIC_INIT(1) },	\
+	.refcnt = { REFCOUNT_INIT(1) },	\
 	.async = 0,			\
 	.file = f,			\
 }
diff --git a/init/version.c b/init/version.c
index fe41a63..8582729 100644
--- a/init/version.c
+++ b/init/version.c
@@ -24,7 +24,7 @@ int version_string(LINUX_VERSION_CODE);
 
 struct uts_namespace init_uts_ns = {
 	.kref = {
-		.refcount	= ATOMIC_INIT(2),
+		.refcount	= REFCOUNT_INIT(2),
 	},
 	.name = {
 		.sysname	= UTS_SYSNAME,
diff --git a/kernel/pid.c b/kernel/pid.c
index f66162f..528a362 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -69,7 +69,7 @@ static inline int mk_pid(struct pid_namespace *pid_ns,
  */
 struct pid_namespace init_pid_ns = {
 	.kref = {
-		.refcount       = ATOMIC_INIT(2),
+		.refcount       = REFCOUNT_INIT(2),
 	},
 	.pidmap = {
 		[ 0 ... PIDMAP_ENTRIES-1] = { ATOMIC_INIT(BITS_PER_PAGE), NULL }
-- 
2.7.4
