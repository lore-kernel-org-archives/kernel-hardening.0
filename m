Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 14 Jan 2016 17:09:52 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160114170951.GA23942@leverpostej>
References: <1452518355-4606-1-git-send-email-ard.biesheuvel@linaro.org>
 <1452518355-4606-13-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1452518355-4606-13-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] Re: [PATCH v3 12/21] arm64: avoid dynamic relocations in early boot
 code
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, linux-kernel@vger.kernel.org, stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, arnd@arndb.de, marc.zyngier@arm.com, christoffer.dall@linaro.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jan 11, 2016 at 02:19:05PM +0100, Ard Biesheuvel wrote:
> Before implementing KASLR for arm64 by building a self-relocating PIE
> executable, we have to ensure that values we use before the relocation
> routine is executed are not subject to dynamic relocation themselves.
> This applies not only to virtual addresses, but also to values that are
> supplied by the linker at build time and relocated using R_AARCH64_ABS64
> relocations.
> 
> So instead, use assemble time constants, or force the use of static
> relocations by folding the constants into the instructions.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

I think we lose a bit of legibility due to the hoops we jump through for
the new literals. However, it is correct, and I've not managed to come
up with anything nicer.

FWIW:

Reviewed-by: Mark Rutland <mark.rutland@arm.com>

Thanks,
Mark.

> ---
>  arch/arm64/kernel/efi-entry.S |  2 +-
>  arch/arm64/kernel/head.S      | 39 +++++++++++++-------
>  2 files changed, 27 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/arm64/kernel/efi-entry.S b/arch/arm64/kernel/efi-entry.S
> index a773db92908b..f82036e02485 100644
> --- a/arch/arm64/kernel/efi-entry.S
> +++ b/arch/arm64/kernel/efi-entry.S
> @@ -61,7 +61,7 @@ ENTRY(entry)
>  	 */
>  	mov	x20, x0		// DTB address
>  	ldr	x0, [sp, #16]	// relocated _text address
> -	ldr	x21, =stext_offset
> +	movz	x21, #:abs_g0:stext_offset
>  	add	x21, x0, x21
>  
>  	/*
> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> index 211f75e673f4..5dc8079cef77 100644
> --- a/arch/arm64/kernel/head.S
> +++ b/arch/arm64/kernel/head.S
> @@ -78,12 +78,11 @@
>   * in the entry routines.
>   */
>  	__HEAD
> -
> +_head:
>  	/*
>  	 * DO NOT MODIFY. Image header expected by Linux boot-loaders.
>  	 */
>  #ifdef CONFIG_EFI
> -efi_head:
>  	/*
>  	 * This add instruction has no meaningful effect except that
>  	 * its opcode forms the magic "MZ" signature required by UEFI.
> @@ -105,14 +104,14 @@ efi_head:
>  	.byte	0x4d
>  	.byte	0x64
>  #ifdef CONFIG_EFI
> -	.long	pe_header - efi_head		// Offset to the PE header.
> +	.long	pe_header - _head		// Offset to the PE header.
>  #else
>  	.word	0				// reserved
>  #endif
>  
>  #ifdef CONFIG_EFI
>  	.globl	__efistub_stext_offset
> -	.set	__efistub_stext_offset, stext - efi_head
> +	.set	__efistub_stext_offset, stext - _head
>  	.align 3
>  pe_header:
>  	.ascii	"PE"
> @@ -135,7 +134,7 @@ optional_header:
>  	.long	_end - stext			// SizeOfCode
>  	.long	0				// SizeOfInitializedData
>  	.long	0				// SizeOfUninitializedData
> -	.long	__efistub_entry - efi_head	// AddressOfEntryPoint
> +	.long	__efistub_entry - _head		// AddressOfEntryPoint
>  	.long	__efistub_stext_offset		// BaseOfCode
>  
>  extra_header_fields:
> @@ -150,7 +149,7 @@ extra_header_fields:
>  	.short	0				// MinorSubsystemVersion
>  	.long	0				// Win32VersionValue
>  
> -	.long	_end - efi_head			// SizeOfImage
> +	.long	_end - _head			// SizeOfImage
>  
>  	// Everything before the kernel image is considered part of the header
>  	.long	__efistub_stext_offset		// SizeOfHeaders
> @@ -230,11 +229,13 @@ ENTRY(stext)
>  	 * On return, the CPU will be ready for the MMU to be turned on and
>  	 * the TCR will have been set.
>  	 */
> -	ldr	x27, =__mmap_switched		// address to jump to after
> +	ldr	x27, 0f				// address to jump to after
>  						// MMU has been enabled
>  	adr_l	lr, __enable_mmu		// return (PIC) address
>  	b	__cpu_setup			// initialise processor
>  ENDPROC(stext)
> +	.align	3
> +0:	.quad	__mmap_switched - (_head - TEXT_OFFSET) + KIMAGE_VADDR
>  
>  /*
>   * Preserve the arguments passed by the bootloader in x0 .. x3
> @@ -402,7 +403,8 @@ __create_page_tables:
>  	mov	x0, x26				// swapper_pg_dir
>  	ldr	x5, =KIMAGE_VADDR
>  	create_pgd_entry x0, x5, x3, x6
> -	ldr	x6, =KERNEL_END			// __va(KERNEL_END)
> +	ldr	w6, kernel_img_size
> +	add	x6, x6, x5
>  	mov	x3, x24				// phys offset
>  	create_block_map x0, x7, x3, x5, x6
>  
> @@ -419,6 +421,9 @@ __create_page_tables:
>  	mov	lr, x27
>  	ret
>  ENDPROC(__create_page_tables)
> +
> +kernel_img_size:
> +	.long	_end - (_head - TEXT_OFFSET)
>  	.ltorg
>  
>  /*
> @@ -426,6 +431,10 @@ ENDPROC(__create_page_tables)
>   */
>  	.set	initial_sp, init_thread_union + THREAD_START_SP
>  __mmap_switched:
> +	adr_l	x8, vectors			// load VBAR_EL1 with virtual
> +	msr	vbar_el1, x8			// vector table address
> +	isb
> +
>  	// Clear BSS
>  	adr_l	x0, __bss_start
>  	mov	x1, xzr
> @@ -612,13 +621,19 @@ ENTRY(secondary_startup)
>  	adrp	x26, swapper_pg_dir
>  	bl	__cpu_setup			// initialise processor
>  
> -	ldr	x21, =secondary_data
> -	ldr	x27, =__secondary_switched	// address to jump to after enabling the MMU
> +	ldr	x8, =KIMAGE_VADDR
> +	ldr	w9, 0f
> +	sub	x27, x8, w9, sxtw		// address to jump to after enabling the MMU
>  	b	__enable_mmu
>  ENDPROC(secondary_startup)
> +0:	.long	(_text - TEXT_OFFSET) - __secondary_switched
>  
>  ENTRY(__secondary_switched)
> -	ldr	x0, [x21]			// get secondary_data.stack
> +	adr_l	x5, vectors
> +	msr	vbar_el1, x5
> +	isb
> +
> +	ldr_l	x0, secondary_data		// get secondary_data.stack
>  	mov	sp, x0
>  	and	x0, x0, #~(THREAD_SIZE - 1)
>  	msr	sp_el0, x0			// save thread_info
> @@ -643,8 +658,6 @@ __enable_mmu:
>  	ubfx	x2, x1, #ID_AA64MMFR0_TGRAN_SHIFT, 4
>  	cmp	x2, #ID_AA64MMFR0_TGRAN_SUPPORTED
>  	b.ne	__no_granule_support
> -	ldr	x5, =vectors
> -	msr	vbar_el1, x5
>  	msr	ttbr0_el1, x25			// load TTBR0
>  	msr	ttbr1_el1, x26			// load TTBR1
>  	isb
> -- 
> 2.5.0
> 
