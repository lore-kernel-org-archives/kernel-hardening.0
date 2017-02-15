From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 15 Feb 2017 15:37:59 +0000
Message-Id: <1487173081-13425-2-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1487173081-13425-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1487173081-13425-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [RFC PATCH 1/3] arm64: mmu: restrict permissions of early kernel mappings
To: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, will.deacon@arm.com, catalin.marinas@arm.com, keescook@chromium.org, labbott@fedoraproject.org, james.morse@arm.com
Cc: kernel-hardening@lists.openwall.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

Restrict the permissions of the early kernel mappings as much as
possible, by
- making the ID map read-only,
- making the virtual kernel mapping non-executable initially, and fixing
  up the permissions after relocation processing has occurred,
- making the kernel text and as much of .rodata as possible read-only,
  this is limited by the presence of the __ro_after_init section, which
  should remain writable throughout the entire __init sequence,
- making the .init.text section read-only if its placement allows it.

The latter condition is based on a couple of parameters, i.e., the page
size, the swapper block size and the actual physical placement of the
kernel Image. On 16k and 64k pagesize kernels and 4k pagesize kernels with
CONFIG_DEBUG_ALIGN_RODATA=y and CONFIG_RELOCATABLE=y, this condition is
guaranteed to be met. In other cases, it depends on the placement of the
kernel and the sizes of the various sections: this will be taken advantage
of in a subsequent patch. In the mean time, we can put some space between
the end of the init code section and the writable init data section by
moving the .rela section into inittext.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/kernel-pgtable.h |  3 ++
 arch/arm64/kernel/head.S                | 53 +++++++++++++++++++-
 arch/arm64/kernel/vmlinux.lds.S         | 14 +++---
 3 files changed, 62 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kernel-pgtable.h b/arch/arm64/include/asm/kernel-pgtable.h
index 7803343e5881..cd543e51e6e8 100644
--- a/arch/arm64/include/asm/kernel-pgtable.h
+++ b/arch/arm64/include/asm/kernel-pgtable.h
@@ -87,6 +87,9 @@
 #define SWAPPER_MM_MMUFLAGS	(PTE_ATTRINDX(MT_NORMAL) | SWAPPER_PTE_FLAGS)
 #endif
 
+#define SWAPPER_MM_MMUFLAGS_RW	(SWAPPER_MM_MMUFLAGS | PTE_PXN | PTE_UXN)
+#define SWAPPER_MM_MMUFLAGS_RX	(SWAPPER_MM_MMUFLAGS | PTE_RDONLY)
+
 /*
  * To make optimal use of block mappings when laying out the linear
  * mapping, round down the base of physical memory to a size that can
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 4fb6ccd886d1..9ea0286c33d5 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -386,7 +386,7 @@ __create_page_tables:
 	cmp	x0, x6
 	b.lo	1b
 
-	mov	x7, SWAPPER_MM_MMUFLAGS
+	mov	x7, SWAPPER_MM_MMUFLAGS_RX
 
 	/*
 	 * Create the identity mapping.
@@ -438,6 +438,8 @@ __create_page_tables:
 	adr_l	x6, __idmap_text_end		// __pa(__idmap_text_end)
 	create_block_map x0, x7, x3, x5, x6
 
+	mov_q	x7, SWAPPER_MM_MMUFLAGS_RW
+
 	/*
 	 * Map the kernel image (starting with PHYS_OFFSET).
 	 */
@@ -873,6 +875,7 @@ __primary_switch:
 #ifdef CONFIG_RELOCATABLE
 	bl	__relocate_kernel
 #ifdef CONFIG_RANDOMIZE_BASE
+	bl	__update_page_permissions
 	ldr	x8, =__primary_switched
 	adrp	x0, __PHYS_OFFSET
 	blr	x8
@@ -898,7 +901,55 @@ __primary_switch:
 	bl	__relocate_kernel
 #endif
 #endif
+	bl	__update_page_permissions
 	ldr	x8, =__primary_switched
 	adrp	x0, __PHYS_OFFSET
 	br	x8
 ENDPROC(__primary_switch)
+
+__update_page_permissions:
+	ldr	x0, =swapper_pg_dir + (SWAPPER_PGTABLE_LEVELS - 1) * PAGE_SIZE
+
+	/*
+	 * Remap the kernel text (and as much of rodata as we can, but without
+	 * covering the __ro_after_init section) with R-X permissions
+	 */
+	mov	x7, SWAPPER_MM_MMUFLAGS_RX
+	ldr	x5, =_text
+	adrp	x3, _text
+	ldr	x6, =__start_data_ro_after_init - SWAPPER_BLOCK_SIZE
+	create_block_map x0, x7, x3, x5, x6
+
+	/*
+	 * Remap .init.text with R-X permissions, unless the swapper block that
+	 * covers it intersects with adjacent writable regions. In that case,
+	 * there is no way around using RWX permissions for this region.
+	 */
+	ldr	x5, =__inittext_begin
+	adrp	x3, __inittext_begin
+	ldr	x6, =_einittext - 1
+
+	/*
+	 * Whether we must use RWX permissions depends on the swapper block
+	 * size, the page size, the segment alignment and possibly on the
+	 * runtime physical offset of the kernel image modulo the swapper
+	 * block size, in which case we can only decide this at runtime.
+	 */
+#if SWAPPER_BLOCK_SIZE > PAGE_SIZE
+	ldr	x8, =__end_data_ro_after_init
+	ldr	x9, =__initdata_begin
+	bic	x5, x5, #SWAPPER_BLOCK_SIZE - 1
+	bic	x9, x9, #SWAPPER_BLOCK_SIZE - 1
+
+	cmp	x5, x8
+	ccmp	x9, x6, #1, ge
+	mov	x8, SWAPPER_MM_MMUFLAGS		// RWX permissions
+	csel	x7, x7, x8, ge
+#endif
+	create_block_map x0, x7, x3, x5, x6
+
+	tlbi	vmalle1				// Remove any stale TLB entries
+	dsb	nsh
+
+	ret
+ENDPROC(__update_page_permissions)
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 2c93d259046c..6778f478fdee 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -160,6 +160,13 @@ SECTIONS
 		*(.altinstr_replacement)
 	}
 
+	.rela : ALIGN(8) {
+		*(.rela .rela*)
+	}
+
+	__rela_offset	= ABSOLUTE(ADDR(.rela) - KIMAGE_VADDR);
+	__rela_size	= SIZEOF(.rela);
+
 	. = ALIGN(PAGE_SIZE);
 	__inittext_end = .;
 	__initdata_begin = .;
@@ -179,13 +186,6 @@ SECTIONS
 
 	PERCPU_SECTION(L1_CACHE_BYTES)
 
-	.rela : ALIGN(8) {
-		*(.rela .rela*)
-	}
-
-	__rela_offset	= ABSOLUTE(ADDR(.rela) - KIMAGE_VADDR);
-	__rela_size	= SIZEOF(.rela);
-
 	. = ALIGN(SEGMENT_ALIGN);
 	__initdata_end = .;
 	__init_end = .;
-- 
2.7.4
