Reply-To: kernel-hardening@lists.openwall.com
From: Djalal Harouni <tixxdz@opendz.org>
Date: Sun, 11 Mar 2012 00:25:17 +0100
Message-Id: <1331421919-15499-8-git-send-email-tixxdz@opendz.org>
In-Reply-To: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
Subject: [kernel-hardening] [PATCH 7/9] proc: protect /proc/<pid>/{maps,smaps,numa_maps}
To: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Vasiliy Kulikov <segoon@openwall.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, WANG Cong <xiyou.wangcong@gmail.com>, James Morris <james.l.morris@oracle.com>, Oleg Nesterov <oleg@redhat.com>, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>, Stephen Wilson <wilsons@start.ca>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Djalal Harouni <tixxdz@opendz.org>
List-ID: <kernel-hardening.lists.openwall.com>

Protect the /proc/<pid>/{maps,smaps,numa_maps} files from reader across
execve by checking its exec_id.

The best solution should be to bind these files to their task by using the
target's exec_id and to perform permission checks at each syscall, but
currently this is not possible, it will break glibc FORTIFY_SOURCE
protection. For the moment the exec_id check is against the reader to be
sure that the reader process is not playing tricks and did not perform an
execve at read time.

Use the new 'proc_file_private' struct to protect these sensitive files,
this struct can store and handle all the
/proc/<pid>/{maps,smaps,numa_maps} internal data.

The proc_exec_id_ok() check is performed inside the functions that are
responsible of constructing and reporting results.

Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: Solar Designer <solar@openwall.com>
Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/proc/task_mmu.c |   37 ++++++++++++++++++++++++++-----------
 1 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 7dcd2a2..96a0e4a 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -90,7 +90,7 @@ static void pad_len_spaces(struct seq_file *m, int len)
 	seq_printf(m, "%*c", len, ' ');
 }
 
-static void vma_stop(struct proc_maps_private *priv, struct vm_area_struct *vma)
+static void vma_stop(struct proc_file_private *priv, struct vm_area_struct *vma)
 {
 	if (vma && vma != priv->tail_vma) {
 		struct mm_struct *mm = vma->vm_mm;
@@ -101,7 +101,7 @@ static void vma_stop(struct proc_maps_private *priv, struct vm_area_struct *vma)
 
 static void *m_start(struct seq_file *m, loff_t *pos)
 {
-	struct proc_maps_private *priv = m->private;
+	struct proc_file_private *priv = m->private;
 	unsigned long last_addr = m->version;
 	struct mm_struct *mm;
 	struct vm_area_struct *vma, *tail_vma = NULL;
@@ -168,7 +168,7 @@ out:
 
 static void *m_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	struct proc_maps_private *priv = m->private;
+	struct proc_file_private *priv = m->private;
 	struct vm_area_struct *vma = v;
 	struct vm_area_struct *tail_vma = priv->tail_vma;
 
@@ -181,7 +181,7 @@ static void *m_next(struct seq_file *m, void *v, loff_t *pos)
 
 static void m_stop(struct seq_file *m, void *v)
 {
-	struct proc_maps_private *priv = m->private;
+	struct proc_file_private *priv = m->private;
 	struct vm_area_struct *vma = v;
 
 	if (!IS_ERR(vma))
@@ -193,15 +193,20 @@ static void m_stop(struct seq_file *m, void *v)
 static int do_maps_open(struct inode *inode, struct file *file,
 			const struct seq_operations *ops)
 {
-	struct proc_maps_private *priv;
+	struct proc_file_private *priv;
 	int ret = -ENOMEM;
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (priv) {
-		priv->pid = proc_pid(inode);
+		/*
+		 * Use current's exec_id since currently there are no
+		 * permission checks at open.
+		 */
+		priv->exec_id = get_task_exec_id(current);
 		ret = seq_open(file, ops);
 		if (!ret) {
 			struct seq_file *m = file->private_data;
 			m->private = priv;
+			priv->pid = proc_pid(inode);
 		} else {
 			kfree(priv);
 		}
@@ -278,9 +283,12 @@ static void show_map_vma(struct seq_file *m, struct vm_area_struct *vma)
 static int show_map(struct seq_file *m, void *v)
 {
 	struct vm_area_struct *vma = v;
-	struct proc_maps_private *priv = m->private;
+	struct proc_file_private *priv = m->private;
 	struct task_struct *task = priv->task;
 
+	if (!proc_exec_id_ok(current, priv))
+		return 0;
+
 	show_map_vma(m, vma);
 
 	if (m->count < m->size)  /* vma is copied successfully */
@@ -424,7 +432,7 @@ static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 
 static int show_smap(struct seq_file *m, void *v)
 {
-	struct proc_maps_private *priv = m->private;
+	struct proc_file_private *priv = m->private;
 	struct task_struct *task = priv->task;
 	struct vm_area_struct *vma = v;
 	struct mem_size_stats mss;
@@ -434,6 +442,9 @@ static int show_smap(struct seq_file *m, void *v)
 		.private = &mss,
 	};
 
+	if (!proc_exec_id_ok(current, priv))
+		return 0;
+
 	memset(&mss, 0, sizeof mss);
 	mss.vma = vma;
 	/* mmap_sem is held in m_start */
@@ -878,7 +889,7 @@ struct numa_maps {
 };
 
 struct numa_maps_private {
-	struct proc_maps_private proc_maps;
+	struct proc_file_private proc_maps;
 	struct numa_maps md;
 };
 
@@ -1005,7 +1016,7 @@ static int gather_hugetbl_stats(pte_t *pte, unsigned long hmask,
 static int show_numa_map(struct seq_file *m, void *v)
 {
 	struct numa_maps_private *numa_priv = m->private;
-	struct proc_maps_private *proc_priv = &numa_priv->proc_maps;
+	struct proc_file_private *proc_priv = &numa_priv->proc_maps;
 	struct vm_area_struct *vma = v;
 	struct numa_maps *md = &numa_priv->md;
 	struct file *file = vma->vm_file;
@@ -1018,6 +1029,9 @@ static int show_numa_map(struct seq_file *m, void *v)
 	if (!mm)
 		return 0;
 
+	if (!proc_exec_id_ok(current, proc_priv))
+		return 0;
+
 	/* Ensure we start with an empty set of numa_maps statistics. */
 	memset(md, 0, sizeof(*md));
 
@@ -1097,11 +1111,12 @@ static int numa_maps_open(struct inode *inode, struct file *file)
 	int ret = -ENOMEM;
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (priv) {
-		priv->proc_maps.pid = proc_pid(inode);
+		priv->proc_maps.exec_id = get_task_exec_id(current);
 		ret = seq_open(file, &proc_pid_numa_maps_op);
 		if (!ret) {
 			struct seq_file *m = file->private_data;
 			m->private = priv;
+			priv->proc_maps.pid = proc_pid(inode);
 		} else {
 			kfree(priv);
 		}
-- 
1.7.1
