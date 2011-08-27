Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sat, 27 Aug 2011 23:01:47 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110827190147.GA3015@albatros>
References: <20110804162009.GA2469@albatros>
 <20110823144430.75315ce8.akpm@linux-foundation.org>
 <20110826132909.GA8266@albatros>
 <20110826124021.15f8e20c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110826124021.15f8e20c.akpm@linux-foundation.org>
Subject: [kernel-hardening] [PATCH v2] proc: fix races against execve() of /proc/PID/fd**
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel-hardening@lists.openwall.com, Al Viro <viro@zeniv.linux.org.uk>, David Rientjes <rientjes@google.com>, Stephen Wilson <wilsons@start.ca>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-kernel@vger.kernel.org, security@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

fd* files are restricted to the task's owner, and other users may not
get direct access to them.  But one may open any of these files and run
any setuid program, keeping opened file descriptors.  As there are
permission checks on open(), but not on stat(), readdir(), and read(),
operations on the kept file descriptors will not be checked.  It makes
it possible to violate procfs permission model.

Reading fdinfo/* may disclosure current fds' position and flags, reading
directory contents of fdinfo/ and fd/ may disclosure the number of opened
files by the target task.  This information is not sensible per se, but
it can reveal some private information (like length of a password stored in
a file) under certain conditions.

Used existing (un)lock_trace functions to check for ptrace_may_access(),
but instead of using EPERM return code from it use EACCES to be
consistent with existing proc_pid_follow_link()/proc_pid_readlink()
return codes.  If they'd differ, attacker can guess what fds exist by
analyzing stat() return code.  Patched handlers: stat() for fd/*, stat()
and read() for fdindo/*, readdir() and lookup() for fd/ and fdinfo/.

v2 - Rebased to v3.1-rc3.
   - Handle stat() case.

CC: Stable Tree <stable@kernel.org>
Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 fs/proc/base.c |  145 +++++++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 101 insertions(+), 44 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 5eb0206..c162080 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1665,12 +1665,43 @@ out:
 	return error;
 }
 
+static int proc_pid_fd_link_getattr(struct vfsmount *mnt, struct dentry *dentry,
+		struct kstat *stat)
+{
+	struct inode *inode = dentry->d_inode;
+	struct task_struct *task = get_proc_task(inode);
+	int rc;
+
+	rc = -EACCES;
+	if (lock_trace(task))
+		goto out_task;
+
+	generic_fillattr(inode, stat);
+	unlock_trace(task);
+	put_task_struct(task);
+	rc = 0;
+out_task:
+	return rc;
+}
+
 static const struct inode_operations proc_pid_link_inode_operations = {
 	.readlink	= proc_pid_readlink,
 	.follow_link	= proc_pid_follow_link,
 	.setattr	= proc_setattr,
 };
 
+static const struct inode_operations proc_fdinfo_link_inode_operations = {
+	.setattr	= proc_setattr,
+	.getattr	= proc_pid_fd_link_getattr,
+};
+
+static const struct inode_operations proc_fd_link_inode_operations = {
+	.readlink	= proc_pid_readlink,
+	.follow_link	= proc_pid_follow_link,
+	.setattr	= proc_setattr,
+	.getattr	= proc_pid_fd_link_getattr,
+};
+
 
 /* building an inode */
 
@@ -1902,49 +1933,61 @@ out:
 
 static int proc_fd_info(struct inode *inode, struct path *path, char *info)
 {
-	struct task_struct *task = get_proc_task(inode);
-	struct files_struct *files = NULL;
+	struct task_struct *task;
+	struct files_struct *files;
 	struct file *file;
 	int fd = proc_fd(inode);
+	int rc;
 
-	if (task) {
-		files = get_files_struct(task);
-		put_task_struct(task);
-	}
-	if (files) {
-		/*
-		 * We are not taking a ref to the file structure, so we must
-		 * hold ->file_lock.
-		 */
-		spin_lock(&files->file_lock);
-		file = fcheck_files(files, fd);
-		if (file) {
-			unsigned int f_flags;
-			struct fdtable *fdt;
-
-			fdt = files_fdtable(files);
-			f_flags = file->f_flags & ~O_CLOEXEC;
-			if (FD_ISSET(fd, fdt->close_on_exec))
-				f_flags |= O_CLOEXEC;
-
-			if (path) {
-				*path = file->f_path;
-				path_get(&file->f_path);
-			}
-			if (info)
-				snprintf(info, PROC_FDINFO_MAX,
-					 "pos:\t%lli\n"
-					 "flags:\t0%o\n",
-					 (long long) file->f_pos,
-					 f_flags);
-			spin_unlock(&files->file_lock);
-			put_files_struct(files);
-			return 0;
+	task = get_proc_task(inode);
+	if (!task)
+		return -ENOENT;
+
+	rc = -EACCES;
+	if (lock_trace(task))
+		goto out_task;
+
+	rc = -ENOENT;
+	files = get_files_struct(task);
+	if (files == NULL)
+		goto out_unlock;
+
+	/*
+	 * We are not taking a ref to the file structure, so we must
+	 * hold ->file_lock.
+	 */
+	spin_lock(&files->file_lock);
+	file = fcheck_files(files, fd);
+	if (file) {
+		unsigned int f_flags;
+		struct fdtable *fdt;
+
+		fdt = files_fdtable(files);
+		f_flags = file->f_flags & ~O_CLOEXEC;
+		if (FD_ISSET(fd, fdt->close_on_exec))
+			f_flags |= O_CLOEXEC;
+
+		if (path) {
+			*path = file->f_path;
+			path_get(&file->f_path);
 		}
-		spin_unlock(&files->file_lock);
-		put_files_struct(files);
-	}
-	return -ENOENT;
+		if (info)
+			snprintf(info, PROC_FDINFO_MAX,
+				 "pos:\t%lli\n"
+				 "flags:\t0%o\n",
+				 (long long) file->f_pos,
+				 f_flags);
+		rc = 0;
+	} else
+		rc = -ENOENT;
+	spin_unlock(&files->file_lock);
+	put_files_struct(files);
+
+out_unlock:
+	unlock_trace(task);
+out_task:
+	put_task_struct(task);
+	return rc;
 }
 
 static int proc_fd_link(struct inode *inode, struct path *path)
@@ -2039,7 +2082,7 @@ static struct dentry *proc_fd_instantiate(struct inode *dir,
 	spin_unlock(&files->file_lock);
 	put_files_struct(files);
 
-	inode->i_op = &proc_pid_link_inode_operations;
+	inode->i_op = &proc_fd_link_inode_operations;
 	inode->i_size = 64;
 	ei->op.proc_get_link = proc_fd_link;
 	d_set_d_op(dentry, &tid_fd_dentry_operations);
@@ -2071,7 +2114,12 @@ static struct dentry *proc_lookupfd_common(struct inode *dir,
 	if (fd == ~0U)
 		goto out;
 
+	result = ERR_PTR(-EACCES);
+	if (lock_trace(task))
+		goto out;
+
 	result = instantiate(dir, dentry, task, &fd);
+	unlock_trace(task);
 out:
 	put_task_struct(task);
 out_no_task:
@@ -2091,23 +2139,28 @@ static int proc_readfd_common(struct file * filp, void * dirent,
 	retval = -ENOENT;
 	if (!p)
 		goto out_no_task;
+
+	retval = -EACCES;
+	if (lock_trace(p))
+		goto out;
+
 	retval = 0;
 
 	fd = filp->f_pos;
 	switch (fd) {
 		case 0:
 			if (filldir(dirent, ".", 1, 0, inode->i_ino, DT_DIR) < 0)
-				goto out;
+				goto out_unlock;
 			filp->f_pos++;
 		case 1:
 			ino = parent_ino(dentry);
 			if (filldir(dirent, "..", 2, 1, ino, DT_DIR) < 0)
-				goto out;
+				goto out_unlock;
 			filp->f_pos++;
 		default:
 			files = get_files_struct(p);
 			if (!files)
-				goto out;
+				goto out_unlock;
 			rcu_read_lock();
 			for (fd = filp->f_pos-2;
 			     fd < files_fdtable(files)->max_fds;
@@ -2131,6 +2184,9 @@ static int proc_readfd_common(struct file * filp, void * dirent,
 			rcu_read_unlock();
 			put_files_struct(files);
 	}
+
+out_unlock:
+	unlock_trace(p);
 out:
 	put_task_struct(p);
 out_no_task:
@@ -2187,6 +2243,7 @@ static int proc_fd_permission(struct inode *inode, int mask)
 /*
  * proc directories can do almost nothing..
  */
+
 static const struct inode_operations proc_fd_inode_operations = {
 	.lookup		= proc_lookupfd,
 	.permission	= proc_fd_permission,
@@ -2208,6 +2265,7 @@ static struct dentry *proc_fdinfo_instantiate(struct inode *dir,
 	ei->fd = fd;
 	inode->i_mode = S_IFREG | S_IRUSR;
 	inode->i_fop = &proc_fdinfo_file_operations;
+	inode->i_op = &proc_fdinfo_link_inode_operations;
 	d_set_d_op(dentry, &tid_fd_dentry_operations);
 	d_add(dentry, inode);
 	/* Close the race of the process dying before we return the dentry */
-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
