From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v2 1/8] mm: Add kernel-doc for kvfree
Date: Wed, 14 Feb 2018 12:11:47 -0800
Message-Id: <20180214201154.10186-2-willy@infradead.org>
In-Reply-To: <20180214201154.10186-1-willy@infradead.org>
References: <20180214201154.10186-1-willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-mm@kvack.org, Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Joe Perches <joe@perches.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Matthew Wilcox <mawilcox@microsoft.com>

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/util.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/util.c b/mm/util.c
index c1250501364f..dc4c7b551aaf 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -430,6 +430,16 @@ void *kvmalloc_node(size_t size, gfp_t flags, int node)
 }
 EXPORT_SYMBOL(kvmalloc_node);
 
+/**
+ * kvfree() - Free memory.
+ * @addr: Pointer to allocated memory.
+ *
+ * kvfree frees memory allocated by any of vmalloc(), kmalloc() or
+ * kvmalloc().  It is slightly more efficient to use kfree() or vfree()
+ * if you are certain that you know which one to use.
+ *
+ * Context: Any context except NMI.
+ */
 void kvfree(const void *addr)
 {
 	if (is_vmalloc_addr(addr))
-- 
2.15.1
