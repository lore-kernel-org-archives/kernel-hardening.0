Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Mon, 25 Jun 2012 14:05:26 -0700
Message-Id: <1340658327-2932-2-git-send-email-keescook@chromium.org>
In-Reply-To: <1340658327-2932-1-git-send-email-keescook@chromium.org>
References: <1340658327-2932-1-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] [PATCH 1/2] fs: add link restrictions
To: linux-kernel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, Eric Paris <eparis@redhat.com>, Matthew Wilcox <matthew@wil.cx>, Doug Ledford <dledford@redhat.com>, Joe Korty <joe.korty@ccur.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>, James Morris <james.l.morris@oracle.com>, linux-doc@vger.kernel.org, Dan Rosenberg <drosenberg@vsecurity.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This adds symlink and hardlink restrictions to the Linux VFS.

Symlinks:

A long-standing class of security issues is the symlink-based
time-of-check-time-of-use race, most commonly seen in world-writable
directories like /tmp. The common method of exploitation of this flaw
is to cross privilege boundaries when following a given symlink (i.e. a
root process follows a symlink belonging to another user). For a likely
incomplete list of hundreds of examples across the years, please see:
http://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=/tmp

The solution is to permit symlinks to only be followed when outside
a sticky world-writable directory, or when the uid of the symlink and
follower match, or when the directory owner matches the symlink's owner.

Some pointers to the history of earlier discussion that I could find:

 1996 Aug, Zygo Blaxell
  http://marc.info/?l=bugtraq&m=87602167419830&w=2
 1996 Oct, Andrew Tridgell
  http://lkml.indiana.edu/hypermail/linux/kernel/9610.2/0086.html
 1997 Dec, Albert D Cahalan
  http://lkml.org/lkml/1997/12/16/4
 2005 Feb, Lorenzo Hernández García-Hierro
  http://lkml.indiana.edu/hypermail/linux/kernel/0502.0/1896.html
 2010 May, Kees Cook
  https://lkml.org/lkml/2010/5/30/144

Past objections and rebuttals could be summarized as:

 - Violates POSIX.
   - POSIX didn't consider this situation and it's not useful to follow
     a broken specification at the cost of security.
 - Might break unknown applications that use this feature.
   - Applications that break because of the change are easy to spot and
     fix. Applications that are vulnerable to symlink ToCToU by not having
     the change aren't. Additionally, no applications have yet been found
     that rely on this behavior.
 - Applications should just use mkstemp() or O_CREATE|O_EXCL.
   - True, but applications are not perfect, and new software is written
     all the time that makes these mistakes; blocking this flaw at the
     kernel is a single solution to the entire class of vulnerability.
 - This should live in the core VFS.
   - This should live in an LSM. (https://lkml.org/lkml/2010/5/31/135)
 - This should live in an LSM.
   - This should live in the core VFS. (https://lkml.org/lkml/2010/8/2/188)

Hardlinks:

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

[1] http://pubs.opengroup.org/onlinepubs/9699919799/functions/linkat.html
[2] http://anonscm.debian.org/gitweb/?p=collab-maint/at.git;a=commitdiff;h=f4114656c3a6c6f6070e315ffdf940a49eda3279

This patch is based on the patches in Openwall and grsecurity, along with
suggestions from Al Viro. I have added a sysctl to enable the protected
behavior, and documentation.

Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

---
v2012.4:
 - split audit functions into a separate patch, suggested by Eric Paris.
v2012.3:
 While this code has been living in -mm and linux-next for 2 releases,
 this is a small rework based on feedback from Al Viro:
 - Moved audit functions into audit.c.
 - Added tests directly to path_openat/path_lookupat.
 - Merged with hardlink restriction patch to make things more sensible.
v2012.2:
 - Change sysctl mode to 0600, suggested by Ingo Molnar.
 - Rework CONFIG logic to split code from default behavior.
 - Renamed sysctl to have a "sysctl_" prefix, suggested by Andrew Morton.
 - Use "true/false" instead of "1/0" for bool arg, thanks to Andrew Morton.
 - Do not trust s_id to be safe to print, suggested by Andrew Morton.
v2012.1:
 - Use GFP_KERNEL for audit log allocation, thanks to Ingo Molnar.
v2011.3:
 - Add pid/comm back to logging.
v2011.2:
 - Updated documentation, thanks to Randy Dunlap.
 - Switched Kconfig default to "y", added __read_mostly to sysctl,
   thanks to Ingo Molnar.
 - Switched to audit logging to gain safe path and name reporting when
   hitting the restriction.
v2011.1:
 - back from hiatus
---
 Documentation/sysctl/fs.txt |   42 +++++++++++++
 fs/Kconfig                  |   60 ++++++++++++++++++
 fs/namei.c                  |  139 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h          |    2 +
 kernel/sysctl.c             |   20 ++++++
 5 files changed, 263 insertions(+), 0 deletions(-)

diff --git a/Documentation/sysctl/fs.txt b/Documentation/sysctl/fs.txt
index 13d6166..d4a372e 100644
--- a/Documentation/sysctl/fs.txt
+++ b/Documentation/sysctl/fs.txt
@@ -32,6 +32,8 @@ Currently, these files are in /proc/sys/fs:
 - nr_open
 - overflowuid
 - overflowgid
+- protected_hardlinks
+- protected_symlinks
 - suid_dumpable
 - super-max
 - super-nr
@@ -157,6 +159,46 @@ The default is 65534.
 
 ==============================================================
 
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
+
+A long-standing class of security issues is the symlink-based
+time-of-check-time-of-use race, most commonly seen in world-writable
+directories like /tmp. The common method of exploitation of this flaw
+is to cross privilege boundaries when following a given symlink (i.e. a
+root process follows a symlink belonging to another user). For a likely
+incomplete list of hundreds of examples across the years, please see:
+http://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=/tmp
+
+When set to "0", symlink following behavior is unrestricted.
+
+When set to "1" symlinks are permitted to be followed only when outside
+a sticky world-writable directory, or when the uid of the symlink and
+follower match, or when the directory owner matches the symlink's owner.
+
+This protection is based on the restrictions in Openwall and grsecurity.
+
+==============================================================
+
 suid_dumpable:
 
 This value can be used to query and set the core dump mode for setuid
diff --git a/fs/Kconfig b/fs/Kconfig
index f95ae3a..ba8974e 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -276,4 +276,64 @@ endif # NETWORK_FILESYSTEMS
 source "fs/nls/Kconfig"
 source "fs/dlm/Kconfig"
 
+config PROTECTED_LINKS
+	bool "Evaluate vulnerable link conditions"
+	default y
+	help
+	  A long-standing class of security issues is the link-based
+	  time-of-check-time-of-use race, most commonly seen in
+	  world-writable directories like /tmp. The common method of
+	  exploitation of this flaw is to cross privilege boundaries
+	  when following a given link (i.e. a root process follows
+	  a malicious symlink belonging to another user, or a hardlink
+	  created to a root-owned file).
+
+	  Enabling this adds the logic to examine these dangerous link
+	  conditions. Whether or not the dangerous link situations are
+	  allowed is controlled by PROTECTED_HARDLINKS_ENABLED and
+	  PROTECTED_SYMLINKS_ENABLED.
+
+config PROTECTED_SYMLINKS
+	depends on PROTECTED_LINKS
+	bool "Disallow symlink following in sticky world-writable dirs"
+	default y
+	help
+	  Solve ToCToU symlink race vulnerabilities by permitting symlinks
+	  to be followed only when outside a sticky world-writable directory,
+	  or when the uid of the symlink and follower match, or when the
+	  directory and symlink owners match.
+
+	  When PROC_SYSCTL is enabled, this setting can also be controlled
+	  via /proc/sys/kernel/protected_symlinks.
+
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
+	int
+	default "1" if PROTECTED_HARDLINKS
+	default "0"
+
 endmenu
diff --git a/fs/namei.c b/fs/namei.c
index 7d69419..71bb13c 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -610,6 +610,136 @@ static inline void put_link(struct nameidata *nd, struct path *link, void *cooki
 	path_put(link);
 }
 
+#ifdef CONFIG_PROTECTED_LINKS
+int sysctl_protected_symlinks __read_mostly =
+	CONFIG_PROTECTED_SYMLINKS_SYSCTL;
+int sysctl_protected_hardlinks __read_mostly =
+	CONFIG_PROTECTED_HARDLINKS_SYSCTL;
+
+/**
+ * may_follow_link - Check symlink following for unsafe situations
+ * @link: The path of the symlink
+ *
+ * In the case of the sysctl_protected_symlinks sysctl being enabled,
+ * CAP_DAC_OVERRIDE needs to be specifically ignored if the symlink is
+ * in a sticky world-writable directory. This is to protect privileged
+ * processes from failing races against path names that may change out
+ * from under them by way of other users creating malicious symlinks.
+ * It will permit symlinks to be followed only when outside a sticky
+ * world-writable directory, or when the uid of the symlink and follower
+ * match, or when the directory owner matches the symlink's owner.
+ *
+ * Returns 0 if following the symlink is allowed, -ve on error.
+ */
+static inline int may_follow_link(struct path *link)
+{
+	int error = 0;
+	const struct inode *parent;
+	const struct inode *inode;
+	const struct cred *cred;
+	struct dentry *dentry;
+
+	if (!sysctl_protected_symlinks)
+		return 0;
+
+	/* Allowed if owner and follower match. */
+	cred = current_cred();
+	dentry = link->dentry;
+	inode = dentry->d_inode;
+	if (cred->fsuid == inode->i_uid)
+		return 0;
+
+	/* Check parent directory mode and owner. */
+	spin_lock(&dentry->d_lock);
+	parent = dentry->d_parent->d_inode;
+	if ((parent->i_mode & (S_ISVTX|S_IWOTH)) == (S_ISVTX|S_IWOTH) &&
+	    parent->i_uid != inode->i_uid) {
+		error = -EACCES;
+	}
+	spin_unlock(&dentry->d_lock);
+
+	return error;
+}
+
+/**
+ * safe_hardlink_source - Check for safe hardlink conditions
+ * @inode: the source inode to hardlink from
+ *
+ * Return false if at least one of the following conditions:
+ *    - inode is not a regular file
+ *    - inode is setuid
+ *    - inode is setgid and group-exec
+ *    - access failure for read and write
+ *
+ * Otherwise returns true.
+ */
+static bool safe_hardlink_source(struct inode *inode)
+{
+	mode_t mode = inode->i_mode;
+
+	/* Special files should not get pinned to the filesystem. */
+	if (!S_ISREG(mode))
+		return false;
+
+	/* Setuid files should not get pinned to the filesystem. */
+	if (mode & S_ISUID)
+		return false;
+
+	/* Executable setgid files should not get pinned to the filesystem. */
+	if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP))
+		return false;
+
+	/* Hardlinking to unreadable or unwritable sources is dangerous. */
+	if (inode_permission(inode, MAY_READ | MAY_WRITE))
+		return false;
+
+	return true;
+}
+
+/**
+ * may_linkat - Check permissions for creating a hardlink
+ * @link: the source to hardlink from
+ *
+ * Block hardlink when all of:
+ *  - sysctl_protected_hardlinks enabled
+ *  - fsuid does not match inode
+ *  - hardlink source is unsafe (see safe_hardlink_source() above)
+ *  - not CAP_FOWNER
+ *
+ * Returns 0 if successful, -ve on error.
+ */
+static int may_linkat(struct path *link)
+{
+	const struct cred *cred;
+	struct inode *inode;
+
+	if (!sysctl_protected_hardlinks)
+		return 0;
+
+	cred = current_cred();
+	inode = link->dentry->d_inode;
+
+	/* Source inode owner (or CAP_FOWNER) can hardlink all they like,
+	 * otherwise, it must be a safe source.
+	 */
+	if (cred->fsuid == inode->i_uid || safe_hardlink_source(inode) ||
+	    capable(CAP_FOWNER))
+		return 0;
+
+	return -EPERM;
+}
+#else
+static inline int may_follow_link(struct path *link)
+{
+	return 0;
+}
+
+static inline int may_linkat(struct path *link)
+{
+	return 0;
+}
+#endif
+
 static __always_inline int
 follow_link(struct path *link, struct nameidata *nd, void **p)
 {
@@ -1775,6 +1905,9 @@ static int path_lookupat(int dfd, const char *name,
 		while (err > 0) {
 			void *cookie;
 			struct path link = path;
+			err = may_follow_link(&link);
+			if (unlikely(err))
+				break;
 			nd->flags |= LOOKUP_PARENT;
 			err = follow_link(&link, nd, &cookie);
 			if (!err)
@@ -2471,6 +2604,9 @@ static struct file *path_openat(int dfd, const char *pathname,
 			filp = ERR_PTR(-ELOOP);
 			break;
 		}
+		error = may_follow_link(&link);
+		if (unlikely(error))
+			break;
 		nd->flags |= LOOKUP_PARENT;
 		nd->flags &= ~(LOOKUP_OPEN|LOOKUP_CREATE|LOOKUP_EXCL);
 		error = follow_link(&link, nd, &cookie);
@@ -3130,6 +3266,9 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
 	error = -EXDEV;
 	if (old_path.mnt != new_path.mnt)
 		goto out_dput;
+	error = may_linkat(&old_path);
+	if (unlikely(error))
+		goto out_dput;
 	error = mnt_want_write(new_path.mnt);
 	if (error)
 		goto out_dput;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 17fd887..b0a6d44 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -437,6 +437,8 @@ extern unsigned long get_max_files(void);
 extern int sysctl_nr_open;
 extern struct inodes_stat_t inodes_stat;
 extern int leases_enable, lease_break_time;
+extern int sysctl_protected_symlinks;
+extern int sysctl_protected_hardlinks;
 
 struct buffer_head;
 typedef int (get_block_t)(struct inode *inode, sector_t iblock,
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 4ab1187..ba133ec 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1493,6 +1493,26 @@ static struct ctl_table fs_table[] = {
 	},
 #endif
 #endif
+#ifdef CONFIG_PROTECTED_LINKS
+	{
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
+		.maxlen		= sizeof(int),
+		.mode		= 0600,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
+#endif
 	{
 		.procname	= "suid_dumpable",
 		.data		= &suid_dumpable,
-- 
1.7.0.4
