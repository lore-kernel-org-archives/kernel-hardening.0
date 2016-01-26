Reply-To: kernel-hardening@lists.openwall.com
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Tue, 26 Jan 2016 18:10:45 +0100
Message-Id: <1453828249-14467-19-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1453828249-14467-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1453828249-14467-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v4 18/22] arm64: add support for kernel ASLR
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, linux-kernel@vger.kernel.org
Cc: stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, arnd@arndb.de, marc.zyngier@arm.com, christoffer.dall@linaro.org, labbott@fedoraproject.org, matt@codeblueprint.co.uk, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

This adds support for KASLR is implemented, based on entropy provided by
the bootloader in the /chosen/kaslr-seed DT property. Depending on the size
of the address space (VA_BITS) and the page size, the entropy in the
virtual displacement is up to 13 bits (16k/2 levels) and up to 25 bits (all
4 levels), with the sidenote that displacements that result in the kernel
image straddling a 1GB/32MB/512MB alignment boundary (for 4KB/16KB/64KB
granule kernels, respectively) are not allowed, and will be rounded up to
an acceptable value.

The module region is randomized by choosing a page aligned 128 MB region
inside the interval [_etext - 128 MB, _stext + 128 MB). This gives between
10 and 14 bits of entropy (depending on page size), independently of the
kernel randomization, but still guarantees that modules are within the
range of relative branch and jump instructions (with the caveat that, since
the module region is shared with other uses of the vmalloc area, modules
may need to be loaded further away if the module region is exhausted)

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/Kconfig              |  14 ++
 arch/arm64/include/asm/memory.h |   5 +-
 arch/arm64/kernel/Makefile      |   1 +
 arch/arm64/kernel/head.S        |  59 ++++++-
 arch/arm64/kernel/kaslr.c       | 169 ++++++++++++++++++++
 arch/arm64/kernel/module.c      |   8 +-
 arch/arm64/kernel/setup.c       |  29 ++++
 arch/arm64/mm/mmu.c             |  33 ++--
 8 files changed, 298 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 6aa86f86fd10..d7e31454d421 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -774,6 +774,20 @@ config RELOCATABLE
 	  relocation pass at runtime even if the kernel is loaded at the
 	  same address it was linked at.
 
+config RANDOMIZE_BASE
+	bool "Randomize the address of the kernel image"
+	select ARM64_MODULE_PLTS
+	select RELOCATABLE
+	help
+	  Randomizes the virtual address at which the kernel image is
+	  loaded, as a security feature that deters exploit attempts
+	  relying on knowledge of the location of kernel internals.
+
+	  It is the bootloader's job to provide entropy, by passing a
+	  random u64 value in /chosen/kaslr-seed at kernel entry.
+
+	  If unsure, say N.
+
 endmenu
 
 menu "Boot options"
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index 61005e7dd6cb..083361531a61 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -52,7 +52,7 @@
 #define KIMAGE_VADDR		(MODULES_END)
 #define MODULES_END		(MODULES_VADDR + MODULES_VSIZE)
 #define MODULES_VADDR		(VA_START + KASAN_SHADOW_SIZE)
-#define MODULES_VSIZE		(SZ_64M)
+#define MODULES_VSIZE		(SZ_128M)
 #define PCI_IO_END		(PAGE_OFFSET - SZ_2M)
 #define PCI_IO_START		(PCI_IO_END - PCI_IO_SIZE)
 #define FIXADDR_TOP		(PCI_IO_START - SZ_2M)
@@ -127,6 +127,9 @@ extern phys_addr_t		memstart_addr;
 /* PHYS_OFFSET - the physical address of the start of memory. */
 #define PHYS_OFFSET		({ memstart_addr; })
 
+/* the virtual base of the kernel image (minus TEXT_OFFSET) */
+extern u64			kimage_vaddr;
+
 /* the offset between the kernel virtual and physical mappings */
 extern u64			kimage_voffset;
 
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index e2f0a755beaa..c9aaecddb941 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -43,6 +43,7 @@ arm64-obj-$(CONFIG_PCI)			+= pci.o
 arm64-obj-$(CONFIG_ARMV8_DEPRECATED)	+= armv8_deprecated.o
 arm64-obj-$(CONFIG_ACPI)		+= acpi.o
 arm64-obj-$(CONFIG_PARAVIRT)		+= paravirt.o
+arm64-obj-$(CONFIG_RANDOMIZE_BASE)	+= kaslr.o
 
 obj-y					+= $(arm64-obj-y) vdso/
 obj-m					+= $(arm64-obj-m)
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 92f9c26632f3..8712a38c3de7 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -210,6 +210,7 @@ section_table:
 ENTRY(stext)
 	bl	preserve_boot_args
 	bl	el2_setup			// Drop to EL1, w20=cpu_boot_mode
+	mov	x23, xzr			// KASLR offset, defaults to 0
 	adrp	x24, __PHYS_OFFSET
 	bl	set_cpu_boot_mode_flag
 	bl	__create_page_tables		// x25=TTBR0, x26=TTBR1
@@ -313,7 +314,7 @@ ENDPROC(preserve_boot_args)
 __create_page_tables:
 	adrp	x25, idmap_pg_dir
 	adrp	x26, swapper_pg_dir
-	mov	x27, lr
+	mov	x28, lr
 
 	/*
 	 * Invalidate the idmap and swapper page tables to avoid potential
@@ -392,6 +393,7 @@ __create_page_tables:
 	 */
 	mov	x0, x26				// swapper_pg_dir
 	ldr	x5, =KIMAGE_VADDR
+	add	x5, x5, x23			// add KASLR displacement
 	create_pgd_entry x0, x5, x3, x6
 	ldr	w6, kernel_img_size
 	add	x6, x6, x5
@@ -408,8 +410,7 @@ __create_page_tables:
 	dmb	sy
 	bl	__inval_cache_range
 
-	mov	lr, x27
-	ret
+	ret	x28
 ENDPROC(__create_page_tables)
 
 kernel_img_size:
@@ -421,6 +422,7 @@ kernel_img_size:
  */
 	.set	initial_sp, init_thread_union + THREAD_START_SP
 __mmap_switched:
+	mov	x28, lr				// preserve LR
 	adr_l	x8, vectors			// load VBAR_EL1 with virtual
 	msr	vbar_el1, x8			// vector table address
 	isb
@@ -449,19 +451,26 @@ __mmap_switched:
 	ldr	x13, [x9, #-8]
 	cmp	w12, #R_AARCH64_RELATIVE
 	b.ne	1f
-	str	x13, [x11]
+	add	x13, x13, x23			// relocate
+	str	x13, [x11, x23]
 	b	0b
 
 1:	cmp	w12, #R_AARCH64_ABS64
 	b.ne	0b
 	add	x12, x12, x12, lsl #1		// symtab offset: 24x top word
 	add	x12, x8, x12, lsr #(32 - 3)	// ... shifted into bottom word
+	ldrsh	w14, [x12, #6]			// Elf64_Sym::st_shndx
 	ldr	x15, [x12, #8]			// Elf64_Sym::st_value
+	cmp	w14, #-0xf			// SHN_ABS (0xfff1) ?
+	add	x14, x15, x23			// relocate
+	csel	x15, x14, x15, ne
 	add	x15, x13, x15
-	str	x15, [x11]
+	str	x15, [x11, x23]
 	b	0b
 
-2:
+2:	adr_l	x8, kimage_vaddr		// make relocated kimage_vaddr
+	dc	cvac, x8			// value visible to secondaries
+	dsb	sy				// with MMU off
 #endif
 
 	adr_l	sp, initial_sp, x4
@@ -470,7 +479,7 @@ __mmap_switched:
 	msr	sp_el0, x4			// Save thread_info
 	str_l	x21, __fdt_pointer, x5		// Save FDT pointer
 
-	ldr	x4, =KIMAGE_VADDR		// Save the offset between
+	ldr_l	x4, kimage_vaddr		// Save the offset between
 	sub	x4, x4, x24			// the kernel virtual and
 	str_l	x4, kimage_voffset, x5		// physical mappings
 
@@ -478,6 +487,15 @@ __mmap_switched:
 #ifdef CONFIG_KASAN
 	bl	kasan_early_init
 #endif
+#ifdef CONFIG_RANDOMIZE_BASE
+	cbnz	x23, 0f				// already running randomized?
+	mov	x0, x21				// pass FDT address in x0
+	bl	kaslr_early_init		// parse FDT for KASLR options
+	cbz	x0, 0f				// KASLR disabled? just proceed
+	ret	x28				// we must enable KASLR, return
+						// to __enable_mmu()
+0:
+#endif
 	b	start_kernel
 ENDPROC(__mmap_switched)
 
@@ -486,6 +504,10 @@ ENDPROC(__mmap_switched)
  * hotplug and needs to have the same protections as the text region
  */
 	.section ".text","ax"
+
+ENTRY(kimage_vaddr)
+	.quad		_text - TEXT_OFFSET
+
 /*
  * If we're fortunate enough to boot at EL2, ensure that the world is
  * sane before dropping to EL1.
@@ -646,7 +668,7 @@ ENTRY(secondary_startup)
 	adrp	x26, swapper_pg_dir
 	bl	__cpu_setup			// initialise processor
 
-	ldr	x8, =KIMAGE_VADDR
+	ldr	x8, kimage_vaddr
 	ldr	w9, 0f
 	sub	x27, x8, w9, sxtw		// address to jump to after enabling the MMU
 	b	__enable_mmu
@@ -679,6 +701,7 @@ ENDPROC(__secondary_switched)
  */
 	.section	".idmap.text", "ax"
 __enable_mmu:
+	mrs	x18, sctlr_el1			// preserve old SCTLR_EL1 value
 	mrs	x1, ID_AA64MMFR0_EL1
 	ubfx	x2, x1, #ID_AA64MMFR0_TGRAN_SHIFT, 4
 	cmp	x2, #ID_AA64MMFR0_TGRAN_SUPPORTED
@@ -696,6 +719,26 @@ __enable_mmu:
 	ic	iallu
 	dsb	nsh
 	isb
+#ifdef CONFIG_RANDOMIZE_BASE
+	mov	x19, x0				// preserve new SCTLR_EL1 value
+	blr	x27
+
+	/*
+	 * If we return here, we have a KASLR displacement in x0 which we need
+	 * to record and take into account by discarding the current kernel
+	 * mapping and creating a new one.
+	 */
+	mov	x23, x0				// record the KASLR offset
+	msr	sctlr_el1, x18			// disable the MMU
+	isb
+	bl	__create_page_tables		// recreate kernel mapping
+
+	msr	sctlr_el1, x19			// re-enable the MMU
+	isb
+	ic	ialluis				// flush instructions fetched
+	isb					// via old mapping
+	add	x27, x27, x23			// relocated __mmap_switched
+#endif
 	br	x27
 ENDPROC(__enable_mmu)
 
diff --git a/arch/arm64/kernel/kaslr.c b/arch/arm64/kernel/kaslr.c
new file mode 100644
index 000000000000..9ddb01f65a1a
--- /dev/null
+++ b/arch/arm64/kernel/kaslr.c
@@ -0,0 +1,169 @@
+/*
+ * Copyright (C) 2016 Linaro Ltd <ard.biesheuvel@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/crc32.h>
+#include <linux/init.h>
+#include <linux/libfdt.h>
+#include <linux/mm_types.h>
+#include <linux/sched.h>
+#include <linux/types.h>
+
+#include <asm/fixmap.h>
+#include <asm/kernel-pgtable.h>
+#include <asm/memory.h>
+#include <asm/mmu.h>
+#include <asm/pgtable.h>
+#include <asm/sections.h>
+
+u32 module_load_offset;
+
+static __init u64 get_kaslr_seed(void *fdt)
+{
+	int node, len;
+	u64 *prop;
+	u64 ret;
+
+	node = fdt_path_offset(fdt, "/chosen");
+	if (node < 0)
+		return 0;
+
+	prop = fdt_getprop_w(fdt, node, "kaslr-seed", &len);
+	if (!prop || len != sizeof(u64))
+		return 0;
+
+	ret = fdt64_to_cpu(*prop);
+	*prop = 0;
+	return ret;
+}
+
+static __init const u8 *get_cmdline(void *fdt)
+{
+	static const u8 default_cmdline[] = CONFIG_CMDLINE;
+
+	if (!IS_ENABLED(CONFIG_CMDLINE_FORCE)) {
+		int node;
+		const u8 *prop;
+
+		node = fdt_path_offset(fdt, "/chosen");
+		if (node < 0)
+			goto out;
+
+		prop = fdt_getprop(fdt, node, "bootargs", NULL);
+		if (!prop)
+			goto out;
+		return prop;
+	}
+out:
+	return default_cmdline;
+}
+
+static u32 get_kernel_crc(void)
+{
+	u64 stack_start = (u64)&init_thread_union.stack;
+	u64 stack_end = stack_start + sizeof(init_thread_union.stack);
+	u32 crc;
+
+	crc = crc32_le(~0, _text, stack_start - (u64)_text);
+	crc = crc32_le(crc, (void *)stack_end, (u64)_edata - stack_end);
+
+	return crc;
+}
+
+extern void *__init __fixmap_remap_fdt(phys_addr_t dt_phys, int *size,
+				       pgprot_t prot);
+
+/*
+ * This routine will be executed with the kernel mapped at its default virtual
+ * address, and if it returns successfully, the kernel will be remapped, and
+ * start_kernel() will be executed from a randomized virtual offset. The
+ * relocation will result in all absolute references (e.g., static variables
+ * containing function pointers) to be reinitialized, and zero-initialized
+ * .bss variables will be reset to 0. However, other .data manipulations will
+ * persist across the change from the default mapping to the randomized mapping,
+ * and thus should not be performed before we have moved the kernel to its final
+ * address. This will be caught by the CRC check, and KASLR will be disabled if
+ * we catch any inadvertent modifications.
+ */
+u64 __init kaslr_early_init(u64 dt_phys)
+{
+	void *fdt;
+	u64 seed, offset, mask, module_range;
+	const u8 *cmdline, *str;
+	int size;
+	u32 crc;
+
+	/*
+	 * Record the CRC of the entire [_text, _edata] interval, except the
+	 * region we are using for the stack. If we detect any changes made
+	 * during the course of this function, we bail. This may seem a bit
+	 * drastic, but in this case , we have no way of guaranteeing we won't
+	 * corrupt anything by moving the kernel image before reentering it.
+	 */
+	crc = get_kernel_crc();
+
+	/*
+	 * Try to map the FDT early. If this fails, we simply bail,
+	 * and proceed with KASLR disabled. We will make another
+	 * attempt at mapping the FDT in setup_machine()
+	 */
+	early_fixmap_init();
+	fdt = __fixmap_remap_fdt(dt_phys, &size, PAGE_KERNEL);
+	if (!fdt)
+		return 0;
+
+	/*
+	 * Retrieve (and wipe) the seed from the FDT
+	 */
+	seed = get_kaslr_seed(fdt);
+	if (!seed)
+		return 0;
+
+	/*
+	 * Check if 'nokaslr' appears on the command line, and
+	 * return 0 if that is the case.
+	 */
+	cmdline = get_cmdline(fdt);
+	str = strstr(cmdline, "nokaslr");
+	if (str == cmdline || (str > cmdline && *(str - 1) == ' '))
+		return 0;
+
+	/* check if we made any inadvertent changes to the kernel text */
+	if (crc != get_kernel_crc())
+		return 0;
+
+	/*
+	 * OK, so we are proceeding with KASLR enabled. Calculate a suitable
+	 * kernel image offset from the seed. Let's place the kernel in the
+	 * lower half of the VMALLOC area (VA_BITS - 2).
+	 * Even if we could randomize at page granularity for 16k and 64k pages,
+	 * let's always round to 2 MB so we don't interfere with the ability to
+	 * map using contiguous PTEs
+	 */
+	mask = ((1UL << (VA_BITS - 2)) - 1) & ~(SZ_2M - 1);
+	offset = seed & mask;
+
+	/*
+	 * The kernel Image should not extend across a 1GB/32MB/512MB alignment
+	 * boundary (for 4KB/16KB/64KB granule kernels, respectively). If this
+	 * happens, increase the KASLR offset by the size of the kernel image.
+	 */
+	if ((((u64)_text + offset) >> SWAPPER_TABLE_SHIFT) !=
+	    (((u64)_end + offset) >> SWAPPER_TABLE_SHIFT))
+		offset = (offset + (u64)(_end - _text)) & mask;
+
+	/*
+	 * Randomize the module region, by setting module_load_offset to
+	 * a PAGE_SIZE multiple in the interval [0, module_range). This
+	 * ensures that the resulting region still covers [_stext, _etext],
+	 * and that all relative branches can be resolved without veneers.
+	 */
+	module_range = MODULES_VSIZE - (u64)(_etext - _stext);
+	module_load_offset = ((module_range * (u16)seed) >> 16) & PAGE_MASK;
+
+	return offset;
+}
diff --git a/arch/arm64/kernel/module.c b/arch/arm64/kernel/module.c
index 84113d3e1df1..54702d456680 100644
--- a/arch/arm64/kernel/module.c
+++ b/arch/arm64/kernel/module.c
@@ -33,8 +33,14 @@
 void *module_alloc(unsigned long size)
 {
 	void *p;
+	u64 base = (u64)_etext - MODULES_VSIZE;
 
-	p = __vmalloc_node_range(size, MODULE_ALIGN, MODULES_VADDR, MODULES_END,
+	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE)) {
+		extern u32 module_load_offset;
+		base += module_load_offset;
+	}
+
+	p = __vmalloc_node_range(size, MODULE_ALIGN, base, base + MODULES_VSIZE,
 				GFP_KERNEL, PAGE_KERNEL_EXEC, 0,
 				NUMA_NO_NODE, __builtin_return_address(0));
 
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index cfed56f0ad26..42371f69def3 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -388,3 +388,32 @@ static int __init topology_init(void)
 	return 0;
 }
 subsys_initcall(topology_init);
+
+/*
+ * Dump out kernel offset information on panic.
+ */
+static int dump_kernel_offset(struct notifier_block *self, unsigned long v,
+			      void *p)
+{
+	u64 const kaslr_offset = kimage_vaddr - KIMAGE_VADDR;
+
+	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE) && kaslr_offset > 0) {
+		pr_emerg("Kernel Offset: 0x%llx from 0x%lx\n",
+			 kaslr_offset, KIMAGE_VADDR);
+	} else {
+		pr_emerg("Kernel Offset: disabled\n");
+	}
+	return 0;
+}
+
+static struct notifier_block kernel_offset_notifier = {
+	.notifier_call = dump_kernel_offset
+};
+
+static int __init register_kernel_offset_dumper(void)
+{
+	atomic_notifier_chain_register(&panic_notifier_list,
+				       &kernel_offset_notifier);
+	return 0;
+}
+__initcall(register_kernel_offset_dumper);
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 8dda38378959..5d7e0b801ab7 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -636,7 +636,8 @@ void __init early_fixmap_init(void)
 	unsigned long addr = FIXADDR_START;
 
 	pgd = pgd_offset_k(addr);
-	if (CONFIG_PGTABLE_LEVELS > 3 && !pgd_none(*pgd)) {
+	if (CONFIG_PGTABLE_LEVELS > 3 &&
+	    !(pgd_none(*pgd) || pgd_page_paddr(*pgd) == __pa(bm_pud))) {
 		/*
 		 * We only end up here if the kernel mapping and the fixmap
 		 * share the top level pgd entry, which should only happen on
@@ -693,11 +694,10 @@ void __set_fixmap(enum fixed_addresses idx,
 	}
 }
 
-void *__init fixmap_remap_fdt(phys_addr_t dt_phys)
+void *__init __fixmap_remap_fdt(phys_addr_t dt_phys, int *size, pgprot_t prot)
 {
 	const u64 dt_virt_base = __fix_to_virt(FIX_FDT);
-	pgprot_t prot = PAGE_KERNEL_RO;
-	int size, offset;
+	int offset;
 	void *dt_virt;
 
 	/*
@@ -736,16 +736,29 @@ void *__init fixmap_remap_fdt(phys_addr_t dt_phys)
 	if (fdt_check_header(dt_virt) != 0)
 		return NULL;
 
-	size = fdt_totalsize(dt_virt);
-	if (size > MAX_FDT_SIZE)
+	*size = fdt_totalsize(dt_virt);
+	if (*size > MAX_FDT_SIZE)
 		return NULL;
 
-	if (offset + size > SWAPPER_BLOCK_SIZE)
-		create_mapping(round_down(dt_phys, SWAPPER_BLOCK_SIZE), dt_virt_base,
-			       round_up(offset + size, SWAPPER_BLOCK_SIZE), prot);
+	if (offset + *size > SWAPPER_BLOCK_SIZE)
+		create_mapping(round_down(dt_phys, SWAPPER_BLOCK_SIZE),
+			       dt_virt_base,
+			       round_up(offset + *size, SWAPPER_BLOCK_SIZE),
+			       prot);
 
-	memblock_reserve(dt_phys, size);
+	return dt_virt;
+}
 
+void *__init fixmap_remap_fdt(phys_addr_t dt_phys)
+{
+	void *dt_virt;
+	int size;
+
+	dt_virt = __fixmap_remap_fdt(dt_phys, &size, PAGE_KERNEL_RO);
+	if (!dt_virt)
+		return NULL;
+
+	memblock_reserve(dt_phys, size);
 	return dt_virt;
 }
 
-- 
2.5.0
