From: Kees Cook <keescook@chromium.org>
Date: Tue, 30 May 2017 14:39:52 -0700
Message-Id: <1496180392-98718-4-git-send-email-keescook@chromium.org>
In-Reply-To: <1496180392-98718-1-git-send-email-keescook@chromium.org>
References: <1496180392-98718-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v5 3/3] x86/refcount: Implement fast refcount overflow protection
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Christoph Hellwig <hch@infradead.org>, Peter Zijlstra <peterz@infradead.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, PaX Team <pageexec@freemail.hu>, Jann Horn <jannh@google.com>, Eric Biggers <ebiggers3@gmail.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, arozansk@redhat.com, Davidlohr Bueso <dave@stgolabs.net>, Manfred Spraul <manfred@colorfullife.com>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

This protection is a modified version of the x86 PAX_REFCOUNT defense
from PaX/grsecurity. This speeds up the refcount_t API by duplicating
the existing atomic_t implementation with a single instruction added to
detect if the refcount has wrapped past INT_MAX (or below 0) resulting
in a negative value, where the handler then restores the refcount_t to
INT_MAX or saturates to INT_MIN / 2. With this overflow protection, the
use-after-free following a refcount_t wrap is blocked from happening,
avoiding the vulnerability entirely.

While this defense only perfectly protects the overflow case, as that
can be detected and stopped before the reference is freed and left to be
abused by an attacker, it also notices some of the "inc from 0" and "below
0" cases. However, these only indicate that a use-after-free has already
happened. Such notifications are likely avoidable by an attacker that has
already exploited a use-after-free vulnerability, but it's better to have
them than allow such conditions to remain universally silent.

On overflow detection (actually "negative value" detection), the refcount
value is reset to INT_MAX, the offending process is killed, and a report
and stack trace are generated. This allows the system to attempt to
keep operating. In the case of a below-zero decrement or other negative
value results, the refcount is saturated to INT_MIN / 2 to keep it from
reaching zero again. (For the INT_MAX reset, another option would be to
choose (INT_MAX - N) with some small N to provide some headroom for
legitimate users of the reference counter.)

On the matter of races, since the entire range beyond INT_MAX but before 0
is negative, every inc will trap, leaving no overflow-only race condition.

As for performance, this implementation adds a single "js" instruction to
the regular execution flow of a copy of the regular atomic_t operations.
Since this is a forward jump, it is by default the non-predicted path,
which will be reinforced by dynamic branch prediction. The result is
this protection having no measurable change in performance over standard
atomic_t operations. The error path, located in .text.unlikely, saves
the refcount location and then uses UD0 to fire a refcount exception
handler, which resets the refcount, reports the error, marks the process
to be killed, and returns to regular execution. This keeps the changes to
.text size minimal, avoiding return jumps and open-coded calls to the
error reporting routine.

Assembly comparison:

atomic_inc
.text:
ffffffff81546149:       f0 ff 45 f4             lock incl -0xc(%rbp)

refcount_inc
.text:
ffffffff81546149:       f0 ff 45 f4             lock incl -0xc(%rbp)
ffffffff8154614d:       0f 88 80 d5 17 00       js     ffffffff816c36d3
...
.text.unlikely:
ffffffff816c36d3:       48 8d 4d f4             lea    -0xc(%rbp),%rcx
ffffffff816c36d7:       0f ff                   (bad)

Thanks to PaX Team for various suggestions for improvement.

Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 arch/Kconfig                    |  9 +++++
 arch/x86/Kconfig                |  1 +
 arch/x86/include/asm/asm.h      |  6 +++
 arch/x86/include/asm/refcount.h | 87 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/mm/extable.c           | 40 +++++++++++++++++++
 include/linux/kernel.h          |  6 +++
 include/linux/refcount.h        |  4 ++
 kernel/panic.c                  | 22 +++++++++++
 8 files changed, 175 insertions(+)
 create mode 100644 arch/x86/include/asm/refcount.h

diff --git a/arch/Kconfig b/arch/Kconfig
index fba3bf186728..e9445ac0e899 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -867,6 +867,15 @@ config STRICT_MODULE_RWX
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
index cd18994a9555..65525f76b27c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -54,6 +54,7 @@ config X86
 	select ARCH_HAS_KCOV			if X86_64
 	select ARCH_HAS_MMIO_FLUSH
 	select ARCH_HAS_PMEM_API		if X86_64
+	select ARCH_HAS_REFCOUNT
 	select ARCH_HAS_SET_MEMORY
 	select ARCH_HAS_SG_CHAIN
 	select ARCH_HAS_STRICT_KERNEL_RWX
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
index 000000000000..aaf9bb3abd71
--- /dev/null
+++ b/arch/x86/include/asm/refcount.h
@@ -0,0 +1,87 @@
+#ifndef __ASM_X86_REFCOUNT_H
+#define __ASM_X86_REFCOUNT_H
+/*
+ * x86-specific implementation of refcount_t. Ported from PAX_REFCOUNT
+ * from PaX/grsecurity.
+ */
+#include <linux/refcount.h>
+
+#define _REFCOUNT_EXCEPTION				\
+	".pushsection .text.unlikely\n"			\
+	"111:\tlea %[counter], %%" _ASM_CX "\n"		\
+	"112:\t" ASM_UD0 "\n"				\
+	".popsection\n"					\
+	"113:\n"					\
+	_ASM_EXTABLE_REFCOUNT(112b, 113b)
+
+#define REFCOUNT_CHECK					\
+	"js 111f\n\t"					\
+	_REFCOUNT_EXCEPTION
+
+#define REFCOUNT_ERROR					\
+	"jmp 111f\n\t"					\
+	_REFCOUNT_EXCEPTION
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
+		if (unlikely(c <= 0 || c == INT_MAX))
+			break;
+	} while (!atomic_try_cmpxchg(&(r->refs), &c, c + 1));
+
+	/* Did we try to increment from an undesirable state? */
+	if (unlikely(c < 0 || c == INT_MAX)) {
+		/*
+		 * Since the overflow flag will have been reset, this will
+		 * always saturate.
+		 */
+		asm volatile(REFCOUNT_ERROR
+			     : : [counter] "m" (r->refs.counter)
+			     : "cc", "cx");
+	}
+
+	return c != 0;
+}
+
+#endif
diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
index 35ea061010a1..33324dfe8799 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -36,6 +36,46 @@ bool ex_handler_fault(const struct exception_table_entry *fixup,
 }
 EXPORT_SYMBOL_GPL(ex_handler_fault);
 
+/*
+ * Handler for UD0 exception following a negative-value test (via "js"
+ * instruction) against the result of a refcount inc/dec/add/sub.
+ */
+bool ex_handler_refcount(const struct exception_table_entry *fixup,
+			 struct pt_regs *regs, int trapnr)
+{
+	int reset;
+
+	/*
+	 * If we crossed from INT_MAX to INT_MIN, the OF flag (result
+	 * wrapped around) and the SF flag (result is negative) will be
+	 * set. In this case, reset to INT_MAX in an attempt to leave the
+	 * refcount usable. Otherwise, we've landed here due to producing
+	 * a negative result from either decrementing zero or operating on
+	 * a negative value. In this case things are badly broken, so we
+	 * we saturate to INT_MIN / 2.
+	 */
+	if (regs->flags & (X86_EFLAGS_OF | X86_EFLAGS_SF))
+		reset = INT_MAX;
+	else
+		reset = INT_MIN / 2;
+	*(int *)regs->cx = reset;
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
+	refcount_error_report(regs);
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(ex_handler_refcount);
+
 bool ex_handler_ext(const struct exception_table_entry *fixup,
 		   struct pt_regs *regs, int trapnr)
 {
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 13bc08aba704..b9a842750e08 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -276,6 +276,12 @@ extern int oops_may_print(void);
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
index 68ecb431dbab..8750fbfe8476 100644
--- a/include/linux/refcount.h
+++ b/include/linux/refcount.h
@@ -54,6 +54,9 @@ extern void refcount_sub(unsigned int i, refcount_t *r);
 extern __must_check bool refcount_dec_and_test(refcount_t *r);
 extern void refcount_dec(refcount_t *r);
 #else
+# ifdef CONFIG_ARCH_HAS_REFCOUNT
+#  include <asm/refcount.h>
+# else
 static inline __must_check bool refcount_add_not_zero(unsigned int i,
 						      refcount_t *r)
 {
@@ -95,6 +98,7 @@ static inline void refcount_dec(refcount_t *r)
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
