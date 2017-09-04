Date: Mon, 4 Sep 2017 14:47:42 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
In-Reply-To: <20170903120757.14968-26-ard.biesheuvel@linaro.org>
Message-ID: <nycvar.YSQ.7.76.1709041447040.8603@knanqh.ubzr>
References: <20170903120757.14968-1-ard.biesheuvel@linaro.org> <20170903120757.14968-26-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH v2 25/29] ARM: decompressor: explicitly map decompressor
 binary cacheable
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, Arnd Bergmann <arnd@arndb.de>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, 3 Sep 2017, Ard Biesheuvel wrote:

> When randomizing the kernel load address, there may be a large
> distance in memory between the decompressor binary and its payload
> and the destination area in memory. Ensure that the decompressor
> itself is mapped cacheable in this case, by tweaking the existing
> routine that takes care of this for XIP decompressors.
> 
> Cc: Russell King <linux@armlinux.org.uk>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Acked-by: Nicolas Pitre <nico@linaro.org>

> ---
>  arch/arm/boot/compressed/head.S | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
> index 5884e8151376..583cc6899d98 100644
> --- a/arch/arm/boot/compressed/head.S
> +++ b/arch/arm/boot/compressed/head.S
> @@ -706,20 +706,24 @@ __setup_mmu:	sub	r3, r4, #16384		@ Page directory size
>  		teq	r0, r2
>  		bne	1b
>  /*
> - * If ever we are running from Flash, then we surely want the cache
> - * to be enabled also for our execution instance...  We map 2MB of it
> - * so there is no map overlap problem for up to 1 MB compressed kernel.
> - * If the execution is in RAM then we would only be duplicating the above.
> + * Make sure our entire executable image (including payload) is mapped
> + * cacheable, in case it is located outside the region we covered above.
> + * (This may be the case if running from flash or with randomization enabled)
> + * If the regions happen to overlap, we just duplicate some of the above.
>   */
>  		orr	r1, r6, #0x04		@ ensure B is set for this
>  		orr	r1, r1, #3 << 10
>  		mov	r2, pc
> +		adr_l	r9, _end
>  		mov	r2, r2, lsr #20
> +		mov	r9, r9, lsr #20
>  		orr	r1, r1, r2, lsl #20
>  		add	r0, r3, r2, lsl #2
> -		str	r1, [r0], #4
> +		add	r9, r3, r9, lsl #2
> +0:		str	r1, [r0], #4
>  		add	r1, r1, #1048576
> -		str	r1, [r0]
> +		cmp	r0, r9
> +		bls	0b
>  		mov	pc, lr
>  ENDPROC(__setup_mmu)
>  
> -- 
> 2.11.0
> 
> 
