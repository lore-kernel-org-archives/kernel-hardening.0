From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Sat,  4 Mar 2017 14:30:48 +0000
Message-Id: <1488637848-13588-7-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1488637848-13588-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1488637848-13588-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v4 6/6] arm64: mm: set the contiguous bit for kernel mappings where appropriate
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, mark.rutland@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, labbott@fedoraproject.org
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, keescook@chromium.org, andre.przywara@arm.com, james.morse@arm.com, suzuki.poulose@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
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
 arch/arm64/mm/mmu.c | 86 ++++++++++++++------
 1 file changed, 63 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 0612573ef869..d0ae2f1f44fc 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -109,8 +109,10 @@ static bool pgattr_change_is_safe(u64 old, u64 new)
 static void alloc_init_pte(pmd_t *pmd, unsigned long addr,
 				  unsigned long end, unsigned long pfn,
 				  pgprot_t prot,
-				  phys_addr_t (*pgtable_alloc)(void))
+				  phys_addr_t (*pgtable_alloc)(void),
+				  bool may_use_cont)
 {
+	pgprot_t __prot = prot;
 	pte_t *pte;
 
 	BUG_ON(pmd_sect(*pmd));
@@ -128,7 +130,19 @@ static void alloc_init_pte(pmd_t *pmd, unsigned long addr,
 	do {
 		pte_t old_pte = *pte;
 
-		set_pte(pte, pfn_pte(pfn, prot));
+		/*
+		 * Set the contiguous bit for the subsequent group of PTEs if
+		 * its size and alignment are appropriate.
+		 */
+		if (may_use_cont &&
+		    ((addr | PFN_PHYS(pfn)) & ~CONT_PTE_MASK) == 0) {
+			if (end - addr >= CONT_PTE_SIZE)
+				__prot = __pgprot(pgprot_val(prot) | PTE_CONT);
+			else
+				__prot = prot;
+		}
+
+		set_pte(pte, pfn_pte(pfn, __prot));
 		pfn++;
 
 		/*
@@ -145,8 +159,10 @@ static void alloc_init_pte(pmd_t *pmd, unsigned long addr,
 static void alloc_init_pmd(pud_t *pud, unsigned long addr, unsigned long end,
 				  phys_addr_t phys, pgprot_t prot,
 				  phys_addr_t (*pgtable_alloc)(void),
-				  bool page_mappings_only)
+				  bool page_mappings_only,
+				  bool may_use_cont)
 {
+	pgprot_t __prot = prot;
 	pmd_t *pmd;
 	unsigned long next;
 
@@ -173,7 +189,19 @@ static void alloc_init_pmd(pud_t *pud, unsigned long addr, unsigned long end,
 		/* try section mapping first */
 		if (((addr | next | phys) & ~SECTION_MASK) == 0 &&
 		      !page_mappings_only) {
-			pmd_set_huge(pmd, phys, prot);
+			/*
+			 * Set the contiguous bit for the subsequent group of
+			 * PMDs if its size and alignment are appropriate.
+			 */
+			if (may_use_cont &&
+			    ((addr | phys) & ~CONT_PMD_MASK) == 0) {
+				if (end - addr >= CONT_PMD_SIZE)
+					__prot = __pgprot(pgprot_val(prot) |
+							  PTE_CONT);
+				else
+					__prot = prot;
+			}
+			pmd_set_huge(pmd, phys, __prot);
 
 			/*
 			 * After the PMD entry has been populated once, we
@@ -183,7 +211,7 @@ static void alloc_init_pmd(pud_t *pud, unsigned long addr, unsigned long end,
 						      pmd_val(*pmd)));
 		} else {
 			alloc_init_pte(pmd, addr, next, __phys_to_pfn(phys),
-				       prot, pgtable_alloc);
+				       prot, pgtable_alloc, may_use_cont);
 
 			BUG_ON(pmd_val(old_pmd) != 0 &&
 			       pmd_val(old_pmd) != pmd_val(*pmd));
@@ -209,7 +237,8 @@ static inline bool use_1G_block(unsigned long addr, unsigned long next,
 static void alloc_init_pud(pgd_t *pgd, unsigned long addr, unsigned long end,
 				  phys_addr_t phys, pgprot_t prot,
 				  phys_addr_t (*pgtable_alloc)(void),
-				  bool page_mappings_only)
+				  bool page_mappings_only,
+				  bool may_use_cont)
 {
 	pud_t *pud;
 	unsigned long next;
@@ -242,7 +271,8 @@ static void alloc_init_pud(pgd_t *pgd, unsigned long addr, unsigned long end,
 						      pud_val(*pud)));
 		} else {
 			alloc_init_pmd(pud, addr, next, phys, prot,
-				       pgtable_alloc, page_mappings_only);
+				       pgtable_alloc, page_mappings_only,
+				       may_use_cont);
 
 			BUG_ON(pud_val(old_pud) != 0 &&
 			       pud_val(old_pud) != pud_val(*pud));
@@ -257,11 +287,14 @@ static void __create_pgd_mapping(pgd_t *pgdir, phys_addr_t phys,
 				 unsigned long virt, phys_addr_t size,
 				 pgprot_t prot,
 				 phys_addr_t (*pgtable_alloc)(void),
-				 bool page_mappings_only)
+				 bool page_mappings_only,
+				 bool may_use_cont)
 {
 	unsigned long addr, length, end, next;
 	pgd_t *pgd = pgd_offset_raw(pgdir, virt);
 
+	BUG_ON(page_mappings_only && may_use_cont); /* sanity check */
+
 	/*
 	 * If the virtual and physical address don't have the same offset
 	 * within a page, we cannot map the region as the caller expects.
@@ -277,7 +310,7 @@ static void __create_pgd_mapping(pgd_t *pgdir, phys_addr_t phys,
 	do {
 		next = pgd_addr_end(addr, end);
 		alloc_init_pud(pgd, addr, next, phys, prot, pgtable_alloc,
-			       page_mappings_only);
+			       page_mappings_only, may_use_cont);
 		phys += next - addr;
 	} while (pgd++, addr = next, addr != end);
 }
@@ -306,7 +339,8 @@ static void __init create_mapping_noalloc(phys_addr_t phys, unsigned long virt,
 			&phys, virt);
 		return;
 	}
-	__create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL, false);
+	__create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL, false,
+			     false);
 }
 
 void __init create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
@@ -316,7 +350,7 @@ void __init create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
 	BUG_ON(mm == &init_mm);
 
 	__create_pgd_mapping(mm->pgd, phys, virt, size, prot,
-			     pgd_pgtable_alloc, page_mappings_only);
+			     pgd_pgtable_alloc, page_mappings_only, false);
 }
 
 static void update_mapping_prot(phys_addr_t phys, unsigned long virt,
@@ -329,7 +363,7 @@ static void update_mapping_prot(phys_addr_t phys, unsigned long virt,
 	}
 
 	__create_pgd_mapping(init_mm.pgd, phys, virt, size, prot,
-			     NULL, debug_pagealloc_enabled());
+			     NULL, debug_pagealloc_enabled(), false);
 
 	/* flush the TLBs after updating live kernel mappings */
 	flush_tlb_kernel_range(virt, virt + size);
@@ -350,7 +384,8 @@ static void __init __map_memblock(pgd_t *pgd, phys_addr_t start, phys_addr_t end
 		__create_pgd_mapping(pgd, start, __phys_to_virt(start),
 				     end - start, PAGE_KERNEL,
 				     early_pgtable_alloc,
-				     debug_pagealloc_enabled());
+				     debug_pagealloc_enabled(),
+				     !debug_pagealloc_enabled());
 		return;
 	}
 
@@ -363,13 +398,15 @@ static void __init __map_memblock(pgd_t *pgd, phys_addr_t start, phys_addr_t end
 				     __phys_to_virt(start),
 				     kernel_start - start, PAGE_KERNEL,
 				     early_pgtable_alloc,
-				     debug_pagealloc_enabled());
+				     debug_pagealloc_enabled(),
+				     !debug_pagealloc_enabled());
 	if (kernel_end < end)
 		__create_pgd_mapping(pgd, kernel_end,
 				     __phys_to_virt(kernel_end),
 				     end - kernel_end, PAGE_KERNEL,
 				     early_pgtable_alloc,
-				     debug_pagealloc_enabled());
+				     debug_pagealloc_enabled(),
+				     !debug_pagealloc_enabled());
 
 	/*
 	 * Map the linear alias of the [_text, __init_begin) interval
@@ -381,7 +418,8 @@ static void __init __map_memblock(pgd_t *pgd, phys_addr_t start, phys_addr_t end
 	 */
 	__create_pgd_mapping(pgd, kernel_start, __phys_to_virt(kernel_start),
 			     kernel_end - kernel_start, PAGE_KERNEL,
-			     early_pgtable_alloc, debug_pagealloc_enabled());
+			     early_pgtable_alloc, debug_pagealloc_enabled(),
+			     false);
 }
 
 void __init mark_linear_text_alias_ro(void)
@@ -428,7 +466,8 @@ void mark_rodata_ro(void)
 }
 
 static void __init map_kernel_segment(pgd_t *pgd, void *va_start, void *va_end,
-				      pgprot_t prot, struct vm_struct *vma)
+				      pgprot_t prot, struct vm_struct *vma,
+				      bool may_use_cont)
 {
 	phys_addr_t pa_start = __pa_symbol(va_start);
 	unsigned long size = va_end - va_start;
@@ -437,7 +476,8 @@ static void __init map_kernel_segment(pgd_t *pgd, void *va_start, void *va_end,
 	BUG_ON(!PAGE_ALIGNED(size));
 
 	__create_pgd_mapping(pgd, pa_start, (unsigned long)va_start, size, prot,
-			     early_pgtable_alloc, debug_pagealloc_enabled());
+			     early_pgtable_alloc, debug_pagealloc_enabled(),
+			     !debug_pagealloc_enabled() && may_use_cont);
 
 	vma->addr	= va_start;
 	vma->phys_addr	= pa_start;
@@ -464,14 +504,14 @@ static void __init map_kernel(pgd_t *pgd)
 
 	pgprot_t text_prot = rodata_enabled ? PAGE_KERNEL_ROX : PAGE_KERNEL_EXEC;
 
-	map_kernel_segment(pgd, _text, _etext, text_prot, &vmlinux_text);
+	map_kernel_segment(pgd, _text, _etext, text_prot, &vmlinux_text, true);
 	map_kernel_segment(pgd, __start_rodata, __inittext_begin, PAGE_KERNEL,
-			   &vmlinux_rodata);
+			   &vmlinux_rodata, false);
 	map_kernel_segment(pgd, __inittext_begin, __inittext_end, text_prot,
-			   &vmlinux_inittext);
+			   &vmlinux_inittext, true);
 	map_kernel_segment(pgd, __initdata_begin, __initdata_end, PAGE_KERNEL,
-			   &vmlinux_initdata);
-	map_kernel_segment(pgd, _data, _end, PAGE_KERNEL, &vmlinux_data);
+			   &vmlinux_initdata, true);
+	map_kernel_segment(pgd, _data, _end, PAGE_KERNEL, &vmlinux_data, true);
 
 	if (!pgd_val(*pgd_offset_raw(pgd, FIXADDR_START))) {
 		/*
-- 
2.7.4
