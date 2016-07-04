Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 5 Jul 2016 01:42:09 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160705014209.caca7667ac0984c2975b4f41@gmail.com>
In-Reply-To: <20160705013928.396ce4a7cbbc40e6c09efc43@gmail.com>
References: <20160705013928.396ce4a7cbbc40e6c09efc43@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v2 2/3] Mark functions with the __nocapture attribute
To: kernel-hardening@lists.openwall.com
Cc: pageexec@freemail.hu, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com, linux-kbuild@vger.kernel.org, minipli@ld-linux.so, linux@armlinux.org.uk, catalin.marinas@arm.com, linux@rasmusvillemoes.dk, david.brown@linaro.org, benh@kernel.crashing.org, tglx@linutronix.de, akpm@linux-foundation.org, jlayton@poochiereds.net, arnd@arndb.de, sam@ravnborg.org, isdn@linux-pingi.de
List-ID: <kernel-hardening.lists.openwall.com>

The nocapture gcc attribute can be on functions only.
The attribute takes one or more unsigned integer constants as parameters
that specify the function argument(s) of const char* type to initify.
If the marked argument is a vararg then the plugin initifies
all vararg arguments.

I couldn't test the arm, arm64 and powerpc architectures.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 arch/arm/include/asm/string.h     |  4 +--
 arch/arm64/include/asm/string.h   | 19 ++++++------
 arch/powerpc/include/asm/string.h | 19 ++++++------
 arch/x86/include/asm/string_32.h  | 21 ++++++-------
 arch/x86/include/asm/string_64.h  | 20 ++++++-------
 arch/x86/kernel/hpet.c            |  2 +-
 include/asm-generic/bug.h         |  6 ++--
 include/linux/compiler-gcc.h      | 10 +++++--
 include/linux/compiler.h          |  4 +++
 include/linux/fs.h                |  5 ++--
 include/linux/printk.h            |  2 +-
 include/linux/string.h            | 63 ++++++++++++++++++++-------------------
 12 files changed, 96 insertions(+), 79 deletions(-)

diff --git a/arch/arm/include/asm/string.h b/arch/arm/include/asm/string.h
index cf4f3aa..ddb9d58 100644
--- a/arch/arm/include/asm/string.h
+++ b/arch/arm/include/asm/string.h
@@ -13,10 +13,10 @@ extern char * strrchr(const char * s, int c);
 extern char * strchr(const char * s, int c);
 
 #define __HAVE_ARCH_MEMCPY
-extern void * memcpy(void *, const void *, __kernel_size_t);
+extern void * memcpy(void *, const void *, __kernel_size_t) __nocapture(2);
 
 #define __HAVE_ARCH_MEMMOVE
-extern void * memmove(void *, const void *, __kernel_size_t);
+extern void * memmove(void *, const void *, __kernel_size_t) __nocapture(2);
 
 #define __HAVE_ARCH_MEMCHR
 extern void * memchr(const void *, int, __kernel_size_t);
diff --git a/arch/arm64/include/asm/string.h b/arch/arm64/include/asm/string.h
index 2eb714c..4263a27 100644
--- a/arch/arm64/include/asm/string.h
+++ b/arch/arm64/include/asm/string.h
@@ -23,24 +23,25 @@ extern char *strrchr(const char *, int c);
 extern char *strchr(const char *, int c);
 
 #define __HAVE_ARCH_STRCMP
-extern int strcmp(const char *, const char *);
+extern int strcmp(const char *, const char *) __nocapture(1, 2);
 
 #define __HAVE_ARCH_STRNCMP
-extern int strncmp(const char *, const char *, __kernel_size_t);
+extern int
+strncmp(const char *, const char *, __kernel_size_t) __nocapture(1, 2);
 
 #define __HAVE_ARCH_STRLEN
-extern __kernel_size_t strlen(const char *);
+extern __kernel_size_t strlen(const char *) __nocapture(1);
 
 #define __HAVE_ARCH_STRNLEN
-extern __kernel_size_t strnlen(const char *, __kernel_size_t);
+extern __kernel_size_t strnlen(const char *, __kernel_size_t) __nocapture(1);
 
 #define __HAVE_ARCH_MEMCPY
-extern void *memcpy(void *, const void *, __kernel_size_t);
-extern void *__memcpy(void *, const void *, __kernel_size_t);
+extern void *memcpy(void *, const void *, __kernel_size_t) __nocapture(2);
+extern void *__memcpy(void *, const void *, __kernel_size_t) __nocapture(2);
 
 #define __HAVE_ARCH_MEMMOVE
-extern void *memmove(void *, const void *, __kernel_size_t);
-extern void *__memmove(void *, const void *, __kernel_size_t);
+extern void *memmove(void *, const void *, __kernel_size_t) __nocapture(2);
+extern void *__memmove(void *, const void *, __kernel_size_t) __nocapture(2);
 
 #define __HAVE_ARCH_MEMCHR
 extern void *memchr(const void *, int, __kernel_size_t);
@@ -50,7 +51,7 @@ extern void *memset(void *, int, __kernel_size_t);
 extern void *__memset(void *, int, __kernel_size_t);
 
 #define __HAVE_ARCH_MEMCMP
-extern int memcmp(const void *, const void *, size_t);
+extern int memcmp(const void *, const void *, size_t) __nocapture(1, 2);
 
 
 #if defined(CONFIG_KASAN) && !defined(__SANITIZE_ADDRESS__)
diff --git a/arch/powerpc/include/asm/string.h b/arch/powerpc/include/asm/string.h
index da3cdff..e67f1eb 100644
--- a/arch/powerpc/include/asm/string.h
+++ b/arch/powerpc/include/asm/string.h
@@ -11,16 +11,17 @@
 #define __HAVE_ARCH_MEMCMP
 #define __HAVE_ARCH_MEMCHR
 
-extern char * strcpy(char *,const char *);
-extern char * strncpy(char *,const char *, __kernel_size_t);
-extern __kernel_size_t strlen(const char *);
-extern int strcmp(const char *,const char *);
-extern int strncmp(const char *, const char *, __kernel_size_t);
-extern char * strcat(char *, const char *);
+extern char * strcpy(char *,const char *) __nocapture(2);
+extern char * strncpy(char *,const char *, __kernel_size_t) __nocapture(2);
+extern __kernel_size_t strlen(const char *) __nocapture(1);
+extern int strcmp(const char *,const char *) __nocapture(1, 2);
+extern int
+strncmp(const char *, const char *, __kernel_size_t) __nocapture(1, 2);
+extern char * strcat(char *, const char *) __nocapture(2);
 extern void * memset(void *,int,__kernel_size_t);
-extern void * memcpy(void *,const void *,__kernel_size_t);
-extern void * memmove(void *,const void *,__kernel_size_t);
-extern int memcmp(const void *,const void *,__kernel_size_t);
+extern void * memcpy(void *,const void *,__kernel_size_t) __nocapture(2);
+extern void * memmove(void *,const void *,__kernel_size_t) __nocapture(2);
+extern int memcmp(const void *,const void *,__kernel_size_t) __nocapture(1, 2);
 extern void * memchr(const void *,int,__kernel_size_t);
 
 #endif /* __KERNEL__ */
diff --git a/arch/x86/include/asm/string_32.h b/arch/x86/include/asm/string_32.h
index 3d3e835..63f29bf 100644
--- a/arch/x86/include/asm/string_32.h
+++ b/arch/x86/include/asm/string_32.h
@@ -6,28 +6,29 @@
 /* Let gcc decide whether to inline or use the out of line functions */
 
 #define __HAVE_ARCH_STRCPY
-extern char *strcpy(char *dest, const char *src);
+extern char *strcpy(char *dest, const char *src) __nocapture(2);
 
 #define __HAVE_ARCH_STRNCPY
-extern char *strncpy(char *dest, const char *src, size_t count);
+extern char *strncpy(char *dest, const char *src, size_t count) __nocapture(2);
 
 #define __HAVE_ARCH_STRCAT
-extern char *strcat(char *dest, const char *src);
+extern char *strcat(char *dest, const char *src) __nocapture(2);
 
 #define __HAVE_ARCH_STRNCAT
-extern char *strncat(char *dest, const char *src, size_t count);
+extern char *strncat(char *dest, const char *src, size_t count) __nocapture(2);
 
 #define __HAVE_ARCH_STRCMP
-extern int strcmp(const char *cs, const char *ct);
+extern int strcmp(const char *cs, const char *ct) __nocapture(1, 2);
 
 #define __HAVE_ARCH_STRNCMP
-extern int strncmp(const char *cs, const char *ct, size_t count);
+extern int
+strncmp(const char *cs, const char *ct, size_t count) __nocapture(1, 2);
 
 #define __HAVE_ARCH_STRCHR
 extern char *strchr(const char *s, int c);
 
 #define __HAVE_ARCH_STRLEN
-extern size_t strlen(const char *s);
+extern size_t strlen(const char *s) __nocapture(1);
 
 static __always_inline void *__memcpy(void *to, const void *from, size_t n)
 {
@@ -197,7 +198,7 @@ static inline void *__memcpy3d(void *to, const void *from, size_t len)
 #endif
 
 #define __HAVE_ARCH_MEMMOVE
-void *memmove(void *dest, const void *src, size_t n);
+void *memmove(void *dest, const void *src, size_t n) __nocapture(2);
 
 #define memcmp __builtin_memcmp
 
@@ -243,11 +244,11 @@ void *__constant_c_memset(void *s, unsigned long c, size_t count)
 
 /* Added by Gertjan van Wingerde to make minix and sysv module work */
 #define __HAVE_ARCH_STRNLEN
-extern size_t strnlen(const char *s, size_t count);
+extern size_t strnlen(const char *s, size_t count) __nocapture(1);
 /* end of additional stuff */
 
 #define __HAVE_ARCH_STRSTR
-extern char *strstr(const char *cs, const char *ct);
+extern char *strstr(const char *cs, const char *ct) __nocapture(2);
 
 /*
  * This looks horribly ugly, but the compiler can optimize it totally,
diff --git a/arch/x86/include/asm/string_64.h b/arch/x86/include/asm/string_64.h
index 90dbbd9..607d3ba 100644
--- a/arch/x86/include/asm/string_64.h
+++ b/arch/x86/include/asm/string_64.h
@@ -27,8 +27,8 @@ static __always_inline void *__inline_memcpy(void *to, const void *from, size_t
    function. */
 
 #define __HAVE_ARCH_MEMCPY 1
-extern void *memcpy(void *to, const void *from, size_t len);
-extern void *__memcpy(void *to, const void *from, size_t len);
+extern void *memcpy(void *to, const void *from, size_t len) __nocapture(2);
+extern void *__memcpy(void *to, const void *from, size_t len) __nocapture(2);
 
 #ifndef CONFIG_KMEMCHECK
 #if (__GNUC__ == 4 && __GNUC_MINOR__ < 3) || __GNUC__ < 4
@@ -56,14 +56,14 @@ void *memset(void *s, int c, size_t n);
 void *__memset(void *s, int c, size_t n);
 
 #define __HAVE_ARCH_MEMMOVE
-void *memmove(void *dest, const void *src, size_t count);
-void *__memmove(void *dest, const void *src, size_t count);
+void *memmove(void *dest, const void *src, size_t count) __nocapture(2);
+void *__memmove(void *dest, const void *src, size_t count) __nocapture(2);
 
-int memcmp(const void *cs, const void *ct, size_t count);
-size_t strlen(const char *s);
-char *strcpy(char *dest, const char *src);
-char *strcat(char *dest, const char *src);
-int strcmp(const char *cs, const char *ct);
+int memcmp(const void *cs, const void *ct, size_t count) __nocapture(1, 2);
+size_t strlen(const char *s) __nocapture(1);
+char *strcpy(char *dest, const char *src) __nocapture(2);
+char *strcat(char *dest, const char *src) __nocapture(2);
+int strcmp(const char *cs, const char *ct) __nocapture(1, 2);
 
 #if defined(CONFIG_KASAN) && !defined(__SANITIZE_ADDRESS__)
 
@@ -89,7 +89,7 @@ int strcmp(const char *cs, const char *ct);
  *
  * Return 0 for success, -EFAULT for fail
  */
-int memcpy_mcsafe(void *dst, const void *src, size_t cnt);
+int memcpy_mcsafe(void *dst, const void *src, size_t cnt) __nocapture(2);
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 357900a..c68ab1a 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -136,7 +136,7 @@ int is_hpet_enabled(void)
 }
 EXPORT_SYMBOL_GPL(is_hpet_enabled);
 
-static void _hpet_print_config(const char *function, int line)
+static void __nocapture(1) _hpet_print_config(const char *function, int line)
 {
 	u32 i, timers, l, h;
 	printk(KERN_INFO "hpet: %s(%d):\n", function, line);
diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 6f96247..630d0c4 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -62,13 +62,13 @@ struct bug_entry {
  * to provide better diagnostics.
  */
 #ifndef __WARN_TAINT
-extern __printf(3, 4)
+extern __printf(3, 4) __nocapture(1)
 void warn_slowpath_fmt(const char *file, const int line,
 		       const char *fmt, ...);
-extern __printf(4, 5)
+extern __printf(4, 5) __nocapture(1)
 void warn_slowpath_fmt_taint(const char *file, const int line, unsigned taint,
 			     const char *fmt, ...);
-extern void warn_slowpath_null(const char *file, const int line);
+extern __nocapture(1) void warn_slowpath_null(const char *file, const int line);
 #define WANT_WARN_ON_SLOWPATH
 #define __WARN()		warn_slowpath_null(__FILE__, __LINE__)
 #define __WARN_printf(arg...)	warn_slowpath_fmt(__FILE__, __LINE__, arg)
diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index df88c0a..192cea4 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -116,8 +116,10 @@
  */
 #define __pure			__attribute__((pure))
 #define __aligned(x)		__attribute__((aligned(x)))
-#define __printf(a, b)		__attribute__((format(printf, a, b)))
-#define __scanf(a, b)		__attribute__((format(scanf, a, b)))
+#define __printf(a, b)		__attribute__((format(printf, a, b))) \
+				__nocapture(a, b)
+#define __scanf(a, b)		__attribute__((format(scanf, a, b))) \
+				__nocapture(a, b)
 #define __attribute_const__	__attribute__((__const__))
 #define __maybe_unused		__attribute__((unused))
 #define __always_unused		__attribute__((unused))
@@ -193,6 +195,10 @@
 # define __latent_entropy	__attribute__((latent_entropy))
 #endif
 
+#ifdef INITIFY_PLUGIN
+#define __nocapture(...) __attribute__((nocapture(__VA_ARGS__)))
+#endif
+
 /*
  * Mark a position in code as unreachable.  This can be used to
  * suppress control flow warnings after asm blocks that transfer
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 0adcfc2..391b48b 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -412,6 +412,10 @@ static __always_inline void __write_once_size(volatile void *p, void *res, int s
 # define __latent_entropy
 #endif
 
+#ifndef __nocapture
+# define __nocapture(...)
+#endif
+
 /*
  * Tell gcc if a function is cold. The compiler will assume any path
  * directly leading to the call is unlikely.
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c4ab2cf..048a0d9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2476,8 +2476,9 @@ extern int register_chrdev_region(dev_t, unsigned, const char *);
 extern int __register_chrdev(unsigned int major, unsigned int baseminor,
 			     unsigned int count, const char *name,
 			     const struct file_operations *fops);
-extern void __unregister_chrdev(unsigned int major, unsigned int baseminor,
-				unsigned int count, const char *name);
+extern __nocapture(4) void __unregister_chrdev(unsigned int major,
+				unsigned int baseminor, unsigned int count,
+				const char *name);
 extern void unregister_chrdev_region(dev_t, unsigned);
 extern void chrdev_show(struct seq_file *,off_t);
 
diff --git a/include/linux/printk.h b/include/linux/printk.h
index e6ff22e..ca137fa 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -163,7 +163,7 @@ __printf(1, 2) __cold int printk_deferred(const char *fmt, ...);
  * with all other unrelated printk_ratelimit() callsites.  Instead use
  * printk_ratelimited() or plain old __ratelimit().
  */
-extern int __printk_ratelimit(const char *func);
+extern int __printk_ratelimit(const char *func) __nocapture(1);
 #define printk_ratelimit() __printk_ratelimit(__func__)
 extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 				   unsigned int interval_msec);
diff --git a/include/linux/string.h b/include/linux/string.h
index 26b6f6a..0a56912 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -18,37 +18,38 @@ extern void *memdup_user_nul(const void __user *, size_t);
 #include <asm/string.h>
 
 #ifndef __HAVE_ARCH_STRCPY
-extern char * strcpy(char *,const char *);
+extern char * strcpy(char *,const char *) __nocapture(2);
 #endif
 #ifndef __HAVE_ARCH_STRNCPY
-extern char * strncpy(char *,const char *, __kernel_size_t);
+extern char * strncpy(char *,const char *, __kernel_size_t) __nocapture(2);
 #endif
 #ifndef __HAVE_ARCH_STRLCPY
-size_t strlcpy(char *, const char *, size_t);
+size_t strlcpy(char *, const char *, size_t) __nocapture(2);
 #endif
 #ifndef __HAVE_ARCH_STRSCPY
-ssize_t __must_check strscpy(char *, const char *, size_t);
+ssize_t __must_check strscpy(char *, const char *, size_t) __nocapture(2);
 #endif
 #ifndef __HAVE_ARCH_STRCAT
-extern char * strcat(char *, const char *);
+extern char * strcat(char *, const char *) __nocapture(2);
 #endif
 #ifndef __HAVE_ARCH_STRNCAT
-extern char * strncat(char *, const char *, __kernel_size_t);
+extern char * strncat(char *, const char *, __kernel_size_t) __nocapture(2);
 #endif
 #ifndef __HAVE_ARCH_STRLCAT
-extern size_t strlcat(char *, const char *, __kernel_size_t);
+extern size_t strlcat(char *, const char *, __kernel_size_t) __nocapture(2);
 #endif
 #ifndef __HAVE_ARCH_STRCMP
-extern int strcmp(const char *,const char *);
+extern int strcmp(const char *,const char *) __nocapture(1, 2);
 #endif
 #ifndef __HAVE_ARCH_STRNCMP
-extern int strncmp(const char *,const char *,__kernel_size_t);
+extern int strncmp(const char *,const char *,__kernel_size_t) __nocapture(1, 2);
 #endif
 #ifndef __HAVE_ARCH_STRCASECMP
-extern int strcasecmp(const char *s1, const char *s2);
+extern int strcasecmp(const char *s1, const char *s2) __nocapture(1, 2);
 #endif
 #ifndef __HAVE_ARCH_STRNCASECMP
-extern int strncasecmp(const char *s1, const char *s2, size_t n);
+extern int
+strncasecmp(const char *s1, const char *s2, size_t n) __nocapture(1, 2);
 #endif
 #ifndef __HAVE_ARCH_STRCHR
 extern char * strchr(const char *,int);
@@ -72,44 +73,44 @@ static inline __must_check char *strstrip(char *str)
 }
 
 #ifndef __HAVE_ARCH_STRSTR
-extern char * strstr(const char *, const char *);
+extern char * strstr(const char *, const char *) __nocapture(2);
 #endif
 #ifndef __HAVE_ARCH_STRNSTR
-extern char * strnstr(const char *, const char *, size_t);
+extern char * strnstr(const char *, const char *, size_t) __nocapture(2);
 #endif
 #ifndef __HAVE_ARCH_STRLEN
-extern __kernel_size_t strlen(const char *);
+extern __kernel_size_t strlen(const char *) __nocapture(1);
 #endif
 #ifndef __HAVE_ARCH_STRNLEN
-extern __kernel_size_t strnlen(const char *,__kernel_size_t);
+extern __kernel_size_t strnlen(const char *,__kernel_size_t) __nocapture(1);
 #endif
 #ifndef __HAVE_ARCH_STRPBRK
-extern char * strpbrk(const char *,const char *);
+extern char * strpbrk(const char *,const char *) __nocapture(2);
 #endif
 #ifndef __HAVE_ARCH_STRSEP
-extern char * strsep(char **,const char *);
+extern char * strsep(char **,const char *) __nocapture(2);
 #endif
 #ifndef __HAVE_ARCH_STRSPN
-extern __kernel_size_t strspn(const char *,const char *);
+extern __kernel_size_t strspn(const char *,const char *) __nocapture(1, 2);
 #endif
 #ifndef __HAVE_ARCH_STRCSPN
-extern __kernel_size_t strcspn(const char *,const char *);
+extern __kernel_size_t strcspn(const char *,const char *) __nocapture(1, 2);
 #endif
 
 #ifndef __HAVE_ARCH_MEMSET
 extern void * memset(void *,int,__kernel_size_t);
 #endif
 #ifndef __HAVE_ARCH_MEMCPY
-extern void * memcpy(void *,const void *,__kernel_size_t);
+extern void * memcpy(void *,const void *,__kernel_size_t) __nocapture(2);
 #endif
 #ifndef __HAVE_ARCH_MEMMOVE
-extern void * memmove(void *,const void *,__kernel_size_t);
+extern void * memmove(void *,const void *,__kernel_size_t) __nocapture(2);
 #endif
 #ifndef __HAVE_ARCH_MEMSCAN
 extern void * memscan(void *,int,__kernel_size_t);
 #endif
 #ifndef __HAVE_ARCH_MEMCMP
-extern int memcmp(const void *,const void *,__kernel_size_t);
+extern int memcmp(const void *,const void *,__kernel_size_t) __nocapture(1, 2);
 #endif
 #ifndef __HAVE_ARCH_MEMCHR
 extern void * memchr(const void *,int,__kernel_size_t);
@@ -119,16 +120,16 @@ char *strreplace(char *s, char old, char new);
 
 extern void kfree_const(const void *x);
 
-extern char *kstrdup(const char *s, gfp_t gfp) __malloc;
-extern const char *kstrdup_const(const char *s, gfp_t gfp);
-extern char *kstrndup(const char *s, size_t len, gfp_t gfp);
-extern void *kmemdup(const void *src, size_t len, gfp_t gfp);
+extern char *kstrdup(const char *s, gfp_t gfp) __malloc __nocapture(1);
+extern const char *kstrdup_const(const char *s, gfp_t gfp) __nocapture(1);
+extern char *kstrndup(const char *s, size_t len, gfp_t gfp) __nocapture(1);
+extern void *kmemdup(const void *src, size_t len, gfp_t gfp) __nocapture(1);
 
 extern char **argv_split(gfp_t gfp, const char *str, int *argcp);
 extern void argv_free(char **argv);
 
-extern bool sysfs_streq(const char *s1, const char *s2);
-extern int kstrtobool(const char *s, bool *res);
+extern bool sysfs_streq(const char *s1, const char *s2) __nocapture(1, 2);
+extern int kstrtobool(const char *s, bool *res) __nocapture(1);
 static inline int strtobool(const char *s, bool *res)
 {
 	return kstrtobool(s, res);
@@ -137,8 +138,10 @@ static inline int strtobool(const char *s, bool *res)
 int match_string(const char * const *array, size_t n, const char *string);
 
 #ifdef CONFIG_BINARY_PRINTF
-int vbin_printf(u32 *bin_buf, size_t size, const char *fmt, va_list args);
-int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf);
+int vbin_printf(u32 *bin_buf, size_t size, const char *fmt,
+		va_list args) __nocapture(3);
+int bstr_printf(char *buf, size_t size, const char *fmt,
+		const u32 *bin_buf) __nocapture(3);
 int bprintf(u32 *bin_buf, size_t size, const char *fmt, ...) __printf(3, 4);
 #endif
 
-- 
2.8.1
