Return-Path: <SRS0=r5oh=KA=lists.openwall.com=kernel-hardening-return-21233-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 429C1C433B4
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 May 2021 00:34:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 313DD6112D
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 May 2021 00:34:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 313DD6112D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21233-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13901 invoked by uid 550); 5 May 2021 00:32:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13772 invoked from network); 5 May 2021 00:32:48 -0000
IronPort-SDR: g6bdNutp5mL1mAL160hMd9l9WZZIJ0nUuecfmjCv8ePoa+p1KM975d1cqZVSjWMzNdvw/VFMuF
 y7ugaQw60IEg==
X-IronPort-AV: E=McAfee;i="6200,9189,9974"; a="262052481"
X-IronPort-AV: E=Sophos;i="5.82,273,1613462400"; 
   d="scan'208";a="262052481"
IronPort-SDR: I0z1rg5VKK8/qOih2QlQJF9tuI0gG+j1HgDM1okQSTuW+K4/wpcR17+Fod6bL5S+JWwk+l0EyQ
 qK4cWswk+e1g==
X-IronPort-AV: E=Sophos;i="5.82,273,1613462400"; 
   d="scan'208";a="429490827"
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
Subject: [PATCH RFC 8/9] x86, mm: Protect page tables with PKS
Date: Tue,  4 May 2021 17:30:31 -0700
Message-Id: <20210505003032.489164-9-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505003032.489164-1-rick.p.edgecombe@intel.com>
References: <20210505003032.489164-1-rick.p.edgecombe@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Write protect page tables with PKS. Toggle writeability inside the
pgtable.h defined page table modifiction functions.

Do not protect the direct map page tables as it is more complicated and
will come in a later patch.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/boot/compressed/ident_map_64.c |  5 ++
 arch/x86/include/asm/pgalloc.h          |  2 +
 arch/x86/include/asm/pgtable.h          | 26 ++++++++-
 arch/x86/include/asm/pgtable_64.h       | 33 ++++++++++--
 arch/x86/include/asm/pkeys_common.h     |  8 ++-
 arch/x86/mm/pgtable.c                   | 72 ++++++++++++++++++++++---
 mm/Kconfig                              |  6 ++-
 7 files changed, 140 insertions(+), 12 deletions(-)

diff --git a/arch/x86/boot/compressed/ident_map_64.c b/arch/x86/boot/compressed/ident_map_64.c
index f7213d0943b8..2999be8f9347 100644
--- a/arch/x86/boot/compressed/ident_map_64.c
+++ b/arch/x86/boot/compressed/ident_map_64.c
@@ -349,3 +349,8 @@ void do_boot_page_fault(struct pt_regs *regs, unsigned long error_code)
 	 */
 	add_identity_map(address, end);
 }
+
+#ifdef CONFIG_PKS_PG_TABLES
+void enable_pgtable_write(void) {}
+void disable_pgtable_write(void) {}
+#endif
diff --git a/arch/x86/include/asm/pgalloc.h b/arch/x86/include/asm/pgalloc.h
index e38b54853a51..f1062d23d7c7 100644
--- a/arch/x86/include/asm/pgalloc.h
+++ b/arch/x86/include/asm/pgalloc.h
@@ -6,6 +6,8 @@
 #include <linux/mm.h>		/* for struct page */
 #include <linux/pagemap.h>
 
+#define STATIC_TABLE_KEY	1
+
 #define __HAVE_ARCH_PTE_ALLOC_ONE
 #ifdef CONFIG_PKS_PG_TABLES
 #define __HAVE_ARCH_FREE_TABLE
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index b1529b44a996..da6bae8bef7a 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -117,6 +117,14 @@ extern pmdval_t early_pmd_flags;
 #define arch_end_context_switch(prev)	do {} while(0)
 #endif	/* CONFIG_PARAVIRT_XXL */
 
+#ifdef CONFIG_PKS_PG_TABLES
+void enable_pgtable_write(void);
+void disable_pgtable_write(void);
+#else /* CONFIG_PKS_PG_TABLES */
+static void enable_pgtable_write(void) { }
+static void disable_pgtable_write(void) { }
+#endif /* CONFIG_PKS_PG_TABLES */
+
 /*
  * The following only work if pte_present() is true.
  * Undefined behaviour if not..
@@ -1102,7 +1110,9 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
 static inline void ptep_set_wrprotect(struct mm_struct *mm,
 				      unsigned long addr, pte_t *ptep)
 {
+	enable_pgtable_write();
 	clear_bit(_PAGE_BIT_RW, (unsigned long *)&ptep->pte);
+	disable_pgtable_write();
 }
 
 #define flush_tlb_fix_spurious_fault(vma, address) do { } while (0)
@@ -1152,7 +1162,9 @@ static inline pud_t pudp_huge_get_and_clear(struct mm_struct *mm,
 static inline void pmdp_set_wrprotect(struct mm_struct *mm,
 				      unsigned long addr, pmd_t *pmdp)
 {
+	enable_pgtable_write();
 	clear_bit(_PAGE_BIT_RW, (unsigned long *)pmdp);
+	disable_pgtable_write();
 }
 
 #define pud_write pud_write
@@ -1167,10 +1179,18 @@ static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 		unsigned long address, pmd_t *pmdp, pmd_t pmd)
 {
 	if (IS_ENABLED(CONFIG_SMP)) {
-		return xchg(pmdp, pmd);
+		pmd_t ret;
+
+		enable_pgtable_write();
+		ret = xchg(pmdp, pmd);
+		disable_pgtable_write();
+
+		return ret;
 	} else {
 		pmd_t old = *pmdp;
+		enable_pgtable_write();
 		WRITE_ONCE(*pmdp, pmd);
+		disable_pgtable_write();
 		return old;
 	}
 }
@@ -1253,13 +1273,17 @@ static inline p4d_t *user_to_kernel_p4dp(p4d_t *p4dp)
  */
 static inline void clone_pgd_range(pgd_t *dst, pgd_t *src, int count)
 {
+	enable_pgtable_write();
 	memcpy(dst, src, count * sizeof(pgd_t));
+	disable_pgtable_write();
 #ifdef CONFIG_PAGE_TABLE_ISOLATION
 	if (!static_cpu_has(X86_FEATURE_PTI))
 		return;
 	/* Clone the user space pgd as well */
+	enable_pgtable_write();
 	memcpy(kernel_to_user_pgdp(dst), kernel_to_user_pgdp(src),
 	       count * sizeof(pgd_t));
+	disable_pgtable_write();
 #endif
 }
 
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
index 56d0399a0cd1..a287f3c8a0a3 100644
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -64,7 +64,9 @@ void set_pte_vaddr_pud(pud_t *pud_page, unsigned long vaddr, pte_t new_pte);
 
 static inline void native_set_pte(pte_t *ptep, pte_t pte)
 {
+	enable_pgtable_write();
 	WRITE_ONCE(*ptep, pte);
+	disable_pgtable_write();
 }
 
 static inline void native_pte_clear(struct mm_struct *mm, unsigned long addr,
@@ -80,7 +82,9 @@ static inline void native_set_pte_atomic(pte_t *ptep, pte_t pte)
 
 static inline void native_set_pmd(pmd_t *pmdp, pmd_t pmd)
 {
+	enable_pgtable_write();
 	WRITE_ONCE(*pmdp, pmd);
+	disable_pgtable_write();
 }
 
 static inline void native_pmd_clear(pmd_t *pmd)
@@ -91,7 +95,12 @@ static inline void native_pmd_clear(pmd_t *pmd)
 static inline pte_t native_ptep_get_and_clear(pte_t *xp)
 {
 #ifdef CONFIG_SMP
-	return native_make_pte(xchg(&xp->pte, 0));
+	pteval_t pte_val;
+
+	enable_pgtable_write();
+	pte_val = xchg(&xp->pte, 0);
+	disable_pgtable_write();
+	return native_make_pte(pte_val);
 #else
 	/* native_local_ptep_get_and_clear,
 	   but duplicated because of cyclic dependency */
@@ -104,7 +113,12 @@ static inline pte_t native_ptep_get_and_clear(pte_t *xp)
 static inline pmd_t native_pmdp_get_and_clear(pmd_t *xp)
 {
 #ifdef CONFIG_SMP
-	return native_make_pmd(xchg(&xp->pmd, 0));
+	pteval_t pte_val;
+
+	enable_pgtable_write();
+	pte_val = xchg(&xp->pmd, 0);
+	disable_pgtable_write();
+	return native_make_pmd(pte_val);
 #else
 	/* native_local_pmdp_get_and_clear,
 	   but duplicated because of cyclic dependency */
@@ -116,7 +130,9 @@ static inline pmd_t native_pmdp_get_and_clear(pmd_t *xp)
 
 static inline void native_set_pud(pud_t *pudp, pud_t pud)
 {
+	enable_pgtable_write();
 	WRITE_ONCE(*pudp, pud);
+	disable_pgtable_write();
 }
 
 static inline void native_pud_clear(pud_t *pud)
@@ -127,7 +143,12 @@ static inline void native_pud_clear(pud_t *pud)
 static inline pud_t native_pudp_get_and_clear(pud_t *xp)
 {
 #ifdef CONFIG_SMP
-	return native_make_pud(xchg(&xp->pud, 0));
+	pteval_t pte_val;
+
+	enable_pgtable_write();
+	pte_val = xchg(&xp->pud, 0);
+	disable_pgtable_write();
+	return native_make_pud(pte_val);
 #else
 	/* native_local_pudp_get_and_clear,
 	 * but duplicated because of cyclic dependency
@@ -144,13 +165,17 @@ static inline void native_set_p4d(p4d_t *p4dp, p4d_t p4d)
 	pgd_t pgd;
 
 	if (pgtable_l5_enabled() || !IS_ENABLED(CONFIG_PAGE_TABLE_ISOLATION)) {
+		enable_pgtable_write();
 		WRITE_ONCE(*p4dp, p4d);
+		disable_pgtable_write();
 		return;
 	}
 
 	pgd = native_make_pgd(native_p4d_val(p4d));
 	pgd = pti_set_user_pgtbl((pgd_t *)p4dp, pgd);
+	enable_pgtable_write();
 	WRITE_ONCE(*p4dp, native_make_p4d(native_pgd_val(pgd)));
+	disable_pgtable_write();
 }
 
 static inline void native_p4d_clear(p4d_t *p4d)
@@ -160,7 +185,9 @@ static inline void native_p4d_clear(p4d_t *p4d)
 
 static inline void native_set_pgd(pgd_t *pgdp, pgd_t pgd)
 {
+	enable_pgtable_write();
 	WRITE_ONCE(*pgdp, pti_set_user_pgtbl(pgdp, pgd));
+	disable_pgtable_write();
 }
 
 static inline void native_pgd_clear(pgd_t *pgd)
diff --git a/arch/x86/include/asm/pkeys_common.h b/arch/x86/include/asm/pkeys_common.h
index 6917f1a27479..5682a922d60f 100644
--- a/arch/x86/include/asm/pkeys_common.h
+++ b/arch/x86/include/asm/pkeys_common.h
@@ -25,7 +25,13 @@
  *
  * NOTE: This needs to be a macro to be used as part of the INIT_THREAD macro.
  */
-#define INIT_PKRS_VALUE (PKR_AD_KEY(1) | PKR_AD_KEY(2) | PKR_AD_KEY(3) | \
+
+/*
+ * HACK: There is no global pkeys support yet. We want the pg table key to be
+ * read only, not disabled. Assume the page table key will be key 1 and set it
+ * WD in the default mask.
+ */
+#define INIT_PKRS_VALUE (PKR_WD_KEY(1) | PKR_AD_KEY(2) | PKR_AD_KEY(3) | \
 			 PKR_AD_KEY(4) | PKR_AD_KEY(5) | PKR_AD_KEY(6) | \
 			 PKR_AD_KEY(7) | PKR_AD_KEY(8) | PKR_AD_KEY(9) | \
 			 PKR_AD_KEY(10) | PKR_AD_KEY(11) | PKR_AD_KEY(12) | \
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index bcef1f458b75..6e536fe77943 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -7,6 +7,7 @@
 #include <asm/fixmap.h>
 #include <asm/mtrr.h>
 #include <asm/set_memory.h>
+#include <linux/pkeys.h>
 #include <linux/page-flags.h>
 
 #ifdef CONFIG_DYNAMIC_PHYSICAL_MASK
@@ -16,6 +17,7 @@ EXPORT_SYMBOL(physical_mask);
 
 static struct grouped_page_cache gpc_pks;
 static bool pks_page_en;
+
 #ifdef CONFIG_HIGHPTE
 #define PGTABLE_HIGHMEM __GFP_HIGHMEM
 #else
@@ -49,8 +51,11 @@ struct page *alloc_table(gfp_t gfp)
 	if (!table)
 		return NULL;
 
-	if (gfp & __GFP_ZERO)
+	if (gfp & __GFP_ZERO) {
+		enable_pgtable_write();
 		memset(page_address(table), 0, PAGE_SIZE);
+		disable_pgtable_write();
+	}
 
 	if (memcg_kmem_enabled() &&
 	    gfp & __GFP_ACCOUNT &&
@@ -607,9 +612,12 @@ int ptep_test_and_clear_young(struct vm_area_struct *vma,
 {
 	int ret = 0;
 
-	if (pte_young(*ptep))
+	if (pte_young(*ptep)) {
+		enable_pgtable_write();
 		ret = test_and_clear_bit(_PAGE_BIT_ACCESSED,
 					 (unsigned long *) &ptep->pte);
+		disable_pgtable_write();
+	}
 
 	return ret;
 }
@@ -620,9 +628,12 @@ int pmdp_test_and_clear_young(struct vm_area_struct *vma,
 {
 	int ret = 0;
 
-	if (pmd_young(*pmdp))
+	if (pmd_young(*pmdp)) {
+		enable_pgtable_write();
 		ret = test_and_clear_bit(_PAGE_BIT_ACCESSED,
 					 (unsigned long *)pmdp);
+		disable_pgtable_write();
+	}
 
 	return ret;
 }
@@ -631,9 +642,12 @@ int pudp_test_and_clear_young(struct vm_area_struct *vma,
 {
 	int ret = 0;
 
-	if (pud_young(*pudp))
+	if (pud_young(*pudp)) {
+		enable_pgtable_write();
 		ret = test_and_clear_bit(_PAGE_BIT_ACCESSED,
 					 (unsigned long *)pudp);
+		disable_pgtable_write();
+	}
 
 	return ret;
 }
@@ -642,6 +656,7 @@ int pudp_test_and_clear_young(struct vm_area_struct *vma,
 int ptep_clear_flush_young(struct vm_area_struct *vma,
 			   unsigned long address, pte_t *ptep)
 {
+	int ret;
 	/*
 	 * On x86 CPUs, clearing the accessed bit without a TLB flush
 	 * doesn't cause data corruption. [ It could cause incorrect
@@ -655,7 +670,10 @@ int ptep_clear_flush_young(struct vm_area_struct *vma,
 	 * shouldn't really matter because there's no real memory
 	 * pressure for swapout to react to. ]
 	 */
-	return ptep_test_and_clear_young(vma, address, ptep);
+	enable_pgtable_write();
+	ret = ptep_test_and_clear_young(vma, address, ptep);
+	disable_pgtable_write();
+	return ret;
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -666,7 +684,9 @@ int pmdp_clear_flush_young(struct vm_area_struct *vma,
 
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 
+	enable_pgtable_write();
 	young = pmdp_test_and_clear_young(vma, address, pmdp);
+	disable_pgtable_write();
 	if (young)
 		flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
 
@@ -924,10 +944,50 @@ int pmd_free_pte_page(pmd_t *pmd, unsigned long addr)
 }
 
 #ifdef CONFIG_PKS_PG_TABLES
+static int pks_key;
+
+static int _pks_protect(struct page *page, unsigned int cnt)
+{
+	/* TODO: do this in one step */
+	if (set_memory_4k((unsigned long)page_address(page), cnt))
+		return 1;
+	set_memory_pks((unsigned long)page_address(page), cnt, pks_key);
+	return 0;
+}
+
+static int _pks_unprotect(struct page *page, unsigned int cnt)
+{
+	set_memory_pks((unsigned long)page_address(page), cnt, 0);
+	return 0;
+}
+
+void enable_pgtable_write(void)
+{
+	if (pks_page_en)
+		pks_mk_readwrite(STATIC_TABLE_KEY);
+}
+
+void disable_pgtable_write(void)
+{
+	if (pks_page_en)
+		pks_mk_readonly(STATIC_TABLE_KEY);
+}
+
 static int __init pks_page_init(void)
 {
+	/*
+	 * TODO: Needs global keys to be initially set globally readable, for now
+	 * warn if its not the expected static key
+	 */
+	pks_key = pks_key_alloc("PKS protected page tables");
+	if (pks_key < 0)
+		goto out;
+	WARN_ON(pks_key != STATIC_TABLE_KEY);
+
 	pks_page_en = !init_grouped_page_cache(&gpc_pks, GFP_KERNEL | PGTABLE_HIGHMEM,
-					       NULL, NULL);
+					       _pks_protect, _pks_unprotect);
+	if (!pks_page_en)
+		pks_key_free(pks_key);
 
 out:
 	return !pks_page_en;
diff --git a/mm/Kconfig b/mm/Kconfig
index 463e95ea0df1..0a856332fd38 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -812,7 +812,11 @@ config ARCH_HAS_SUPERVISOR_PKEYS
 	bool
 config ARCH_ENABLE_SUPERVISOR_PKEYS
 	def_bool y
-	depends on PKS_TEST
+	depends on PKS_TEST || PKS_PG_TABLES
+
+config PKS_PG_TABLES
+	def_bool y
+	depends on !PAGE_TABLE_ISOLATION && !HIGHMEM && !X86_PAE && PGTABLE_LEVELS = 4
 
 config PERCPU_STATS
 	bool "Collect percpu memory statistics"
-- 
2.30.2

