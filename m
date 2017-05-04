From: Daniel Micay <danielmicay@gmail.com>
Date: Thu,  4 May 2017 10:24:35 -0400
Message-Id: <20170504142435.10175-1-danielmicay@gmail.com>
Subject: [kernel-hardening] [PATCH] add the option of fortified string.h functions
To: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
Cc: Daniel Micay <danielmicay@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

This adds support for compiling with a rough equivalent to the glibc
_FORTIFY_SOURCE=1 feature, providing compile-time and runtime buffer
overflow checks for string.h functions when the compiler determines the
size of the source or destination buffer at compile-time. Unlike glibc,
it covers buffer reads in addition to writes.

GNU C __builtin_*_chk intrinsics are avoided because they're only
designed to detect write overflows and are overly complex. A single
inline branch works for everything but strncat while those intrinsics
would force the creation of a bunch of extra non-inline wrappers that
aren't able to receive the detected source buffer size.

This detects various undefined uses of memcpy, etc. at compile-time
outside of non-core kernel code, and in the arm64 vdso code, so there
will need to be a series of fixes applied (mainly memcpy -> strncpy for
copying string constants to avoid copying past the end of the source).
It isn't particularly bad, but there are likely some issues that occur
during regular use at runtime (none found so far).

Future improvements left out of initial implementation for simplicity,
as it's all quite optional and can be done incrementally:

The fortified string functions should place a limit on reads from the
source. For strcat/strcpy, these could just be a variant of strlcat /
strlcpy using the size limit as a bound on both the source and
destination, with the return value only reporting whether truncation
occurred rather than providing the source length. It would be an easier
API for developers to use too and not that it really matters but it
would be more efficient for the case where truncation is intended.

It should be possible to optionally use __builtin_object_size(x, 1) for
some functions (C strings) to detect intra-object overflows (like
glibc's _FORTIFY_SOURCE=2), but for now this takes the conservative
approach to avoid likely compatibility issues.

The error reporting could be made friendlier by splitting up the
compile-time error for reads and writes. The runtime error could also
directly report the buffer and copy sizes.

It may make sense to have the compile-time checks in a separate
configuration option since they wouldn't have a runtime performance cost
if there was an ifdef for the runtime check. However, the runtime cost
of these checks is already quite low (much lower than SSP) and as long
as some people are using it with allyesconfig, the issues will be found
for any in-tree code.

Signed-off-by: Daniel Micay <danielmicay@gmail.com>
---
 arch/x86/boot/compressed/misc.c |   5 ++
 include/linux/string.h          | 161 ++++++++++++++++++++++++++++++++++++++++
 lib/string.c                    |   8 ++
 security/Kconfig                |   6 ++
 4 files changed, 180 insertions(+)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index b3c5a5f030ce..43691238a21d 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -409,3 +409,8 @@ asmlinkage __visible void *extract_kernel(void *rmode, memptr heap,
 	debug_putstr("done.\nBooting the kernel.\n");
 	return output;
 }
+
+void fortify_panic(const char *name)
+{
+	error("detected buffer overflow");
+}
diff --git a/include/linux/string.h b/include/linux/string.h
index 26b6f6a66f83..3bd429c9593a 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -169,4 +169,165 @@ static inline const char *kbasename(const char *path)
 	return tail ? tail + 1 : path;
 }
 
+#define __FORTIFY_INLINE extern __always_inline __attribute__((gnu_inline))
+#define __RENAME(x) __asm__(#x)
+
+void fortify_panic(const char *name) __noreturn __cold;
+void __buffer_overflow(void) __compiletime_error("buffer overflow");
+
+#if !defined(__NO_FORTIFY) && defined(__OPTIMIZE__) && defined(CONFIG_FORTIFY_SOURCE)
+__FORTIFY_INLINE char *strcpy(char *p, const char *q)
+{
+	size_t p_size = __builtin_object_size(p, 0);
+	if (p_size == (size_t)-1)
+		return __builtin_strcpy(p, q);
+	if (strlcpy(p, q, p_size) >= p_size)
+		fortify_panic(__func__);
+	return p;
+}
+
+__FORTIFY_INLINE char *strncpy(char *p, const char *q, __kernel_size_t size)
+{
+	size_t p_size = __builtin_object_size(p, 0);
+	if (__builtin_constant_p(size) && p_size < size)
+		__buffer_overflow();
+	if (p_size < size)
+		fortify_panic(__func__);
+	return __builtin_strncpy(p, q, size);
+}
+
+__FORTIFY_INLINE char *strcat(char *p, const char *q)
+{
+	size_t p_size = __builtin_object_size(p, 0);
+	if (p_size == (size_t)-1)
+		return __builtin_strcat(p, q);
+	if (strlcat(p, q, p_size) >= p_size)
+		fortify_panic(__func__);
+	return p;
+}
+
+__FORTIFY_INLINE char *strncat(char *p, const char *q, __kernel_size_t count)
+{
+	size_t p_len, copy_len;
+	size_t p_size = __builtin_object_size(p, 0);
+	if (p_size == (size_t)-1)
+		return __builtin_strncat(p, q, count);
+	p_len = __builtin_strlen(p);
+	copy_len = strnlen(q, count);
+	if (p_size < p_len + copy_len + 1)
+		fortify_panic(__func__);
+	__builtin_memcpy(p + p_len, q, copy_len);
+	p[p_len + copy_len] = '\0';
+	return p;
+}
+
+__FORTIFY_INLINE __kernel_size_t strlen(const char *p)
+{
+	__kernel_size_t ret;
+	size_t p_size = __builtin_object_size(p, 0);
+	if (p_size == (size_t)-1)
+		return __builtin_strlen(p);
+	ret = strnlen(p, p_size);
+	if (p_size <= ret)
+		fortify_panic(__func__);
+	return ret;
+}
+
+extern __kernel_size_t __real_strnlen(const char *, __kernel_size_t) __RENAME(strnlen);
+__FORTIFY_INLINE __kernel_size_t strnlen(const char *p, __kernel_size_t maxlen)
+{
+	size_t p_size = __builtin_object_size(p, 0);
+	__kernel_size_t ret = __real_strnlen(p, maxlen < p_size ? maxlen : p_size);
+	if (p_size <= ret)
+		fortify_panic(__func__);
+	return ret;
+}
+
+__FORTIFY_INLINE void *memset(void *p, int c, __kernel_size_t size)
+{
+	size_t p_size = __builtin_object_size(p, 0);
+	if (__builtin_constant_p(size) && p_size < size)
+		__buffer_overflow();
+	if (p_size < size)
+		fortify_panic(__func__);
+	return __builtin_memset(p, c, size);
+}
+
+__FORTIFY_INLINE void *memcpy(void *p, const void *q, __kernel_size_t size)
+{
+	size_t p_size = __builtin_object_size(p, 0);
+	size_t q_size = __builtin_object_size(q, 0);
+	if (__builtin_constant_p(size) && (p_size < size || q_size < size))
+		__buffer_overflow();
+	if (p_size < size || q_size < size)
+		fortify_panic(__func__);
+	return __builtin_memcpy(p, q, size);
+}
+
+__FORTIFY_INLINE void *memmove(void *p, const void *q, __kernel_size_t size)
+{
+	size_t p_size = __builtin_object_size(p, 0);
+	size_t q_size = __builtin_object_size(q, 0);
+	if (__builtin_constant_p(size) && (p_size < size || q_size < size))
+		__buffer_overflow();
+	if (p_size < size || q_size < size)
+		fortify_panic(__func__);
+	return __builtin_memmove(p, q, size);
+}
+
+extern void *__real_memscan(void *, int, __kernel_size_t) __RENAME(memscan);
+__FORTIFY_INLINE void *memscan(void *p, int c, __kernel_size_t size)
+{
+	size_t p_size = __builtin_object_size(p, 0);
+	if (__builtin_constant_p(size) && p_size < size)
+		__buffer_overflow();
+	if (p_size < size)
+		fortify_panic(__func__);
+	return __real_memscan(p, c, size);
+}
+
+__FORTIFY_INLINE int memcmp(const void *p, const void *q, __kernel_size_t size)
+{
+	size_t p_size = __builtin_object_size(p, 0);
+	size_t q_size = __builtin_object_size(q, 0);
+	if (__builtin_constant_p(size) && (p_size < size || q_size < size))
+		__buffer_overflow();
+	if (p_size < size || q_size < size)
+		fortify_panic(__func__);
+	return __builtin_memcmp(p, q, size);
+}
+
+__FORTIFY_INLINE void *memchr(const void *p, int c, __kernel_size_t size)
+{
+	size_t p_size = __builtin_object_size(p, 0);
+	if (__builtin_constant_p(size) && p_size < size)
+		__buffer_overflow();
+	if (p_size < size)
+		fortify_panic(__func__);
+	return __builtin_memchr(p, c, size);
+}
+
+void *__real_memchr_inv(const void *s, int c, size_t n) __RENAME(memchr_inv);
+__FORTIFY_INLINE void *memchr_inv(const void *p, int c, size_t size)
+{
+	size_t p_size = __builtin_object_size(p, 0);
+	if (__builtin_constant_p(size) && p_size < size)
+		__buffer_overflow();
+	if (p_size < size)
+		fortify_panic(__func__);
+	return __real_memchr_inv(p, c, size);
+}
+
+extern void *__real_kmemdup(const void *src, size_t len, gfp_t gfp) __RENAME(kmemdup);
+__FORTIFY_INLINE void *kmemdup(const void *p, size_t size, gfp_t gfp)
+{
+	size_t p_size = __builtin_object_size(p, 0);
+	if (__builtin_constant_p(size) && p_size < size)
+		__buffer_overflow();
+	if (p_size < size)
+		fortify_panic(__func__);
+	return __real_kmemdup(p, size, gfp);
+}
+#endif
+
 #endif /* _LINUX_STRING_H_ */
diff --git a/lib/string.c b/lib/string.c
index b5c9a1168d3a..ca356e537e24 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -19,6 +19,8 @@
  * -  Kissed strtok() goodbye
  */
 
+#define __NO_FORTIFY
+
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/ctype.h>
@@ -952,3 +954,9 @@ char *strreplace(char *s, char old, char new)
 	return s;
 }
 EXPORT_SYMBOL(strreplace);
+
+void fortify_panic(const char *name)
+{
+	panic("detected buffer overflow in %s", name);
+}
+EXPORT_SYMBOL(fortify_panic);
diff --git a/security/Kconfig b/security/Kconfig
index 93027fdf47d1..0e5035d720ce 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -154,6 +154,12 @@ config HARDENED_USERCOPY_PAGESPAN
 	  been removed. This config is intended to be used only while
 	  trying to find such users.
 
+config FORTIFY_SOURCE
+	bool "Harden common functions against buffer overflows"
+	help
+	  Detect overflows of buffers in common functions where the compiler
+	  can determine the buffer size.
+
 config STATIC_USERMODEHELPER
 	bool "Force all usermode helper calls through a single binary"
 	help
-- 
2.12.2
