From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Tue, 14 Feb 2017 20:52:36 +0000
Message-Id: <1487105558-21897-4-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1487105558-21897-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1487105558-21897-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v3 3/5] arm64: alternatives: apply boot time fixups via the linear mapping
To: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, labbott@fedoraproject.org
Cc: kernel-hardening@lists.openwall.com, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, andre.przywara@arm.com, suzuki.poulose@arm.com, james.morse@arm.com, keescook@chromium.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

One important rule of thumb when desiging a secure software system is
that memory should never be writable and executable at the same time.
We mostly adhere to this rule in the kernel, except at boot time, when
regions may be mapped RWX until after we are done applying alternatives
or making other one-off changes.

For the alternative patching, we can improve the situation by applying
the fixups via the linear mapping, which is never mapped with executable
permissions. So map the linear alias of .text with RW- permissions
initially, and remove the write permissions as soon as alternative
patching has completed.

Reviewed-by: Laura Abbott <labbott@redhat.com>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Tested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/mmu.h    |  1 +
 arch/arm64/kernel/alternative.c |  2 +-
 arch/arm64/kernel/smp.c         |  1 +
 arch/arm64/mm/mmu.c             | 22 +++++++++++++++-----
 4 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index 47619411f0ff..5468c834b072 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -37,5 +37,6 @@ extern void create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
 			       unsigned long virt, phys_addr_t size,
 			       pgprot_t prot, bool page_mappings_only);
 extern void *fixmap_remap_fdt(phys_addr_t dt_phys);
+extern void mark_linear_text_alias_ro(void);
 
 #endif
diff --git a/arch/arm64/kernel/alternative.c b/arch/arm64/kernel/alternative.c
index 06d650f61da7..8cee29d9bc07 100644
--- a/arch/arm64/kernel/alternative.c
+++ b/arch/arm64/kernel/alternative.c
@@ -128,7 +128,7 @@ static void __apply_alternatives(void *alt_region)
 
 		for (i = 0; i < nr_inst; i++) {
 			insn = get_alt_insn(alt, origptr + i, replptr + i);
-			*(origptr + i) = cpu_to_le32(insn);
+			((u32 *)lm_alias(origptr))[i] = cpu_to_le32(insn);
 		}
 
 		flush_icache_range((uintptr_t)origptr,
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index a8ec5da530af..d6307e311a10 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -432,6 +432,7 @@ void __init smp_cpus_done(unsigned int max_cpus)
 	setup_cpu_features();
 	hyp_mode_check();
 	apply_alternatives_all();
+	mark_linear_text_alias_ro();
 }
 
 void __init smp_prepare_boot_cpu(void)
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index a98419b72a09..b7ce0b9ad096 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -398,16 +398,28 @@ static void __init __map_memblock(pgd_t *pgd, phys_addr_t start, phys_addr_t end
 				     debug_pagealloc_enabled());
 
 	/*
-	 * Map the linear alias of the [_text, __init_begin) interval as
-	 * read-only/non-executable. This makes the contents of the
-	 * region accessible to subsystems such as hibernate, but
-	 * protects it from inadvertent modification or execution.
+	 * Map the linear alias of the [_text, __init_begin) interval
+	 * as non-executable now, and remove the write permission in
+	 * mark_linear_text_alias_ro() below (which will be called after
+	 * alternative patching has completed). This makes the contents
+	 * of the region accessible to subsystems such as hibernate,
+	 * but protects it from inadvertent modification or execution.
 	 */
 	__create_pgd_mapping(pgd, kernel_start, __phys_to_virt(kernel_start),
-			     kernel_end - kernel_start, PAGE_KERNEL_RO,
+			     kernel_end - kernel_start, PAGE_KERNEL,
 			     early_pgtable_alloc, debug_pagealloc_enabled());
 }
 
+void __init mark_linear_text_alias_ro(void)
+{
+	/*
+	 * Remove the write permissions from the linear alias of .text/.rodata
+	 */
+	update_mapping_prot(__pa_symbol(_text), (unsigned long)lm_alias(_text),
+			    (unsigned long)__init_begin - (unsigned long)_text,
+			    PAGE_KERNEL_RO);
+}
+
 static void __init map_mem(pgd_t *pgd)
 {
 	struct memblock_region *reg;
-- 
2.7.4
