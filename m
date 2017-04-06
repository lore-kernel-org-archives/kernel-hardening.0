From: Eddie Kovsky <ewk@edkovsky.org>
Date: Wed,  5 Apr 2017 21:35:50 -0600
Message-Id: <20170406033550.32525-3-ewk@edkovsky.org>
In-Reply-To: <20170406033550.32525-1-ewk@edkovsky.org>
References: <20170406033550.32525-1-ewk@edkovsky.org>
Subject: [kernel-hardening] [PATCH v5 2/2] extable: verify address is read-only
To: jeyu@redhat.com, rusty@rustcorp.com.au, keescook@chromium.org
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Provide a mechanism to check if the address of a variable is
const or ro_after_init. It mimics the existing functions that test if an
address is inside the kernel's text section.

The idea is to prevent structures that are not read-only from being
passed to functions. Other functions inside the kernel could then use
this capability to verify that their arguments are read-only.

This implements the first half of a suggestion made by Kees Cook for
the Kernel Self Protection Project:

	- provide mechanism to check for ro_after_init memory areas, and
	reject structures not marked ro_after_init in vmbus_register()

Suggested-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Eddie Kovsky <ewk@edkovsky.org>
---
Changes in v5:
 - Replace __start_data_ro_after_init with __start_ro_after_init
 - Replace __end_data_ro_after_init with __end_ro_after_init
Changes in v4:
 - Rename function core_kernel_ro_data() to core_kernel_rodata().
Changes in v3:
 - Fix missing declaration of is_module_rodata_address()
---
 include/linux/kernel.h |  2 ++
 kernel/extable.c       | 29 +++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 4c26dc3a8295..5748784ca209 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -444,6 +444,8 @@ extern int core_kernel_data(unsigned long addr);
 extern int __kernel_text_address(unsigned long addr);
 extern int kernel_text_address(unsigned long addr);
 extern int func_ptr_is_kernel_text(void *ptr);
+extern int core_kernel_rodata(unsigned long addr);
+extern int kernel_ro_address(unsigned long addr);
 
 unsigned long int_sqrt(unsigned long);
 
diff --git a/kernel/extable.c b/kernel/extable.c
index 2676d7f8baf6..18c5e4dbe0fc 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -154,3 +154,32 @@ int func_ptr_is_kernel_text(void *ptr)
 		return 1;
 	return is_module_text_address(addr);
 }
+
+/**
+ * core_kernel_rodata - Verify address points to read-only section
+ * @addr: address to test
+ *
+ */
+int core_kernel_rodata(unsigned long addr)
+{
+	if (addr >= (unsigned long)__start_rodata &&
+	    addr < (unsigned long)__end_rodata)
+		return 1;
+
+	if (addr >= (unsigned long)__start_ro_after_init &&
+	    addr < (unsigned long)__end_ro_after_init)
+		return 1;
+
+	return 0;
+}
+
+/* Verify that address is const or ro_after_init. */
+int kernel_ro_address(unsigned long addr)
+{
+	if (core_kernel_rodata(addr))
+		return 1;
+	if (is_module_rodata_address(addr))
+		return 1;
+
+	return 0;
+}
-- 
2.12.2
