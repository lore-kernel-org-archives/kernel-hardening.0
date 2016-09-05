Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 5 Sep 2016 16:38:28 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160905153828.GA27305@leverpostej>
References: <1472828533-28197-1-git-send-email-catalin.marinas@arm.com>
 <1472828533-28197-2-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1472828533-28197-2-git-send-email-catalin.marinas@arm.com>
Subject: [kernel-hardening] Re: [PATCH v2 1/7] arm64: Factor out PAN enabling/disabling into
 separate uaccess_* macros
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, AKASHI Takahiro <takahiro.akashi@linaro.org>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Catalin,

On Fri, Sep 02, 2016 at 04:02:07PM +0100, Catalin Marinas wrote:
> This patch moves the directly coded alternatives for turning PAN on/off
> into separate uaccess_{enable,disable} macros or functions. The asm
> macros take a few arguments which will be used in subsequent patches.
> 
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: James Morse <james.morse@arm.com>
> Cc: Kees Cook <keescook@chromium.org>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  arch/arm64/include/asm/futex.h       | 14 ++++-----
>  arch/arm64/include/asm/uaccess.h     | 55 ++++++++++++++++++++++++++++++------
>  arch/arm64/kernel/armv8_deprecated.c | 10 +++----
>  arch/arm64/lib/clear_user.S          |  8 ++----
>  arch/arm64/lib/copy_from_user.S      |  8 ++----
>  arch/arm64/lib/copy_in_user.S        |  8 ++----
>  arch/arm64/lib/copy_to_user.S        |  8 ++----
>  7 files changed, 71 insertions(+), 40 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
> index f2585cdd32c2..7e5f236093be 100644
> --- a/arch/arm64/include/asm/futex.h
> +++ b/arch/arm64/include/asm/futex.h
> @@ -27,9 +27,9 @@
>  #include <asm/sysreg.h>
>  
>  #define __futex_atomic_op(insn, ret, oldval, uaddr, tmp, oparg)		\
> +do {									\
> +	uaccess_enable(ARM64_HAS_PAN);					\
>  	asm volatile(							\
> -	ALTERNATIVE("nop", SET_PSTATE_PAN(0), ARM64_HAS_PAN,		\
> -		    CONFIG_ARM64_PAN)					\
>  "	prfm	pstl1strm, %2\n"					\
>  "1:	ldxr	%w1, %2\n"						\
>  	insn "\n"							\
> @@ -44,11 +44,11 @@
>  "	.popsection\n"							\
>  	_ASM_EXTABLE(1b, 4b)						\
>  	_ASM_EXTABLE(2b, 4b)						\
> -	ALTERNATIVE("nop", SET_PSTATE_PAN(1), ARM64_HAS_PAN,		\
> -		    CONFIG_ARM64_PAN)					\
>  	: "=&r" (ret), "=&r" (oldval), "+Q" (*uaddr), "=&r" (tmp)	\
>  	: "r" (oparg), "Ir" (-EFAULT)					\
> -	: "memory")
> +	: "memory");							\
> +	uaccess_disable(ARM64_HAS_PAN);					\
> +} while (0)

It might be worth noting in the commit message that this change means
that any memory accesses the compiler decides to spill between uaccess_*
calls and the main asm block are unprotected, but that's unlikely to be
an issue in practice.

[...]

>  /*
> + * User access enabling/disabling.
> + */
> +#define uaccess_disable(alt)						\
> +do {									\
> +	asm(ALTERNATIVE("nop", SET_PSTATE_PAN(1), alt,			\
> +			CONFIG_ARM64_PAN));				\
> +} while (0)
> +
> +#define uaccess_enable(alt)						\
> +do {									\
> +	asm(ALTERNATIVE("nop", SET_PSTATE_PAN(0), alt,			\
> +			CONFIG_ARM64_PAN));				\
> +} while (0)

Passing the alternative down is somewhat confusing. e.g. in the futex
case it looks like we're only doing something when PAN is present,
whereas we'll manipulate TTBR0 in the absence of PAN.

If I've understood correctly, we need this to distinguish regular
load/store uaccess sequences (eg. the futex code) from potentially
patched unprivileged load/store sequences (e.g. {get,put}_user) when
poking PSTATE.PAN.

So perhaps we could ahve something like:

* privileged_uaccess_{enable,disable}()
  Which toggle TTBR0, or PAN (always).
  These would handle cases like the futex/swp code.
 
* (unprivileged_)uaccess_{enable,disable}()
  Which toggle TTBR0, or PAN (in the absence of UAO).
  These would handle cases like the {get,put}_user sequences.

Though perhaps that is just as confusing. ;)

Otherwise, this looks like a nice centralisation of the PSTATE.PAN
manipulation code.

Thanks,
Mark.
