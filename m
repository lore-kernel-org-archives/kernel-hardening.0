Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 18 Nov 2011 15:22:08 -0800
From: Kees Cook <keescook@chromium.org>
Message-ID: <20111118232208.GA19000@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] [RFC] fs: symlink restrictions on sticky directories
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

(In case symlink restrictions aren't going to live in Yama, here's a
version in core VFS based on some feed-back from Al Viro.)

A long-standing class of security issues is the symlink-based
time-of-check-time-of-use race, most commonly seen in world-writable
directories like /tmp. The common method of exploitation of this flaw
is to cross privilege boundaries when following a given symlink (i.e. a
root process follows a symlink belonging to another user).  For a likely
incomplete list of hundreds of examples across the years, please see:
http://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=/tmp

The solution is to permit symlinks to only be followed when outside a sticky
world-writable directory, or when the uid of the symlink and follower match,
or when the directory owner matches the symlink's owner.

Some pointers to the history of earlier discussion that I could find:

 1996 Aug, Zygo Blaxell
  http://marc.info/?l=bugtraq&m=87602167419830&w=2
 1996 Oct, Andrew Tridgell
  http://lkml.indiana.edu/hypermail/linux/kernel/9610.2/0086.html
 1997 Dec, Albert D Cahalan
  http://lkml.org/lkml/1997/12/16/4
 2005 Feb, Lorenzo Hernández García-Hierro
  http://lkml.indiana.edu/hypermail/linux/kernel/0502.0/1896.html

Past objections and rebuttals could be summarized as:

 - Violates POSIX.
   - POSIX didn't consider this situation and it's not useful to follow
     a broken specification at the cost of security.
 - Might break unknown applications that use this feature.
   - Applications that break because of the change are easy to spot and
     fix. Applications that are vulnerable to symlink ToCToU by not having
     the change aren't.
 - Applications should just use mkstemp() or O_CREATE|O_EXCL.
   - True, but applications are not perfect, and new software is written
     all the time that makes these mistakes; blocking this flaw at the
     kernel is a single solution to the entire class of vulnerability.

This patch is based on the patch in Openwall and grsecurity.  I have
added a sysctl to enable the protected behavior, documentation, and a
ratelimited warning.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 Documentation/sysctl/fs.txt |   21 ++++++++++++
 fs/Kconfig                  |   15 ++++++++
 fs/namei.c                  |   76 +++++++++++++++++++++++++++++++++++++++---
 kernel/sysctl.c             |   10 ++++++
 4 files changed, 116 insertions(+), 6 deletions(-)

diff --git a/Documentation/sysctl/fs.txt b/Documentation/sysctl/fs.txt
index 88fd7f5..939621b 100644
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
+root process follows a symlink belonging to another user).  For a likely
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
index 5f4c45d..74b9e49 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -278,3 +278,18 @@ source "fs/nls/Kconfig"
 source "fs/dlm/Kconfig"
 
 endmenu
+
+config PROTECTED_STICKY_SYMLINKS
+	bool "Protect symlink following in sticky world-writable directories"
+	help
+	  A long-standing class of security issues is the symlink-based
+	  time-of-check-time-of-use race, most commonly seen in
+	  world-writable directories like /tmp. The common method of
+	  exploitation of this flaw is to cross privilege boundaries
+	  when following a given symlink (i.e. a root process follows
+	  a malicious symlink belonging to another user).
+
+	  Enabling this solves the problem by permitting symlinks to only
+	  be followed when outside a sticky world-writable directory,
+	  or when the uid of the symlink and follower match, or when
+	  the directory and symlink owners match.
diff --git a/fs/namei.c b/fs/namei.c
index 5008f01..fc206f4 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -33,6 +33,7 @@
 #include <linux/device_cgroup.h>
 #include <linux/fs_struct.h>
 #include <linux/posix_acl.h>
+#include <linux/ratelimit.h>
 #include <asm/uaccess.h>
 
 #include "internal.h"
@@ -624,10 +625,68 @@ static inline void put_link(struct nameidata *nd, struct path *link, void *cooki
 	path_put(link);
 }
 
+#ifdef CONFIG_PROTECTED_STICKY_SYMLINKS
+int protected_sticky_symlinks = 1;
+#else
+int protected_sticky_symlinks;
+#endif
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
+ * It will permit symlinks to only be followed when outside a sticky
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
+	if (!protected_sticky_symlinks)
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
+	if (error) {
+		char name[sizeof(current->comm)];
+		printk_ratelimited(KERN_NOTICE "non-matching-uid symlink "
+			"following attempted in sticky world-writable "
+			"directory by %s (fsuid %d)\n",
+			get_task_comm(name, current), cred->fsuid);
+	}
+	return error;
+}
+
 static __always_inline int
-follow_link(struct path *link, struct nameidata *nd, void **p)
+follow_link(struct path *link, struct nameidata *nd, void **p, bool sensitive)
 {
-	int error;
+	int error = 0;
 	struct dentry *dentry = link->dentry;
 
 	BUG_ON(nd->flags & LOOKUP_RCU);
@@ -646,7 +705,10 @@ follow_link(struct path *link, struct nameidata *nd, void **p)
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
@@ -1339,7 +1401,7 @@ static inline int nested_symlink(struct path *path, struct nameidata *nd)
 		struct path link = *path;
 		void *cookie;
 
-		res = follow_link(&link, nd, &cookie);
+		res = follow_link(&link, nd, &cookie, 0);
 		if (!res)
 			res = walk_component(nd, path, &nd->last,
 					     nd->last_type, LOOKUP_FOLLOW);
@@ -1612,7 +1674,8 @@ static int path_lookupat(int dfd, const char *name,
 			void *cookie;
 			struct path link = path;
 			nd->flags |= LOOKUP_PARENT;
-			err = follow_link(&link, nd, &cookie);
+
+			err = follow_link(&link, nd, &cookie, 1);
 			if (!err)
 				err = lookup_last(nd, &path);
 			put_link(nd, &link, cookie);
@@ -2324,7 +2387,8 @@ static struct file *path_openat(int dfd, const char *pathname,
 		}
 		nd->flags |= LOOKUP_PARENT;
 		nd->flags &= ~(LOOKUP_OPEN|LOOKUP_CREATE|LOOKUP_EXCL);
-		error = follow_link(&link, nd, &cookie);
+
+		error = follow_link(&link, nd, &cookie, 1);
 		if (unlikely(error))
 			filp = ERR_PTR(error);
 		else
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index ae27196..cc2c5f9 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -92,6 +92,7 @@ extern int sysctl_overcommit_memory;
 extern int sysctl_overcommit_ratio;
 extern int max_threads;
 extern int core_uses_pid;
+extern int protected_sticky_symlinks;
 extern int suid_dumpable;
 extern char core_pattern[];
 extern unsigned int core_pipe_limit;
@@ -1495,6 +1496,15 @@ static struct ctl_table fs_table[] = {
 #endif
 #endif
 	{
+		.procname	= "protected_sticky_symlinks",
+		.data		= &protected_sticky_symlinks,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
+	{
 		.procname	= "suid_dumpable",
 		.data		= &suid_dumpable,
 		.maxlen		= sizeof(int),
-- 
1.7.0.4
