From: Kees Cook <keescook@chromium.org>
Date: Mon, 19 Jun 2017 16:36:22 -0700
Message-Id: <1497915397-93805-9-git-send-email-keescook@chromium.org>
In-Reply-To: <1497915397-93805-1-git-send-email-keescook@chromium.org>
References: <1497915397-93805-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 08/23] ext2: define usercopy region in ext2_inode_cache slab cache
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, David Windsor <dave@nullcore.net>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

From: David Windsor <dave@nullcore.net>

The ext2 symlink pathnames, stored in struct ext2_inode_info.i_data
and therefore contained in the ext2_inode_cache slab cache, need to be
copied to/from userspace.

In support of usercopy hardening, this patch defines a region in
the ext2_inode_cache slab cache in which userspace copy operations
are allowed.

This region is known as the slab cache's usercopy region.  Slab
caches can now check that each copy operation involving cache-managed
memory falls entirely within the slab's usercopy region.

This patch is modified from Brad Spengler/PaX Team's PAX_USERCOPY
whitelisting code in the last public patch of grsecurity/PaX based on my
understanding of the code. Changes or omissions from the original code are
mine and don't reflect the original grsecurity/PaX code.

Signed-off-by: David Windsor <dave@nullcore.net>
[kees: adjust commit log]
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/ext2/super.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 9c2028b50e5c..3e2aa21bc616 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -219,11 +219,13 @@ static void init_once(void *foo)
 
 static int __init init_inodecache(void)
 {
-	ext2_inode_cachep = kmem_cache_create("ext2_inode_cache",
-					     sizeof(struct ext2_inode_info),
-					     0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD|SLAB_ACCOUNT),
-					     init_once);
+	ext2_inode_cachep = kmem_cache_create_usercopy("ext2_inode_cache",
+				sizeof(struct ext2_inode_info), 0,
+				(SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD|
+					SLAB_ACCOUNT),
+				offsetof(struct ext2_inode_info, i_data),
+				sizeof_field(struct ext2_inode_info, i_data),
+				init_once);
 	if (ext2_inode_cachep == NULL)
 		return -ENOMEM;
 	return 0;
-- 
2.7.4
