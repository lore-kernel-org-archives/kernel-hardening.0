Reply-To: kernel-hardening@lists.openwall.com
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 11 Jan 2016 14:18:57 +0100
Message-Id: <1452518355-4606-5-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1452518355-4606-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1452518355-4606-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v3 04/21] arm64: decouple early fixmap init from linear mapping
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, linux-kernel@vger.kernel.org
Cc: stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, arnd@arndb.de, marc.zyngier@arm.com, christoffer.dall@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

Since the early fixmap page tables are populated using pages that are
part of the static footprint of the kernel, they are covered by the
initial kernel mapping, and we can refer to them without using __va/__pa
translations, which are tied to the linear mapping.

Since the fixmap page tables are disjoint from the kernel mapping up
to the top level pgd entry, we can refer to bm_pte[] directly, and there
is no need to walk the page tables and perform __pa()/__va() translations
at each step.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/mm/mmu.c | 32 ++++++--------------
 1 file changed, 9 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 7711554a94f4..75b5f0dc3bdc 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -570,38 +570,24 @@ void vmemmap_free(unsigned long start, unsigned long end)
 #endif	/* CONFIG_SPARSEMEM_VMEMMAP */
 
 static pte_t bm_pte[PTRS_PER_PTE] __page_aligned_bss;
-#if CONFIG_PGTABLE_LEVELS > 2
 static pmd_t bm_pmd[PTRS_PER_PMD] __page_aligned_bss;
-#endif
-#if CONFIG_PGTABLE_LEVELS > 3
 static pud_t bm_pud[PTRS_PER_PUD] __page_aligned_bss;
-#endif
 
 static inline pud_t * fixmap_pud(unsigned long addr)
 {
-	pgd_t *pgd = pgd_offset_k(addr);
-
-	BUG_ON(pgd_none(*pgd) || pgd_bad(*pgd));
-
-	return pud_offset(pgd, addr);
+	return (CONFIG_PGTABLE_LEVELS > 3) ? &bm_pud[pud_index(addr)]
+					   : (pud_t *)pgd_offset_k(addr);
 }
 
-static inline pmd_t * fixmap_pmd(unsigned long addr)
+static inline pte_t * fixmap_pmd(unsigned long addr)
 {
-	pud_t *pud = fixmap_pud(addr);
-
-	BUG_ON(pud_none(*pud) || pud_bad(*pud));
-
-	return pmd_offset(pud, addr);
+	return (CONFIG_PGTABLE_LEVELS > 2) ? &bm_pmd[pmd_index(addr)]
+					   : (pmd_t *)pgd_offset_k(addr);
 }
 
 static inline pte_t * fixmap_pte(unsigned long addr)
 {
-	pmd_t *pmd = fixmap_pmd(addr);
-
-	BUG_ON(pmd_none(*pmd) || pmd_bad(*pmd));
-
-	return pte_offset_kernel(pmd, addr);
+	return &bm_pte[pte_index(addr)];
 }
 
 void __init early_fixmap_init(void)
@@ -613,14 +599,14 @@ void __init early_fixmap_init(void)
 
 	pgd = pgd_offset_k(addr);
 	pgd_populate(&init_mm, pgd, bm_pud);
-	pud = pud_offset(pgd, addr);
+	pud = fixmap_pud(addr);
 	pud_populate(&init_mm, pud, bm_pmd);
-	pmd = pmd_offset(pud, addr);
+	pmd = fixmap_pmd(addr);
 	pmd_populate_kernel(&init_mm, pmd, bm_pte);
 
 	/*
 	 * The boot-ioremap range spans multiple pmds, for which
-	 * we are not preparted:
+	 * we are not prepared:
 	 */
 	BUILD_BUG_ON((__fix_to_virt(FIX_BTMAP_BEGIN) >> PMD_SHIFT)
 		     != (__fix_to_virt(FIX_BTMAP_END) >> PMD_SHIFT));
-- 
2.5.0
