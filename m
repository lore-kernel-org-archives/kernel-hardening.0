From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Thu,  9 Mar 2017 09:25:12 +0100
Message-Id: <1489047912-642-11-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1489047912-642-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1489047912-642-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v5 10/10] arm64: mm: set the contiguous bit for kernel mappings where appropriate
To: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, keescook@chromium.org, labbott@fedoraproject.org
Cc: kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

This is the third attempt at enabling the use of contiguous hints for
kernel mappings. The most recent attempt 0bfc445dec9d was reverted after
it turned out that updating permission attributes on live contiguous ranges
may result in TLB conflicts. So this time, the contiguous hint is not set
for .rodata or for the linear alias of .text/.rodata, both of which are
mapped read-write initially, and remapped read-only at a later stage.
(Note that the latter region could also be unmapped and remapped again
with updated permission attributes, given that the region, while live, is
only mapped for the convenience of the hibernation code, but that also
means the TLB footprint is negligible anyway, so why bother)

This enables the following contiguous range sizes for the virtual mapping
of the kernel image, and for the linear mapping:

          granule size |  cont PTE  |  cont PMD  |
          -------------+------------+------------+
               4 KB    |    64 KB   |   32 MB    |
              16 KB    |     2 MB   |    1 GB*   |
              64 KB    |     2 MB   |   16 GB*   |

* Only when built for 3 or more levels of translation. This is due to the
  fact that a 2 level configuration only consists of PGDs and PTEs, and the
  added complexity of dealing with folded PMDs is not justified considering
  that 16 GB contiguous ranges are likely to be ignored by the hardware (and
  16k/2 levels is a niche configuration)

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/pgtable.h |  10 ++
 arch/arm64/mm/mmu.c              | 154 +++++++++++++-------
 2 files changed, 114 insertions(+), 50 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 0eef6064bf3b..f10a7bf81849 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -74,6 +74,16 @@ extern unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)];
 #define pte_user_exec(pte)	(!(pte_val(pte) & PTE_UXN))
 #define pte_cont(pte)		(!!(pte_val(pte) & PTE_CONT))
 
+static inline u64 pte_cont_addr_end(u64 addr, u64 end)
+{
+	return min((addr + CONT_PTE_SIZE) & CONT_PTE_MASK, end);
+}
+
+static inline u64 pmd_cont_addr_end(u64 addr, u64 end)
+{
+	return min((addr + CONT_PMD_SIZE) & CONT_PMD_MASK, end);
+}
+
 #ifdef CONFIG_ARM64_HW_AFDBM
 #define pte_hw_dirty(pte)	(pte_write(pte) && !(pte_val(pte) & PTE_RDONLY))
 #else
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 9babafa253cf..e2ffab56c1a6 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -44,6 +44,7 @@
 #include <asm/ptdump.h>
 
 #define NO_BLOCK_MAPPINGS	BIT(0)
+#define NO_CONT_MAPPINGS	BIT(1)
 
 u64 idmap_t0sz = TCR_T0SZ(VA_BITS);
 
@@ -116,11 +117,30 @@ static bool pgattr_change_is_safe(u64 old, u64 new)
 	return ((old ^ new) & ~mask) == 0;
 }
 
-static void alloc_init_pte(pmd_t *pmd, unsigned long addr,
-				  unsigned long end, phys_addr_t phys,
-				  pgprot_t prot,
-				  phys_addr_t (*pgtable_alloc)(void))
+static void init_pte(pte_t *pte, unsigned long addr, unsigned long end,
+		     phys_addr_t phys, pgprot_t prot)
 {
+	do {
+		pte_t old_pte = *pte;
+
+		set_pte(pte, pfn_pte(__phys_to_pfn(phys), prot));
+
+		/*
+		 * After the PTE entry has been populated once, we
+		 * only allow updates to the permission attributes.
+		 */
+		BUG_ON(!pgattr_change_is_safe(pte_val(old_pte), pte_val(*pte)));
+
+	} while (pte++, addr += PAGE_SIZE, phys += PAGE_SIZE, addr != end);
+}
+
+static void alloc_init_cont_pte(pmd_t *pmd, unsigned long addr,
+				unsigned long end, phys_addr_t phys,
+				pgprot_t prot,
+				phys_addr_t (*pgtable_alloc)(void),
+				int flags)
+{
+	unsigned long next;
 	pte_t *pte;
 
 	BUG_ON(pmd_sect(*pmd));
@@ -136,45 +156,30 @@ static void alloc_init_pte(pmd_t *pmd, unsigned long addr,
 
 	pte = pte_set_fixmap_offset(pmd, addr);
 	do {
-		pte_t old_pte = *pte;
+		pgprot_t __prot = prot;
 
-		set_pte(pte, pfn_pte(__phys_to_pfn(phys), prot));
-		phys += PAGE_SIZE;
+		next = pte_cont_addr_end(addr, end);
 
-		/*
-		 * After the PTE entry has been populated once, we
-		 * only allow updates to the permission attributes.
-		 */
-		BUG_ON(!pgattr_change_is_safe(pte_val(old_pte), pte_val(*pte)));
+		/* use a contiguous mapping if the range is suitably aligned */
+		if ((((addr | next | phys) & ~CONT_PTE_MASK) == 0) &&
+		    (flags & NO_CONT_MAPPINGS) == 0)
+			__prot = __pgprot(pgprot_val(prot) | PTE_CONT);
 
-	} while (pte++, addr += PAGE_SIZE, addr != end);
+		init_pte(pte, addr, next, phys, __prot);
+
+		phys += next - addr;
+		pte += (next - addr) / PAGE_SIZE;
+	} while (addr = next, addr != end);
 
 	pte_clear_fixmap();
 }
 
-static void alloc_init_pmd(pud_t *pud, unsigned long addr, unsigned long end,
-				  phys_addr_t phys, pgprot_t prot,
-				  phys_addr_t (*pgtable_alloc)(void),
-				  int flags)
+static void init_pmd(pmd_t *pmd, unsigned long addr, unsigned long end,
+		     phys_addr_t phys, pgprot_t prot,
+		     phys_addr_t (*pgtable_alloc)(void), int flags)
 {
-	pmd_t *pmd;
 	unsigned long next;
 
-	/*
-	 * Check for initial section mappings in the pgd/pud and remove them.
-	 */
-	BUG_ON(pud_sect(*pud));
-	if (pud_none(*pud)) {
-		phys_addr_t pmd_phys;
-		BUG_ON(!pgtable_alloc);
-		pmd_phys = pgtable_alloc();
-		pmd = pmd_set_fixmap(pmd_phys);
-		__pud_populate(pud, pmd_phys, PUD_TYPE_TABLE);
-		pmd_clear_fixmap();
-	}
-	BUG_ON(pud_bad(*pud));
-
-	pmd = pmd_set_fixmap_offset(pud, addr);
 	do {
 		pmd_t old_pmd = *pmd;
 
@@ -192,14 +197,54 @@ static void alloc_init_pmd(pud_t *pud, unsigned long addr, unsigned long end,
 			BUG_ON(!pgattr_change_is_safe(pmd_val(old_pmd),
 						      pmd_val(*pmd)));
 		} else {
-			alloc_init_pte(pmd, addr, next, phys,
-				       prot, pgtable_alloc);
+			alloc_init_cont_pte(pmd, addr, next, phys, prot,
+					    pgtable_alloc, flags);
 
 			BUG_ON(pmd_val(old_pmd) != 0 &&
 			       pmd_val(old_pmd) != pmd_val(*pmd));
 		}
 		phys += next - addr;
 	} while (pmd++, addr = next, addr != end);
+}
+
+static void alloc_init_cont_pmd(pud_t *pud, unsigned long addr,
+				unsigned long end, phys_addr_t phys,
+				pgprot_t prot,
+				phys_addr_t (*pgtable_alloc)(void), int flags)
+{
+	unsigned long next;
+	pmd_t *pmd;
+
+	/*
+	 * Check for initial section mappings in the pgd/pud.
+	 */
+	BUG_ON(pud_sect(*pud));
+	if (pud_none(*pud)) {
+		phys_addr_t pmd_phys;
+		BUG_ON(!pgtable_alloc);
+		pmd_phys = pgtable_alloc();
+		pmd = pmd_set_fixmap(pmd_phys);
+		__pud_populate(pud, pmd_phys, PUD_TYPE_TABLE);
+		pmd_clear_fixmap();
+	}
+	BUG_ON(pud_bad(*pud));
+
+	pmd = pmd_set_fixmap_offset(pud, addr);
+	do {
+		pgprot_t __prot = prot;
+
+		next = pmd_cont_addr_end(addr, end);
+
+		/* use a contiguous mapping if the range is suitably aligned */
+		if ((((addr | next | phys) & ~CONT_PMD_MASK) == 0) &&
+		    (flags & NO_CONT_MAPPINGS) == 0)
+			__prot = __pgprot(pgprot_val(prot) | PTE_CONT);
+
+		init_pmd(pmd, addr, next, phys, __prot, pgtable_alloc, flags);
+
+		phys += next - addr;
+		pmd += (next - (addr & PMD_MASK)) / PMD_SIZE;
+	} while (addr = next, addr != end);
 
 	pmd_clear_fixmap();
 }
@@ -252,8 +297,8 @@ static void alloc_init_pud(pgd_t *pgd, unsigned long addr, unsigned long end,
 			BUG_ON(!pgattr_change_is_safe(pud_val(old_pud),
 						      pud_val(*pud)));
 		} else {
-			alloc_init_pmd(pud, addr, next, phys, prot,
-				       pgtable_alloc, flags);
+			alloc_init_cont_pmd(pud, addr, next, phys, prot,
+					    pgtable_alloc, flags);
 
 			BUG_ON(pud_val(old_pud) != 0 &&
 			       pud_val(old_pud) != pud_val(*pud));
@@ -317,19 +362,20 @@ static void __init create_mapping_noalloc(phys_addr_t phys, unsigned long virt,
 			&phys, virt);
 		return;
 	}
-	__create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL, 0);
+	__create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL,
+			     NO_CONT_MAPPINGS);
 }
 
 void __init create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
 			       unsigned long virt, phys_addr_t size,
 			       pgprot_t prot, bool page_mappings_only)
 {
-	int flags;
+	int flags = NO_CONT_MAPPINGS;
 
 	BUG_ON(mm == &init_mm);
 
 	if (page_mappings_only)
-		flags = NO_BLOCK_MAPPINGS;
+		flags |= NO_BLOCK_MAPPINGS;
 
 	__create_pgd_mapping(mm->pgd, phys, virt, size, prot,
 			     pgd_pgtable_alloc, flags);
@@ -344,7 +390,8 @@ static void update_mapping_prot(phys_addr_t phys, unsigned long virt,
 		return;
 	}
 
-	__create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL, 0);
+	__create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL,
+			     NO_CONT_MAPPINGS);
 
 	/* flush the TLBs after updating live kernel mappings */
 	flush_tlb_kernel_range(virt, virt + size);
@@ -357,7 +404,7 @@ static void __init __map_memblock(pgd_t *pgd, phys_addr_t start, phys_addr_t end
 	int flags = 0;
 
 	if (debug_pagealloc_enabled())
-		flags = NO_BLOCK_MAPPINGS;
+		flags = NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
 
 	/*
 	 * Take care not to create a writable alias for the
@@ -394,10 +441,12 @@ static void __init __map_memblock(pgd_t *pgd, phys_addr_t start, phys_addr_t end
 	 * alternative patching has completed). This makes the contents
 	 * of the region accessible to subsystems such as hibernate,
 	 * but protects it from inadvertent modification or execution.
+	 * Note that contiguous mappings cannot be remapped in this way,
+	 * so we should avoid them here.
 	 */
 	__create_pgd_mapping(pgd, kernel_start, __phys_to_virt(kernel_start),
 			     kernel_end - kernel_start, PAGE_KERNEL,
-			     early_pgtable_alloc, 0);
+			     early_pgtable_alloc, NO_CONT_MAPPINGS);
 }
 
 void __init mark_linear_text_alias_ro(void)
@@ -444,7 +493,8 @@ void mark_rodata_ro(void)
 }
 
 static void __init map_kernel_segment(pgd_t *pgd, void *va_start, void *va_end,
-				      pgprot_t prot, struct vm_struct *vma)
+				      pgprot_t prot, struct vm_struct *vma,
+				      int flags)
 {
 	phys_addr_t pa_start = __pa_symbol(va_start);
 	unsigned long size = va_end - va_start;
@@ -453,7 +503,7 @@ static void __init map_kernel_segment(pgd_t *pgd, void *va_start, void *va_end,
 	BUG_ON(!PAGE_ALIGNED(size));
 
 	__create_pgd_mapping(pgd, pa_start, (unsigned long)va_start, size, prot,
-			     early_pgtable_alloc, 0);
+			     early_pgtable_alloc, flags);
 
 	vma->addr	= va_start;
 	vma->phys_addr	= pa_start;
@@ -485,14 +535,18 @@ static void __init map_kernel(pgd_t *pgd)
 	 */
 	pgprot_t text_prot = rodata_enabled ? PAGE_KERNEL_ROX : PAGE_KERNEL_EXEC;
 
-	map_kernel_segment(pgd, _text, _etext, text_prot, &vmlinux_text);
+	/*
+	 * Only rodata will be remapped with different permissions later on,
+	 * all other segments are allowed to use contiguous mappings.
+	 */
+	map_kernel_segment(pgd, _text, _etext, text_prot, &vmlinux_text, 0);
 	map_kernel_segment(pgd, __start_rodata, __inittext_begin, PAGE_KERNEL,
-			   &vmlinux_rodata);
+			   &vmlinux_rodata, NO_CONT_MAPPINGS);
 	map_kernel_segment(pgd, __inittext_begin, __inittext_end, text_prot,
-			   &vmlinux_inittext);
+			   &vmlinux_inittext, 0);
 	map_kernel_segment(pgd, __initdata_begin, __initdata_end, PAGE_KERNEL,
-			   &vmlinux_initdata);
-	map_kernel_segment(pgd, _data, _end, PAGE_KERNEL, &vmlinux_data);
+			   &vmlinux_initdata, 0);
+	map_kernel_segment(pgd, _data, _end, PAGE_KERNEL, &vmlinux_data, 0);
 
 	if (!pgd_val(*pgd_offset_raw(pgd, FIXADDR_START))) {
 		/*
-- 
2.7.4
