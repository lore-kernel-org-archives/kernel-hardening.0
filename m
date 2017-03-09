MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1488506159-3506-1-git-send-email-dwindsor@gmail.com>
References: <1488506159-3506-1-git-send-email-dwindsor@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 9 Mar 2017 14:58:23 -0800
Message-ID: <CAGXu5j+f2hc4EGh-gDuuV6E4x1uiqME2nncSsJJDPJHp5jV4mw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [PATCH] refcount: add refcount_t API
 kernel-doc comments
To: David Windsor <dwindsor@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, "Reshetova, Elena" <elena.reshetova@intel.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 2, 2017 at 5:55 PM, David Windsor <dwindsor@gmail.com> wrote:
> This adds kernel-doc comments for the new refcount_t API.
>
> v2: incorporate fixes from Peter Zijlstra and Ingo Molnar

Thanks for the update!

>
> Signed-off-by: David Windsor <dwindsor@gmail.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

Can this go via the tip locking tree, or should I take it in my kspp tree?

Thanks,

-Kees

> ---
>  lib/refcount.c | 122 +++++++++++++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 110 insertions(+), 12 deletions(-)
>
> diff --git a/lib/refcount.c b/lib/refcount.c
> index 1d33366..d6e317a 100644
> --- a/lib/refcount.c
> +++ b/lib/refcount.c
> @@ -37,6 +37,24 @@
>  #include <linux/refcount.h>
>  #include <linux/bug.h>
>
> +/**
> + * refcount_add_not_zero - add a value to a refcount unless it is 0
> + * @i: the value to add to the refcount
> + * @r: the refcount
> + *
> + * Will saturate at UINT_MAX and WARN.
> + *
> + * Provides no memory ordering, it is assumed the caller has guaranteed the
> + * object memory to be stable (RCU, etc.). It does provide a control dependency
> + * and thereby orders future stores. See the comment on top.
> + *
> + * Use of this function is not recommended for the normal reference counting
> + * use case in which references are taken and released one at a time.  In these
> + * cases, refcount_inc(), or one of its variants, should instead be used to
> + * increment a reference count.
> + *
> + * Return: false if the passed refcount is 0, true otherwise
> + */
>  bool refcount_add_not_zero(unsigned int i, refcount_t *r)
>  {
>         unsigned int old, new, val = atomic_read(&r->refs);
> @@ -64,18 +82,39 @@ bool refcount_add_not_zero(unsigned int i, refcount_t *r)
>  }
>  EXPORT_SYMBOL_GPL(refcount_add_not_zero);
>
> +/**
> + * refcount_add - add a value to a refcount
> + * @i: the value to add to the refcount
> + * @r: the refcount
> + *
> + * Similar to atomic_add(), but will saturate at UINT_MAX and WARN.
> + *
> + * Provides no memory ordering, it is assumed the caller has guaranteed the
> + * object memory to be stable (RCU, etc.). It does provide a control dependency
> + * and thereby orders future stores. See the comment on top.
> + *
> + * Use of this function is not recommended for the normal reference counting
> + * use case in which references are taken and released one at a time.  In these
> + * cases, refcount_inc(), or one of its variants, should instead be used to
> + * increment a reference count.
> + */
>  void refcount_add(unsigned int i, refcount_t *r)
>  {
>         WARN(!refcount_add_not_zero(i, r), "refcount_t: addition on 0; use-after-free.\n");
>  }
>  EXPORT_SYMBOL_GPL(refcount_add);
>
> -/*
> - * Similar to atomic_inc_not_zero(), will saturate at UINT_MAX and WARN.
> +/**
> + * refcount_inc_not_zero - increment a refcount unless it is 0
> + * @r: the refcount to increment
> + *
> + * Similar to atomic_inc_not_zero(), but will saturate at UINT_MAX and WARN.
>   *
>   * Provides no memory ordering, it is assumed the caller has guaranteed the
>   * object memory to be stable (RCU, etc.). It does provide a control dependency
>   * and thereby orders future stores. See the comment on top.
> + *
> + * Return: true if the increment was successful, false otherwise
>   */
>  bool refcount_inc_not_zero(refcount_t *r)
>  {
> @@ -103,11 +142,17 @@ bool refcount_inc_not_zero(refcount_t *r)
>  }
>  EXPORT_SYMBOL_GPL(refcount_inc_not_zero);
>
> -/*
> - * Similar to atomic_inc(), will saturate at UINT_MAX and WARN.
> +/**
> + * refcount_inc - increment a refcount
> + * @r: the refcount to increment
> + *
> + * Similar to atomic_inc(), but will saturate at UINT_MAX and WARN.
>   *
>   * Provides no memory ordering, it is assumed the caller already has a
> - * reference on the object, will WARN when this is not so.
> + * reference on the object.
> + *
> + * Will WARN if the refcount is 0, as this represents a possible use-after-free
> + * condition.
>   */
>  void refcount_inc(refcount_t *r)
>  {
> @@ -115,6 +160,26 @@ void refcount_inc(refcount_t *r)
>  }
>  EXPORT_SYMBOL_GPL(refcount_inc);
>
> +/**
> + * refcount_sub_and_test - subtract from a refcount and test if it is 0
> + * @i: amount to subtract from the refcount
> + * @r: the refcount
> + *
> + * Similar to atomic_dec_and_test(), but it will WARN, return false and
> + * ultimately leak on underflow and will fail to decrement when saturated
> + * at UINT_MAX.
> + *
> + * Provides release memory ordering, such that prior loads and stores are done
> + * before, and provides a control dependency such that free() must come after.
> + * See the comment on top.
> + *
> + * Use of this function is not recommended for the normal reference counting
> + * use case in which references are taken and released one at a time.  In these
> + * cases, refcount_dec(), or one of its variants, should instead be used to
> + * decrement a reference count.
> + *
> + * Return: true if the resulting refcount is 0, false otherwise
> + */
>  bool refcount_sub_and_test(unsigned int i, refcount_t *r)
>  {
>         unsigned int old, new, val = atomic_read(&r->refs);
> @@ -140,13 +205,18 @@ bool refcount_sub_and_test(unsigned int i, refcount_t *r)
>  }
>  EXPORT_SYMBOL_GPL(refcount_sub_and_test);
>
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
> + * Return: true if the resulting refcount is 0, false otherwise
>   */
>  bool refcount_dec_and_test(refcount_t *r)
>  {
> @@ -154,21 +224,26 @@ bool refcount_dec_and_test(refcount_t *r)
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
>         WARN(refcount_dec_and_test(r), "refcount_t: decrement hit 0; leaking memory.\n");
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
> @@ -178,6 +253,8 @@ EXPORT_SYMBOL_GPL(refcount_dec);
>   * It can be used like a try-delete operator; this explicit case is provided
>   * and not cmpxchg in generic, because that would allow implementing unsafe
>   * operations.
> + *
> + * Return: true if the resulting refcount is 0, false otherwise
>   */
>  bool refcount_dec_if_one(refcount_t *r)
>  {
> @@ -185,11 +262,16 @@ bool refcount_dec_if_one(refcount_t *r)
>  }
>  EXPORT_SYMBOL_GPL(refcount_dec_if_one);
>
> -/*
> +/**
> + * refcount_dec_not_one - decrement a refcount if it is not 1
> + * @r: the refcount
> + *
>   * No atomic_t counterpart, it decrements unless the value is 1, in which case
>   * it will return false.
>   *
>   * Was often done like: atomic_add_unless(&var, -1, 1)
> + *
> + * Return: true if the decrement operation was successful, false otherwise
>   */
>  bool refcount_dec_not_one(refcount_t *r)
>  {
> @@ -219,13 +301,21 @@ bool refcount_dec_not_one(refcount_t *r)
>  }
>  EXPORT_SYMBOL_GPL(refcount_dec_not_one);
>
> -/*
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
> + * Return: true and hold mutex if able to decrement refcount to 0, false
> + *         otherwise
>   */
>  bool refcount_dec_and_mutex_lock(refcount_t *r, struct mutex *lock)
>  {
> @@ -242,13 +332,21 @@ bool refcount_dec_and_mutex_lock(refcount_t *r, struct mutex *lock)
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
> + * Return: true and hold spinlock if able to decrement refcount to 0, false
> + *         otherwise
>   */
>  bool refcount_dec_and_lock(refcount_t *r, spinlock_t *lock)
>  {
> --
> 2.7.4
>



-- 
Kees Cook
Pixel Security
