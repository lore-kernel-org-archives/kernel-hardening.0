Date: Tue, 14 Feb 2017 15:57:27 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170214155727.GF23718@leverpostej>
References: <1486844586-26135-1-git-send-email-ard.biesheuvel@linaro.org>
 <1486844586-26135-6-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1486844586-26135-6-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] Re: [PATCH v2 5/5] arm64: mmu: apply strict permissions to
 .init.text and .init.data
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, will.deacon@arm.com, labbott@fedoraproject.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, andre.przywara@arm.com, Suzuki.Poulose@arm.com, james.morse@arm.com, keescook@chromium.org, kernel-hardening@lists.openwall.com, nd@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Feb 11, 2017 at 08:23:06PM +0000, Ard Biesheuvel wrote:
> To avoid having mappings that are writable and executable at the same
> time, split the init region into a .init.text region that is mapped
> read-only, and a .init.data region that is mapped non-executable.
> 
> This is possible now that the alternative patching occurs via the linear
> mapping, and the linear alias of the init region is always mapped writable
> (but never executable).
> 
> Since the alternatives descriptions themselves are read-only data, move
> those into the .init.text region.
> 
> Reviewed-by: Laura Abbott <labbott@redhat.com>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

This generally looks good.

As with my comment on patch 4, we might want to allow .init.text to be
mapped writeable for the sake of external debuggers.

Thanks,
Mark.

> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index e97f1ce967ec..c53c43b4ed3f 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -479,12 +479,16 @@ static void __init map_kernel_segment(pgd_t *pgd, void *va_start, void *va_end,
>   */
>  static void __init map_kernel(pgd_t *pgd)
>  {
> -	static struct vm_struct vmlinux_text, vmlinux_rodata, vmlinux_init, vmlinux_data;
> +	static struct vm_struct vmlinux_text, vmlinux_rodata, vmlinux_inittext,
> +				vmlinux_initdata, vmlinux_data;
>  
>  	map_kernel_segment(pgd, _text, _etext, PAGE_KERNEL_ROX, &vmlinux_text);
> -	map_kernel_segment(pgd, __start_rodata, __init_begin, PAGE_KERNEL, &vmlinux_rodata);
> -	map_kernel_segment(pgd, __init_begin, __init_end, PAGE_KERNEL_EXEC,
> -			   &vmlinux_init);
> +	map_kernel_segment(pgd, __start_rodata, __inittext_begin, PAGE_KERNEL,
> +			   &vmlinux_rodata);
> +	map_kernel_segment(pgd, __inittext_begin, __inittext_end, PAGE_KERNEL_ROX,
> +			   &vmlinux_inittext);
> +	map_kernel_segment(pgd, __initdata_begin, __initdata_end, PAGE_KERNEL,
> +			   &vmlinux_initdata);
>  	map_kernel_segment(pgd, _data, _end, PAGE_KERNEL, &vmlinux_data);
>  
>  	if (!pgd_val(*pgd_offset_raw(pgd, FIXADDR_START))) {
> -- 
> 2.7.4
> 
