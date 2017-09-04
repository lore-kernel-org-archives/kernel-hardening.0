Date: Mon, 4 Sep 2017 12:19:10 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
In-Reply-To: <20170903120757.14968-9-ard.biesheuvel@linaro.org>
Message-ID: <nycvar.YSQ.7.76.1709041215450.8603@knanqh.ubzr>
References: <20170903120757.14968-1-ard.biesheuvel@linaro.org> <20170903120757.14968-9-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH v2 08/29] ARM: head: use PC-relative insn sequence for
 __smp_alt
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, Arnd Bergmann <arnd@arndb.de>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, 3 Sep 2017, Ard Biesheuvel wrote:

> Replace the open coded PC relative offset calculations with a pair
> of adr_l invocations. This ensures these quantities are invariant
> under runtime relocation.

You probably should add that this patch must be applied on top of "ARM: 
kernel: use relative references for UP/SMP alternatives" because of the 
expected r3 value prior to that patch.

Acked-by: Nicolas Pitre <nico@linaro.org>

> Cc: Russell King <linux@armlinux.org.uk>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm/kernel/head.S | 12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
> index ec22f42fd8bb..db6b823f20a4 100644
> --- a/arch/arm/kernel/head.S
> +++ b/arch/arm/kernel/head.S
> @@ -523,19 +523,11 @@ ARM_BE8(rev	r0, r0)			@ byteswap if big endian
>  	retne	lr
>  
>  __fixup_smp_on_up:
> -	adr	r0, 1f
> -	ldmia	r0, {r3 - r5}
> -	sub	r3, r0, r3
> -	add	r4, r4, r3
> -	add	r5, r5, r3
> +	adr_l	r4, __smpalt_begin
> +	adr_l	r5, __smpalt_end
>  	b	__do_fixup_smp_on_up
>  ENDPROC(__fixup_smp)
>  
> -	.align
> -1:	.word	.
> -	.word	__smpalt_begin
> -	.word	__smpalt_end
> -
>  	.pushsection .data
>  	.globl	smp_on_up
>  smp_on_up:
> -- 
> 2.11.0
> 
> 
