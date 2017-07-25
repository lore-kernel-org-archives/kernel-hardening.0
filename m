From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Tue, 25 Jul 2017 19:15:36 +0100
Message-Id: <20170725181536.21092-1-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v2] arm64: kernel: implement fast refcount checking
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com
Cc: will.deacon@arm.com, keescook@chromium.org, mark.rutland@arm.com, labbott@fedoraproject.org, hw.likun@huawei.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

This adds support to arm64 for fast refcount checking, as proposed by
Kees for x86 based on the implementation by grsecurity/PaX.

The general approach is identical: the existing atomic_t helpers are
cloned for refcount_t, with a single branch instruction added that
jumps to an out of line handler if overflow and/or decrement to
zero is detected.

One complication that we have to deal with on arm64 is the fact that
is has two atomics implementations: the original LL/SC implementation
using load/store exclusive loops, and the newer LSE one that do mostly
the same in a single instruction. So we need to clone some parts of
both for the refcount handlers, but we also need to deal with the way
LSE builds fall back to LL/SC at runtime if the hardware does not
support it.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
This is a quick v2 after I sent the original RFC patch only 6 hours ago.
However, as Kees pointed out, it appears I am not the only person looking
into this for arm64, and so it makes sense to share my latest before going
on travel for the rest of the week.

v2: - Avoid adrp instructions, it does not always work in modules. Instead,
      use a 32-bit offset in the out-of-line sequence that we can dereference
      in the handler.
    - Use release semantics for sub/dec
    - Switch to b.mi / b.ls which better matches the x86 code (we don't
      actually detect signed overflow, i.e., from 0x7fffffff to 0x80000000)
    - Write a commit log

Now tested using lkdtm: not all tests work as expected (the SATURATE ones
seem broken) but Kees has this covered already.

 arch/arm64/Kconfig                    |  1 +
 arch/arm64/include/asm/atomic.h       | 15 ++++
 arch/arm64/include/asm/atomic_ll_sc.h | 28 +++++++
 arch/arm64/include/asm/atomic_lse.h   | 52 ++++++++++++
 arch/arm64/include/asm/brk-imm.h      |  1 +
 arch/arm64/include/asm/refcount.h     | 88 ++++++++++++++++++++
 arch/arm64/kernel/traps.c             | 37 ++++++++
 arch/arm64/lib/atomic_ll_sc.c         |  6 ++
 8 files changed, 228 insertions(+)

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
index c0235e0ff849..93a0313ab0ae 100644
--- a/arch/arm64/include/asm/atomic.h
+++ b/arch/arm64/include/asm/atomic.h
@@ -24,10 +24,25 @@
 #include <linux/types.h>
 
 #include <asm/barrier.h>
+#include <asm/brk-imm.h>
 #include <asm/lse.h>
 
 #ifdef __KERNEL__
 
+#define REFCOUNT_CHECK(cond)						\
+"22:	b." #cond "	33f\n"						\
+"	.pushsection	\".text.unlikely\"\n"				\
+"33:	mov		x16, %[counter]\n"				\
+"	adr		x17, 44f\n"					\
+"	brk		%[brk_imm]\n"					\
+"44:	.long		22b - .\n"					\
+"	.popsection\n"
+
+#define REFCOUNT_INPUTS(r)						\
+	[counter] "r" (&(r)->counter), [brk_imm] "i" (REFCOUNT_BRK_IMM),
+
+#define REFCOUNT_CLOBBERS	: "cc", "x16", "x17"
+
 #define __ARM64_IN_ATOMIC_IMPL
 
 #if defined(CONFIG_ARM64_LSE_ATOMICS) && defined(CONFIG_AS_LSE)
diff --git a/arch/arm64/include/asm/atomic_ll_sc.h b/arch/arm64/include/asm/atomic_ll_sc.h
index f5a2d09afb38..99d0beb70ef1 100644
--- a/arch/arm64/include/asm/atomic_ll_sc.h
+++ b/arch/arm64/include/asm/atomic_ll_sc.h
@@ -327,4 +327,32 @@ __CMPXCHG_DBL(_mb, dmb ish, l, "memory")
 
 #undef __CMPXCHG_DBL
 
+#define REFCOUNT_OP(op, asm_op, cond, l, clobber...)			\
+__LL_SC_INLINE int							\
+__LL_SC_PREFIX(__refcount_##op(int i, atomic_t *r))			\
+{									\
+	unsigned long tmp;						\
+	int result;							\
+									\
+	asm volatile("// refcount_" #op "\n"				\
+"	prfm		pstl1strm, %2\n"				\
+"1:	ldxr		%w0, %2\n"					\
+"	" #asm_op "	%w0, %w0, %w[i]\n"				\
+"	st" #l "xr	%w1, %w0, %2\n"					\
+"	cbnz		%w1, 1b\n"					\
+	REFCOUNT_CHECK(cond)						\
+	: "=&r" (result), "=&r" (tmp), "+Q" (r->counter)		\
+	: REFCOUNT_INPUTS(r) [i] "Ir" (i)				\
+	clobber);							\
+									\
+	return result;							\
+}									\
+__LL_SC_EXPORT(__refcount_##op);
+
+REFCOUNT_OP(add_lt, adds, mi,  , REFCOUNT_CLOBBERS);
+REFCOUNT_OP(sub_lt_neg, adds, mi, l, REFCOUNT_CLOBBERS);
+REFCOUNT_OP(sub_le_neg, adds, ls, l, REFCOUNT_CLOBBERS);
+REFCOUNT_OP(sub_lt, subs, mi, l, REFCOUNT_CLOBBERS);
+REFCOUNT_OP(sub_le, subs, ls, l, REFCOUNT_CLOBBERS);
+
 #endif	/* __ASM_ATOMIC_LL_SC_H */
diff --git a/arch/arm64/include/asm/atomic_lse.h b/arch/arm64/include/asm/atomic_lse.h
index 99fa69c9c3cf..0551dfe6679a 100644
--- a/arch/arm64/include/asm/atomic_lse.h
+++ b/arch/arm64/include/asm/atomic_lse.h
@@ -531,4 +531,56 @@ __CMPXCHG_DBL(_mb, al, "memory")
 #undef __LL_SC_CMPXCHG_DBL
 #undef __CMPXCHG_DBL
 
+#define REFCOUNT_ADD_OP(op, rel, cond)					\
+static inline int __refcount_##op(int i, atomic_t *r)			\
+{									\
+	register int w0 asm ("w0") = i;					\
+	register atomic_t *x1 asm ("x1") = r;				\
+									\
+	asm volatile(ARM64_LSE_ATOMIC_INSN(				\
+	/* LL/SC */							\
+	__LL_SC_CALL(__refcount_##op)					\
+	__nops(1),							\
+	/* LSE atomics */						\
+	"	ldadd" #rel "	%w[i], w30, %[v]\n"			\
+	"	adds		%w[i], %w[i], w30")			\
+	REFCOUNT_CHECK(cond)						\
+	: [i] "+r" (w0), [v] "+Q" (r->counter)				\
+	: REFCOUNT_INPUTS(r) "r" (x1)					\
+	: __LL_SC_CLOBBERS, "cc");					\
+									\
+	return w0;							\
+}
+
+#define REFCOUNT_SUB_OP(op, cond, fbop)					\
+static inline int __refcount_##op(int i, atomic_t *r)			\
+{									\
+	register int w0 asm ("w0") = i;					\
+	register atomic_t *x1 asm ("x1") = r;				\
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
+	"	ldaddl	%w[i], w30, %[v]\n"				\
+	"	adds	%w[i], %w[i], w30")				\
+	REFCOUNT_CHECK(cond)						\
+	: [i] "+r" (w0), [v] "+Q" (r->counter)				\
+	: REFCOUNT_INPUTS(r) "r" (x1)					\
+	: __LL_SC_CLOBBERS, "cc");					\
+									\
+	return w0;							\
+}
+
+REFCOUNT_ADD_OP(add_lt, , mi);
+REFCOUNT_ADD_OP(sub_lt_neg, l, mi);
+REFCOUNT_ADD_OP(sub_le_neg, l, ls);
+REFCOUNT_SUB_OP(sub_lt, mi, sub_lt_neg);
+REFCOUNT_SUB_OP(sub_le, ls, sub_le_neg);
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
index 000000000000..575c199cb34a
--- /dev/null
+++ b/arch/arm64/include/asm/refcount.h
@@ -0,0 +1,88 @@
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
+/**
+ * __refcount_add_unless - add unless the number is already a given value
+ * @r: pointer of type refcount_t
+ * @a: the amount to add to v...
+ * @u: ...unless v is equal to u.
+ *
+ * Atomically adds @a to @r, so long as @r was not already @u.
+ * Returns the old value of @r.
+ */
+static __always_inline __must_check int __refcount_add_unless(refcount_t *r,
+							      int a, int u)
+{
+	int c, new;
+
+	c = atomic_read(&(r->refs));
+	do {
+		if (unlikely(c == u))
+			break;
+
+		asm volatile(
+			"adds	%0, %0, %2	;"
+			REFCOUNT_CHECK(lt)
+			: "=r" (new)
+			: "0" (c), "Ir" (a),
+			  [counter] "r" (&r->refs.counter),
+			  [brk_imm] "i" (REFCOUNT_BRK_IMM)
+			: "cc", "x16", "x17");
+
+	} while (!atomic_try_cmpxchg(&(r->refs), &c, new));
+
+	return c;
+}
+
+static __always_inline __must_check
+bool refcount_add_not_zero(unsigned int i, refcount_t *r)
+{
+	return __refcount_add_unless(r, i, 0) != 0;
+}
+
+static __always_inline __must_check bool refcount_inc_not_zero(refcount_t *r)
+{
+	return refcount_add_not_zero(1, r);
+}
+
+#endif
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index c7c7088097be..69040206a559 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -758,8 +758,45 @@ int __init early_brk64(unsigned long addr, unsigned int esr,
 	return bug_handler(regs, esr) != DBG_HOOK_HANDLED;
 }
 
+static int refcount_overflow_handler(struct pt_regs *regs, unsigned int esr)
+{
+	/* First unconditionally saturate the refcount. */
+	*(int *)regs->regs[16] = INT_MIN / 2;
+
+	/*
+	 * This function has been called because either a negative refcount
+	 * value was seen by any of the refcount functions, or a zero
+	 * refcount value was seen by refcount_dec().
+	 *
+	 * Duplicate the condition check against PSTATE based on the
+	 * instructions that could have brought us here:
+	 *
+	 *   b.mi  =>  N == 1
+	 *   b.ls  =>  C == 0 || Z == 1
+	 */
+	if (regs->pstate & (PSR_N_BIT | PSR_Z_BIT) ||
+	    !(regs->pstate & PSR_C_BIT)) {
+		bool zero = regs->pstate & PSR_Z_BIT;
+
+		/* point pc to the branch instruction that brought us here */
+		regs->pc = regs->regs[17] + *(s32 *)regs->regs[17];
+		refcount_error_report(regs, zero ? "hit zero" : "overflow");
+	}
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
index b0c538b0da28..5f038abdc635 100644
--- a/arch/arm64/lib/atomic_ll_sc.c
+++ b/arch/arm64/lib/atomic_ll_sc.c
@@ -1,3 +1,9 @@
 #include <asm/atomic.h>
 #define __ARM64_IN_ATOMIC_IMPL
+#undef REFCOUNT_CHECK
+#undef REFCOUNT_INPUTS
+#undef REFCOUNT_CLOBBERS
+#define REFCOUNT_CHECK(cond)
+#define REFCOUNT_INPUTS(r)
+#define REFCOUNT_CLOBBERS : "cc"
 #include <asm/atomic_ll_sc.h>
-- 
2.9.3
