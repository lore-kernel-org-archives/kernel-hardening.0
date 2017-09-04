Date: Mon, 4 Sep 2017 13:00:37 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
In-Reply-To: <20170903120757.14968-15-ard.biesheuvel@linaro.org>
Message-ID: <nycvar.YSQ.7.76.1709041300120.8603@knanqh.ubzr>
References: <20170903120757.14968-1-ard.biesheuvel@linaro.org> <20170903120757.14968-15-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH v2 14/29] arm-soc: mvebu: replace open coded VA->PA
 conversion
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, Arnd Bergmann <arnd@arndb.de>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, 3 Sep 2017, Ard Biesheuvel wrote:

> This replaces an open coded calculation to obtain the physical
> address of a far symbol with a call to the new ldr_l etc macro.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Acked-by: Nicolas Pitre <nico@linaro.org>

> ---
>  arch/arm/mach-mvebu/coherency_ll.S | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/arch/arm/mach-mvebu/coherency_ll.S b/arch/arm/mach-mvebu/coherency_ll.S
> index 8b2fbc8b6bc6..df0ccb5cef1d 100644
> --- a/arch/arm/mach-mvebu/coherency_ll.S
> +++ b/arch/arm/mach-mvebu/coherency_ll.S
> @@ -42,9 +42,7 @@ ENTRY(ll_get_coherency_base)
>  	ldr	r1, =coherency_base
>  	cmp	r1, #0
>  	beq	2f
> -	adr	r1, 3f
> -	ldr	r3, [r1]
> -	ldr	r1, [r1, r3]
> +	ldr_l	r1, coherency_phys_base
>  	b	2f
>  1:
>  	/*
> @@ -160,7 +158,3 @@ ENTRY(ll_disable_coherency)
>  	dsb
>  	ret	lr
>  ENDPROC(ll_disable_coherency)
> -
> -	.align 2
> -3:
> -	.long	coherency_phys_base - .
> -- 
> 2.11.0
> 
> 
