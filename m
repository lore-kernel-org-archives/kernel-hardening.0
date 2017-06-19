From: Kees Cook <keescook@chromium.org>
Date: Mon, 19 Jun 2017 16:36:24 -0700
Message-Id: <1497915397-93805-11-git-send-email-keescook@chromium.org>
In-Reply-To: <1497915397-93805-1-git-send-email-keescook@chromium.org>
References: <1497915397-93805-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 10/23] vxfs: define usercopy region in vxfs_inode slab cache
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, David Windsor <dave@nullcore.net>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

From: David Windsor <dave@nullcore.net>

The vxfs symlink pathnames, stored in struct vxfs_inode_info.vii_immed.vi_immed
and therefore contained in the vxfs_inode slab cache, need to be copied
to/from userspace.

In support of usercopy hardening, this patch defines a region in
the vxfs_inode slab cache in which userspace copy operations
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
 fs/freevxfs/vxfs_super.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/freevxfs/vxfs_super.c b/fs/freevxfs/vxfs_super.c
index 455ce5b77e9b..c143e18d5a65 100644
--- a/fs/freevxfs/vxfs_super.c
+++ b/fs/freevxfs/vxfs_super.c
@@ -332,9 +332,13 @@ vxfs_init(void)
 {
 	int rv;
 
-	vxfs_inode_cachep = kmem_cache_create("vxfs_inode",
+	vxfs_inode_cachep = kmem_cache_create_usercopy("vxfs_inode",
 			sizeof(struct vxfs_inode_info), 0,
-			SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD, NULL);
+			SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD,
+			offsetof(struct vxfs_inode_info, vii_immed.vi_immed),
+			sizeof_field(struct vxfs_inode_info,
+				vii_immed.vi_immed),
+			NULL);
 	if (!vxfs_inode_cachep)
 		return -ENOMEM;
 	rv = register_filesystem(&vxfs_fs_type);
-- 
2.7.4
