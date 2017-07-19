From: Kees Cook <keescook@chromium.org>
Date: Tue, 18 Jul 2017 17:03:34 -0700
Message-Id: <1500422614-94821-3-git-send-email-keescook@chromium.org>
In-Reply-To: <1500422614-94821-1-git-send-email-keescook@chromium.org>
References: <1500422614-94821-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v6 2/2] x86/refcount: Implement fast refcount overflow protection
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Christoph Hellwig <hch@infradead.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, Eric Biggers <ebiggers3@gmail.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, Greg KH <gregkh@linuxfoundation.org>, Alexey Dobriyan <adobriyan@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, arozansk@redhat.com, Davidlohr Bueso <dave@stgolabs.net>, Manfred Spraul <manfred@colorfullife.com>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, "x86@kernel.org" <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

This implements refcount_t overflow protection on x86 without a noticeable
performance impact, though without the fuller checking of REFCOUNT_FULL.
This is done by duplicating the existing atomic_t refcount implementation
but with normally a single instruction added to detect if the refcount
has gone negative (i.e. wrapped past INT_MAX or below zero). When
detected, the handler saturates the refcount_t to INT_MIN / 2. With this
overflow protection, the erroneous reference release that would follow
a wrap back to zero is blocked from happening, avoiding the class of
refcount-over-increment use-after-free vulnerabilities entirely.

Only the overflow case of refcounting can be perfectly protected, since it
can be detected and stopped before the reference is freed and left to be
abused by an attacker. This implementation also notices some of the "dec
to 0 without test", and "below 0" cases. However, these only indicate that
a use-after-free may have already happened. Such notifications are likely
avoidable by an attacker that has already exploited a use-after-free
vulnerability, but it's better to have them than allow such conditions to
remain universally silent.

On first overflow detection, the refcount value is reset to INT_MIN / 2
(which serves as a saturation value), the offending process is killed,
and a report and stack trace are produced. When operations detect only
negative value results (such as changing an already saturated value),
saturation still happens but no notification is performed (since the
value was already saturated).

On the matter of races, since the entire range beyond INT_MAX but before
0 is negative, every operation at INT_MIN / 2 will trap, leaving no
overflow-only race condition.

As for performance, this implementation adds a single "js" instruction
to the regular execution flow of a copy of the standard atomic_t refcount
operations. (The non-"and_test" refcount_dec() function, which is uncommon
in regular refcount design patterns, has an additional "jz" instruction
to detect reaching exactly zero.) Since this is a forward jump, it is by
default the non-predicted path, which will be reinforced by dynamic branch
prediction. The result is this protection having virtually no measurable
change in performance over standard atomic_t operations. The error path,
located in .text.unlikely, saves the refcount location and then uses UD0
to fire a refcount exception handler, which resets the refcount, handles
reporting, and returns to regular execution. This keeps the changes to
.text size minimal, avoiding return jumps and open-coded calls to the
error reporting routine.

Example assembly comparison:

refcount_inc before
.text:
ffffffff81546149:       f0 ff 45 f4             lock incl -0xc(%rbp)

refcount_inc after
.text:
ffffffff81546149:       f0 ff 45 f4             lock incl -0xc(%rbp)
ffffffff8154614d:       0f 88 80 d5 17 00       js     ffffffff816c36d3
...
.text.unlikely:
ffffffff816c36d3:       48 8d 4d f4             lea    -0xc(%rbp),%rcx
ffffffff816c36d7:       0f ff                   (bad)

This protection is a modified version of the x86 PAX_REFCOUNT defense
from the last public patch of PaX/grsecurity, based on my understanding of
the code. Changes or omissions from the original code are mine and don't
reflect the original grsecurity/PaX code. Thanks to PaX Team for various
suggestions for improvement.

Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 arch/Kconfig                    |   9 ++++
 arch/x86/Kconfig                |   1 +
 arch/x86/include/asm/asm.h      |   6 +++
 arch/x86/include/asm/refcount.h | 105 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/mm/extable.c           |  37 ++++++++++++++
 include/linux/kernel.h          |   6 +++
 include/linux/refcount.h        |   4 ++
 kernel/panic.c                  |  22 +++++++++
 8 files changed, 190 insertions(+)
 create mode 100644 arch/x86/include/asm/refcount.h

diff --git a/arch/Kconfig b/arch/Kconfig
index 21d0089117fe..349185f951cd 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -931,6 +931,15 @@ config STRICT_MODULE_RWX
 config ARCH_WANT_RELAX_ORDER
 	bool
 
+config ARCH_HAS_REFCOUNT
+	bool
+	help
+	  An architecture selects this when it has implemented refcount_t
+	  using primitizes that provide a faster runtime at the expense
+	  of some full refcount state checks. The refcount overflow condition,
+	  however, must be retained. Catching overflows is the primary
+	  security concern for protecting against bugs in reference counts.
+
 config REFCOUNT_FULL
 	bool "Perform full reference count validation at the expense of speed"
 	help
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 781521b7cf9e..73574c91e857 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -55,6 +55,7 @@ config X86
 	select ARCH_HAS_KCOV			if X86_64
 	select ARCH_HAS_MMIO_FLUSH
 	select ARCH_HAS_PMEM_API		if X86_64
+	select ARCH_HAS_REFCOUNT
 	select ARCH_HAS_UACCESS_FLUSHCACHE	if X86_64
 	select ARCH_HAS_SET_MEMORY
 	select ARCH_HAS_SG_CHAIN
diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
index 7a9df3beb89b..676ee5807d86 100644
--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
@@ -74,6 +74,9 @@
 # define _ASM_EXTABLE_EX(from, to)				\
 	_ASM_EXTABLE_HANDLE(from, to, ex_handler_ext)
 
+# define _ASM_EXTABLE_REFCOUNT(from, to)			\
+	_ASM_EXTABLE_HANDLE(from, to, ex_handler_refcount)
+
 # define _ASM_NOKPROBE(entry)					\
 	.pushsection "_kprobe_blacklist","aw" ;			\
 	_ASM_ALIGN ;						\
@@ -123,6 +126,9 @@
 # define _ASM_EXTABLE_EX(from, to)				\
 	_ASM_EXTABLE_HANDLE(from, to, ex_handler_ext)
 
+# define _ASM_EXTABLE_REFCOUNT(from, to)			\
+	_ASM_EXTABLE_HANDLE(from, to, ex_handler_refcount)
+
 /* For C file, we already have NOKPROBE_SYMBOL macro */
 #endif
 
diff --git a/arch/x86/include/asm/refcount.h b/arch/x86/include/asm/refcount.h
new file mode 100644
index 000000000000..13b91e850a02
--- /dev/null
+++ b/arch/x86/include/asm/refcount.h
@@ -0,0 +1,105 @@
+#ifndef __ASM_X86_REFCOUNT_H
+#define __ASM_X86_REFCOUNT_H
+/*
+ * x86-specific implementation of refcount_t. Based on PAX_REFCOUNT from
+ * PaX/grsecurity.
+ */
+#include <linux/refcount.h>
+
+/*
+ * Body of refcount error handling: in .text.unlikely, saved into CX the
+ * address of the refcount that has entered a bad state, and trigger an
+ * exception. Fixup address is back in regular execution flow in .text.
+ */
+#define _REFCOUNT_EXCEPTION				\
+	".pushsection .text.unlikely\n"			\
+	"111:\tlea %[counter], %%" _ASM_CX "\n"		\
+	"112:\t" ASM_UD0 "\n"				\
+	".popsection\n"					\
+	"113:\n"					\
+	_ASM_EXTABLE_REFCOUNT(112b, 113b)
+
+/* Trigger refcount exception if refcount result is negative. */
+#define REFCOUNT_CHECK_LT_ZERO				\
+	"js 111f\n\t"					\
+	_REFCOUNT_EXCEPTION
+
+/* Trigger refcount exception if refcount result is zero or negative. */
+#define REFCOUNT_CHECK_LE_ZERO				\
+	"jz 111f\n\t"					\
+	REFCOUNT_CHECK_LT_ZERO
+
+/* Trigger refcount exception unconditionally. */
+#define REFCOUNT_ERROR					\
+	"jmp 111f\n\t"					\
+	_REFCOUNT_EXCEPTION
+
+static __always_inline void refcount_add(unsigned int i, refcount_t *r)
+{
+	asm volatile(LOCK_PREFIX "addl %1,%0\n\t"
+		REFCOUNT_CHECK_LT_ZERO
+		: [counter] "+m" (r->refs.counter)
+		: "ir" (i)
+		: "cc", "cx");
+}
+
+static __always_inline void refcount_inc(refcount_t *r)
+{
+	asm volatile(LOCK_PREFIX "incl %0\n\t"
+		REFCOUNT_CHECK_LT_ZERO
+		: [counter] "+m" (r->refs.counter)
+		: : "cc", "cx");
+}
+
+static __always_inline void refcount_dec(refcount_t *r)
+{
+	asm volatile(LOCK_PREFIX "decl %0\n\t"
+		REFCOUNT_CHECK_LE_ZERO
+		: [counter] "+m" (r->refs.counter)
+		: : "cc", "cx");
+}
+
+static __always_inline __must_check
+bool refcount_sub_and_test(unsigned int i, refcount_t *r)
+{
+	GEN_BINARY_SUFFIXED_RMWcc(LOCK_PREFIX "subl", REFCOUNT_CHECK_LT_ZERO,
+				  r->refs.counter, "er", i, "%0", e);
+}
+
+static __always_inline __must_check bool refcount_dec_and_test(refcount_t *r)
+{
+	GEN_UNARY_SUFFIXED_RMWcc(LOCK_PREFIX "decl", REFCOUNT_CHECK_LT_ZERO,
+				 r->refs.counter, "%0", e);
+}
+
+static __always_inline __must_check
+bool refcount_add_not_zero(unsigned int i, refcount_t *r)
+{
+	int c, result;
+
+	c = atomic_read(&(r->refs));
+	do {
+		if (unlikely(c == 0))
+			return false;
+
+		result = c + i;
+
+		/* Did we try to increment from/to an undesirable state? */
+		if (unlikely(c < 0 || c == INT_MAX || result < c)) {
+			asm volatile(REFCOUNT_ERROR
+				     : : [counter] "m" (r->refs.counter)
+				     : "cc", "cx");
+			break;
+		}
+
+	} while (!atomic_try_cmpxchg(&(r->refs), &c, result));
+
+	return c != 0;
+}
+
+static __always_inline __must_check bool refcount_inc_not_zero(refcount_t *r)
+{
+	return refcount_add_not_zero(1, r);
+}
+
+#endif
diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
index 0ea8afcb929c..62f71aad0403 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -36,6 +36,43 @@ bool ex_handler_fault(const struct exception_table_entry *fixup,
 }
 EXPORT_SYMBOL_GPL(ex_handler_fault);
 
+/*
+ * Handler for UD0 exception following a failed test against the
+ * result of a refcount inc/dec/add/sub.
+ */
+bool ex_handler_refcount(const struct exception_table_entry *fixup,
+			 struct pt_regs *regs, int trapnr)
+{
+	bool report = false;
+
+	/*
+	 * If we crossed from INT_MAX to INT_MIN or from -1 to 0, the OF
+	 * flag (result wrapped around) will be set. Additionally, going
+	 * from 1 to 0 will set the ZF flag. In each of these cases we
+	 * will kill the process, since it is the first to trigger the
+	 * condition from an unsaturated state.
+	 */
+	if (regs->flags & (X86_EFLAGS_OF | X86_EFLAGS_ZF))
+		report = true;
+	*(int *)regs->cx = INT_MIN / 2;
+
+	/*
+	 * Strictly speaking, this reports the fixup destination, not
+	 * the fault location, and not the actually overflowing
+	 * instruction, which is the instruction before the "js", but
+	 * since that instruction could be a variety of lengths, just
+	 * report the location after the overflow, which should be close
+	 * enough for finding the overflow, as it's at least back in
+	 * the function, having returned from .text.unlikely.
+	 */
+	regs->ip = ex_fixup_addr(fixup);
+	if (report)
+		refcount_error_report(regs);
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(ex_handler_refcount);
+
 bool ex_handler_ext(const struct exception_table_entry *fixup,
 		   struct pt_regs *regs, int trapnr)
 {
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index bd6d96cf80b1..02ac674e5ce4 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -277,6 +277,12 @@ extern int oops_may_print(void);
 void do_exit(long error_code) __noreturn;
 void complete_and_exit(struct completion *, long) __noreturn;
 
+#ifdef CONFIG_ARCH_HAS_REFCOUNT
+void refcount_error_report(struct pt_regs *regs);
+#else
+static inline void refcount_error_report(struct pt_regs *regs) { }
+#endif
+
 /* Internal, do not use. */
 int __must_check _kstrtoul(const char *s, unsigned int base, unsigned long *res);
 int __must_check _kstrtol(const char *s, unsigned int base, long *res);
diff --git a/include/linux/refcount.h b/include/linux/refcount.h
index 591792c8e5b0..48b7c9c68c4d 100644
--- a/include/linux/refcount.h
+++ b/include/linux/refcount.h
@@ -53,6 +53,9 @@ extern __must_check bool refcount_sub_and_test(unsigned int i, refcount_t *r);
 extern __must_check bool refcount_dec_and_test(refcount_t *r);
 extern void refcount_dec(refcount_t *r);
 #else
+# ifdef CONFIG_ARCH_HAS_REFCOUNT
+#  include <asm/refcount.h>
+# else
 static inline __must_check bool refcount_add_not_zero(unsigned int i, refcount_t *r)
 {
 	return atomic_add_unless(&r->refs, i, 0);
@@ -87,6 +90,7 @@ static inline void refcount_dec(refcount_t *r)
 {
 	atomic_dec(&r->refs);
 }
+# endif /* !CONFIG_ARCH_HAS_REFCOUNT */
 #endif /* CONFIG_REFCOUNT_FULL */
 
 extern __must_check bool refcount_dec_if_one(refcount_t *r);
diff --git a/kernel/panic.c b/kernel/panic.c
index a58932b41700..fb8576ce1638 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -26,6 +26,7 @@
 #include <linux/nmi.h>
 #include <linux/console.h>
 #include <linux/bug.h>
+#include <linux/ratelimit.h>
 
 #define PANIC_TIMER_STEP 100
 #define PANIC_BLINK_SPD 18
@@ -601,6 +602,27 @@ EXPORT_SYMBOL(__stack_chk_fail);
 
 #endif
 
+#ifdef CONFIG_ARCH_HAS_REFCOUNT
+static DEFINE_RATELIMIT_STATE(refcount_ratelimit, 15 * HZ, 3);
+
+void refcount_error_report(struct pt_regs *regs)
+{
+	/* Always make sure triggering process will be terminated. */
+	do_send_sig_info(SIGKILL, SEND_SIG_FORCED, current, true);
+
+	if (!__ratelimit(&refcount_ratelimit))
+		return;
+
+	pr_emerg("refcount overflow detected in: %s:%d, uid/euid: %u/%u\n",
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
-- 
2.7.4
