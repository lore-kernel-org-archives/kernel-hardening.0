Date: Mon, 4 Sep 2017 13:01:33 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
In-Reply-To: <20170903120757.14968-16-ard.biesheuvel@linaro.org>
Message-ID: <nycvar.YSQ.7.76.1709041301250.8603@knanqh.ubzr>
References: <20170903120757.14968-1-ard.biesheuvel@linaro.org> <20170903120757.14968-16-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH v2 15/29] arm-soc: various: replace open coded VA->PA
 calculation of pen_release
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, Arnd Bergmann <arnd@arndb.de>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, 3 Sep 2017, Ard Biesheuvel wrote:

> This replaces a few copies of the open coded calculations of the
> physical address of 'pen_release' in the secondary startup code
> of a couple of platforms. This ensures these quantities are invariant
> under runtime relocation.
> 
> Cc: Russell King <linux@armlinux.org.uk>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Acked-by: Nicolas Pitre <nico@linaro.org>


> ---
>  arch/arm/mach-prima2/headsmp.S    | 11 +++--------
>  arch/arm/mach-spear/headsmp.S     | 11 +++--------
>  arch/arm/mach-sti/headsmp.S       | 10 +++-------
>  arch/arm/plat-versatile/headsmp.S |  9 +--------
>  4 files changed, 10 insertions(+), 31 deletions(-)
> 
> diff --git a/arch/arm/mach-prima2/headsmp.S b/arch/arm/mach-prima2/headsmp.S
> index 209d9fc5c16c..070df700bb38 100644
> --- a/arch/arm/mach-prima2/headsmp.S
> +++ b/arch/arm/mach-prima2/headsmp.S
> @@ -9,6 +9,8 @@
>  #include <linux/linkage.h>
>  #include <linux/init.h>
>  
> +#include <asm/assembler.h>
> +
>  /*
>   * SIRFSOC specific entry point for secondary CPUs.  This provides
>   * a "holding pen" into which all secondary cores are held until we're
> @@ -17,10 +19,7 @@
>  ENTRY(sirfsoc_secondary_startup)
>          mrc     p15, 0, r0, c0, c0, 5
>          and     r0, r0, #15
> -        adr     r4, 1f
> -        ldmia   r4, {r5, r6}
> -        sub     r4, r4, r5
> -        add     r6, r6, r4
> +        adr_l   r6, pen_release
>  pen:    ldr     r7, [r6]
>          cmp     r7, r0
>          bne     pen
> @@ -31,7 +30,3 @@ pen:    ldr     r7, [r6]
>           */
>          b       secondary_startup
>  ENDPROC(sirfsoc_secondary_startup)
> -
> -        .align
> -1:      .long   .
> -        .long   pen_release
> diff --git a/arch/arm/mach-spear/headsmp.S b/arch/arm/mach-spear/headsmp.S
> index c52192dc3d9f..4da01b103f33 100644
> --- a/arch/arm/mach-spear/headsmp.S
> +++ b/arch/arm/mach-spear/headsmp.S
> @@ -13,6 +13,8 @@
>  #include <linux/linkage.h>
>  #include <linux/init.h>
>  
> +#include <asm/assembler.h>
> +
>  	__INIT
>  
>  /*
> @@ -23,10 +25,7 @@
>  ENTRY(spear13xx_secondary_startup)
>  	mrc	p15, 0, r0, c0, c0, 5
>  	and	r0, r0, #15
> -	adr	r4, 1f
> -	ldmia	r4, {r5, r6}
> -	sub	r4, r4, r5
> -	add	r6, r6, r4
> +	adr_l	r6, pen_release
>  pen:	ldr	r7, [r6]
>  	cmp	r7, r0
>  	bne	pen
> @@ -40,8 +39,4 @@ pen:	ldr	r7, [r6]
>  	 * should now contain the SVC stack for this core
>  	 */
>  	b	secondary_startup
> -
> -	.align
> -1:	.long	.
> -	.long	pen_release
>  ENDPROC(spear13xx_secondary_startup)
> diff --git a/arch/arm/mach-sti/headsmp.S b/arch/arm/mach-sti/headsmp.S
> index e0ad451700d5..cdf3442f397b 100644
> --- a/arch/arm/mach-sti/headsmp.S
> +++ b/arch/arm/mach-sti/headsmp.S
> @@ -16,6 +16,8 @@
>  #include <linux/linkage.h>
>  #include <linux/init.h>
>  
> +#include <asm/assembler.h>
> +
>  /*
>   * ST specific entry point for secondary CPUs.  This provides
>   * a "holding pen" into which all secondary cores are held until we're
> @@ -24,10 +26,7 @@
>  ENTRY(sti_secondary_startup)
>  	mrc	p15, 0, r0, c0, c0, 5
>  	and	r0, r0, #15
> -	adr	r4, 1f
> -	ldmia	r4, {r5, r6}
> -	sub	r4, r4, r5
> -	add	r6, r6, r4
> +	adr_l	r6, pen_release
>  pen:	ldr	r7, [r6]
>  	cmp	r7, r0
>  	bne	pen
> @@ -38,6 +37,3 @@ pen:	ldr	r7, [r6]
>  	 */
>  	b	secondary_startup
>  ENDPROC(sti_secondary_startup)
> -
> -1:	.long	.
> -	.long	pen_release
> diff --git a/arch/arm/plat-versatile/headsmp.S b/arch/arm/plat-versatile/headsmp.S
> index 40f27e52de75..0f2a5eddac5a 100644
> --- a/arch/arm/plat-versatile/headsmp.S
> +++ b/arch/arm/plat-versatile/headsmp.S
> @@ -21,10 +21,7 @@ ENTRY(versatile_secondary_startup)
>   ARM_BE8(setend	be)
>  	mrc	p15, 0, r0, c0, c0, 5
>  	bic	r0, #0xff000000
> -	adr	r4, 1f
> -	ldmia	r4, {r5, r6}
> -	sub	r4, r4, r5
> -	add	r6, r6, r4
> +	adr_l	r6, pen_release
>  pen:	ldr	r7, [r6]
>  	cmp	r7, r0
>  	bne	pen
> @@ -34,8 +31,4 @@ pen:	ldr	r7, [r6]
>  	 * should now contain the SVC stack for this core
>  	 */
>  	b	secondary_startup
> -
> -	.align
> -1:	.long	.
> -	.long	pen_release
>  ENDPROC(versatile_secondary_startup)
> -- 
> 2.11.0
> 
> 
