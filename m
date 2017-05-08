From: Kees Cook <keescook@chromium.org>
Date: Mon,  8 May 2017 12:32:52 -0700
Message-Id: <1494271972-140319-3-git-send-email-keescook@chromium.org>
In-Reply-To: <1494271972-140319-1-git-send-email-keescook@chromium.org>
References: <1494271972-140319-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v3 2/2] x86/refcount: Implement fast refcount overflow protection
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, PaX Team <pageexec@freemail.hu>, Jann Horn <jannh@google.com>, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

This protection is a modified version of the x86 PAX_REFCOUNT
implementation from PaX/grsecurity, prior to the use of named text
sections. This speeds up the refcount_t API by duplicating the existing
atomic_t implementation with a single instruction added to detect if the
refcount has wrapped past INT_MAX (or below 0) resulting in a signed
value. With this overflow protection, the use-after-free following a
refcount_t wrap is blocked from happening, avoiding the vulnerability
entirely.

While this defense only perfectly protects the overflow case, as that
can be detected and stopped before the reference is freed and left to be
abused by an attacker, it also notices some of the "inc from 0" and "below
0" cases. However, these only indicate that a use-after-free has already
happened. Such notifications are likely avoidable by an attacker that has
already exploited a use-after-free vulnerability, but it's better to have
them than allow such conditions to remain silent.

On overflow detection (actually "negative value" detection), the refcount
value is reset to INT_MAX, the offending process is killed, and a report
is generated. This allows the system to attempt to keep operating. Another
option, though not done in this patch, would be to reset the counter to
(INT_MIN / 2) to trap all future refcount inc or dec actions, but this
would result in even legitimate uses getting blocked. Yet another option
would be to choose (INT_MAX - N) with some small N to provide some
headroom for legitimate users of the reference counter.

On the matter of races, since the entire range beyond INT_MAX but before 0
is signed, every inc will trap, leaving no overflow-only race condition.

As for performance, this implementation adds a single "jns" instruction to
the regular execution flow of a copy of the regular atomic_t operations,
making this comparable to the existing atomic_t operations. The reporting
routine uses an interupt vector to trap to return back to C to do the
heavy lifting, to help keep the change in .text size minimal.

Various differences from PaX:
- based on earlier implementation prior to named text sections
- applied only to refcount_t, not atomic_t
- rebased to -next
- reorganized refcount error handler
- uses "jns" instead of "jno" to trap all negative results instead of
  just under/overflow transitions

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/Kconfig                       | 19 +++++++++
 arch/x86/Kconfig                   |  1 +
 arch/x86/entry/entry_32.S          |  9 +++++
 arch/x86/entry/entry_64.S          |  3 ++
 arch/x86/include/asm/irq_vectors.h |  3 ++
 arch/x86/include/asm/refcount.h    | 80 ++++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/traps.h       |  5 +++
 arch/x86/kernel/traps.c            | 16 +++++++-
 include/asm-generic/sections.h     |  4 ++
 include/asm-generic/vmlinux.lds.h  |  9 +++++
 include/linux/kernel.h             |  2 +
 include/linux/refcount.h           |  4 ++
 kernel/panic.c                     | 23 +++++++++++
 lib/refcount.c                     |  5 ++-
 14 files changed, 181 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/include/asm/refcount.h

diff --git a/arch/Kconfig b/arch/Kconfig
index 640999412d11..00ef4fa5513c 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -860,4 +860,23 @@ config STRICT_MODULE_RWX
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
+	  only check for reference count overflows (which is the most common
+	  way reference counting bugs are turned into security exploits).
+
 source "kernel/gcov/Kconfig"
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cd18994a9555..80855b250371 100644
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
index 50bc26949e9e..bba69761ec24 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -789,6 +789,15 @@ ENTRY(spurious_interrupt_bug)
 	jmp	common_exception
 END(spurious_interrupt_bug)
 
+#ifdef CONFIG_FAST_REFCOUNT
+ENTRY(refcount_error)
+	ASM_CLAC
+	pushl   $0
+	pushl   $do_refcount_error
+	jmp     common_exception
+ENDPROC(refcount_error)
+#endif
+
 #ifdef CONFIG_XEN
 ENTRY(xen_hypervisor_callback)
 	pushl	$-1				/* orig_ax = -1 => not a system call */
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 607d72c4a485..783045d3887c 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -855,6 +855,9 @@ idtentry coprocessor_error		do_coprocessor_error		has_error_code=0
 idtentry alignment_check		do_alignment_check		has_error_code=1
 idtentry simd_coprocessor_error		do_simd_coprocessor_error	has_error_code=0
 
+#ifdef CONFIG_FAST_REFCOUNT
+idtentry refcount_error			do_refcount_error		has_error_code=0
+#endif
 
 	/*
 	 * Reload gs selector with exception handling
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 6ca9fd6234e1..d11777618c26 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -48,6 +48,9 @@
 
 #define IA32_SYSCALL_VECTOR		0x80
 
+/* Refcount overflow reporting exception. */
+#define X86_REFCOUNT_VECTOR		0x81
+
 /*
  * Vectors 0x30-0x3f are used for ISA interrupts.
  *   round up to the next 16-vector boundary
diff --git a/arch/x86/include/asm/refcount.h b/arch/x86/include/asm/refcount.h
new file mode 100644
index 000000000000..6e8bbd72cabc
--- /dev/null
+++ b/arch/x86/include/asm/refcount.h
@@ -0,0 +1,80 @@
+#ifndef __ASM_X86_REFCOUNT_H
+#define __ASM_X86_REFCOUNT_H
+/*
+ * x86-specific implementation of refcount_t. Ported from PAX_REFCOUNT in
+ * PaX/grsecurity before the use of named text sections, and changed to use
+ * "jns" instead of "jno" to trap on all signed results, not just when
+ * overflowing.
+ */
+#include <linux/refcount.h>
+#include <asm/irq_vectors.h>
+
+#define REFCOUNT_EXCEPTION				\
+	"movl $0x7fffffff, %[counter]\n\t"		\
+	"int $"__stringify(X86_REFCOUNT_VECTOR)"\n"	\
+	"0:\n\t"					\
+	_ASM_EXTABLE(0b, 0b)
+
+#define REFCOUNT_CHECK					\
+	"jns 0f\n\t"					\
+	REFCOUNT_EXCEPTION
+
+static __always_inline void refcount_add(unsigned int i, refcount_t *r)
+{
+	asm volatile(LOCK_PREFIX "addl %1,%0\n\t"
+		REFCOUNT_CHECK
+		: [counter] "+m" (r->refs.counter)
+		: "ir" (i)
+		: "cc", "cx");
+}
+
+static __always_inline void refcount_inc(refcount_t *r)
+{
+	asm volatile(LOCK_PREFIX "incl %0\n\t"
+		REFCOUNT_CHECK
+		: [counter] "+m" (r->refs.counter)
+		: : "cc", "cx");
+}
+
+static __always_inline void refcount_dec(refcount_t *r)
+{
+	asm volatile(LOCK_PREFIX "decl %0\n\t"
+		REFCOUNT_CHECK
+		: [counter] "+m" (r->refs.counter)
+		: : "cc", "cx");
+}
+
+static __always_inline __must_check
+bool refcount_sub_and_test(unsigned int i, refcount_t *r)
+{
+	GEN_BINARY_SUFFIXED_RMWcc(LOCK_PREFIX "subl", REFCOUNT_CHECK,
+				  r->refs.counter, "er", i, "%0", e);
+}
+
+static __always_inline __must_check bool refcount_dec_and_test(refcount_t *r)
+{
+	GEN_UNARY_SUFFIXED_RMWcc(LOCK_PREFIX "decl", REFCOUNT_CHECK,
+				 r->refs.counter, "%0", e);
+}
+
+static __always_inline __must_check bool refcount_inc_not_zero(refcount_t *r)
+{
+	int c;
+
+	c = atomic_read(&(r->refs));
+	do {
+		if (unlikely(c <= 0))
+			break;
+	} while (!atomic_try_cmpxchg(&(r->refs), &c, c + 1));
+
+	/* Did we start or finish in an undesirable state? */
+	if (unlikely(c <= 0 || c + 1 < 0)) {
+		asm volatile(REFCOUNT_EXCEPTION
+			: : [counter] "m" (r->refs.counter)
+			: "cc", "cx");
+	}
+
+	return c != 0;
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
index 3995d3a777d4..0b2dbcc001d6 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -218,8 +218,13 @@ do_trap_no_signal(struct task_struct *tsk, int trapnr, char *str,
 	}
 
 	if (!user_mode(regs)) {
-		if (fixup_exception(regs, trapnr))
+		if (fixup_exception(regs, trapnr)) {
+			if (IS_ENABLED(CONFIG_FAST_REFCOUNT) &&
+			    trapnr == X86_REFCOUNT_VECTOR)
+				refcount_error_report(regs, str);
+
 			return 0;
+		}
 
 		if (fixup_bug(regs, trapnr))
 			return 0;
@@ -327,6 +332,10 @@ DO_ERROR(X86_TRAP_NP,     SIGBUS,  "segment not present",	segment_not_present)
 DO_ERROR(X86_TRAP_SS,     SIGBUS,  "stack segment",		stack_segment)
 DO_ERROR(X86_TRAP_AC,     SIGBUS,  "alignment check",		alignment_check)
 
+#ifdef CONFIG_FAST_REFCOUNT
+DO_ERROR(X86_REFCOUNT_VECTOR, SIGILL, "refcount overflow",	refcount_error)
+#endif
+
 #ifdef CONFIG_VMAP_STACK
 __visible void __noreturn handle_stack_overflow(const char *message,
 						struct pt_regs *regs,
@@ -1017,6 +1026,11 @@ void __init trap_init(void)
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
index 3558f4eb1a86..2f2f34942689 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -446,9 +446,18 @@
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
index 13bc08aba704..94f87d5642e4 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -276,6 +276,8 @@ extern int oops_may_print(void);
 void do_exit(long error_code) __noreturn;
 void complete_and_exit(struct completion *, long) __noreturn;
 
+void refcount_error_report(struct pt_regs *regs, const char *kind);
+
 /* Internal, do not use. */
 int __must_check _kstrtoul(const char *s, unsigned int base, unsigned long *res);
 int __must_check _kstrtol(const char *s, unsigned int base, long *res);
diff --git a/include/linux/refcount.h b/include/linux/refcount.h
index b34aa649d204..d09ad4e91e55 100644
--- a/include/linux/refcount.h
+++ b/include/linux/refcount.h
@@ -41,6 +41,9 @@ static inline unsigned int refcount_read(const refcount_t *r)
 	return atomic_read(&r->refs);
 }
 
+#ifdef CONFIG_FAST_REFCOUNT
+#include <asm/refcount.h>
+#else
 extern __must_check bool refcount_add_not_zero(unsigned int i, refcount_t *r);
 extern void refcount_add(unsigned int i, refcount_t *r);
 
@@ -52,6 +55,7 @@ extern void refcount_sub(unsigned int i, refcount_t *r);
 
 extern __must_check bool refcount_dec_and_test(refcount_t *r);
 extern void refcount_dec(refcount_t *r);
+#endif
 
 extern __must_check bool refcount_dec_if_one(refcount_t *r);
 extern __must_check bool refcount_dec_not_one(refcount_t *r);
diff --git a/kernel/panic.c b/kernel/panic.c
index a58932b41700..c95b9194bd7c 100644
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
+	/* Always make sure triggering process will be terminated. */
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
+	show_regs(regs);
+}
+#endif
+
 core_param(panic, panic_timeout, int, 0644);
 core_param(pause_on_oops, pause_on_oops, int, 0644);
 core_param(panic_on_warn, panic_on_warn, int, 0644);
diff --git a/lib/refcount.c b/lib/refcount.c
index 9f906783987e..2bf6d1a8cfa5 100644
--- a/lib/refcount.c
+++ b/lib/refcount.c
@@ -37,6 +37,9 @@
 #include <linux/refcount.h>
 #include <linux/bug.h>
 
+/* Leave out architecture-specific implementations. */
+#ifndef CONFIG_FAST_REFCOUNT
+
 /**
  * refcount_add_not_zero - add a value to a refcount unless it is 0
  * @i: the value to add to the refcount
@@ -225,6 +228,7 @@ void refcount_dec(refcount_t *r)
 	WARN_ONCE(refcount_dec_and_test(r), "refcount_t: decrement hit 0; leaking memory.\n");
 }
 EXPORT_SYMBOL(refcount_dec);
+#endif /* CONFIG_FAST_REFCOUNT */
 
 /**
  * refcount_dec_if_one - decrement a refcount if it is 1
@@ -345,4 +349,3 @@ bool refcount_dec_and_lock(refcount_t *r, spinlock_t *lock)
 	return true;
 }
 EXPORT_SYMBOL(refcount_dec_and_lock);
-
-- 
2.7.4
