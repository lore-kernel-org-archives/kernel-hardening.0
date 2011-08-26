Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Fri, 26 Aug 2011 17:29:09 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110826132909.GA8266@albatros>
References: <20110804162009.GA2469@albatros>
 <20110823144430.75315ce8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110823144430.75315ce8.akpm@linux-foundation.org>
Subject: [kernel-hardening] [PATCH] proc: fix races against execve() of
 /proc/PID/{fd/,fdinfo/,fdinfo/*}
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel-hardening@lists.openwall.com, Al Viro <viro@zeniv.linux.org.uk>, David Rientjes <rientjes@google.com>, Stephen Wilson <wilsons@start.ca>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-kernel@vger.kernel.org, security@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

fd* files are restricted to the task's owner, and other users may not
get direct access to them.  But one may open any of these files and run
any setuid program, keeping opened file descriptors.  As there are
permission checks on open(), but not on readdir() and read(), operations
on the kept file descriptors will not be checked.  It makes it possible
to violate procfs permission model.

Reading fdinfo/* may disclosure current fds' position and flags, reading
directory contents of fdinfo/ and fd/ may disclosure the number of opened
files by the target task.  This information is not sensible per se, but
it can reveal some private information (like length of a password stored in
a file) under certain conditions.

Used existing (un)lock_trace functions to deal with the issue by calling
ptrace_may_access() permission checks.

CC: Stable Tree <stable@kernel.org>
Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Hopefully, I'll propose more simple way to guard private procfs files
 soon, without these "scattered" ptrace checks.

 fs/proc/base.c |   86 +++++++++++++++++++++++++++++++++++--------------------
 1 files changed, 55 insertions(+), 31 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 08e3ecc..b0477c3 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1906,37 +1906,46 @@ static int proc_fd_info(struct inode *inode, struct path *path, char *info)
 	struct files_struct *files = NULL;
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
-			if (path) {
-				*path = file->f_path;
-				path_get(&file->f_path);
-			}
-			if (info)
-				snprintf(info, PROC_FDINFO_MAX,
-					 "pos:\t%lli\n"
-					 "flags:\t0%o\n",
-					 (long long) file->f_pos,
-					 file->f_flags);
-			spin_unlock(&files->file_lock);
-			put_files_struct(files);
-			return 0;
+	if (!task)
+		return -ESRCH;
+
+	rc = lock_trace(task);
+	if (rc)
+		goto out_task;
+
+	files = get_files_struct(task);
+	if (files == NULL)
+		goto out_unlock;
+	/*
+	 * We are not taking a ref to the file structure, so we must
+	 * hold ->file_lock.
+	 */
+	spin_lock(&files->file_lock);
+	file = fcheck_files(files, fd);
+	if (file) {
+		if (path) {
+			*path = file->f_path;
+			path_get(&file->f_path);
 		}
-		spin_unlock(&files->file_lock);
-		put_files_struct(files);
+		if (info)
+			snprintf(info, PROC_FDINFO_MAX,
+					"pos:\t%lli\n"
+					"flags:\t0%o\n",
+					(long long) file->f_pos,
+					file->f_flags);
+		rc = 0;
+	} else {
+		rc = -ENOENT;
 	}
-	return -ENOENT;
+	spin_unlock(&files->file_lock);
+	put_files_struct(files);
+out_unlock:
+	unlock_trace(task);
+out_task:
+	put_task_struct(task);
+	return rc;
 }
 
 static int proc_fd_link(struct inode *inode, struct path *path)
@@ -2057,13 +2066,20 @@ static struct dentry *proc_lookupfd_common(struct inode *dir,
 	struct task_struct *task = get_proc_task(dir);
 	unsigned fd = name_to_int(dentry);
 	struct dentry *result = ERR_PTR(-ENOENT);
+	int rc;
 
 	if (!task)
 		goto out_no_task;
 	if (fd == ~0U)
 		goto out;
 
+	rc = lock_trace(task);
+	result = ERR_PTR(rc);
+	if (rc)
+		goto out;
+
 	result = instantiate(dir, dentry, task, &fd);
+	unlock_trace(task);
 out:
 	put_task_struct(task);
 out_no_task:
@@ -2083,23 +2099,28 @@ static int proc_readfd_common(struct file * filp, void * dirent,
 	retval = -ENOENT;
 	if (!p)
 		goto out_no_task;
+
+	retval = lock_trace(p);
+	if (retval)
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
@@ -2123,6 +2144,9 @@ static int proc_readfd_common(struct file * filp, void * dirent,
 			rcu_read_unlock();
 			put_files_struct(files);
 	}
+
+out_unlock:
+	unlock_trace(p);
 out:
 	put_task_struct(p);
 out_no_task:
-- 
1.7.0.4
