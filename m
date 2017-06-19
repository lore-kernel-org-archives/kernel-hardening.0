From: Kees Cook <keescook@chromium.org>
Date: Mon, 19 Jun 2017 16:36:27 -0700
Message-Id: <1497915397-93805-14-git-send-email-keescook@chromium.org>
In-Reply-To: <1497915397-93805-1-git-send-email-keescook@chromium.org>
References: <1497915397-93805-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 13/23] ufs: define usercopy region in ufs_inode_cache slab cache
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, David Windsor <dave@nullcore.net>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

From: David Windsor <dave@nullcore.net>

The ufs symlink pathnames, stored in struct ufs_inode_info.i_u1.i_symlink
and therefore contained in the ufs_inode_cache slab cache, need to be copied
to/from userspace.

In support of usercopy hardening, this patch defines a region in the
ufs_inode_cache slab cache in which userspace copy operations are allowed.

This region is known as the slab cache's usercopy region.  Slab caches can
now check that each copy operation involving cache-managed memory falls
entirely within the slab's usercopy region.

This patch is modified from Brad Spengler/PaX Team's PAX_USERCOPY
whitelisting code in the last public patch of grsecurity/PaX based on my
understanding of the code. Changes or omissions from the original code are
mine and don't reflect the original grsecurity/PaX code.

Signed-off-by: David Windsor <dave@nullcore.net>
[kees: adjust commit log]
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/ufs/super.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index 878cc6264f1a..fa001feed14a 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -1441,11 +1441,14 @@ static void init_once(void *foo)
 
 static int __init init_inodecache(void)
 {
-	ufs_inode_cachep = kmem_cache_create("ufs_inode_cache",
-					     sizeof(struct ufs_inode_info),
-					     0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD|SLAB_ACCOUNT),
-					     init_once);
+	ufs_inode_cachep = kmem_cache_create_usercopy("ufs_inode_cache",
+				sizeof(struct ufs_inode_info), 0,
+				(SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD|
+					SLAB_ACCOUNT),
+				offsetof(struct ufs_inode_info, i_u1.i_symlink),
+				sizeof_field(struct ufs_inode_info,
+					i_u1.i_symlink),
+				init_once);
 	if (ufs_inode_cachep == NULL)
 		return -ENOMEM;
 	return 0;
-- 
2.7.4
