Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Fri, 22 Jan 2016 14:39:04 -0800
Message-Id: <1453502345-30416-2-git-send-email-keescook@chromium.org>
In-Reply-To: <1453502345-30416-1-git-send-email-keescook@chromium.org>
References: <1453502345-30416-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 1/2] sysctl: expand use of proc_dointvec_minmax_sysadmin
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Richard Weinberger <richard@nod.at>, "Eric W. Biederman" <ebiederm@xmission.com>, Andy Lutomirski <luto@amacapital.net>, =?UTF-8?q?Robert=20=C5=9Awi=C4=99cki?= <robert@swiecki.net>, Dmitry Vyukov <dvyukov@google.com>, David Howells <dhowells@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Eric Dumazet <edumazet@google.com>, Sasha Levin <sasha.levin@oracle.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Several sysctls expect a state where the highest value (in extra2) is
locked once set for that boot. Yama does this, and kptr_restrict should
be doing it. This extracts Yama's logic and adds it to the existing
proc_dointvec_minmax_sysadmin, taking care to avoid the simple boolean
states (which do not get locked). Since Yama wants to be checking a
different capability, we build wrappers for both cases (CAP_SYS_ADMIN
and CAP_SYS_PTRACE).

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 Documentation/sysctl/kernel.txt |  4 +++-
 include/linux/sysctl.h          | 18 ++++++++++++++++++
 kernel/sysctl.c                 | 34 +++++++++++++++++++++-------------
 security/yama/yama_lsm.c        | 18 +-----------------
 4 files changed, 43 insertions(+), 31 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 73c6b1ef0e84..bbfc5e339a3d 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -385,7 +385,9 @@ to protect against uses of %pK in dmesg(8) if leaking kernel pointer
 values to unprivileged users is a concern.
 
 When kptr_restrict is set to (2), kernel pointers printed using
-%pK will be replaced with 0's regardless of privileges.
+%pK will be replaced with 0's regardless of privileges, and the value
+will be locked at "2", so that the root user cannot remove this
+restriction.
 
 ==============================================================
 
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index fa7bc29925c9..f8f0b991fe3e 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -23,6 +23,7 @@
 
 #include <linux/list.h>
 #include <linux/rcupdate.h>
+#include <linux/capability.h>
 #include <linux/wait.h>
 #include <linux/rbtree.h>
 #include <uapi/linux/sysctl.h>
@@ -55,6 +56,23 @@ extern int proc_doulongvec_ms_jiffies_minmax(struct ctl_table *table, int,
 				      void __user *, size_t *, loff_t *);
 extern int proc_do_large_bitmap(struct ctl_table *, int,
 				void __user *, size_t *, loff_t *);
+extern int proc_dointvec_minmax_cap(int cap, struct ctl_table *table,
+				    int write, void __user *buffer,
+				    size_t *lenp, loff_t *ppos);
+static inline int proc_dointvec_minmax_cap_sysadmin(struct ctl_table *table,
+				    int write, void __user *buffer,
+				    size_t *lenp, loff_t *ppos)
+{
+	return proc_dointvec_minmax_cap(CAP_SYS_ADMIN, table, write, buffer,
+					lenp, ppos);
+}
+static inline int proc_dointvec_minmax_cap_ptrace(struct ctl_table *table,
+				    int write, void __user *buffer,
+				    size_t *lenp, loff_t *ppos)
+{
+	return proc_dointvec_minmax_cap(CAP_SYS_PTRACE, table, write, buffer,
+					lenp, ppos);
+}
 
 /*
  * Register a set of sysctl names by calling register_sysctl_table
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c810f8afdb7f..fc8899dd636d 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -181,11 +181,6 @@ static int proc_taint(struct ctl_table *table, int write,
 			       void __user *buffer, size_t *lenp, loff_t *ppos);
 #endif
 
-#ifdef CONFIG_PRINTK
-static int proc_dointvec_minmax_sysadmin(struct ctl_table *table, int write,
-				void __user *buffer, size_t *lenp, loff_t *ppos);
-#endif
-
 static int proc_dointvec_minmax_coredump(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp, loff_t *ppos);
 #ifdef CONFIG_COREDUMP
@@ -803,7 +798,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &dmesg_restrict,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax_sysadmin,
+		.proc_handler	= proc_dointvec_minmax_cap_sysadmin,
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
@@ -812,7 +807,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &kptr_restrict,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax_sysadmin,
+		.proc_handler	= proc_dointvec_minmax_cap_sysadmin,
 		.extra1		= &zero,
 		.extra2		= &two,
 	},
@@ -2217,16 +2212,29 @@ static int proc_taint(struct ctl_table *table, int write,
 	return err;
 }
 
-#ifdef CONFIG_PRINTK
-static int proc_dointvec_minmax_sysadmin(struct ctl_table *table, int write,
-				void __user *buffer, size_t *lenp, loff_t *ppos)
+int proc_dointvec_minmax_cap(int cap, struct ctl_table *table, int write,
+			     void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-	if (write && !capable(CAP_SYS_ADMIN))
+	struct ctl_table table_copy;
+	int value;
+
+	/* Require init capabilities to make changes. */
+	if (write && !capable(cap))
 		return -EPERM;
 
-	return proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+	/*
+	 * To deal with const sysctl tables, we make a copy to perform
+	 * the locking. When data is >1 and ==extra2, lock extra1 to
+	 * extra2 to stop the value from being changed any further at
+	 * runtime.
+	 */
+	table_copy = *table;
+	value = *(int *)table_copy.data;
+	if (value > 1 && value == *(int *)table_copy.extra2)
+		table_copy.extra1 = table_copy.extra2;
+
+	return proc_dointvec_minmax(&table_copy, write, buffer, lenp, ppos);
 }
-#endif
 
 struct do_proc_dointvec_minmax_conv_param {
 	int *min;
diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
index d3c19c970a06..3215afd08fbd 100644
--- a/security/yama/yama_lsm.c
+++ b/security/yama/yama_lsm.c
@@ -354,22 +354,6 @@ static struct security_hook_list yama_hooks[] = {
 };
 
 #ifdef CONFIG_SYSCTL
-static int yama_dointvec_minmax(struct ctl_table *table, int write,
-				void __user *buffer, size_t *lenp, loff_t *ppos)
-{
-	struct ctl_table table_copy;
-
-	if (write && !capable(CAP_SYS_PTRACE))
-		return -EPERM;
-
-	/* Lock the max value if it ever gets set. */
-	table_copy = *table;
-	if (*(int *)table_copy.data == *(int *)table_copy.extra2)
-		table_copy.extra1 = table_copy.extra2;
-
-	return proc_dointvec_minmax(&table_copy, write, buffer, lenp, ppos);
-}
-
 static int zero;
 static int max_scope = YAMA_SCOPE_NO_ATTACH;
 
@@ -385,7 +369,7 @@ static struct ctl_table yama_sysctl_table[] = {
 		.data           = &ptrace_scope,
 		.maxlen         = sizeof(int),
 		.mode           = 0644,
-		.proc_handler   = yama_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax_cap_ptrace,
 		.extra1         = &zero,
 		.extra2         = &max_scope,
 	},
-- 
2.6.3
