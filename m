From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Sun,  3 Sep 2017 11:16:22 +0100
Message-Id: <20170903101622.12093-1-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v4] arm64: kernel: implement fast refcount checking
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com
Cc: will.deacon@arm.com, keescook@chromium.org, hw.likun@huawei.com, labbott@fedoraproject.org, mark.rutland@arm.com, catalin.marinas@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

This adds support to arm64 for fast refcount checking, as proposed by
Kees for x86 based on the implementation by grsecurity/PaX.

The general approach is identical: the existing atomic_t helpers are
cloned for refcount_t, with the arithmetic instruction modified to set
the PSTATE flags, and one or two branch instructions added that jump to
an out of line handler if overflow, decrement to zero or increment from
zero are detected.

One complication that we have to deal with on arm64 is the fact that
it has two atomics implementations: the original LL/SC implementation
using load/store exclusive loops, and the newer LSE one that does mostly
the same in a single instruction. So we need to clone some parts of
both for the refcount handlers, but we also need to deal with the way
LSE builds fall back to LL/SC at runtime if the hardware does not
support it.

As is the case with the x86 version, the performance delta is in the
noise (Cortex-A57 @ 2 GHz, using LL/SC not LSE), even though the arm64
implementation incorporates an add-from-zero check as well:

perf stat -B -- echo ATOMIC_TIMING >/sys/kernel/debug/provoke-crash/DIRECT

 Performance counter stats for 'cat /dev/fd/63':

      65716.592696      task-clock (msec)         #    1.000 CPUs utilized
                 2      context-switches          #    0.000 K/sec
                 0      cpu-migrations            #    0.000 K/sec
                46      page-faults               #    0.001 K/sec
      131341846242      cycles                    #    1.999 GHz
       36712622640      instructions              #    0.28  insn per cycle
   <not supported>      branches
            792754      branch-misses

      65.736371584 seconds time elapsed

perf stat -B -- echo REFCOUNT_TIMING >/sys/kernel/debug/provoke-crash/DIRECT

      65615.259736      task-clock (msec)         #    1.000 CPUs utilized
                 2      context-switches          #    0.000 K/sec
                 0      cpu-migrations            #    0.000 K/sec
                45      page-faults               #    0.001 K/sec
      131138621533      cycles                    #    1.999 GHz
       43155978260      instructions              #    0.33  insn per cycle
   <not supported>      branches
            779668      branch-misses

      65.616216112 seconds time elapsed

For comparison, the numbers below were captured using CONFIG_REFCOUNT_FULL,
which uses the validation routines implemented in C using cmpxchg():

perf stat -B -- echo REFCOUNT_TIMING >/sys/kernel/debug/provoke-crash/DIRECT

 Performance counter stats for 'cat /dev/fd/63':

     104566.154096      task-clock (msec)         #    1.000 CPUs utilized
                 2      context-switches          #    0.000 K/sec
                 0      cpu-migrations            #    0.000 K/sec
                46      page-faults               #    0.000 K/sec
      208929924555      cycles                    #    1.998 GHz
      131354624418      instructions              #    0.63  insn per cycle
   <not supported>      branches
           1604302      branch-misses

     104.586265040 seconds time elapsed

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
v4: - Include CONFIG_REFCOUNT_FULL performance numbers for comparison.
    - Instead of via x16/x17, pass the overflow context into the handler using
      a dummy 'cbz' instruction that encodes the register holding the counter
      address and the offset to the branch instruction that detected the
      overflow.
    - Don't rely on condition flags to be preserved across a C 'return' from
      the out of line LL/SC routines; instead, check the return value of the
      out of line routine, which will also be set to zero if the pre-check for
      zero was triggered.
    - Drop the optimized LSE version to omit the 'neg' instruction when
      subtracting immediate values; the code is complicated enough as it is,
      and we can always add it later if we have numbers that justify doing so.
    - As suggested by Li Kun and Will, implement refcount_add_not_zero using
      both LL/SC and LSE (CAS) instructions.

 arch/arm64/Kconfig                    |  1 +
 arch/arm64/include/asm/atomic.h       | 24 ++++++
 arch/arm64/include/asm/atomic_ll_sc.h | 50 ++++++++++++
 arch/arm64/include/asm/atomic_lse.h   | 81 ++++++++++++++++++++
 arch/arm64/include/asm/brk-imm.h      |  1 +
 arch/arm64/include/asm/refcount.h     | 55 +++++++++++++
 arch/arm64/kernel/traps.c             | 38 +++++++++
 arch/arm64/lib/atomic_ll_sc.c         | 12 +++
 8 files changed, 262 insertions(+)

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
index c0235e0ff849..36d58b25edff 100644
--- a/arch/arm64/include/asm/atomic.h
+++ b/arch/arm64/include/asm/atomic.h
@@ -21,13 +21,37 @@
 #define __ASM_ATOMIC_H
 
 #include <linux/compiler.h>
+#include <linux/stringify.h>
 #include <linux/types.h>
 
 #include <asm/barrier.h>
+#include <asm/brk-imm.h>
 #include <asm/lse.h>
 
 #ifdef __KERNEL__
 
+/*
+ * To avoid having to allocate registers that pass the counter address and
+ * address of the call site to the overflow handler, encode the register and
+ * call site offset in a dummy cbz instruction that we can decode later.
+ */
+#define REFCOUNT_CHECK_TAIL						\
+"	.subsection	1\n"						\
+"33:	brk "		__stringify(REFCOUNT_BRK_IMM) "\n"		\
+"	cbz		%[counter], 22b\n"	/* never reached */	\
+"	.previous\n"
+
+#define REFCOUNT_POST_CHECK_NEG						\
+"22:	b.mi		33f\n"						\
+	REFCOUNT_CHECK_TAIL
+
+#define REFCOUNT_POST_CHECK_NEG_OR_ZERO					\
+"	b.eq		33f\n"						\
+	REFCOUNT_POST_CHECK_NEG
+
+#define REFCOUNT_PRE_CHECK_ZERO(reg)	"ccmp " #reg ", wzr, #8, pl\n"
+#define REFCOUNT_PRE_CHECK_NONE(reg)
+
 #define __ARM64_IN_ATOMIC_IMPL
 
 #if defined(CONFIG_ARM64_LSE_ATOMICS) && defined(CONFIG_AS_LSE)
diff --git a/arch/arm64/include/asm/atomic_ll_sc.h b/arch/arm64/include/asm/atomic_ll_sc.h
index f5a2d09afb38..eedf79f425dd 100644
--- a/arch/arm64/include/asm/atomic_ll_sc.h
+++ b/arch/arm64/include/asm/atomic_ll_sc.h
@@ -327,4 +327,54 @@ __CMPXCHG_DBL(_mb, dmb ish, l, "memory")
 
 #undef __CMPXCHG_DBL
 
+#define REFCOUNT_OP(op, asm_op, pre, post, l)				\
+__LL_SC_INLINE int							\
+__LL_SC_PREFIX(__refcount_##op(int i, atomic_t *r))			\
+{									\
+	unsigned int tmp;						\
+	int result;							\
+									\
+	asm volatile("// refcount_" #op "\n"				\
+"	prfm		pstl1strm, %[cval]\n"				\
+"1:	ldxr		%w1, %[cval]\n"					\
+"	" #asm_op "	%w[val], %w1, %w[i]\n"				\
+	REFCOUNT_PRE_CHECK_ ## pre (%w1)				\
+"	st" #l "xr	%w1, %w[val], %[cval]\n"			\
+"	cbnz		%w1, 1b\n"					\
+	REFCOUNT_POST_CHECK_ ## post					\
+	: [val] "=&r"(result), "=&r"(tmp), [cval] "+Q"(r->counter)	\
+	: [counter] "r"(&r->counter), [i] "Ir" (i)			\
+	: "cc");							\
+									\
+	return result;							\
+}									\
+__LL_SC_EXPORT(__refcount_##op);
+
+REFCOUNT_OP(add_lt, adds, ZERO, NEG_OR_ZERO,  );
+REFCOUNT_OP(sub_lt, subs, NONE, NEG,         l);
+REFCOUNT_OP(sub_le, subs, NONE, NEG_OR_ZERO, l);
+
+__LL_SC_INLINE int
+__LL_SC_PREFIX(__refcount_add_not_zero(int i, atomic_t *r))
+{
+	unsigned int tmp;
+	int result;
+
+	asm volatile("// refcount_add_not_zero\n"
+"	prfm	pstl1strm, %[cval]\n"
+"1:	ldxr	%w[val], %[cval]\n"
+"	cbz	%w[val], 2f\n"
+"	adds	%w[val], %w[val], %w[i]\n"
+"	stxr	%w1, %w[val], %[cval]\n"
+"	cbnz	%w1, 1b\n"
+	REFCOUNT_POST_CHECK_NEG
+"2:"
+	: [val] "=&r" (result), "=&r" (tmp), [cval] "+Q" (r->counter)
+	: [counter] "r"(&r->counter), [i] "Ir" (i)
+	: "cc");
+
+	return result;
+}
+__LL_SC_EXPORT(__refcount_add_not_zero);
+
 #endif	/* __ASM_ATOMIC_LL_SC_H */
diff --git a/arch/arm64/include/asm/atomic_lse.h b/arch/arm64/include/asm/atomic_lse.h
index 99fa69c9c3cf..7785c4293103 100644
--- a/arch/arm64/include/asm/atomic_lse.h
+++ b/arch/arm64/include/asm/atomic_lse.h
@@ -531,4 +531,85 @@ __CMPXCHG_DBL(_mb, al, "memory")
 #undef __LL_SC_CMPXCHG_DBL
 #undef __CMPXCHG_DBL
 
+#define REFCOUNT_ADD_OP(op, pre, post)					\
+static inline int __refcount_##op(int i, atomic_t *r)			\
+{									\
+	register int w0 asm ("w0") = i;					\
+	register atomic_t *x1 asm ("x1") = r;				\
+									\
+	asm volatile(ARM64_LSE_ATOMIC_INSN(				\
+	/* LL/SC */							\
+	__LL_SC_CALL(__refcount_##op)					\
+	"	cmp	%w0, wzr\n"					\
+	__nops(1),							\
+	/* LSE atomics */						\
+	"	ldadd		%w[i], w30, %[cval]\n"			\
+	"	adds		%w[i], %w[i], w30\n"			\
+	REFCOUNT_PRE_CHECK_ ## pre (w30))				\
+	REFCOUNT_POST_CHECK_ ## post					\
+	: [i] "+r" (w0), [cval] "+Q" (r->counter)			\
+	: [counter] "r"(&r->counter), "r" (x1)				\
+	: __LL_SC_CLOBBERS, "cc");					\
+									\
+	return w0;							\
+}
+
+REFCOUNT_ADD_OP(add_lt, ZERO, NEG_OR_ZERO);
+
+#define REFCOUNT_SUB_OP(op, post)					\
+static inline int __refcount_##op(int i, atomic_t *r)			\
+{									\
+	register int w0 asm ("w0") = i;					\
+	register atomic_t *x1 asm ("x1") = r;				\
+									\
+	asm volatile(ARM64_LSE_ATOMIC_INSN(				\
+	/* LL/SC */							\
+	__LL_SC_CALL(__refcount_##op)					\
+	"	cmp	%w0, wzr\n"					\
+	__nops(1),							\
+	/* LSE atomics */						\
+	"	neg	%w[i], %w[i]\n"					\
+	"	ldaddl	%w[i], w30, %[cval]\n"				\
+	"	adds	%w[i], %w[i], w30")				\
+	REFCOUNT_POST_CHECK_ ## post					\
+	: [i] "+r" (w0), [cval] "+Q" (r->counter)			\
+	: [counter] "r" (&r->counter), "r" (x1)				\
+	: __LL_SC_CLOBBERS, "cc");					\
+									\
+	return w0;							\
+}
+
+REFCOUNT_SUB_OP(sub_lt, NEG);
+REFCOUNT_SUB_OP(sub_le, NEG_OR_ZERO);
+
+static inline int __refcount_add_not_zero(int i, atomic_t *r)
+{
+	register int result asm ("w0");
+	register atomic_t *x1 asm ("x1") = r;
+
+	asm volatile(ARM64_LSE_ATOMIC_INSN(
+	/* LL/SC */
+	"	mov	%w0, %w[i]\n"
+	__LL_SC_CALL(__refcount_add_not_zero)
+	"	cmp	%w0, wzr\n"
+	__nops(6),
+	/* LSE atomics */
+	"	ldr	%w0, %[cval]\n"
+	"1:	cmp	%w0, wzr\n"
+	"	b.eq	2f\n"
+	"	add	w30, %w0, %w[i]\n"
+	"	cas	%w0, w30, %[cval]\n"
+	"	sub	w30, w30, %w[i]\n"
+	"	cmp	%w0, w30\n"
+	"	b.ne	1b\n"
+	"	adds	%w0, w30, %w[i]\n"
+	"2:\n")
+	REFCOUNT_POST_CHECK_NEG
+	: "=&r" (result), [cval] "+Q" (r->counter)
+	: [counter] "r" (&r->counter), [i] "Ir" (i), "r" (x1)
+	: __LL_SC_CLOBBERS, "cc");
+
+	return result;
+}
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
index 000000000000..f6233b752cec
--- /dev/null
+++ b/arch/arm64/include/asm/refcount.h
@@ -0,0 +1,55 @@
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
+	return __refcount_add_not_zero(i, &r->refs) != 0;
+}
+
+static __always_inline __must_check bool refcount_inc_not_zero(refcount_t *r)
+{
+	return __refcount_add_not_zero(1, &r->refs) != 0;
+}
+
+#endif
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index c7c7088097be..1fa681847e16 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -758,8 +758,46 @@ int __init early_brk64(unsigned long addr, unsigned int esr,
 	return bug_handler(regs, esr) != DBG_HOOK_HANDLED;
 }
 
+static int refcount_overflow_handler(struct pt_regs *regs, unsigned int esr)
+{
+	u32 dummy_cbz = le32_to_cpup((__le32 *)(regs->pc + 4));
+	bool zero = regs->pstate & PSR_Z_BIT;
+	u32 rt;
+
+	/*
+	 * Find the register that holds the counter address from the
+	 * dummy 'cbz' instruction that follows the 'brk' instruction
+	 * that sent us here.
+	 */
+	rt = aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RT, dummy_cbz);
+
+	/* First unconditionally saturate the refcount. */
+	*(int *)regs->regs[rt] = INT_MIN / 2;
+
+	/*
+	 * This function has been called because either a negative refcount
+	 * value was seen by any of the refcount functions, or a zero
+	 * refcount value was seen by refcount_{add,dec}().
+	 */
+
+	/* point pc to the branch instruction that detected the overflow */
+	regs->pc += 4 + aarch64_get_branch_offset(dummy_cbz);
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
index b0c538b0da28..8a335cd9f0e2 100644
--- a/arch/arm64/lib/atomic_ll_sc.c
+++ b/arch/arm64/lib/atomic_ll_sc.c
@@ -1,3 +1,15 @@
 #include <asm/atomic.h>
 #define __ARM64_IN_ATOMIC_IMPL
+
+/*
+ * Disarm the refcount checks in the out-of-line LL/SC routines. These are
+ * redundant, given that the LSE callers already perform the same checks.
+ * We do have to make sure that we exit with a zero value if the pre-check
+ * detected a zero value.
+ */
+#undef REFCOUNT_POST_CHECK_NEG
+#undef REFCOUNT_POST_CHECK_NEG_OR_ZERO
+#define REFCOUNT_POST_CHECK_NEG
+#define REFCOUNT_POST_CHECK_NEG_OR_ZERO   "csel %w[val], wzr, %w[val], eq\n"
+
 #include <asm/atomic_ll_sc.h>
-- 
2.11.0
