Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 18 Oct 2016 16:06:57 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
Message-ID: <20161018070656.GO19531@linaro.org>
References: <1476472255-15851-1-git-send-email-colin@cvidal.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476472255-15851-1-git-send-email-colin@cvidal.org>
Subject: [kernel-hardening] Re: include/asm-generic/atomic-long.h: Reordering atomic_*_wrap
 macros
To: Colin Vidal <colin@cvidal.org>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>, David Windsor <dwindsor@gmail.com>, Hans Liljestrand <ishkamiel@gmail.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Colin,

On Fri, Oct 14, 2016 at 09:10:55PM +0200, Colin Vidal wrote:
> Hi Elena,
> 
> I don't know if it may helps for the v2, but here is the (tiny)
> modifications I have done on a generic part to be able to build on ARM
> without CONFIG_HARDENING_ATOMIC (of course, there is also some
> modifications in arch/arm, but it is not the subject, and it only a
> prototype for now). It does not break x86 builds.

I saw the same problem when compiling on arm64, but

> It basically a reordering / guard on macros atomic_*_wrap in order to

I don't think that we need re-ordering, and

> avoid implicitly defined / redefined error about them, when
> CONFIG_HARDENED_ATOMIC is unset.
> 
> Thanks,
> 
> Colin
> 
> ---
>  include/asm-generic/atomic-long.h | 43 ++++++++++++++++-----------------------
>  1 file changed, 18 insertions(+), 25 deletions(-)
> 
> diff --git a/include/asm-generic/atomic-long.h b/include/asm-generic/atomic-long.h
> index 790cb00..6f1dc3e 100644
> --- a/include/asm-generic/atomic-long.h
> +++ b/include/asm-generic/atomic-long.h
> @@ -46,6 +46,22 @@ typedef atomic_t atomic_long_wrap_t;
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
> +#define atomic_inc_return_wrap(v) atomic_inc_return(v)
> +#define atomic_add_return_wrap(i, v) atomic_add_return((i), (v))
> +#define atomic_dec_wrap(v) atomic_dec(v)
> +#define atomic_cmpxchg_wrap(v, o, n) atomic_cmpxchg((v), (o), (n))
> +#define atomic_xchg_wrap(v, i) atomic_xchg((v), (i))
> +#define atomic_long_sub_and_test_wrap(i, v) atomic_long_sub_and_test(i, v)

removing this definition (atomic_long_sub_and_test_wrap) in
the original location and

> +#endif /* CONFIG_HARDENED_ATOMIC */
> +
>  #define ATOMIC_LONG_READ_OP(mo, suffix)						\
>  static inline long atomic_long_read##mo##suffix(const atomic_long##suffix##_t *l)\
>  {									\
> @@ -233,12 +249,14 @@ static inline int atomic_long_sub_and_test(long i, atomic_long_t *l)
>  	return ATOMIC_LONG_PFX(_sub_and_test)(i, v);
>  }
>  
> +#ifdef CONFIG_HARDENED_ATOMIC

removing this guard would work both for HARDENED_ATOMIC and
!HARDENED_ATOMIC.

Anyway, IMO, we should (and can) generate _wrap version of definitions
in a more systematic way to cover whole functions.

Thanks,
-Takahiro AKASHI

>  static inline int atomic_long_sub_and_test_wrap(long i, atomic_long_wrap_t *l)
>  {
>  	ATOMIC_LONG_PFX(_wrap_t) *v = (ATOMIC_LONG_PFX(_wrap_t) *)l;
>  
>  	return ATOMIC_LONG_PFX(_sub_and_test_wrap)(i, v);
>  }
> +#endif
>  
>  static inline int atomic_long_dec_and_test(atomic_long_t *l)
>  {
> @@ -291,29 +309,4 @@ static inline long atomic_long_add_unless(atomic_long_t *l, long a, long u)
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
> -- 
> 2.7.4
> 
