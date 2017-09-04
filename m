Date: Mon, 4 Sep 2017 12:06:50 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
In-Reply-To: <20170903120757.14968-5-ard.biesheuvel@linaro.org>
Message-ID: <nycvar.YSQ.7.76.1709041206300.8603@knanqh.ubzr>
References: <20170903120757.14968-1-ard.biesheuvel@linaro.org> <20170903120757.14968-5-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH v2 04/29] ARM: head-common.S: use PC-relative insn sequence
 for __proc_info
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, Arnd Bergmann <arnd@arndb.de>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, 3 Sep 2017, Ard Biesheuvel wrote:

> Replace the open coded PC relative offset calculations with a pair
> of adr_l invocations. This ensures these quantities are invariant
> under runtime relocation.
> 
> Cc: Russell King <linux@armlinux.org.uk>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Acked-by: Nicolas Pitre <nico@linaro.org>


> ---
>  arch/arm/kernel/head-common.S | 22 ++++++--------------
>  1 file changed, 6 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/arm/kernel/head-common.S b/arch/arm/kernel/head-common.S
> index 8733012d231f..06035488130c 100644
> --- a/arch/arm/kernel/head-common.S
> +++ b/arch/arm/kernel/head-common.S
> @@ -150,11 +150,12 @@ ENDPROC(lookup_processor_type)
>   *	r9 = cpuid (preserved)
>   */
>  __lookup_processor_type:
> -	adr	r3, __lookup_processor_type_data
> -	ldmia	r3, {r4 - r6}
> -	sub	r3, r3, r4			@ get offset between virt&phys
> -	add	r5, r5, r3			@ convert virt addresses to
> -	add	r6, r6, r3			@ physical address space
> +	/*
> +	 * Look in <asm/procinfo.h> for information about the __proc_info
> +	 * structure.
> +	 */
> +	adr_l	r5, __proc_info_begin
> +	adr_l	r6, __proc_info_end
>  1:	ldmia	r5, {r3, r4}			@ value, mask
>  	and	r4, r4, r9			@ mask wanted bits
>  	teq	r3, r4
> @@ -166,17 +167,6 @@ __lookup_processor_type:
>  2:	ret	lr
>  ENDPROC(__lookup_processor_type)
>  
> -/*
> - * Look in <asm/procinfo.h> for information about the __proc_info structure.
> - */
> -	.align	2
> -	.type	__lookup_processor_type_data, %object
> -__lookup_processor_type_data:
> -	.long	.
> -	.long	__proc_info_begin
> -	.long	__proc_info_end
> -	.size	__lookup_processor_type_data, . - __lookup_processor_type_data
> -
>  __error_lpae:
>  #ifdef CONFIG_DEBUG_LL
>  	adr	r0, str_lpae
> -- 
> 2.11.0
> 
> 
