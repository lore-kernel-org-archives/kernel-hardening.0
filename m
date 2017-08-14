From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 14 Aug 2017 13:54:07 +0100
Message-Id: <20170814125411.22604-27-ard.biesheuvel@linaro.org>
In-Reply-To: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
References: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH 26/30] ARM: decompressor: add KASLR support
To: kernel-hardening@lists.openwall.com
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

Add support to the decompressor to load the kernel at a randomized
offset, and invoke the kernel proper while passing on the information
about the offset at which the kernel was loaded.

This implementation was created with the UEFI stub in mind (which has
a rich execution environment that provides access to the platforms
random number generators), which will assign the kaslr_offset variable
directly. However, to allow other bootloaders to use this facility,
the KASLR offset is exposed via a zImage header field as well.

Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/boot/compressed/head.S |  8 ++++++
 arch/arm/include/asm/zimage.h   | 30 ++++++++++++++++++--
 2 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index e451738d8954..7111a2cbef95 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -200,6 +200,10 @@ not_angel:
 		 */
 		mov	r4, pc
 		and	r4, r4, #0xf8000000
+#ifdef CONFIG_RANDOMIZE_BASE
+		ldr_l	r0, kaslr_offset
+		add	r4, r4, r0
+#endif
 		/* Determine final kernel image address. */
 		add	r4, r4, #TEXT_OFFSET
 #else
@@ -1353,6 +1357,10 @@ __hyp_reentry_vectors:
 
 __enter_kernel:
 		mov	r0, #0			@ must be 0
+#ifdef CONFIG_RANDOMIZE_BASE
+		ldr_l	r3, kaslr_offset
+		add	r4, r4, #4		@ skip first instruction
+#endif
  ARM(		mov	pc, r4		)	@ call kernel
  M_CLASS(	add	r4, r4, #1	)	@ enter in Thumb mode for M class
  THUMB(		bx	r4		)	@ entry point is always ARM for A/R classes
diff --git a/arch/arm/include/asm/zimage.h b/arch/arm/include/asm/zimage.h
index ff65cc3bb716..554a48ddcfd8 100644
--- a/arch/arm/include/asm/zimage.h
+++ b/arch/arm/include/asm/zimage.h
@@ -10,10 +10,15 @@
 #ifndef __ASM_ZIMAGE_H
 #define __ASM_ZIMAGE_H
 
+#include <asm/pgtable.h>
+
 #define ZIMAGE_HEADER_MAGIC		0x016f2818
 #define ZIMAGE_OPTIONAL_HEADER_MAGIC	0xe7fedef0
 
-#if defined(__ASSEMBLY__) && !defined(LINKER_SCRIPT)
+#define ZIMAGE_OPT_HDR_ID_KASLR		0x1
+
+#ifndef LINKER_SCRIPT
+#ifdef __ASSEMBLY__
 
 	.macro		__ZIMAGE_HEADER
 	.word		_magic_sig	@ Magic numbers to help the loader
@@ -31,9 +36,30 @@
 	 * Each header starts with a u16[2] containing id and size of the
 	 * entire header, including the u16[] itself.
 	 */
+
+#ifdef CONFIG_RANDOMIZE_BASE
+0:	.short		ZIMAGE_OPT_HDR_ID_KASLR
+	.short		__kaslr_hdr_size
+
+	/*
+	 * The KASLR header carries the information needed by the bootloader
+	 * to choose a randomization offset, and record it in the offset
+	 * field below.
+	 */
+ENTRY(kaslr_offset)
+	.long		0				@ kaslr offset
+	.long		CONFIG_PAGE_OFFSET		@ page offset
+	.long		VMALLOC_DEFAULT_BASE		@ start of vmalloc area
+	.long		SECTION_SIZE			@ kaslr granularity
+	.set		__kaslr_hdr_size, . - 0b
+#endif
+
 	.long		0xffffffff	@ end of optional headers
 	.popsection
 	.endm
 
-#endif
+#else /* __ASSEMBLY__ */
+extern u32 kaslr_offset;
+#endif /* __ASSEMBLY__ */
+#endif /* LINKER_SCRIPT */
 #endif
-- 
2.11.0
