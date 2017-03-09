Date: Thu, 9 Mar 2017 18:04:06 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170309180406.GE11966@leverpostej>
References: <1489047912-642-1-git-send-email-ard.biesheuvel@linaro.org>
 <1489047912-642-9-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1489047912-642-9-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] Re: [PATCH v5 08/10] arm64/mmu: add contiguous bit to sanity bug
 check
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, keescook@chromium.org, labbott@fedoraproject.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 09, 2017 at 09:25:10AM +0100, Ard Biesheuvel wrote:
> A mapping with the contiguous bit cannot be safely manipulated while
> live, regardless of whether the bit changes between the old and new
> mapping. So take this into account when deciding whether the change
> is safe.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Reviewed-by: Mark Rutland <mark.rutland@arm.com>

Strictly speaking, I think this is marginally more stringent than what
the ARM ARM describes. My reading is that the "Misprogramming of the
Contiguous bit" rules only apply when there are multiple valid entries,
and hence if you had a contiguous span with only a single valid entry
(and TLBs up-to-date), you could modify that in-place so long as you
followed the usual BBM rules.

However, I don't see us ever (deliberately) doing that, given it would
require more work, and there's no guarantee that the CPU would consider
the whole span as being mapped. It's also possible my reading of the ARM
ARM is flawed.

Thanks,
Mark.

> ---
>  arch/arm64/mm/mmu.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index d3fecd20a136..a6d7a86dd2b8 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -103,7 +103,15 @@ static bool pgattr_change_is_safe(u64 old, u64 new)
>  	 */
>  	static const pteval_t mask = PTE_PXN | PTE_RDONLY | PTE_WRITE;
>  
> -	return old  == 0 || new  == 0 || ((old ^ new) & ~mask) == 0;
> +	/* creating or taking down mappings is always safe */
> +	if (old == 0 || new == 0)
> +		return true;
> +
> +	/* live contiguous mappings may not be manipulated at all */
> +	if ((old | new) & PTE_CONT)
> +		return false;
> +
> +	return ((old ^ new) & ~mask) == 0;
>  }
>  
>  static void alloc_init_pte(pmd_t *pmd, unsigned long addr,
> -- 
> 2.7.4
> 
