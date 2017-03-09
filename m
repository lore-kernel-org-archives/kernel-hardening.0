From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Thu,  9 Mar 2017 21:52:05 +0100
Message-Id: <1489092729-16871-8-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1489092729-16871-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1489092729-16871-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v6 07/11] arm64/mmu: ignore debug_pagealloc for kernel segments
To: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, keescook@chromium.org, labbott@fedoraproject.org
Cc: kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

The debug_pagealloc facility manipulates kernel mappings in the linear
region at page granularity to detect out of bounds or use-after-free
accesses. Since the kernel segments are not allocated dynamically,
there is no point in taking the debug_pagealloc_enabled flag into
account for them, and we can use block mappings unconditionally.

Note that this applies equally to the linear alias of text/rodata:
we will never have dynamic allocations there given that the same
memory is statically in use by the kernel image.

Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/mm/mmu.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index bb9179084217..ec23aec6433f 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -328,8 +328,7 @@ static void update_mapping_prot(phys_addr_t phys, unsigned long virt,
 		return;
 	}
 
-	__create_pgd_mapping(init_mm.pgd, phys, virt, size, prot,
-			     NULL, debug_pagealloc_enabled());
+	__create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL, false);
 
 	/* flush the TLBs after updating live kernel mappings */
 	flush_tlb_kernel_range(virt, virt + size);
@@ -381,7 +380,7 @@ static void __init __map_memblock(pgd_t *pgd, phys_addr_t start, phys_addr_t end
 	 */
 	__create_pgd_mapping(pgd, kernel_start, __phys_to_virt(kernel_start),
 			     kernel_end - kernel_start, PAGE_KERNEL,
-			     early_pgtable_alloc, debug_pagealloc_enabled());
+			     early_pgtable_alloc, false);
 }
 
 void __init mark_linear_text_alias_ro(void)
@@ -437,7 +436,7 @@ static void __init map_kernel_segment(pgd_t *pgd, void *va_start, void *va_end,
 	BUG_ON(!PAGE_ALIGNED(size));
 
 	__create_pgd_mapping(pgd, pa_start, (unsigned long)va_start, size, prot,
-			     early_pgtable_alloc, debug_pagealloc_enabled());
+			     early_pgtable_alloc, false);
 
 	vma->addr	= va_start;
 	vma->phys_addr	= pa_start;
-- 
2.7.4
