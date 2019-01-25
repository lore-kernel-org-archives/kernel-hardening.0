From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH] mm: Prevent mapping slab pages to userspace
Date: Fri, 25 Jan 2019 09:38:27 -0800
Message-Id: <20190125173827.2658-1-willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Rik van Riel <riel@surriel.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Michael Ellerman <mpe@ellerman.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

It's never appropriate to map a page allocated by SLAB into userspace.
A buggy device driver might try this, or an attacker might be able to
find a way to make it happen.

Signed-off-by: Matthew Wilcox <willy@infradead.org>
---
 mm/memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index e11ca9dd823f..ce8c90b752be 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1451,7 +1451,7 @@ static int insert_page(struct vm_area_struct *vma, unsigned long addr,
 	spinlock_t *ptl;
 
 	retval = -EINVAL;
-	if (PageAnon(page))
+	if (PageAnon(page) || PageSlab(page))
 		goto out;
 	retval = -ENOMEM;
 	flush_dcache_page(page);
-- 
2.20.1
