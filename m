Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Wed,  8 Jun 2016 14:11:42 -0700
Message-Id: <1465420302-23754-5-git-send-email-keescook@chromium.org>
In-Reply-To: <1465420302-23754-1-git-send-email-keescook@chromium.org>
References: <1465420302-23754-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v2 4/4] usercopy: provide split of user-controlled slabs
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey.schaufler@intel.com>, Rik van Riel <riel@redhat.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

Several userspace APIs (ipc, seq_file) provide precise control over
the size of kernel kmallocs, which provides a trivial way to perform
heap overflow attacks where the attacker must control neighboring
allocations. Instead, move these APIs into their own cache so they
cannot interfere with the standard kmallocs, and disable slab merging.
This is enabled with CONFIG_HARDENED_USERCOPY_SPLIT_KMALLOC.

Based on PAX_USERCOPY_SLABS by Brad Spengler and PaX Team.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/seq_file.c        |  2 +-
 include/linux/slab.h |  4 ++++
 ipc/msgutil.c        |  4 ++--
 mm/slab_common.c     | 35 ++++++++++++++++++++++++++++
 mm/slob.c            | 65 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 mm/slub.c            | 11 +++++++++
 security/Kconfig     | 13 +++++++++++
 7 files changed, 131 insertions(+), 3 deletions(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index 19f532e7d35e..1686d05d7914 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -26,7 +26,7 @@ static void seq_set_overflow(struct seq_file *m)
 static void *seq_buf_alloc(unsigned long size)
 {
 	void *buf;
-	gfp_t gfp = GFP_KERNEL;
+	gfp_t gfp = GFP_KERNEL | GFP_USERCOPY;
 
 	/*
 	 * For high order allocations, use __GFP_NORETRY to avoid oom-killing -
diff --git a/include/linux/slab.h b/include/linux/slab.h
index 59cc29ef4cd1..196972482333 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -270,6 +270,10 @@ extern struct kmem_cache *kmalloc_caches[KMALLOC_SHIFT_HIGH + 1];
 extern struct kmem_cache *kmalloc_dma_caches[KMALLOC_SHIFT_HIGH + 1];
 #endif
 
+#ifdef CONFIG_HARDENED_USERCOPY_SPLIT_KMALLOC
+extern struct kmem_cache *kmalloc_usercopy_caches[KMALLOC_SHIFT_HIGH + 1];
+#endif
+
 /*
  * Figure out which kmalloc slab an allocation of a certain size
  * belongs to.
diff --git a/ipc/msgutil.c b/ipc/msgutil.c
index ed81aafd2392..6bd28c3aec8c 100644
--- a/ipc/msgutil.c
+++ b/ipc/msgutil.c
@@ -55,7 +55,7 @@ static struct msg_msg *alloc_msg(size_t len)
 	size_t alen;
 
 	alen = min(len, DATALEN_MSG);
-	msg = kmalloc(sizeof(*msg) + alen, GFP_KERNEL);
+	msg = kmalloc(sizeof(*msg) + alen, GFP_KERNEL | GFP_USERCOPY);
 	if (msg == NULL)
 		return NULL;
 
@@ -67,7 +67,7 @@ static struct msg_msg *alloc_msg(size_t len)
 	while (len > 0) {
 		struct msg_msgseg *seg;
 		alen = min(len, DATALEN_SEG);
-		seg = kmalloc(sizeof(*seg) + alen, GFP_KERNEL);
+		seg = kmalloc(sizeof(*seg) + alen, GFP_KERNEL | GFP_USERCOPY);
 		if (seg == NULL)
 			goto out_err;
 		*pseg = seg;
diff --git a/mm/slab_common.c b/mm/slab_common.c
index f3f6ae3f56fc..fd567a61f8aa 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -44,7 +44,16 @@ struct kmem_cache *kmem_cache;
  * Merge control. If this is set then no merging of slab caches will occur.
  * (Could be removed. This was introduced to pacify the merge skeptics.)
  */
+#ifdef CONFIG_HARDENED_USERCOPY_SPLIT_KMALLOC
+/*
+ * If the kmalloc slabs are split between user-controlled sizing and
+ * regular kmalloc, we want to make sure we don't help attackers by
+ * merging slabs.
+ */
+static int slab_nomerge = 1;
+#else
 static int slab_nomerge;
+#endif
 
 static int __init setup_slab_nomerge(char *str)
 {
@@ -811,6 +820,11 @@ struct kmem_cache *kmalloc_dma_caches[KMALLOC_SHIFT_HIGH + 1];
 EXPORT_SYMBOL(kmalloc_dma_caches);
 #endif
 
+#ifdef CONFIG_HARDENED_USERCOPY_SPLIT_KMALLOC
+struct kmem_cache *kmalloc_usercopy_caches[KMALLOC_SHIFT_HIGH + 1];
+EXPORT_SYMBOL(kmalloc_usercopy_caches);
+#endif /* CONFIG_HARDENED_USERCOPY_SPLIT_KMALLOC */
+
 /*
  * Conversion table for small slabs sizes / 8 to the index in the
  * kmalloc array. This is necessary for slabs < 192 since we have non power
@@ -875,6 +889,11 @@ struct kmem_cache *kmalloc_slab(size_t size, gfp_t flags)
 		return kmalloc_dma_caches[index];
 
 #endif
+#ifdef CONFIG_HARDENED_USERCOPY_SPLIT_KMALLOC
+	if (unlikely((flags & GFP_USERCOPY)))
+		return kmalloc_usercopy_caches[index];
+#endif /* CONFIG_HARDENED_USERCOPY_SPLIT_KMALLOC */
+
 	return kmalloc_caches[index];
 }
 
@@ -998,6 +1017,22 @@ void __init create_kmalloc_caches(unsigned long flags)
 		}
 	}
 #endif
+#ifdef CONFIG_HARDENED_USERCOPY_SPLIT_KMALLOC
+	for (i = 0; i <= KMALLOC_SHIFT_HIGH; i++) {
+		struct kmem_cache *s = kmalloc_caches[i];
+
+		if (s) {
+			int size = kmalloc_size(i);
+			char *n = kasprintf(GFP_NOWAIT,
+				 "usercopy-kmalloc-%d", size);
+
+			BUG_ON(!n);
+			kmalloc_usercopy_caches[i] = create_kmalloc_cache(n,
+				size, SLAB_USERCOPY | flags);
+		}
+	}
+#endif /* CONFIG_HARDENED_USERCOPY_SPLIT_KMALLOC */
+
 }
 #endif /* !CONFIG_SLOB */
 
diff --git a/mm/slob.c b/mm/slob.c
index 2d54fcd262fa..a01379794670 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -583,6 +583,53 @@ int __kmem_cache_create(struct kmem_cache *c, unsigned long flags)
 	return 0;
 }
 
+#ifdef CONFIG_HARDENED_USERCOPY_SPLIT_KMALLOC
+static __always_inline void *
+__do_kmalloc_node_align(size_t size, gfp_t gfp, int node, unsigned long caller, int align)
+{
+	slob_t *m;
+	void *ret = NULL;
+
+	gfp &= gfp_allowed_mask;
+
+	lockdep_trace_alloc(gfp);
+
+	if (size < PAGE_SIZE - align) {
+		if (!size)
+			return ZERO_SIZE_PTR;
+
+		m = slob_alloc(size + align, gfp, align, node);
+
+		if (!m)
+			return NULL;
+		BUILD_BUG_ON(ARCH_KMALLOC_MINALIGN < 2 * SLOB_UNIT);
+		BUILD_BUG_ON(ARCH_SLAB_MINALIGN < 2 * SLOB_UNIT);
+		m[0].units = size;
+		m[1].units = align;
+		ret = (void *)m + align;
+
+		trace_kmalloc_node(caller, ret,
+				   size, size + align, gfp, node);
+	} else {
+		unsigned int order = get_order(size);
+		struct page *page;
+
+		if (likely(order))
+			gfp |= __GFP_COMP;
+		page = slob_new_pages(gfp, order, node);
+		if (page) {
+			ret = page_address(page);
+			page->private = size;
+		}
+
+		trace_kmalloc_node(caller, ret,
+				   size, PAGE_SIZE << order, gfp, node);
+	}
+
+	return ret;
+}
+#endif /* CONFIG_HARDENED_USERCOPY_SPLIT_KMALLOC */
+
 static void *slob_alloc_node(struct kmem_cache *c, gfp_t flags, int node)
 {
 	void *b;
@@ -591,6 +638,10 @@ static void *slob_alloc_node(struct kmem_cache *c, gfp_t flags, int node)
 
 	lockdep_trace_alloc(flags);
 
+#ifdef CONFIG_HARDENED_USERCOPY_SPLIT_KMALLOC
+	b = __do_kmalloc_node_align(c->size, flags, node, _RET_IP_, c->align);
+#else /* CONFIG_HARDENED_USERCOPY_SPLIT_KMALLOC */
+
 	if (c->size < PAGE_SIZE) {
 		b = slob_alloc(c->size, flags, c->align, node);
 		trace_kmem_cache_alloc_node(_RET_IP_, b, c->object_size,
@@ -602,6 +653,7 @@ static void *slob_alloc_node(struct kmem_cache *c, gfp_t flags, int node)
 					    PAGE_SIZE << get_order(c->size),
 					    flags, node);
 	}
+#endif /* CONFIG_HARDENED_USERCOPY_SPLIT_KMALLOC */
 
 	if (b && c->ctor)
 		c->ctor(b);
@@ -648,6 +700,15 @@ static void kmem_rcu_free(struct rcu_head *head)
 
 void kmem_cache_free(struct kmem_cache *c, void *b)
 {
+#ifdef CONFIG_HARDENED_USERCOPY_SPLIT_KMALLOC
+	int size = c->size;
+
+	if (size + c->align < PAGE_SIZE) {
+		size += c->align;
+		b -= c->align;
+	}
+#endif /* CONFIG_HARDENED_USERCOPY_SPLIT_KMALLOC */
+
 	kmemleak_free_recursive(b, c->flags);
 	if (unlikely(c->flags & SLAB_DESTROY_BY_RCU)) {
 		struct slob_rcu *slob_rcu;
@@ -658,7 +719,11 @@ void kmem_cache_free(struct kmem_cache *c, void *b)
 		__kmem_cache_free(b, c->size);
 	}
 
+#ifdef CONFIG_HARDENED_USERCOPY_SPLIT_KMALLOC
+	trace_kfree(_RET_IP_, b);
+#else /* CONFIG_HARDENED_USERCOPY_SPLIT_KMALLOC */
 	trace_kmem_cache_free(_RET_IP_, b);
+#endif /* CONFIG_HARDENED_USERCOPY_SPLIT_KMALLOC */
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
diff --git a/mm/slub.c b/mm/slub.c
index 589f0ffe712b..bab85cf94f3f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4838,6 +4838,14 @@ static ssize_t cache_dma_show(struct kmem_cache *s, char *buf)
 SLAB_ATTR_RO(cache_dma);
 #endif
 
+#ifdef CONFIG_HARDENED_USERCOPY_SPLIT_KMALLOC
+static ssize_t usercopy_show(struct kmem_cache *s, char *buf)
+{
+	return sprintf(buf, "%d\n", !!(s->flags & SLAB_USERCOPY));
+}
+SLAB_ATTR_RO(usercopy);
+#endif /* CONFIG_HARDENED_USERCOPY_SPLIT_KMALLOC */
+
 static ssize_t destroy_by_rcu_show(struct kmem_cache *s, char *buf)
 {
 	return sprintf(buf, "%d\n", !!(s->flags & SLAB_DESTROY_BY_RCU));
@@ -5178,6 +5186,9 @@ static struct attribute *slab_attrs[] = {
 #ifdef CONFIG_ZONE_DMA
 	&cache_dma_attr.attr,
 #endif
+#ifdef CONFIG_HARDENED_USERCOPY_SPLIT_KMALLOC
+	&usercopy_attr.attr,
+#endif /* CONFIG_HARDENED_USERCOPY_SPLIT_KMALLOC */
 #ifdef CONFIG_NUMA
 	&remote_node_defrag_ratio_attr.attr,
 #endif
diff --git a/security/Kconfig b/security/Kconfig
index 0ec17a252e49..f5d367213d8c 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -139,6 +139,19 @@ config HARDENED_USERCOPY_WHITELIST
 	  memory that an attack has access to through bugs in interfaces
 	  that use copy_to_user() and copy_from_user().
 
+config HARDENED_USERCOPY_SPLIT_KMALLOC
+	bool "Split kmalloc caches from user-controlled allocations"
+	depends on HARDENED_USERCOPY
+	default HARDENED_USERCOPY
+	help
+	  This option creates a separate set of kmalloc caches used for
+	  userspace APIs that provide fine-grained control over kernel
+	  allocation sizes. Without this, it is much easier for attackers
+	  to precisely size and attack heap overflows. If their allocations
+	  are separated into a different cache, attackers must find other
+	  ways to prepare heap attacks that will be near their desired
+	  targets.
+
 source security/selinux/Kconfig
 source security/smack/Kconfig
 source security/tomoyo/Kconfig
-- 
2.7.4
