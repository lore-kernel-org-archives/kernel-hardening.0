From: "Tobin C. Harding" <tobin@kernel.org>
Subject: [PATCH 1/6] lib/string: Enable string selftesting
Date: Tue, 19 Feb 2019 10:23:03 +1100
Message-Id: <20190218232308.11241-2-tobin@kernel.org>
In-Reply-To: <20190218232308.11241-1-tobin@kernel.org>
References: <20190218232308.11241-1-tobin@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Kees Cook <keescook@chromium.org>
Cc: "Tobin C. Harding" <tobin@kernel.org>, Shuah Khan <shuah@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Currently we have a test module but it is not tied into the kselftest
infrastructure.  In preparation for adding string manipulation functions
and testing we should enable kselftest to utilize the test module.

Enable string testing via kselftest infrastructure.

Signed-off-by: Tobin C. Harding <tobin@kernel.org>
---
 lib/Kconfig.debug                     | 14 ++++++++++++++
 lib/Makefile                          |  2 +-
 lib/test_string.c                     |  4 ++--
 tools/testing/selftests/lib/Makefile  |  2 +-
 tools/testing/selftests/lib/config    |  1 +
 tools/testing/selftests/lib/string.sh | 19 +++++++++++++++++++
 6 files changed, 38 insertions(+), 4 deletions(-)
 create mode 100755 tools/testing/selftests/lib/string.sh

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index d4df5b24d75e..0dca64c1d8a4 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1802,8 +1802,22 @@ config ASYNC_RAID6_TEST
 config TEST_HEXDUMP
 	tristate "Test functions located in the hexdump module at runtime"
 
+config TEST_STRING
+       tristate "Perform selftest on string manipulation functions"
+       default n
+       help
+        Enable this option to test string manipulation functions.
+	Currently this only tests memset_{16,32,64}.
+
+	If unsure, say N.
+
 config TEST_STRING_HELPERS
 	tristate "Test functions located in the string_helpers module at runtime"
+	default n
+	help
+	 Enable this option to unit test code in lib/string_helpers.c
+
+	 If unsure, say N.
 
 config TEST_KSTRTOX
 	tristate "Test kstrto*() family of functions at runtime"
diff --git a/lib/Makefile b/lib/Makefile
index e1b59da71418..9c30e1fee27f 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -39,7 +39,7 @@ obj-y += bcd.o div64.o sort.o parser.o debug_locks.o random32.o \
 	 bsearch.o find_bit.o llist.o memweight.o kfifo.o \
 	 percpu-refcount.o rhashtable.o reciprocal_div.o \
 	 once.o refcount.o usercopy.o errseq.o bucket_locks.o
-obj-$(CONFIG_STRING_SELFTEST) += test_string.o
+obj-$(CONFIG_TEST_STRING) += test_string.o
 obj-y += string_helpers.o
 obj-$(CONFIG_TEST_STRING_HELPERS) += test-string_helpers.o
 obj-y += hexdump.o
diff --git a/lib/test_string.c b/lib/test_string.c
index 0fcdb82dca86..a9cba442389a 100644
--- a/lib/test_string.c
+++ b/lib/test_string.c
@@ -111,7 +111,7 @@ static __init int memset64_selftest(void)
 	return 0;
 }
 
-static __init int string_selftest_init(void)
+static __init int test_string_init(void)
 {
 	int test, subtest;
 
@@ -137,5 +137,5 @@ static __init int string_selftest_init(void)
 	return 0;
 }
 
-module_init(string_selftest_init);
+module_init(test_string_init);
 MODULE_LICENSE("GPL v2");
diff --git a/tools/testing/selftests/lib/Makefile b/tools/testing/selftests/lib/Makefile
index 70d5711e3ac8..2ee4559b277e 100644
--- a/tools/testing/selftests/lib/Makefile
+++ b/tools/testing/selftests/lib/Makefile
@@ -3,6 +3,6 @@
 # No binaries, but make sure arg-less "make" doesn't trigger "run_tests"
 all:
 
-TEST_PROGS := printf.sh bitmap.sh prime_numbers.sh
+TEST_PROGS := printf.sh bitmap.sh prime_numbers.sh string.sh
 
 include ../lib.mk
diff --git a/tools/testing/selftests/lib/config b/tools/testing/selftests/lib/config
index 126933bcc950..2032402ad409 100644
--- a/tools/testing/selftests/lib/config
+++ b/tools/testing/selftests/lib/config
@@ -1,3 +1,4 @@
 CONFIG_TEST_PRINTF=m
 CONFIG_TEST_BITMAP=m
+CONFIG_TEST_STRING=m
 CONFIG_PRIME_NUMBERS=m
diff --git a/tools/testing/selftests/lib/string.sh b/tools/testing/selftests/lib/string.sh
new file mode 100755
index 000000000000..99024b6f3a6a
--- /dev/null
+++ b/tools/testing/selftests/lib/string.sh
@@ -0,0 +1,19 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+# Runs string manipulation tests using test_string kernel module
+
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
+if ! /sbin/modprobe -q -n test_string; then
+	echo "string: module test_string is not found [SKIP]"
+	exit $ksft_skip
+fi
+
+if /sbin/modprobe -q test_string; then
+	/sbin/modprobe -q -r test_string
+	echo "string: ok"
+else
+	echo "string: [FAIL]"
+	exit 1
+fi
-- 
2.20.1
