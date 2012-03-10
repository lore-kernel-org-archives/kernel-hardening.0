Reply-To: kernel-hardening@lists.openwall.com
From: Djalal Harouni <tixxdz@opendz.org>
Date: Sun, 11 Mar 2012 00:25:19 +0100
Message-Id: <1331421919-15499-10-git-send-email-tixxdz@opendz.org>
In-Reply-To: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
Subject: [kernel-hardening] [PATCH 9/9] proc: improve and clean up /proc/<pid>/mem protection
To: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Vasiliy Kulikov <segoon@openwall.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, WANG Cong <xiyou.wangcong@gmail.com>, James Morris <james.l.morris@oracle.com>, Oleg Nesterov <oleg@redhat.com>, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>, Stephen Wilson <wilsons@start.ca>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Djalal Harouni <tixxdz@opendz.org>
List-ID: <kernel-hardening.lists.openwall.com>

The /proc/<pid>/mem is a sensitive file which needs proper protection.

Commit e268337dfe26dfc7efd422a804dbb27977a3cccc changes the handling of
the /proc/<pid>/mem file by attaching and tracking the VM of the target
process at open time which means that even after an execve the old VM will
still be referenced.

Commit 6d08f2c7139790c268820a2e590795cb8333181a makes sure that the VM of
the target process is not pinned which will prevent rlimits bypass but the
internal kernel mm_struct will be.

The mm_struct is a big struct and this can have negative effects on the
machine especially low memory ones if a process keep /proc/<pid>/mem open,
fork and re-exec where the /proc/<pid>/mem is related to a dead or a
zombie process.

Some tests regarding the current implementation:

1) slabtop results with 32 processes each one with 1000 opened file:
OBJS   ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
 26272  26270  99%    1.56K   1634       20     52288K mm_struct
 26685  26681  99%    0.69K   1251       23     20016K filp
...
   108    103  95%    5.20K     18        6       576K task_struct

The number of mm_structs do not reflect the number of task_structs, and
all these mm_structs are related to zombie/dead processes. In this case
with 32 processes on low memory the OOM killer will be triggered killing
other processes.

2) With enough memory and with a higher number of processes:
OBJS   ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
 34233  31414  91%    1.25K   2858       12     45728K mm_struct
 34944  32062  91%    0.38K   1664       21     13312K filp
 44835  41973  93%    0.19K   2135       21      8540K kmalloc-192
...
   294    163  55%    4.88K     49        6      1568K task_struct

In this (2) situation we reach the VFS file-max value
/proc/sys/fs/file-max which was 34869 on the tested system.

But It is not the job of the VFS to block this behaviour, and systems with
higher file-max values will suffer.

Based on the above considerations and if we can achieve the same
/proc/<pid>/mem protection then we should go for it.

Use the proc_file_private and its exec_id to track /proc/<pid>/mem usage.
Set the exec_id to the target task's exec_id at open time, and later
compare it on each read and write calls before processing the VM of the
target which means we bind the /proc/<pid>/mem to its exec_id process at
open time. Permission checks are also done on each syscall so we do not
care about the reader, only the target is tracked and its mm_struct is not
pinned, this means that on each syscall readers/writers will operate on
the right mm_struct.

We must perform permission checks at each syscall.

The appropriate exec_id of the proc_file_private must be set at the right
time just before doing the permission checks at open time, this way we do
not race against target task execve. The exec_id checks at read and write
time must also be done at the right time after permission checks when the
mm is already grabbed.

Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/proc/base.c |   99 ++++++++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 78 insertions(+), 21 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 536cd65..a9cc73c 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -760,50 +760,99 @@ static const struct file_operations proc_single_file_operations = {
 
 static int mem_open(struct inode* inode, struct file* file)
 {
-	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
+	struct proc_file_private *priv;
+	struct task_struct *task;
 	struct mm_struct *mm;
+	int ret = -ENOMEM;
 
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return ret;
+
+	ret = -ESRCH;
+	task = get_proc_task(file->f_path.dentry->d_inode);
 	if (!task)
-		return -ESRCH;
+		goto out_free;
 
+	/*
+	 * Use target task's exec_id to bind the current opened
+	 * /proc/<pid>/mem file to its process image.
+	 *
+	 * Setup exec_id first then check for permissions.
+	 */
+	priv->exec_id = get_task_exec_id(task);
 	mm = mm_access(task, PTRACE_MODE_ATTACH);
 	put_task_struct(task);
 
-	if (IS_ERR(mm))
-		return PTR_ERR(mm);
+	if (!mm) {
+		ret = -ENOENT;
+		goto out_free;
+	}
 
-	if (mm) {
-		/* ensure this mm_struct can't be freed */
-		atomic_inc(&mm->mm_count);
-		/* but do not pin its memory */
-		mmput(mm);
+	if (IS_ERR(mm)) {
+		ret = PTR_ERR(mm);
+		goto out_free;
 	}
 
 	/* OK to pass negative loff_t, we can catch out-of-range */
 	file->f_mode |= FMODE_UNSIGNED_OFFSET;
-	file->private_data = mm;
+	file->private_data = priv;
+
+	mmput(mm);
 
 	return 0;
+
+out_free:
+	kfree(priv);
+	return ret;
 }
 
 static ssize_t mem_rw(struct file *file, char __user *buf,
 			size_t count, loff_t *ppos, int write)
 {
-	struct mm_struct *mm = file->private_data;
+	struct proc_file_private *priv = file->private_data;
+	struct task_struct *task;
 	unsigned long addr = *ppos;
-	ssize_t copied;
+	ssize_t copied = 0;
 	char *page;
+	struct mm_struct *mm;
 
-	if (!mm)
-		return 0;
+	if (!priv)
+		return copied;
+
+	copied = -ESRCH;
+	task = get_proc_task(file->f_dentry->d_inode);
+	if (!task)
+		goto out_no_task;
 
+	copied = -ENOMEM;
 	page = (char *)__get_free_page(GFP_TEMPORARY);
 	if (!page)
-		return -ENOMEM;
+		goto out;
+
+	mm = mm_access(task, PTRACE_MODE_ATTACH);
+	if (!mm) {
+		copied = -ENOENT;
+		goto out_free;
+	}
+
+	if (IS_ERR(mm)) {
+		copied = PTR_ERR(mm);
+		goto out_free;
+	}
 
 	copied = 0;
-	if (!atomic_inc_not_zero(&mm->mm_users))
-		goto free;
+	/*
+	 * See if the processed /proc/<pid>/mem file belongs to the
+	 * original opened /proc/<pid>/ process image and that there was
+	 * no new execve.
+	 *
+	 * Do the check here since access_remote_vm() will operate
+	 * on the already grabbed mm.
+	 */
+	if (!proc_exec_id_ok(task, priv))
+		/* There was an execv */
+		goto out_mm;
 
 	while (count > 0) {
 		int this_len = min_t(int, count, PAGE_SIZE);
@@ -813,6 +862,10 @@ static ssize_t mem_rw(struct file *file, char __user *buf,
 			break;
 		}
 
+		/*
+		 * Do not change this: we must operate on the previously
+		 * grabbed mm.
+		 */
 		this_len = access_remote_vm(mm, addr, page, this_len, write);
 		if (!this_len) {
 			if (!copied)
@@ -832,9 +885,13 @@ static ssize_t mem_rw(struct file *file, char __user *buf,
 	}
 	*ppos = addr;
 
+out_mm:
 	mmput(mm);
-free:
+out_free:
 	free_page((unsigned long) page);
+out:
+	put_task_struct(task);
+out_no_task:
 	return copied;
 }
 
@@ -868,9 +925,9 @@ loff_t mem_lseek(struct file *file, loff_t offset, int orig)
 
 static int mem_release(struct inode *inode, struct file *file)
 {
-	struct mm_struct *mm = file->private_data;
-	if (mm)
-		mmdrop(mm);
+	struct proc_file_private *priv = file->private_data;
+
+	kfree(priv);
 	return 0;
 }
 
-- 
1.7.1
