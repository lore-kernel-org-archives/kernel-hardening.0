Date: Wed, 1 Mar 2017 09:47:50 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20170301084750.GY6515@twins.programming.kicks-ass.net>
References: <1488339285-23777-1-git-send-email-dwindsor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1488339285-23777-1-git-send-email-dwindsor@gmail.com>
Subject: [kernel-hardening] Re: [PATCH] refcount: add refcount_t API kernel-doc comments
To: David Windsor <dwindsor@gmail.com>
Cc: mingo@kernel.org, elena.reshetova@intel.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 28, 2017 at 10:34:45PM -0500, David Windsor wrote:

> diff --git a/lib/refcount.c b/lib/refcount.c
> index 1d33366..30e0927 100644
> --- a/lib/refcount.c
> +++ b/lib/refcount.c
> @@ -37,6 +37,15 @@
>  #include <linux/refcount.h>
>  #include <linux/bug.h>
>  
> +/**
> + * refcount_add_not_zero - add a value to a refcount unless the refcount is 0
> + * @i: the value to add to the refcount
> + * @r: the refcount
> + *
> + * Will saturate at UINT_MAX and WARN.
> + *
> + * Return: false if the refcount is 0, true otherwise.
> + */
>  bool refcount_add_not_zero(unsigned int i, refcount_t *r)
>  {
>  	unsigned int old, new, val = atomic_read(&r->refs);
> @@ -64,18 +73,30 @@ bool refcount_add_not_zero(unsigned int i, refcount_t *r)
>  }
>  EXPORT_SYMBOL_GPL(refcount_add_not_zero);
>  
> +/**
> + * refcount_add - add a value to a refcount
> + * @i: the value to add to the refcount
> + * @r: the refcount
> + *
> + * Similar to atomic_add(), will saturate at UINT_MAX and WARN.
> + */
>  void refcount_add(unsigned int i, refcount_t *r)
>  {
>  	WARN(!refcount_add_not_zero(i, r), "refcount_t: addition on 0; use-after-free.\n");
>  }
>  EXPORT_SYMBOL_GPL(refcount_add);

Usage of both of these should be discouraged, add/sub on refcounts is
'odd'. Also, both these lack the comment on memory ordering, copy/paste
from inc_not_zero/inc.

> -/*
> +/**
> + * refcount_inc_not_zero - increment a refcount unless it is 0
> + * @r: the refcount to increment
> + *
>   * Similar to atomic_inc_not_zero(), will saturate at UINT_MAX and WARN.
>   *
>   * Provides no memory ordering, it is assumed the caller has guaranteed the
>   * object memory to be stable (RCU, etc.). It does provide a control dependency
>   * and thereby orders future stores. See the comment on top.
> + *
> + * Return: false if the refcount is 0, true otherwise

An alternative interpretation is: return true if the increment happened,
false otherwise. But given the saturation semantics that might be
awkward, but its the one I find easier to work with.

>   */
>  bool refcount_inc_not_zero(refcount_t *r)
>  {
> @@ -103,11 +124,16 @@ bool refcount_inc_not_zero(refcount_t *r)
>  }
>  EXPORT_SYMBOL_GPL(refcount_inc_not_zero);
>  
> -/*
> +/**
> + * refcount_inc - increment a refcount
> + * @r: the refcount to increment
> + *
>   * Similar to atomic_inc(), will saturate at UINT_MAX and WARN.
>   *
>   * Provides no memory ordering, it is assumed the caller already has a
>   * reference on the object, will WARN when this is not so.
> + *
> + * Will WARN if refcount is 0.

I think that duplicates the final part of the prior sentence in intent.

Also, it might be useful to explain why.

>   */
>  void refcount_inc(refcount_t *r)
>  {
> @@ -115,6 +141,22 @@ void refcount_inc(refcount_t *r)
>  }
>  EXPORT_SYMBOL_GPL(refcount_inc);
>  
> +/**
> + * refcount_sub_and_test - subtract from a refcount and test if it is 0
> + * @i: amount to subtract from the refcount
> + * @r: the refcount
> + *
> + * Similar to atomic_dec_and_test(), it will WARN on underflow and fail to
> + * decrement when saturated at UINT_MAX.

It will equally fail the subtraction on underflow and return false
(didn't hit 0) and leak.

> + *
> + * Provides release memory ordering, such that prior loads and stores are done
> + * before, and provides a control dependency such that free() must come after.
> + * See the comment on top.
> + *
> + * Return: true if the resulting refcount is greater than 0, false if the
> + * resulting refcount is 0, the refcount is saturated at UINT_MAX or the
> + * subtraction operation causes an underflow.

I think you got that wrong, will return true when we hit 0, false
otherwise.

Remember; one writes:

	if (dec_and_test(&obj->ref))
		free(obj);

> + */
>  bool refcount_sub_and_test(unsigned int i, refcount_t *r)
>  {
>  	unsigned int old, new, val = atomic_read(&r->refs);
> @@ -140,13 +182,20 @@ bool refcount_sub_and_test(unsigned int i, refcount_t *r)
>  }
>  EXPORT_SYMBOL_GPL(refcount_sub_and_test);

As with add, sub should be discouraged.

> -/*
> +/**
> + * refcount_dec_and_test - decrement a refcount and test if it is 0
> + * @r: the refcount
> + *
>   * Similar to atomic_dec_and_test(), it will WARN on underflow and fail to
>   * decrement when saturated at UINT_MAX.
>   *
>   * Provides release memory ordering, such that prior loads and stores are done
>   * before, and provides a control dependency such that free() must come after.
>   * See the comment on top.
> + *
> + * Return: true if the resulting refcount is greater than 0, false if the
> + * resulting refcount is 0, the refcount is saturated at UINT_MAX or the
> + * decrement operation causes an underflow.

got that similarly wrong.

>   */
>  bool refcount_dec_and_test(refcount_t *r)
>  {
> @@ -154,21 +203,26 @@ bool refcount_dec_and_test(refcount_t *r)
>  }
>  EXPORT_SYMBOL_GPL(refcount_dec_and_test);
>  
> -/*
> +/**
> + * refcount_dec - decrement a refcount
> + * @r: the refcount
> + *
>   * Similar to atomic_dec(), it will WARN on underflow and fail to decrement
>   * when saturated at UINT_MAX.
>   *
>   * Provides release memory ordering, such that prior loads and stores are done
>   * before.
>   */
> -
>  void refcount_dec(refcount_t *r)
>  {
>  	WARN(refcount_dec_and_test(r), "refcount_t: decrement hit 0; leaking memory.\n");
>  }
>  EXPORT_SYMBOL_GPL(refcount_dec);
>  
> -/*
> +/**
> + * refcount_dec_if_one - decrement a refcount if it is 1
> + * @r: the refcount
> + *
>   * No atomic_t counterpart, it attempts a 1 -> 0 transition and returns the
>   * success thereof.
>   *
> @@ -178,6 +232,8 @@ EXPORT_SYMBOL_GPL(refcount_dec);
>   * It can be used like a try-delete operator; this explicit case is provided
>   * and not cmpxchg in generic, because that would allow implementing unsafe
>   * operations.
> + *
> + * Return: true if the 1 -> 0 transition was successful, false otherwise

I'd formulate it differently, to match dec_and_test, return true if 0.

>   */
>  bool refcount_dec_if_one(refcount_t *r)
>  {
> @@ -185,11 +241,16 @@ bool refcount_dec_if_one(refcount_t *r)
>  }
>  EXPORT_SYMBOL_GPL(refcount_dec_if_one);
