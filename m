From: "Tobin C. Harding" <tobin@kernel.org>
Subject: [PATCH v3 2/7] kselftest: Add test runner creation script
Date: Thu,  7 Mar 2019 08:42:21 +1100
Message-Id: <20190306214226.14598-3-tobin@kernel.org>
In-Reply-To: <20190306214226.14598-1-tobin@kernel.org>
References: <20190306214226.14598-1-tobin@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Kees Cook <keescook@chromium.org>, Shuah Khan <shuah@kernel.org>
Cc: "Tobin C. Harding" <tobin@kernel.org>, Jann Horn <jannh@google.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Randy Dunlap <rdunlap@infradead.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Stephen Rothwell <sfr@canb.auug.org.au>, Andy Lutomirski <luto@amacapital.net>, Daniel Micay <danielmicay@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, kernel-hardening@lists.openwall.com, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Currently if we wish to use kselftest to run tests within a kernel
module we write a small script to load/unload and do error reporting.
There are a bunch of these under tools/testing/selftests/lib/ that are
all identical except for the test name.  We can reduce code duplication
and improve maintainability if we have one version of this.  However
kselftest requires an executable for each test.  We can move all the
script logic to a central script then have each individual test script
set the module name and call the main script.  There is a little bit of
boilerplate left in each script to handle building/running tests with
the O=/path/to/out make option.

Add test runner creation script.

Signed-off-by: Tobin C. Harding <tobin@kernel.org>
---
 tools/testing/selftests/kselftest_module.sh | 75 +++++++++++++++++++++
 1 file changed, 75 insertions(+)
 create mode 100755 tools/testing/selftests/kselftest_module.sh

diff --git a/tools/testing/selftests/kselftest_module.sh b/tools/testing/selftests/kselftest_module.sh
new file mode 100755
index 000000000000..b5d446738614
--- /dev/null
+++ b/tools/testing/selftests/kselftest_module.sh
@@ -0,0 +1,75 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0+
+
+#
+# Runs an individual test module.  kselftest expects a separate
+# executable for each test.  So test should each have an individial
+# script that can call this script.
+#
+
+# Individual test scrits should define these:
+module=""			# filename (without the .ko).
+desc=""				# Output prefix.
+
+modprobe="/sbin/modprobe"
+
+main() {
+    parse_args $@
+    assert_root
+    assert_have_module
+    run_module
+}
+
+parse_args() {
+    script=${0##*/}
+
+    if [[ ! $# -eq 2 ]]; then
+	echo "Usage: $script <module_name> <description> [FAIL]"
+	exit 1
+    fi
+
+    module=$1
+    desc=$2
+}
+
+assert_root() {
+    if [[ $EUID -ne 0 ]]; then
+	skip "please run as root"
+    fi
+}
+
+assert_have_module() {
+    if ! $modprobe -q -n $module; then
+	skip "module $module is not found"
+    fi
+}
+
+run_module() {
+    if $modprobe -q $module; then
+	$modprobe -q -r $module
+	say "ok"
+    else
+	fail ""
+    fi
+}
+
+say() {
+    echo "$desc: $1"
+}
+
+
+fail() {
+    say "$1 [FAIL]" >&2
+    exit 1
+}
+
+skip() {
+    say "$1 [SKIP]" >&2
+    # Kselftest framework requirement - SKIP code is 4.
+    exit 4
+}
+
+#
+# Main script
+#
+main $@
-- 
2.20.1
