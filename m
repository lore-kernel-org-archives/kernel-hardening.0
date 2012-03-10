Reply-To: kernel-hardening@lists.openwall.com
From: Djalal Harouni <tixxdz@opendz.org>
Date: Sun, 11 Mar 2012 00:25:13 +0100
Message-Id: <1331421919-15499-4-git-send-email-tixxdz@opendz.org>
In-Reply-To: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
Subject: [kernel-hardening] [PATCH 3/9] proc: new proc_exec_id_ok() helper function
To: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Vasiliy Kulikov <segoon@openwall.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, WANG Cong <xiyou.wangcong@gmail.com>, James Morris <james.l.morris@oracle.com>, Oleg Nesterov <oleg@redhat.com>, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>, Stephen Wilson <wilsons@start.ca>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Djalal Harouni <tixxdz@opendz.org>
List-ID: <kernel-hardening.lists.openwall.com>

proc_exec_id_ok() will be used for /proc/<pid>/* files checks to see if the
task's exec_id equals the exec_id of the proc_file_private struct.

Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/proc/internal.h |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index a8968f6..bed27a8 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -10,6 +10,7 @@
  */
 
 #include <linux/proc_fs.h>
+#include <linux/sched.h>
 
 extern struct proc_dir_entry proc_root;
 #ifdef CONFIG_PROC_SYSCTL
@@ -95,6 +96,25 @@ static inline int proc_fd(struct inode *inode)
 	return PROC_I(inode)->fd;
 }
 
+/**
+ * proc_exec_id_ok - check if the task's exec_id equals the exec_id of
+ * the proc_file_private.
+ * @task: Task struct to check against.
+ * @proc_private: The proc_file_private struct.
+ *
+ * Check if the exec_id of the two structs are equal. Use it to protect
+ * special procfs files when the fd is passed to a new execve (i.e. suid)
+ *
+ * It will be more effective if the check is delayed as mush as possible
+ * to avoid any new execve surprises especially if we are checking against
+ * target task's exec_id.
+ */
+static inline int proc_exec_id_ok(struct task_struct *task,
+				  struct proc_file_private *proc_priv)
+{
+	return task_exec_id_ok(task, proc_priv->exec_id);
+}
+
 struct dentry *proc_lookup_de(struct proc_dir_entry *de, struct inode *ino,
 		struct dentry *dentry);
 int proc_readdir_de(struct proc_dir_entry *de, struct file *filp, void *dirent,
-- 
1.7.1
