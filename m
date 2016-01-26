Reply-To: kernel-hardening@lists.openwall.com
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Tue, 26 Jan 2016 18:10:31 +0100
Message-Id: <1453828249-14467-5-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1453828249-14467-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1453828249-14467-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v4 04/22] arm64: decouple early fixmap init from linear mapping
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, linux-kernel@vger.kernel.org
Cc: stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, arnd@arndb.de, marc.zyngier@arm.com, christoffer.dall@linaro.org, labbott@fedoraproject.org, matt@codeblueprint.co.uk, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

Since the early fixmap page tables are populated using pages that are
part of the static footprint of the kernel, they are covered by the
initial kernel mapping, and we can refer to them without using __va/__pa
translations, which are tied to the linear mapping.

Since the fixmap page tables are disjoint from the kernel mapping up
to the top level pgd entry, we can refer to bm_pte[] directly, and there
is no need to walk the page tables and perform __pa()/__va() translations
at each step.

Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/mm/mmu.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 7711554a94f4..cb3a7bdb4e23 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -583,7 +583,7 @@ static inline pud_t * fixmap_pud(unsigned long addr)
 
 	BUG_ON(pgd_none(*pgd) || pgd_bad(*pgd));
 
-	return pud_offset(pgd, addr);
+	return pud_offset_kimg(pgd, addr);
 }
 
 static inline pmd_t * fixmap_pmd(unsigned long addr)
@@ -592,16 +592,12 @@ static inline pmd_t * fixmap_pmd(unsigned long addr)
 
 	BUG_ON(pud_none(*pud) || pud_bad(*pud));
 
-	return pmd_offset(pud, addr);
+	return pmd_offset_kimg(pud, addr);
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
@@ -613,14 +609,14 @@ void __init early_fixmap_init(void)
 
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
