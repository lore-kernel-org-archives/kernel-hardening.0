Return-Path: <SRS0=TM6g=KA=lists.openwall.com=kernel-hardening-return-21231-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31D4AC433B4
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 May 2021 00:33:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 47769613CB
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 May 2021 00:33:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 47769613CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21231-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13839 invoked by uid 550); 5 May 2021 00:32:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13543 invoked from network); 5 May 2021 00:32:44 -0000
IronPort-SDR: 0lFSaufe8oPSV5vDqCKSMYOxbreUAf5dKWnh7MOX5AmASpXzGwcbYxgYbcCPK7rFWJXMAthPGu
 jyZ7vO3WMqDA==
X-IronPort-AV: E=McAfee;i="6200,9189,9974"; a="262052477"
X-IronPort-AV: E=Sophos;i="5.82,273,1613462400"; 
   d="scan'208";a="262052477"
IronPort-SDR: n5FzI0DMWtZHqm16cE4XyBakjUGMbHRvOPkqq/nUBUeuUE55IKsspO+Ry/oUXbnS89HIhFAU9T
 vS+Sne504Erw==
X-IronPort-AV: E=Sophos;i="5.82,273,1613462400"; 
   d="scan'208";a="429490799"
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: dave.hansen@intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org,
	akpm@linux-foundation.org,
	linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Cc: ira.weiny@intel.com,
	rppt@kernel.org,
	dan.j.williams@intel.com,
	linux-kernel@vger.kernel.org,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH RFC 5/9] x86, mm: Use cache of page tables
Date: Tue,  4 May 2021 17:30:28 -0700
Message-Id: <20210505003032.489164-6-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505003032.489164-1-rick.p.edgecombe@intel.com>
References: <20210505003032.489164-1-rick.p.edgecombe@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change the page table allocation functions defined in pgalloc.h to use
a cache of physically grouped pages. This will let the page tables to be
set with PKS permissions later.

For userspace page tables, they are gathered up using mmu gather, and
freed along with other types of pages in swap.c. Reuse the PageTable
page flag to communicate that swap needs to return this page to the
cache of page tables, and not free it to the page allocator. Set this flag
in the free_tlb() family of functions called by mmu gather.

Do not set PKS permissions on the page tables, because the page table
setting functions cannot handle it yet. This will be done in later
patches.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/include/asm/pgalloc.h |  4 ++
 arch/x86/mm/pgtable.c          | 75 ++++++++++++++++++++++++++++++++++
 include/asm-generic/pgalloc.h  | 42 +++++++++++++++----
 include/linux/mm.h             |  7 ++++
 mm/swap.c                      |  7 ++++
 mm/swap_state.c                |  6 +++
 6 files changed, 132 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/pgalloc.h b/arch/x86/include/asm/pgalloc.h
index 62ad61d6fefc..e38b54853a51 100644
--- a/arch/x86/include/asm/pgalloc.h
+++ b/arch/x86/include/asm/pgalloc.h
@@ -7,6 +7,10 @@
 #include <linux/pagemap.h>
 
 #define __HAVE_ARCH_PTE_ALLOC_ONE
+#ifdef CONFIG_PKS_PG_TABLES
+#define __HAVE_ARCH_FREE_TABLE
+#define __HAVE_ARCH_ALLOC_TABLE
+#endif
 #define __HAVE_ARCH_PGD_FREE
 #include <asm-generic/pgalloc.h>
 
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index f6a9e2e36642..7ccd031d2384 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -6,12 +6,16 @@
 #include <asm/tlb.h>
 #include <asm/fixmap.h>
 #include <asm/mtrr.h>
+#include <asm/set_memory.h>
+#include <linux/page-flags.h>
 
 #ifdef CONFIG_DYNAMIC_PHYSICAL_MASK
 phys_addr_t physical_mask __ro_after_init = (1ULL << __PHYSICAL_MASK_SHIFT) - 1;
 EXPORT_SYMBOL(physical_mask);
 #endif
 
+static struct grouped_page_cache gpc_pks;
+static bool pks_page_en;
 #ifdef CONFIG_HIGHPTE
 #define PGTABLE_HIGHMEM __GFP_HIGHMEM
 #else
@@ -33,6 +37,46 @@ pgtable_t pte_alloc_one(struct mm_struct *mm)
 	return __pte_alloc_one(mm, __userpte_alloc_gfp);
 }
 
+#ifdef CONFIG_PKS_PG_TABLES
+struct page *alloc_table(gfp_t gfp)
+{
+	struct page *table;
+
+	if (!pks_page_en)
+		return alloc_page(gfp);
+
+	table = get_grouped_page(numa_node_id(), &gpc_pks);
+	if (!table)
+		return NULL;
+
+	if (gfp & __GFP_ZERO)
+		memset(page_address(table), 0, PAGE_SIZE);
+
+	if (memcg_kmem_enabled() &&
+	    gfp & __GFP_ACCOUNT &&
+	    !__memcg_kmem_charge_page(table, gfp, 0)) {
+		free_table(table);
+		table = NULL;
+	}
+
+	VM_BUG_ON_PAGE(*(unsigned long *)&table->ptl, table);
+
+	return table;
+}
+
+void free_table(struct page *table_page)
+{
+	if (!pks_page_en) {
+		__free_pages(table_page, 0);
+		return;
+	}
+
+	if (memcg_kmem_enabled() && PageMemcgKmem(table_page))
+		__memcg_kmem_uncharge_page(table_page, 0);
+	free_grouped_page(&gpc_pks, table_page);
+}
+#endif /* CONFIG_PKS_PG_TABLES */
+
 static int __init setup_userpte(char *arg)
 {
 	if (!arg)
@@ -54,6 +98,8 @@ void ___pte_free_tlb(struct mmu_gather *tlb, struct page *pte)
 {
 	pgtable_pte_page_dtor(pte);
 	paravirt_release_pte(page_to_pfn(pte));
+	/* Set Page Table so swap knows how to free it */
+	__SetPageTable(pte);
 	paravirt_tlb_remove_table(tlb, pte);
 }
 
@@ -70,12 +116,16 @@ void ___pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd)
 	tlb->need_flush_all = 1;
 #endif
 	pgtable_pmd_page_dtor(page);
+	/* Set Page Table so swap nows how to free it */
+	__SetPageTable(virt_to_page(pmd));
 	paravirt_tlb_remove_table(tlb, page);
 }
 
 #if CONFIG_PGTABLE_LEVELS > 3
 void ___pud_free_tlb(struct mmu_gather *tlb, pud_t *pud)
 {
+	/* Set Page Table so swap nows how to free it */
+	__SetPageTable(virt_to_page(pud));
 	paravirt_release_pud(__pa(pud) >> PAGE_SHIFT);
 	paravirt_tlb_remove_table(tlb, virt_to_page(pud));
 }
@@ -83,6 +133,8 @@ void ___pud_free_tlb(struct mmu_gather *tlb, pud_t *pud)
 #if CONFIG_PGTABLE_LEVELS > 4
 void ___p4d_free_tlb(struct mmu_gather *tlb, p4d_t *p4d)
 {
+	/* Set Page Table so swap nows how to free it */
+	__SetPageTable(virt_to_page(p4d));
 	paravirt_release_p4d(__pa(p4d) >> PAGE_SHIFT);
 	paravirt_tlb_remove_table(tlb, virt_to_page(p4d));
 }
@@ -411,12 +463,24 @@ static inline void _pgd_free(pgd_t *pgd)
 
 static inline pgd_t *_pgd_alloc(void)
 {
+	if (pks_page_en) {
+		struct page *page = alloc_table(GFP_PGTABLE_USER);
+
+		if (!page)
+			return NULL;
+		return page_address(page);
+	}
+
 	return (pgd_t *)__get_free_pages(GFP_PGTABLE_USER,
 					 PGD_ALLOCATION_ORDER);
 }
 
 static inline void _pgd_free(pgd_t *pgd)
 {
+	if (pks_page_en) {
+		free_table(virt_to_page(pgd));
+		return;
+	}
 	free_pages((unsigned long)pgd, PGD_ALLOCATION_ORDER);
 }
 #endif /* CONFIG_X86_PAE */
@@ -859,6 +923,17 @@ int pmd_free_pte_page(pmd_t *pmd, unsigned long addr)
 	return 1;
 }
 
+#ifdef CONFIG_PKS_PG_TABLES
+static int __init pks_page_init(void)
+{
+	pks_page_en = !init_grouped_page_cache(&gpc_pks, GFP_KERNEL | PGTABLE_HIGHMEM);
+
+out:
+	return !pks_page_en;
+}
+
+device_initcall(pks_page_init);
+#endif /* CONFIG_PKS_PG_TABLES */
 #else /* !CONFIG_X86_64 */
 
 int pud_free_pmd_page(pud_t *pud, unsigned long addr)
diff --git a/include/asm-generic/pgalloc.h b/include/asm-generic/pgalloc.h
index 02932efad3ab..3437db2a2740 100644
--- a/include/asm-generic/pgalloc.h
+++ b/include/asm-generic/pgalloc.h
@@ -2,11 +2,26 @@
 #ifndef __ASM_GENERIC_PGALLOC_H
 #define __ASM_GENERIC_PGALLOC_H
 
+#include <linux/mm.h>
+
 #ifdef CONFIG_MMU
 
 #define GFP_PGTABLE_KERNEL	(GFP_KERNEL | __GFP_ZERO)
 #define GFP_PGTABLE_USER	(GFP_PGTABLE_KERNEL | __GFP_ACCOUNT)
 
+#ifndef __HAVE_ARCH_ALLOC_TABLE
+static inline struct page *alloc_table(gfp_t gfp)
+{
+	return alloc_page(gfp);
+}
+#else /* __HAVE_ARCH_ALLOC_TABLE */
+extern struct page *alloc_table(gfp_t gfp);
+#endif /* __HAVE_ARCH_ALLOC_TABLE */
+
+#ifdef __HAVE_ARCH_FREE_TABLE
+extern void free_table(struct page *);
+#endif /* __HAVE_ARCH_FREE_TABLE */
+
 /**
  * __pte_alloc_one_kernel - allocate a page for PTE-level kernel page table
  * @mm: the mm_struct of the current context
@@ -18,7 +33,12 @@
  */
 static inline pte_t *__pte_alloc_one_kernel(struct mm_struct *mm)
 {
-	return (pte_t *)__get_free_page(GFP_PGTABLE_KERNEL);
+	struct page *page = alloc_table(GFP_PGTABLE_KERNEL);
+
+	if (!page)
+		return NULL;
+
+	return (pte_t *)page_address(page);
 }
 
 #ifndef __HAVE_ARCH_PTE_ALLOC_ONE_KERNEL
@@ -41,7 +61,7 @@ static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm)
  */
 static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
 {
-	free_page((unsigned long)pte);
+	free_table(virt_to_page(pte));
 }
 
 /**
@@ -60,11 +80,11 @@ static inline pgtable_t __pte_alloc_one(struct mm_struct *mm, gfp_t gfp)
 {
 	struct page *pte;
 
-	pte = alloc_page(gfp);
+	pte = alloc_table(gfp);
 	if (!pte)
 		return NULL;
 	if (!pgtable_pte_page_ctor(pte)) {
-		__free_page(pte);
+		free_table(pte);
 		return NULL;
 	}
 
@@ -99,7 +119,7 @@ static inline pgtable_t pte_alloc_one(struct mm_struct *mm)
 static inline void pte_free(struct mm_struct *mm, struct page *pte_page)
 {
 	pgtable_pte_page_dtor(pte_page);
-	__free_page(pte_page);
+	free_table(pte_page);
 }
 
 
@@ -123,11 +143,11 @@ static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
 
 	if (mm == &init_mm)
 		gfp = GFP_PGTABLE_KERNEL;
-	page = alloc_pages(gfp, 0);
+	page = alloc_table(gfp);
 	if (!page)
 		return NULL;
 	if (!pgtable_pmd_page_ctor(page)) {
-		__free_pages(page, 0);
+		free_table(page);
 		return NULL;
 	}
 	return (pmd_t *)page_address(page);
@@ -139,7 +159,7 @@ static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
 {
 	BUG_ON((unsigned long)pmd & (PAGE_SIZE-1));
 	pgtable_pmd_page_dtor(virt_to_page(pmd));
-	free_page((unsigned long)pmd);
+	free_table(virt_to_page(pmd));
 }
 #endif
 
@@ -160,10 +180,14 @@ static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
 static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
 	gfp_t gfp = GFP_PGTABLE_USER;
+	struct page *table;
 
 	if (mm == &init_mm)
 		gfp = GFP_PGTABLE_KERNEL;
-	return (pud_t *)get_zeroed_page(gfp);
+	table = alloc_table(gfp);
+	if (!table)
+		return NULL;
+	return (pud_t *)page_address(table);
 }
 #endif
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 64a71bf20536..d6dedfc02aab 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2185,6 +2185,13 @@ static inline bool ptlock_init(struct page *page) { return true; }
 static inline void ptlock_free(struct page *page) {}
 #endif /* USE_SPLIT_PTE_PTLOCKS */
 
+#ifndef CONFIG_PKS_PG_TABLES
+static inline void free_table(struct page *table_page)
+{
+	__free_pages(table_page, 0);
+}
+#endif /* CONFIG_PKS_PG_TABLES */
+
 static inline void pgtable_init(void)
 {
 	ptlock_cache_init();
diff --git a/mm/swap.c b/mm/swap.c
index 31b844d4ed94..d6ff697be28e 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -36,6 +36,7 @@
 #include <linux/hugetlb.h>
 #include <linux/page_idle.h>
 #include <linux/local_lock.h>
+#include <asm/pgalloc.h>
 
 #include "internal.h"
 
@@ -888,6 +889,12 @@ void release_pages(struct page **pages, int nr)
 			continue;
 		}
 
+		if (PageTable(page)) {
+			__ClearPageTable(page);
+			free_table(page);
+			continue;
+		}
+
 		if (!put_page_testzero(page))
 			continue;
 
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 3cdee7b11da9..a60ec3d4ab21 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -22,6 +22,7 @@
 #include <linux/swap_slots.h>
 #include <linux/huge_mm.h>
 #include <linux/shmem_fs.h>
+#include <asm/pgalloc.h>
 #include "internal.h"
 
 /*
@@ -310,6 +311,11 @@ static inline void free_swap_cache(struct page *page)
 void free_page_and_swap_cache(struct page *page)
 {
 	free_swap_cache(page);
+	if (PageTable(page)) {
+		__ClearPageTable(page);
+		free_table(page);
+		return;
+	}
 	if (!is_huge_zero_page(page))
 		put_page(page);
 }
-- 
2.30.2

