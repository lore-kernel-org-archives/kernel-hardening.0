Message-ID: <596748FB.20902@arm.com>
Date: Thu, 13 Jul 2017 11:18:35 +0100
From: James Morse <james.morse@arm.com>
MIME-Version: 1.0
References: <1499898783-25732-1-git-send-email-mark.rutland@arm.com> <1499898783-25732-3-git-send-email-mark.rutland@arm.com>
In-Reply-To: <1499898783-25732-3-git-send-email-mark.rutland@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC PATCH 2/6] arm64: avoid open-coding THREAD_SIZE{,_ORDER}
To: Mark Rutland <mark.rutland@arm.com>
Cc: ard.biesheuvel@linaro.org, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, akashi.takahiro@linaro.org, catalin.marinas@arm.com, dave.martin@arm.com, labbott@fedoraproject.org, will.deacon@arm.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi Mark,

On 12/07/17 23:32, Mark Rutland wrote:
> Currently we define THREAD_SIZE_ORDER dependent on which arm64-specific
> page size kconfig symbol was selected. This is unfortunate, as it hides
> the relationship between THREAD_SIZE_ORDER and THREAD_SIZE, and makes it
> painful more painful than necessary to modify the thread size as we will
> need to do for some debug configurations.
> 
> This patch follows arch/metag's approach of consistently defining
> THREAD_SIZE in terms of THREAD_SIZE_ORDER. This avoids having ifdefs for
> particular page size configurations, and allows us to change a single
> definition to change the thread size.

I think this has unintended side effects for 64K page systems.  (or at least not
yet intended)

Today:
> #ifdef CONFIG_ARM64_4K_PAGES
> #define THREAD_SIZE_ORDER	2
> #elif defined(CONFIG_ARM64_16K_PAGES)
> #define THREAD_SIZE_ORDER	0
> #endif

Means THREAD_SIZE_ORDER is unset on 64K, and THREAD_SIZE is always:
> #define THREAD_SIZE		16384

/kernel/fork.c matches this with its:
> # if THREAD_SIZE >= PAGE_SIZE || defined(CONFIG_VMAP_STACK)
[...]
> #else
[...]
> void thread_stack_cache_init(void)
> {
>	thread_stack_cache = kmem_cache_create("thread_stack", THREAD_SIZE,
> 					      THREAD_SIZE, 0, NULL);
> 	BUG_ON(thread_stack_cache == NULL);
> }
> #endif

To create a kmemcache to share 64K pages as 16K stacks.


After this patch:
> #define THREAD_SHIFT		14
>
> #if THREAD_SHIFT >= PAGE_SHIFT
> #define THREAD_SIZE_ORDER	(THREAD_SHIFT - PAGE_SHIFT)
> #else
> #define THREAD_SIZE_ORDER	0
> #endif

Means THREAD_SIZE_ORDER is 0, and:
> #define THREAD_SIZE		(PAGE_SIZE << THREAD_SIZE_ORDER)

gives us a 64K THREAD_SIZE.



Thanks,

James





> diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
> index 141f13e9..6d0c59a 100644
> --- a/arch/arm64/include/asm/thread_info.h
> +++ b/arch/arm64/include/asm/thread_info.h
> @@ -23,13 +23,17 @@
>  
>  #include <linux/compiler.h>
>  
> -#ifdef CONFIG_ARM64_4K_PAGES
> -#define THREAD_SIZE_ORDER	2
> -#elif defined(CONFIG_ARM64_16K_PAGES)
> +#include <asm/page.h>
> +
> +#define THREAD_SHIFT		14
> +
> +#if THREAD_SHIFT >= PAGE_SHIFT
> +#define THREAD_SIZE_ORDER	(THREAD_SHIFT - PAGE_SHIFT)
> +#else
>  #define THREAD_SIZE_ORDER	0
>  #endif
>  
> -#define THREAD_SIZE		16384
> +#define THREAD_SIZE		(PAGE_SIZE << THREAD_SIZE_ORDER)
>  #define THREAD_START_SP		(THREAD_SIZE - 16)
>  
>  #ifndef __ASSEMBLY__
> 
