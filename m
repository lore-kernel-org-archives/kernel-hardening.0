From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Thu,  9 Mar 2017 21:52:00 +0100
Message-Id: <1489092729-16871-3-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1489092729-16871-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1489092729-16871-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v6 02/11] arm64: mmu: move TLB maintenance from callers to create_mapping_late()
To: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, keescook@chromium.org, labbott@fedoraproject.org
Cc: kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

In preparation of refactoring the kernel mapping logic so that text regions
are never mapped writable, which would require adding explicit TLB
maintenance to new call sites of create_mapping_late() (which is currently
invoked twice from the same function), move the TLB maintenance from the
call site into create_mapping_late() itself, and change it from a full
TLB flush into a flush by VA, which is more appropriate here.

Also, given that create_mapping_late() has evolved into a routine that only
updates protection bits on existing mappings, rename it to
update_mapping_prot()

Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Tested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/mm/mmu.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index d28dbcf596b6..6cafd8723d1a 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -319,17 +319,20 @@ void __init create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
 			     pgd_pgtable_alloc, page_mappings_only);
 }
 
-static void create_mapping_late(phys_addr_t phys, unsigned long virt,
-				  phys_addr_t size, pgprot_t prot)
+static void update_mapping_prot(phys_addr_t phys, unsigned long virt,
+				phys_addr_t size, pgprot_t prot)
 {
 	if (virt < VMALLOC_START) {
-		pr_warn("BUG: not creating mapping for %pa at 0x%016lx - outside kernel range\n",
+		pr_warn("BUG: not updating mapping for %pa at 0x%016lx - outside kernel range\n",
 			&phys, virt);
 		return;
 	}
 
 	__create_pgd_mapping(init_mm.pgd, phys, virt, size, prot,
 			     NULL, debug_pagealloc_enabled());
+
+	/* flush the TLBs after updating live kernel mappings */
+	flush_tlb_kernel_range(virt, virt + size);
 }
 
 static void __init __map_memblock(pgd_t *pgd, phys_addr_t start, phys_addr_t end)
@@ -402,19 +405,16 @@ void mark_rodata_ro(void)
 	unsigned long section_size;
 
 	section_size = (unsigned long)_etext - (unsigned long)_text;
-	create_mapping_late(__pa_symbol(_text), (unsigned long)_text,
+	update_mapping_prot(__pa_symbol(_text), (unsigned long)_text,
 			    section_size, PAGE_KERNEL_ROX);
 	/*
 	 * mark .rodata as read only. Use __init_begin rather than __end_rodata
 	 * to cover NOTES and EXCEPTION_TABLE.
 	 */
 	section_size = (unsigned long)__init_begin - (unsigned long)__start_rodata;
-	create_mapping_late(__pa_symbol(__start_rodata), (unsigned long)__start_rodata,
+	update_mapping_prot(__pa_symbol(__start_rodata), (unsigned long)__start_rodata,
 			    section_size, PAGE_KERNEL_RO);
 
-	/* flush the TLBs after updating live kernel mappings */
-	flush_tlb_all();
-
 	debug_checkwx();
 }
 
-- 
2.7.4
