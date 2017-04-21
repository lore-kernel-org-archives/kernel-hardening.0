Date: Fri, 21 Apr 2017 15:09:39 -0700
From: Kees Cook <keescook@chromium.org>
Message-ID: <20170421220939.GA65363@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [PATCH] x86/refcount: Implement fast refcount_t handling
To: linux-kernel@vger.kernel.org
Cc: Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, x86@kernel.org, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Jann Horn <jann@thejh.net>, davem@davemloft.net, linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, PaX Team <pageexec@freemail.hu>
List-ID: <kernel-hardening.lists.openwall.com>

This patch ports the x86-specific atomic overflow handling from PaX's
PAX_REFCOUNT to the upstream refcount_t API. This is an updated version
from PaX that eliminates the saturation race condition by resetting the
atomic counter back to the INT_MAX saturation value on both overflow and
underflow. To win a race, a system would have to have INT_MAX threads
simultaneously overflow before the saturation handler runs.

With this, the commonly used inc/dec_and_test usage patterns present
in performance-sensitive areas of the kernel (mm, net, block) will
use the regular inline atomic operations with only a single overflow
test instruction added to the fast path.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/Kconfig                       |  19 ++++++
 arch/x86/Kconfig                   |   1 +
 arch/x86/entry/entry_32.S          |   9 +++
 arch/x86/entry/entry_64.S          |   3 +
 arch/x86/include/asm/irq_vectors.h |   3 +
 arch/x86/include/asm/refcount.h    | 123 +++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/traps.h       |   5 ++
 arch/x86/kernel/traps.c            |  38 ++++++++++++
 drivers/misc/lkdtm_bugs.c          |  19 ++++--
 include/asm-generic/sections.h     |   4 ++
 include/asm-generic/vmlinux.lds.h  |   9 +++
 include/linux/kernel.h             |   2 +
 include/linux/refcount.h           |   4 ++
 kernel/panic.c                     |  23 +++++++
 lib/refcount.c                     |   6 +-
 15 files changed, 263 insertions(+), 5 deletions(-)
 create mode 100644 arch/x86/include/asm/refcount.h

diff --git a/arch/Kconfig b/arch/Kconfig
index cd211a14a88f..2cd150f03175 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -847,4 +847,23 @@ config STRICT_MODULE_RWX
 config ARCH_WANT_RELAX_ORDER
 	bool
 
+config ARCH_HAS_FAST_REFCOUNT
+	bool
+	help
+	  An architecture selects this when it has implemented refcount_t
+	  using primitizes that provide a faster runtime at the expense
+	  of some refcount state checks. The refcount overflow condition,
+	  however, must be retained. Catching overflows is the primary
+	  security concern for protecting against bugs in reference counts.
+
+config FAST_REFCOUNT
+	bool "Speed up reference counting at the expense of full validation"
+	depends on ARCH_HAS_FAST_REFCOUNT
+	help
+	  The regular reference counting infrastructure in the kernel checks
+	  many error conditions. If this option is selected, refcounting
+	  is made faster using architecture-specific implementions that may
+	  only check for reference count overflows (which is the primary
+	  way reference counting bugs are turned into security exploits).
+
 source "kernel/gcov/Kconfig"
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cc98d5a294ee..a13db97e0d71 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -50,6 +50,7 @@ config X86
 	select ARCH_HAS_DEVMEM_IS_ALLOWED
 	select ARCH_HAS_ELF_RANDOMIZE
 	select ARCH_HAS_FAST_MULTIPLIER
+	select ARCH_HAS_FAST_REFCOUNT
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_KCOV			if X86_64
 	select ARCH_HAS_MMIO_FLUSH
diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index 57f7ec35216e..9e8d9e2d70bf 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -792,6 +792,15 @@ ENTRY(spurious_interrupt_bug)
 	jmp	common_exception
 END(spurious_interrupt_bug)
 
+#ifdef CONFIG_FAST_REFCOUNT
+ENTRY(refcount_error)
+	ASM_CLAC
+	pushl   $0
+	pushl   $do_refcount_error
+	jmp     error_code
+ENDPROC(refcount_error)
+#endif
+
 #ifdef CONFIG_XEN
 ENTRY(xen_hypervisor_callback)
 	pushl	$-1				/* orig_ax = -1 => not a system call */
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 044d18ebc43c..a736b882ec76 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -858,6 +858,9 @@ idtentry coprocessor_error		do_coprocessor_error		has_error_code=0
 idtentry alignment_check		do_alignment_check		has_error_code=1
 idtentry simd_coprocessor_error		do_simd_coprocessor_error	has_error_code=0
 
+#ifdef CONFIG_FAST_REFCOUNT
+idtentry refcount_error			do_refcount_error		has_error_code=0
+#endif
 
 	/*
 	 * Reload gs selector with exception handling
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 6ca9fd6234e1..64ca4dcc29ec 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -48,6 +48,9 @@
 
 #define IA32_SYSCALL_VECTOR		0x80
 
+/* Refcount Overflow or Underflow Exception. */
+#define X86_REFCOUNT_VECTOR		0x81
+
 /*
  * Vectors 0x30-0x3f are used for ISA interrupts.
  *   round up to the next 16-vector boundary
diff --git a/arch/x86/include/asm/refcount.h b/arch/x86/include/asm/refcount.h
new file mode 100644
index 000000000000..79e35981e42f
--- /dev/null
+++ b/arch/x86/include/asm/refcount.h
@@ -0,0 +1,123 @@
+#ifndef __ASM_X86_REFCOUNT_H
+#define __ASM_X86_REFCOUNT_H
+/*
+ * x86-specific implementation of refcount_t. Ported from PAX_REFCOUNT in
+ * PaX/grsecurity.
+ */
+#include <linux/refcount.h>
+#include <asm/irq_vectors.h>
+
+#define __REFCOUNT_CHECK(size)				\
+	"jo 111f\n"					\
+	".if "__stringify(size)" == 4\n\t"		\
+	".pushsection .text.refcount_overflow\n"	\
+	".elseif "__stringify(size)" == -4\n\t"		\
+	".pushsection .text.refcount_underflow\n"	\
+	".else\n"					\
+	".error \"invalid size\"\n"			\
+	".endif\n"					\
+	"111:\tlea %[counter],%%"_ASM_CX"\n\t"		\
+	"int $"__stringify(X86_REFCOUNT_VECTOR)"\n"	\
+	"222:\n\t"					\
+	".popsection\n"					\
+	"333:\n"					\
+	_ASM_EXTABLE(222b, 333b)
+
+#define REFCOUNT_CHECK_OVERFLOW(size)	__REFCOUNT_CHECK(size)
+#define REFCOUNT_CHECK_UNDERFLOW(size)	__REFCOUNT_CHECK(-(size))
+
+#if !defined(__GCC_ASM_FLAG_OUTPUTS__) && defined(CC_HAVE_ASM_GOTO)
+/* Use asm goto */
+#define __GEN_CHECKED_RMWcc(fullop, var, size, cc, ...)			\
+do {									\
+	asm_volatile_goto(fullop					\
+			"\n\t"__REFCOUNT_CHECK(size)			\
+			";j" #cc " %l[cc_label]"			\
+			: : [counter] "m" (var), ## __VA_ARGS__		\
+			: "memory", "cc", "cx" : cc_label);		\
+	return 0;							\
+cc_label:								\
+	return 1;							\
+} while (0)
+
+#define GEN_BINARY_CHECKED_RMWcc(op, var, size, vcon, val, arg0, cc)	\
+	__GEN_CHECKED_RMWcc(op " %1, " arg0, var, size, cc, vcon (val))
+
+#else /* defined(__GCC_ASM_FLAG_OUTPUTS__) || !defined(CC_HAVE_ASM_GOTO) */
+
+#define __GEN_CHECKED_RMWcc(fullop, var, size, cc, ...)			\
+do {									\
+	bool c;								\
+	asm volatile (fullop						\
+			"\n\t"__REFCOUNT_CHECK(size)			\
+			";" CC_SET(cc)					\
+			: [counter] "+m" (var), CC_OUT(cc) (c)		\
+			: __VA_ARGS__ : "memory", "cc", "cx");		\
+	return c != 0;							\
+} while (0)
+
+#define GEN_BINARY_CHECKED_RMWcc(op, var, size, vcon, val, arg0, cc)	\
+	__GEN_CHECKED_RMWcc(op " %2, " arg0, var, size, cc, vcon (val))
+
+#endif /* defined(__GCC_ASM_FLAG_OUTPUTS__) || !defined(CC_HAVE_ASM_GOTO) */
+
+#define GEN_UNARY_CHECKED_RMWcc(op, var, size, arg0, cc)		\
+	__GEN_CHECKED_RMWcc(op " " arg0, var, size, cc)
+
+static __always_inline void refcount_add(unsigned int i, refcount_t *r)
+{
+	asm volatile(LOCK_PREFIX "addl %1,%0\n\t"
+		REFCOUNT_CHECK_OVERFLOW(4)
+		: [counter] "+m" (r->refs.counter)
+		: "ir" (i)
+		: "cc", "cx");
+}
+
+static __always_inline void refcount_inc(refcount_t *r)
+{
+	asm volatile(LOCK_PREFIX "incl %0\n\t"
+		REFCOUNT_CHECK_OVERFLOW(4)
+		: [counter] "+m" (r->refs.counter)
+		: : "cc", "cx");
+}
+
+static __always_inline void refcount_dec(refcount_t *r)
+{
+	asm volatile(LOCK_PREFIX "decl %0\n\t"
+		REFCOUNT_CHECK_UNDERFLOW(4)
+		: [counter] "+m" (r->refs.counter)
+		: : "cc", "cx");
+}
+
+static __always_inline __must_check
+bool refcount_sub_and_test(unsigned int i, refcount_t *r)
+{
+	GEN_BINARY_CHECKED_RMWcc(LOCK_PREFIX "subl", r->refs.counter,
+				-4, "er", i, "%0", e);
+}
+
+static __always_inline __must_check bool refcount_dec_and_test(refcount_t *r)
+{
+	GEN_UNARY_CHECKED_RMWcc(LOCK_PREFIX "decl", r->refs.counter,
+				-4, "%0", e);
+}
+
+static __always_inline __must_check bool refcount_inc_not_zero(refcount_t *r)
+{
+	const int a = 1;
+	const int u = 0;
+	int c, old;
+
+	c = atomic_read(&(r->refs));
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = atomic_cmpxchg(&(r->refs), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != u;
+}
+
+#endif
diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 01fd0a7f48cd..e4d8db75d85e 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -38,6 +38,10 @@ asmlinkage void machine_check(void);
 #endif /* CONFIG_X86_MCE */
 asmlinkage void simd_coprocessor_error(void);
 
+#ifdef CONFIG_FAST_REFCOUNT
+asmlinkage void refcount_error(void);
+#endif
+
 #ifdef CONFIG_TRACING
 asmlinkage void trace_page_fault(void);
 #define trace_stack_segment stack_segment
@@ -54,6 +58,7 @@ asmlinkage void trace_page_fault(void);
 #define trace_alignment_check alignment_check
 #define trace_simd_coprocessor_error simd_coprocessor_error
 #define trace_async_page_fault async_page_fault
+#define trace_refcount_error refcount_error
 #endif
 
 dotraplinkage void do_divide_error(struct pt_regs *, long);
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 4e496379a871..999d324119c0 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -192,6 +192,13 @@ do_trap_no_signal(struct task_struct *tsk, int trapnr, char *str,
 			tsk->thread.trap_nr = trapnr;
 			die(str, regs, error_code);
 		}
+
+#ifdef CONFIG_FAST_REFCOUNT
+		if (trapnr == X86_REFCOUNT_VECTOR) {
+			regs->ip -= 2;	/* sizeof(int $xx) */
+			refcount_error_report(regs, str);
+		}
+#endif
 		return 0;
 	}
 
@@ -308,6 +315,32 @@ __visible void __noreturn handle_stack_overflow(const char *message,
 }
 #endif
 
+#ifdef CONFIG_FAST_REFCOUNT
+
+dotraplinkage void do_refcount_error(struct pt_regs *regs, long error_code)
+{
+	const char *str = NULL;
+
+	BUG_ON(!(regs->flags & X86_EFLAGS_OF));
+
+#define range_check(size, direction, type, value) \
+	if ((unsigned long)__##size##_##direction##_start <= regs->ip && \
+	    regs->ip < (unsigned long)__##size##_##direction##_end) { \
+		*(type *)regs->cx = value; \
+		str = #size " " #direction; \
+	}
+
+	range_check(refcount,   overflow,  int, INT_MAX)
+	range_check(refcount,   underflow, int, INT_MIN)
+
+#undef range_check
+
+	BUG_ON(!str);
+	do_error_trap(regs, error_code, (char *)str, X86_REFCOUNT_VECTOR,
+		      SIGILL);
+}
+#endif
+
 #ifdef CONFIG_X86_64
 /* Runs on IST stack */
 dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
@@ -983,6 +1016,11 @@ void __init trap_init(void)
 	set_bit(IA32_SYSCALL_VECTOR, used_vectors);
 #endif
 
+#ifdef CONFIG_FAST_REFCOUNT
+	set_intr_gate(X86_REFCOUNT_VECTOR, refcount_error);
+	set_bit(X86_REFCOUNT_VECTOR, used_vectors);
+#endif
+
 	/*
 	 * Set the IDT descriptor to a fixed read-only location, so that the
 	 * "sidt" instruction will not leak the location of the kernel, and
diff --git a/drivers/misc/lkdtm_bugs.c b/drivers/misc/lkdtm_bugs.c
index e3f4cd8876b5..1bdafb29b802 100644
--- a/drivers/misc/lkdtm_bugs.c
+++ b/drivers/misc/lkdtm_bugs.c
@@ -135,9 +135,15 @@ void lkdtm_HUNG_TASK(void)
 	schedule();
 }
 
+#ifdef CONFIG_FAST_REFCOUNT
+#define REFCOUNT_MAX	INT_MAX
+#else
+#define REFCOUNT_MAX	UINT_MAX
+#endif
+
 void lkdtm_REFCOUNT_SATURATE_INC(void)
 {
-	refcount_t over = REFCOUNT_INIT(UINT_MAX - 1);
+	refcount_t over = REFCOUNT_INIT(REFCOUNT_MAX - 1);
 
 	pr_info("attempting good refcount decrement\n");
 	refcount_dec(&over);
@@ -146,7 +152,7 @@ void lkdtm_REFCOUNT_SATURATE_INC(void)
 	pr_info("attempting bad refcount inc overflow\n");
 	refcount_inc(&over);
 	refcount_inc(&over);
-	if (refcount_read(&over) == UINT_MAX)
+	if (refcount_read(&over) == REFCOUNT_MAX)
 		pr_err("Correctly stayed saturated, but no BUG?!\n");
 	else
 		pr_err("Fail: refcount wrapped\n");
@@ -154,7 +160,7 @@ void lkdtm_REFCOUNT_SATURATE_INC(void)
 
 void lkdtm_REFCOUNT_SATURATE_ADD(void)
 {
-	refcount_t over = REFCOUNT_INIT(UINT_MAX - 1);
+	refcount_t over = REFCOUNT_INIT(REFCOUNT_MAX - 1);
 
 	pr_info("attempting good refcount decrement\n");
 	refcount_dec(&over);
@@ -162,7 +168,7 @@ void lkdtm_REFCOUNT_SATURATE_ADD(void)
 
 	pr_info("attempting bad refcount add overflow\n");
 	refcount_add(2, &over);
-	if (refcount_read(&over) == UINT_MAX)
+	if (refcount_read(&over) == REFCOUNT_MAX)
 		pr_err("Correctly stayed saturated, but no BUG?!\n");
 	else
 		pr_err("Fail: refcount wrapped\n");
@@ -178,6 +184,11 @@ void lkdtm_REFCOUNT_ZERO_DEC(void)
 		pr_err("Stayed at zero, but no BUG?!\n");
 	else
 		pr_err("Fail: refcount went crazy\n");
+
+	pr_info("attempting bad refcount decrement past INT_MIN\n");
+	atomic_set(&zero.refs, INT_MIN);
+	refcount_dec(&zero);
+	pr_err("Fail: wrap not detected\n");
 }
 
 void lkdtm_REFCOUNT_ZERO_SUB(void)
diff --git a/include/asm-generic/sections.h b/include/asm-generic/sections.h
index 532372c6cf15..0590f384f234 100644
--- a/include/asm-generic/sections.h
+++ b/include/asm-generic/sections.h
@@ -20,6 +20,8 @@
  *                   may be out of this range on some architectures.
  * [_sinittext, _einittext]: contains .init.text.* sections
  * [__bss_start, __bss_stop]: contains BSS sections
+ * [__refcount_overflow/underflow_start, ..._end]: contains .text sections
+ *		     for refcount error handling.
  *
  * Following global variables are optional and may be unavailable on some
  * architectures and/or kernel configurations.
@@ -39,6 +41,8 @@ extern char __per_cpu_load[], __per_cpu_start[], __per_cpu_end[];
 extern char __kprobes_text_start[], __kprobes_text_end[];
 extern char __entry_text_start[], __entry_text_end[];
 extern char __start_rodata[], __end_rodata[];
+extern char __refcount_overflow_start[], __refcount_overflow_end[];
+extern char __refcount_underflow_start[], __refcount_underflow_end[];
 
 /* Start and end of .ctors section - used for constructor calls. */
 extern char __ctors_start[], __ctors_end[];
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 143db9c523e2..a04aae39e820 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -448,9 +448,18 @@
 		ALIGN_FUNCTION();					\
 		*(.text.hot .text .text.fixup .text.unlikely)		\
 		*(.ref.text)						\
+		REFCOUNT_TEXT						\
 	MEM_KEEP(init.text)						\
 	MEM_KEEP(exit.text)						\
 
+#define __REFCOUNT_TEXT(section)					\
+		VMLINUX_SYMBOL(__##section##_start) = .;                \
+		*(.text.##section)                                      \
+		VMLINUX_SYMBOL(__##section##_end) = .;
+
+#define REFCOUNT_TEXT							\
+	__REFCOUNT_TEXT(refcount_overflow)				\
+	__REFCOUNT_TEXT(refcount_underflow)
 
 /* sched.text is aling to function alignment to secure we have same
  * address even at second ld pass when generating System.map */
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 4c26dc3a8295..bc15822b24eb 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -275,6 +275,8 @@ extern int oops_may_print(void);
 void do_exit(long error_code) __noreturn;
 void complete_and_exit(struct completion *, long) __noreturn;
 
+void refcount_error_report(struct pt_regs *regs, const char *kind);
+
 /* Internal, do not use. */
 int __must_check _kstrtoul(const char *s, unsigned int base, unsigned long *res);
 int __must_check _kstrtol(const char *s, unsigned int base, long *res);
diff --git a/include/linux/refcount.h b/include/linux/refcount.h
index 0023fee4bbbc..fdb82bcaf975 100644
--- a/include/linux/refcount.h
+++ b/include/linux/refcount.h
@@ -22,6 +22,9 @@ static inline unsigned int refcount_read(const refcount_t *r)
 	return atomic_read(&r->refs);
 }
 
+#ifdef CONFIG_FAST_REFCOUNT
+#include <asm/refcount.h>
+#else
 extern __must_check bool refcount_add_not_zero(unsigned int i, refcount_t *r);
 extern void refcount_add(unsigned int i, refcount_t *r);
 
@@ -33,6 +36,7 @@ extern void refcount_sub(unsigned int i, refcount_t *r);
 
 extern __must_check bool refcount_dec_and_test(refcount_t *r);
 extern void refcount_dec(refcount_t *r);
+#endif
 
 extern __must_check bool refcount_dec_if_one(refcount_t *r);
 extern __must_check bool refcount_dec_not_one(refcount_t *r);
diff --git a/kernel/panic.c b/kernel/panic.c
index a58932b41700..a1745b60cc36 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -26,6 +26,7 @@
 #include <linux/nmi.h>
 #include <linux/console.h>
 #include <linux/bug.h>
+#include <linux/ratelimit.h>
 
 #define PANIC_TIMER_STEP 100
 #define PANIC_BLINK_SPD 18
@@ -601,6 +602,28 @@ EXPORT_SYMBOL(__stack_chk_fail);
 
 #endif
 
+#ifdef CONFIG_FAST_REFCOUNT
+static DEFINE_RATELIMIT_STATE(refcount_ratelimit, 15 * HZ, 3);
+
+void refcount_error_report(struct pt_regs *regs, const char *kind)
+{
+	do_send_sig_info(SIGKILL, SEND_SIG_FORCED, current, true);
+
+	if (!__ratelimit(&refcount_ratelimit))
+		return;
+
+	pr_emerg("%s detected in: %s:%d, uid/euid: %u/%u\n",
+		kind ? kind : "refcount error",
+		current->comm, task_pid_nr(current),
+		from_kuid_munged(&init_user_ns, current_uid()),
+		from_kuid_munged(&init_user_ns, current_euid()));
+	print_symbol(KERN_EMERG "refcount error occurred at: %s\n",
+		instruction_pointer(regs));
+	BUG();
+}
+EXPORT_SYMBOL(refcount_error_report);
+#endif
+
 core_param(panic, panic_timeout, int, 0644);
 core_param(pause_on_oops, pause_on_oops, int, 0644);
 core_param(panic_on_warn, panic_on_warn, int, 0644);
diff --git a/lib/refcount.c b/lib/refcount.c
index aa09ad3c30b0..903a59557893 100644
--- a/lib/refcount.c
+++ b/lib/refcount.c
@@ -37,6 +37,9 @@
 #include <linux/refcount.h>
 #include <linux/bug.h>
 
+/* Leave out architecture-specific implementations. */
+#ifndef CONFIG_FAST_REFCOUNT
+
 bool refcount_add_not_zero(unsigned int i, refcount_t *r)
 {
 	unsigned int old, new, val = atomic_read(&r->refs);
@@ -168,6 +171,8 @@ void refcount_dec(refcount_t *r)
 }
 EXPORT_SYMBOL_GPL(refcount_dec);
 
+#endif /* CONFIG_FAST_REFCOUNT */
+
 /*
  * No atomic_t counterpart, it attempts a 1 -> 0 transition and returns the
  * success thereof.
@@ -264,4 +269,3 @@ bool refcount_dec_and_lock(refcount_t *r, spinlock_t *lock)
 	return true;
 }
 EXPORT_SYMBOL_GPL(refcount_dec_and_lock);
-
-- 
2.7.4


-- 
Kees Cook
Pixel Security
