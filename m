Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
From: Vasiliy Kulikov <segoon@openwall.com>
Date: Wed, 15 Jun 2011 22:51:39 +0400
Message-Id: <1308163900-6006-1-git-send-email-segoon@openwall.com>
Subject: [kernel-hardening] [RFC 1/5 v4] procfs: parse mount options
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Al Viro <viro@zeniv.linux.org.uk>, Daniel Lezcano <daniel.lezcano@free.fr>, Alexey Dobriyan <adobriyan@gmail.com>, Stephen Wilson <wilsons@start.ca>, "Serge E. Hallyn" <serge@hallyn.com>
List-ID: <kernel-hardening.lists.openwall.com>

This patch adds support of procfs mount options.
Actual mount options are comming in the next patches.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 fs/proc/inode.c    |   10 +++++++++
 fs/proc/internal.h |    1 +
 fs/proc/root.c     |   56 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 65 insertions(+), 2 deletions(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 74b48cf..b5f49eb 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -7,6 +7,7 @@
 #include <linux/time.h>
 #include <linux/proc_fs.h>
 #include <linux/kernel.h>
+#include <linux/pid_namespace.h>
 #include <linux/mm.h>
 #include <linux/string.h>
 #include <linux/stat.h>
@@ -17,7 +18,9 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/sysctl.h>
+#include <linux/seq_file.h>
 #include <linux/slab.h>
+#include <linux/mount.h>
 
 #include <asm/system.h>
 #include <asm/uaccess.h>
@@ -102,12 +105,19 @@ void __init proc_init_inodecache(void)
 					     init_once);
 }
 
+static int proc_show_options(struct seq_file *seq, struct vfsmount *vfs)
+{
+	return 0;
+}
+
 static const struct super_operations proc_sops = {
 	.alloc_inode	= proc_alloc_inode,
 	.destroy_inode	= proc_destroy_inode,
 	.drop_inode	= generic_delete_inode,
 	.evict_inode	= proc_evict_inode,
 	.statfs		= simple_statfs,
+	.remount_fs	= proc_remount,
+	.show_options	= proc_show_options,
 };
 
 static void __pde_users_dec(struct proc_dir_entry *pde)
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 7838e5c..2925775 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -117,6 +117,7 @@ void pde_put(struct proc_dir_entry *pde);
 
 int proc_fill_super(struct super_block *);
 struct inode *proc_get_inode(struct super_block *, struct proc_dir_entry *);
+int proc_remount(struct super_block *sb, int *flags, char *data);
 
 /*
  * These are generic /proc routines that use the internal
diff --git a/fs/proc/root.c b/fs/proc/root.c
index a9000e9..b2571fe 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -18,6 +18,7 @@
 #include <linux/bitops.h>
 #include <linux/mount.h>
 #include <linux/pid_namespace.h>
+#include <linux/parser.h>
 
 #include "internal.h"
 
@@ -35,6 +36,49 @@ static int proc_set_super(struct super_block *sb, void *data)
 	return set_anon_super(sb, NULL);
 }
 
+enum {
+	Opt_err,
+};
+
+static const match_table_t tokens = {
+	{Opt_err, NULL},
+};
+
+static int proc_parse_options(char *options, struct pid_namespace *pid)
+{
+	char *p;
+	substring_t args[MAX_OPT_ARGS];
+	int option;
+
+	pr_debug("proc: options = %s\n", options);
+
+	if (!options)
+		return 1;
+
+	while ((p = strsep(&options, ",")) != NULL) {
+		int token;
+		if (!*p)
+			continue;
+
+		args[0].to = args[0].from = 0;
+		token = match_token(p, tokens, args);
+		switch (token) {
+		default:
+			pr_err("proc: unrecognized mount option \"%s\" "
+			       "or missing value", p);
+			return 0;
+		}
+	}
+
+	return 1;
+}
+
+int proc_remount(struct super_block *sb, int *flags, char *data)
+{
+	struct pid_namespace *pid = sb->s_fs_info;
+	return !proc_parse_options(data, pid);
+}
+
 static struct dentry *proc_mount(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data)
 {
@@ -42,11 +86,15 @@ static struct dentry *proc_mount(struct file_system_type *fs_type,
 	struct super_block *sb;
 	struct pid_namespace *ns;
 	struct proc_inode *ei;
+	char *options;
 
-	if (flags & MS_KERNMOUNT)
+	if (flags & MS_KERNMOUNT) {
 		ns = (struct pid_namespace *)data;
-	else
+		options = NULL;
+	} else {
 		ns = current->nsproxy->pid_ns;
+		options = data;
+	}
 
 	sb = sget(fs_type, proc_test_super, proc_set_super, ns);
 	if (IS_ERR(sb))
@@ -54,6 +102,10 @@ static struct dentry *proc_mount(struct file_system_type *fs_type,
 
 	if (!sb->s_root) {
 		sb->s_flags = flags;
+		if (!proc_parse_options(options, ns)) {
+			deactivate_locked_super(sb);
+			return ERR_PTR(-EINVAL);
+		}
 		err = proc_fill_super(sb);
 		if (err) {
 			deactivate_locked_super(sb);
-- 
1.7.0.4
