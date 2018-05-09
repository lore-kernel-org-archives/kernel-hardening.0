From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 05/13] mm: Use array_size() helpers for kvmalloc()
Date: Tue,  8 May 2018 17:42:21 -0700
Message-Id: <20180509004229.36341-6-keescook@chromium.org>
In-Reply-To: <20180509004229.36341-1-keescook@chromium.org>
References: <20180509004229.36341-1-keescook@chromium.org>
To: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Kees Cook <keescook@chromium.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Instead of open-coded multiplication, use the new array_size() helper
to detect overflow in kvmalloc()-family functions.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/mm.h      | 6 +++---
 include/linux/vmalloc.h | 1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1ac1f06a4be6..c97ed9aa3412 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -25,6 +25,7 @@
 #include <linux/err.h>
 #include <linux/page_ref.h>
 #include <linux/memremap.h>
+#include <linux/overflow.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -560,10 +561,9 @@ static inline void *kvzalloc(size_t size, gfp_t flags)
 
 static inline void *kvmalloc_array(size_t n, size_t size, gfp_t flags)
 {
-	if (size != 0 && n > SIZE_MAX / size)
-		return NULL;
+	size_t bytes = array_size(n, size);
 
-	return kvmalloc(n * size, flags);
+	return kvmalloc(bytes, flags);
 }
 
 extern void kvfree(const void *addr);
diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 1e5d8c392f15..398e9c95cd61 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -8,6 +8,7 @@
 #include <linux/llist.h>
 #include <asm/page.h>		/* pgprot_t */
 #include <linux/rbtree.h>
+#include <linux/overflow.h>
 
 struct vm_area_struct;		/* vma defining user mapping in mm_types.h */
 struct notifier_block;		/* in notifier.h */
-- 
2.17.0
