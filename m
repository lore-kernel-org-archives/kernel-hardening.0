Reply-To: kernel-hardening@lists.openwall.com
From: Djalal Harouni <tixxdz@opendz.org>
Date: Tue,  1 Oct 2013 21:26:18 +0100
Message-Id: <1380659178-28605-10-git-send-email-tixxdz@opendz.org>
In-Reply-To: <1380659178-28605-1-git-send-email-tixxdz@opendz.org>
References: <1380659178-28605-1-git-send-email-tixxdz@opendz.org>
Subject: [kernel-hardening] [PATCH v2 9/9] procfs: improve permission checks on /proc/*/syscall
To: "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, David Rientjes <rientjes@google.com>, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: tixxdz@gmail.com, Djalal Harouni <tixxdz@opendz.org>
List-ID: <kernel-hardening.lists.openwall.com>

Permission checks need to happen during each system call. Therefore we
need to convert the /proc/*/syscall entry from an INF node to a REG
node. Doing this will make /proc/*/syscall have its own file operations
to implement appropriate checks and avoid breaking shared INF file
operations.

Add the syscall_open() to check if the file's opener has enough
permission to ptrace the task during ->open().

Add the syscall_read() to check permissions and to read task syscall
information. If the classic ptrace_may_access() check is passed, then
check if current's cred have changed between ->open() and ->read(), if
so, call proc_allow_access() to check if the original file's opener had
enough permissions to read the task syscall info. This will block
passing the file descriptor to a more privileged process.

For readability split code into another task_syscall_read() function
which is used to get the syscall entries of the task.

Cc: Kees Cook <keescook@chromium.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/proc/base.c | 93 ++++++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 84 insertions(+), 9 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index b80588a..f98889d 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -150,6 +150,9 @@ struct pid_entry {
 		NULL, &proc_single_file_operations,	\
 		{ .proc_show = show } )
 
+/* 4K page size but our output routines use some slack for overruns */
+#define PROC_BLOCK_SIZE        (3*1024)
+
 /**
  * proc_same_open_cred - Check if the file's opener cred matches the
  * current cred.
@@ -678,13 +681,32 @@ static int proc_pid_limits(struct task_struct *task, char *buffer)
 }
 
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
-static int proc_pid_syscall(struct task_struct *task, char *buffer)
+static int syscall_open(struct inode *inode, struct file *filp)
+{
+	int err = -ESRCH;
+	struct task_struct *task = get_proc_task(file_inode(filp));
+
+	if (!task)
+		return err;
+
+	err = mutex_lock_killable(&task->signal->cred_guard_mutex);
+	if (err)
+		goto out;
+
+	if (!ptrace_may_access(task, PTRACE_MODE_ATTACH))
+		err = -EPERM;
+
+	mutex_unlock(&task->signal->cred_guard_mutex);
+out:
+	put_task_struct(task);
+	return err;
+}
+
+static int task_syscall_read(struct task_struct *task, char *buffer)
 {
+	int res;
 	long nr;
 	unsigned long args[6], sp, pc;
-	int res = lock_trace(task);
-	if (res)
-		return res;
 
 	if (task_current_syscall(task, &nr, args, 6, &sp, &pc))
 		res = sprintf(buffer, "running\n");
@@ -696,9 +718,64 @@ static int proc_pid_syscall(struct task_struct *task, char *buffer)
 		       nr,
 		       args[0], args[1], args[2], args[3], args[4], args[5],
 		       sp, pc);
-	unlock_trace(task);
+
 	return res;
 }
+
+static ssize_t syscall_read(struct file *file, char __user *buf,
+			    size_t count, loff_t *ppos)
+{
+	int same_cred;
+	ssize_t length;
+	unsigned long page;
+	const struct cred *fcred = file->f_cred;
+	struct inode *inode = file_inode(file);
+	struct task_struct *task = get_proc_task(inode);
+
+	length = -ESRCH;
+	if (!task)
+		return length;
+
+	if (count > PROC_BLOCK_SIZE)
+		count = PROC_BLOCK_SIZE;
+
+	length = -ENOMEM;
+	page = __get_free_page(GFP_TEMPORARY);
+	if (!page)
+		goto out;
+
+	same_cred = proc_same_open_cred(fcred);
+
+	length = lock_trace(task);
+	if (length)
+		goto out_free;
+
+	if (!same_cred &&
+	    !proc_allow_access(fcred, task, PTRACE_MODE_ATTACH)) {
+		length = -EPERM;
+		unlock_trace(task);
+		goto out_free;
+	}
+
+	length = task_syscall_read(task, (char *)page);
+	unlock_trace(task);
+
+	if (length >= 0)
+		length = simple_read_from_buffer(buf, count, ppos,
+						 (char *)page, length);
+
+out_free:
+	free_page(page);
+out:
+	put_task_struct(task);
+	return length;
+}
+
+static const struct file_operations proc_pid_syscall_operations = {
+	.open           = syscall_open,
+	.read           = syscall_read,
+	.llseek         = generic_file_llseek,
+};
 #endif /* CONFIG_HAVE_ARCH_TRACEHOOK */
 
 /************************************************************************/
@@ -789,8 +866,6 @@ static const struct inode_operations proc_def_inode_operations = {
 	.setattr	= proc_setattr,
 };
 
-#define PROC_BLOCK_SIZE	(3*1024)		/* 4K page size but our output routines use some slack for overruns */
-
 static ssize_t proc_info_read(struct file * file, char __user * buf,
 			  size_t count, loff_t *ppos)
 {
@@ -2760,7 +2835,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 #endif
 	REG("comm",      S_IRUGO|S_IWUSR, proc_pid_set_comm_operations),
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
-	INF("syscall",    S_IRUSR, proc_pid_syscall),
+	REG("syscall",    S_IRUSR, proc_pid_syscall_operations),
 #endif
 	INF("cmdline",    S_IRUGO, proc_pid_cmdline),
 	ONE("stat",       S_IRUGO, proc_tgid_stat),
@@ -3096,7 +3171,7 @@ static const struct pid_entry tid_base_stuff[] = {
 #endif
 	REG("comm",      S_IRUGO|S_IWUSR, proc_pid_set_comm_operations),
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
-	INF("syscall",   S_IRUSR, proc_pid_syscall),
+	REG("syscall",   S_IRUSR, proc_pid_syscall_operations),
 #endif
 	INF("cmdline",   S_IRUGO, proc_pid_cmdline),
 	ONE("stat",      S_IRUGO, proc_tid_stat),
-- 
1.7.11.7
