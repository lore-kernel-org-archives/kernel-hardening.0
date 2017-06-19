From: Kees Cook <keescook@chromium.org>
Date: Mon, 19 Jun 2017 16:36:33 -0700
Message-Id: <1497915397-93805-20-git-send-email-keescook@chromium.org>
In-Reply-To: <1497915397-93805-1-git-send-email-keescook@chromium.org>
References: <1497915397-93805-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 19/23] xfs: define usercopy region in xfs_inode slab cache
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, David Windsor <dave@nullcore.net>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

From: David Windsor <dave@nullcore.net>

XFS inline inode data, stored in struct xfs_inode_t.i_df.if_u2.if_inline_data
and therefore contained in the xfs_inode slab cache, needs to be copied
to/from userspace.

In support of usercopy hardening, this patch defines a region in
the xfs_inode slab cache in which userspace copy operations
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
 fs/xfs/kmem.h      | 10 ++++++++++
 fs/xfs/xfs_super.c |  7 +++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
index d6ea520162b2..b3f02b6226b3 100644
--- a/fs/xfs/kmem.h
+++ b/fs/xfs/kmem.h
@@ -100,6 +100,16 @@ kmem_zone_init_flags(int size, char *zone_name, unsigned long flags,
 	return kmem_cache_create(zone_name, size, 0, flags, construct);
 }
 
+static inline kmem_zone_t *
+kmem_zone_init_flags_usercopy(int size, char *zone_name, unsigned long flags,
+				size_t useroffset, size_t usersize,
+				void (*construct)(void *))
+{
+	return kmem_cache_create_usercopy(zone_name, size, 0, flags,
+				useroffset, usersize, construct);
+}
+
+
 static inline void
 kmem_zone_free(kmem_zone_t *zone, void *ptr)
 {
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 455a575f101d..b6963baa3ac8 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1828,9 +1828,12 @@ xfs_init_zones(void)
 		goto out_destroy_efd_zone;
 
 	xfs_inode_zone =
-		kmem_zone_init_flags(sizeof(xfs_inode_t), "xfs_inode",
+		kmem_zone_init_flags_usercopy(sizeof(xfs_inode_t), "xfs_inode",
 			KM_ZONE_HWALIGN | KM_ZONE_RECLAIM | KM_ZONE_SPREAD |
-			KM_ZONE_ACCOUNT, xfs_fs_inode_init_once);
+				KM_ZONE_ACCOUNT,
+			offsetof(xfs_inode_t, i_df.if_u2.if_inline_data),
+			sizeof_field(xfs_inode_t, i_df.if_u2.if_inline_data),
+			xfs_fs_inode_init_once);
 	if (!xfs_inode_zone)
 		goto out_destroy_efi_zone;
 
-- 
2.7.4
