Date: Tue, 7 Feb 2017 13:30:57 -0500
From: Peter Jones <pjones@redhat.com>
Message-ID: <20170207183056.42gqqg2jp32jexmy@redhat.com>
References: <1486398275-3966-1-git-send-email-ard.biesheuvel@linaro.org>
 <1486398275-3966-6-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1486398275-3966-6-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] Re: [PATCH 5/7] arm64: efi: remove pointless dummy .reloc section
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, labbott@fedoraproject.org, kernel-hardening@lists.openwall.com, leif.lindholm@linaro.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 06, 2017 at 04:24:33PM +0000, Ard Biesheuvel wrote:
> The kernel's EFI PE/COFF header contains a dummy .reloc section, and
> an explanatory comment that claims that this is required for the EFI
> application loader to accept the Image as a relocatable image (i.e.,
> one that can be loaded at any offset and fixed up in place)
> 
> This was inherited from the x86 implementation, which has elaborate host
> tooling to mangle the PE/COFF header post-link time, and which populates
> the .reloc section with a single dummy base relocation. On ARM, no such
> tooling exists, and the .reloc section remains empty, and is never even
> exposed via the BaseRelocationTable directory entry, which is where the
> PE/COFF loader looks for it.
> 
> The PE/COFF spec is unclear about relocatable images that do not require
> any fixups, but the EDK2 implementation, which is the de facto reference
> for PE/COFF in the UEFI space, clearly does not care, and explicitly
> mentions (in a comment) that relocatable images with no base relocations
> are perfectly fine, as long as they don't have the RELOCS_STRIPPED
> attribute set (which is not the case for our PE/COFF image)
> 
> So simply remove the .reloc section altogether.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Looks completely reasonable to me.

Acked-by: Peter Jones <pjones@redhat.com>

> ---
>  arch/arm64/kernel/efi-header.S | 22 +-------------------
>  1 file changed, 1 insertion(+), 21 deletions(-)
> 
> diff --git a/arch/arm64/kernel/efi-header.S b/arch/arm64/kernel/efi-header.S
> index 74a25c09a1b8..35b11654ecc5 100644
> --- a/arch/arm64/kernel/efi-header.S
> +++ b/arch/arm64/kernel/efi-header.S
> @@ -37,7 +37,7 @@ pe_header:
>  	.short 	0
>  coff_header:
>  	.short	0xaa64					// AArch64
> -	.short	2					// nr_sections
> +	.short	1					// nr_sections
>  	.long	0 					// TimeDateStamp
>  	.long	0					// PointerToSymbolTable
>  	.long	1					// NumberOfSymbols
> @@ -96,26 +96,6 @@ extra_header_fields:
>  
>  	// Section table
>  section_table:
> -
> -	/*
> -	 * The EFI application loader requires a relocation section
> -	 * because EFI applications must be relocatable.  This is a
> -	 * dummy section as far as we are concerned.
> -	 */
> -	.ascii	".reloc"
> -	.byte	0
> -	.byte	0					// end of 0 padding of section name
> -	.long	0
> -	.long	0
> -	.long	0					// SizeOfRawData
> -	.long	0					// PointerToRawData
> -	.long	0					// PointerToRelocations
> -	.long	0					// PointerToLineNumbers
> -	.short	0					// NumberOfRelocations
> -	.short	0					// NumberOfLineNumbers
> -	.long	0x42100040				// Characteristics (section flags)
> -
> -
>  	.ascii	".text"
>  	.byte	0
>  	.byte	0
> -- 
> 2.7.4
> 

-- 
  Peter
