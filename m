Reply-To: kernel-hardening@lists.openwall.com
From: Djalal Harouni <tixxdz@opendz.org>
Date: Tue,  1 Oct 2013 21:26:16 +0100
Message-Id: <1380659178-28605-8-git-send-email-tixxdz@opendz.org>
In-Reply-To: <1380659178-28605-1-git-send-email-tixxdz@opendz.org>
References: <1380659178-28605-1-git-send-email-tixxdz@opendz.org>
Subject: [kernel-hardening] [PATCH v2 7/9] procfs: add permission checks on the file's opener of /proc/*/personality
To: "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, David Rientjes <rientjes@google.com>, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: tixxdz@gmail.com, Djalal Harouni <tixxdz@opendz.org>
List-ID: <kernel-hardening.lists.openwall.com>

If current's cred have changed between ->open() and ->read(), then call
proc_allow_access() to check if the original file's opener had enough
permissions to access the /proc/*/personality entry during ->read().

Cc: Kees Cook <keescook@chromium.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/proc/base.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index d4b604d..77f5b84 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2647,11 +2647,23 @@ static const struct file_operations proc_projid_map_operations = {
 static int proc_pid_personality(struct seq_file *m, struct pid_namespace *ns,
 				struct pid *pid, struct task_struct *task)
 {
+	struct file *file = m->private;
+	const struct cred *fcred = file->f_cred;
+	int same_cred = proc_same_open_cred(fcred);
 	int err = lock_trace(task);
-	if (!err) {
-		seq_printf(m, "%08x\n", task->personality);
-		unlock_trace(task);
+	if (err)
+		return err;
+
+	if (!same_cred &&
+	    !proc_allow_access(fcred, task, PTRACE_MODE_ATTACH)) {
+		err = -EPERM;
+		goto out;
 	}
+
+	seq_printf(m, "%08x\n", task->personality);
+
+out:
+	unlock_trace(task);
 	return err;
 }
 
-- 
1.7.11.7
