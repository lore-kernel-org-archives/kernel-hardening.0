Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 7 Jan 2012 10:55:48 -0800
From: Kees Cook <keescook@chromium.org>
Message-ID: <20120107185548.GA30748@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] [PATCH v2012.2] fs: symlink restrictions on sticky directories
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Rik van Riel <riel@redhat.com>, Federica Teodori <federica.teodori@googlemail.com>, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>, Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Eric Paris <eparis@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>, Dan Rosenberg <drosenberg@vsecurity.com>, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

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

This patch is based on the patch in Openwall and grsecurity, along with
suggestions from Al Viro. I have added a sysctl to enable the protected
behavior, documentation, and an audit notification.

Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
---
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
 Documentation/sysctl/fs.txt |   21 ++++++++++
 fs/Kconfig                  |   34 ++++++++++++++++
 fs/namei.c                  |   91 ++++++++++++++++++++++++++++++++++++++++---
 kernel/sysctl.c             |   14 +++++++
 4 files changed, 154 insertions(+), 6 deletions(-)

diff --git a/Documentation/sysctl/fs.txt b/Documentation/sysctl/fs.txt
index 88fd7f5..4b47cd5 100644
--- a/Documentation/sysctl/fs.txt
+++ b/Documentation/sysctl/fs.txt
@@ -32,6 +32,7 @@ Currently, these files are in /proc/sys/fs:
 - nr_open
 - overflowuid
 - overflowgid
+- protected_sticky_symlinks
 - suid_dumpable
 - super-max
 - super-nr
@@ -157,6 +158,26 @@ The default is 65534.
 
 ==============================================================
 
+protected_sticky_symlinks:
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
index 5f4c45d..61f0f0f 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -277,4 +277,38 @@ endif
 source "fs/nls/Kconfig"
 source "fs/dlm/Kconfig"
 
+config PROTECTED_STICKY_SYMLINKS
+	bool "Evaluate vulnerable symlink conditions"
+	default y
+	help
+	  A long-standing class of security issues is the symlink-based
+	  time-of-check-time-of-use race, most commonly seen in
+	  world-writable directories like /tmp. The common method of
+	  exploitation of this flaw is to cross privilege boundaries
+	  when following a given symlink (i.e. a root process follows
+	  a malicious symlink belonging to another user).
+
+	  Enabling this adds the logic to examine these dangerous symlink
+	  conditions. Whether or not the dangerous symlink situations are
+	  allowed is controlled by PROTECTED_STICKY_SYMLINKS_ENABLED.
+
+config PROTECTED_STICKY_SYMLINKS_ENABLED
+	depends on PROTECTED_STICKY_SYMLINKS
+	bool "Disallow symlink following in sticky world-writable dirs"
+	default y
+	help
+	  Solve ToCToU symlink race vulnerablities by permitting symlinks
+	  to be followed only when outside a sticky world-writable directory,
+	  or when the uid of the symlink and follower match, or when the
+	  directory and symlink owners match.
+
+	  When PROC_SYSCTL is enabled, this setting can also be controlled
+	  via /proc/sys/kernel/protected_sticky_symlinks.
+
+config PROTECTED_STICKY_SYMLINKS_ENABLED_SYSCTL
+	depends on PROTECTED_STICKY_SYMLINKS
+	int
+	default "1" if PROTECTED_STICKY_SYMLINKS_ENABLED
+	default "0"
+
 endmenu
diff --git a/fs/namei.c b/fs/namei.c
index 5008f01..fc11891 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -624,10 +624,84 @@ static inline void put_link(struct nameidata *nd, struct path *link, void *cooki
 	path_put(link);
 }
 
+#ifdef CONFIG_PROTECTED_STICKY_SYMLINKS
+int sysctl_protected_sticky_symlinks __read_mostly =
+	CONFIG_PROTECTED_STICKY_SYMLINKS_ENABLED_SYSCTL;
+
+/**
+ * may_follow_link - Check symlink following for unsafe situations
+ * @dentry: The inode/dentry of the symlink
+ * @nameidata: The path data of the symlink
+ *
+ * In the case of the protected_sticky_symlinks sysctl being enabled,
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
+static inline int
+may_follow_link(struct dentry *dentry, struct nameidata *nameidata)
+{
+	int error = 0;
+	const struct inode *parent;
+	const struct inode *inode;
+	const struct cred *cred;
+
+	if (!sysctl_protected_sticky_symlinks)
+		return 0;
+
+	/* Allowed if owner and follower match. */
+	cred = current_cred();
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
+#ifdef CONFIG_AUDIT
+	if (error) {
+		struct audit_buffer *ab;
+
+		ab = audit_log_start(current->audit_context,
+				     GFP_KERNEL, AUDIT_AVC);
+		audit_log_format(ab, "op=follow_link action=denied");
+		audit_log_format(ab, " pid=%d comm=", current->pid);
+		audit_log_untrustedstring(ab, current->comm);
+		audit_log_d_path(ab, " path=", &nameidata->path);
+		audit_log_format(ab, " name=");
+		audit_log_untrustedstring(ab, dentry->d_name.name);
+		audit_log_format(ab, " dev=");
+		audit_log_untrustedstring(ab, inode->i_sb->s_id);
+		audit_log_format(ab, " ino=%lu", inode->i_ino);
+		audit_log_end(ab);
+	}
+#endif
+	return error;
+}
+#else
+static inline int
+may_follow_link(struct dentry *dentry, struct nameidata *nameidata)
+{
+	return 0;
+}
+#endif
+
 static __always_inline int
-follow_link(struct path *link, struct nameidata *nd, void **p)
+follow_link(struct path *link, struct nameidata *nd, void **p, bool sensitive)
 {
-	int error;
+	int error = 0;
 	struct dentry *dentry = link->dentry;
 
 	BUG_ON(nd->flags & LOOKUP_RCU);
@@ -646,7 +720,10 @@ follow_link(struct path *link, struct nameidata *nd, void **p)
 	touch_atime(link->mnt, dentry);
 	nd_set_link(nd, NULL);
 
-	error = security_inode_follow_link(link->dentry, nd);
+	if (sensitive)
+		error = may_follow_link(link->dentry, nd);
+	if (!error)
+		error = security_inode_follow_link(link->dentry, nd);
 	if (error) {
 		*p = ERR_PTR(error); /* no ->put_link(), please */
 		path_put(&nd->path);
@@ -1339,7 +1416,7 @@ static inline int nested_symlink(struct path *path, struct nameidata *nd)
 		struct path link = *path;
 		void *cookie;
 
-		res = follow_link(&link, nd, &cookie);
+		res = follow_link(&link, nd, &cookie, false);
 		if (!res)
 			res = walk_component(nd, path, &nd->last,
 					     nd->last_type, LOOKUP_FOLLOW);
@@ -1612,7 +1689,8 @@ static int path_lookupat(int dfd, const char *name,
 			void *cookie;
 			struct path link = path;
 			nd->flags |= LOOKUP_PARENT;
-			err = follow_link(&link, nd, &cookie);
+
+			err = follow_link(&link, nd, &cookie, true);
 			if (!err)
 				err = lookup_last(nd, &path);
 			put_link(nd, &link, cookie);
@@ -2324,7 +2402,8 @@ static struct file *path_openat(int dfd, const char *pathname,
 		}
 		nd->flags |= LOOKUP_PARENT;
 		nd->flags &= ~(LOOKUP_OPEN|LOOKUP_CREATE|LOOKUP_EXCL);
-		error = follow_link(&link, nd, &cookie);
+
+		error = follow_link(&link, nd, &cookie, true);
 		if (unlikely(error))
 			filp = ERR_PTR(error);
 		else
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index ae27196..62b41ab 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -109,6 +109,9 @@ extern int sysctl_nr_trim_pages;
 #ifdef CONFIG_BLOCK
 extern int blk_iopoll_enabled;
 #endif
+#ifdef CONFIG_PROTECTED_STICKY_SYMLINKS
+extern int sysctl_protected_sticky_symlinks;
+#endif
 
 /* Constants used for minimum and  maximum */
 #ifdef CONFIG_LOCKUP_DETECTOR
@@ -1494,6 +1497,17 @@ static struct ctl_table fs_table[] = {
 	},
 #endif
 #endif
+#ifdef CONFIG_PROTECTED_STICKY_SYMLINKS
+	{
+		.procname	= "protected_sticky_symlinks",
+		.data		= &sysctl_protected_sticky_symlinks,
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
1.7.4.1


-- 
Kees Cook
ChromeOS Security
