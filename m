Reply-To: kernel-hardening@lists.openwall.com
From: Djalal Harouni <tixxdz@opendz.org>
Date: Tue,  1 Oct 2013 21:26:11 +0100
Message-Id: <1380659178-28605-3-git-send-email-tixxdz@opendz.org>
In-Reply-To: <1380659178-28605-1-git-send-email-tixxdz@opendz.org>
References: <1380659178-28605-1-git-send-email-tixxdz@opendz.org>
Subject: [kernel-hardening] [PATCH v2 2/9] procfs: add proc_allow_access() to check if file's opener may access task
To: "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, David Rientjes <rientjes@google.com>, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: tixxdz@gmail.com, Djalal Harouni <tixxdz@opendz.org>
List-ID: <kernel-hardening.lists.openwall.com>

Since /proc entries varies at runtime, permission checks need to happen
during each system call.

However even with that /proc file descriptors can be passed to a more
privileged process (e.g. a suid-exec) which will pass the classic
ptrace_may_access() permission check. The open() call will be issued in
general by an unprivileged process while the disclosure of sensitive
/proc information will happen using a more privileged process at
read(),write()...

Therfore we need a more sophisticated check to detect if the cred of the
process have changed, and if the cred of the original opener that are
stored in the file->f_cred have enough permission to access the task's
/proc entries during read(), write()...

Add the proc_allow_access() function that will receive the file->f_cred
as an argument, and tries to check if the opener had enough permission
to access the task's /proc entries.

This function should be used with the ptrace_may_access() check.

Cc: Kees Cook <keescook@chromium.org>
Suggested-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/proc/base.c     | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/proc/internal.h |  2 ++
 2 files changed, 58 insertions(+)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index e834946..c29eeae 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -168,6 +168,62 @@ int proc_same_open_cred(const struct cred *fcred)
 		cap_issubset(cred->cap_permitted, fcred->cap_permitted));
 }
 
+/* Returns 0 on success, -errno on denial. */
+static int __proc_allow_access(const struct cred *cred,
+			       struct task_struct *task, unsigned int mode)
+{
+	int ret = 0;
+	const struct cred *tcred;
+	const struct cred *fcred = cred;
+
+	rcu_read_lock();
+	tcred = __task_cred(task);
+	if (uid_eq(fcred->uid, tcred->euid) &&
+	    uid_eq(fcred->uid, tcred->suid) &&
+	    uid_eq(fcred->uid, tcred->uid)  &&
+	    gid_eq(fcred->gid, tcred->egid) &&
+	    gid_eq(fcred->gid, tcred->sgid) &&
+	    gid_eq(fcred->gid, tcred->gid))
+		goto out;
+
+	if (mode & PTRACE_MODE_NOAUDIT)
+		ret = security_capable_noaudit(fcred, tcred->user_ns,
+					       CAP_SYS_PTRACE);
+	else
+		ret = security_capable(fcred, tcred->user_ns,
+				       CAP_SYS_PTRACE);
+
+out:
+	rcu_read_unlock();
+	return !ret ? ret : -EPERM;
+}
+
+/**
+ * proc_allow_access - Check if the file's opener had enough permissions
+ * to access the target process.
+ * @fcred:  The file's opener cred (file->f_cred)
+ * @task:  The target task we want to inspect
+ * @mode:  The ptrace mode
+ *
+ * Return a non-zero if the file's opener had enough permissions to
+ * access the task's /proc entries.
+ *
+ * Since this function will check the permissions of the opener
+ * against the target task, it can be used to protect /proc files
+ * from opening a /proc file descriptor and do a suid-exec.
+ *
+ * Callers must hold the task->signal->cred_guard_mutex
+ */
+int proc_allow_access(const struct cred *fcred,
+		      struct task_struct *task, unsigned int mode)
+{
+	int ret;
+	task_lock(task);
+	ret = __proc_allow_access(fcred, task, mode);
+	task_unlock(task);
+	return !ret;
+}
+
 /*
  * Count the number of hardlinks for the pid_entry table, excluding the .
  * and .. links.
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index e2459f4..c3f3c34 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -159,6 +159,8 @@ extern int proc_pid_statm(struct seq_file *, struct pid_namespace *,
 /*
  * base.c
  */
+extern int proc_allow_access(const struct cred *,
+			     struct task_struct *, unsigned int);
 extern int proc_same_open_cred(const struct cred *);
 extern const struct dentry_operations pid_dentry_operations;
 extern int pid_getattr(struct vfsmount *, struct dentry *, struct kstat *);
-- 
1.7.11.7
