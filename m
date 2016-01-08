Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 8 Jan 2016 12:36:15 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160108123614.GC3097@leverpostej>
References: <1451489172-17420-1-git-send-email-ard.biesheuvel@linaro.org>
 <1451489172-17420-13-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1451489172-17420-13-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] Re: [PATCH v2 12/13] arm64: add support for relocatable kernel
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, linux-kernel@vger.kernel.org, stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, arnd@arndb.de, marc.zyngier@arm.com, christoffer.dall@linaro.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Dec 30, 2015 at 04:26:11PM +0100, Ard Biesheuvel wrote:
> This adds support for runtime relocation of the kernel Image, by
> building it as a PIE (ET_DYN) executable and applying the dynamic
> relocations in the early boot code.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  Documentation/arm64/booting.txt |  3 +-
>  arch/arm64/Kconfig              | 13 ++++
>  arch/arm64/Makefile             |  6 +-
>  arch/arm64/include/asm/memory.h |  3 +
>  arch/arm64/kernel/head.S        | 75 +++++++++++++++++++-
>  arch/arm64/kernel/setup.c       | 22 +++---
>  arch/arm64/kernel/vmlinux.lds.S |  9 +++
>  scripts/sortextable.c           |  4 +-
>  8 files changed, 117 insertions(+), 18 deletions(-)

[...]

> +#ifdef CONFIG_ARM64_RELOCATABLE_KERNEL
> +
> +#define R_AARCH64_RELATIVE	0x403
> +#define R_AARCH64_ABS64		0x101

Let's not duplicate asm/elf.h.

I have a patch to split the reloc types out into a separate header we
can reuse from assembly -- I'll send that momentarily. We can add
R_AARCH64_RELATIVE atop of that.

> +
> +	/*
> +	 * Iterate over each entry in the relocation table, and apply the
> +	 * relocations in place.
> +	 */
> +	adr_l	x8, __dynsym_start		// start of symbol table
> +	adr_l	x9, __reloc_start		// start of reloc table
> +	adr_l	x10, __reloc_end		// end of reloc table
> +
> +0:	cmp	x9, x10
> +	b.hs	2f
> +	ldp	x11, x12, [x9], #24
> +	ldr	x13, [x9, #-8]
> +	cmp	w12, #R_AARCH64_RELATIVE
> +	b.ne	1f
> +	add	x13, x13, x23			// relocate
> +	str	x13, [x11, x23]
> +	b	0b
> +
> +1:	cmp	w12, #R_AARCH64_ABS64
> +	b.ne	0b
> +	add	x12, x12, x12, lsl #1		// symtab offset: 24x top word
> +	add	x12, x8, x12, lsr #(32 - 3)	// ... shifted into bottom word
> +	ldrsh	w14, [x12, #6]			// Elf64_Sym::st_shndx
> +	ldr	x15, [x12, #8]			// Elf64_Sym::st_value
> +	cmp	w14, #-0xf			// SHN_ABS (0xfff1) ?
> +	add	x14, x15, x23			// relocate
> +	csel	x15, x14, x15, ne
> +	add	x15, x13, x15
> +	str	x15, [x11, x23]
> +	b	0b

We need to clean each of these relocated instructions to the PoU to be
visible for I-cache fetches.

As this is normal-cacheable we can post the maintenance with a DC CVAU
immediately after the store (no barriers necessary), and rely on the DSB
at 2f to complete all of those.

> +
> +2:	adr_l	x8, kimage_vaddr		// make relocated kimage_vaddr
> +	dc	cvac, x8			// value visible to secondaries
> +	dsb	sy				// with MMU off

Then we need:

	ic	iallu
	dsb	nsh
	isb

To make sure the I-side is consistent with the PoU.

As secondaries will do similarly in __enable_mmu we don't need to add
any code for them.

> +#endif
> +
>  	adr_l	sp, initial_sp, x4
>  	str_l	x21, __fdt_pointer, x5		// Save FDT pointer
>  
> -	ldr	x0, =KIMAGE_VADDR		// Save the offset between
> +	ldr_l	x0, kimage_vaddr		// Save the offset between
>  	sub	x24, x0, x24			// the kernel virtual and
>  	str_l	x24, kimage_voffset, x0		// physical mappings
>  
> @@ -462,6 +527,10 @@ ENDPROC(__mmap_switched)
>   * hotplug and needs to have the same protections as the text region
>   */
>  	.section ".text","ax"
> +
> +ENTRY(kimage_vaddr)
> +	.quad		_text - TEXT_OFFSET
> +
>  /*
>   * If we're fortunate enough to boot at EL2, ensure that the world is
>   * sane before dropping to EL1.
> @@ -622,7 +691,7 @@ ENTRY(secondary_startup)
>  	adrp	x26, swapper_pg_dir
>  	bl	__cpu_setup			// initialise processor
>  
> -	ldr	x8, =KIMAGE_VADDR
> +	ldr	x8, kimage_vaddr
>  	ldr	w9, 0f
>  	sub	x27, x8, w9, sxtw		// address to jump to after enabling the MMU
>  	b	__enable_mmu
> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
> index 96177a7c0f05..2faee6042e99 100644
> --- a/arch/arm64/kernel/setup.c
> +++ b/arch/arm64/kernel/setup.c
> @@ -292,16 +292,15 @@ u64 __cpu_logical_map[NR_CPUS] = { [0 ... NR_CPUS-1] = INVALID_HWID };
>  
>  void __init setup_arch(char **cmdline_p)
>  {
> -	static struct vm_struct vmlinux_vm __initdata = {
> -		.addr		= (void *)KIMAGE_VADDR,
> -		.size		= 0,
> -		.flags		= VM_IOREMAP,
> -		.caller		= setup_arch,
> -	};
> -
> -	vmlinux_vm.size = round_up((unsigned long)_end - KIMAGE_VADDR,
> -				   1 << SWAPPER_BLOCK_SHIFT);
> -	vmlinux_vm.phys_addr = __pa(KIMAGE_VADDR);
> +	static struct vm_struct vmlinux_vm __initdata;
> +
> +	vmlinux_vm.addr = (void *)kimage_vaddr;
> +	vmlinux_vm.size = round_up((u64)_end - kimage_vaddr,
> +				   SWAPPER_BLOCK_SIZE);
> +	vmlinux_vm.phys_addr = __pa(kimage_vaddr);
> +	vmlinux_vm.flags = VM_IOREMAP;
> +	vmlinux_vm.caller = setup_arch;
> +
>  	vm_area_add_early(&vmlinux_vm);
>  
>  	pr_info("Boot CPU: AArch64 Processor [%08x]\n", read_cpuid_id());
> @@ -367,7 +366,8 @@ void __init setup_arch(char **cmdline_p)
>  	conswitchp = &dummy_con;
>  #endif
>  #endif
> -	if (boot_args[1] || boot_args[2] || boot_args[3]) {
> +	if ((!IS_ENABLED(CONFIG_ARM64_RELOCATABLE_KERNEL) && boot_args[1]) ||
> +	    boot_args[2] || boot_args[3]) {
>  		pr_err("WARNING: x1-x3 nonzero in violation of boot protocol:\n"
>  			"\tx1: %016llx\n\tx2: %016llx\n\tx3: %016llx\n"
>  			"This indicates a broken bootloader or old kernel\n",

At this point it may make sense to split this out into a separate
function. If the handshake is more involved we'll need more code to
verify this, and it'd be nice to split that from setup_arch.

> diff --git a/arch/arm64/kernel/vmlinux.lds.S
> b/arch/arm64/kernel/vmlinux.lds.S
> index f935f082188d..cc1486039338 100644
> --- a/arch/arm64/kernel/vmlinux.lds.S
> +++ b/arch/arm64/kernel/vmlinux.lds.S
> @@ -148,6 +148,15 @@ SECTIONS
>  	.altinstr_replacement : {
>  		*(.altinstr_replacement)
>  	}
> +	.rela : ALIGN(8) {
> +		__reloc_start = .;
> +		*(.rela .rela*)
> +		__reloc_end = .;
> +	}
> +	.dynsym : ALIGN(8) {
> +		__dynsym_start = .;
> +		*(.dynsym)
> +	}
>  
>  	. = ALIGN(PAGE_SIZE);
>  	__init_end = .;
> diff --git a/scripts/sortextable.c b/scripts/sortextable.c
> index af247c70fb66..5ecbedefdb0f 100644
> --- a/scripts/sortextable.c
> +++ b/scripts/sortextable.c
> @@ -266,9 +266,9 @@ do_file(char const *const fname)
>  		break;
>  	}  /* end switch */
>  	if (memcmp(ELFMAG, ehdr->e_ident, SELFMAG) != 0
> -	||  r2(&ehdr->e_type) != ET_EXEC
> +	|| (r2(&ehdr->e_type) != ET_EXEC && r2(&ehdr->e_type) != ET_DYN)
>  	||  ehdr->e_ident[EI_VERSION] != EV_CURRENT) {
> -		fprintf(stderr, "unrecognized ET_EXEC file %s\n", fname);
> +		fprintf(stderr, "unrecognized ET_EXEC/ET_DYN file %s\n", fname);
>  		fail_file();
>  	}

This change should probably be a preparatory patch.

Otherwise, looks good!

Thanks,
Mark.
