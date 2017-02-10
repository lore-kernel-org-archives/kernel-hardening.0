Date: Fri, 10 Feb 2017 10:19:23 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170210101923.GE28753@leverpostej>
References: <1486554947-3964-1-git-send-email-ard.biesheuvel@linaro.org>
 <1486554947-3964-8-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1486554947-3964-8-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] Re: [PATCH v2 07/14] arm64: efi: replace open coded constants with
 symbolic ones
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, leif.lindholm@linaro.org, catalin.marinas@arm.com, linux@armlinux.org.uk, kernel-hardening@lists.openwall.com, labbott@fedoraproject.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 08, 2017 at 11:55:40AM +0000, Ard Biesheuvel wrote:
> Replace open coded constants with symbolic ones throughout the
> Image and the EFI headers. No binary level changes are intended.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Acked-by: Mark Rutland <mark.rutland@arm.com>

Thanks,
Mark.

> ---
>  arch/arm64/kernel/efi-header.S | 38 +++++++++++---------
>  1 file changed, 21 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/arm64/kernel/efi-header.S b/arch/arm64/kernel/efi-header.S
> index 8786d58af2df..7637226ea9ca 100644
> --- a/arch/arm64/kernel/efi-header.S
> +++ b/arch/arm64/kernel/efi-header.S
> @@ -7,22 +7,24 @@
>   * published by the Free Software Foundation.
>   */
>  
> +#include <linux/pe.h>
> +#include <linux/sizes.h>
> +
>  	.macro	__EFI_PE_HEADER
> -	.ascii	"PE"
> -	.short 	0
> +	.long	PE_MAGIC
>  coff_header:
> -	.short	0xaa64					// AArch64
> -	.short	1					// nr_sections
> +	.short	IMAGE_FILE_MACHINE_ARM64		// Machine
> +	.short	section_count				// NumberOfSections
>  	.long	0 					// TimeDateStamp
>  	.long	0					// PointerToSymbolTable
>  	.long	0					// NumberOfSymbols
>  	.short	section_table - optional_header		// SizeOfOptionalHeader
> -	.short	0x206					// Characteristics.
> -							// IMAGE_FILE_DEBUG_STRIPPED |
> -							// IMAGE_FILE_EXECUTABLE_IMAGE |
> -							// IMAGE_FILE_LINE_NUMS_STRIPPED
> +	.short	IMAGE_FILE_DEBUG_STRIPPED | \
> +		IMAGE_FILE_EXECUTABLE_IMAGE | \
> +		IMAGE_FILE_LINE_NUMS_STRIPPED		// Characteristics
> +
>  optional_header:
> -	.short	0x20b					// PE32+ format
> +	.short	PE_OPT_MAGIC_PE32PLUS			// PE32+ format
>  	.byte	0x02					// MajorLinkerVersion
>  	.byte	0x14					// MinorLinkerVersion
>  	.long	_end - efi_header_end			// SizeOfCode
> @@ -33,7 +35,7 @@ optional_header:
>  
>  extra_header_fields:
>  	.quad	0					// ImageBase
> -	.long	0x1000					// SectionAlignment
> +	.long	SZ_4K					// SectionAlignment
>  	.long	PECOFF_FILE_ALIGNMENT			// FileAlignment
>  	.short	0					// MajorOperatingSystemVersion
>  	.short	0					// MinorOperatingSystemVersion
> @@ -48,7 +50,7 @@ extra_header_fields:
>  	// Everything before the kernel image is considered part of the header
>  	.long	efi_header_end - _head			// SizeOfHeaders
>  	.long	0					// CheckSum
> -	.short	0xa					// Subsystem (EFI application)
> +	.short	IMAGE_SUBSYSTEM_EFI_APPLICATION		// Subsystem
>  	.short	0					// DllCharacteristics
>  	.quad	0					// SizeOfStackReserve
>  	.quad	0					// SizeOfStackCommit
> @@ -71,10 +73,7 @@ extra_header_fields:
>  
>  	// Section table
>  section_table:
> -	.ascii	".text"
> -	.byte	0
> -	.byte	0
> -	.byte	0        				// end of 0 padding of section name
> +	.ascii	".text\0\0\0"
>  	.long	_end - efi_header_end			// VirtualSize
>  	.long	efi_header_end - _head			// VirtualAddress
>  	.long	_edata - efi_header_end			// SizeOfRawData
> @@ -84,7 +83,12 @@ section_table:
>  	.long	0					// PointerToLineNumbers
>  	.short	0					// NumberOfRelocations
>  	.short	0					// NumberOfLineNumbers
> -	.long	0xe0000020				// Characteristics
> +	.long	IMAGE_SCN_CNT_CODE | \
> +		IMAGE_SCN_MEM_EXECUTE | \
> +		IMAGE_SCN_MEM_READ | \
> +		IMAGE_SCN_MEM_WRITE			// Characteristics
> +
> +	.set	section_count, (. - section_table) / 40
>  
>  #ifdef CONFIG_DEBUG_EFI
>  	/*
> @@ -106,7 +110,7 @@ efi_debug_table:
>  	.long	0					// TimeDateStamp
>  	.short	0					// MajorVersion
>  	.short	0					// MinorVersion
> -	.long	2					// Type == EFI_IMAGE_DEBUG_TYPE_CODEVIEW
> +	.long	IMAGE_DEBUG_TYPE_CODEVIEW		// Type
>  	.long	efi_debug_entry_size			// SizeOfData
>  	.long	0					// RVA
>  	.long	efi_debug_entry - _head			// FileOffset
> -- 
> 2.7.4
> 
