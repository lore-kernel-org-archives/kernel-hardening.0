Subject: Re: [PATCH 1/4] arm64/mm: pass swapper_pg_dir as an argument to
 __enable_mmu()
References: <20180601080833.11762-1-yaojun8558363@gmail.com>
From: James Morse <james.morse@arm.com>
Message-ID: <9e62fa1e-5322-7818-a6b9-da07d8e397da@arm.com>
Date: Fri, 1 Jun 2018 13:35:38 +0100
MIME-Version: 1.0
In-Reply-To: <20180601080833.11762-1-yaojun8558363@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Jun Yao <yaojun8558363@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, greg@kroah.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Jun Yao,

On 01/06/18 09:08, Jun Yao wrote:
> Introduce __pa_swapper_pg_dir to save physical address of
> swapper_pg_dir. And pass it as an argument to __enable_mmu().


> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> index b0853069702f..e3bb44b4b6c6 100644
> --- a/arch/arm64/kernel/head.S
> +++ b/arch/arm64/kernel/head.S
> @@ -706,6 +706,8 @@ secondary_startup:
>  	 * Common entry point for secondary CPUs.
>  	 */
>  	bl	__cpu_setup			// initialise processor
> +	adrp    x25, idmap_pg_dir
> +	ldr_l   x26, __pa_swapper_pg_dir
>  	bl	__enable_mmu
>  	ldr	x8, =__secondary_switched
>  	br	x8

'__pa_swapper_pg_dir' here is read with the MMU off, but you write it with the
MMU on. To make this safe, you need to clean this value to the 'PoC' each time
you write it, so that secondaries here will read the new value.

Please put __pa_swapper_pg_dir in the mmuoff.data.read section, this ensures
hibernate will re-clean this value to the PoC once it has restored the memory.


> @@ -761,10 +763,8 @@ ENTRY(__enable_mmu)
>  	cmp	x2, #ID_AA64MMFR0_TGRAN_SUPPORTED
>  	b.ne	__no_granule_support
>  	update_early_cpu_boot_status 0, x1, x2
> -	adrp	x1, idmap_pg_dir
> -	adrp	x2, swapper_pg_dir
> -	phys_to_ttbr x3, x1
> -	phys_to_ttbr x4, x2
> +	phys_to_ttbr x3, x25
> +	phys_to_ttbr x4, x26
>  	msr	ttbr0_el1, x3			// load TTBR0
>  	msr	ttbr1_el1, x4			// load TTBR1
>  	isb

__enable_mmu() is now taking arguments in x25 and x26. Please update the comment
above it that describes the 'x0' argument.

Why do you pass the idmap ttbr value in too? Its always the same.


> @@ -823,6 +823,8 @@ __primary_switch:
>  	mrs	x20, sctlr_el1			// preserve old SCTLR_EL1 value
>  #endif
>  
> +	adrp    x25, idmap_pg_dir
> +	adrp    x26, swapper_pg_dir
>  	bl	__enable_mmu
>  #ifdef CONFIG_RELOCATABLE
>  	bl	__relocate_kernel

> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 2dbb2c9f1ec1..41eee333f91a 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -55,6 +55,8 @@ u64 idmap_ptrs_per_pgd = PTRS_PER_PGD;
>  u64 kimage_voffset __ro_after_init;
>  EXPORT_SYMBOL(kimage_voffset);
>  
> +phys_addr_t __pa_swapper_pg_dir;

See the definition of 'secondary_holding_pen_release' for an example of how to
put this in the mmuoff.data.read section.


> +
>  /*
>   * Empty_zero_page is a special page that is used for zero-initialized data
>   * and COW.
> @@ -631,6 +633,8 @@ void __init paging_init(void)
>  	phys_addr_t pgd_phys = early_pgtable_alloc();
>  	pgd_t *pgdp = pgd_set_fixmap(pgd_phys);
>  
> +	__pa_swapper_pg_dir = __pa_symbol(swapper_pg_dir);

This write needs to be cleaned to the PoC, see write_pen_release() for an example.


>  	map_kernel(pgdp);
>  	map_mem(pgdp);
>  


Thanks,

James
