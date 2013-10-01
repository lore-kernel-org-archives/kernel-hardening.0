Reply-To: kernel-hardening@lists.openwall.com
From: Djalal Harouni <tixxdz@opendz.org>
Date: Tue,  1 Oct 2013 21:26:14 +0100
Message-Id: <1380659178-28605-6-git-send-email-tixxdz@opendz.org>
In-Reply-To: <1380659178-28605-1-git-send-email-tixxdz@opendz.org>
References: <1380659178-28605-1-git-send-email-tixxdz@opendz.org>
Subject: [kernel-hardening] [PATCH v2 5/9] procfs: make /proc entries that use seq files able to access file->f_cred
To: "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, David Rientjes <rientjes@google.com>, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: tixxdz@gmail.com, Djalal Harouni <tixxdz@opendz.org>
List-ID: <kernel-hardening.lists.openwall.com>

In order to check if the cred of current have changed between ->open()
and ->read(), we must able to access the file's opener cred
'file->f_cred' at any point.

To make this possible for /proc/*/{stack,personality,stat} pass the
'file struct' as a 3rd argument to single_open() so it will be stored in
seq_file->private in seq_open(). This way these entries are able to
continue to use seq files, and access the file->f_cred easily.

This is also a preparation for the following patches which will check
the corresponding file->f_cred.

Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/proc/base.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 54e926a..d4b604d 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -765,7 +765,8 @@ static const struct file_operations proc_info_file_operations = {
 
 static int proc_single_show(struct seq_file *m, void *v)
 {
-	struct inode *inode = m->private;
+	struct file *filp = m->private;
+	struct inode *inode = file_inode(filp);
 	struct pid_namespace *ns;
 	struct pid *pid;
 	struct task_struct *task;
@@ -785,7 +786,9 @@ static int proc_single_show(struct seq_file *m, void *v)
 
 static int proc_single_open(struct inode *inode, struct file *filp)
 {
-	return single_open(filp, proc_single_show, inode);
+	/* Later we need inode and filp->f_cred, so pass filp as 3rd
+	 * argument, it will be referenced by seq_file->private */
+	return single_open(filp, proc_single_show, filp);
 }
 
 static const struct file_operations proc_single_file_operations = {
-- 
1.7.11.7
