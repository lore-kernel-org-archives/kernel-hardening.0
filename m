Date: Mon, 15 Apr 2019 19:02:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: security: introduce CONFIG_INIT_HEAP_ALL
Message-Id: <20190415190213.5831bbc17e5073690713b001@linux-foundation.org>
In-Reply-To: <20190412124501.132678-1-glider@google.com>
References: <20190412124501.132678-1-glider@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Alexander Potapenko <glider@google.com>
Cc: linux-security-module@vger.kernel.org, linux-mm@kvack.org, ndesaulniers@google.com, kcc@google.com, dvyukov@google.com, keescook@chromium.org, sspatil@android.com, labbott@redhat.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 12 Apr 2019 14:45:01 +0200 Alexander Potapenko <glider@google.com> wrote:

> This config option adds the possibility to initialize newly allocated
> pages and heap objects with zeroes.

At what cost?  Some performance test results would help this along.

> This is needed to prevent possible
> information leaks and make the control-flow bugs that depend on
> uninitialized values more deterministic.
> 
> Initialization is done at allocation time at the places where checks for
> __GFP_ZERO are performed. We don't initialize slab caches with
> constructors or SLAB_TYPESAFE_BY_RCU to preserve their semantics.
> 
> For kernel testing purposes filling allocations with a nonzero pattern
> would be more suitable, but may require platform-specific code. To have
> a simple baseline we've decided to start with zero-initialization.
> 
> No performance optimizations are done at the moment to reduce double
> initialization of memory regions.

Requiring a kernel rebuild is rather user-hostile.  A boot option
(early_param()) would be much more useful and I expect that the loss in
coverage would be small and acceptable?  Could possibly use the
static_branch infrastructure.

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

Is there any reason why this *must* be implemented as a macro?  If not,
it should be written in C please.
