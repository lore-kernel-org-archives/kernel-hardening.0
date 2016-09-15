Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 15 Sep 2016 16:10:45 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160915151045.GD9316@leverpostej>
References: <1473788797-10879-1-git-send-email-catalin.marinas@arm.com>
 <1473788797-10879-2-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1473788797-10879-2-git-send-email-catalin.marinas@arm.com>
Subject: [kernel-hardening] Re: [PATCH v3 1/7] arm64: Factor out PAN enabling/disabling into
 separate uaccess_* macros
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Kees Cook <keescook@chromium.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, AKASHI Takahiro <takahiro.akashi@linaro.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Catalin,

On Tue, Sep 13, 2016 at 06:46:31PM +0100, Catalin Marinas wrote:
> This patch moves the directly coded alternatives for turning PAN on/off
> into separate uaccess_{enable,disable} macros or functions. The asm
> macros take a few arguments which will be used in subsequent patches.
> 
> Note that any (unlikely) access that the compiler might generate between
> uaccess_enable() and uaccess_disable(), other than those explicitly
> specified by the user access code, will not be protected by PAN.

There's one missing include that I've noted below, along with a number
we can now drop. Otherwise, the important parts all look good to me.

With the includes fixed up:

Reviewed-by: Mark Rutland <mark.rutland@arm.com>

[...]

> Cc: Will Deacon <will.deacon@arm.com>
> Cc: James Morse <james.morse@arm.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  arch/arm64/include/asm/futex.h       | 14 +++----
>  arch/arm64/include/asm/uaccess.h     | 79 ++++++++++++++++++++++++++++++++----
>  arch/arm64/kernel/armv8_deprecated.c | 10 ++---
>  arch/arm64/lib/clear_user.S          |  8 ++--
>  arch/arm64/lib/copy_from_user.S      |  8 ++--
>  arch/arm64/lib/copy_in_user.S        |  8 ++--
>  arch/arm64/lib/copy_to_user.S        |  8 ++--
>  7 files changed, 95 insertions(+), 40 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
> index f2585cdd32c2..71dfa3b42313 100644
> --- a/arch/arm64/include/asm/futex.h
> +++ b/arch/arm64/include/asm/futex.h
> @@ -27,9 +27,9 @@
>  #include <asm/sysreg.h>
>  
>  #define __futex_atomic_op(insn, ret, oldval, uaddr, tmp, oparg)		\
> +do {									\
> +	uaccess_enable();						\
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
> +	uaccess_disable();						\
> +} while (0)

With the uaccess_{enable,disable}* macros, we can drop the includes for
<asm/alternative.h>, <asm/cpufeature.h>, and <asm/sysreg.h> from
futex.h, as we no longer (directly) use anything from those.

[...]

> diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
> index c47257c91b77..cc6c32d4dcc4 100644
> --- a/arch/arm64/include/asm/uaccess.h
> +++ b/arch/arm64/include/asm/uaccess.h

> @@ -321,4 +357,31 @@ extern long strncpy_from_user(char *dest, const char __user *src, long count);
>  extern __must_check long strlen_user(const char __user *str);
>  extern __must_check long strnlen_user(const char __user *str, long n);
>  
> +#else	/* __ASSEMBLY__ */
> +
> +#include <asm/alternative.h>
> +#include <asm/assembler.h>

We also need <asm/sysreg.h> for SET_PSTATE_PAN()

Given we use that and <asm/alternative.h> either way, should we pull
those above the #ifdef __ASSEMBLY__? I have no feeling either way.

[...]

> diff --git a/arch/arm64/kernel/armv8_deprecated.c b/arch/arm64/kernel/armv8_deprecated.c
> index 42ffdb54e162..7156e7bfcd89 100644
> --- a/arch/arm64/kernel/armv8_deprecated.c
> +++ b/arch/arm64/kernel/armv8_deprecated.c
> @@ -281,9 +281,9 @@ static void __init register_insn_emulation_sysctl(struct ctl_table *table)
>   * Error-checking SWP macros implemented using ldxr{b}/stxr{b}
>   */
>  #define __user_swpX_asm(data, addr, res, temp, B)		\
> +do {								\
> +	uaccess_enable();					\
>  	__asm__ __volatile__(					\
> -	ALTERNATIVE("nop", SET_PSTATE_PAN(0), ARM64_HAS_PAN,	\
> -		    CONFIG_ARM64_PAN)				\
>  	"0:	ldxr"B"		%w2, [%3]\n"			\
>  	"1:	stxr"B"		%w0, %w1, [%3]\n"		\
>  	"	cbz		%w0, 2f\n"			\
> @@ -299,11 +299,11 @@ static void __init register_insn_emulation_sysctl(struct ctl_table *table)
>  	"	.popsection"					\
>  	_ASM_EXTABLE(0b, 4b)					\
>  	_ASM_EXTABLE(1b, 4b)					\
> -	ALTERNATIVE("nop", SET_PSTATE_PAN(1), ARM64_HAS_PAN,	\
> -		CONFIG_ARM64_PAN)				\
>  	: "=&r" (res), "+r" (data), "=&r" (temp)		\
>  	: "r" (addr), "i" (-EAGAIN), "i" (-EFAULT)		\
> -	: "memory")
> +	: "memory");						\
> +	uaccess_disable();					\
> +} while (0)

With this, we can drop the include of <asm/alternative.h>, though unlike
futex.h we need to keep <asm/cpufeature.h> and <asm/sysreg.h>.

[...]

> diff --git a/arch/arm64/lib/clear_user.S b/arch/arm64/lib/clear_user.S
> index 5d1cad3ce6d6..08b5f18ba604 100644
> --- a/arch/arm64/lib/clear_user.S
> +++ b/arch/arm64/lib/clear_user.S
> @@ -17,10 +17,10 @@
>   */
>  #include <linux/linkage.h>
>  
> -#include <asm/alternative.h>
>  #include <asm/assembler.h>
>  #include <asm/cpufeature.h>
>  #include <asm/sysreg.h>
> +#include <asm/uaccess.h>

As with futex.h, we can drop <asm/assembler.h>, <asm/cpufeature.h>, and
<asm/sysreg.h>, as the uaccess_{enable,disable}* macros mean we no
longer use anything from those directly.

[...]

> diff --git a/arch/arm64/lib/copy_from_user.S b/arch/arm64/lib/copy_from_user.S
> index 0b90497d4424..6505ec81f1da 100644
> --- a/arch/arm64/lib/copy_from_user.S
> +++ b/arch/arm64/lib/copy_from_user.S
> @@ -16,11 +16,11 @@
>  
>  #include <linux/linkage.h>
>  
> -#include <asm/alternative.h>
>  #include <asm/assembler.h>
>  #include <asm/cache.h>
>  #include <asm/cpufeature.h>
>  #include <asm/sysreg.h>
> +#include <asm/uaccess.h>

Likewise, we can also drop <asm/assembler.h>, <asm/cpufeature.h>, and
<asm/sysreg.h> here.

[...]

> diff --git a/arch/arm64/lib/copy_in_user.S b/arch/arm64/lib/copy_in_user.S
> index f7292dd08c84..9b04ff3ab610 100644
> --- a/arch/arm64/lib/copy_in_user.S
> +++ b/arch/arm64/lib/copy_in_user.S
> @@ -18,11 +18,11 @@
>  
>  #include <linux/linkage.h>
>  
> -#include <asm/alternative.h>
>  #include <asm/assembler.h>
>  #include <asm/cache.h>
>  #include <asm/cpufeature.h>
>  #include <asm/sysreg.h>
> +#include <asm/uaccess.h>

Likewise, we can also drop <asm/assembler.h>, <asm/cpufeature.h>, and
<asm/sysreg.h> here.

[...]

> diff --git a/arch/arm64/lib/copy_to_user.S b/arch/arm64/lib/copy_to_user.S
> index 7a7efe255034..8077e4f34d56 100644
> --- a/arch/arm64/lib/copy_to_user.S
> +++ b/arch/arm64/lib/copy_to_user.S
> @@ -16,11 +16,11 @@
>  
>  #include <linux/linkage.h>
>  
> -#include <asm/alternative.h>
>  #include <asm/assembler.h>
>  #include <asm/cache.h>
>  #include <asm/cpufeature.h>
>  #include <asm/sysreg.h>
> +#include <asm/uaccess.h>

Likewise, we can also drop <asm/assembler.h>, <asm/cpufeature.h>, and
<asm/sysreg.h> here.

Thanks,
Mark.
