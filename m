Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Fri, 16 Dec 2016 14:06:24 -0800
Message-Id: <1481925984-98605-5-git-send-email-keescook@chromium.org>
In-Reply-To: <1481925984-98605-1-git-send-email-keescook@chromium.org>
References: <1481925984-98605-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v4 4/4] initify: Mark functions with the __unverified_nocapture attribute
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>, linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Josh Triplett <josh@joshtriplett.org>, pageexec@freemail.hu, spender@grsecurity.net, mmarek@suse.com, yamada.masahiro@socionext.com, linux-kbuild@vger.kernel.org, minipli@ld-linux.so, linux@armlinux.org.uk, catalin.marinas@arm.com, linux@rasmusvillemoes.dk, david.brown@linaro.org, benh@kernel.crashing.org, tglx@linutronix.de, akpm@linux-foundation.org, jlayton@poochiereds.net, sam@ravnborg.org
List-ID: <kernel-hardening.lists.openwall.com>

From: Emese Revfy <re.emese@gmail.com>

This attribute disables the compile data flow verification of the
designated nocapture parameters of the function. Use it only on function
parameters that are difficult for the plugin to analyze.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/compiler-gcc.h | 1 +
 include/linux/compiler.h     | 4 ++++
 lib/vsprintf.c               | 4 ++--
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index 1e11ee911c3e..4ebb3ba17631 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -207,6 +207,7 @@
  */
 #ifdef INITIFY_PLUGIN
 #define __nocapture(...) __attribute__((nocapture(__VA_ARGS__)))
+#define __unverified_nocapture(...) __attribute__((unverified_nocapture(__VA_ARGS__)))
 #endif
 
 /*
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 8b3dcc790bb6..1bde420f07bb 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -437,6 +437,10 @@ static __always_inline void __write_once_size(volatile void *p, void *res, int s
 # define __nocapture(...)
 #endif
 
+#ifndef __unverified_nocapture
+# define __unverified_nocapture(...)
+#endif
+
 /*
  * Tell gcc if a function is cold. The compiler will assume any path
  * directly leading to the call is unlikely.
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index a192761d338a..cb964b51f9f8 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -118,7 +118,7 @@ long long simple_strtoll(const char *cp, char **endp, unsigned int base)
 }
 EXPORT_SYMBOL(simple_strtoll);
 
-static noinline_for_stack __nocapture(1)
+static noinline_for_stack __nocapture(1) __unverified_nocapture(1)
 int skip_atoi(const char **s)
 {
 	int i = 0;
@@ -1570,7 +1570,7 @@ int kptr_restrict __read_mostly;
  * function pointers are really function descriptors, which contain a
  * pointer to the real address.
  */
-static noinline_for_stack __nocapture(1)
+static noinline_for_stack __nocapture(1) __unverified_nocapture(1)
 char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 	      struct printf_spec spec)
 {
-- 
2.7.4
