MIME-Version: 1.0
In-Reply-To: <20180326221554.GA45166@beast>
References: <20180326221554.GA45166@beast>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 27 Mar 2018 12:03:13 +0200
Message-ID: <CANiq72k0HggPm2jx1UNcL8Y+B6F8ecVc2mvi8scmTdUZy0ZK0g@mail.gmail.com>
Subject: Re: [PATCH v6] kernel.h: Retain constant expression output for max()/min()
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Martin Uecker <Martin.Uecker@med.uni-goettingen.de>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Randy Dunlap <rdunlap@infradead.org>, Ingo Molnar <mingo@kernel.org>, David Laight <David.Laight@aculab.com>, Ian Abbott <abbotti@mev.co.uk>, linux-kernel <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 27, 2018 at 12:15 AM, Kees Cook <keescook@chromium.org> wrote:
> In the effort to remove all VLAs from the kernel[1], it is desirable to
> build with -Wvla. However, this warning is overly pessimistic, in that
> it is only happy with stack array sizes that are declared as constant
> expressions, and not constant values. One case of this is the evaluation
> of the max() macro which, due to its construction, ends up converting
> constant expression arguments into a constant value result.
>
> All attempts to rewrite this macro with __builtin_constant_p() failed wit=
h
> older compilers (e.g. gcc 4.4)[2]. However, Martin Uecker constructed[3] =
a
> mind-shattering solution that works everywhere. Cthulhu fhtagn!
>
> This patch updates the min()/max() macros to evaluate to a constant
> expression when called on constant expression arguments. This removes
> several false-positive stack VLA warnings from an x86 allmodconfig
> build when -Wvla is added:
>
> $ diff -u before.txt after.txt | grep ^-
> -drivers/input/touchscreen/cyttsp4_core.c:871:2: warning: ISO C90 forbids=
 variable length array =E2=80=98ids=E2=80=99 [-Wvla]
> -fs/btrfs/tree-checker.c:344:4: warning: ISO C90 forbids variable length =
array =E2=80=98namebuf=E2=80=99 [-Wvla]
> -lib/vsprintf.c:747:2: warning: ISO C90 forbids variable length array =E2=
=80=98sym=E2=80=99 [-Wvla]
> -net/ipv4/proc.c:403:2: warning: ISO C90 forbids variable length array =
=E2=80=98buff=E2=80=99 [-Wvla]
> -net/ipv6/proc.c:198:2: warning: ISO C90 forbids variable length array =
=E2=80=98buff=E2=80=99 [-Wvla]
> -net/ipv6/proc.c:218:2: warning: ISO C90 forbids variable length array =
=E2=80=98buff64=E2=80=99 [-Wvla]
>
> This also updates the one case where different enums were being compared
> and explicitly casts them to int (which matches the old side-effect of
> the single-evaluation code).
>
> [1] https://lkml.org/lkml/2018/3/7/621
> [2] https://lkml.org/lkml/2018/3/10/170
> [3] https://lkml.org/lkml/2018/3/20/845
>
> Co-Developed-by: Linus Torvalds <torvalds@linux-foundation.org>
> Co-Developed-by: Martin Uecker <Martin.Uecker@med.uni-goettingen.de>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> Let's see if this one sticks!
> ---
>  drivers/char/tpm/tpm_tis_core.h |  8 ++---
>  include/linux/kernel.h          | 71 ++++++++++++++++++++++++-----------=
------
>  2 files changed, 45 insertions(+), 34 deletions(-)
>
> diff --git a/drivers/char/tpm/tpm_tis_core.h b/drivers/char/tpm/tpm_tis_c=
ore.h
> index d5c6a2e952b3..f6e1dbe212a7 100644
> --- a/drivers/char/tpm/tpm_tis_core.h
> +++ b/drivers/char/tpm/tpm_tis_core.h
> @@ -62,10 +62,10 @@ enum tis_defaults {
>  /* Some timeout values are needed before it is known whether the chip is
>   * TPM 1.0 or TPM 2.0.
>   */
> -#define TIS_TIMEOUT_A_MAX      max(TIS_SHORT_TIMEOUT, TPM2_TIMEOUT_A)
> -#define TIS_TIMEOUT_B_MAX      max(TIS_LONG_TIMEOUT, TPM2_TIMEOUT_B)
> -#define TIS_TIMEOUT_C_MAX      max(TIS_SHORT_TIMEOUT, TPM2_TIMEOUT_C)
> -#define TIS_TIMEOUT_D_MAX      max(TIS_SHORT_TIMEOUT, TPM2_TIMEOUT_D)
> +#define TIS_TIMEOUT_A_MAX      max_t(int, TIS_SHORT_TIMEOUT, TPM2_TIMEOU=
T_A)
> +#define TIS_TIMEOUT_B_MAX      max_t(int, TIS_LONG_TIMEOUT, TPM2_TIMEOUT=
_B)
> +#define TIS_TIMEOUT_C_MAX      max_t(int, TIS_SHORT_TIMEOUT, TPM2_TIMEOU=
T_C)
> +#define TIS_TIMEOUT_D_MAX      max_t(int, TIS_SHORT_TIMEOUT, TPM2_TIMEOU=
T_D)
>
>  #define        TPM_ACCESS(l)                   (0x0000 | ((l) << 12))
>  #define        TPM_INT_ENABLE(l)               (0x0008 | ((l) << 12))
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 3fd291503576..a2c1b2a382dd 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -783,41 +783,58 @@ static inline void ftrace_dump(enum ftrace_dump_mod=
e oops_dump_mode) { }
>  #endif /* CONFIG_TRACING */
>
>  /*
> - * min()/max()/clamp() macros that also do
> - * strict type-checking.. See the
> - * "unnecessary" pointer comparison.
> + * min()/max()/clamp() macros must accomplish three things:
> + *
> + * - avoid multiple evaluations of the arguments (so side-effects like
> + *   "x++" happen only once) when non-constant.
> + * - perform strict type-checking (to generate warnings instead of
> + *   nasty runtime surprises). See the "unnecessary" pointer comparison
> + *   in __typecheck().
> + * - retain result as a constant expressions when called with only
> + *   constant expressions (to avoid tripping VLA warnings in stack
> + *   allocation usage).
> + */
> +#define __typecheck(x, y) \
> +               (!!(sizeof((typeof(x)*)1 =3D=3D (typeof(y)*)1)))
> +
> +/*
> + * This returns a constant expression while determining if an argument i=
s
> + * a constant expression, most importantly without evaluating the argume=
nt.
> + * Glory to Martin Uecker <Martin.Uecker@med.uni-goettingen.de>
>   */
> -#define __min(t1, t2, min1, min2, x, y) ({             \
> -       t1 min1 =3D (x);                                  \
> -       t2 min2 =3D (y);                                  \
> -       (void) (&min1 =3D=3D &min2);                        \
> -       min1 < min2 ? min1 : min2; })
> +#define __is_constant(x) \
> +       (sizeof(int) =3D=3D sizeof(*(1 ? ((void*)((long)(x) * 0l)) : (int=
*)1)))

I think Linus suggested __is_constant, but what about __is_constexpr
instead? It makes the intention a bit more clear and follows the C++'s
specifier.

Acked-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>

Cheers,
Miguel

> +
> +#define __no_side_effects(x, y) \
> +               (__is_constant(x) && __is_constant(y))
> +
> +#define __safe_cmp(x, y) \
> +               (__typecheck(x, y) && __no_side_effects(x, y))
> +
> +#define __cmp(x, y, op)        ((x) op (y) ? (x) : (y))
> +
> +#define __cmp_once(x, y, op) ({                \
> +               typeof(x) __x =3D (x);    \
> +               typeof(y) __y =3D (y);    \
> +               __cmp(__x, __y, op); })
> +
> +#define __careful_cmp(x, y, op)                                \
> +               __builtin_choose_expr(__safe_cmp(x, y), \
> +                                     __cmp(x, y, op), __cmp_once(x, y, o=
p))
>
>  /**
>   * min - return minimum of two values of the same or compatible types
>   * @x: first value
>   * @y: second value
>   */
> -#define min(x, y)                                      \
> -       __min(typeof(x), typeof(y),                     \
> -             __UNIQUE_ID(min1_), __UNIQUE_ID(min2_),   \
> -             x, y)
> -
> -#define __max(t1, t2, max1, max2, x, y) ({             \
> -       t1 max1 =3D (x);                                  \
> -       t2 max2 =3D (y);                                  \
> -       (void) (&max1 =3D=3D &max2);                        \
> -       max1 > max2 ? max1 : max2; })
> +#define min(x, y)      __careful_cmp(x, y, <)
>
>  /**
>   * max - return maximum of two values of the same or compatible types
>   * @x: first value
>   * @y: second value
>   */
> -#define max(x, y)                                      \
> -       __max(typeof(x), typeof(y),                     \
> -             __UNIQUE_ID(max1_), __UNIQUE_ID(max2_),   \
> -             x, y)
> +#define max(x, y)      __careful_cmp(x, y, >)
>
>  /**
>   * min3 - return minimum of three values
> @@ -869,10 +886,7 @@ static inline void ftrace_dump(enum ftrace_dump_mode=
 oops_dump_mode) { }
>   * @x: first value
>   * @y: second value
>   */
> -#define min_t(type, x, y)                              \
> -       __min(type, type,                               \
> -             __UNIQUE_ID(min1_), __UNIQUE_ID(min2_),   \
> -             x, y)
> +#define min_t(t, x, y) __careful_cmp((t)(x), (t)(y), <)
>
>  /**
>   * max_t - return maximum of two values, using the specified type
> @@ -880,10 +894,7 @@ static inline void ftrace_dump(enum ftrace_dump_mode=
 oops_dump_mode) { }
>   * @x: first value
>   * @y: second value
>   */
> -#define max_t(type, x, y)                              \
> -       __max(type, type,                               \
> -             __UNIQUE_ID(min1_), __UNIQUE_ID(min2_),   \
> -             x, y)
> +#define max_t(t, x, y) __careful_cmp((t)(x), (t)(y), >)
>
>  /**
>   * clamp_t - return a value clamped to a given range using a given type
> --
> 2.7.4
>
>
> --
> Kees Cook
> Pixel Security
