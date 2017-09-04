Date: Mon, 4 Sep 2017 14:03:00 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
In-Reply-To: <20170903120757.14968-18-ard.biesheuvel@linaro.org>
Message-ID: <nycvar.YSQ.7.76.1709041326130.8603@knanqh.ubzr>
References: <20170903120757.14968-1-ard.biesheuvel@linaro.org> <20170903120757.14968-18-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH v2 17/29] ARM: kernel: use relative phys-to-virt patch
 tables
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, Arnd Bergmann <arnd@arndb.de>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, 3 Sep 2017, Ard Biesheuvel wrote:

> Replace the contents of the __pv_table entries with relative references
> so that we don't have to relocate them at runtime when running the KASLR
> kernel. This ensures these quantities are invariant under runtime
> relocation, which makes any cache maintenance after runtime relocation
> unnecessary.
> 
> Cc: Russell King <linux@armlinux.org.uk>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm/include/asm/memory.h |  6 +++---
>  arch/arm/kernel/head.S        | 21 ++++++++++----------
>  2 files changed, 13 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
> index 1f54e4e98c1e..47a984e3a244 100644
> --- a/arch/arm/include/asm/memory.h
> +++ b/arch/arm/include/asm/memory.h
> @@ -195,7 +195,7 @@ extern const void *__pv_table_begin, *__pv_table_end;
>  	__asm__("@ __pv_stub\n"				\
>  	"1:	" instr "	%0, %1, %2\n"		\
>  	"	.pushsection .pv_table,\"a\"\n"		\
> -	"	.long	1b\n"				\
> +	"	.long	1b - .\n"			\
>  	"	.popsection\n"				\

[...]

> --- a/arch/arm/kernel/head.S
> +++ b/arch/arm/kernel/head.S
> @@ -612,22 +611,22 @@ __fixup_a_pv_table:
>  	orr	r6, r6, r7, lsl #12
>  	orr	r6, #0x4000
>  	b	2f
> -1:	add     r7, r3
> -	ldrh	ip, [r7, #2]
> +1:	add	r7, r4
> +	ldrh	ip, [r7, #-2]

Please use "ldrh ip, [r7, #(-4 + 2)]" so the -4 offset is clearly 
spelled out. The #-2 gave me a pause of confusion.

>  ARM_BE8(rev16	ip, ip)
>  	tst	ip, #0x4000
>  	and	ip, #0x8f00
>  	orrne	ip, r6	@ mask in offset bits 31-24
>  	orreq	ip, r0	@ mask in offset bits 7-0
>  ARM_BE8(rev16	ip, ip)
> -	strh	ip, [r7, #2]
> +	strh	ip, [r7, #-2]

Ditto here.

>  	bne	2f
> -	ldrh	ip, [r7]
> +	ldrh	ip, [r7, #-4]

And to be clear, here I'd use "#(-4 + 0)" to be explicit.

>  ARM_BE8(rev16	ip, ip)
>  	bic	ip, #0x20
>  	orr	ip, ip, r0, lsr #16
>  ARM_BE8(rev16	ip, ip)
> -	strh	ip, [r7]
> +	strh	ip, [r7, #-4]

And so here.


With that:

Reviewed-by: Nicolas Pitre <nico@linaro.org>


>  2:	cmp	r4, r5
>  	ldrcc	r7, [r4], #4	@ use branch for delay slot
>  	bcc	1b
> @@ -639,7 +638,8 @@ ARM_BE8(rev16	ip, ip)
>  	moveq	r0, #0x400000	@ set bit 22, mov to mvn instruction
>  #endif
>  	b	2f
> -1:	ldr	ip, [r7, r3]
> +1:	ldr	ip, [r7, r4]!
> +	add	r4, r4, #4
>  #ifdef CONFIG_CPU_ENDIAN_BE8
>  	@ in BE8, we load data in BE, but instructions still in LE
>  	bic	ip, ip, #0xff000000
> @@ -654,9 +654,9 @@ ARM_BE8(rev16	ip, ip)
>  	biceq	ip, ip, #0x400000	@ clear bit 22
>  	orreq	ip, ip, r0	@ mask in offset bits 7-0
>  #endif
> -	str	ip, [r7, r3]
> +	str	ip, [r7]
>  2:	cmp	r4, r5
> -	ldrcc	r7, [r4], #4	@ use branch for delay slot
> +	ldrcc	r7, [r4]	@ use branch for delay slot
>  	bcc	1b
>  	ret	lr
>  #endif
> @@ -664,7 +664,6 @@ ENDPROC(__fixup_a_pv_table)
>  
>  ENTRY(fixup_pv_table)
>  	stmfd	sp!, {r4 - r7, lr}
> -	mov	r3, #0			@ no offset
>  	mov	r4, r0			@ r0 = table start
>  	add	r5, r0, r1		@ r1 = table size
>  	bl	__fixup_a_pv_table
> -- 
> 2.11.0
> 
> 
