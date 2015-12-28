Reply-To: kernel-hardening@lists.openwall.com
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 28 Dec 2015 12:20:53 +0100
Message-Id: <1451301654-32019-10-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1451301654-32019-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1451301654-32019-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [RFC PATCH 09/10] arm64: add support for relocatable kernel
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, lkml@vger.kernel.org
Cc: stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

This adds support for runtime relocation of the kernel Image, by
building it as a PIE (ET_DYN) executable and applying the dynamic
relocations in the early boot code.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 Documentation/arm64/booting.txt |  3 +-
 arch/arm64/Kconfig              | 13 ++++
 arch/arm64/Makefile             |  6 +-
 arch/arm64/include/asm/memory.h | 10 ++-
 arch/arm64/kernel/arm64ksyms.c  |  5 ++
 arch/arm64/kernel/head.S        | 76 +++++++++++++++++++-
 arch/arm64/kernel/setup.c       | 22 +++---
 arch/arm64/kernel/vmlinux.lds.S |  9 +++
 scripts/sortextable.c           |  4 +-
 9 files changed, 130 insertions(+), 18 deletions(-)

diff --git a/Documentation/arm64/booting.txt b/Documentation/arm64/booting.txt
index 701d39d3171a..dcd8eee72984 100644
--- a/Documentation/arm64/booting.txt
+++ b/Documentation/arm64/booting.txt
@@ -109,7 +109,8 @@ Header notes:
 			1 - 4K
 			2 - 16K
 			3 - 64K
-  Bits 3-63:	Reserved.
+  Bit 3:	Relocatable kernel.
+  Bits 4-63:	Reserved.
 
 - When image_size is zero, a bootloader should attempt to keep as much
   memory as possible free for use by the kernel immediately after the
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 54eeab140bca..f458fb9e0dce 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -363,6 +363,7 @@ config ARM64_ERRATUM_843419
 	bool "Cortex-A53: 843419: A load or store might access an incorrect address"
 	depends on MODULES
 	default y
+	select ARM64_MODULE_CMODEL_LARGE
 	help
 	  This option builds kernel modules using the large memory model in
 	  order to avoid the use of the ADRP instruction, which can cause
@@ -709,6 +710,18 @@ config ARM64_MODULE_PLTS
 	bool
 	select HAVE_MOD_ARCH_SPECIFIC
 
+config ARM64_MODULE_CMODEL_LARGE
+	bool
+
+config ARM64_RELOCATABLE_KERNEL
+	bool "Kernel address space layout randomization (KASLR)"
+	select ARM64_MODULE_PLTS
+	select ARM64_MODULE_CMODEL_LARGE
+	help
+	  This feature randomizes the virtual address of the kernel image, to
+	  harden against exploits that rely on knowledge about the absolute
+	  addresses of certain kernel data structures.
+
 endmenu
 
 menu "Boot options"
diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index d4654830e536..75dc477d45f5 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -15,6 +15,10 @@ CPPFLAGS_vmlinux.lds = -DTEXT_OFFSET=$(TEXT_OFFSET)
 OBJCOPYFLAGS	:=-O binary -R .note -R .note.gnu.build-id -R .comment -S
 GZFLAGS		:=-9
 
+ifneq ($(CONFIG_ARM64_RELOCATABLE_KERNEL),)
+LDFLAGS_vmlinux		+= -pie
+endif
+
 KBUILD_DEFCONFIG := defconfig
 
 # Check for binutils support for specific extensions
@@ -41,7 +45,7 @@ endif
 
 CHECKFLAGS	+= -D__aarch64__
 
-ifeq ($(CONFIG_ARM64_ERRATUM_843419), y)
+ifeq ($(CONFIG_ARM64_MODULE_CMODEL_LARGE), y)
 KBUILD_CFLAGS_MODULE	+= -mcmodel=large
 endif
 
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index 1dcbf142d36c..e435423f9731 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -88,10 +88,10 @@
 #define __virt_to_phys(x) ({						\
 	phys_addr_t __x = (phys_addr_t)(x);				\
 	__x >= PAGE_OFFSET ? (__x - PAGE_OFFSET + PHYS_OFFSET) :	\
-			     (__x - KIMAGE_VADDR + PHYS_OFFSET); })
+			     (__x - kimage_vaddr + PHYS_OFFSET); })
 
 #define __phys_to_virt(x)	((unsigned long)((x) - PHYS_OFFSET + PAGE_OFFSET))
-#define __phys_to_kimg(x)	((unsigned long)((x) - PHYS_OFFSET + KIMAGE_VADDR))
+#define __phys_to_kimg(x)	((unsigned long)((x) - PHYS_OFFSET + kimage_vaddr))
 
 /*
  * Convert a page to/from a physical address
@@ -121,6 +121,12 @@ extern phys_addr_t		memstart_addr;
 /* PHYS_OFFSET - the physical address of the start of memory. */
 #define PHYS_OFFSET		({ memstart_addr; })
 
+#ifdef CONFIG_ARM64_RELOCATABLE_KERNEL
+extern u64			kimage_vaddr;
+#else
+#define kimage_vaddr		KIMAGE_VADDR
+#endif
+
 /*
  * The maximum physical address that the linear direct mapping
  * of system RAM can cover. (PAGE_OFFSET can be interpreted as
diff --git a/arch/arm64/kernel/arm64ksyms.c b/arch/arm64/kernel/arm64ksyms.c
index 3b6d8cc9dfe0..4f7b7f44e2b5 100644
--- a/arch/arm64/kernel/arm64ksyms.c
+++ b/arch/arm64/kernel/arm64ksyms.c
@@ -41,6 +41,11 @@ EXPORT_SYMBOL(__copy_in_user);
 	/* physical memory */
 EXPORT_SYMBOL(memstart_addr);
 
+#ifdef CONFIG_ARM64_RELOCATABLE_KERNEL
+	/* runtime kernel virtual base address */
+EXPORT_SYMBOL(kimage_vaddr);
+#endif
+
 	/* string / mem functions */
 EXPORT_SYMBOL(strchr);
 EXPORT_SYMBOL(strrchr);
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 4f086e247eea..5ec779412436 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -59,8 +59,15 @@
 
 #define __HEAD_FLAG_PAGE_SIZE ((PAGE_SHIFT - 10) / 2)
 
+#ifdef CONFIG_ARM64_RELOCATABLE_KERNEL
+#define __HEAD_FLAG_RELOC	1
+#else
+#define __HEAD_FLAG_RELOC	0
+#endif
+
 #define __HEAD_FLAGS	((__HEAD_FLAG_BE << 0) |	\
-			 (__HEAD_FLAG_PAGE_SIZE << 1))
+			 (__HEAD_FLAG_PAGE_SIZE << 1) |	\
+			 (__HEAD_FLAG_RELOC << 3))
 
 /*
  * Kernel startup entry point.
@@ -229,6 +236,9 @@ ENTRY(stext)
 	 */
 	ldr	x27, 0f				// address to jump to after
 						// MMU has been enabled
+#ifdef CONFIG_ARM64_RELOCATABLE_KERNEL
+	add	x27, x27, x23			// add KASLR displacement
+#endif
 	adr_l	lr, __enable_mmu		// return (PIC) address
 	b	__cpu_setup			// initialise processor
 ENDPROC(stext)
@@ -241,6 +251,16 @@ ENDPROC(stext)
 preserve_boot_args:
 	mov	x21, x0				// x21=FDT
 
+#ifdef CONFIG_ARM64_RELOCATABLE_KERNEL
+	/*
+	 * Mask off the bits of the random value supplied in x1 so it can serve
+	 * as a KASLR displacement value which will move the kernel image to a
+	 * random offset in the lower half of the VMALLOC area.
+	 */
+	mov	x23, #(1 << (VA_BITS - 2)) - 1
+	and	x23, x23, x1, lsl #SWAPPER_BLOCK_SHIFT
+#endif
+
 	adr_l	x0, boot_args			// record the contents of
 	stp	x21, x1, [x0]			// x0 .. x3 at kernel entry
 	stp	x2, x3, [x0, #16]
@@ -400,6 +420,9 @@ __create_page_tables:
 	 */
 	mov	x0, x26				// swapper_pg_dir
 	ldr	x5, =KIMAGE_VADDR
+#ifdef CONFIG_ARM64_RELOCATABLE_KERNEL
+	add	x5, x5, x23			// add KASLR displacement
+#endif
 	create_pgd_entry x0, x5, x3, x6
 	ldr	w6, kernel_img_size
 	add	x6, x6, x5
@@ -437,6 +460,51 @@ __mmap_switched:
 	str	xzr, [x6], #8			// Clear BSS
 	b	1b
 2:
+
+#ifdef CONFIG_ARM64_RELOCATABLE_KERNEL
+
+#define R_AARCH64_RELATIVE	0x403
+#define R_AARCH64_ABS64		0x101
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
+	cmp	x12, #R_AARCH64_RELATIVE
+	b.ne	1f
+	ldr	x12, [x9, #-8]
+	add	x12, x12, x23			// relocate
+	str	x12, [x11, x23]
+	b	0b
+
+1:	ubfx	x13, x12, #0, #32
+	cmp	x13, #R_AARCH64_ABS64
+	b.ne	0b
+	lsr	x13, x12, #32			// symbol index
+	ldr	x12, [x9, #-8]
+	add	x13, x13, x13, lsl #1		// x 3
+	add	x13, x8, x13, lsl #3		// x 8
+	ldrsh	w14, [x13, #6]			// Elf64_Sym::st_shndx
+	ldr	x15, [x13, #8]			// Elf64_Sym::st_value
+	cmp	w14, #-0xf			// SHN_ABS (0xfff1) ?
+	add	x14, x15, x23			// relocate
+	csel	x15, x14, x15, ne
+	add	x15, x12, x15
+	str	x15, [x11, x23]
+	b	0b
+
+2:	ldr	x8, =vectors			// reload VBAR_EL1 with
+	msr	vbar_el1, x8			// relocated address
+	isb
+#endif
+
 	adr_l	sp, initial_sp, x4
 	str_l	x21, __fdt_pointer, x5		// Save FDT pointer
 	str_l	x24, memstart_addr, x6		// Save PHYS_OFFSET
@@ -452,6 +520,12 @@ ENDPROC(__mmap_switched)
  * hotplug and needs to have the same protections as the text region
  */
 	.section ".text","ax"
+
+#ifdef CONFIG_ARM64_RELOCATABLE_KERNEL
+ENTRY(kimage_vaddr)
+	.quad		_text - TEXT_OFFSET
+#endif
+
 /*
  * If we're fortunate enough to boot at EL2, ensure that the world is
  * sane before dropping to EL1.
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 96177a7c0f05..2faee6042e99 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -292,16 +292,15 @@ u64 __cpu_logical_map[NR_CPUS] = { [0 ... NR_CPUS-1] = INVALID_HWID };
 
 void __init setup_arch(char **cmdline_p)
 {
-	static struct vm_struct vmlinux_vm __initdata = {
-		.addr		= (void *)KIMAGE_VADDR,
-		.size		= 0,
-		.flags		= VM_IOREMAP,
-		.caller		= setup_arch,
-	};
-
-	vmlinux_vm.size = round_up((unsigned long)_end - KIMAGE_VADDR,
-				   1 << SWAPPER_BLOCK_SHIFT);
-	vmlinux_vm.phys_addr = __pa(KIMAGE_VADDR);
+	static struct vm_struct vmlinux_vm __initdata;
+
+	vmlinux_vm.addr = (void *)kimage_vaddr;
+	vmlinux_vm.size = round_up((u64)_end - kimage_vaddr,
+				   SWAPPER_BLOCK_SIZE);
+	vmlinux_vm.phys_addr = __pa(kimage_vaddr);
+	vmlinux_vm.flags = VM_IOREMAP;
+	vmlinux_vm.caller = setup_arch;
+
 	vm_area_add_early(&vmlinux_vm);
 
 	pr_info("Boot CPU: AArch64 Processor [%08x]\n", read_cpuid_id());
@@ -367,7 +366,8 @@ void __init setup_arch(char **cmdline_p)
 	conswitchp = &dummy_con;
 #endif
 #endif
-	if (boot_args[1] || boot_args[2] || boot_args[3]) {
+	if ((!IS_ENABLED(CONFIG_ARM64_RELOCATABLE_KERNEL) && boot_args[1]) ||
+	    boot_args[2] || boot_args[3]) {
 		pr_err("WARNING: x1-x3 nonzero in violation of boot protocol:\n"
 			"\tx1: %016llx\n\tx2: %016llx\n\tx3: %016llx\n"
 			"This indicates a broken bootloader or old kernel\n",
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 69dfa376e843..77faf85f6d46 100644
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
diff --git a/scripts/sortextable.c b/scripts/sortextable.c
index af247c70fb66..5ecbedefdb0f 100644
--- a/scripts/sortextable.c
+++ b/scripts/sortextable.c
@@ -266,9 +266,9 @@ do_file(char const *const fname)
 		break;
 	}  /* end switch */
 	if (memcmp(ELFMAG, ehdr->e_ident, SELFMAG) != 0
-	||  r2(&ehdr->e_type) != ET_EXEC
+	|| (r2(&ehdr->e_type) != ET_EXEC && r2(&ehdr->e_type) != ET_DYN)
 	||  ehdr->e_ident[EI_VERSION] != EV_CURRENT) {
-		fprintf(stderr, "unrecognized ET_EXEC file %s\n", fname);
+		fprintf(stderr, "unrecognized ET_EXEC/ET_DYN file %s\n", fname);
 		fail_file();
 	}
 
-- 
2.5.0
