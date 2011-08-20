Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sat, 20 Aug 2011 18:27:23 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110820142723.GA5708@albatros>
References: <20110817191550.GA18554@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110817191550.GA18554@albatros>
Subject: [kernel-hardening] Re: kmalloc() nofail allocations
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

Here is a patch to do it.  I've implemented k(m|z)alloc() and
kmem_cache_{z,}alloc() nofail variants.  As a result, setuid() cannot
fail with any reason, but EACCES.

kernel/cred.c is partly moved to _nofail() too, just to show how much
error handling code it removes.

--
 include/linux/slab.h     |   26 ++++++++++++++++++++++++++
 include/linux/slub_def.h |   15 +++++++++++++++
 kernel/cred.c            |   28 ++++++----------------------
 kernel/sys.c             |    2 --
 kernel/user.c            |    8 +-------
 5 files changed, 48 insertions(+), 31 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 573c809..c2a967b 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -189,6 +189,32 @@ size_t ksize(const void *);
 #include <linux/slab_def.h>
 #endif
 
+/*
+ * *_nofail() is used for small allocations, which cannot fail because
+ * allocations of such size are infinitely retried up to the success.
+ * 
+ * Limitation of k*alloc_nofail(): `size' argument must be constant.
+ * If you have a dynamic `size', you have to use common k*alloc().
+ */
+#define kmalloc_nofail(size, flags) \
+({ \
+	void *p; \
+	(void)BUILD_BUG_ON_ZERO(size > (PAGE_SIZE << (PAGE_ALLOC_COSTLY_ORDER-1))); \
+	if (flags & __GFP_NORETRY) \
+		panic("Attempt to call kmalloc_nofail() with __GFP_NORETRY"); \
+	p = kmalloc(size, flags); \
+	if (p == NULL) \
+		panic("kmalloc_nofail() returned NULL\n"); \
+	p; \
+})
+
+#define kzalloc_nofail(size, flags) \
+	kmalloc_nofail(size, (flags | __GFP_ZERO))
+
+
+#define kmem_cache_zalloc_nofail(cache, flags) \
+	kmem_cache_alloc_nofail(cache, (flags | __GFP_ZERO))
+
 /**
  * kcalloc - allocate memory for an array. The memory is set to zero.
  * @n: number of elements.
diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index f58d641..9e63bc5 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -309,4 +309,19 @@ static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
 }
 #endif
 
+/* This is a slightly weaker check than kmalloc_nofail() as kmem check is runtime check :\ */
+#define kmem_cache_alloc_nofail(cache, flags) \
+({ \
+	void *p; \
+	if ((cache)->objsize > (PAGE_SIZE << (PAGE_ALLOC_COSTLY_ORDER-1))) \
+		panic("Too big size (%lu) for kmem_cache_alloc_nofail()!", \
+			(long)(cache)->objsize); \
+	if (flags & __GFP_NORETRY); \
+		panic("Attempt to call kmem_cache_alloc_nofail() with __GFP_NORETRY"); \
+	p = kmem_cache_alloc(cache, flags); \
+	if (p == NULL) \
+		panic("kmem_cache_alloc() returned NULL\n"); \
+	p; \
+})
+
 #endif /* _LINUX_SLUB_DEF_H */
diff --git a/kernel/cred.c b/kernel/cred.c
index 8ef31f5..4c2997a 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -239,16 +239,10 @@ struct cred *cred_alloc_blank(void)
 {
 	struct cred *new;
 
-	new = kmem_cache_zalloc(cred_jar, GFP_KERNEL);
-	if (!new)
-		return NULL;
+	new = kmem_cache_zalloc_nofail(cred_jar, GFP_KERNEL);
 
 #ifdef CONFIG_KEYS
-	new->tgcred = kzalloc(sizeof(*new->tgcred), GFP_KERNEL);
-	if (!new->tgcred) {
-		kmem_cache_free(cred_jar, new);
-		return NULL;
-	}
+	new->tgcred = kzalloc_nofail(sizeof(*new->tgcred), GFP_KERNEL);
 	atomic_set(&new->tgcred->usage, 1);
 #endif
 
@@ -289,9 +283,7 @@ struct cred *prepare_creds(void)
 
 	validate_process_creds();
 
-	new = kmem_cache_alloc(cred_jar, GFP_KERNEL);
-	if (!new)
-		return NULL;
+	new = kmem_cache_alloc_nofail(cred_jar, GFP_KERNEL);
 
 	kdebug("prepare_creds() alloc %p", new);
 
@@ -334,9 +326,7 @@ struct cred *prepare_exec_creds(void)
 	struct cred *new;
 
 #ifdef CONFIG_KEYS
-	tgcred = kmalloc(sizeof(*tgcred), GFP_KERNEL);
-	if (!tgcred)
-		return NULL;
+	tgcred = kmalloc_nofail(sizeof(*tgcred), GFP_KERNEL);
 #endif
 
 	new = prepare_creds();
@@ -430,11 +420,7 @@ int copy_creds(struct task_struct *p, unsigned long clone_flags)
 	 * a process - this is slightly icky as we violate COW credentials a
 	 * bit */
 	if (!(clone_flags & CLONE_THREAD)) {
-		tgcred = kmalloc(sizeof(*tgcred), GFP_KERNEL);
-		if (!tgcred) {
-			ret = -ENOMEM;
-			goto error_put;
-		}
+		tgcred = kmalloc_nofail(sizeof(*tgcred), GFP_KERNEL);
 		atomic_set(&tgcred->usage, 1);
 		spin_lock_init(&tgcred->lock);
 		tgcred->process_keyring = NULL;
@@ -647,9 +633,7 @@ struct cred *prepare_kernel_cred(struct task_struct *daemon)
 	const struct cred *old;
 	struct cred *new;
 
-	new = kmem_cache_alloc(cred_jar, GFP_KERNEL);
-	if (!new)
-		return NULL;
+	new = kmem_cache_alloc_nofail(cred_jar, GFP_KERNEL);
 
 	kdebug("prepare_kernel_cred() alloc %p", new);
 
diff --git a/kernel/sys.c b/kernel/sys.c
index dd948a1..d8bca2d 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -618,8 +618,6 @@ static int set_user(struct cred *new)
 	struct user_struct *new_user;
 
 	new_user = alloc_uid(current_user_ns(), new->uid);
-	if (!new_user)
-		return -EAGAIN;
 
 	/*
 	 * We don't fail in case of NPROC limit excess here because too many
diff --git a/kernel/user.c b/kernel/user.c
index 9e03e9c..d79a345 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -146,10 +146,7 @@ struct user_struct *alloc_uid(struct user_namespace *ns, uid_t uid)
 	spin_unlock_irq(&uidhash_lock);
 
 	if (!up) {
-		new = kmem_cache_zalloc(uid_cachep, GFP_KERNEL);
-		if (!new)
-			goto out_unlock;
-
+		new = kmem_cache_zalloc_nofail(uid_cachep, GFP_KERNEL);
 		new->uid = uid;
 		atomic_set(&new->__count, 1);
 
@@ -174,9 +171,6 @@ struct user_struct *alloc_uid(struct user_namespace *ns, uid_t uid)
 	}
 
 	return up;
-
-out_unlock:
-	return NULL;
 }
 
 static int __init uid_cache_init(void)
