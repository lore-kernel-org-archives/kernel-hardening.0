Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 9 Jun 2016 19:39:27 -0400
From: Rik van Riel <riel@redhat.com>
Message-ID: <20160609193927.2f03f128@annuminas.surriel.com>
In-Reply-To: <1465420302-23754-1-git-send-email-keescook@chromium.org>
References: <1465420302-23754-1-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [RFC][PATCH 6/4] mm: disallow user copy to/from separately
 allocated pages
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey.schaufler@intel.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

This patch is some new functionality for the usercopy hardening
method. I hope it will be useful both to the mainline community
and the grsecurity community.

I have not figured out what to do about CMA yet, but that can
probably be done in a follow-up patch.

---8<---

Subject: mm: disallow user copy to/from separately allocated pages

A single copy_from_user or copy_to_user should go to or from a single
kernel object. Inside the slab, or on the stack, we can track the
individual objects.

For the general kernel heap, we do not know exactly where each object
is, but we can tell whether the whole range from ptr to ptr + n is
inside the same page, or inside the same compound page.

If the start and end of the "object" are in pages that were not allocated
together, we are likely dealing with an overflow from one object into
the next page, and should disallow this copy.

The kernel will have some objects that cross page boundaries in
sections like .rodata, .bss, etc.  Copying from those needs to be
allowed; they can be identified with PageReserved.

TODO: figure out what to do with CMA memory

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 mm/usercopy.c | 23 +++++++++++++++++++----
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/mm/usercopy.c b/mm/usercopy.c
index e09c33070759..be75d97c5d75 100644
--- a/mm/usercopy.c
+++ b/mm/usercopy.c
@@ -109,7 +109,7 @@ static inline bool check_kernel_text_object(const void *ptr, unsigned long n)
 
 static inline const char *check_heap_object(const void *ptr, unsigned long n)
 {
-	struct page *page;
+	struct page *page, *endpage;
 
 	if (ZERO_OR_NULL_PTR(ptr))
 		return "<null>";
@@ -118,11 +118,26 @@ static inline const char *check_heap_object(const void *ptr, unsigned long n)
 		return NULL;
 
 	page = virt_to_head_page(ptr);
-	if (!PageSlab(page))
+	if (PageSlab(page))
+		/* Check allocator for flags and size. */
+		return __check_heap_object(ptr, n, page);
+
+	/* Is the object wholly within one base page? Great. */
+	if (likely(((unsigned long)ptr & (unsigned long)PAGE_MASK) ==
+		   ((unsigned long)(ptr + n - 1) & (unsigned long)PAGE_MASK)))
+		return NULL;
+
+	/* Are the start and end inside the same compound page? Great. */
+	endpage = virt_to_head_page(ptr + n - 1);
+	if (likely(endpage == page))
+		return NULL;
+
+	/* Is this a special area, eg. .rodata, .bss, or device memory? */
+	if (PageReserved(page) && PageReserved(endpage))
 		return NULL;
 
-	/* Check allocator for flags and size. */
-	return __check_heap_object(ptr, n, page);
+	/* Uh oh. The "object" spans several independently allocated pages. */
+	return "<spans multiple pages>";
 }
 
 /*
