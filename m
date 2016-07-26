Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 26 Jul 2016 22:38:13 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160726223813.16d7cfd7f7dc514c6f7f9e9d@gmail.com>
In-Reply-To: <20160726223541.513ce76f6de65389da6a6abe@gmail.com>
References: <20160726223541.513ce76f6de65389da6a6abe@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v3 2/7] Split up struct warn_args
To: kernel-hardening@lists.openwall.com
Cc: pageexec@freemail.hu, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com, linux-kbuild@vger.kernel.org, minipli@ld-linux.so, linux@armlinux.org.uk, catalin.marinas@arm.com, linux@rasmusvillemoes.dk, david.brown@linaro.org, benh@kernel.crashing.org, tglx@linutronix.de, akpm@linux-foundation.org, jlayton@poochiereds.net, arnd@arndb.de, sam@ravnborg.org, isdn@linux-pingi.de
List-ID: <kernel-hardening.lists.openwall.com>

to enable dataflow verification by the initify plugin. This allows marking
warn_slowpath* parameters as nocapture and compile time verification of
the related dataflows.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 include/asm-generic/bug.h |  5 +----
 kernel/panic.c            | 32 ++++++++++++--------------------
 lib/bug.c                 |  2 +-
 3 files changed, 14 insertions(+), 25 deletions(-)

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 6f96247..3048d10 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -81,11 +81,8 @@ extern void warn_slowpath_null(const char *file, const int line);
 	do { printk(arg); __WARN_TAINT(taint); } while (0)
 #endif
 
-/* used internally by panic.c */
-struct warn_args;
-
 void __warn(const char *file, int line, void *caller, unsigned taint,
-	    struct pt_regs *regs, struct warn_args *args);
+	    struct pt_regs *regs, const char *fmt, va_list args);
 
 #ifndef WARN_ON
 #define WARN_ON(condition) ({						\
diff --git a/kernel/panic.c b/kernel/panic.c
index ca8cea1..993ad20 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -475,13 +475,8 @@ void oops_exit(void)
 	kmsg_dump(KMSG_DUMP_OOPS);
 }
 
-struct warn_args {
-	const char *fmt;
-	va_list args;
-};
-
 void __warn(const char *file, int line, void *caller, unsigned taint,
-	    struct pt_regs *regs, struct warn_args *args)
+	    struct pt_regs *regs, const char *fmt, va_list args)
 {
 	disable_trace_on_warning();
 
@@ -495,8 +490,8 @@ void __warn(const char *file, int line, void *caller, unsigned taint,
 		pr_warn("WARNING: CPU: %d PID: %d at %pS\n",
 			raw_smp_processor_id(), current->pid, caller);
 
-	if (args)
-		vprintk(args->fmt, args->args);
+	if (fmt)
+		vprintk(fmt, args);
 
 	if (panic_on_warn) {
 		/*
@@ -525,31 +520,28 @@ void __warn(const char *file, int line, void *caller, unsigned taint,
 #ifdef WANT_WARN_ON_SLOWPATH
 void warn_slowpath_fmt(const char *file, int line, const char *fmt, ...)
 {
-	struct warn_args args;
+	va_list args;
 
-	args.fmt = fmt;
-	va_start(args.args, fmt);
-	__warn(file, line, __builtin_return_address(0), TAINT_WARN, NULL,
-	       &args);
-	va_end(args.args);
+	va_start(args, fmt);
+	__warn(file, line, __builtin_return_address(0), TAINT_WARN, NULL, fmt, args);
+	va_end(args);
 }
 EXPORT_SYMBOL(warn_slowpath_fmt);
 
 void warn_slowpath_fmt_taint(const char *file, int line,
 			     unsigned taint, const char *fmt, ...)
 {
-	struct warn_args args;
+	va_list args;
 
-	args.fmt = fmt;
-	va_start(args.args, fmt);
-	__warn(file, line, __builtin_return_address(0), taint, NULL, &args);
-	va_end(args.args);
+	va_start(args, fmt);
+	__warn(file, line, __builtin_return_address(0), taint, NULL, fmt, args);
+	va_end(args);
 }
 EXPORT_SYMBOL(warn_slowpath_fmt_taint);
 
 void warn_slowpath_null(const char *file, int line)
 {
-	__warn(file, line, __builtin_return_address(0), TAINT_WARN, NULL, NULL);
+	__warn(file, line, __builtin_return_address(0), TAINT_WARN, NULL, NULL, NULL);
 }
 EXPORT_SYMBOL(warn_slowpath_null);
 #endif
diff --git a/lib/bug.c b/lib/bug.c
index bc3656e..c8bdebb 100644
--- a/lib/bug.c
+++ b/lib/bug.c
@@ -168,7 +168,7 @@ enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
 	if (warning) {
 		/* this is a WARN_ON rather than BUG/BUG_ON */
 		__warn(file, line, (void *)bugaddr, BUG_GET_TAINT(bug), regs,
-		       NULL);
+		       NULL, NULL);
 		return BUG_TRAP_TYPE_WARN;
 	}
 
-- 
2.8.1
