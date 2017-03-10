Date: Fri, 10 Mar 2017 11:25:22 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170310112521.GA11356@leverpostej>
References: <1489092729-16871-1-git-send-email-ard.biesheuvel@linaro.org>
 <1489092729-16871-11-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1489092729-16871-11-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] Re: [PATCH v6 10/11] arm64/mm: remove pointless map/unmap sequences
 when creating page tables
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, keescook@chromium.org, labbott@fedoraproject.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 09, 2017 at 09:52:08PM +0100, Ard Biesheuvel wrote:
> The routines __pud_populate and __pmd_populate only create a table
> entry at their respective level which refers to the next level page
> by its physical address, so there is no reason to map this page and
> then unmap it immediately after.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Reviewed-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  arch/arm64/mm/mmu.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index bc9d5eb7bfa2..85ab82f5a0bc 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -128,9 +128,7 @@ static void alloc_init_pte(pmd_t *pmd, unsigned long addr,
>  		phys_addr_t pte_phys;
>  		BUG_ON(!pgtable_alloc);
>  		pte_phys = pgtable_alloc();
> -		pte = pte_set_fixmap(pte_phys);
>  		__pmd_populate(pmd, pte_phys, PMD_TYPE_TABLE);
> -		pte_clear_fixmap();
>  	}
>  	BUG_ON(pmd_bad(*pmd));
>  
> @@ -168,9 +166,7 @@ static void alloc_init_pmd(pud_t *pud, unsigned long addr, unsigned long end,
>  		phys_addr_t pmd_phys;
>  		BUG_ON(!pgtable_alloc);
>  		pmd_phys = pgtable_alloc();
> -		pmd = pmd_set_fixmap(pmd_phys);
>  		__pud_populate(pud, pmd_phys, PUD_TYPE_TABLE);
> -		pmd_clear_fixmap();
>  	}
>  	BUG_ON(pud_bad(*pud));
>  
> -- 
> 2.7.4
> 
