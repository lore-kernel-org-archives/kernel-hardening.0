Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Wed,  8 Jun 2016 14:11:41 -0700
Message-Id: <1465420302-23754-4-git-send-email-keescook@chromium.org>
In-Reply-To: <1465420302-23754-1-git-send-email-keescook@chromium.org>
References: <1465420302-23754-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v2 3/4] usercopy: whitelist user-copyable caches
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey.schaufler@intel.com>, Rik van Riel <riel@redhat.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

Most stuff in the kernel should not be copied to/from userspace, so we
instead mark those that were arguably designed to be with SLAB_USERCOPY.
Some, like the general kmalloc caches, must be marked this way since they
are one of the most frequently used allocation methods, after the stack,
used to hold data copied to/from userspace.

Since this is likely going to be temporarily disruptive for other
architectures or workflows, this can be disabled by turning off
CONFIG_HARDENED_USERCOPY_WHITELIST.

Note: "dcache" cache isn't whitelisted in grsecurity/PaX, but I have
not figured out how to make readdir operate sanely yet.

Based on PAX_USERCOPY by Brad Spengler and PaX Team.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/cifs/cifsfs.c       |  7 ++++---
 fs/dcache.c            |  6 ++++--
 fs/jfs/super.c         |  2 +-
 include/linux/gfp.h    |  5 ++++-
 include/linux/slab.h   |  1 +
 kernel/fork.c          |  2 +-
 mm/slab.c              |  8 +++++++-
 mm/slab.h              |  3 ++-
 mm/slab_common.c       |  6 +++---
 mm/slub.c              |  4 ++++
 net/decnet/af_decnet.c |  1 +
 security/Kconfig       | 10 ++++++++++
 virt/kvm/kvm_main.c    |  2 +-
 13 files changed, 43 insertions(+), 14 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 5d8b7edf8a8f..18444cc5e7dc 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1142,7 +1142,8 @@ cifs_init_request_bufs(void)
 */
 	cifs_req_cachep = kmem_cache_create("cifs_request",
 					    CIFSMaxBufSize + max_hdr_size, 0,
-					    SLAB_HWCACHE_ALIGN, NULL);
+					    SLAB_HWCACHE_ALIGN|SLAB_USERCOPY,
+					    NULL);
 	if (cifs_req_cachep == NULL)
 		return -ENOMEM;
 
@@ -1169,8 +1170,8 @@ cifs_init_request_bufs(void)
 	efficient to alloc 1 per page off the slab compared to 17K (5page)
 	alloc of large cifs buffers even when page debugging is on */
 	cifs_sm_req_cachep = kmem_cache_create("cifs_small_rq",
-			MAX_CIFS_SMALL_BUFFER_SIZE, 0, SLAB_HWCACHE_ALIGN,
-			NULL);
+			MAX_CIFS_SMALL_BUFFER_SIZE, 0,
+			SLAB_USERCOPY | SLAB_HWCACHE_ALIGN, NULL);
 	if (cifs_sm_req_cachep == NULL) {
 		mempool_destroy(cifs_req_poolp);
 		kmem_cache_destroy(cifs_req_cachep);
diff --git a/fs/dcache.c b/fs/dcache.c
index ad4a542e9bab..976896d39283 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -3616,8 +3616,10 @@ static void __init dcache_init(void)
 	 * but it is probably not worth it because of the cache nature
 	 * of the dcache. 
 	 */
+	/* FIXME: this shouldn't need SLAB_USERCOPY. */
 	dentry_cache = KMEM_CACHE(dentry,
-		SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|SLAB_MEM_SPREAD|SLAB_ACCOUNT);
+		SLAB_USERCOPY | SLAB_RECLAIM_ACCOUNT | SLAB_PANIC |
+		SLAB_MEM_SPREAD | SLAB_ACCOUNT);
 
 	/* Hash may have been set up in dcache_init_early */
 	if (!hashdist)
@@ -3653,7 +3655,7 @@ void __init vfs_caches_init_early(void)
 void __init vfs_caches_init(void)
 {
 	names_cachep = kmem_cache_create("names_cache", PATH_MAX, 0,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_USERCOPY, NULL);
 
 	dcache_init();
 	inode_init();
diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index cec8814a3b8b..9f1b2a24e779 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -898,7 +898,7 @@ static int __init init_jfs_fs(void)
 
 	jfs_inode_cachep =
 	    kmem_cache_create("jfs_ip", sizeof(struct jfs_inode_info), 0,
-			    SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD|SLAB_ACCOUNT,
+			    SLAB_USERCOPY|SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD|SLAB_ACCOUNT,
 			    init_once);
 	if (jfs_inode_cachep == NULL)
 		return -ENOMEM;
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 570383a41853..2c9f70a69561 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -41,6 +41,7 @@ struct vm_area_struct;
 #define ___GFP_OTHER_NODE	0x800000u
 #define ___GFP_WRITE		0x1000000u
 #define ___GFP_KSWAPD_RECLAIM	0x2000000u
+#define ___GFP_USERCOPY		0x4000000u
 /* If the above are modified, __GFP_BITS_SHIFT may need updating */
 
 /*
@@ -86,6 +87,7 @@ struct vm_area_struct;
 #define __GFP_HARDWALL   ((__force gfp_t)___GFP_HARDWALL)
 #define __GFP_THISNODE	((__force gfp_t)___GFP_THISNODE)
 #define __GFP_ACCOUNT	((__force gfp_t)___GFP_ACCOUNT)
+#define __GFP_USERCOPY	((__force gfp_t)___GFP_USERCOPY)
 
 /*
  * Watermark modifiers -- controls access to emergency reserves
@@ -188,7 +190,7 @@ struct vm_area_struct;
 #define __GFP_OTHER_NODE ((__force gfp_t)___GFP_OTHER_NODE)
 
 /* Room for N __GFP_FOO bits */
-#define __GFP_BITS_SHIFT 26
+#define __GFP_BITS_SHIFT 27
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
 
 /*
@@ -258,6 +260,7 @@ struct vm_area_struct;
 #define GFP_TRANSHUGE	((GFP_HIGHUSER_MOVABLE | __GFP_COMP | \
 			 __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN) & \
 			 ~__GFP_RECLAIM)
+#define GFP_USERCOPY	__GFP_USERCOPY
 
 /* Convert GFP flags to their corresponding migrate type */
 #define GFP_MOVABLE_MASK (__GFP_RECLAIMABLE|__GFP_MOVABLE)
diff --git a/include/linux/slab.h b/include/linux/slab.h
index 5c0cd75b2d07..59cc29ef4cd1 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -21,6 +21,7 @@
  * The ones marked DEBUG are only valid if CONFIG_DEBUG_SLAB is set.
  */
 #define SLAB_CONSISTENCY_CHECKS	0x00000100UL	/* DEBUG: Perform (expensive) checks on alloc/free */
+#define SLAB_USERCOPY		0x00000200UL	/* USERCOPY: Allow copying objs to/from userspace */
 #define SLAB_RED_ZONE		0x00000400UL	/* DEBUG: Red zone objs in a cache */
 #define SLAB_POISON		0x00000800UL	/* DEBUG: Poison objects */
 #define SLAB_HWCACHE_ALIGN	0x00002000UL	/* Align objs on cache lines */
diff --git a/kernel/fork.c b/kernel/fork.c
index 5c2c355aa97f..2b09fc076dea 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -197,7 +197,7 @@ static void free_thread_info(struct thread_info *ti)
 void thread_info_cache_init(void)
 {
 	thread_info_cache = kmem_cache_create("thread_info", THREAD_SIZE,
-					      THREAD_SIZE, 0, NULL);
+					      THREAD_SIZE, SLAB_USERCOPY, NULL);
 	BUG_ON(thread_info_cache == NULL);
 }
 # endif
diff --git a/mm/slab.c b/mm/slab.c
index 4cb2e5408625..b3fbdd6ac027 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1354,7 +1354,8 @@ void __init kmem_cache_init(void)
 	 * structures first.  Without this, further allocations will bug.
 	 */
 	kmalloc_caches[INDEX_NODE] = create_kmalloc_cache("kmalloc-node",
-				kmalloc_size(INDEX_NODE), ARCH_KMALLOC_FLAGS);
+				kmalloc_size(INDEX_NODE),
+				SLAB_USERCOPY | ARCH_KMALLOC_FLAGS);
 	slab_state = PARTIAL_NODE;
 	setup_kmalloc_cache_index_table();
 
@@ -4482,6 +4483,7 @@ module_init(slab_proc_init);
  * Rejects objects that are:
  * - NULL or zero-allocated
  * - incorrectly sized
+ * - not marked with SLAB_USERCOPY
  *
  * Returns NULL if check passes, otherwise const char * to name of cache
  * to indicate an error.
@@ -4494,6 +4496,10 @@ const char *__check_heap_object(const void *ptr, unsigned long n,
 	unsigned long offset;
 
 	cachep = page->slab_cache;
+#ifdef CONFIG_HARDENED_USERCOPY_WHITELIST
+	if (!(cachep->flags & SLAB_USERCOPY))
+		return cachep->name;
+#endif
 
 	objnr = obj_to_index(cachep, page, (void *)ptr);
 	BUG_ON(objnr >= cachep->num);
diff --git a/mm/slab.h b/mm/slab.h
index dedb1a920fb8..db29e111902b 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -119,7 +119,8 @@ static inline unsigned long kmem_cache_flags(unsigned long object_size,
 
 /* Legal flag mask for kmem_cache_create(), for various configurations */
 #define SLAB_CORE_FLAGS (SLAB_HWCACHE_ALIGN | SLAB_CACHE_DMA | SLAB_PANIC | \
-			 SLAB_DESTROY_BY_RCU | SLAB_DEBUG_OBJECTS )
+			 SLAB_DESTROY_BY_RCU | SLAB_DEBUG_OBJECTS | \
+			 SLAB_USERCOPY)
 
 #if defined(CONFIG_DEBUG_SLAB)
 #define SLAB_DEBUG_FLAGS (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER)
diff --git a/mm/slab_common.c b/mm/slab_common.c
index a65dad7fdcd1..f3f6ae3f56fc 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -967,7 +967,7 @@ void __init create_kmalloc_caches(unsigned long flags)
 
 	for (i = KMALLOC_SHIFT_LOW; i <= KMALLOC_SHIFT_HIGH; i++) {
 		if (!kmalloc_caches[i])
-			new_kmalloc_cache(i, flags);
+			new_kmalloc_cache(i, SLAB_USERCOPY | flags);
 
 		/*
 		 * Caches that are not of the two-to-the-power-of size.
@@ -975,9 +975,9 @@ void __init create_kmalloc_caches(unsigned long flags)
 		 * earlier power of two caches
 		 */
 		if (KMALLOC_MIN_SIZE <= 32 && !kmalloc_caches[1] && i == 6)
-			new_kmalloc_cache(1, flags);
+			new_kmalloc_cache(1, SLAB_USERCOPY | flags);
 		if (KMALLOC_MIN_SIZE <= 64 && !kmalloc_caches[2] && i == 7)
-			new_kmalloc_cache(2, flags);
+			new_kmalloc_cache(2, SLAB_USERCOPY | flags);
 	}
 
 	/* Kmalloc array is now usable */
diff --git a/mm/slub.c b/mm/slub.c
index 83d3cbc7adf8..589f0ffe712b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3622,6 +3622,10 @@ const char *__check_heap_object(const void *ptr, unsigned long n,
 	unsigned long offset;
 
 	s = page->slab_cache;
+#ifdef CONFIG_HARDENED_USERCOPY_WHITELIST
+	if (!(s->flags & SLAB_USERCOPY))
+		return s->name;
+#endif
 
 	offset = (ptr - page_address(page)) % s->size;
 	if (offset <= s->object_size && n <= s->object_size - offset)
diff --git a/net/decnet/af_decnet.c b/net/decnet/af_decnet.c
index 13d6b1a6e0fc..0ac2a9bd18f3 100644
--- a/net/decnet/af_decnet.c
+++ b/net/decnet/af_decnet.c
@@ -466,6 +466,7 @@ static struct proto dn_proto = {
 	.sysctl_rmem		= sysctl_decnet_rmem,
 	.max_header		= DN_MAX_NSP_DATA_HEADER + 64,
 	.obj_size		= sizeof(struct dn_sock),
+	.slab_flags		= SLAB_USERCOPY,
 };
 
 static struct sock *dn_alloc_sock(struct net *net, struct socket *sock, gfp_t gfp, int kern)
diff --git a/security/Kconfig b/security/Kconfig
index 081607a5e078..0ec17a252e49 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -129,6 +129,16 @@ config HARDENED_USERCOPY
 	  This kills entire classes of heap overflows and similar
 	  kernel memory exposures.
 
+config HARDENED_USERCOPY_WHITELIST
+	bool "Whiltelist heap memory that is allow to be user-copied"
+	default HARDENED_USERCOPY
+	help
+	  This option adds checking for kernel memory being whitelisted
+	  as "expected to be copied to/from userspace", via the
+	  SLAB_USERCOPY flag. This greatly reduces the areas of kernel
+	  memory that an attack has access to through bugs in interfaces
+	  that use copy_to_user() and copy_from_user().
+
 source security/selinux/Kconfig
 source security/smack/Kconfig
 source security/tomoyo/Kconfig
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 02e98f3131bd..2178fd2b87b9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3752,7 +3752,7 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	if (!vcpu_align)
 		vcpu_align = __alignof__(struct kvm_vcpu);
 	kvm_vcpu_cache = kmem_cache_create("kvm_vcpu", vcpu_size, vcpu_align,
-					   0, NULL);
+					   SLAB_USERCOPY, NULL);
 	if (!kvm_vcpu_cache) {
 		r = -ENOMEM;
 		goto out_free_3;
-- 
2.7.4
