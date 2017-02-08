From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed,  8 Feb 2017 11:55:41 +0000
Message-Id: <1486554947-3964-9-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1486554947-3964-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1486554947-3964-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v2 08/14] arm64: efi: split Image code and data into separate PE/COFF sections
To: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, leif.lindholm@linaro.org
Cc: catalin.marinas@arm.com, linux@armlinux.org.uk, kernel-hardening@lists.openwall.com, labbott@fedoraproject.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

To prevent unintended modifications to the kernel text (malicious or
otherwise) while running the EFI stub, describe the kernel image as
two separate sections: a .text section with read-execute permissions,
covering .text, .rodata and .init.text, and a .data section with
read-write permissions, covering .init.data, .data and .bss.

This relies on the firmware to actually take the section permission
flags into account, but this is something that is currently being
implemented in EDK2, which means we will likely start seeing it in
the wild between one and two years from now.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/kernel/efi-header.S  | 23 +++++++++++++++-----
 arch/arm64/kernel/vmlinux.lds.S |  5 +++++
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kernel/efi-header.S b/arch/arm64/kernel/efi-header.S
index 7637226ea9ca..5870bd611498 100644
--- a/arch/arm64/kernel/efi-header.S
+++ b/arch/arm64/kernel/efi-header.S
@@ -27,8 +27,8 @@ optional_header:
 	.short	PE_OPT_MAGIC_PE32PLUS			// PE32+ format
 	.byte	0x02					// MajorLinkerVersion
 	.byte	0x14					// MinorLinkerVersion
-	.long	_end - efi_header_end			// SizeOfCode
-	.long	0					// SizeOfInitializedData
+	.long	__pecoff_data_start - efi_header_end	// SizeOfCode
+	.long	__pecoff_data_size			// SizeOfInitializedData
 	.long	0					// SizeOfUninitializedData
 	.long	__efistub_entry - _head			// AddressOfEntryPoint
 	.long	efi_header_end - _head			// BaseOfCode
@@ -74,9 +74,9 @@ extra_header_fields:
 	// Section table
 section_table:
 	.ascii	".text\0\0\0"
-	.long	_end - efi_header_end			// VirtualSize
+	.long	__pecoff_data_start - efi_header_end	// VirtualSize
 	.long	efi_header_end - _head			// VirtualAddress
-	.long	_edata - efi_header_end			// SizeOfRawData
+	.long	__pecoff_data_start - efi_header_end	// SizeOfRawData
 	.long	efi_header_end - _head			// PointerToRawData
 
 	.long	0					// PointerToRelocations
@@ -84,7 +84,20 @@ section_table:
 	.short	0					// NumberOfRelocations
 	.short	0					// NumberOfLineNumbers
 	.long	IMAGE_SCN_CNT_CODE | \
-		IMAGE_SCN_MEM_EXECUTE | \
+		IMAGE_SCN_MEM_READ | \
+		IMAGE_SCN_MEM_EXECUTE			// Characteristics
+
+	.ascii	".data\0\0\0"
+	.long	__pecoff_data_size			// VirtualSize
+	.long	__pecoff_data_start - _head		// VirtualAddress
+	.long	__pecoff_data_rawsize			// SizeOfRawData
+	.long	__pecoff_data_start - _head		// PointerToRawData
+
+	.long	0					// PointerToRelocations
+	.long	0					// PointerToLineNumbers
+	.short	0					// NumberOfRelocations
+	.short	0					// NumberOfLineNumbers
+	.long	IMAGE_SCN_CNT_INITIALIZED_DATA | \
 		IMAGE_SCN_MEM_READ | \
 		IMAGE_SCN_MEM_WRITE			// Characteristics
 
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index b8deffa9e1bf..a93cc2b6f50b 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -149,6 +149,9 @@ SECTIONS
 		ARM_EXIT_KEEP(EXIT_TEXT)
 	}
 
+	. = ALIGN(SZ_4K);
+	__pecoff_data_start = .;
+
 	.init.data : {
 		INIT_DATA
 		INIT_SETUP(16)
@@ -206,6 +209,7 @@ SECTIONS
 	}
 
 	PECOFF_EDATA_PADDING
+	__pecoff_data_rawsize = ABSOLUTE(. - __pecoff_data_start);
 	_edata = .;
 
 	BSS_SECTION(0, 0, 0)
@@ -221,6 +225,7 @@ SECTIONS
 	. += RESERVED_TTBR0_SIZE;
 #endif
 
+	__pecoff_data_size = ABSOLUTE(. - __pecoff_data_start);
 	_end = .;
 
 	STABS_DEBUG
-- 
2.7.4
