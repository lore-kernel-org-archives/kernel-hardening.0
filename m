From: Jun Yao <yaojun8558363@gmail.com>
Subject: [PATCH v2 2/2] arm64/mm: Move {tramp_pg_dir, swapper_pg_dir} to .rodata section
Date: Mon, 25 Jun 2018 19:39:21 +0800
Message-Id: <20180625113921.21854-3-yaojun8558363@gmail.com>
In-Reply-To: <20180625113921.21854-1-yaojun8558363@gmail.com>
References: <20180625113921.21854-1-yaojun8558363@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: catalin.marinas@arm.com, will.deacon@arm.com, ard.biesheuvel@linaro.org, james.morse@arm.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

When CONFIG_ARM64_VA_BITS_36/CONFIG_ARM64_VA_BITS_39/
CONFIG_ARM64_VA_BITS_42 are selected, a block-mapping can be
written to swapper_pg_dir. To defend 'KSMA', we move swapper_pg_dir
to .rodata section when these configurations are selected. At the
same time, we update swapper_pg_dir by fixmap.

Signed-off-by: Jun Yao <yaojun8558363@gmail.com>
---
 arch/arm64/include/asm/fixmap.h  |  1 +
 arch/arm64/include/asm/pgalloc.h | 33 ++++++++++++++++++++++++++++++++
 arch/arm64/include/asm/pgtable.h |  5 +++++
 arch/arm64/kernel/head.S         |  6 +++---
 arch/arm64/kernel/vmlinux.lds.S  | 23 ++++++++++++++++++++++
 arch/arm64/mm/mmu.c              |  6 ++++++
 6 files changed, 71 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/fixmap.h b/arch/arm64/include/asm/fixmap.h
index 62908eeedcdc..881784b43965 100644
--- a/arch/arm64/include/asm/fixmap.h
+++ b/arch/arm64/include/asm/fixmap.h
@@ -83,6 +83,7 @@ enum fixed_addresses {
 	FIX_PTE,
 	FIX_PMD,
 	FIX_PUD,
+	FIX_SWAPPER,
 
 	__end_of_fixed_addresses
 };
diff --git a/arch/arm64/include/asm/pgalloc.h b/arch/arm64/include/asm/pgalloc.h
index 2e05bcd944c8..62512ad9c310 100644
--- a/arch/arm64/include/asm/pgalloc.h
+++ b/arch/arm64/include/asm/pgalloc.h
@@ -49,6 +49,22 @@ static inline void __pud_populate(pud_t *pudp, phys_addr_t pmdp, pudval_t prot)
 
 static inline void pud_populate(struct mm_struct *mm, pud_t *pudp, pmd_t *pmdp)
 {
+#ifdef CONFIG_ARM64_VA_BITS_39
+	if (mm == &init_mm) {
+		pud_t *pud;
+		unsigned long offset;
+		extern spinlock_t pgdir_lock;
+
+		spin_lock(&pgdir_lock);
+		pud = (pud_t *)swapper_set_fixmap();
+		offset = (unsigned long)pudp - (unsigned long)swapper_pg_dir;
+		pud = (pud_t *)((unsigned long)pud + offset);
+		__pud_populate(pud, __pa(pmdp), PMD_TYPE_TABLE);
+		swapper_clear_fixmap();
+		spin_unlock(&pgdir_lock);
+		return;
+	}
+#endif
 	__pud_populate(pudp, __pa(pmdp), PMD_TYPE_TABLE);
 }
 #else
@@ -142,6 +158,23 @@ pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmdp, pte_t *ptep)
 	/*
 	 * The pmd must be loaded with the physical address of the PTE table
 	 */
+#if defined(CONFIG_ARM64_VA_BITS_42) || \
+	defined(CONFIG_ARM64_VA_BITS_36)
+	if (mm == &init_mm) {
+		pmd_t *pmd;
+		unsigned long offset;
+		extern spinlock_t pgdir_lock;
+
+		spin_lock(&pgdir_lock);
+		pmd = (pmd_t *)swapper_set_fixmap();
+		offset = (unsigned long)pmdp - (unsigned long)swapper_pg_dir;
+		pmd = (pmd_t *)((unsigned long)pmd + offset);
+		__pmd_populate(pmd, __pa(ptep), PMD_TYPE_TABLE);
+		swapper_clear_fixmap();
+		spin_unlock(&pgdir_lock);
+		return;
+	}
+#endif
 	__pmd_populate(pmdp, __pa(ptep), PMD_TYPE_TABLE);
 }
 
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index b2435e8b975b..85743ea0709b 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -592,6 +592,11 @@ static inline phys_addr_t pgd_page_paddr(pgd_t pgd)
 /* to find an entry in a kernel page-table-directory */
 #define pgd_offset_k(addr)	pgd_offset(&init_mm, addr)
 
+#define swapper_set_fixmap() \
+	set_fixmap_offset(FIX_SWAPPER, __pa_symbol(swapper_pg_dir))
+
+#define swapper_clear_fixmap()	clear_fixmap(FIX_SWAPPER)
+
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 {
 	const pteval_t mask = PTE_USER | PTE_PXN | PTE_UXN | PTE_RDONLY |
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 9677deb7b6c7..9db187024b44 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -300,7 +300,7 @@ __create_page_tables:
 	 * dirty cache lines being evicted.
 	 */
 	adrp	x0, idmap_pg_dir
-	adrp	x1, swapper_pg_end
+	adrp	x1, idmap_pg_end
 	sub	x1, x1, x0
 	bl	__inval_dcache_area
 
@@ -313,7 +313,7 @@ __create_page_tables:
 	 * Clear the idmap and init page tables.
 	 */
 	adrp	x0, idmap_pg_dir
-	adrp	x1, swapper_pg_end
+	adrp	x1, idmap_pg_end
 	sub	x1, x1, x0
 	clear_pages x0, x1
 
@@ -404,7 +404,7 @@ __create_page_tables:
 	 * tables again to remove any speculatively loaded cache lines.
 	 */
 	adrp	x0, idmap_pg_dir
-	adrp	x1, swapper_pg_end
+	adrp	x1, idmap_pg_end
 	sub	x1, x1, x0
 	dmb	sy
 	bl	__inval_dcache_area
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index b0e4255fcba4..db72c4680f1d 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -219,6 +219,28 @@ SECTIONS
 	. = ALIGN(PAGE_SIZE);
 	idmap_pg_dir = .;
 	. += IDMAP_DIR_SIZE;
+	idmap_pg_end = .;
+
+#if defined(CONFIG_ARM64_VA_BITS_39) || \
+	defined(CONFIG_ARM64_VA_BITS_36) || \
+	defined(CONFIG_ARM64_VA_BITS_42)
+	.rodata : {
+#ifdef CONFIG_UNMAP_KERNEL_AT_EL0
+		. = ALIGN(PAGE_SIZE);
+		tramp_pg_dir = .;
+		. += PAGE_SIZE;
+#endif
+
+#ifdef CONFIG_ARM64_SW_TTBR0_PAN
+		reserved_ttbr0 = .;
+		. += RESERVED_TTBR0_SIZE;
+#endif
+		swapper_pg_dir = .;
+		. += PAGE_SIZE;
+		swapper_pg_end = .;
+	}
+
+#else
 
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
 	tramp_pg_dir = .;
@@ -232,6 +254,7 @@ SECTIONS
 	swapper_pg_dir = .;
 	. += PAGE_SIZE;
 	swapper_pg_end = .;
+#endif
 
 	__pecoff_data_size = ABSOLUTE(. - __initdata_begin);
 	_end = .;
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index a3b5f1dffb84..fbaf3e9b4a43 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -66,6 +66,12 @@ static pte_t bm_pte[PTRS_PER_PTE] __page_aligned_bss;
 static pmd_t bm_pmd[PTRS_PER_PMD] __page_aligned_bss __maybe_unused;
 static pud_t bm_pud[PTRS_PER_PUD] __page_aligned_bss __maybe_unused;
 
+#if defined(CONFIG_ARM64_VA_BITS_39) || \
+	defined(CONFIG_ARM64_VA_BITS_36) || \
+	defined(CONFIG_ARM64_VA_BITS_42)
+DEFINE_SPINLOCK(pgdir_lock);
+#endif
+
 pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 			      unsigned long size, pgprot_t vma_prot)
 {
-- 
2.17.1
