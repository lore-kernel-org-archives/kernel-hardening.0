From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH] mm: Prevent mapping typed pages to userspace
Date: Mon, 28 Jan 2019 21:38:30 -0800
Message-Id: <20190129053830.3749-1-willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Michael Ellerman <mpe@ellerman.id.au>, Will Deacon <will.deacon@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

Pages which use page_type must never be mapped to userspace as it would
destroy their page type.  Add an explicit check for this instead of
assuming that kernel drivers always get this right.

Signed-off-by: Matthew Wilcox <willy@infradead.org>
---
 mm/memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index ce8c90b752be..db3534bbd652 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1451,7 +1451,7 @@ static int insert_page(struct vm_area_struct *vma, unsigned long addr,
 	spinlock_t *ptl;
 
 	retval = -EINVAL;
-	if (PageAnon(page) || PageSlab(page))
+	if (PageAnon(page) || PageSlab(page) || page_has_type(page))
 		goto out;
 	retval = -ENOMEM;
 	flush_dcache_page(page);
-- 
2.20.1
