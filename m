Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 11 Jan 2016 16:09:06 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160111160906.GO6499@leverpostej>
References: <1452518355-4606-1-git-send-email-ard.biesheuvel@linaro.org>
 <1452518355-4606-5-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1452518355-4606-5-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] Re: [PATCH v3 04/21] arm64: decouple early fixmap init from linear
 mapping
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, linux-kernel@vger.kernel.org, stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, arnd@arndb.de, marc.zyngier@arm.com, christoffer.dall@linaro.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jan 11, 2016 at 02:18:57PM +0100, Ard Biesheuvel wrote:
> Since the early fixmap page tables are populated using pages that are
> part of the static footprint of the kernel, they are covered by the
> initial kernel mapping, and we can refer to them without using __va/__pa
> translations, which are tied to the linear mapping.
> 
> Since the fixmap page tables are disjoint from the kernel mapping up
> to the top level pgd entry, we can refer to bm_pte[] directly, and there
> is no need to walk the page tables and perform __pa()/__va() translations
> at each step.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm64/mm/mmu.c | 32 ++++++--------------
>  1 file changed, 9 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 7711554a94f4..75b5f0dc3bdc 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -570,38 +570,24 @@ void vmemmap_free(unsigned long start, unsigned long end)
>  #endif	/* CONFIG_SPARSEMEM_VMEMMAP */
>  
>  static pte_t bm_pte[PTRS_PER_PTE] __page_aligned_bss;
> -#if CONFIG_PGTABLE_LEVELS > 2
>  static pmd_t bm_pmd[PTRS_PER_PMD] __page_aligned_bss;
> -#endif
> -#if CONFIG_PGTABLE_LEVELS > 3
>  static pud_t bm_pud[PTRS_PER_PUD] __page_aligned_bss;
> -#endif
>  
>  static inline pud_t * fixmap_pud(unsigned long addr)
>  {
> -	pgd_t *pgd = pgd_offset_k(addr);
> -
> -	BUG_ON(pgd_none(*pgd) || pgd_bad(*pgd));
> -
> -	return pud_offset(pgd, addr);
> +	return (CONFIG_PGTABLE_LEVELS > 3) ? &bm_pud[pud_index(addr)]
> +					   : (pud_t *)pgd_offset_k(addr);

If we move patch 6 earlier, we could use pud_offset_kimg here, and avoid
the cast, at the cost of passing the pgd into fixmap_pud.

Similarly for fixmap_pmd.

>  }
>  
> -static inline pmd_t * fixmap_pmd(unsigned long addr)
> +static inline pte_t * fixmap_pmd(unsigned long addr)
>  {
> -	pud_t *pud = fixmap_pud(addr);
> -
> -	BUG_ON(pud_none(*pud) || pud_bad(*pud));
> -
> -	return pmd_offset(pud, addr);
> +	return (CONFIG_PGTABLE_LEVELS > 2) ? &bm_pmd[pmd_index(addr)]
> +					   : (pmd_t *)pgd_offset_k(addr);
>  }

I assume the return type change was unintentional?

With STRICT_MM_TYPECHECKS:

arch/arm64/mm/mmu.c: In function 'fixmap_pmd':
arch/arm64/mm/mmu.c:604:9: warning: return from incompatible pointer type [-Wincompatible-pointer-types]
  return (CONFIG_PGTABLE_LEVELS > 2) ? &bm_pmd[pmd_index(addr)]
         ^
arch/arm64/mm/mmu.c: In function 'early_fixmap_init':
arch/arm64/mm/mmu.c:635:6: warning: assignment from incompatible pointer type [-Wincompatible-pointer-types]
  pmd = fixmap_pmd(addr);
      ^
arch/arm64/mm/mmu.c:645:11: warning: comparison of distinct pointer types lacks a cast
  if ((pmd != fixmap_pmd(fix_to_virt(FIX_BTMAP_BEGIN)))
           ^
arch/arm64/mm/mmu.c:646:14: warning: comparison of distinct pointer types lacks a cast
       || pmd != fixmap_pmd(fix_to_virt(FIX_BTMAP_END))) {
              ^

Side note: is there any reason we can't/shouldn't make
STRICT_MM_TYPECHECKS a common config option? Or simply have it on by
default for arm64?

Having built with and without typechecks I see that it doesn't bloat the
kernel Image size, though the binary isn't quite identical:

[mark@leverpostej:~/src/linux]% ls -al *.*checks
-rwxrwxr-x 1 mark mark   9288192 Jan 11 15:40 Image.checks
-rwxrwxr-x 1 mark mark   9288192 Jan 11 15:36 Image.nochecks
-rwxrwxr-x 1 mark mark 106782024 Jan 11 15:40 vmlinux.checks
-rwxrwxr-x 1 mark mark 106688928 Jan 11 15:35 vmlinux.nochecks

Things didn't quite line up between the two images, though I'm not sure
what the underlying difference was.

Thanks,
Mark.
