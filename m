From: "Tobin C. Harding" <tobin@kernel.org>
Subject: [PATCH 4/6] lib/string: Add string copy/zero function
Date: Tue, 19 Feb 2019 10:23:06 +1100
Message-Id: <20190218232308.11241-5-tobin@kernel.org>
In-Reply-To: <20190218232308.11241-1-tobin@kernel.org>
References: <20190218232308.11241-1-tobin@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Kees Cook <keescook@chromium.org>
Cc: "Tobin C. Harding" <tobin@kernel.org>, Shuah Khan <shuah@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

We have a function to copy strings safely and we have a function to copy
strings _and_ zero the tail of the destination (if source string is
shorter than destination buffer) but we do not have a function to do
both at once.  This means developers must write this themselves if they
desire this functionality.  This is a chore, and also leaves us open to
off by one errors unnecessarily.

Add a function that calls strscpy() then memset()s the tail to zero if
the source string is shorter than the destination buffer.

Add testing via kselftest.

Signed-off-by: Tobin C. Harding <tobin@kernel.org>
---
 include/linux/string.h |  4 ++++
 lib/Kconfig.debug      |  2 +-
 lib/string.c           | 30 ++++++++++++++++++++++++++++--
 lib/test_string.c      | 31 +++++++++++++++++++++++++++++++
 4 files changed, 64 insertions(+), 3 deletions(-)

diff --git a/include/linux/string.h b/include/linux/string.h
index 7927b875f80c..695a5e6a31e3 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -31,6 +31,10 @@ size_t strlcpy(char *, const char *, size_t);
 #ifndef __HAVE_ARCH_STRSCPY
 ssize_t strscpy(char *, const char *, size_t);
 #endif
+
+/* Wrapper function, no arch specific code required */
+ssize_t strscpy_zeroed(char *dest, const char *src, size_t count);
+
 #ifndef __HAVE_ARCH_STRCAT
 extern char * strcat(char *, const char *);
 #endif
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 0dca64c1d8a4..faa15ff47c4f 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1807,7 +1807,7 @@ config TEST_STRING
        default n
        help
         Enable this option to test string manipulation functions.
-	Currently this only tests memset_{16,32,64}.
+	Currently this only tests memset_{16,32,64} and strscpy_zeroed().
 
 	If unsure, say N.
 
diff --git a/lib/string.c b/lib/string.c
index 65969cf32f5d..ff5106e8249f 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -171,8 +171,7 @@ EXPORT_SYMBOL(strlcpy);
  *
  * Preferred to strncpy() since it always returns a valid string, and
  * doesn't unnecessarily force the tail of the destination buffer to be
- * zeroed.  If the zeroing is desired, it's likely cleaner to use strscpy(),
- * check the return size, then just memset() the tail of the dest buffer.
+ * zeroed.  If the zeroing is desired use strscpy_zeroed().
  *
  * Return: The number of characters copied (not including the trailing
  *         NUL) or -E2BIG if the destination buffer wasn't big enough.
@@ -238,6 +237,33 @@ ssize_t strscpy(char *dest, const char *src, size_t count)
 EXPORT_SYMBOL(strscpy);
 #endif
 
+/**
+ * strscopy_zeroed() - Copy a C-string into a sized buffer
+ * @dest: Where to copy the string to
+ * @src: Where to copy the string from
+ * @count: Size of destination buffer
+ *
+ * If the source string is shorter than the destination buffer, zeros
+ * the tail of the destination buffer.
+ *
+ * Return: The number of characters copied (not including the trailing
+ *         NUL) or -E2BIG if the destination buffer wasn't big enough.
+ */
+ssize_t strscpy_zeroed(char *dest, const char *src, size_t count)
+{
+	ssize_t written;
+
+	written = strscpy(dest, src, count);
+	if (written < 0)
+		return written;
+
+	if (written < count)
+		memset(dest + written, 0, count - written);
+
+	return written;
+}
+EXPORT_SYMBOL(strscpy_zeroed);
+
 #ifndef __HAVE_ARCH_STRCAT
 /**
  * strcat - Append one %NUL-terminated string to another
diff --git a/lib/test_string.c b/lib/test_string.c
index a9cba442389a..cc4eef51a395 100644
--- a/lib/test_string.c
+++ b/lib/test_string.c
@@ -111,6 +111,32 @@ static __init int memset64_selftest(void)
 	return 0;
 }
 
+static __init int strscpy_zeroed_selftest(void)
+{
+	char buf[6];
+	int written;
+
+	memset(buf, 'a', sizeof(buf));
+
+	written = strscpy_zeroed(buf, "bb", 4);
+	if (written != 2)
+		return 1;
+
+	/* Copied correctly */
+	if (buf[0] != 'b' || buf[1] != 'b')
+		return 2;
+
+	/* Zeroed correctly */
+	if (buf[2] != '\0' || buf[3] != '\0')
+		return 3;
+
+	/* Only touched what it was supposed to */
+	if (buf[4] != 'a' || buf[5] != 'a')
+		return 4;
+
+	return 0;
+}
+
 static __init int test_string_init(void)
 {
 	int test, subtest;
@@ -130,6 +156,11 @@ static __init int test_string_init(void)
 	if (subtest)
 		goto fail;
 
+	test = 4;
+	subtest = strscpy_zeroed_selftest();
+	if (subtest)
+		goto fail;
+
 	pr_info("String selftests succeeded\n");
 	return 0;
 fail:
-- 
2.20.1
