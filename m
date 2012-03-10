Reply-To: kernel-hardening@lists.openwall.com
From: Djalal Harouni <tixxdz@opendz.org>
Date: Sun, 11 Mar 2012 00:25:14 +0100
Message-Id: <1331421919-15499-5-git-send-email-tixxdz@opendz.org>
In-Reply-To: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
Subject: [kernel-hardening] [PATCH 4/9] proc: protect /proc/<pid>/* INF files from reader across execve
To: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Vasiliy Kulikov <segoon@openwall.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, WANG Cong <xiyou.wangcong@gmail.com>, James Morris <james.l.morris@oracle.com>, Oleg Nesterov <oleg@redhat.com>, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>, Stephen Wilson <wilsons@start.ca>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Djalal Harouni <tixxdz@opendz.org>
List-ID: <kernel-hardening.lists.openwall.com>

Protect all the INF files /proc/$pid/{auxv,limits,syscall,cmdline,io,...}
from reader across execve. A process can open its /proc/self/* INF files
and exec a setuid or a privileged program, then this last one will use the
passed fd and leak its own sensitive information.

Since there are multiple INF files this patch provides a solution without
any internal processing logic change.
The exec_id of the proc_file_private will be set to the reader's exec_id
instead of the target's exec_id. Using the target's exec_id should be the
natural choice since this will bind these files to their task, but in
order to do that we must do permission checks (ptrace) at each syscall, and
currently these checks are done at read time and only for some important
procfs files. By using the current's (reader) exec_id we are sure that the
reader process at read time did not perform an execve.

All the /proc/<pid>/* INF files are protected by a one hit check just
before returning results to userspace.

This is an aggressive check compared to the target's exec_id check.

Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: Solar Designer <solar@openwall.com>
Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/proc/base.c |   49 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index d4548dd..387e637 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -610,15 +610,42 @@ static const struct inode_operations proc_def_inode_operations = {
 
 #define PROC_BLOCK_SIZE	(3*1024)		/* 4K page size but our output routines use some slack for overruns */
 
+static int proc_info_open(struct inode *inode, struct file *filp)
+{
+	struct proc_file_private *priv;
+	int ret = -ENOMEM;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return ret;
+
+	/*
+	 * Use the exec_id of current to protect INF files. We do this
+	 * since there are no permission checks (ptrace...) at open, they
+	 * are done at read time, and only for the sensitive files.
+	 * By using the current's exec_id we are sure that the reader process
+	 * did not change.
+	 */
+	priv->exec_id = get_task_exec_id(current);
+	filp->private_data = priv;
+
+	return 0;
+}
+
 static ssize_t proc_info_read(struct file * file, char __user * buf,
 			  size_t count, loff_t *ppos)
 {
 	struct inode * inode = file->f_path.dentry->d_inode;
+	struct proc_file_private *priv = file->private_data;
 	unsigned long page;
-	ssize_t length;
-	struct task_struct *task = get_proc_task(inode);
+	ssize_t length = 0;
+	struct task_struct *task;
+
+	if (!priv)
+		return length;
 
 	length = -ESRCH;
+	task = get_proc_task(inode);
 	if (!task)
 		goto out_no_task;
 
@@ -631,8 +658,16 @@ static ssize_t proc_info_read(struct file * file, char __user * buf,
 
 	length = PROC_I(inode)->op.proc_read(task, (char*)page);
 
+	/* Check delayed */
+	if (!proc_exec_id_ok(current, priv)) {
+		length = 0;
+		goto out_free;
+	}
+
 	if (length >= 0)
 		length = simple_read_from_buffer(buf, count, ppos, (char *)page, length);
+
+out_free:
 	free_page(page);
 out:
 	put_task_struct(task);
@@ -640,9 +675,19 @@ out_no_task:
 	return length;
 }
 
+static int proc_info_release(struct inode *inode, struct file *filp)
+{
+	struct proc_file_private *priv = filp->private_data;
+
+	kfree(priv);
+	return 0;
+}
+
 static const struct file_operations proc_info_file_operations = {
+	.open		= proc_info_open,
 	.read		= proc_info_read,
 	.llseek		= generic_file_llseek,
+	.release	= proc_info_release,
 };
 
 static int proc_single_show(struct seq_file *m, void *v)
-- 
1.7.1
