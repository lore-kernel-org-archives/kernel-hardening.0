Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Wed, 1 Mar 2017 08:38:16 +0100
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20170301073816.GA24100@gmail.com>
References: <1488339285-23777-1-git-send-email-dwindsor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1488339285-23777-1-git-send-email-dwindsor@gmail.com>
Subject: [kernel-hardening] Re: [PATCH] refcount: add refcount_t API kernel-doc comments
To: David Windsor <dwindsor@gmail.com>
Cc: peterz@infradead.org, elena.reshetova@intel.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


* David Windsor <dwindsor@gmail.com> wrote:

> This adds kernel-doc comments for the new refcount_t API.
> 
> Signed-off-by: David Windsor <dwindsor@gmail.com>
> ---
>  include/linux/refcount.h | 19 ++++++++++
>  lib/refcount.c           | 95 +++++++++++++++++++++++++++++++++++++++++++-----
>  2 files changed, 105 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/refcount.h b/include/linux/refcount.h
> index 0023fee..3c02135 100644
> --- a/include/linux/refcount.h
> +++ b/include/linux/refcount.h
> @@ -6,17 +6,36 @@
>  #include <linux/spinlock.h>
>  #include <linux/kernel.h>
>  
> +/**
> + * refcount_t - variant of atomic_t specialized for reference counts
> + * @refs: atomic_t counter field
> + *
> + * The counter saturates at UINT_MAX and will not move once
> + * there. This avoids wrapping the counter and causing 'spurious'
> + * use-after-free issues.

Let's not beat around the bush:

  s/issues/bugs

> +/**
> + * refcount_add - add a value to a refcount
> + * @i: the value to add to the refcount
> + * @r: the refcount
> + *
> + * Similar to atomic_add(), will saturate at UINT_MAX and WARN.

I realize you picked it up from the existing comments, but if we push this into 
docbook I'd phrase it this way:

    * Similar to atomic_add(), but will saturate at UINT_MAX and WARN.

(The 'but' contasts the main difference to atomic_add().)

> + */
>  void refcount_add(unsigned int i, refcount_t *r)
>  {
>  	WARN(!refcount_add_not_zero(i, r), "refcount_t: addition on 0; use-after-free.\n");
>  }
>  EXPORT_SYMBOL_GPL(refcount_add);
>  
> -/*
> +/**
> + * refcount_inc_not_zero - increment a refcount unless it is 0
> + * @r: the refcount to increment

So this is slightly different from the phrasing earlier on:

+/**
+ * refcount_add_not_zero - add a value to a refcount unless the refcount is 0
+ * @i: the value to add to the refcount
+ * @r: the refcount
+ * 

Please harmonize it: either use 'a refcount unless it is 0' or 'a refcount unless 
the refcount is 0' - but not a mixture of the two.

Same goes for similar occurances further below.

> + *
>   * Similar to atomic_inc_not_zero(), will saturate at UINT_MAX and WARN.

This should be updated similarly as above.

>   *
>   * Provides no memory ordering, it is assumed the caller has guaranteed the
>   * object memory to be stable (RCU, etc.). It does provide a control dependency
>   * and thereby orders future stores. See the comment on top.
> + *
> + * Return: false if the refcount is 0, true otherwise
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

s/if refcount/if the refcount

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

I'd insert the 'but' here too to highlight differences to the atomic APIs.

> +/**
> + * refcount_dec_and_mutex_lock - return holding mutex if able to decrement
> + *                               refcount to 0
> + * @r: the refcount
> + * @lock: the mutex to be locked
> + *
>   * Similar to atomic_dec_and_mutex_lock(), it will WARN on underflow and fail
>   * to decrement when saturated at UINT_MAX.
>   *
>   * Provides release memory ordering, such that prior loads and stores are done
>   * before, and provides a control dependency such that free() must come after.
>   * See the comment on top.
> + *
> + * Return: true and hold lock if able to decrement refcount to 0, false
> + *         otherwise

If we refer to a function parameter then it should be quoted as 'lock', but what 
mean here is that we'll hold the mutex:

s/lock/mutex

>   */
>  bool refcount_dec_and_mutex_lock(refcount_t *r, struct mutex *lock)
>  {
> @@ -242,13 +311,21 @@ bool refcount_dec_and_mutex_lock(refcount_t *r, struct mutex *lock)
>  }
>  EXPORT_SYMBOL_GPL(refcount_dec_and_mutex_lock);
>  
> -/*
> +/**
> + * refcount_dec_and_lock - return holding spinlock if able to decrement
> + *                         refcount to 0
> + * @r: the refcount
> + * @lock: the spinlock to be locked
> + *
>   * Similar to atomic_dec_and_lock(), it will WARN on underflow and fail to
>   * decrement when saturated at UINT_MAX.
>   *
>   * Provides release memory ordering, such that prior loads and stores are done
>   * before, and provides a control dependency such that free() must come after.
>   * See the comment on top.
> + *
> + * Return: true and hold lock if able to decrement refcount to 0, false
> + *         otherwise

s/lock/spinlock

Looks good otherwise and thanks for the documentation update!

Thanks,

	Ingo
