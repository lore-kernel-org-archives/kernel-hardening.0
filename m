Date: Thu, 9 Mar 2017 18:19:53 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170309181953.GF11966@leverpostej>
References: <1489047912-642-1-git-send-email-ard.biesheuvel@linaro.org>
 <1489047912-642-10-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1489047912-642-10-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] Re: [PATCH v5 09/10] arm64/mmu: replace 'page_mappings_only'
 parameter with flags argument
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, keescook@chromium.org, labbott@fedoraproject.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 09, 2017 at 09:25:11AM +0100, Ard Biesheuvel wrote:
> In preparation of extending the policy for manipulating kernel mappings
> with whether or not contiguous hints may be used in the page tables,
> replace the bool 'page_mappings_only' with a flags field and a flag
> NO_BLOCK_MAPPINGS.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Thanks for attacking this.

I was going to comment on the name change, but I see that the next patch
introduces and uses NO_CONT_MAPPINGS, so that's fine by me.

>  void __init create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
>  			       unsigned long virt, phys_addr_t size,
>  			       pgprot_t prot, bool page_mappings_only)
>  {
> +	int flags;
> +
>  	BUG_ON(mm == &init_mm);
>  
> +	if (page_mappings_only)
> +		flags = NO_BLOCK_MAPPINGS;

> +
>  	__create_pgd_mapping(mm->pgd, phys, virt, size, prot,
> -			     pgd_pgtable_alloc, page_mappings_only);
> +			     pgd_pgtable_alloc, flags);
>  }

Given we can't pass the flags in to create_pgd_mapping() without
exposing those more generally, this also looks fine.

FWIW:

Reviewed-by: Mark Rutland <mark.rutland@arm.com>

Mark.
