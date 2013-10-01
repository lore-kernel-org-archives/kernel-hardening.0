Reply-To: kernel-hardening@lists.openwall.com
From: Djalal Harouni <tixxdz@opendz.org>
Date: Tue,  1 Oct 2013 21:26:10 +0100
Message-Id: <1380659178-28605-2-git-send-email-tixxdz@opendz.org>
In-Reply-To: <1380659178-28605-1-git-send-email-tixxdz@opendz.org>
References: <1380659178-28605-1-git-send-email-tixxdz@opendz.org>
Subject: [kernel-hardening] [PATCH v2 1/9] procfs: add proc_same_open_cred() to check if the cred have changed
To: "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, David Rientjes <rientjes@google.com>, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: tixxdz@gmail.com, Djalal Harouni <tixxdz@opendz.org>
List-ID: <kernel-hardening.lists.openwall.com>

Since /proc entries varies at runtime, permission checks need to
happen during each system call.

However even with that /proc file descriptors can be passed to a more
privileged process (e.g. a suid-exec) which will pass the classic
ptrace_may_access() permission check. The open() call will be issued in
general by an unprivileged process while the disclosure of sensitive
/proc information will happen using a more privileged process at
read(), write()...

The /proc need to know if the cred of the original opener matches the
cred of current in order to take the appropriate actions.

The match concerns the cred fields that are used in the
ptrace_may_access() check: uid, gid and cap_permitted.

If there is a match then the current task that tries to read/write
/proc entries has the same privileges as the task that issued the
open() call.

However if the match fails then the cred have changed which means that
perhaps we have gain or lost the privileges of processing the /proc
file descriptor. So add proc_same_open_cred() to check if the cred have
changed.

Cc: Kees Cook <keescook@chromium.org>
Suggested-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/proc/base.c     | 29 +++++++++++++++++++++++++++++
 fs/proc/internal.h |  1 +
 2 files changed, 30 insertions(+)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 1485e38..e834946 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -139,6 +139,35 @@ struct pid_entry {
 		NULL, &proc_single_file_operations,	\
 		{ .proc_show = show } )
 
+/**
+ * proc_same_open_cred - Check if the file's opener cred matches the
+ * current cred.
+ * @fcred:  The file's opener cred (file->f_cred)
+ *
+ * Return 1 if the cred of the file's opener matches the cred of
+ * current, otherwise 0.
+ *
+ * The match concerns the cred that are used in the ptrace_may_access()
+ * check to allow /proc task access. These cred are: uid,gid and
+ * cap_permitted.
+ *
+ * This function can be used to check if /proc file descriptors where
+ * passed to a more privileged process (e.g. execs a suid executable).
+ */
+int proc_same_open_cred(const struct cred *fcred)
+{
+	const struct cred *cred = current_cred();
+	const struct user_namespace *set_ns = fcred->user_ns;
+	const struct user_namespace *subset_ns = cred->user_ns;
+
+	if (set_ns != subset_ns)
+		return 0;
+
+	return (uid_eq(fcred->uid, cred->uid) &&
+		gid_eq(fcred->gid, cred->gid) &&
+		cap_issubset(cred->cap_permitted, fcred->cap_permitted));
+}
+
 /*
  * Count the number of hardlinks for the pid_entry table, excluding the .
  * and .. links.
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 651d09a..e2459f4 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -159,6 +159,7 @@ extern int proc_pid_statm(struct seq_file *, struct pid_namespace *,
 /*
  * base.c
  */
+extern int proc_same_open_cred(const struct cred *);
 extern const struct dentry_operations pid_dentry_operations;
 extern int pid_getattr(struct vfsmount *, struct dentry *, struct kstat *);
 extern int proc_setattr(struct dentry *, struct iattr *);
-- 
1.7.11.7
