From: Casey Schaufler <casey.schaufler@intel.com>
Subject: [PATCH RFC v2 3/5] LSM: Security module checking for side-channel dangers
Date: Fri, 17 Aug 2018 15:16:22 -0700
Message-Id: <20180817221624.10232-4-casey.schaufler@intel.com>
In-Reply-To: <20180817221624.10232-1-casey.schaufler@intel.com>
References: <20180817221624.10232-1-casey.schaufler@intel.com>
To: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, casey.schaufler@intel.com, dave.hansen@intel.com, deneen.t.dock@intel.com, kristen@linux.intel.com, arjan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

From: Casey Schaufler <cschaufler@localhost.localdomain>

The sidechannel LSM checks for cases where a side-channel
attack may be dangerous based on security attributes of tasks.
This includes:
	Effective UID of the tasks is different
	Capablity sets are different
	Tasks are in different namespaces
An option is also provided to assert that task are never
to be considered safe. This is high paranoia, and expensive
as well.

Signed-off-by: Casey Schaufler <casey.schaufler@intel.com>
---
 MAINTAINERS                        |   6 ++
 include/linux/lsm_hooks.h          |   5 +
 security/Kconfig                   |   1 +
 security/Makefile                  |   2 +
 security/security.c                |   1 +
 security/sidechannel/Kconfig       |  60 +++++++++++
 security/sidechannel/Makefile      |   1 +
 security/sidechannel/sidechannel.c | 156 +++++++++++++++++++++++++++++
 8 files changed, 232 insertions(+)
 create mode 100644 security/sidechannel/Kconfig
 create mode 100644 security/sidechannel/Makefile
 create mode 100644 security/sidechannel/sidechannel.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 3119bba7971c..d078d6a5b471 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13066,6 +13066,12 @@ F:	drivers/slimbus/
 F:	Documentation/devicetree/bindings/slimbus/
 F:	include/linux/slimbus.h
 
+SIDECHANNEL SECURITY MODULE
+M:	Casey Schaufler <casey.schaufler@intel.com>
+L:	linux-security-module@vger.kernel.org
+S:	Maintained
+F:	security/sidechannel/
+
 SMACK SECURITY MODULE
 M:	Casey Schaufler <casey@schaufler-ca.com>
 L:	linux-security-module@vger.kernel.org
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index fd2a7e6beb01..d48e4a085fe2 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -2088,5 +2088,10 @@ void __init loadpin_add_hooks(void);
 #else
 static inline void loadpin_add_hooks(void) { };
 #endif
+#ifdef CONFIG_SECURITY_SIDECHANNEL
+void __init sidechannel_add_hooks(void);
+#else
+static inline void sidechannel_add_hooks(void) { };
+#endif
 
 #endif /* ! __LINUX_LSM_HOOKS_H */
diff --git a/security/Kconfig b/security/Kconfig
index c4302067a3ad..28cb7b2939ee 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -237,6 +237,7 @@ source security/tomoyo/Kconfig
 source security/apparmor/Kconfig
 source security/loadpin/Kconfig
 source security/yama/Kconfig
+source security/sidechannel/Kconfig
 
 source security/integrity/Kconfig
 
diff --git a/security/Makefile b/security/Makefile
index 4d2d3782ddef..d0c9e1b227f9 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -10,6 +10,7 @@ subdir-$(CONFIG_SECURITY_TOMOYO)        += tomoyo
 subdir-$(CONFIG_SECURITY_APPARMOR)	+= apparmor
 subdir-$(CONFIG_SECURITY_YAMA)		+= yama
 subdir-$(CONFIG_SECURITY_LOADPIN)	+= loadpin
+subdir-$(CONFIG_SECURITY_SIDECHANNEL)	+= sidechannel
 
 # always enable default capabilities
 obj-y					+= commoncap.o
@@ -25,6 +26,7 @@ obj-$(CONFIG_SECURITY_TOMOYO)		+= tomoyo/
 obj-$(CONFIG_SECURITY_APPARMOR)		+= apparmor/
 obj-$(CONFIG_SECURITY_YAMA)		+= yama/
 obj-$(CONFIG_SECURITY_LOADPIN)		+= loadpin/
+obj-$(CONFIG_SECURITY_SIDECHANNEL)	+= sidechannel/
 obj-$(CONFIG_CGROUP_DEVICE)		+= device_cgroup.o
 
 # Object integrity file lists
diff --git a/security/security.c b/security/security.c
index 353b711e635a..777919349751 100644
--- a/security/security.c
+++ b/security/security.c
@@ -80,6 +80,7 @@ int __init security_init(void)
 	capability_add_hooks();
 	yama_add_hooks();
 	loadpin_add_hooks();
+	sidechannel_add_hooks();
 
 	/*
 	 * Load all the remaining security modules.
diff --git a/security/sidechannel/Kconfig b/security/sidechannel/Kconfig
new file mode 100644
index 000000000000..af9396534128
--- /dev/null
+++ b/security/sidechannel/Kconfig
@@ -0,0 +1,60 @@
+config SECURITY_SIDECHANNEL
+	bool "Sidechannel attack safety extra checks"
+	depends on SECURITY
+	default n
+	help
+	  Look for a variety of cases where a side-channel attack
+	  could potentially be exploited. Instruct the switching
+	  code to use the indirect_branch_prediction_barrier in
+	  cases where the passed task and the current task may be
+	  at risk.
+
+          If you are unsure how to answer this question, answer N.
+
+config SECURITY_SIDECHANNEL_UIDS
+	bool "Sidechannel check on UID"
+	depends on SECURITY_SIDECHANNEL
+	default n
+	help
+	  Assume that tasks with different effective UIDs may be
+	  subject to side-channel attacks. As most task switching
+	  occurs between tasks with different effective UIDs this
+	  can have a significant performance impact.
+
+          If you are unsure how to answer this question, answer N.
+
+
+config SECURITY_SIDECHANNEL_CAPABILITIES
+	bool "Sidechannel check on capability sets"
+	depends on SECURITY_SIDECHANNEL
+	default n
+	help
+	  Assume that tasks with different sets of privilege may be
+	  subject to side-channel attacks. Potential interactions
+	  where the attacker lacks capabilities the attacked has
+	  are blocked.
+
+          If you are unsure how to answer this question, answer N.
+
+config SECURITY_SIDECHANNEL_NAMESPACES
+	bool "Sidechannel check on namespaces"
+	depends on SECURITY_SIDECHANNEL
+	depends on NAMESPACES
+	default n
+	help
+	  Assume that tasks in different namespaces may be
+	  subject to side-channel attacks. User, PID and cgroup
+	  namespaces are checked.
+
+          If you are unsure how to answer this question, answer N.
+
+config SECURITY_SIDECHANNEL_ALWAYS
+	bool "Sidechannel assumed to always be possible"
+	depends on SECURITY_SIDECHANNEL
+	default n
+	help
+	  Assume that all tasks may be subject to side-channel attacks.
+	  Always instruct the system to use countermeasures regardless
+	  of the potential impact.
+
+          If you are unsure how to answer this question, answer N.
diff --git a/security/sidechannel/Makefile b/security/sidechannel/Makefile
new file mode 100644
index 000000000000..f61d83f28035
--- /dev/null
+++ b/security/sidechannel/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_SECURITY_SIDECHANNEL) += sidechannel.o
diff --git a/security/sidechannel/sidechannel.c b/security/sidechannel/sidechannel.c
new file mode 100644
index 000000000000..9dc875611bd8
--- /dev/null
+++ b/security/sidechannel/sidechannel.c
@@ -0,0 +1,156 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Side Channel Safety Security Module
+ *
+ * Copyright (C) 2018 Intel Corporation.
+ *
+ */
+
+#define pr_fmt(fmt) "SideChannel: " fmt
+
+#include <linux/types.h>
+#include <linux/lsm_hooks.h>
+#include <linux/capability.h>
+#include <linux/cred.h>
+#include <linux/sched.h>
+#include <linux/string_helpers.h>
+#include <linux/nsproxy.h>
+#include <linux/pid_namespace.h>
+
+#ifdef CONFIG_SECURITY_SIDECHANNEL_ALWAYS
+static int sidechannel_task_safe_sidechannel(struct task_struct *p)
+{
+	return -EACCES;
+}
+#else
+/*
+ * safe_by_uid - Are task and current sidechannel safe?
+ * @p: task to check on
+ *
+ * Returns 0 if the tasks are sidechannel safe, -EACCES otherwise.
+ */
+#ifdef CONFIG_SECURITY_SIDECHANNEL_UIDS
+static int safe_by_uid(struct task_struct *p)
+{
+	const struct cred *ccred = current_real_cred();
+	const struct cred *pcred = get_task_cred(p);
+
+	/*
+	 * Credential checks. Considered safe if:
+	 *	UIDs are the same
+	 */
+	if (ccred != pcred && ccred->euid.val != pcred->euid.val)
+		return -EACCES;
+	return 0;
+}
+#else
+static inline int safe_by_uid(struct task_struct *p)
+{
+	return 0;
+}
+#endif
+
+/*
+ * safe_by_capability - Are task and current sidechannel safe?
+ * @p: task to check on
+ *
+ * Returns 0 if the tasks are sidechannel safe, -EACCES otherwise.
+ */
+#ifdef CONFIG_SECURITY_SIDECHANNEL_CAPABILITIES
+static int safe_by_capability(struct task_struct *p)
+{
+	const struct cred *ccred = current_real_cred();
+	const struct cred *pcred = get_task_cred(p);
+
+	/*
+	 * Capabilities checks. Considered safe if:
+	 *	current has all the capabilities p does
+	 */
+	if (ccred != pcred &&
+	    !cap_issubset(pcred->cap_effective, ccred->cap_effective))
+		return -EACCES;
+	return 0;
+}
+#else
+static inline int safe_by_capability(struct task_struct *p)
+{
+	return 0;
+}
+#endif
+
+#ifdef CONFIG_SECURITY_SIDECHANNEL_NAMESPACES
+/**
+ * safe_by_namespace - Are task and current sidechannel safe?
+ * @p: task to check on
+ *
+ * Returns 0 if the tasks are sidechannel safe, -EACCES otherwise.
+ */
+static int safe_by_namespace(struct task_struct *p)
+{
+	struct cgroup_namespace *ccgn = NULL;
+	struct cgroup_namespace *pcgn = NULL;
+
+	/*
+	 * Namespace checks. Considered safe if:
+	 *	cgroup namespace is the same
+	 *	User namespace is the same
+	 *	PID namespace is the same
+	 */
+	if (current->nsproxy)
+		ccgn = current->nsproxy->cgroup_ns;
+	if (p->nsproxy)
+		pcgn = p->nsproxy->cgroup_ns;
+	if (ccgn != pcgn)
+		return -EACCES;
+	if (current_real_cred()->user_ns != get_task_cred(p)->user_ns)
+		return -EACCES;
+	if (task_active_pid_ns(current) != task_active_pid_ns(p))
+		return -EACCES;
+	return 0;
+}
+#else
+static inline int safe_by_namespace(struct task_struct *p)
+{
+	return 0;
+}
+#endif
+
+/**
+ * sidechannel_task_safe_sidechannel - Are task and current sidechannel safe?
+ * @p: task to check on
+ *
+ * Returns 0 if the tasks are sidechannel safe, -EACCES otherwise.
+ */
+static int sidechannel_task_safe_sidechannel(struct task_struct *p)
+{
+	int rc;
+
+	/*
+	 * Easy optimizations
+	 */
+	if (p == current || p->pid == current->pid)
+		return 0;
+
+	rc = safe_by_uid(p);
+	if (rc)
+		return rc;
+	rc = safe_by_capability(p);
+	if (rc)
+		return rc;
+	rc = safe_by_namespace(p);
+	if (rc)
+		return rc;
+	return 0;
+}
+#endif /* CONFIG_SECURITY_SIDECHANNEL_ALWAYS */
+
+static struct security_hook_list sidechannel_hooks[] __lsm_ro_after_init = {
+	LSM_HOOK_INIT(task_safe_sidechannel, sidechannel_task_safe_sidechannel),
+};
+
+void __init sidechannel_add_hooks(void)
+{
+	pr_info("Extra sidechannel checks enabled\n");
+	security_add_hooks(sidechannel_hooks, ARRAY_SIZE(sidechannel_hooks),
+			   "sidechannel");
+}
-- 
2.17.1
