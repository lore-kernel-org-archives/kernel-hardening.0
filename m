Date: Wed, 9 May 2018 04:34:46 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 04/13] mm: Use array_size() helpers for kmalloc()
Message-ID: <20180509113446.GA18549@bombadil.infradead.org>
References: <20180509004229.36341-1-keescook@chromium.org>
 <20180509004229.36341-5-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180509004229.36341-5-keescook@chromium.org>
To: Kees Cook <keescook@chromium.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, May 08, 2018 at 05:42:20PM -0700, Kees Cook wrote:
> @@ -499,6 +500,8 @@ static __always_inline void *kmalloc_large(size_t size, gfp_t flags)
>   */
>  static __always_inline void *kmalloc(size_t size, gfp_t flags)
>  {
> +	if (size == SIZE_MAX)
> +		return NULL;
>  	if (__builtin_constant_p(size)) {
>  		if (size > KMALLOC_MAX_CACHE_SIZE)
>  			return kmalloc_large(size, flags);

I don't like the add-checking-to-every-call-site part of this patch.
Fine, the compiler will optimise it away if it can calculate it at compile
time, but there are a lot of situations where it can't.  You aren't
adding any safety by doing this; trying to allocate SIZE_MAX bytes is
guaranteed to fail, and it doesn't need to fail quickly.

> @@ -624,11 +629,13 @@ int memcg_update_all_caches(int num_memcgs);
>   */
>  static inline void *kmalloc_array(size_t n, size_t size, gfp_t flags)
>  {
> -	if (size != 0 && n > SIZE_MAX / size)
> +	size_t bytes = array_size(n, size);
> +
> +	if (bytes == SIZE_MAX)
>  		return NULL;
>  	if (__builtin_constant_p(n) && __builtin_constant_p(size))
> -		return kmalloc(n * size, flags);
> -	return __kmalloc(n * size, flags);
> +		return kmalloc(bytes, flags);
> +	return __kmalloc(bytes, flags);
>  }
>  
>  /**
> @@ -639,7 +646,9 @@ static inline void *kmalloc_array(size_t n, size_t size, gfp_t flags)
>   */
>  static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
>  {
> -	return kmalloc_array(n, size, flags | __GFP_ZERO);
> +	size_t bytes = array_size(n, size);
> +
> +	return kmalloc(bytes, flags | __GFP_ZERO);
>  }

Hmm.  I wonder why we have the kmalloc/__kmalloc "optimisation"
in kmalloc_array, but not kcalloc.  Bet we don't really need it in
kmalloc_array.  I'll do some testing.
