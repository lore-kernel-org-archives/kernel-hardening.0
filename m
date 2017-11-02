From: "Tobin C. Harding" <me@tobin.cc>
Date: Thu,  2 Nov 2017 17:16:29 +1100
Message-Id: <1509603390-7587-2-git-send-email-me@tobin.cc>
In-Reply-To: <1509603390-7587-1-git-send-email-me@tobin.cc>
References: <1509603390-7587-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [RFC 1/2] printk: add sanitized versions of *printf()
To: kernel-hardening@lists.openwall.com
Cc: "Tobin C. Harding" <me@tobin.cc>
List-ID: <kernel-hardening.lists.openwall.com>

Kernel addresses should not be leaked to user space.

Add 'sanitized' versions of the *printf() functions that output zeros
for any address printed using %pK.

This patch is not a merge candidate, hence the overloading of %pK.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 include/linux/kernel.h |  11 ++
 lib/vsprintf.c         | 301 +++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 255 insertions(+), 57 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 91189bb0c818..6fdeb2584ed7 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -459,6 +459,17 @@ char *kvasprintf(gfp_t gfp, const char *fmt, va_list args);
 extern __printf(2, 0)
 const char *kvasprintf_const(gfp_t gfp, const char *fmt, va_list args);
 
+extern __printf(2, 3) int sprintf_sanitize(char *buf, const char *fmt, ...);
+extern __printf(2, 0) int vsprintf_sanitize(char *buf, const char *, va_list);
+extern __printf(3, 4)
+int snprintf_sanitize(char *buf, size_t size, const char *fmt, ...);
+extern __printf(3, 0)
+int vsnprintf_sanitize(char *buf, size_t size, const char *fmt, va_list args);
+extern __printf(3, 4)
+int scnprintf_sanitize(char *buf, size_t size, const char *fmt, ...);
+extern __printf(3, 0)
+int vscnprintf_sanitize(char *buf, size_t size, const char *fmt, va_list args);
+
 extern __scanf(2, 3)
 int sscanf(const char *, const char *, ...);
 extern __scanf(2, 0)
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 1cca8d8785e1..41115a31d112 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -48,6 +48,11 @@
 #include <linux/string_helpers.h>
 #include "kstrtox.h"
 
+enum {
+	SANITIZE = true,
+	NO_SANITIZE = false
+};
+
 /**
  * simple_strtoull - convert a string to an unsigned long long
  * @cp: The start of the string
@@ -1399,6 +1404,19 @@ char *kernel_pointer(char *buf, char *end, const void *ptr,
 }
 
 static noinline_for_stack
+char *sanitized_address(char *buf, char *end, struct printf_spec spec)
+{
+	spec.base = 16;
+	spec.flags |= SMALL;
+	if (spec.field_width == -1) {
+		spec.field_width = 2 * sizeof(void *);
+		spec.flags |= ZEROPAD;
+	}
+
+	return number(buf, end, 0, spec);
+}
+
+static noinline_for_stack
 char *netdev_bits(char *buf, char *end, const void *addr, const char *fmt)
 {
 	unsigned long long num;
@@ -1829,7 +1847,7 @@ static char *ptr_to_id(char *buf, char *end, void *ptr, struct printf_spec spec)
  */
 static noinline_for_stack
 char *pointer(const char *fmt, char *buf, char *end, void *ptr,
-	      struct printf_spec spec)
+	      struct printf_spec spec, bool sanitize)
 {
 	const int default_width = 2 * sizeof(void *);
 
@@ -1915,7 +1933,9 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 			return buf;
 		}
 	case 'K':
-		return kernel_pointer(buf, end, ptr, spec);
+		if (!sanitize)
+			return kernel_pointer(buf, end, ptr, spec);
+		return sanitized_address(buf, end, spec);
 	case 'N':
 		return netdev_bits(buf, end, ptr, fmt);
 	case 'a':
@@ -2161,35 +2181,8 @@ set_precision(struct printf_spec *spec, int prec)
 	}
 }
 
-/**
- * vsnprintf - Format a string and place it in a buffer
- * @buf: The buffer to place the result into
- * @size: The size of the buffer, including the trailing null space
- * @fmt: The format string to use
- * @args: Arguments for the format string
- *
- * This function generally follows C99 vsnprintf, but has some
- * extensions and a few limitations:
- *
- *  - ``%n`` is unsupported
- *  - ``%p*`` is handled by pointer()
- *
- * See pointer() or Documentation/printk-formats.txt for more
- * extensive description.
- *
- * **Please update the documentation in both places when making changes**
- *
- * The return value is the number of characters which would
- * be generated for the given input, excluding the trailing
- * '\0', as per ISO C99. If you want to have the exact
- * number of characters written into @buf as return value
- * (not including the trailing '\0'), use vscnprintf(). If the
- * return is greater than or equal to @size, the resulting
- * string is truncated.
- *
- * If you're not already dealing with a va_list consider using snprintf().
- */
-int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
+static int
+_vsnprintf(char *buf, size_t size, bool sanitize, const char *fmt, va_list args)
 {
 	unsigned long long num;
 	char *str, *end;
@@ -2264,7 +2257,7 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 
 		case FORMAT_TYPE_PTR:
 			str = pointer(fmt, str, end, va_arg(args, void *),
-				      spec);
+				      spec, sanitize);
 			while (isalnum(*fmt))
 				fmt++;
 			break;
@@ -2341,9 +2334,58 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 	return str-buf;
 
 }
+
+/**
+ * vsnprintf - Format a string and place it in a buffer
+ * @buf: The buffer to place the result into
+ * @size: The size of the buffer, including the trailing null space
+ * @fmt: The format string to use
+ * @args: Arguments for the format string
+ *
+ * This function generally follows C99 vsnprintf, but has some
+ * extensions and a few limitations:
+ *
+ *  - ``%n`` is unsupported
+ *  - ``%p*`` is handled by pointer()
+ *
+ * See pointer() or Documentation/printk-formats.txt for more
+ * extensive description.
+ *
+ * **Please update the documentation in both places when making changes**
+ *
+ * The return value is the number of characters which would
+ * be generated for the given input, excluding the trailing
+ * '\0', as per ISO C99. If you want to have the exact
+ * number of characters written into @buf as return value
+ * (not including the trailing '\0'), use vscnprintf(). If the
+ * return is greater than or equal to @size, the resulting
+ * string is truncated.
+ *
+ * If you're not already dealing with a va_list consider using snprintf().
+ */
+int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
+{
+	return _vsnprintf(buf, size, NO_SANITIZE, fmt, args);
+}
 EXPORT_SYMBOL(vsnprintf);
 
 /**
+ * vsnprintf_sanitize - Format a string and place it in a buffer
+ * @buf: The buffer to place the result into
+ * @size: The size of the buffer, including the trailing null space
+ * @fmt: The format string to use
+ * @args: Arguments for the format string
+ *
+ * Sanitize kernel addresses printed with ``%pK`` before formatting
+ * string as for vsnprintf().  see vsnprintf() documentation for details.
+ */
+int vsnprintf_sanitize(char *buf, size_t size, const char *fmt, va_list args)
+{
+	return _vsnprintf(buf, size, SANITIZE, fmt, args);
+}
+EXPORT_SYMBOL(vsnprintf_sanitize);
+
+/**
  * vscnprintf - Format a string and place it in a buffer
  * @buf: The buffer to place the result into
  * @size: The size of the buffer, including the trailing null space
@@ -2373,6 +2415,35 @@ int vscnprintf(char *buf, size_t size, const char *fmt, va_list args)
 EXPORT_SYMBOL(vscnprintf);
 
 /**
+ * vscnprintf_sanitize - Format a string and place it in a buffer
+ * @buf: The buffer to place the result into
+ * @size: The size of the buffer, including the trailing null space
+ * @fmt: The format string to use
+ * @args: Arguments for the format string
+ *
+ * Sanitize kernel addresses printed with ``%pK`` before formatting
+ * string as for vscnprintf().  see vscnprintf() documentation for details.
+ *
+ * If you're not already dealing with a va_list consider using
+ * scnprintf_sanitize().
+ *
+ * See the vsnprintf() documentation for format string extensions over C99.
+ */
+int vscnprintf_sanitize(char *buf, size_t size, const char *fmt, va_list args)
+{
+	int i;
+
+	i = vsnprintf_sanitize(buf, size, fmt, args);
+
+	if (likely(i < size))
+		return i;
+	if (size != 0)
+		return size - 1;
+	return 0;
+}
+EXPORT_SYMBOL(vscnprintf_sanitize);
+
+/**
  * snprintf - Format a string and place it in a buffer
  * @buf: The buffer to place the result into
  * @size: The size of the buffer, including the trailing null space
@@ -2400,6 +2471,31 @@ int snprintf(char *buf, size_t size, const char *fmt, ...)
 EXPORT_SYMBOL(snprintf);
 
 /**
+ * snprintf_sanitize - Format a string and place it in a buffer
+ * @buf: The buffer to place the result into
+ * @size: The size of the buffer, including the trailing null space
+ * @fmt: The format string to use
+ * @...: Arguments for the format string
+ *
+ * Sanitize kernel addresses printed with ``%pK`` before formatting
+ * string as for snprintf().  see snprintf() documentation for details.
+ *
+ * See the vsnprintf() documentation for format string extensions over C99.
+ */
+int snprintf_sanitize(char *buf, size_t size, const char *fmt, ...)
+{
+	va_list args;
+	int i;
+
+	va_start(args, fmt);
+	i = vsnprintf_sanitize(buf, size, fmt, args);
+	va_end(args);
+
+	return i;
+}
+EXPORT_SYMBOL(snprintf_sanitize);
+
+/**
  * scnprintf - Format a string and place it in a buffer
  * @buf: The buffer to place the result into
  * @size: The size of the buffer, including the trailing null space
@@ -2409,7 +2505,6 @@ EXPORT_SYMBOL(snprintf);
  * The return value is the number of characters written into @buf not including
  * the trailing '\0'. If @size is == 0 the function returns 0.
  */
-
 int scnprintf(char *buf, size_t size, const char *fmt, ...)
 {
 	va_list args;
@@ -2424,6 +2519,29 @@ int scnprintf(char *buf, size_t size, const char *fmt, ...)
 EXPORT_SYMBOL(scnprintf);
 
 /**
+ * scnprintf_sanitize - Format a string and place it in a buffer
+ * @buf: The buffer to place the result into
+ * @size: The size of the buffer, including the trailing null space
+ * @fmt: The format string to use
+ * @...: Arguments for the format string
+ *
+ * Sanitize kernel addresses printed with ``%pK`` before formatting
+ * string as for scnprintf().  see scnprintf() documentation for details.
+ */
+int scnprintf_sanitize(char *buf, size_t size, const char *fmt, ...)
+{
+	va_list args;
+	int i;
+
+	va_start(args, fmt);
+	i = vscnprintf_sanitize(buf, size, fmt, args);
+	va_end(args);
+
+	return i;
+}
+EXPORT_SYMBOL(scnprintf_sanitize);
+
+/**
  * vsprintf - Format a string and place it in a buffer
  * @buf: The buffer to place the result into
  * @fmt: The format string to use
@@ -2444,6 +2562,28 @@ int vsprintf(char *buf, const char *fmt, va_list args)
 EXPORT_SYMBOL(vsprintf);
 
 /**
+ * vsprintf_sanitize - Format a string and place it in a buffer
+ * @buf: The buffer to place the result into
+ * @fmt: The format string to use
+ * @args: Arguments for the format string
+ *
+ * Sanitize kernel addresses before printing as for vsprintf().
+ *
+ * The function returns the number of characters written
+ * into @buf. Use vsnprintf_sanitize() or vscnprintf() in order to avoid
+ * buffer overflows.
+ *
+ * If you're not already dealing with a va_list consider using sprintf().
+ *
+ * See the vsnprintf() documentation for format string extensions over C99.
+ */
+int vsprintf_sanitize(char *buf, const char *fmt, va_list args)
+{
+	return vsnprintf_sanitize(buf, INT_MAX, fmt, args);
+}
+EXPORT_SYMBOL(vsprintf_sanitize);
+
+/**
  * sprintf - Format a string and place it in a buffer
  * @buf: The buffer to place the result into
  * @fmt: The format string to use
@@ -2468,6 +2608,29 @@ int sprintf(char *buf, const char *fmt, ...)
 }
 EXPORT_SYMBOL(sprintf);
 
+/**
+ * sprintf_sanitize - Format a string and place it in a buffer
+ * @buf: The buffer to place the result into
+ * @fmt: The format string to use
+ * @...: Arguments for the format string
+ *
+ * Sanitize kernel addresses printed with ``%pK`` before formatting
+ * string as for sprintf().  see the documentation for vsnprintf()
+ * and vsnprintf_sanitize() for more details.
+ */
+int sprintf_sanitize(char *buf, const char *fmt, ...)
+{
+	va_list args;
+	int i;
+
+	va_start(args, fmt);
+	i = vsnprintf_sanitize(buf, INT_MAX, fmt, args);
+	va_end(args);
+
+	return i;
+}
+EXPORT_SYMBOL(sprintf_sanitize);
+
 #ifdef CONFIG_BINARY_PRINTF
 /*
  * bprintf service:
@@ -2598,29 +2761,8 @@ do {									\
 }
 EXPORT_SYMBOL_GPL(vbin_printf);
 
-/**
- * bstr_printf - Format a string from binary arguments and place it in a buffer
- * @buf: The buffer to place the result into
- * @size: The size of the buffer, including the trailing null space
- * @fmt: The format string to use
- * @bin_buf: Binary arguments for the format string
- *
- * This function like C99 vsnprintf, but the difference is that vsnprintf gets
- * arguments from stack, and bstr_printf gets arguments from @bin_buf which is
- * a binary buffer that generated by vbin_printf.
- *
- * The format follows C99 vsnprintf, but has some extensions:
- *  see vsnprintf comment for details.
- *
- * The return value is the number of characters which would
- * be generated for the given input, excluding the trailing
- * '\0', as per ISO C99. If you want to have the exact
- * number of characters written into @buf as return value
- * (not including the trailing '\0'), use vscnprintf(). If the
- * return is greater than or equal to @size, the resulting
- * string is truncated.
- */
-int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf)
+static int _bstr_printf(char *buf, size_t size, bool sanitize,
+			const char *fmt, const u32 *bin_buf)
 {
 	struct printf_spec spec = {0};
 	char *str, *end;
@@ -2709,7 +2851,8 @@ int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf)
 		}
 
 		case FORMAT_TYPE_PTR:
-			str = pointer(fmt, str, end, get_arg(void *), spec);
+			str = pointer(fmt, str, end, get_arg(void *), spec,
+				      sanitize);
 			while (isalnum(*fmt))
 				fmt++;
 			break;
@@ -2778,9 +2921,53 @@ int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf)
 	/* the trailing null byte doesn't count towards the total */
 	return str - buf;
 }
+
+/**
+ * bstr_printf - Format a string from binary arguments and place it in a buffer
+ * @buf: The buffer to place the result into
+ * @size: The size of the buffer, including the trailing null space
+ * @fmt: The format string to use
+ * @bin_buf: Binary arguments for the format string
+ *
+ * This function like C99 vsnprintf, but the difference is that vsnprintf gets
+ * arguments from stack, and bstr_printf gets arguments from @bin_buf which is
+ * a binary buffer that generated by vbin_printf.
+ *
+ * The format follows C99 vsnprintf, but has some extensions:
+ *  see vsnprintf comment for details.
+ *
+ * The return value is the number of characters which would
+ * be generated for the given input, excluding the trailing
+ * '\0', as per ISO C99. If you want to have the exact
+ * number of characters written into @buf as return value
+ * (not including the trailing '\0'), use vscnprintf(). If the
+ * return is greater than or equal to @size, the resulting
+ * string is truncated.
+ */
+int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf)
+{
+	return _bstr_printf(buf, size, NO_SANITIZE, fmt, bin_buf);
+}
 EXPORT_SYMBOL_GPL(bstr_printf);
 
 /**
+ * bstr_printf_sanitize - Format a string from binary arguments into a  buffer
+ * @buf: The buffer to place the result into
+ * @size: The size of the buffer, including the trailing null space
+ * @fmt: The format string to use
+ * @bin_buf: Binary arguments for the format string
+ *
+ * Sanitize all addresses printed with ``%pK`` before formatting
+ * as for bstr_printf().
+ */
+int bstr_printf_sanitize(char *buf, size_t size, const char *fmt,
+			 const u32 *bin_buf)
+{
+	return _bstr_printf(buf, size, SANITIZE, fmt, bin_buf);
+}
+EXPORT_SYMBOL_GPL(bstr_printf_sanitize);
+
+/**
  * bprintf - Parse a format string and place args' binary value in a buffer
  * @bin_buf: The buffer to place args' binary value
  * @size: The size of the buffer(by words(32bits), not characters)
-- 
2.7.4
