Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 21 Nov 2011 23:18:11 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20111121191811.GA24039@albatros>
References: <1319672956-17114-1-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319672956-17114-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [RFC] Make Yama pid_ns aware
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, "Serge E. Hallyn" <serge@hallyn.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

As Yama's sysctls are about defining a security policy for the system,
it is reasonable to define it per container in case of LXC containers
(or out-of-tree alternatives like OpenVZ).  In my opinion they belong
to pid namespace.  With per-pid_ns sysctls it is possible to create
multiple containers with different ptrace, /tmp, etc. policies.

As Yama is not merged yet, I post the patch in this thread.

The patch is straightforward:

1) all sysctl variables are moved from global vars to pid_namespace
fields.

2) each cloned pid ns gets the settings of the parent.

3) the variables of current pid ns are visible through sysctl interface.

proc_pid_dointvec_minmax() is stolen from its ipc_ns equivalent in
ipc/ipc_sysctl.c.

(The patch is not tested.)

diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index 38d1032..46edaf8 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -30,6 +30,11 @@ struct pid_namespace {
 #ifdef CONFIG_BSD_PROCESS_ACCT
 	struct bsd_acct_struct *bacct;
 #endif
+#ifdef CONFIG_SECURITY_YAMA
+	int ptrace_scope;
+	int protected_sticky_symlinks;
+	int protected_nonaccess_hardlinks;
+#endif
 };
 
 extern struct pid_namespace init_pid_ns;
diff --git a/kernel/pid.c b/kernel/pid.c
index fa5f722..0cd8926 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -78,6 +78,11 @@ struct pid_namespace init_pid_ns = {
 	.last_pid = 0,
 	.level = 0,
 	.child_reaper = &init_task,
+#ifdef CONFIG_SECURITY_YAMA
+	.ptrace_scope = 1,
+	.protected_sticky_symlinks = 1,
+	.protected_nonaccess_hardlinks = 1,
+#endif
 };
 EXPORT_SYMBOL_GPL(init_pid_ns);
 
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index e9c9adc..73d47c4 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -101,6 +101,14 @@ static struct pid_namespace *create_pid_namespace(struct pid_namespace *parent_p
 	if (err)
 		goto out_put_parent_pid_ns;
 
+#ifdef CONFIG_SECURITY_YAMA
+	ns->ptrace_scope = parent_pid_ns->ptrace_scope;
+	ns->protected_sticky_symlinks =
+		parent_pid_ns->protected_sticky_symlinks;
+	ns->protected_nonaccess_hardlinks =
+		parent_pid_ns->protected_nonaccess_hardlinks;
+#endif
+
 	return ns;
 
 out_put_parent_pid_ns:
diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
index a92538c..cf99a8c 100644
--- a/security/yama/yama_lsm.c
+++ b/security/yama/yama_lsm.c
@@ -16,10 +16,7 @@
 #include <linux/ptrace.h>
 #include <linux/prctl.h>
 #include <linux/ratelimit.h>
-
-static int ptrace_scope = 1;
-static int protected_sticky_symlinks = 1;
-static int protected_nonaccess_hardlinks = 1;
+#include <linux/pid_namespace.h>
 
 /* describe a PTRACE relationship for potential exception */
 struct ptrace_relation {
@@ -250,7 +247,7 @@ static int yama_ptrace_access_check(struct task_struct *child,
 
 	/* require ptrace target be a child of ptracer on attach */
 	if (mode == PTRACE_MODE_ATTACH &&
-	    ptrace_scope &&
+	    current->nsproxy->pid_ns->ptrace_scope &&
 	    !capable(CAP_SYS_PTRACE) &&
 	    !task_is_descendant(current, child) &&
 	    !ptracer_exception_found(current, child))
@@ -292,7 +289,7 @@ static int yama_inode_follow_link(struct dentry *dentry,
 	const struct inode *inode;
 	const struct cred *cred;
 
-	if (!protected_sticky_symlinks)
+	if (!current->nsproxy->pid_ns->protected_sticky_symlinks)
 		return 0;
 
 	/* if inode isn't a symlink, don't try to evaluate blocking it */
@@ -362,7 +359,7 @@ static int yama_path_link(struct dentry *old_dentry, struct path *new_dir,
 	const int mode = inode->i_mode;
 	const struct cred *cred = current_cred();
 
-	if (!protected_nonaccess_hardlinks)
+	if (!current->nsproxy->pid_ns->protected_nonaccess_hardlinks)
 		return 0;
 
 	if (cred->fsuid != inode->i_uid &&
@@ -395,6 +392,26 @@ static struct security_operations yama_ops = {
 static int zero;
 static int one = 1;
 
+static void *get_pid_data(ctl_table *table)
+{
+	char *which = table->data;
+	struct pid_namespace *pid_ns = current->nsproxy->pid_ns;
+	which = (which - (char *)&init_pid_ns) + (char *)pid_ns;
+	return which;
+}
+
+static int proc_pid_dointvec_minmax(ctl_table *table, int write,
+	void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table pid_table;
+
+	memcpy(&pid_table, table, sizeof(pid_table));
+	pid_table.data = get_pid_data(table);
+
+	return proc_dointvec_minmax(&pid_table, write, buffer, lenp, ppos);
+}
+
+
 struct ctl_path yama_sysctl_path[] = {
 	{ .procname = "kernel", },
 	{ .procname = "yama", },
@@ -404,28 +421,28 @@ struct ctl_path yama_sysctl_path[] = {
 static struct ctl_table yama_sysctl_table[] = {
 	{
 		.procname       = "protected_sticky_symlinks",
-		.data           = &protected_sticky_symlinks,
+		.data           = &init_pid_ns.protected_sticky_symlinks,
 		.maxlen         = sizeof(int),
 		.mode           = 0644,
-		.proc_handler   = proc_dointvec_minmax,
+		.proc_handler   = proc_pid_dointvec_minmax,
 		.extra1         = &zero,
 		.extra2         = &one,
 	},
 	{
 		.procname       = "protected_nonaccess_hardlinks",
-		.data           = &protected_nonaccess_hardlinks,
+		.data           = &init_pid_ns.protected_nonaccess_hardlinks,
 		.maxlen         = sizeof(int),
 		.mode           = 0644,
-		.proc_handler   = proc_dointvec_minmax,
+		.proc_handler   = proc_pid_dointvec_minmax,
 		.extra1         = &zero,
 		.extra2         = &one,
 	},
 	{
 		.procname       = "ptrace_scope",
-		.data           = &ptrace_scope,
+		.data           = &init_pid_ns.ptrace_scope,
 		.maxlen         = sizeof(int),
 		.mode           = 0644,
-		.proc_handler   = proc_dointvec_minmax,
+		.proc_handler   = proc_pid_dointvec_minmax,
 		.extra1         = &zero,
 		.extra2         = &one,
 	},
---
