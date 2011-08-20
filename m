Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 20 Aug 2011 20:31:20 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110820163120.GA7256@openwall.com>
References: <20110817191550.GA18554@albatros> <20110820142723.GA5708@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110820142723.GA5708@albatros>
Subject: Re: [kernel-hardening] kmalloc() nofail allocations
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy,

Overall, I like this.  My biggest concern is that it implies that the
kernel will always have a can't fail memory allocation interface.  So if
kernel developers at some point want to change this, they'll have a hard
time making such changes.  On the other hand, the current situation with
some code assuming that failures are impossible and some other code
checking for them anyway is inconsistent and not very helpful for
possible memory allocation semantics changes anyway.

So let's give this a try.

On Sat, Aug 20, 2011 at 06:27:23PM +0400, Vasiliy Kulikov wrote:
> Here is a patch to do it.  I've implemented k(m|z)alloc() and
> kmem_cache_{z,}alloc() nofail variants.  As a result, setuid() cannot
> fail with any reason, but EACCES.
> 
> kernel/cred.c is partly moved to _nofail() too, just to show how much
> error handling code it removes.

This mostly looks good to me.  Some comments are below:

> +#define kmalloc_nofail(size, flags) \
> +({ \
> +	void *p; \
> +	(void)BUILD_BUG_ON_ZERO(size > (PAGE_SIZE << (PAGE_ALLOC_COSTLY_ORDER-1))); \
> +	if (flags & __GFP_NORETRY) \
> +		panic("Attempt to call kmalloc_nofail() with __GFP_NORETRY"); \
> +	p = kmalloc(size, flags); \
> +	if (p == NULL) \
> +		panic("kmalloc_nofail() returned NULL\n"); \
> +	p; \
> +})

You need to enclose size and flags in braces in this macro.

Also, I think portions of this macro should be moved into a non-inline
function defined in some .c file - to reduce total code size.  Then the
macro (and thus duplicated code) could be shortened to:

#define kmalloc_nofail(size, flags) \
({ \
	(void)BUILD_BUG_ON_ZERO((size) > (PAGE_SIZE << (PAGE_ALLOC_COSTLY_ORDER-1))); \
	_kmalloc_nofail((size), (flags)); \
})

or to optimize it for speed at the cost of slight size increase:

#define kmalloc_nofail(size, flags) \
({ \
	void *p; \
	(void)BUILD_BUG_ON_ZERO((size) > (PAGE_SIZE << (PAGE_ALLOC_COSTLY_ORDER-1))); \
	p = kmalloc((size), (flags)); \
	if (((flags) & __GFP_NORETRY) || p == NULL) \
		kmalloc_nofail_panic((flags), p); \
	p; \
})

so you have only one instance of a function call on error instead of
two calls to panic() and you don't rely on the compiler and linker
combining the many instances of constant strings.

You can leave these changes for after your initial RFC postings to LKML
if you like, though.

> +#define kzalloc_nofail(size, flags) \
> +	kmalloc_nofail(size, (flags | __GFP_ZERO))

Need braces around flags.

> +#define kmem_cache_zalloc_nofail(cache, flags) \
> +	kmem_cache_alloc_nofail(cache, (flags | __GFP_ZERO))

Need braces around cache and flags.

> +/* This is a slightly weaker check than kmalloc_nofail() as kmem check is runtime check :\ */
> +#define kmem_cache_alloc_nofail(cache, flags) \
> +({ \
> +	void *p; \
> +	if ((cache)->objsize > (PAGE_SIZE << (PAGE_ALLOC_COSTLY_ORDER-1))) \
> +		panic("Too big size (%lu) for kmem_cache_alloc_nofail()!", \
> +			(long)(cache)->objsize); \
> +	if (flags & __GFP_NORETRY); \
> +		panic("Attempt to call kmem_cache_alloc_nofail() with __GFP_NORETRY"); \
> +	p = kmem_cache_alloc(cache, flags); \
> +	if (p == NULL) \
> +		panic("kmem_cache_alloc() returned NULL\n"); \
> +	p; \
> +})

Similar comments apply here.  Since the size check is runtime anyway,
perhaps it should be moved into a non-inline function.

Please fix at least the braces, and bring this to LKML for discussion.

Thanks,

Alexander
