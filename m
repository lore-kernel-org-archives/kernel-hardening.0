Date: Fri, 10 Mar 2017 12:30:06 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170310123006.GB11356@leverpostej>
References: <1489092729-16871-1-git-send-email-ard.biesheuvel@linaro.org>
 <1489092729-16871-12-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1489092729-16871-12-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] Re: [PATCH v6 11/11] arm64: mm: set the contiguous bit for kernel
 mappings where appropriate
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, keescook@chromium.org, labbott@fedoraproject.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, jean-philippe.brucker@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 09, 2017 at 09:52:09PM +0100, Ard Biesheuvel wrote:
> This is the third attempt at enabling the use of contiguous hints for
> kernel mappings. The most recent attempt 0bfc445dec9d was reverted after
> it turned out that updating permission attributes on live contiguous ranges
> may result in TLB conflicts. So this time, the contiguous hint is not set
> for .rodata or for the linear alias of .text/.rodata, both of which are
> mapped read-write initially, and remapped read-only at a later stage.
> (Note that the latter region could also be unmapped and remapped again
> with updated permission attributes, given that the region, while live, is
> only mapped for the convenience of the hibernation code, but that also
> means the TLB footprint is negligible anyway, so why bother)
> 
> This enables the following contiguous range sizes for the virtual mapping
> of the kernel image, and for the linear mapping:
> 
>           granule size |  cont PTE  |  cont PMD  |
>           -------------+------------+------------+
>                4 KB    |    64 KB   |   32 MB    |
>               16 KB    |     2 MB   |    1 GB*   |
>               64 KB    |     2 MB   |   16 GB*   |
> 
> * Only when built for 3 or more levels of translation. This is due to the
>   fact that a 2 level configuration only consists of PGDs and PTEs, and the
>   added complexity of dealing with folded PMDs is not justified considering
>   that 16 GB contiguous ranges are likely to be ignored by the hardware (and
>   16k/2 levels is a niche configuration)
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

This looks great; thanks for slogging through this!

To the best of my understanding this should avoid the issue seen by
Jean-Philippe with the last attempt.

As with the rest of the series:

Reviewed-by: Mark Rutland <mark.rutland@arm.com>

I've given this a spin with 4K and 64K pages (2 and 3 level for the
latter) on Juno, with debug_pagealloc dynamically disabled/enabled. The
page tables look as expected in all cases, and memtest can happily poke
all memory without issue regardless.

FWIW, for the series:

Tested-by: Mark Rutland <mark.rutland@arm.com>

Hopefully Catalin/Will are happy to pick this up soon!

Thanks,
Mark.

> ---
>  arch/arm64/include/asm/pgtable.h |  10 ++
>  arch/arm64/mm/mmu.c              | 140 ++++++++++++++------
>  2 files changed, 107 insertions(+), 43 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 0eef6064bf3b..c213fdbd056c 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -74,6 +74,16 @@ extern unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)];
>  #define pte_user_exec(pte)	(!(pte_val(pte) & PTE_UXN))
>  #define pte_cont(pte)		(!!(pte_val(pte) & PTE_CONT))
>  
> +#define pte_cont_addr_end(addr, end)						\
> +({	unsigned long __boundary = ((addr) + CONT_PTE_SIZE) & CONT_PTE_MASK;	\
> +	(__boundary - 1 < (end) - 1) ? __boundary : (end);			\
> +})
> +
> +#define pmd_cont_addr_end(addr, end)						\
> +({	unsigned long __boundary = ((addr) + CONT_PMD_SIZE) & CONT_PMD_MASK;	\
> +	(__boundary - 1 < (end) - 1) ? __boundary : (end);			\
> +})
> +
>  #ifdef CONFIG_ARM64_HW_AFDBM
>  #define pte_hw_dirty(pte)	(pte_write(pte) && !(pte_val(pte) & PTE_RDONLY))
>  #else
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 85ab82f5a0bc..91502e36e6d9 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -44,6 +44,7 @@
>  #include <asm/ptdump.h>
>  
>  #define NO_BLOCK_MAPPINGS	BIT(0)
> +#define NO_CONT_MAPPINGS	BIT(1)
>  
>  u64 idmap_t0sz = TCR_T0SZ(VA_BITS);
>  
> @@ -116,22 +117,11 @@ static bool pgattr_change_is_safe(u64 old, u64 new)
>  	return ((old ^ new) & ~mask) == 0;
>  }
>  
> -static void alloc_init_pte(pmd_t *pmd, unsigned long addr,
> -				  unsigned long end, phys_addr_t phys,
> -				  pgprot_t prot,
> -				  phys_addr_t (*pgtable_alloc)(void))
> +static void init_pte(pmd_t *pmd, unsigned long addr, unsigned long end,
> +		     phys_addr_t phys, pgprot_t prot)
>  {
>  	pte_t *pte;
>  
> -	BUG_ON(pmd_sect(*pmd));
> -	if (pmd_none(*pmd)) {
> -		phys_addr_t pte_phys;
> -		BUG_ON(!pgtable_alloc);
> -		pte_phys = pgtable_alloc();
> -		__pmd_populate(pmd, pte_phys, PMD_TYPE_TABLE);
> -	}
> -	BUG_ON(pmd_bad(*pmd));
> -
>  	pte = pte_set_fixmap_offset(pmd, addr);
>  	do {
>  		pte_t old_pte = *pte;
> @@ -150,25 +140,45 @@ static void alloc_init_pte(pmd_t *pmd, unsigned long addr,
>  	pte_clear_fixmap();
>  }
>  
> -static void alloc_init_pmd(pud_t *pud, unsigned long addr, unsigned long end,
> -				  phys_addr_t phys, pgprot_t prot,
> -				  phys_addr_t (*pgtable_alloc)(void),
> -				  int flags)
> +static void alloc_init_cont_pte(pmd_t *pmd, unsigned long addr,
> +				unsigned long end, phys_addr_t phys,
> +				pgprot_t prot,
> +				phys_addr_t (*pgtable_alloc)(void),
> +				int flags)
>  {
> -	pmd_t *pmd;
>  	unsigned long next;
>  
> -	/*
> -	 * Check for initial section mappings in the pgd/pud and remove them.
> -	 */
> -	BUG_ON(pud_sect(*pud));
> -	if (pud_none(*pud)) {
> -		phys_addr_t pmd_phys;
> +	BUG_ON(pmd_sect(*pmd));
> +	if (pmd_none(*pmd)) {
> +		phys_addr_t pte_phys;
>  		BUG_ON(!pgtable_alloc);
> -		pmd_phys = pgtable_alloc();
> -		__pud_populate(pud, pmd_phys, PUD_TYPE_TABLE);
> +		pte_phys = pgtable_alloc();
> +		__pmd_populate(pmd, pte_phys, PMD_TYPE_TABLE);
>  	}
> -	BUG_ON(pud_bad(*pud));
> +	BUG_ON(pmd_bad(*pmd));
> +
> +	do {
> +		pgprot_t __prot = prot;
> +
> +		next = pte_cont_addr_end(addr, end);
> +
> +		/* use a contiguous mapping if the range is suitably aligned */
> +		if ((((addr | next | phys) & ~CONT_PTE_MASK) == 0) &&
> +		    (flags & NO_CONT_MAPPINGS) == 0)
> +			__prot = __pgprot(pgprot_val(prot) | PTE_CONT);
> +
> +		init_pte(pmd, addr, next, phys, __prot);
> +
> +		phys += next - addr;
> +	} while (addr = next, addr != end);
> +}
> +
> +static void init_pmd(pud_t *pud, unsigned long addr, unsigned long end,
> +		     phys_addr_t phys, pgprot_t prot,
> +		     phys_addr_t (*pgtable_alloc)(void), int flags)
> +{
> +	unsigned long next;
> +	pmd_t *pmd;
>  
>  	pmd = pmd_set_fixmap_offset(pud, addr);
>  	do {
> @@ -188,8 +198,8 @@ static void alloc_init_pmd(pud_t *pud, unsigned long addr, unsigned long end,
>  			BUG_ON(!pgattr_change_is_safe(pmd_val(old_pmd),
>  						      pmd_val(*pmd)));
>  		} else {
> -			alloc_init_pte(pmd, addr, next, phys,
> -				       prot, pgtable_alloc);
> +			alloc_init_cont_pte(pmd, addr, next, phys, prot,
> +					    pgtable_alloc, flags);
>  
>  			BUG_ON(pmd_val(old_pmd) != 0 &&
>  			       pmd_val(old_pmd) != pmd_val(*pmd));
> @@ -200,6 +210,41 @@ static void alloc_init_pmd(pud_t *pud, unsigned long addr, unsigned long end,
>  	pmd_clear_fixmap();
>  }
>  
> +static void alloc_init_cont_pmd(pud_t *pud, unsigned long addr,
> +				unsigned long end, phys_addr_t phys,
> +				pgprot_t prot,
> +				phys_addr_t (*pgtable_alloc)(void), int flags)
> +{
> +	unsigned long next;
> +
> +	/*
> +	 * Check for initial section mappings in the pgd/pud.
> +	 */
> +	BUG_ON(pud_sect(*pud));
> +	if (pud_none(*pud)) {
> +		phys_addr_t pmd_phys;
> +		BUG_ON(!pgtable_alloc);
> +		pmd_phys = pgtable_alloc();
> +		__pud_populate(pud, pmd_phys, PUD_TYPE_TABLE);
> +	}
> +	BUG_ON(pud_bad(*pud));
> +
> +	do {
> +		pgprot_t __prot = prot;
> +
> +		next = pmd_cont_addr_end(addr, end);
> +
> +		/* use a contiguous mapping if the range is suitably aligned */
> +		if ((((addr | next | phys) & ~CONT_PMD_MASK) == 0) &&
> +		    (flags & NO_CONT_MAPPINGS) == 0)
> +			__prot = __pgprot(pgprot_val(prot) | PTE_CONT);
> +
> +		init_pmd(pud, addr, next, phys, __prot, pgtable_alloc, flags);
> +
> +		phys += next - addr;
> +	} while (addr = next, addr != end);
> +}
> +
>  static inline bool use_1G_block(unsigned long addr, unsigned long next,
>  			unsigned long phys)
>  {
> @@ -248,8 +293,8 @@ static void alloc_init_pud(pgd_t *pgd, unsigned long addr, unsigned long end,
>  			BUG_ON(!pgattr_change_is_safe(pud_val(old_pud),
>  						      pud_val(*pud)));
>  		} else {
> -			alloc_init_pmd(pud, addr, next, phys, prot,
> -				       pgtable_alloc, flags);
> +			alloc_init_cont_pmd(pud, addr, next, phys, prot,
> +					    pgtable_alloc, flags);
>  
>  			BUG_ON(pud_val(old_pud) != 0 &&
>  			       pud_val(old_pud) != pud_val(*pud));
> @@ -313,7 +358,8 @@ static void __init create_mapping_noalloc(phys_addr_t phys, unsigned long virt,
>  			&phys, virt);
>  		return;
>  	}
> -	__create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL, 0);
> +	__create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL,
> +			     NO_CONT_MAPPINGS);
>  }
>  
>  void __init create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
> @@ -325,7 +371,7 @@ void __init create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
>  	BUG_ON(mm == &init_mm);
>  
>  	if (page_mappings_only)
> -		flags = NO_BLOCK_MAPPINGS;
> +		flags = NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
>  
>  	__create_pgd_mapping(mm->pgd, phys, virt, size, prot,
>  			     pgd_pgtable_alloc, flags);
> @@ -340,7 +386,8 @@ static void update_mapping_prot(phys_addr_t phys, unsigned long virt,
>  		return;
>  	}
>  
> -	__create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL, 0);
> +	__create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL,
> +			     NO_CONT_MAPPINGS);
>  
>  	/* flush the TLBs after updating live kernel mappings */
>  	flush_tlb_kernel_range(virt, virt + size);
> @@ -353,7 +400,7 @@ static void __init __map_memblock(pgd_t *pgd, phys_addr_t start, phys_addr_t end
>  	int flags = 0;
>  
>  	if (debug_pagealloc_enabled())
> -		flags = NO_BLOCK_MAPPINGS;
> +		flags = NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
>  
>  	/*
>  	 * Take care not to create a writable alias for the
> @@ -390,10 +437,12 @@ static void __init __map_memblock(pgd_t *pgd, phys_addr_t start, phys_addr_t end
>  	 * alternative patching has completed). This makes the contents
>  	 * of the region accessible to subsystems such as hibernate,
>  	 * but protects it from inadvertent modification or execution.
> +	 * Note that contiguous mappings cannot be remapped in this way,
> +	 * so we should avoid them here.
>  	 */
>  	__create_pgd_mapping(pgd, kernel_start, __phys_to_virt(kernel_start),
>  			     kernel_end - kernel_start, PAGE_KERNEL,
> -			     early_pgtable_alloc, 0);
> +			     early_pgtable_alloc, NO_CONT_MAPPINGS);
>  }
>  
>  void __init mark_linear_text_alias_ro(void)
> @@ -440,7 +489,8 @@ void mark_rodata_ro(void)
>  }
>  
>  static void __init map_kernel_segment(pgd_t *pgd, void *va_start, void *va_end,
> -				      pgprot_t prot, struct vm_struct *vma)
> +				      pgprot_t prot, struct vm_struct *vma,
> +				      int flags)
>  {
>  	phys_addr_t pa_start = __pa_symbol(va_start);
>  	unsigned long size = va_end - va_start;
> @@ -449,7 +499,7 @@ static void __init map_kernel_segment(pgd_t *pgd, void *va_start, void *va_end,
>  	BUG_ON(!PAGE_ALIGNED(size));
>  
>  	__create_pgd_mapping(pgd, pa_start, (unsigned long)va_start, size, prot,
> -			     early_pgtable_alloc, 0);
> +			     early_pgtable_alloc, flags);
>  
>  	vma->addr	= va_start;
>  	vma->phys_addr	= pa_start;
> @@ -481,14 +531,18 @@ static void __init map_kernel(pgd_t *pgd)
>  	 */
>  	pgprot_t text_prot = rodata_enabled ? PAGE_KERNEL_ROX : PAGE_KERNEL_EXEC;
>  
> -	map_kernel_segment(pgd, _text, _etext, text_prot, &vmlinux_text);
> +	/*
> +	 * Only rodata will be remapped with different permissions later on,
> +	 * all other segments are allowed to use contiguous mappings.
> +	 */
> +	map_kernel_segment(pgd, _text, _etext, text_prot, &vmlinux_text, 0);
>  	map_kernel_segment(pgd, __start_rodata, __inittext_begin, PAGE_KERNEL,
> -			   &vmlinux_rodata);
> +			   &vmlinux_rodata, NO_CONT_MAPPINGS);
>  	map_kernel_segment(pgd, __inittext_begin, __inittext_end, text_prot,
> -			   &vmlinux_inittext);
> +			   &vmlinux_inittext, 0);
>  	map_kernel_segment(pgd, __initdata_begin, __initdata_end, PAGE_KERNEL,
> -			   &vmlinux_initdata);
> -	map_kernel_segment(pgd, _data, _end, PAGE_KERNEL, &vmlinux_data);
> +			   &vmlinux_initdata, 0);
> +	map_kernel_segment(pgd, _data, _end, PAGE_KERNEL, &vmlinux_data, 0);
>  
>  	if (!pgd_val(*pgd_offset_raw(pgd, FIXADDR_START))) {
>  		/*
> -- 
> 2.7.4
> 
