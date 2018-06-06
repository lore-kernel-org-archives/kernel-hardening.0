From: Jun Yao <yaojun8558363@gmail.com>
Subject: [PATCH v3 1/3] arm64/mm: pass swapper_pg_dir as an argument to __enable_mmu()
Date: Wed,  6 Jun 2018 12:39:19 +0800
Message-Id: <20180606043921.19851-2-yaojun8558363@gmail.com>
In-Reply-To: <20180606043921.19851-1-yaojun8558363@gmail.com>
References: <20180606043921.19851-1-yaojun8558363@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: catalin.marinas@arm.com, will.deacon@arm.com, james.morse@arm.com, robin.murphy@arm.com, labbott@redhat.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Introduce __pa_swapper_pg_dir to save physical address of
swapper_pg_dir. And pass it as an argument to __enable_mmu().

Signed-off-by: Jun Yao <yaojun8558363@gmail.com>
---
 arch/arm64/include/asm/mmu_context.h |  4 +---
 arch/arm64/include/asm/pgtable.h     |  1 +
 arch/arm64/kernel/cpufeature.c       |  2 +-
 arch/arm64/kernel/head.S             |  6 ++++--
 arch/arm64/kernel/hibernate.c        |  2 +-
 arch/arm64/kernel/sleep.S            |  1 +
 arch/arm64/mm/kasan_init.c           |  4 ++--
 arch/arm64/mm/mmu.c                  | 20 ++++++++++++++++++--
 8 files changed, 29 insertions(+), 11 deletions(-)

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
index 7c4c8f318ba9..519ab5581b08 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -722,6 +722,7 @@ extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 extern pgd_t swapper_pg_end[];
 extern pgd_t idmap_pg_dir[PTRS_PER_PGD];
 extern pgd_t tramp_pg_dir[PTRS_PER_PGD];
+extern volatile phys_addr_t __pa_swapper_pg_dir;
 
 /*
  * Encode and decode a swap entry:
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index d2856b129097..e3d76a9dd67a 100644
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
index b0853069702f..2e871b1cb75f 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -706,6 +706,7 @@ secondary_startup:
 	 * Common entry point for secondary CPUs.
 	 */
 	bl	__cpu_setup			// initialise processor
+	ldr_l   x26, __pa_swapper_pg_dir
 	bl	__enable_mmu
 	ldr	x8, =__secondary_switched
 	br	x8
@@ -748,6 +749,7 @@ ENDPROC(__secondary_switched)
  * Enable the MMU.
  *
  *  x0  = SCTLR_EL1 value for turning on the MMU.
+ *  x26 = TTBR1 value for turning on the MMU.
  *
  * Returns to the caller via x30/lr. This requires the caller to be covered
  * by the .idmap.text section.
@@ -762,9 +764,8 @@ ENTRY(__enable_mmu)
 	b.ne	__no_granule_support
 	update_early_cpu_boot_status 0, x1, x2
 	adrp	x1, idmap_pg_dir
-	adrp	x2, swapper_pg_dir
 	phys_to_ttbr x3, x1
-	phys_to_ttbr x4, x2
+	phys_to_ttbr x4, x26
 	msr	ttbr0_el1, x3			// load TTBR0
 	msr	ttbr1_el1, x4			// load TTBR1
 	isb
@@ -823,6 +824,7 @@ __primary_switch:
 	mrs	x20, sctlr_el1			// preserve old SCTLR_EL1 value
 #endif
 
+	adrp    x26, swapper_pg_dir
 	bl	__enable_mmu
 #ifdef CONFIG_RELOCATABLE
 	bl	__relocate_kernel
diff --git a/arch/arm64/kernel/hibernate.c b/arch/arm64/kernel/hibernate.c
index 6b2686d54411..0a0a0ca19f9b 100644
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
index bebec8ef9372..03854c329449 100644
--- a/arch/arm64/kernel/sleep.S
+++ b/arch/arm64/kernel/sleep.S
@@ -101,6 +101,7 @@ ENTRY(cpu_resume)
 	bl	el2_setup		// if in EL2 drop to EL1 cleanly
 	bl	__cpu_setup
 	/* enable the MMU early - so we can access sleep_save_stash by va */
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
index 2dbb2c9f1ec1..d518e27792ef 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -55,6 +55,13 @@ u64 idmap_ptrs_per_pgd = PTRS_PER_PGD;
 u64 kimage_voffset __ro_after_init;
 EXPORT_SYMBOL(kimage_voffset);
 
+/*
+ * Ensure that hibernate will re-clean this value to the PoC once
+ * it has restored the memory.
+ */
+volatile phys_addr_t __section(".mmuoff.data.read")
+__pa_swapper_pg_dir;
+
 /*
  * Empty_zero_page is a special page that is used for zero-initialized data
  * and COW.
@@ -631,6 +638,15 @@ void __init paging_init(void)
 	phys_addr_t pgd_phys = early_pgtable_alloc();
 	pgd_t *pgdp = pgd_set_fixmap(pgd_phys);
 
+	__pa_swapper_pg_dir = __pa_symbol(swapper_pg_dir);
+
+	/*
+	 * We need to clean '__pa_swapper_pg_dir' to the PoC, so that
+	 * secondaries will read the new value.
+	 */
+	__flush_dcache_area((void *)&__pa_swapper_pg_dir,
+			    sizeof(__pa_swapper_pg_dir));
+
 	map_kernel(pgdp);
 	map_mem(pgdp);
 
@@ -642,9 +658,9 @@ void __init paging_init(void)
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
