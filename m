From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed,  8 Feb 2017 11:55:47 +0000
Message-Id: <1486554947-3964-15-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1486554947-3964-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1486554947-3964-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v2 14/14] arm: efi: add PE/COFF debug table to EFI header
To: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, leif.lindholm@linaro.org
Cc: catalin.marinas@arm.com, linux@armlinux.org.uk, kernel-hardening@lists.openwall.com, labbott@fedoraproject.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

This updates the PE/COFF header to emit the absolute path to the
decompressor vmlinux ELF file into a so-called NB10 Codeview entry.
This is hugely helpful when debugging the firmware->stub handover.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/boot/compressed/Makefile     |  4 ++
 arch/arm/boot/compressed/efi-header.S | 45 ++++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index d50430c40045..6b978bdbac3e 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -196,3 +196,7 @@ AFLAGS_hyp-stub.o := -Wa,-march=armv7-a
 
 $(obj)/hyp-stub.S: $(srctree)/arch/$(SRCARCH)/kernel/hyp-stub.S
 	$(call cmd,shipped)
+
+ifeq ($(CONFIG_EFI)$(CONFIG_DEBUG_INFO),yy)
+AFLAGS_head.o += -DVMLINUX_PATH="\"$(realpath $(obj)/vmlinux)\""
+endif
diff --git a/arch/arm/boot/compressed/efi-header.S b/arch/arm/boot/compressed/efi-header.S
index 3cf09f7efced..dff3c72c7c5a 100644
--- a/arch/arm/boot/compressed/efi-header.S
+++ b/arch/arm/boot/compressed/efi-header.S
@@ -95,6 +95,11 @@ extra_header_fields:
 	.quad	0					@ CertificationTable
 	.quad	0					@ BaseRelocationTable
 
+#ifdef CONFIG_DEBUG_INFO
+	.long	efi_debug_table - start			@ DebugTable
+	.long	efi_debug_table_size
+#endif
+
 section_table:
 	.ascii	".text\0\0\0"
 	.long	__pecoff_data_start - __efi_start	@ VirtualSize
@@ -124,6 +129,46 @@ section_table:
 
 	.set	section_count, (. - section_table) / 40
 
+#ifdef CONFIG_DEBUG_INFO
+	/*
+	 * The debug table is referenced via its Relative Virtual Address (RVA),
+	 * which is only defined for those parts of the image that are covered
+	 * by a section declaration. Since this header is not covered by any
+	 * section, the debug table must be emitted elsewhere. So stick it in
+	 * the .init.rodata section instead.
+	 *
+	 * Note that the EFI debug entry itself may legally have a zero RVA,
+	 * which means we can simply put it right after the section headers.
+	 */
+	.section	".rodata", #alloc
+
+	.align	2
+efi_debug_table:
+	// EFI_IMAGE_DEBUG_DIRECTORY_ENTRY
+	.long	0					@ Characteristics
+	.long	0					@ TimeDateStamp
+	.short	0					@ MajorVersion
+	.short	0					@ MinorVersion
+	.long	IMAGE_DEBUG_TYPE_CODEVIEW		@ Type
+	.long	efi_debug_entry_size			@ SizeOfData
+	.long	0					@ RVA
+	.long	efi_debug_entry - start			@ FileOffset
+
+	.set	efi_debug_table_size, . - efi_debug_table
+	.previous
+
+efi_debug_entry:
+	// EFI_IMAGE_DEBUG_CODEVIEW_NB10_ENTRY
+	.ascii	"NB10"					@ Signature
+	.long	0					@ Unknown
+	.long	0					@ Unknown2
+	.long	0					@ Unknown3
+
+	.asciz	VMLINUX_PATH
+
+	.set	efi_debug_entry_size, . - efi_debug_entry
+#endif
+
 	.align	12
 __efi_start:
 #endif
-- 
2.7.4
