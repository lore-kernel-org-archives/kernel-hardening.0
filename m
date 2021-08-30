Return-Path: <SRS0=9pT7=NW=lists.openwall.com=kernel-hardening-return-21366-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B83DDC432BE
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 00:03:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 97F6F60F4B
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 00:03:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 97F6F60F4B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 7944 invoked by uid 550); 31 Aug 2021 00:00:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7406 invoked from network); 31 Aug 2021 00:00:33 -0000
X-IronPort-AV: E=McAfee;i="6200,9189,10092"; a="197933738"
X-IronPort-AV: E=Sophos;i="5.84,364,1620716400"; 
   d="scan'208";a="197933738"
X-IronPort-AV: E=Sophos;i="5.84,364,1620716400"; 
   d="scan'208";a="530713007"
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
Subject: [RFC PATCH v2 16/19] x86/mm: Protect page tables with PKS
Date: Mon, 30 Aug 2021 16:59:24 -0700
Message-Id: <20210830235927.6443-17-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210830235927.6443-1-rick.p.edgecombe@intel.com>
References: <20210830235927.6443-1-rick.p.edgecombe@intel.com>

Write protect page tables with PKS. Toggle writeability inside the
pgtable.h defined page table modifiction functions.

Do not protect the direct map page tables as it is more complicated and
will come in a later patch.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/boot/compressed/ident_map_64.c |  5 ++
 arch/x86/include/asm/pgtable.h          | 18 ++++++-
 arch/x86/include/asm/pgtable_64.h       | 33 ++++++++++--
 arch/x86/include/asm/pkeys_common.h     |  1 -
 arch/x86/mm/pgtable.c                   | 71 ++++++++++++++++++++++---
 arch/x86/mm/pkeys.c                     |  1 +
 include/linux/pkeys.h                   |  1 +
 mm/Kconfig                              |  6 +++
 8 files changed, 123 insertions(+), 13 deletions(-)

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
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 3505e3b1f40b..871308c40dac 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1085,7 +1085,9 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
 static inline void ptep_set_wrprotect(struct mm_struct *mm,
 				      unsigned long addr, pte_t *ptep)
 {
+	enable_pgtable_write();
 	clear_bit(_PAGE_BIT_RW, (unsigned long *)&ptep->pte);
+	disable_pgtable_write();
 }
 
 #define flush_tlb_fix_spurious_fault(vma, address) do { } while (0)
@@ -1135,7 +1137,9 @@ static inline pud_t pudp_huge_get_and_clear(struct mm_struct *mm,
 static inline void pmdp_set_wrprotect(struct mm_struct *mm,
 				      unsigned long addr, pmd_t *pmdp)
 {
+	enable_pgtable_write();
 	clear_bit(_PAGE_BIT_RW, (unsigned long *)pmdp);
+	disable_pgtable_write();
 }
 
 #define pud_write pud_write
@@ -1150,10 +1154,18 @@ static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
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
@@ -1236,13 +1248,17 @@ static inline p4d_t *user_to_kernel_p4dp(p4d_t *p4dp)
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
index 079a8be9686b..13f4341c4c0b 100644
--- a/arch/x86/include/asm/pkeys_common.h
+++ b/arch/x86/include/asm/pkeys_common.h
@@ -15,5 +15,4 @@
 #define PKR_AD_KEY(pkey)     (PKR_AD_BIT << PKR_PKEY_SHIFT(pkey))
 #define PKR_WD_KEY(pkey)     (PKR_WD_BIT << PKR_PKEY_SHIFT(pkey))
 #define PKR_VALUE(pkey, val) (val << PKR_PKEY_SHIFT(pkey))
-
 #endif /*_ASM_X86_PKEYS_COMMON_H */
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 006dc4f81f6d..69b43097c9da 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -8,6 +8,7 @@
 #include <asm/mtrr.h>
 #include <asm/set_memory.h>
 #include <asm/cmdline.h>
+#include <linux/pkeys.h>
 #include <linux/page-flags.h>
 
 #ifdef CONFIG_DYNAMIC_PHYSICAL_MASK
@@ -60,8 +61,11 @@ struct page *alloc_table_node(gfp_t gfp, int node)
 		return NULL;
 	__SetPageTable(table);
 
-	if (gfp & __GFP_ZERO)
+	if (gfp & __GFP_ZERO) {
+		enable_pgtable_write();
 		memset(page_address(table), 0, PAGE_SIZE);
+		disable_pgtable_write();
+	}
 
 	if (memcg_kmem_enabled() &&
 	    gfp & __GFP_ACCOUNT &&
@@ -614,9 +618,12 @@ int ptep_test_and_clear_young(struct vm_area_struct *vma,
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
@@ -627,9 +634,12 @@ int pmdp_test_and_clear_young(struct vm_area_struct *vma,
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
@@ -638,9 +648,12 @@ int pudp_test_and_clear_young(struct vm_area_struct *vma,
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
@@ -649,6 +662,7 @@ int pudp_test_and_clear_young(struct vm_area_struct *vma,
 int ptep_clear_flush_young(struct vm_area_struct *vma,
 			   unsigned long address, pte_t *ptep)
 {
+	int ret;
 	/*
 	 * On x86 CPUs, clearing the accessed bit without a TLB flush
 	 * doesn't cause data corruption. [ It could cause incorrect
@@ -662,7 +676,10 @@ int ptep_clear_flush_young(struct vm_area_struct *vma,
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
@@ -673,7 +690,9 @@ int pmdp_clear_flush_young(struct vm_area_struct *vma,
 
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 
+	enable_pgtable_write();
 	young = pmdp_test_and_clear_young(vma, address, pmdp);
+	disable_pgtable_write();
 	if (young)
 		flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
 
@@ -923,6 +942,30 @@ int pmd_free_pte_page(pmd_t *pmd, unsigned long addr)
 }
 
 #ifdef CONFIG_PKS_PG_TABLES
+static int _pks_protect(struct page *page, unsigned int cnt)
+{
+	set_memory_pks((unsigned long)page_address(page), cnt, PKS_KEY_PG_TABLES);
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
+	if (pks_tables_inited())
+		pks_mk_readwrite(PKS_KEY_PG_TABLES);
+}
+
+void disable_pgtable_write(void)
+{
+	if (pks_tables_inited())
+		pks_mk_readonly(PKS_KEY_PG_TABLES);
+}
+
 bool pks_tables_inited(void)
 {
 	return pks_tables_inited_val;
@@ -930,11 +973,23 @@ bool pks_tables_inited(void)
 
 static int __init pks_page_init(void)
 {
+	/*
+	 * If PKS is not enabled, don't try to enable anything and don't
+	 * report anything.
+	 */
+	if (!cpu_feature_enabled(X86_FEATURE_PKS) || !cpu_feature_enabled(X86_FEATURE_PKS_TABLES))
+		return 0;
+
 	pks_tables_inited_val = !init_grouped_page_cache(&gpc_pks, GFP_KERNEL | PGTABLE_HIGHMEM,
-					       NULL, NULL);
+					       _pks_protect, _pks_unprotect);
 
-out:
-	return !pks_tables_inited_val;
+	if (pks_tables_inited_val) {
+		pr_info("PKS tables initialized\n");
+		return 0;
+	}
+
+	pr_warn("PKS tables failed to initialize\n");
+	return 1;
 }
 
 device_initcall(pks_page_init);
diff --git a/arch/x86/mm/pkeys.c b/arch/x86/mm/pkeys.c
index 201004586c2b..48a390722c06 100644
--- a/arch/x86/mm/pkeys.c
+++ b/arch/x86/mm/pkeys.c
@@ -302,6 +302,7 @@ static int __init create_initial_pkrs_value(void)
 
 	consumer_defaults[PKS_KEY_DEFAULT]          = PKR_RW_BIT;
 	consumer_defaults[PKS_KEY_PGMAP_PROTECTION] = PKR_AD_BIT;
+	consumer_defaults[PKS_KEY_PG_TABLES]        = PKR_WD_BIT;
 
 	/* Ensure the number of consumers is less than the number of keys */
 	BUILD_BUG_ON(PKS_KEY_NR_CONSUMERS > PKS_NUM_PKEYS);
diff --git a/include/linux/pkeys.h b/include/linux/pkeys.h
index c06b47264c5d..42187a070df4 100644
--- a/include/linux/pkeys.h
+++ b/include/linux/pkeys.h
@@ -50,6 +50,7 @@ static inline bool arch_pkeys_enabled(void)
 enum pks_pkey_consumers {
 	PKS_KEY_DEFAULT = 0, /* Must be 0 for default PTE values */
 	PKS_KEY_PGMAP_PROTECTION,
+	PKS_KEY_PG_TABLES,
 	PKS_KEY_NR_CONSUMERS
 };
 extern u32 pkrs_init_value;
diff --git a/mm/Kconfig b/mm/Kconfig
index 4184d0a7531d..0f8e8595a396 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -845,6 +845,12 @@ config ARCH_ENABLE_SUPERVISOR_PKEYS
 	def_bool y
 	depends on PKS_TEST || GENERAL_PKS_USER
 
+config PKS_PG_TABLES
+	bool "PKS write protected page tables"
+	select GENERAL_PKS_USER
+	depends on !HIGHMEM && !X86_PAE && SPARSEMEM_VMEMMAP
+	depends on ARCH_HAS_SUPERVISOR_PKEYS
+
 config PERCPU_STATS
 	bool "Collect percpu memory statistics"
 	help
-- 
2.17.1

