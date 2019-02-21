From: Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH v3 14/20] mm: Make hibernate handle unmapped pages
Date: Thu, 21 Feb 2019 15:44:45 -0800
Message-Id: <20190221234451.17632-15-rick.p.edgecombe@intel.com>
In-Reply-To: <20190221234451.17632-1-rick.p.edgecombe@intel.com>
References: <20190221234451.17632-1-rick.p.edgecombe@intel.com>
To: Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, linux_dti@icloud.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, akpm@linux-foundation.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, will.deacon@arm.com, ard.biesheuvel@linaro.org, kristen@linux.intel.com, deneen.t.dock@intel.com, Rick Edgecombe <rick.p.edgecombe@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>
List-ID: <kernel-hardening.lists.openwall.com>

Make hibernate handle unmapped pages on the direct map when
CONFIG_ARCH_HAS_SET_ALIAS is set. These functions allow for setting pages
to invalid configurations, so now hibernate should check if the pages have
valid mappings and handle if they are unmapped when doing a hibernate
save operation.

Previously this checking was already done when CONFIG_DEBUG_PAGEALLOC
was configured. It does not appear to have a big hibernating performance
impact. The speed of the saving operation before this change was measured
as 819.02 MB/s, and after was measured at 813.32 MB/s.

Before:
[    4.670938] PM: Wrote 171996 kbytes in 0.21 seconds (819.02 MB/s)

After:
[    4.504714] PM: Wrote 178932 kbytes in 0.22 seconds (813.32 MB/s)

Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Borislav Petkov <bp@alien8.de>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/mm/pageattr.c  |  4 ----
 include/linux/mm.h      | 18 ++++++------------
 kernel/power/snapshot.c |  5 +++--
 mm/page_alloc.c         |  7 +++++--
 4 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index fff9c91ad177..1cffee05f987 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -2257,7 +2257,6 @@ int set_direct_map_default_noflush(struct page *page)
 	return __set_pages_p(page, 1);
 }
 
-#ifdef CONFIG_DEBUG_PAGEALLOC
 void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
 	if (PageHighMem(page))
@@ -2302,11 +2301,8 @@ bool kernel_page_present(struct page *page)
 	pte = lookup_address((unsigned long)page_address(page), &level);
 	return (pte_val(*pte) & _PAGE_PRESENT);
 }
-
 #endif /* CONFIG_HIBERNATION */
 
-#endif /* CONFIG_DEBUG_PAGEALLOC */
-
 int __init kernel_map_pages_in_pgd(pgd_t *pgd, u64 pfn, unsigned long address,
 				   unsigned numpages, unsigned long page_flags)
 {
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 80bb6408fe73..5748e9ce133e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2642,37 +2642,31 @@ static inline void kernel_poison_pages(struct page *page, int numpages,
 					int enable) { }
 #endif
 
-#ifdef CONFIG_DEBUG_PAGEALLOC
 extern bool _debug_pagealloc_enabled;
-extern void __kernel_map_pages(struct page *page, int numpages, int enable);
 
 static inline bool debug_pagealloc_enabled(void)
 {
-	return _debug_pagealloc_enabled;
+	return IS_ENABLED(CONFIG_DEBUG_PAGEALLOC) && _debug_pagealloc_enabled;
 }
 
+#if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_ARCH_HAS_SET_DIRECT_MAP)
+extern void __kernel_map_pages(struct page *page, int numpages, int enable);
+
 static inline void
 kernel_map_pages(struct page *page, int numpages, int enable)
 {
-	if (!debug_pagealloc_enabled())
-		return;
-
 	__kernel_map_pages(page, numpages, enable);
 }
 #ifdef CONFIG_HIBERNATION
 extern bool kernel_page_present(struct page *page);
 #endif	/* CONFIG_HIBERNATION */
-#else	/* CONFIG_DEBUG_PAGEALLOC */
+#else	/* CONFIG_DEBUG_PAGEALLOC || CONFIG_ARCH_HAS_SET_DIRECT_MAP */
 static inline void
 kernel_map_pages(struct page *page, int numpages, int enable) {}
 #ifdef CONFIG_HIBERNATION
 static inline bool kernel_page_present(struct page *page) { return true; }
 #endif	/* CONFIG_HIBERNATION */
-static inline bool debug_pagealloc_enabled(void)
-{
-	return false;
-}
-#endif	/* CONFIG_DEBUG_PAGEALLOC */
+#endif	/* CONFIG_DEBUG_PAGEALLOC || CONFIG_ARCH_HAS_SET_DIRECT_MAP */
 
 #ifdef __HAVE_ARCH_GATE_AREA
 extern struct vm_area_struct *get_gate_vma(struct mm_struct *mm);
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 640b2034edd6..f69b2920d4f4 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1334,8 +1334,9 @@ static inline void do_copy_page(long *dst, long *src)
  * safe_copy_page - Copy a page in a safe way.
  *
  * Check if the page we are going to copy is marked as present in the kernel
- * page tables (this always is the case if CONFIG_DEBUG_PAGEALLOC is not set
- * and in that case kernel_page_present() always returns 'true').
+ * page tables. This always is the case if CONFIG_DEBUG_PAGEALLOC or
+ * CONFIG_ARCH_HAS_SET_DIRECT_MAP is not set. In that case kernel_page_present()
+ * always returns 'true'.
  */
 static void safe_copy_page(void *dst, struct page *s_page)
 {
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d295c9bc01a8..92d0a0934274 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1074,7 +1074,9 @@ static __always_inline bool free_pages_prepare(struct page *page,
 	}
 	arch_free_page(page, order);
 	kernel_poison_pages(page, 1 << order, 0);
-	kernel_map_pages(page, 1 << order, 0);
+	if (debug_pagealloc_enabled())
+		kernel_map_pages(page, 1 << order, 0);
+
 	kasan_free_nondeferred_pages(page, order);
 
 	return true;
@@ -1944,7 +1946,8 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 	set_page_refcounted(page);
 
 	arch_alloc_page(page, order);
-	kernel_map_pages(page, 1 << order, 1);
+	if (debug_pagealloc_enabled())
+		kernel_map_pages(page, 1 << order, 1);
 	kernel_poison_pages(page, 1 << order, 1);
 	kasan_alloc_pages(page, order);
 	set_page_owner(page, order, gfp_flags);
-- 
2.17.1
