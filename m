Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 26 Jul 2016 22:43:27 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160726224327.c9b41ba7c1c37771f49968ce@gmail.com>
In-Reply-To: <20160726223541.513ce76f6de65389da6a6abe@gmail.com>
References: <20160726223541.513ce76f6de65389da6a6abe@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v3 7/7] Mark functions with the __unverified_nocapture
 attribute
To: kernel-hardening@lists.openwall.com
Cc: pageexec@freemail.hu, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com, linux-kbuild@vger.kernel.org, minipli@ld-linux.so, linux@armlinux.org.uk, catalin.marinas@arm.com, linux@rasmusvillemoes.dk, david.brown@linaro.org, benh@kernel.crashing.org, tglx@linutronix.de, akpm@linux-foundation.org, jlayton@poochiereds.net, arnd@arndb.de, sam@ravnborg.org, isdn@linux-pingi.de
List-ID: <kernel-hardening.lists.openwall.com>

This attribute disables the compile data flow verification of the
designated nocapture parameters of the function. Use it only on function
parameters that are difficult for the plugin to analyze.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 include/linux/compiler-gcc.h | 1 +
 include/linux/compiler.h     | 4 ++++
 lib/vsprintf.c               | 4 ++--
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index 6697ea3..76797b9 100644
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
index 391b48b..f0b4156 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -416,6 +416,10 @@ static __always_inline void __write_once_size(volatile void *p, void *res, int s
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
index a192761..cb964b5 100644
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
2.8.1
