Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 8 Jan 2016 12:00:08 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
Message-ID: <20160108120008.GF16432@e104818-lin.cambridge.arm.com>
References: <1451489172-17420-1-git-send-email-ard.biesheuvel@linaro.org>
 <1451489172-17420-5-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1451489172-17420-5-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] Re: [PATCH v2 04/13] arm64: decouple early fixmap init from linear
 mapping
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, mark.rutland@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, linux-kernel@vger.kernel.org, arnd@arndb.de, bhupesh.sharma@freescale.com, stuart.yoder@freescale.com, marc.zyngier@arm.com, christoffer.dall@linaro.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Dec 30, 2015 at 04:26:03PM +0100, Ard Biesheuvel wrote:
> @@ -583,33 +555,42 @@ void __init early_fixmap_init(void)
>  	unsigned long addr = FIXADDR_START;
>  
>  	pgd = pgd_offset_k(addr);
> -	pgd_populate(&init_mm, pgd, bm_pud);
> -	pud = pud_offset(pgd, addr);
> -	pud_populate(&init_mm, pud, bm_pmd);
> -	pmd = pmd_offset(pud, addr);
> -	pmd_populate_kernel(&init_mm, pmd, bm_pte);
> +#if CONFIG_PGTABLE_LEVELS > 3
> +	if (pgd_none(*pgd)) {
> +		static pud_t bm_pud[PTRS_PER_PUD] __pgdir;
> +
> +		pgd_populate(&init_mm, pgd, bm_pud);
> +		memblock_reserve(__pa(bm_pud), sizeof(bm_pud));
> +	}
> +	pud = (pud_t *)__phys_to_kimg(pud_offset_phys(pgd, addr));
> +#else
> +	pud = (pud_t *)pgd;
> +#endif
> +#if CONFIG_PGTABLE_LEVELS > 2
> +	if (pud_none(*pud)) {
> +		static pmd_t bm_pmd[PTRS_PER_PMD] __pgdir;
> +
> +		pud_populate(&init_mm, pud, bm_pmd);
> +		memblock_reserve(__pa(bm_pmd), sizeof(bm_pmd));
> +	}
> +	pmd = (pmd_t *)__phys_to_kimg(pmd_offset_phys(pud, addr));
> +#else
> +	pmd = (pmd_t *)pud;
> +#endif
> +	if (pmd_none(*pmd)) {
> +		static pte_t bm_pte[PTRS_PER_PTE] __pgdir;
> +
> +		pmd_populate_kernel(&init_mm, pmd, bm_pte);
> +		memblock_reserve(__pa(bm_pte), sizeof(bm_pte));
> +	}
> +	__fixmap_pte = (pte_t *)__phys_to_kimg(pmd_page_paddr(*pmd));

I haven't tried but could you not avoid the #if and just rely on the
pud_none() etc. definitions to be 0 and the compiler+linker optimising
the irrelevant code out?

-- 
Catalin
