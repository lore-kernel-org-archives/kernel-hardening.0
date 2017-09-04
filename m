Date: Mon, 4 Sep 2017 14:25:13 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
In-Reply-To: <20170903120757.14968-23-ard.biesheuvel@linaro.org>
Message-ID: <nycvar.YSQ.7.76.1709041424570.8603@knanqh.ubzr>
References: <20170903120757.14968-1-ard.biesheuvel@linaro.org> <20170903120757.14968-23-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH v2 22/29] ARM: mm: export default vmalloc base address
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, Arnd Bergmann <arnd@arndb.de>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, 3 Sep 2017, Ard Biesheuvel wrote:

> In order for the EFI stub to be able to decide over what range to
> randomize the load address of the kernel, expose the definition of
> the default vmalloc base address as VMALLOC_DEFAULT_BASE.
> 
> Cc: Russell King <linux@armlinux.org.uk>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Acked-by: Nicolas Pitre <nico@linaro.org>

> ---
>  arch/arm/include/asm/pgtable.h | 1 +
>  arch/arm/mm/mmu.c              | 3 +--
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
> index 1c462381c225..a0d4a63a6516 100644
> --- a/arch/arm/include/asm/pgtable.h
> +++ b/arch/arm/include/asm/pgtable.h
> @@ -45,6 +45,7 @@
>  #define VMALLOC_OFFSET		(8*1024*1024)
>  #define VMALLOC_START		(((unsigned long)high_memory + VMALLOC_OFFSET) & ~(VMALLOC_OFFSET-1))
>  #define VMALLOC_END		0xff800000UL
> +#define VMALLOC_DEFAULT_BASE	(VMALLOC_END - (240 << 20) - VMALLOC_OFFSET)
>  
>  #define LIBRARY_TEXT_START	0x0c000000
>  
> diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
> index e46a6a446cdd..566f7e657931 100644
> --- a/arch/arm/mm/mmu.c
> +++ b/arch/arm/mm/mmu.c
> @@ -1128,8 +1128,7 @@ void __init debug_ll_io_init(void)
>  }
>  #endif
>  
> -static void * __initdata vmalloc_min =
> -	(void *)(VMALLOC_END - (240 << 20) - VMALLOC_OFFSET);
> +static void * __initdata vmalloc_min = (void *)VMALLOC_DEFAULT_BASE;
>  
>  /*
>   * vmalloc=size forces the vmalloc area to be exactly 'size'
> -- 
> 2.11.0
> 
> 
