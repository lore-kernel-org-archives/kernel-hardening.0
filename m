Date: Mon, 14 Aug 2017 15:42:10 +0100
From: Dave Martin <Dave.Martin@arm.com>
Message-ID: <20170814144209.GR6321@e103592.cambridge.arm.com>
References: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
 <20170814125411.22604-18-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170814125411.22604-18-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] Re: [PATCH 17/30] arm-soc: tegra: make sleep asm code runtime
 relocatable
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: kernel-hardening@lists.openwall.com, Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Russell King <linux@armlinux.org.uk>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Thomas Garnier <thgarnie@google.com>, linux-arm-kernel@lists.infradead.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 14, 2017 at 01:53:58PM +0100, Ard Biesheuvel wrote:
> The PIE kernel build does not allow absolute references encoded in
> movw/movt instruction pairs, so use our mov_l macro instead (which
> will still use such a pair unless CONFIG_RELOCATABLE is defined)
> 
> Also, avoid 32-bit absolute literals to refer to absolute symbols.
> Instead, use a 16 bit reference so that PIE linker cannot get
> confused whether the symbol reference is subject to relocation at
> runtime.

This sounds like we're papering over something.

If the linker is "confused", that sounds like we are either abusing
it somehow, or the linker is broken.


> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm/mach-tegra/sleep-tegra20.S | 22 ++++++++++++--------
>  arch/arm/mach-tegra/sleep-tegra30.S |  6 +++---
>  arch/arm/mach-tegra/sleep.S         |  4 ++--
>  3 files changed, 18 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/arm/mach-tegra/sleep-tegra20.S b/arch/arm/mach-tegra/sleep-tegra20.S
> index 5c8e638ee51a..cab95de5c8f1 100644
> --- a/arch/arm/mach-tegra/sleep-tegra20.S
> +++ b/arch/arm/mach-tegra/sleep-tegra20.S
> @@ -99,7 +99,7 @@ ENTRY(tegra20_cpu_shutdown)
>  	cmp	r0, #0
>  	reteq	lr			@ must not be called for CPU 0
>  	mov32	r1, TEGRA_IRAM_RESET_BASE_VIRT
> -	ldr	r2, =__tegra20_cpu1_resettable_status_offset
> +	ldrh	r2, 0f
>  	mov	r12, #CPU_RESETTABLE
>  	strb	r12, [r1, r2]
>  
> @@ -121,6 +121,7 @@ ENTRY(tegra20_cpu_shutdown)
>  	beq	.
>  	ret	lr
>  ENDPROC(tegra20_cpu_shutdown)
> +0:	.short	__tegra20_cpu1_resettable_status_offset
>  #endif
>  
>  #ifdef CONFIG_PM_SLEEP
> @@ -181,6 +182,9 @@ ENTRY(tegra_pen_unlock)
>  	ret     lr
>  ENDPROC(tegra_pen_unlock)
>  
> +.L__tegra20_cpu1_resettable_status_offset:
> +	.short	__tegra20_cpu1_resettable_status_offset
> +
>  /*
>   * tegra20_cpu_clear_resettable(void)
>   *
> @@ -189,7 +193,7 @@ ENDPROC(tegra_pen_unlock)
>   */
>  ENTRY(tegra20_cpu_clear_resettable)
>  	mov32	r1, TEGRA_IRAM_RESET_BASE_VIRT

Can we simply port mov32 to mov_l?  Or do we hit a problem with
multiplatform kernels where mov_l may involve a literal pool entry
(and does it matter)?


[...]

Cheers
---Dave
