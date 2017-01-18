Reply-To: kernel-hardening@lists.openwall.com
From: Elena Reshetova <elena.reshetova@intel.com>
Date: Wed, 18 Jan 2017 11:11:42 +0200
Message-Id: <1484730707-29313-14-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1484730707-29313-1-git-send-email-elena.reshetova@intel.com>
References: <1484730707-29313-1-git-send-email-elena.reshetova@intel.com>
Subject: [kernel-hardening] [RFCv2 PATCH 13/18] ipc: covert from atomic_t to refcount_t
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, peterz@infradead.org, will.deacon@arm.com, dwindsor@gmail.com, gregkh@linuxfoundation.org, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. Convert the cases found.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/ipc_namespace.h | 5 +++--
 ipc/namespace.c               | 4 ++--
 ipc/sem.c                     | 8 ++++----
 ipc/util.c                    | 6 +++---
 ipc/util.h                    | 3 ++-
 5 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
index 848e579..7230638 100644
--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
@@ -7,6 +7,7 @@
 #include <linux/notifier.h>
 #include <linux/nsproxy.h>
 #include <linux/ns_common.h>
+#include <linux/refcount.h>
 
 struct user_namespace;
 
@@ -19,7 +20,7 @@ struct ipc_ids {
 };
 
 struct ipc_namespace {
-	atomic_t	count;
+	refcount_t	count;
 	struct ipc_ids	ids[3];
 
 	int		sem_ctls[4];
@@ -118,7 +119,7 @@ extern struct ipc_namespace *copy_ipcs(unsigned long flags,
 static inline struct ipc_namespace *get_ipc_ns(struct ipc_namespace *ns)
 {
 	if (ns)
-		atomic_inc(&ns->count);
+		refcount_inc(&ns->count);
 	return ns;
 }
 
diff --git a/ipc/namespace.c b/ipc/namespace.c
index 0abdea4..ed10bbc 100644
--- a/ipc/namespace.c
+++ b/ipc/namespace.c
@@ -48,7 +48,7 @@ static struct ipc_namespace *create_ipc_ns(struct user_namespace *user_ns,
 		goto fail_free;
 	ns->ns.ops = &ipcns_operations;
 
-	atomic_set(&ns->count, 1);
+	refcount_set(&ns->count, 1);
 	ns->user_ns = get_user_ns(user_ns);
 	ns->ucounts = ucounts;
 
@@ -142,7 +142,7 @@ static void free_ipc_ns(struct ipc_namespace *ns)
  */
 void put_ipc_ns(struct ipc_namespace *ns)
 {
-	if (atomic_dec_and_lock(&ns->count, &mq_lock)) {
+	if (refcount_dec_and_lock(&ns->count, &mq_lock)) {
 		mq_clear_sbinfo(ns);
 		spin_unlock(&mq_lock);
 		mq_put_mnt(ns);
diff --git a/ipc/sem.c b/ipc/sem.c
index e08b948..04bab9b 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -139,7 +139,7 @@ struct sem_undo {
  * that may be shared among all a CLONE_SYSVSEM task group.
  */
 struct sem_undo_list {
-	atomic_t		refcnt;
+	refcount_t		refcnt;
 	spinlock_t		lock;
 	struct list_head	list_proc;
 };
@@ -1629,7 +1629,7 @@ static inline int get_undo_list(struct sem_undo_list **undo_listp)
 		if (undo_list == NULL)
 			return -ENOMEM;
 		spin_lock_init(&undo_list->lock);
-		atomic_set(&undo_list->refcnt, 1);
+		refcount_set(&undo_list->refcnt, 1);
 		INIT_LIST_HEAD(&undo_list->list_proc);
 
 		current->sysvsem.undo_list = undo_list;
@@ -2028,7 +2028,7 @@ int copy_semundo(unsigned long clone_flags, struct task_struct *tsk)
 		error = get_undo_list(&undo_list);
 		if (error)
 			return error;
-		atomic_inc(&undo_list->refcnt);
+		refcount_inc(&undo_list->refcnt);
 		tsk->sysvsem.undo_list = undo_list;
 	} else
 		tsk->sysvsem.undo_list = NULL;
@@ -2057,7 +2057,7 @@ void exit_sem(struct task_struct *tsk)
 		return;
 	tsk->sysvsem.undo_list = NULL;
 
-	if (!atomic_dec_and_test(&ulp->refcnt))
+	if (!refcount_dec_and_test(&ulp->refcnt))
 		return;
 
 	for (;;) {
diff --git a/ipc/util.c b/ipc/util.c
index 798cad1..24484a6 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -437,7 +437,7 @@ void *ipc_rcu_alloc(int size)
 	struct ipc_rcu *out = ipc_alloc(sizeof(struct ipc_rcu) + size);
 	if (unlikely(!out))
 		return NULL;
-	atomic_set(&out->refcount, 1);
+	refcount_set(&out->refcount, 1);
 	return out + 1;
 }
 
@@ -445,14 +445,14 @@ int ipc_rcu_getref(void *ptr)
 {
 	struct ipc_rcu *p = ((struct ipc_rcu *)ptr) - 1;
 
-	return atomic_inc_not_zero(&p->refcount);
+	return refcount_inc_not_zero(&p->refcount);
 }
 
 void ipc_rcu_putref(void *ptr, void (*func)(struct rcu_head *head))
 {
 	struct ipc_rcu *p = ((struct ipc_rcu *)ptr) - 1;
 
-	if (!atomic_dec_and_test(&p->refcount))
+	if (!refcount_dec_and_test(&p->refcount))
 		return;
 
 	call_rcu(&p->rcu, func);
diff --git a/ipc/util.h b/ipc/util.h
index 51f7ca5..274ec9b 100644
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -12,6 +12,7 @@
 
 #include <linux/unistd.h>
 #include <linux/err.h>
+#include <linux/refcount.h>
 
 #define SEQ_MULTIPLIER	(IPCMNI)
 
@@ -49,7 +50,7 @@ static inline void shm_exit_ns(struct ipc_namespace *ns) { }
 
 struct ipc_rcu {
 	struct rcu_head rcu;
-	atomic_t refcount;
+	refcount_t refcount;
 } ____cacheline_aligned_in_smp;
 
 #define ipc_rcu_to_struct(p)  ((void *)(p+1))
-- 
2.7.4
