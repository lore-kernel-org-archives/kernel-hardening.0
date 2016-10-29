Reply-To: kernel-hardening@lists.openwall.com
From: David Windsor <dwindsor@gmail.com>
Date: Sat, 29 Oct 2016 12:19:56 -0400
Message-Id: <1477757996-22468-6-git-send-email-dwindsor@gmail.com>
In-Reply-To: <1477757996-22468-1-git-send-email-dwindsor@gmail.com>
References: <1477757996-22468-1-git-send-email-dwindsor@gmail.com>
Subject: [kernel-hardening][RFC PATCH 5/5] mm: add overflow protection to struct kmem_cache.refcount
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, elena.reshetova@intel.com, ishkamiel@gmail.com, takahiro.akashi@linaro.org, colin@cvidal.org, dwindsor@gmail.com
List-ID: <kernel-hardening.lists.openwall.com>

Change type of struct kmem_cache.refcount to atomic_t.  This enables overflow
protection: when CONFIG_HARDENED_ATOMIC is enabled, atomic_t variables
cannot be overflowed.

The copyright for the original PAX_REFCOUNT code:
  - all REFCOUNT code in general: PaX Team <pageexec@freemail.hu>
  - various false positive fixes: Mathias Krause <minipli@googlemail.com>
---
 include/linux/slab_def.h |  2 +-
 include/linux/slub_def.h |  2 +-
 mm/slab.c                |  2 +-
 mm/slab.h                |  2 +-
 mm/slab_common.c         | 12 ++++++------
 mm/slub.c                | 10 +++++-----
 6 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
index 601c69a..d018db5 100644
--- a/include/linux/slab_def.h
+++ b/include/linux/slab_def.h
@@ -40,7 +40,7 @@ struct kmem_cache {
 /* 4) cache creation/removal */
 	const char *name;
 	struct list_head list;
-	int refcount;
+	atomic_t refcount;
 	int object_size;
 	int align;
 
diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index 75f56c2..32710ff 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -74,7 +74,7 @@ struct kmem_cache {
 	struct kmem_cache_order_objects max;
 	struct kmem_cache_order_objects min;
 	gfp_t allocflags;	/* gfp flags to use on each alloc */
-	int refcount;		/* Refcount for slab cache destroy */
+	atomic_t refcount;		/* Refcount for slab cache destroy */
 	void (*ctor)(void *);
 	int inuse;		/* Offset to metadata */
 	int align;		/* Alignment */
diff --git a/mm/slab.c b/mm/slab.c
index 3113caf..e0cf1b4 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1919,7 +1919,7 @@ __kmem_cache_alias(const char *name, size_t size, size_t align,
 
 	cachep = find_mergeable(size, align, flags, name, ctor);
 	if (cachep) {
-		cachep->refcount++;
+		atomic_inc(&cachep->refcount);
 
 		/*
 		 * Adjust the object sizes so that we clear
diff --git a/mm/slab.h b/mm/slab.h
index 9653f2e..9b49151 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -22,7 +22,7 @@ struct kmem_cache {
 	unsigned int align;	/* Alignment as calculated */
 	unsigned long flags;	/* Active flags on the slab */
 	const char *name;	/* Slab name for sysfs */
-	int refcount;		/* Use counter */
+	atomic_t refcount;		/* Use counter */
 	void (*ctor)(void *);	/* Called on object slot creation */
 	struct list_head list;	/* List of all slab caches on the system */
 };
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 71f0b28..869d29f 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -244,7 +244,7 @@ int slab_unmergeable(struct kmem_cache *s)
 	/*
 	 * We may have set a slab to be unmergeable during bootstrap.
 	 */
-	if (s->refcount < 0)
+	if (atomic_read(&s->refcount) < 0)
 		return 1;
 
 	return 0;
@@ -348,7 +348,7 @@ static struct kmem_cache *create_cache(const char *name,
 	if (err)
 		goto out_free_cache;
 
-	s->refcount = 1;
+	atomic_set(&s->refcount, 1);
 	list_add(&s->list, &slab_caches);
 out:
 	if (err)
@@ -718,8 +718,8 @@ void kmem_cache_destroy(struct kmem_cache *s)
 	kasan_cache_destroy(s);
 	mutex_lock(&slab_mutex);
 
-	s->refcount--;
-	if (s->refcount)
+	atomic_dec(&s->refcount);
+	if (atomic_read(&s->refcount))
 		goto out_unlock;
 
 	err = shutdown_memcg_caches(s, &release, &need_rcu_barrier);
@@ -786,7 +786,7 @@ void __init create_boot_cache(struct kmem_cache *s, const char *name, size_t siz
 		panic("Creation of kmalloc slab %s size=%zu failed. Reason %d\n",
 					name, size, err);
 
-	s->refcount = -1;	/* Exempt from merging for now */
+	atomic_set(&s->refcount, -1);	/* Exempt from merging for now */
 }
 
 struct kmem_cache *__init create_kmalloc_cache(const char *name, size_t size,
@@ -799,7 +799,7 @@ struct kmem_cache *__init create_kmalloc_cache(const char *name, size_t size,
 
 	create_boot_cache(s, name, size, flags);
 	list_add(&s->list, &slab_caches);
-	s->refcount = 1;
+	atomic_set(&s->refcount, 1);
 	return s;
 }
 
diff --git a/mm/slub.c b/mm/slub.c
index 2b3e740..d981fe3 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4180,7 +4180,7 @@ __kmem_cache_alias(const char *name, size_t size, size_t align,
 
 	s = find_mergeable(size, align, flags, name, ctor);
 	if (s) {
-		s->refcount++;
+		atomic_inc(&s->refcount);
 
 		/*
 		 * Adjust the object sizes so that we clear
@@ -4196,7 +4196,7 @@ __kmem_cache_alias(const char *name, size_t size, size_t align,
 		}
 
 		if (sysfs_slab_alias(s, name)) {
-			s->refcount--;
+			atomic_dec(&s->refcount);
 			s = NULL;
 		}
 	}
@@ -4903,7 +4903,7 @@ SLAB_ATTR_RO(ctor);
 
 static ssize_t aliases_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%d\n", s->refcount < 0 ? 0 : s->refcount - 1);
+	return sprintf(buf, "%d\n", atomic_read(&s->refcount) < 0 ? 0 : atomic_read(&s->refcount) - 1);
 }
 SLAB_ATTR_RO(aliases);
 
@@ -5046,7 +5046,7 @@ static ssize_t trace_store(struct kmem_cache *s, const char *buf,
 	 * as well as cause other issues like converting a mergeable
 	 * cache into an umergeable one.
 	 */
-	if (s->refcount > 1)
+	if (atomic_read(&s->refcount) > 1)
 		return -EINVAL;
 
 	s->flags &= ~SLAB_TRACE;
@@ -5164,7 +5164,7 @@ static ssize_t failslab_show(struct kmem_cache *s, char *buf)
 static ssize_t failslab_store(struct kmem_cache *s, const char *buf,
 							size_t length)
 {
-	if (s->refcount > 1)
+	if (atomic_read(&s->refcount) > 1)
 		return -EINVAL;
 
 	s->flags &= ~SLAB_FAILSLAB;
-- 
2.7.4
