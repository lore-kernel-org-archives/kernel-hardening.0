Reply-To: kernel-hardening@lists.openwall.com
From: Djalal Harouni <tixxdz@opendz.org>
Date: Sun, 11 Mar 2012 00:25:15 +0100
Message-Id: <1331421919-15499-6-git-send-email-tixxdz@opendz.org>
In-Reply-To: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
Subject: [kernel-hardening] [PATCH 5/9] proc: add protection support for /proc/<pid>/* ONE files
To: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Vasiliy Kulikov <segoon@openwall.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, WANG Cong <xiyou.wangcong@gmail.com>, James Morris <james.l.morris@oracle.com>, Oleg Nesterov <oleg@redhat.com>, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>, Stephen Wilson <wilsons@start.ca>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Djalal Harouni <tixxdz@opendz.org>
List-ID: <kernel-hardening.lists.openwall.com>

Sensitive information of the /proc/<pid>/* ONE files can be leaked if a
process opens its own /proc/self/* files and exec a setuid or a privileged
program, this last one will read from the fd and leak its own sensitive
data.

Since there are multiple ONE files this patch will use the following
logic: the exec_id of the proc_file_private will be set to the reader's
exec_id instead of the target's exec_id. Using the target's exec_id should
be the natural choice since this will bind these files to their task, but
in order to do that we must do permission checks (ptrace) at each syscall,
and currently these checks are done at read time and only for some
important procfs files. By using the current's (reader) exec_id we are sure
that the reader process at read time did not perform an execve.

Currently this is the list of the ONE files that will use this protection:
/proc/<pid>/{personality,stat,stack} and each file will have its own
check. This will be provided by the next patch.

This is an aggressive check compared to the target's exec_id check.

Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: Solar Designer <solar@openwall.com>
Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/proc/base.c |   36 ++++++++++++++++++++++++++++++++----
 1 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 387e637..6df8ddd 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -692,12 +692,17 @@ static const struct file_operations proc_info_file_operations = {
 
 static int proc_single_show(struct seq_file *m, void *v)
 {
-	struct inode *inode = m->private;
+	struct proc_file_private *priv = m->private;
+	struct inode *inode;
 	struct pid_namespace *ns;
 	struct pid *pid;
 	struct task_struct *task;
-	int ret;
+	int ret = 0;
 
+	if (!priv)
+		return ret;
+
+	inode = priv->inode;
 	ns = inode->i_sb->s_fs_info;
 	pid = proc_pid(inode);
 	task = get_pid_task(pid, PIDTYPE_PID);
@@ -712,14 +717,37 @@ static int proc_single_show(struct seq_file *m, void *v)
 
 static int proc_single_open(struct inode *inode, struct file *filp)
 {
-	return single_open(filp, proc_single_show, inode);
+	struct proc_file_private *priv;
+	int ret = -ENOMEM;
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (priv) {
+		/* Protect ONE files with current's exec_id */
+		priv->exec_id = get_task_exec_id(current);
+		ret = single_open(filp, proc_single_show, priv);
+		if (!ret)
+			priv->inode = inode;
+		else
+			kfree(priv);
+	}
+	return ret;
+}
+
+static int proc_single_release(struct inode *inode, struct file *filp)
+{
+	struct seq_file *seq = filp->private_data;
+	int ret = 0;
+	if (seq) {
+		kfree(seq->private);
+		ret = single_release(inode, filp);
+	}
+	return ret;
 }
 
 static const struct file_operations proc_single_file_operations = {
 	.open		= proc_single_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= single_release,
+	.release	= proc_single_release,
 };
 
 static int mem_open(struct inode* inode, struct file* file)
-- 
1.7.1
