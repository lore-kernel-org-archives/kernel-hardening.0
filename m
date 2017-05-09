From: Kees Cook <keescook@chromium.org>
Date: Tue,  9 May 2017 12:01:23 -0700
Message-Id: <1494356483-81678-3-git-send-email-keescook@chromium.org>
In-Reply-To: <1494356483-81678-1-git-send-email-keescook@chromium.org>
References: <1494356483-81678-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v4 2/2] x86/refcount: Implement fast refcount overflow protection
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, PaX Team <pageexec@freemail.hu>, Jann Horn <jannh@google.com>, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, linux-arch <linux-arch@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This protection is a modified version of the x86 PAX_REFCOUNT defense
from PaX/grsecurity. This speeds up the refcount_t API by duplicating
the existing atomic_t implementation with a single instruction added to
detect if the refcount has wrapped past INT_MAX (or below 0) resulting
in a negative value, where the handler then restores the refcount_t to
INT_MAX. With this overflow protection, the use-after-free following a
refcount_t wrap is blocked from happening, avoiding the vulnerability
entirely.

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
keep operating. Another option, though not done in this patch, would be
to reset the counter to (INT_MIN / 2) to trap all future refcount inc
or dec actions, but this would result in even legitimate uses getting
blocked. Yet another option would be to choose (INT_MAX - N) with some
small N to provide some headroom for legitimate users of the reference
counter.

On the matter of races, since the entire range beyond INT_MAX but before 0
is negative, every inc will trap, leaving no overflow-only race condition.

As for performance, this implementation adds a single "js" instruction to
the regular execution flow of a copy of the regular atomic_t operations.
Since this is a forward jump, it is by default the non-predicted path,
which will be reinforced by dynamic branch prediction. The result is this
protection having no measurable change in performance over standard
atomic_t operations. The error path, located in .text.unlikely, uses
UD0 to fire a refcount exception handler, which reports and returns to
regular execution. This keeps the changes to .text size minimal, avoiding
return jumps and open-coded calls to the error reporting routine.

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
ffffffff816c36d3:       c7 45 f4 ff ff ff 7f    movl   $0x7fffffff,-0xc(%rbp)
ffffffff816c36da:       0f ff                   (bad)

Various differences from PaX:
- uses earlier value reset implementation in assembly
- uses UD0 and refcount exception handler instead of new int vector
- uses .text.unlikely instead of custom named text sections
- applied only to refcount_t, not atomic_t (single size, only overflow)
- reorganized refcount error handler
- uses "js" instead of "jo" to trap all negative results instead of
  just under/overflow transitions

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/Kconfig                    | 20 ++++++++++
 arch/x86/Kconfig                |  1 +
 arch/x86/include/asm/asm.h      |  6 +++
 arch/x86/include/asm/refcount.h | 83 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/mm/extable.c           | 20 ++++++++++
 include/linux/kernel.h          |  6 +++
 include/linux/refcount.h        |  4 ++
 kernel/panic.c                  | 22 +++++++++++
 lib/refcount.c                  |  5 ++-
 9 files changed, 166 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/include/asm/refcount.h

diff --git a/arch/Kconfig b/arch/Kconfig
index 640999412d11..731c96ae6076 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -860,4 +860,24 @@ config STRICT_MODULE_RWX
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
+	default ARCH_HAS_FAST_REFCOUNT
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
diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
index 7acb51c49fec..f3ea9247065e 100644
--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
@@ -73,6 +73,9 @@
 # define _ASM_EXTABLE_EX(from, to)				\
 	_ASM_EXTABLE_HANDLE(from, to, ex_handler_ext)
 
+# define _ASM_EXTABLE_REFCOUNT(from, to)			\
+	_ASM_EXTABLE_HANDLE(from, to, ex_handler_refcount)
+
 # define _ASM_NOKPROBE(entry)					\
 	.pushsection "_kprobe_blacklist","aw" ;			\
 	_ASM_ALIGN ;						\
@@ -122,6 +125,9 @@
 # define _ASM_EXTABLE_EX(from, to)				\
 	_ASM_EXTABLE_HANDLE(from, to, ex_handler_ext)
 
+# define _ASM_EXTABLE_REFCOUNT(from, to)			\
+	_ASM_EXTABLE_HANDLE(from, to, ex_handler_refcount)
+
 /* For C file, we already have NOKPROBE_SYMBOL macro */
 #endif
 
diff --git a/arch/x86/include/asm/refcount.h b/arch/x86/include/asm/refcount.h
new file mode 100644
index 000000000000..2b3fe225b7bd
--- /dev/null
+++ b/arch/x86/include/asm/refcount.h
@@ -0,0 +1,83 @@
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
+	"111:\tmovl $0x7fffffff, %[counter]\n"		\
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
+		if (unlikely(c <= 0))
+			break;
+	} while (!atomic_try_cmpxchg(&(r->refs), &c, c + 1));
+
+	/* Did we start or finish in an undesirable state? */
+	if (unlikely(c <= 0 || c + 1 < 0)) {
+		asm volatile(REFCOUNT_ERROR
+			: : [counter] "m" (r->refs.counter)
+			: "cc", "cx");
+	}
+
+	return c != 0;
+}
+
+#endif
diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
index 35ea061010a1..75c9479e676c 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -36,6 +36,26 @@ bool ex_handler_fault(const struct exception_table_entry *fixup,
 }
 EXPORT_SYMBOL_GPL(ex_handler_fault);
 
+bool ex_handler_refcount(const struct exception_table_entry *fixup,
+			 struct pt_regs *regs, int trapnr)
+{
+	regs->ip = ex_fixup_addr(fixup);
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
index 13bc08aba704..28635815c34e 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -276,6 +276,12 @@ extern int oops_may_print(void);
 void do_exit(long error_code) __noreturn;
 void complete_and_exit(struct completion *, long) __noreturn;
 
+#ifdef CONFIG_FAST_REFCOUNT
+void refcount_error_report(struct pt_regs *regs);
+#else
+static inline void refcount_error_report(struct pt_regs *regs) { }
+#endif
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
index a58932b41700..19257e558896 100644
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
 
+#ifdef CONFIG_FAST_REFCOUNT
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
