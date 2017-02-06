From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon,  6 Feb 2017 16:24:31 +0000
Message-Id: <1486398275-3966-4-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1486398275-3966-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1486398275-3966-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH 3/7] arm64: efi: move EFI header and related data to a separate .S file
To: linux-arm-kernel@lists.infradead.org, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com
Cc: labbott@fedoraproject.org, kernel-hardening@lists.openwall.com, leif.lindholm@linaro.org, pjones@redhat.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

In preparation of yet another round of modifications to the PE/COFF
header, macroize it and move the definition into a separate source
file.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/kernel/efi-header.S | 182 ++++++++++++++++++++
 arch/arm64/kernel/head.S       | 171 +-----------------
 2 files changed, 186 insertions(+), 167 deletions(-)

diff --git a/arch/arm64/kernel/efi-header.S b/arch/arm64/kernel/efi-header.S
new file mode 100644
index 000000000000..8c8cd0a8192b
--- /dev/null
+++ b/arch/arm64/kernel/efi-header.S
@@ -0,0 +1,182 @@
+/*
+ * Copyright (C) 2013 - 2017 Linaro, Ltd.
+ * Copyright (C) 2013, 2014 Red Hat, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+	.macro	__jmp, target
+#ifdef CONFIG_EFI
+	/*
+	 * This add instruction has no meaningful effect except that
+	 * its opcode forms the magic "MZ" signature required by UEFI.
+	 */
+	add	x13, x18, #0x16
+	b	\target
+#else
+	b	\target				// branch to kernel start, magic
+	.long	0				// reserved
+#endif
+	.endm
+
+	.macro	__EFI_HEADER
+#ifdef CONFIG_EFI
+	.long	pe_header - _head		// Offset to the PE header.
+#else
+	.word	0				// reserved
+#endif
+
+#ifdef CONFIG_EFI
+	.align 3
+pe_header:
+	.ascii	"PE"
+	.short 	0
+coff_header:
+	.short	0xaa64					// AArch64
+	.short	2					// nr_sections
+	.long	0 					// TimeDateStamp
+	.long	0					// PointerToSymbolTable
+	.long	1					// NumberOfSymbols
+	.short	section_table - optional_header		// SizeOfOptionalHeader
+	.short	0x206					// Characteristics.
+							// IMAGE_FILE_DEBUG_STRIPPED |
+							// IMAGE_FILE_EXECUTABLE_IMAGE |
+							// IMAGE_FILE_LINE_NUMS_STRIPPED
+optional_header:
+	.short	0x20b					// PE32+ format
+	.byte	0x02					// MajorLinkerVersion
+	.byte	0x14					// MinorLinkerVersion
+	.long	_end - efi_header_end			// SizeOfCode
+	.long	0					// SizeOfInitializedData
+	.long	0					// SizeOfUninitializedData
+	.long	__efistub_entry - _head			// AddressOfEntryPoint
+	.long	efi_header_end - _head			// BaseOfCode
+
+extra_header_fields:
+	.quad	0					// ImageBase
+	.long	0x1000					// SectionAlignment
+	.long	PECOFF_FILE_ALIGNMENT			// FileAlignment
+	.short	0					// MajorOperatingSystemVersion
+	.short	0					// MinorOperatingSystemVersion
+	.short	0					// MajorImageVersion
+	.short	0					// MinorImageVersion
+	.short	0					// MajorSubsystemVersion
+	.short	0					// MinorSubsystemVersion
+	.long	0					// Win32VersionValue
+
+	.long	_end - _head				// SizeOfImage
+
+	// Everything before the kernel image is considered part of the header
+	.long	efi_header_end - _head			// SizeOfHeaders
+	.long	0					// CheckSum
+	.short	0xa					// Subsystem (EFI application)
+	.short	0					// DllCharacteristics
+	.quad	0					// SizeOfStackReserve
+	.quad	0					// SizeOfStackCommit
+	.quad	0					// SizeOfHeapReserve
+	.quad	0					// SizeOfHeapCommit
+	.long	0					// LoaderFlags
+	.long	(section_table - .) / 8			// NumberOfRvaAndSizes
+
+	.quad	0					// ExportTable
+	.quad	0					// ImportTable
+	.quad	0					// ResourceTable
+	.quad	0					// ExceptionTable
+	.quad	0					// CertificationTable
+	.quad	0					// BaseRelocationTable
+
+#ifdef CONFIG_DEBUG_EFI
+	.long	efi_debug_table - _head			// DebugTable
+	.long	efi_debug_table_size
+#endif
+
+	// Section table
+section_table:
+
+	/*
+	 * The EFI application loader requires a relocation section
+	 * because EFI applications must be relocatable.  This is a
+	 * dummy section as far as we are concerned.
+	 */
+	.ascii	".reloc"
+	.byte	0
+	.byte	0					// end of 0 padding of section name
+	.long	0
+	.long	0
+	.long	0					// SizeOfRawData
+	.long	0					// PointerToRawData
+	.long	0					// PointerToRelocations
+	.long	0					// PointerToLineNumbers
+	.short	0					// NumberOfRelocations
+	.short	0					// NumberOfLineNumbers
+	.long	0x42100040				// Characteristics (section flags)
+
+
+	.ascii	".text"
+	.byte	0
+	.byte	0
+	.byte	0        				// end of 0 padding of section name
+	.long	_end - efi_header_end			// VirtualSize
+	.long	efi_header_end - _head			// VirtualAddress
+	.long	_edata - efi_header_end			// SizeOfRawData
+	.long	efi_header_end - _head			// PointerToRawData
+
+	.long	0					// PointerToRelocations
+	.long	0					// PointerToLineNumbers
+	.short	0					// NumberOfRelocations
+	.short	0					// NumberOfLineNumbers
+	.long	0xe0500020				// Characteristics
+
+#ifdef CONFIG_DEBUG_EFI
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
+	__INITRODATA
+
+	.align	2
+efi_debug_table:
+	// EFI_IMAGE_DEBUG_DIRECTORY_ENTRY
+	.long	0					// Characteristics
+	.long	0					// TimeDateStamp
+	.short	0					// MajorVersion
+	.short	0					// MinorVersion
+	.long	2					// Type == EFI_IMAGE_DEBUG_TYPE_CODEVIEW
+	.long	efi_debug_entry_size			// SizeOfData
+	.long	0					// RVA
+	.long	efi_debug_entry - _head			// FileOffset
+
+	.set	efi_debug_table_size, . - efi_debug_table
+	.previous
+
+efi_debug_entry:
+	// EFI_IMAGE_DEBUG_CODEVIEW_NB10_ENTRY
+	.ascii	"NB10"					// Signature
+	.long	0					// Unknown
+	.long	0					// Unknown2
+	.long	0					// Unknown3
+
+	.asciz	VMLINUX_PATH
+
+	.set	efi_debug_entry_size, . - efi_debug_entry
+#endif
+
+	/*
+	 * EFI will load .text onwards at the 4k section alignment
+	 * described in the PE/COFF header. To ensure that instruction
+	 * sequences using an adrp and a :lo12: immediate will function
+	 * correctly at this alignment, we must ensure that .text is
+	 * placed at a 4k boundary in the Image to begin with.
+	 */
+	.align 12
+efi_header_end:
+#endif
+	.endm
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index c6cc82ec190b..aca9b184035a 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -42,6 +42,8 @@
 #include <asm/thread_info.h>
 #include <asm/virt.h>
 
+#include "efi-header.S"
+
 #define __PHYS_OFFSET	(KERNEL_START - TEXT_OFFSET)
 
 #if (TEXT_OFFSET & 0xfff) != 0
@@ -72,17 +74,7 @@ _head:
 	/*
 	 * DO NOT MODIFY. Image header expected by Linux boot-loaders.
 	 */
-#ifdef CONFIG_EFI
-	/*
-	 * This add instruction has no meaningful effect except that
-	 * its opcode forms the magic "MZ" signature required by UEFI.
-	 */
-	add	x13, x18, #0x16
-	b	stext
-#else
-	b	stext				// branch to kernel start, magic
-	.long	0				// reserved
-#endif
+	__jmp	stext				// Executable code
 	le64sym	_kernel_offset_le		// Image load offset from start of RAM, little-endian
 	le64sym	_kernel_size_le			// Effective size of kernel image, little-endian
 	le64sym	_kernel_flags_le		// Informative flags, little-endian
@@ -93,163 +85,8 @@ _head:
 	.byte	0x52
 	.byte	0x4d
 	.byte	0x64
-#ifdef CONFIG_EFI
-	.long	pe_header - _head		// Offset to the PE header.
-#else
-	.word	0				// reserved
-#endif
-
-#ifdef CONFIG_EFI
-	.align 3
-pe_header:
-	.ascii	"PE"
-	.short 	0
-coff_header:
-	.short	0xaa64				// AArch64
-	.short	2				// nr_sections
-	.long	0 				// TimeDateStamp
-	.long	0				// PointerToSymbolTable
-	.long	1				// NumberOfSymbols
-	.short	section_table - optional_header	// SizeOfOptionalHeader
-	.short	0x206				// Characteristics.
-						// IMAGE_FILE_DEBUG_STRIPPED |
-						// IMAGE_FILE_EXECUTABLE_IMAGE |
-						// IMAGE_FILE_LINE_NUMS_STRIPPED
-optional_header:
-	.short	0x20b				// PE32+ format
-	.byte	0x02				// MajorLinkerVersion
-	.byte	0x14				// MinorLinkerVersion
-	.long	_end - efi_header_end		// SizeOfCode
-	.long	0				// SizeOfInitializedData
-	.long	0				// SizeOfUninitializedData
-	.long	__efistub_entry - _head		// AddressOfEntryPoint
-	.long	efi_header_end - _head		// BaseOfCode
-
-extra_header_fields:
-	.quad	0				// ImageBase
-	.long	0x1000				// SectionAlignment
-	.long	PECOFF_FILE_ALIGNMENT		// FileAlignment
-	.short	0				// MajorOperatingSystemVersion
-	.short	0				// MinorOperatingSystemVersion
-	.short	0				// MajorImageVersion
-	.short	0				// MinorImageVersion
-	.short	0				// MajorSubsystemVersion
-	.short	0				// MinorSubsystemVersion
-	.long	0				// Win32VersionValue
-
-	.long	_end - _head			// SizeOfImage
-
-	// Everything before the kernel image is considered part of the header
-	.long	efi_header_end - _head		// SizeOfHeaders
-	.long	0				// CheckSum
-	.short	0xa				// Subsystem (EFI application)
-	.short	0				// DllCharacteristics
-	.quad	0				// SizeOfStackReserve
-	.quad	0				// SizeOfStackCommit
-	.quad	0				// SizeOfHeapReserve
-	.quad	0				// SizeOfHeapCommit
-	.long	0				// LoaderFlags
-	.long	(section_table - .) / 8		// NumberOfRvaAndSizes
-
-	.quad	0				// ExportTable
-	.quad	0				// ImportTable
-	.quad	0				// ResourceTable
-	.quad	0				// ExceptionTable
-	.quad	0				// CertificationTable
-	.quad	0				// BaseRelocationTable
-
-#ifdef CONFIG_DEBUG_EFI
-	.long	efi_debug_table - _head		// DebugTable
-	.long	efi_debug_table_size
-#endif
-
-	// Section table
-section_table:
 
-	/*
-	 * The EFI application loader requires a relocation section
-	 * because EFI applications must be relocatable.  This is a
-	 * dummy section as far as we are concerned.
-	 */
-	.ascii	".reloc"
-	.byte	0
-	.byte	0			// end of 0 padding of section name
-	.long	0
-	.long	0
-	.long	0			// SizeOfRawData
-	.long	0			// PointerToRawData
-	.long	0			// PointerToRelocations
-	.long	0			// PointerToLineNumbers
-	.short	0			// NumberOfRelocations
-	.short	0			// NumberOfLineNumbers
-	.long	0x42100040		// Characteristics (section flags)
-
-
-	.ascii	".text"
-	.byte	0
-	.byte	0
-	.byte	0        		// end of 0 padding of section name
-	.long	_end - efi_header_end	// VirtualSize
-	.long	efi_header_end - _head	// VirtualAddress
-	.long	_edata - efi_header_end	// SizeOfRawData
-	.long	efi_header_end - _head	// PointerToRawData
-
-	.long	0		// PointerToRelocations (0 for executables)
-	.long	0		// PointerToLineNumbers (0 for executables)
-	.short	0		// NumberOfRelocations  (0 for executables)
-	.short	0		// NumberOfLineNumbers  (0 for executables)
-	.long	0xe0500020	// Characteristics (section flags)
-
-#ifdef CONFIG_DEBUG_EFI
-	/*
-	 * The debug table is referenced via its Relative Virtual Address (RVA),
-	 * which is only defined for those parts of the image that are covered
-	 * by a section declaration. Since this header is not covered by any
-	 * section, the debug table must be emitted elsewhere. So stick it in
-	 * the .init.rodata section instead.
-	 *
-	 * Note that the EFI debug entry itself may legally have a zero RVA,
-	 * which means we can simply put it right after the section headers.
-	 */
-	__INITRODATA
-
-	.align	2
-efi_debug_table:
-	// EFI_IMAGE_DEBUG_DIRECTORY_ENTRY
-	.long	0			// Characteristics
-	.long	0			// TimeDateStamp
-	.short	0			// MajorVersion
-	.short	0			// MinorVersion
-	.long	2			// Type == EFI_IMAGE_DEBUG_TYPE_CODEVIEW
-	.long	efi_debug_entry_size	// SizeOfData
-	.long	0			// RVA
-	.long	efi_debug_entry - _head	// FileOffset
-
-	.set	efi_debug_table_size, . - efi_debug_table
-	.previous
-
-efi_debug_entry:
-	// EFI_IMAGE_DEBUG_CODEVIEW_NB10_ENTRY
-	.ascii	"NB10"			// Signature
-	.long	0			// Unknown
-	.long	0			// Unknown2
-	.long	0			// Unknown3
-
-	.asciz	VMLINUX_PATH
-
-	.set	efi_debug_entry_size, . - efi_debug_entry
-#endif
-
-	/*
-	 * EFI will load .text onwards at the 4k section alignment
-	 * described in the PE/COFF header. To ensure that instruction
-	 * sequences using an adrp and a :lo12: immediate will function
-	 * correctly at this alignment, we must ensure that .text is
-	 * placed at a 4k boundary in the Image to begin with.
-	 */
-	.align 12
-efi_header_end:
-#endif
+	__EFI_HEADER
 
 	__INIT
 
-- 
2.7.4
