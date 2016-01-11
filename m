Reply-To: kernel-hardening@lists.openwall.com
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 11 Jan 2016 14:19:11 +0100
Message-Id: <1452518355-4606-19-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1452518355-4606-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1452518355-4606-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v3 17/21] arm64: add support for a relocatable kernel and KASLR
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, linux-kernel@vger.kernel.org
Cc: stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, arnd@arndb.de, marc.zyngier@arm.com, christoffer.dall@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

This adds support for runtime relocation of the kernel Image, by
building it as a PIE (ET_DYN) executable and applying the dynamic
relocations in the early boot code.

On top of this, support for KASLR is implemented, based on entropy
provided by the bootloader in register x1 at kernel entry. Depending
on the size of the address space (VA_BITS) and the page size, the
entropy in the virtual displacement is up to 13 bits (16k/2 levels)
and up to 25 bits (all 4 levels), with the caveat that displacements
that result in the kernel image straddling a 1GB/32MB/512MB alignment
boundary (for 4KB/16KB/64KB granule kernels, respectively) are not
allowed.

The same virtual offset is applied to the module region: this gives
almost the same security benefits, and keeps the modules in close
proximity to the kernel so we only have to rely on branches via PLTs
once the module region is exhausted (which is slightly more likely
to occur, as the relocated module region is shared with other uses
of the vmalloc area)

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 Documentation/arm64/booting.txt     | 16 +++-
 arch/arm64/Kconfig                  | 26 ++++++
 arch/arm64/Makefile                 |  4 +
 arch/arm64/include/asm/elf_relocs.h |  2 +
 arch/arm64/include/asm/memory.h     |  3 +
 arch/arm64/kernel/head.S            | 94 +++++++++++++++++++-
 arch/arm64/kernel/module.c          |  3 +-
 arch/arm64/kernel/setup.c           | 38 ++++++--
 arch/arm64/kernel/vmlinux.lds.S     |  9 ++
 9 files changed, 180 insertions(+), 15 deletions(-)

diff --git a/Documentation/arm64/booting.txt b/Documentation/arm64/booting.txt
index 67484067ce4f..0bd5ea83a54f 100644
--- a/Documentation/arm64/booting.txt
+++ b/Documentation/arm64/booting.txt
@@ -115,13 +115,25 @@ Header notes:
 			    accessible
 			1 - 2MB aligned base may be anywhere in physical
 			    memory
-  Bits 4-63:	Reserved.
+  Bit 4:	Virtual address space layout randomization (KASLR)
+			0 - kernel will execute from a fixed virtual offset
+			    that is decided at compile time, register x1 should
+			    be zero at kernel entry
+			1 - kernel will execute from a virtual offset that is
+			    randomized based on the contents of register x1 at
+			    kernel entry
+  Bits 5-63:	Reserved.
 
 - When image_size is zero, a bootloader should attempt to keep as much
   memory as possible free for use by the kernel immediately after the
   end of the kernel image. The amount of space required will vary
   depending on selected features, and is effectively unbound.
 
+- It is up to the bootloader to decide whether a KASLR capable kernel should
+  boot with randomization enabled. If this is the case, register x1 should
+  contain a strong random value. If the bootloader passes 'nokaslr' on the
+  kernel command line to disable randomization, it must also pass 0 in x1.
+
 The Image must be placed text_offset bytes from a 2MB aligned base
 address anywhere in usable system RAM and called there. The region
 between the 2 MB aligned base address and the start of the image has no
@@ -145,7 +157,7 @@ Before jumping into the kernel, the following conditions must be met:
 
 - Primary CPU general-purpose register settings
   x0 = physical address of device tree blob (dtb) in system RAM.
-  x1 = 0 (reserved for future use)
+  x1 = 0, unless bit 4 is set in the Image header
   x2 = 0 (reserved for future use)
   x3 = 0 (reserved for future use)
 
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 778df20bf623..7fa5b74ee80d 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -711,6 +711,32 @@ config ARM64_MODULE_PLTS
 	select ARM64_MODULE_CMODEL_LARGE
 	select HAVE_MOD_ARCH_SPECIFIC
 
+config RELOCATABLE
+	bool
+	help
+	  This builds the kernel as a Position Independent Executable (PIE),
+	  which retains all relocation metadata required to relocate the
+	  kernel binary at runtime to a different virtual address than the
+	  address it was linked at.
+	  Since AArch64 uses the RELA relocation format, this requires a
+	  relocation pass at runtime even if the kernel is loaded at the
+	  same address it was linked at.
+
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
+	  random value in x1 at kernel entry.
+
+	  If unsure, say N.
+
+
 endmenu
 
 menu "Boot options"
diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index db462980c6be..c3eaa03f9020 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -15,6 +15,10 @@ CPPFLAGS_vmlinux.lds = -DTEXT_OFFSET=$(TEXT_OFFSET)
 OBJCOPYFLAGS	:=-O binary -R .note -R .note.gnu.build-id -R .comment -S
 GZFLAGS		:=-9
 
+ifneq ($(CONFIG_RELOCATABLE),)
+LDFLAGS_vmlinux		+= -pie
+endif
+
 KBUILD_DEFCONFIG := defconfig
 
 # Check for binutils support for specific extensions
diff --git a/arch/arm64/include/asm/elf_relocs.h b/arch/arm64/include/asm/elf_relocs.h
index 3f6b93099011..e1316de840a5 100644
--- a/arch/arm64/include/asm/elf_relocs.h
+++ b/arch/arm64/include/asm/elf_relocs.h
@@ -69,5 +69,7 @@
 #define R_AARCH64_MOVW_PREL_G2_NC	292
 #define R_AARCH64_MOVW_PREL_G3		293
 
+#define R_AARCH64_RELATIVE		1027
+
 #endif /* __ASM_ELF_RELOCS_H */
 
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index 758fb4a503ef..422a30a5f328 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -122,6 +122,9 @@ extern phys_addr_t		memstart_addr;
 /* PHYS_OFFSET - the physical address of the start of memory. */
 #define PHYS_OFFSET		({ memstart_addr; })
 
+/* the virtual base of the kernel image (minus TEXT_OFFSET) */
+extern u64			kimage_vaddr;
+
 /* the offset between the kernel virtual and physical mappings */
 extern u64			kimage_voffset;
 
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index d66aee595170..4bf6a5c9a24e 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -29,6 +29,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/cache.h>
 #include <asm/cputype.h>
+#include <asm/elf_relocs.h>
 #include <asm/kernel-pgtable.h>
 #include <asm/memory.h>
 #include <asm/pgtable-hwdef.h>
@@ -61,9 +62,16 @@
 
 #define __HEAD_FLAG_PAGE_SIZE	((PAGE_SHIFT - 10) / 2)
 
+#ifdef CONFIG_RANDOMIZE_BASE
+#define __HEAD_FLAG_KASLR	1
+#else
+#define __HEAD_FLAG_KASLR	0
+#endif
+
 #define __HEAD_FLAGS		((__HEAD_FLAG_BE << 0) |	\
 				 (__HEAD_FLAG_PAGE_SIZE << 1) |	\
-				 (__HEAD_FLAG_PHYS_BASE << 3))
+				 (__HEAD_FLAG_PHYS_BASE << 3) |	\
+				 (__HEAD_FLAG_KASLR << 4))
 
 /*
  * Kernel startup entry point.
@@ -234,6 +242,7 @@ ENTRY(stext)
 	 */
 	ldr	x27, 0f				// address to jump to after
 						// MMU has been enabled
+	add	x27, x27, x23			// add KASLR displacement
 	adr_l	lr, __enable_mmu		// return (PIC) address
 	b	__cpu_setup			// initialise processor
 ENDPROC(stext)
@@ -245,6 +254,7 @@ ENDPROC(stext)
  */
 preserve_boot_args:
 	mov	x21, x0				// x21=FDT
+	mov	x22, x1				// x22=random seed
 
 	adr_l	x0, boot_args			// record the contents of
 	stp	x21, x1, [x0]			// x0 .. x3 at kernel entry
@@ -328,6 +338,40 @@ __create_page_tables:
 	adrp	x26, swapper_pg_dir
 	mov	x27, lr
 
+#ifdef CONFIG_RANDOMIZE_BASE
+	/*
+	 * Mask off the bits of the random value stored in x22 so it can serve
+	 * as a KASLR displacement value which will move the kernel image to a
+	 * random offset in the lower half of the VMALLOC area (VA_BITS - 2).
+	 * Even if we could randomize at page granularity for 16k and 64k
+	 * granule kernels, let's always preserve the 2 MB (21 bit) alignment
+	 * and not interfere with the ability to use ranges of contiguous PTEs.
+	 */
+	.set	RANDOM_WIDTH, VA_BITS - 2
+	.set	RANDOM_ALIGN, 21
+
+	mov	x10, ((1 << (RANDOM_WIDTH - RANDOM_ALIGN)) - 1) << RANDOM_ALIGN
+	and	x23, x22, x10
+
+	/*
+	 * The kernel Image should not extend across a 1GB/32MB/512MB alignment
+	 * boundary (for 4KB/16KB/64KB granule kernels, respectively). If this
+	 * happens, increase the KASLR displacement in x23 by the size of the
+	 * kernel image.
+	 */
+	ldr	w8, kernel_img_size
+	mov	x11, KIMAGE_VADDR & ((1 << SWAPPER_TABLE_SHIFT) - 1)
+	add	x11, x11, x23
+	add	x9, x8, x11
+	eor	x9, x9, x11
+	tbz	x9, SWAPPER_TABLE_SHIFT, 0f
+	add	x23, x23, x8
+	and	x23, x23, x10
+0:
+#else
+	mov	x23, xzr
+#endif
+
 	/*
 	 * Invalidate the idmap and swapper page tables to avoid potential
 	 * dirty cache lines being evicted.
@@ -405,6 +449,7 @@ __create_page_tables:
 	 */
 	mov	x0, x26				// swapper_pg_dir
 	ldr	x5, =KIMAGE_VADDR
+	add	x5, x5, x23			// add KASLR displacement
 	create_pgd_entry x0, x5, x3, x6
 	ldr	w6, kernel_img_size
 	add	x6, x6, x5
@@ -446,13 +491,52 @@ __mmap_switched:
 	bl	__pi_memset
 
 	dsb	ishst				// Make zero page visible to PTW
+
+#ifdef CONFIG_RELOCATABLE
+
+	/*
+	 * Iterate over each entry in the relocation table, and apply the
+	 * relocations in place.
+	 */
+	adr_l	x8, __dynsym_start		// start of symbol table
+	adr_l	x9, __reloc_start		// start of reloc table
+	adr_l	x10, __reloc_end		// end of reloc table
+
+0:	cmp	x9, x10
+	b.hs	2f
+	ldp	x11, x12, [x9], #24
+	ldr	x13, [x9, #-8]
+	cmp	w12, #R_AARCH64_RELATIVE
+	b.ne	1f
+	add	x13, x13, x23			// relocate
+	str	x13, [x11, x23]
+	b	0b
+
+1:	cmp	w12, #R_AARCH64_ABS64
+	b.ne	0b
+	add	x12, x12, x12, lsl #1		// symtab offset: 24x top word
+	add	x12, x8, x12, lsr #(32 - 3)	// ... shifted into bottom word
+	ldrsh	w14, [x12, #6]			// Elf64_Sym::st_shndx
+	ldr	x15, [x12, #8]			// Elf64_Sym::st_value
+	cmp	w14, #-0xf			// SHN_ABS (0xfff1) ?
+	add	x14, x15, x23			// relocate
+	csel	x15, x14, x15, ne
+	add	x15, x13, x15
+	str	x15, [x11, x23]
+	b	0b
+
+2:	adr_l	x8, kimage_vaddr		// make relocated kimage_vaddr
+	dc	cvac, x8			// value visible to secondaries
+	dsb	sy				// with MMU off
+#endif
+
 	adr_l	sp, initial_sp, x4
 	mov	x4, sp
 	and	x4, x4, #~(THREAD_SIZE - 1)
 	msr	sp_el0, x4			// Save thread_info
 	str_l	x21, __fdt_pointer, x5		// Save FDT pointer
 
-	ldr	x0, =KIMAGE_VADDR		// Save the offset between
+	ldr_l	x0, kimage_vaddr		// Save the offset between
 	sub	x24, x0, x24			// the kernel virtual and
 	str_l	x24, kimage_voffset, x0		// physical mappings
 
@@ -468,6 +552,10 @@ ENDPROC(__mmap_switched)
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
@@ -628,7 +716,7 @@ ENTRY(secondary_startup)
 	adrp	x26, swapper_pg_dir
 	bl	__cpu_setup			// initialise processor
 
-	ldr	x8, =KIMAGE_VADDR
+	ldr	x8, kimage_vaddr
 	ldr	w9, 0f
 	sub	x27, x8, w9, sxtw		// address to jump to after enabling the MMU
 	b	__enable_mmu
diff --git a/arch/arm64/kernel/module.c b/arch/arm64/kernel/module.c
index 3a298b0e21bb..d38662028200 100644
--- a/arch/arm64/kernel/module.c
+++ b/arch/arm64/kernel/module.c
@@ -34,7 +34,8 @@ void *module_alloc(unsigned long size)
 {
 	void *p;
 
-	p = __vmalloc_node_range(size, MODULE_ALIGN, MODULES_VADDR, MODULES_END,
+	p = __vmalloc_node_range(size, MODULE_ALIGN,
+				kimage_vaddr - MODULES_VSIZE, kimage_vaddr,
 				GFP_KERNEL, PAGE_KERNEL_EXEC, 0,
 				NUMA_NO_NODE, __builtin_return_address(0));
 
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index c67ba4453ec6..f8111894447c 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -288,16 +288,41 @@ static inline void __init relocate_initrd(void)
 }
 #endif
 
+static bool nokaslr;
+static int __init early_nokaslr(char *p)
+{
+	nokaslr = true;
+	return 0;
+}
+early_param("nokaslr", early_nokaslr);
+
+static void check_boot_args(void)
+{
+	if ((!IS_ENABLED(CONFIG_RANDOMIZE_BASE) && boot_args[1]) ||
+	    boot_args[2] || boot_args[3]) {
+		pr_err("WARNING: x1-x3 nonzero in violation of boot protocol:\n"
+			"\tx1: %016llx\n\tx2: %016llx\n\tx3: %016llx\n"
+			"This indicates a broken bootloader or old kernel\n",
+			boot_args[1], boot_args[2], boot_args[3]);
+	}
+	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE) && boot_args[1] && nokaslr) {
+		pr_err("WARNING: found KASLR entropy in x1 but 'nokaslr' was passed on the commmand line:\n"
+			"\tx1: %016llx\n"
+			"This indicates a broken bootloader\n",
+			boot_args[1]);
+	}
+}
+
 u64 __cpu_logical_map[NR_CPUS] = { [0 ... NR_CPUS-1] = INVALID_HWID };
 
 void __init setup_arch(char **cmdline_p)
 {
 	static struct vm_struct vmlinux_vm;
 
-	vmlinux_vm.addr		= (void *)KIMAGE_VADDR;
-	vmlinux_vm.size		= round_up((u64)_end - KIMAGE_VADDR,
+	vmlinux_vm.addr		= (void *)kimage_vaddr;
+	vmlinux_vm.size		= round_up((u64)_end - kimage_vaddr,
 					   SWAPPER_BLOCK_SIZE);
-	vmlinux_vm.phys_addr	= __pa(KIMAGE_VADDR);
+	vmlinux_vm.phys_addr	= __pa(kimage_vaddr);
 	vmlinux_vm.flags	= VM_MAP;
 	vmlinux_vm.caller	= setup_arch;
 
@@ -366,12 +391,7 @@ void __init setup_arch(char **cmdline_p)
 	conswitchp = &dummy_con;
 #endif
 #endif
-	if (boot_args[1] || boot_args[2] || boot_args[3]) {
-		pr_err("WARNING: x1-x3 nonzero in violation of boot protocol:\n"
-			"\tx1: %016llx\n\tx2: %016llx\n\tx3: %016llx\n"
-			"This indicates a broken bootloader or old kernel\n",
-			boot_args[1], boot_args[2], boot_args[3]);
-	}
+	check_boot_args();
 }
 
 static int __init arm64_device_init(void)
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index ced0dedcabcc..eddd234d7721 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -148,6 +148,15 @@ SECTIONS
 	.altinstr_replacement : {
 		*(.altinstr_replacement)
 	}
+	.rela : ALIGN(8) {
+		__reloc_start = .;
+		*(.rela .rela*)
+		__reloc_end = .;
+	}
+	.dynsym : ALIGN(8) {
+		__dynsym_start = .;
+		*(.dynsym)
+	}
 
 	. = ALIGN(PAGE_SIZE);
 	__init_end = .;
-- 
2.5.0
