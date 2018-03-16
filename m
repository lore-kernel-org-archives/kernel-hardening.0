From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v5 1/2] kernel.h: Introduce const_max_t() for VLA removal
Date: Thu, 15 Mar 2018 21:25:58 -0700
Message-Id: <1521174359-46392-2-git-send-email-keescook@chromium.org>
In-Reply-To: <1521174359-46392-1-git-send-email-keescook@chromium.org>
References: <1521174359-46392-1-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Ingo Molnar <mingo@kernel.org>, David Laight <David.Laight@aculab.com>, Ian Abbott <abbotti@mev.co.uk>, linux-input@vger.kernel.org, linux-btrfs@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

In the effort to remove all VLAs from the kernel[1], it is desirable to
build with -Wvla. However, this warning is overly pessimistic, in that
it is only happy with stack array sizes that are declared as constant
expressions, and not constant values. One case of this is the evaluation
of the max() macro which, due to its construction, ends up converting
constant expression arguments into a constant value result. Attempts
to adjust the behavior of max() ran afoul of version-dependent compiler
behavior[2].

To work around this and still gain -Wvla coverage, this patch introduces
a new macro, const_max_t(), for use in these cases of stack array size
declaration, where the constant expressions are retained. Since this means
losing the double-evaluation protections of the max() macro, this macro is
designed to explicitly fail if used on non-constant arguments.

Older compilers will fail with the unhelpful message:

    error: first argument to ‘__builtin_choose_expr’ not a constant

Newer compilers will fail with a hopefully more helpful message:

    error: call to ‘__error_non_const_arg’ declared with attribute error: const_max_t() used with non-constant expression

To gain the ability to compare differing types, the desired type must
be explicitly declared, as with the existing max_t() macro. This is
needed when comparing different enum types and to allow things like:

    int foo[const_max_t(size_t, 6, sizeof(something))];

[1] https://lkml.org/lkml/2018/3/7/621
[2] https://lkml.org/lkml/2018/3/10/170

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/kernel.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 3fd291503576..e14531781568 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -820,6 +820,25 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
 	      x, y)
 
 /**
+ * const_max_t - return maximum of two compile-time constant expressions
+ * @type: type used for evaluation
+ * @x: first compile-time constant expression
+ * @y: second compile-time constant expression
+ *
+ * This has no multi-evaluation defenses, and must only ever be used with
+ * compile-time constant expressions (for example when calculating a stack
+ * array size).
+ */
+size_t __error_non_const_arg(void) \
+__compiletime_error("const_max_t() used with non-constant expression");
+#define const_max_t(type, x, y)					\
+	__builtin_choose_expr(__builtin_constant_p(x) &&	\
+			      __builtin_constant_p(y),		\
+			      (type)(x) > (type)(y) ?		\
+				(type)(x) : (type)(y),		\
+			      __error_non_const_arg())
+
+/**
  * min3 - return minimum of three values
  * @x: first value
  * @y: second value
-- 
2.7.4
