Date: Thu, 9 Mar 2017 15:53:21 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170309155321.GB11966@leverpostej>
References: <1489047912-642-1-git-send-email-ard.biesheuvel@linaro.org>
 <1489047912-642-7-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1489047912-642-7-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] Re: [PATCH v5 06/10] arm64/mmu: align alloc_init_pte prototype with
 pmd/pud versions
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, keescook@chromium.org, labbott@fedoraproject.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 09, 2017 at 09:25:08AM +0100, Ard Biesheuvel wrote:
> Align the function prototype of alloc_init_pte() with its pmd and pud
> counterparts by replacing the pfn parameter with the equivalent physical
> address.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm64/mm/mmu.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 75e21c33caff..c3963c592ec3 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -107,7 +107,7 @@ static bool pgattr_change_is_safe(u64 old, u64 new)
>  }
>  
>  static void alloc_init_pte(pmd_t *pmd, unsigned long addr,
> -				  unsigned long end, unsigned long pfn,
> +				  unsigned long end, phys_addr_t phys,
>  				  pgprot_t prot,
>  				  phys_addr_t (*pgtable_alloc)(void))
>  {
> @@ -128,8 +128,8 @@ static void alloc_init_pte(pmd_t *pmd, unsigned long addr,
>  	do {
>  		pte_t old_pte = *pte;
>  
> -		set_pte(pte, pfn_pte(pfn, prot));
> -		pfn++;
> +		set_pte(pte, pfn_pte(__phys_to_pfn(phys), prot));
> +		phys += PAGE_SIZE;

Minor nit: so as to align the strucutre of the loop with the other
functions, it'd be nice to have this on the final line of the loop body.

Either way:

Reviewed-by: Mark Rutland <mark.rutland@arm.com>

Mark.

>  
>  		/*
>  		 * After the PTE entry has been populated once, we
> @@ -182,7 +182,7 @@ static void alloc_init_pmd(pud_t *pud, unsigned long addr, unsigned long end,
>  			BUG_ON(!pgattr_change_is_safe(pmd_val(old_pmd),
>  						      pmd_val(*pmd)));
>  		} else {
> -			alloc_init_pte(pmd, addr, next, __phys_to_pfn(phys),
> +			alloc_init_pte(pmd, addr, next, phys,
>  				       prot, pgtable_alloc);
>  
>  			BUG_ON(pmd_val(old_pmd) != 0 &&
> -- 
> 2.7.4
> 
