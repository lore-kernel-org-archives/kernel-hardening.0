Date: Fri, 9 Mar 2018 19:22:47 +0900
From: Jinbum Park <jinb.park7@gmail.com>
Subject: [PATCH] lib: Add testing module for UBSAN
Message-ID: <20180309102247.GA2944@pjb1027-Latitude-E5410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
To: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: akpm@linux-foundation.org, aryabinin@virtuozzo.com, dvyukov@google.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

This is a test module for UBSAN.
It triggers all undefined behaviors that linux supports now,
and detect them.

All test-cases have passed by compiling with gcc-5.5.0.

If use gcc-4.9.x,
misaligned, out-of-bounds, object-size-mismatch will not be detected.
Because gcc-4.9.x doesn't support them.

Signed-off-by: Jinbum Park <jinb.park7@gmail.com>
---
 lib/Kconfig.ubsan |   7 +++
 lib/Makefile      |   2 +
 lib/test_ubsan.c  | 144 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 153 insertions(+)
 create mode 100644 lib/test_ubsan.c

diff --git a/lib/Kconfig.ubsan b/lib/Kconfig.ubsan
index a669c19..19d42ea 100644
--- a/lib/Kconfig.ubsan
+++ b/lib/Kconfig.ubsan
@@ -46,3 +46,10 @@ config UBSAN_NULL
 	help
 	  This option enables detection of memory accesses via a
 	  null pointer.
+
+config TEST_UBSAN
+	tristate "Module for testing for undefined behavior detection"
+	depends on m && UBSAN
+	help
+	  This is a test module for UBSAN.
+	  It triggers various undefined behavior, and detect it.
diff --git a/lib/Makefile b/lib/Makefile
index c25957d1..f3503f8 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -54,6 +54,8 @@ obj-$(CONFIG_TEST_SYSCTL) += test_sysctl.o
 obj-$(CONFIG_TEST_HASH) += test_hash.o test_siphash.o
 obj-$(CONFIG_TEST_KASAN) += test_kasan.o
 CFLAGS_test_kasan.o += -fno-builtin
+obj-$(CONFIG_TEST_UBSAN) += test_ubsan.o
+UBSAN_SANITIZE_test_ubsan.o := y
 obj-$(CONFIG_TEST_KSTRTOX) += test-kstrtox.o
 obj-$(CONFIG_TEST_LIST_SORT) += test_list_sort.o
 obj-$(CONFIG_TEST_LKM) += test_module.o
diff --git a/lib/test_ubsan.c b/lib/test_ubsan.c
new file mode 100644
index 0000000..58dedff
--- /dev/null
+++ b/lib/test_ubsan.c
@@ -0,0 +1,144 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+typedef void(*test_ubsan_fp)(void);
+
+static void test_ubsan_add_overflow(void)
+{
+	volatile int val = INT_MAX;
+
+	val += 2;
+}
+
+static void test_ubsan_sub_overflow(void)
+{
+	volatile int val = INT_MIN;
+	volatile int val2 = 2;
+
+	val -= val2;
+}
+
+static void test_ubsan_mul_overflow(void)
+{
+	volatile int val = INT_MAX / 2;
+
+	val *= 3;
+}
+
+static void test_ubsan_negate_overflow(void)
+{
+	volatile int val = INT_MIN;
+
+	val = -val;
+}
+
+static void test_ubsan_divrem_overflow(void)
+{
+	volatile int val = 16;
+	volatile int val2 = 0;
+
+	val /= val2;
+}
+
+static void test_ubsan_vla_bound_not_positive(void)
+{
+	volatile int size = -1;
+	char buf[size];
+
+	(void)buf;
+}
+
+static void test_ubsan_shift_out_of_bounds(void)
+{
+	volatile int val = -1;
+	int val2 = 10;
+
+	val2 <<= val;
+}
+
+static void test_ubsan_out_of_bounds(void)
+{
+	volatile int i = 4, j = 5;
+	volatile int arr[i];
+
+	arr[j] = i;
+}
+
+static void test_ubsan_load_invalid_value(void)
+{
+	volatile char *dst, *src;
+	bool val, val2, *ptr;
+	char c = 4;
+
+	dst = (char *)&val;
+	src = &c;
+	*dst = *src;
+
+	ptr = &val2;
+	val2 = val;
+}
+
+static void test_ubsan_null_ptr_deref(void)
+{
+	volatile int *ptr = NULL;
+	int val;
+
+	val = *ptr;
+}
+
+void test_ubsan_misaligned_access(void)
+{
+	volatile char arr[5] __aligned(4) = {1, 2, 3, 4, 5};
+	volatile int *ptr, val = 6;
+
+	ptr = (int *)(arr + 1);
+	*ptr = val;
+}
+
+static void test_ubsan_object_size_mismatch(void)
+{
+	/* "((aligned(8)))" helps this not into be misaligned for ptr-access. */
+	volatile int val __aligned(8) = 4;
+	volatile long long *ptr, val2;
+
+	ptr = (long long *)&val;
+	val2 = *ptr;
+}
+
+static const test_ubsan_fp test_ubsan_array[] = {
+	test_ubsan_add_overflow,
+	test_ubsan_sub_overflow,
+	test_ubsan_mul_overflow,
+	test_ubsan_negate_overflow,
+	test_ubsan_divrem_overflow,
+	test_ubsan_vla_bound_not_positive,
+	test_ubsan_shift_out_of_bounds,
+	test_ubsan_out_of_bounds,
+	test_ubsan_load_invalid_value,
+	//test_ubsan_null_ptr_deref, /* exclude it because there is a crash */
+	test_ubsan_misaligned_access,
+	test_ubsan_object_size_mismatch,
+};
+
+static int __init test_ubsan_init(void)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(test_ubsan_array); i++)
+		test_ubsan_array[i]();
+
+	(void)test_ubsan_null_ptr_deref; /* to avoid unsed-function warning */
+	return 0;
+}
+module_init(test_ubsan_init);
+
+static void __exit test_ubsan_exit(void)
+{
+	/* do nothing */
+}
+module_exit(test_ubsan_exit);
+
+MODULE_AUTHOR("Jinbum Park <jinb.park7@gmail.com>");
+MODULE_LICENSE("GPL v2");
-- 
1.9.1
