From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Date: Wed,  8 Nov 2017 23:30:17 +0100
Message-Id: <20171108223020.24487-4-linux@rasmusvillemoes.dk>
In-Reply-To: <20171108223020.24487-1-linux@rasmusvillemoes.dk>
References: <20171108223020.24487-1-linux@rasmusvillemoes.dk>
Subject: [kernel-hardening] [RFC 3/6] compiler.h: add __attribute__((format_arg)) shorthand
To: kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>
List-ID: <kernel-hardening.lists.openwall.com>

The __format_arg attribute tells gcc that it can use a specific
argument to the annotated function as the format string for the
purpose of type-checking a surrounding __printf function call, e.g.

  sprintf(buf, fmtcheck(what->ever, "%d %lx", 0), i, m)

makes gcc check that i and m are indeed an int and a long; with

  sprintf(buf, what->ever, i, m)

the compiler cannot do any type checking.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 include/linux/compiler-gcc.h | 1 +
 include/linux/compiler.h     | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index bb78e5bdff26..69a233f9fa26 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -128,6 +128,7 @@
 #define __maybe_unused		__attribute__((unused))
 #define __always_unused		__attribute__((unused))
 #define __mode(x)               __attribute__((mode(x)))
+#define __format_arg(n)         __attribute__((format_arg(n)))
 
 /* gcc version specific checks */
 
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 478914ad280b..2c8793f72fb0 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -631,4 +631,8 @@ static __always_inline void __write_once_size(volatile void *p, void *res, int s
 #define __format_template(x)
 #endif
 
+#ifndef __format_arg
+#define __format_arg(n)
+#endif
+
 #endif /* __LINUX_COMPILER_H */
-- 
2.11.0
