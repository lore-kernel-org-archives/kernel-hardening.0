MIME-Version: 1.0
In-Reply-To: <20170725114901.31403-1-ard.biesheuvel@linaro.org>
References: <20170725114901.31403-1-ard.biesheuvel@linaro.org>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Tue, 25 Jul 2017 15:37:11 +0100
Message-ID: <CAKv+Gu86xZWua0d0UsPpz8xhbNx14EqTVeFGUweN9o69AWUXiA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [RFC PATCH untested] arm64: kernel: implement fast refcount checking
To: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: Will Deacon <will.deacon@arm.com>, Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Laura Abbott <labbott@fedoraproject.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 25 July 2017 at 12:49, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> Hi all,
>
> I had a stab at porting the fast refcount checks to arm64. It is slightly
> less straight-forward than x86 given that we need to support both LSE and
> LL/SC, and fallback to the latter if running a kernel built with support
> for the former on hardware that does not support it.
>
> It is build tested with and without LSE support, and boots fine on non-LSE
> hardware in both cases.
>
> Suggestions welcome as to how to test and/or benchmark this,
>

I discovered this awesome tool called lkdtm, and noticed that the
patch does not quite work in its current form: the condition check is
incorrect, and it uses adrp instruction, which is not allowed in
modules in a standard build.

Updated patch here:
https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=arm64-fast-refcount


> ---------8<----------------
> This adds support to arm64 for fast refcount checking, as proposed by
> Kees for x86.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm64/Kconfig                    |  1 +
>  arch/arm64/include/asm/atomic.h       | 15 ++++
>  arch/arm64/include/asm/atomic_ll_sc.h | 27 ++++++
>  arch/arm64/include/asm/atomic_lse.h   | 51 ++++++++++++
>  arch/arm64/include/asm/brk-imm.h      |  1 +
>  arch/arm64/include/asm/refcount.h     | 88 ++++++++++++++++++++
>  arch/arm64/kernel/traps.c             | 35 ++++++++
>  arch/arm64/lib/atomic_ll_sc.c         |  6 ++
>  8 files changed, 224 insertions(+)
>
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index dfd908630631..53b9a8f5277b 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -16,6 +16,7 @@ config ARM64
>         select ARCH_HAS_GCOV_PROFILE_ALL
>         select ARCH_HAS_GIGANTIC_PAGE if (MEMORY_ISOLATION && COMPACTION) || CMA
>         select ARCH_HAS_KCOV
> +       select ARCH_HAS_REFCOUNT
>         select ARCH_HAS_SET_MEMORY
>         select ARCH_HAS_SG_CHAIN
>         select ARCH_HAS_STRICT_KERNEL_RWX
> diff --git a/arch/arm64/include/asm/atomic.h b/arch/arm64/include/asm/atomic.h
> index c0235e0ff849..66dc66399630 100644
> --- a/arch/arm64/include/asm/atomic.h
> +++ b/arch/arm64/include/asm/atomic.h
> @@ -24,10 +24,25 @@
>  #include <linux/types.h>
>
>  #include <asm/barrier.h>
> +#include <asm/brk-imm.h>
>  #include <asm/lse.h>
>
>  #ifdef __KERNEL__
>
> +#define REFCOUNT_CHECK(cond)                                           \
> +"22:   b." #cond "     33f\n"                                          \
> +"      .pushsection    \".text.unlikely\"\n"                           \
> +"33:   mov             x16, %[counter]\n"                              \
> +"      adrp            x17, 22b\n"                                     \
> +"      add             x17, x17, :lo12:22b\n"                          \
> +"      brk             %[brk_imm]\n"                                   \
> +"      .popsection\n"
> +
> +#define REFCOUNT_INPUTS(r)                                             \
> +       [counter] "r" (&(r)->counter), [brk_imm] "i" (REFCOUNT_BRK_IMM),
> +
> +#define REFCOUNT_CLOBBERS      : "cc", "x16", "x17"
> +
>  #define __ARM64_IN_ATOMIC_IMPL
>
>  #if defined(CONFIG_ARM64_LSE_ATOMICS) && defined(CONFIG_AS_LSE)
> diff --git a/arch/arm64/include/asm/atomic_ll_sc.h b/arch/arm64/include/asm/atomic_ll_sc.h
> index f5a2d09afb38..7b1cb901986c 100644
> --- a/arch/arm64/include/asm/atomic_ll_sc.h
> +++ b/arch/arm64/include/asm/atomic_ll_sc.h
> @@ -327,4 +327,31 @@ __CMPXCHG_DBL(_mb, dmb ish, l, "memory")
>
>  #undef __CMPXCHG_DBL
>
> +#define REFCOUNT_OP(op, asm_op, cond, clobber...)                      \
> +__LL_SC_INLINE int                                                     \
> +__LL_SC_PREFIX(__refcount_##op(int i, atomic_t *r))                    \
> +{                                                                      \
> +       unsigned long tmp;                                              \
> +       int result;                                                     \
> +                                                                       \
> +       asm volatile("// refcount_" #op "\n"                            \
> +"      prfm            pstl1strm, %2\n"                                \
> +"1:    ldxr            %w0, %2\n"                                      \
> +"      " #asm_op "     %w0, %w0, %w[i]\n"                              \
> +"      stxr            %w1, %w0, %2\n"                                 \
> +"      cbnz            %w1, 1b\n"                                      \
> +       REFCOUNT_CHECK(cond)                                            \
> +       : "=&r" (result), "=&r" (tmp), "+Q" (r->counter)                \
> +       : REFCOUNT_INPUTS(r) [i] "Ir" (i)                               \
> +       clobber);                                                       \
> +                                                                       \
> +       return result;                                                  \
> +}                                                                      \
> +__LL_SC_EXPORT(__refcount_##op);
> +
> +REFCOUNT_OP(add_lt, adds, lt, REFCOUNT_CLOBBERS);
> +REFCOUNT_OP(add_le, adds, le, REFCOUNT_CLOBBERS);
> +REFCOUNT_OP(sub_lt, subs, lt, REFCOUNT_CLOBBERS);
> +REFCOUNT_OP(sub_le, subs, le, REFCOUNT_CLOBBERS);
> +
>  #endif /* __ASM_ATOMIC_LL_SC_H */
> diff --git a/arch/arm64/include/asm/atomic_lse.h b/arch/arm64/include/asm/atomic_lse.h
> index 99fa69c9c3cf..f64bb51f1860 100644
> --- a/arch/arm64/include/asm/atomic_lse.h
> +++ b/arch/arm64/include/asm/atomic_lse.h
> @@ -531,4 +531,55 @@ __CMPXCHG_DBL(_mb, al, "memory")
>  #undef __LL_SC_CMPXCHG_DBL
>  #undef __CMPXCHG_DBL
>
> +#define REFCOUNT_ADD_OP(op, cond)                                      \
> +static inline int __refcount_##op(int i, atomic_t *r)                  \
> +{                                                                      \
> +       register int w0 asm ("w0") = i;                                 \
> +       register atomic_t *x1 asm ("x1") = r;                           \
> +                                                                       \
> +       asm volatile(ARM64_LSE_ATOMIC_INSN(                             \
> +       /* LL/SC */                                                     \
> +       __LL_SC_CALL(__refcount_##op)                                   \
> +       __nops(1),                                                      \
> +       /* LSE atomics */                                               \
> +       "       ldadd   %w[i], w30, %[v]\n"                             \
> +       "       adds    %w[i], %w[i], w30")                             \
> +       REFCOUNT_CHECK(cond)                                            \
> +       : [i] "+r" (w0), [v] "+Q" (r->counter)                          \
> +       : REFCOUNT_INPUTS(r) "r" (x1)                                   \
> +       : __LL_SC_CLOBBERS, "cc");                                      \
> +                                                                       \
> +       return w0;                                                      \
> +}
> +
> +#define REFCOUNT_SUB_OP(op, cond, fbop)                                        \
> +static inline int __refcount_##op(int i, atomic_t *r)                  \
> +{                                                                      \
> +       register int w0 asm ("w0") = i;                                 \
> +       register atomic_t *x1 asm ("x1") = r;                           \
> +                                                                       \
> +       if (__builtin_constant_p(i))                                    \
> +               return __refcount_##fbop(-i, r);                        \
> +                                                                       \
> +       asm volatile(ARM64_LSE_ATOMIC_INSN(                             \
> +       /* LL/SC */                                                     \
> +       __LL_SC_CALL(__refcount_##op)                                   \
> +       __nops(2),                                                      \
> +       /* LSE atomics */                                               \
> +       "       neg     %w[i], %w[i]\n"                                 \
> +       "       ldadd   %w[i], w30, %[v]\n"                             \
> +       "       adds    %w[i], %w[i], w30")                             \
> +       REFCOUNT_CHECK(cond)                                            \
> +       : [i] "+r" (w0), [v] "+Q" (r->counter)                          \
> +       : REFCOUNT_INPUTS(r) "r" (x1)                                   \
> +       : __LL_SC_CLOBBERS, "cc");                                      \
> +                                                                       \
> +       return w0;                                                      \
> +}
> +
> +REFCOUNT_ADD_OP(add_lt, lt);
> +REFCOUNT_ADD_OP(add_le, le);
> +REFCOUNT_SUB_OP(sub_lt, lt, add_lt);
> +REFCOUNT_SUB_OP(sub_le, le, add_le);
> +
>  #endif /* __ASM_ATOMIC_LSE_H */
> diff --git a/arch/arm64/include/asm/brk-imm.h b/arch/arm64/include/asm/brk-imm.h
> index ed693c5bcec0..0bce57737ff1 100644
> --- a/arch/arm64/include/asm/brk-imm.h
> +++ b/arch/arm64/include/asm/brk-imm.h
> @@ -18,6 +18,7 @@
>   * 0x800: kernel-mode BUG() and WARN() traps
>   */
>  #define FAULT_BRK_IMM                  0x100
> +#define REFCOUNT_BRK_IMM               0x101
>  #define KGDB_DYN_DBG_BRK_IMM           0x400
>  #define KGDB_COMPILED_DBG_BRK_IMM      0x401
>  #define BUG_BRK_IMM                    0x800
> diff --git a/arch/arm64/include/asm/refcount.h b/arch/arm64/include/asm/refcount.h
> new file mode 100644
> index 000000000000..3d69537ff2e7
> --- /dev/null
> +++ b/arch/arm64/include/asm/refcount.h
> @@ -0,0 +1,88 @@
> +/*
> + * arm64-specific implementation of refcount_t. Based on x86 version and
> + * PAX_REFCOUNT from PaX/grsecurity.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef __ASM_REFCOUNT_H
> +#define __ASM_REFCOUNT_H
> +
> +#include <linux/refcount.h>
> +
> +#include <asm/atomic.h>
> +#include <asm/uaccess.h>
> +
> +static __always_inline void refcount_add(int i, refcount_t *r)
> +{
> +       __refcount_add_lt(i, &r->refs);
> +}
> +
> +static __always_inline void refcount_inc(refcount_t *r)
> +{
> +       __refcount_add_lt(1, &r->refs);
> +}
> +
> +static __always_inline void refcount_dec(refcount_t *r)
> +{
> +       __refcount_sub_le(1, &r->refs);
> +}
> +
> +static __always_inline __must_check bool refcount_sub_and_test(unsigned int i,
> +                                                              refcount_t *r)
> +{
> +       return __refcount_sub_lt(i, &r->refs) == 0;
> +}
> +
> +static __always_inline __must_check bool refcount_dec_and_test(refcount_t *r)
> +{
> +       return __refcount_sub_lt(1, &r->refs) == 0;
> +}
> +
> +/**
> + * __refcount_add_unless - add unless the number is already a given value
> + * @r: pointer of type refcount_t
> + * @a: the amount to add to v...
> + * @u: ...unless v is equal to u.
> + *
> + * Atomically adds @a to @r, so long as @r was not already @u.
> + * Returns the old value of @r.
> + */
> +static __always_inline __must_check
> +int __refcount_add_unless(refcount_t *r, int a, int u)
> +{
> +       int c, new;
> +
> +       c = atomic_read(&(r->refs));
> +       do {
> +               if (unlikely(c == u))
> +                       break;
> +
> +               asm volatile(
> +                       "adds   %0, %0, %2      ;"
> +                       REFCOUNT_CHECK(lt)
> +                       : "=r" (new)
> +                       : "0" (c), "Ir" (a),
> +                         [counter] "r" (&r->refs.counter),
> +                         [brk_imm] "i" (REFCOUNT_BRK_IMM)
> +                       : "cc", "x16", "x17");
> +
> +       } while (!atomic_try_cmpxchg(&(r->refs), &c, new));
> +
> +       return c;
> +}
> +
> +static __always_inline __must_check
> +bool refcount_add_not_zero(unsigned int i, refcount_t *r)
> +{
> +       return __refcount_add_unless(r, i, 0) != 0;
> +}
> +
> +static __always_inline __must_check bool refcount_inc_not_zero(refcount_t *r)
> +{
> +       return refcount_add_not_zero(1, r);
> +}
> +
> +#endif
> diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
> index c7c7088097be..6b5a3658d050 100644
> --- a/arch/arm64/kernel/traps.c
> +++ b/arch/arm64/kernel/traps.c
> @@ -758,8 +758,43 @@ int __init early_brk64(unsigned long addr, unsigned int esr,
>         return bug_handler(regs, esr) != DBG_HOOK_HANDLED;
>  }
>
> +static int refcount_overflow_handler(struct pt_regs *regs, unsigned int esr)
> +{
> +       /* First unconditionally saturate the refcount. */
> +       *(int *)regs->regs[16] = INT_MIN / 2;
> +
> +       /*
> +        * This function has been called because either a negative refcount
> +        * value was seen by any of the refcount functions, or a zero
> +        * refcount value was seen by refcount_dec().
> +        *
> +        * If we crossed from INT_MAX to INT_MIN, V (oVerflow: signed overflow)
> +        * will be set. Additionally, seeing the refcount reach 0 will set Z
> +        * (Zero: result was zero). In each of these cases we want a report,
> +        * since it's a boundary condition.
> +        */
> +       if (regs->pstate & (PSR_Z_BIT | PSR_V_BIT)) {
> +               bool zero = regs->pstate & PSR_Z_BIT;
> +
> +               /* point pc to the branch instruction that brought us here */
> +               regs->pc = regs->regs[17];
> +               refcount_error_report(regs, zero ? "hit zero" : "overflow");
> +       }
> +
> +       /* advance pc and proceed */
> +       regs->pc += 4;
> +       return DBG_HOOK_HANDLED;
> +}
> +
> +static struct break_hook refcount_break_hook = {
> +       .esr_val        = 0xf2000000 | REFCOUNT_BRK_IMM,
> +       .esr_mask       = 0xffffffff,
> +       .fn             = refcount_overflow_handler,
> +};
> +
>  /* This registration must happen early, before debug_traps_init(). */
>  void __init trap_init(void)
>  {
>         register_break_hook(&bug_break_hook);
> +       register_break_hook(&refcount_break_hook);
>  }
> diff --git a/arch/arm64/lib/atomic_ll_sc.c b/arch/arm64/lib/atomic_ll_sc.c
> index b0c538b0da28..5f038abdc635 100644
> --- a/arch/arm64/lib/atomic_ll_sc.c
> +++ b/arch/arm64/lib/atomic_ll_sc.c
> @@ -1,3 +1,9 @@
>  #include <asm/atomic.h>
>  #define __ARM64_IN_ATOMIC_IMPL
> +#undef REFCOUNT_CHECK
> +#undef REFCOUNT_INPUTS
> +#undef REFCOUNT_CLOBBERS
> +#define REFCOUNT_CHECK(cond)
> +#define REFCOUNT_INPUTS(r)
> +#define REFCOUNT_CLOBBERS : "cc"
>  #include <asm/atomic_ll_sc.h>
> --
> 2.9.3
>
