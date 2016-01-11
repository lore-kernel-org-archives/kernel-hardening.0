Reply-To: kernel-hardening@lists.openwall.com
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 11 Jan 2016 14:19:06 +0100
Message-Id: <1452518355-4606-14-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1452518355-4606-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1452518355-4606-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v3 13/21] arm64: allow kernel Image to be loaded anywhere in physical memory
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, linux-kernel@vger.kernel.org
Cc: stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, arnd@arndb.de, marc.zyngier@arm.com, christoffer.dall@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

This relaxes the kernel Image placement requirements, so that it
may be placed at any 2 MB aligned offset in physical memory.

This is accomplished by ignoring PHYS_OFFSET when installing
memblocks, and accounting for the apparent virtual offset of
the kernel Image. As a result, virtual address references
below PAGE_OFFSET are correctly mapped onto physical references
into the kernel Image regardless of where it sits in memory.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 Documentation/arm64/booting.txt         | 20 ++++--
 arch/arm64/include/asm/boot.h           |  6 ++
 arch/arm64/include/asm/kernel-pgtable.h | 11 +++
 arch/arm64/include/asm/kvm_mmu.h        |  2 +-
 arch/arm64/include/asm/memory.h         | 15 +++--
 arch/arm64/kernel/head.S                | 19 ++++--
 arch/arm64/mm/init.c                    | 71 +++++++++++++++++++-
 arch/arm64/mm/mmu.c                     |  3 +
 8 files changed, 125 insertions(+), 22 deletions(-)

diff --git a/Documentation/arm64/booting.txt b/Documentation/arm64/booting.txt
index 701d39d3171a..67484067ce4f 100644
--- a/Documentation/arm64/booting.txt
+++ b/Documentation/arm64/booting.txt
@@ -109,7 +109,13 @@ Header notes:
 			1 - 4K
 			2 - 16K
 			3 - 64K
-  Bits 3-63:	Reserved.
+  Bit 3:	Kernel physical placement
+			0 - 2MB aligned base should be as close as possible
+			    to the base of DRAM, since memory below it is not
+			    accessible
+			1 - 2MB aligned base may be anywhere in physical
+			    memory
+  Bits 4-63:	Reserved.
 
 - When image_size is zero, a bootloader should attempt to keep as much
   memory as possible free for use by the kernel immediately after the
@@ -117,14 +123,14 @@ Header notes:
   depending on selected features, and is effectively unbound.
 
 The Image must be placed text_offset bytes from a 2MB aligned base
-address near the start of usable system RAM and called there. Memory
-below that base address is currently unusable by Linux, and therefore it
-is strongly recommended that this location is the start of system RAM.
-The region between the 2 MB aligned base address and the start of the
-image has no special significance to the kernel, and may be used for
-other purposes.
+address anywhere in usable system RAM and called there. The region
+between the 2 MB aligned base address and the start of the image has no
+special significance to the kernel, and may be used for other purposes.
 At least image_size bytes from the start of the image must be free for
 use by the kernel.
+NOTE: versions prior to v4.6 cannot make use of memory below the
+physical offset of the Image so it is recommended that the Image be
+placed as close as possible to the start of system RAM.
 
 Any memory described to the kernel (even that below the start of the
 image) which is not marked as reserved from the kernel (e.g., with a
diff --git a/arch/arm64/include/asm/boot.h b/arch/arm64/include/asm/boot.h
index 81151b67b26b..ebf2481889c3 100644
--- a/arch/arm64/include/asm/boot.h
+++ b/arch/arm64/include/asm/boot.h
@@ -11,4 +11,10 @@
 #define MIN_FDT_ALIGN		8
 #define MAX_FDT_SIZE		SZ_2M
 
+/*
+ * arm64 requires the kernel image to placed
+ * TEXT_OFFSET bytes beyond a 2 MB aligned base
+ */
+#define MIN_KIMG_ALIGN		SZ_2M
+
 #endif
diff --git a/arch/arm64/include/asm/kernel-pgtable.h b/arch/arm64/include/asm/kernel-pgtable.h
index daa8a7b9917a..dfe4bae463b7 100644
--- a/arch/arm64/include/asm/kernel-pgtable.h
+++ b/arch/arm64/include/asm/kernel-pgtable.h
@@ -80,5 +80,16 @@
 #define SWAPPER_MM_MMUFLAGS	(PTE_ATTRINDX(MT_NORMAL) | SWAPPER_PTE_FLAGS)
 #endif
 
+/*
+ * To make optimal use of block mappings when laying out the linear mapping,
+ * round down the base of physical memory to a size that can be mapped
+ * efficiently, i.e., either PUD_SIZE (4k) or PMD_SIZE (64k), or a multiple that
+ * can be mapped using contiguous bits in the page tables: 32 * PMD_SIZE (16k)
+ */
+#ifdef CONFIG_ARM64_64K_PAGES
+#define ARM64_MEMSTART_ALIGN	SZ_512M
+#else
+#define ARM64_MEMSTART_ALIGN	SZ_1G
+#endif
 
 #endif	/* __ASM_KERNEL_PGTABLE_H */
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 0899026a2821..7e9516365b76 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -73,7 +73,7 @@
 
 #define KERN_TO_HYP(kva)	((unsigned long)kva - PAGE_OFFSET + HYP_PAGE_OFFSET)
 
-#define kvm_ksym_ref(sym)	((void *)&sym - KIMAGE_VADDR + PAGE_OFFSET)
+#define kvm_ksym_ref(sym)	phys_to_virt((u64)&sym - kimage_voffset)
 
 /*
  * We currently only support a 40bit IPA.
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index e45d3141ad98..758fb4a503ef 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -89,10 +89,10 @@
 #define __virt_to_phys(x) ({						\
 	phys_addr_t __x = (phys_addr_t)(x);				\
 	__x >= PAGE_OFFSET ? (__x - PAGE_OFFSET + PHYS_OFFSET) :	\
-			     (__x - KIMAGE_VADDR + PHYS_OFFSET); })
+			     (__x - kimage_voffset); })
 
 #define __phys_to_virt(x)	((unsigned long)((x) - PHYS_OFFSET + PAGE_OFFSET))
-#define __phys_to_kimg(x)	((unsigned long)((x) - PHYS_OFFSET + KIMAGE_VADDR))
+#define __phys_to_kimg(x)	((unsigned long)((x) + kimage_voffset))
 
 /*
  * Convert a page to/from a physical address
@@ -122,13 +122,14 @@ extern phys_addr_t		memstart_addr;
 /* PHYS_OFFSET - the physical address of the start of memory. */
 #define PHYS_OFFSET		({ memstart_addr; })
 
+/* the offset between the kernel virtual and physical mappings */
+extern u64			kimage_voffset;
+
 /*
- * The maximum physical address that the linear direct mapping
- * of system RAM can cover. (PAGE_OFFSET can be interpreted as
- * a 2's complement signed quantity and negated to derive the
- * maximum size of the linear mapping.)
+ * Allow all memory at the discovery stage. We will clip it later.
  */
-#define MAX_MEMBLOCK_ADDR	({ memstart_addr - PAGE_OFFSET - 1; })
+#define MIN_MEMBLOCK_ADDR	0
+#define MAX_MEMBLOCK_ADDR	U64_MAX
 
 /*
  * PFNs are used to describe any physical page; this means
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 5dc8079cef77..d66aee595170 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -52,15 +52,18 @@
 #define KERNEL_END	_end
 
 #ifdef CONFIG_CPU_BIG_ENDIAN
-#define __HEAD_FLAG_BE	1
+#define __HEAD_FLAG_BE		1
 #else
-#define __HEAD_FLAG_BE	0
+#define __HEAD_FLAG_BE		0
 #endif
 
-#define __HEAD_FLAG_PAGE_SIZE ((PAGE_SHIFT - 10) / 2)
+#define __HEAD_FLAG_PHYS_BASE	1
 
-#define __HEAD_FLAGS	((__HEAD_FLAG_BE << 0) |	\
-			 (__HEAD_FLAG_PAGE_SIZE << 1))
+#define __HEAD_FLAG_PAGE_SIZE	((PAGE_SHIFT - 10) / 2)
+
+#define __HEAD_FLAGS		((__HEAD_FLAG_BE << 0) |	\
+				 (__HEAD_FLAG_PAGE_SIZE << 1) |	\
+				 (__HEAD_FLAG_PHYS_BASE << 3))
 
 /*
  * Kernel startup entry point.
@@ -448,7 +451,11 @@ __mmap_switched:
 	and	x4, x4, #~(THREAD_SIZE - 1)
 	msr	sp_el0, x4			// Save thread_info
 	str_l	x21, __fdt_pointer, x5		// Save FDT pointer
-	str_l	x24, memstart_addr, x6		// Save PHYS_OFFSET
+
+	ldr	x0, =KIMAGE_VADDR		// Save the offset between
+	sub	x24, x0, x24			// the kernel virtual and
+	str_l	x24, kimage_voffset, x0		// physical mappings
+
 	mov	x29, #0
 #ifdef CONFIG_KASAN
 	bl	kasan_early_init
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index baa923bda651..9e89965a2fad 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -35,7 +35,9 @@
 #include <linux/efi.h>
 #include <linux/swiotlb.h>
 
+#include <asm/boot.h>
 #include <asm/fixmap.h>
+#include <asm/kernel-pgtable.h>
 #include <asm/memory.h>
 #include <asm/sections.h>
 #include <asm/setup.h>
@@ -157,9 +159,76 @@ static int __init early_mem(char *p)
 }
 early_param("mem", early_mem);
 
+/*
+ * clip_mem_range() - remove memblock memory between @min and @max until
+ *                    we meet the limit in 'memory_limit'.
+ */
+static void __init clip_mem_range(u64 min, u64 max)
+{
+	u64 mem_size, to_remove;
+	int i;
+
+again:
+	mem_size = memblock_phys_mem_size();
+	if (mem_size <= memory_limit || max <= min)
+		return;
+
+	to_remove = mem_size - memory_limit;
+
+	for (i = memblock.memory.cnt - 1; i >= 0; i--) {
+		struct memblock_region *r = memblock.memory.regions + i;
+		u64 start = max(min, r->base);
+		u64 end = min(max, r->base + r->size);
+
+		if (start >= max || end <= min)
+			continue;
+
+		if (end > min) {
+			u64 size = min(to_remove, end - max(start, min));
+
+			memblock_remove(end - size, size);
+		} else {
+			memblock_remove(start, min(max - start, to_remove));
+		}
+		goto again;
+	}
+}
+
 void __init arm64_memblock_init(void)
 {
-	memblock_enforce_memory_limit(memory_limit);
+	const s64 linear_region_size = -(s64)PAGE_OFFSET;
+
+	/*
+	 * Select a suitable value for the base of physical memory.
+	 */
+	memstart_addr = round_down(memblock_start_of_DRAM(),
+				   ARM64_MEMSTART_ALIGN);
+
+	/*
+	 * Remove the memory that we will not be able to cover
+	 * with the linear mapping.
+	 */
+	memblock_remove(memstart_addr + linear_region_size, ULLONG_MAX);
+
+	if (memory_limit != (phys_addr_t)ULLONG_MAX) {
+		u64 kbase = round_down(__pa(_text), MIN_KIMG_ALIGN);
+		u64 kend = PAGE_ALIGN(__pa(_end));
+		u64 const sz_4g = 0x100000000UL;
+
+		/*
+		 * Clip memory in order of preference:
+		 * - above the kernel and above 4 GB
+		 * - between 4 GB and the start of the kernel (if the kernel
+		 *   is loaded high in memory)
+		 * - between the kernel and 4 GB (if the kernel is loaded
+		 *   low in memory)
+		 * - below 4 GB
+		 */
+		clip_mem_range(max(sz_4g, kend), ULLONG_MAX);
+		clip_mem_range(sz_4g, kbase);
+		clip_mem_range(kend, sz_4g);
+		clip_mem_range(0, min(kbase, sz_4g));
+	}
 
 	/*
 	 * Register the kernel text, kernel data, initrd, and initial
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 0b28f1469f9b..a1fd3414a322 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -46,6 +46,9 @@
 
 u64 idmap_t0sz = TCR_T0SZ(VA_BITS);
 
+u64 kimage_voffset __read_mostly;
+EXPORT_SYMBOL(kimage_voffset);
+
 /*
  * Empty_zero_page is a special page that is used for zero-initialized data
  * and COW.
-- 
2.5.0
