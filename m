Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 27 Oct 2016 14:24:36 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20161027132235.GA30193@leverpostej>
References: <1476802761-24340-1-git-send-email-colin@cvidal.org>
 <1476802761-24340-3-git-send-email-colin@cvidal.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476802761-24340-3-git-send-email-colin@cvidal.org>
Subject: Re: [kernel-hardening] [RFC 2/2] arm: implementation for
 HARDENED_ATOMIC
To: kernel-hardening@lists.openwall.com
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, David Windsor <dave@progbits.org>, Kees Cook <keescook@chromium.org>, Hans Liljestrand <ishkamiel@gmail.com>, Colin Vidal <colin@cvidal.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On Tue, Oct 18, 2016 at 04:59:21PM +0200, Colin Vidal wrote:
> This adds arm-specific code in order to support HARDENED_ATOMIC
> feature. When overflow is detected in atomic_t, atomic64_t or
> atomic_long_t, an exception is raised and call
> hardened_atomic_overflow.

I have some comments below, but for real review this needs to go via the
linux-arm-kernel list.

> diff --git a/arch/arm/include/asm/atomic.h b/arch/arm/include/asm/atomic.h
> index 66d0e21..fdaee17 100644
> --- a/arch/arm/include/asm/atomic.h
> +++ b/arch/arm/include/asm/atomic.h
> @@ -17,18 +17,52 @@
>  #include <linux/irqflags.h>
>  #include <asm/barrier.h>
>  #include <asm/cmpxchg.h>
> +#include <linux/bug.h>
>  
>  #define ATOMIC_INIT(i)	{ (i) }
>  
>  #ifdef __KERNEL__
>  
> +#ifdef CONFIG_HARDENED_ATOMIC
> +#define HARDENED_ATOMIC_INSN "bkpt 0xf103"

Please put the immediate in a #define somewhere.

What about thumb2 kernels?

> +#define _ASM_EXTABLE(from, to)			\
> +	".pushsection __ex_table,\"a\"\n"	\
> +	".align 3\n"				\
> +	".long "#from","#to"\n"			\
> +	".popsection"
> +#define __OVERFLOW_POST				\
> +	"bvc 3f\n"				\
> +	"2: "HARDENED_ATOMIC_INSN"\n"		\
> +	"3:\n"
> +#define __OVERFLOW_POST_RETURN			\
> +	"bvc 3f\n"				\
> +	"mov %0,%1\n"				\
> +	"2: "HARDENED_ATOMIC_INSN"\n"		\
> +	"3:\n"
> +#define __OVERFLOW_EXTABLE			\
> +	"4:\n"					\
> +	_ASM_EXTABLE(2b, 4b)
> +#else
> +#define __OVERFLOW_POST
> +#define __OVERFLOW_POST_RETURN
> +#define __OVERFLOW_EXTABLE
> +#endif
> +

All this should live close to the assembly using it, to make it possible
to follow.

This may also not be the best way of structuring this code. The
additional indirection of passing this in at a high level makes it hard
to read and potentially fragile. For single instructions it was ok, but
I'm not so sure that it's ok for larger sequences like this.

> diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
> index 3a2e678..ce8ee00 100644
> --- a/arch/arm/mm/fault.c
> +++ b/arch/arm/mm/fault.c
> @@ -580,6 +580,21 @@ do_PrefetchAbort(unsigned long addr, unsigned int ifsr, struct pt_regs *regs)
>  	const struct fsr_info *inf = ifsr_info + fsr_fs(ifsr);
>  	struct siginfo info;
>  
> +#ifdef CONFIG_HARDENED_ATOMIC
> +	if (fsr_fs(ifsr) == FAULT_CODE_DEBUG) {

You'll need to justify why this isn't in the ifsr_info table. It has the
same basic shape as the usual set of handlers.

I note that we don't seem to use SW breakpoints at all currently, and I
suspect there's a reason for that which we need to consider.

Also, if this *must* live here, please make it a static inline with an
empty stub, rather than an ifdef'd block.

> +		unsigned long pc = instruction_pointer(regs);
> +		unsigned int bkpt;
> +
> +		if (!probe_kernel_address((const unsigned int *)pc, bkpt) &&
> +		    cpu_to_le32(bkpt) == 0xe12f1073) {

This appears to be the A1 encoding from the ARM ARM. What about the T1
encoding, i.e. thumb?

Regardless, *please* de-magic the number using a #define.

Also, this should be le32_to_cpu -- in the end we're treating the
coverted value as cpu-native. The variable itself should be a __le32.

Thanks,
Mark.

> +			current->thread.error_code = ifsr;
> +			current->thread.trap_no = 0;
> +			hardened_atomic_overflow(regs);
> +			fixup_exception(regs);
> +			return;
> +		}
> +	}
> +#endif
>  	if (!inf->fn(addr, ifsr | FSR_LNX_PF, regs))
>  		return;
>  
> -- 
> 2.7.4
> 
