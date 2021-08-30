Return-Path: <SRS0=Iy8F=NW=lists.openwall.com=kernel-hardening-return-21369-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16B21C43214
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 00:04:00 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1035260FC0
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 00:03:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1035260FC0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 8119 invoked by uid 550); 31 Aug 2021 00:00:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7423 invoked from network); 31 Aug 2021 00:00:33 -0000
X-IronPort-AV: E=McAfee;i="6200,9189,10092"; a="197933744"
X-IronPort-AV: E=Sophos;i="5.84,364,1620716400"; 
   d="scan'208";a="197933744"
X-IronPort-AV: E=Sophos;i="5.84,364,1620716400"; 
   d="scan'208";a="530713019"
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: dave.hansen@intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	x86@kernel.org,
	akpm@linux-foundation.org,
	keescook@chromium.org,
	shakeelb@google.com,
	vbabka@suse.cz,
	rppt@kernel.org
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>,
	linux-mm@kvack.org,
	linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 17/19] x86/mm/cpa: PKS protect direct map page tables
Date: Mon, 30 Aug 2021 16:59:25 -0700
Message-Id: <20210830235927.6443-18-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210830235927.6443-1-rick.p.edgecombe@intel.com>
References: <20210830235927.6443-1-rick.p.edgecombe@intel.com>

Protecting direct map page tables is a bit more difficult because a page
table may be needed for a page split as part of setting the PKS
permission the new page table. So in the case of an empty cache of page
tables the page table allocator could get into a situation where it cannot
create any more page tables.

Several solutions were looked at:

1. Break the direct map with pages allocated from the large page being
converted to PKS. This would result in a window where the table could be
written to right before it was linked into the page tables. It also
depends on high order pages being available, and so would regress from
the un-protected behavior in that respect.
2. Hold some page tables in reserve to be able to break the large page
for a new 2MB page, but if there are no 2MB page's available we may need
to add a single page to the cache, in which case we would use up the
reserve of page tables needed to break a new page, but not get enough
page tables back to replenish the resereve.
3. Always map the direct map at 4k when protecting page tables so that
pages don't need to be broken to map them with a PKS key. This would have
undesirable performance.

4. Lastly, the strategy employed in this patch, have a separate cache of
page tables just used for the direct map. Early in boot, squirrel away
enough page tables to map the direct map at 4k. This comes with the same
memory overhead of mapping the direct map at 4k, but gets the other
benefits of mapping the direct map as large pages.

There is also the problem of protecting page tables that are allocated
during boot. Instead of recording the tables to protect later, create a
page table traversing infrastructure to walk every page table in init_mm
and apply protection. This also covers non-direct map odds-and-ends page
tables that are allocated during boot. The existing page table traversing
in pagewalk.c cannot be used for this purpose because there are not actual
vmas for all of the kernel address space.

The algorithm for protecting the direct map page table cache, while also
allocating from it for direct map splits is described in the comments of
init_pks_dmap_tables().

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/include/asm/set_memory.h |   2 +
 arch/x86/mm/init.c                |  89 ++++++++++
 arch/x86/mm/pat/set_memory.c      | 263 +++++++++++++++++++++++++++++-
 3 files changed, 350 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_memory.h
index 1ba2fb45ed05..9f8d0d0ae063 100644
--- a/arch/x86/include/asm/set_memory.h
+++ b/arch/x86/include/asm/set_memory.h
@@ -90,6 +90,8 @@ bool kernel_page_present(struct page *page);
 
 extern int kernel_set_to_readonly;
 
+void add_dmap_table(unsigned long addr);
+
 #ifdef CONFIG_X86_64
 /*
  * Prevent speculative access to the page by either unmapping
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index c8933c6d5efd..a91696e3da96 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -6,6 +6,7 @@
 #include <linux/swapfile.h>
 #include <linux/swapops.h>
 #include <linux/kmemleak.h>
+#include <linux/hugetlb.h>
 #include <linux/sched/task.h>
 
 #include <asm/set_memory.h>
@@ -26,6 +27,7 @@
 #include <asm/pti.h>
 #include <asm/text-patching.h>
 #include <asm/memtype.h>
+#include <asm/pgalloc.h>
 
 /*
  * We need to define the tracepoints somewhere, and tlb.c
@@ -119,6 +121,17 @@ __ref void *alloc_low_pages(unsigned int num)
 	if (after_bootmem) {
 		unsigned int order;
 
+		if (cpu_feature_enabled(X86_FEATURE_PKS_TABLES)) {
+			struct page *page;
+
+			/* 64 bit only allocates order 0 pages */
+			WARN_ON(num != 1);
+
+			page = alloc_table(GFP_ATOMIC | __GFP_ZERO);
+			if (!page)
+				return NULL;
+			return (void *)page_address(page);
+		}
 		order = get_order((unsigned long)num << PAGE_SHIFT);
 		return (void *)__get_free_pages(GFP_ATOMIC | __GFP_ZERO, order);
 	}
@@ -504,6 +517,79 @@ bool pfn_range_is_mapped(unsigned long start_pfn, unsigned long end_pfn)
 	return false;
 }
 
+#ifdef CONFIG_PKS_PG_TABLES
+/* Page tables needed in bytes */
+static u64 calc_tables_needed(unsigned int size)
+{
+	unsigned int puds = size >> PUD_SHIFT;
+	unsigned int pmds = size >> PMD_SHIFT;
+
+	/*
+	 * Catch if direct map ever might need more page tables to split
+	 * down to 4k.
+	 */
+	BUILD_BUG_ON(p4d_huge(foo));
+	BUILD_BUG_ON(pgd_huge(foo));
+
+	return (puds + pmds) << PAGE_SHIFT;
+}
+
+/*
+ * If pre boot, reserve large pages from memory that will be mapped. It's ok that this is not
+ * mapped as PKS, other init code in CPA will handle the conversion.
+ */
+static unsigned int __init reserve_pre_boot(u64 start, u64 end)
+{
+	u64 cur = memblock_find_in_range(start, end, HPAGE_SIZE, HPAGE_SIZE);
+	int i;
+
+	if (!cur)
+		return 0;
+	memblock_reserve(cur, HPAGE_SIZE);
+	for (i = 0; i < HPAGE_SIZE; i += PAGE_SIZE)
+		add_dmap_table((unsigned long)__va(cur + i));
+	return HPAGE_SIZE;
+}
+
+/* If post boot, memblock is not available. Just reserve from other memory regions */
+static unsigned int __init reserve_post_boot(void)
+{
+	struct page *page = alloc_table(GFP_KERNEL);
+
+	if (!page)
+		return 0;
+
+	add_dmap_table((unsigned long)page_address(page));
+
+	return PAGE_SIZE;
+}
+
+static void __init reserve_page_tables(u64 start, u64 end)
+{
+	u64 reserve_size = calc_tables_needed(end - start);
+	u64 reserved = 0;
+	u64 cur_reserved;
+
+	while (reserved < reserve_size) {
+		if (after_bootmem)
+			cur_reserved = reserve_post_boot();
+		else
+			cur_reserved = reserve_pre_boot(start, end);
+
+		if (!cur_reserved) {
+			WARN(1, "Could not reserve direct map page tables %llu/%llu\n",
+				reserved,
+				reserve_size);
+			return;
+		}
+
+		reserved += cur_reserved;
+	}
+}
+#else
+static inline void reserve_page_tables(u64 start, u64 end) { }
+#endif
+
 /*
  * Setup the direct mapping of the physical memory at PAGE_OFFSET.
  * This runs before bootmem is initialized and gets pages directly from
@@ -529,6 +615,9 @@ unsigned long __ref init_memory_mapping(unsigned long start,
 
 	add_pfn_range_mapped(start >> PAGE_SHIFT, ret >> PAGE_SHIFT);
 
+	if (cpu_feature_enabled(X86_FEATURE_PKS_TABLES))
+		reserve_page_tables(start, end);
+
 	return ret >> PAGE_SHIFT;
 }
 
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index dc704e8da032..6acf25999b0f 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -18,6 +18,7 @@
 #include <linux/libnvdimm.h>
 #include <linux/vmstat.h>
 #include <linux/kernel.h>
+#include <linux/pkeys.h>
 
 #include <asm/e820/api.h>
 #include <asm/processor.h>
@@ -71,6 +72,68 @@ static DEFINE_SPINLOCK(cpa_lock);
 #define CPA_PAGES_ARRAY 4
 #define CPA_NO_CHECK_ALIAS 8 /* Do not search for aliases */
 
+static struct page *alloc_regular_dmap_table(void)
+{
+	return alloc_pages(GFP_KERNEL, 0);
+}
+
+#ifdef CONFIG_PKS_PG_TABLES
+static LLIST_HEAD(tables_cache);
+static bool dmap_tables_inited;
+
+void add_dmap_table(unsigned long addr)
+{
+	struct llist_node *node = (struct llist_node *)addr;
+
+	enable_pgtable_write();
+	llist_add(node, &tables_cache);
+	disable_pgtable_write();
+}
+
+static struct page *get_pks_table(void)
+{
+	void *ptr = llist_del_first(&tables_cache);
+
+	if (!ptr)
+		return NULL;
+
+	return virt_to_page(ptr);
+}
+
+static struct page *alloc_dmap_table(void)
+{
+	struct page *table;
+
+	if (!pks_tables_inited())
+		return alloc_regular_dmap_table();
+
+	table = get_pks_table();
+	/* Fall back to un-protected table is couldn't get one from cache */
+	if (!table) {
+		if (dmap_tables_inited)
+			WARN(1, "Allocating unprotected direct map table\n");
+		table = alloc_regular_dmap_table();
+	}
+
+	return table;
+}
+
+static void free_dmap_table(struct page *table)
+{
+	add_dmap_table((unsigned long)virt_to_page(table));
+}
+#else /* CONFIG_PKS_PG_TABLES */
+static struct page *alloc_dmap_table(void)
+{
+	return alloc_regular_dmap_table();
+}
+
+static void free_dmap_table(struct page *table)
+{
+	__free_page(table);
+}
+#endif
+
 static inline pgprot_t cachemode2pgprot(enum page_cache_mode pcm)
 {
 	return __pgprot(cachemode2protval(pcm));
@@ -1076,14 +1139,15 @@ static int split_large_page(struct cpa_data *cpa, pte_t *kpte,
 
 	if (!debug_pagealloc_enabled())
 		spin_unlock(&cpa_lock);
-	base = alloc_pages(GFP_KERNEL, 0);
+	base = alloc_dmap_table();
+
 	if (!debug_pagealloc_enabled())
 		spin_lock(&cpa_lock);
 	if (!base)
 		return -ENOMEM;
 
 	if (__split_large_page(cpa, kpte, address, base))
-		__free_page(base);
+		free_dmap_table(base);
 
 	return 0;
 }
@@ -1096,7 +1160,7 @@ static bool try_to_free_pte_page(pte_t *pte)
 		if (!pte_none(pte[i]))
 			return false;
 
-	free_page((unsigned long)pte);
+	free_dmap_table(virt_to_page(pte));
 	return true;
 }
 
@@ -1108,7 +1172,7 @@ static bool try_to_free_pmd_page(pmd_t *pmd)
 		if (!pmd_none(pmd[i]))
 			return false;
 
-	free_page((unsigned long)pmd);
+	free_dmap_table(virt_to_page(pmd));
 	return true;
 }
 
@@ -2535,6 +2599,197 @@ void free_grouped_page(struct grouped_page_cache *gpc, struct page *page)
 	list_lru_add_node(&gpc->lru, &page->lru, page_to_nid(page));
 }
 #endif /* !HIGHMEM */
+
+#ifdef CONFIG_PKS_PG_TABLES
+#define IS_TABLE_KEY(val) (((val & _PAGE_PKEY_MASK) >> _PAGE_BIT_PKEY_BIT0) == PKS_KEY_PG_TABLES)
+
+static bool is_dmap_protected(unsigned long addr)
+{
+	pgd_t *pgd;
+	p4d_t *p4d;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+
+	pgd = init_mm.pgd + pgd_index(addr);
+	if (!pgd_present(*pgd))
+		return true;
+
+	p4d = p4d_offset(pgd, addr);
+	if (!p4d_present(*p4d) || (p4d_large(*p4d) && IS_TABLE_KEY(p4d_val(*p4d))))
+		return true;
+	else if (p4d_large(*p4d))
+		return false;
+
+	pud = pud_offset(p4d, addr);
+	if (!pud_present(*pud) || (pud_large(*pud) && IS_TABLE_KEY(pud_val(*pud))))
+		return true;
+	else if (pud_large(*pud))
+		return false;
+
+	pmd = pmd_offset(pud, addr);
+	if (!pmd_present(*pmd) || (pmd_large(*pmd) && IS_TABLE_KEY(pmd_val(*pmd))))
+		return true;
+	else if (pmd_large(*pmd))
+		return false;
+
+	pte = pte_offset_kernel(pmd, addr);
+	if (!pte_present(*pte) || IS_TABLE_KEY(pte_val(*pte)))
+		return true;
+
+	return false;
+}
+
+static void ensure_table_protected(unsigned long pfn, void *vaddr, void *vend)
+{
+	unsigned long addr_table = (unsigned long)__va(pfn << PAGE_SHIFT);
+
+	if (is_dmap_protected(addr_table))
+		return;
+
+	if (set_memory_pks(addr_table, 1, PKS_KEY_PG_TABLES))
+		pr_warn("Failed to protect page table mapping 0x%pK-0x%pK\n", vaddr, vend);
+}
+
+typedef void (*traverse_cb)(unsigned long pfn, void *vaddr, void *vend);
+
+/*
+ * The pXX_page_vaddr() functions are half way done being renamed to pXX_pgtable(),
+ * leaving no pattern in the names, provide local copies of the missing pXX_pgtable()
+ * implementations for the time being so they can be used in the template below.
+ */
+
+static inline p4d_t *pgd_pgtable(pgd_t pgd)
+{
+	return (p4d_t *)pgd_page_vaddr(pgd);
+}
+
+#define TRAVERSE(upper, lower, ptrs_cnt, upper_size, skip) \
+static void traverse_##upper(upper##_t *upper, traverse_cb cb, unsigned long base) \
+{ \
+	unsigned long cur_addr = base; \
+	upper##_t *cur; \
+\
+	if (skip) { \
+		traverse_##lower((lower##_t *)upper, cb, cur_addr); \
+		return; \
+	} \
+\
+	for (cur = upper; cur < upper + ptrs_cnt; cur++) { \
+		/* \
+		 * Use native_foo_val() instead of foo_none() because pgd_none() always \
+		 * return 0 when in 4 level paging. \
+		 */ \
+		if (native_##upper##_val(*cur) && !upper##_large(*cur)) { \
+			void *vstart = (void *)sign_extend64(cur_addr, __VIRTUAL_MASK_SHIFT); \
+			void *vend = vstart + upper_size - 1; \
+\
+			cb(upper##_pfn(*cur), vstart, vend); \
+			traverse_##lower((lower##_t *)upper##_pgtable(*cur), cb, cur_addr); \
+		} \
+		cur_addr += upper_size; \
+	} \
+}
+
+static void traverse_pte(pte_t *pte, traverse_cb cb, unsigned long base) { }
+TRAVERSE(pmd, pte, PTRS_PER_PMD, PMD_SIZE, false)
+TRAVERSE(pud, pmd, PTRS_PER_PUD, PUD_SIZE, false)
+TRAVERSE(p4d, pud, PTRS_PER_P4D, P4D_SIZE, !pgtable_l5_enabled())
+TRAVERSE(pgd, p4d, PTRS_PER_PGD, PGDIR_SIZE, false)
+
+static void traverse_mm(struct mm_struct *mm, traverse_cb cb)
+{
+	cb(__pa(mm->pgd) >> PAGE_SHIFT, 0, (void *)-1);
+	traverse_pgd(mm->pgd, cb, 0);
+}
+
+static void free_maybe_reserved(struct page *page)
+{
+	if (PageReserved(page))
+		free_reserved_page(page);
+	else
+		__free_page(page);
+}
+
+struct pks_table_llnode {
+	struct llist_node node;
+	void *table;
+};
+
+/* PKS protect reserved dmap tables */
+static int __init init_pks_dmap_tables(void)
+{
+	static LLIST_HEAD(tables_to_covert);
+	struct pks_table_llnode *cur_entry;
+	struct llist_node *cur, *next;
+	struct pks_table_llnode *tmp;
+	bool fail_to_build_list = false;
+
+	/*
+	 * If pks tables failed to initialize, return the pages to the page
+	 * allocator, and don't enable dmap tables.
+	 */
+	if (!pks_tables_inited()) {
+		llist_for_each_safe(cur, next, llist_del_all(&tables_cache))
+			free_maybe_reserved(virt_to_page(cur));
+		return 0;
+	}
+
+	/* Build separate list of tables */
+	llist_for_each_safe(cur, next, llist_del_all(&tables_cache)) {
+		tmp = kmalloc(sizeof(*tmp), GFP_KERNEL);
+		if (!tmp) {
+			fail_to_build_list = true;
+			free_maybe_reserved(virt_to_page(cur));
+			continue;
+		}
+		tmp->table = cur;
+		llist_add(&tmp->node, &tables_to_covert);
+		llist_add(cur, &tables_cache);
+	}
+
+	if (fail_to_build_list)
+		goto out_err;
+
+	/*
+	 * Tables in tables_cache can now be used, because they are being kept track
+	 * of tables_to_covert.
+	 */
+	dmap_tables_inited = true;
+
+	/*
+	 * PKS protect all tables in tables_to_covert. Some of them are also in tables_cache
+	 * and may get used in this process.
+	 */
+	while ((cur = llist_del_first(&tables_to_covert))) {
+		cur_entry = llist_entry(cur, struct pks_table_llnode, node);
+		set_memory_pks((unsigned long)cur_entry->table, 1, PKS_KEY_PG_TABLES);
+		kfree(cur_entry);
+	}
+
+	/*
+	 * It is safe to traverse while the callback ensure_table_protected() may
+	 * change the page tables, because CPA will only split pages and not merge
+	 * them. Any page used for the splits, will have already been protected in
+	 * a previous step, so they will not be missed if tables are mapped by a
+	 * structure that has already been traversed.
+	 */
+	traverse_mm(&init_mm, &ensure_table_protected);
+
+	return 0;
+out_err:
+	while ((cur = llist_del_first(&tables_to_covert))) {
+		cur_entry = llist_entry(cur, struct pks_table_llnode, node);
+		free_maybe_reserved(virt_to_page(cur));
+		kfree(cur_entry);
+	}
+	pr_warn("Unable to protect direct map page cache, direct map unprotected.\n");
+	return 0;
+}
+
+late_initcall(init_pks_dmap_tables);
+#endif /* CONFIG_PKS_PG_TABLES */
+
 /*
  * The testcases use internal knowledge of the implementation that shouldn't
  * be exposed to the rest of the kernel. Include these directly here.
-- 
2.17.1

