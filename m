From: "Tobin C. Harding" <tobin@kernel.org>
Subject: [PATCH v3 7/7] lib: Add test module for strscpy_pad
Date: Thu,  7 Mar 2019 08:42:26 +1100
Message-Id: <20190306214226.14598-8-tobin@kernel.org>
In-Reply-To: <20190306214226.14598-1-tobin@kernel.org>
References: <20190306214226.14598-1-tobin@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Kees Cook <keescook@chromium.org>, Shuah Khan <shuah@kernel.org>
Cc: "Tobin C. Harding" <tobin@kernel.org>, Jann Horn <jannh@google.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Randy Dunlap <rdunlap@infradead.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Stephen Rothwell <sfr@canb.auug.org.au>, Andy Lutomirski <luto@amacapital.net>, Daniel Micay <danielmicay@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, kernel-hardening@lists.openwall.com, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Add a test module for the new strscpy_pad() function.  Tie it into the
kselftest infrastructure for lib/ tests.

Signed-off-by: Tobin C. Harding <tobin@kernel.org>
---
 lib/Kconfig.debug                      |   3 +
 lib/Makefile                           |   1 +
 lib/test_strscpy.c                     | 150 +++++++++++++++++++++++++
 tools/testing/selftests/lib/Makefile   |   2 +-
 tools/testing/selftests/lib/config     |   1 +
 tools/testing/selftests/lib/strscpy.sh |  17 +++
 6 files changed, 173 insertions(+), 1 deletion(-)
 create mode 100644 lib/test_strscpy.c
 create mode 100755 tools/testing/selftests/lib/strscpy.sh

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index d4df5b24d75e..441c1571495c 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1805,6 +1805,9 @@ config TEST_HEXDUMP
 config TEST_STRING_HELPERS
 	tristate "Test functions located in the string_helpers module at runtime"
 
+config TEST_STRSCPY
+	tristate "Test strscpy*() family of functions at runtime"
+
 config TEST_KSTRTOX
 	tristate "Test kstrto*() family of functions at runtime"
 
diff --git a/lib/Makefile b/lib/Makefile
index e1b59da71418..82e027f73a3e 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -68,6 +68,7 @@ obj-$(CONFIG_TEST_STATIC_KEYS) += test_static_keys.o
 obj-$(CONFIG_TEST_STATIC_KEYS) += test_static_key_base.o
 obj-$(CONFIG_TEST_PRINTF) += test_printf.o
 obj-$(CONFIG_TEST_BITMAP) += test_bitmap.o
+obj-$(CONFIG_TEST_STRSCPY) += test_strscpy.o
 obj-$(CONFIG_TEST_BITFIELD) += test_bitfield.o
 obj-$(CONFIG_TEST_UUID) += test_uuid.o
 obj-$(CONFIG_TEST_XARRAY) += test_xarray.o
diff --git a/lib/test_strscpy.c b/lib/test_strscpy.c
new file mode 100644
index 000000000000..95665e8a0f97
--- /dev/null
+++ b/lib/test_strscpy.c
@@ -0,0 +1,150 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/string.h>
+
+#include "../tools/testing/selftests/kselftest_module.h"
+
+/*
+ * Kernel module for testing 'strscpy' family of functions.
+ */
+
+KSTM_MODULE_GLOBALS();
+
+/*
+ * tc() - Run a specific test case.
+ * @src: Source string, argument to strscpy_pad()
+ * @count: Size of destination buffer, argument to strscpy_pad()
+ * @expected: Expected return value from call to strscpy_pad()
+ * @terminator: 1 if there should be a terminating null byte 0 otherwise.
+ * @chars: Number of characters from the src string expected to be
+ *         written to the dst buffer.
+ * @pad: Number of pad characters expected (in the tail of dst buffer).
+ *       (@pad does not include the null terminator byte.)
+ *
+ * Calls strscpy_pad() and verifies the return value and state of the
+ * destination buffer after the call returns.
+ */
+static int __init tc(char *src, int count, int expected,
+		     int chars, int terminator, int pad)
+{
+	int nr_bytes_poison;
+	int max_expected;
+	int max_count;
+	int written;
+	char buf[6];
+	int index, i;
+	const char POISON = 'z';
+
+	total_tests++;
+
+	if (!src) {
+		pr_err("null source string not supported\n");
+		return -1;
+	}
+
+	memset(buf, POISON, sizeof(buf));
+	/* Future proofing test suite, validate args */
+	max_count = sizeof(buf) - 2; /* Space for null and to verify overflow */
+	max_expected = count - 1;     /* Space for the null */
+	if (count > max_count) {
+		pr_err("count (%d) is too big (%d) ... aborting", count, max_count);
+		return -1;
+	}
+	if (expected > max_expected) {
+		pr_warn("expected (%d) is bigger than can possibly be returned (%d)",
+			expected, max_expected);
+	}
+
+	written = strscpy_pad(buf, src, count);
+	if ((written) != (expected)) {
+		pr_err("%d != %d (written, expected)\n", written, expected);
+		goto fail;
+	}
+
+	if (count && written == -E2BIG) {
+		if (strncmp(buf, src, count - 1) != 0) {
+			pr_err("buffer state invalid for -E2BIG\n");
+			goto fail;
+		}
+		if (buf[count - 1] != '\0') {
+			pr_err("too big string is not null terminated correctly\n");
+			goto fail;
+		}
+	}
+
+	for (i = 0; i < chars; i++) {
+		if (buf[i] != src[i]) {
+			pr_err("buf[i]==%c != src[i]==%c\n", buf[i], src[i]);
+			goto fail;
+		}
+	}
+
+	if (terminator) {
+		if (buf[count - 1] != '\0') {
+			pr_err("string is not null terminated correctly\n");
+			goto fail;
+		}
+	}
+
+	for (i = 0; i < pad; i++) {
+		index = chars + terminator + i;
+		if (buf[index] != '\0') {
+			pr_err("padding missing at index: %d\n", i);
+			goto fail;
+		}
+	}
+
+	nr_bytes_poison = sizeof(buf) - chars - terminator - pad;
+	for (i = 0; i < nr_bytes_poison; i++) {
+		index = sizeof(buf) - 1 - i; /* Check from the end back */
+		if (buf[index] != POISON) {
+			pr_err("poison value missing at index: %d\n", i);
+			goto fail;
+		}
+	}
+
+	return 0;
+fail:
+	failed_tests++;
+	return -1;
+}
+
+static void __init selftest(void)
+{
+	/*
+	 * tc() uses a destination buffer of size 6 and needs at
+	 * least 2 characters spare (one for null and one to check for
+	 * overflow).  This means we should only call tc() with
+	 * strings up to a maximum of 4 characters long and 'count'
+	 * should not exceed 4.  To test with longer strings increase
+	 * the buffer size in tc().
+	 */
+
+	/* tc(src, count, expected, chars, terminator, pad) */
+	KSTM_CHECK_ZERO(tc("a", 0, -E2BIG, 0, 0, 0));
+	KSTM_CHECK_ZERO(tc("", 0, -E2BIG, 0, 0, 0));
+
+	KSTM_CHECK_ZERO(tc("a", 1, -E2BIG, 0, 1, 0));
+	KSTM_CHECK_ZERO(tc("", 1, 0, 0, 1, 0));
+
+	KSTM_CHECK_ZERO(tc("ab", 2, -E2BIG, 1, 1, 0));
+	KSTM_CHECK_ZERO(tc("a", 2, 1, 1, 1, 0));
+	KSTM_CHECK_ZERO(tc("", 2, 0, 0, 1, 1));
+
+	KSTM_CHECK_ZERO(tc("abc", 3, -E2BIG, 2, 1, 0));
+	KSTM_CHECK_ZERO(tc("ab", 3, 2, 2, 1, 0));
+	KSTM_CHECK_ZERO(tc("a", 3, 1, 1, 1, 1));
+	KSTM_CHECK_ZERO(tc("", 3, 0, 0, 1, 2));
+
+	KSTM_CHECK_ZERO(tc("abcd", 4, -E2BIG, 3, 1, 0));
+	KSTM_CHECK_ZERO(tc("abc", 4, 3, 3, 1, 0));
+	KSTM_CHECK_ZERO(tc("ab", 4, 2, 2, 1, 1));
+	KSTM_CHECK_ZERO(tc("a", 4, 1, 1, 1, 2));
+	KSTM_CHECK_ZERO(tc("", 4, 0, 0, 1, 3));
+}
+
+KSTM_MODULE_LOADERS(test_strscpy);
+MODULE_AUTHOR("Tobin C. Harding <tobin@kernel.org>");
+MODULE_LICENSE("GPL");
diff --git a/tools/testing/selftests/lib/Makefile b/tools/testing/selftests/lib/Makefile
index 70d5711e3ac8..9f26635f3e57 100644
--- a/tools/testing/selftests/lib/Makefile
+++ b/tools/testing/selftests/lib/Makefile
@@ -3,6 +3,6 @@
 # No binaries, but make sure arg-less "make" doesn't trigger "run_tests"
 all:
 
-TEST_PROGS := printf.sh bitmap.sh prime_numbers.sh
+TEST_PROGS := printf.sh bitmap.sh prime_numbers.sh strscpy.sh
 
 include ../lib.mk
diff --git a/tools/testing/selftests/lib/config b/tools/testing/selftests/lib/config
index 126933bcc950..14a77ea4a8da 100644
--- a/tools/testing/selftests/lib/config
+++ b/tools/testing/selftests/lib/config
@@ -1,3 +1,4 @@
 CONFIG_TEST_PRINTF=m
 CONFIG_TEST_BITMAP=m
 CONFIG_PRIME_NUMBERS=m
+CONFIG_TEST_STRSCPY=m
diff --git a/tools/testing/selftests/lib/strscpy.sh b/tools/testing/selftests/lib/strscpy.sh
new file mode 100755
index 000000000000..f3ba4b90e602
--- /dev/null
+++ b/tools/testing/selftests/lib/strscpy.sh
@@ -0,0 +1,17 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0+
+
+module=test_strscpy
+description="strscpy"
+
+#
+# Shouldn't need to edit anything below here.
+#
+
+file="kselftest_module.sh"
+path="../$file"
+if [[ ! $KBUILD_SRC == "" ]]; then
+    path="${KBUILD_SRC}/tools/testing/selftests/$file"
+fi
+
+$path $module $description
-- 
2.20.1
