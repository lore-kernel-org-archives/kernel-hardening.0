From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed,  8 Feb 2017 11:55:46 +0000
Message-Id: <1486554947-3964-14-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1486554947-3964-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1486554947-3964-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v2 13/14] arm: efi: split zImage code and data into separate PE/COFF sections
To: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, leif.lindholm@linaro.org
Cc: catalin.marinas@arm.com, linux@armlinux.org.uk, kernel-hardening@lists.openwall.com, labbott@fedoraproject.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

To prevent unintended modifications to the kernel text (malicious or
otherwise) while running the EFI stub, describe the kernel image as
two separate sections: a .text section with read-execute permissions,
covering .text, .rodata, .piggytext and the GOT sections (which the
stub does not care about anyway), and a .data section with read-write
permissions, covering .data and .bss.

This relies on the firmware to actually take the section permission
flags into account, but this is something that is currently being
implemented in EDK2, which means we will likely start seeing it in
the wild between one and two years from now.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/boot/compressed/efi-header.S  | 30 ++++++++++++++------
 arch/arm/boot/compressed/vmlinux.lds.S | 27 +++++++++++++-----
 2 files changed, 41 insertions(+), 16 deletions(-)

diff --git a/arch/arm/boot/compressed/efi-header.S b/arch/arm/boot/compressed/efi-header.S
index 7ff2b2f05e4c..3cf09f7efced 100644
--- a/arch/arm/boot/compressed/efi-header.S
+++ b/arch/arm/boot/compressed/efi-header.S
@@ -57,16 +57,16 @@ optional_header:
 	.short	PE_OPT_MAGIC_PE32			@ PE32 format
 	.byte	0x02					@ MajorLinkerVersion
 	.byte	0x14					@ MinorLinkerVersion
-	.long	_end - __efi_start			@ SizeOfCode
-	.long	0					@ SizeOfInitializedData
+	.long	__pecoff_data_start - __efi_start	@ SizeOfCode
+	.long	__pecoff_data_size			@ SizeOfInitializedData
 	.long	0					@ SizeOfUninitializedData
 	.long	efi_stub_entry - start			@ AddressOfEntryPoint
 	.long	start_offset				@ BaseOfCode
-	.long	0					@ BaseOfData
+	.long	__pecoff_data_start - start		@ BaseOfData
 
 extra_header_fields:
 	.long	0					@ ImageBase
-	.long	SZ_512					@ SectionAlignment
+	.long	SZ_4K					@ SectionAlignment
 	.long	SZ_512					@ FileAlignment
 	.short	0					@ MajorOsVersion
 	.short	0					@ MinorOsVersion
@@ -76,7 +76,7 @@ extra_header_fields:
 	.short	0					@ MinorSubsystemVersion
 	.long	0					@ Win32VersionValue
 
-	.long	_end - start				@ SizeOfImage
+	.long	__pecoff_end - start			@ SizeOfImage
 	.long	start_offset				@ SizeOfHeaders
 	.long	0					@ CheckSum
 	.short	IMAGE_SUBSYSTEM_EFI_APPLICATION		@ Subsystem
@@ -97,9 +97,9 @@ extra_header_fields:
 
 section_table:
 	.ascii	".text\0\0\0"
-	.long	_end - __efi_start			@ VirtualSize
+	.long	__pecoff_data_start - __efi_start	@ VirtualSize
 	.long	__efi_start				@ VirtualAddress
-	.long	_edata - __efi_start			@ SizeOfRawData
+	.long	__pecoff_data_start - __efi_start	@ SizeOfRawData
 	.long	__efi_start				@ PointerToRawData
 	.long	0					@ PointerToRelocations
 	.long	0					@ PointerToLineNumbers
@@ -107,12 +107,24 @@ section_table:
 	.short	0					@ NumberOfLineNumbers
 	.long	IMAGE_SCN_CNT_CODE | \
 		IMAGE_SCN_MEM_READ | \
-		IMAGE_SCN_MEM_WRITE | \
 		IMAGE_SCN_MEM_EXECUTE			@ Characteristics
 
+	.ascii	".data\0\0\0"
+	.long	__pecoff_data_size			@ VirtualSize
+	.long	__pecoff_data_start - start		@ VirtualAddress
+	.long	__pecoff_data_rawsize			@ SizeOfRawData
+	.long	__pecoff_data_start - start		@ PointerToRawData
+	.long	0					@ PointerToRelocations
+	.long	0					@ PointerToLineNumbers
+	.short	0					@ NumberOfRelocations
+	.short	0					@ NumberOfLineNumbers
+	.long	IMAGE_SCN_CNT_INITIALIZED_DATA | \
+		IMAGE_SCN_MEM_READ | \
+		IMAGE_SCN_MEM_WRITE			@ Characteristics
+
 	.set	section_count, (. - section_table) / 40
 
-	.align	9
+	.align	12
 __efi_start:
 #endif
 	.endm
diff --git a/arch/arm/boot/compressed/vmlinux.lds.S b/arch/arm/boot/compressed/vmlinux.lds.S
index 5d50daea466a..144e2f408292 100644
--- a/arch/arm/boot/compressed/vmlinux.lds.S
+++ b/arch/arm/boot/compressed/vmlinux.lds.S
@@ -51,13 +51,6 @@ SECTIONS
     *(.rodata)
     *(.rodata.*)
   }
-  .data : {
-    /*
-     * The EFI stub always executes from RAM, and runs strictly before the
-     * decompressor, so we can make an exception for its r/w data, and keep it
-     */
-    *(.data.efistub)
-  }
   .piggydata : {
     *(.piggydata)
   }
@@ -73,6 +66,23 @@ SECTIONS
   /* ensure the zImage file size is always a multiple of 64 bits */
   /* (without a dummy byte, ld just ignores the empty section) */
   .pad			: { BYTE(0); . = ALIGN(8); }
+
+#ifdef CONFIG_EFI_STUB
+  .data : ALIGN(4096) {
+    __pecoff_data_start = .;
+    /*
+     * The EFI stub always executes from RAM, and runs strictly before the
+     * decompressor, so we can make an exception for its r/w data, and keep it
+     */
+    *(.data.efistub)
+    __pecoff_data_end = .;
+
+    . = ALIGN(512);
+  }
+  __pecoff_data_rawsize = . - ADDR(.data);
+  . = __pecoff_data_end;
+#endif
+
   _edata = .;
 
   _magic_sig = ZIMAGE_MAGIC(0x016f2818);
@@ -87,6 +97,9 @@ SECTIONS
   . = ALIGN(8);		/* the stack must be 64-bit aligned */
   .stack		: { *(.stack) }
 
+  PROVIDE(__pecoff_data_size = ALIGN(512) - ADDR(.data));
+  PROVIDE(__pecoff_end = ALIGN(512));
+
   .stab 0		: { *(.stab) }
   .stabstr 0		: { *(.stabstr) }
   .stab.excl 0		: { *(.stab.excl) }
-- 
2.7.4
