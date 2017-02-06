From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon,  6 Feb 2017 16:24:34 +0000
Message-Id: <1486398275-3966-7-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1486398275-3966-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1486398275-3966-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH 6/7] arm64: efi: replace open coded constants with symbolic ones
To: linux-arm-kernel@lists.infradead.org, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com
Cc: labbott@fedoraproject.org, kernel-hardening@lists.openwall.com, leif.lindholm@linaro.org, pjones@redhat.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

Replace open coded constants with symbolic ones throughout the
Image and the EFI headers. Note that in two cases, this removes
a value that the PE/COFF spec does not allow:
- NumberOfSymbols in the PE header should be 0
- PE/COFF executable sections (as opposed to sections in object files)
  should not use the section alignment flags

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/kernel/efi-header.S | 37 ++++++++++----------
 arch/arm64/kernel/head.S       |  5 +--
 2 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/kernel/efi-header.S b/arch/arm64/kernel/efi-header.S
index 35b11654ecc5..c87c23336c86 100644
--- a/arch/arm64/kernel/efi-header.S
+++ b/arch/arm64/kernel/efi-header.S
@@ -7,6 +7,8 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/pe.h>
+
 	.macro	__jmp, target
 #ifdef CONFIG_EFI
 	/*
@@ -33,21 +35,20 @@
 	.long	pe_header - _head		// Offset to the PE header.
 
 pe_header:
-	.ascii	"PE"
-	.short 	0
+	.long	PE_MAGIC
 coff_header:
-	.short	0xaa64					// AArch64
-	.short	1					// nr_sections
+	.short	IMAGE_FILE_MACHINE_ARM64		// Machine
+	.short	1					// NumberOfSections
 	.long	0 					// TimeDateStamp
 	.long	0					// PointerToSymbolTable
-	.long	1					// NumberOfSymbols
+	.long	0					// NumberOfSymbols
 	.short	section_table - optional_header		// SizeOfOptionalHeader
-	.short	0x206					// Characteristics.
-							// IMAGE_FILE_DEBUG_STRIPPED |
-							// IMAGE_FILE_EXECUTABLE_IMAGE |
-							// IMAGE_FILE_LINE_NUMS_STRIPPED
+	.short	IMAGE_FILE_DEBUG_STRIPPED | \
+		IMAGE_FILE_EXECUTABLE_IMAGE | \
+		IMAGE_FILE_LINE_NUMS_STRIPPED		// Characteristics
+
 optional_header:
-	.short	0x20b					// PE32+ format
+	.short	PE_OPT_MAGIC_PE32PLUS			// PE32+ format
 	.byte	0x02					// MajorLinkerVersion
 	.byte	0x14					// MinorLinkerVersion
 	.long	_end - efi_header_end			// SizeOfCode
@@ -58,7 +59,7 @@ optional_header:
 
 extra_header_fields:
 	.quad	0					// ImageBase
-	.long	0x1000					// SectionAlignment
+	.long	SZ_4K					// SectionAlignment
 	.long	PECOFF_FILE_ALIGNMENT			// FileAlignment
 	.short	0					// MajorOperatingSystemVersion
 	.short	0					// MinorOperatingSystemVersion
@@ -73,7 +74,7 @@ extra_header_fields:
 	// Everything before the kernel image is considered part of the header
 	.long	efi_header_end - _head			// SizeOfHeaders
 	.long	0					// CheckSum
-	.short	0xa					// Subsystem (EFI application)
+	.short	IMAGE_SUBSYSTEM_EFI_APPLICATION		// Subsystem
 	.short	0					// DllCharacteristics
 	.quad	0					// SizeOfStackReserve
 	.quad	0					// SizeOfStackCommit
@@ -96,10 +97,7 @@ extra_header_fields:
 
 	// Section table
 section_table:
-	.ascii	".text"
-	.byte	0
-	.byte	0
-	.byte	0        				// end of 0 padding of section name
+	.ascii	".text\0\0\0"
 	.long	_end - efi_header_end			// VirtualSize
 	.long	efi_header_end - _head			// VirtualAddress
 	.long	_edata - efi_header_end			// SizeOfRawData
@@ -109,7 +107,10 @@ section_table:
 	.long	0					// PointerToLineNumbers
 	.short	0					// NumberOfRelocations
 	.short	0					// NumberOfLineNumbers
-	.long	0xe0500020				// Characteristics
+	.long	IMAGE_SCN_CNT_CODE | \
+		IMAGE_SCN_MEM_EXECUTE | \
+		IMAGE_SCN_MEM_READ | \
+		IMAGE_SCN_MEM_WRITE			// Characteristics
 
 #ifdef CONFIG_DEBUG_EFI
 	/*
@@ -131,7 +132,7 @@ efi_debug_table:
 	.long	0					// TimeDateStamp
 	.short	0					// MajorVersion
 	.short	0					// MinorVersion
-	.long	2					// Type == EFI_IMAGE_DEBUG_TYPE_CODEVIEW
+	.long	IMAGE_DEBUG_TYPE_CODEVIEW		// Type
 	.long	efi_debug_entry_size			// SizeOfData
 	.long	0					// RVA
 	.long	efi_debug_entry - _head			// FileOffset
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index aca9b184035a..055735ba3600 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -81,10 +81,7 @@ _head:
 	.quad	0				// reserved
 	.quad	0				// reserved
 	.quad	0				// reserved
-	.byte	0x41				// Magic number, "ARM\x64"
-	.byte	0x52
-	.byte	0x4d
-	.byte	0x64
+	.ascii	"ARM\x64"			// Magic number
 
 	__EFI_HEADER
 
-- 
2.7.4
