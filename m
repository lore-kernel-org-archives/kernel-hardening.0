From: Kees Cook <keescook@chromium.org>
Date: Mon, 19 Jun 2017 16:36:26 -0700
Message-Id: <1497915397-93805-13-git-send-email-keescook@chromium.org>
In-Reply-To: <1497915397-93805-1-git-send-email-keescook@chromium.org>
References: <1497915397-93805-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 12/23] orangefs: define usercopy region in orangefs_inode_cache slab cache
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, David Windsor <dave@nullcore.net>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

From: David Windsor <dave@nullcore.net>

The orangefs symlink pathnames, stored in struct orangefs_inode_s.link_target
and therefore contained in the orangefs_inode_cache, need to be copied
to/from userspace.

In support of usercopy hardening, this patch defines a region in
the orangefs_inode_cache slab cache in which userspace copy operations
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
 fs/orangefs/super.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/orangefs/super.c b/fs/orangefs/super.c
index 5c7c273e17ec..0dddfc264aca 100644
--- a/fs/orangefs/super.c
+++ b/fs/orangefs/super.c
@@ -613,11 +613,16 @@ void orangefs_kill_sb(struct super_block *sb)
 
 int orangefs_inode_cache_initialize(void)
 {
-	orangefs_inode_cache = kmem_cache_create("orangefs_inode_cache",
-					      sizeof(struct orangefs_inode_s),
-					      0,
-					      ORANGEFS_CACHE_CREATE_FLAGS,
-					      orangefs_inode_cache_ctor);
+	orangefs_inode_cache = kmem_cache_create_usercopy(
+					"orangefs_inode_cache",
+					sizeof(struct orangefs_inode_s),
+					0,
+					ORANGEFS_CACHE_CREATE_FLAGS,
+					offsetof(struct orangefs_inode_s,
+						link_target),
+					sizeof_field(struct orangefs_inode_s,
+						link_target),
+					orangefs_inode_cache_ctor);
 
 	if (!orangefs_inode_cache) {
 		gossip_err("Cannot create orangefs_inode_cache\n");
-- 
2.7.4
