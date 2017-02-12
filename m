From: Eddie Kovsky <ewk@edkovsky.org>
Date: Sun, 12 Feb 2017 16:31:39 -0700
Message-Id: <20170212233140.10606-2-ewk@edkovsky.org>
In-Reply-To: <20170212233140.10606-1-ewk@edkovsky.org>
References: <20170212233140.10606-1-ewk@edkovsky.org>
Subject: [kernel-hardening] [RFC] [PATCH 1/2] module: verify address is read-only
To: jeyu@redhat.com, rusty@rustcorp.com.au, keescook@chromium.org
Cc: kernel-hardening@lists.openwall.com, Eddie Kovsky <ewk@edkovsky.org>
List-ID: <kernel-hardening.lists.openwall.com>

Implement a mechanism to check if a module's address is in
the rodata or ro_after_init sections. It mimics the exsiting functions
that test if an address is inside a module's text section.

Signed-off-by: Eddie Kovsky <ewk@edkovsky.org>
---
 include/linux/module.h |  2 ++
 kernel/module.c        | 44 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/include/linux/module.h b/include/linux/module.h
index 0297c5cd7cdf..2848416f7715 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -492,7 +492,9 @@ static inline int module_is_live(struct module *mod)

 struct module *__module_text_address(unsigned long addr);
 struct module *__module_address(unsigned long addr);
+struct module *__module_ro_address(unsigned long addr);
 bool is_module_address(unsigned long addr);
+bool is_module_ro_address(unsigned long addr);
 bool is_module_percpu_address(unsigned long addr);
 bool is_module_text_address(unsigned long addr);

diff --git a/kernel/module.c b/kernel/module.c
index 8168eb738f4d..e7eb329c585d 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -4270,6 +4270,50 @@ struct module *__module_text_address(unsigned long addr)
 }
 EXPORT_SYMBOL_GPL(__module_text_address);

+/**
+ * is_module_text_ro_address - is this address inside read-only module code?
+ * @addr: the address to check.
+ *
+ */
+bool is_module_ro_address(unsigned long addr)
+{
+	bool ret;
+
+	preempt_disable();
+	ret = __module_ro_address(addr) != NULL;
+	preempt_enable();
+
+	return ret;
+}
+
+/*
+ * __module_ro_address - get the module whose code contains a read-only address.
+ * @addr: the address.
+ *
+ * Must be called with preempt disabled or module mutex held so that
+ * module doesn't get freed during this.
+ */
+struct module *__module_ro_address(unsigned long addr)
+{
+	struct module *mod = __module_address(addr);
+
+	if (mod) {
+		/* Make sure it's within the read-only section. */
+		if (!within(addr, mod->init_layout.base,
+			    mod->init_layout.ro_size)
+		    && !within(addr, mod->core_layout.base,
+			       mod->core_layout.ro_size))
+			mod = NULL;
+		if (!within(addr, mod->init_layout.base,
+			    mod->init_layout.ro_after_init_size)
+		    && !within(addr, mod->core_layout.base,
+			       mod->core_layout.ro_after_init_size))
+			mod = NULL;
+	}
+	return mod;
+}
+EXPORT_SYMBOL_GPL(__module_ro_address);
+
 /* Don't grab lock, we're oopsing. */
 void print_modules(void)
 {
--
2.11.1
