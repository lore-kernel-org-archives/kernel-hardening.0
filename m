Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 12 Oct 2016 17:26:35 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
Message-ID: <20161012082634.GK19531@linaro.org>
References: <1475476886-26232-1-git-send-email-elena.reshetova@intel.com>
 <1475476886-26232-2-git-send-email-elena.reshetova@intel.com>
 <CAGXu5j+7_cd4GgX46wSMv9LHpogwH7qrU8=K8OPEed4hCGr65g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+7_cd4GgX46wSMv9LHpogwH7qrU8=K8OPEed4hCGr65g@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [RFC PATCH 01/13] Add architecture
 independent hardened atomic base
To: kernel-hardening@lists.openwall.com
Cc: Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Kees, Elena,

I've just finished prototyping HARDENED_ATOMIC support for arm64,
but

On Mon, Oct 03, 2016 at 02:10:40PM -0700, Kees Cook wrote:
> On Sun, Oct 2, 2016 at 11:41 PM, Elena Reshetova
> <elena.reshetova@intel.com> wrote:
> > This series brings the PaX/Grsecurity PAX_REFCOUNT [1]
> > feature support to the upstream kernel. All credit for the
> > feature goes to the feature authors.
> >
> > The name of the upstream feature is HARDENED_ATOMIC
> > and it is configured using CONFIG_HARDENED_ATOMIC and
> > HAVE_ARCH_HARDENED_ATOMIC.
> >
> > This series only adds x86 support; other architectures are expected
> > to add similar support gradually.
> >
> > Feature Summary
> > ---------------
> > The primary goal of KSPP is to provide protection against classes
> > of vulnerabilities.  One such class of vulnerabilities, known as
> > use-after-free bugs, frequently results when reference counters
> > guarding shared kernel objects are overflowed.  The existence of
> > a kernel path in which a reference counter is incremented more
> > than it is decremented can lead to wrapping. This buggy path can be
> > executed until INT_MAX/LONG_MAX is reached, at which point further
> > increments will cause the counter to wrap to 0.  At this point, the
> > kernel will erroneously mark the object as not in use, resulting in
> > a multitude of undesirable cases: releasing the object to other users,
> > freeing the object while it still has legitimate users, or other
> > undefined conditions.  The above scenario is known as a use-after-free
> > bug.
> >
> > HARDENED_ATOMIC provides mandatory protection against kernel
> > reference counter overflows.  In Linux, reference counters
> > are implemented using the atomic_t and atomic_long_t types.
> > HARDENED_ATOMIC modifies the functions dealing with these types
> > such that when INT_MAX/LONG_MAX is reached, the atomic variables
> > remain saturated at these maximum values, rather than wrapping.
> >
> > There are several non-reference counter users of atomic_t and
> > atomic_long_t (the fact that these types are being so widely
> > misused is not addressed by this series).  These users, typically
> > statistical counters, are not concerned with whether the values of
> > these types wrap, and therefore can dispense with the added performance
> > penalty incurred from protecting against overflows. New types have
> > been introduced for these users: atomic_wrap_t and atomic_long_wrap_t.
> > Functions for manipulating these types have been added as well.
> >
> > Note that the protection provided by HARDENED_ATOMIC is not "opt-in":
> > since atomic_t is so widely misused, it must be protected as-is.
> > HARDENED_ATOMIC protects all users of atomic_t and atomic_long_t
> > against overflow.  New users wishing to use atomic types, but not
> > needing protection against overflows, should use the new types
> > introduced by this series: atomic_wrap_t and atomic_long_wrap_t.
> >
> > Bugs Prevented
> > --------------
> > HARDENED_ATOMIC would directly mitigate these Linux kernel bugs:
> >
> > CVE-2016-3135 - Netfilter xt_alloc_table_info integer overflow
> > CVE-2016-0728 - Keyring refcount overflow
> > CVE-2014-2851 - Group_info refcount overflow
> > CVE-2010-2959 - CAN integer overflow vulnerability,
> > related post: https://jon.oberheide.org/blog/2010/09/10/linux-kernel-can-slub-overflow/
> >
> > And a relatively fresh exploit example:
> > https://www.exploit-db.com/exploits/39773/
> >
> > [1] https://forums.grsecurity.net/viewtopic.php?f=7&t=4173
> >
> > Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> > Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
> > Signed-off-by: David Windsor <dwindsor@gmail.com>
> > ---
> >  include/asm-generic/atomic-long.h | 166 +++++++++++++++++++++++++++-----------
> >  include/asm-generic/atomic.h      |   9 +++
> >  include/asm-generic/atomic64.h    |  13 +++
> >  include/asm-generic/bug.h         |   4 +
> >  include/asm-generic/local.h       |  15 ++++
> >  include/linux/atomic.h            |  14 ++++
> >  include/linux/types.h             |  17 ++++
> >  kernel/panic.c                    |  12 +++
> >  security/Kconfig                  |  15 ++++
> >  9 files changed, 219 insertions(+), 46 deletions(-)
> >
> > diff --git a/include/asm-generic/atomic-long.h b/include/asm-generic/atomic-long.h
> > index 288cc9e..e74ca86 100644
> > --- a/include/asm-generic/atomic-long.h
> > +++ b/include/asm-generic/atomic-long.h
> > @@ -22,6 +22,12 @@
> >
> >  typedef atomic64_t atomic_long_t;
> >
> > +#ifdef CONFIG_HARDENED_ATOMIC
> > +typedef atomic64_wrap_t atomic_long_wrap_t;
> > +#else
> > +typedef atomic64_t atomic_long_wrap_t;
> > +#endif
> > +
> >  #define ATOMIC_LONG_INIT(i)    ATOMIC64_INIT(i)
> >  #define ATOMIC_LONG_PFX(x)     atomic64 ## x
> >
> > @@ -29,51 +35,61 @@ typedef atomic64_t atomic_long_t;
> >
> >  typedef atomic_t atomic_long_t;
> >
> > +#ifdef CONFIG_HARDENED_ATOMIC
> > +typedef atomic_wrap_t atomic_long_wrap_t;
> > +#else
> > +typedef atomic_t atomic_long_wrap_t;
> > +#endif
> > +
> >  #define ATOMIC_LONG_INIT(i)    ATOMIC_INIT(i)
> >  #define ATOMIC_LONG_PFX(x)     atomic ## x
> >
> >  #endif
> >
> > -#define ATOMIC_LONG_READ_OP(mo)                                                \
> > -static inline long atomic_long_read##mo(const atomic_long_t *l)                \
> > +#define ATOMIC_LONG_READ_OP(mo, suffix)                                                \
> > +static inline long atomic_long_read##mo##suffix(const atomic_long##suffix##_t *l)\
> >  {                                                                      \
> > -       ATOMIC_LONG_PFX(_t) *v = (ATOMIC_LONG_PFX(_t) *)l;              \
> > +       ATOMIC_LONG_PFX(suffix##_t) *v = (ATOMIC_LONG_PFX(suffix##_t) *)l;\
> >                                                                         \
> > -       return (long)ATOMIC_LONG_PFX(_read##mo)(v);                     \
> > +       return (long)ATOMIC_LONG_PFX(_read##mo##suffix)(v);             \
> >  }
> > -ATOMIC_LONG_READ_OP()
> > -ATOMIC_LONG_READ_OP(_acquire)
> > +ATOMIC_LONG_READ_OP(,)
> > +ATOMIC_LONG_READ_OP(,_wrap)
> > +ATOMIC_LONG_READ_OP(_acquire,)
> >
> >  #undef ATOMIC_LONG_READ_OP
> >
> > -#define ATOMIC_LONG_SET_OP(mo)                                         \
> > -static inline void atomic_long_set##mo(atomic_long_t *l, long i)       \
> > +#define ATOMIC_LONG_SET_OP(mo, suffix)                                 \
> > +static inline void atomic_long_set##mo##suffix(atomic_long##suffix##_t *l, long i)\
> >  {                                                                      \
> > -       ATOMIC_LONG_PFX(_t) *v = (ATOMIC_LONG_PFX(_t) *)l;              \
> > +       ATOMIC_LONG_PFX(suffix##_t) *v = (ATOMIC_LONG_PFX(suffix##_t) *)l;\
> >                                                                         \
> > -       ATOMIC_LONG_PFX(_set##mo)(v, i);                                \
> > +       ATOMIC_LONG_PFX(_set##mo##suffix)(v, i);                        \
> >  }
> > -ATOMIC_LONG_SET_OP()
> > -ATOMIC_LONG_SET_OP(_release)
> > +ATOMIC_LONG_SET_OP(,)
> > +ATOMIC_LONG_SET_OP(,_wrap)
> > +ATOMIC_LONG_SET_OP(_release,)
> >
> >  #undef ATOMIC_LONG_SET_OP
> >
> > -#define ATOMIC_LONG_ADD_SUB_OP(op, mo)                                 \
> > +#define ATOMIC_LONG_ADD_SUB_OP(op, mo, suffix)                         \
> >  static inline long                                                     \
> > -atomic_long_##op##_return##mo(long i, atomic_long_t *l)                        \
> > +atomic_long_##op##_return##mo##suffix(long i, atomic_long##suffix##_t *l)\
> >  {                                                                      \
> > -       ATOMIC_LONG_PFX(_t) *v = (ATOMIC_LONG_PFX(_t) *)l;              \
> > +       ATOMIC_LONG_PFX(suffix##_t) *v = (ATOMIC_LONG_PFX(suffix##_t) *)l;\
> >                                                                         \
> > -       return (long)ATOMIC_LONG_PFX(_##op##_return##mo)(i, v);         \
> > +       return (long)ATOMIC_LONG_PFX(_##op##_return##mo##suffix)(i, v);\
> >  }
> > -ATOMIC_LONG_ADD_SUB_OP(add,)
> > -ATOMIC_LONG_ADD_SUB_OP(add, _relaxed)
> > -ATOMIC_LONG_ADD_SUB_OP(add, _acquire)
> > -ATOMIC_LONG_ADD_SUB_OP(add, _release)
> > -ATOMIC_LONG_ADD_SUB_OP(sub,)
> > -ATOMIC_LONG_ADD_SUB_OP(sub, _relaxed)
> > -ATOMIC_LONG_ADD_SUB_OP(sub, _acquire)
> > -ATOMIC_LONG_ADD_SUB_OP(sub, _release)
> > +ATOMIC_LONG_ADD_SUB_OP(add,,)
> > +ATOMIC_LONG_ADD_SUB_OP(add,,_wrap)
> > +ATOMIC_LONG_ADD_SUB_OP(add, _relaxed,)
> > +ATOMIC_LONG_ADD_SUB_OP(add, _acquire,)
> > +ATOMIC_LONG_ADD_SUB_OP(add, _release,)
> > +ATOMIC_LONG_ADD_SUB_OP(sub,,)
> > +//ATOMIC_LONG_ADD_SUB_OP(sub,,_wrap) todo: check if this is really not needed
> 
> Let's get this question answered. Seems like it'd make sense to create
> complete function coverage?

I'd love to know the answer since there tons of variants of atomic operations.

> > +ATOMIC_LONG_ADD_SUB_OP(sub, _relaxed,)
> > +ATOMIC_LONG_ADD_SUB_OP(sub, _acquire,)
> > +ATOMIC_LONG_ADD_SUB_OP(sub, _release,)
> >
> >  #undef ATOMIC_LONG_ADD_SUB_OP
> >
> > @@ -98,6 +114,11 @@ ATOMIC_LONG_ADD_SUB_OP(sub, _release)
> >  #define atomic_long_xchg(v, new) \
> >         (ATOMIC_LONG_PFX(_xchg)((ATOMIC_LONG_PFX(_t) *)(v), (new)))
> >
> > +#ifdef CONFIG_HARDENED_ATOMIC
> > +#define atomic_long_xchg_wrap(v, new) \
> > +       (ATOMIC_LONG_PFX(_xchg_wrap)((ATOMIC_LONG_PFX(_wrap_t) *)(v), (new)))
> > +#endif
> > +
> >  static __always_inline void atomic_long_inc(atomic_long_t *l)
> >  {
> >         ATOMIC_LONG_PFX(_t) *v = (ATOMIC_LONG_PFX(_t) *)l;
> > @@ -105,6 +126,15 @@ static __always_inline void atomic_long_inc(atomic_long_t *l)
> >         ATOMIC_LONG_PFX(_inc)(v);
> >  }
> >
> > +#ifdef CONFIG_HARDENED_ATOMIC
> > +static __always_inline void atomic_long_inc_wrap(atomic_long_wrap_t *l)
> > +{
> > +       ATOMIC_LONG_PFX(_wrap_t) *v = (ATOMIC_LONG_PFX(_wrap_t) *)l;
> > +
> > +       ATOMIC_LONG_PFX(_inc_wrap)(v);
> > +}
> > +#endif
> > +
> >  static __always_inline void atomic_long_dec(atomic_long_t *l)
> >  {
> >         ATOMIC_LONG_PFX(_t) *v = (ATOMIC_LONG_PFX(_t) *)l;
> > @@ -112,6 +142,15 @@ static __always_inline void atomic_long_dec(atomic_long_t *l)
> >         ATOMIC_LONG_PFX(_dec)(v);
> >  }
> >
> > +#ifdef CONFIG_HARDENED_ATOMIC
> > +static __always_inline void atomic_long_dec_wrap(atomic_long_wrap_t *l)
> > +{
> > +       ATOMIC_LONG_PFX(_wrap_t) *v = (ATOMIC_LONG_PFX(_wrap_t) *)l;
> > +
> > +       ATOMIC_LONG_PFX(_dec_wrap)(v);
> > +}
> > +#endif
> > +
> >  #define ATOMIC_LONG_FETCH_OP(op, mo)                                   \
> >  static inline long                                                     \
> >  atomic_long_fetch_##op##mo(long i, atomic_long_t *l)                   \
> > @@ -168,21 +207,23 @@ ATOMIC_LONG_FETCH_INC_DEC_OP(dec, _release)
> >
> >  #undef ATOMIC_LONG_FETCH_INC_DEC_OP
> >
> > -#define ATOMIC_LONG_OP(op)                                             \
> > +#define ATOMIC_LONG_OP(op, suffix)                                     \
> >  static __always_inline void                                            \
> > -atomic_long_##op(long i, atomic_long_t *l)                             \
> > +atomic_long_##op##suffix(long i, atomic_long##suffix##_t *l)           \
> >  {                                                                      \
> > -       ATOMIC_LONG_PFX(_t) *v = (ATOMIC_LONG_PFX(_t) *)l;              \
> > +       ATOMIC_LONG_PFX(suffix##_t) *v = (ATOMIC_LONG_PFX(suffix##_t) *)l;\
> >                                                                         \
> > -       ATOMIC_LONG_PFX(_##op)(i, v);                                   \
> > +       ATOMIC_LONG_PFX(_##op##suffix)(i, v);                           \
> >  }
> >
> > -ATOMIC_LONG_OP(add)
> > -ATOMIC_LONG_OP(sub)
> > -ATOMIC_LONG_OP(and)
> > -ATOMIC_LONG_OP(andnot)
> > -ATOMIC_LONG_OP(or)
> > -ATOMIC_LONG_OP(xor)
> > +ATOMIC_LONG_OP(add,)
> > +ATOMIC_LONG_OP(add,_wrap)
> > +ATOMIC_LONG_OP(sub,)
> > +ATOMIC_LONG_OP(sub,_wrap)
> > +ATOMIC_LONG_OP(and,)
> > +ATOMIC_LONG_OP(or,)
> > +ATOMIC_LONG_OP(xor,)
> > +ATOMIC_LONG_OP(andnot,)

For instance, are we sure that we would never call atomic_long_and_wrap()
to atomic_long_wrap_t variable?

> >  #undef ATOMIC_LONG_OP
> >
> > @@ -193,6 +234,13 @@ static inline int atomic_long_sub_and_test(long i, atomic_long_t *l)
> >         return ATOMIC_LONG_PFX(_sub_and_test)(i, v);
> >  }
> >
> > +static inline int atomic_long_sub_and_test_wrap(long i, atomic_long_wrap_t *l)
> > +{
> > +       ATOMIC_LONG_PFX(_wrap_t) *v = (ATOMIC_LONG_PFX(_wrap_t) *)l;
> > +
> > +       return ATOMIC_LONG_PFX(_sub_and_test_wrap)(i, v);
> > +}
> > +
> >  static inline int atomic_long_dec_and_test(atomic_long_t *l)
> >  {
> >         ATOMIC_LONG_PFX(_t) *v = (ATOMIC_LONG_PFX(_t) *)l;
> > @@ -214,22 +262,23 @@ static inline int atomic_long_add_negative(long i, atomic_long_t *l)
> >         return ATOMIC_LONG_PFX(_add_negative)(i, v);
> >  }
> >
> > -#define ATOMIC_LONG_INC_DEC_OP(op, mo)                                 \
> > +#define ATOMIC_LONG_INC_DEC_OP(op, mo, suffix)                         \
> >  static inline long                                                     \
> > -atomic_long_##op##_return##mo(atomic_long_t *l)                                \
> > +atomic_long_##op##_return##mo##suffix(atomic_long##suffix##_t *l)      \
> >  {                                                                      \
> > -       ATOMIC_LONG_PFX(_t) *v = (ATOMIC_LONG_PFX(_t) *)l;              \
> > +       ATOMIC_LONG_PFX(suffix##_t) *v = (ATOMIC_LONG_PFX(suffix##_t) *)l;\
> >                                                                         \
> > -       return (long)ATOMIC_LONG_PFX(_##op##_return##mo)(v);            \
> > +       return (long)ATOMIC_LONG_PFX(_##op##_return##mo##suffix)(v);    \
> >  }
> > -ATOMIC_LONG_INC_DEC_OP(inc,)
> > -ATOMIC_LONG_INC_DEC_OP(inc, _relaxed)
> > -ATOMIC_LONG_INC_DEC_OP(inc, _acquire)
> > -ATOMIC_LONG_INC_DEC_OP(inc, _release)
> > -ATOMIC_LONG_INC_DEC_OP(dec,)
> > -ATOMIC_LONG_INC_DEC_OP(dec, _relaxed)
> > -ATOMIC_LONG_INC_DEC_OP(dec, _acquire)
> > -ATOMIC_LONG_INC_DEC_OP(dec, _release)
> > +ATOMIC_LONG_INC_DEC_OP(inc,,)
> > +ATOMIC_LONG_INC_DEC_OP(inc,,_wrap)
> > +ATOMIC_LONG_INC_DEC_OP(inc, _relaxed,)
> > +ATOMIC_LONG_INC_DEC_OP(inc, _acquire,)
> > +ATOMIC_LONG_INC_DEC_OP(inc, _release,)
> > +ATOMIC_LONG_INC_DEC_OP(dec,,)
> > +ATOMIC_LONG_INC_DEC_OP(dec, _relaxed,)
> > +ATOMIC_LONG_INC_DEC_OP(dec, _acquire,)
> > +ATOMIC_LONG_INC_DEC_OP(dec, _release,)
> >
> >  #undef ATOMIC_LONG_INC_DEC_OP
> >
> > @@ -243,4 +292,29 @@ static inline long atomic_long_add_unless(atomic_long_t *l, long a, long u)
> >  #define atomic_long_inc_not_zero(l) \
> >         ATOMIC_LONG_PFX(_inc_not_zero)((ATOMIC_LONG_PFX(_t) *)(l))
> >
> > +#ifndef CONFIG_HARDENED_ATOMIC
> > +#define atomic_read_wrap(v) atomic_read(v)
> > +#define atomic_set_wrap(v, i) atomic_set((v), (i))
> > +#define atomic_add_wrap(i, v) atomic_add((i), (v))
> > +#define atomic_add_unless_wrap(v, i, j) atomic_add_unless((v), (i), (j))
> > +#define atomic_sub_wrap(i, v) atomic_sub((i), (v))
> > +#define atomic_inc_wrap(v) atomic_inc(v)
> > +#define atomic_inc_and_test_wrap(v) atomic_inc_and_test(v)
> > +#define atomic_inc_return_wrap(v) atomic_inc_return(v)
> > +#define atomic_add_return_wrap(i, v) atomic_add_return((i), (v))
> > +#define atomic_dec_wrap(v) atomic_dec(v)
> > +#define atomic_cmpxchg_wrap(v, o, n) atomic_cmpxchg((v), (o), (n))
> > +#define atomic_xchg_wrap(v, i) atomic_xchg((v), (i))
> > +#define atomic_long_read_wrap(v) atomic_long_read(v)
> > +#define atomic_long_set_wrap(v, i) atomic_long_set((v), (i))
> > +#define atomic_long_add_wrap(i, v) atomic_long_add((i), (v))
> > +#define atomic_long_sub_wrap(i, v) atomic_long_sub((i), (v))
> > +#define atomic_long_inc_wrap(v) atomic_long_inc(v)
> > +#define atomic_long_add_return_wrap(i, v) atomic_long_add_return((i), (v))
> > +#define atomic_long_inc_return_wrap(v) atomic_long_inc_return(v)
> > +#define atomic_long_sub_and_test_wrap(v) atomic_long_sub_and_test(v)
> > +#define atomic_long_dec_wrap(v) atomic_long_dec(v)
> > +#define atomic_long_xchg_wrap(v, i) atomic_long_xchg((v), (i))
> > +#endif /* CONFIG_HARDENED_ATOMIC */

It seems that there are missing function definitions here if atomic_long
should have all the counterparts to atomic:
    atomic_long_add_unless_wrap()
    atomic_long_cmpxchg_wrap()

Thanks,
-Takahiro AKASHI

> > +
> >  #endif  /*  _ASM_GENERIC_ATOMIC_LONG_H  */
> > diff --git a/include/asm-generic/atomic.h b/include/asm-generic/atomic.h
> > index 9ed8b98..159e749 100644
> > --- a/include/asm-generic/atomic.h
> > +++ b/include/asm-generic/atomic.h
> > @@ -232,4 +232,13 @@ static inline int __atomic_add_unless(atomic_t *v, int a, int u)
> >         return c;
> >  }
> >
> > +static inline int __atomic_add_unless_wrap(atomic_t *v, int a, int u)
> > +{
> > +       int c, old;
> > +       c = atomic_read_wrap(v);
> > +       while (c != u && (old = atomic_cmpxchg_wrap(v, c, c + a)) != c)
> > +               c = old;
> > +       return c;
> > +}
> > +
> >  #endif /* __ASM_GENERIC_ATOMIC_H */
> > diff --git a/include/asm-generic/atomic64.h b/include/asm-generic/atomic64.h
> > index dad68bf..4987419 100644
> > --- a/include/asm-generic/atomic64.h
> > +++ b/include/asm-generic/atomic64.h
> > @@ -16,6 +16,8 @@ typedef struct {
> >         long long counter;
> >  } atomic64_t;
> >
> > +typedef atomic64_t atomic64_wrap_t;
> > +
> >  #define ATOMIC64_INIT(i)       { (i) }
> >
> >  extern long long atomic64_read(const atomic64_t *v);
> > @@ -62,4 +64,15 @@ extern int    atomic64_add_unless(atomic64_t *v, long long a, long long u);
> >  #define atomic64_dec_and_test(v)       (atomic64_dec_return((v)) == 0)
> >  #define atomic64_inc_not_zero(v)       atomic64_add_unless((v), 1LL, 0LL)
> >
> > +#define atomic64_read_wrap(v) atomic64_read(v)
> > +#define atomic64_set_wrap(v, i) atomic64_set((v), (i))
> > +#define atomic64_add_wrap(a, v) atomic64_add((a), (v))
> > +#define atomic64_add_return_wrap(a, v) atomic64_add_return((a), (v))
> > +#define atomic64_sub_wrap(a, v) atomic64_sub((a), (v))
> > +#define atomic64_inc_wrap(v) atomic64_inc(v)
> > +#define atomic64_inc_return_wrap(v) atomic64_inc_return(v)
> > +#define atomic64_dec_wrap(v) atomic64_dec(v)
> > +#define atomic64_cmpxchg_wrap(v, o, n) atomic64_cmpxchg((v), (o), (n))
> > +#define atomic64_xchg_wrap(v, n) atomic64_xchg((v), (n))
> > +
> >  #endif  /*  _ASM_GENERIC_ATOMIC64_H  */
> > diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
> > index 6f96247..9428d60 100644
> > --- a/include/asm-generic/bug.h
> > +++ b/include/asm-generic/bug.h
> > @@ -215,6 +215,10 @@ void __warn(const char *file, int line, void *caller, unsigned taint,
> >  # define WARN_ON_SMP(x)                        ({0;})
> >  #endif
> >
> > +#ifdef CONFIG_HARDENED_ATOMIC
> > +void hardened_atomic_refcount_overflow(struct pt_regs *regs);
> > +#endif
> 
> This should probably drop the "refcount" part of its name: refcounting
> is higher level, and this is just simply reporting the overflow
> condition. And that would make the name shorter. Additionally, I think
> an #else case should be added for a no-op static inline to make
> calling this in the per-arch traps avoid using an #ifdef.
> 
> > +
> >  #endif /* __ASSEMBLY__ */
> >
> >  #endif
> > diff --git a/include/asm-generic/local.h b/include/asm-generic/local.h
> > index 9ceb03b..a98ad1d 100644
> > --- a/include/asm-generic/local.h
> > +++ b/include/asm-generic/local.h
> > @@ -23,24 +23,39 @@ typedef struct
> >         atomic_long_t a;
> >  } local_t;
> >
> > +typedef struct {
> > +       atomic_long_wrap_t a;
> > +} local_wrap_t;
> > +
> >  #define LOCAL_INIT(i)  { ATOMIC_LONG_INIT(i) }
> >
> >  #define local_read(l)  atomic_long_read(&(l)->a)
> > +#define local_read_wrap(l)     atomic_long_read_wrap(&(l)->a)
> >  #define local_set(l,i) atomic_long_set((&(l)->a),(i))
> > +#define local_set_wrap(l,i)    atomic_long_set_wrap((&(l)->a),(i))
> >  #define local_inc(l)   atomic_long_inc(&(l)->a)
> > +#define local_inc_wrap(l)      atomic_long_inc_wrap(&(l)->a)
> >  #define local_dec(l)   atomic_long_dec(&(l)->a)
> > +#define local_dec_wrap(l)      atomic_long_dec_wrap(&(l)->a)
> >  #define local_add(i,l) atomic_long_add((i),(&(l)->a))
> > +#define local_add_wrap(i,l)    atomic_long_add_wrap((i),(&(l)->a))
> >  #define local_sub(i,l) atomic_long_sub((i),(&(l)->a))
> > +#define local_sub_wrap(i,l)    atomic_long_sub_wrap((i),(&(l)->a))
> >
> >  #define local_sub_and_test(i, l) atomic_long_sub_and_test((i), (&(l)->a))
> > +#define local_sub_and_test_wrap(i, l) atomic_long_sub_and_test_wrap((i), (&(l)->a))
> >  #define local_dec_and_test(l) atomic_long_dec_and_test(&(l)->a)
> >  #define local_inc_and_test(l) atomic_long_inc_and_test(&(l)->a)
> >  #define local_add_negative(i, l) atomic_long_add_negative((i), (&(l)->a))
> >  #define local_add_return(i, l) atomic_long_add_return((i), (&(l)->a))
> > +#define local_add_return_wrap(i, l) atomic_long_add_return_wrap((i), (&(l)->a))
> >  #define local_sub_return(i, l) atomic_long_sub_return((i), (&(l)->a))
> >  #define local_inc_return(l) atomic_long_inc_return(&(l)->a)
> > +/* verify that below function is needed */
> > +#define local_dec_return(l) atomic_long_dec_return(&(l)->a)
> >
> >  #define local_cmpxchg(l, o, n) atomic_long_cmpxchg((&(l)->a), (o), (n))
> > +#define local_cmpxchg_wrap(l, o, n) atomic_long_cmpxchg_wrap((&(l)->a), (o), (n))
> >  #define local_xchg(l, n) atomic_long_xchg((&(l)->a), (n))
> >  #define local_add_unless(l, _a, u) atomic_long_add_unless((&(l)->a), (_a), (u))
> >  #define local_inc_not_zero(l) atomic_long_inc_not_zero(&(l)->a)
> > diff --git a/include/linux/atomic.h b/include/linux/atomic.h
> > index e71835b..b5817c8 100644
> > --- a/include/linux/atomic.h
> > +++ b/include/linux/atomic.h
> > @@ -507,6 +507,20 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
> >  }
> >
> >  /**
> > + * atomic_add_unless_wrap - add unless the number is already a given value
> > + * @v: pointer of type atomic_wrap_t
> > + * @a: the amount to add to v...
> > + * @u: ...unless v is equal to u.
> > + *
> > + * Atomically adds @a to @v, so long as @v was not already @u.
> > + * Returns non-zero if @v was not @u, and zero otherwise.
> > + */
> > +static inline int atomic_add_unless_wrap(atomic_wrap_t *v, int a, int u)
> > +{
> > +       return __atomic_add_unless_wrap(v, a, u) != u;
> > +}
> > +
> > +/**
> >   * atomic_inc_not_zero - increment unless the number is zero
> >   * @v: pointer of type atomic_t
> >   *
> > diff --git a/include/linux/types.h b/include/linux/types.h
> > index baf7183..b47a7f8 100644
> > --- a/include/linux/types.h
> > +++ b/include/linux/types.h
> > @@ -175,10 +175,27 @@ typedef struct {
> >         int counter;
> >  } atomic_t;
> >
> > +#ifdef CONFIG_HARDENED_ATOMIC
> > +typedef struct {
> > +       int counter;
> > +} atomic_wrap_t;
> > +#else
> > +typedef atomic_t atomic_wrap_t;
> > +#endif
> > +
> >  #ifdef CONFIG_64BIT
> >  typedef struct {
> >         long counter;
> >  } atomic64_t;
> > +
> > +#ifdef CONFIG_HARDENED_ATOMIC
> > +typedef struct {
> > +       long counter;
> > +} atomic64_wrap_t;
> > +#else
> > +typedef atomic64_t atomic64_wrap_t;
> > +#endif
> > +
> >  #endif
> >
> >  struct list_head {
> > diff --git a/kernel/panic.c b/kernel/panic.c
> > index e6480e2..66b0154 100644
> > --- a/kernel/panic.c
> > +++ b/kernel/panic.c
> > @@ -616,3 +616,15 @@ static int __init oops_setup(char *s)
> >         return 0;
> >  }
> >  early_param("oops", oops_setup);
> > +
> > +#ifdef CONFIG_HARDENED_ATOMIC
> > +void hardened_atomic_refcount_overflow(struct pt_regs *regs)
> > +{
> > +       printk(KERN_EMERG "HARDENED_ATOMIC: refcount overflow detected in: %s:%d, uid/euid: %u/%u\n",
> 
> This can be pr_emerg(). I'd drop the "refcount" mention here and below.
> 
> > +               current->comm, task_pid_nr(current),
> > +               from_kuid_munged(&init_user_ns, current_uid()),
> > +               from_kuid_munged(&init_user_ns, current_euid()));
> > +       print_symbol(KERN_EMERG "HARDENED_ATOMIC: refcount overflow occurred at: %s\n", instruction_pointer(regs));
> > +       BUG();
> 
> Does print_symbol() produce more information than BUG() here?
> 
> > +}
> > +#endif
> > diff --git a/security/Kconfig b/security/Kconfig
> > index 118f454..dc39f7e 100644
> > --- a/security/Kconfig
> > +++ b/security/Kconfig
> > @@ -158,6 +158,21 @@ config HARDENED_USERCOPY_PAGESPAN
> >           been removed. This config is intended to be used only while
> >           trying to find such users.
> >
> > +config HAVE_ARCH_HARDENED_ATOMIC
> > +       bool
> > +       help
> > +         The architecture supports CONFIG_HARDENED_ATOMIC by
> > +         providing additional checks on counter overflows for atomic_t
> > +
> > +config HARDENED_ATOMIC
> > +       bool "Prevent reference counter overflow in atomic_t"
> > +       depends on HAVE_ARCH_HARDENED_ATOMIC
> 
> Oh, this should select BUG too.
> 
> > +       help
> > +         This option prevents reference counters in atomic_t from
> > +         overflow. This allows to avoid the
> > +         situation when counter overflow leads to an exploitable
> > +         use-after-free situation.
> 
> I think the Kconfig help text could be clarified up a bit (and needs
> some minor formatting adjustments). Perhaps something like:
> 
> config HAVE_ARCH_HARDENED_ATOMIC
> ...
>   The architecture supports CONFIG_HARDENED_ATOMIC by
>   providing trapping on atomic_t wraps, with a call to
>   hardened_atomic_overflow().
> 
> config HARDENED_ATOMIC
> ...
>   This option catches counter wrapping in atomic_t, which
>   can turn refcounting over/underflow bugs into resource
>   consumption bugs instead of exploitable user-after-free flaws.
> 
> > +
> >  source security/selinux/Kconfig
> >  source security/smack/Kconfig
> >  source security/tomoyo/Kconfig
> > --
> > 2.7.4
> >
> 
> -Kees
> 
> -- 
> Kees Cook
> Nexus Security
