Reply-To: kernel-hardening@lists.openwall.com
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 30 Dec 2015 16:26:10 +0100
Message-Id: <1451489172-17420-12-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1451489172-17420-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1451489172-17420-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v2 11/13] arm64: allow kernel Image to be loaded anywhere in physical memory
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
 Documentation/arm64/booting.txt  | 12 ++---
 arch/arm64/include/asm/boot.h    |  5 ++
 arch/arm64/include/asm/kvm_mmu.h |  2 +-
 arch/arm64/include/asm/memory.h  | 15 +++---
 arch/arm64/kernel/head.S         |  6 ++-
 arch/arm64/mm/init.c             | 50 +++++++++++++++++++-
 arch/arm64/mm/mmu.c              | 12 +++++
 7 files changed, 86 insertions(+), 16 deletions(-)

diff --git a/Documentation/arm64/booting.txt b/Documentation/arm64/booting.txt
index 701d39d3171a..03e02ebc1b0c 100644
--- a/Documentation/arm64/booting.txt
+++ b/Documentation/arm64/booting.txt
@@ -117,14 +117,14 @@ Header notes:
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
index 81151b67b26b..984cb0fa61ce 100644
--- a/arch/arm64/include/asm/boot.h
+++ b/arch/arm64/include/asm/boot.h
@@ -11,4 +11,9 @@
 #define MIN_FDT_ALIGN		8
 #define MAX_FDT_SIZE		SZ_2M
 
+/*
+ * arm64 requires the kernel image to be 2 MB aligned
+ */
+#define MIN_KIMG_ALIGN         SZ_2M
+
 #endif
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
index 1dcbf142d36c..557228658666 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -88,10 +88,10 @@
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
@@ -121,13 +121,14 @@ extern phys_addr_t		memstart_addr;
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
index 1230fa93fd8c..01a33e42ed70 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -445,7 +445,11 @@ __mmap_switched:
 2:
 	adr_l	sp, initial_sp, x4
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
index 2cfc9c54bf51..6aafe15c7754 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -35,6 +35,7 @@
 #include <linux/efi.h>
 #include <linux/swiotlb.h>
 
+#include <asm/boot.h>
 #include <asm/fixmap.h>
 #include <asm/kernel-pgtable.h>
 #include <asm/memory.h>
@@ -158,9 +159,56 @@ static int __init early_mem(char *p)
 }
 early_param("mem", early_mem);
 
+static void __init enforce_memory_limit(void)
+{
+	const phys_addr_t kbase = round_down(__pa(_text), MIN_KIMG_ALIGN);
+	u64 to_remove = memblock_phys_mem_size() - memory_limit;
+	phys_addr_t max_addr = 0;
+	struct memblock_region *r;
+
+	if (memory_limit == (phys_addr_t)ULLONG_MAX)
+		return;
+
+	/*
+	 * The kernel may be high up in physical memory, so try to apply the
+	 * limit below the kernel first, and only let the generic handling
+	 * take over if it turns out we haven't clipped enough memory yet.
+	 */
+	for_each_memblock(memory, r) {
+		if (r->base + r->size > kbase) {
+			u64 rem = min(to_remove, kbase - r->base);
+
+			max_addr = r->base + rem;
+			to_remove -= rem;
+			break;
+		}
+		if (to_remove <= r->size) {
+			max_addr = r->base + to_remove;
+			to_remove = 0;
+			break;
+		}
+		to_remove -= r->size;
+	}
+
+	memblock_remove(0, max_addr);
+
+	if (to_remove)
+		memblock_enforce_memory_limit(memory_limit);
+}
+
 void __init arm64_memblock_init(void)
 {
-	memblock_enforce_memory_limit(memory_limit);
+	/*
+	 * Remove the memory that we will not be able to cover
+	 * with the linear mapping.
+	 */
+	const s64 linear_region_size = -(s64)PAGE_OFFSET;
+
+	memblock_remove(round_down(memblock_start_of_DRAM(),
+				   1 << SWAPPER_TABLE_SHIFT) +
+			linear_region_size, ULLONG_MAX);
+
+	enforce_memory_limit();
 
 	/*
 	 * Register the kernel text, kernel data, initrd, and initial
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 6275d183c005..10067385e40f 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -44,6 +44,9 @@
 
 u64 idmap_t0sz = TCR_T0SZ(VA_BITS);
 
+u64 kimage_voffset __read_mostly;
+EXPORT_SYMBOL(kimage_voffset);
+
 /*
  * Empty_zero_page is a special page that is used for zero-initialized data
  * and COW.
@@ -326,6 +329,15 @@ static void __init map_mem(pgd_t *pgd)
 {
 	struct memblock_region *reg;
 
+	/*
+	 * Select a suitable value for the base of physical memory.
+	 * This should be equal to or below the lowest usable physical
+	 * memory address, and aligned to PUD/PMD size so that we can map
+	 * it efficiently.
+	 */
+	memstart_addr = round_down(memblock_start_of_DRAM(),
+				   1 << SWAPPER_TABLE_SHIFT);
+
 	/* map all the memory banks */
 	for_each_memblock(memory, reg) {
 		phys_addr_t start = reg->base;
-- 
2.5.0
