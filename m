Reply-To: kernel-hardening@lists.openwall.com
From: Djalal Harouni <tixxdz@opendz.org>
Date: Tue,  1 Oct 2013 21:26:15 +0100
Message-Id: <1380659178-28605-7-git-send-email-tixxdz@opendz.org>
In-Reply-To: <1380659178-28605-1-git-send-email-tixxdz@opendz.org>
References: <1380659178-28605-1-git-send-email-tixxdz@opendz.org>
Subject: [kernel-hardening] [PATCH v2 6/9] procfs: add permission checks on the file's opener of /proc/*/stat
To: "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, David Rientjes <rientjes@google.com>, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: tixxdz@gmail.com, Djalal Harouni <tixxdz@opendz.org>
List-ID: <kernel-hardening.lists.openwall.com>

Some fields of the /proc/*/stat are sensitive fields that need
appropriate protection.

However, /proc file descriptors can be passed to a more privileged
process (e.g. a suid-exec) which will pass the classic
ptrace_may_access() permission check during read().

To prevent it, use proc_same_open_cred() to detect if current's cred
have changed between ->open() and ->read(), if so, call
proc_allow_access() to check if the original file's opener had enough
permissions to read these sensitive fields. This will prevent passing
file descriptors to a more privileged process to leak data.

The patch also adds a previously missing signal->cred_guard_mutex lock.

This patch does not break userspace since it only hides the fields that
were supposed to be protected.

Cc: Kees Cook <keescook@chromium.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/proc/array.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index cbd0f1b..f034e05 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -394,7 +394,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 	char state;
 	pid_t ppid = 0, pgid = -1, sid = -1;
 	int num_threads = 0;
-	int permitted;
+	int permitted = 0;
 	struct mm_struct *mm;
 	unsigned long long start_time;
 	unsigned long cmin_flt = 0, cmaj_flt = 0;
@@ -404,10 +404,22 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 	unsigned long rsslim = 0;
 	char tcomm[sizeof(task->comm)];
 	unsigned long flags;
+	struct file *file = m->private;
+	int same_cred = proc_same_open_cred(file->f_cred);
+	unsigned int ptrace_mode = PTRACE_MODE_READ | PTRACE_MODE_NOAUDIT;
 
 	state = *get_task_state(task);
 	vsize = eip = esp = 0;
-	permitted = ptrace_may_access(task, PTRACE_MODE_READ | PTRACE_MODE_NOAUDIT);
+
+	if (!mutex_lock_killable(&task->signal->cred_guard_mutex)) {
+		permitted = ptrace_may_access(task, ptrace_mode);
+		if (permitted && !same_cred)
+			permitted = proc_allow_access(file->f_cred,
+						      task, ptrace_mode);
+
+		mutex_unlock(&task->signal->cred_guard_mutex);
+	}
+
 	mm = get_task_mm(task);
 	if (mm) {
 		vsize = task_vsize(mm);
-- 
1.7.11.7
