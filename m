From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 31 Jul 2017 13:01:44 +0100
Message-Id: <20170731120144.14214-1-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v3] arm64: kernel: implement fast refcount checking
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com
Cc: will.deacon@arm.com, keescook@chromium.org, mark.rutland@arm.com, labbott@fedoraproject.org, hw.likun@huawei.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

This adds support to arm64 for fast refcount checking, as proposed by
Kees for x86 based on the implementation by grsecurity/PaX.

The general approach is identical: the existing atomic_t helpers are
cloned for refcount_t, with the arithmetic instruction modified to set
the PSTATE flags, and one or two branch instructions added that jump to
an out of line handler if overflow and/or decrement to zero are detected.

One complication that we have to deal with on arm64 is the fact that
is has two atomics implementations: the original LL/SC implementation
using load/store exclusive loops, and the newer LSE one that do mostly
the same in a single instruction. So we need to clone some parts of
both for the refcount handlers, but we also need to deal with the way
LSE builds fall back to LL/SC at runtime if the hardware does not
support it. (The only exception is refcount_add_not_zero(), which
updates the refcount conditionally, so it is only implemented using
a load/store exclusive loop)

As is the case with the x86 version, the performance delta is in the
noise (Cortex-A57 @ 2 GHz, using LL/SC not LSE):

perf stat -B -- cat <(echo ATOMIC_TIMING) >/sys/kernel/debug/provoke-crash/DIRECT

 Performance counter stats for 'cat /dev/fd/63':

      65736.585960      task-clock (msec)         #    1.000 CPUs utilized
                 1      context-switches          #    0.000 K/sec
                 0      cpu-migrations            #    0.000 K/sec
                45      page-faults               #    0.001 K/sec
      131379085033      cycles                    #    1.999 GHz
       36739083993      instructions              #    0.28  insn per cycle
   <not supported>      branches
            909235      branch-misses

      65.737640608 seconds time elapsed

perf stat -B -- cat <(echo REFCOUNT_TIMING) >/sys/kernel/debug/provoke-crash/DIRECT

 Performance counter stats for 'cat /dev/fd/63':

      65555.402680      task-clock (msec)         #    1.000 CPUs utilized
                 6      context-switches          #    0.000 K/sec
                 0      cpu-migrations            #    0.000 K/sec
                46      page-faults               #    0.001 K/sec
      131023560293      cycles                    #    1.999 GHz
       38885768741      instructions              #    0.30  insn per cycle
   <not supported>      branches
            869174      branch-misses

      65.580366472 seconds time elapsed

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
v3: - switch to refcount_add_not_zero() that has opencoded ll/sc atomics

I played around with adding a pre-check to the refcount_add paths to check
for cases where the refcount is already zero, but that results in a 10%
performance hit:

perf stat -B -- cat <(echo REFCOUNT_TIMING) >/sys/kernel/debug/provoke-crash/DIRECT

 Performance counter stats for 'cat /dev/fd/63':

      72470.950728      task-clock (msec)         #    1.000 CPUs utilized
                 0      context-switches          #    0.000 K/sec
                 0      cpu-migrations            #    0.000 K/sec
                46      page-faults               #    0.001 K/sec
      144846868175      cycles                    #    1.999 GHz
       41058738640      instructions              #    0.28  insn per cycle
   <not supported>      branches
            899090      branch-misses

      72.471588816 seconds time elapsed

 arch/arm64/Kconfig                    |  1 +
 arch/arm64/include/asm/atomic.h       | 23 +++++++
 arch/arm64/include/asm/atomic_ll_sc.h | 28 ++++++++
 arch/arm64/include/asm/atomic_lse.h   | 55 +++++++++++++++
 arch/arm64/include/asm/brk-imm.h      |  1 +
 arch/arm64/include/asm/refcount.h     | 71 ++++++++++++++++++++
 arch/arm64/kernel/traps.c             | 29 ++++++++
 arch/arm64/lib/atomic_ll_sc.c         | 16 +++++
 8 files changed, 224 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index dfd908630631..53b9a8f5277b 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -16,6 +16,7 @@ config ARM64
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_GIGANTIC_PAGE if (MEMORY_ISOLATION && COMPACTION) || CMA
 	select ARCH_HAS_KCOV
+	select ARCH_HAS_REFCOUNT
 	select ARCH_HAS_SET_MEMORY
 	select ARCH_HAS_SG_CHAIN
 	select ARCH_HAS_STRICT_KERNEL_RWX
diff --git a/arch/arm64/include/asm/atomic.h b/arch/arm64/include/asm/atomic.h
index c0235e0ff849..63457741d141 100644
--- a/arch/arm64/include/asm/atomic.h
+++ b/arch/arm64/include/asm/atomic.h
@@ -24,10 +24,33 @@
 #include <linux/types.h>
 
 #include <asm/barrier.h>
+#include <asm/brk-imm.h>
 #include <asm/lse.h>
 
 #ifdef __KERNEL__
 
+#define REFCOUNT_CHECK_TAIL						\
+"	.subsection	1\n"						\
+"33:	mov		x16, %[counter]\n"				\
+"	adr		x17, 44f\n"					\
+"	brk		%[brk_imm]\n"					\
+"44:	.long		22b - .\n"					\
+"	.previous\n"
+
+#define REFCOUNT_POST_CHECK_NEG						\
+"22:	b.mi		33f\n"						\
+	REFCOUNT_CHECK_TAIL
+
+#define REFCOUNT_POST_CHECK_NEG_OR_ZERO					\
+"	b.mi		33f\n"						\
+"22:	b.eq		33f\n"						\
+	REFCOUNT_CHECK_TAIL
+
+#define REFCOUNT_INPUTS(r)						\
+	[counter] "r" (&(r)->counter), [brk_imm] "i" (REFCOUNT_BRK_IMM),
+
+#define REFCOUNT_CLOBBERS	"cc", "x16", "x17"
+
 #define __ARM64_IN_ATOMIC_IMPL
 
 #if defined(CONFIG_ARM64_LSE_ATOMICS) && defined(CONFIG_AS_LSE)
diff --git a/arch/arm64/include/asm/atomic_ll_sc.h b/arch/arm64/include/asm/atomic_ll_sc.h
index f5a2d09afb38..ef7a42931533 100644
--- a/arch/arm64/include/asm/atomic_ll_sc.h
+++ b/arch/arm64/include/asm/atomic_ll_sc.h
@@ -327,4 +327,32 @@ __CMPXCHG_DBL(_mb, dmb ish, l, "memory")
 
 #undef __CMPXCHG_DBL
 
+#define REFCOUNT_OP(op, asm_op, post, l)				\
+__LL_SC_INLINE int							\
+__LL_SC_PREFIX(__refcount_##op(int i, atomic_t *r))			\
+{									\
+	unsigned long tmp;						\
+	int result;							\
+									\
+	asm volatile("// refcount_" #op "\n"				\
+"	prfm		pstl1strm, %2\n"				\
+"1:	ldxr		%w[val], %2\n"					\
+"	" #asm_op "	%w[val], %w[val], %w[i]\n"			\
+"	st" #l "xr	%w1, %w[val], %2\n"				\
+"	cbnz		%w1, 1b\n"					\
+	REFCOUNT_POST_CHECK_ ## post					\
+	: [val] "=&r" (result), "=&r" (tmp), "+Q" (r->counter)		\
+	: REFCOUNT_INPUTS(r) [i] "Ir" (i)				\
+	: REFCOUNT_CLOBBERS);						\
+									\
+	return result;							\
+}									\
+__LL_SC_EXPORT(__refcount_##op);
+
+REFCOUNT_OP(add_lt,     adds, NEG,          );
+REFCOUNT_OP(sub_lt_neg, adds, NEG,         l);
+REFCOUNT_OP(sub_le_neg, adds, NEG_OR_ZERO, l);
+REFCOUNT_OP(sub_lt,     subs, NEG,         l);
+REFCOUNT_OP(sub_le,     subs, NEG_OR_ZERO, l);
+
 #endif	/* __ASM_ATOMIC_LL_SC_H */
diff --git a/arch/arm64/include/asm/atomic_lse.h b/arch/arm64/include/asm/atomic_lse.h
index 99fa69c9c3cf..004891b61df1 100644
--- a/arch/arm64/include/asm/atomic_lse.h
+++ b/arch/arm64/include/asm/atomic_lse.h
@@ -531,4 +531,59 @@ __CMPXCHG_DBL(_mb, al, "memory")
 #undef __LL_SC_CMPXCHG_DBL
 #undef __CMPXCHG_DBL
 
+#define REFCOUNT_ADD_OP(op, rel, post)					\
+static inline int __refcount_##op(int i, atomic_t *r)			\
+{									\
+	register int w0 asm ("w0") = i;					\
+	register atomic_t *x1 asm ("x1") = r;				\
+	register int w30 asm ("w30");					\
+									\
+	asm volatile(ARM64_LSE_ATOMIC_INSN(				\
+	/* LL/SC */							\
+	__LL_SC_CALL(__refcount_##op)					\
+	__nops(1),							\
+	/* LSE atomics */						\
+	"	ldadd" #rel "	%w[i], %w[val], %[v]\n"			\
+	"	adds		%w[i], %w[i], %w[val]")			\
+	REFCOUNT_POST_CHECK_ ## post					\
+	: [i] "+r" (w0), [v] "+Q" (r->counter), [val] "=&r" (w30)	\
+	: REFCOUNT_INPUTS(r) "r" (x1)					\
+	: REFCOUNT_CLOBBERS);						\
+									\
+	return w0;							\
+}
+
+REFCOUNT_ADD_OP(add_lt,      , NEG        );
+REFCOUNT_ADD_OP(sub_lt_neg, l, NEG        );
+REFCOUNT_ADD_OP(sub_le_neg, l, NEG_OR_ZERO);
+
+#define REFCOUNT_SUB_OP(op, post, fbop)					\
+static inline int __refcount_##op(int i, atomic_t *r)			\
+{									\
+	register int w0 asm ("w0") = i;					\
+	register atomic_t *x1 asm ("x1") = r;				\
+	register int w30 asm ("w30");					\
+									\
+	if (__builtin_constant_p(i))					\
+		return __refcount_##fbop(-i, r);			\
+									\
+	asm volatile(ARM64_LSE_ATOMIC_INSN(				\
+	/* LL/SC */							\
+	__LL_SC_CALL(__refcount_##op)					\
+	__nops(2),							\
+	/* LSE atomics */						\
+	"	neg	%w[i], %w[i]\n"					\
+	"	ldaddl	%w[i], %w[val], %[v]\n"				\
+	"	adds	%w[i], %w[i], %w[val]")				\
+	REFCOUNT_POST_CHECK_ ## post					\
+	: [i] "+r" (w0), [v] "+Q" (r->counter), [val] "=&r" (w30)	\
+	: REFCOUNT_INPUTS(r) "r" (x1)					\
+	: REFCOUNT_CLOBBERS);						\
+									\
+	return w0;							\
+}
+
+REFCOUNT_SUB_OP(sub_lt, NEG,         sub_lt_neg);
+REFCOUNT_SUB_OP(sub_le, NEG_OR_ZERO, sub_le_neg);
+
 #endif	/* __ASM_ATOMIC_LSE_H */
diff --git a/arch/arm64/include/asm/brk-imm.h b/arch/arm64/include/asm/brk-imm.h
index ed693c5bcec0..0bce57737ff1 100644
--- a/arch/arm64/include/asm/brk-imm.h
+++ b/arch/arm64/include/asm/brk-imm.h
@@ -18,6 +18,7 @@
  * 0x800: kernel-mode BUG() and WARN() traps
  */
 #define FAULT_BRK_IMM			0x100
+#define REFCOUNT_BRK_IMM		0x101
 #define KGDB_DYN_DBG_BRK_IMM		0x400
 #define KGDB_COMPILED_DBG_BRK_IMM	0x401
 #define BUG_BRK_IMM			0x800
diff --git a/arch/arm64/include/asm/refcount.h b/arch/arm64/include/asm/refcount.h
new file mode 100644
index 000000000000..ceb2fe713b80
--- /dev/null
+++ b/arch/arm64/include/asm/refcount.h
@@ -0,0 +1,71 @@
+/*
+ * arm64-specific implementation of refcount_t. Based on x86 version and
+ * PAX_REFCOUNT from PaX/grsecurity.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_REFCOUNT_H
+#define __ASM_REFCOUNT_H
+
+#include <linux/refcount.h>
+
+#include <asm/atomic.h>
+#include <asm/uaccess.h>
+
+static __always_inline void refcount_add(int i, refcount_t *r)
+{
+	__refcount_add_lt(i, &r->refs);
+}
+
+static __always_inline void refcount_inc(refcount_t *r)
+{
+	__refcount_add_lt(1, &r->refs);
+}
+
+static __always_inline void refcount_dec(refcount_t *r)
+{
+	__refcount_sub_le(1, &r->refs);
+}
+
+static __always_inline __must_check bool refcount_sub_and_test(unsigned int i,
+							       refcount_t *r)
+{
+	return __refcount_sub_lt(i, &r->refs) == 0;
+}
+
+static __always_inline __must_check bool refcount_dec_and_test(refcount_t *r)
+{
+	return __refcount_sub_lt(1, &r->refs) == 0;
+}
+
+static __always_inline __must_check bool refcount_add_not_zero(unsigned int i,
+							       refcount_t *r)
+{
+	unsigned long tmp;
+	int result;
+
+	asm volatile("// refcount_add_not_zero \n"
+"	prfm		pstl1strm, %2\n"
+"1:	ldxr		%w[val], %2\n"
+"	cbz		%w[val], 2f\n"
+"	adds		%w[val], %w[val], %w[i]\n"
+"	stxr		%w1, %w[val], %2\n"
+"	cbnz		%w1, 1b\n"
+	REFCOUNT_POST_CHECK_NEG
+"2:"
+	: [val] "=&r" (result), "=&r" (tmp), "+Q" (r->refs.counter)
+	: REFCOUNT_INPUTS(&r->refs) [i] "Ir" (i)
+	: REFCOUNT_CLOBBERS);
+
+	return result != 0;
+}
+
+static __always_inline __must_check bool refcount_inc_not_zero(refcount_t *r)
+{
+	return refcount_add_not_zero(1, r);
+}
+
+#endif
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index c7c7088097be..07bd026ec71d 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -758,8 +758,37 @@ int __init early_brk64(unsigned long addr, unsigned int esr,
 	return bug_handler(regs, esr) != DBG_HOOK_HANDLED;
 }
 
+static int refcount_overflow_handler(struct pt_regs *regs, unsigned int esr)
+{
+	bool zero = regs->pstate & PSR_Z_BIT;
+
+	/* First unconditionally saturate the refcount. */
+	*(int *)regs->regs[16] = INT_MIN / 2;
+
+	/*
+	 * This function has been called because either a negative refcount
+	 * value was seen by any of the refcount functions, or a zero
+	 * refcount value was seen by refcount_{add,dec}().
+	 */
+
+	/* point pc to the branch instruction that brought us here */
+	regs->pc = regs->regs[17] + *(s32 *)regs->regs[17];
+	refcount_error_report(regs, zero ? "hit zero" : "overflow");
+
+	/* advance pc and proceed */
+	regs->pc += 4;
+	return DBG_HOOK_HANDLED;
+}
+
+static struct break_hook refcount_break_hook = {
+	.esr_val	= 0xf2000000 | REFCOUNT_BRK_IMM,
+	.esr_mask	= 0xffffffff,
+	.fn		= refcount_overflow_handler,
+};
+
 /* This registration must happen early, before debug_traps_init(). */
 void __init trap_init(void)
 {
 	register_break_hook(&bug_break_hook);
+	register_break_hook(&refcount_break_hook);
 }
diff --git a/arch/arm64/lib/atomic_ll_sc.c b/arch/arm64/lib/atomic_ll_sc.c
index b0c538b0da28..013a10c5461a 100644
--- a/arch/arm64/lib/atomic_ll_sc.c
+++ b/arch/arm64/lib/atomic_ll_sc.c
@@ -1,3 +1,19 @@
 #include <asm/atomic.h>
 #define __ARM64_IN_ATOMIC_IMPL
+
+/*
+ * If we are invoking the LL/SC versions out of line as the fallback
+ * alternatives for LSE atomics, disarm the overflow check because it
+ * would be redundant (and would identify the out of line routine as
+ * the location of the error which not be helpful either).
+ */
+#undef REFCOUNT_POST_CHECK_NEG
+#undef REFCOUNT_POST_CHECK_NEG_OR_ZERO
+#undef REFCOUNT_INPUTS
+#undef REFCOUNT_CLOBBERS
+#define REFCOUNT_POST_CHECK_NEG
+#define REFCOUNT_POST_CHECK_NEG_OR_ZERO
+#define REFCOUNT_INPUTS(r)
+#define REFCOUNT_CLOBBERS			"cc"
+
 #include <asm/atomic_ll_sc.h>
-- 
2.11.0
