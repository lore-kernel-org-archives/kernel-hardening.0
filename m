From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed,  8 Feb 2017 11:55:39 +0000
Message-Id: <1486554947-3964-7-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1486554947-3964-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1486554947-3964-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v2 06/14] arm64: efi: remove pointless dummy .reloc section
To: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, leif.lindholm@linaro.org
Cc: catalin.marinas@arm.com, linux@armlinux.org.uk, kernel-hardening@lists.openwall.com, labbott@fedoraproject.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

The kernel's EFI PE/COFF header contains a dummy .reloc section, and
an explanatory comment that claims that this is required for the EFI
application loader to accept the Image as a relocatable image (i.e.,
one that can be loaded at any offset and fixed up in place)

This was inherited from the x86 implementation, which has elaborate host
tooling to mangle the PE/COFF header post-link time, and which populates
the .reloc section with a single dummy base relocation. On ARM, no such
tooling exists, and the .reloc section remains empty, and is never even
exposed via the BaseRelocationTable directory entry, which is where the
PE/COFF loader looks for it.

The PE/COFF spec is unclear about relocatable images that do not require
any fixups, but the EDK2 implementation, which is the de facto reference
for PE/COFF in the UEFI space, clearly does not care, and explicitly
mentions (in a comment) that relocatable images with no base relocations
are perfectly fine, as long as they don't have the RELOCS_STRIPPED
attribute set (which is not the case for our PE/COFF image)

So simply remove the .reloc section altogether.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Peter Jones <pjones@redhat.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/kernel/efi-header.S | 22 +-------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

diff --git a/arch/arm64/kernel/efi-header.S b/arch/arm64/kernel/efi-header.S
index 515624bbfcd0..8786d58af2df 100644
--- a/arch/arm64/kernel/efi-header.S
+++ b/arch/arm64/kernel/efi-header.S
@@ -12,7 +12,7 @@
 	.short 	0
 coff_header:
 	.short	0xaa64					// AArch64
-	.short	2					// nr_sections
+	.short	1					// nr_sections
 	.long	0 					// TimeDateStamp
 	.long	0					// PointerToSymbolTable
 	.long	0					// NumberOfSymbols
@@ -71,26 +71,6 @@ extra_header_fields:
 
 	// Section table
 section_table:
-
-	/*
-	 * The EFI application loader requires a relocation section
-	 * because EFI applications must be relocatable.  This is a
-	 * dummy section as far as we are concerned.
-	 */
-	.ascii	".reloc"
-	.byte	0
-	.byte	0					// end of 0 padding of section name
-	.long	0
-	.long	0
-	.long	0					// SizeOfRawData
-	.long	0					// PointerToRawData
-	.long	0					// PointerToRelocations
-	.long	0					// PointerToLineNumbers
-	.short	0					// NumberOfRelocations
-	.short	0					// NumberOfLineNumbers
-	.long	0x42000040				// Characteristics (section flags)
-
-
 	.ascii	".text"
 	.byte	0
 	.byte	0
-- 
2.7.4
