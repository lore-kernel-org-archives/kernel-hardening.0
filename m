Date: Thu, 23 May 2019 17:04:48 -0700
From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v4 1/3] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
Message-ID: <201905231647.ED31A5FE30@keescook>
References: <20190523140844.132150-1-glider@google.com>
 <20190523140844.132150-2-glider@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523140844.132150-2-glider@google.com>
To: Alexander Potapenko <glider@google.com>
Cc: akpm@linux-foundation.org, cl@linux.com, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, linux-security-module@vger.kernel.org, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Hocko <mhocko@kernel.org>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, Mark Rutland <mark.rutland@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, May 23, 2019 at 04:08:42PM +0200, Alexander Potapenko wrote:
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 52e6fbb042cc..68fb6fa41cc1 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -1673,6 +1673,14 @@
>  
>  	initrd=		[BOOT] Specify the location of the initial ramdisk
>  
> +	init_on_alloc=	[MM] Fill newly allocated pages and heap objects with
> +			zeroes.
> +			Format: 0 | 1
> +			Default set by CONFIG_INIT_ON_ALLOC_DEFAULT_ON.
> +	init_on_free=	[MM] Fill freed pages and heap objects with zeroes.
> +			Format: 0 | 1
> +			Default set by CONFIG_INIT_ON_FREE_DEFAULT_ON.
> +
>  	init_pkru=	[x86] Specify the default memory protection keys rights
>  			register contents for all processes.  0x55555554 by
>  			default (disallow access to all but pkey 0).  Can

Nit: add a blank line between these new options' documentation to match
the others.

> diff --git a/security/Kconfig.hardening b/security/Kconfig.hardening
> index 0a1d4ca314f4..87883e3e3c2a 100644
> --- a/security/Kconfig.hardening
> +++ b/security/Kconfig.hardening
> @@ -159,6 +159,20 @@ config STACKLEAK_RUNTIME_DISABLE
>  	  runtime to control kernel stack erasing for kernels built with
>  	  CONFIG_GCC_PLUGIN_STACKLEAK.
>  
> +config INIT_ON_ALLOC_DEFAULT_ON
> +	bool "Set init_on_alloc=1 by default"
> +	help
> +	  Enable init_on_alloc=1 by default, making the kernel initialize every
> +	  page and heap allocation with zeroes.
> +	  init_on_alloc can be overridden via command line.
> +
> +config INIT_ON_FREE_DEFAULT_ON
> +	bool "Set init_on_free=1 by default"
> +	help
> +	  Enable init_on_free=1 by default, making the kernel initialize freed
> +	  pages and slab memory with zeroes.
> +	  init_on_free can be overridden via command line.
> +

I think these could use a lot more detail. How about something like
these, with more details and performance notes:

config INIT_ON_ALLOC_DEFAULT_ON
	bool "Enable heap memory zeroing on allocation by default"
	help
	  This has the effect of setting "init_on_alloc=1" on the kernel
	  command line. This can be disabled with "init_on_alloc=0".
	  When "init_on_alloc" is enabled, all page allocator and slab
	  allocator memory will be zeroed when allocated, eliminating
	  many kinds of "uninitialized heap memory" flaws, especially
	  heap content exposures. The performance impact varies by
	  workload, but most cases see <1% impact. Some synthetic
	  workloads have measured as high as 7%.

config INIT_ON_FREE_DEFAULT_ON
	bool "Enable heap memory zeroing on free by default"
	help
	  This has the effect of setting "init_on_free=1" on the kernel
	  command line. This can be disabled with "init_on_free=0".
	  Similar to "init_on_alloc", when "init_on_free" is enabled,
	  all page allocator and slab allocator memory will be zeroed
	  when freed, eliminating many kinds of "uninitialized heap memory"
	  flaws, especially heap content exposures. The primary difference
	  with "init_on_free" is that data lifetime in memory is reduced,
	  as anything freed is wiped immediately, making live forensics or
	  cold boot memory attacks unable to recover freed memory contents.
	  The performance impact varies by workload, but is more expensive
	  than "init_on_alloc" due to the negative cache effects of
	  touching "cold" memory areas. Most cases see 3-5% impact. Some
	  synthetic workloads have measured as high as 8%.


-- 
Kees Cook


-- 
Kees Cook
