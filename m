From: Kees Cook <keescook@chromium.org>
Date: Mon, 19 Jun 2017 16:36:20 -0700
Message-Id: <1497915397-93805-7-git-send-email-keescook@chromium.org>
In-Reply-To: <1497915397-93805-1-git-send-email-keescook@chromium.org>
References: <1497915397-93805-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 06/23] cifs: define usercopy region in cifs_request slab cache
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, David Windsor <dave@nullcore.net>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

From: David Windsor <dave@nullcore.net>

cifs request buffers, stored in the cifs_request slab cache,
need to be copied to/from userspace.

In support of usercopy hardening, this patch defines a region in
the cifs_request slab cache in which userspace copy operations
are allowed.

This region is known as the slab cache's usercopy region.  Slab
caches can now check that each copy operation involving cache-managed
memory falls entirely within the slab's usercopy region.

This patch is verbatim from Brad Spengler/PaX Team's PAX_USERCOPY
whitelisting code in the last public patch of grsecurity/PaX based on my
understanding of the code. Changes or omissions from the original code are
mine and don't reflect the original grsecurity/PaX code.

Signed-off-by: David Windsor <dave@nullcore.net>
[kees: adjust commit log]
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/cifs/cifsfs.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 9a1667e0e8d6..385c5cc8903e 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1234,9 +1234,11 @@ cifs_init_request_bufs(void)
 	cifs_dbg(VFS, "CIFSMaxBufSize %d 0x%x\n",
 		 CIFSMaxBufSize, CIFSMaxBufSize);
 */
-	cifs_req_cachep = kmem_cache_create("cifs_request",
+	cifs_req_cachep = kmem_cache_create_usercopy("cifs_request",
 					    CIFSMaxBufSize + max_hdr_size, 0,
-					    SLAB_HWCACHE_ALIGN, NULL);
+					    SLAB_HWCACHE_ALIGN, 0,
+					    CIFSMaxBufSize + max_hdr_size,
+					    NULL);
 	if (cifs_req_cachep == NULL)
 		return -ENOMEM;
 
@@ -1262,9 +1264,9 @@ cifs_init_request_bufs(void)
 	more SMBs to use small buffer alloc and is still much more
 	efficient to alloc 1 per page off the slab compared to 17K (5page)
 	alloc of large cifs buffers even when page debugging is on */
-	cifs_sm_req_cachep = kmem_cache_create("cifs_small_rq",
+	cifs_sm_req_cachep = kmem_cache_create_usercopy("cifs_small_rq",
 			MAX_CIFS_SMALL_BUFFER_SIZE, 0, SLAB_HWCACHE_ALIGN,
-			NULL);
+			0, MAX_CIFS_SMALL_BUFFER_SIZE, NULL);
 	if (cifs_sm_req_cachep == NULL) {
 		mempool_destroy(cifs_req_poolp);
 		kmem_cache_destroy(cifs_req_cachep);
-- 
2.7.4
