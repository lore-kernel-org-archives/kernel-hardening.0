From: Jun Yao <yaojun8558363@gmail.com>
Subject: [PATCH 1/4] arm64/mm: pass swapper_pg_dir as an argument to __enable_mmu()
Date: Fri,  1 Jun 2018 16:08:33 +0800
Message-Id: <20180601080833.11762-1-yaojun8558363@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, greg@kroah.com
List-ID: <kernel-hardening.lists.openwall.com>

Introduce __pa_swapper_pg_dir to save physical address of
swapper_pg_dir. And pass it as an argument to __enable_mmu().

Signed-off-by: Jun Yao <yaojun8558363@gmail.com>
---
 arch/arm64/include/asm/mmu_context.h |  4 +---
 arch/arm64/include/asm/pgtable.h     |  1 +
 arch/arm64/kernel/cpufeature.c       |  2 +-
 arch/arm64/kernel/head.S             | 10 ++++++----
 arch/arm64/kernel/hibernate.c        |  2 +-
 arch/arm64/kernel/sleep.S            |  2 ++
 arch/arm64/mm/kasan_init.c           |  4 ++--
 arch/arm64/mm/mmu.c                  |  8 ++++++--
 8 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/mmu_context.h b/arch/arm64/include/asm/mmu_context.h
index 39ec0b8a689e..3eddb871f251 100644
--- a/arch/arm64/include/asm/mmu_context.h
+++ b/arch/arm64/include/asm/mmu_context.h
@@ -141,14 +141,12 @@ static inline void cpu_install_idmap(void)
  * Atomically replaces the active TTBR1_EL1 PGD with a new VA-compatible PGD,
  * avoiding the possibility of conflicting TLB entries being allocated.
  */
-static inline void cpu_replace_ttbr1(pgd_t *pgdp)
+static inline void cpu_replace_ttbr1(phys_addr_t pgd_phys)
 {
 	typedef void (ttbr_replace_func)(phys_addr_t);
 	extern ttbr_replace_func idmap_cpu_replace_ttbr1;
 	ttbr_replace_func *replace_phys;
 
-	phys_addr_t pgd_phys = virt_to_phys(pgdp);
-
 	replace_phys = (void *)__pa_symbol(idmap_cpu_replace_ttbr1);
 
 	cpu_install_idmap();
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 7c4c8f318ba9..14ba344b1af7 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -722,6 +722,7 @@ extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 extern pgd_t swapper_pg_end[];
 extern pgd_t idmap_pg_dir[PTRS_PER_PGD];
 extern pgd_t tramp_pg_dir[PTRS_PER_PGD];
+extern phys_addr_t __pa_swapper_pg_dir;
 
 /*
  * Encode and decode a swap entry:
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index fbee8c17a4e6..588e66a4cfec 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -917,7 +917,7 @@ kpti_install_ng_mappings(const struct arm64_cpu_capabilities *__unused)
 	remap_fn = (void *)__pa_symbol(idmap_kpti_install_ng_mappings);
 
 	cpu_install_idmap();
-	remap_fn(cpu, num_online_cpus(), __pa_symbol(swapper_pg_dir));
+	remap_fn(cpu, num_online_cpus(), __pa_swapper_pg_dir);
 	cpu_uninstall_idmap();
 
 	if (!cpu)
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index b0853069702f..e3bb44b4b6c6 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -706,6 +706,8 @@ secondary_startup:
 	 * Common entry point for secondary CPUs.
 	 */
 	bl	__cpu_setup			// initialise processor
+	adrp    x25, idmap_pg_dir
+	ldr_l   x26, __pa_swapper_pg_dir
 	bl	__enable_mmu
 	ldr	x8, =__secondary_switched
 	br	x8
@@ -761,10 +763,8 @@ ENTRY(__enable_mmu)
 	cmp	x2, #ID_AA64MMFR0_TGRAN_SUPPORTED
 	b.ne	__no_granule_support
 	update_early_cpu_boot_status 0, x1, x2
-	adrp	x1, idmap_pg_dir
-	adrp	x2, swapper_pg_dir
-	phys_to_ttbr x3, x1
-	phys_to_ttbr x4, x2
+	phys_to_ttbr x3, x25
+	phys_to_ttbr x4, x26
 	msr	ttbr0_el1, x3			// load TTBR0
 	msr	ttbr1_el1, x4			// load TTBR1
 	isb
@@ -823,6 +823,8 @@ __primary_switch:
 	mrs	x20, sctlr_el1			// preserve old SCTLR_EL1 value
 #endif
 
+	adrp    x25, idmap_pg_dir
+	adrp    x26, swapper_pg_dir
 	bl	__enable_mmu
 #ifdef CONFIG_RELOCATABLE
 	bl	__relocate_kernel
diff --git a/arch/arm64/kernel/hibernate.c b/arch/arm64/kernel/hibernate.c
index 1ec5f28c39fc..12948949202c 100644
--- a/arch/arm64/kernel/hibernate.c
+++ b/arch/arm64/kernel/hibernate.c
@@ -125,7 +125,7 @@ int arch_hibernation_header_save(void *addr, unsigned int max_size)
 		return -EOVERFLOW;
 
 	arch_hdr_invariants(&hdr->invariants);
-	hdr->ttbr1_el1		= __pa_symbol(swapper_pg_dir);
+	hdr->ttbr1_el1          = __pa_swapper_pg_dir;
 	hdr->reenter_kernel	= _cpu_resume;
 
 	/* We can't use __hyp_get_vectors() because kvm may still be loaded */
diff --git a/arch/arm64/kernel/sleep.S b/arch/arm64/kernel/sleep.S
index bebec8ef9372..860d46395be1 100644
--- a/arch/arm64/kernel/sleep.S
+++ b/arch/arm64/kernel/sleep.S
@@ -101,6 +101,8 @@ ENTRY(cpu_resume)
 	bl	el2_setup		// if in EL2 drop to EL1 cleanly
 	bl	__cpu_setup
 	/* enable the MMU early - so we can access sleep_save_stash by va */
+	adrp    x25, idmap_pg_dir
+	ldr_l   x26, __pa_swapper_pg_dir
 	bl	__enable_mmu
 	ldr	x8, =_cpu_resume
 	br	x8
diff --git a/arch/arm64/mm/kasan_init.c b/arch/arm64/mm/kasan_init.c
index 12145874c02b..dd4f28c19165 100644
--- a/arch/arm64/mm/kasan_init.c
+++ b/arch/arm64/mm/kasan_init.c
@@ -199,7 +199,7 @@ void __init kasan_init(void)
 	 */
 	memcpy(tmp_pg_dir, swapper_pg_dir, sizeof(tmp_pg_dir));
 	dsb(ishst);
-	cpu_replace_ttbr1(lm_alias(tmp_pg_dir));
+	cpu_replace_ttbr1(__pa_symbol(tmp_pg_dir));
 
 	clear_pgds(KASAN_SHADOW_START, KASAN_SHADOW_END);
 
@@ -236,7 +236,7 @@ void __init kasan_init(void)
 			pfn_pte(sym_to_pfn(kasan_zero_page), PAGE_KERNEL_RO));
 
 	memset(kasan_zero_page, 0, PAGE_SIZE);
-	cpu_replace_ttbr1(lm_alias(swapper_pg_dir));
+	cpu_replace_ttbr1(__pa_swapper_pg_dir);
 
 	/* At this point kasan is fully initialized. Enable error messages */
 	init_task.kasan_depth = 0;
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 2dbb2c9f1ec1..41eee333f91a 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -55,6 +55,8 @@ u64 idmap_ptrs_per_pgd = PTRS_PER_PGD;
 u64 kimage_voffset __ro_after_init;
 EXPORT_SYMBOL(kimage_voffset);
 
+phys_addr_t __pa_swapper_pg_dir;
+
 /*
  * Empty_zero_page is a special page that is used for zero-initialized data
  * and COW.
@@ -631,6 +633,8 @@ void __init paging_init(void)
 	phys_addr_t pgd_phys = early_pgtable_alloc();
 	pgd_t *pgdp = pgd_set_fixmap(pgd_phys);
 
+	__pa_swapper_pg_dir = __pa_symbol(swapper_pg_dir);
+
 	map_kernel(pgdp);
 	map_mem(pgdp);
 
@@ -642,9 +646,9 @@ void __init paging_init(void)
 	 *
 	 * To do this we need to go via a temporary pgd.
 	 */
-	cpu_replace_ttbr1(__va(pgd_phys));
+	cpu_replace_ttbr1(pgd_phys);
 	memcpy(swapper_pg_dir, pgdp, PGD_SIZE);
-	cpu_replace_ttbr1(lm_alias(swapper_pg_dir));
+	cpu_replace_ttbr1(__pa_swapper_pg_dir);
 
 	pgd_clear_fixmap();
 	memblock_free(pgd_phys, PAGE_SIZE);
-- 
2.17.0
