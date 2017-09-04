Date: Mon, 4 Sep 2017 12:15:32 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
In-Reply-To: <20170903120757.14968-8-ard.biesheuvel@linaro.org>
Message-ID: <nycvar.YSQ.7.76.1709041215010.8603@knanqh.ubzr>
References: <20170903120757.14968-1-ard.biesheuvel@linaro.org> <20170903120757.14968-8-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH v2 07/29] ARM: kernel: use relative references for UP/SMP
 alternatives
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, Arnd Bergmann <arnd@arndb.de>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, 3 Sep 2017, Ard Biesheuvel wrote:

> To avoid absolute references that are subject to runtime relocation
> when running a kernel built with CONFIG_RELOCATABLE=y, use relative
> references in the smp.alt entries.
> 
> Cc: Russell King <linux@armlinux.org.uk>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Acked-by: Nicolas Pitre <nico@linaro.org>

> ---
>  arch/arm/include/asm/assembler.h |  4 ++--
>  arch/arm/include/asm/processor.h |  2 +-
>  arch/arm/kernel/head.S           | 10 +++++-----
>  3 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm/include/asm/assembler.h b/arch/arm/include/asm/assembler.h
> index 341e4ed1ef84..a0906c1fc65d 100644
> --- a/arch/arm/include/asm/assembler.h
> +++ b/arch/arm/include/asm/assembler.h
> @@ -260,7 +260,7 @@
>   */
>  #define ALT_UP(instr...)					\
>  	.pushsection ".alt.smp.init", "a"			;\
> -	.long	9998b						;\
> +	.long	9998b - .					;\
>  9997:	instr							;\
>  	.if . - 9997b == 2					;\
>  		nop						;\
> @@ -272,7 +272,7 @@
>  #define ALT_UP_B(label)					\
>  	.equ	up_b_offset, label - 9998b			;\
>  	.pushsection ".alt.smp.init", "a"			;\
> -	.long	9998b						;\
> +	.long	9998b - .					;\
>  	W(b)	. + up_b_offset					;\
>  	.popsection
>  #else
> diff --git a/arch/arm/include/asm/processor.h b/arch/arm/include/asm/processor.h
> index c3d5fc124a05..3667b395bb17 100644
> --- a/arch/arm/include/asm/processor.h
> +++ b/arch/arm/include/asm/processor.h
> @@ -92,7 +92,7 @@ unsigned long get_wchan(struct task_struct *p);
>  #define __ALT_SMP_ASM(smp, up)						\
>  	"9998:	" smp "\n"						\
>  	"	.pushsection \".alt.smp.init\", \"a\"\n"		\
> -	"	.long	9998b\n"					\
> +	"	.long	9998b - .\n"					\
>  	"	" up "\n"						\
>  	"	.popsection\n"
>  #else
> diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
> index 6e9df3663a57..ec22f42fd8bb 100644
> --- a/arch/arm/kernel/head.S
> +++ b/arch/arm/kernel/head.S
> @@ -548,14 +548,15 @@ smp_on_up:
>  __do_fixup_smp_on_up:
>  	cmp	r4, r5
>  	reths	lr
> -	ldmia	r4!, {r0, r6}
> - ARM(	str	r6, [r0, r3]	)
> - THUMB(	add	r0, r0, r3	)
> +	ldmia	r4, {r0, r6}
> + ARM(	str	r6, [r0, r4]	)
> + THUMB(	add	r0, r0, r4	)
> +	add	r4, r4, #8
>  #ifdef __ARMEB__
>   THUMB(	mov	r6, r6, ror #16	)	@ Convert word order for big-endian.
>  #endif
>   THUMB(	strh	r6, [r0], #2	)	@ For Thumb-2, store as two halfwords
> - THUMB(	mov	r6, r6, lsr #16	)	@ to be robust against misaligned r3.
> + THUMB(	mov	r6, r6, lsr #16	)	@ to be robust against misaligned r0.
>   THUMB(	strh	r6, [r0]	)
>  	b	__do_fixup_smp_on_up
>  ENDPROC(__do_fixup_smp_on_up)
> @@ -564,7 +565,6 @@ ENTRY(fixup_smp)
>  	stmfd	sp!, {r4 - r6, lr}
>  	mov	r4, r0
>  	add	r5, r0, r1
> -	mov	r3, #0
>  	bl	__do_fixup_smp_on_up
>  	ldmfd	sp!, {r4 - r6, pc}
>  ENDPROC(fixup_smp)
> -- 
> 2.11.0
> 
> 
