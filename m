From: Eddie Kovsky <ewk@edkovsky.org>
Date: Sun, 12 Feb 2017 16:31:40 -0700
Message-Id: <20170212233140.10606-3-ewk@edkovsky.org>
In-Reply-To: <20170212233140.10606-1-ewk@edkovsky.org>
References: <20170212233140.10606-1-ewk@edkovsky.org>
Subject: [kernel-hardening] [RFC] [PATCH 2/2] extable: verify address is read-only
To: jeyu@redhat.com, rusty@rustcorp.com.au, keescook@chromium.org
Cc: kernel-hardening@lists.openwall.com, Eddie Kovsky <ewk@edkovsky.org>
List-ID: <kernel-hardening.lists.openwall.com>

Provide a mechanism to check if the address of a variable is
const or ro_after_init. It mimics the existing functions that test if an
address is inside the kernel's text section.

Signed-off-by: Eddie Kovsky <ewk@edkovsky.org>
---
 include/linux/kernel.h |  2 ++
 kernel/extable.c       | 31 +++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 4c26dc3a8295..51beea39e6c4 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -444,6 +444,8 @@ extern int core_kernel_data(unsigned long addr);
 extern int __kernel_text_address(unsigned long addr);
 extern int kernel_text_address(unsigned long addr);
 extern int func_ptr_is_kernel_text(void *ptr);
+extern int core_kernel_ro_data(unsigned long addr);
+extern int kernel_ro_address(unsigned long addr);

 unsigned long int_sqrt(unsigned long);

diff --git a/kernel/extable.c b/kernel/extable.c
index 6b0d09051efb..f5a29c4ae391 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -149,3 +149,34 @@ int func_ptr_is_kernel_text(void *ptr)
 		return 1;
 	return is_module_text_address(addr);
 }
+
+/**
+ * core_kernel_ro_data - Verify address points to read-only section
+ * @addr: address to test
+ *
+ */
+int core_kernel_ro_data(unsigned long addr)
+{
+	if (addr >= (unsigned long)__start_rodata &&
+	    addr < (unsigned long)__end_rodata)
+		return 1;
+
+	if (addr >= (unsigned long)__start_data_ro_after_init &&
+	    addr < (unsigned long)__end_data_ro_after_init)
+		return 1;
+
+	return 0;
+}
+
+/* Verify that address is const or ro_after_init. */
+int kernel_ro_address(unsigned long addr)
+{
+	if (core_kernel_ro_data(addr))
+		return 1;
+	if (is_module_ro_address(addr))
+		return 1;
+	if (is_ftrace_trampoline(addr))
+		return 1;
+
+	return 0;
+}
--
2.11.1
