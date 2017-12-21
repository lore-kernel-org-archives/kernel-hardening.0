Date: Thu, 21 Dec 2017 16:50:36 +0900
From: Jinbum Park <jinb.park7@gmail.com>
Message-ID: <20171221075036.GA32158@pjb1027-Latitude-E5410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [PATCH] arm: kernel: implement fast refcount
 checking
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: linux@armlinux.org.uk, will.deacon@arm.com, peterz@infradead.org, boqun.feng@gmail.com, mingo@kernel.org, mark.rutland@arm.com, nicolas.pitre@linaro.org, mickael.guene@st.com, keescook@chromium.org, labbott@redhat.com, ard.biesheuvel@linaro.org
List-ID: <kernel-hardening.lists.openwall.com>

This adds support to arm for fast refcount checking.
It's heavily based on x86, arm64 implementation.
(7a46ec0e2f48 ("locking/refcounts,
x86/asm: Implement fast refcount overflow protection)

This doesn't support under-ARMv6, thumb2-kernel yet.

Test result of this patch is as follows.

1. LKDTM test

- All REFCOUNT_* tests in LKDTM have passed.

2. Performance test

- Cortex-A7, Quad Core, 450 MHz
- Case with CONFIG_ARCH_HAS_REFCOUNT,

perf stat -B -- echo ATOMIC_TIMING \
		>/sys/kernel/debug/provoke-crash/DIRECT
204.364247057 seconds time elapsed

perf stat -B -- echo REFCOUNT_TIMING \
		>/sys/kernel/debug/provoke-crash/DIRECT
208.006062212 seconds time elapsed

- Case with CONFIG_REFCOUNT_FULL,

perf stat -B -- echo REFCOUNT_TIMING \
		>/sys/kernel/debug/provoke-crash/DIRECT
369.256523453 seconds time elapsed

Signed-off-by: Jinbum Park <jinb.park7@gmail.com>
---
 arch/arm/Kconfig                |  1 +
 arch/arm/include/asm/atomic.h   | 82 +++++++++++++++++++++++++++++++++++++++++
 arch/arm/include/asm/refcount.h | 55 +++++++++++++++++++++++++++
 arch/arm/kernel/traps.c         | 44 ++++++++++++++++++++++
 4 files changed, 182 insertions(+)
 create mode 100644 arch/arm/include/asm/refcount.h

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 3ea00d6..e07b986 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -7,6 +7,7 @@ config ARM
 	select ARCH_HAS_DEBUG_VIRTUAL
 	select ARCH_HAS_DEVMEM_IS_ALLOWED
 	select ARCH_HAS_ELF_RANDOMIZE
+	select ARCH_HAS_REFCOUNT if __LINUX_ARM_ARCH__ >= 6 && (!THUMB2_KERNEL)
 	select ARCH_HAS_SET_MEMORY
 	select ARCH_HAS_STRICT_KERNEL_RWX if MMU && !XIP_KERNEL
 	select ARCH_HAS_STRICT_MODULE_RWX if MMU
diff --git a/arch/arm/include/asm/atomic.h b/arch/arm/include/asm/atomic.h
index 66d0e21..b203396 100644
--- a/arch/arm/include/asm/atomic.h
+++ b/arch/arm/include/asm/atomic.h
@@ -17,6 +17,7 @@
 #include <linux/irqflags.h>
 #include <asm/barrier.h>
 #include <asm/cmpxchg.h>
+#include <asm/opcodes.h>
 
 #define ATOMIC_INIT(i)	{ (i) }
 
@@ -32,6 +33,87 @@
 
 #if __LINUX_ARM_ARCH__ >= 6
 
+#ifdef CONFIG_ARCH_HAS_REFCOUNT
+
+#define REFCOUNT_ARM_BKPT_INSTR 0xfff001fc
+
+/*
+ * 1) encode call site that detect overflow in dummy b instruction.
+ * 2) overflow handler can decode dummy b, and get call site.
+ * 3) "(call site + 4) == strex" is always true.
+ * 4) the handler can get counter address via decoding strex.
+ */
+#define REFCOUNT_TRIGGER_BKPT \
+	__inst_arm(REFCOUNT_ARM_BKPT_INSTR) \
+"	b	22b\n"
+
+/* If bkpt is triggered, skip strex routines after handling overflow */
+#define REFCOUNT_CHECK_TAIL \
+"	strex	%1, %0, [%3]\n" \
+"	teq	%1, #0\n" \
+"	bne	1b\n" \
+"	.subsection	1\n" \
+"33:\n" \
+	REFCOUNT_TRIGGER_BKPT \
+"	.previous\n"
+
+#define REFCOUNT_POST_CHECK_NEG \
+"22:	bmi	  33f\n" \
+	REFCOUNT_CHECK_TAIL
+
+#define REFCOUNT_POST_CHECK_NEG_OR_ZERO \
+"	beq	33f\n" \
+	REFCOUNT_POST_CHECK_NEG
+
+#define REFCOUNT_SMP_MB smp_mb()
+#define REFCOUNT_SMP_NONE_MB
+
+#define REFCOUNT_OP(op, c_op, asm_op, post, mb) \
+static inline int __refcount_##op(int i, atomic_t *v) \
+{ \
+	unsigned long tmp; \
+	int result; \
+\
+	REFCOUNT_SMP_ ## mb; \
+	prefetchw(&v->counter); \
+	__asm__ __volatile__("@ __refcount_" #op "\n" \
+"1:	ldrex	%0, [%3]\n" \
+"	" #asm_op "	%0, %0, %4\n" \
+	REFCOUNT_POST_CHECK_ ## post \
+	: "=&r" (result), "=&r" (tmp), "+Qo" (v->counter) \
+	: "r" (&v->counter), "Ir" (i) \
+	: "cc"); \
+\
+	REFCOUNT_SMP_ ## mb; \
+	return result; \
+} \
+
+REFCOUNT_OP(add_lt, +=, adds, NEG_OR_ZERO, NONE_MB);
+REFCOUNT_OP(sub_lt, -=, subs, NEG, MB);
+REFCOUNT_OP(sub_le, -=, subs, NEG_OR_ZERO, NONE_MB);
+
+static inline int __refcount_add_not_zero(int i, atomic_t *v)
+{
+	unsigned long tmp;
+	int result;
+
+	prefetchw(&v->counter);
+	__asm__ __volatile__("@ __refcount_add_not_zero\n"
+"1:	ldrex	%0, [%3]\n"
+"	teq		%0, #0\n"
+"	beq		2f\n"
+"	adds	%0, %0,	%4\n"
+	REFCOUNT_POST_CHECK_NEG
+"2:"
+	: "=&r" (result), "=&r" (tmp), "+Qo" (v->counter)
+	: "r" (&v->counter), "Ir" (i)
+	: "cc");
+
+	return result;
+}
+
+#endif /* CONFIG_ARCH_HAS_REFCOUNT */
+
 /*
  * ARMv6 UP and SMP safe atomic ops.  We use load exclusive and
  * store exclusive to ensure that these are atomic.  We may loop
diff --git a/arch/arm/include/asm/refcount.h b/arch/arm/include/asm/refcount.h
new file mode 100644
index 0000000..300a2d5
--- /dev/null
+++ b/arch/arm/include/asm/refcount.h
@@ -0,0 +1,55 @@
+/*
+ * arm-specific implementation of refcount_t. Based on x86 version and
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
+								refcount_t *r)
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
+								refcount_t *r)
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
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index 5cf0488..a309215 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -795,8 +795,52 @@ void abort(void)
 }
 EXPORT_SYMBOL(abort);
 
+#ifdef CONFIG_ARCH_HAS_REFCOUNT
+
+static int refcount_overflow_handler(struct pt_regs *regs, unsigned int instr)
+{
+	u32 dummy_b = le32_to_cpup((__le32 *)(regs->ARM_pc + 4));
+	u32 strex;
+	u32 rt;
+	bool zero = regs->ARM_cpsr & PSR_Z_BIT;
+
+	/* point pc to the branch instruction that detected the overflow */
+	regs->ARM_pc += 4 + (((s32)dummy_b << 8) >> 6) + 8;
+
+	/* decode strex to set refcount */
+	strex = le32_to_cpup((__le32 *)(regs->ARM_pc + 4));
+	rt = (strex << 12) >> 28;
+
+	/* unconditionally saturate the refcount */
+	*(int *)regs->uregs[rt] = INT_MIN / 2;
+
+	/* report error */
+	refcount_error_report(regs, zero ? "hit zero" : "overflow");
+
+	/* advance pc and proceed, skip "strex" routine */
+	regs->ARM_pc += 16;
+	return 0;
+}
+
+static struct undef_hook refcount_break_hook = {
+	.instr_mask	= 0xffffffff,
+	.instr_val	= REFCOUNT_ARM_BKPT_INSTR,
+	.cpsr_mask	= 0,
+	.cpsr_val	= 0,
+	.fn		= refcount_overflow_handler,
+};
+
+#define register_refcount_break_hook() register_undef_hook(&refcount_break_hook)
+
+#else /* !CONFIG_ARCH_HAS_REFCOUNT */
+
+#define register_refcount_break_hook()
+
+#endif /* CONFIG_ARCH_HAS_REFCOUNT */
+
 void __init trap_init(void)
 {
+	register_refcount_break_hook();
 	return;
 }
 
-- 
1.9.1
