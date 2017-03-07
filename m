Date: Tue, 7 Mar 2017 14:21:40 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170307142140.GB3514@leverpostej>
References: <1488637848-13588-1-git-send-email-ard.biesheuvel@linaro.org>
 <1488637848-13588-6-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1488637848-13588-6-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] Re: [PATCH v4 5/6] arm64: mmu: apply strict permissions to
 .init.text and .init.data
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, catalin.marinas@arm.com, will.deacon@arm.com, labbott@fedoraproject.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, keescook@chromium.org, andre.przywara@arm.com, james.morse@arm.com, suzuki.poulose@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Mar 04, 2017 at 02:30:47PM +0000, Ard Biesheuvel wrote:
> diff --git a/arch/arm64/include/asm/sections.h b/arch/arm64/include/asm/sections.h
> index 4e7e7067afdb..22582819b2e5 100644
> --- a/arch/arm64/include/asm/sections.h
> +++ b/arch/arm64/include/asm/sections.h
> @@ -24,7 +24,8 @@ extern char __hibernate_exit_text_start[], __hibernate_exit_text_end[];
>  extern char __hyp_idmap_text_start[], __hyp_idmap_text_end[];
>  extern char __hyp_text_start[], __hyp_text_end[];
>  extern char __idmap_text_start[], __idmap_text_end[];
> +extern char __initdata_begin[], __initdata_end[];
> +extern char __inittext_begin[], __inittext_end[];
>  extern char __irqentry_text_start[], __irqentry_text_end[];
>  extern char __mmuoff_data_start[], __mmuoff_data_end[];
> -
>  #endif /* __ASM_SECTIONS_H */

Unintended whitespace change?

Please restore the line above the endif. 

> diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
> index b8deffa9e1bf..2c93d259046c 100644
> --- a/arch/arm64/kernel/vmlinux.lds.S
> +++ b/arch/arm64/kernel/vmlinux.lds.S
> @@ -143,12 +143,27 @@ SECTIONS
>  
>  	. = ALIGN(SEGMENT_ALIGN);
>  	__init_begin = .;
> +	__inittext_begin = .;
>  
>  	INIT_TEXT_SECTION(8)
>  	.exit.text : {
>  		ARM_EXIT_KEEP(EXIT_TEXT)
>  	}
>  
> +	. = ALIGN(4);
> +	.altinstructions : {
> +		__alt_instructions = .;
> +		*(.altinstructions)
> +		__alt_instructions_end = .;
> +	}
> +	.altinstr_replacement : {
> +		*(.altinstr_replacement)
> +	}
> +
> +	. = ALIGN(PAGE_SIZE);

Arguably this should be SEGMENT_ALIGN for consitency, but given this is
just .init* this should be fine.

> +	__inittext_end = .;
> +	__initdata_begin = .;
> +
>  	.init.data : {
>  		INIT_DATA
>  		INIT_SETUP(16)

[...]

> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index edd982f88714..0612573ef869 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -459,14 +459,18 @@ early_param("rodata", parse_rodata);
>   */
>  static void __init map_kernel(pgd_t *pgd)
>  {
> -	static struct vm_struct vmlinux_text, vmlinux_rodata, vmlinux_init, vmlinux_data;
> +	static struct vm_struct vmlinux_text, vmlinux_rodata, vmlinux_inittext,
> +				vmlinux_initdata, vmlinux_data;
>  
>  	pgprot_t text_prot = rodata_enabled ? PAGE_KERNEL_ROX : PAGE_KERNEL_EXEC;
>  
>  	map_kernel_segment(pgd, _text, _etext, text_prot, &vmlinux_text);
> -	map_kernel_segment(pgd, __start_rodata, __init_begin, PAGE_KERNEL, &vmlinux_rodata);
> -	map_kernel_segment(pgd, __init_begin, __init_end, PAGE_KERNEL_EXEC,
> -			   &vmlinux_init);
> +	map_kernel_segment(pgd, __start_rodata, __inittext_begin, PAGE_KERNEL,
> +			   &vmlinux_rodata);
> +	map_kernel_segment(pgd, __inittext_begin, __inittext_end, text_prot,
> +			   &vmlinux_inittext);
> +	map_kernel_segment(pgd, __initdata_begin, __initdata_end, PAGE_KERNEL,
> +			   &vmlinux_initdata);
>  	map_kernel_segment(pgd, _data, _end, PAGE_KERNEL, &vmlinux_data);


This all look fine, given text_prot is used for the init text.

With the whitespace restored:

Reviewed-by: Mark Rutland <mark.rutland@arm.com>

Mark.
