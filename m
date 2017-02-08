From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed,  8 Feb 2017 11:55:42 +0000
Message-Id: <1486554947-3964-10-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1486554947-3964-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1486554947-3964-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v2 09/14] arm: compressed: put zImage header and EFI header in dedicated section
To: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, leif.lindholm@linaro.org
Cc: catalin.marinas@arm.com, linux@armlinux.org.uk, kernel-hardening@lists.openwall.com, labbott@fedoraproject.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

To align the PE/COFF and the ELF headers of the decompressor binary, put
the zImage header and the EFI header in a separate .head.text section,
and emit it at the start of the Image. This change is necessary for UEFI
based debug tooling to be able to use the vmlinux ELF binary, since it
gets confused if the PE/COFF .text section and the ELF .text section live
at different offsets.

This requires a tweak of the initial jump, because (b)adr does not reach
across a section boundary. Other than that, and a few bytes of padding at
the beginning of .start, this change does not affect the binary image.

Cc: Dave Martin <dave.martin@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/boot/compressed/efi-header.S  |  2 --
 arch/arm/boot/compressed/head.S        | 14 +++++++++-----
 arch/arm/boot/compressed/vmlinux.lds.S |  5 ++++-
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/compressed/efi-header.S b/arch/arm/boot/compressed/efi-header.S
index 9d5dc4fda3c1..1d26a9d0a9e8 100644
--- a/arch/arm/boot/compressed/efi-header.S
+++ b/arch/arm/boot/compressed/efi-header.S
@@ -23,8 +23,6 @@
 
 		.macro	__EFI_HEADER
 #ifdef CONFIG_EFI_STUB
-		b	__efi_start
-
 		.set	start_offset, __efi_start - start
 		.org	start + 0x3c
 		@
diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index fc6d541549a2..42ba2f557791 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -114,7 +114,7 @@
 #endif
 		.endm
 
-		.section ".start", #alloc, #execinstr
+		.section ".head.text", #alloc, #execinstr
 /*
  * sort out different calling conventions
  */
@@ -132,17 +132,21 @@ start:
 		.endr
    ARM(		mov	r0, r0		)
    ARM(		b	1f		)
- THUMB(		badr	r12, 1f		)
- THUMB(		bx	r12		)
+AR_CLASS(THUMB(	sub	pc, pc, #3	))	@ A/R: switch to Thumb2 mode
+ M_CLASS(	nop.w			)	@ M: already in Thumb2 mode
+   THUMB(	.thumb			)
+   THUMB(	b.w	1f		)
 
 		.word	_magic_sig	@ Magic numbers to help the loader
 		.word	_magic_start	@ absolute load/run zImage address
 		.word	_magic_end	@ zImage end address
 		.word	0x04030201	@ endianness flag
 
- THUMB(		.thumb			)
-1:		__EFI_HEADER
+		__EFI_HEADER
 
+		.section ".start", #alloc, #execinstr
+		.align
+1:
  ARM_BE8(	setend	be		)	@ go BE8 if compiled for BE8
  AR_CLASS(	mrs	r9, cpsr	)
 #ifdef CONFIG_ARM_VIRT_EXT
diff --git a/arch/arm/boot/compressed/vmlinux.lds.S b/arch/arm/boot/compressed/vmlinux.lds.S
index 81c493156ce8..5d50daea466a 100644
--- a/arch/arm/boot/compressed/vmlinux.lds.S
+++ b/arch/arm/boot/compressed/vmlinux.lds.S
@@ -34,8 +34,11 @@ SECTIONS
   . = TEXT_START;
   _text = .;
 
-  .text : {
+  .head.text : {
     _start = .;
+    *(.head.text)
+  }
+  .text : {
     *(.start)
     *(.text)
     *(.text.*)
-- 
2.7.4
