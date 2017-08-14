From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 14 Aug 2017 13:54:04 +0100
Message-Id: <20170814125411.22604-24-ard.biesheuvel@linaro.org>
In-Reply-To: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
References: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH 23/30] ARM: kernel: implement randomization of the kernel load address
To: kernel-hardening@lists.openwall.com
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

This implements randomization of the placement of the kernel image
inside the lowmem region. It is intended to work together with the
decompressor to place the kernel at an offset in physical memory
that is a multiple of 2 MB, and to take the same offset into account
when creating the virtual mapping.

This uses runtime relocation of the kernel built as a PIE binary, to
fix up all absolute symbol references to refer to their runtime virtual
address. The physical-to-virtual mapping remains unchanged.

In order to allow the decompressor to hand over to the core kernel
without making assumptions that are not guaranteed to hold when
invoking the core kernel directly using bootloaders that are not
KASLR aware, the KASLR offset is expected to be placed in r3 when
entering the kernel 4 bytes past the entry point, skipping the first
instruction.

Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/Kconfig       |  15 +++
 arch/arm/kernel/head.S | 103 ++++++++++++++++++--
 2 files changed, 109 insertions(+), 9 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 300add3b8023..0d7b40f1061d 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1825,6 +1825,21 @@ config XEN
 	help
 	  Say Y if you want to run Linux in a Virtual Machine on Xen on ARM.
 
+config RANDOMIZE_BASE
+	bool "Randomize the address of the kernel image"
+	depends on MMU && AUTO_ZRELADDR
+	depends on !XIP_KERNEL && !ZBOOT_ROM && !HAVE_TCM
+	select RELOCATABLE
+	help
+	  Randomizes the virtual and physical address at which the kernel
+	  image is loaded, as a security feature that deters exploit attempts
+	  relying on knowledge of the location of kernel internals.
+
+	  This relies on the UEFI stub to invoke the EFI_RNG_PROTOCOL to
+	  randomize the load address of the decompressed kernel in the
+	  physical space. The same offset is applied to the virtual mapping
+	  of the kernel in the virtual space by the kernel proper.
+
 endmenu
 
 menu "Boot options"
diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index 71bc0d037bc9..0795da990dde 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -48,6 +48,28 @@
 #define PMD_ORDER	2
 #endif
 
+	.macro	get_kaslr_offset, reg
+#ifdef CONFIG_RANDOMIZE_BASE
+	ldr_l			\reg, __kaslr_offset
+#else
+	mov			\reg, #0
+#endif
+	.endm
+
+	.macro	add_kaslr_offset, reg, tmp
+#ifdef CONFIG_RANDOMIZE_BASE
+	get_kaslr_offset	\tmp
+	add			\reg, \reg, \tmp
+#endif
+	.endm
+
+	.macro	sub_kaslr_offset, reg, tmp
+#ifdef CONFIG_RANDOMIZE_BASE
+	get_kaslr_offset	\tmp
+	sub			\reg, \reg, \tmp
+#endif
+	.endm
+
 /*
  * Kernel startup entry point.
  * ---------------------------
@@ -73,6 +95,7 @@
 	.equ	swapper_pg_dir, . - PG_DIR_SIZE
 
 ENTRY(stext)
+	mov	r3, #0			@ normal entry point - clear r3
  ARM_BE8(setend	be )			@ ensure we are in BE8 mode
 
  THUMB(	badr	r9, 1f		)	@ Kernel is always entered in ARM.
@@ -80,6 +103,16 @@ ENTRY(stext)
  THUMB(	.thumb			)	@ switch to Thumb now.
  THUMB(1:			)
 
+#ifdef CONFIG_RANDOMIZE_BASE
+	str_l	r3, __kaslr_offset, r9	@ offset in r3 if entered via kaslr ep
+
+	.section ".bss", "aw", %nobits
+	.align	2
+__kaslr_offset:
+	.long	0			@ will be wiped before entering C code
+	.previous
+#endif
+
 #ifdef CONFIG_ARM_VIRT_EXT
 	bl	__hyp_stub_install
 #endif
@@ -103,6 +136,7 @@ ENTRY(stext)
 #ifndef CONFIG_XIP_KERNEL
 	adr_l	r8, _text			@ __pa(_text)
 	sub	r8, r8, #TEXT_OFFSET		@ PHYS_OFFSET
+	sub_kaslr_offset r8, r12
 #else
 	ldr	r8, =PLAT_PHYS_OFFSET		@ always constant in this case
 #endif
@@ -139,8 +173,8 @@ ENTRY(stext)
 	 * r0 will hold the CPU control register value, r1, r2, r4, and
 	 * r9 will be preserved.  r5 will also be preserved if LPAE.
 	 */
-	ldr	r13, =__mmap_switched		@ address to jump to after
-						@ mmu has been enabled
+	adr_l	lr, __primary_switch		@ address to jump to after
+	mov	r13, lr				@ mmu has been enabled
 	badr	lr, 1f				@ return (PIC) address
 #ifdef CONFIG_ARM_LPAE
 	mov	r5, #0				@ high TTBR0
@@ -151,7 +185,8 @@ ENTRY(stext)
 	ldr	r12, [r10, #PROCINFO_INITFUNC]
 	add	r12, r12, r10
 	ret	r12
-1:	b	__enable_mmu
+1:	get_kaslr_offset r12			@ get before turning MMU on
+	b	__enable_mmu
 ENDPROC(stext)
 	.ltorg
 
@@ -230,9 +265,14 @@ __create_page_tables:
 	/*
 	 * Map our RAM from the start to the end of the kernel .bss section.
 	 */
-	add	r0, r4, #PAGE_OFFSET >> (SECTION_SHIFT - PMD_ORDER)
-	ldr	r6, =(_end - 1)
-	orr	r3, r8, r7
+	get_kaslr_offset r3
+	add	r0, r3, #PAGE_OFFSET
+	add	r0, r4, r0, lsr #(SECTION_SHIFT - PMD_ORDER)
+	adr_l	r6, _end - 1
+	sub	r6, r6, r8
+	add	r6, r6, #PAGE_OFFSET
+	add	r3, r3, r8
+	orr	r3, r3, r7
 	add	r6, r4, r6, lsr #(SECTION_SHIFT - PMD_ORDER)
 1:	str	r3, [r0], #1 << PMD_ORDER
 	add	r3, r3, #1 << SECTION_SHIFT
@@ -376,7 +416,7 @@ ENTRY(secondary_startup)
 	 * Use the page tables supplied from  __cpu_up.
 	 */
 	adr_l	r3, secondary_data
-	mov_l	r12, __secondary_switched
+	adr_l	r12, __secondary_switch
 	ldrd	r4, [r3, #0]			@ get secondary_data.pgdir
 ARM_BE8(eor	r4, r4, r5)			@ Swap r5 and r4 in BE:
 ARM_BE8(eor	r5, r4, r5)			@ it can be done in 3 steps
@@ -414,6 +454,7 @@ ENDPROC(__secondary_switched)
  *  r4  = TTBR pointer (low word)
  *  r5  = TTBR pointer (high word if LPAE)
  *  r9  = processor ID
+ *  r12 = KASLR offset
  *  r13 = *virtual* address to jump to upon completion
  */
 __enable_mmu:
@@ -451,6 +492,7 @@ ENDPROC(__enable_mmu)
  *  r1  = machine ID
  *  r2  = atags or dtb pointer
  *  r9  = processor ID
+ *  r12 = KASLR offset
  *  r13 = *virtual* address to jump to upon completion
  *
  * other registers depend on the function called upon completion
@@ -466,10 +508,52 @@ ENTRY(__turn_mmu_on)
 	mov	r3, r3
 	mov	r3, r13
 	ret	r3
-__turn_mmu_on_end:
 ENDPROC(__turn_mmu_on)
-	.popsection
 
+__primary_switch:
+#ifdef CONFIG_RELOCATABLE
+	adr_l	r7, _text			@ r7 := __pa(_text)
+	sub	r7, r7, #TEXT_OFFSET		@ r7 := PHYS_OFFSET
+
+	adr_l	r5, __rel_begin
+	adr_l	r6, __rel_end
+	sub	r5, r5, r7
+	sub	r6, r6, r7
+
+	add	r5, r5, #PAGE_OFFSET
+	add	r6, r6, #PAGE_OFFSET
+	add	r5, r5, r12
+	add	r6, r6, r12
+
+	adr_l	r3, __stubs_start		@ __pa(__stubs_start)
+	sub	r3, r3, r7			@ offset of __stubs_start
+	add	r3, r3, #PAGE_OFFSET		@ __va(__stubs_start)
+	sub	r3, r3, #0xffff1000		@ subtract VA of stubs section
+
+0:	cmp	r5, r6
+	bge	1f
+	ldm	r5!, {r7, r8}			@ load next relocation entry
+	cmp	r8, #23				@ R_ARM_RELATIVE
+	bne	0b
+	cmp	r7, #0xff000000			@ vector page?
+	addgt	r7, r7, r3			@ fix up VA offset
+	ldr	r8, [r7, r12]
+	add	r8, r8, r12
+	str	r8, [r7, r12]
+	b	0b
+1:
+#endif
+	ldr	pc, =__mmap_switched
+ENDPROC(__primary_switch)
+
+#ifdef CONFIG_SMP
+__secondary_switch:
+	ldr	pc, =__secondary_switched
+ENDPROC(__secondary_switch)
+#endif
+	.ltorg
+__turn_mmu_on_end:
+	.popsection
 
 #ifdef CONFIG_SMP_ON_UP
 	__HEAD
@@ -570,6 +654,7 @@ __fixup_pv_table:
 	adr_l	r6, __pv_phys_pfn_offset
 	adr_l	r7, __pv_offset			@ __pa(__pv_offset)
 	mov_l	r3, __pv_offset			@ __va(__pv_offset)
+	add_kaslr_offset r3, ip
 	mvn	ip, #0
 	subs	r3, r7, r3	@ PHYS_OFFSET - PAGE_OFFSET
 	mov	r0, r8, lsr #PAGE_SHIFT	@ convert to PFN
-- 
2.11.0
