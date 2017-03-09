Date: Thu, 9 Mar 2017 19:33:44 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170309193343.GG11966@leverpostej>
References: <1489047912-642-1-git-send-email-ard.biesheuvel@linaro.org>
 <1489047912-642-11-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1489047912-642-11-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] Re: [PATCH v5 10/10] arm64: mm: set the contiguous bit for kernel
 mappings where appropriate
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, keescook@chromium.org, labbott@fedoraproject.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 09, 2017 at 09:25:12AM +0100, Ard Biesheuvel wrote:
> +static inline u64 pte_cont_addr_end(u64 addr, u64 end)
> +{
> +	return min((addr + CONT_PTE_SIZE) & CONT_PTE_MASK, end);
> +}
> +
> +static inline u64 pmd_cont_addr_end(u64 addr, u64 end)
> +{
> +	return min((addr + CONT_PMD_SIZE) & CONT_PMD_MASK, end);
> +}

These differ structurally from the usual p??_addr_end() macros defined
in include/asm-generic/pgtable.h. I agree the asm-generic macros aren't
pretty, but it would be nice to be consistent.

I don't think the above handle a partial contiguous span at the end of
the address space (e.g. where end is initial PAGE_SIZE away from 2^64),
whereas the asm-generic form does, AFAICT.

Can we please use:

#define pte_cont_addr_end(addr, end)						\
({	unsigned long __boundary = ((addr) + CONT_PTE_SIZE) & CONT_PTE_MASK;	\
	(__boundary - 1 < (end) - 1)? __boundary: (end);			\
})

#define pmd_cont_addr_end(addr, end)						\
({	unsigned long __boundary = ((addr) + CONT_PMD_SIZE) & CONT_PMD_MASK;	\
	(__boundary - 1 < (end) - 1)? __boundary: (end);			\
})

... instead?

[...]

> +static void init_pte(pte_t *pte, unsigned long addr, unsigned long end,
> +		     phys_addr_t phys, pgprot_t prot)
>  {
> +	do {
> +		pte_t old_pte = *pte;
> +
> +		set_pte(pte, pfn_pte(__phys_to_pfn(phys), prot));
> +
> +		/*
> +		 * After the PTE entry has been populated once, we
> +		 * only allow updates to the permission attributes.
> +		 */
> +		BUG_ON(!pgattr_change_is_safe(pte_val(old_pte), pte_val(*pte)));
> +
> +	} while (pte++, addr += PAGE_SIZE, phys += PAGE_SIZE, addr != end);
> +}
> +
> +static void alloc_init_cont_pte(pmd_t *pmd, unsigned long addr,
> +				unsigned long end, phys_addr_t phys,
> +				pgprot_t prot,
> +				phys_addr_t (*pgtable_alloc)(void),
> +				int flags)
> +{
> +	unsigned long next;
>  	pte_t *pte;
>  
>  	BUG_ON(pmd_sect(*pmd));
> @@ -136,45 +156,30 @@ static void alloc_init_pte(pmd_t *pmd, unsigned long addr,
>  
>  	pte = pte_set_fixmap_offset(pmd, addr);
>  	do {
> -		pte_t old_pte = *pte;
> +		pgprot_t __prot = prot;
>  
> -		set_pte(pte, pfn_pte(__phys_to_pfn(phys), prot));
> -		phys += PAGE_SIZE;
> +		next = pte_cont_addr_end(addr, end);
>  
> -		/*
> -		 * After the PTE entry has been populated once, we
> -		 * only allow updates to the permission attributes.
> -		 */
> -		BUG_ON(!pgattr_change_is_safe(pte_val(old_pte), pte_val(*pte)));
> +		/* use a contiguous mapping if the range is suitably aligned */
> +		if ((((addr | next | phys) & ~CONT_PTE_MASK) == 0) &&
> +		    (flags & NO_CONT_MAPPINGS) == 0)
> +			__prot = __pgprot(pgprot_val(prot) | PTE_CONT);
>  
> -	} while (pte++, addr += PAGE_SIZE, addr != end);
> +		init_pte(pte, addr, next, phys, __prot);
> +
> +		phys += next - addr;
> +		pte += (next - addr) / PAGE_SIZE;
> +	} while (addr = next, addr != end);
>  
>  	pte_clear_fixmap();
>  }

I think it would be preferable to pass the pmd down into
alloc_init_pte(), so that we don't have to mess with the pte in both
alloc_init_cont_pte() and alloc_init_pte().

Likewise for alloc_init_cont_pmd() and alloc_init_pmd(), regarding the
pmd.

I realise we'll redundantly map/unmap the PTE for each contiguous span,
but I doubt there's a case it has a noticeable impact.

With lots of memory we'll use blocks at a higher level, and for
debug_pagealloc we'll pass the whole pte down to init_pte() as we
currently do.

[...]

> +	if (pud_none(*pud)) {
> +		phys_addr_t pmd_phys;
> +		BUG_ON(!pgtable_alloc);
> +		pmd_phys = pgtable_alloc();
> +		pmd = pmd_set_fixmap(pmd_phys);
> +		__pud_populate(pud, pmd_phys, PUD_TYPE_TABLE);
> +		pmd_clear_fixmap();
> +	}

It looks like when the splitting logic was removed, we forgot to remove
the fixmapping here (and for the pmd_none() case). The __p?d_populate
functions don't touch the next level table, so there's no reason to
fixmap it.

Would you mind spinning a patch to rip those out?

[...]

>  void __init create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
>  			       unsigned long virt, phys_addr_t size,
>  			       pgprot_t prot, bool page_mappings_only)
>  {
> -	int flags;
> +	int flags = NO_CONT_MAPPINGS;
>  
>  	BUG_ON(mm == &init_mm);
>  
>  	if (page_mappings_only)
> -		flags = NO_BLOCK_MAPPINGS;
> +		flags |= NO_BLOCK_MAPPINGS;

Why is it never safe to use cont mappings here?

EFI's the only caller of this, and the only case I can see that we need
to avoid contiguous entries for are the runtime services data/code, due
to efi_set_mapping_permissions(). We map those with page_mappings_only
set.

I couldn't spot why we'd need to avoid cont entries otherwise.

What am I missing?

Thanks,
Mark.
