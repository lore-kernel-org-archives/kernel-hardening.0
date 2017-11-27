From: Djalal Harouni <tixxdz@gmail.com>
Date: Mon, 27 Nov 2017 18:18:35 +0100
Message-Id: <1511803118-2552-3-git-send-email-tixxdz@gmail.com>
In-Reply-To: <1511803118-2552-1-git-send-email-tixxdz@gmail.com>
References: <1511803118-2552-1-git-send-email-tixxdz@gmail.com>
Subject: [kernel-hardening] [PATCH v5 next 2/5] modules:capabilities: add cap_kernel_module_request() permission check
To: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, James Morris <james.l.morris@oracle.com>, Ben Hutchings <ben.hutchings@codethink.co.uk>, Solar Designer <solar@openwall.com>, Serge Hallyn <serge@hallyn.com>, Jessica Yu <jeyu@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@kernel.org>, "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

This is a preparation patch to improve for the module auto-load
infrastrucutre.

With this change, subsystems that want to autoload modules and implement
onsite capability checks, can defer the checks to the capability
subsystem by passing the required capabilities with the appropriate
modules alias. The capability subsystem will trust callers about
the passed values and perform a capability check to either allow module
auto-loading or deny it.

This patch changes:
* Adds cap_kernel_module_request() capability hook.
* Adds an empty may_autoload_module() that will be updated in the next
  patch.

Cc: James Morris <james.l.morris@oracle.com>
Cc: Serge Hallyn <serge@hallyn.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ben Hutchings <ben.hutchings@codethink.co.uk>
Suggested-by: Rusty Russell <rusty@rustcorp.com.au>
Suggested-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
---
 include/linux/module.h   | 10 ++++++++++
 include/linux/security.h |  4 +++-
 kernel/module.c          | 23 +++++++++++++++++++++++
 security/commoncap.c     | 26 ++++++++++++++++++++++++++
 4 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index c69b49a..5cbb239 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -497,6 +497,10 @@ bool __is_module_percpu_address(unsigned long addr, unsigned long *can_addr);
 bool is_module_percpu_address(unsigned long addr);
 bool is_module_text_address(unsigned long addr);
 
+/* Determine whether a module auto-load operation is permitted. */
+int may_autoload_module(char *kmod_name, int required_cap,
+			const char *kmod_prefix);
+
 static inline bool within_module_core(unsigned long addr,
 				      const struct module *mod)
 {
@@ -643,6 +647,12 @@ bool is_module_sig_enforced(void);
 
 #else /* !CONFIG_MODULES... */
 
+static inline int may_autoload_module(char *kmod_name, int required_cap,
+				      const char *kmod_prefix)
+{
+	return -ENOSYS;
+}
+
 static inline struct module *__module_address(unsigned long addr)
 {
 	return NULL;
diff --git a/include/linux/security.h b/include/linux/security.h
index 41e700a..9bb53b5 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -102,6 +102,8 @@ extern int cap_task_setscheduler(struct task_struct *p);
 extern int cap_task_setioprio(struct task_struct *p, int ioprio);
 extern int cap_task_setnice(struct task_struct *p, int nice);
 extern int cap_vm_enough_memory(struct mm_struct *mm, long pages);
+extern int cap_kernel_module_request(char *kmod_name, int required_cap,
+				     const char *kmod_prefix);
 
 struct msghdr;
 struct sk_buff;
@@ -924,7 +926,7 @@ static inline int security_kernel_module_request(char *kmod_name,
 						 int required_cap,
 						 const char *prefix)
 {
-	return 0;
+	return cap_kernel_module_request(kmod_name, required_cap, prefix);
 }
 
 static inline int security_kernel_read_file(struct file *file,
diff --git a/kernel/module.c b/kernel/module.c
index f0411a2..3380d39 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -4340,6 +4340,29 @@ struct module *__module_text_address(unsigned long addr)
 }
 EXPORT_SYMBOL_GPL(__module_text_address);
 
+/**
+ * may_autoload_module - Determine whether a module auto-load operation
+ * is permitted
+ * @kmod_name: The module name
+ * @required_cap: if positive, may allow to auto-load the module if this
+ *	capability is set
+ * @kmod_prefix: The module prefix if any, otherwise NULL
+ *
+ * Determine whether a module auto-load operation is allowed or not.
+ *
+ * This allows to have more control on automatic module loading, and align it
+ * with explicit load/unload module operations. The kernel contains several
+ * modules, some of them are not updated often and may contain bugs and
+ * vulnerabilities.
+ *
+ * Returns 0 if the module request is allowed or -EPERM if not.
+ */
+int may_autoload_module(char *kmod_name, int required_cap,
+			const char *kmod_prefix)
+{
+	return 0;
+}
+
 /* Don't grab lock, we're oopsing. */
 void print_modules(void)
 {
diff --git a/security/commoncap.c b/security/commoncap.c
index 4f8e093..236e573 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -1340,6 +1340,31 @@ int cap_mmap_file(struct file *file, unsigned long reqprot,
 	return 0;
 }
 
+/**
+ * cap_kernel_module_request - Determine whether a module auto-load is permitted
+ * @kmod_name: The module name
+ * @required_cap: if positive, may allow to auto-load the module if this
+ *	capability is set
+ * @kmod_prefix: the module prefix if any, otherwise NULL
+ *
+ * Determine whether a module should be automatically loaded.
+ * Returns 0 if the module request should be allowed, -EPERM if not.
+ */
+int cap_kernel_module_request(char *kmod_name, int required_cap,
+			      const char *kmod_prefix)
+{
+	int ret;
+	char comm[sizeof(current->comm)];
+
+	ret = may_autoload_module(kmod_name, required_cap, kmod_prefix);
+	if (ret < 0)
+		pr_notice_ratelimited(
+			"module: automatic module loading of %.64s by \"%s\"[%d] was denied\n",
+			kmod_name, get_task_comm(comm, current), current->pid);
+
+	return ret;
+}
+
 #ifdef CONFIG_SECURITY
 
 struct security_hook_list capability_hooks[] __lsm_ro_after_init = {
@@ -1361,6 +1386,7 @@ struct security_hook_list capability_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(task_setioprio, cap_task_setioprio),
 	LSM_HOOK_INIT(task_setnice, cap_task_setnice),
 	LSM_HOOK_INIT(vm_enough_memory, cap_vm_enough_memory),
+	LSM_HOOK_INIT(kernel_module_request, cap_kernel_module_request),
 };
 
 void __init capability_add_hooks(void)
-- 
2.7.4
