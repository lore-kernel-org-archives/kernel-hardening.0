From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Tue, 26 Sep 2017 16:14:32 +0200
Message-Id: <1506435273-8428-2-git-send-email-s.mesoraca16@gmail.com>
In-Reply-To: <1506435273-8428-1-git-send-email-s.mesoraca16@gmail.com>
References: <1506435273-8428-1-git-send-email-s.mesoraca16@gmail.com>
Subject: [kernel-hardening] [RFC v2 1/2] Protected FIFOs and regular files
To: linux-kernel@vger.kernel.org
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, Alexander Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-fsdevel@vger.kernel.org, Salvatore Mesoraca <s.mesoraca16@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Disallows open of FIFOs or regular files not owned by the user in world
writable sticky directories, unless the owner is the same as that of
the directory or the file is opened without the O_CREAT flag.
The purpose is to make data spoofing attacks harder.
This protection can be turned on and off separately for FIFOs and regular
files via sysctl, just like the symlinks/hardlinks protection.
This patch is based on Openwall's "HARDEN_FIFO" feature by Solar
Designer.

This is a brief list of old vulnerabilities that could have been prevented
by this feature, some of them even allow for privilege escalation:
CVE-2000-1134
CVE-2007-3852
CVE-2008-0525
CVE-2009-0416
CVE-2011-4834
CVE-2015-1838
CVE-2015-7442
CVE-2016-7489

This list is not meant to be complete. It's difficult to track down
all vulnerabilities of this kind because they were often reported
without any mention of this particular attack vector.
In fact, before symlinks restrictions, fifos/regular files were not the
favorite vehicle to exploit them.

Suggested-by: Solar Designer <solar@openwall.com>
Suggested-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
---
 Documentation/sysctl/fs.txt | 36 ++++++++++++++++++++++++++
 fs/namei.c                  | 61 ++++++++++++++++++++++++++++++++++++++++++---
 include/linux/fs.h          |  2 ++
 kernel/sysctl.c             | 18 +++++++++++++
 4 files changed, 114 insertions(+), 3 deletions(-)

diff --git a/Documentation/sysctl/fs.txt b/Documentation/sysctl/fs.txt
index 35e17f7..655e261 100644
--- a/Documentation/sysctl/fs.txt
+++ b/Documentation/sysctl/fs.txt
@@ -34,7 +34,9 @@ Currently, these files are in /proc/sys/fs:
 - overflowgid
 - pipe-user-pages-hard
 - pipe-user-pages-soft
+- protected_fifos
 - protected_hardlinks
+- protected_regular
 - protected_symlinks
 - suid_dumpable
 - super-max
@@ -182,6 +184,24 @@ applied.
 
 ==============================================================
 
+protected_fifos:
+
+The intent of this protection is to avoid unintentional writes to
+an attacker-controlled FIFO, where a program expected to create a regular
+file.
+
+When set to "0", FIFOs writing is unrestricted.
+
+When set to "1" don't allow O_CREAT open on FIFOs that we don't own
+in world writable sticky directories, unless they are owned by the
+owner of the directory.
+
+When set to "2" it also apply to group writable sticky directories.
+
+This protection is based on the restrictions in Openwall.
+
+==============================================================
+
 protected_hardlinks:
 
 A long-standing class of security issues is the hardlink-based
@@ -202,6 +222,22 @@ This protection is based on the restrictions in Openwall and grsecurity.
 
 ==============================================================
 
+protected_regular:
+
+This protection is similar to protected_fifos, but it
+avoids writes to an attacker-controlled regular file, where a program
+expected to create one.
+
+When set to "0", regular files writing is unrestricted.
+
+When set to "1" don't allow O_CREAT open on regular files that we
+don't own in world writable sticky directories, unless they are
+owned by the owner of the directory.
+
+When set to "2" it also apply to group writable sticky directories.
+
+==============================================================
+
 protected_symlinks:
 
 A long-standing class of security issues is the symlink-based
diff --git a/fs/namei.c b/fs/namei.c
index c75ea03..d2b287d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -901,6 +901,8 @@ static inline void put_link(struct nameidata *nd)
 
 int sysctl_protected_symlinks __read_mostly = 0;
 int sysctl_protected_hardlinks __read_mostly = 0;
+int sysctl_protected_fifos __read_mostly;
+int sysctl_protected_regular __read_mostly;
 
 /**
  * may_follow_link - Check symlink following for unsafe situations
@@ -1014,6 +1016,54 @@ static int may_linkat(struct path *link)
 	return -EPERM;
 }
 
+/**
+ * may_create_in_sticky - Check whether an O_CREAT open in a sticky directory
+ *			  should be allowed or not, when the file already
+ *			  existed.
+ * @dir: the stick parent directory
+ * @name: the file name
+ * @inode: the inode of the file to open
+ *
+ * Block an O_CREAT open of a FIFO (or a regular file) when:
+ *   - sysctl_protected_fifos (or sysctl_protected_regular) is enabled
+ *   - the file already exists
+ *   - we are in a sticky directory
+ *   - we don't own the file
+ *   - the owner of the directory doesn't own the file
+ *   - the directory is world writable
+ * If the sysctl_protected_fifos (or sysctl_protected_regular) is set to 2
+ * the directory doesn't have to be world writable: being group writable will
+ * be enough.
+ *
+ * Returns 0 if the open is allowed, -ve on error.
+ */
+static int may_create_in_sticky(struct dentry * const dir,
+				const unsigned char * const name,
+				struct inode * const inode)
+{
+	if ((!sysctl_protected_fifos && S_ISFIFO(inode->i_mode)) ||
+	    (!sysctl_protected_regular && S_ISREG(inode->i_mode)) ||
+	    likely(!(dir->d_inode->i_mode & S_ISVTX)) ||
+	    uid_eq(inode->i_uid, dir->d_inode->i_uid) ||
+	    uid_eq(current_fsuid(), inode->i_uid))
+		return 0;
+
+	if (likely(dir->d_inode->i_mode & 0002) ||
+	    (dir->d_inode->i_mode & 0020 &&
+	     ((sysctl_protected_fifos >= 2 && S_ISFIFO(inode->i_mode)) ||
+	      (sysctl_protected_regular >= 2 && S_ISREG(inode->i_mode))))) {
+		pr_notice_ratelimited("denied writing in '%s' of %d.%d in a sticky directory by UID %d, EUID %d, process %s:%d.\n",
+				      name,
+				      from_kuid(&init_user_ns, inode->i_uid),
+				      from_kgid(&init_user_ns, inode->i_gid),
+				      from_kuid(&init_user_ns, current_uid()),
+				      from_kuid(&init_user_ns, current_euid()),
+				      current->comm, current->pid);
+		return -EACCES;
+	}
+	return 0;
+}
+
 static __always_inline
 const char *get_link(struct nameidata *nd)
 {
@@ -3364,9 +3414,14 @@ static int do_last(struct nameidata *nd,
 	if (error)
 		return error;
 	audit_inode(nd->name, nd->path.dentry, 0);
-	error = -EISDIR;
-	if ((open_flag & O_CREAT) && d_is_dir(nd->path.dentry))
-		goto out;
+	if (open_flag & O_CREAT) {
+		error = -EISDIR;
+		if (d_is_dir(nd->path.dentry))
+			goto out;
+		error = may_create_in_sticky(dir, nd->last.name, inode);
+		if (unlikely(error))
+			goto out;
+	}
 	error = -ENOTDIR;
 	if ((nd->flags & LOOKUP_DIRECTORY) && !d_can_lookup(nd->path.dentry))
 		goto out;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 339e737..14bb497 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -71,6 +71,8 @@
 extern int leases_enable, lease_break_time;
 extern int sysctl_protected_symlinks;
 extern int sysctl_protected_hardlinks;
+extern int sysctl_protected_fifos;
+extern int sysctl_protected_regular;
 
 typedef __kernel_rwf_t rwf_t;
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 6648fbb..6b127e2 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1807,6 +1807,24 @@ static int sysrq_sysctl_handler(struct ctl_table *table, int write,
 		.extra2		= &one,
 	},
 	{
+		.procname	= "protected_fifos",
+		.data		= &sysctl_protected_fifos,
+		.maxlen		= sizeof(int),
+		.mode		= 0600,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &two,
+	},
+	{
+		.procname	= "protected_regular",
+		.data		= &sysctl_protected_regular,
+		.maxlen		= sizeof(int),
+		.mode		= 0600,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &two,
+	},
+	{
 		.procname	= "suid_dumpable",
 		.data		= &suid_dumpable,
 		.maxlen		= sizeof(int),
-- 
1.9.1
