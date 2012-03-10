Reply-To: kernel-hardening@lists.openwall.com
From: Djalal Harouni <tixxdz@opendz.org>
Date: Sun, 11 Mar 2012 00:25:18 +0100
Message-Id: <1331421919-15499-9-git-send-email-tixxdz@opendz.org>
In-Reply-To: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
Subject: [kernel-hardening] [PATCH 8/9] proc: protect /proc/<pid>/{environ,pagemap} across execve
To: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Vasiliy Kulikov <segoon@openwall.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, WANG Cong <xiyou.wangcong@gmail.com>, James Morris <james.l.morris@oracle.com>, Oleg Nesterov <oleg@redhat.com>, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>, Stephen Wilson <wilsons@start.ca>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Djalal Harouni <tixxdz@opendz.org>
List-ID: <kernel-hardening.lists.openwall.com>

The /proc/<pid>/{environ,pagemap} are sensitive files which must be
protected across execve to avoid information leaks.

These files are protected by attaching them to their task at open time by
saving the exec_id of the target task, this way in read we just compare
the target task's exec_id and the previously saved exec_id of the
proc_file_private struct, in other words we just bind these files to their
appropriate process image at open time. We do this since we are able to do
proper permission checks (ptrace) at each syscall, so we do not care about
the reader.

Another important rule is to set the exec_id of the target task before the
permission checks at open, this way we do not race against target task
execve, and it will be more effective if the exec_id check at read/write
times are delayed as much as possible to be sure that the target task do
not change during execve.

This patch adds the open file_operation to the
/proc/<pid>/{environ,pagemap} so we are able to set the exec_id of the
target task and to do the appropriate permission checks. The exec_id check
is done in the related read file_operation.

Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/proc/base.c     |   85 +++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/proc/task_mmu.c |   69 +++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 148 insertions(+), 6 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 0a5383e..536cd65 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -882,15 +882,66 @@ static const struct file_operations proc_mem_operations = {
 	.release	= mem_release,
 };
 
+static int environ_open(struct inode *inode, struct file *filp)
+{
+	struct proc_file_private *priv;
+	struct mm_struct *mm;
+	struct task_struct *task;
+	int ret = -ENOMEM;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return ret;
+
+	ret = -ESRCH;
+	task = get_proc_task(filp->f_path.dentry->d_inode);
+	if (!task)
+		goto out_free;
+
+	/*
+	 * Use target task's exec_id to bind the file to the task.
+	 * Setup exec_id first then check for permissions.
+	 */
+	priv->exec_id = get_task_exec_id(task);
+	mm = mm_for_maps(task);
+	put_task_struct(task);
+
+	if (!mm) {
+		ret = -ENOENT;
+		goto out_free;
+	}
+
+	if (IS_ERR(mm)) {
+		ret = PTR_ERR(mm);
+		goto out_free;
+	}
+
+	filp->private_data = priv;
+	/* do not pin mm */
+	mmput(mm);
+
+	return 0;
+
+out_free:
+	kfree(priv);
+	return ret;
+}
+
 static ssize_t environ_read(struct file *file, char __user *buf,
 			size_t count, loff_t *ppos)
 {
-	struct task_struct *task = get_proc_task(file->f_dentry->d_inode);
+	struct proc_file_private *priv = file->private_data;
+	struct task_struct *task;
 	char *page;
 	unsigned long src = *ppos;
-	int ret = -ESRCH;
+	int ret = 0;
 	struct mm_struct *mm;
 
+	if (!priv)
+		return ret;
+
+	ret = -ESRCH;
+	task = get_proc_task(file->f_dentry->d_inode);
 	if (!task)
 		goto out_no_task;
 
@@ -901,9 +952,15 @@ static ssize_t environ_read(struct file *file, char __user *buf,
 
 
 	mm = mm_for_maps(task);
-	ret = PTR_ERR(mm);
-	if (!mm || IS_ERR(mm))
+	if (!mm) {
+		ret = -ENOENT;
+		goto out_free;
+	}
+
+	if (IS_ERR(mm)) {
+		ret = PTR_ERR(mm);
 		goto out_free;
+	}
 
 	ret = 0;
 	while (count > 0) {
@@ -925,6 +982,16 @@ static ssize_t environ_read(struct file *file, char __user *buf,
 			break;
 		}
 
+		/*
+		 * Delay the check since access_process_vm() operates
+		 * on a task.
+		 */
+		if (!proc_exec_id_ok(task, priv)) {
+			/* There was an execv */
+			ret = 0;
+			break;
+		}
+
 		if (copy_to_user(buf, page, retval)) {
 			ret = -EFAULT;
 			break;
@@ -946,9 +1013,19 @@ out_no_task:
 	return ret;
 }
 
+static int environ_release(struct inode *inode, struct file *filp)
+{
+	struct proc_file_private *priv = filp->private_data;
+
+	kfree(priv);
+	return 0;
+}
+
 static const struct file_operations proc_environ_operations = {
+	.open		= environ_open,
 	.read		= environ_read,
 	.llseek		= generic_file_llseek,
+	.release	= environ_release,
 };
 
 static ssize_t oom_adjust_read(struct file *file, char __user *buf,
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 96a0e4a..5b00969 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -770,13 +770,59 @@ static int pagemap_hugetlb_range(pte_t *pte, unsigned long hmask,
  */
 #define PAGEMAP_WALK_SIZE	(PMD_SIZE)
 #define PAGEMAP_WALK_MASK	(PMD_MASK)
+static int pagemap_open(struct inode *inode, struct file *filp)
+{
+	struct proc_file_private *priv;
+	struct mm_struct *mm;
+	struct task_struct *task;
+	int ret = -ENOMEM;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return ret;
+
+	ret = -ESRCH;
+	task = get_proc_task(filp->f_path.dentry->d_inode);
+	if (!task)
+		goto out_free;
+
+	/*
+	 * Use target task's exec_id to bind the file to the task.
+	 * Setup exec_id first then check for permissions.
+	 */
+	priv->exec_id = get_task_exec_id(task);
+	mm = mm_for_maps(task);
+	put_task_struct(task);
+
+	if (!mm) {
+		ret = -ENOENT;
+		goto out_free;
+	}
+
+	if (IS_ERR(mm)) {
+		ret = PTR_ERR(mm);
+		goto out_free;
+	}
+
+	filp->private_data = priv;
+	/* do not pin mm */
+	mmput(mm);
+
+	return 0;
+
+out_free:
+	kfree(priv);
+	return ret;
+}
+
 static ssize_t pagemap_read(struct file *file, char __user *buf,
 			    size_t count, loff_t *ppos)
 {
-	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
+	struct proc_file_private *priv = file->private_data;
+	struct task_struct *task;
 	struct mm_struct *mm;
 	struct pagemapread pm;
-	int ret = -ESRCH;
+	int ret = 0;
 	struct mm_walk pagemap_walk = {};
 	unsigned long src;
 	unsigned long svpfn;
@@ -784,6 +830,11 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
 	unsigned long end_vaddr;
 	int copied = 0;
 
+	if (!priv)
+		return ret;
+
+	ret = -ESRCH;
+	task = get_proc_task(file->f_path.dentry->d_inode);
 	if (!task)
 		goto out;
 
@@ -831,6 +882,10 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
 	 * will stop when we hit the end of the buffer.
 	 */
 	ret = 0;
+	if (!proc_exec_id_ok(task, priv))
+		/* There was an execve */
+		goto out_mm;
+
 	while (count && (start_vaddr < end_vaddr)) {
 		int len;
 		unsigned long end;
@@ -868,9 +923,19 @@ out:
 	return ret;
 }
 
+static int pagemap_release(struct inode *inode, struct file *filp)
+{
+	struct proc_file_private *priv = filp->private_data;
+
+	kfree(priv);
+	return 0;
+}
+
 const struct file_operations proc_pagemap_operations = {
+	.open		= pagemap_open,
 	.llseek		= mem_lseek, /* borrow this */
 	.read		= pagemap_read,
+	.release	= pagemap_release,
 };
 #endif /* CONFIG_PROC_PAGE_MONITOR */
 
-- 
1.7.1
