Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 2 Sep 2016 16:47:17 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160902154716.GA17347@leverpostej>
References: <1472828533-28197-1-git-send-email-catalin.marinas@arm.com>
 <1472828533-28197-8-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1472828533-28197-8-git-send-email-catalin.marinas@arm.com>
Subject: [kernel-hardening] Re: [PATCH v2 7/7] arm64: Enable CONFIG_ARM64_TTBR0_PAN
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, AKASHI Takahiro <takahiro.akashi@linaro.org>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Sep 02, 2016 at 04:02:13PM +0100, Catalin Marinas wrote:
> This patch adds the Kconfig option to enable support for TTBR0 PAN. The
> option is default off because of a slight performance hit when enabled,
> caused by the additional TTBR0_EL1 switching during user access
> operations or exception entry/exit code.
> 
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: James Morse <james.morse@arm.com>
> Cc: Kees Cook <keescook@chromium.org>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  arch/arm64/Kconfig | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index bc3f00f586f1..3fb9a6ce464d 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -785,6 +785,14 @@ config SETEND_EMULATION
>  	  If unsure, say Y
>  endif
>  
> +config ARM64_TTBR0_PAN
> +	bool "Priviledged Access Never using TTBR0_EL1 switching"

Minor nit/bikeshed, but could we follow the example of arch/arm's
SW_DOMAIN_PAN and call this ARM64_SW_TTRBR0_PAN, prepending "Emulate "
to the dsecription?

That makes it very clear that this is a SW feature, rather than using
the real PAN, but only on TTBR0.

Thanks,
Mark.

> +	help
> +	  Enabling this option prevents the kernel from accessing
> +	  user-space memory directly by pointing TTBR0_EL1 to a reserved
> +	  zeroed area and reserved ASID. The user access routines
> +	  restore the valid TTBR0_EL1 temporarily.
> +
>  menu "ARMv8.1 architectural features"
>  
>  config ARM64_HW_AFDBM
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
