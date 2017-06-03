From: Matt Brown <matt@nmatt.com>
Date: Sat,  3 Jun 2017 01:53:51 -0400
Message-Id: <20170603055351.16080-1-matt@nmatt.com>
Subject: [kernel-hardening] [PATCH v1 1/1] Add Trusted Path Execution as a stackable LSM
To: james.l.morris@oracle.com, serge@hallyn.com
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, Matt Brown <matt@nmatt.com>
List-ID: <kernel-hardening.lists.openwall.com>

This patch was modified from Brad Spengler's Trusted Path Execution (TPE)
feature in Grsecurity and also incorporates logging ideas from
cormander's tpe-lkm.

Modifications from the Grsecurity implementation of TPE were made to
turn it into a stackable LSM using the existing LSM hook bprm_set_creds.
Also, denial messages were improved by including the full path of the
disallowed program. (This idea was taken from cormander's tpe-lkm)

Trusted Path Execution is not a new idea:

http://phrack.org/issues/52/6.html#article

| A trusted path is one that is inside is a root owned directory that
| is not group or world writable.  /bin, /usr/bin, /usr/local/bin, are
| (under normal circumstances) considered trusted.  Any non-root
| users home directory is not trusted, nor is /tmp.

This Trusted Path Execution implementation introduces the following
Kconfig options and sysctls. These config behaviors are taken straight
from Grsecurity's implementation.

CONFIG_SECURITY_TPE (sysctl=kernel.tpe.enabled)

This option enables Trusted Path Execution. TPE blocks *untrusted*
users from executing files that meet the following conditions:

* file is not in a root-owned directory
* file is writable by a user other than root

NOTE: root is never restricted by TPE

CONFIG_SECURITY_TPE_GID (sysctl=kernel.tpe.gid)

This option defines a group id that, by default, is the untrusted group.
If a user is untrusted then it has the checks described in
CONFIG_SECURITY_TPE applied. Otherwise, the user is trusted and the
checks are not applied. Since root is never restricted by TPE, you can
effectively remove the concept of a trusted or untrusted group by
setting this value to 0.

CONFIG_SECURITY_TPE_ALL (sysctl=kernel.tpe.restrict_all)

This option applies another set of restrictions to all non-root users
even if they are trusted. This only allows execution under the
following conditions:

* file is in a directory owned by the user that is not group or
  world-writable
* file is in a directory owned by root and writable only by root

CONFIG_SECURITY_TPE_INVERT (sysctl=kernel.tpe.gid_invert)

This option reverses the trust logic of the gid option and makes
kernel.tpe.gid into the trusted group. This means that all other groups
become untrusted. This sysctl is helpful when you want TPE restrictions
to apply to most of the users on the system.

Threat Models:

1. Attacker on system executing exploit on system vulnerability

*  If attacker uses a binary as a part of their system exploit, TPE can
   frustrate their efforts

*  Issues:
   *  Can be bypassed by interpreted languages such as python. You can run
      malicious code by doing: python -c 'evil code'

2. Attacker on system replaces binary used by a privileged user with a
   malicious one

*  This situation arises when administrator of a system leaves a binary
   as world writable.

*  TPE is very effective against this threat model

Signed-off-by: Matt Brown <matt@nmatt.com>
---
 MAINTAINERS               |   5 ++
 include/linux/lsm_hooks.h |   5 ++
 security/Kconfig          |   1 +
 security/Makefile         |   2 +
 security/security.c       |   1 +
 security/tpe/Kconfig      |  57 +++++++++++++++
 security/tpe/Makefile     |   3 +
 security/tpe/tpe_lsm.c    | 175 ++++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 249 insertions(+)
 create mode 100644 security/tpe/Kconfig
 create mode 100644 security/tpe/Makefile
 create mode 100644 security/tpe/tpe_lsm.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 38d3e4e..1952bd6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11357,6 +11357,11 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git yama/tip
 S:	Supported
 F:	security/yama/
 
+TPE SECURITY MODULE
+M:	Matt Brown <matt@nmatt.com>
+S:	Supported
+F:	security/tpe/
+
 SENSABLE PHANTOM
 M:	Jiri Slaby <jirislaby@gmail.com>
 S:	Maintained
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index e29d4c6..d017f49 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1920,5 +1920,10 @@ void __init loadpin_add_hooks(void);
 #else
 static inline void loadpin_add_hooks(void) { };
 #endif
+#ifdef CONFIG_SECURITY_TPE
+void __init tpe_add_hooks(void);
+#else
+static inline void tpe_add_hooks(void) { };
+#endif
 
 #endif /* ! __LINUX_LSM_HOOKS_H */
diff --git a/security/Kconfig b/security/Kconfig
index 34fb609..30e60cd 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -245,6 +245,7 @@ source security/tomoyo/Kconfig
 source security/apparmor/Kconfig
 source security/loadpin/Kconfig
 source security/yama/Kconfig
+source security/tpe/Kconfig
 
 source security/integrity/Kconfig
 
diff --git a/security/Makefile b/security/Makefile
index f2d71cd..f8b5197 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -9,6 +9,7 @@ subdir-$(CONFIG_SECURITY_TOMOYO)        += tomoyo
 subdir-$(CONFIG_SECURITY_APPARMOR)	+= apparmor
 subdir-$(CONFIG_SECURITY_YAMA)		+= yama
 subdir-$(CONFIG_SECURITY_LOADPIN)	+= loadpin
+subdir-$(CONFIG_SECURITY_TPE)		+= tpe
 
 # always enable default capabilities
 obj-y					+= commoncap.o
@@ -24,6 +25,7 @@ obj-$(CONFIG_SECURITY_TOMOYO)		+= tomoyo/
 obj-$(CONFIG_SECURITY_APPARMOR)		+= apparmor/
 obj-$(CONFIG_SECURITY_YAMA)		+= yama/
 obj-$(CONFIG_SECURITY_LOADPIN)		+= loadpin/
+obj-$(CONFIG_SECURITY_TPE)		+= tpe/
 obj-$(CONFIG_CGROUP_DEVICE)		+= device_cgroup.o
 
 # Object integrity file lists
diff --git a/security/security.c b/security/security.c
index d0e07f2..ab0dc26 100644
--- a/security/security.c
+++ b/security/security.c
@@ -62,6 +62,7 @@ int __init security_init(void)
 	capability_add_hooks();
 	yama_add_hooks();
 	loadpin_add_hooks();
+	tpe_add_hooks();
 
 	/*
 	 * Load all the remaining security modules.
diff --git a/security/tpe/Kconfig b/security/tpe/Kconfig
new file mode 100644
index 0000000..84fe1b7
--- /dev/null
+++ b/security/tpe/Kconfig
@@ -0,0 +1,57 @@
+config SECURITY_TPE
+	bool "Trusted Path Execution (TPE)"
+	default n
+	help
+	  If you say Y here, you will be able to choose a gid to add to the
+	  supplementary groups of users you want to mark as "untrusted."
+	  These users will not be able to execute any files that are not in
+	  root-owned directories writable only by root.  If the sysctl option
+	  is enabled, a sysctl option with name "tpe" is created.
+
+config SECURITY_TPE_ALL
+	bool "Partially restrict all non-root users"
+	depends on SECURITY_TPE
+	help
+	  If you say Y here, all non-root users will be covered under
+	  a weaker TPE restriction.  This is separate from, and in addition to,
+	  the main TPE options that you have selected elsewhere.  Thus, if a
+	  "trusted" GID is chosen, this restriction applies to even that GID.
+	  Under this restriction, all non-root users will only be allowed to
+	  execute files in directories they own that are not group or
+	  world-writable, or in directories owned by root and writable only by
+	  root.  If the sysctl option is enabled, a sysctl option with name
+	  "tpe_restrict_all" is created.
+
+config SECURITY_TPE_INVERT
+	bool "Invert GID option"
+	depends on SECURITY_TPE
+	help
+	  If you say Y here, the group you specify in the TPE configuration will
+	  decide what group TPE restrictions will be *disabled* for.  This
+	  option is useful if you want TPE restrictions to be applied to most
+	  users on the system.  If the sysctl option is enabled, a sysctl option
+	  with name "tpe_invert" is created.  Unlike other sysctl options, this
+	  entry will default to on for backward-compatibility.
+
+config SECURITY_TPE_GID
+	int
+	default SECURITY_TPE_UNTRUSTED_GID if (SECURITY_TPE && !SECURITY_TPE_INVERT)
+	default SECURITY_TPE_TRUSTED_GID if (SECURITY_TPE && SECURITY_TPE_INVERT)
+
+config SECURITY_TPE_UNTRUSTED_GID
+	int "GID for TPE-untrusted users"
+	depends on SECURITY_TPE && !SECURITY_TPE_INVERT
+	default 1005
+	help
+	  Setting this GID determines what group TPE restrictions will be
+	  *enabled* for.  If the sysctl option is enabled, a sysctl option
+	  with name "tpe_gid" is created.
+
+config SECURITY_TPE_TRUSTED_GID
+	int "GID for TPE-trusted users"
+	depends on SECURITY_TPE && SECURITY_TPE_INVERT
+	default 1005
+	help
+	  Setting this GID determines what group TPE restrictions will be
+	  *disabled* for.  If the sysctl option is enabled, a sysctl option
+	  with name "tpe_gid" is created.
diff --git a/security/tpe/Makefile b/security/tpe/Makefile
new file mode 100644
index 0000000..e1bd8ef
--- /dev/null
+++ b/security/tpe/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_SECURITY_TPE) := tpe_lsm.o
+
+tpe-y := tpe_lsm.o
diff --git a/security/tpe/tpe_lsm.c b/security/tpe/tpe_lsm.c
new file mode 100644
index 0000000..075ca02
--- /dev/null
+++ b/security/tpe/tpe_lsm.c
@@ -0,0 +1,175 @@
+/*
+ * Trusted Path Execution Security Module
+ *
+ * Copyright 2017 Matt Brown
+ *
+ * Author: Matt Brown <matt@nmatt.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#include <linux/kernel.h>
+#include <linux/uidgid.h>
+#include <linux/ratelimit.h>
+#include <linux/limits.h>
+#include <linux/cred.h>
+#include <linux/slab.h>
+#include <linux/lsm_hooks.h>
+#include <linux/sysctl.h>
+#include <linux/binfmts.h>
+#include <linux/string_helpers.h>
+
+#define TPE_GLOBAL_UID(x) from_kuid_munged(&init_user_ns, (x))
+#define TPE_GLOBAL_GID(x) from_kgid_munged(&init_user_ns, (x))
+#define global_root(x) uid_eq((x), GLOBAL_ROOT_UID)
+#define global_nonroot(x) (!uid_eq((x), GLOBAL_ROOT_UID))
+#define global_nonroot_gid(x) (!gid_eq((x), GLOBAL_ROOT_GID))
+
+static int tpe_enabled __read_mostly = IS_ENABLED(CONFIG_SECURITY_TPE);
+static kgid_t tpe_gid __read_mostly = KGIDT_INIT(CONFIG_SECURITY_TPE_GID);
+static int tpe_all __read_mostly = IS_ENABLED(CONFIG_SECURITY_TPE_ALL);
+static int tpe_invert __read_mostly = IS_ENABLED(CONFIG_SECURITY_TPE_INVERT);
+
+int print_tpe_error(struct file *file, char *reason1, char *reason2)
+{
+	char *filepath;
+
+	filepath = kstrdup_quotable_file(file, GFP_KERNEL);
+
+	if (!filepath)
+		return -ENOMEM;
+
+	pr_warn_ratelimited("TPE: Denied execution of %s Reason: %s%s%s\n",
+		(IS_ERR(filepath) ? "failed fetching file path" : filepath),
+		reason1, reason2 ? " and " : "", reason2 ?: "");
+	kfree(filepath);
+	return -EPERM;
+}
+
+/*
+ * Return 0 if the hook is successful and permission is granted.
+ * Otherwise return the proper error message
+ *
+ */
+static int tpe_bprm_set_creds(struct linux_binprm *bprm)
+{
+	struct file *file = bprm->file;
+	struct inode *inode = d_backing_inode(file->f_path.dentry->d_parent);
+	struct inode *file_inode = d_backing_inode(file->f_path.dentry);
+	const struct cred *cred = current_cred();
+	char *reason1 = NULL;
+	char *reason2 = NULL;
+
+	if (!tpe_enabled)
+		return 0;
+
+	/* never restrict root */
+	if (global_root(cred->uid))
+		return 0;
+
+	if (!tpe_all)
+		goto general_tpe_check;
+
+	/* TPE_ALL: restrictions enforced even if the gid is trusted */
+	if (global_nonroot(inode->i_uid) && !uid_eq(inode->i_uid, cred->uid))
+		reason1 = "directory not owned by user";
+	else if (inode->i_mode & 0002)
+		reason1 = "file in world-writable directory";
+	else if ((inode->i_mode & 0020) && global_nonroot_gid(inode->i_gid))
+		reason1 = "file in group-writable directory";
+	else if (file_inode->i_mode & 0002)
+		reason1 = "file is world-writable";
+
+	if (reason1)
+		goto end;
+
+general_tpe_check:
+	/* determine if group is trusted */
+	if (tpe_invert && !in_group_p(tpe_gid))
+		reason2 = "not in trusted group";
+	else if (!tpe_invert && in_group_p(tpe_gid))
+		reason2 = "in untrusted group";
+	else
+		return 0;
+
+	/* main TPE checks */
+	if (global_nonroot(inode->i_uid))
+		reason1 = "file in non-root-owned directory";
+	else if (inode->i_mode & 0002)
+		reason1 = "file in world-writable directory";
+	else if ((inode->i_mode & 0020) && global_nonroot_gid(inode->i_gid))
+		reason1 = "file in group-writable directory";
+	else if (file_inode->i_mode & 0002)
+		reason1 = "file is world-writable";
+
+end:
+	if (reason1)
+		return print_tpe_error(file, reason1, reason2);
+	else
+		return 0;
+}
+
+static struct security_hook_list tpe_hooks[] = {
+	LSM_HOOK_INIT(bprm_set_creds, tpe_bprm_set_creds),
+};
+
+#ifdef CONFIG_SYSCTL
+struct ctl_path tpe_sysctl_path[] = {
+	{ .procname = "kernel", },
+	{ .procname = "tpe", },
+	{ }
+};
+
+static struct ctl_table tpe_sysctl_table[] = {
+	{
+		.procname	= "enabled",
+		.data		= &tpe_enabled,
+		.maxlen		= sizeof(int),
+		.mode		= 0600,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "gid",
+		.data		= &tpe_gid,
+		.maxlen		= sizeof(int),
+		.mode		= 0600,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "gid_invert",
+		.data		= &tpe_invert,
+		.maxlen		= sizeof(int),
+		.mode		= 0600,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "restrict_all",
+		.data		= &tpe_all,
+		.maxlen		= sizeof(int),
+		.mode		= 0600,
+		.proc_handler	= proc_dointvec,
+	},
+	{ }
+};
+static void __init tpe_init_sysctl(void)
+{
+	if (!register_sysctl_paths(tpe_sysctl_path, tpe_sysctl_table))
+		panic("TPE: sysctl registration failed.\n");
+}
+#else
+static inline void tpe_init_sysctl(void) { }
+#endif /* CONFIG_SYSCTL */
+
+
+void __init tpe_add_hooks(void)
+{
+	pr_info("TPE: securing systems like it's 1998\n");
+	security_add_hooks(tpe_hooks, ARRAY_SIZE(tpe_hooks), "tpe");
+	tpe_init_sysctl();
+}
-- 
2.10.2
