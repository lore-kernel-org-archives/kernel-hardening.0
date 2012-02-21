Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 21 Feb 2012 13:58:00 -0800
From: Kees Cook <keescook@chromium.org>
Message-ID: <20120221215800.GA26721@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [PATCH v2] fs: hardlink creation restrictions
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Marcin Slusarz <marcin.slusarz@gmail.com>, linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

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
Acked-by: Ingo Molnar <mingo@elte.hu>

---
v2:
 - move may_linkat() before write intent, thanks to Marcin Slusarz.
 - reduce length of CONFIG and sysctl names, suggested by Ingo Molnar.
 - drop needless CONFIG_AUDIT check, thanks to Ingo Molnar.
 - default to on, since it is safer and can be disabled at runtime.
 - extract audit logs to single common function, suggested by Ingo Molnar.

---
 Documentation/sysctl/fs.txt |   25 +++++++++-
 fs/Kconfig                  |   56 ++++++++++++++++------
 fs/namei.c                  |  113 +++++++++++++++++++++++++++++++-----------
 include/linux/fs.h          |    3 +-
 kernel/sysctl.c             |   15 +++++-
 5 files changed, 161 insertions(+), 51 deletions(-)

diff --git a/Documentation/sysctl/fs.txt b/Documentation/sysctl/fs.txt
index 4b47cd5..9d29414 100644
--- a/Documentation/sysctl/fs.txt
+++ b/Documentation/sysctl/fs.txt
@@ -32,7 +32,8 @@ Currently, these files are in /proc/sys/fs:
 - nr_open
 - overflowuid
 - overflowgid
-- protected_sticky_symlinks
+- protected_hardlinks
+- protected_symlinks
 - suid_dumpable
 - super-max
 - super-nr
@@ -158,7 +159,27 @@ The default is 65534.
 
 ==============================================================
 
-protected_sticky_symlinks:
+protected_hardlinks:
+
+A long-standing class of security issues is the hardlink-based
+time-of-check-time-of-use race, most commonly seen in world-writable
+directories like /tmp. The common method of exploitation of this flaw
+is to cross privilege boundaries when following a given hardlink (i.e. a
+root process follows a hardlink created by another user). Additionally,
+on systems without separated partitions, this stops unauthorized users
+from "pinning" vulnerable setuid/setgid files against being upgraded by
+the administrator, or linking to special files.
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
+protected_symlinks:
 
 A long-standing class of security issues is the symlink-based
 time-of-check-time-of-use race, most commonly seen in world-writable
diff --git a/fs/Kconfig b/fs/Kconfig
index ca279b7..0298e22 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -271,38 +271,64 @@ endif # NETWORK_FILESYSTEMS
 source "fs/nls/Kconfig"
 source "fs/dlm/Kconfig"
 
-config PROTECTED_STICKY_SYMLINKS
-	bool "Evaluate vulnerable symlink conditions"
+config PROTECTED_LINKS
+	bool "Evaluate vulnerable link conditions"
 	default y
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
+	  allowed is controlled by PROTECTED_HARDLINKS_ENABLED and
+	  PROTECTED_SYMLINKS_ENABLED.
 
-config PROTECTED_STICKY_SYMLINKS_ENABLED
-	depends on PROTECTED_STICKY_SYMLINKS
+config PROTECTED_SYMLINKS
+	depends on PROTECTED_LINKS
 	bool "Disallow symlink following in sticky world-writable dirs"
 	default y
 	help
-	  Solve ToCToU symlink race vulnerablities by permitting symlinks
+	  Solve ToCToU symlink race vulnerabilities by permitting symlinks
 	  to be followed only when outside a sticky world-writable directory,
 	  or when the uid of the symlink and follower match, or when the
 	  directory and symlink owners match.
 
 	  When PROC_SYSCTL is enabled, this setting can also be controlled
-	  via /proc/sys/kernel/protected_sticky_symlinks.
+	  via /proc/sys/kernel/protected_symlinks.
 
-config PROTECTED_STICKY_SYMLINKS_ENABLED_SYSCTL
-	depends on PROTECTED_STICKY_SYMLINKS
+	  See Documentation/sysctl/fs.txt for details.
+
+config PROTECTED_SYMLINKS_SYSCTL
+	depends on PROTECTED_LINKS
+	int
+	default "1" if PROTECTED_SYMLINKS
+	default "0"
+
+config PROTECTED_HARDLINKS
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
+	  via /proc/sys/kernel/protected_hardlinks.
+
+	  See Documentation/sysctl/fs.txt for details.
+
+config PROTECTED_HARDLINKS_SYSCTL
+	depends on PROTECTED_LINKS
 	int
-	default "1" if PROTECTED_STICKY_SYMLINKS_ENABLED
+	default "1" if PROTECTED_HARDLINKS
 	default "0"
 
 endmenu
diff --git a/fs/namei.c b/fs/namei.c
index 95626f1..ae66788 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -623,16 +623,33 @@ static inline void put_link(struct nameidata *nd, struct path *link, void *cooki
 	path_put(link);
 }
 
-#ifdef CONFIG_PROTECTED_STICKY_SYMLINKS
-int sysctl_protected_sticky_symlinks __read_mostly =
-	CONFIG_PROTECTED_STICKY_SYMLINKS_ENABLED_SYSCTL;
+#ifdef CONFIG_PROTECTED_LINKS
+int sysctl_protected_symlinks __read_mostly =
+	CONFIG_PROTECTED_SYMLINKS_SYSCTL;
+int sysctl_protected_hardlinks __read_mostly =
+	CONFIG_PROTECTED_HARDLINKS_SYSCTL;
+
+static inline void
+audit_log_link_denied(const char *operation, struct path *link)
+{
+	struct audit_buffer *ab;
+
+	ab = audit_log_start(current->audit_context, GFP_KERNEL, AUDIT_AVC);
+	audit_log_format(ab, "op=%s action=denied", operation);
+	audit_log_format(ab, " pid=%d comm=", current->pid);
+	audit_log_untrustedstring(ab, current->comm);
+	audit_log_d_path(ab, " path=", link);
+	audit_log_format(ab, " dev=");
+	audit_log_untrustedstring(ab, link->dentry->d_inode->i_sb->s_id);
+	audit_log_format(ab, " ino=%lu", link->dentry->d_inode->i_ino);
+	audit_log_end(ab);
+}
 
 /**
  * may_follow_link - Check symlink following for unsafe situations
- * @dentry: The inode/dentry of the symlink
- * @nameidata: The path data of the symlink
+ * @link: The path of the symlink
  *
- * In the case of the protected_sticky_symlinks sysctl being enabled,
+ * In the case of the sysctl_protected_symlinks sysctl being enabled,
  * CAP_DAC_OVERRIDE needs to be specifically ignored if the symlink is
  * in a sticky world-writable directory. This is to protect privileged
  * processes from failing races against path names that may change out
@@ -643,19 +660,20 @@ int sysctl_protected_sticky_symlinks __read_mostly =
  *
  * Returns 0 if following the symlink is allowed, -ve on error.
  */
-static inline int
-may_follow_link(struct dentry *dentry, struct nameidata *nameidata)
+static inline int may_follow_link(struct path *link)
 {
 	int error = 0;
 	const struct inode *parent;
 	const struct inode *inode;
 	const struct cred *cred;
+	struct dentry *dentry;
 
-	if (!sysctl_protected_sticky_symlinks)
+	if (!sysctl_protected_symlinks)
 		return 0;
 
 	/* Allowed if owner and follower match. */
 	cred = current_cred();
+	dentry = link->dentry;
 	inode = dentry->d_inode;
 	if (cred->fsuid == inode->i_uid)
 		return 0;
@@ -669,29 +687,61 @@ may_follow_link(struct dentry *dentry, struct nameidata *nameidata)
 	}
 	spin_unlock(&dentry->d_lock);
 
-#ifdef CONFIG_AUDIT
-	if (error) {
-		struct audit_buffer *ab;
-
-		ab = audit_log_start(current->audit_context,
-				     GFP_KERNEL, AUDIT_AVC);
-		audit_log_format(ab, "op=follow_link action=denied");
-		audit_log_format(ab, " pid=%d comm=", current->pid);
-		audit_log_untrustedstring(ab, current->comm);
-		audit_log_d_path(ab, " path=", &nameidata->path);
-		audit_log_format(ab, " name=");
-		audit_log_untrustedstring(ab, dentry->d_name.name);
-		audit_log_format(ab, " dev=");
-		audit_log_untrustedstring(ab, inode->i_sb->s_id);
-		audit_log_format(ab, " ino=%lu", inode->i_ino);
-		audit_log_end(ab);
-	}
-#endif
+	if (error)
+		audit_log_link_denied("follow_link", link);
+
+	return error;
+}
+
+/**
+ * may_linkat - Check permissions for creating a hardlink
+ * @link: the source to hardlink from
+ *
+ * Block hardlink when all of:
+ *  - sysctl_protected_hardlinks enabled
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
+static inline int may_linkat(struct path *link)
+{
+	int error = 0;
+	const struct cred *cred;
+	struct inode *inode;
+	int mode;
+
+	if (!sysctl_protected_hardlinks)
+		return 0;
+
+	cred = current_cred();
+	inode = link->dentry->d_inode;
+	mode = inode->i_mode;
+
+	if (cred->fsuid != inode->i_uid &&
+	    (!S_ISREG(mode) || (mode & S_ISUID) ||
+	     ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP)) ||
+	     (inode_permission(inode, MAY_READ | MAY_WRITE))) &&
+	    !capable(CAP_FOWNER))
+		error = -EPERM;
+
+	if (error)
+		audit_log_link_denied("linkat", link);
+
 	return error;
 }
 #else
-static inline int
-may_follow_link(struct dentry *dentry, struct nameidata *nameidata)
+static inline int may_follow_link(struct path *link)
+{
+	return 0;
+}
+
+static inline int may_linkat(struct path *link)
 {
 	return 0;
 }
@@ -720,7 +770,7 @@ follow_link(struct path *link, struct nameidata *nd, void **p, bool sensitive)
 	nd_set_link(nd, NULL);
 
 	if (sensitive)
-		error = may_follow_link(link->dentry, nd);
+		error = may_follow_link(link);
 	if (!error)
 		error = security_inode_follow_link(link->dentry, nd);
 	if (error) {
@@ -3049,6 +3099,9 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
 	error = -EXDEV;
 	if (old_path.mnt != new_path.mnt)
 		goto out_dput;
+	error = may_linkat(&old_path);
+	if (error)
+		goto out_dput;
 	error = mnt_want_write(new_path.mnt);
 	if (error)
 		goto out_dput;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e8474d8..f3c44f7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -422,7 +422,8 @@ extern unsigned long get_max_files(void);
 extern int sysctl_nr_open;
 extern struct inodes_stat_t inodes_stat;
 extern int leases_enable, lease_break_time;
-extern int sysctl_protected_sticky_symlinks;
+extern int sysctl_protected_symlinks;
+extern int sysctl_protected_hardlinks;
 
 struct buffer_head;
 typedef int (get_block_t)(struct inode *inode, sector_t iblock,
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index b1d0cf2..73c3314 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1503,10 +1503,19 @@ static struct ctl_table fs_table[] = {
 	},
 #endif
 #endif
-#ifdef CONFIG_PROTECTED_STICKY_SYMLINKS
+#ifdef CONFIG_PROTECTED_LINKS
 	{
-		.procname	= "protected_sticky_symlinks",
-		.data		= &sysctl_protected_sticky_symlinks,
+		.procname	= "protected_symlinks",
+		.data		= &sysctl_protected_symlinks,
+		.maxlen		= sizeof(int),
+		.mode		= 0600,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
+	{
+		.procname	= "protected_hardlinks",
+		.data		= &sysctl_protected_hardlinks,
 		.maxlen		= sizeof(int),
 		.mode		= 0600,
 		.proc_handler	= proc_dointvec_minmax,
-- 
1.7.0.4
