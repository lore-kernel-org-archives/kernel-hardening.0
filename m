Date: Mon, 4 Sep 2017 12:09:55 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
In-Reply-To: <20170903120757.14968-7-ard.biesheuvel@linaro.org>
Message-ID: <nycvar.YSQ.7.76.1709041209470.8603@knanqh.ubzr>
References: <20170903120757.14968-1-ard.biesheuvel@linaro.org> <20170903120757.14968-7-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH v2 06/29] ARM: head.S: use PC-relative insn sequence for
 secondary_data
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, Arnd Bergmann <arnd@arndb.de>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, 3 Sep 2017, Ard Biesheuvel wrote:

> Replace the open coded PC relative offset calculations with adr_l
> and ldr_l invocations. This ensures these quantities are invariant
> under runtime relocation.
> 
> Cc: Russell King <linux@armlinux.org.uk>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Acked-by: Nicolas Pitre <nico@linaro.org>

> ---
>  arch/arm/kernel/head.S | 19 ++++---------------
>  1 file changed, 4 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
> index 0a98aec0e39d..6e9df3663a57 100644
> --- a/arch/arm/kernel/head.S
> +++ b/arch/arm/kernel/head.S
> @@ -386,10 +386,8 @@ ENTRY(secondary_startup)
>  	/*
>  	 * Use the page tables supplied from  __cpu_up.
>  	 */
> -	adr	r4, __secondary_data
> -	ldmia	r4, {r5, r7, r12}		@ address to jump to after
> -	sub	lr, r4, r5			@ mmu has been enabled
> -	add	r3, r7, lr
> +	adr_l	r3, secondary_data
> +	mov_l	r12, __secondary_switched
>  	ldrd	r4, [r3, #0]			@ get secondary_data.pgdir
>  ARM_BE8(eor	r4, r4, r5)			@ Swap r5 and r4 in BE:
>  ARM_BE8(eor	r5, r4, r5)			@ it can be done in 3 steps
> @@ -404,22 +402,13 @@ ARM_BE8(eor	r4, r4, r5)			@ without using a temp reg.
>  ENDPROC(secondary_startup)
>  ENDPROC(secondary_startup_arm)
>  
> -	/*
> -	 * r6  = &secondary_data
> -	 */
>  ENTRY(__secondary_switched)
> -	ldr	sp, [r7, #12]			@ get secondary_data.stack
> +	ldr_l	r7, secondary_data + 12		@ get secondary_data.stack
> +	mov	sp, r7
>  	mov	fp, #0
>  	b	secondary_start_kernel
>  ENDPROC(__secondary_switched)
>  
> -	.align
> -
> -	.type	__secondary_data, %object
> -__secondary_data:
> -	.long	.
> -	.long	secondary_data
> -	.long	__secondary_switched
>  #endif /* defined(CONFIG_SMP) */
>  
>  
> -- 
> 2.11.0
> 
> 
