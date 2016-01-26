Reply-To: kernel-hardening@lists.openwall.com
From: Laura Abbott <labbott@fedoraproject.org>
Date: Mon, 25 Jan 2016 17:15:11 -0800
Message-Id: <1453770913-32287-2-git-send-email-labbott@fedoraproject.org>
In-Reply-To: <1453770913-32287-1-git-send-email-labbott@fedoraproject.org>
References: <1453770913-32287-1-git-send-email-labbott@fedoraproject.org>
Subject: [kernel-hardening] [RFC][PATCH 1/3] slub: Drop lock at the end of free_debug_processing
To: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <js1304@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Laura Abbott <labbott@fedoraproject.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>


Currently, free_debug_processing has a comment "Keep node_lock to preserve
integrity until the object is actually freed". In actuallity,
the lock is dropped immediately in __slab_free. Rather than wait until
__slab_free and potentially throw off the unlikely marking, just drop
the lock in __slab_free. This also lets free_debug_processing take
its own copy of the spinlock flags rather than trying to share the ones
from __slab_free. Since there is no use for the node afterwards, change
the return type of free_debug_processing to return an int like
alloc_debug_processing.

Signed-off-by: Laura Abbott <labbott@fedoraproject.org>
---
 mm/slub.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 574a085..6ddba32 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1071,16 +1071,17 @@ bad:
 }
 
 /* Supports checking bulk free of a constructed freelist */
-static noinline struct kmem_cache_node *free_debug_processing(
+static noinline int free_debug_processing(
 	struct kmem_cache *s, struct page *page,
 	void *head, void *tail, int bulk_cnt,
-	unsigned long addr, unsigned long *flags)
+	unsigned long addr)
 {
 	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
 	void *object = head;
 	int cnt = 0;
+	unsigned long uninitialized_var(flags);
 
-	spin_lock_irqsave(&n->list_lock, *flags);
+	spin_lock_irqsave(&n->list_lock, flags);
 	slab_lock(page);
 
 	if (!check_slab(s, page))
@@ -1133,17 +1134,14 @@ out:
 			 bulk_cnt, cnt);
 
 	slab_unlock(page);
-	/*
-	 * Keep node_lock to preserve integrity
-	 * until the object is actually freed
-	 */
-	return n;
+	spin_unlock_irqrestore(&n->list_lock, flags);
+	return 1;
 
 fail:
 	slab_unlock(page);
-	spin_unlock_irqrestore(&n->list_lock, *flags);
+	spin_unlock_irqrestore(&n->list_lock, flags);
 	slab_fix(s, "Object at 0x%p not freed", object);
-	return NULL;
+	return 0;
 }
 
 static int __init setup_slub_debug(char *str)
@@ -1234,7 +1232,7 @@ static inline void setup_object_debug(struct kmem_cache *s,
 static inline int alloc_debug_processing(struct kmem_cache *s,
 	struct page *page, void *object, unsigned long addr) { return 0; }
 
-static inline struct kmem_cache_node *free_debug_processing(
+static inline int free_debug_processing(
 	struct kmem_cache *s, struct page *page,
 	void *head, void *tail, int bulk_cnt,
 	unsigned long addr, unsigned long *flags) { return NULL; }
@@ -2651,8 +2649,7 @@ static void __slab_free(struct kmem_cache *s, struct page *page,
 	stat(s, FREE_SLOWPATH);
 
 	if (kmem_cache_debug(s) &&
-	    !(n = free_debug_processing(s, page, head, tail, cnt,
-					addr, &flags)))
+	    !free_debug_processing(s, page, head, tail, cnt, addr))
 		return;
 
 	do {
-- 
2.5.0
