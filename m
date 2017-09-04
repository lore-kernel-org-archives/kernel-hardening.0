Date: Mon, 4 Sep 2017 14:15:02 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
In-Reply-To: <20170903120757.14968-21-ard.biesheuvel@linaro.org>
Message-ID: <nycvar.YSQ.7.76.1709041412160.8603@knanqh.ubzr>
References: <20170903120757.14968-1-ard.biesheuvel@linaro.org> <20170903120757.14968-21-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH v2 20/29] ARM: kernel: use PC-relative symbol references
 in MMU switch code
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, Arnd Bergmann <arnd@arndb.de>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, 3 Sep 2017, Ard Biesheuvel wrote:

> To prepare for adding support for KASLR, which relocates all absolute
> symbol references at runtime after the caches have been enabled,
> update the MMU switch code to avoid using absolute symbol references
> where possible. This ensures these quantities are invariant under
> runtime relocation.
> 
> Cc: Russell King <linux@armlinux.org.uk>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm/kernel/head-common.S | 39 ++++++++------------
>  1 file changed, 15 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/arm/kernel/head-common.S b/arch/arm/kernel/head-common.S
> index 06035488130c..b74477507a12 100644
> --- a/arch/arm/kernel/head-common.S
> +++ b/arch/arm/kernel/head-common.S
> @@ -79,9 +79,10 @@ ENDPROC(__vet_atags)
>   */
>  	__INIT
>  __mmap_switched:
> -	adr	r3, __mmap_switched_data
> -
> -	ldmia	r3!, {r4, r5, r6, r7}
> +	adr_l	r4, __data_loc
> +	adr_l	r5, _sdata
> +	adr_l	r6, __bss_start
> +	adr_l	r7, _end
>  	cmp	r4, r5				@ Copy data segment if needed
>  1:	cmpne	r5, r6
>  	ldrne	fp, [r4], #4
> @@ -93,9 +94,17 @@ __mmap_switched:
>  	strcc	fp, [r6],#4
>  	bcc	1b
>  
> - ARM(	ldmia	r3, {r4, r5, r6, r7, sp})
> - THUMB(	ldmia	r3, {r4, r5, r6, r7}	)
> - THUMB(	ldr	sp, [r3, #16]		)
> +	adr_l	r3, init_thread_union + THREAD_START_SP
> +	mov	sp, r3
> +	adr_l	r4, processor_id
> +	adr_l	r5, __machine_arch_type
> +	adr_l	r6, __atags_pointer
> +#ifdef CONFIG_CPU_CP15
> +	adr_l	r7, cr_alignment
> +#else
> +	mov	r7, #0
> +#endif

The code that follows is testing for a non-zero r7 value to store r0 so 
you could make that code conditional rather than loading 0 here.

> +
>  	str	r9, [r4]			@ Save processor ID
>  	str	r1, [r5]			@ Save machine type
>  	str	r2, [r6]			@ Save atags pointer
> @@ -104,24 +113,6 @@ __mmap_switched:
>  	b	start_kernel
>  ENDPROC(__mmap_switched)
>  
> -	.align	2
> -	.type	__mmap_switched_data, %object
> -__mmap_switched_data:
> -	.long	__data_loc			@ r4
> -	.long	_sdata				@ r5
> -	.long	__bss_start			@ r6
> -	.long	_end				@ r7
> -	.long	processor_id			@ r4
> -	.long	__machine_arch_type		@ r5
> -	.long	__atags_pointer			@ r6
> -#ifdef CONFIG_CPU_CP15
> -	.long	cr_alignment			@ r7
> -#else
> -	.long	0				@ r7
> -#endif
> -	.long	init_thread_union + THREAD_START_SP @ sp
> -	.size	__mmap_switched_data, . - __mmap_switched_data
> -
>  /*
>   * This provides a C-API version of __lookup_processor_type
>   */
> -- 
> 2.11.0
> 
> 
