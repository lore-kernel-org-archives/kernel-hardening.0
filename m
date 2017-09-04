Date: Mon, 4 Sep 2017 12:20:47 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
In-Reply-To: <20170903120757.14968-10-ard.biesheuvel@linaro.org>
Message-ID: <nycvar.YSQ.7.76.1709041219510.8603@knanqh.ubzr>
References: <20170903120757.14968-1-ard.biesheuvel@linaro.org> <20170903120757.14968-10-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH v2 09/29] ARM: sleep.S: use PC-relative insn sequence
 for sleep_save_sp/mpidr_hash
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, Arnd Bergmann <arnd@arndb.de>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, 3 Sep 2017, Ard Biesheuvel wrote:

> Replace the open coded PC relative offset calculations with adr_l and
> ldr_l invocations. Note that ALT_SMP() expects a single instruction
> so move the macro invocation after it.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Acked-by: Nicolas Pitre <nico@linaro.org>

> ---
>  arch/arm/kernel/sleep.S | 19 +++++--------------
>  1 file changed, 5 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/arm/kernel/sleep.S b/arch/arm/kernel/sleep.S
> index 0f6c1000582c..f4920b5d0fc4 100644
> --- a/arch/arm/kernel/sleep.S
> +++ b/arch/arm/kernel/sleep.S
> @@ -71,8 +71,9 @@ ENTRY(__cpu_suspend)
>  	ldr	r3, =sleep_save_sp
>  	stmfd	sp!, {r0, r1}		@ save suspend func arg and pointer
>  	ldr	r3, [r3, #SLEEP_SAVE_SP_VIRT]
> -	ALT_SMP(ldr r0, =mpidr_hash)
> +	ALT_SMP(W(nop))			@ don't use adr_l inside ALT_SMP()
>  	ALT_UP_B(1f)
> +	adr_l	r0, mpidr_hash
>  	/* This ldmia relies on the memory layout of the mpidr_hash struct */
>  	ldmia	r0, {r1, r6-r8}	@ r1 = mpidr mask (r6,r7,r8) = l[0,1,2] shifts
>  	compute_mpidr_hash	r0, r6, r7, r8, r2, r1
> @@ -137,9 +138,8 @@ ARM_BE8(setend be)			@ ensure we are in BE mode
>  	mov	r1, #0
>  	ALT_SMP(mrc p15, 0, r0, c0, c0, 5)
>  	ALT_UP_B(1f)
> -	adr	r2, mpidr_hash_ptr
> -	ldr	r3, [r2]
> -	add	r2, r2, r3		@ r2 = struct mpidr_hash phys address
> +	adr_l	r2, mpidr_hash		@ r2 = struct mpidr_hash phys address
> +
>  	/*
>  	 * This ldmia relies on the memory layout of the mpidr_hash
>  	 * struct mpidr_hash.
> @@ -147,10 +147,7 @@ ARM_BE8(setend be)			@ ensure we are in BE mode
>  	ldmia	r2, { r3-r6 }	@ r3 = mpidr mask (r4,r5,r6) = l[0,1,2] shifts
>  	compute_mpidr_hash	r1, r4, r5, r6, r0, r3
>  1:
> -	adr	r0, _sleep_save_sp
> -	ldr	r2, [r0]
> -	add	r0, r0, r2
> -	ldr	r0, [r0, #SLEEP_SAVE_SP_PHYS]
> +	ldr_l	r0, sleep_save_sp + SLEEP_SAVE_SP_PHYS
>  	ldr	r0, [r0, r1, lsl #2]
>  
>  	@ load phys pgd, stack, resume fn
> @@ -164,12 +161,6 @@ ENDPROC(cpu_resume)
>  ENDPROC(cpu_resume_arm)
>  #endif
>  
> -	.align 2
> -_sleep_save_sp:
> -	.long	sleep_save_sp - .
> -mpidr_hash_ptr:
> -	.long	mpidr_hash - .			@ mpidr_hash struct offset
> -
>  	.data
>  	.type	sleep_save_sp, #object
>  ENTRY(sleep_save_sp)
> -- 
> 2.11.0
> 
> 
