Reply-To: kernel-hardening@lists.openwall.com
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 28 Dec 2015 12:20:47 +0100
Message-Id: <1451301654-32019-4-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1451301654-32019-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1451301654-32019-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [RFC PATCH 03/10] arm64: decouple early fixmap init from linear mapping
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, lkml@vger.kernel.org
Cc: stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

Since the early fixmap page tables are populated using pages that are
part of the static footprint of the kernel, they are covered by the
initial kernel mapping, and we can refer to them without using __va/__pa
translations, which are tied to the linear mapping.

Instead, let's introduce __phys_to_kimg, which will be tied to the kernel
virtual mapping, regardless of whether or not it intersects with the linear
mapping. This will allow us to move the kernel out of the linear mapping in
a subsequent patch.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/compiler.h |  2 +
 arch/arm64/kernel/vmlinux.lds.S   | 12 +--
 arch/arm64/mm/mmu.c               | 85 ++++++++------------
 3 files changed, 42 insertions(+), 57 deletions(-)

diff --git a/arch/arm64/include/asm/compiler.h b/arch/arm64/include/asm/compiler.h
index ee35fd0f2236..dd342af63673 100644
--- a/arch/arm64/include/asm/compiler.h
+++ b/arch/arm64/include/asm/compiler.h
@@ -27,4 +27,6 @@
  */
 #define __asmeq(x, y)  ".ifnc " x "," y " ; .err ; .endif\n\t"
 
+#define __pgdir		__attribute__((section(".pgdir"),aligned(PAGE_SIZE)))
+
 #endif	/* __ASM_COMPILER_H */
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index ced0dedcabcc..363c2f529951 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -160,11 +160,13 @@ SECTIONS
 
 	BSS_SECTION(0, 0, 0)
 
-	. = ALIGN(PAGE_SIZE);
-	idmap_pg_dir = .;
-	. += IDMAP_DIR_SIZE;
-	swapper_pg_dir = .;
-	. += SWAPPER_DIR_SIZE;
+	.pgdir (NOLOAD) : ALIGN(PAGE_SIZE) {
+		idmap_pg_dir = .;
+		. += IDMAP_DIR_SIZE;
+		swapper_pg_dir = .;
+		. += SWAPPER_DIR_SIZE;
+		*(.pgdir)
+	}
 
 	_end = .;
 
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 50b1de8e127b..3435c316d607 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -540,39 +540,11 @@ void vmemmap_free(unsigned long start, unsigned long end)
 }
 #endif	/* CONFIG_SPARSEMEM_VMEMMAP */
 
-static pte_t bm_pte[PTRS_PER_PTE] __page_aligned_bss;
-#if CONFIG_PGTABLE_LEVELS > 2
-static pmd_t bm_pmd[PTRS_PER_PMD] __page_aligned_bss;
-#endif
-#if CONFIG_PGTABLE_LEVELS > 3
-static pud_t bm_pud[PTRS_PER_PUD] __page_aligned_bss;
-#endif
-
-static inline pud_t * fixmap_pud(unsigned long addr)
-{
-	pgd_t *pgd = pgd_offset_k(addr);
-
-	BUG_ON(pgd_none(*pgd) || pgd_bad(*pgd));
-
-	return pud_offset(pgd, addr);
-}
-
-static inline pmd_t * fixmap_pmd(unsigned long addr)
-{
-	pud_t *pud = fixmap_pud(addr);
-
-	BUG_ON(pud_none(*pud) || pud_bad(*pud));
+static pte_t *__fixmap_pte;
 
-	return pmd_offset(pud, addr);
-}
-
-static inline pte_t * fixmap_pte(unsigned long addr)
+static inline pte_t *fixmap_pte(unsigned long addr)
 {
-	pmd_t *pmd = fixmap_pmd(addr);
-
-	BUG_ON(pmd_none(*pmd) || pmd_bad(*pmd));
-
-	return pte_offset_kernel(pmd, addr);
+	return __fixmap_pte + pte_index(addr);
 }
 
 void __init early_fixmap_init(void)
@@ -583,33 +555,42 @@ void __init early_fixmap_init(void)
 	unsigned long addr = FIXADDR_START;
 
 	pgd = pgd_offset_k(addr);
-	pgd_populate(&init_mm, pgd, bm_pud);
-	pud = pud_offset(pgd, addr);
-	pud_populate(&init_mm, pud, bm_pmd);
-	pmd = pmd_offset(pud, addr);
-	pmd_populate_kernel(&init_mm, pmd, bm_pte);
+#if CONFIG_PGTABLE_LEVELS > 3
+	if (pgd_none(*pgd)) {
+		static pud_t bm_pud[PTRS_PER_PUD] __pgdir;
+
+		__pgd_populate(pgd, __pa(bm_pud), PUD_TYPE_TABLE);
+		memblock_reserve(__pa(bm_pud), sizeof(bm_pud));
+	}
+	pud = (pud_t *)__phys_to_kimg(pud_offset_phys(pgd, addr));
+#else
+	pud = (pud_t *)pgd;
+#endif
+#if CONFIG_PGTABLE_LEVELS > 2
+	if (pud_none(*pud)) {
+		static pmd_t bm_pmd[PTRS_PER_PMD] __pgdir;
+
+		__pud_populate(pud, __pa(bm_pmd), PMD_TYPE_TABLE);
+		memblock_reserve(__pa(bm_pmd), sizeof(bm_pmd));
+	}
+	pmd = (pmd_t *)__phys_to_kimg(pmd_offset_phys(pud, addr));
+#else
+	pmd = (pmd_t *)pud;
+#endif
+	if (pmd_none(*pmd)) {
+		static pte_t bm_pte[PTRS_PER_PTE] __pgdir;
+
+		__pmd_populate(pmd, __pa(bm_pte), PMD_TYPE_TABLE);
+		memblock_reserve(__pa(bm_pte), sizeof(bm_pte));
+	}
+	__fixmap_pte = (pte_t *)__phys_to_kimg(pmd_page_paddr(*pmd));
 
 	/*
 	 * The boot-ioremap range spans multiple pmds, for which
-	 * we are not preparted:
+	 * we are not prepared:
 	 */
 	BUILD_BUG_ON((__fix_to_virt(FIX_BTMAP_BEGIN) >> PMD_SHIFT)
 		     != (__fix_to_virt(FIX_BTMAP_END) >> PMD_SHIFT));
-
-	if ((pmd != fixmap_pmd(fix_to_virt(FIX_BTMAP_BEGIN)))
-	     || pmd != fixmap_pmd(fix_to_virt(FIX_BTMAP_END))) {
-		WARN_ON(1);
-		pr_warn("pmd %p != %p, %p\n",
-			pmd, fixmap_pmd(fix_to_virt(FIX_BTMAP_BEGIN)),
-			fixmap_pmd(fix_to_virt(FIX_BTMAP_END)));
-		pr_warn("fix_to_virt(FIX_BTMAP_BEGIN): %08lx\n",
-			fix_to_virt(FIX_BTMAP_BEGIN));
-		pr_warn("fix_to_virt(FIX_BTMAP_END):   %08lx\n",
-			fix_to_virt(FIX_BTMAP_END));
-
-		pr_warn("FIX_BTMAP_END:       %d\n", FIX_BTMAP_END);
-		pr_warn("FIX_BTMAP_BEGIN:     %d\n", FIX_BTMAP_BEGIN);
-	}
 }
 
 void __set_fixmap(enum fixed_addresses idx,
-- 
2.5.0
