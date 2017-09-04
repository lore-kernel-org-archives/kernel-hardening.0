Date: Mon, 4 Sep 2017 12:08:25 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
In-Reply-To: <20170903120757.14968-6-ard.biesheuvel@linaro.org>
Message-ID: <nycvar.YSQ.7.76.1709041208020.8603@knanqh.ubzr>
References: <20170903120757.14968-1-ard.biesheuvel@linaro.org> <20170903120757.14968-6-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH v2 05/29] ARM: head-common.S: use PC-relative insn sequence
 for idmap creation
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, Arnd Bergmann <arnd@arndb.de>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, 3 Sep 2017, Ard Biesheuvel wrote:

> Replace the open coded PC relative offset calculations involving
> __turn_mmu_on and __turn_mmu_on_end with a pair of adr_l invocations.
> This ensures these quantities are invariant under runtime relocation.
> 
> Cc: Russell King <linux@armlinux.org.uk>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Acked-by: Nicolas Pitre <nico@linaro.org>

> ---
>  arch/arm/kernel/head.S | 12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
> index 04286fd9e09c..0a98aec0e39d 100644
> --- a/arch/arm/kernel/head.S
> +++ b/arch/arm/kernel/head.S
> @@ -227,11 +227,8 @@ __create_page_tables:
>  	 * Create identity mapping to cater for __enable_mmu.
>  	 * This identity mapping will be removed by paging_init().
>  	 */
> -	adr	r0, __turn_mmu_on_loc
> -	ldmia	r0, {r3, r5, r6}
> -	sub	r0, r0, r3			@ virt->phys offset
> -	add	r5, r5, r0			@ phys __turn_mmu_on
> -	add	r6, r6, r0			@ phys __turn_mmu_on_end
> +	adr_l	r5, __turn_mmu_on		@ _pa(__turn_mmu_on)
> +	adr_l	r6, __turn_mmu_on_end		@ _pa(__turn_mmu_on_end)
>  	mov	r5, r5, lsr #SECTION_SHIFT
>  	mov	r6, r6, lsr #SECTION_SHIFT
>  
> @@ -354,11 +351,6 @@ __create_page_tables:
>  	ret	lr
>  ENDPROC(__create_page_tables)
>  	.ltorg
> -	.align
> -__turn_mmu_on_loc:
> -	.long	.
> -	.long	__turn_mmu_on
> -	.long	__turn_mmu_on_end
>  
>  #if defined(CONFIG_SMP)
>  	.text
> -- 
> 2.11.0
> 
> 
