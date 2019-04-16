Date: Tue, 16 Apr 2019 15:32:21 +0000
From: Christopher Lameter <cl@linux.com>
Subject: Re: [PATCH] mm: security: introduce CONFIG_INIT_HEAP_ALL
In-Reply-To: <20190412124501.132678-1-glider@google.com>
Message-ID: <0100016a26c711be-b99971ca-49f5-482c-9028-962ee471f733-000000@email.amazonses.com>
References: <20190412124501.132678-1-glider@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: Alexander Potapenko <glider@google.com>
Cc: akpm@linux-foundation.org, linux-security-module@vger.kernel.org, linux-mm@kvack.org, ndesaulniers@google.com, kcc@google.com, dvyukov@google.com, Kees Cook <keescook@chromium.org>, sspatil@android.com, labbott@redhat.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 12 Apr 2019, Alexander Potapenko wrote:

> diff --git a/mm/slab.h b/mm/slab.h
> index 43ac818b8592..4bb10af0031b 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -167,6 +167,16 @@ static inline slab_flags_t kmem_cache_flags(unsigned int object_size,
>  			      SLAB_TEMPORARY | \
>  			      SLAB_ACCOUNT)
>
> +/*
> + * Do we need to initialize this allocation?
> + * Always true for __GFP_ZERO, CONFIG_INIT_HEAP_ALL enforces initialization
> + * of caches without constructors and RCU.
> + */
> +#define SLAB_WANT_INIT(cache, gfp_flags) \
> +	((GFP_INIT_ALWAYS_ON && !(cache)->ctor && \
> +	  !((cache)->flags & SLAB_TYPESAFE_BY_RCU)) || \
> +	 (gfp_flags & __GFP_ZERO))

This is another complex thing to maintain when adding flags to the slab
allocator.

> +config INIT_HEAP_ALL
> +	bool "Initialize kernel heap allocations"

"Zero pages and objects allocated in the kernel"

> +	default n
> +	help
> +	  Enforce initialization of pages allocated from page allocator
> +	  and objects returned by kmalloc and friends.
> +	  Allocated memory is initialized with zeroes, preventing possible
> +	  information leaks and making the control-flow bugs that depend
> +	  on uninitialized values more deterministic.

Hmmm... But we already have debugging options that poison objects and
pages?
