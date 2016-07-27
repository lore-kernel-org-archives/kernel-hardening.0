Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 27 Jul 2016 17:31:42 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160727173142.c8bba4e83d80e9020018216d@gmail.com>
In-Reply-To: <20160726223813.16d7cfd7f7dc514c6f7f9e9d@gmail.com>
References: <20160726223541.513ce76f6de65389da6a6abe@gmail.com>
	<20160726223813.16d7cfd7f7dc514c6f7f9e9d@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v3 2/7] Split up struct warn_args
To: kernel-hardening@lists.openwall.com
Cc: pageexec@freemail.hu, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com, linux-kbuild@vger.kernel.org, minipli@ld-linux.so, linux@armlinux.org.uk, catalin.marinas@arm.com, linux@rasmusvillemoes.dk, david.brown@linaro.org, benh@kernel.crashing.org, tglx@linutronix.de, akpm@linux-foundation.org, jlayton@poochiereds.net, arnd@arndb.de, sam@ravnborg.org, isdn@linux-pingi.de
List-ID: <kernel-hardening.lists.openwall.com>

Disable the initify plugin on the 6th parameter
of __warn() because the va_list type can't be NULL
on the tile arch.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 include/asm-generic/bug.h |  7 +++++--
 kernel/panic.c            | 32 ++++++++++++++++++++------------
 lib/bug.c                 |  2 +-
 3 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 13a9241..f6ae0d7 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -81,9 +81,12 @@ extern __nocapture(1) void warn_slowpath_null(const char *file, const int line);
 	do { printk(arg); __WARN_TAINT(taint); } while (0)
 #endif
 
-__nocapture(1, 6)
+/* used internally by panic.c */
+struct warn_args;
+
+__nocapture(1, 0)
 void __warn(const char *file, int line, void *caller, unsigned taint,
-	    struct pt_regs *regs, const char *fmt, va_list args);
+	    struct pt_regs *regs, struct warn_args *args);
 
 #ifndef WARN_ON
 #define WARN_ON(condition) ({						\
diff --git a/kernel/panic.c b/kernel/panic.c
index 993ad20..ca8cea1 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -475,8 +475,13 @@ void oops_exit(void)
 	kmsg_dump(KMSG_DUMP_OOPS);
 }
 
+struct warn_args {
+	const char *fmt;
+	va_list args;
+};
+
 void __warn(const char *file, int line, void *caller, unsigned taint,
-	    struct pt_regs *regs, const char *fmt, va_list args)
+	    struct pt_regs *regs, struct warn_args *args)
 {
 	disable_trace_on_warning();
 
@@ -490,8 +495,8 @@ void __warn(const char *file, int line, void *caller, unsigned taint,
 		pr_warn("WARNING: CPU: %d PID: %d at %pS\n",
 			raw_smp_processor_id(), current->pid, caller);
 
-	if (fmt)
-		vprintk(fmt, args);
+	if (args)
+		vprintk(args->fmt, args->args);
 
 	if (panic_on_warn) {
 		/*
@@ -520,28 +525,31 @@ void __warn(const char *file, int line, void *caller, unsigned taint,
 #ifdef WANT_WARN_ON_SLOWPATH
 void warn_slowpath_fmt(const char *file, int line, const char *fmt, ...)
 {
-	va_list args;
+	struct warn_args args;
 
-	va_start(args, fmt);
-	__warn(file, line, __builtin_return_address(0), TAINT_WARN, NULL, fmt, args);
-	va_end(args);
+	args.fmt = fmt;
+	va_start(args.args, fmt);
+	__warn(file, line, __builtin_return_address(0), TAINT_WARN, NULL,
+	       &args);
+	va_end(args.args);
 }
 EXPORT_SYMBOL(warn_slowpath_fmt);
 
 void warn_slowpath_fmt_taint(const char *file, int line,
 			     unsigned taint, const char *fmt, ...)
 {
-	va_list args;
+	struct warn_args args;
 
-	va_start(args, fmt);
-	__warn(file, line, __builtin_return_address(0), taint, NULL, fmt, args);
-	va_end(args);
+	args.fmt = fmt;
+	va_start(args.args, fmt);
+	__warn(file, line, __builtin_return_address(0), taint, NULL, &args);
+	va_end(args.args);
 }
 EXPORT_SYMBOL(warn_slowpath_fmt_taint);
 
 void warn_slowpath_null(const char *file, int line)
 {
-	__warn(file, line, __builtin_return_address(0), TAINT_WARN, NULL, NULL, NULL);
+	__warn(file, line, __builtin_return_address(0), TAINT_WARN, NULL, NULL);
 }
 EXPORT_SYMBOL(warn_slowpath_null);
 #endif
diff --git a/lib/bug.c b/lib/bug.c
index c8bdebb..bc3656e 100644
--- a/lib/bug.c
+++ b/lib/bug.c
@@ -168,7 +168,7 @@ enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
 	if (warning) {
 		/* this is a WARN_ON rather than BUG/BUG_ON */
 		__warn(file, line, (void *)bugaddr, BUG_GET_TAINT(bug), regs,
-		       NULL, NULL);
+		       NULL);
 		return BUG_TRAP_TYPE_WARN;
 	}
 
-- 
2.8.1
