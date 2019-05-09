Subject: Re: [PATCH 1/4] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
References: <20190508153736.256401-1-glider@google.com>
 <20190508153736.256401-2-glider@google.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <6e5ccf92-cc58-ab2b-d025-0f5642d5f4a6@infradead.org>
Date: Wed, 8 May 2019 18:04:55 -0700
MIME-Version: 1.0
In-Reply-To: <20190508153736.256401-2-glider@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Alexander Potapenko <glider@google.com>, akpm@linux-foundation.org, cl@linux.com, keescook@chromium.org, labbott@redhat.com
Cc: linux-mm@kvack.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, yamada.masahiro@socionext.com, jmorris@namei.org, serge@hallyn.com, ndesaulniers@google.com, kcc@google.com, dvyukov@google.com, sspatil@android.com, jannh@google.com, mark.rutland@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

On 5/8/19 8:37 AM, Alexander Potapenko wrote:
> diff --git a/security/Kconfig.hardening b/security/Kconfig.hardening
> index 0a1d4ca314f4..4a4001f5ad25 100644
> --- a/security/Kconfig.hardening
> +++ b/security/Kconfig.hardening
> @@ -159,6 +159,22 @@ config STACKLEAK_RUNTIME_DISABLE
>  	  runtime to control kernel stack erasing for kernels built with
>  	  CONFIG_GCC_PLUGIN_STACKLEAK.
>  
> +config INIT_ON_ALLOC_DEFAULT_ON
> +	bool "Set init_on_alloc=1 by default"
> +	default false

That should be spelled "default n" but since that is already the default,
just omit the line completely.

> +	help
> +	  Enable init_on_alloc=1 by default, making the kernel initialize every
> +	  page and heap allocation with zeroes.
> +	  init_on_alloc can be overridden via command line.
> +
> +config INIT_ON_FREE_DEFAULT_ON
> +	bool "Set init_on_free=1 by default"
> +	default false

ditto.

> +	help
> +	  Enable init_on_free=1 by default, making the kernel initialize freed
> +	  pages and slab memory with zeroes.
> +	  init_on_free can be overridden via command line.
> +
>  endmenu
>  
>  endmenu


-- 
~Randy
