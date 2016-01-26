Reply-To: kernel-hardening@lists.openwall.com
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Tue, 26 Jan 2016 18:10:34 +0100
Message-Id: <1453828249-14467-8-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1453828249-14467-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1453828249-14467-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v4 07/22] arm64: move kernel image to base of vmalloc area
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, linux-kernel@vger.kernel.org
Cc: stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, arnd@arndb.de, marc.zyngier@arm.com, christoffer.dall@linaro.org, labbott@fedoraproject.org, matt@codeblueprint.co.uk, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

This moves the module area to right before the vmalloc area, and
moves the kernel image to the base of the vmalloc area. This is
an intermediate step towards implementing KASLR, which allows the
kernel image to be located anywhere in the vmalloc area.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/kasan.h   |  2 +-
 arch/arm64/include/asm/memory.h  | 21 +++--
 arch/arm64/include/asm/pgtable.h | 10 +-
 arch/arm64/mm/dump.c             | 12 +--
 arch/arm64/mm/init.c             | 23 ++---
 arch/arm64/mm/kasan_init.c       | 18 +++-
 arch/arm64/mm/mmu.c              | 97 +++++++++++++-------
 7 files changed, 116 insertions(+), 67 deletions(-)

diff --git a/arch/arm64/include/asm/kasan.h b/arch/arm64/include/asm/kasan.h
index de0d21211c34..71ad0f93eb71 100644
--- a/arch/arm64/include/asm/kasan.h
+++ b/arch/arm64/include/asm/kasan.h
@@ -14,7 +14,7 @@
  * KASAN_SHADOW_END: KASAN_SHADOW_START + 1/8 of kernel virtual addresses.
  */
 #define KASAN_SHADOW_START      (VA_START)
-#define KASAN_SHADOW_END        (KASAN_SHADOW_START + (1UL << (VA_BITS - 3)))
+#define KASAN_SHADOW_END        (KASAN_SHADOW_START + KASAN_SHADOW_SIZE)
 
 /*
  * This value is used to map an address to the corresponding shadow
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index aebc739f5a11..4388651d1f0d 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -45,16 +45,15 @@
  * VA_START - the first kernel virtual address.
  * TASK_SIZE - the maximum size of a user space task.
  * TASK_UNMAPPED_BASE - the lower boundary of the mmap VM area.
- * The module space lives between the addresses given by TASK_SIZE
- * and PAGE_OFFSET - it must be within 128MB of the kernel text.
  */
 #define VA_BITS			(CONFIG_ARM64_VA_BITS)
 #define VA_START		(UL(0xffffffffffffffff) << VA_BITS)
 #define PAGE_OFFSET		(UL(0xffffffffffffffff) << (VA_BITS - 1))
-#define KIMAGE_VADDR		(PAGE_OFFSET)
-#define MODULES_END		(KIMAGE_VADDR)
-#define MODULES_VADDR		(MODULES_END - SZ_64M)
-#define PCI_IO_END		(MODULES_VADDR - SZ_2M)
+#define KIMAGE_VADDR		(MODULES_END)
+#define MODULES_END		(MODULES_VADDR + MODULES_VSIZE)
+#define MODULES_VADDR		(VA_START + KASAN_SHADOW_SIZE)
+#define MODULES_VSIZE		(SZ_64M)
+#define PCI_IO_END		(PAGE_OFFSET - SZ_2M)
 #define PCI_IO_START		(PCI_IO_END - PCI_IO_SIZE)
 #define FIXADDR_TOP		(PCI_IO_START - SZ_2M)
 #define TASK_SIZE_64		(UL(1) << VA_BITS)
@@ -72,6 +71,16 @@
 #define TASK_UNMAPPED_BASE	(PAGE_ALIGN(TASK_SIZE / 4))
 
 /*
+ * The size of the KASAN shadow region. This should be 1/8th of the
+ * size of the entire kernel virtual address space.
+ */
+#ifdef CONFIG_KASAN
+#define KASAN_SHADOW_SIZE	(UL(1) << (VA_BITS - 3))
+#else
+#define KASAN_SHADOW_SIZE	(0)
+#endif
+
+/*
  * Physical vs virtual RAM address space conversion.  These are
  * private definitions which should NOT be used outside memory.h
  * files.  Use virt_to_phys/phys_to_virt/__pa/__va instead.
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index e9eaf6e9262d..550d21574d0d 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -36,19 +36,13 @@
  *
  * VMEMAP_SIZE: allows the whole VA space to be covered by a struct page array
  *	(rounded up to PUD_SIZE).
- * VMALLOC_START: beginning of the kernel VA space
+ * VMALLOC_START: beginning of the kernel vmalloc space
  * VMALLOC_END: extends to the available space below vmmemmap, PCI I/O space,
  *	fixed mappings and modules
  */
 #define VMEMMAP_SIZE		ALIGN((1UL << (VA_BITS - PAGE_SHIFT)) * sizeof(struct page), PUD_SIZE)
 
-#ifndef CONFIG_KASAN
-#define VMALLOC_START		(VA_START)
-#else
-#include <asm/kasan.h>
-#define VMALLOC_START		(KASAN_SHADOW_END + SZ_64K)
-#endif
-
+#define VMALLOC_START		(MODULES_END)
 #define VMALLOC_END		(PAGE_OFFSET - PUD_SIZE - VMEMMAP_SIZE - SZ_64K)
 
 #define vmemmap			((struct page *)(VMALLOC_END + SZ_64K))
diff --git a/arch/arm64/mm/dump.c b/arch/arm64/mm/dump.c
index 5a22a119a74c..e83ffb00560c 100644
--- a/arch/arm64/mm/dump.c
+++ b/arch/arm64/mm/dump.c
@@ -35,7 +35,9 @@ struct addr_marker {
 };
 
 enum address_markers_idx {
-	VMALLOC_START_NR = 0,
+	MODULES_START_NR = 0,
+	MODULES_END_NR,
+	VMALLOC_START_NR,
 	VMALLOC_END_NR,
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 	VMEMMAP_START_NR,
@@ -45,12 +47,12 @@ enum address_markers_idx {
 	FIXADDR_END_NR,
 	PCI_START_NR,
 	PCI_END_NR,
-	MODULES_START_NR,
-	MODUELS_END_NR,
 	KERNEL_SPACE_NR,
 };
 
 static struct addr_marker address_markers[] = {
+	{ MODULES_VADDR,	"Modules start" },
+	{ MODULES_END,		"Modules end" },
 	{ VMALLOC_START,	"vmalloc() Area" },
 	{ VMALLOC_END,		"vmalloc() End" },
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
@@ -61,9 +63,7 @@ static struct addr_marker address_markers[] = {
 	{ FIXADDR_TOP,		"Fixmap end" },
 	{ PCI_IO_START,		"PCI I/O start" },
 	{ PCI_IO_END,		"PCI I/O end" },
-	{ MODULES_VADDR,	"Modules start" },
-	{ MODULES_END,		"Modules end" },
-	{ PAGE_OFFSET,		"Kernel Mapping" },
+	{ PAGE_OFFSET,		"Linear Mapping" },
 	{ -1,			NULL },
 };
 
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index f3b061e67bfe..1d627cd8121c 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -36,6 +36,7 @@
 #include <linux/swiotlb.h>
 
 #include <asm/fixmap.h>
+#include <asm/kasan.h>
 #include <asm/memory.h>
 #include <asm/sections.h>
 #include <asm/setup.h>
@@ -302,22 +303,26 @@ void __init mem_init(void)
 #ifdef CONFIG_KASAN
 		  "    kasan   : 0x%16lx - 0x%16lx   (%6ld GB)\n"
 #endif
+		  "    modules : 0x%16lx - 0x%16lx   (%6ld MB)\n"
 		  "    vmalloc : 0x%16lx - 0x%16lx   (%6ld GB)\n"
+		  "      .init : 0x%p" " - 0x%p" "   (%6ld KB)\n"
+		  "      .text : 0x%p" " - 0x%p" "   (%6ld KB)\n"
+		  "      .data : 0x%p" " - 0x%p" "   (%6ld KB)\n"
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 		  "    vmemmap : 0x%16lx - 0x%16lx   (%6ld GB maximum)\n"
 		  "              0x%16lx - 0x%16lx   (%6ld MB actual)\n"
 #endif
 		  "    fixed   : 0x%16lx - 0x%16lx   (%6ld KB)\n"
 		  "    PCI I/O : 0x%16lx - 0x%16lx   (%6ld MB)\n"
-		  "    modules : 0x%16lx - 0x%16lx   (%6ld MB)\n"
-		  "    memory  : 0x%16lx - 0x%16lx   (%6ld MB)\n"
-		  "      .init : 0x%p" " - 0x%p" "   (%6ld KB)\n"
-		  "      .text : 0x%p" " - 0x%p" "   (%6ld KB)\n"
-		  "      .data : 0x%p" " - 0x%p" "   (%6ld KB)\n",
+		  "    memory  : 0x%16lx - 0x%16lx   (%6ld MB)\n",
 #ifdef CONFIG_KASAN
 		  MLG(KASAN_SHADOW_START, KASAN_SHADOW_END),
 #endif
+		  MLM(MODULES_VADDR, MODULES_END),
 		  MLG(VMALLOC_START, VMALLOC_END),
+		  MLK_ROUNDUP(__init_begin, __init_end),
+		  MLK_ROUNDUP(_text, _etext),
+		  MLK_ROUNDUP(_sdata, _edata),
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 		  MLG((unsigned long)vmemmap,
 		      (unsigned long)vmemmap + VMEMMAP_SIZE),
@@ -326,11 +331,7 @@ void __init mem_init(void)
 #endif
 		  MLK(FIXADDR_START, FIXADDR_TOP),
 		  MLM(PCI_IO_START, PCI_IO_END),
-		  MLM(MODULES_VADDR, MODULES_END),
-		  MLM(PAGE_OFFSET, (unsigned long)high_memory),
-		  MLK_ROUNDUP(__init_begin, __init_end),
-		  MLK_ROUNDUP(_text, _etext),
-		  MLK_ROUNDUP(_sdata, _edata));
+		  MLM(PAGE_OFFSET, (unsigned long)high_memory));
 
 #undef MLK
 #undef MLM
@@ -358,8 +359,8 @@ void __init mem_init(void)
 
 void free_initmem(void)
 {
-	fixup_init();
 	free_initmem_default(0);
+	fixup_init();
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
diff --git a/arch/arm64/mm/kasan_init.c b/arch/arm64/mm/kasan_init.c
index 0ca411fc5ea3..4d0623bfb781 100644
--- a/arch/arm64/mm/kasan_init.c
+++ b/arch/arm64/mm/kasan_init.c
@@ -17,9 +17,11 @@
 #include <linux/start_kernel.h>
 
 #include <asm/mmu_context.h>
+#include <asm/kernel-pgtable.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
+#include <asm/sections.h>
 #include <asm/tlbflush.h>
 
 static pgd_t tmp_pg_dir[PTRS_PER_PGD] __initdata __aligned(PGD_SIZE);
@@ -33,7 +35,7 @@ static void __init kasan_early_pte_populate(pmd_t *pmd, unsigned long addr,
 	if (pmd_none(*pmd))
 		pmd_populate_kernel(&init_mm, pmd, kasan_zero_pte);
 
-	pte = pte_offset_kernel(pmd, addr);
+	pte = pte_offset_kimg(pmd, addr);
 	do {
 		next = addr + PAGE_SIZE;
 		set_pte(pte, pfn_pte(virt_to_pfn(kasan_zero_page),
@@ -51,7 +53,7 @@ static void __init kasan_early_pmd_populate(pud_t *pud,
 	if (pud_none(*pud))
 		pud_populate(&init_mm, pud, kasan_zero_pmd);
 
-	pmd = pmd_offset(pud, addr);
+	pmd = pmd_offset_kimg(pud, addr);
 	do {
 		next = pmd_addr_end(addr, end);
 		kasan_early_pte_populate(pmd, addr, next);
@@ -68,7 +70,7 @@ static void __init kasan_early_pud_populate(pgd_t *pgd,
 	if (pgd_none(*pgd))
 		pgd_populate(&init_mm, pgd, kasan_zero_pud);
 
-	pud = pud_offset(pgd, addr);
+	pud = pud_offset_kimg(pgd, addr);
 	do {
 		next = pud_addr_end(addr, end);
 		kasan_early_pmd_populate(pud, addr, next);
@@ -126,8 +128,12 @@ static void __init clear_pgds(unsigned long start,
 
 void __init kasan_init(void)
 {
+	u64 kimg_shadow_start, kimg_shadow_end;
 	struct memblock_region *reg;
 
+	kimg_shadow_start = (u64)kasan_mem_to_shadow(_text);
+	kimg_shadow_end = (u64)kasan_mem_to_shadow(_end);
+
 	/*
 	 * We are going to perform proper setup of shadow memory.
 	 * At first we should unmap early shadow (clear_pgds() call bellow).
@@ -141,8 +147,12 @@ void __init kasan_init(void)
 
 	clear_pgds(KASAN_SHADOW_START, KASAN_SHADOW_END);
 
+	vmemmap_populate(kimg_shadow_start, kimg_shadow_end, NUMA_NO_NODE);
+
 	kasan_populate_zero_shadow((void *)KASAN_SHADOW_START,
-			kasan_mem_to_shadow((void *)MODULES_VADDR));
+				   (void *)kimg_shadow_start);
+	kasan_populate_zero_shadow((void *)kimg_shadow_end,
+				   kasan_mem_to_shadow((void *)PAGE_OFFSET));
 
 	for_each_memblock(memory, reg) {
 		void *start = (void *)__phys_to_virt(reg->base);
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index b84915723ea0..4c4b15932963 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -53,6 +53,10 @@ u64 idmap_t0sz = TCR_T0SZ(VA_BITS);
 unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)] __page_aligned_bss;
 EXPORT_SYMBOL(empty_zero_page);
 
+static pte_t bm_pte[PTRS_PER_PTE] __page_aligned_bss;
+static pmd_t bm_pmd[PTRS_PER_PMD] __page_aligned_bss;
+static pud_t bm_pud[PTRS_PER_PUD] __page_aligned_bss;
+
 pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 			      unsigned long size, pgprot_t vma_prot)
 {
@@ -349,14 +353,14 @@ static void __init __map_memblock(pgd_t *pgd, phys_addr_t start, phys_addr_t end
 {
 
 	unsigned long kernel_start = __pa(_stext);
-	unsigned long kernel_end = __pa(_end);
+	unsigned long kernel_end = __pa(_etext);
 
 	/*
-	 * The kernel itself is mapped at page granularity. Map all other
-	 * memory, making sure we don't overwrite the existing kernel mappings.
+	 * Take care not to create a writable alias for the
+	 * read-only text and rodata sections of the kernel image.
 	 */
 
-	/* No overlap with the kernel. */
+	/* No overlap with the kernel text */
 	if (end < kernel_start || start >= kernel_end) {
 		__create_pgd_mapping(pgd, start, __phys_to_virt(start),
 				     end - start, PAGE_KERNEL,
@@ -365,7 +369,7 @@ static void __init __map_memblock(pgd_t *pgd, phys_addr_t start, phys_addr_t end
 	}
 
 	/*
-	 * This block overlaps the kernel mapping. Map the portion(s) which
+	 * This block overlaps the kernel text mapping. Map the portion(s) which
 	 * don't overlap.
 	 */
 	if (start < kernel_start)
@@ -398,25 +402,28 @@ static void __init map_mem(pgd_t *pgd)
 	}
 }
 
-#ifdef CONFIG_DEBUG_RODATA
 void mark_rodata_ro(void)
 {
+	if (!IS_ENABLED(CONFIG_DEBUG_RODATA))
+		return;
+
 	create_mapping_late(__pa(_stext), (unsigned long)_stext,
 				(unsigned long)_etext - (unsigned long)_stext,
 				PAGE_KERNEL_ROX);
-
 }
-#endif
 
 void fixup_init(void)
 {
-	create_mapping_late(__pa(__init_begin), (unsigned long)__init_begin,
-			(unsigned long)__init_end - (unsigned long)__init_begin,
-			PAGE_KERNEL);
+	/*
+	 * Unmap the __init region but leave the VM area in place. This
+	 * prevents the region from being reused for kernel modules, which
+	 * is not supported by kallsyms.
+	 */
+	unmap_kernel_range((u64)__init_begin, (u64)(__init_end - __init_begin));
 }
 
 static void __init map_kernel_chunk(pgd_t *pgd, void *va_start, void *va_end,
-				    pgprot_t prot)
+				    pgprot_t prot, struct vm_struct *vma)
 {
 	phys_addr_t pa_start = __pa(va_start);
 	unsigned long size = va_end - va_start;
@@ -426,6 +433,14 @@ static void __init map_kernel_chunk(pgd_t *pgd, void *va_start, void *va_end,
 
 	__create_pgd_mapping(pgd, pa_start, (unsigned long)va_start, size, prot,
 			     early_pgtable_alloc);
+
+	vma->addr	= va_start;
+	vma->phys_addr	= pa_start;
+	vma->size	= size;
+	vma->flags	= VM_MAP;
+	vma->caller	= map_kernel_chunk;
+
+	vm_area_add_early(vma);
 }
 
 /*
@@ -433,17 +448,35 @@ static void __init map_kernel_chunk(pgd_t *pgd, void *va_start, void *va_end,
  */
 static void __init map_kernel(pgd_t *pgd)
 {
+	static struct vm_struct vmlinux_text, vmlinux_init, vmlinux_data;
 
-	map_kernel_chunk(pgd, _stext, _etext, PAGE_KERNEL_EXEC);
-	map_kernel_chunk(pgd, __init_begin, __init_end, PAGE_KERNEL_EXEC);
-	map_kernel_chunk(pgd, _data, _end, PAGE_KERNEL);
+	map_kernel_chunk(pgd, _stext, _etext, PAGE_KERNEL_EXEC, &vmlinux_text);
+	map_kernel_chunk(pgd, __init_begin, __init_end, PAGE_KERNEL_EXEC,
+			 &vmlinux_init);
+	map_kernel_chunk(pgd, _data, _end, PAGE_KERNEL, &vmlinux_data);
 
-	/*
-	 * The fixmap falls in a separate pgd to the kernel, and doesn't live
-	 * in the carveout for the swapper_pg_dir. We can simply re-use the
-	 * existing dir for the fixmap.
-	 */
-	set_pgd(pgd_offset_raw(pgd, FIXADDR_START), *pgd_offset_k(FIXADDR_START));
+	if (!pgd_val(*pgd_offset_raw(pgd, FIXADDR_START))) {
+		/*
+		 * The fixmap falls in a separate pgd to the kernel, and doesn't
+		 * live in the carveout for the swapper_pg_dir. We can simply
+		 * re-use the existing dir for the fixmap.
+		 */
+		set_pgd(pgd_offset_raw(pgd, FIXADDR_START),
+			*pgd_offset_k(FIXADDR_START));
+	} else if (CONFIG_PGTABLE_LEVELS > 3) {
+		/*
+		 * The fixmap shares its top level pgd entry with the kernel
+		 * mapping. This can really only occur when we are running
+		 * with 16k/4 levels, so we can simply reuse the pud level
+		 * entry instead.
+		 */
+		BUG_ON(!IS_ENABLED(CONFIG_ARM64_16K_PAGES));
+		set_pud(pud_set_fixmap_offset(pgd, FIXADDR_START),
+			__pud(__pa(bm_pmd) | PUD_TYPE_TABLE));
+		pud_clear_fixmap();
+	} else {
+		BUG();
+	}
 
 	kasan_copy_shadow(pgd);
 }
@@ -569,14 +602,6 @@ void vmemmap_free(unsigned long start, unsigned long end)
 }
 #endif	/* CONFIG_SPARSEMEM_VMEMMAP */
 
-static pte_t bm_pte[PTRS_PER_PTE] __page_aligned_bss;
-#if CONFIG_PGTABLE_LEVELS > 2
-static pmd_t bm_pmd[PTRS_PER_PMD] __page_aligned_bss;
-#endif
-#if CONFIG_PGTABLE_LEVELS > 3
-static pud_t bm_pud[PTRS_PER_PUD] __page_aligned_bss;
-#endif
-
 static inline pud_t * fixmap_pud(unsigned long addr)
 {
 	pgd_t *pgd = pgd_offset_k(addr);
@@ -608,8 +633,18 @@ void __init early_fixmap_init(void)
 	unsigned long addr = FIXADDR_START;
 
 	pgd = pgd_offset_k(addr);
-	pgd_populate(&init_mm, pgd, bm_pud);
-	pud = fixmap_pud(addr);
+	if (CONFIG_PGTABLE_LEVELS > 3 && !pgd_none(*pgd)) {
+		/*
+		 * We only end up here if the kernel mapping and the fixmap
+		 * share the top level pgd entry, which should only happen on
+		 * 16k/4 levels configurations.
+		 */
+		BUG_ON(!IS_ENABLED(CONFIG_ARM64_16K_PAGES));
+		pud = pud_offset_kimg(pgd, addr);
+	} else {
+		pgd_populate(&init_mm, pgd, bm_pud);
+		pud = fixmap_pud(addr);
+	}
 	pud_populate(&init_mm, pud, bm_pmd);
 	pmd = fixmap_pmd(addr);
 	pmd_populate_kernel(&init_mm, pmd, bm_pte);
-- 
2.5.0
