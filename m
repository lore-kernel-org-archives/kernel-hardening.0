From: Jun Yao <yaojun8558363@gmail.com>
Subject: [PATCH v2 1/2] arm64/mm: Introduce init_pg_dir
Date: Mon, 25 Jun 2018 19:39:20 +0800
Message-Id: <20180625113921.21854-2-yaojun8558363@gmail.com>
In-Reply-To: <20180625113921.21854-1-yaojun8558363@gmail.com>
References: <20180625113921.21854-1-yaojun8558363@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: catalin.marinas@arm.com, will.deacon@arm.com, ard.biesheuvel@linaro.org, james.morse@arm.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

We setup initial page tables in init_pg_dir, which is a reserved
area of the __initdata section. And in paging_init(), we no
longer need a temporary top-level and we can setup final page
tables in swapper_pg_dir directly.

Signed-off-by: Jun Yao <yaojun8558363@gmail.com>
---
 arch/arm64/include/asm/fixmap.h   |  1 -
 arch/arm64/include/asm/pgtable.h  |  5 ++--
 arch/arm64/kernel/head.S          | 46 +++++++++++++++++++++++--------
 arch/arm64/kernel/vmlinux.lds.S   |  3 +-
 arch/arm64/mm/mmu.c               | 30 ++++----------------
 include/asm-generic/vmlinux.lds.h |  5 ++++
 mm/init-mm.c                      |  2 +-
 7 files changed, 49 insertions(+), 43 deletions(-)

diff --git a/arch/arm64/include/asm/fixmap.h b/arch/arm64/include/asm/fixmap.h
index ec1e6d6fa14c..62908eeedcdc 100644
--- a/arch/arm64/include/asm/fixmap.h
+++ b/arch/arm64/include/asm/fixmap.h
@@ -83,7 +83,6 @@ enum fixed_addresses {
 	FIX_PTE,
 	FIX_PMD,
 	FIX_PUD,
-	FIX_PGD,
 
 	__end_of_fixed_addresses
 };
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 7c4c8f318ba9..b2435e8b975b 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -592,9 +592,6 @@ static inline phys_addr_t pgd_page_paddr(pgd_t pgd)
 /* to find an entry in a kernel page-table-directory */
 #define pgd_offset_k(addr)	pgd_offset(&init_mm, addr)
 
-#define pgd_set_fixmap(addr)	((pgd_t *)set_fixmap_offset(FIX_PGD, addr))
-#define pgd_clear_fixmap()	clear_fixmap(FIX_PGD)
-
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 {
 	const pteval_t mask = PTE_USER | PTE_PXN | PTE_UXN | PTE_RDONLY |
@@ -718,6 +715,8 @@ static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 }
 #endif
 
+extern pgd_t init_pg_dir[PTRS_PER_PGD];
+extern pgd_t init_pg_end[];
 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 extern pgd_t swapper_pg_end[];
 extern pgd_t idmap_pg_dir[PTRS_PER_PGD];
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index b0853069702f..9677deb7b6c7 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -276,6 +276,15 @@ ENDPROC(preserve_boot_args)
 	populate_entries \tbl, \count, \istart, \iend, \flags, #SWAPPER_BLOCK_SIZE, \tmp
 	.endm
 
+	.macro clear_pages, start, size
+1:	stp	xzr, xzr, [\start], #16
+	stp	xzr, xzr, [\start], #16
+	stp	xzr, xzr, [\start], #16
+	stp	xzr, xzr, [\start], #16
+	subs	\size, \size, #64
+	b.ne	1b
+	.endm
+
 /*
  * Setup the initial page tables. We only setup the barest amount which is
  * required to get the kernel running. The following sections are required:
@@ -287,7 +296,7 @@ __create_page_tables:
 	mov	x28, lr
 
 	/*
-	 * Invalidate the idmap and swapper page tables to avoid potential
+	 * Invalidate the idmap and init page tables to avoid potential
 	 * dirty cache lines being evicted.
 	 */
 	adrp	x0, idmap_pg_dir
@@ -295,18 +304,23 @@ __create_page_tables:
 	sub	x1, x1, x0
 	bl	__inval_dcache_area
 
+	adrp	x0, init_pg_dir
+	adrp	x1, init_pg_end
+	sub	x1, x1, x0
+	bl	__inval_dcache_area
+
 	/*
-	 * Clear the idmap and swapper page tables.
+	 * Clear the idmap and init page tables.
 	 */
 	adrp	x0, idmap_pg_dir
 	adrp	x1, swapper_pg_end
 	sub	x1, x1, x0
-1:	stp	xzr, xzr, [x0], #16
-	stp	xzr, xzr, [x0], #16
-	stp	xzr, xzr, [x0], #16
-	stp	xzr, xzr, [x0], #16
-	subs	x1, x1, #64
-	b.ne	1b
+	clear_pages x0, x1
+
+	adrp	x0, init_pg_dir
+	adrp	x1, init_pg_end
+	sub	x1, x1, x0
+	clear_pages x0, x1
 
 	mov	x7, SWAPPER_MM_MMUFLAGS
 
@@ -373,7 +387,7 @@ __create_page_tables:
 	/*
 	 * Map the kernel image (starting with PHYS_OFFSET).
 	 */
-	adrp	x0, swapper_pg_dir
+	adrp	x0, init_pg_dir
 	mov_q	x5, KIMAGE_VADDR + TEXT_OFFSET	// compile time __va(_text)
 	add	x5, x5, x23			// add KASLR displacement
 	mov	x4, PTRS_PER_PGD
@@ -386,7 +400,7 @@ __create_page_tables:
 
 	/*
 	 * Since the page tables have been populated with non-cacheable
-	 * accesses (MMU disabled), invalidate the idmap and swapper page
+	 * accesses (MMU disabled), invalidate the idmap and init page
 	 * tables again to remove any speculatively loaded cache lines.
 	 */
 	adrp	x0, idmap_pg_dir
@@ -395,6 +409,12 @@ __create_page_tables:
 	dmb	sy
 	bl	__inval_dcache_area
 
+	adrp	x0, init_pg_dir
+	adrp	x1, init_pg_end
+	sub	x1, x1, x0
+	dmb	sy
+	bl	__inval_dcache_area
+
 	ret	x28
 ENDPROC(__create_page_tables)
 	.ltorg
@@ -706,6 +726,7 @@ secondary_startup:
 	 * Common entry point for secondary CPUs.
 	 */
 	bl	__cpu_setup			// initialise processor
+	adr_l   x26, swapper_pg_dir
 	bl	__enable_mmu
 	ldr	x8, =__secondary_switched
 	br	x8
@@ -748,6 +769,7 @@ ENDPROC(__secondary_switched)
  * Enable the MMU.
  *
  *  x0  = SCTLR_EL1 value for turning on the MMU.
+ *  x26 = TTBR1_EL1 value for turning on the MMU.
  *
  * Returns to the caller via x30/lr. This requires the caller to be covered
  * by the .idmap.text section.
@@ -762,7 +784,7 @@ ENTRY(__enable_mmu)
 	b.ne	__no_granule_support
 	update_early_cpu_boot_status 0, x1, x2
 	adrp	x1, idmap_pg_dir
-	adrp	x2, swapper_pg_dir
+	mov	x2, x26
 	phys_to_ttbr x3, x1
 	phys_to_ttbr x4, x2
 	msr	ttbr0_el1, x3			// load TTBR0
@@ -822,7 +844,7 @@ __primary_switch:
 	mov	x19, x0				// preserve new SCTLR_EL1 value
 	mrs	x20, sctlr_el1			// preserve old SCTLR_EL1 value
 #endif
-
+	adrp	x26, init_pg_dir
 	bl	__enable_mmu
 #ifdef CONFIG_RELOCATABLE
 	bl	__relocate_kernel
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 605d1b60469c..b0e4255fcba4 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -168,6 +168,7 @@ SECTIONS
 		CON_INITCALL
 		SECURITY_INITCALL
 		INIT_RAM_FS
+		INIT_DIR
 		*(.init.rodata.* .init.bss)	/* from the EFI stub */
 	}
 	.exit.data : {
@@ -229,7 +230,7 @@ SECTIONS
 	. += RESERVED_TTBR0_SIZE;
 #endif
 	swapper_pg_dir = .;
-	. += SWAPPER_DIR_SIZE;
+	. += PAGE_SIZE;
 	swapper_pg_end = .;
 
 	__pecoff_data_size = ABSOLUTE(. - __initdata_begin);
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 2dbb2c9f1ec1..a3b5f1dffb84 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -628,34 +628,14 @@ static void __init map_kernel(pgd_t *pgdp)
  */
 void __init paging_init(void)
 {
-	phys_addr_t pgd_phys = early_pgtable_alloc();
-	pgd_t *pgdp = pgd_set_fixmap(pgd_phys);
-
-	map_kernel(pgdp);
-	map_mem(pgdp);
-
 	/*
-	 * We want to reuse the original swapper_pg_dir so we don't have to
-	 * communicate the new address to non-coherent secondaries in
-	 * secondary_entry, and so cpu_switch_mm can generate the address with
-	 * adrp+add rather than a load from some global variable.
-	 *
-	 * To do this we need to go via a temporary pgd.
+	 * Setup final page tables in swapper_pg_dir.
 	 */
-	cpu_replace_ttbr1(__va(pgd_phys));
-	memcpy(swapper_pg_dir, pgdp, PGD_SIZE);
-	cpu_replace_ttbr1(lm_alias(swapper_pg_dir));
+	map_kernel(swapper_pg_dir);
+	map_mem(swapper_pg_dir);
 
-	pgd_clear_fixmap();
-	memblock_free(pgd_phys, PAGE_SIZE);
-
-	/*
-	 * We only reuse the PGD from the swapper_pg_dir, not the pud + pmd
-	 * allocated with it.
-	 */
-	memblock_free(__pa_symbol(swapper_pg_dir) + PAGE_SIZE,
-		      __pa_symbol(swapper_pg_end) - __pa_symbol(swapper_pg_dir)
-		      - PAGE_SIZE);
+	cpu_replace_ttbr1(lm_alias(swapper_pg_dir));
+	init_mm.pgd = swapper_pg_dir;
 }
 
 /*
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index af240573e482..a11e7117da4d 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -230,6 +230,11 @@
 	KEEP(*(.dtb.init.rodata))					\
 	VMLINUX_SYMBOL(__dtb_end) = .;
 
+#define INIT_DIR							\
+	. = ALIGN(PAGE_SIZE);						\
+	init_pg_dir = .;						\
+	. += SWAPPER_DIR_SIZE;						\
+	init_pg_end = .;
 /*
  * .data section
  */
diff --git a/mm/init-mm.c b/mm/init-mm.c
index f94d5d15ebc0..08a0eed00667 100644
--- a/mm/init-mm.c
+++ b/mm/init-mm.c
@@ -17,7 +17,7 @@
 
 struct mm_struct init_mm = {
 	.mm_rb		= RB_ROOT,
-	.pgd		= swapper_pg_dir,
+	.pgd		= init_pg_dir,
 	.mm_users	= ATOMIC_INIT(2),
 	.mm_count	= ATOMIC_INIT(1),
 	.mmap_sem	= __RWSEM_INITIALIZER(init_mm.mmap_sem),
-- 
2.17.1
