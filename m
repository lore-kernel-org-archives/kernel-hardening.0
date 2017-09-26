From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Tue, 26 Sep 2017 16:14:33 +0200
Message-Id: <1506435273-8428-3-git-send-email-s.mesoraca16@gmail.com>
In-Reply-To: <1506435273-8428-1-git-send-email-s.mesoraca16@gmail.com>
References: <1506435273-8428-1-git-send-email-s.mesoraca16@gmail.com>
Subject: [kernel-hardening] [RFC v2 2/2] Protected O_CREAT open in sticky directory
To: linux-kernel@vger.kernel.org
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, Alexander Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-fsdevel@vger.kernel.org, Salvatore Mesoraca <s.mesoraca16@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Disallows O_CREAT open missing the O_EXCL flag, in world or
group writable directories, even if the file doesn't exist yet.
With few exceptions (e.g. shared lock files based on flock())
if a program tries to open a file with the O_CREAT flag and
without the O_EXCL, it probably has a bug.
This feature allows to detect and potentially block programs that
act this way and can be used to find vulnerabilities (like those
prevented by patch #1) and to do policy enforcement.

Suggested-by: Solar Designer <solar@openwall.com>
Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
---
I wasn't able to come up with a better name than
"protected_sticky_child_create" so I'm open to suggestion
for more decent names.
---
 Documentation/sysctl/fs.txt | 30 ++++++++++++++++++++++++
 fs/namei.c                  | 57 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h          |  1 +
 kernel/sysctl.c             |  9 +++++++
 4 files changed, 97 insertions(+)

diff --git a/Documentation/sysctl/fs.txt b/Documentation/sysctl/fs.txt
index 655e261..647aee5 100644
--- a/Documentation/sysctl/fs.txt
+++ b/Documentation/sysctl/fs.txt
@@ -37,6 +37,7 @@ Currently, these files are in /proc/sys/fs:
 - protected_fifos
 - protected_hardlinks
 - protected_regular
+- protected_sticky_child_create
 - protected_symlinks
 - suid_dumpable
 - super-max
@@ -238,6 +239,35 @@ When set to "2" it also apply to group writable sticky directories.
 
 ==============================================================
 
+protected_sticky_child_create:
+
+An O_CREAT open missing the O_EXCL flag in a sticky directory is,
+often, a bug or a synthom of the fact that the program is not
+using appropriate procedures to access sticky directories.
+This protection allow to detect and possibly block these unsafe
+open invocations, even if the files doen't exist yet.
+Though should be noted that, sometimes, it's OK to open a file
+with O_CREAT and without O_EXCL (e.g. shared lock files based
+on flock()), for this reason values above 2 should be set
+with care.
+
+When set to "0" the protection is disabled.
+
+When set to "1", notify about O_CREAT open missing the O_EXCL flag
+in world writable sticky directories.
+
+When set to "2", notify about O_CREAT open missing the O_EXCL flag
+in group writable sticky directories.
+
+When set to "3", block O_CREAT open missing the O_EXCL flag
+in world writable sticky directories and notify (but don't block)
+in group writable sticky directories.
+
+When set to "4", block O_CREAT open missing the O_EXCL flag
+in world writable and group writable sticky directories.
+
+==============================================================
+
 protected_symlinks:
 
 A long-standing class of security issues is the symlink-based
diff --git a/fs/namei.c b/fs/namei.c
index d2b287d..5c6c0eb 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -903,6 +903,7 @@ static inline void put_link(struct nameidata *nd)
 int sysctl_protected_hardlinks __read_mostly = 0;
 int sysctl_protected_fifos __read_mostly;
 int sysctl_protected_regular __read_mostly;
+int sysctl_protected_sticky_child_create __read_mostly;
 
 /**
  * may_follow_link - Check symlink following for unsafe situations
@@ -1064,6 +1065,54 @@ static int may_create_in_sticky(struct dentry * const dir,
 	return 0;
 }
 
+/**
+ * may_create_no_excl - Detect and possibly block unsafe O_CREAT open
+ *			without O_EXCL.
+ * @dir: the stick parent directory
+ * @name: the file name
+ * @inode: the inode of the file to open (can be NULL to skip uid checks)
+ *
+ * When sysctl_protected_sticky_child_create is set to "0" the
+ * protection is disabled.
+ * When it's set to "1", notify about O_CREAT open missing the O_EXCL flag
+ * in world writable sticky directories.
+ * When it's set to "2", notify about O_CREAT open missing the O_EXCL flag
+ * in group writable sticky directories.
+ * When it's set to "3", block O_CREAT open missing the O_EXCL flag
+ * in world writable sticky directories and notify (but don't block)
+ * in group writable sticky directories.
+ * When it's set to "4", block O_CREAT open missing the O_EXCL flag
+ * in world writable and group writable sticky directories.
+ *
+ * Returns 0 if the open is allowed, -ve on error.
+ */
+static int may_create_no_excl(struct dentry * const dir,
+			      const unsigned char * const name,
+			      struct inode * const inode)
+{
+	umode_t mode = dir->d_inode->i_mode;
+
+	if (likely(!(mode & S_ISVTX)))
+		return 0;
+	if (inode && (uid_eq(inode->i_uid, dir->d_inode->i_uid) ||
+		      uid_eq(current_fsuid(), inode->i_uid)))
+		return 0;
+
+	if ((sysctl_protected_sticky_child_create && likely(mode & 0002)) ||
+	    (sysctl_protected_sticky_child_create >= 2 && mode & 0020)) {
+		pr_notice_ratelimited("unsafe O_CREAT open (missing O_EXCL) of '%s' in a sticky directory by UID %d, EUID %d, process %s:%d.\n",
+				      name,
+				      from_kuid(&init_user_ns, current_uid()),
+				      from_kuid(&init_user_ns, current_euid()),
+				      current->comm, current->pid);
+		if (sysctl_protected_sticky_child_create >= 4 ||
+		    (sysctl_protected_sticky_child_create == 3 &&
+		     likely(mode & 0002)))
+			return -EACCES;
+	}
+	return 0;
+}
+
 static __always_inline
 const char *get_link(struct nameidata *nd)
 {
@@ -3255,6 +3304,11 @@ static int lookup_open(struct nameidata *nd, struct path *path,
 			error = -EACCES;
 			goto out_dput;
 		}
+		if (!(open_flag & O_EXCL)) {
+			error = may_create_no_excl(dir, nd->last.name, NULL);
+			if (unlikely(error))
+				goto out_dput;
+		}
 		error = dir_inode->i_op->create(dir_inode, dentry, mode,
 						open_flag & O_EXCL);
 		if (error)
@@ -3421,6 +3475,9 @@ static int do_last(struct nameidata *nd,
 		error = may_create_in_sticky(dir, nd->last.name, inode);
 		if (unlikely(error))
 			goto out;
+		error = may_create_no_excl(dir, nd->last.name, inode);
+		if (unlikely(error))
+			goto out;
 	}
 	error = -ENOTDIR;
 	if ((nd->flags & LOOKUP_DIRECTORY) && !d_can_lookup(nd->path.dentry))
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 14bb497..16025e6 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -73,6 +73,7 @@
 extern int sysctl_protected_hardlinks;
 extern int sysctl_protected_fifos;
 extern int sysctl_protected_regular;
+extern int sysctl_protected_sticky_child_create;
 
 typedef __kernel_rwf_t rwf_t;
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 6b127e2..5927823 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1825,6 +1825,15 @@ static int sysrq_sysctl_handler(struct ctl_table *table, int write,
 		.extra2		= &two,
 	},
 	{
+		.procname	= "protected_sticky_child_create",
+		.data		= &sysctl_protected_sticky_child_create,
+		.maxlen		= sizeof(int),
+		.mode		= 0600,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &four,
+	},
+	{
 		.procname	= "suid_dumpable",
 		.data		= &suid_dumpable,
 		.maxlen		= sizeof(int),
-- 
1.9.1
