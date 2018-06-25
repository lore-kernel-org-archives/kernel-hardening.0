Subject: Re: [PATCH v2 1/2] arm64/mm: Introduce init_pg_dir
References: <20180625113921.21854-1-yaojun8558363@gmail.com>
 <20180625113921.21854-2-yaojun8558363@gmail.com>
From: James Morse <james.morse@arm.com>
Message-ID: <82797340-00a2-b3b5-981c-a049ca755db5@arm.com>
Date: Mon, 25 Jun 2018 17:37:01 +0100
MIME-Version: 1.0
In-Reply-To: <20180625113921.21854-2-yaojun8558363@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Jun Yao <yaojun8558363@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, will.deacon@arm.com, ard.biesheuvel@linaro.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Jun,

On 25/06/18 12:39, Jun Yao wrote:
> We setup initial page tables in init_pg_dir, which is a reserved
> area of the __initdata section. And in paging_init(), we no
> longer need a temporary top-level and we can setup final page
> tables in swapper_pg_dir directly.

This patch is doing quite a lot. Some ideas on how to break it up below.


>  arch/arm64/include/asm/fixmap.h   |  1 -
>  arch/arm64/include/asm/pgtable.h  |  5 ++--
>  arch/arm64/kernel/head.S          | 46 +++++++++++++++++++++++--------

You missed an enable_mmu() caller in sleep.S


>  arch/arm64/kernel/vmlinux.lds.S   |  3 +-
>  arch/arm64/mm/mmu.c               | 30 ++++----------------

>  include/asm-generic/vmlinux.lds.h |  5 ++++
>  mm/init-mm.c                      |  2 +-

We shouldn't need to modify these files as they affect other architectures too.


> diff --git a/arch/arm64/include/asm/fixmap.h b/arch/arm64/include/asm/fixmap.h
> index ec1e6d6fa14c..62908eeedcdc 100644
> --- a/arch/arm64/include/asm/fixmap.h
> +++ b/arch/arm64/include/asm/fixmap.h
> @@ -83,7 +83,6 @@ enum fixed_addresses {
>  	FIX_PTE,
>  	FIX_PMD,
>  	FIX_PUD,
> -	FIX_PGD,

> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 7c4c8f318ba9..b2435e8b975b 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -592,9 +592,6 @@ static inline phys_addr_t pgd_page_paddr(pgd_t pgd)
>  /* to find an entry in a kernel page-table-directory */
>  #define pgd_offset_k(addr)	pgd_offset(&init_mm, addr)
>  
> -#define pgd_set_fixmap(addr)	((pgd_t *)set_fixmap_offset(FIX_PGD, addr))
> -#define pgd_clear_fixmap()	clear_fixmap(FIX_PGD)

I think we want to keep these for pgd_populate() once the top level entry is
read only. Linux's folding means the PUD or PMD levels may be called PGD so that
the top level type is always the same.


>  static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
>  {
>  	const pteval_t mask = PTE_USER | PTE_PXN | PTE_UXN | PTE_RDONLY |
> @@ -718,6 +715,8 @@ static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
>  }
>  #endif
>  
> +extern pgd_t init_pg_dir[PTRS_PER_PGD];
> +extern pgd_t init_pg_end[];

Please mark these with __initdata so that tools like sparse can catch code
trying to access these once they've been freed.


>  extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
>  extern pgd_t swapper_pg_end[];
>  extern pgd_t idmap_pg_dir[PTRS_PER_PGD];
> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> index b0853069702f..9677deb7b6c7 100644
> --- a/arch/arm64/kernel/head.S
> +++ b/arch/arm64/kernel/head.S
> @@ -276,6 +276,15 @@ ENDPROC(preserve_boot_args)
>  	populate_entries \tbl, \count, \istart, \iend, \flags, #SWAPPER_BLOCK_SIZE, \tmp
>  	.endm
>  
> +	.macro clear_pages, start, size
> +1:	stp	xzr, xzr, [\start], #16
> +	stp	xzr, xzr, [\start], #16
> +	stp	xzr, xzr, [\start], #16
> +	stp	xzr, xzr, [\start], #16
> +	subs	\size, \size, #64
> +	b.ne	1b
> +	.endm

Could this go in arch/arm64/include/asm/assembler.h along with the other
assembly macros. We may want to use it elsewhere.

(Nit: This isn't really clearing pages, its more of a range.)


>  /*
>   * Setup the initial page tables. We only setup the barest amount which is
>   * required to get the kernel running. The following sections are required:



> @@ -373,7 +387,7 @@ __create_page_tables:
>  	/*
>  	 * Map the kernel image (starting with PHYS_OFFSET).
>  	 */
> -	adrp	x0, swapper_pg_dir
> +	adrp	x0, init_pg_dir
>  	mov_q	x5, KIMAGE_VADDR + TEXT_OFFSET	// compile time __va(_text)
>  	add	x5, x5, x23			// add KASLR displacement
>  	mov	x4, PTRS_PER_PGD
> @@ -386,7 +400,7 @@ __create_page_tables:
>  
>  	/*
>  	 * Since the page tables have been populated with non-cacheable
> -	 * accesses (MMU disabled), invalidate the idmap and swapper page
> +	 * accesses (MMU disabled), invalidate the idmap and init page
>  	 * tables again to remove any speculatively loaded cache lines.
>  	 */
>  	adrp	x0, idmap_pg_dir
> @@ -395,6 +409,12 @@ __create_page_tables:
>  	dmb	sy
>  	bl	__inval_dcache_area
>  
> +	adrp	x0, init_pg_dir
> +	adrp	x1, init_pg_end
> +	sub	x1, x1, x0

> +	dmb	sy

I think this barrier is to ensure the writes from map_memory happen before we
start invalidating the corresponding cache area, so that any newly cached data
after the invalidate must read the data map_memory wrote.

We shouldn't need a second one here.


> +	bl	__inval_dcache_area
> +
>  	ret	x28
>  ENDPROC(__create_page_tables)
>  	.ltorg
> @@ -706,6 +726,7 @@ secondary_startup:
>  	 * Common entry point for secondary CPUs.
>  	 */
>  	bl	__cpu_setup			// initialise processor
> +	adr_l   x26, swapper_pg_dir

We know this is page aligned, the adrp that you removed from __enable_mmu is enough.


>  	bl	__enable_mmu
>  	ldr	x8, =__secondary_switched
>  	br	x8
> @@ -748,6 +769,7 @@ ENDPROC(__secondary_switched)
>   * Enable the MMU.
>   *
>   *  x0  = SCTLR_EL1 value for turning on the MMU.
> + *  x26 = TTBR1_EL1 value for turning on the MMU.

(Nit: I'd prefer these functions kept to the PCS wherever possible. Yes this
means shuffling some registers which is noisy, but if this is broken up into
smaller patches it should be tolerable)


>   *
>   * Returns to the caller via x30/lr. This requires the caller to be covered
>   * by the .idmap.text section.
> @@ -762,7 +784,7 @@ ENTRY(__enable_mmu)
>  	b.ne	__no_granule_support
>  	update_early_cpu_boot_status 0, x1, x2
>  	adrp	x1, idmap_pg_dir
> -	adrp	x2, swapper_pg_dir
> +	mov	x2, x26
>  	phys_to_ttbr x3, x1
>  	phys_to_ttbr x4, x2
>  	msr	ttbr0_el1, x3			// load TTBR0


> diff --git a/mm/init-mm.c b/mm/init-mm.c
> index f94d5d15ebc0..08a0eed00667 100644
> --- a/mm/init-mm.c
> +++ b/mm/init-mm.c
> @@ -17,7 +17,7 @@
>
>  struct mm_struct init_mm = {
>  	.mm_rb		= RB_ROOT,
> -	.pgd		= swapper_pg_dir,
> +	.pgd		= init_pg_dir,
>  	.mm_users	= ATOMIC_INIT(2),
>  	.mm_count	= ATOMIC_INIT(1),
>  	.mmap_sem	= __RWSEM_INITIALIZER(init_mm.mmap_sem),
>

We really can't do this, it breaks other architectures that don't have an
'init_pg_dir', and code to shuffle to 'swapper_pg_dir' once they've done
paging_init().

We can keep the change entirely in arch/arm64 if we set init_mm.pgd to
init_pg_dir before we call early_fixmap_init() in kaslr_early_init() and
setup_arch(). You already switch it back in paging_init().


> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 2dbb2c9f1ec1..a3b5f1dffb84 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -628,34 +628,14 @@ static void __init map_kernel(pgd_t *pgdp)
>   */
>  void __init paging_init(void)
>  {
> -	phys_addr_t pgd_phys = early_pgtable_alloc();
> -	pgd_t *pgdp = pgd_set_fixmap(pgd_phys);
> -
> -	map_kernel(pgdp);
> -	map_mem(pgdp);
> -
>  	/*
> -	 * We want to reuse the original swapper_pg_dir so we don't have to
> -	 * communicate the new address to non-coherent secondaries in
> -	 * secondary_entry, and so cpu_switch_mm can generate the address with
> -	 * adrp+add rather than a load from some global variable.
> -	 *
> -	 * To do this we need to go via a temporary pgd.
> +	 * Setup final page tables in swapper_pg_dir.
>  	 */
> -	cpu_replace_ttbr1(__va(pgd_phys));
> -	memcpy(swapper_pg_dir, pgdp, PGD_SIZE);
> -	cpu_replace_ttbr1(lm_alias(swapper_pg_dir));
> +	map_kernel(swapper_pg_dir);
> +	map_mem(swapper_pg_dir);
>  
> -	pgd_clear_fixmap();
> -	memblock_free(pgd_phys, PAGE_SIZE);
> -
> -	/*
> -	 * We only reuse the PGD from the swapper_pg_dir, not the pud + pmd
> -	 * allocated with it.
> -	 */
> -	memblock_free(__pa_symbol(swapper_pg_dir) + PAGE_SIZE,
> -		      __pa_symbol(swapper_pg_end) - __pa_symbol(swapper_pg_dir)
> -		      - PAGE_SIZE);
> +	cpu_replace_ttbr1(lm_alias(swapper_pg_dir));
> +	init_mm.pgd = swapper_pg_dir;
>  }

This is difficult to follow because this patch is doing too much. I think you
could break it into four:
1. Create init_pg_dir, its linker-script changes and boiler-plate
clearing/cleaning/invalidating in head.S. Nothing will use it yet.
2. Make enable_mmu() take the physical address of the ttbr1 page as an argument.
3. Switch head.S to create page tables in init_pg_dir, and trim paging_init as
above.
4. Changes to the linker script and paging_init() to make swapper_pg_dir smaller
so we don't need to memblock_free() it.

This way the page table generation changes and the
boiler-plate-setup/final-cleanup are in separate patches.


Thanks,

James
