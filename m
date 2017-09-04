Date: Mon, 4 Sep 2017 14:11:30 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
In-Reply-To: <20170903120757.14968-20-ard.biesheuvel@linaro.org>
Message-ID: <nycvar.YSQ.7.76.1709041409530.8603@knanqh.ubzr>
References: <20170903120757.14968-1-ard.biesheuvel@linaro.org> <20170903120757.14968-20-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH v2 19/29] ARM: kernel: make vmlinux buildable as a PIE
 executable
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, Arnd Bergmann <arnd@arndb.de>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, 3 Sep 2017, Ard Biesheuvel wrote:

> Update the build flags and linker script to allow vmlinux to be built
> as a PIE  binary, which retains relocation information about absolute
> symbol references so that they can be fixed up at runtime. This will
> be used for implementing KASLR,
> 
> Cc: Russell King <linux@armlinux.org.uk>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm/Kconfig                 |  4 ++++
>  arch/arm/Makefile                |  5 +++++
>  arch/arm/include/asm/assembler.h |  2 +-
>  arch/arm/kernel/vmlinux.lds.S    |  9 +++++++++
>  include/linux/hidden.h           | 20 ++++++++++++++++++++
>  scripts/module-common.lds        |  1 +
>  6 files changed, 40 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 61a0cb15067e..300add3b8023 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -2085,6 +2085,10 @@ config DMI
>  	  firmware need to be enabled. This would require the DMI subsystem
>  	  to be enabled much earlier than we do on ARM, which is non-trivial.
>  
> +config RELOCATABLE
> +	bool
> +	select HAVE_ARCH_PREL32_RELOCATIONS
> +

You should probably make it depend on !XIP_KERNEL.

Other than that

Acked-by: Nicolas Pitre <nico@linaro.org>


>  
>  menu "CPU Power Management"
> diff --git a/arch/arm/Makefile b/arch/arm/Makefile
> index 47d3a1ab08d2..8544c8148b9f 100644
> --- a/arch/arm/Makefile
> +++ b/arch/arm/Makefile
> @@ -52,6 +52,11 @@ AS		+= -EL
>  LD		+= -EL
>  endif
>  
> +ifeq ($(CONFIG_RELOCATABLE),y)
> +KBUILD_CFLAGS		+= -fpic -include $(srctree)/include/linux/hidden.h
> +LDFLAGS_vmlinux		+= -pie -shared -Bsymbolic
> +endif
> +
>  #
>  # The Scalar Replacement of Aggregates (SRA) optimization pass in GCC 4.9 and
>  # later may result in code being generated that handles signed short and signed
> diff --git a/arch/arm/include/asm/assembler.h b/arch/arm/include/asm/assembler.h
> index ae43859a9000..0586e1c77a80 100644
> --- a/arch/arm/include/asm/assembler.h
> +++ b/arch/arm/include/asm/assembler.h
> @@ -555,7 +555,7 @@ THUMB(	orr	\reg , \reg , #PSR_T_BIT	)
>  	 * mov_l - move a constant value or [relocated] address into a register
>  	 */
>  	.macro		mov_l, dst:req, imm:req
> -	.if		__LINUX_ARM_ARCH__ < 7
> +	.if		CONFIG_RELOCATABLE == 1 || __LINUX_ARM_ARCH__ < 7
>  	ldr		\dst, =\imm
>  	.else
>  	movw		\dst, #:lower16:\imm
> diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
> index c83a7ba737d6..5853d4be2067 100644
> --- a/arch/arm/kernel/vmlinux.lds.S
> +++ b/arch/arm/kernel/vmlinux.lds.S
> @@ -89,6 +89,9 @@ SECTIONS
>  #endif
>  		*(.discard)
>  		*(.discard.*)
> +		*(.ARM.exidx.discard.text)
> +		*(.interp .dynamic)
> +		*(.dynsym .dynstr .hash)
>  	}
>  
>  	. = PAGE_OFFSET + TEXT_OFFSET;
> @@ -209,6 +212,12 @@ SECTIONS
>  		__smpalt_end = .;
>  	}
>  #endif
> +	.rel.dyn : ALIGN(8) {
> +		__rel_begin = .;
> +		*(.rel .rel.* .rel.dyn)
> +	}
> +	__rel_end = ADDR(.rel.dyn) + SIZEOF(.rel.dyn);
> +
>  	.init.pv_table : {
>  		__pv_table_begin = .;
>  		*(.pv_table)
> diff --git a/include/linux/hidden.h b/include/linux/hidden.h
> new file mode 100644
> index 000000000000..781fb6f0c742
> --- /dev/null
> +++ b/include/linux/hidden.h
> @@ -0,0 +1,20 @@
> +/*
> + * GCC assumes that we are building shared libraries or hosted binaries
> + * when the -fpic or -fpie switches are used. This results in all references
> + * to symbols with external linkage to be redirected via entries in the global
> + * offset table (GOT), which keeps .text pages clean and reduces the footprint
> + * of CoWed dirty pages to the GOT itself. It also allows symbol preemption,
> + * which is mandatory under ELF rules for shared libraries.
> + *
> + * For the kernel, we use PIC so that we can relocate the executable image at
> + * runtime. This does not involve CoW or symbol preemption, and we'd rather
> + * have relative references instead of absolute ones whenever possible.
> + * So set the default visibility to hidden: this informs the compiler that
> + * none of our symbols will ever be exported from a shared library, allowing
> + * it to use relative references where possible.
> + *
> + * Note that simply passing -fvisibility=hidden is not sufficient to achieve
> + * this: In that case, definitions will be marked hidden, but declarations
> + * will not, and we still end up with GOT entries unnecessarily.
> + */
> +#pragma GCC visibility push(hidden)
> diff --git a/scripts/module-common.lds b/scripts/module-common.lds
> index d61b9e8678e8..55bb41f32c8a 100644
> --- a/scripts/module-common.lds
> +++ b/scripts/module-common.lds
> @@ -7,6 +7,7 @@ SECTIONS {
>  	/DISCARD/ : {
>  		*(.discard)
>  		*(.discard.*)
> +		*(*.discard.*)
>  	}
>  
>  	__ksymtab		0 : { *(SORT(___ksymtab+*)) }
> -- 
> 2.11.0
> 
> 
