Reply-To: kernel-hardening@lists.openwall.com
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 28 Dec 2015 12:20:48 +0100
Message-Id: <1451301654-32019-5-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1451301654-32019-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1451301654-32019-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [RFC PATCH 04/10] arm64: move kernel image to base of vmalloc area
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, lkml@vger.kernel.org
Cc: stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

This moves the module area to right before the vmalloc area, and
moves the kernel image to the base of the vmalloc area. This is
an intermediate step towards implementing kASLR, where the kernel
image can be located anywhere in the vmalloc area.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/kasan.h   | 17 ++++-----
 arch/arm64/include/asm/memory.h  | 17 ++++++---
 arch/arm64/include/asm/pgtable.h |  7 ----
 arch/arm64/kernel/setup.c        | 13 +++++++
 arch/arm64/mm/dump.c             | 12 +++----
 arch/arm64/mm/init.c             | 20 +++++------
 arch/arm64/mm/mmu.c              | 37 ++------------------
 7 files changed, 53 insertions(+), 70 deletions(-)

diff --git a/arch/arm64/include/asm/kasan.h b/arch/arm64/include/asm/kasan.h
index 2774fa384c47..476d56e0f04c 100644
--- a/arch/arm64/include/asm/kasan.h
+++ b/arch/arm64/include/asm/kasan.h
@@ -1,19 +1,16 @@
 #ifndef __ASM_KASAN_H
 #define __ASM_KASAN_H
 
-#ifndef __ASSEMBLY__
-
 #ifdef CONFIG_KASAN
 
 #include <linux/linkage.h>
-#include <asm/memory.h>
 
 /*
  * KASAN_SHADOW_START: beginning of the kernel virtual addresses.
  * KASAN_SHADOW_END: KASAN_SHADOW_START + 1/8 of kernel virtual addresses.
  */
-#define KASAN_SHADOW_START      (VA_START)
-#define KASAN_SHADOW_END        (KASAN_SHADOW_START + (1UL << (VA_BITS - 3)))
+#define KASAN_SHADOW_START	(VA_START)
+#define KASAN_SHADOW_END	(KASAN_SHADOW_START + (_AC(1, UL) << (VA_BITS - 3)))
 
 /*
  * This value is used to map an address to the corresponding shadow
@@ -25,14 +22,18 @@
  * should satisfy the following equation:
  *      KASAN_SHADOW_OFFSET = KASAN_SHADOW_END - (1ULL << 61)
  */
-#define KASAN_SHADOW_OFFSET     (KASAN_SHADOW_END - (1ULL << (64 - 3)))
+#define KASAN_SHADOW_OFFSET	(KASAN_SHADOW_END - (_AC(1, ULL) << (64 - 3)))
 
+#ifndef __ASSEMBLY__
 void kasan_init(void);
 asmlinkage void kasan_early_init(void);
+#endif
 
 #else
+
+#ifndef __ASSEMBLY__
 static inline void kasan_init(void) { }
 #endif
 
-#endif
-#endif
+#endif /* CONFIG_KASAN */
+#endif /* __ASM_KASAN_H */
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index bea9631b34a8..1dcbf142d36c 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -51,14 +51,23 @@
 #define VA_BITS			(CONFIG_ARM64_VA_BITS)
 #define VA_START		(UL(0xffffffffffffffff) << VA_BITS)
 #define PAGE_OFFSET		(UL(0xffffffffffffffff) << (VA_BITS - 1))
-#define KIMAGE_VADDR		(PAGE_OFFSET)
-#define MODULES_END		(KIMAGE_VADDR)
-#define MODULES_VADDR		(MODULES_END - SZ_64M)
-#define PCI_IO_END		(MODULES_VADDR - SZ_2M)
+#define PCI_IO_END		(PAGE_OFFSET - SZ_2M)
 #define PCI_IO_START		(PCI_IO_END - PCI_IO_SIZE)
 #define FIXADDR_TOP		(PCI_IO_START - SZ_2M)
 #define TASK_SIZE_64		(UL(1) << VA_BITS)
 
+#ifndef CONFIG_KASAN
+#define MODULES_VADDR		(VA_START)
+#else
+#include <asm/kasan.h>
+#define MODULES_VADDR		(KASAN_SHADOW_END)
+#endif
+
+#define MODULES_END		(MODULES_VADDR + SZ_64M)
+
+#define KIMAGE_VADDR		(MODULES_END)
+#define VMALLOC_START		(MODULES_END)
+
 #ifdef CONFIG_COMPAT
 #define TASK_SIZE_32		UL(0x100000000)
 #define TASK_SIZE		(test_thread_flag(TIF_32BIT) ? \
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 0664468466fb..93203a6b9574 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -42,13 +42,6 @@
  */
 #define VMEMMAP_SIZE		ALIGN((1UL << (VA_BITS - PAGE_SHIFT)) * sizeof(struct page), PUD_SIZE)
 
-#ifndef CONFIG_KASAN
-#define VMALLOC_START		(VA_START)
-#else
-#include <asm/kasan.h>
-#define VMALLOC_START		(KASAN_SHADOW_END + SZ_64K)
-#endif
-
 #define VMALLOC_END		(PAGE_OFFSET - PUD_SIZE - VMEMMAP_SIZE - SZ_64K)
 
 #define vmemmap			((struct page *)(VMALLOC_END + SZ_64K))
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index cfed56f0ad26..96177a7c0f05 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -53,6 +53,7 @@
 #include <asm/cpufeature.h>
 #include <asm/cpu_ops.h>
 #include <asm/kasan.h>
+#include <asm/kernel-pgtable.h>
 #include <asm/sections.h>
 #include <asm/setup.h>
 #include <asm/smp_plat.h>
@@ -291,6 +292,18 @@ u64 __cpu_logical_map[NR_CPUS] = { [0 ... NR_CPUS-1] = INVALID_HWID };
 
 void __init setup_arch(char **cmdline_p)
 {
+	static struct vm_struct vmlinux_vm __initdata = {
+		.addr		= (void *)KIMAGE_VADDR,
+		.size		= 0,
+		.flags		= VM_IOREMAP,
+		.caller		= setup_arch,
+	};
+
+	vmlinux_vm.size = round_up((unsigned long)_end - KIMAGE_VADDR,
+				   1 << SWAPPER_BLOCK_SHIFT);
+	vmlinux_vm.phys_addr = __pa(KIMAGE_VADDR);
+	vm_area_add_early(&vmlinux_vm);
+
 	pr_info("Boot CPU: AArch64 Processor [%08x]\n", read_cpuid_id());
 
 	sprintf(init_utsname()->machine, ELF_PLATFORM);
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
index 8e678d05ad84..2cfc9c54bf51 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -305,22 +305,26 @@ void __init mem_init(void)
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
@@ -329,11 +333,7 @@ void __init mem_init(void)
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
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 3435c316d607..8042f88f42b5 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -322,40 +322,6 @@ static void create_mapping_late(phys_addr_t phys, unsigned long virt,
 	__create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, late_alloc);
 }
 
-static void __init __map_memblock(pgd_t *pgd, phys_addr_t start, phys_addr_t end)
-{
-
-	unsigned long kernel_start = __pa(_stext);
-	unsigned long kernel_end = __pa(_end);
-
-	/*
-	 * The kernel itself is mapped at page granularity. Map all other
-	 * memory, making sure we don't overwrite the existing kernel mappings.
-	 */
-
-	/* No overlap with the kernel. */
-	if (end < kernel_start || start >= kernel_end) {
-		__create_pgd_mapping(pgd, start, __phys_to_virt(start),
-				     end - start, PAGE_KERNEL, early_alloc);
-		return;
-	}
-
-	/*
-	 * This block overlaps the kernel mapping. Map the portion(s) which
-	 * don't overlap.
-	 */
-	if (start < kernel_start)
-		__create_pgd_mapping(pgd, start,
-				     __phys_to_virt(start),
-				     kernel_start - start, PAGE_KERNEL,
-				     early_alloc);
-	if (kernel_end < end)
-		__create_pgd_mapping(pgd, kernel_end,
-				     __phys_to_virt(kernel_end),
-				     end - kernel_end, PAGE_KERNEL,
-				     early_alloc);
-}
-
 static void __init map_mem(pgd_t *pgd)
 {
 	struct memblock_region *reg;
@@ -370,7 +336,8 @@ static void __init map_mem(pgd_t *pgd)
 		if (memblock_is_nomap(reg))
 			continue;
 
-		__map_memblock(pgd, start, end);
+		__create_pgd_mapping(pgd, start, __phys_to_virt(start),
+				     end - start, PAGE_KERNEL, early_alloc);
 	}
 }
 
-- 
2.5.0
