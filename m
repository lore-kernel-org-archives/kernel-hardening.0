From: Kees Cook <keescook@chromium.org>
Date: Mon, 19 Jun 2017 16:36:34 -0700
Message-Id: <1497915397-93805-21-git-send-email-keescook@chromium.org>
In-Reply-To: <1497915397-93805-1-git-send-email-keescook@chromium.org>
References: <1497915397-93805-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 20/23] usercopy: convert kmalloc caches to usercopy caches
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, David Windsor <dave@nullcore.net>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

From: David Windsor <dave@nullcore.net>

Mark the kmalloc slab caches as entirely whitelisted.  These
caches are frequently used to fulfill kernel allocations that contain
data to be copied to/from userspace.  It is impossible to know
at build time what objects will be contained in these caches,
so the entire cache is whitelisted.

This patch is modified from Brad Spengler/PaX Team's PAX_USERCOPY
whitelisting code in the last public patch of grsecurity/PaX based on my
understanding of the code. Changes or omissions from the original code are
mine and don't reflect the original grsecurity/PaX code.

Signed-off-by: David Windsor <dave@nullcore.net>
[kees: merged in moved kmalloc hunks, adjust commit log]
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 mm/slab.c        |  3 ++-
 mm/slab.h        |  3 ++-
 mm/slab_common.c | 10 ++++++----
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 5c78830aeea0..4cafbe13f239 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1291,7 +1291,8 @@ void __init kmem_cache_init(void)
 	 */
 	kmalloc_caches[INDEX_NODE] = create_kmalloc_cache(
 				kmalloc_info[INDEX_NODE].name,
-				kmalloc_size(INDEX_NODE), ARCH_KMALLOC_FLAGS);
+				kmalloc_size(INDEX_NODE), ARCH_KMALLOC_FLAGS,
+				0, kmalloc_size(INDEX_NODE));
 	slab_state = PARTIAL_NODE;
 	setup_kmalloc_cache_index_table();
 
diff --git a/mm/slab.h b/mm/slab.h
index 92c0cedb296d..4cdc8e64fdbd 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -96,7 +96,8 @@ struct kmem_cache *kmalloc_slab(size_t, gfp_t);
 extern int __kmem_cache_create(struct kmem_cache *, unsigned long flags);
 
 extern struct kmem_cache *create_kmalloc_cache(const char *name, size_t size,
-			unsigned long flags);
+			unsigned long flags, size_t useroffset,
+			size_t usersize);
 extern void create_boot_cache(struct kmem_cache *, const char *name,
 			size_t size, unsigned long flags, size_t useroffset,
 			size_t usersize);
diff --git a/mm/slab_common.c b/mm/slab_common.c
index af97465b99e6..685321a0d355 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -917,14 +917,15 @@ void __init create_boot_cache(struct kmem_cache *s, const char *name, size_t siz
 }
 
 struct kmem_cache *__init create_kmalloc_cache(const char *name, size_t size,
-				unsigned long flags)
+				unsigned long flags, size_t useroffset,
+				size_t usersize)
 {
 	struct kmem_cache *s = kmem_cache_zalloc(kmem_cache, GFP_NOWAIT);
 
 	if (!s)
 		panic("Out of memory when creating slab %s\n", name);
 
-	create_boot_cache(s, name, size, flags, 0, size);
+	create_boot_cache(s, name, size, flags, useroffset, usersize);
 	list_add(&s->list, &slab_caches);
 	memcg_link_cache(s);
 	s->refcount = 1;
@@ -1078,7 +1079,8 @@ void __init setup_kmalloc_cache_index_table(void)
 static void __init new_kmalloc_cache(int idx, unsigned long flags)
 {
 	kmalloc_caches[idx] = create_kmalloc_cache(kmalloc_info[idx].name,
-					kmalloc_info[idx].size, flags);
+					kmalloc_info[idx].size, flags, 0,
+					kmalloc_info[idx].size);
 }
 
 /*
@@ -1119,7 +1121,7 @@ void __init create_kmalloc_caches(unsigned long flags)
 
 			BUG_ON(!n);
 			kmalloc_dma_caches[i] = create_kmalloc_cache(n,
-				size, SLAB_CACHE_DMA | flags);
+				size, SLAB_CACHE_DMA | flags, 0, 0);
 		}
 	}
 #endif
-- 
2.7.4
