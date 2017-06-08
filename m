References: <59cec608-608e-6de6-21d9-bdec7b0ded3b@schaufler-ca.com>
From: Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <94833d92-81f4-c64e-b39d-e4a9823be25e@schaufler-ca.com>
Date: Thu, 8 Jun 2017 13:50:07 -0700
MIME-Version: 1.0
In-Reply-To: <59cec608-608e-6de6-21d9-bdec7b0ded3b@schaufler-ca.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH 6/6] LSM: general but not extreme module stacking
To: LSM <linux-security-module@vger.kernel.org>, James Morris <jmorris@namei.org>
Cc: John Johansen <john.johansen@canonical.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKLM <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Subject: [PATCH 6/6] LSM: general but not extreme module stacking

Leverage the infrastructure management of the credential and
file security blobs to allow stacking of security modules in
all but the most extreme case. Security modules are informed
of the location of their data within the blobs at module
initialization.

Stacking is optional. If stacking is not configured the old
limit of one "major" security module applies. If stacking is
configured any combination that does not include both SELinux
and Smack is allowed.

A subdirectory has been added to /proc/.../attr for each of
SELinux and AppArmor (Smack introduced such a subdirectory earlier)
to disambiguate what data is provided in the proc/.../attr
interfaces. An entry "context" is added to /proc/.../attr and
to each of the subdirectories. The "context" entry provides
process attribute information in the form:

        lsm-name='lsm-data'[,lsm-name='lsm-data']...

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
---
 Documentation/security/LSM.txt      |  18 ++++-
 fs/proc/base.c                      |  33 +++++++++
 include/linux/lsm_hooks.h           |   2 +-
 security/Kconfig                    |  94 ++++++++++++++++++++++++
 security/apparmor/include/context.h |  10 +++
 security/apparmor/lsm.c             |  43 +++++++++--
 security/security.c                 | 142 +++++++++++++++++++++++++++++++++++-
 security/selinux/hooks.c            |  24 +++++-
 security/selinux/include/objsec.h   |   8 ++
 security/smack/smack.h              |   9 +++
 security/smack/smack_lsm.c          |  23 +++---
 security/tomoyo/common.h            |  12 ++-
 security/tomoyo/tomoyo.c            |   3 +-
 13 files changed, 395 insertions(+), 26 deletions(-)

diff --git a/Documentation/security/LSM.txt b/Documentation/security/LSM.txt
index 57eafbc..23664b7 100644
--- a/Documentation/security/LSM.txt
+++ b/Documentation/security/LSM.txt
@@ -18,8 +18,14 @@ in the core functionality of Linux itself.
 
 The Linux capabilities modules will always be included. For more details
 on capabilities, see capabilities(7) in the Linux man-pages project.
-This may be followed by any number of "minor" modules and at most one
-"major" module.
+
+Security modules that do not use the security data blobs maintained
+by the LSM infrastructure are considered "minor" modules. These may be
+included at compile time and stacked explicitly. Security modules that
+use the LSM maintained security blobs are considered "major" modules.
+These may only be stacked if the CONFIG_LSM_STACKED configuration
+option is used. If this is chosen all of the security modules selected
+will be used.
 
 A list of the active security modules can be found by reading
 /sys/kernel/security/lsm. This is a comma separated list, and
@@ -36,6 +42,14 @@ security module and contains all its special files. The files directly
 in /proc/.../attr remain as legacy interfaces for modules that provide
 subdirectories.
 
+The files named "context" in the attr directories contain the
+same information as the "current" files, but formatted to
+identify the module it comes from.
+
+if selinux is the active security module:
+	/proc/self/attr/context could contain selinux='unconfined_t'
+	/proc/self/attr/selinux/context could contain selinux='unconfined_t'
+
 Based on https://lkml.org/lkml/2007/10/26/215,
 a new LSM is accepted into the kernel when its intent (a description of
 what it tries to protect against and in what cases one would expect to
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 10b777a..bfb1bf0 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2549,13 +2549,37 @@ static const struct inode_operations proc_##LSM##_attr_dir_inode_ops = { \
 	.setattr	= proc_setattr, \
 }
 
+#ifdef CONFIG_SECURITY_SELINUX
+static const struct pid_entry selinux_attr_dir_stuff[] = {
+	ATTR("selinux", "current",	0666),
+	ATTR("selinux", "prev",		0444),
+	ATTR("selinux", "exec",		0666),
+	ATTR("selinux", "fscreate",	0666),
+	ATTR("selinux", "keycreate",	0666),
+	ATTR("selinux", "sockcreate",	0666),
+	ATTR("selinux", "context",	0666),
+};
+LSM_DIR_OPS(selinux);
+#endif
+
 #ifdef CONFIG_SECURITY_SMACK
 static const struct pid_entry smack_attr_dir_stuff[] = {
 	ATTR("smack", "current",	0666),
+	ATTR("smack", "context",	0666),
 };
 LSM_DIR_OPS(smack);
 #endif
 
+#ifdef CONFIG_SECURITY_APPARMOR
+static const struct pid_entry apparmor_attr_dir_stuff[] = {
+	ATTR("apparmor", "current",	0666),
+	ATTR("apparmor", "prev",	0444),
+	ATTR("apparmor", "exec",	0666),
+	ATTR("apparmor", "context",	0666),
+};
+LSM_DIR_OPS(apparmor);
+#endif
+
 static const struct pid_entry attr_dir_stuff[] = {
 	ATTR(NULL, "current",		0666),
 	ATTR(NULL, "prev",		0444),
@@ -2563,10 +2587,19 @@ static const struct pid_entry attr_dir_stuff[] = {
 	ATTR(NULL, "fscreate",		0666),
 	ATTR(NULL, "keycreate",		0666),
 	ATTR(NULL, "sockcreate",	0666),
+	ATTR(NULL, "context",		0666),
+#ifdef CONFIG_SECURITY_SELINUX
+	DIR("selinux",			0555,
+	    proc_selinux_attr_dir_inode_ops, proc_selinux_attr_dir_ops),
+#endif
 #ifdef CONFIG_SECURITY_SMACK
 	DIR("smack",			0555,
 	    proc_smack_attr_dir_inode_ops, proc_smack_attr_dir_ops),
 #endif
+#ifdef CONFIG_SECURITY_APPARMOR
+	DIR("apparmor",			0555,
+	    proc_apparmor_attr_dir_inode_ops, proc_apparmor_attr_dir_ops),
+#endif
 };
 
 static int proc_attr_dir_readdir(struct file *file, struct dir_context *ctx)
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 0f30752..d514a63 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1950,7 +1950,7 @@ static inline void security_delete_hooks(struct security_hook_list *hooks,
 #define __lsm_ro_after_init	__ro_after_init
 #endif /* CONFIG_SECURITY_WRITABLE_HOOKS */
 
-extern int __init security_module_enable(const char *module);
+extern bool __init security_module_enable(const char *lsm, const bool stacked);
 extern void __init capability_add_hooks(void);
 #ifdef CONFIG_SECURITY_YAMA
 extern void __init yama_add_hooks(void);
diff --git a/security/Kconfig b/security/Kconfig
index 999509d8..4128619 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -36,6 +36,28 @@ config SECURITY_WRITABLE_HOOKS
 	bool
 	default n
 
+config SECURITY_STACKING
+	bool "Security module stacking"
+	depends on SECURITY
+	help
+	  Allows multiple major security modules to be stacked.
+	  Modules are invoked in the order registered with a
+	  "bail on fail" policy, in which the infrastructure
+	  will stop processing once a denial is detected. Not
+	  all modules can be stacked. SELinux and Smack are
+	  known to be incompatible. User space components may
+	  have trouble identifying the security module providing
+	  data in some cases.
+
+	  If you select this option you will have to select which
+	  of the stackable modules you wish to be active. The
+	  "Default security module" will be ignored. The boot line
+	  "security=" option can be used to specify that one of
+	  the modules identifed for stacking should be used instead
+	  of the entire stack.
+
+	  If you are unsure how to answer this question, answer N.
+
 config SECURITY_LSM_DEBUG
 	bool "Enable debugging of the LSM infrastructure"
 	depends on SECURITY
@@ -209,6 +231,9 @@ source security/yama/Kconfig
 
 source security/integrity/Kconfig
 
+menu "Security Module Selection"
+	visible if !SECURITY_STACKING
+
 choice
 	prompt "Default security module"
 	default DEFAULT_SECURITY_SELINUX if SECURITY_SELINUX
@@ -248,3 +273,72 @@ config DEFAULT_SECURITY
 
 endmenu
 
+menu "Security Module Stack"
+	visible if SECURITY_STACKING
+
+choice
+	prompt "Stacked 'extreme' security module"
+	default SECURITY_SELINUX_STACKED if SECURITY_SELINUX
+	default SECURITY_SMACK_STACKED if SECURITY_SMACK
+
+	help
+	  Enable an extreme security module. These modules cannot
+	  be used at the same time.
+
+	config SECURITY_SELINUX_STACKED
+		bool "SELinux" if SECURITY_SELINUX=y
+	help
+	  Add the SELinux security module to the stack. At this
+	  time the Smack security module is incompatible with this
+	  module.
+	  Please be sure your user space code is accomodating of
+	  this security module.
+
+	config SECURITY_SMACK_STACKED
+		bool "Simplified Mandatory Access Control" if SECURITY_SMACK=y
+	help
+	  Add the Smack security module to the stack. At this
+	  time the SELinux security module is incompatible with this
+	  module.
+	  Please be sure your user space code is accomodating of
+	  this security module.
+
+	config SECURITY_NOTHING_STACKED
+		bool "Use no 'extreme' security module"
+	help
+	  Add neither the SELinux security module nor the Smack security
+	  module to the stack.
+	  Please be sure your user space code does not require either of
+	  these security modules.
+
+endchoice
+
+config SECURITY_TOMOYO_STACKED
+	bool "TOMOYO support is enabled by default"
+	depends on SECURITY_TOMOYO && SECURITY_STACKING
+	default n
+	help
+	  This option instructs the system to use the TOMOYO checks.
+	  If not selected the module will not be invoked.
+	  Stacked security modules may interact in unexpected ways.
+	  Please be sure your user space code is accomodating of
+	  multiple security modules.
+
+	  If you are unsure how to answer this question, answer N.
+
+config SECURITY_APPARMOR_STACKED
+	bool "AppArmor support is enabled by default"
+	depends on SECURITY_APPARMOR && SECURITY_STACKING
+	default n
+	help
+	  This option instructs the system to use the AppArmor checks.
+	  If not selected the module will not be invoked.
+	  Stacked security modules may interact in unexpected ways.
+	  Please be sure your user space code is accomodating of
+	  multiple security modules.
+
+	  If you are unsure how to answer this question, answer N.
+
+endmenu
+
+endmenu
diff --git a/security/apparmor/include/context.h b/security/apparmor/include/context.h
index 3ff3879..de3c4b8 100644
--- a/security/apparmor/include/context.h
+++ b/security/apparmor/include/context.h
@@ -88,14 +88,24 @@ int aa_set_current_hat(struct aa_profile *profile, u64 token);
 int aa_restore_previous_profile(u64 cookie);
 struct aa_profile *aa_get_task_profile(struct task_struct *task);
 
+extern struct lsm_blob_sizes apparmor_blob_sizes;
+
 static inline struct aa_task_ctx *apparmor_cred(const struct cred *cred)
 {
+#ifdef CONFIG_SECURITY_STACKING
+	return cred->security + apparmor_blob_sizes.lbs_cred;
+#else
 	return cred->security;
+#endif
 }
 
 static inline struct aa_file_ctx *apparmor_file(const struct file *file)
 {
+#ifdef CONFIG_SECURITY_STACKING
+	return file->f_security + apparmor_blob_sizes.lbs_file;
+#else
 	return file->f_security;
+#endif
 }
 
 /**
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 12a0265..32b8bb0 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -446,9 +446,13 @@ static int apparmor_getprocattr(struct task_struct *task, char *name,
 	const struct cred *cred = get_task_cred(task);
 	struct aa_task_ctx *ctx = cred_ctx(cred);
 	struct aa_profile *profile = NULL;
+	char *vp;
+	char *np;
 
 	if (strcmp(name, "current") == 0)
 		profile = aa_get_newest_profile(ctx->profile);
+	else if (strcmp(name, "context") == 0)
+		profile = aa_get_newest_profile(ctx->profile);
 	else if (strcmp(name, "prev") == 0  && ctx->previous)
 		profile = aa_get_newest_profile(ctx->previous);
 	else if (strcmp(name, "exec") == 0 && ctx->onexec)
@@ -456,9 +460,29 @@ static int apparmor_getprocattr(struct task_struct *task, char *name,
 	else
 		error = -EINVAL;
 
-	if (profile)
-		error = aa_getprocattr(profile, value);
+	if (profile == NULL)
+		goto put_out;
+
+	error = aa_getprocattr(profile, &vp);
+	if (error < 0)
+		goto put_out;
+
+	if (strcmp(name, "context") == 0) {
+		*value = kasprintf(GFP_KERNEL, "apparmor='%s'", vp);
+		if (*value == NULL) {
+			error = -ENOMEM;
+			goto put_out;
+		}
+		np = strchr(*value, '\n');
+		if (np != NULL) {
+			np[0] = '\'';
+			np[1] = '\0';
+		}
+		error = strlen(*value);
+	} else
+		*value = vp;
 
+put_out:
 	aa_put_profile(profile);
 	put_cred(cred);
 
@@ -496,7 +520,7 @@ static int apparmor_setprocattr(const char *name, void *value,
 		goto out;
 
 	arg_size = size - (args - (largs ? largs : (char *) value));
-	if (strcmp(name, "current") == 0) {
+	if (strcmp(name, "current") == 0 || strcmp(name, "context") == 0) {
 		if (strcmp(command, "changehat") == 0) {
 			error = aa_setprocattr_changehat(args, arg_size,
 							 !AA_DO_TEST);
@@ -518,7 +542,10 @@ static int apparmor_setprocattr(const char *name, void *value,
 		else
 			goto fail;
 	} else
-		/* only support the "current" and "exec" process attributes */
+		/*
+		 * only support the "current", "context" and "exec"
+		 * process attributes
+		 */
 		goto fail;
 
 	if (!error)
@@ -918,13 +945,17 @@ static int __init apparmor_init(void)
 	int error;
 
 	if (!finish) {
-		if (apparmor_enabled && security_module_enable("apparmor"))
+		if (apparmor_enabled &&
+		    security_module_enable("apparmor",
+				IS_ENABLED(CONFIG_SECURITY_APPARMOR_STACKED)))
 			security_add_blobs(&apparmor_blob_sizes);
 		finish = 1;
 		return 0;
 	}
 
-	if (!apparmor_enabled || !security_module_enable("apparmor")) {
+	if (!apparmor_enabled ||
+	    !security_module_enable("apparmor",
+				IS_ENABLED(CONFIG_SECURITY_APPARMOR_STACKED))) {
 		aa_info_message("AppArmor disabled by boot time parameter");
 		apparmor_enabled = 0;
 		return 0;
diff --git a/security/security.c b/security/security.c
index 1004914..895e9ef 100644
--- a/security/security.c
+++ b/security/security.c
@@ -34,6 +34,7 @@
 
 /* Maximum number of letters for an LSM name string */
 #define SECURITY_NAME_MAX	10
+#define MODULE_STACK		"(stacking)"
 
 struct security_hook_heads security_hook_heads __lsm_ro_after_init;
 char *lsm_names;
@@ -41,7 +42,11 @@ static struct lsm_blob_sizes blob_sizes;
 
 /* Boot-time LSM user choice */
 static __initdata char chosen_lsm[SECURITY_NAME_MAX + 1] =
+#ifdef CONFIG_SECURITY_STACKING
+	MODULE_STACK;
+#else
 	CONFIG_DEFAULT_SECURITY;
+#endif
 
 static void __init do_security_initcalls(void)
 {
@@ -150,6 +155,7 @@ static int lsm_append(char *new, char **result)
 /**
  * security_module_enable - Load given security module on boot ?
  * @module: the name of the module
+ * @stacked: indicates that the module wants to be stacked
  *
  * Each LSM must pass this method before registering its own operations
  * to avoid security registration races. This method may also be used
@@ -165,9 +171,29 @@ static int lsm_append(char *new, char **result)
  *
  * Otherwise, return false.
  */
-int __init security_module_enable(const char *module)
+bool __init security_module_enable(const char *lsm, const bool stacked)
 {
-	return !strcmp(module, chosen_lsm);
+#ifdef CONFIG_SECURITY_STACKING
+	/*
+	 * Module defined on the command line security=XXXX
+	 */
+	if (strcmp(chosen_lsm, MODULE_STACK)) {
+		if (!strcmp(lsm, chosen_lsm)) {
+			pr_info("Command line sets the %s security module.\n",
+				lsm);
+			return true;
+		}
+		return false;
+	}
+	/*
+	 * Module configured as stacked.
+	 */
+	return stacked;
+#else
+	if (strcmp(lsm, chosen_lsm) == 0)
+		return true;
+	return false;
+#endif
 }
 
 /**
@@ -1642,8 +1668,49 @@ int security_getprocattr(struct task_struct *p, const char *lsm, char *name,
 				char **value)
 {
 	struct security_hook_list *hp;
+	char *vp;
+	char *cp = NULL;
+	int trc;
 	int rc;
 
+	/*
+	 * "context" requires work here in addition to what
+	 * the modules provide.
+	 */
+	if (strcmp(name, "context") == 0) {
+		*value = NULL;
+		rc = -EINVAL;
+		list_for_each_entry(hp,
+				&security_hook_heads.getprocattr, list) {
+			if (lsm != NULL && strcmp(lsm, hp->lsm))
+				continue;
+			trc = hp->hook.getprocattr(p, "context", &vp);
+			if (trc == -ENOENT)
+				continue;
+			if (trc <= 0) {
+				kfree(*value);
+				return trc;
+			}
+			rc = trc;
+			if (*value == NULL) {
+				*value = vp;
+			} else {
+				cp = kasprintf(GFP_KERNEL, "%s,%s", *value, vp);
+				if (cp == NULL) {
+					kfree(*value);
+					kfree(vp);
+					return -ENOMEM;
+				}
+				kfree(*value);
+				kfree(vp);
+				*value = cp;
+			}
+		}
+		if (rc > 0)
+			return strlen(*value);
+		return rc;
+	}
+
 	list_for_each_entry(hp, &security_hook_heads.getprocattr, list) {
 		if (lsm != NULL && strcmp(lsm, hp->lsm))
 			continue;
@@ -1659,6 +1726,77 @@ int security_setprocattr(const char *lsm, const char *name, void *value,
 {
 	struct security_hook_list *hp;
 	int rc;
+	char *local;
+	char *cp;
+	int slen;
+	int failed = 0;
+
+	/*
+	 * If lsm is NULL look at all the modules to find one
+	 * that processes name. If lsm is not NULL only look at
+	 * that module.
+	 *
+	 * "context" is handled directly here.
+	 */
+	if (strcmp(name, "context") == 0) {
+		/*
+		 * First verify that the input is acceptable.
+		 * lsm1='v1'lsm2='v2'lsm3='v3'
+		 *
+		 * A note on the use of strncmp() below.
+		 * The check is for the substring at the beginning of cp.
+		 * The kzalloc of size + 1 ensures a terminated string.
+		 */
+		rc = -EINVAL;
+		local = kzalloc(size + 1, GFP_KERNEL);
+		memcpy(local, value, size);
+		cp = local;
+		list_for_each_entry(hp, &security_hook_heads.setprocattr,
+					list) {
+			if (lsm != NULL && strcmp(lsm, hp->lsm))
+				continue;
+			if (cp[0] == ',') {
+				if (cp == local)
+					goto free_out;
+				cp++;
+			}
+			slen = strlen(hp->lsm);
+			if (strncmp(cp, hp->lsm, slen))
+				goto free_out;
+			cp += slen;
+			if (cp[0] != '=' || cp[1] != '\'' || cp[2] == '\'')
+				goto free_out;
+			for (cp += 2; cp[0] != '\''; cp++)
+				if (cp[0] == '\0')
+					goto free_out;
+			cp++;
+		}
+
+		cp = local;
+		list_for_each_entry(hp, &security_hook_heads.setprocattr,
+					list) {
+			if (lsm != NULL && strcmp(lsm, hp->lsm))
+				continue;
+			if (cp[0] == ',')
+				cp++;
+			cp += strlen(hp->lsm) + 2;
+			for (slen = 0; cp[slen] != '\''; slen++)
+				;
+			cp[slen] = '\0';
+
+			rc = hp->hook.setprocattr("context", cp, slen);
+			if (rc < 0)
+				failed = rc;
+			cp += slen + 1;
+		}
+		if (failed != 0)
+			rc = failed;
+		else
+			rc = size;
+free_out:
+		kfree(local);
+		return rc;
+	}
 
 	list_for_each_entry(hp, &security_hook_heads.setprocattr, list) {
 		if (lsm != NULL && strcmp(lsm, hp->lsm))
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 6e51ae5..cc8c177 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5682,6 +5682,8 @@ static int selinux_getprocattr(struct task_struct *p,
 
 	if (!strcmp(name, "current"))
 		sid = __tsec->sid;
+	else if (!strcmp(name, "context"))
+		sid = __tsec->sid;
 	else if (!strcmp(name, "prev"))
 		sid = __tsec->osid;
 	else if (!strcmp(name, "exec"))
@@ -5701,7 +5703,19 @@ static int selinux_getprocattr(struct task_struct *p,
 	if (!sid)
 		return 0;
 
-	error = security_sid_to_context(sid, value, &len);
+	if (strcmp(name, "context")) {
+		error = security_sid_to_context(sid, value, &len);
+	} else {
+		char *vp;
+
+		error = security_sid_to_context(sid, &vp, &len);
+		if (!error) {
+			*value = kasprintf(GFP_KERNEL, "selinux='%s'", vp);
+			if (*value == NULL)
+				error = -ENOMEM;
+		}
+	}
+
 	if (error)
 		return error;
 	return len;
@@ -5737,6 +5751,9 @@ static int selinux_setprocattr(const char *name, void *value, size_t size)
 	else if (!strcmp(name, "current"))
 		error = avc_has_perm(mysid, mysid, SECCLASS_PROCESS,
 				     PROCESS__SETCURRENT, NULL);
+	else if (!strcmp(name, "context"))
+		error = avc_has_perm(mysid, mysid, SECCLASS_PROCESS,
+				     PROCESS__SETCURRENT, NULL);
 	else
 		error = -EINVAL;
 	if (error)
@@ -5797,7 +5814,7 @@ static int selinux_setprocattr(const char *name, void *value, size_t size)
 		tsec->keycreate_sid = sid;
 	} else if (!strcmp(name, "sockcreate")) {
 		tsec->sockcreate_sid = sid;
-	} else if (!strcmp(name, "current")) {
+	} else if (!strcmp(name, "current") || !strcmp(name, "context")) {
 		error = -EINVAL;
 		if (sid == 0)
 			goto abort_change;
@@ -6174,7 +6191,8 @@ static __init int selinux_init(void)
 {
 	static int finish;
 
-	if (!security_module_enable("selinux")) {
+	if (!security_module_enable("selinux",
+				IS_ENABLED(CONFIG_SECURITY_SELINUX_STACKED))) {
 		selinux_enabled = 0;
 		return 0;
 	}
diff --git a/security/selinux/include/objsec.h b/security/selinux/include/objsec.h
index 1b1dff4..05fe04a 100644
--- a/security/selinux/include/objsec.h
+++ b/security/selinux/include/objsec.h
@@ -144,12 +144,20 @@ extern struct lsm_blob_sizes selinux_blob_sizes;
 
 static inline struct task_security_struct *selinux_cred(const struct cred *cred)
 {
+#ifdef CONFIG_SECURITY_STACKING
+	return cred->security + selinux_blob_sizes.lbs_cred;
+#else
 	return cred->security;
+#endif
 }
 
 static inline struct file_security_struct *selinux_file(const struct file *file)
 {
+#ifdef CONFIG_SECURITY_STACKING
+	return file->f_security + selinux_blob_sizes.lbs_file;
+#else
 	return file->f_security;
+#endif
 }
 
 static inline struct inode_security_struct *selinux_inode(
diff --git a/security/smack/smack.h b/security/smack/smack.h
index f4ad92d..e1cd53e 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -336,6 +336,7 @@ extern struct smack_known *smack_syslog_label;
 extern struct smack_known *smack_unconfined;
 #endif
 extern int smack_ptrace_rule;
+extern struct lsm_blob_sizes smack_blob_sizes;
 
 extern struct smack_known smack_known_floor;
 extern struct smack_known smack_known_hat;
@@ -358,12 +359,20 @@ extern struct hlist_head smack_known_hash[SMACK_HASH_SLOTS];
 
 static inline struct task_smack *smack_cred(const struct cred *cred)
 {
+#ifdef CONFIG_SECURITY_STACKING
+	return cred->security + smack_blob_sizes.lbs_cred;
+#else
 	return cred->security;
+#endif
 }
 
 static inline struct smack_known **smack_file(const struct file *file)
 {
+#ifdef CONFIG_SECURITY_STACKING
+	return file->f_security + smack_blob_sizes.lbs_file;
+#else
 	return file->f_security;
+#endif
 }
 
 static inline struct inode_smack *smack_inode(const struct inode *inode)
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index a0b580e..b2589eb 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -3453,18 +3453,20 @@ static int smack_getprocattr(struct task_struct *p, char *name, char **value)
 {
 	struct smack_known *skp = smk_of_task_struct(p);
 	char *cp;
-	int slen;
 
-	if (strcmp(name, "current") != 0)
+	if (strcmp(name, "current") == 0) {
+		cp = kstrdup(skp->smk_known, GFP_KERNEL);
+		if (cp == NULL)
+			return -ENOMEM;
+	} else if (strcmp(name, "context") == 0) {
+		cp = kasprintf(GFP_KERNEL, "smack='%s'", skp->smk_known);
+		if (cp == NULL)
+			return -ENOMEM;
+	} else
 		return -EINVAL;
 
-	cp = kstrdup(skp->smk_known, GFP_KERNEL);
-	if (cp == NULL)
-		return -ENOMEM;
-
-	slen = strlen(cp);
 	*value = cp;
-	return slen;
+	return strlen(cp);
 }
 
 /**
@@ -3492,7 +3494,7 @@ static int smack_setprocattr(const char *name, void *value, size_t size)
 	if (value == NULL || size == 0 || size >= SMK_LONGLABEL)
 		return -EINVAL;
 
-	if (strcmp(name, "current") != 0)
+	if (strcmp(name, "current") != 0 && strcmp(name, "context") != 0)
 		return -EINVAL;
 
 	skp = smk_import_entry(value, size);
@@ -4622,7 +4624,8 @@ static __init int smack_init(void)
 	struct cred *cred = (struct cred *) current->cred;
 	struct task_smack *tsp;
 
-	if (!security_module_enable("smack"))
+	if (!security_module_enable("smack",
+				IS_ENABLED(CONFIG_SECURITY_SMACK_STACKED)))
 		return 0;
 
 	if (!finish) {
diff --git a/security/tomoyo/common.h b/security/tomoyo/common.h
index cbcfccc..2eed9d4 100644
--- a/security/tomoyo/common.h
+++ b/security/tomoyo/common.h
@@ -1085,6 +1085,7 @@ extern struct tomoyo_domain_info tomoyo_kernel_domain;
 extern struct tomoyo_policy_namespace tomoyo_kernel_namespace;
 extern unsigned int tomoyo_memory_quota[TOMOYO_MAX_MEMORY_STAT];
 extern unsigned int tomoyo_memory_used[TOMOYO_MAX_MEMORY_STAT];
+extern struct lsm_blob_sizes tomoyo_blob_sizes;
 
 /********** Inlined functions. **********/
 
@@ -1204,7 +1205,11 @@ static inline void tomoyo_put_group(struct tomoyo_group *group)
  */
 static inline struct tomoyo_domain_info **tomoyo_cred(const struct cred *cred)
 {
+#ifdef CONFIG_SECURITY_STACKING
+	return cred->security + tomoyo_blob_sizes.lbs_cred;
+#else
 	return cred->security;
+#endif
 }
 
 /**
@@ -1214,8 +1219,13 @@ static inline struct tomoyo_domain_info **tomoyo_cred(const struct cred *cred)
  */
 static inline struct tomoyo_domain_info *tomoyo_domain(void)
 {
-	struct tomoyo_domain_info **blob = tomoyo_cred(current_cred());
+	const struct cred *cred = current_cred();
+	struct tomoyo_domain_info **blob;
+
+	if (cred->security == NULL)
+		return NULL;
 
+	blob = tomoyo_cred(cred);
 	return *blob;
 }
 
diff --git a/security/tomoyo/tomoyo.c b/security/tomoyo/tomoyo.c
index 901fa78..aa52fff 100644
--- a/security/tomoyo/tomoyo.c
+++ b/security/tomoyo/tomoyo.c
@@ -561,7 +561,8 @@ static int __init tomoyo_init(void)
 	struct cred *cred = (struct cred *) current_cred();
 	struct tomoyo_domain_info **blob;
 
-	if (!security_module_enable("tomoyo"))
+	if (!security_module_enable("tomoyo",
+				IS_ENABLED(CONFIG_SECURITY_TOMOYO_STACKED)))
 		return 0;
 
 	if (!finish) {
-- 
2.5.5
