From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 5/6] Convert jffs2 acl to struct_size
Date: Thu,  7 Jun 2018 07:57:19 -0700
Message-Id: <20180607145720.22590-6-willy@infradead.org>
In-Reply-To: <20180607145720.22590-1-willy@infradead.org>
References: <20180607145720.22590-1-willy@infradead.org>
To: Kees Cook <keescook@chromium.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

From: Matthew Wilcox <mawilcox@microsoft.com>

Need to tell the compiler that the acl entries follow the acl header.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/jffs2/acl.c | 3 ++-
 fs/jffs2/acl.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/jffs2/acl.c b/fs/jffs2/acl.c
index 7ebacf14837f..093ffbd82395 100644
--- a/fs/jffs2/acl.c
+++ b/fs/jffs2/acl.c
@@ -133,7 +133,8 @@ static void *jffs2_acl_to_medium(const struct posix_acl *acl, size_t *size)
 	size_t i;
 
 	*size = jffs2_acl_size(acl->a_count);
-	header = kmalloc(sizeof(*header) + acl->a_count * sizeof(*entry), GFP_KERNEL);
+	header = kmalloc(struct_size(header, a_entries, acl->a_count),
+			GFP_KERNEL);
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
2.17.0
