From: "Tobin C. Harding" <me@tobin.cc>
Date: Thu,  2 Nov 2017 10:50:40 +1100
Message-Id: <1509580240-28314-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [RFC] vla: add VLA macro and testing
To: kernel-hardening@lists.openwall.com
Cc: "Tobin C. Harding" <me@tobin.cc>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

Variable Length Arrays (VLA) pose a risk to the stack if the variable
passed into the array declaration is too large. If the variable used can
be controlled by a malicious party then this poses a security risk to
the kernel.

Add a macro for declaring VLA's. Macro includes a requested size and a
maximum size, if requested size is larger than maximum size then
requested size is capped at maximum. Requested size is passed by
reference and updated by macro so caller has access to size of array
after declaration.

Signed-off-by: Tobin C. Harding <me@tobin.cc>

---

I was unable to get the test module to integrate with the kernel build system
correctly. The attempt was to mirror the way `lib/test_printf.c` functions. This
effort was unsuccessful, it is included in the patch in the hope of getting
better suggestions. To test, the test module was built out of tree and all tests
pass.  

The macro needs some work. It functions as intended but

Checkpatch emits ERROR: Macros with multiple statements should be enclosed in a
do - while loop.

Also for each use of VLA() checkpatch emits WARNING: Missing a blank line after
declarations.

Also I was unsure where to put the macro definition, appreciate any suggestions.

thanks,
Tobin.

 include/linux/vla.h                | 24 ++++++++++
 lib/Kconfig.debug                  |  3 ++
 lib/Makefile                       |  1 +
 lib/test_vla.c                     | 98 ++++++++++++++++++++++++++++++++++++++
 tools/testing/selftests/lib/config |  1 +
 5 files changed, 127 insertions(+)
 create mode 100644 include/linux/vla.h
 create mode 100644 lib/test_vla.c

diff --git a/include/linux/vla.h b/include/linux/vla.h
new file mode 100644
index 000000000000..e8f1572bbf42
--- /dev/null
+++ b/include/linux/vla.h
@@ -0,0 +1,24 @@
+/*
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+#ifndef __LINUX_VLA_H
+#define __LINUX_VLA_H
+
+/*
+ * When declaring a local variable using VLA(), VLA() must be the last
+ * declaration otherwise a compiler warning [-Wdeclaration-after-statement] will
+ * be generated
+ */
+#define VLA(type, name, size, max) \
+	type name[(*size < max ? *size : max)]; \
+	*size = (*size < max ? *size : max)
+
+#endif	/* __LINUX_VLA_H */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index dfdad67d8f6c..3b8eb2789235 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1917,6 +1917,9 @@ config TEST_DEBUG_VIRTUAL
 
 	  If unsure, say N.
 
+config TEST_VLA
+	tristate "Test VLA macro at runtime"
+
 endmenu # runtime tests
 
 config MEMTEST
diff --git a/lib/Makefile b/lib/Makefile
index dafa79613fb4..b1e8f7c54c5b 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -63,6 +63,7 @@ obj-$(CONFIG_TEST_UUID) += test_uuid.o
 obj-$(CONFIG_TEST_PARMAN) += test_parman.o
 obj-$(CONFIG_TEST_KMOD) += test_kmod.o
 obj-$(CONFIG_TEST_DEBUG_VIRTUAL) += test_debug_virtual.o
+obj-$(CONFIG_TEST_VLA) += test_vla.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
diff --git a/lib/test_vla.c b/lib/test_vla.c
new file mode 100644
index 000000000000..033aeb219062
--- /dev/null
+++ b/lib/test_vla.c
@@ -0,0 +1,98 @@
+/*
+ * Tests for VLA macro.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/printk.h>
+
+#include <linux/vla.h>
+
+#define MAX_VLA_SIZE 32
+
+static unsigned total_tests __initdata;
+static unsigned failed_tests __initdata;
+
+static int __init test_vla_less_than_max(int want)
+{
+	int *size = &want;
+	VLA(char, myvla, size, MAX_VLA_SIZE);
+
+	total_tests++;
+
+	if (*size != want) {
+		pr_warn("VLA() declaration error: size=%d want=%d max=%d\n",
+			*size, want, MAX_VLA_SIZE);
+		return 1;
+	}
+
+	/* quiet compiler warning */
+	myvla[0] = 'a';
+
+	return 0;
+}
+
+static int __init test_vla_greater_than_max(int want)
+{
+	int *size = &want;
+	VLA(char, myvla, size, MAX_VLA_SIZE);
+
+	total_tests++;
+
+	if (*size != MAX_VLA_SIZE) {
+		pr_warn("VLA() declaration error: size=%d want=%d max=%d\n",
+			*size, want, MAX_VLA_SIZE);
+		return 1;
+	}
+
+	/* quiet compiler warning */
+	myvla[0] = 'a';
+
+	return 0;
+}
+
+static void __init test_vla_int_type_usage(int want)
+{
+	int *size = &want;
+	int i;
+	VLA(int, myvla, size, MAX_VLA_SIZE);
+
+	total_tests++;
+
+	for (i = 0; i < *size; i++)
+		myvla[i] = 0;
+}
+
+static int __init test_vla_init(void)
+{
+	int lt_max = MAX_VLA_SIZE / 2;
+	int gt_max = MAX_VLA_SIZE * 2;
+	int err;
+
+	err = test_vla_less_than_max(lt_max);
+	if (err)
+		failed_tests++;
+
+	err = test_vla_greater_than_max(gt_max);
+	if (err)
+		failed_tests++;
+
+	test_vla_int_type_usage(lt_max);
+	test_vla_int_type_usage(gt_max);
+
+	if (failed_tests == 0)
+		pr_info("all %u tests passed\n", total_tests);
+	else
+		pr_warn("failed %u out of %u tests\n",
+			failed_tests, total_tests);
+
+	return failed_tests ? -EINVAL : 0;
+}
+
+module_init(test_vla_init);
+
+MODULE_AUTHOR("Tobin C. Harding <me@tobin.cc>");
+MODULE_LICENSE("GPL");
diff --git a/tools/testing/selftests/lib/config b/tools/testing/selftests/lib/config
index 126933bcc950..0776156f881d 100644
--- a/tools/testing/selftests/lib/config
+++ b/tools/testing/selftests/lib/config
@@ -1,3 +1,4 @@
 CONFIG_TEST_PRINTF=m
 CONFIG_TEST_BITMAP=m
 CONFIG_PRIME_NUMBERS=m
+CONFIG_TEST_VLA=m
-- 
2.7.4
