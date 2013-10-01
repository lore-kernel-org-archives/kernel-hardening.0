Reply-To: kernel-hardening@lists.openwall.com
From: Djalal Harouni <tixxdz@opendz.org>
Date: Tue,  1 Oct 2013 21:26:17 +0100
Message-Id: <1380659178-28605-9-git-send-email-tixxdz@opendz.org>
In-Reply-To: <1380659178-28605-1-git-send-email-tixxdz@opendz.org>
References: <1380659178-28605-1-git-send-email-tixxdz@opendz.org>
Subject: [kernel-hardening] [PATCH v2 8/9] procfs: improve permission checks on /proc/*/stack
To: "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, David Rientjes <rientjes@google.com>, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: tixxdz@gmail.com, Djalal Harouni <tixxdz@opendz.org>
List-ID: <kernel-hardening.lists.openwall.com>

Permission checks need to happen during each system call. Therefore we
need to convert the /proc/*/stack entry from a ONE node to a REG node.
Doing this will make /proc/*/stack have its own file operations to
implement appropriate checks and avoid breaking shared ONE file
operations.

The patch makes sure that /proc/*/stack is still using seq files to
provide its output.

The patch adds stack_open() to check if the file's opener has enough
permission to ptrace the task during ->open().

However, even with this, /proc file descriptors can be passed to a more
privileged process (e.g. a suid-exec) which will pass the classic
ptrace_may_access() permission check during read().

To prevent this, use proc_same_open_cred() to detect if the cred of
current have changed between ->open() and ->read(), if so, then call
proc_allow_access() to check if the original file's opener had enough
privileges to access the /proc's task entries during ->read(). This will
block passing file descriptors to a more privileged process.

If the cred did not change then continue with read().

For readability, split code into another task_stack_show() function
which is used to get the stack trace of a task.

Cc: Kees Cook <keescook@chromium.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/proc/base.c | 87 ++++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 75 insertions(+), 12 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 77f5b84..b80588a 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -395,13 +395,14 @@ static void unlock_trace(struct task_struct *task)
 
 #define MAX_STACK_TRACE_DEPTH	64
 
-static int proc_pid_stack(struct seq_file *m, struct pid_namespace *ns,
-			  struct pid *pid, struct task_struct *task)
+static int task_stack_show(struct seq_file *m, struct task_struct *task)
 {
-	struct stack_trace trace;
-	unsigned long *entries;
 	int err;
 	int i;
+	int same_cred;
+	struct stack_trace trace;
+	unsigned long *entries;
+	struct file *filp = m->private;
 
 	entries = kmalloc(MAX_STACK_TRACE_DEPTH * sizeof(*entries), GFP_KERNEL);
 	if (!entries)
@@ -412,20 +413,82 @@ static int proc_pid_stack(struct seq_file *m, struct pid_namespace *ns,
 	trace.entries		= entries;
 	trace.skip		= 0;
 
+	same_cred = proc_same_open_cred(filp->f_cred);
+
 	err = lock_trace(task);
-	if (!err) {
-		save_stack_trace_tsk(task, &trace);
+	if (err)
+		goto free;
 
-		for (i = 0; i < trace.nr_entries; i++) {
-			seq_printf(m, "[<%pK>] %pS\n",
-				   (void *)entries[i], (void *)entries[i]);
-		}
+	if (!same_cred &&
+	    !proc_allow_access(filp->f_cred, task, PTRACE_MODE_ATTACH)) {
+		err = -EPERM;
 		unlock_trace(task);
+		goto free;
+	}
+
+	save_stack_trace_tsk(task, &trace);
+	unlock_trace(task);
+
+	for (i = 0; i < trace.nr_entries; i++) {
+		seq_printf(m, "[<%pK>] %pS\n",
+			   (void *)entries[i], (void *)entries[i]);
 	}
+
+free:
 	kfree(entries);
+	return err;
+}
 
+static int stack_show(struct seq_file *m, void *v)
+{
+	int ret;
+	struct pid *pid;
+	struct task_struct *task;
+	struct file *filp = m->private;
+	struct inode *inode = file_inode(filp);
+
+	ret = -ESRCH;
+	pid = proc_pid(inode);
+	task = get_pid_task(pid, PIDTYPE_PID);
+	if (!task)
+		return ret;
+
+	ret = task_stack_show(m, task);
+
+	put_task_struct(task);
+	return ret;
+}
+
+static int stack_open(struct inode *inode, struct file *filp)
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
+	err = -EPERM;
+	if (ptrace_may_access(task, PTRACE_MODE_ATTACH))
+		/* We need inode and filp->f_cred, so pass filp
+		 * as third argument */
+		err = single_open(filp, stack_show, filp);
+
+	mutex_unlock(&task->signal->cred_guard_mutex);
+out:
+	put_task_struct(task);
 	return err;
 }
+
+static const struct file_operations proc_pid_stack_operations = {
+	.open           = stack_open,
+	.read           = seq_read,
+	.llseek         = seq_lseek,
+	.release        = single_release,
+};
 #endif
 
 #ifdef CONFIG_SCHEDSTATS
@@ -2725,7 +2788,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	INF("wchan",      S_IRUGO, proc_pid_wchan),
 #endif
 #ifdef CONFIG_STACKTRACE
-	ONE("stack",      S_IRUSR, proc_pid_stack),
+	REG("stack",      S_IRUSR, proc_pid_stack_operations),
 #endif
 #ifdef CONFIG_SCHEDSTATS
 	INF("schedstat",  S_IRUGO, proc_pid_schedstat),
@@ -3063,7 +3126,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	INF("wchan",     S_IRUGO, proc_pid_wchan),
 #endif
 #ifdef CONFIG_STACKTRACE
-	ONE("stack",      S_IRUSR, proc_pid_stack),
+	REG("stack",      S_IRUSR, proc_pid_stack_operations),
 #endif
 #ifdef CONFIG_SCHEDSTATS
 	INF("schedstat", S_IRUGO, proc_pid_schedstat),
-- 
1.7.11.7
