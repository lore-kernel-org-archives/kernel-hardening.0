Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 18 Feb 2012 11:38:57 -0800
From: Kees Cook <keescook@chromium.org>
Message-ID: <20120218193857.GA30985@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [PATCH] fs: hardlink creation restrictions
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>, Alexander Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This is the other half of link restrictions, now that symlink restriction
has landed in -mm.

On systems that have user-writable directories on the same partition
as system files, a long-standing class of security issues is the
hardlink-based time-of-check-time-of-use race, most commonly seen in
world-writable directories like /tmp. The common method of exploitation
of this flaw is to cross privilege boundaries when following a given
hardlink (i.e. a root process follows a hardlink created by another
user). Additionally, an issue exists where users can "pin" a potentially
vulnerable setuid/setgid file so that an administrator will not actually
upgrade a system fully.

The solution is to permit hardlinks to only be created when the user is
already the existing file's owner, or if they already have read/write
access to the existing file.

Many Linux users are surprised when they learn they can link to files
they have no access to, so this change appears to follow the doctrine
of "least surprise". Additionally, this change does not violate POSIX,
which states "the implementation may require that the calling process
has permission to access the existing file"[1].

This change is known to break some implementations of the "at" daemon,
though the version used by Fedora and Ubuntu has been fixed[2] for
a while. Otherwise, the change has been undisruptive while in use in
Ubuntu for the last 1.5 years.

This patch is based on the patch in Openwall and grsecurity.  I have
added a sysctl to enable the protected behavior, documentation, and an
audit notification.

[1] http://pubs.opengroup.org/onlinepubs/9699919799/functions/linkat.html
[2] http://anonscm.debian.org/gitweb/?p=collab-maint/at.git;a=commitdiff;h=f4114656c3a6c6f6070e315ffdf940a49eda3279

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 Documentation/sysctl/fs.txt |   21 ++++++++++++
 fs/Kconfig                  |   46 ++++++++++++++++++++-------
 fs/namei.c                  |   72 ++++++++++++++++++++++++++++++++++++++++++-
 include/linux/fs.h          |    1 +
 kernel/sysctl.c             |   11 ++++++-
 5 files changed, 137 insertions(+), 14 deletions(-)

diff --git a/Documentation/sysctl/fs.txt b/Documentation/sysctl/fs.txt
index 4b47cd5..08458be 100644
--- a/Documentation/sysctl/fs.txt
+++ b/Documentation/sysctl/fs.txt
@@ -32,6 +32,7 @@ Currently, these files are in /proc/sys/fs:
 - nr_open
 - overflowuid
 - overflowgid
+- protected_nonaccess_hardlinks
 - protected_sticky_symlinks
 - suid_dumpable
 - super-max
@@ -158,6 +159,26 @@ The default is 65534.
 
 ==============================================================
 
+protected_nonaccess_hardlinks:
+
+A long-standing class of security issues is the hardlink-based
+time-of-check-time-of-use race, most commonly seen in world-writable
+directories like /tmp. The common method of exploitation of this flaw
+is to cross privilege boundaries when following a given hardlink (i.e. a
+root process follows a hardlink created by another user). Additionally,
+on systems without separated partitions, this stops unauthorized users
+from "pinning" vulnerable setuid/setgid files against being upgraded by
+the administrator.
+
+When set to "0", hardlink creation behavior is unrestricted.
+
+When set to "1" hardlinks cannot be created by users if they do not
+already own the source file, or do not have read/write access to it.
+
+This protection is based on the restrictions in Openwall and grsecurity.
+
+==============================================================
+
 protected_sticky_symlinks:
 
 A long-standing class of security issues is the symlink-based
diff --git a/fs/Kconfig b/fs/Kconfig
index ca279b7..66f9334 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -271,27 +271,29 @@ endif # NETWORK_FILESYSTEMS
 source "fs/nls/Kconfig"
 source "fs/dlm/Kconfig"
 
-config PROTECTED_STICKY_SYMLINKS
-	bool "Evaluate vulnerable symlink conditions"
-	default y
+config PROTECTED_LINKS
+	bool "Evaluate vulnerable link conditions"
+	default n
 	help
-	  A long-standing class of security issues is the symlink-based
+	  A long-standing class of security issues is the link-based
 	  time-of-check-time-of-use race, most commonly seen in
 	  world-writable directories like /tmp. The common method of
 	  exploitation of this flaw is to cross privilege boundaries
-	  when following a given symlink (i.e. a root process follows
-	  a malicious symlink belonging to another user).
+	  when following a given link (i.e. a root process follows
+	  a malicious symlink belonging to another user, or a hardlink
+	  created to a root-owned file).
 
-	  Enabling this adds the logic to examine these dangerous symlink
-	  conditions. Whether or not the dangerous symlink situations are
-	  allowed is controlled by PROTECTED_STICKY_SYMLINKS_ENABLED.
+	  Enabling this adds the logic to examine these dangerous link
+	  conditions. Whether or not the dangerous link situations are
+	  allowed is controlled by PROTECTED_NONACCESS_HARDLINKS_ENABLED and
+	  PROTECTED_STICKY_SYMLINKS_ENABLED.
 
 config PROTECTED_STICKY_SYMLINKS_ENABLED
-	depends on PROTECTED_STICKY_SYMLINKS
+	depends on PROTECTED_LINKS
 	bool "Disallow symlink following in sticky world-writable dirs"
 	default y
 	help
-	  Solve ToCToU symlink race vulnerablities by permitting symlinks
+	  Solve ToCToU symlink race vulnerabilities by permitting symlinks
 	  to be followed only when outside a sticky world-writable directory,
 	  or when the uid of the symlink and follower match, or when the
 	  directory and symlink owners match.
@@ -300,9 +302,29 @@ config PROTECTED_STICKY_SYMLINKS_ENABLED
 	  via /proc/sys/kernel/protected_sticky_symlinks.
 
 config PROTECTED_STICKY_SYMLINKS_ENABLED_SYSCTL
-	depends on PROTECTED_STICKY_SYMLINKS
+	depends on PROTECTED_LINKS
 	int
 	default "1" if PROTECTED_STICKY_SYMLINKS_ENABLED
 	default "0"
 
+config PROTECTED_NONACCESS_HARDLINKS_ENABLED
+	depends on PROTECTED_LINKS
+	bool "Disallow hardlink creation to non-accessible files"
+	default y
+	help
+	  Solve ToCToU hardlink race vulnerabilities by permitting hardlinks
+	  to be created only when to a regular file that is owned by the user,
+	  or is readable and writable by the user. Also blocks users from
+	  "pinning" vulnerable setuid/setgid programs from being upgraded by
+	  the administrator.
+
+	  When PROC_SYSCTL is enabled, this setting can also be controlled
+	  via /proc/sys/kernel/protected_nonaccess_hardlinks.
+
+config PROTECTED_NONACCESS_HARDLINKS_ENABLED_SYSCTL
+	depends on PROTECTED_LINKS
+	int
+	default "1" if PROTECTED_NONACCESS_HARDLINKS_ENABLED
+	default "0"
+
 endmenu
diff --git a/fs/namei.c b/fs/namei.c
index 95626f1..c36b8c5 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -623,7 +623,7 @@ static inline void put_link(struct nameidata *nd, struct path *link, void *cooki
 	path_put(link);
 }
 
-#ifdef CONFIG_PROTECTED_STICKY_SYMLINKS
+#ifdef CONFIG_PROTECTED_LINKS
 int sysctl_protected_sticky_symlinks __read_mostly =
 	CONFIG_PROTECTED_STICKY_SYMLINKS_ENABLED_SYSCTL;
 
@@ -3004,6 +3004,73 @@ int vfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_de
 	return error;
 }
 
+#ifdef CONFIG_PROTECTED_LINKS
+int sysctl_protected_nonaccess_hardlinks __read_mostly =
+	CONFIG_PROTECTED_NONACCESS_HARDLINKS_ENABLED_SYSCTL;
+
+/**
+ * may_linkat - Check permissions for creating a hardlink
+ * @old_path: the source to hardlink from
+ *
+ * Block hardlink when all of:
+ *  - sysctl_protected_nonaccess_hardlinks enabled
+ *  - fsuid does not match inode
+ *  - at least one of:
+ *    - inode is not a regular file
+ *    - inode is setuid
+ *    - inode is setgid and group-exec
+ *    - access failure for read and write
+ *  - not CAP_FOWNER
+ *
+ * Returns 0 if successful, -ve on error.
+ */
+static inline int may_linkat(struct path *old_path)
+{
+	int error = 0;
+	const struct cred *cred;
+	struct inode *inode;
+	int mode;
+
+	if (!sysctl_protected_nonaccess_hardlinks)
+		return 0;
+
+	cred = current_cred();
+	inode = old_path->dentry->d_inode;
+	mode = inode->i_mode;
+
+	if (cred->fsuid != inode->i_uid &&
+	    (!S_ISREG(mode) || (mode & S_ISUID) ||
+	     ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP)) ||
+	     (inode_permission(inode, MAY_READ | MAY_WRITE))) &&
+	    !capable(CAP_FOWNER))
+		error = -EPERM;
+
+#ifdef CONFIG_AUDIT
+	if (error) {
+		struct audit_buffer *ab;
+
+		ab = audit_log_start(current->audit_context,
+				     GFP_KERNEL, AUDIT_AVC);
+		audit_log_format(ab, "op=linkat action=denied");
+		audit_log_format(ab, " pid=%d comm=", current->pid);
+		audit_log_untrustedstring(ab, current->comm);
+		audit_log_d_path(ab, " path=", old_path);
+		audit_log_format(ab, " dev=");
+		audit_log_untrustedstring(ab, inode->i_sb->s_id);
+		audit_log_format(ab, " ino=%lu", inode->i_ino);
+		audit_log_end(ab);
+	}
+#endif
+
+	return error;
+}
+#else
+static inline int may_linkat(struct path *old_path)
+{
+	return 0;
+}
+#endif
+
 /*
  * Hardlinks are often used in delicate situations.  We avoid
  * security-related surprises by not following symlinks on the
@@ -3052,6 +3119,9 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
 	error = mnt_want_write(new_path.mnt);
 	if (error)
 		goto out_dput;
+	error = may_linkat(&old_path);
+	if (error)
+		goto out_dput;
 	error = security_path_link(old_path.dentry, &new_path, new_dentry);
 	if (error)
 		goto out_drop_write;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e8474d8..feb0592 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -423,6 +423,7 @@ extern int sysctl_nr_open;
 extern struct inodes_stat_t inodes_stat;
 extern int leases_enable, lease_break_time;
 extern int sysctl_protected_sticky_symlinks;
+extern int sysctl_protected_nonaccess_hardlinks;
 
 struct buffer_head;
 typedef int (get_block_t)(struct inode *inode, sector_t iblock,
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index b1d0cf2..fa8b3d3 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1503,7 +1503,7 @@ static struct ctl_table fs_table[] = {
 	},
 #endif
 #endif
-#ifdef CONFIG_PROTECTED_STICKY_SYMLINKS
+#ifdef CONFIG_PROTECTED_LINKS
 	{
 		.procname	= "protected_sticky_symlinks",
 		.data		= &sysctl_protected_sticky_symlinks,
@@ -1513,6 +1513,15 @@ static struct ctl_table fs_table[] = {
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
+	{
+		.procname	= "protected_nonaccess_hardlinks",
+		.data		= &sysctl_protected_nonaccess_hardlinks,
+		.maxlen		= sizeof(int),
+		.mode		= 0600,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
 #endif
 	{
 		.procname	= "suid_dumpable",
-- 
1.7.0.4
