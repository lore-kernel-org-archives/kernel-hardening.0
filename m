From: Daniel Micay <danielmicay@gmail.com>
Date: Tue,  9 May 2017 00:19:06 -0400
Message-Id: <20170509041906.1089-1-danielmicay@gmail.com>
Subject: [kernel-hardening] [PATCH v2] add the option of fortified string.h functions
To: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
Cc: Mark Rutland <mark.rutland@arm.com>, Daniel Micay <danielmicay@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

This adds support for compiling with a rough equivalent to the glibc
_FORTIFY_SOURCE=1 feature, providing compile-time and runtime buffer
overflow checks for string.h functions when the compiler determines the
size of the source or destination buffer at compile-time. Unlike glibc,
it covers buffer reads in addition to writes.

GNU C __builtin_*_chk intrinsics are avoided because they would force a
much more complex implementation. They aren't designed to detect read
overflows and offer no real benefit when using an implementation based
on inline checks. Inline checks don't add up to much code size and allow
full use of the regular string intrinsics while avoiding the need for a
bunch of _chk functions and per-arch assembly to avoid wrapper overhead.

This detects various overflows at compile-time in various drivers and
some non-x86 core kernel code. There will likely be issues caught in
regular use at runtime too.

Future improvements left out of initial implementation for simplicity,
as it's all quite optional and can be done incrementally:

* Some of the fortified string functions (strncpy, strcat), don't yet
  place a limit on reads from the source based on __builtin_object_size of
  the source buffer.

* Extending coverage to more string functions (strlcpy, strlcat) and
  perhaps making the memory buffer checks into something more reusable
  for broader use.

* It should be possible to optionally use __builtin_object_size(x, 1) for
  some functions (C strings) to detect intra-object overflows (like
  glibc's _FORTIFY_SOURCE=2), but for now this takes the conservative
  approach to avoid likely compatibility issues.

* The error reporting could be made friendlier by splitting up the
  compile-time error for reads and writes.

* The compile-time checks should be made available via a separate config
  option which can be enabled by default (or always enabled) once enough
  time has passed to get the issues it catches fixed.

Signed-off-by: Daniel Micay <danielmicay@gmail.com>
---
Changes since v1:
* fix compatibility with CONFIG_KASAN
* replace strlcpy with strscpy in fortified strcpy and verify the source buffer
* use fortified strlen/strnlen in fortified strncat to check for read overflow

 arch/arm64/include/asm/string.h  |   3 +
 arch/x86/boot/compressed/misc.c  |   5 ++
 arch/x86/include/asm/string_64.h |   3 +
 include/linux/string.h           | 164 +++++++++++++++++++++++++++++++++++++++
 lib/string.c                     |   6 ++
 security/Kconfig                 |   6 ++
 6 files changed, 187 insertions(+)

diff --git a/arch/arm64/include/asm/string.h b/arch/arm64/include/asm/string.h
index 2eb714c4639f..0f05eb3ae4c7 100644
--- a/arch/arm64/include/asm/string.h
+++ b/arch/arm64/include/asm/string.h
@@ -63,6 +63,9 @@ extern int memcmp(const void *, const void *, size_t);
 #define memcpy(dst, src, len) __memcpy(dst, src, len)
 #define memmove(dst, src, len) __memmove(dst, src, len)
 #define memset(s, c, n) __memset(s, c, n)
+
+#define __NO_FORTIFY /* FORTIFY_SOURCE uses __builtin_memcpy, etc. */
+
 #endif
 
 #endif
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
diff --git a/arch/x86/include/asm/string_64.h b/arch/x86/include/asm/string_64.h
index a164862d77e3..56976bb0a66d 100644
--- a/arch/x86/include/asm/string_64.h
+++ b/arch/x86/include/asm/string_64.h
@@ -77,6 +77,9 @@ int strcmp(const char *cs, const char *ct);
 #define memcpy(dst, src, len) __memcpy(dst, src, len)
 #define memmove(dst, src, len) __memmove(dst, src, len)
 #define memset(s, c, n) __memset(s, c, n)
+
+#define __NO_FORTIFY /* FORTIFY_SOURCE uses __builtin_memcpy, etc. */
+
 #endif
 
 __must_check int memcpy_mcsafe_unrolled(void *dst, const void *src, size_t cnt);
diff --git a/include/linux/string.h b/include/linux/string.h
index 26b6f6a66f83..eca8bf97b13c 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -169,4 +169,168 @@ static inline const char *kbasename(const char *path)
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
+	size_t q_size = __builtin_object_size(q, 0);
+	if (p_size == (size_t)-1 && q_size == (size_t)-1)
+		return __builtin_strcpy(p, q);
+	if (strscpy(p, q, p_size < q_size ? p_size : q_size) < 0)
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
+/* defined after fortified strlen and strnlen to reuse them */
+__FORTIFY_INLINE char *strncat(char *p, const char *q, __kernel_size_t count)
+{
+	size_t p_len, copy_len;
+	size_t p_size = __builtin_object_size(p, 0);
+	size_t q_size = __builtin_object_size(q, 0);
+	if (p_size == (size_t)-1 && q_size == (size_t)-1)
+		return __builtin_strncat(p, q, count);
+	p_len = strlen(p);
+	copy_len = strnlen(q, count);
+	if (p_size < p_len + copy_len + 1)
+		fortify_panic(__func__);
+	__builtin_memcpy(p + p_len, q, copy_len);
+	p[p_len + copy_len] = '\0';
+	return p;
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
index b5c9a1168d3a..c695b886ea39 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -952,3 +952,9 @@ char *strreplace(char *s, char old, char new)
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
