Reply-To: kernel-hardening@lists.openwall.com
From: Thomas Garnier <thgarnie@google.com>
Date: Wed,  4 Jan 2017 14:16:30 -0800
Message-Id: <20170104221630.831-1-thgarnie@google.com>
Subject: [kernel-hardening] [RFC] x86/mm/KASLR: Remap GDTs at fixed location
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Thomas Garnier <thgarnie@google.com>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave@sr71.net>, Chen Yucong <slaoub@gmail.com>, Arjan van de Ven <arjan@linux.intel.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Anna-Maria Gleixner <anna-maria@linutronix.de>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Michael Ellerman <mpe@ellerman.id.au>, Juergen Gross <jgross@suse.com>, Richard Weinberger <richard@nod.at>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Each processor holds a GDT in its per-cpu structure. The sgdt
instruction gives the base address of the current GDT. This address can
be used to bypass KASLR memory randomization. With another bug, an
attacker could target other per-cpu structures or deduce the base of the
main memory section (PAGE_OFFSET).

In this change, a space is reserved at the end of the memory range
available for KASLR memory randomization. The space is big enough to hold
the maximum number of CPUs (as defined by setup_max_cpus). Each GDT is
mapped at specific offset based on the target CPU. Note that if there is
not enough space available, the GDTs are not remapped.

The document was changed to mention GDT remapping for KASLR. This patch
also include dump page tables support.

This patch was tested on multiple hardware configurations and for
hibernation support.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
Based on next-20170104
---
 arch/x86/include/asm/kaslr.h  |   4 ++
 arch/x86/kernel/cpu/common.c  |   7 ++-
 arch/x86/mm/dump_pagetables.c |  10 ++++
 arch/x86/mm/kaslr.c           | 107 +++++++++++++++++++++++++++++++++++++++++-
 kernel/cpu.c                  |   3 ++
 kernel/smp.c                  |   1 +
 6 files changed, 130 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kaslr.h b/arch/x86/include/asm/kaslr.h
index 1052a797d71d..babc32803182 100644
--- a/arch/x86/include/asm/kaslr.h
+++ b/arch/x86/include/asm/kaslr.h
@@ -9,8 +9,12 @@ extern unsigned long vmalloc_base;
 extern unsigned long vmemmap_base;
 
 void kernel_randomize_memory(void);
+void kernel_randomize_smp(void);
+void* kaslr_get_gdt_remap(int cpu);
 #else
 static inline void kernel_randomize_memory(void) { }
+static inline void kernel_randomize_smp(void) { }
+static inline void *kaslr_get_gdt_remap(int cpu) { return NULL; }
 #endif /* CONFIG_RANDOMIZE_MEMORY */
 
 #endif
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index dc1697ca5191..2c8a7b4718ea 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -450,8 +450,13 @@ void load_percpu_segment(int cpu)
 void switch_to_new_gdt(int cpu)
 {
 	struct desc_ptr gdt_descr;
+	struct desc_struct *gdt;
 
-	gdt_descr.address = (long)get_cpu_gdt_table(cpu);
+	gdt = kaslr_get_gdt_remap(cpu);
+	if (!gdt)
+		gdt = get_cpu_gdt_table(cpu);
+
+	gdt_descr.address = (long)gdt;
 	gdt_descr.size = GDT_SIZE - 1;
 	load_gdt(&gdt_descr);
 	/* Reload the per-cpu base */
diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index ea9c49adaa1f..213fe01f28dc 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -50,6 +50,9 @@ enum address_markers_idx {
 	LOW_KERNEL_NR,
 	VMALLOC_START_NR,
 	VMEMMAP_START_NR,
+# ifdef CONFIG_RANDOMIZE_MEMORY
+	GDT_REMAP_NR,
+# endif
 # ifdef CONFIG_X86_ESPFIX64
 	ESPFIX_START_NR,
 # endif
@@ -75,6 +78,9 @@ static struct addr_marker address_markers[] = {
 	{ 0/* PAGE_OFFSET */,   "Low Kernel Mapping" },
 	{ 0/* VMALLOC_START */, "vmalloc() Area" },
 	{ 0/* VMEMMAP_START */, "Vmemmap" },
+# ifdef CONFIG_RANDOMIZE_MEMORY
+	{ 0, "GDT remapping" },
+# endif
 # ifdef CONFIG_X86_ESPFIX64
 	{ ESPFIX_BASE_ADDR,	"ESPfix Area", 16 },
 # endif
@@ -442,6 +448,10 @@ static int __init pt_dump_init(void)
 	address_markers[LOW_KERNEL_NR].start_address = PAGE_OFFSET;
 	address_markers[VMALLOC_START_NR].start_address = VMALLOC_START;
 	address_markers[VMEMMAP_START_NR].start_address = VMEMMAP_START;
+#ifdef CONFIG_RANDOMIZE_MEMORY
+	address_markers[GDT_REMAP_NR].start_address =
+		(unsigned long) kaslr_get_gdt_remap(0);
+#endif
 #endif
 #ifdef CONFIG_X86_32
 	address_markers[VMALLOC_START_NR].start_address = VMALLOC_START;
diff --git a/arch/x86/mm/kaslr.c b/arch/x86/mm/kaslr.c
index 887e57182716..db1bdb75f8af 100644
--- a/arch/x86/mm/kaslr.c
+++ b/arch/x86/mm/kaslr.c
@@ -22,11 +22,13 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/random.h>
+#include <linux/slab.h>
 
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
 #include <asm/setup.h>
 #include <asm/kaslr.h>
+#include <asm/desc.h>
 
 #include "mm_internal.h"
 
@@ -60,6 +62,7 @@ unsigned long vmalloc_base = __VMALLOC_BASE;
 EXPORT_SYMBOL(vmalloc_base);
 unsigned long vmemmap_base = __VMEMMAP_BASE;
 EXPORT_SYMBOL(vmemmap_base);
+unsigned long gdt_tables_base = 0;
 
 /*
  * Memory regions randomized by KASLR (except modules that use a separate logic
@@ -97,7 +100,7 @@ void __init kernel_randomize_memory(void)
 	unsigned long vaddr = vaddr_start;
 	unsigned long rand, memory_tb;
 	struct rnd_state rand_state;
-	unsigned long remain_entropy;
+	unsigned long remain_entropy, gdt_reserved;
 
 	/*
 	 * All these BUILD_BUG_ON checks ensures the memory layout is
@@ -131,6 +134,13 @@ void __init kernel_randomize_memory(void)
 	for (i = 0; i < ARRAY_SIZE(kaslr_regions); i++)
 		remain_entropy -= get_padding(&kaslr_regions[i]);
 
+	/* Reserve space for fixed GDTs, if we have enough available */
+	gdt_reserved = sizeof(struct gdt_page) * max(setup_max_cpus, 1U);
+	if (gdt_reserved < remain_entropy) {
+		gdt_tables_base = vaddr_end - gdt_reserved;
+		remain_entropy -= gdt_reserved;
+	}
+
 	prandom_seed_state(&rand_state, kaslr_get_random_long("Memory"));
 
 	for (i = 0; i < ARRAY_SIZE(kaslr_regions); i++) {
@@ -192,3 +202,98 @@ void __meminit init_trampoline(void)
 	set_pgd(&trampoline_pgd_entry,
 		__pgd(_KERNPG_TABLE | __pa(pud_page_tramp)));
 }
+
+/* Hold the remapping of the gdt page for each cpu */
+DEFINE_PER_CPU_PAGE_ALIGNED(struct desc_struct *, gdt_remap);
+
+/* Return the address where the GDT is remapped for this CPU */
+static unsigned long gdt_remap_address(int cpu)
+{
+	return gdt_tables_base + cpu * sizeof(struct gdt_page);
+}
+
+/* Remap the specified gdt table */
+static struct desc_struct *remap_gdt(int cpu)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+	struct desc_struct *gdt;
+	unsigned long addr;
+
+	/* GDT table should be only one page */
+	BUILD_BUG_ON(sizeof(struct gdt_page) != PAGE_SIZE);
+
+	/* Keep the original GDT before the allocator is available */
+	if (!slab_is_available())
+		return NULL;
+
+	gdt = get_cpu_gdt_table(cpu);
+	addr = gdt_remap_address(cpu);
+
+	pgd = pgd_offset_k(addr);
+	pud = pud_alloc(&init_mm, pgd, addr);
+	if (WARN_ON(!pud))
+		return NULL;
+	pmd = pmd_alloc(&init_mm, pud, addr);
+	if (WARN_ON(!pmd))
+		return NULL;
+	pte = pte_alloc_kernel(pmd, addr);
+	if (WARN_ON(!pte))
+		return NULL;
+
+	/* If the PTE is already set, something is wrong with the VA ranges */
+	BUG_ON(!pte_none(*pte));
+
+	/* Remap the target GDT and return it */
+	set_pte_at(&init_mm, addr, pte,
+		   pfn_pte(PFN_DOWN(__pa(gdt)), PAGE_KERNEL));
+	gdt = (struct desc_struct *)addr;
+	per_cpu(gdt_remap, cpu) = gdt;
+	return gdt;
+}
+
+/* Check if GDT remapping is enabled */
+static bool kaslr_gdt_remap_enabled(void)
+{
+	return kaslr_memory_enabled() && gdt_tables_base != 0;
+}
+
+/*
+ * The GDT table address is available to user-mode through the sgdt
+ * instruction. This function will return a fixed remapping to load so you
+ * cannot leak the per-cpu structure address.
+ */
+void* kaslr_get_gdt_remap(int cpu)
+{
+	struct desc_struct *gdt_remapping;
+
+	if (!kaslr_gdt_remap_enabled())
+		return NULL;
+
+	gdt_remapping = per_cpu(gdt_remap, cpu);
+	if (!gdt_remapping)
+		gdt_remapping = remap_gdt(cpu);
+
+	return gdt_remapping;
+}
+
+/*
+ * Switch the first processor GDT to the remapping. The GDT is loaded too early
+ * to generate the remapping correctly. This step is done later at boot or
+ * before other processors come back from hibernation.
+ */
+void kernel_randomize_smp(void)
+{
+	struct desc_ptr gdt_descr;
+	struct desc_struct *gdt;
+
+	gdt = kaslr_get_gdt_remap(raw_smp_processor_id());
+	if (WARN_ON(!gdt))
+		return;
+
+	gdt_descr.address = (long)gdt;
+	gdt_descr.size = GDT_SIZE - 1;
+	load_gdt(&gdt_descr);
+}
diff --git a/kernel/cpu.c b/kernel/cpu.c
index f75c4d031eeb..4d6979299b9a 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -1040,6 +1040,9 @@ void enable_nonboot_cpus(void)
 {
 	int cpu, error;
 
+	/* Redo KASLR steps for main processor */
+	kernel_randomize_smp();
+
 	/* Allow everyone to use the CPU hotplug again */
 	cpu_maps_update_begin();
 	__cpu_hotplug_enable();
diff --git a/kernel/smp.c b/kernel/smp.c
index 77fcdb9f2775..e1ef8d05e179 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -554,6 +554,7 @@ void __init smp_init(void)
 
 	idle_threads_init();
 	cpuhp_threads_init();
+	kernel_randomize_smp();
 
 	pr_info("Bringing up secondary CPUs ...\n");
 
-- 
2.11.0.390.gc69c2f50cf-goog
