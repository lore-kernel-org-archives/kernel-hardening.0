From: Jun Yao <yaojun8558363@gmail.com>
Subject: [PATCH v3 3/3] arm64/mm: migrate swapper_pg_dir and tramp_pg_dir
Date: Wed,  6 Jun 2018 12:39:21 +0800
Message-Id: <20180606043921.19851-4-yaojun8558363@gmail.com>
In-Reply-To: <20180606043921.19851-1-yaojun8558363@gmail.com>
References: <20180606043921.19851-1-yaojun8558363@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: catalin.marinas@arm.com, will.deacon@arm.com, james.morse@arm.com, robin.murphy@arm.com, labbott@redhat.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Migrate swapper_pg_dir and tramp_pg_dir. And their virtual addresses
do not correlate with kernel's address.

Signed-off-by: Jun Yao <yaojun8558363@gmail.com>
---
 arch/arm64/include/asm/pgtable.h |  1 +
 arch/arm64/mm/mmu.c              | 79 +++++++++++++++++++++-----------
 2 files changed, 52 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 2bda899dcf22..b032d6c2e390 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -722,6 +722,7 @@ extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 extern pgd_t swapper_pg_end[];
 extern pgd_t idmap_pg_dir[PTRS_PER_PGD];
 extern pgd_t tramp_pg_dir[PTRS_PER_PGD];
+extern pgd_t reserved_ttbr0[PTRS_PER_PGD];
 extern volatile phys_addr_t __pa_swapper_pg_dir;
 extern pgd_t *new_swapper_pg_dir;
 
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 94056e064c6f..ba0b55158971 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -63,6 +63,9 @@ volatile phys_addr_t __section(".mmuoff.data.read")
 __pa_swapper_pg_dir;
 
 pgd_t *new_swapper_pg_dir = swapper_pg_dir;
+#ifdef CONFIG_UNMAP_KERNEL_AT_EL0
+pgd_t *new_tramp_pg_dir;
+#endif
 
 /*
  * Empty_zero_page is a special page that is used for zero-initialized data
@@ -86,19 +89,14 @@ pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 }
 EXPORT_SYMBOL(phys_mem_access_prot);
 
-static phys_addr_t __init early_pgtable_alloc(void)
+static void __init clear_page_phys(phys_addr_t phys)
 {
-	phys_addr_t phys;
-	void *ptr;
-
-	phys = memblock_alloc(PAGE_SIZE, PAGE_SIZE);
-
 	/*
 	 * The FIX_{PGD,PUD,PMD} slots may be in active use, but the FIX_PTE
 	 * slot will be free, so we can (ab)use the FIX_PTE slot to initialise
 	 * any level of table.
 	 */
-	ptr = pte_set_fixmap(phys);
+	void *ptr = pte_set_fixmap(phys);
 
 	memset(ptr, 0, PAGE_SIZE);
 
@@ -107,6 +105,14 @@ static phys_addr_t __init early_pgtable_alloc(void)
 	 * table walker
 	 */
 	pte_clear_fixmap();
+}
+
+static phys_addr_t __init early_pgtable_alloc(void)
+{
+	phys_addr_t phys;
+
+	phys = memblock_alloc(PAGE_SIZE, PAGE_SIZE);
+	clear_page_phys(phys);
 
 	return phys;
 }
@@ -560,6 +566,10 @@ static int __init map_entry_trampoline(void)
 	__create_pgd_mapping(tramp_pg_dir, pa_start, TRAMP_VALIAS, PAGE_SIZE,
 			     prot, pgd_pgtable_alloc, 0);
 
+	memcpy(new_tramp_pg_dir, tramp_pg_dir, PGD_SIZE);
+	memblock_free(__pa_symbol(tramp_pg_dir),
+		__pa_symbol(swapper_pg_dir) - __pa_symbol(tramp_pg_dir));
+
 	/* Map both the text and data into the kernel page table */
 	__set_fixmap(FIX_ENTRY_TRAMP_TEXT, pa_start, prot);
 	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE)) {
@@ -637,10 +647,29 @@ static void __init map_kernel(pgd_t *pgdp)
  */
 void __init paging_init(void)
 {
-	phys_addr_t pgd_phys = early_pgtable_alloc();
-	pgd_t *pgdp = pgd_set_fixmap(pgd_phys);
+	phys_addr_t pgd_phys;
+	pgd_t *pgdp;
+	phys_addr_t mem_size;
 
-	__pa_swapper_pg_dir = __pa_symbol(swapper_pg_dir);
+	mem_size = __pa_symbol(swapper_pg_dir) + PAGE_SIZE
+			- (__pa_symbol(idmap_pg_dir) + IDMAP_DIR_SIZE);
+
+	if (mem_size == PAGE_SIZE) {
+		pgd_phys = early_pgtable_alloc();
+		__pa_swapper_pg_dir = pgd_phys;
+	} else {
+		phys_addr_t p;
+
+		pgd_phys = memblock_alloc(mem_size, PAGE_SIZE);
+
+		for (p = pgd_phys; p < pgd_phys + mem_size; p += PAGE_SIZE)
+			clear_page_phys(p);
+
+		#ifdef CONFIG_UNMAP_KERNEL_AT_EL0
+		new_tramp_pg_dir = __va(pgd_phys);
+		#endif
+		__pa_swapper_pg_dir = pgd_phys + mem_size - PAGE_SIZE;
+	}
 
 	/*
 	 * We need to clean '__pa_swapper_pg_dir' to the PoC, so that
@@ -649,31 +678,25 @@ void __init paging_init(void)
 	__flush_dcache_area((void *)&__pa_swapper_pg_dir,
 			    sizeof(__pa_swapper_pg_dir));
 
+	new_swapper_pg_dir = __va(__pa_swapper_pg_dir);
+
+	pgdp = pgd_set_fixmap(__pa_swapper_pg_dir);
+
 	map_kernel(pgdp);
 	map_mem(pgdp);
 
-	/*
-	 * We want to reuse the original swapper_pg_dir so we don't have to
-	 * communicate the new address to non-coherent secondaries in
-	 * secondary_entry, and so cpu_switch_mm can generate the address with
-	 * adrp+add rather than a load from some global variable.
-	 *
-	 * To do this we need to go via a temporary pgd.
-	 */
-	cpu_replace_ttbr1(pgd_phys);
-	memcpy(swapper_pg_dir, pgdp, PGD_SIZE);
 	cpu_replace_ttbr1(__pa_swapper_pg_dir);
+	init_mm.pgd = new_swapper_pg_dir;
 
 	pgd_clear_fixmap();
-	memblock_free(pgd_phys, PAGE_SIZE);
 
-	/*
-	 * We only reuse the PGD from the swapper_pg_dir, not the pud + pmd
-	 * allocated with it.
-	 */
-	memblock_free(__pa_symbol(swapper_pg_dir) + PAGE_SIZE,
-		      __pa_symbol(swapper_pg_end) - __pa_symbol(swapper_pg_dir)
-		      - PAGE_SIZE);
+#ifdef CONFIG_ARM64_SW_TTBR0_PAN
+	memblock_free(__pa_symbol(reserved_ttbr0), RESERVED_TTBR0_SIZE);
+#endif
+
+	memblock_free(__pa_symbol(swapper_pg_dir),
+		__pa_symbol(swapper_pg_end) - __pa_symbol(swapper_pg_dir));
+
 }
 
 /*
-- 
2.17.0
