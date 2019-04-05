From: "Tobin C. Harding" <tobin@kernel.org>
Subject: [PATCH v4 4/6] lib: Use new kselftest header
Date: Fri,  5 Apr 2019 12:58:57 +1100
Message-Id: <20190405015859.32755-5-tobin@kernel.org>
In-Reply-To: <20190405015859.32755-1-tobin@kernel.org>
References: <20190405015859.32755-1-tobin@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Shuah Khan <shuah@kernel.org>
Cc: "Tobin C. Harding" <tobin@kernel.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Randy Dunlap <rdunlap@infradead.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Stephen Rothwell <sfr@canb.auug.org.au>, Andy Lutomirski <luto@amacapital.net>, Daniel Micay <danielmicay@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, kernel-hardening@lists.openwall.com, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

We just added a new C header file for use with test modules that are
intended to be run with kselftest.  We can reduce code duplication by
using this header.

Use new kselftest header to reduce code duplication in test_printf and
test_bitmap test modules.

Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Tobin C. Harding <tobin@kernel.org>
---
 lib/test_bitmap.c | 20 ++++----------------
 lib/test_printf.c | 23 +++++------------------
 2 files changed, 9 insertions(+), 34 deletions(-)

diff --git a/lib/test_bitmap.c b/lib/test_bitmap.c
index 6cd7d0740005..792d90608052 100644
--- a/lib/test_bitmap.c
+++ b/lib/test_bitmap.c
@@ -12,6 +12,8 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 
+#include "../tools/testing/selftests/kselftest_module.h"
+
 static unsigned total_tests __initdata;
 static unsigned failed_tests __initdata;
 
@@ -361,7 +363,7 @@ static void noinline __init test_mem_optimisations(void)
 	}
 }
 
-static int __init test_bitmap_init(void)
+static void __init selftest(void)
 {
 	test_zero_clear();
 	test_fill_set();
@@ -369,22 +371,8 @@ static int __init test_bitmap_init(void)
 	test_bitmap_arr32();
 	test_bitmap_parselist();
 	test_mem_optimisations();
-
-	if (failed_tests == 0)
-		pr_info("all %u tests passed\n", total_tests);
-	else
-		pr_warn("failed %u out of %u tests\n",
-			failed_tests, total_tests);
-
-	return failed_tests ? -EINVAL : 0;
 }
 
-static void __exit test_bitmap_cleanup(void)
-{
-}
-
-module_init(test_bitmap_init);
-module_exit(test_bitmap_cleanup);
-
+KSTM_MODULE_LOADERS(test_bitmap);
 MODULE_AUTHOR("david decotigny <david.decotigny@googlers.com>");
 MODULE_LICENSE("GPL");
diff --git a/lib/test_printf.c b/lib/test_printf.c
index 601e8519319a..f4fcc1c43739 100644
--- a/lib/test_printf.c
+++ b/lib/test_printf.c
@@ -21,6 +21,8 @@
 #include <linux/gfp.h>
 #include <linux/mm.h>
 
+#include "../tools/testing/selftests/kselftest_module.h"
+
 #define BUF_SIZE 256
 #define PAD_SIZE 16
 #define FILL_CHAR '$'
@@ -590,12 +592,11 @@ test_pointer(void)
 	flags();
 }
 
-static int __init
-test_printf_init(void)
+static void __init selftest(void)
 {
 	alloced_buffer = kmalloc(BUF_SIZE + 2*PAD_SIZE, GFP_KERNEL);
 	if (!alloced_buffer)
-		return -ENOMEM;
+		return;
 	test_buffer = alloced_buffer + PAD_SIZE;
 
 	test_basic();
@@ -604,22 +605,8 @@ test_printf_init(void)
 	test_pointer();
 
 	kfree(alloced_buffer);
-
-	if (failed_tests == 0)
-		pr_info("all %u tests passed\n", total_tests);
-	else
-		pr_warn("failed %u out of %u tests\n", failed_tests, total_tests);
-
-	return failed_tests ? -EINVAL : 0;
 }
 
-module_init(test_printf_init);
-
-static void __exit test_printf_exit(void)
-{
-}
-
-module_exit(test_printf_exit);
-
+KSTM_MODULE_LOADERS(test_printf);
 MODULE_AUTHOR("Rasmus Villemoes <linux@rasmusvillemoes.dk>");
 MODULE_LICENSE("GPL");
-- 
2.21.0
