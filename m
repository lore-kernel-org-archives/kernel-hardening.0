MIME-Version: 1.0
In-Reply-To: <20170823145811.GA30753@arm.com>
References: <20170731192251.12491-1-ard.biesheuvel@linaro.org> <20170823145811.GA30753@arm.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 23 Aug 2017 16:51:21 +0100
Message-ID: <CAKv+Gu89_deP8L=hy==6uv-szdGSBO7v9t+vKHT8rKUjARdc-w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v4] arm64: kernel: implement fast refcount checking
To: Will Deacon <will.deacon@arm.com>, Kees Cook <keescook@chromium.org>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Laura Abbott <labbott@fedoraproject.org>, "Likun (Hw)" <hw.likun@huawei.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 23 August 2017 at 15:58, Will Deacon <will.deacon@arm.com> wrote:
> Hi Ard,
>
> Comments of varying quality inline...
>
> On Mon, Jul 31, 2017 at 08:22:51PM +0100, Ard Biesheuvel wrote:
>> This adds support to arm64 for fast refcount checking, as proposed by
>> Kees for x86 based on the implementation by grsecurity/PaX.
>>
>> The general approach is identical: the existing atomic_t helpers are
>> cloned for refcount_t, with the arithmetic instruction modified to set
>> the PSTATE flags, and one or two branch instructions added that jump to
>> an out of line handler if overflow, decrement to zero or increment from
>> zero are detected.
>>
>> One complication that we have to deal with on arm64 is the fact that
>> it has two atomics implementations: the original LL/SC implementation
>> using load/store exclusive loops, and the newer LSE one that does mostly
>> the same in a single instruction. So we need to clone some parts of
>> both for the refcount handlers, but we also need to deal with the way
>> LSE builds fall back to LL/SC at runtime if the hardware does not
>> support it. (The only exception is refcount_add_not_zero(), which
>> updates the refcount conditionally, so it is only implemented using
>> a load/store exclusive loop)
>>
>> As is the case with the x86 version, the performance delta is in the
>> noise (Cortex-A57 @ 2 GHz, using LL/SC not LSE), even though the arm64
>> implementation incorporates an add-from-zero check as well:
>
> How does this compare to versions built using cmpxchg?
>

Good question. I haven't actually checked, because I was focusing on
the delta with the ordinary atomics.

>>
>> perf stat -B -- cat <(echo ATOMIC_TIMING) >/sys/kernel/debug/provoke-crash/DIRECT
>>
>>  Performance counter stats for 'cat /dev/fd/63':
>>
>>       65758.632112      task-clock (msec)         #    1.000 CPUs utilized
>>                  2      context-switches          #    0.000 K/sec
>>                  0      cpu-migrations            #    0.000 K/sec
>>                 47      page-faults               #    0.001 K/sec
>>       131421735632      cycles                    #    1.999 GHz
>>        36752227542      instructions              #    0.28  insn per cycle
>>    <not supported>      branches
>>             961008      branch-misses
>>
>>       65.785264736 seconds time elapsed
>>
>> perf stat -B -- cat <(echo REFCOUNT_TIMING) >/sys/kernel/debug/provoke-crash/DIRECT
>>
>>  Performance counter stats for 'cat /dev/fd/63':
>>
>>       65734.255992      task-clock (msec)         #    1.000 CPUs utilized
>>                  2      context-switches          #    0.000 K/sec
>>                  0      cpu-migrations            #    0.000 K/sec
>>                 46      page-faults               #    0.001 K/sec
>>       131376830467      cycles                    #    1.999 GHz
>>        43183673156      instructions              #    0.33  insn per cycle
>>    <not supported>      branches
>>             879345      branch-misses
>>
>>       65.735309648 seconds time elapsed
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> ---
>> v4: Implement add-from-zero checking using a conditional compare rather than
>>     a conditional branch, which I omitted from v3 due to the 10% performance
>>     hit: this will result in the new refcount to be written back to memory
>>     before invoking the handler, which is more in line with the other checks,
>>     and is apparently much easier on the branch predictor, given that there
>>     is no performance hit whatsoever.
>>
>>  arch/arm64/Kconfig                    |  1 +
>>  arch/arm64/include/asm/atomic.h       | 25 +++++++
>>  arch/arm64/include/asm/atomic_ll_sc.h | 29 ++++++++
>>  arch/arm64/include/asm/atomic_lse.h   | 56 +++++++++++++++
>>  arch/arm64/include/asm/brk-imm.h      |  1 +
>>  arch/arm64/include/asm/refcount.h     | 71 ++++++++++++++++++++
>>  arch/arm64/kernel/traps.c             | 29 ++++++++
>>  arch/arm64/lib/atomic_ll_sc.c         | 16 +++++
>>  8 files changed, 228 insertions(+)
>>
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index dfd908630631..53b9a8f5277b 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -16,6 +16,7 @@ config ARM64
>>       select ARCH_HAS_GCOV_PROFILE_ALL
>>       select ARCH_HAS_GIGANTIC_PAGE if (MEMORY_ISOLATION && COMPACTION) || CMA
>>       select ARCH_HAS_KCOV
>> +     select ARCH_HAS_REFCOUNT
>>       select ARCH_HAS_SET_MEMORY
>>       select ARCH_HAS_SG_CHAIN
>>       select ARCH_HAS_STRICT_KERNEL_RWX
>> diff --git a/arch/arm64/include/asm/atomic.h b/arch/arm64/include/asm/atomic.h
>> index c0235e0ff849..ded9bde5f08f 100644
>> --- a/arch/arm64/include/asm/atomic.h
>> +++ b/arch/arm64/include/asm/atomic.h
>> @@ -24,10 +24,35 @@
>>  #include <linux/types.h>
>>
>>  #include <asm/barrier.h>
>> +#include <asm/brk-imm.h>
>>  #include <asm/lse.h>
>>
>>  #ifdef __KERNEL__
>>
>> +#define REFCOUNT_CHECK_TAIL                                          \
>> +"    .subsection     1\n"                                            \
>> +"33: mov             x16, %[counter]\n"                              \
>> +"    adr             x17, 44f\n"                                     \
>> +"    brk             %[brk_imm]\n"                                   \
>> +"44: .long           22b - .\n"                                      \
>> +"    .previous\n"
>> +
>> +#define REFCOUNT_POST_CHECK_NEG                                              \
>> +"22: b.mi            33f\n"                                          \
>> +     REFCOUNT_CHECK_TAIL
>> +
>> +#define REFCOUNT_POST_CHECK_NEG_OR_ZERO                                      \
>> +"    b.eq            33f\n"                                          \
>> +     REFCOUNT_POST_CHECK_NEG
>> +
>> +#define REFCOUNT_PRE_CHECK_ZERO(reg) "ccmp " #reg ", wzr, #8, pl\n"
>
> How does this work for the add_lt case if we compute negative counter
> value? afaict, we'll set the flags to #8 (HI), which won't get picked up
> by the NEG_OR_ZERO post check.
>

You mean when the addend is negative, making it a de facto subtract?
The refcount API does not use signed addends, so I don't think that's
an issue.

>> +#define REFCOUNT_PRE_CHECK_NONE(reg)
>> +
>> +#define REFCOUNT_INPUTS(r)                                           \
>> +     [counter] "r" (&(r)->counter), [brk_imm] "i" (REFCOUNT_BRK_IMM),
>> +
>> +#define REFCOUNT_CLOBBERS    "cc", "x16", "x17"
>
> It would be better to just have "cc" here, and then let the compiler
> allocate the registers for the normal cases. That would allow us to use
> __LL_SC_CLOBBERS for the LSE versions.
>

Well, that makes it difficult to figure out where to pull the values
from in refcount_overflow_handler(). I chose x16/x17 precisely because
the out of line ll/sc atomics will also use them as scratch registers,
so they are already non-live in many cases.

>> +
>>  #define __ARM64_IN_ATOMIC_IMPL
>>
>>  #if defined(CONFIG_ARM64_LSE_ATOMICS) && defined(CONFIG_AS_LSE)
>> diff --git a/arch/arm64/include/asm/atomic_ll_sc.h b/arch/arm64/include/asm/atomic_ll_sc.h
>> index f5a2d09afb38..7037428b7efb 100644
>> --- a/arch/arm64/include/asm/atomic_ll_sc.h
>> +++ b/arch/arm64/include/asm/atomic_ll_sc.h
>> @@ -327,4 +327,33 @@ __CMPXCHG_DBL(_mb, dmb ish, l, "memory")
>>
>>  #undef __CMPXCHG_DBL
>>
>> +#define REFCOUNT_OP(op, asm_op, pre, post, l)                                \
>> +__LL_SC_INLINE int                                                   \
>> +__LL_SC_PREFIX(__refcount_##op(int i, atomic_t *r))                  \
>> +{                                                                    \
>> +     unsigned long tmp;                                              \
>
> This can be unsigned int.
>

OK

>> +     int result;                                                     \
>> +                                                                     \
>> +     asm volatile("// refcount_" #op "\n"                            \
>> +"    prfm            pstl1strm, %2\n"                                \
>> +"1:  ldxr            %w1, %2\n"                                      \
>> +"    " #asm_op "     %w[val], %w1, %w[i]\n"                          \
>> +     REFCOUNT_PRE_CHECK_ ## pre (%w1)                                \
>> +"    st" #l "xr      %w1, %w[val], %2\n"                             \
>
> Given that you don't avoid the store here, how do you ensure that the
> counter saturates?
>

Not sure I follow. We ensure that the counter saturates by
conditionally branching to the out of line handler, that is the whole
point. If you are asking whether the counter visibly assumes an
unwanted value before the handler overwrites it, then yes, that is
expected. Conditionally branching beforehand is what results in the
10% performance hit in the benchmark.


>> +"    cbnz            %w1, 1b\n"                                      \
>> +     REFCOUNT_POST_CHECK_ ## post                                    \
>> +     : [val] "=&r" (result), "=&r" (tmp), "+Q" (r->counter)          \
>> +     : REFCOUNT_INPUTS(r) [i] "Ir" (i)                               \
>> +     : REFCOUNT_CLOBBERS);                                           \
>> +                                                                     \
>> +     return result;                                                  \
>
> We're back in C here, so I don't think we can safely assume that the
> compiler won't nobble the condition flags as part of the return. If it
> does that, then the post-check in the caller for the case that the LL/SC
> atomics are out-of-line won't necessary work correctly.
>

Yes, so that complicated the out of line case for ll/sc. I was vaguely
aware of that, but hadn't quite figured out whether it was a real
problem.

>> +}                                                                    \
>> +__LL_SC_EXPORT(__refcount_##op);
>> +
>> +REFCOUNT_OP(add_lt,     adds, ZERO, NEG_OR_ZERO,  );
>> +REFCOUNT_OP(sub_lt_neg, adds, NONE, NEG,         l);
>> +REFCOUNT_OP(sub_le_neg, adds, NONE, NEG_OR_ZERO, l);
>
> Where are sub_{lt,le}_neg used?  (gah, I just spotted this!).
>

OK

>> +REFCOUNT_OP(sub_lt,     subs, NONE, NEG,         l);
>> +REFCOUNT_OP(sub_le,     subs, NONE, NEG_OR_ZERO, l);
>> +
>>  #endif       /* __ASM_ATOMIC_LL_SC_H */
>> diff --git a/arch/arm64/include/asm/atomic_lse.h b/arch/arm64/include/asm/atomic_lse.h
>> index 99fa69c9c3cf..c00e02edc589 100644
>> --- a/arch/arm64/include/asm/atomic_lse.h
>> +++ b/arch/arm64/include/asm/atomic_lse.h
>> @@ -531,4 +531,60 @@ __CMPXCHG_DBL(_mb, al, "memory")
>>  #undef __LL_SC_CMPXCHG_DBL
>>  #undef __CMPXCHG_DBL
>>
>> +#define REFCOUNT_ADD_OP(op, rel, pre, nops, post)                    \
>> +static inline int __refcount_##op(int i, atomic_t *r)                        \
>> +{                                                                    \
>> +     register int w0 asm ("w0") = i;                                 \
>> +     register atomic_t *x1 asm ("x1") = r;                           \
>> +     register int w30 asm ("w30");                                   \
>> +                                                                     \
>> +     asm volatile(ARM64_LSE_ATOMIC_INSN(                             \
>> +     /* LL/SC */                                                     \
>> +     __LL_SC_CALL(__refcount_##op)                                   \
>> +     __nops(nops),                                                   \
>> +     /* LSE atomics */                                               \
>> +     "       ldadd" #rel "   %w[i], %w[val], %[v]\n"                 \
>> +     "       adds            %w[i], %w[i], %w[val]\n"                \
>> +     REFCOUNT_PRE_CHECK_ ## pre (%w[val]))                           \
>> +     REFCOUNT_POST_CHECK_ ## post                                    \
>> +     : [i] "+r" (w0), [v] "+Q" (r->counter), [val] "=&r" (w30)       \
>> +     : REFCOUNT_INPUTS(r) "r" (x1)                                   \
>> +     : REFCOUNT_CLOBBERS);                                           \
>> +                                                                     \
>> +     return w0;                                                      \
>> +}
>> +
>> +REFCOUNT_ADD_OP(add_lt,      , ZERO, 2, NEG_OR_ZERO);
>> +REFCOUNT_ADD_OP(sub_lt_neg, l, NONE, 1, NEG        );
>> +REFCOUNT_ADD_OP(sub_le_neg, l, NONE, 1, NEG_OR_ZERO);
>
> Hmm, this is really horrible to read. If we can get rid of the _neg variants
> it would be nice, because the interaction between the choice of PRE handler
> and the number of nops is subtle.
>

Yes.

>> +
>> +#define REFCOUNT_SUB_OP(op, post, fbop)                                      \
>> +static inline int __refcount_##op(int i, atomic_t *r)                        \
>> +{                                                                    \
>> +     register int w0 asm ("w0") = i;                                 \
>> +     register atomic_t *x1 asm ("x1") = r;                           \
>> +     register int w30 asm ("w30");                                   \
>> +                                                                     \
>> +     if (__builtin_constant_p(i))                                    \
>> +             return __refcount_##fbop(-i, r);                        \
>
> Why is this worthwhile?
>

Because I thought we could end up with

mov reg, immediate
neg reg, reg
ldaddl
... etc

which I assumed we would like to avoid. But actually, as per my own
findings just now, I don't think the refcount API could end up
emitting that.

>> +                                                                     \
>> +     asm volatile(ARM64_LSE_ATOMIC_INSN(                             \
>> +     /* LL/SC */                                                     \
>> +     __LL_SC_CALL(__refcount_##op)                                   \
>> +     __nops(2),                                                      \
>> +     /* LSE atomics */                                               \
>> +     "       neg     %w[i], %w[i]\n"                                 \
>> +     "       ldaddl  %w[i], %w[val], %[v]\n"                         \
>> +     "       adds    %w[i], %w[i], %w[val]")                         \
>> +     REFCOUNT_POST_CHECK_ ## post                                    \
>> +     : [i] "+r" (w0), [v] "+Q" (r->counter), [val] "=&r" (w30)       \
>> +     : REFCOUNT_INPUTS(r) "r" (x1)                                   \
>> +     : REFCOUNT_CLOBBERS);                                           \
>> +                                                                     \
>> +     return w0;                                                      \
>> +}
>> +
>> +REFCOUNT_SUB_OP(sub_lt, NEG,         sub_lt_neg);
>> +REFCOUNT_SUB_OP(sub_le, NEG_OR_ZERO, sub_le_neg);
>> +
>>  #endif       /* __ASM_ATOMIC_LSE_H */
>> diff --git a/arch/arm64/include/asm/brk-imm.h b/arch/arm64/include/asm/brk-imm.h
>> index ed693c5bcec0..0bce57737ff1 100644
>> --- a/arch/arm64/include/asm/brk-imm.h
>> +++ b/arch/arm64/include/asm/brk-imm.h
>> @@ -18,6 +18,7 @@
>>   * 0x800: kernel-mode BUG() and WARN() traps
>>   */
>>  #define FAULT_BRK_IMM                        0x100
>> +#define REFCOUNT_BRK_IMM             0x101
>>  #define KGDB_DYN_DBG_BRK_IMM         0x400
>>  #define KGDB_COMPILED_DBG_BRK_IMM    0x401
>>  #define BUG_BRK_IMM                  0x800
>> diff --git a/arch/arm64/include/asm/refcount.h b/arch/arm64/include/asm/refcount.h
>> new file mode 100644
>> index 000000000000..ceb2fe713b80
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/refcount.h
>> @@ -0,0 +1,71 @@
>> +/*
>> + * arm64-specific implementation of refcount_t. Based on x86 version and
>> + * PAX_REFCOUNT from PaX/grsecurity.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#ifndef __ASM_REFCOUNT_H
>> +#define __ASM_REFCOUNT_H
>> +
>> +#include <linux/refcount.h>
>> +
>> +#include <asm/atomic.h>
>> +#include <asm/uaccess.h>
>> +
>> +static __always_inline void refcount_add(int i, refcount_t *r)
>> +{
>> +     __refcount_add_lt(i, &r->refs);
>> +}
>> +
>> +static __always_inline void refcount_inc(refcount_t *r)
>> +{
>> +     __refcount_add_lt(1, &r->refs);
>> +}
>> +
>> +static __always_inline void refcount_dec(refcount_t *r)
>> +{
>> +     __refcount_sub_le(1, &r->refs);
>> +}
>> +
>> +static __always_inline __must_check bool refcount_sub_and_test(unsigned int i,
>> +                                                            refcount_t *r)
>> +{
>> +     return __refcount_sub_lt(i, &r->refs) == 0;
>> +}
>> +
>> +static __always_inline __must_check bool refcount_dec_and_test(refcount_t *r)
>> +{
>> +     return __refcount_sub_lt(1, &r->refs) == 0;
>> +}
>
> Nit, but we can just follow the lib/refcount.c implementation here.
>

Yes, and the same applies to Kees's version for x86, I suppose. We can
do that as a separate fix.

>> +
>> +static __always_inline __must_check bool refcount_add_not_zero(unsigned int i,
>> +                                                            refcount_t *r)
>> +{
>> +     unsigned long tmp;
>> +     int result;
>> +
>> +     asm volatile("// refcount_add_not_zero \n"
>> +"    prfm            pstl1strm, %2\n"
>> +"1:  ldxr            %w[val], %2\n"
>> +"    cbz             %w[val], 2f\n"
>> +"    adds            %w[val], %w[val], %w[i]\n"
>> +"    stxr            %w1, %w[val], %2\n"
>> +"    cbnz            %w1, 1b\n"
>> +     REFCOUNT_POST_CHECK_NEG
>> +"2:"
>> +     : [val] "=&r" (result), "=&r" (tmp), "+Q" (r->refs.counter)
>> +     : REFCOUNT_INPUTS(&r->refs) [i] "Ir" (i)
>> +     : REFCOUNT_CLOBBERS);
>> +
>> +     return result != 0;
>> +}
>
> We could implement this using CAS for LSE (like we do for things like
> deC_if_positive). Alternatively, define a shared version using cmpxchg.
>

A previous version had that, but I can't remember the exact details. I
will look into that.

I couldn't figure out how to use CAS here, btw, because we need the
old value and leave the counter in memory untouched if it is zero.

>> +
>> +static __always_inline __must_check bool refcount_inc_not_zero(refcount_t *r)
>> +{
>> +     return refcount_add_not_zero(1, r);
>> +}
>> +
>> +#endif
>> diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
>> index c7c7088097be..07bd026ec71d 100644
>> --- a/arch/arm64/kernel/traps.c
>> +++ b/arch/arm64/kernel/traps.c
>> @@ -758,8 +758,37 @@ int __init early_brk64(unsigned long addr, unsigned int esr,
>>       return bug_handler(regs, esr) != DBG_HOOK_HANDLED;
>>  }
>>
>> +static int refcount_overflow_handler(struct pt_regs *regs, unsigned int esr)
>> +{
>> +     bool zero = regs->pstate & PSR_Z_BIT;
>> +
>> +     /* First unconditionally saturate the refcount. */
>> +     *(int *)regs->regs[16] = INT_MIN / 2;
>
> Does this work even when racing against a concurrent refcount operation
> that doesn't have a pre-check? I can't figure out how something like a
> sub_lt operation on a saturated counter couldn't reset the value to zero.
>

I hope Kees can clarify this, but as I understand it, this value was
chosen right in the middle of the negative space so it would take many
operations to get it to a sane value again, reducing the likelihood
that a situation is created that may be exploited.
