Reply-To: kernel-hardening@lists.openwall.com
References: <1476802761-24340-1-git-send-email-colin@cvidal.org>
 <1476802761-24340-2-git-send-email-colin@cvidal.org>
From: Vaishali Thakkar <vaishali.thakkar@oracle.com>
Message-ID: <5806481C.1070807@oracle.com>
Date: Tue, 18 Oct 2016 21:34:44 +0530
MIME-Version: 1.0
In-Reply-To: <1476802761-24340-2-git-send-email-colin@cvidal.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [RFC 1/2] Reordering / guard definition on
 atomic_*_wrap function in order to avoid implicitly defined / redefined error
 on them, when CONFIG_HARDENED_ATOMIC is unset.
To: kernel-hardening@lists.openwall.com, "Reshetova, Elena" <elena.reshetova@intel.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, David Windsor <dave@progbits.org>, Kees Cook <keescook@chromium.org>, Hans Liljestrand <ishkamiel@gmail.com>
Cc: Colin Vidal <colin@cvidal.org>
List-ID: <kernel-hardening.lists.openwall.com>



On Tuesday 18 October 2016 08:29 PM, Colin Vidal wrote:
> Signed-off-by: Colin Vidal <colin@cvidal.org>

Hi,

While I can't comment on technical things because of my limited arm
specific knowledge [although these are simple changes, I would let
others comment on this], I think subject is too long according to the
kernel's patch submission guidelines.

Also, I know these are simple mechanic changes. But I still think
that having a commit log can help here. May be you can have something
similar to Elena's x86 patches. 

Your other patch in the series looks good to me. :)

Thanks.


> ---
>  include/asm-generic/atomic-long.h | 55 +++++++++++++++++++++------------------
>  include/linux/atomic.h            | 55 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 85 insertions(+), 25 deletions(-)
> 
> diff --git a/include/asm-generic/atomic-long.h b/include/asm-generic/atomic-long.h
> index 790cb00..94d712b 100644
> --- a/include/asm-generic/atomic-long.h
> +++ b/include/asm-generic/atomic-long.h
> @@ -46,6 +46,30 @@ typedef atomic_t atomic_long_wrap_t;
>  
>  #endif
>  
> +#ifndef CONFIG_HARDENED_ATOMIC
> +#define atomic_read_wrap(v) atomic_read(v)
> +#define atomic_set_wrap(v, i) atomic_set((v), (i))
> +#define atomic_add_wrap(i, v) atomic_add((i), (v))
> +#define atomic_add_unless_wrap(v, i, j) atomic_add_unless((v), (i), (j))
> +#define atomic_sub_wrap(i, v) atomic_sub((i), (v))
> +#define atomic_inc_wrap(v) atomic_inc(v)
> +#define atomic_inc_and_test_wrap(v) atomic_inc_and_test(v)
> +#ifndef atomic_inc_return_wrap
> +#define atomic_inc_return_wrap(v) atomic_inc_return(v)
> +#endif
> +#ifndef atomic_add_return_wrap
> +#define atomic_add_return_wrap(i, v) atomic_add_return((i), (v))
> +#endif
> +#define atomic_dec_wrap(v) atomic_dec(v)
> +#ifndef atomic_xchg_wrap
> +#define atomic_xchg_wrap(v, i) atomic_xchg((v), (i))
> +#endif
> +#define atomic_long_inc_wrap(v) atomic_long_inc(v)
> +#define atomic_long_dec_wrap(v) atomic_long_dec(v)
> +#define atomic_long_xchg_wrap(v, n) atomic_long_xchg(v, n)
> +#define atomic_long_cmpxchg_wrap(l, o, n) atomic_long_cmpxchg(l, o, n)
> +#endif /* CONFIG_HARDENED_ATOMIC */
> +
>  #define ATOMIC_LONG_READ_OP(mo, suffix)						\
>  static inline long atomic_long_read##mo##suffix(const atomic_long##suffix##_t *l)\
>  {									\
> @@ -104,6 +128,12 @@ ATOMIC_LONG_ADD_SUB_OP(sub, _release,)
>  #define atomic_long_cmpxchg(l, old, new) \
>  	(ATOMIC_LONG_PFX(_cmpxchg)((ATOMIC_LONG_PFX(_t) *)(l), (old), (new)))
>  
> +#ifdef CONFIG_HARDENED_ATOMIC
> +#define atomic_long_cmpxchg_wrap(l, old, new)				\
> +	(ATOMIC_LONG_PFX(_cmpxchg_wrap)((ATOMIC_LONG_PFX(_wrap_t) *)(l),\
> +					(old), (new)))
> +#endif
> +
>  #define atomic_long_xchg_relaxed(v, new) \
>  	(ATOMIC_LONG_PFX(_xchg_relaxed)((ATOMIC_LONG_PFX(_t) *)(v), (new)))
>  #define atomic_long_xchg_acquire(v, new) \
> @@ -291,29 +321,4 @@ static inline long atomic_long_add_unless(atomic_long_t *l, long a, long u)
>  #define atomic_long_inc_not_zero(l) \
>  	ATOMIC_LONG_PFX(_inc_not_zero)((ATOMIC_LONG_PFX(_t) *)(l))
>  
> -#ifndef CONFIG_HARDENED_ATOMIC
> -#define atomic_read_wrap(v) atomic_read(v)
> -#define atomic_set_wrap(v, i) atomic_set((v), (i))
> -#define atomic_add_wrap(i, v) atomic_add((i), (v))
> -#define atomic_add_unless_wrap(v, i, j) atomic_add_unless((v), (i), (j))
> -#define atomic_sub_wrap(i, v) atomic_sub((i), (v))
> -#define atomic_inc_wrap(v) atomic_inc(v)
> -#define atomic_inc_and_test_wrap(v) atomic_inc_and_test(v)
> -#define atomic_inc_return_wrap(v) atomic_inc_return(v)
> -#define atomic_add_return_wrap(i, v) atomic_add_return((i), (v))
> -#define atomic_dec_wrap(v) atomic_dec(v)
> -#define atomic_cmpxchg_wrap(v, o, n) atomic_cmpxchg((v), (o), (n))
> -#define atomic_xchg_wrap(v, i) atomic_xchg((v), (i))
> -#define atomic_long_read_wrap(v) atomic_long_read(v)
> -#define atomic_long_set_wrap(v, i) atomic_long_set((v), (i))
> -#define atomic_long_add_wrap(i, v) atomic_long_add((i), (v))
> -#define atomic_long_sub_wrap(i, v) atomic_long_sub((i), (v))
> -#define atomic_long_inc_wrap(v) atomic_long_inc(v)
> -#define atomic_long_add_return_wrap(i, v) atomic_long_add_return((i), (v))
> -#define atomic_long_inc_return_wrap(v) atomic_long_inc_return(v)
> -#define atomic_long_sub_and_test_wrap(i, v) atomic_long_sub_and_test((i), (v))
> -#define atomic_long_dec_wrap(v) atomic_long_dec(v)
> -#define atomic_long_xchg_wrap(v, i) atomic_long_xchg((v), (i))
> -#endif /* CONFIG_HARDENED_ATOMIC */
> -
>  #endif  /*  _ASM_GENERIC_ATOMIC_LONG_H  */
> diff --git a/include/linux/atomic.h b/include/linux/atomic.h
> index b5817c8..be16ea1 100644
> --- a/include/linux/atomic.h
> +++ b/include/linux/atomic.h
> @@ -89,6 +89,11 @@
>  #define  atomic_add_return(...)						\
>  	__atomic_op_fence(atomic_add_return, __VA_ARGS__)
>  #endif
> +
> +#ifndef atomic_add_return_wrap_relaxed
> +#define atomic_add_return_wrap(...)		                        \
> +	__atomic_op_fence(atomic_add_return_wrap, __VA_ARGS__)
> +#endif
>  #endif /* atomic_add_return_relaxed */
>  
>  /* atomic_inc_return_relaxed */
> @@ -113,6 +118,11 @@
>  #define  atomic_inc_return(...)						\
>  	__atomic_op_fence(atomic_inc_return, __VA_ARGS__)
>  #endif
> +
> +#ifndef atomic_inc_return_wrap
> +#define  atomic_inc_return_wrap(...)					\
> +	__atomic_op_fence(atomic_inc_return_wrap, __VA_ARGS__)
> +#endif
>  #endif /* atomic_inc_return_relaxed */
>  
>  /* atomic_sub_return_relaxed */
> @@ -137,6 +147,11 @@
>  #define  atomic_sub_return(...)						\
>  	__atomic_op_fence(atomic_sub_return, __VA_ARGS__)
>  #endif
> +
> +#ifndef atomic_sub_return_wrap_relaxed
> +#define atomic_sub_return_wrap(...)		                        \
> +	__atomic_op_fence(atomic_sub_return_wrap, __VA_ARGS__)
> +#endif
>  #endif /* atomic_sub_return_relaxed */
>  
>  /* atomic_dec_return_relaxed */
> @@ -161,6 +176,11 @@
>  #define  atomic_dec_return(...)						\
>  	__atomic_op_fence(atomic_dec_return, __VA_ARGS__)
>  #endif
> +
> +#ifndef atomic_dec_return_wrap
> +#define  atomic_dec_return_wrap(...)					\
> +	__atomic_op_fence(atomic_dec_return, __VA_ARGS__)
> +#endif
>  #endif /* atomic_dec_return_relaxed */
>  
>  
> @@ -421,6 +441,11 @@
>  #define  atomic_cmpxchg(...)						\
>  	__atomic_op_fence(atomic_cmpxchg, __VA_ARGS__)
>  #endif
> +
> +#ifndef atomic_cmpxchg_wrap
> +#define  atomic_cmpxchg_wrap(...)					\
> +	__atomic_op_fence(atomic_cmpxchg_wrap, __VA_ARGS__)
> +#endif
>  #endif /* atomic_cmpxchg_relaxed */
>  
>  /* cmpxchg_relaxed */
> @@ -675,6 +700,11 @@ static inline int atomic_dec_if_positive(atomic_t *v)
>  #define  atomic64_add_return(...)					\
>  	__atomic_op_fence(atomic64_add_return, __VA_ARGS__)
>  #endif
> +
> +#ifndef atomic64_add_return_wrap
> +#define  atomic64_add_return_wrap(...)					\
> +	__atomic_op_fence(atomic64_add_return_wrap, __VA_ARGS__)
> +#endif
>  #endif /* atomic64_add_return_relaxed */
>  
>  /* atomic64_inc_return_relaxed */
> @@ -699,6 +729,11 @@ static inline int atomic_dec_if_positive(atomic_t *v)
>  #define  atomic64_inc_return(...)					\
>  	__atomic_op_fence(atomic64_inc_return, __VA_ARGS__)
>  #endif
> +
> +#ifndef atomic64_inc_return_wrap
> +#define  atomic64_inc_return_wrap(...)					\
> +	__atomic_op_fence(atomic64_inc_return_wrap, __VA_ARGS__)
> +#endif
>  #endif /* atomic64_inc_return_relaxed */
>  
>  
> @@ -724,6 +759,11 @@ static inline int atomic_dec_if_positive(atomic_t *v)
>  #define  atomic64_sub_return(...)					\
>  	__atomic_op_fence(atomic64_sub_return, __VA_ARGS__)
>  #endif
> +
> +#ifndef atomic64_sub_return_wrap
> +#define  atomic64_sub_return_wrap(...)					\
> +	__atomic_op_fence(atomic64_sub_return_wrap, __VA_ARGS__)
> +#endif
>  #endif /* atomic64_sub_return_relaxed */
>  
>  /* atomic64_dec_return_relaxed */
> @@ -748,6 +788,11 @@ static inline int atomic_dec_if_positive(atomic_t *v)
>  #define  atomic64_dec_return(...)					\
>  	__atomic_op_fence(atomic64_dec_return, __VA_ARGS__)
>  #endif
> +
> +#ifndef atomic64_dec_return_wrap
> +#define  atomic64_dec_return_wrap(...)					\
> +	__atomic_op_fence(atomic64_dec_return_wrap, __VA_ARGS__)
> +#endif
>  #endif /* atomic64_dec_return_relaxed */
>  
>  
> @@ -984,6 +1029,11 @@ static inline int atomic_dec_if_positive(atomic_t *v)
>  #define  atomic64_xchg(...)						\
>  	__atomic_op_fence(atomic64_xchg, __VA_ARGS__)
>  #endif
> +
> +#ifndef atomic64_xchg_wrap
> +#define  atomic64_xchg_wrap(...)					\
> +	__atomic_op_fence(atomic64_xchg_wrap, __VA_ARGS__)
> +#endif
>  #endif /* atomic64_xchg_relaxed */
>  
>  /* atomic64_cmpxchg_relaxed */
> @@ -1008,6 +1058,11 @@ static inline int atomic_dec_if_positive(atomic_t *v)
>  #define  atomic64_cmpxchg(...)						\
>  	__atomic_op_fence(atomic64_cmpxchg, __VA_ARGS__)
>  #endif
> +
> +#ifndef atomic64_cmpxchg_wrap
> +#define  atomic64_cmpxchg_wrap(...)					\
> +	__atomic_op_fence(atomic64_cmpxchg_wrap, __VA_ARGS__)
> +#endif
>  #endif /* atomic64_cmpxchg_relaxed */
>  
>  #ifndef atomic64_andnot
> 

-- 
Vaishali
