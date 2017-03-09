From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Thu,  9 Mar 2017 09:25:11 +0100
Message-Id: <1489047912-642-10-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1489047912-642-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1489047912-642-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v5 09/10] arm64/mmu: replace 'page_mappings_only' parameter with flags argument
To: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, keescook@chromium.org, labbott@fedoraproject.org
Cc: kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

In preparation of extending the policy for manipulating kernel mappings
with whether or not contiguous hints may be used in the page tables,
replace the bool 'page_mappings_only' with a flags field and a flag
NO_BLOCK_MAPPINGS.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/mm/mmu.c | 45 ++++++++++++--------
 1 file changed, 27 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index a6d7a86dd2b8..9babafa253cf 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -43,6 +43,8 @@
 #include <asm/mmu_context.h>
 #include <asm/ptdump.h>
 
+#define NO_BLOCK_MAPPINGS	BIT(0)
+
 u64 idmap_t0sz = TCR_T0SZ(VA_BITS);
 
 u64 kimage_voffset __ro_after_init;
@@ -153,7 +155,7 @@ static void alloc_init_pte(pmd_t *pmd, unsigned long addr,
 static void alloc_init_pmd(pud_t *pud, unsigned long addr, unsigned long end,
 				  phys_addr_t phys, pgprot_t prot,
 				  phys_addr_t (*pgtable_alloc)(void),
-				  bool page_mappings_only)
+				  int flags)
 {
 	pmd_t *pmd;
 	unsigned long next;
@@ -180,7 +182,7 @@ static void alloc_init_pmd(pud_t *pud, unsigned long addr, unsigned long end,
 
 		/* try section mapping first */
 		if (((addr | next | phys) & ~SECTION_MASK) == 0 &&
-		      !page_mappings_only) {
+		    (flags & NO_BLOCK_MAPPINGS) == 0) {
 			pmd_set_huge(pmd, phys, prot);
 
 			/*
@@ -217,7 +219,7 @@ static inline bool use_1G_block(unsigned long addr, unsigned long next,
 static void alloc_init_pud(pgd_t *pgd, unsigned long addr, unsigned long end,
 				  phys_addr_t phys, pgprot_t prot,
 				  phys_addr_t (*pgtable_alloc)(void),
-				  bool page_mappings_only)
+				  int flags)
 {
 	pud_t *pud;
 	unsigned long next;
@@ -239,7 +241,8 @@ static void alloc_init_pud(pgd_t *pgd, unsigned long addr, unsigned long end,
 		/*
 		 * For 4K granule only, attempt to put down a 1GB block
 		 */
-		if (use_1G_block(addr, next, phys) && !page_mappings_only) {
+		if (use_1G_block(addr, next, phys) &&
+		    (flags & NO_BLOCK_MAPPINGS) == 0) {
 			pud_set_huge(pud, phys, prot);
 
 			/*
@@ -250,7 +253,7 @@ static void alloc_init_pud(pgd_t *pgd, unsigned long addr, unsigned long end,
 						      pud_val(*pud)));
 		} else {
 			alloc_init_pmd(pud, addr, next, phys, prot,
-				       pgtable_alloc, page_mappings_only);
+				       pgtable_alloc, flags);
 
 			BUG_ON(pud_val(old_pud) != 0 &&
 			       pud_val(old_pud) != pud_val(*pud));
@@ -265,7 +268,7 @@ static void __create_pgd_mapping(pgd_t *pgdir, phys_addr_t phys,
 				 unsigned long virt, phys_addr_t size,
 				 pgprot_t prot,
 				 phys_addr_t (*pgtable_alloc)(void),
-				 bool page_mappings_only)
+				 int flags)
 {
 	unsigned long addr, length, end, next;
 	pgd_t *pgd = pgd_offset_raw(pgdir, virt);
@@ -285,7 +288,7 @@ static void __create_pgd_mapping(pgd_t *pgdir, phys_addr_t phys,
 	do {
 		next = pgd_addr_end(addr, end);
 		alloc_init_pud(pgd, addr, next, phys, prot, pgtable_alloc,
-			       page_mappings_only);
+			       flags);
 		phys += next - addr;
 	} while (pgd++, addr = next, addr != end);
 }
@@ -314,17 +317,22 @@ static void __init create_mapping_noalloc(phys_addr_t phys, unsigned long virt,
 			&phys, virt);
 		return;
 	}
-	__create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL, false);
+	__create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL, 0);
 }
 
 void __init create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
 			       unsigned long virt, phys_addr_t size,
 			       pgprot_t prot, bool page_mappings_only)
 {
+	int flags;
+
 	BUG_ON(mm == &init_mm);
 
+	if (page_mappings_only)
+		flags = NO_BLOCK_MAPPINGS;
+
 	__create_pgd_mapping(mm->pgd, phys, virt, size, prot,
-			     pgd_pgtable_alloc, page_mappings_only);
+			     pgd_pgtable_alloc, flags);
 }
 
 static void update_mapping_prot(phys_addr_t phys, unsigned long virt,
@@ -336,7 +344,7 @@ static void update_mapping_prot(phys_addr_t phys, unsigned long virt,
 		return;
 	}
 
-	__create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL, false);
+	__create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL, 0);
 
 	/* flush the TLBs after updating live kernel mappings */
 	flush_tlb_kernel_range(virt, virt + size);
@@ -346,6 +354,10 @@ static void __init __map_memblock(pgd_t *pgd, phys_addr_t start, phys_addr_t end
 {
 	phys_addr_t kernel_start = __pa_symbol(_text);
 	phys_addr_t kernel_end = __pa_symbol(__init_begin);
+	int flags = 0;
+
+	if (debug_pagealloc_enabled())
+		flags = NO_BLOCK_MAPPINGS;
 
 	/*
 	 * Take care not to create a writable alias for the
@@ -356,8 +368,7 @@ static void __init __map_memblock(pgd_t *pgd, phys_addr_t start, phys_addr_t end
 	if (end < kernel_start || start >= kernel_end) {
 		__create_pgd_mapping(pgd, start, __phys_to_virt(start),
 				     end - start, PAGE_KERNEL,
-				     early_pgtable_alloc,
-				     debug_pagealloc_enabled());
+				     early_pgtable_alloc, flags);
 		return;
 	}
 
@@ -369,14 +380,12 @@ static void __init __map_memblock(pgd_t *pgd, phys_addr_t start, phys_addr_t end
 		__create_pgd_mapping(pgd, start,
 				     __phys_to_virt(start),
 				     kernel_start - start, PAGE_KERNEL,
-				     early_pgtable_alloc,
-				     debug_pagealloc_enabled());
+				     early_pgtable_alloc, flags);
 	if (kernel_end < end)
 		__create_pgd_mapping(pgd, kernel_end,
 				     __phys_to_virt(kernel_end),
 				     end - kernel_end, PAGE_KERNEL,
-				     early_pgtable_alloc,
-				     debug_pagealloc_enabled());
+				     early_pgtable_alloc, flags);
 
 	/*
 	 * Map the linear alias of the [_text, __init_begin) interval
@@ -388,7 +397,7 @@ static void __init __map_memblock(pgd_t *pgd, phys_addr_t start, phys_addr_t end
 	 */
 	__create_pgd_mapping(pgd, kernel_start, __phys_to_virt(kernel_start),
 			     kernel_end - kernel_start, PAGE_KERNEL,
-			     early_pgtable_alloc, false);
+			     early_pgtable_alloc, 0);
 }
 
 void __init mark_linear_text_alias_ro(void)
@@ -444,7 +453,7 @@ static void __init map_kernel_segment(pgd_t *pgd, void *va_start, void *va_end,
 	BUG_ON(!PAGE_ALIGNED(size));
 
 	__create_pgd_mapping(pgd, pa_start, (unsigned long)va_start, size, prot,
-			     early_pgtable_alloc, false);
+			     early_pgtable_alloc, 0);
 
 	vma->addr	= va_start;
 	vma->phys_addr	= pa_start;
-- 
2.7.4
