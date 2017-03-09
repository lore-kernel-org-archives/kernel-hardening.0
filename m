From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Thu,  9 Mar 2017 09:25:05 +0100
Message-Id: <1489047912-642-4-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1489047912-642-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1489047912-642-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v5 03/10] arm64: alternatives: apply boot time fixups via the linear mapping
To: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, keescook@chromium.org, labbott@fedoraproject.org
Cc: kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
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
 arch/arm64/kernel/alternative.c | 11 +++++-----
 arch/arm64/kernel/smp.c         |  1 +
 arch/arm64/mm/mmu.c             | 22 +++++++++++++++-----
 4 files changed, 25 insertions(+), 10 deletions(-)

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
index 06d650f61da7..8840c109c5d6 100644
--- a/arch/arm64/kernel/alternative.c
+++ b/arch/arm64/kernel/alternative.c
@@ -105,11 +105,11 @@ static u32 get_alt_insn(struct alt_instr *alt, u32 *insnptr, u32 *altinsnptr)
 	return insn;
 }
 
-static void __apply_alternatives(void *alt_region)
+static void __apply_alternatives(void *alt_region, bool use_linear_alias)
 {
 	struct alt_instr *alt;
 	struct alt_region *region = alt_region;
-	u32 *origptr, *replptr;
+	u32 *origptr, *replptr, *updptr;
 
 	for (alt = region->begin; alt < region->end; alt++) {
 		u32 insn;
@@ -124,11 +124,12 @@ static void __apply_alternatives(void *alt_region)
 
 		origptr = ALT_ORIG_PTR(alt);
 		replptr = ALT_REPL_PTR(alt);
+		updptr = use_linear_alias ? (u32 *)lm_alias(origptr) : origptr;
 		nr_inst = alt->alt_len / sizeof(insn);
 
 		for (i = 0; i < nr_inst; i++) {
 			insn = get_alt_insn(alt, origptr + i, replptr + i);
-			*(origptr + i) = cpu_to_le32(insn);
+			updptr[i] = cpu_to_le32(insn);
 		}
 
 		flush_icache_range((uintptr_t)origptr,
@@ -155,7 +156,7 @@ static int __apply_alternatives_multi_stop(void *unused)
 		isb();
 	} else {
 		BUG_ON(patched);
-		__apply_alternatives(&region);
+		__apply_alternatives(&region, true);
 		/* Barriers provided by the cache flushing */
 		WRITE_ONCE(patched, 1);
 	}
@@ -176,5 +177,5 @@ void apply_alternatives(void *start, size_t length)
 		.end	= start + length,
 	};
 
-	__apply_alternatives(&region);
+	__apply_alternatives(&region, false);
 }
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index ef1caae02110..d4739552da28 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -434,6 +434,7 @@ void __init smp_cpus_done(unsigned int max_cpus)
 	setup_cpu_features();
 	hyp_mode_check();
 	apply_alternatives_all();
+	mark_linear_text_alias_ro();
 }
 
 void __init smp_prepare_boot_cpu(void)
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 6cafd8723d1a..df377fbe464e 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -372,16 +372,28 @@ static void __init __map_memblock(pgd_t *pgd, phys_addr_t start, phys_addr_t end
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
