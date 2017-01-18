Reply-To: kernel-hardening@lists.openwall.com
From: Elena Reshetova <elena.reshetova@intel.com>
Date: Wed, 18 Jan 2017 11:11:30 +0200
Message-Id: <1484730707-29313-2-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1484730707-29313-1-git-send-email-elena.reshetova@intel.com>
References: <1484730707-29313-1-git-send-email-elena.reshetova@intel.com>
Subject: [kernel-hardening] [RFCv2 PATCH 01/18] kref: Add KREF_INIT()
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, peterz@infradead.org, will.deacon@arm.com, dwindsor@gmail.com, gregkh@linuxfoundation.org
List-ID: <kernel-hardening.lists.openwall.com>

From: Peter Zijlstra <peterz@infradead.org>

Since we need to change the implementation, stop exposing internals.

Provide KREF_INIT() to allow static initialization of struct kref.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/block/drbd/drbd_bitmap.c | 2 +-
 fs/fuse/fuse_i.h                 | 2 +-
 include/linux/kref.h             | 2 ++
 init/version.c                   | 4 +---
 kernel/pid.c                     | 4 +---
 5 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index ab62b81..dece26f 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -1070,7 +1070,7 @@ static int bm_rw(struct drbd_device *device, const unsigned int flags, unsigned
 		.done = 0,
 		.flags = flags,
 		.error = 0,
-		.kref = { ATOMIC_INIT(2) },
+		.kref = KREF_INIT(2),
 	};
 
 	if (!get_ldev_if_state(device, D_ATTACHING)) {  /* put is in drbd_bm_aio_ctx_destroy() */
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 9130794..052f8d3 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -256,7 +256,7 @@ struct fuse_io_priv {
 
 #define FUSE_IO_PRIV_SYNC(f) \
 {					\
-	.refcnt = { ATOMIC_INIT(1) },	\
+	.refcnt = KREF_INIT(1),		\
 	.async = 0,			\
 	.file = f,			\
 }
diff --git a/include/linux/kref.h b/include/linux/kref.h
index e15828f..9af255a 100644
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -24,6 +24,8 @@ struct kref {
 	atomic_t refcount;
 };
 
+#define KREF_INIT(n)	{ .refcount = ATOMIC_INIT(n), }
+
 /**
  * kref_init - initialize object.
  * @kref: object in question.
diff --git a/init/version.c b/init/version.c
index fe41a63..5606341 100644
--- a/init/version.c
+++ b/init/version.c
@@ -23,9 +23,7 @@ int version_string(LINUX_VERSION_CODE);
 #endif
 
 struct uts_namespace init_uts_ns = {
-	.kref = {
-		.refcount	= ATOMIC_INIT(2),
-	},
+	.kref = KREF_INIT(2),
 	.name = {
 		.sysname	= UTS_SYSNAME,
 		.nodename	= UTS_NODENAME,
diff --git a/kernel/pid.c b/kernel/pid.c
index f66162f..0291804 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -68,9 +68,7 @@ static inline int mk_pid(struct pid_namespace *pid_ns,
  * the scheme scales to up to 4 million PIDs, runtime.
  */
 struct pid_namespace init_pid_ns = {
-	.kref = {
-		.refcount       = ATOMIC_INIT(2),
-	},
+	.kref = KREF_INIT(2),
 	.pidmap = {
 		[ 0 ... PIDMAP_ENTRIES-1] = { ATOMIC_INIT(BITS_PER_PAGE), NULL }
 	},
-- 
2.7.4
