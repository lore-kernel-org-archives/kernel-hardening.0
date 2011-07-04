Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 4 Jul 2011 21:01:50 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110704170150.GA2806@albatros>
References: <201106292214.p5TMEtHg015372@imap1.linux-foundation.org>
 <20110630134855.GA6165@mail.hallyn.com>
 <20110630135718.GA13406@albatros>
 <20110703180028.GA26742@albatros>
 <20110704115523.GA11252@albatros>
 <20110704150513.GA6893@redhat.com>
 <20110704152636.GA21350@albatros>
 <20110704153757.GA9078@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110704153757.GA9078@redhat.com>
Subject: [kernel-hardening] [PATCH] shm: optimize locking and ipc_namespace getting
To: akpm@linux-foundation.org
Cc: Oleg Nesterov <oleg@redhat.com>, Serge Hallyn <serge.hallyn@canonical.com>, daniel.lezcano@free.fr, ebiederm@xmission.com, mingo@elte.hu, rdunlap@xenotime.net, tj@kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

shm_lock() does a lookup of shm segment in shm_ids(ns).ipcs_idr, which
is redundant as we already know shmid_kernel address.  An actual lock is
also not required for reads until we really want to destroy the segment.

exit_shm() and shm_destroy_orphaned() may avoid the loop by checking
whether there is at least one segment in current ipc_namespace.

The check of nsproxy and ipc_ns against NULL is redundant as exit_shm()
is called from do_exit() before the call to exit_notify(), so the
dereferencing current->nsproxy->ipc_ns is guaranteed to be safe.

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 ipc/shm.c |   67 +++++++++++++++++++++++++++++++------------------------------
 1 files changed, 34 insertions(+), 33 deletions(-)

---
diff --git a/ipc/shm.c b/ipc/shm.c
index 3baae98..aa91236 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -131,6 +131,12 @@ static inline struct shmid_kernel *shm_lock(struct ipc_namespace *ns, int id)
 	return container_of(ipcp, struct shmid_kernel, shm_perm);
 }
 
+static inline void shm_lock_by_ptr(struct shmid_kernel *ipcp)
+{
+	rcu_read_lock();
+	spin_lock(&ipcp->shm_perm.lock);
+}
+
 static inline struct shmid_kernel *shm_lock_check(struct ipc_namespace *ns,
 						int id)
 {
@@ -231,18 +237,16 @@ static void shm_close(struct vm_area_struct *vma)
 	up_write(&shm_ids(ns).rw_mutex);
 }
 
+/* Called with ns->shm_ids(ns).rw_mutex locked */
 static int shm_try_destroy_current(int id, void *p, void *data)
 {
 	struct ipc_namespace *ns = data;
-	struct shmid_kernel *shp = shm_lock(ns, id);
-
-	if (IS_ERR(shp))
-		return 0;
+	struct kern_ipc_perm *ipcp = p;
+	struct shmid_kernel *shp;
+	shp = container_of(ipcp, struct shmid_kernel, shm_perm);
 
-	if (shp->shm_creator != current) {
-		shm_unlock(shp);
+	if (shp->shm_creator != current)
 		return 0;
-	}
 
 	/*
 	 * Mark it as orphaned to destroy the segment when
@@ -255,64 +259,61 @@ static int shm_try_destroy_current(int id, void *p, void *data)
 	 * Don't even try to destroy it.  If shm_forced_rmid=0 and IPC_RMID
 	 * is not set, it shouldn't be deleted here.
 	 */
-	if (!ns->shm_forced_rmid) {
-		shm_unlock(shp);
+	if (!ns->shm_forced_rmid)
 		return 0;
-	}
 
-	if (shm_may_destroy(ns, shp))
+	if (shm_may_destroy(ns, shp)) {
+		shm_lock_by_ptr(shp);
 		shm_destroy(ns, shp);
-	else
-		shm_unlock(shp);
+	}
 	return 0;
 }
 
+/* Called with ns->shm_ids(ns).rw_mutex locked */
 static int shm_try_destroy_orphaned(int id, void *p, void *data)
 {
 	struct ipc_namespace *ns = data;
-	struct shmid_kernel *shp = shm_lock(ns, id);
-
-	if (IS_ERR(shp))
-		return 0;
+	struct kern_ipc_perm *ipcp = p;
+	struct shmid_kernel *shp;
+	shp = container_of(ipcp, struct shmid_kernel, shm_perm);
 
 	/*
 	 * We want to destroy segments without users and with already
 	 * exit'ed originating process.
+	 *
+	 * As shp->* are changed under rw_mutex, it's safe to skip shp locking.
 	 */
-	if (shp->shm_creator != NULL) {
-		shm_unlock(shp);
+	if (shp->shm_creator != NULL)
 		return 0;
-	}
 
-	if (shm_may_destroy(ns, shp))
+	if (shm_may_destroy(ns, shp)) {
+		shm_lock_by_ptr(shp);
 		shm_destroy(ns, shp);
-	else
-		shm_unlock(shp);
+	}
 	return 0;
 }
 
 void shm_destroy_orphaned(struct ipc_namespace *ns)
 {
 	down_write(&shm_ids(ns).rw_mutex);
-	idr_for_each(&shm_ids(ns).ipcs_idr, &shm_try_destroy_orphaned, ns);
+	if (&shm_ids(ns).in_use)
+		idr_for_each(&shm_ids(ns).ipcs_idr,
+			     &shm_try_destroy_orphaned,
+			     ns);
 	up_write(&shm_ids(ns).rw_mutex);
 }
 
 
 void exit_shm(struct task_struct *task)
 {
-	struct nsproxy *nsp = task->nsproxy;
-	struct ipc_namespace *ns;
-
-	if (!nsp)
-		return;
-	ns = nsp->ipc_ns;
-	if (!ns)
-		return;
+	struct ipc_namespace *ns = task->nsproxy->ipc_ns;
 
 	/* Destroy all already created segments, but not mapped yet */
 	down_write(&shm_ids(ns).rw_mutex);
-	idr_for_each(&shm_ids(ns).ipcs_idr, &shm_try_destroy_current, ns);
+	if (&shm_ids(ns).in_use)
+		idr_for_each(&shm_ids(ns).ipcs_idr,
+			     &shm_try_destroy_current,
+			     ns);
 	up_write(&shm_ids(ns).rw_mutex);
 }
 
-- 
1.7.0.4
