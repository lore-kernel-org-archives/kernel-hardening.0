From: Eddie Kovsky <ewk@edkovsky.org>
Date: Sun, 26 Mar 2017 15:08:24 -0600
Message-Id: <20170326210825.23255-2-ewk@edkovsky.org>
In-Reply-To: <20170326210825.23255-1-ewk@edkovsky.org>
References: <20170326210825.23255-1-ewk@edkovsky.org>
Subject: [kernel-hardening] [PATCH v4 1/2] module: verify address is read-only
To: jeyu@redhat.com, rusty@rustcorp.com.au, keescook@chromium.org
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Implement a mechanism to check if a module's address is in
the rodata or ro_after_init sections. It mimics the existing functions
that test if an address is inside a module's text section.

Functions that take a module as an argument will be able to verify that the
module address is in a read-only section. The idea is to prevent structures
(including modules) that are not read-only from being passed to functions.

This implements the first half of a suggestion made by Kees Cook for
the Kernel Self Protection Project:

    - provide mechanism to check for ro_after_init memory areas, and
      reject structures not marked ro_after_init in vmbus_register()

Suggested-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Eddie Kovsky <ewk@edkovsky.org>
---
Changes in v4:
 - Rename function __module_ro_address() to __module_rodata_address()
 - Move module_rodata_address() stub below is_module_address()
 - Minor comment fixes
 - Verify that mod is not NULL before setting up layout variables
Changes in v3:
 - Change function name is_module_ro_address() to
is_module_rodata_address().
 - Improve comments on is_module_rodata_address().
 - Add a !CONFIG_MODULES stub for is_module_rodata_address.
 - Correct and simplify the check for the read-only memory regions in
the module address.
---
 include/linux/module.h | 12 ++++++++++++
 kernel/module.c        | 53 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+)

diff --git a/include/linux/module.h b/include/linux/module.h
index 9ad68561d8c2..a3d17b081de3 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -492,7 +492,9 @@ static inline int module_is_live(struct module *mod)
 
 struct module *__module_text_address(unsigned long addr);
 struct module *__module_address(unsigned long addr);
+struct module *__module_rodata_address(unsigned long addr);
 bool is_module_address(unsigned long addr);
+bool is_module_rodata_address(unsigned long addr);
 bool __is_module_percpu_address(unsigned long addr, unsigned long *can_addr);
 bool is_module_percpu_address(unsigned long addr);
 bool is_module_text_address(unsigned long addr);
@@ -646,6 +648,11 @@ static inline struct module *__module_address(unsigned long addr)
 	return NULL;
 }
 
+static inline struct module *__module_rodata_address(unsigned long addr)
+{
+	return NULL;
+}
+
 static inline struct module *__module_text_address(unsigned long addr)
 {
 	return NULL;
@@ -656,6 +663,11 @@ static inline bool is_module_address(unsigned long addr)
 	return false;
 }
 
+static inline bool is_module_rodata_address(unsigned long addr)
+{
+	return false;
+}
+
 static inline bool is_module_percpu_address(unsigned long addr)
 {
 	return false;
diff --git a/kernel/module.c b/kernel/module.c
index 8ffcd29a4245..26bd62c61d87 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -4292,6 +4292,59 @@ struct module *__module_text_address(unsigned long addr)
 }
 EXPORT_SYMBOL_GPL(__module_text_address);
 
+/**
+ * is_module_rodata_address - is this address inside read-only module data?
+ * @addr: the address to check.
+ *
+ */
+bool is_module_rodata_address(unsigned long addr)
+{
+	bool ret;
+
+	preempt_disable();
+	ret = __module_rodata_address(addr) != NULL;
+	preempt_enable();
+
+	return ret;
+}
+
+/*
+ * __module_rodata_address - get the module whose rodata/ro_after_init sections
+ * contain the given address.
+ * @addr: the address.
+ *
+ * Must be called with preempt disabled or module mutex held so that
+ * module doesn't get freed during this.
+ */
+struct module *__module_rodata_address(unsigned long addr)
+{
+	struct module *mod = __module_address(addr);
+
+	/*
+	 * Make sure module is within the read-only section.
+	 * range(base + text_size, base + ro_after_init_size)
+	 * encompasses both the rodata and ro_after_init regions.
+	 * See comment above frob_text() for the layout diagram.
+	 */
+	if (mod) {
+		void *init_base = mod->init_layout.base;
+		unsigned int init_text_size = mod->init_layout.text_size;
+		unsigned int init_ro_after_init_size = mod->init_layout.ro_after_init_size;
+
+		void *core_base = mod->core_layout.base;
+		unsigned int core_text_size = mod->core_layout.text_size;
+		unsigned int core_ro_after_init_size = mod->core_layout.ro_after_init_size;
+
+		if (!within(addr, init_base + init_text_size,
+			    init_ro_after_init_size - init_text_size)
+		    && !within(addr, core_base + core_text_size,
+			       core_ro_after_init_size - core_text_size))
+			mod = NULL;
+	}
+	return mod;
+}
+EXPORT_SYMBOL_GPL(__module_rodata_address);
+
 /* Don't grab lock, we're oopsing. */
 void print_modules(void)
 {
-- 
2.12.1
