Reply-To: kernel-hardening@lists.openwall.com
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 28 Dec 2015 12:20:52 +0100
Message-Id: <1451301654-32019-9-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1451301654-32019-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1451301654-32019-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [RFC PATCH 08/10] arm64: avoid dynamic relocations in early boot code
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, lkml@vger.kernel.org
Cc: stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

Before implementing KASLR for arm64 by building a self-relocating PIE
executable, we have to ensure that values we use before the relocation
routine is executed are not subject to dynamic relocation themselves.
This applies not only to virtual addresses, but also to values that are
supplied by the linker at build time and relocated using R_AARCH64_ABS64
relocations.

So instead, use assemble time constants, or force the use of static
relocations by folding the constants into the instructions.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/kernel/efi-entry.S |  2 +-
 arch/arm64/kernel/head.S      | 12 +++++++++---
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/efi-entry.S b/arch/arm64/kernel/efi-entry.S
index a773db92908b..f82036e02485 100644
--- a/arch/arm64/kernel/efi-entry.S
+++ b/arch/arm64/kernel/efi-entry.S
@@ -61,7 +61,7 @@ ENTRY(entry)
 	 */
 	mov	x20, x0		// DTB address
 	ldr	x0, [sp, #16]	// relocated _text address
-	ldr	x21, =stext_offset
+	movz	x21, #:abs_g0:stext_offset
 	add	x21, x0, x21
 
 	/*
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index a03ffffd84cb..4f086e247eea 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -227,11 +227,13 @@ ENTRY(stext)
 	 * On return, the CPU will be ready for the MMU to be turned on and
 	 * the TCR will have been set.
 	 */
-	ldr	x27, =__mmap_switched		// address to jump to after
+	ldr	x27, 0f				// address to jump to after
 						// MMU has been enabled
 	adr_l	lr, __enable_mmu		// return (PIC) address
 	b	__cpu_setup			// initialise processor
 ENDPROC(stext)
+	.align	3
+0:	.quad	__mmap_switched - (_head - TEXT_OFFSET) + KIMAGE_VADDR
 
 /*
  * Preserve the arguments passed by the bootloader in x0 .. x3
@@ -341,7 +343,7 @@ __create_page_tables:
 	cmp	x0, x6
 	b.lo	1b
 
-	ldr	x7, =SWAPPER_MM_MMUFLAGS
+	mov	x7, SWAPPER_MM_MMUFLAGS
 
 	/*
 	 * Create the identity mapping.
@@ -399,7 +401,8 @@ __create_page_tables:
 	mov	x0, x26				// swapper_pg_dir
 	ldr	x5, =KIMAGE_VADDR
 	create_pgd_entry x0, x5, x3, x6
-	ldr	x6, =KERNEL_END			// __va(KERNEL_END)
+	ldr	w6, kernel_img_size
+	add	x6, x6, x5
 	mov	x3, x24				// phys offset
 	create_block_map x0, x7, x3, x5, x6
 
@@ -416,6 +419,9 @@ __create_page_tables:
 	mov	lr, x27
 	ret
 ENDPROC(__create_page_tables)
+
+kernel_img_size:
+	.long	_end - (_head - TEXT_OFFSET)
 	.ltorg
 
 /*
-- 
2.5.0
