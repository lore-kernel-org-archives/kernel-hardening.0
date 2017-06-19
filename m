From: Kees Cook <keescook@chromium.org>
Date: Mon, 19 Jun 2017 16:36:31 -0700
Message-Id: <1497915397-93805-18-git-send-email-keescook@chromium.org>
In-Reply-To: <1497915397-93805-1-git-send-email-keescook@chromium.org>
References: <1497915397-93805-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 17/23] dcache: define usercopy region in dentry_cache slab cache
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, David Windsor <dave@nullcore.net>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

From: David Windsor <dave@nullcore.net>

When a dentry name is short enough, it can be stored directly in
the dentry itself.  These dentry short names, stored in struct
dentry.d_iname and therefore contained in the dentry_cache slab cache,
need to be coped to/from userspace.

In support of usercopy hardening, this patch defines a region in
the dentry_cache slab cache in which userspace copy operations
are allowed.

This region is known as the slab cache's usercopy region.  Slab
caches can now check that each copy operation involving cache-managed
memory falls entirely within the slab's usercopy region.

This patch is modified from Brad Spengler/PaX Team's PAX_USERCOPY
whitelisting code in the last public patch of grsecurity/PaX based on my
understanding of the code. Changes or omissions from the original code are
mine and don't reflect the original grsecurity/PaX code.

Signed-off-by: David Windsor <dave@nullcore.net>
[kees: adjust hunks for kmalloc-specific things moved later, adjust commit log]
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/dcache.c          | 5 +++--
 include/linux/slab.h | 5 +++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index f7f3c4114baa..bae2e148946c 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -3580,8 +3580,9 @@ static void __init dcache_init(void)
 	 * but it is probably not worth it because of the cache nature
 	 * of the dcache. 
 	 */
-	dentry_cache = KMEM_CACHE(dentry,
-		SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|SLAB_MEM_SPREAD|SLAB_ACCOUNT);
+	dentry_cache = KMEM_CACHE_USERCOPY(dentry,
+		SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|SLAB_MEM_SPREAD|SLAB_ACCOUNT,
+		d_iname);
 
 	/* Hash may have been set up in dcache_init_early */
 	if (!hashdist)
diff --git a/include/linux/slab.h b/include/linux/slab.h
index a48f54238273..97f4a0117b3b 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -151,6 +151,11 @@ void memcg_destroy_kmem_caches(struct mem_cgroup *);
 		sizeof(struct __struct), __alignof__(struct __struct),\
 		(__flags), NULL)
 
+#define KMEM_CACHE_USERCOPY(__struct, __flags, __field) kmem_cache_create_usercopy(#__struct,\
+		sizeof(struct __struct), __alignof__(struct __struct),\
+		(__flags), offsetof(struct __struct, __field),\
+		sizeof_field(struct __struct, __field), NULL)
+
 /*
  * Common kmalloc functions provided by all allocators
  */
-- 
2.7.4
