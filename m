From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v2 8/8] Convert jffs2 acl to kvzalloc_struct
Date: Wed, 14 Feb 2018 12:11:54 -0800
Message-Id: <20180214201154.10186-9-willy@infradead.org>
In-Reply-To: <20180214201154.10186-1-willy@infradead.org>
References: <20180214201154.10186-1-willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-mm@kvack.org, Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Joe Perches <joe@perches.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Matthew Wilcox <mawilcox@microsoft.com>

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/jffs2/acl.c | 3 ++-
 fs/jffs2/acl.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/jffs2/acl.c b/fs/jffs2/acl.c
index 7ebacf14837f..9df7feffd6ea 100644
--- a/fs/jffs2/acl.c
+++ b/fs/jffs2/acl.c
@@ -13,6 +13,7 @@
 
 #include <linux/kernel.h>
 #include <linux/slab.h>
+#include <linux/mm.h>
 #include <linux/fs.h>
 #include <linux/sched.h>
 #include <linux/time.h>
@@ -133,7 +134,7 @@ static void *jffs2_acl_to_medium(const struct posix_acl *acl, size_t *size)
 	size_t i;
 
 	*size = jffs2_acl_size(acl->a_count);
-	header = kmalloc(sizeof(*header) + acl->a_count * sizeof(*entry), GFP_KERNEL);
+	header = kvzalloc_struct(header, a_entries, acl->a_count, GFP_KERNEL);
 	if (!header)
 		return ERR_PTR(-ENOMEM);
 	header->a_version = cpu_to_je32(JFFS2_ACL_VERSION);
diff --git a/fs/jffs2/acl.h b/fs/jffs2/acl.h
index 2e2b5745c3b7..12d0271bdde3 100644
--- a/fs/jffs2/acl.h
+++ b/fs/jffs2/acl.h
@@ -22,6 +22,7 @@ struct jffs2_acl_entry_short {
 
 struct jffs2_acl_header {
 	jint32_t	a_version;
+	struct jffs2_acl_entry	a_entries[];
 };
 
 #ifdef CONFIG_JFFS2_FS_POSIX_ACL
-- 
2.15.1
