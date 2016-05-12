Reply-To: kernel-hardening@lists.openwall.com
From: Thomas Garnier <thgarnie@google.com>
Date: Thu, 12 May 2016 09:08:59 -0700
Message-Id: <1463069340-117401-4-git-send-email-thgarnie@google.com>
In-Reply-To: <1463069340-117401-1-git-send-email-thgarnie@google.com>
References: <1463069340-117401-1-git-send-email-thgarnie@google.com>
Subject: [kernel-hardening] [PATCH v4 3/4] x86, boot: Implement ASLR for kernel memory sections (x86_64)
To: "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, Thomas Garnier <thgarnie@google.com>, Dmitry Vyukov <dvyukov@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Kees Cook <keescook@chromium.org>, Stephen Smalley <sds@tycho.nsa.gov>, Kefeng Wang <wangkefeng.wang@huawei.com>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, Toshi Kani <toshi.kani@hpe.com>, Alexander Kuleshov <kuleshovmail@gmail.com>, Alexander Popov <alpopov@ptsecurity.com>, Joerg Roedel <jroedel@suse.de>, Dave Young <dyoung@redhat.com>, Baoquan He <bhe@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mark Salter <msalter@redhat.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, gthelen@google.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Randomizes the virtual address space of kernel memory sections (physical
memory mapping, vmalloc & vmemmap) for x86_64. This security feature
mitigates exploits relying on predictable kernel addresses. These
addresses can be used to disclose the kernel modules base addresses or
corrupt specific structures to elevate privileges bypassing the current
implementation of KASLR. This feature can be enabled with the
CONFIG_RANDOMIZE_MEMORY option.

The physical memory mapping holds most allocations from boot and heap
allocators. Knowning the base address and physical memory size, an
attacker can deduce the PDE virtual address for the vDSO memory page.
This attack was demonstrated at CanSecWest 2016, in the "Getting
Physical Extreme Abuse of Intel Based Paged Systems"
https://goo.gl/ANpWdV (see second part of the presentation). The
exploits used against Linux worked successfuly against 4.6+ but fail
with KASLR memory enabled (https://goo.gl/iTtXMJ). Similar research
was done at Google leading to this patch proposal. Variants exists to
overwrite /proc or /sys objects ACLs leading to elevation of privileges.
These variants were tested against 4.6+.

The vmalloc memory section contains the allocation made through the
vmalloc api. The allocations are done sequentially to prevent
fragmentation and each allocation address can easily be deduced
especially from boot.

The vmemmap section holds a representation of the physical
memory (through a struct page array). An attacker could use this section
to disclose the kernel memory layout (walking the page linked list).

The order of each memory section is not changed. The feature looks at
the available space for the sections based on different configuration
options and randomizes the base and space between each. The size of the
physical memory mapping is the available physical memory. No performance
impact was detected while testing the feature.

Entropy is generated using the KASLR early boot functions now shared in
the lib directory (originally written by Kees Cook). Randomization is
done on PGD & PUD page table levels to increase possible addresses. The
physical memory mapping code was adapted to support PUD level virtual
addresses. This implementation on the best configuration provides 30,000
possible virtual addresses in average for each memory section.  An
additional low memory page is used to ensure each CPU can start with a
PGD aligned virtual address (for realmode).

x86/dump_pagetable was updated to correctly display each section.

KASLR ident on compress boot was adapted to use the static base.

Updated documentation on x86_64 memory layout accordingly.

Performance data:

Kernbench shows almost no difference (-+ less than 1%):

Before:

Average Optimal load -j 12 Run (std deviation):
Elapsed Time 102.63 (1.2695)
User Time 1034.89 (1.18115)
System Time 87.056 (0.456416)
Percent CPU 1092.9 (13.892)
Context Switches 199805 (3455.33)
Sleeps 97907.8 (900.636)

After:

Average Optimal load -j 12 Run (std deviation):
Elapsed Time 102.489 (1.10636)
User Time 1034.86 (1.36053)
System Time 87.764 (0.49345)
Percent CPU 1095 (12.7715)
Context Switches 199036 (4298.1)
Sleeps 97681.6 (1031.11)

Hackbench shows 0% difference on average (hackbench 90
repeated 10 times):

attemp,before,after
1,0.076,0.069
2,0.072,0.069
3,0.066,0.066
4,0.066,0.068
5,0.066,0.067
6,0.066,0.069
7,0.067,0.066
8,0.063,0.067
9,0.067,0.065
10,0.068,0.071
average,0.0677,0.0677

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
Based on next-20160511
---
 Documentation/x86/x86_64/mm.txt         |   4 +
 arch/x86/Kconfig                        |  17 ++++
 arch/x86/boot/compressed/pagetable.c    |   3 +
 arch/x86/include/asm/kaslr.h            |  12 +++
 arch/x86/include/asm/page_64_types.h    |  11 ++-
 arch/x86/include/asm/pgtable_64.h       |   1 +
 arch/x86/include/asm/pgtable_64_types.h |  15 +++-
 arch/x86/kernel/head_64.S               |   2 +-
 arch/x86/kernel/setup.c                 |   3 +
 arch/x86/mm/Makefile                    |   1 +
 arch/x86/mm/dump_pagetables.c           |  16 +++-
 arch/x86/mm/init.c                      |   7 ++
 arch/x86/mm/kaslr.c                     | 146 ++++++++++++++++++++++++++++++++
 arch/x86/realmode/init.c                |   5 +-
 14 files changed, 233 insertions(+), 10 deletions(-)
 create mode 100644 arch/x86/mm/kaslr.c

diff --git a/Documentation/x86/x86_64/mm.txt b/Documentation/x86/x86_64/mm.txt
index 5aa7383..8c7dd59 100644
--- a/Documentation/x86/x86_64/mm.txt
+++ b/Documentation/x86/x86_64/mm.txt
@@ -39,4 +39,8 @@ memory window (this size is arbitrary, it can be raised later if needed).
 The mappings are not part of any other kernel PGD and are only available
 during EFI runtime calls.
 
+Note that if CONFIG_RANDOMIZE_MEMORY is enabled, the direct mapping of all
+physical memory, vmalloc/ioremap space and virtual memory map are randomized.
+Their order is preserved but their base will be offset early at boot time.
+
 -Andi Kleen, Jul 2004
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1afec82..f5ed150 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1988,6 +1988,23 @@ config PHYSICAL_ALIGN
 
 	  Don't change this unless you know what you are doing.
 
+config RANDOMIZE_MEMORY
+	bool "Randomize the kernel memory sections"
+	depends on X86_64
+	depends on RANDOMIZE_BASE
+	default RANDOMIZE_BASE
+	---help---
+	   Randomizes the base virtual address of kernel memory sections
+	   (physical memory mapping, vmalloc & vmemmap). This security feature
+	   makes exploits relying on predictable memory locations less reliable.
+
+	   The order of allocations remains unchanged. Entropy is generated in
+	   the same way as RANDOMIZE_BASE. Current implementation in the optimal
+	   configuration have in average 30,000 different possible virtual
+	   addresses for each memory section.
+
+	   If unsure, say N.
+
 config HOTPLUG_CPU
 	bool "Support for hot-pluggable CPUs"
 	depends on SMP
diff --git a/arch/x86/boot/compressed/pagetable.c b/arch/x86/boot/compressed/pagetable.c
index 34b95df..49b6d22 100644
--- a/arch/x86/boot/compressed/pagetable.c
+++ b/arch/x86/boot/compressed/pagetable.c
@@ -17,6 +17,9 @@
 /* These actually do the work of building the kernel identity maps. */
 #include <asm/init.h>
 #include <asm/pgtable.h>
+/* Use the static base for this part of the boot process */
+#undef __PAGE_OFFSET
+#define __PAGE_OFFSET __PAGE_OFFSET_BASE
 #include "../../mm/ident_map.c"
 
 /* Used by pgtable.h asm code to force instruction serialization. */
diff --git a/arch/x86/include/asm/kaslr.h b/arch/x86/include/asm/kaslr.h
index 5547438..c66d84c 100644
--- a/arch/x86/include/asm/kaslr.h
+++ b/arch/x86/include/asm/kaslr.h
@@ -3,4 +3,16 @@
 
 unsigned long kaslr_get_random_long(const char *purpose);
 
+#ifdef CONFIG_RANDOMIZE_MEMORY
+extern unsigned long page_offset_base;
+extern unsigned long vmalloc_base;
+extern unsigned long vmemmap_base;
+
+void kernel_randomize_memory(void);
+void kaslr_trampoline_init(void);
+#else
+static inline void kernel_randomize_memory(void) { }
+static inline void kaslr_trampoline_init(void) { }
+#endif /* CONFIG_RANDOMIZE_MEMORY */
+
 #endif
diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
index d5c2f8b..9215e05 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -1,6 +1,10 @@
 #ifndef _ASM_X86_PAGE_64_DEFS_H
 #define _ASM_X86_PAGE_64_DEFS_H
 
+#ifndef __ASSEMBLY__
+#include <asm/kaslr.h>
+#endif
+
 #ifdef CONFIG_KASAN
 #define KASAN_STACK_ORDER 1
 #else
@@ -32,7 +36,12 @@
  * hypervisor to fit.  Choosing 16 slots here is arbitrary, but it's
  * what Xen requires.
  */
-#define __PAGE_OFFSET           _AC(0xffff880000000000, UL)
+#define __PAGE_OFFSET_BASE      _AC(0xffff880000000000, UL)
+#ifdef CONFIG_RANDOMIZE_MEMORY
+#define __PAGE_OFFSET           page_offset_base
+#else
+#define __PAGE_OFFSET           __PAGE_OFFSET_BASE
+#endif /* CONFIG_RANDOMIZE_MEMORY */
 
 #define __START_KERNEL_map	_AC(0xffffffff80000000, UL)
 
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
index 2ee7811..0dfec89 100644
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -21,6 +21,7 @@ extern pmd_t level2_fixmap_pgt[512];
 extern pmd_t level2_ident_pgt[512];
 extern pte_t level1_fixmap_pgt[512];
 extern pgd_t init_level4_pgt[];
+extern pgd_t trampoline_pgd_entry;
 
 #define swapper_pg_dir init_level4_pgt
 
diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
index e6844df..d388739 100644
--- a/arch/x86/include/asm/pgtable_64_types.h
+++ b/arch/x86/include/asm/pgtable_64_types.h
@@ -5,6 +5,7 @@
 
 #ifndef __ASSEMBLY__
 #include <linux/types.h>
+#include <asm/kaslr.h>
 
 /*
  * These are used to make use of C type-checking..
@@ -54,9 +55,17 @@ typedef struct { pteval_t pte; } pte_t;
 
 /* See Documentation/x86/x86_64/mm.txt for a description of the memory map. */
 #define MAXMEM		 _AC(__AC(1, UL) << MAX_PHYSMEM_BITS, UL)
-#define VMALLOC_START    _AC(0xffffc90000000000, UL)
-#define VMALLOC_END      _AC(0xffffe8ffffffffff, UL)
-#define VMEMMAP_START	 _AC(0xffffea0000000000, UL)
+#define VMALLOC_SIZE_TB	 _AC(32, UL)
+#define __VMALLOC_BASE	 _AC(0xffffc90000000000, UL)
+#define __VMEMMAP_BASE	 _AC(0xffffea0000000000, UL)
+#ifdef CONFIG_RANDOMIZE_MEMORY
+#define VMALLOC_START	 vmalloc_base
+#define VMEMMAP_START	 vmemmap_base
+#else
+#define VMALLOC_START	 __VMALLOC_BASE
+#define VMEMMAP_START	 __VMEMMAP_BASE
+#endif /* CONFIG_RANDOMIZE_MEMORY */
+#define VMALLOC_END      (VMALLOC_START + _AC((VMALLOC_SIZE_TB << 40) - 1, UL))
 #define MODULES_VADDR    (__START_KERNEL_map + KERNEL_IMAGE_SIZE)
 #define MODULES_END      _AC(0xffffffffff000000, UL)
 #define MODULES_LEN   (MODULES_END - MODULES_VADDR)
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 5df831e..03a2aa0 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -38,7 +38,7 @@
 
 #define pud_index(x)	(((x) >> PUD_SHIFT) & (PTRS_PER_PUD-1))
 
-L4_PAGE_OFFSET = pgd_index(__PAGE_OFFSET)
+L4_PAGE_OFFSET = pgd_index(__PAGE_OFFSET_BASE)
 L4_START_KERNEL = pgd_index(__START_KERNEL_map)
 L3_START_KERNEL = pud_index(__START_KERNEL_map)
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index c4e7b39..a261658 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -113,6 +113,7 @@
 #include <asm/prom.h>
 #include <asm/microcode.h>
 #include <asm/mmu_context.h>
+#include <asm/kaslr.h>
 
 /*
  * max_low_pfn_mapped: highest direct mapped pfn under 4GB
@@ -942,6 +943,8 @@ void __init setup_arch(char **cmdline_p)
 
 	x86_init.oem.arch_setup();
 
+	kernel_randomize_memory();
+
 	iomem_resource.end = (1ULL << boot_cpu_data.x86_phys_bits) - 1;
 	setup_memory_map();
 	parse_setup_data();
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 62c0043..96d2b84 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -37,4 +37,5 @@ obj-$(CONFIG_NUMA_EMU)		+= numa_emulation.o
 
 obj-$(CONFIG_X86_INTEL_MPX)	+= mpx.o
 obj-$(CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS) += pkeys.o
+obj-$(CONFIG_RANDOMIZE_MEMORY) += kaslr.o
 
diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index 99bfb19..9a17250 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -72,9 +72,9 @@ static struct addr_marker address_markers[] = {
 	{ 0, "User Space" },
 #ifdef CONFIG_X86_64
 	{ 0x8000000000000000UL, "Kernel Space" },
-	{ PAGE_OFFSET,		"Low Kernel Mapping" },
-	{ VMALLOC_START,        "vmalloc() Area" },
-	{ VMEMMAP_START,        "Vmemmap" },
+	{ 0/* PAGE_OFFSET */,   "Low Kernel Mapping" },
+	{ 0/* VMALLOC_START */, "vmalloc() Area" },
+	{ 0/* VMEMMAP_START */, "Vmemmap" },
 # ifdef CONFIG_X86_ESPFIX64
 	{ ESPFIX_BASE_ADDR,	"ESPfix Area", 16 },
 # endif
@@ -434,8 +434,16 @@ void ptdump_walk_pgd_level_checkwx(void)
 
 static int __init pt_dump_init(void)
 {
+	/*
+	 * Various markers are not compile-time constants, so assign them
+	 * here.
+	 */
+#ifdef CONFIG_X86_64
+	address_markers[LOW_KERNEL_NR].start_address = PAGE_OFFSET;
+	address_markers[VMALLOC_START_NR].start_address = VMALLOC_START;
+	address_markers[VMEMMAP_START_NR].start_address = VMEMMAP_START;
+#endif
 #ifdef CONFIG_X86_32
-	/* Not a compile-time constant on x86-32 */
 	address_markers[VMALLOC_START_NR].start_address = VMALLOC_START;
 	address_markers[VMALLOC_END_NR].start_address = VMALLOC_END;
 # ifdef CONFIG_HIGHMEM
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 372aad2..e386e0e 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -17,6 +17,7 @@
 #include <asm/proto.h>
 #include <asm/dma.h>		/* for MAX_DMA_PFN */
 #include <asm/microcode.h>
+#include <asm/kaslr.h>
 
 /*
  * We need to define the tracepoints somewhere, and tlb.c
@@ -590,6 +591,12 @@ void __init init_mem_mapping(void)
 	/* the ISA range is always mapped regardless of memory holes */
 	init_memory_mapping(0, ISA_END_ADDRESS);
 
+	/* Default trampoline pgd value */
+	trampoline_pgd_entry = init_level4_pgt[pgd_index(__PAGE_OFFSET)];
+
+	/* Init the trampoline page table if needed for KASLR memory */
+	kaslr_trampoline_init();
+
 	/*
 	 * If the allocation is in bottom-up direction, we setup direct mapping
 	 * in bottom-up, otherwise we setup direct mapping in top-down.
diff --git a/arch/x86/mm/kaslr.c b/arch/x86/mm/kaslr.c
new file mode 100644
index 0000000..2415178
--- /dev/null
+++ b/arch/x86/mm/kaslr.c
@@ -0,0 +1,146 @@
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/mm.h>
+#include <linux/smp.h>
+#include <linux/init.h>
+#include <linux/memory.h>
+#include <linux/random.h>
+
+#include <asm/processor.h>
+#include <asm/pgtable.h>
+#include <asm/pgalloc.h>
+#include <asm/e820.h>
+#include <asm/init.h>
+#include <asm/setup.h>
+#include <asm/kaslr.h>
+#include <asm/kasan.h>
+
+#include "mm_internal.h"
+
+#define TB_SHIFT 40
+
+/*
+ * Memory base and end randomization is based on different configurations.
+ * We want as much space as possible to increase entropy available.
+ */
+static const unsigned long memory_rand_start = __PAGE_OFFSET_BASE;
+
+#if defined(CONFIG_KASAN)
+static const unsigned long memory_rand_end = KASAN_SHADOW_START;
+#elif defined(CONFIG_X86_ESPFIX64)
+static const unsigned long memory_rand_end = ESPFIX_BASE_ADDR;
+#elif defined(CONFIG_EFI)
+static const unsigned long memory_rand_end = EFI_VA_START;
+#else
+static const unsigned long memory_rand_end = __START_KERNEL_map;
+#endif
+
+/* Default values */
+unsigned long page_offset_base = __PAGE_OFFSET_BASE;
+EXPORT_SYMBOL(page_offset_base);
+unsigned long vmalloc_base = __VMALLOC_BASE;
+EXPORT_SYMBOL(vmalloc_base);
+unsigned long vmemmap_base = __VMEMMAP_BASE;
+EXPORT_SYMBOL(vmemmap_base);
+
+/* Describe each randomized memory sections in sequential order */
+static __initdata struct kaslr_memory_region {
+	unsigned long *base;
+	unsigned short size_tb;
+} kaslr_regions[] = {
+	{ &page_offset_base, 64/* Maximum */ },
+	{ &vmalloc_base, VMALLOC_SIZE_TB },
+	{ &vmemmap_base, 1 },
+};
+
+/* Size in Terabytes + 1 hole */
+static __init unsigned long get_padding(struct kaslr_memory_region *region)
+{
+	return ((unsigned long)region->size_tb + 1) << TB_SHIFT;
+}
+
+/* Initialize base and padding for each memory section randomized with KASLR */
+void __init kernel_randomize_memory(void)
+{
+	size_t i;
+	unsigned long addr = memory_rand_start;
+	unsigned long padding, rand, mem_tb;
+	struct rnd_state rnd_st;
+	unsigned long remain_padding = memory_rand_end - memory_rand_start;
+
+	/*
+	 * All these BUILD_BUG_ON checks ensures the memory layout is
+	 * consistent with the current KASLR design.
+	 */
+	BUILD_BUG_ON(memory_rand_start >= memory_rand_end);
+	BUILD_BUG_ON(config_enabled(CONFIG_KASAN) &&
+		memory_rand_end >= ESPFIX_BASE_ADDR);
+	BUILD_BUG_ON((config_enabled(CONFIG_KASAN) ||
+			config_enabled(CONFIG_X86_ESPFIX64)) &&
+		memory_rand_end >= EFI_VA_START);
+	BUILD_BUG_ON((config_enabled(CONFIG_KASAN) ||
+			config_enabled(CONFIG_X86_ESPFIX64) ||
+			config_enabled(CONFIG_EFI)) &&
+		memory_rand_end >= __START_KERNEL_map);
+	BUILD_BUG_ON(memory_rand_end > __START_KERNEL_map);
+
+	if (!kaslr_enabled())
+		return;
+
+	BUG_ON(kaslr_regions[0].base != &page_offset_base);
+	mem_tb = ((max_pfn << PAGE_SHIFT) >> TB_SHIFT);
+
+	if (mem_tb < kaslr_regions[0].size_tb)
+		kaslr_regions[0].size_tb = mem_tb;
+
+	for (i = 0; i < ARRAY_SIZE(kaslr_regions); i++)
+		remain_padding -= get_padding(&kaslr_regions[i]);
+
+	prandom_seed_state(&rnd_st, kaslr_get_random_long("Memory"));
+
+	/* Position each section randomly with minimum 1 terabyte between */
+	for (i = 0; i < ARRAY_SIZE(kaslr_regions); i++) {
+		padding = remain_padding / (ARRAY_SIZE(kaslr_regions) - i);
+		prandom_bytes_state(&rnd_st, &rand, sizeof(rand));
+		padding = (rand % (padding + 1)) & PUD_MASK;
+		addr += padding;
+		*kaslr_regions[i].base = addr;
+		addr += get_padding(&kaslr_regions[i]);
+		remain_padding -= padding;
+	}
+}
+
+/*
+ * Create PGD aligned trampoline table to allow real mode initialization
+ * of additional CPUs. Consume only 1 low memory page.
+ */
+void __meminit kaslr_trampoline_init(void)
+{
+	unsigned long addr, next;
+	pgd_t *pgd;
+	pud_t *pud_page, *tr_pud_page;
+	int i;
+
+	if (!kaslr_enabled())
+		return;
+
+	tr_pud_page = alloc_low_page();
+	set_pgd(&trampoline_pgd_entry, __pgd(_PAGE_TABLE | __pa(tr_pud_page)));
+
+	addr = 0;
+	pgd = pgd_offset_k((unsigned long)__va(addr));
+	pud_page = (pud_t *) pgd_page_vaddr(*pgd);
+
+	for (i = pud_index(addr); i < PTRS_PER_PUD; i++, addr = next) {
+		pud_t *pud, *tr_pud;
+
+		tr_pud = tr_pud_page + pud_index(addr);
+		pud = pud_page + pud_index((unsigned long)__va(addr));
+		next = (addr & PUD_MASK) + PUD_SIZE;
+
+		/* Needed to copy pte or pud alike */
+		BUILD_BUG_ON(sizeof(pud_t) != sizeof(pte_t));
+		*tr_pud = *pud;
+	}
+}
diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index 0b7a63d..705e3ff 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -8,6 +8,9 @@
 struct real_mode_header *real_mode_header;
 u32 *trampoline_cr4_features;
 
+/* Hold the pgd entry used on booting additional CPUs */
+pgd_t trampoline_pgd_entry;
+
 void __init reserve_real_mode(void)
 {
 	phys_addr_t mem;
@@ -84,7 +87,7 @@ void __init setup_real_mode(void)
 	*trampoline_cr4_features = __read_cr4();
 
 	trampoline_pgd = (u64 *) __va(real_mode_header->trampoline_pgd);
-	trampoline_pgd[0] = init_level4_pgt[pgd_index(__PAGE_OFFSET)].pgd;
+	trampoline_pgd[0] = trampoline_pgd_entry.pgd;
 	trampoline_pgd[511] = init_level4_pgt[511].pgd;
 #endif
 }
-- 
2.8.0.rc3.226.g39d4020
