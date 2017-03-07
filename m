Date: Tue, 7 Mar 2017 16:46:48 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170307164648.GC3514@leverpostej>
References: <1488637848-13588-1-git-send-email-ard.biesheuvel@linaro.org>
 <1488637848-13588-7-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1488637848-13588-7-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] Re: [PATCH v4 6/6] arm64: mm: set the contiguous bit for kernel
 mappings where appropriate
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, catalin.marinas@arm.com, will.deacon@arm.com, labbott@fedoraproject.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, keescook@chromium.org, andre.przywara@arm.com, james.morse@arm.com, suzuki.poulose@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On Sat, Mar 04, 2017 at 02:30:48PM +0000, Ard Biesheuvel wrote:
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
> ---
>  arch/arm64/mm/mmu.c | 86 ++++++++++++++------
>  1 file changed, 63 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 0612573ef869..d0ae2f1f44fc 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -109,8 +109,10 @@ static bool pgattr_change_is_safe(u64 old, u64 new)
>  static void alloc_init_pte(pmd_t *pmd, unsigned long addr,
>  				  unsigned long end, unsigned long pfn,
>  				  pgprot_t prot,
> -				  phys_addr_t (*pgtable_alloc)(void))
> +				  phys_addr_t (*pgtable_alloc)(void),
> +				  bool may_use_cont)

Maybe we should invert this as single_pages_only, to keep the same
polarity as page_mappings_only?

That might make the calls to __create_pgd_mapping() in __map_memblock()
look a little nicer, for instance.

>  {
> +	pgprot_t __prot = prot;
>  	pte_t *pte;
>  
>  	BUG_ON(pmd_sect(*pmd));
> @@ -128,7 +130,19 @@ static void alloc_init_pte(pmd_t *pmd, unsigned long addr,
>  	do {
>  		pte_t old_pte = *pte;
>  
> -		set_pte(pte, pfn_pte(pfn, prot));
> +		/*
> +		 * Set the contiguous bit for the subsequent group of PTEs if
> +		 * its size and alignment are appropriate.
> +		 */
> +		if (may_use_cont &&
> +		    ((addr | PFN_PHYS(pfn)) & ~CONT_PTE_MASK) == 0) {
> +			if (end - addr >= CONT_PTE_SIZE)
> +				__prot = __pgprot(pgprot_val(prot) | PTE_CONT);
> +			else
> +				__prot = prot;
> +		}
> +
> +		set_pte(pte, pfn_pte(pfn, __prot));
>  		pfn++;
>  
>  		/*

While it would require more code, I think it would be better to add a
function between alloc_init_pte() and alloc_init_pmd(), handling this in
the usual fashion. e.g.

---->8----
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 0eef606..2c90925 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -74,6 +74,11 @@
 #define pte_user_exec(pte)     (!(pte_val(pte) & PTE_UXN))
 #define pte_cont(pte)          (!!(pte_val(pte) & PTE_CONT))
 
+#define pte_cont_addr_end(addr, end)                                           \
+({     unsigned long __boundary = ((addr) + CONT_PTE_SIZE) & CONT_PTE_MASK;    \
+       (__boundary - 1 < (end) - 1)? __boundary: (end);                        \
+})
+
 #ifdef CONFIG_ARM64_HW_AFDBM
 #define pte_hw_dirty(pte)      (pte_write(pte) && !(pte_val(pte) & PTE_RDONLY))
 #else
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 2aec93ab..3cee826 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -142,6 +142,32 @@ static void alloc_init_pte(pmd_t *pmd, unsigned long addr,
        pte_clear_fixmap();
 }
 
+static void alloc_init_cont_pte(pmd_t *pmd, unsigned long addr,
+                                 unsigned long end, phys_addr_t phys,
+                                 pgprot_t prot,
+                                 phys_addr_t (*pgtable_alloc)(void),
+                                 bool may_use_cont)
+{
+       const pgprot_t cont_prot = __pgprot(pgprot_val(prot) | PTE_CONT);
+       unsigned long next;
+
+       do {
+               next = pte_cont_addr_end(addr, end);
+
+               /* try a contiguous mapping first */
+               if ((((addr | next | phys) & ~CONT_PTE_MASK) == 0) &&
+                   may_use_cont) {
+                       alloc_init_pte(pmd, addr, next, phys, cont_prot,
+                                      pgtable_alloc);
+               } else {
+                       alloc_init_pte(pmd, addr, next, phys, prot,
+                                      pgtable_alloc);
+               }
+
+               phys += next - addr;
+       } while (addr = next, addr != end);
+}
+
 static void alloc_init_pmd(pud_t *pud, unsigned long addr, unsigned long end,
                                  phys_addr_t phys, pgprot_t prot,
                                  phys_addr_t (*pgtable_alloc)(void),
---->8----

It's more code, but it follows the existing pattern, and I personally
find it easier to follow than changing prot within the loop.

Note that I've cheated and made alloc_init_pte() take a phys_addr_t
rather than a pfn, which I think we should do anyhow for consistency. I
have a patch for that, if you agree.

Another think we *might* want to do here is pass a flags parameter that
than separate page_mappings_only and mask_use_cont. That might also make
things less painful in future if there are other things we need to pass
down.

That might also end up complicating matters, given the way we currently
use debug_pagealloc_enabled() in __create_pgd_mapping() callers, so I'm
also happy to leave that.

[...]

> @@ -173,7 +189,19 @@ static void alloc_init_pmd(pud_t *pud, unsigned long addr, unsigned long end,
>  		/* try section mapping first */
>  		if (((addr | next | phys) & ~SECTION_MASK) == 0 &&
>  		      !page_mappings_only) {
> -			pmd_set_huge(pmd, phys, prot);
> +			/*
> +			 * Set the contiguous bit for the subsequent group of
> +			 * PMDs if its size and alignment are appropriate.
> +			 */
> +			if (may_use_cont &&
> +			    ((addr | phys) & ~CONT_PMD_MASK) == 0) {
> +				if (end - addr >= CONT_PMD_SIZE)
> +					__prot = __pgprot(pgprot_val(prot) |
> +							  PTE_CONT);
> +				else
> +					__prot = prot;
> +			}
> +			pmd_set_huge(pmd, phys, __prot);

As above, I think it would be better to have a alloc_init_cont_pmd()
wrapper that iterated in CONT_PMD_SIZE chunks, so as to keep the usual
pattern.

> @@ -381,7 +418,8 @@ static void __init __map_memblock(pgd_t *pgd, phys_addr_t start, phys_addr_t end
>  	 */
>  	__create_pgd_mapping(pgd, kernel_start, __phys_to_virt(kernel_start),
>  			     kernel_end - kernel_start, PAGE_KERNEL,
> -			     early_pgtable_alloc, debug_pagealloc_enabled());
> +			     early_pgtable_alloc, debug_pagealloc_enabled(),
> +			     false);
>  }

> @@ -437,7 +476,8 @@ static void __init map_kernel_segment(pgd_t *pgd, void *va_start, void *va_end,
>  	BUG_ON(!PAGE_ALIGNED(size));
>  
>  	__create_pgd_mapping(pgd, pa_start, (unsigned long)va_start, size, prot,
> -			     early_pgtable_alloc, debug_pagealloc_enabled());
> +			     early_pgtable_alloc, debug_pagealloc_enabled(),
> +			     !debug_pagealloc_enabled() && may_use_cont);
>  
>  	vma->addr	= va_start;
>  	vma->phys_addr	= pa_start;
> @@ -464,14 +504,14 @@ static void __init map_kernel(pgd_t *pgd)
>  
>  	pgprot_t text_prot = rodata_enabled ? PAGE_KERNEL_ROX : PAGE_KERNEL_EXEC;
>  
> -	map_kernel_segment(pgd, _text, _etext, text_prot, &vmlinux_text);
> +	map_kernel_segment(pgd, _text, _etext, text_prot, &vmlinux_text, true);
>  	map_kernel_segment(pgd, __start_rodata, __inittext_begin, PAGE_KERNEL,
> -			   &vmlinux_rodata);
> +			   &vmlinux_rodata, false);
>  	map_kernel_segment(pgd, __inittext_begin, __inittext_end, text_prot,
> -			   &vmlinux_inittext);
> +			   &vmlinux_inittext, true);
>  	map_kernel_segment(pgd, __initdata_begin, __initdata_end, PAGE_KERNEL,
> -			   &vmlinux_initdata);
> -	map_kernel_segment(pgd, _data, _end, PAGE_KERNEL, &vmlinux_data);
> +			   &vmlinux_initdata, true);
> +	map_kernel_segment(pgd, _data, _end, PAGE_KERNEL, &vmlinux_data, true);

It might be worth a comment somewhere as to why we have to special case
text, rodata, and the linear alias, but otherwise this looks fine.

Thanks,
Mark.
