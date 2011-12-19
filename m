Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Mon, 19 Dec 2011 14:17:46 -0800
Message-Id: <1324333066-12452-3-git-send-email-keescook@chromium.org>
In-Reply-To: <1324333066-12452-1-git-send-email-keescook@chromium.org>
References: <1324333066-12452-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 2/2] security: Yama LSM
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, Roland McGrath <roland@hack.frob.com>, James Morris <jmorris@namei.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This adds the Yama Linux Security Module to collect DAC security
improvements (specifically just ptrace restrictions for now) that have
existed in various forms over the years and have been carried outside the
mainline kernel by other Linux distributions like Openwall and grsecurity.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
v9:
 - Remove pid_ns feature. Touches too many core kernel areas at the moment.
v8:
 - Updated RCU usage and locking, thanks to Mandeep Singh Baines.
v7:
 - Merge ptrace restrictions, which include various fixes from
   Vasiliy Kulikov, Solar Designer, Ming Lei, Tetsuo Handa, and Eric Paris.
 - Merge pid_ns feature from Vasiliy Kulikov.
 - Rip out link restrictions for initial upstreaming.
v6:
 - Fix interaction with overlayfs, thanks to Andy Whitcroft and Leann
   Ogasawara.
 - Clarify rationale for LSM.
 - Move documentation under security subdirectory.
v5:
 - resend, with ptrace relationship interface
v4:
 - drop accidentally included fs/exec.c chunk.
v3:
 - drop needless cap_ callbacks.
 - fix usage of get_task_comm.
 - drop CONFIG_ of sysctl defaults, as recommended by Andi Kleen.
 - require SYSCTL.
v2:
 - add rcu locking, thanks to Tetsuo Handa.
 - add Documentation/Yama.txt for summary of features.
---
 Documentation/security/00-INDEX |    2 +
 Documentation/security/Yama.txt |   59 ++++++++
 include/linux/prctl.h           |    6 +
 security/Kconfig                |    6 +
 security/Makefile               |    2 +
 security/yama/Kconfig           |   13 ++
 security/yama/Makefile          |    3 +
 security/yama/yama_lsm.c        |  315 +++++++++++++++++++++++++++++++++++++++
 8 files changed, 406 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/security/Yama.txt
 create mode 100644 security/yama/Kconfig
 create mode 100644 security/yama/Makefile
 create mode 100644 security/yama/yama_lsm.c

diff --git a/Documentation/security/00-INDEX b/Documentation/security/00-INDEX
index 19bc494..1f33b73 100644
--- a/Documentation/security/00-INDEX
+++ b/Documentation/security/00-INDEX
@@ -4,6 +4,8 @@ SELinux.txt
 	- how to get started with the SELinux security enhancement.
 Smack.txt
 	- documentation on the Smack Linux Security Module.
+Yama.txt
+	- documentation on the Yama Linux Security Module.
 apparmor.txt
 	- documentation on the AppArmor security extension.
 credentials.txt
diff --git a/Documentation/security/Yama.txt b/Documentation/security/Yama.txt
new file mode 100644
index 0000000..281a89e
--- /dev/null
+++ b/Documentation/security/Yama.txt
@@ -0,0 +1,59 @@
+Yama is a Linux Security Module that collects a number of system-wide DAC
+security protections that are not handled by the core kernel itself. To
+select it at boot time, specify "security=yama" (though this will disable
+any other LSM).
+
+Yama is controlled through sysctl in /proc/sys/kernel/yama:
+
+- ptrace_scope
+
+==============================================================
+
+ptrace_scope:
+
+As Linux grows in popularity, it will become a larger target for
+malware. One particularly troubling weakness of the Linux process
+interfaces is that a single user is able to examine the memory and
+running state of any of their processes. For example, if one application
+(e.g. Pidgin) was compromised, it would be possible for an attacker to
+attach to other running processes (e.g. Firefox, SSH sessions, GPG agent,
+etc) to extract additional credentials and continue to expand the scope
+of their attack without resorting to user-assisted phishing.
+
+This is not a theoretical problem. SSH session hijacking
+(http://www.storm.net.nz/projects/7) and arbitrary code injection
+(http://c-skills.blogspot.com/2007/05/injectso.html) attacks already
+exist and remain possible if ptrace is allowed to operate as before.
+Since ptrace is not commonly used by non-developers and non-admins, system
+builders should be allowed the option to disable this debugging system.
+
+For a solution, some applications use prctl(PR_SET_DUMPABLE, ...) to
+specifically disallow such ptrace attachment (e.g. ssh-agent), but many
+do not. A more general solution is to only allow ptrace directly from a
+parent to a child process (i.e. direct "gdb EXE" and "strace EXE" still
+work), or with CAP_SYS_PTRACE (i.e. "gdb --pid=PID", and "strace -p PID"
+still work as root).
+
+For software that has defined application-specific relationships
+between a debugging process and its inferior (crash handlers, etc),
+prctl(PR_SET_PTRACER, pid, ...) can be used. An inferior can declare which
+other process (and its descendents) are allowed to call PTRACE_ATTACH
+against it. For example, this is used by KDE, Chromium, and Firefox's
+crash handlers, and by Wine for allowing only Wine processes to ptrace
+each other.
+
+0 - classic ptrace permissions: a process can PTRACE_ATTACH to any other
+    process running under the same uid, as long as it is dumpable (i.e.
+    did not transition uids, start privileged, or have called
+    prctl(PR_SET_DUMPABLE...) already).
+
+1 - restricted ptrace: a process must have a predefined relationship
+    with the inferior it wants to call PTRACE_ATTACH on. By default,
+    this relationship is that of only its descendants when the above
+    classic criteria is also met. To change the relationship, an
+    inferior can call prctl(PR_SET_PTRACER, debugger, ...) to declare
+    an allowed debugger PID to call PTRACE_ATTACH on the inferior.
+
+The original children-only logic was based on the restrictions in grsecurity.
+
+==============================================================
diff --git a/include/linux/prctl.h b/include/linux/prctl.h
index a3baeb2..dc71db0 100644
--- a/include/linux/prctl.h
+++ b/include/linux/prctl.h
@@ -102,4 +102,10 @@
 
 #define PR_MCE_KILL_GET 34
 
+/*
+ * Set specific pid that is allowed to ptrace the current task.
+ * A value of 0 mean "no process".
+ */
+#define PR_SET_PTRACER 0x59616d61
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/security/Kconfig b/security/Kconfig
index 51bd5a0..ccc61f8 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -187,6 +187,7 @@ source security/selinux/Kconfig
 source security/smack/Kconfig
 source security/tomoyo/Kconfig
 source security/apparmor/Kconfig
+source security/yama/Kconfig
 
 source security/integrity/Kconfig
 
@@ -196,6 +197,7 @@ choice
 	default DEFAULT_SECURITY_SMACK if SECURITY_SMACK
 	default DEFAULT_SECURITY_TOMOYO if SECURITY_TOMOYO
 	default DEFAULT_SECURITY_APPARMOR if SECURITY_APPARMOR
+	default DEFAULT_SECURITY_YAMA if SECURITY_YAMA
 	default DEFAULT_SECURITY_DAC
 
 	help
@@ -214,6 +216,9 @@ choice
 	config DEFAULT_SECURITY_APPARMOR
 		bool "AppArmor" if SECURITY_APPARMOR=y
 
+	config DEFAULT_SECURITY_YAMA
+		bool "Yama" if SECURITY_YAMA=y
+
 	config DEFAULT_SECURITY_DAC
 		bool "Unix Discretionary Access Controls"
 
@@ -225,6 +230,7 @@ config DEFAULT_SECURITY
 	default "smack" if DEFAULT_SECURITY_SMACK
 	default "tomoyo" if DEFAULT_SECURITY_TOMOYO
 	default "apparmor" if DEFAULT_SECURITY_APPARMOR
+	default "yama" if DEFAULT_SECURITY_YAMA
 	default "" if DEFAULT_SECURITY_DAC
 
 endmenu
diff --git a/security/Makefile b/security/Makefile
index a5e502f..c26c81e 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -7,6 +7,7 @@ subdir-$(CONFIG_SECURITY_SELINUX)	+= selinux
 subdir-$(CONFIG_SECURITY_SMACK)		+= smack
 subdir-$(CONFIG_SECURITY_TOMOYO)        += tomoyo
 subdir-$(CONFIG_SECURITY_APPARMOR)	+= apparmor
+subdir-$(CONFIG_SECURITY_YAMA)		+= yama
 
 # always enable default capabilities
 obj-y					+= commoncap.o
@@ -21,6 +22,7 @@ obj-$(CONFIG_SECURITY_SMACK)		+= smack/built-in.o
 obj-$(CONFIG_AUDIT)			+= lsm_audit.o
 obj-$(CONFIG_SECURITY_TOMOYO)		+= tomoyo/built-in.o
 obj-$(CONFIG_SECURITY_APPARMOR)		+= apparmor/built-in.o
+obj-$(CONFIG_SECURITY_YAMA)		+= yama/built-in.o
 obj-$(CONFIG_CGROUP_DEVICE)		+= device_cgroup.o
 
 # Object integrity file lists
diff --git a/security/yama/Kconfig b/security/yama/Kconfig
new file mode 100644
index 0000000..51d6709
--- /dev/null
+++ b/security/yama/Kconfig
@@ -0,0 +1,13 @@
+config SECURITY_YAMA
+	bool "Yama support"
+	depends on SECURITY
+	select SECURITYFS
+	select SECURITY_PATH
+	default n
+	help
+	  This selects Yama, which extends DAC support with additional
+	  system-wide security settings beyond regular Linux discretionary
+	  access controls. Currently available is ptrace scope restriction.
+	  Further information can be found in Documentation/security/Yama.txt.
+
+	  If you are unsure how to answer this question, answer N.
diff --git a/security/yama/Makefile b/security/yama/Makefile
new file mode 100644
index 0000000..8b5e065
--- /dev/null
+++ b/security/yama/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_SECURITY_YAMA) := yama.o
+
+yama-y := yama_lsm.o
diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
new file mode 100644
index 0000000..1029fcd
--- /dev/null
+++ b/security/yama/yama_lsm.c
@@ -0,0 +1,315 @@
+/*
+ * Yama Linux Security Module
+ *
+ * Author: Kees Cook <keescook@chromium.org>
+ *
+ * Copyright (C) 2010 Canonical, Ltd.
+ * Copyright (C) 2011 The Chromium OS Authors.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/security.h>
+#include <linux/sysctl.h>
+#include <linux/ptrace.h>
+#include <linux/prctl.h>
+#include <linux/ratelimit.h>
+
+static int ptrace_scope = 1;
+
+/* describe a ptrace relationship for potential exception */
+struct ptrace_relation {
+	struct task_struct *tracer;
+	struct task_struct *tracee;
+	struct list_head node;
+};
+
+static LIST_HEAD(ptracer_relations);
+static DEFINE_SPINLOCK(ptracer_relations_lock);
+
+/**
+ * yama_ptracer_add - add/replace an exception for this tracer/tracee pair
+ * @tracer: the task_struct of the process doing the ptrace
+ * @tracee: the task_struct of the process to be ptraced
+ *
+ * Returns 0 if relationship was added, -ve on error.
+ */
+static int yama_ptracer_add(struct task_struct *tracer,
+			    struct task_struct *tracee)
+{
+	int rc = 0;
+	struct ptrace_relation *added;
+	struct ptrace_relation *entry, *relation = NULL;
+
+	added = kmalloc(sizeof(*added), GFP_KERNEL);
+	spin_lock_bh(&ptracer_relations_lock);
+	list_for_each_entry(entry, &ptracer_relations, node)
+		if (entry->tracee == tracee) {
+			relation = entry;
+			break;
+		}
+	if (!relation) {
+		relation = added;
+		if (!relation) {
+			rc = -ENOMEM;
+			goto unlock_out;
+		}
+		relation->tracee = tracee;
+		list_add(&relation->node, &ptracer_relations);
+	}
+	relation->tracer = tracer;
+
+unlock_out:
+	spin_unlock_bh(&ptracer_relations_lock);
+	if (added && added != relation)
+		kfree(added);
+
+	return rc;
+}
+
+/**
+ * yama_ptracer_del - remove exceptions related to the given tasks
+ * @tracer: remove any relation where tracer task matches
+ * @tracee: remove any relation where tracee task matches
+ */
+static void yama_ptracer_del(struct task_struct *tracer,
+			     struct task_struct *tracee)
+{
+	struct ptrace_relation *relation;
+	struct list_head *list, *safe;
+
+	spin_lock_bh(&ptracer_relations_lock);
+	list_for_each_safe(list, safe, &ptracer_relations) {
+		relation = list_entry(list, struct ptrace_relation, node);
+		if (relation->tracee == tracee ||
+		    relation->tracer == tracer) {
+			list_del(&relation->node);
+			kfree(relation);
+		}
+	}
+	spin_unlock_bh(&ptracer_relations_lock);
+}
+
+/**
+ * yama_task_free - check for task_pid to remove from exception list
+ * @task: task being removed
+ */
+static void yama_task_free(struct task_struct *task)
+{
+	yama_ptracer_del(task, task);
+}
+
+/**
+ * yama_task_prctl - check for Yama-specific prctl operations
+ * @option: operation
+ * @arg2: argument
+ * @arg3: argument
+ * @arg4: argument
+ * @arg5: argument
+ *
+ * Return 0 on success, -ve on error.  -ENOSYS is returned when Yama
+ * does not handle the given option.
+ */
+static int yama_task_prctl(int option, unsigned long arg2, unsigned long arg3,
+			   unsigned long arg4, unsigned long arg5)
+{
+	int rc;
+	struct task_struct *myself = current;
+
+	rc = cap_task_prctl(option, arg2, arg3, arg4, arg5);
+	if (rc != -ENOSYS)
+		return rc;
+
+	switch (option) {
+	case PR_SET_PTRACER:
+		rcu_read_lock();
+		if (!thread_group_leader(myself))
+			myself = rcu_dereference(myself->group_leader);
+		get_task_struct(myself);
+		rcu_read_unlock();
+
+		if (arg2 == 0) {
+			yama_ptracer_del(NULL, myself);
+			rc = 0;
+		} else {
+			struct task_struct *tracer;
+
+			rcu_read_lock();
+			tracer = find_task_by_vpid(arg2);
+			if (tracer)
+				get_task_struct(tracer);
+			else
+				rc = -EINVAL;
+			rcu_read_unlock();
+
+			if (tracer) {
+				rc = yama_ptracer_add(tracer, myself);
+				put_task_struct(tracer);
+			}
+		}
+
+		put_task_struct(myself);
+		break;
+	}
+
+	return rc;
+}
+
+/**
+ * task_is_descendant - walk up a process family tree looking for a match
+ * @parent: the process to compare against while walking up from child
+ * @child: the process to start from while looking upwards for parent
+ *
+ * Returns 1 if child is a descendant of parent, 0 if not.
+ */
+static int task_is_descendant(struct task_struct *parent,
+			      struct task_struct *child)
+{
+	int rc = 0;
+	struct task_struct *walker = child;
+
+	if (!parent || !child)
+		return 0;
+
+	rcu_read_lock();
+	if (!thread_group_leader(parent))
+		parent = rcu_dereference(parent->group_leader);
+	while (walker->pid > 0) {
+		if (!thread_group_leader(walker))
+			walker = rcu_dereference(walker->group_leader);
+		if (walker == parent) {
+			rc = 1;
+			break;
+		}
+		walker = rcu_dereference(walker->real_parent);
+	}
+	rcu_read_unlock();
+
+	return rc;
+}
+
+/**
+ * ptracer_exception_found - tracer registered as exception for this tracee
+ * @tracer: the task_struct of the process attempting ptrace
+ * @tracee: the task_struct of the process to be ptraced
+ *
+ * Returns 1 if tracer has is ptracer exception ancestor for tracee.
+ */
+static int ptracer_exception_found(struct task_struct *tracer,
+				   struct task_struct *tracee)
+{
+	int rc = 0;
+	struct ptrace_relation *relation;
+	struct task_struct *parent = NULL;
+
+	spin_lock_bh(&ptracer_relations_lock);
+	rcu_read_lock();
+	if (!thread_group_leader(tracee))
+		tracee = rcu_dereference(tracee->group_leader);
+	list_for_each_entry(relation, &ptracer_relations, node)
+		if (relation->tracee == tracee) {
+			parent = relation->tracer;
+			break;
+		}
+
+	if (task_is_descendant(parent, tracer))
+		rc = 1;
+	rcu_read_unlock();
+	spin_unlock_bh(&ptracer_relations_lock);
+
+	return rc;
+}
+
+/**
+ * yama_ptrace_access_check - validate PTRACE_ATTACH calls
+ * @child: task that current task is attempting to ptrace
+ * @mode: ptrace attach mode
+ *
+ * Returns 0 if following the ptrace is allowed, -ve on error.
+ */
+static int yama_ptrace_access_check(struct task_struct *child,
+				    unsigned int mode)
+{
+	int rc;
+
+	/* If standard caps disallows it, so does Yama.  We should
+	 * only tighten restrictions further.
+	 */
+	rc = cap_ptrace_access_check(child, mode);
+	if (rc)
+		return rc;
+
+	/* require ptrace target be a child of ptracer on attach */
+	if (mode == PTRACE_MODE_ATTACH &&
+	    ptrace_scope &&
+	    !task_is_descendant(current, child) &&
+	    !ptracer_exception_found(current, child) &&
+	    !capable(CAP_SYS_PTRACE))
+		rc = -EPERM;
+
+	if (rc) {
+		char name[sizeof(current->comm)];
+		printk_ratelimited(KERN_NOTICE "ptrace of non-child"
+			" pid %d was attempted by: %s (pid %d)\n",
+			child->pid,
+			get_task_comm(name, current),
+			current->pid);
+	}
+
+	return rc;
+}
+
+static struct security_operations yama_ops = {
+	.name =			"yama",
+
+	.ptrace_access_check =	yama_ptrace_access_check,
+	.task_prctl =		yama_task_prctl,
+	.task_free =		yama_task_free,
+};
+
+#ifdef CONFIG_SYSCTL
+static int zero;
+static int one = 1;
+
+struct ctl_path yama_sysctl_path[] = {
+	{ .procname = "kernel", },
+	{ .procname = "yama", },
+	{ }
+};
+
+static struct ctl_table yama_sysctl_table[] = {
+	{
+		.procname       = "ptrace_scope",
+		.data           = &ptrace_scope,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec_minmax,
+		.extra1         = &zero,
+		.extra2         = &one,
+	},
+	{ }
+};
+#endif /* CONFIG_SYSCTL */
+
+static __init int yama_init(void)
+{
+	if (!security_module_enable(&yama_ops))
+		return 0;
+
+	printk(KERN_INFO "Yama: becoming mindful.\n");
+
+	if (register_security(&yama_ops))
+		panic("Yama: kernel registration failed.\n");
+
+#ifdef CONFIG_SYSCTL
+	if (!register_sysctl_paths(yama_sysctl_path, yama_sysctl_table))
+		panic("Yama: sysctl registration failed.\n");
+#endif
+
+	return 0;
+}
+
+security_initcall(yama_init);
-- 
1.7.0.4
