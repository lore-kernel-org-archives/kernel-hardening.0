From: Kees Cook <keescook@chromium.org>
Date: Mon, 19 Jun 2017 16:36:17 -0700
Message-Id: <1497915397-93805-4-git-send-email-keescook@chromium.org>
In-Reply-To: <1497915397-93805-1-git-send-email-keescook@chromium.org>
References: <1497915397-93805-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 03/23] vfs: define usercopy region in names_cache slab caches
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, David Windsor <dave@nullcore.net>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

From: David Windsor <dave@nullcore.net>

vfs pathnames stored internally in inodes and contained in
the names_cache slab cache need to be copied to/from userspace.

In support of usercopy hardening, this patch defines the entire
cache object in the names_cache slab cache as whitelisted, since
it holds name strings to be copied to userspace.

This patch is verbatim from Brad Spengler/PaX Team's PAX_USERCOPY
whitelisting code in the last public patch of grsecurity/PaX based on my
understanding of the code. Changes or omissions from the original code are
mine and don't reflect the original grsecurity/PaX code.

Signed-off-by: David Windsor <dave@nullcore.net>
[kees: adjust commit log]
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/dcache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index cddf39777835..f7f3c4114baa 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -3616,8 +3616,8 @@ void __init vfs_caches_init_early(void)
 
 void __init vfs_caches_init(void)
 {
-	names_cachep = kmem_cache_create("names_cache", PATH_MAX, 0,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
+	names_cachep = kmem_cache_create_usercopy("names_cache", PATH_MAX, 0,
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC, 0, PATH_MAX, NULL);
 
 	dcache_init();
 	inode_init();
-- 
2.7.4
