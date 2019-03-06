From: "Tobin C. Harding" <tobin@kernel.org>
Subject: [PATCH v3 3/7] kselftest/lib: Use new shell runner to define tests
Date: Thu,  7 Mar 2019 08:42:22 +1100
Message-Id: <20190306214226.14598-4-tobin@kernel.org>
In-Reply-To: <20190306214226.14598-1-tobin@kernel.org>
References: <20190306214226.14598-1-tobin@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Kees Cook <keescook@chromium.org>, Shuah Khan <shuah@kernel.org>
Cc: "Tobin C. Harding" <tobin@kernel.org>, Jann Horn <jannh@google.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Randy Dunlap <rdunlap@infradead.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Stephen Rothwell <sfr@canb.auug.org.au>, Andy Lutomirski <luto@amacapital.net>, Daniel Micay <danielmicay@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, kernel-hardening@lists.openwall.com, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

We just added a new script kselftest_module.sh that can be used to
define kselftest tests that run tests within a kernel module.  We can
use it to reduce code duplication in all of the test runner scripts in
tools/testing/selftests/lib/.

Use new shell runner tools/testing/selftests/kselftest_module.sh to
define test runner scripts.

Signed-off-by: Tobin C. Harding <tobin@kernel.org>
---
 tools/testing/selftests/lib/bitmap.sh        | 25 ++++++++++----------
 tools/testing/selftests/lib/prime_numbers.sh | 23 +++++++++---------
 tools/testing/selftests/lib/printf.sh        | 25 ++++++++++----------
 3 files changed, 35 insertions(+), 38 deletions(-)

diff --git a/tools/testing/selftests/lib/bitmap.sh b/tools/testing/selftests/lib/bitmap.sh
index 5a90006d1aea..ed4180ea0021 100755
--- a/tools/testing/selftests/lib/bitmap.sh
+++ b/tools/testing/selftests/lib/bitmap.sh
@@ -1,19 +1,18 @@
 #!/bin/sh
 # SPDX-License-Identifier: GPL-2.0
 
-# Kselftest framework requirement - SKIP code is 4.
-ksft_skip=4
+module=test_bitmap
+description="bitmap"
 
-# Runs bitmap infrastructure tests using test_bitmap kernel module
-if ! /sbin/modprobe -q -n test_bitmap; then
-	echo "bitmap: module test_bitmap is not found [SKIP]"
-	exit $ksft_skip
-fi
+#
+# Shouldn't need to edit anything below here.
+#
 
-if /sbin/modprobe -q test_bitmap; then
-	/sbin/modprobe -q -r test_bitmap
-	echo "bitmap: ok"
-else
-	echo "bitmap: [FAIL]"
-	exit 1
+file="kselftest_module.sh"
+path="../$file"
+if [[ ! $KBUILD_SRC == "" ]]; then
+    path="${KBUILD_SRC}/tools/testing/selftests/$file"
 fi
+
+$path $module $description
+
diff --git a/tools/testing/selftests/lib/prime_numbers.sh b/tools/testing/selftests/lib/prime_numbers.sh
index 78e7483c8d60..6f782386d897 100755
--- a/tools/testing/selftests/lib/prime_numbers.sh
+++ b/tools/testing/selftests/lib/prime_numbers.sh
@@ -2,18 +2,17 @@
 # SPDX-License-Identifier: GPL-2.0
 # Checks fast/slow prime_number generation for inconsistencies
 
-# Kselftest framework requirement - SKIP code is 4.
-ksft_skip=4
+module=prime_numbers
+description="prime_numbers"
 
-if ! /sbin/modprobe -q -n prime_numbers; then
-	echo "prime_numbers: module prime_numbers is not found [SKIP]"
-	exit $ksft_skip
-fi
+#
+# Shouldn't need to edit anything below here.
+#
 
-if /sbin/modprobe -q prime_numbers selftest=65536; then
-	/sbin/modprobe -q -r prime_numbers
-	echo "prime_numbers: ok"
-else
-	echo "prime_numbers: [FAIL]"
-	exit 1
+file="kselftest_module.sh"
+path="../$file"
+if [[ ! $KBUILD_SRC == "" ]]; then
+    path="${KBUILD_SRC}/tools/testing/selftests/$file"
 fi
+
+$path $module $description
diff --git a/tools/testing/selftests/lib/printf.sh b/tools/testing/selftests/lib/printf.sh
index 45a23e2d64ad..89717915d028 100755
--- a/tools/testing/selftests/lib/printf.sh
+++ b/tools/testing/selftests/lib/printf.sh
@@ -1,19 +1,18 @@
 #!/bin/sh
 # SPDX-License-Identifier: GPL-2.0
-# Runs printf infrastructure using test_printf kernel module
+# Tests the printf infrastructure using test_printf kernel module.
 
-# Kselftest framework requirement - SKIP code is 4.
-ksft_skip=4
+module=test_printf
+description="printf"
 
-if ! /sbin/modprobe -q -n test_printf; then
-	echo "printf: module test_printf is not found [SKIP]"
-	exit $ksft_skip
-fi
+#
+# Shouldn't need to edit anything below here.
+#
 
-if /sbin/modprobe -q test_printf; then
-	/sbin/modprobe -q -r test_printf
-	echo "printf: ok"
-else
-	echo "printf: [FAIL]"
-	exit 1
+file="kselftest_module.sh"
+path="../$file"
+if [[ ! $KBUILD_SRC == "" ]]; then
+    path="${KBUILD_SRC}/tools/testing/selftests/$file"
 fi
+
+$path $module $description
-- 
2.20.1
