Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 5 Sep 2016 17:11:17 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160905161117.GB27305@leverpostej>
References: <1472828533-28197-1-git-send-email-catalin.marinas@arm.com>
 <1472828533-28197-3-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1472828533-28197-3-git-send-email-catalin.marinas@arm.com>
Subject: [kernel-hardening] Re: [PATCH v2 2/7] arm64: Factor out TTBR0_EL1 post-update
 workaround into a specific asm macro
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, AKASHI Takahiro <takahiro.akashi@linaro.org>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Catalin, 

On Fri, Sep 02, 2016 at 04:02:08PM +0100, Catalin Marinas wrote:
> This patch takes the errata workaround code out of cpu_do_switch_mm into
> a dedicated post_ttbr0_update_workaround macro which will be reused in a
> subsequent patch.

> +/*
> + * Errata workaround post TTBR0_EL1 update.
> + */
> +	.macro	post_ttbr0_update_workaround, ret = 0
> +alternative_if_not ARM64_WORKAROUND_CAVIUM_27456
> +	.if	\ret
> +	ret
> +	.endif
> +	nop
> +	nop
> +	nop
> +alternative_else
> +	ic	iallu
> +	dsb	nsh
> +	isb
> +	.if	\ret
> +	ret
> +	.endif
> +alternative_endif
> +	.endm

IMO, the ret parameter makes the callers harder to read. Can we leave
the ret up to the caller and suffer the marginal penalty of a few nops
in a slow(ish) path? 

We can get rid of them in the !CONFIG_CAVIUM_ERRATUM_27456 case with a
simple ifdef:

	.macro post_ttbr0_update_workaround	
#ifdef CONFIG_CAVIUM_ERRATUM_27456
alternative_if_not ARM64_WORKAROUND_CAVIUM_27456
	nop
	nop
	nop
alternative_else
	ic	iallu
	dsb	nsh
	isb
alternative_endif
#endif
	.endm

> +
>  #endif	/* __ASM_ASSEMBLER_H */
> diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
> index 5bb61de23201..9359659f2559 100644
> --- a/arch/arm64/mm/proc.S
> +++ b/arch/arm64/mm/proc.S
> @@ -125,17 +125,7 @@ ENTRY(cpu_do_switch_mm)
>  	bfi	x0, x1, #48, #16		// set the ASID
>  	msr	ttbr0_el1, x0			// set TTBR0
>  	isb
> -alternative_if_not ARM64_WORKAROUND_CAVIUM_27456
> -	ret
> -	nop
> -	nop
> -	nop
> -alternative_else
> -	ic	iallu
> -	dsb	nsh
> -	isb
> -	ret
> -alternative_endif
> +	post_ttbr0_update_workaround ret = 1

+	ret

Thanks,
Mark,
