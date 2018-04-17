Date: Tue, 17 Apr 2018 15:17:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5] namei: Allow restricted O_CREAT of FIFOs and regular
 files
Message-Id: <20180417151758.af56d5303cad4e82d2207755@linux-foundation.org>
In-Reply-To: <20180416175918.GA13494@beast>
References: <20180416175918.GA13494@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook@chromium.org>
Cc: Solar Designer <solar@openwall.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 16 Apr 2018 10:59:18 -0700 Kees Cook <keescook@chromium.org> wrote:

> Disallows open of FIFOs or regular files not owned by the user in world
> writable sticky directories, unless the owner is the same as that of the
> directory or the file is opened without the O_CREAT flag. The purpose
> is to make data spoofing attacks harder. This protection can be turned
> on and off separately for FIFOs and regular files via sysctl, just like
> the symlinks/hardlinks protection. This patch is based on Openwall's
> "HARDEN_FIFO" feature by Solar Designer.
> 
> This is a brief list of old vulnerabilities that could have been prevented
> by this feature, some of them even allow for privilege escalation:
> CVE-2000-1134
> CVE-2007-3852
> CVE-2008-0525
> CVE-2009-0416
> CVE-2011-4834
> CVE-2015-1838
> CVE-2015-7442
> CVE-2016-7489
> 
> This list is not meant to be complete. It's difficult to track down
> all vulnerabilities of this kind because they were often reported
> without any mention of this particular attack vector. In fact, before
> hardlinks/symlinks restrictions, fifos/regular files weren't the favorite
> vehicle to exploit them.

Well, I'll toss it in there, but would much prefer it if Al were to
take a look, please.


From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Subject: namei: allow restricted O_CREAT of FIFOs and regular files

Disallows open of FIFOs or regular files not owned by the user in world
writable sticky directories, unless the owner is the same as that of the
directory or the file is opened without the O_CREAT flag.  The purpose is
to make data spoofing attacks harder.  This protection can be turned on
and off separately for FIFOs and regular files via sysctl, just like the
symlinks/hardlinks protection.  This patch is based on Openwall's
"HARDEN_FIFO" feature by Solar Designer.

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

This list is not meant to be complete.  It's difficult to track down all
vulnerabilities of this kind because they were often reported without any
mention of this particular attack vector.  In fact, before
hardlinks/symlinks restrictions, fifos/regular files weren't the favorite
vehicle to exploit them.

[keescook@chromium.org: drop pr_warn_ratelimited() in favor of audit changes in the future]
[keescook@chromium.org: adjust commit subjet]
Link: http://lkml.kernel.org/r/20180416175918.GA13494@beast
Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Suggested-by: Solar Designer <solar@openwall.com>
Suggested-by: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/fs.txt |   36 +++++++++++++++++++++++
 fs/namei.c                  |   52 ++++++++++++++++++++++++++++++++--
 include/linux/fs.h          |    2 +
 kernel/sysctl.c             |   18 +++++++++++
 4 files changed, 105 insertions(+), 3 deletions(-)

diff -puN Documentation/sysctl/fs.txt~namei-allow-restricted-o_creat-of-fifos-and-regular-files Documentation/sysctl/fs.txt
--- a/Documentation/sysctl/fs.txt~namei-allow-restricted-o_creat-of-fifos-and-regular-files
+++ a/Documentation/sysctl/fs.txt
@@ -34,7 +34,9 @@ Currently, these files are in /proc/sys/
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
+When set to "0", writing to FIFOs is unrestricted.
+
+When set to "1" don't allow O_CREAT open on FIFOs that we don't own
+in world writable sticky directories, unless they are owned by the
+owner of the directory.
+
+When set to "2" it also applies to group writable sticky directories.
+
+This protection is based on the restrictions in Openwall.
+
+==============================================================
+
 protected_hardlinks:
 
 A long-standing class of security issues is the hardlink-based
@@ -202,6 +222,22 @@ This protection is based on the restrict
 
 ==============================================================
 
+protected_regular:
+
+This protection is similar to protected_fifos, but it
+avoids writes to an attacker-controlled regular file, where a program
+expected to create one.
+
+When set to "0", writing to regular files is unrestricted.
+
+When set to "1" don't allow O_CREAT open on regular files that we
+don't own in world writable sticky directories, unless they are
+owned by the owner of the directory.
+
+When set to "2" it also applies to group writable sticky directories.
+
+==============================================================
+
 protected_symlinks:
 
 A long-standing class of security issues is the symlink-based
diff -puN fs/namei.c~namei-allow-restricted-o_creat-of-fifos-and-regular-files fs/namei.c
--- a/fs/namei.c~namei-allow-restricted-o_creat-of-fifos-and-regular-files
+++ a/fs/namei.c
@@ -887,6 +887,8 @@ static inline void put_link(struct namei
 
 int sysctl_protected_symlinks __read_mostly = 0;
 int sysctl_protected_hardlinks __read_mostly = 0;
+int sysctl_protected_fifos __read_mostly;
+int sysctl_protected_regular __read_mostly;
 
 /**
  * may_follow_link - Check symlink following for unsafe situations
@@ -1001,6 +1003,45 @@ static int may_linkat(struct path *link)
 	return -EPERM;
 }
 
+/**
+ * may_create_in_sticky - Check whether an O_CREAT open in a sticky directory
+ *			  should be allowed, or not, on files that already
+ *			  exist.
+ * @dir: the sticky parent directory
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
+		return -EACCES;
+	}
+	return 0;
+}
+
 static __always_inline
 const char *get_link(struct nameidata *nd)
 {
@@ -3342,9 +3383,14 @@ finish_open:
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
+		error = may_create_in_sticky(dir, inode);
+		if (unlikely(error))
+			goto out;
+	}
 	error = -ENOTDIR;
 	if ((nd->flags & LOOKUP_DIRECTORY) && !d_can_lookup(nd->path.dentry))
 		goto out;
diff -puN include/linux/fs.h~namei-allow-restricted-o_creat-of-fifos-and-regular-files include/linux/fs.h
--- a/include/linux/fs.h~namei-allow-restricted-o_creat-of-fifos-and-regular-files
+++ a/include/linux/fs.h
@@ -73,6 +73,8 @@ extern struct inodes_stat_t inodes_stat;
 extern int leases_enable, lease_break_time;
 extern int sysctl_protected_symlinks;
 extern int sysctl_protected_hardlinks;
+extern int sysctl_protected_fifos;
+extern int sysctl_protected_regular;
 
 typedef __kernel_rwf_t rwf_t;
 
diff -puN kernel/sysctl.c~namei-allow-restricted-o_creat-of-fifos-and-regular-files kernel/sysctl.c
--- a/kernel/sysctl.c~namei-allow-restricted-o_creat-of-fifos-and-regular-files
+++ a/kernel/sysctl.c
@@ -1805,6 +1805,24 @@ static struct ctl_table fs_table[] = {
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
_
